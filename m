Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0GIW3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:29:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671Ab0GIW3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:29:37 -0400
Date: Fri, 9 Jul 2010 15:28:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
Message-Id: <20100709152851.330bf2b2.akpm@linux-foundation.org>
In-Reply-To: <20100709090956.CD51.A69D9226@jp.fujitsu.com>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com>
	<20100708130048.fccfcdad.akpm@linux-foundation.org>
	<20100709090956.CD51.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Jul 2010 10:16:33 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2588,7 +2588,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		.swappiness = vm_swappiness,
>  		.order = order,
>  	};
> -	unsigned long slab_reclaimable;
> +	unsigned long nr_slab_pages0, nr_slab_pages1;
>  
>  	disable_swap_token();
>  	cond_resched();
> @@ -2615,8 +2615,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
>  	}
>  
> -	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> -	if (slab_reclaimable > zone->min_slab_pages) {
> +	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +	if (nr_slab_pages0 > zone->min_slab_pages) {
>  		/*
>  		 * shrink_slab() does not currently allow us to determine how
>  		 * many pages were freed in this zone.

Well no, but it could do so, with some minor changes to struct
reclaim_state and its handling.  Put a zone* and a counter in
reclaim_state, handle them in sl?b.c.

> So we take the current
> @@ -2628,16 +2628,17 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		 * take a long time.
>  		 */
>  		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
> -			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
> -				slab_reclaimable - nr_pages)
> +		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
> +				nr_slab_pages0))
>  			;
>  
>  		/*
>  		 * Update nr_reclaimed by the number of slab pages we
>  		 * reclaimed from this zone.
>  		 */
> -		sc.nr_reclaimed += slab_reclaimable -
> -			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +		nr_slab_pages1 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +		if (nr_slab_pages1 < nr_slab_pages0)
> +			sc.nr_reclaimed += nr_slab_pages0 - nr_slab_pages1;

My, that's horrible.  The whole expression says "this number is
basically a pile of random junk.  Let's add it in anyway".


>  	}
>  
>  	p->reclaim_state = NULL;
