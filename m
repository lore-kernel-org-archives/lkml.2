Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab2LTFZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:25:43 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49981 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTFZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:25:35 -0500
X-AuditID: 9c930197-b7c5bae000000e31-16-50d2a14c780f
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH] compaction: fix build error in CMA && !COMPACTION
Date: Thu, 20 Dec 2012 14:25:30 +0900
Message-Id: <1355981130-2382-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isolate_freepages_block and isolate_migratepages_range is used for CMA
as well as compaction so it breaks build for CONFIG_CMA &&
!CONFIG_COMPACTION.

This patch fixes it.

Cc: Mel Gorman <mgorman@suse.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/compaction.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 5ad7f4f..70f4443 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -17,6 +17,21 @@
 #include <linux/balloon_compaction.h>
 #include "internal.h"
 
+#ifdef CONFIG_COMPACTION
+static inline void count_compact_event(enum vm_event_item item)
+{
+	count_vm_event(item);
+}
+
+static inline void count_compact_events(enum vm_event_item item, long delta)
+{
+	count_vm_events(item, delta);
+}
+#else
+#define count_compact_event(item)
+#define count_compact_events(item, delta)
+#endif
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 #define CREATE_TRACE_POINTS
@@ -303,10 +318,9 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
 	if (blockpfn == end_pfn)
 		update_pageblock_skip(cc, valid_page, total_isolated, false);
 
-	count_vm_events(COMPACTFREE_SCANNED, nr_scanned);
+	count_compact_events(COMPACTFREE_SCANNED, nr_scanned);
 	if (total_isolated)
-		count_vm_events(COMPACTISOLATED, total_isolated);
-
+		count_compact_events(COMPACTISOLATED, total_isolated);
 	return total_isolated;
 }
 
@@ -613,9 +627,9 @@ next_pageblock:
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
-	count_vm_events(COMPACTMIGRATE_SCANNED, nr_scanned);
+	count_compact_events(COMPACTMIGRATE_SCANNED, nr_scanned);
 	if (nr_isolated)
-		count_vm_events(COMPACTISOLATED, nr_isolated);
+		count_compact_events(COMPACTISOLATED, nr_isolated);
 
 	return low_pfn;
 }
@@ -1110,7 +1124,7 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
 	if (!order || !may_enter_fs || !may_perform_io)
 		return rc;
 
-	count_vm_event(COMPACTSTALL);
+	count_compact_event(COMPACTSTALL);
 
 #ifdef CONFIG_CMA
 	if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
-- 
1.7.9.5

