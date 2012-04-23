Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2DWXvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:51:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38517 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab2DWXvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:51:04 -0400
Date: Mon, 23 Apr 2012 16:51:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 02/16] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
In-Reply-To: <1334578624-23257-3-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1204231637390.17030@chino.kir.corp.google.com>
References: <1334578624-23257-1-git-send-email-mgorman@suse.de> <1334578624-23257-3-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Mel Gorman wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 280eabe..0fa2c72 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1463,6 +1463,7 @@ failed:
>  #define ALLOC_HARDER		0x10 /* try to alloc harder */
>  #define ALLOC_HIGH		0x20 /* __GFP_HIGH set */
>  #define ALLOC_CPUSET		0x40 /* check for correct cpuset */
> +#define ALLOC_PFMEMALLOC	0x80 /* Caller has PF_MEMALLOC set */
>  
>  #ifdef CONFIG_FAIL_PAGE_ALLOC
>  
> @@ -2208,16 +2209,22 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	} else if (unlikely(rt_task(current)) && !in_interrupt())
>  		alloc_flags |= ALLOC_HARDER;
>  
> -	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
> -		if (!in_interrupt() &&
> -		    ((current->flags & PF_MEMALLOC) ||
> -		     unlikely(test_thread_flag(TIF_MEMDIE))))
> +	if ((current->flags & PF_MEMALLOC) ||
> +			unlikely(test_thread_flag(TIF_MEMDIE))) {
> +		alloc_flags |= ALLOC_PFMEMALLOC;
> +
> +		if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
>  			alloc_flags |= ALLOC_NO_WATERMARKS;
>  	}
>  
>  	return alloc_flags;
>  }
>  
> +bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
> +{
> +	return !!(gfp_to_alloc_flags(gfp_mask) & ALLOC_PFMEMALLOC);
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> @@ -2407,8 +2414,16 @@ nopage:
>  got_pg:
>  	if (kmemcheck_enabled)
>  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
> -	return page;
>  
> +	/*
> +	 * page->pfmemalloc is set when the caller had PFMEMALLOC set or is
> +	 * been OOM killed. The expectation is that the caller is taking
> +	 * steps that will free more memory. The caller should avoid the
> +	 * page being used for !PFMEMALLOC purposes.
> +	 */
> +	page->pfmemalloc = !!(alloc_flags & ALLOC_PFMEMALLOC);
> +
> +	return page;
>  }
>  
>  /*

I think this is slightly inconsistent if the page allocation succeeded 
without needing ALLOC_NO_WATERMARKS, meaning that page was allocated above 
the min watermark.  That's possible if the slowpath's first call to 
get_page_from_freelist() succeeds without needing 
__alloc_pages_high_priority().  So perhaps we need to do something like

	got_pg_memalloc:
		...
		page->pfmemalloc = !!(alloc_flags & ALLOC_PFMEMALLOC);
	got_pg:
		if (kmemcheck_enabled)
			kmemcheck_pagealloc_alloc(page, order, gfp_mask);
		return page;

and use got_pg_memalloc everywhere we currently use got_pg other than the 
when it succeeds with ALLOC_NO_WATERMARKS.

> @@ -2459,6 +2474,8 @@ retry_cpuset:
>  		page = __alloc_pages_slowpath(gfp_mask, order,
>  				zonelist, high_zoneidx, nodemask,
>  				preferred_zone, migratetype);
> +	else
> +		page->pfmemalloc = false;
>  
>  	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
>  
