Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1AJKbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:31:51 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:8818 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1AJKbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:31:48 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291593600"; 
   d="scan'208";a="3677714"
Date: Mon, 10 Jan 2011 10:33:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 10/11] xen gntdev: use gnttab_map_refs and
 gnttab_unmap_refs
In-Reply-To: <20110105202349.GA29993@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1101071357180.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop> <1292420446-3348-10-git-send-email-stefano.stabellini@eu.citrix.com> <20110105202349.GA29993@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 15, 2010 at 01:40:45PM +0000, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > Use gnttab_map_refs and gnttab_unmap_refs to map and unmap the grant
> > ref, so that we can have a corresponding struct page.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > ---
> >  drivers/xen/gntdev.c |   37 ++++++++++++++++++++++++++++++-------
> >  1 files changed, 30 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> > index fc5e420..35de6bb 100644
> > --- a/drivers/xen/gntdev.c
> > +++ b/drivers/xen/gntdev.c
> > @@ -68,6 +68,7 @@ struct grant_map {
> >  	struct ioctl_gntdev_grant_ref *grants;
> >  	struct gnttab_map_grant_ref   *map_ops;
> >  	struct gnttab_unmap_grant_ref *unmap_ops;
> > +	struct page **pages;
> >  };
> >  
> >  /* ------------------------------------------------------------------ */
> > @@ -88,6 +89,7 @@ static void gntdev_print_maps(struct gntdev_priv *priv,
> >  static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> >  {
> >  	struct grant_map *add;
> > +	int i;
> 
> So 'int' here.
> >  
> >  	add = kzalloc(sizeof(struct grant_map), GFP_KERNEL);
> >  	if (NULL == add)
> > @@ -96,11 +98,19 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> >  	add->grants    = kzalloc(sizeof(add->grants[0])    * count, GFP_KERNEL);
> >  	add->map_ops   = kzalloc(sizeof(add->map_ops[0])   * count, GFP_KERNEL);
> >  	add->unmap_ops = kzalloc(sizeof(add->unmap_ops[0]) * count, GFP_KERNEL);
> > -	if (NULL == add->grants  ||
> > -	    NULL == add->map_ops ||
> > -	    NULL == add->unmap_ops)
> > +	add->pages     = kzalloc(sizeof(add->pages[0])     * count, GFP_KERNEL);
> > +	if (NULL == add->grants    ||
> > +	    NULL == add->map_ops   ||
> > +	    NULL == add->unmap_ops ||
> > +	    NULL == add->pages)
> >  		goto err;
> >  
> > +	for (i = 0; i < count; i++) {
> > +		add->pages[i] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
> > +		if (add->pages[i] == NULL)
> > +			goto err;
> > +	}
> > +
> >  	add->index = 0;
> >  	add->count = count;
> >  	add->priv  = priv;
> > @@ -111,6 +121,12 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> >  	return add;
> >  
> >  err:
> > +	if (add->pages)
> > +		for (i = 0; i < count; i++) {
> > +			if (add->pages[i])
> > +				__free_page(add->pages[i]);
> > +		}
> > +	kfree(add->pages);
> >  	kfree(add->grants);
> >  	kfree(add->map_ops);
> >  	kfree(add->unmap_ops);
> > @@ -186,8 +202,17 @@ static int gntdev_del_map(struct grant_map *map)
> >  
> >  static void gntdev_free_map(struct grant_map *map)
> >  {
> > +	unsigned i;
> 
> But 'unsigned' here?
> 

Good eye! Changed both to int.
