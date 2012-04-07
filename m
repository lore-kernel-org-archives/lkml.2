Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2DGCBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 22:01:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42098 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab2DGCBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 22:01:05 -0400
Date: Fri, 6 Apr 2012 19:00:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
cc: Mel Gorman <mgorman@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stuart Foster <smf.linux@ntlworld.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Christoph Lameter <cl@linux.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [ 101/175] mm: vmscan: forcibly scan highmem if there are too
 many buffer_heads pinning highmem
In-Reply-To: <20120406061248.GA16549@pcnci2.linuxbox.cz>
Message-ID: <alpine.LSU.2.00.1204061826210.3965@eggly.anvils>
References: <20120330194845.531765417@linuxfoundation.org> <1333422093.443.32.camel@deadeye> <20120405202435.GA11562@suse.de> <20120406061248.GA16549@pcnci2.linuxbox.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012, Nikola Ciprich wrote:
> Hi, sorry it took me a bit longer.
> 
> here's my backport,

To 3.0.27 I presume; I've not tried it against 3.2.14,
haven't checked if that would be much the same or not.

> compiles fine, kernel boots without any problems.
> please review.

Thank you for doing the work, but I'm afraid it looks wrong to me.
I'd be more confident to leave it to Mel myself.  Comments below.

> n.
> 
> Signed-off-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz
> 
> (backport of upstream commit cc715d99e529d470dde2f33a6614f255adea71f3)
> 
>     mm: vmscan: forcibly scan highmem if there are too many buffer_heads pinning highmem
>     
>     Stuart Foster reported on bugzilla that copying large amounts of data
>     from NTFS caused an OOM kill on 32-bit X86 with 16G of memory.  Andrew
>     Morton correctly identified that the problem was NTFS was using 512
>     blocks meaning each page had 8 buffer_heads in low memory pinning it.
>     
>     In the past, direct reclaim used to scan highmem even if the allocating
>     process did not specify __GFP_HIGHMEM but not any more.  kswapd no longer
>     will reclaim from zones that are above the high watermark.  The intention
>     in both cases was to minimise unnecessary reclaim.  The downside is on
>     machines with large amounts of highmem that lowmem can be fully consumed
>     by buffer_heads with nothing trying to free them.
>     
>     The following patch is based on a suggestion by Andrew Morton to extend
>     the buffer_heads_over_limit case to force kswapd and direct reclaim to
>     scan the highmem zone regardless of the allocation request or watermarks.
>     
>     Addresses https://bugzilla.kernel.org/show_bug.cgi?id=42578
> 
> ---
> 
> diff -Naur linux-3.0/mm/vmscan.c linux-3.0-cc715d99e529d470dde2f33a6614f255adea71f3-backport/mm/vmscan.c
> --- linux-3.0/mm/vmscan.c	2012-04-05 23:09:28.364000004 +0200
> +++ linux-3.0-cc715d99e529d470dde2f33a6614f255adea71f3-backport/mm/vmscan.c	2012-04-05 23:25:30.989968627 +0200
> @@ -1581,6 +1581,14 @@

diff -p is often more helpful, and especially so for this patch:
here we are in shrink_active_list().

>  			putback_lru_page(page);
>  			continue;
>  		}
> +		
> +		if (unlikely(buffer_heads_over_limit)) {
> +			if (page_has_private(page) && trylock_page(page)) {
> +				if (page_has_private(page))
> +					try_to_release_page(page, 0);
> +				unlock_page(page);
> +			}
> +		}
>  
>  		if (page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
>  			nr_rotated += hpage_nr_pages(page);

I don't think this does functional harm, but it duplicates the work
done by the pagevec_strip() you left in move_active_pages_to_lru(),
so the resulting source would be puzzling.

We could remove the pagevec_strip(), but really, it was just a
misunderstanding that led to my little buffer_heads_over_limit
cleanup in one place getting merged in with Mel's significant
buffer_heads_over_limit fix in another.

My cleanup doesn't deserve backporting to 3.0 or 3.2: I included it
in the 3.3 backport to avoid raised eyebrows, but once we get back
to kernels with pagevec_strip(), let's just leave this hunk out.

> @@ -2053,6 +2061,14 @@

Here we are in all_unreclaimable().

>  	struct zoneref *z;
>  	struct zone *zone;
>  
> +	/*
> +	 * If the number of buffer_heads in the machine exceeds the maximum
> +	 * allowed level, force direct reclaim to scan the highmem zone as
> +	 * highmem pages could be pinning lowmem pages storing buffer_heads
> +	 */
> +	if (buffer_heads_over_limit)
> +		sc->gfp_mask |= __GFP_HIGHMEM;
> +

But in Mel's patch that belongs to shrink_zones():
I don't see a reason to move it in the backport.

>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  			gfp_zone(sc->gfp_mask), sc->nodemask) {
>  		if (!populated_zone(zone))
> @@ -2514,7 +2530,8 @@

I think this hunk in balance_pgdat() is correct.

>  				(zone->present_pages +
>  					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
>  				KSWAPD_ZONE_BALANCE_GAP_RATIO);
> -			if (!zone_watermark_ok_safe(zone, order,
> +			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
> +				!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone) + balance_gap,
>  					end_zone, 0)) {
>  				shrink_zone(priority, zone, &sc);
> @@ -2543,6 +2560,17 @@

But this hunk in balance_pgdat() comes too late: it should set
end_zone in between the inactive_anon_is_low shrink_active_list
and the !zone_watermark_ok_safe() setting of end_zone higher up,
before the previous hunk.

>  				continue;
>  			}
>  
> +			/*
> +			 * If the number of buffer_heads in the machine
> +			 * exceeds the maximum allowed level and this node
> +			 * has a highmem zone, force kswapd to reclaim from
> +			 * it to relieve lowmem pressure.
> +			 */
> +			if (buffer_heads_over_limit && is_highmem_idx(i)) {
> +				end_zone = i;
> +				break;
> +			}
> +
>  			if (!zone_watermark_ok_safe(zone, order,
>  					high_wmark_pages(zone), end_zone, 0)) {
>  				all_zones_ok = 0;

Hugh
