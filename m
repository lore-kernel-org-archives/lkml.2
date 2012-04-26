Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2DZHy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:54:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58284 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab2DZHyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:54:37 -0400
Subject: [PATCH 12/12] mm/vmscan: kill struct mem_cgroup_zone
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Apr 2012 11:54:34 +0400
Message-ID: <20120426075434.18961.47496.stgit@zurg>
In-Reply-To: <20120426074632.18961.17803.stgit@zurg>
References: <20120426074632.18961.17803.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills struct mem_cgroup_zone and renames shrink_mem_cgroup_zone()
into shrink_lruvec(), it always shrinks one lruvec which it takes as argument.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9114739..34cd8a5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -94,11 +94,6 @@ struct scan_control {
 	nodemask_t	*nodemask;
 };
 
-struct mem_cgroup_zone {
-	struct mem_cgroup *mem_cgroup;
-	struct zone *zone;
-};
-
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
 #ifdef ARCH_HAS_PREFETCH
@@ -1811,8 +1806,7 @@ static inline bool should_continue_reclaim(struct lruvec *lruvec,
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_mem_cgroup_zone(struct mem_cgroup_zone *mz,
-				   struct scan_control *sc)
+static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
@@ -1820,9 +1814,6 @@ static void shrink_mem_cgroup_zone(struct mem_cgroup_zone *mz,
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
-	struct lruvec *lruvec;
-
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 
 restart:
 	nr_reclaimed = 0;
@@ -1884,12 +1875,10 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
 
 	memcg = mem_cgroup_iter(root, NULL, &reclaim);
 	do {
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = memcg,
-			.zone = zone,
-		};
+		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
+
+		shrink_lruvec(lruvec, sc);
 
-		shrink_mem_cgroup_zone(&mz, sc);
 		/*
 		 * Limit reclaim has historically picked one memcg and
 		 * scanned it with decreasing priority levels until
@@ -2214,10 +2203,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
 		.priority = 0,
 		.target_mem_cgroup = memcg,
 	};
-	struct mem_cgroup_zone mz = {
-		.mem_cgroup = memcg,
-		.zone = zone,
-	};
+	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
@@ -2233,7 +2219,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *memcg,
 	 * will pick up pages from other mem cgroup's as well. We hack
 	 * the priority and make it zero.
 	 */
-	shrink_mem_cgroup_zone(&mz, &sc);
+	shrink_lruvec(lruvec, &sc);
 
 	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed);
 

