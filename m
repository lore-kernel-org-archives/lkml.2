Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0GHHiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:38:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41469 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0GHHiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:38:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v2 1/2] vmscan: don't subtraction of unsined
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100708163401.CD34.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 16:38:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
unsafe.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/vmscan.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9c7e57c..8715da1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2588,7 +2588,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.swappiness = vm_swappiness,
 		.order = order,
 	};
-	unsigned long slab_reclaimable;
+	unsigned long n, m;
 
 	disable_swap_token();
 	cond_resched();
@@ -2615,8 +2615,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		} while (priority >= 0 && sc.nr_reclaimed < nr_pages);
 	}
 
-	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	if (slab_reclaimable > zone->min_slab_pages) {
+	n = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+	if (n > zone->min_slab_pages) {
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2628,16 +2628,16 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * take a long time.
 		 */
 		while (shrink_slab(sc.nr_scanned, gfp_mask, order) &&
-			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
-				slab_reclaimable - nr_pages)
+		       (zone_page_state(zone, NR_SLAB_RECLAIMABLE) + nr_pages > n))
 			;
 
 		/*
 		 * Update nr_reclaimed by the number of slab pages we
 		 * reclaimed from this zone.
 		 */
-		sc.nr_reclaimed += slab_reclaimable -
-			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+		m = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+		if (m < n)
+			sc.nr_reclaimed += n - m;
 	}
 
 	p->reclaim_state = NULL;
-- 
1.6.5.2



