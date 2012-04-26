Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2DZHy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:54:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58284 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2DZHy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:54:26 -0400
Subject: [PATCH 09/12] mm/vmscan: push lruvec pointer into shrink_list()
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Apr 2012 11:54:23 +0400
Message-ID: <20120426075422.18961.80799.stgit@zurg>
In-Reply-To: <20120426074632.18961.17803.stgit@zurg>
References: <20120426074632.18961.17803.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 mm/vmscan.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c055d6e..258e002 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1250,7 +1250,7 @@ update_isolated_counts(struct zone *zone,
  * of reclaimed pages
  */
 static noinline_for_stack unsigned long
-shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone *mz,
+shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		     struct scan_control *sc, enum lru_list lru)
 {
 	LIST_HEAD(page_list);
@@ -1263,9 +1263,8 @@ shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone *mz,
 	unsigned long nr_writeback = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
-	struct zone *zone = mz->zone;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
-	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, mz->mem_cgroup);
+	struct zone *zone = lruvec_zone(lruvec);
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1415,7 +1414,7 @@ static void move_active_pages_to_lru(struct zone *zone,
 }
 
 static void shrink_active_list(unsigned long nr_to_scan,
-			       struct mem_cgroup_zone *mz,
+			       struct lruvec *lruvec,
 			       struct scan_control *sc,
 			       enum lru_list lru)
 {
@@ -1426,12 +1425,11 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	unsigned long nr_rotated = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
-	struct zone *zone = mz->zone;
-	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, mz->mem_cgroup);
+	struct zone *zone = lruvec_zone(lruvec);
 
 	lru_add_drain();
 
@@ -1597,21 +1595,17 @@ static int inactive_list_is_low(struct lruvec *lruvec, int file)
 }
 
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
-				 struct mem_cgroup_zone *mz,
-				 struct scan_control *sc)
+				 struct lruvec *lruvec, struct scan_control *sc)
 {
 	int file = is_file_lru(lru);
 
 	if (is_active_lru(lru)) {
-		struct lruvec *lruvec = mem_cgroup_zone_lruvec(mz->zone,
-							       mz->mem_cgroup);
-
 		if (inactive_list_is_low(lruvec, file))
-			shrink_active_list(nr_to_scan, mz, sc, lru);
+			shrink_active_list(nr_to_scan, lruvec, sc, lru);
 		return 0;
 	}
 
-	return shrink_inactive_list(nr_to_scan, mz, sc, lru);
+	return shrink_inactive_list(nr_to_scan, lruvec, sc, lru);
 }
 
 static int vmscan_swappiness(struct scan_control *sc)
@@ -1854,7 +1848,7 @@ restart:
 				nr[lru] -= nr_to_scan;
 
 				nr_reclaimed += shrink_list(lru, nr_to_scan,
-							    mz, sc);
+							    lruvec, sc);
 			}
 		}
 		/*
@@ -1877,7 +1871,7 @@ restart:
 	 * rebalance the anon lru active/inactive ratio.
 	 */
 	if (inactive_anon_is_low(lruvec))
-		shrink_active_list(SWAP_CLUSTER_MAX, mz,
+		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
 
 	/* reclaim/compaction might need reclaim to continue */
@@ -2310,13 +2304,9 @@ static void age_active_anon(struct zone *zone, struct scan_control *sc)
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = memcg,
-			.zone = zone,
-		};
 
 		if (inactive_anon_is_low(lruvec))
-			shrink_active_list(SWAP_CLUSTER_MAX, &mz,
+			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 					   sc, LRU_ACTIVE_ANON);
 
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);

