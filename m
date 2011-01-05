Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1AEUZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:25:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52279 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1AEUZr (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 15:25:47 -0500
Date: Wed, 5 Jan 2011 15:23:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 10/11] xen gntdev: use gnttab_map_refs and
 gnttab_unmap_refs
Message-ID: <20110105202349.GA29993@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-10-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292420446-3348-10-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 01:40:45PM +0000, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Use gnttab_map_refs and gnttab_unmap_refs to map and unmap the grant
> ref, so that we can have a corresponding struct page.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  drivers/xen/gntdev.c |   37 ++++++++++++++++++++++++++++++-------
>  1 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index fc5e420..35de6bb 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -68,6 +68,7 @@ struct grant_map {
>  	struct ioctl_gntdev_grant_ref *grants;
>  	struct gnttab_map_grant_ref   *map_ops;
>  	struct gnttab_unmap_grant_ref *unmap_ops;
> +	struct page **pages;
>  };
>  
>  /* ------------------------------------------------------------------ */
> @@ -88,6 +89,7 @@ static void gntdev_print_maps(struct gntdev_priv *priv,
>  static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  {
>  	struct grant_map *add;
> +	int i;

So 'int' here.
>  
>  	add = kzalloc(sizeof(struct grant_map), GFP_KERNEL);
>  	if (NULL == add)
> @@ -96,11 +98,19 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  	add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
>  	add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
>  	add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
> -	if (NULL == add->grants  ||
> -	    NULL == add->map_ops ||
> -	    NULL == add->unmap_ops)
> +	add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
> +	if (NULL == add->grants    ||
> +	    NULL == add->map_ops   ||
> +	    NULL == add->unmap_ops ||
> +	    NULL == add->pages)
>  		goto err;
>  
> +	for (i = 0; i < count; i++) {
> +		add->pages[i] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
> +		if (add->pages[i] == NULL)
> +			goto err;
> +	}
> +
>  	add->index = 0;
>  	add->count = count;
>  	add->priv  = priv;
> @@ -111,6 +121,12 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  	return add;
>  
>  err:
> +	if (add->pages)
> +		for (i = 0; i < count; i++) {
> +			if (add->pages[i])
> +				__free_page(add->pages[i]);
> +		}
> +	kfree(add->pages);
>  	kfree(add->grants);
>  	kfree(add->map_ops);
>  	kfree(add->unmap_ops);
> @@ -186,8 +202,17 @@ static int gntdev_del_map(struct grant_map *map)
>  
>  static void gntdev_free_map(struct grant_map *map)
>  {
> +	unsigned i;

But 'unsigned' here?

> +
>  	if (!map)
>  		return;
> +
> +	if (map->pages)
> +		for (i = 0; i < map->count; i++) {
> +			if (map->pages[i])
> +				__free_page(map->pages[i]);
> +		}
> +	kfree(map->pages);
>  	kfree(map->grants);
>  	kfree(map->map_ops);
>  	kfree(map->unmap_ops);
> @@ -221,8 +246,7 @@ static int map_grant_pages(struct grant_map *map)
>  
>  	if (debug)
>  		printk("%s: map %d+%d\n", __FUNCTION__, map->index, map->count);
> -	err = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref,
> -					map->map_ops, map->count);
> +	err = gnttab_map_refs(map->map_ops, map->pages, map->count);
>  	if (WARN_ON(err))
>  		return err;
>  
> @@ -241,8 +265,7 @@ static int unmap_grant_pages(struct grant_map *map, int offset, int pages)
>  	if (debug)
>  		printk("%s: map %d+%d [%d+%d]\n", __FUNCTION__,
>  		       map->index, map->count, offset, pages);
> -	err = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref,
> -					map->unmap_ops + offset, pages);
> +	err = gnttab_unmap_refs(map->unmap_ops + offset, map->pages, pages);
>  	if (WARN_ON(err))
>  		return err;
>  
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
