Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1BVRAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:00:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33854 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294Ab1BVRAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:00:13 -0500
Date: Tue, 22 Feb 2011 16:59:45 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Clemens Ladisch <cladisch@googlemail.com>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
	5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in
	kswapd for GFP_ATOMIC order > 0
Message-ID: <20110222165944.GG15652@csn.ul.ie>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110222161513.GC13092@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:15:13PM +0100, Andrea Arcangeli wrote:
> ---
>  mm/compaction.c |   19 ++++++++++---------
>  mm/vmscan.c     |    8 ++------
>  2 files changed, 12 insertions(+), 15 deletions(-)
> 
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -271,9 +271,19 @@ static unsigned long isolate_migratepage
>  	}
>  
>  	/* Time to isolate some pages for migration */
> +	cond_resched();
>  	spin_lock_irq(&zone->lru_lock);
>  	for (; low_pfn < end_pfn; low_pfn++) {
>  		struct page *page;
> +
> +		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
> +			if (fatal_signal_pending(current))
> +				break;
> +			spin_unlock_irq(&zone->lru_lock);
> +			cond_resched();
> +			spin_lock_irq(&zone->lru_lock);
> +		}
> +

There is a small chance that if the lock is contended, the current CPU
will simply reacquire the lock. Any idea how likely that is? The
need_resched() check itself seems reasonable and should reduce the
length of time interrupts are disabled.

>  		if (!pfn_valid_within(low_pfn))
>  			continue;
>  		nr_scanned++;
> @@ -413,15 +423,6 @@ static int compact_finished(struct zone 
>  	if (cc->order == -1)
>  		return COMPACT_CONTINUE;
>  
> -	/*
> -	 * Generating only one page of the right order is not enough
> -	 * for kswapd, we must continue until we're above the high
> -	 * watermark as a pool for high order GFP_ATOMIC allocations
> -	 * too.
> -	 */
> -	if (cc->compact_mode == COMPACT_MODE_KSWAPD)
> -		return COMPACT_CONTINUE;
> -

Why is this change necessary? kswapd may go to sleep sooner as a result
of this change but it doesn't affect the length of time interrupts are
disabled. Some other latency problem you've found?

>  	/* Direct compactor: Is a suitable page free? */
>  	for (order = cc->order; order < MAX_ORDER; order++) {
>  		/* Job done if page is free of the right migratetype */
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2385,7 +2385,6 @@ loop_again:
>  		 * cause too much scanning of the lower zones.
>  		 */
>  		for (i = 0; i <= end_zone; i++) {
> -			int compaction;
>  			struct zone *zone = pgdat->node_zones + i;
>  			int nr_slab;
>  
> @@ -2416,24 +2415,21 @@ loop_again:
>  			sc.nr_reclaimed += reclaim_state->reclaimed_slab;
>  			total_scanned += sc.nr_scanned;
>  
> -			compaction = 0;
>  			if (order &&
>  			    zone_watermark_ok(zone, 0,
>  					       high_wmark_pages(zone),
>  					      end_zone, 0) &&
>  			    !zone_watermark_ok(zone, order,
>  					       high_wmark_pages(zone),
> -					       end_zone, 0)) {
> +					       end_zone, 0))
>  				compact_zone_order(zone,
>  						   order,
>  						   sc.gfp_mask, false,
>  						   COMPACT_MODE_KSWAPD);
> -				compaction = 1;
> -			}
>  
>  			if (zone->all_unreclaimable)
>  				continue;
> -			if (!compaction && nr_slab == 0 &&
> +			if (nr_slab == 0 &&
>  			    !zone_reclaimable(zone))
>  				zone->all_unreclaimable = 1;

I'm not seeing how this change is related to interrupts either. The intention
of the current code is that after compaction, a zone should not be considered
all_unreclaimnable. The reason is that there was enough free memory
before compaction started but compaction takes some time during which
kswapd is not reclaiming pages at all. The view of the zone before and
after compaction is not directly related to all_unreclaimable so
all_reclaimable should only be set after shrinking a zone and there is
insufficient free memory to meet watermarks.

-- 
Mel Gorman
SUSE Labs
