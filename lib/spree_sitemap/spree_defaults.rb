module SpreeSitemap::SpreeDefaults
  def default_url_options
    {:host => SitemapGenerator::Sitemap.default_host}
  end
  include Spree::Core::Engine.routes.url_helpers

  def add_login(options={})
    add(login_path, options)
  end

  def add_signup(options={})
    add(signup_path, options)
  end

  def add_account(options={})
    add(account_path, options)
  end

  def add_password_reset(options={})
    add(new_spree_user_password_path, options)
  end

  def add_products(options={})
    active_products = Spree::Product.active

    add(products_path, options.merge(:lastmod => active_products.last_updated))
    active_products.each do |product|
      add(product_path(product), options.merge(:lastmod => product.updated_at))
    end
  end

  def add_taxons(options={})
    Spree::Taxon.roots.each {|taxon| add_taxon(taxon, options) if !taxon.permalink.include? "featured" } #Avoiding all taxons just for featured purposes.
  end

  def add_taxon(taxon, options={})
    #add(nested_taxons_path(taxon.permalink), options.merge(:lastmod => taxon.products.last_updated))
    add(modified_taxons_path(taxon), options.merge(:lastmod => taxon.products.last_updated))
    taxon.children.each {|child| add_taxon(child, options) }
  end

  #Added by Suyash - to avoid /t in the hard coded taxon permalinks. Urls are seo friendly and need it in sitemap too.
  def modified_taxons_path(taxon) 
    permalink = taxon.permalink.split("/").last
    path_to_taxon = "/products/cards/" + permalink
    return path_to_taxon
  end
end
