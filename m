Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab0FYLXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 07:23:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46717 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0FYLXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 07:23:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 2/2] vmscan: don't subtraction of unsined 
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100625201915.8067.A69D9226@jp.fujitsu.com>
References: <20100625201915.8067.A69D9226@jp.fujitsu.com>
Message-Id: <20100625202126.806A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 25 Jun 2010 20:23:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'slab_reclaimable' and 'nr_pages' are unsigned. so, subtraction is
unsafe.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c927948..b1a90f8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2612,6 +2612,8 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
 	if (slab_reclaimable > zone->min_slab_pages) {
 		unsigned long lru_pages = zone_reclaimable_pages(zone);
+		unsigned long srec_new;
+
 		/*
 		 * shrink_slab() does not currently allow us to determine how
 		 * many pages were freed in this zone. So we take the current
@@ -2622,17 +2624,21 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		 * Note that shrink_slab will free memory on all zones and may
 		 * take a long time.
 		 */
-		while (shrink_slab(sc.nr_scanned, gfp_mask, lru_pages) &&
-			zone_page_state(zone, NR_SLAB_RECLAIMABLE) >
-				slab_reclaimable - nr_pages)
-			;
+		for (;;) {
+			if (!shrink_slab(sc.nr_scanned, gfp_mask, lru_pages))
+				break;
+			srec_new = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+			if (srec_new + nr_pages <= slab_reclaimable)
+				break;
+		}
 
 		/*
 		 * Update nr_reclaimed by the number of slab pages we
 		 * reclaimed from this zone.
 		 */
-		sc.nr_reclaimed += slab_reclaimable -
-			zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+		srec_new = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
+		if (srec_new < slab_reclaimable)
+			sc.nr_reclaimed += slab_reclaimable - srec_new;
 	}
 
 	p->reclaim_state = NULL;
-- 
1.6.5.2



