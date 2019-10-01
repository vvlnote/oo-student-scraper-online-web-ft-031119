require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_array = []

    doc = Nokogiri::HTML(open(index_url))
      doc.css(".student-card").each do |student|
      student_hash = {}
      student_hash[:name] = student.css(".student-name").text
      student_hash[:location] = student.css(".student-location").text
      student_hash[:profile_url] = student.css("a").attribute("href").value
      student_array << student_hash
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    info = {}
    doc = Nokogiri::HTML(open(profile_url))
    doc.css(".vitals-container").css('a').each do |link|
      url = link.attribute("href").value
      type = link.css('img').attribute('src').value
      info[:twitter] = url if type.include?('twitter')
      info[:linkedin] = url if type.include?('linkedin')
      info[:github] = url if type.include?('github')
      info[:blog] = url if type.include?('rss')
    end
    info[:profile_quote] = doc.css(".profile-quote").text
    info[:bio] = doc.css(".description-holder p").text
    info
  end

end
