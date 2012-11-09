Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2KIWSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 17:18:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56291 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2KIWSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 17:18:23 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: compaction: Fix compiler warning
Date: Fri,  9 Nov 2012 23:18:17 +0100
Message-Id: <1352499497-32266-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:iDQCl1J34+4tAqYcORujelllBkYpdYRODESd3z592YH
 x/pKZIFrJKUC518tS0Dlas+/bf7wKGidFQ2b2mS+yHD5zsdFbL
 0M4AtKp97InmzGmV84BPvl2uKPf2rdasuw+fvkU42D1vomgeB7
 EVsq+Z6TdIlxbM6/voaOpVddmNQZL+pJ1itMXIq79BGlMQcU3u
 qBs9AjHEIqnQmlGqD+ut0wIg9PG4we6Qi68CF570x3ByPE27jj
 KorHQNIOLT3U9aRDbe4YkuKDQGIQobJ9Tg1bwgxslSltM4OqSk
 Svbw/GGOMWCA4VRc//I5DPfoP7LdZItPzs+sskftJNOaf256nK
 wwBrSmqnGSj5+092o8Ggeb6cBUN1cMwRIc4SWw6lr6Fc6ffSJk
 IcllS1rwxvGXKQ/cR8dObGjEAU6v+pD4q1Z7C2LgrVQlf/L0rR
 cxVMW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compact_capture_page() function is only used if compaction is
enabled so it should be moved into the corresponding #ifdef.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 mm/compaction.c | 108 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f268bd8..d33e6d0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -215,60 +215,6 @@ static bool suitable_migration_target(struct page *page)
 	return false;
 }
 
-static void compact_capture_page(struct compact_control *cc)
-{
-	unsigned long flags;
-	int mtype, mtype_low, mtype_high;
-
-	if (!cc->page || *cc->page)
-		return;
-
-	/*
-	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
-	 * regardless of the migratetype of the freelist is is captured from.
-	 * This is fine because the order for a high-order MIGRATE_MOVABLE
-	 * allocation is typically at least a pageblock size and overall
-	 * fragmentation is not impaired. Other allocation types must
-	 * capture pages from their own migratelist because otherwise they
-	 * could pollute other pageblocks like MIGRATE_MOVABLE with
-	 * difficult to move pages and making fragmentation worse overall.
-	 */
-	if (cc->migratetype == MIGRATE_MOVABLE) {
-		mtype_low = 0;
-		mtype_high = MIGRATE_PCPTYPES;
-	} else {
-		mtype_low = cc->migratetype;
-		mtype_high = cc->migratetype + 1;
-	}
-
-	/* Speculatively examine the free lists without zone lock */
-	for (mtype = mtype_low; mtype < mtype_high; mtype++) {
-		int order;
-		for (order = cc->order; order < MAX_ORDER; order++) {
-			struct page *page;
-			struct free_area *area;
-			area = &(cc->zone->free_area[order]);
-			if (list_empty(&area->free_list[mtype]))
-				continue;
-
-			/* Take the lock and attempt capture of the page */
-			if (!compact_trylock_irqsave(&cc->zone->lock, &flags, cc))
-				return;
-			if (!list_empty(&area->free_list[mtype])) {
-				page = list_entry(area->free_list[mtype].next,
-							struct page, lru);
-				if (capture_free_page(page, cc->order, mtype)) {
-					spin_unlock_irqrestore(&cc->zone->lock,
-									flags);
-					*cc->page = page;
-					return;
-				}
-			}
-			spin_unlock_irqrestore(&cc->zone->lock, flags);
-		}
-	}
-}
-
 /*
  * Isolate free pages onto a private freelist. Caller must hold zone->lock.
  * If @strict is true, will abort returning 0 on any invalid PFNs or non-free
@@ -945,6 +891,60 @@ unsigned long compaction_suitable(struct zone *zone, int order)
 	return COMPACT_CONTINUE;
 }
 
+static void compact_capture_page(struct compact_control *cc)
+{
+	unsigned long flags;
+	int mtype, mtype_low, mtype_high;
+
+	if (!cc->page || *cc->page)
+		return;
+
+	/*
+	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
+	 * regardless of the migratetype of the freelist is is captured from.
+	 * This is fine because the order for a high-order MIGRATE_MOVABLE
+	 * allocation is typically at least a pageblock size and overall
+	 * fragmentation is not impaired. Other allocation types must
+	 * capture pages from their own migratelist because otherwise they
+	 * could pollute other pageblocks like MIGRATE_MOVABLE with
+	 * difficult to move pages and making fragmentation worse overall.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE) {
+		mtype_low = 0;
+		mtype_high = MIGRATE_PCPTYPES;
+	} else {
+		mtype_low = cc->migratetype;
+		mtype_high = cc->migratetype + 1;
+	}
+
+	/* Speculatively examine the free lists without zone lock */
+	for (mtype = mtype_low; mtype < mtype_high; mtype++) {
+		int order;
+		for (order = cc->order; order < MAX_ORDER; order++) {
+			struct page *page;
+			struct free_area *area;
+			area = &(cc->zone->free_area[order]);
+			if (list_empty(&area->free_list[mtype]))
+				continue;
+
+			/* Take the lock and attempt capture of the page */
+			if (!compact_trylock_irqsave(&cc->zone->lock, &flags, cc))
+				return;
+			if (!list_empty(&area->free_list[mtype])) {
+				page = list_entry(area->free_list[mtype].next,
+							struct page, lru);
+				if (capture_free_page(page, cc->order, mtype)) {
+					spin_unlock_irqrestore(&cc->zone->lock,
+									flags);
+					*cc->page = page;
+					return;
+				}
+			}
+			spin_unlock_irqrestore(&cc->zone->lock, flags);
+		}
+	}
+}
+
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
-- 
1.8.0

