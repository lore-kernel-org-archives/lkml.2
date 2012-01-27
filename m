Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2A0Xgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:36:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2A0Xge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:36:34 -0500
Date: Fri, 27 Jan 2012 15:36:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3 -mm 2/3] mm: kswapd carefully call compaction
Message-Id: <20120127153628.53f04f7d.akpm@linux-foundation.org>
In-Reply-To: <20120126145958.4c37ea04@cuia.bos.redhat.com>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
	<20120126145958.4c37ea04@cuia.bos.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 14:59:58 -0500
Rik van Riel <riel@redhat.com> wrote:

> With CONFIG_COMPACTION enabled, kswapd does not try to free
> contiguous free pages, even when it is woken for a higher order
> request.
> 
> This could be bad for eg. jumbo frame network allocations, which
> are done from interrupt context and cannot compact memory themselves.
> Higher than before allocation failure rates in the network receive
> path have been observed in kernels with compaction enabled.
> 
> Teach kswapd to defragment the memory zones in a node, but only
> if required and compaction is not deferred in a zone.
> 
> ...
>
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2673,6 +2673,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
>  	int priority;
>  	int i;
>  	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
> +	int zones_need_compaction = 1;
>  	unsigned long total_scanned;
>  	struct reclaim_state *reclaim_state = current->reclaim_state;
>  	unsigned long nr_soft_reclaimed;
> @@ -2937,9 +2938,17 @@ out:
>  				goto loop_again;
>  			}
>  
> +			/* Check if the memory needs to be defragmented. */
> +			if (zone_watermark_ok(zone, order,
> +				    low_wmark_pages(zone), *classzone_idx, 0))
> +				zones_need_compaction = 0;
> +
>  			/* If balanced, clear the congested flag */
>  			zone_clear_flag(zone, ZONE_CONGESTED);
>  		}
> +
> +		if (zones_need_compaction)
> +			compact_pgdat(pgdat, order);
>  	}

Nicer:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: vmscan-kswapd-carefully-call-compaction-fix

reduce scope of zones_need_compaction

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~vmscan-kswapd-carefully-call-compaction-fix
+++ a/mm/vmscan.c
@@ -2672,7 +2672,6 @@ static unsigned long balance_pgdat(pg_da
 	int priority;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
-	int zones_need_compaction = 1;
 	unsigned long total_scanned;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
 	unsigned long nr_soft_reclaimed;
@@ -2920,6 +2919,8 @@ out:
 	 * and it is potentially going to sleep here.
 	 */
 	if (order) {
+		int zones_need_compaction = 1;
+
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
_

(could have given it type "bool", but that seems unnecessary when it
has "needs" in the name)
