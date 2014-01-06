require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

class Scraper
  BASE_URL = "http://www.whitehouse.gov"
  PAGE_BASE = "/briefing-room/Speeches-and-Remarks?page="
  START_PAGE = 45
  END_PAGE = 284

  def initialize
  end

  def scrape
    puts "Started Scraping"
    START_PAGE.upto END_PAGE do |page_index|
      puts "Scraping page: #{page_index}"
      scrape_page Nokogiri::HTML(open(page_url(page_index)))
    end
    puts "Finished Scraping"
  end


private
  def scrape_page page
     links = page.css(".views-row a").map{|link| link["href"]}
     links.each do |link|
      print "."
      store_speech link
    end
    puts ""
  end

  def store_speech link
    open link_to_file(link), "wb" do |speech_file|
      speech = Nokogiri::HTML(open(speech_url(link)))
      speech_file.puts speech.css("#content").to_s
    end
  end

  def link_to_file link
    link.split("/")[2..-1].join("-")
  end

  def page_url(page_index)
    "#{BASE_URL}#{PAGE_BASE}#{page_index}"
  end

  def speech_url(link)
    "#{BASE_URL}#{link}"
  end

end

Scraper.new.scrape