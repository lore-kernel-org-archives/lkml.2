Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2GFP7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:59:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43325 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2GFP73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:59:29 -0400
Date: Sat, 7 Jul 2012 00:59:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order
 0
Message-ID: <20120706155920.GA7721@barrios>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341588521-17744-1-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On Sat, Jul 07, 2012 at 12:28:41AM +0900, Joonsoo Kim wrote:
> __alloc_pages_direct_compact has many arguments so invoking it is very costly.

It's already slow path so it's pointless for such optimization.

> And in almost invoking case, order is 0, so return immediately.

You can't make sure it.

> 
> Let's not invoke it when order 0

Let's not ruin git blame.

> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6092f33..f4039aa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2056,7 +2056,10 @@ out:
>  }
>  
>  #ifdef CONFIG_COMPACTION
> -/* Try memory compaction for high-order allocations before reclaim */
> +/*
> + * Try memory compaction for high-order allocations before reclaim
> + * Must be called with order > 0
> + */
>  static struct page *
>  __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> @@ -2067,8 +2070,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
>  {
>  	struct page *page;
>  
> -	if (!order)
> -		return NULL;
> +	BUG_ON(!order);
>  
>  	if (compaction_deferred(preferred_zone, order)) {
>  		*deferred_compaction = true;
> @@ -2363,15 +2365,17 @@ rebalance:
>  	 * Try direct compaction. The first pass is asynchronous. Subsequent
>  	 * attempts after direct reclaim are synchronous
>  	 */
> -	page = __alloc_pages_direct_compact(gfp_mask, order,
> -					zonelist, high_zoneidx,
> -					nodemask,
> -					alloc_flags, preferred_zone,
> -					migratetype, sync_migration,
> -					&deferred_compaction,
> -					&did_some_progress);
> -	if (page)
> -		goto got_pg;
> +	if (unlikely(order)) {
> +		page = __alloc_pages_direct_compact(gfp_mask, order,
> +						zonelist, high_zoneidx,
> +						nodemask,
> +						alloc_flags, preferred_zone,
> +						migratetype, sync_migration,
> +						&deferred_compaction,
> +						&did_some_progress);
> +		if (page)
> +			goto got_pg;
> +	}
>  	sync_migration = true;
>  
>  	/*
> @@ -2446,15 +2450,17 @@ rebalance:
>  		 * direct reclaim and reclaim/compaction depends on compaction
>  		 * being called after reclaim so call directly if necessary
>  		 */
> -		page = __alloc_pages_direct_compact(gfp_mask, order,
> -					zonelist, high_zoneidx,
> -					nodemask,
> -					alloc_flags, preferred_zone,
> -					migratetype, sync_migration,
> -					&deferred_compaction,
> -					&did_some_progress);
> -		if (page)
> -			goto got_pg;
> +		if (unlikely(order)) {
> +			page = __alloc_pages_direct_compact(gfp_mask, order,
> +						zonelist, high_zoneidx,
> +						nodemask,
> +						alloc_flags, preferred_zone,
> +						migratetype, sync_migration,
> +						&deferred_compaction,
> +						&did_some_progress);
> +			if (page)
> +				goto got_pg;
> +		}
>  	}
>  
>  nopage:
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
