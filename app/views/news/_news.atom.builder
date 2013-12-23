feed.entry(news, :published => news.node.created_at) do |entry|
  url = news_url news
  entry.title(news.title)
  if news.node.cc_licensed
    entry.rights("Licence CC by-sa http://creativecommons.org/licenses/by-sa/3.0/deed.fr")
  end
  first  = content_tag(:div, news.body)
  links  = content_tag(:ul, news.links.map.with_index do |l,i|
             content_tag(:li, "lien n°#{i+1} : ".html_safe +
                              link_to(l.title, "http://#{MY_DOMAIN}/redirect/#{l.id}", :title => l.url, :hreflang => l.lang))
           end.join.html_safe)
  second = content_tag(:div, news.second_part)
  if news.published?
    epub = content_tag(:div, link_to("Télécharger ce contenu au format Epub", "#{url}.epub"))
  else
    epub = ""
  end
  comments = atom_comments_link(url)
  entry.content(first + links + second + epub + comments, :type => 'html')
  news.attendees.each do |attendee|
    entry.author do |author|
      author.name(attendee.name)
    end
  end
  entry.category(:term => news.section.title)
  news.node.popular_tags.each do |tag|
    entry.category(:term => tag.name)
  end
  if news.published?
    entry.wfw :commentRss, "http://#{MY_DOMAIN}/nodes/#{news.node.id}/comments.atom"
  end
end