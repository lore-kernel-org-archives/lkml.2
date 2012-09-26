Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2IZGaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:30:01 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58499 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2IZG3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:29:40 -0400
X-AuditID: 9c93016f-b7b23ae000004419-8e-5062a0d05d15
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] CMA: migrate mlocked page
Date: Wed, 26 Sep 2012 15:32:45 +0900
Message-Id: <1348641165-29108-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now CMA can't migrate mlocked page so it ends up fail to allocate
contiguous memory space. It's not good for CMA.
This patch makes mlocked page be migrated out.
Of course, it can affect realtime processes but in CMA usecase,
contiguos memory allocation failing is far worse than access latency
to an mlcoked page being vairable while CMA is running.
If someone want to make the system realtime, he shouldn't enable
CMA because stall happens in random time.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/mmzone.h |    2 ++
 mm/compaction.c        |    8 ++++++--
 mm/internal.h          |    2 +-
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |    4 ++--
 5 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 10aa549..2c9348a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -218,6 +218,8 @@ struct lruvec {
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x2)
 /* Isolate for asynchronous migration */
 #define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x4)
+/* Isolate unevictable pages */
+#define ISOLATE_UNEVICTABLE	((__force isolate_mode_t)0x8)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
diff --git a/mm/compaction.c b/mm/compaction.c
index 5037399..891637d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -445,6 +445,7 @@ static bool too_many_isolated(struct zone *zone)
  * @cc:		Compaction control structure.
  * @low_pfn:	The first PFN of the range.
  * @end_pfn:	The one-past-the-last PFN of the range.
+ * @unevictable: true if it allows to isolate unevictable pages
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn).  Returns zero if there is a fatal signal
@@ -460,7 +461,7 @@ static bool too_many_isolated(struct zone *zone)
  */
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-			   unsigned long low_pfn, unsigned long end_pfn)
+		unsigned long low_pfn, unsigned long end_pfn, bool unevictable)
 {
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
@@ -585,6 +586,9 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		if (!cc->sync)
 			mode |= ISOLATE_ASYNC_MIGRATE;
 
+		if (unevictable)
+			mode |= ISOLATE_UNEVICTABLE;
+
 		lruvec = mem_cgroup_page_lruvec(page, zone);
 
 		/* Try isolate the page */
@@ -790,7 +794,7 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	}
 
 	/* Perform the isolation */
-	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn);
+	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn, false);
 	if (!low_pfn || cc->contended)
 		return ISOLATE_ABORT;
 
diff --git a/mm/internal.h b/mm/internal.h
index d1e84fd..9d5d276 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -138,7 +138,7 @@ unsigned long
 isolate_freepages_range(unsigned long start_pfn, unsigned long end_pfn);
 unsigned long
 isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
-			   unsigned long low_pfn, unsigned long end_pfn);
+	unsigned long low_pfn, unsigned long end_pfn, bool unevictable);
 
 #endif
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1a69094..296bea9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5694,7 +5694,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
 		if (list_empty(&cc.migratepages)) {
 			cc.nr_migratepages = 0;
 			pfn = isolate_migratepages_range(cc.zone, &cc,
-							 pfn, end);
+							 pfn, end, true);
 			if (!pfn) {
 				ret = -EINTR;
 				break;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b5e45f4..1df51f4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1009,8 +1009,8 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 	if (!PageLRU(page))
 		return ret;
 
-	/* Do not give back unevictable pages for compaction */
-	if (PageUnevictable(page))
+	/* Compaction can't handle unevictable pages but CMA can do */
+	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
 		return ret;
 
 	ret = -EBUSY;
-- 
1.7.9.5

