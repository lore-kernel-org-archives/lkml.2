Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2DZHyH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:54:07 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42855 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab2DZHyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:54:00 -0400
Subject: [PATCH 02/12] mm: add link from struct lruvec to struct zone
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Apr 2012 11:53:56 +0400
Message-ID: <20120426075356.18961.40318.stgit@zurg>
In-Reply-To: <20120426074632.18961.17803.stgit@zurg>
References: <20120426074632.18961.17803.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is first stage of struct mem_cgroup_zone removal, further patches replaces
struct mem_cgroup_zone with pointer to struct lruvec.
If CONFIG_CGROUP_MEM_RES_CTLR=n page_zone() is just container_of().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/mmzone.h |   14 ++++++++++++++
 mm/memcontrol.c        |    4 +---
 mm/mmzone.c            |   14 ++++++++++++++
 mm/page_alloc.c        |    8 +-------
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6ee32b2..7ac3527 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -201,6 +201,9 @@ struct zone_reclaim_stat {
 struct lruvec {
 	struct list_head lists[NR_LRU_LISTS];
 	struct zone_reclaim_stat reclaim_stat;
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	struct zone *zone;
+#endif
 };
 
 /* Mask used at gathering information at once (see memcontrol.c) */
@@ -729,6 +732,17 @@ extern int init_currently_empty_zone(struct zone *zone, unsigned long start_pfn,
 				     unsigned long size,
 				     enum memmap_context context);
 
+extern void lruvec_init(struct lruvec *lruvec, struct zone *zone);
+
+static inline struct zone *lruvec_zone(struct lruvec *lruvec)
+{
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	return lruvec->zone;
+#else
+	return container_of(lruvec, struct zone, lruvec);
+#endif
+}
+
 #ifdef CONFIG_HAVE_MEMORY_PRESENT
 void memory_present(int nid, unsigned long start, unsigned long end);
 #else
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8d9d29f..66c2f80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4730,7 +4730,6 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
-	enum lru_list lru;
 	int zone, tmp = node;
 	/*
 	 * This routine is called against possible nodes.
@@ -4748,8 +4747,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-		for_each_lru(lru)
-			INIT_LIST_HEAD(&mz->lruvec.lists[lru]);
+		lruvec_init(&mz->lruvec, &NODE_DATA(node)->node_zones[zone]);
 		mz->usage_in_excess = 0;
 		mz->on_tree = false;
 		mz->memcg = memcg;
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 7cf7b7d..6830eab 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -86,3 +86,17 @@ int memmap_valid_within(unsigned long pfn,
 	return 1;
 }
 #endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
+
+void lruvec_init(struct lruvec *lruvec, struct zone *zone)
+{
+	enum lru_list lru;
+
+	memset(lruvec, 0, sizeof(struct lruvec));
+
+	for_each_lru(lru)
+		INIT_LIST_HEAD(&lruvec->lists[lru]);
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR
+	lruvec->zone = zone;
+#endif
+}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1be83d5..63cb3a8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4374,7 +4374,6 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
-		enum lru_list lru;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
@@ -4424,12 +4423,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(lru)
-			INIT_LIST_HEAD(&zone->lruvec.lists[lru]);
-		zone->lruvec.reclaim_stat.recent_rotated[0] = 0;
-		zone->lruvec.reclaim_stat.recent_rotated[1] = 0;
-		zone->lruvec.reclaim_stat.recent_scanned[0] = 0;
-		zone->lruvec.reclaim_stat.recent_scanned[1] = 0;
+		lruvec_init(&zone->lruvec, zone);
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)

