Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1IUUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:31:55 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:56630 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab1IUUby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:31:54 -0400
Date: Wed, 21 Sep 2011 16:31:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v4 1/2] xen: add an "highmem" parameter to
 alloc_xenballooned_pages
Message-ID: <20110921203144.GA934@phenom.oracle.com>
References: <alpine.DEB.2.00.1109081942470.12963@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1109081942470.12963@kaball-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E7A49B5.0139:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 07:45:08PM +0100, Stefano Stabellini wrote:
> Add an highmem parameter to alloc_xenballooned_pages, to allow callers to
> request lowmem or highmem pages.

<grumble grumble>

+ scripts/checkpatch.pl --no-signoff /tmp/git.patch
ERROR: "foo** bar" should be "foo **bar"
#467: FILE: include/xen/balloon.h:28:
+int alloc_xenballooned_pages(int nr_pages, struct page** pages,

total: 1 errors, 0 warnings, 461 lines checked

Please fix and repost.

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/xen/balloon.c |   12 ++++++++----
>  drivers/xen/gntdev.c  |    2 +-
>  include/xen/balloon.h |    3 ++-
>  3 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index 5dfd8f8..7f7d463 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -501,20 +501,24 @@ EXPORT_SYMBOL_GPL(balloon_set_new_target);
>   * alloc_xenballooned_pages - get pages that have been ballooned out
>   * @nr_pages: Number of pages to get
>   * @pages: pages returned
> + * @highmem: highmem or lowmem pages
>   * @return 0 on success, error otherwise
>   */
> -int alloc_xenballooned_pages(int nr_pages, struct page** pages)
> +int alloc_xenballooned_pages(int nr_pages, struct page** pages, bool highmem)
>  {
>  	int pgno = 0;
>  	struct page* page;
>  	mutex_lock(&balloon_mutex);
>  	while (pgno < nr_pages) {
> -		page = balloon_retrieve(true);
> -		if (page) {
> +		page = balloon_retrieve(highmem);
> +		if (page && PageHighMem(page) == highmem) {
>  			pages[pgno++] = page;
>  		} else {
>  			enum bp_state st;
> -			st = decrease_reservation(nr_pages - pgno, GFP_HIGHUSER);
> +			if (page)
> +				balloon_append(page);
> +			st = decrease_reservation(nr_pages - pgno,
> +					highmem ? GFP_HIGHUSER : GFP_USER);
>  			if (st != BP_DONE)
>  				goto out_undo;
>  		}
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index f914b26..7b9b1d1 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -123,7 +123,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  	    NULL == add->pages)
>  		goto err;
>  
> -	if (alloc_xenballooned_pages(count, add->pages))
> +	if (alloc_xenballooned_pages(count, add->pages, false /* lowmem */))
>  		goto err;
>  
>  	for (i = 0; i < count; i++) {
> diff --git a/include/xen/balloon.h b/include/xen/balloon.h
> index 76f7538..b1a8233 100644
> --- a/include/xen/balloon.h
> +++ b/include/xen/balloon.h
> @@ -25,7 +25,8 @@ extern struct balloon_stats balloon_stats;
>  
>  void balloon_set_new_target(unsigned long target);
>  
> -int alloc_xenballooned_pages(int nr_pages, struct page** pages);
> +int alloc_xenballooned_pages(int nr_pages, struct page** pages,
> +		bool highmem);
>  void free_xenballooned_pages(int nr_pages, struct page** pages);
>  
>  struct sys_device;
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
