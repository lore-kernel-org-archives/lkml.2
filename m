Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab2AZUCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 15:02:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2AZUCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 15:02:52 -0500
Date: Thu, 26 Jan 2012 15:01:02 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH v3 -mm 3/3] mm: only defer compaction for failed order and
 higher
Message-ID: <20120126150102.30b75cfe@cuia.bos.redhat.com>
In-Reply-To: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a failed order-9 (transparent hugepage) compaction can
lead to memory compaction being temporarily disabled for a memory
zone.  Even if we only need compaction for an order 2 allocation,
eg. for jumbo frames networking.

The fix is relatively straightforward: keep track of the highest
order at which compaction is succeeding, and only defer compaction
for orders at which compaction is failing.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
-v3: add comment suggested by Mel Gorman

 include/linux/compaction.h |   14 ++++++++++----
 include/linux/mmzone.h     |    1 +
 mm/compaction.c            |   12 +++++++++++-
 mm/page_alloc.c            |    6 ++++--
 mm/vmscan.c                |    2 +-
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/compaction.h b/include/linux/compaction.h
index 7a9323a..51a90b7 100644
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -34,20 +34,26 @@ extern unsigned long compaction_suitable(struct zone *zone, int order);
  * allocation success. 1 << compact_defer_limit compactions are skipped up
  * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
-static inline void defer_compaction(struct zone *zone)
+static inline void defer_compaction(struct zone *zone, int order)
 {
 	zone->compact_considered = 0;
 	zone->compact_defer_shift++;
 
+	if (order < zone->compact_order_failed)
+		zone->compact_order_failed = order;
+
 	if (zone->compact_defer_shift > COMPACT_MAX_DEFER_SHIFT)
 		zone->compact_defer_shift = COMPACT_MAX_DEFER_SHIFT;
 }
 
 /* Returns true if compaction should be skipped this time */
-static inline bool compaction_deferred(struct zone *zone)
+static inline bool compaction_deferred(struct zone *zone, int order)
 {
 	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
 
+	if (order < zone->compact_order_failed)
+		return false;
+
 	/* Avoid possible overflow */
 	if (++zone->compact_considered > defer_limit)
 		zone->compact_considered = defer_limit;
@@ -73,11 +79,11 @@ static inline unsigned long compaction_suitable(struct zone *zone, int order)
 	return COMPACT_SKIPPED;
 }
 
-static inline void defer_compaction(struct zone *zone)
+static inline void defer_compaction(struct zone *zone, int order)
 {
 }
 
-static inline bool compaction_deferred(struct zone *zone)
+static inline bool compaction_deferred(struct zone *zone, int order)
 {
 	return 1;
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 650ba2f..dff7115 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -365,6 +365,7 @@ struct zone {
 	 */
 	unsigned int		compact_considered;
 	unsigned int		compact_defer_shift;
+	int			compact_order_failed;
 #endif
 
 	ZONE_PADDING(_pad1_)
diff --git a/mm/compaction.c b/mm/compaction.c
index 51ece75..3bde234 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -673,9 +673,19 @@ static int __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
 		INIT_LIST_HEAD(&cc->freepages);
 		INIT_LIST_HEAD(&cc->migratepages);
 
-		if (cc->order < 0 || !compaction_deferred(zone))
+		if (cc->order < 0 || !compaction_deferred(zone, cc->order))
 			compact_zone(zone, cc);
 
+		if (cc->order > 0) {
+			int ok = zone_watermark_ok(zone, cc->order,
+						low_wmark_pages(zone), 0, 0);
+			if (ok && cc->order > zone->compact_order_failed)
+				zone->compact_order_failed = cc->order + 1;
+			/* Currently async compaction is never deferred. */
+			else if (!ok && cc->sync)
+				defer_compaction(zone, cc->order);
+		}
+
 		VM_BUG_ON(!list_empty(&cc->freepages));
 		VM_BUG_ON(!list_empty(&cc->migratepages));
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0027d8f..cd617d9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1990,7 +1990,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	if (!order)
 		return NULL;
 
-	if (compaction_deferred(preferred_zone)) {
+	if (compaction_deferred(preferred_zone, order)) {
 		*deferred_compaction = true;
 		return NULL;
 	}
@@ -2012,6 +2012,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		if (page) {
 			preferred_zone->compact_considered = 0;
 			preferred_zone->compact_defer_shift = 0;
+			if (order >= preferred_zone->compact_order_failed)
+				preferred_zone->compact_order_failed = order + 1;
 			count_vm_event(COMPACTSUCCESS);
 			return page;
 		}
@@ -2028,7 +2030,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		 * defer if the failure was a sync compaction failure.
 		 */
 		if (sync_migration)
-			defer_compaction(preferred_zone);
+			defer_compaction(preferred_zone, order);
 
 		cond_resched();
 	}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0d7a9cd..021ca2f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2196,7 +2196,7 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
 	 * If compaction is deferred, reclaim up to a point where
 	 * compaction will have a chance of success when re-enabled
 	 */
-	if (compaction_deferred(zone))
+	if (compaction_deferred(zone, sc->order))
 		return watermark_ok;
 
 	/* If compaction is not ready to start, keep reclaiming */

