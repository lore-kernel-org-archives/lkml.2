Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab1LARhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 12:37:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab1LARge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 12:36:34 -0500
From: Mel Gorman <mgorman@suse.de>
To: Linux-MM <linux-mm@kvack.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Nai Xia <nai.xia@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] mm: vmscan: Check if reclaim should really abort even if compaction_ready() is true for one zone
Date: Thu,  1 Dec 2011 17:36:20 +0000
Message-Id: <1322760981-28719-11-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1322760981-28719-1-git-send-email-mgorman@suse.de>
References: <1322760981-28719-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If compaction can proceed for a given zone, shrink_zones() does not
reclaim any more pages from it. After commit [e0c2327: vmscan: abort
reclaim/compaction if compaction can proceed], do_try_to_free_pages()
tries to finish as soon as possible once one zone can compact.

This was intended to prevent slabs being shrunk unnecessarily but
there are side-effects. One is that a small zone that is ready for
compaction will abort reclaim even if the chances of successfully
allocating a THP from that zone is small. It also means that reclaim
can return too early even though sc->nr_to_reclaim pages were not
reclaimed.

This partially reverts the commit until it is proven that slabs are
really being shrunk unnecessarily but preserves the check to return
1 to avoid OOM if reclaim was aborted prematurely.

[aarcange@redhat.com: This patch replaces a revert from Andrea]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6c7085d..b0eeec7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2176,7 +2176,8 @@ static inline bool compaction_ready(struct zone *zone, struct scan_control *sc)
  *
  * This function returns true if a zone is being reclaimed for a costly
  * high-order allocation and compaction is ready to begin. This indicates to
- * the caller that it should retry the allocation or fail.
+ * the caller that it should consider retrying the allocation instead of
+ * further reclaim.
  */
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -2185,7 +2186,7 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
-	bool should_abort_reclaim = false;
+	bool aborted_reclaim = false;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2211,7 +2212,7 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
 				 * allocations.
 				 */
 				if (compaction_ready(zone, sc)) {
-					should_abort_reclaim = true;
+					aborted_reclaim = true;
 					continue;
 				}
 			}
@@ -2233,7 +2234,7 @@ static bool shrink_zones(int priority, struct zonelist *zonelist,
 		shrink_zone(priority, zone, sc);
 	}
 
-	return should_abort_reclaim;
+	return aborted_reclaim;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2287,7 +2288,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
-	bool should_abort_reclaim;
+	bool aborted_reclaim;
 
 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2299,9 +2300,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		should_abort_reclaim = shrink_zones(priority, zonelist, sc);
-		if (should_abort_reclaim)
-			break;
+		aborted_reclaim = shrink_zones(priority, zonelist, sc);
 
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2368,8 +2367,8 @@ out:
 	if (oom_killer_disabled)
 		return 0;
 
-	/* Aborting reclaim to try compaction? don't OOM, then */
-	if (should_abort_reclaim)
+	/* Aborted reclaim to try compaction? don't OOM, then */
+	if (aborted_reclaim)
 		return 1;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
-- 
1.7.3.4

