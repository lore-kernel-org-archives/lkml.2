Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab2BVQxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:53:13 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59070 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2BVQtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:49:04 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 22 Feb 2012 17:48:43 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv23 02/16] mm: compaction: introduce isolate_migratepages_range()
In-reply-to: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>
Message-id: <1329929337-16648-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

This commit introduces isolate_migratepages_range() function which
extracts functionality from isolate_migratepages() so that it can be
used on arbitrary PFN ranges.

isolate_migratepages() function is implemented as a simple wrapper
around isolate_migratepages_range().

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Tested-by: Rob Clark <rob.clark@linaro.org>
Tested-by: Ohad Ben-Cohen <ohad@wizery.com>
Tested-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
---
 mm/compaction.c |   75 +++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 74a8c82..ee20fc0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -250,31 +250,34 @@ typedef enum {
 	ISOLATE_SUCCESS,	/* Pages isolated, migrate */
 } isolate_migrate_t;
 
-/*
- * Isolate all pages that can be migrated from the block pointed to by
- * the migrate scanner within compact_control.
+/**
+ * isolate_migratepages_range() - isolate all migrate-able pages in range.
+ * @zone:	Zone pages are in.
+ * @cc:		Compaction control structure.
+ * @low_pfn:	The first PFN of the range.
+ * @end_pfn:	The one-past-the-last PFN of the range.
+ *
+ * Isolate all pages that can be migrated from the range specified by
+ * [low_pfn, end_pfn).  Returns zero if there is a fatal signal
+ * pending), otherwise PFN of the first page that was not scanned
+ * (which may be both less, equal to or more then end_pfn).
+ *
+ * Assumes that cc->migratepages is empty and cc->nr_migratepages is
+ * zero.
+ *
+ * Apart from cc->migratepages and cc->nr_migratetypes this function
+ * does not modify any cc's fields, in particular it does not modify
+ * (or read for that matter) cc->migrate_pfn.
  */
-static isolate_migrate_t isolate_migratepages(struct zone *zone,
-					struct compact_control *cc)
+static unsigned long
+isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
+			   unsigned long low_pfn, unsigned long end_pfn)
 {
-	unsigned long low_pfn, end_pfn;
 	unsigned long last_pageblock_nr = 0, pageblock_nr;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
 	struct list_head *migratelist = &cc->migratepages;
 	isolate_mode_t mode = ISOLATE_ACTIVE|ISOLATE_INACTIVE;
 
-	/* Do not scan outside zone boundaries */
-	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
-
-	/* Only scan within a pageblock boundary */
-	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
-
-	/* Do not cross the free scanner or scan within a memory hole */
-	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
-		cc->migrate_pfn = end_pfn;
-		return ISOLATE_NONE;
-	}
-
 	/*
 	 * Ensure that there are not too many pages isolated from the LRU
 	 * list by either parallel reclaimers or compaction. If there are,
@@ -283,12 +286,12 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	while (unlikely(too_many_isolated(zone))) {
 		/* async migration should just abort */
 		if (!cc->sync)
-			return ISOLATE_ABORT;
+			return 0;
 
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		if (fatal_signal_pending(current))
-			return ISOLATE_ABORT;
+			return 0;
 	}
 
 	/* Time to isolate some pages for migration */
@@ -396,10 +399,40 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
 	acct_isolated(zone, cc);
 
 	spin_unlock_irq(&zone->lru_lock);
-	cc->migrate_pfn = low_pfn;
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
+	return low_pfn;
+}
+
+/*
+ * Isolate all pages that can be migrated from the block pointed to by
+ * the migrate scanner within compact_control.
+ */
+static isolate_migrate_t isolate_migratepages(struct zone *zone,
+					struct compact_control *cc)
+{
+	unsigned long low_pfn, end_pfn;
+
+	/* Do not scan outside zone boundaries */
+	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
+
+	/* Only scan within a pageblock boundary */
+	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
+
+	/* Do not cross the free scanner or scan within a memory hole */
+	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
+		cc->migrate_pfn = end_pfn;
+		return ISOLATE_NONE;
+	}
+
+	/* Perform the isolation */
+	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn);
+	if (!low_pfn)
+		return ISOLATE_ABORT;
+
+	cc->migrate_pfn = low_pfn;
+
 	return ISOLATE_SUCCESS;
 }
 
-- 
1.7.1.569.g6f426

