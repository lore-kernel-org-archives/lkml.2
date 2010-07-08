Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0GHUCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:02:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751578Ab0GHUCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:02:15 -0400
Date: Thu, 8 Jul 2010 13:00:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
Message-Id: <20100708130048.fccfcdad.akpm@linux-foundation.org>
In-Reply-To: <20100708163401.CD34.A69D9226@jp.fujitsu.com>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Jul 2010 16:38:10 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> 'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
> unsafe.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> ---
>  mm/vmscan.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9c7e57c..8715da1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2588,7 +2588,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		.swappiness = vm_swappiness,
>  		.order = order,
>  	};
> -	unsigned long slab_reclaimable;
> +	unsigned long n, m;

Please use better identifiers.

>  	disable_swap_token();
>  	cond_resched();
> @@ -2615,8 +2615,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
>  	}
>  
> -	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> -	if (slab_reclaimable > zone->min_slab_pages) {
> +	n = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +	if (n > zone->min_slab_pages) {
>  		/*
>  		 * shrink_slab() does not currently allow us to determine how
>  		 * many pages were freed in this zone. So we take the current
> @@ -2628,16 +2628,16 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  		 * take a long time.
>  		 */
>  		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
> -			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
> -				slab_reclaimable - nr_pages)
> +		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages > n))
>  			;
>  
>  		/*
>  		 * Update nr_reclaimed by the number of slab pages we
>  		 * reclaimed from this zone.
>  		 */
> -		sc.nr_reclaimed += slab_reclaimable -
> -			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +		m = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +		if (m < n)
> +			sc.nr_reclaimed += n - m;

And it's not a completly trivial objection.  Your patch made the above
code snippet quite a lot harder to read (and hence harder to maintain).

