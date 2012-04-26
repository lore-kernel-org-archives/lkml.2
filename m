Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2DZHzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:55:43 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42855 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424Ab2DZHyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:54:19 -0400
Subject: [PATCH 07/12] mm/vmscan: replace zone_nr_lru_pages() with
 get_lruvec_size()
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Apr 2012 11:54:15 +0400
Message-ID: <20120426075415.18961.59046.stgit@zurg>
In-Reply-To: <20120426074632.18961.17803.stgit@zurg>
References: <20120426074632.18961.17803.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory cgroup enabled we always use lruvecs which are embedded into
struct mem_cgroup_per_zone, so we can reach lru_size counters via container_of().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/memcontrol.h |    6 ++----
 mm/memcontrol.c            |    9 +++++++++
 mm/vmscan.c                |   31 ++++++++++++++++---------------
 3 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 76f9d9b..7980187 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -122,8 +122,7 @@ int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
-unsigned long mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg,
-					int nid, int zid, unsigned int lrumask);
+unsigned long mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
 extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
@@ -342,8 +341,7 @@ mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
 }
 
 static inline unsigned long
-mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
-				unsigned int lru_mask)
+mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	return 0;
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 66c2f80..2cb6f4d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -723,6 +723,15 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 }
 
 unsigned long
+mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
+{
+	struct mem_cgroup_per_zone *mz;
+
+	mz = container_of(lruvec, struct mem_cgroup_per_zone, lruvec);
+	return mz->lru_size[lru];
+}
+
+static unsigned long
 mem_cgroup_zone_nr_lru_pages(struct mem_cgroup *memcg, int nid, int zid,
 			unsigned int lru_mask)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 31df071..6d46117 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -155,19 +155,14 @@ static struct zone_reclaim_stat *get_reclaim_stat(struct mem_cgroup_zone *mz)
 	return &mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup)->reclaim_stat;
 }
 
-static unsigned long zone_nr_lru_pages(struct mem_cgroup_zone *mz,
-				       enum lru_list lru)
+static unsigned long get_lruvec_size(struct lruvec *lruvec, enum lru_list lru)
 {
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_zone_nr_lru_pages(mz->mem_cgroup,
-						    zone_to_nid(mz->zone),
-						    zone_idx(mz->zone),
-						    BIT(lru));
+		return mem_cgroup_get_lruvec_size(lruvec, lru);
 
-	return zone_page_state(mz->zone, NR_LRU_BASE + lru);
+	return zone_page_state(lruvec_zone(lruvec), NR_LRU_BASE + lru);
 }
 
-
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1645,6 +1640,9 @@ static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
 	enum lru_list lru;
 	int noswap = 0;
 	bool force_scan = false;
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 
 	/*
 	 * If the zone or memcg is small, nr[l] can be 0.  This
@@ -1670,10 +1668,10 @@ static void get_scan_count(struct mem_cgroup_zone *mz, struct scan_control *sc,
 		goto out;
 	}
 
-	anon  = zone_nr_lru_pages(mz, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(mz, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(mz, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(mz, LRU_INACTIVE_FILE);
+	anon  = get_lruvec_size(lruvec, LRU_ACTIVE_ANON) +
+		get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
+	file  = get_lruvec_size(lruvec, LRU_ACTIVE_FILE) +
+		get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
 
 	if (global_reclaim(sc)) {
 		free  = zone_page_state(mz->zone, NR_FREE_PAGES);
@@ -1736,7 +1734,7 @@ out:
 		int file = is_file_lru(lru);
 		unsigned long scan;
 
-		scan = zone_nr_lru_pages(mz, lru);
+		scan = get_lruvec_size(lruvec, lru);
 		if (sc->priority || noswap) {
 			scan >>= sc->priority;
 			if (!scan && force_scan)
@@ -1772,6 +1770,7 @@ static inline bool should_continue_reclaim(struct mem_cgroup_zone *mz,
 {
 	unsigned long pages_for_compaction;
 	unsigned long inactive_lru_pages;
+	struct lruvec *lruvec;
 
 	/* If not in reclaim/compaction mode, stop */
 	if (!in_reclaim_compaction(sc))
@@ -1804,10 +1803,12 @@ static inline bool should_continue_reclaim(struct mem_cgroup_zone *mz,
 	 * If we have not reclaimed enough pages for compaction and the
 	 * inactive lists are large enough, continue reclaiming
 	 */
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 	pages_for_compaction = (2UL << sc->order);
-	inactive_lru_pages = zone_nr_lru_pages(mz, LRU_INACTIVE_FILE);
+	inactive_lru_pages = get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
 	if (nr_swap_pages > 0)
-		inactive_lru_pages += zone_nr_lru_pages(mz, LRU_INACTIVE_ANON);
+		inactive_lru_pages += get_lruvec_size(lruvec,
+						      LRU_INACTIVE_ANON);
 	if (sc->nr_reclaimed < pages_for_compaction &&
 			inactive_lru_pages > pages_for_compaction)
 		return true;

