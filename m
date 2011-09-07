Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab1IGRBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:01:54 -0400
Received: from claw.goop.org ([74.207.240.146]:52667 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1IGRBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:01:52 -0400
Message-ID: <4E67A377.3090004@goop.org>
Date: Wed, 07 Sep 2011 10:01:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: stefano.stabellini@eu.citrix.com
CC: konrad.wilk@oracle.com, Ian.Campbell@eu.citrix.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH v3 1/2] xen: add an "highmem" parameter to alloc_xenballooned_pages
References: <alpine.DEB.2.00.1109071723470.12963@kaball-desktop> <1315413571-10938-1-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1315413571-10938-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 09:39 AM, stefano.stabellini@eu.citrix.com wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>
> Add an highmem parameter to alloc_xenballooned_pages, to allow callers to
> request lowmem or highmem pages.
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
> index f914b26..07a56c2 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -123,7 +123,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>  	    NULL == add->pages)
>  		goto err;
>  
> -	if (alloc_xenballooned_pages(count, add->pages))
> +	if (alloc_xenballooned_pages(count, add->pages, 0 /* lowmem */))

If the parameter is "bool" you should pass true/false.  But it might be
better to just make it take a GFP_ constant directly.

    J
