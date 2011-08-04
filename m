Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1HDHrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 03:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1HDHrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 03:47:09 -0400
Date: Thu, 4 Aug 2011 09:47:00 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: thp: disable defrag for page faults per default
Message-ID: <20110804074700.GE21516@redhat.com>
References: <1311626321-14364-1-git-send-email-jweiner@redhat.com>
 <20110726093517.GA3010@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726093517.GA3010@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 10:35:17AM +0100, Mel Gorman wrote:
> On Mon, Jul 25, 2011 at 10:38:41PM +0200, Johannes Weiner wrote:
> > With defrag mode enabled per default, huge page allocations pass
> > __GFP_WAIT and may drop compaction into sync-mode where they wait for
> > pages under writeback.
> > 
> > I observe applications hang for several minutes(!) when they fault in
> > huge pages and compaction starts to wait on in-"flight" USB stick IO.
> > 
> > This patch disables defrag mode for page fault allocations unless the
> > VMA is madvised explicitely.  Khugepaged will continue to allocate
> > with __GFP_WAIT per default, but stalls are not a problem of
> > application responsiveness there.
> > 
> 
> Seems drastic. You could just avoid sync migration for transparent
> hugepage allocations with something like the patch below? There still
> is a stall as some order-0 pages will be reclaimed before compaction
> is tried again but it will nothing like a sync migration.
> 
> === CUT HERE ===
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1fac154..40f2a9b 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2174,7 +2174,14 @@ rebalance:
>  					sync_migration);
>  	if (page)
>  		goto got_pg;
> -	sync_migration = true;
> +
> +	/*
> +	 * Do not use sync migration for transparent hugepage allocations as
> +	 * it could stall writing back pages which is far worse than simply
> +	 * failing to promote a page.
> +	 */
> +	if (!(gfp_mask & __GFP_NO_KSWAPD))
> +		sync_migration = true;

For khugepaged it probably makes sense to enter sync migration.  But
it's less important and could be fixed with an extra GFP flag later,
maybe?

> As this is USB, the rate of pages getting written back may mean that
> too much clean memory is reclaimed in direct reclaim while compaction
> still fails due to dirty pages. If this is the case, it can be mitigated
> with something like this before calling direct reclaim;
> 
> if ((gfp_mask & __GFP_NO_KSWAPD) && compaction_deferred(preferred_zone))
> 	goto nopage;

Ah, that looks sensible.

Thanks, I'll add those hunks to my tree and see how they improve
behaviour and keep an eye on the THP statistics.
