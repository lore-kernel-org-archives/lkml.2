Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab2EBB6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445Ab2EBB56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:57:58 -0400
Date: Wed, 2 May 2012 03:57:41 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] mm: refault distance-based file cache sizing
Message-ID: <20120502015741.GE22923@redhat.com>
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org>
 <1335861713-4573-6-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335861713-4573-6-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 10:41:53AM +0200, Johannes Weiner wrote:
> frequently used active page.  Instead, for each refault with a
> distance smaller than the size of the active list, we deactivate an

Shouldn't this be the size of active list + size of inactive list?

If the active list is 500M, inactive 500M and the new working set is
600M, the refault distance will be 600M, it won't be smaller than the
size of the active list, and it won't deactivate the active list as it
should and it won't be detected as working set.

Only the refault distance bigger than inactive+active should not
deactivate the active list if I understand how this works correctly.

> @@ -1726,6 +1728,11 @@ zonelist_scan:
>  		if ((alloc_flags & ALLOC_CPUSET) &&
>  			!cpuset_zone_allowed_softwall(zone, gfp_mask))
>  				continue;
> +		if ((alloc_flags & ALLOC_WMARK_LOW) &&
> +		    current->refault_distance &&
> +		    !workingset_zone_alloc(zone, current->refault_distance,
> +					   &distance, &active))
> +			continue;
>  		/*
>  		 * When allocating a page cache page for writing, we
>  		 * want to get it from a zone that is within its dirty

It's a bit hard to see how this may not run oom prematurely if the
distance is always bigger, this is just an implementation question and
maybe I'm missing a fallback somewhere where we actually allocate
memory from whatever place in case no place is ideal.

> +	/*
> +	 * Lower zones may not even be full, and free pages are
> +	 * potential inactive space, too.  But the dirty reserve is
> +	 * not available to page cache due to lowmem reserves and the
> +	 * kswapd watermark.  Don't include it.
> +	 */
> +	zone_free = zone_page_state(zone, NR_FREE_PAGES);
> +	if (zone_free > zone->dirty_balance_reserve)
> +		zone_free -= zone->dirty_balance_reserve;
> +	else
> +		zone_free = 0;

Maybe also remove the high wmark from the sum? It can be some hundred
meg so it's better to take it into account, to have a more accurate
math and locate the best zone that surely fits.

For the same reason it looks like the lowmem reserve should also be
taken into account, on the full sum.

> +	if (missing >= zone_active + zone_free) {

This seems a place where to add the zone_inactive too according to my
comment on top.
