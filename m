Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0GIBQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 21:16:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37134 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0GIBQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 21:16:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/2] vmscan: don't subtraction of unsined
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20100708130048.fccfcdad.akpm@linux-foundation.org>
References: <20100708163401.CD34.A69D9226@jp.fujitsu.com> <20100708130048.fccfcdad.akpm@linux-foundation.org>
Message-Id: <20100709090956.CD51.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Jul 2010 10:16:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > @@ -2628,16 +2628,16 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >  		 * take a long time.
> >  		 */
> >  		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
> > -			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
> > -				slab_reclaimable - nr_pages)
> > +		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages > n))
> >  			;
> >  
> >  		/*
> >  		 * Update nr_reclaimed by the number of slab pages we
> >  		 * reclaimed from this zone.
> >  		 */
> > -		sc.nr_reclaimed += slab_reclaimable -
> > -			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> > +		m = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> > +		if (m < n)
> > +			sc.nr_reclaimed += n - m;
> 
> And it's not a completly trivial objection.  Your patch made the above
> code snippet quite a lot harder to read (and hence harder to maintain).

Initially, I proposed following patch to Christoph. but he prefer n and m.
To be honest, I don't think this naming is big matter. so you prefer following
I'll submit it.




=====================================================================
>From 397199d69860061eaa5e1aaadac45c46c76b0522 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 30 Jun 2010 13:35:16 +0900
Subject: [PATCH] vmscan: don't subtraction of unsined

'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
unsafe.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c7e57c..79ff877 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2588,7 +2588,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.swappiness = vm_swappiness,
 		.order = order,
 	};
-	unsigned long slab_reclaimable;
+	unsigned long nr_slab_pages0, nr_slab_pages1;
 
 	disable_swap_token();
 	cond_resched();
@@ -2615,8 +2615,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
 	}
 
-	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	if (slab_reclaimable > zone->min_slab_pages) {
+	nr_slab_pages0 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+	if (nr_slab_pages0 > zone->min_slab_pages) {
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2628,16 +2628,17 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * take a long time.
 		 */
 		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
-			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
-				slab_reclaimable - nr_pages)
+		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages >
+				nr_slab_pages0))
 			;
 
 		/*
 		 * Update nr_reclaimed by the number of slab pages we
 		 * reclaimed from this zone.
 		 */
-		sc.nr_reclaimed += slab_reclaimable -
-			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+		nr_slab_pages1 = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+		if (nr_slab_pages1 < nr_slab_pages0)
+			sc.nr_reclaimed += nr_slab_pages0 - nr_slab_pages1;
 	}
 
 	p->reclaim_state = NULL;
-- 
1.6.5.2







