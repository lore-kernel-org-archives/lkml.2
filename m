Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab2GFPaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:30:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47339 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab2GFPaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:30:01 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order 0
Date: Sat,  7 Jul 2012 00:28:41 +0900
Message-Id: <1341588521-17744-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_pages_direct_compact has many arguments so invoking it is very costly.
And in almost invoking case, order is 0, so return immediately.

Let's not invoke it when order 0

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6092f33..f4039aa 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2056,7 +2056,10 @@ out:
 }
 
 #ifdef CONFIG_COMPACTION
-/* Try memory compaction for high-order allocations before reclaim */
+/*
+ * Try memory compaction for high-order allocations before reclaim
+ * Must be called with order > 0
+ */
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
@@ -2067,8 +2070,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 {
 	struct page *page;
 
-	if (!order)
-		return NULL;
+	BUG_ON(!order);
 
 	if (compaction_deferred(preferred_zone, order)) {
 		*deferred_compaction = true;
@@ -2363,15 +2365,17 @@ rebalance:
 	 * Try direct compaction. The first pass is asynchronous. Subsequent
 	 * attempts after direct reclaim are synchronous
 	 */
-	page = __alloc_pages_direct_compact(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					migratetype, sync_migration,
-					&deferred_compaction,
-					&did_some_progress);
-	if (page)
-		goto got_pg;
+	if (unlikely(order)) {
+		page = __alloc_pages_direct_compact(gfp_mask, order,
+						zonelist, high_zoneidx,
+						nodemask,
+						alloc_flags, preferred_zone,
+						migratetype, sync_migration,
+						&deferred_compaction,
+						&did_some_progress);
+		if (page)
+			goto got_pg;
+	}
 	sync_migration = true;
 
 	/*
@@ -2446,15 +2450,17 @@ rebalance:
 		 * direct reclaim and reclaim/compaction depends on compaction
 		 * being called after reclaim so call directly if necessary
 		 */
-		page = __alloc_pages_direct_compact(gfp_mask, order,
-					zonelist, high_zoneidx,
-					nodemask,
-					alloc_flags, preferred_zone,
-					migratetype, sync_migration,
-					&deferred_compaction,
-					&did_some_progress);
-		if (page)
-			goto got_pg;
+		if (unlikely(order)) {
+			page = __alloc_pages_direct_compact(gfp_mask, order,
+						zonelist, high_zoneidx,
+						nodemask,
+						alloc_flags, preferred_zone,
+						migratetype, sync_migration,
+						&deferred_compaction,
+						&did_some_progress);
+			if (page)
+				goto got_pg;
+		}
 	}
 
 nopage:
-- 
1.7.9.5

