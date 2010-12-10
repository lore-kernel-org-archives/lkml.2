Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0LJPq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:46:28 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55794 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0LJPq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:46:27 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/6] mm: kswapd: Use the order that kswapd was reclaiming at for sleeping_prematurely()
Date: Fri, 10 Dec 2010 15:46:22 +0000
Message-Id: <1291995985-5913-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
References: <1291995985-5913-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before kswapd goes to sleep, it uses sleeping_prematurely() to check if
there was a race pushing a zone below its watermark. If the race happened,
it stays awake. However, balance_pgdat() can decide to reclaim at order-0
if it decides that high-order reclaim is not working as expected. This
information is not passed back to sleeping_prematurely().  The impact is
that kswapd remains awake reclaiming pages long after it should have gone
to sleep. This patch passes the adjusted order to sleeping_prematurely and
uses the same logic as balance_pgdat to decide if it's ok to go to sleep.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/vmscan.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6723101..4d968b0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2220,7 +2220,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, unsigned long balanced_pages,
 }
 
 /* is kswapd sleeping prematurely? */
-static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
+static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
 {
 	int i;
 	unsigned long balanced = 0;
@@ -2230,7 +2230,7 @@ static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
 	if (remaining)
 		return 1;
 
-	/* If after HZ/10, a zone is below the high mark, it's premature */
+	/* Check the watermark levels */
 	for (i = 0; i < pgdat->nr_zones; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
@@ -2262,7 +2262,7 @@ static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at high_wmark_pages(zone).
  *
- * Returns the number of pages which were actually freed.
+ * Returns the final order kswapd was reclaiming at
  *
  * There is special handling here for zones which are full of pinned pages.
  * This can happen if the pages are all mlocked, or if they are all used by
@@ -2525,7 +2525,13 @@ out:
 		}
 	}
 
-	return sc.nr_reclaimed;
+	/*
+	 * Return the order we were reclaiming at so sleeping_prematurely()
+	 * makes a decision on the order we were last reclaiming at. However,
+	 * if another caller entered the allocator slow path while kswapd
+	 * was awake, order will remain at the higher level
+	 */
+	return order;
 }
 
 static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
@@ -2652,7 +2658,7 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			balance_pgdat(pgdat, order, classzone_idx);
+			order = balance_pgdat(pgdat, order, classzone_idx);
 		}
 	}
 	return 0;
-- 
1.7.1

