Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2GaFHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:07:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48509 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755272Ab2GaEuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:03 -0400
Message-Id: <20120731044311.576903378@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Subject: [ 04/73] mm: page allocator: do not call direct reclaim for THP allocations while compaction is deferred
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit 66199712e9eef5aede09dbcd9dfff87798a66917 upstream.

Stable note: Not tracked in Buzilla. This was part of a series that
	reduced interactivity stalls experienced when THP was enabled.

If compaction is deferred, direct reclaim is used to try to free enough
pages for the allocation to succeed.  For small high-orders, this has a
reasonable chance of success.  However, if the caller has specified
__GFP_NO_KSWAPD to limit the disruption to the system, it makes more sense
to fail the allocation rather than stall the caller in direct reclaim.
This patch skips direct reclaim if compaction is deferred and the caller
specifies __GFP_NO_KSWAPD.

Async compaction only considers a subset of pages so it is possible for
compaction to be deferred prematurely and not enter direct reclaim even in
cases where it should.  To compensate for this, this patch also defers
compaction only if sync compaction failed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/page_alloc.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9404b38..cb5723c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1981,14 +1981,20 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress,
-	bool sync_migration)
+	int migratetype, bool sync_migration,
+	bool *deferred_compaction,
+	unsigned long *did_some_progress)
 {
 	struct page *page;
 
-	if (!order || compaction_deferred(preferred_zone))
+	if (!order)
 		return NULL;
 
+	if (compaction_deferred(preferred_zone)) {
+		*deferred_compaction = true;
+		return NULL;
+	}
+
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration);
@@ -2016,7 +2022,13 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		 * but not enough to satisfy watermarks.
 		 */
 		count_vm_event(COMPACTFAIL);
-		defer_compaction(preferred_zone);
+
+		/*
+		 * As async compaction considers a subset of pageblocks, only
+		 * defer if the failure was a sync compaction failure.
+		 */
+		if (sync_migration)
+			defer_compaction(preferred_zone);
 
 		cond_resched();
 	}
@@ -2028,8 +2040,9 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress,
-	bool sync_migration)
+	int migratetype, bool sync_migration,
+	bool *deferred_compaction,
+	unsigned long *did_some_progress)
 {
 	return NULL;
 }
@@ -2179,6 +2192,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	bool sync_migration = false;
+	bool deferred_compaction = false;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2259,12 +2273,22 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress,
-					sync_migration);
+					migratetype, sync_migration,
+					&deferred_compaction,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 	sync_migration = true;
 
+	/*
+	 * If compaction is deferred for high-order allocations, it is because
+	 * sync compaction recently failed. In this is the case and the caller
+	 * has requested the system not be heavily disrupted, fail the
+	 * allocation now instead of entering direct reclaim
+	 */
+	if (deferred_compaction && (gfp_mask & __GFP_NO_KSWAPD))
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
@@ -2328,8 +2352,9 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress,
-					sync_migration);
+					migratetype, sync_migration,
+					&deferred_compaction,
+					&did_some_progress);
 		if (page)
 			goto got_pg;
 	}


