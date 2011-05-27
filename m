Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1E0Md6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:33:58 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39646 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1E0McE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:32:04 -0400
From: Ankita Garg <ankita@in.ibm.com>
To: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: ankita@in.ibm.com, svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Subject: [PATCH 03/10] mm: Init zones inside memory regions
Date: Fri, 27 May 2011 18:01:31 +0530
Message-Id: <1306499498-14263-4-git-send-email-ankita@in.ibm.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes zones inside memory regions. Each memory region is
scanned for the pfns present in it. The intersection of the range with that of
a zone is setup as the amount of memory present in the zone in that region.
Most of the other setup related steps continue to be unmodified.

Signed-off-by: Ankita Garg <ankita@in.ibm.com>
---
 include/linux/mm.h |    2 +
 mm/page_alloc.c    |  182 +++++++++++++++++++++++++++++++++-------------------
 2 files changed, 118 insertions(+), 66 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 25299a3..e4e7869 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1360,6 +1360,8 @@ extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
 			unsigned long *start_pfn, unsigned long *end_pfn);
+extern void get_pfn_range_for_region(int nid, int region,
+			unsigned long *start_pfn, unsigned long *end_pfn);
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index af2529d..a21e067 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4000,6 +4000,11 @@ static void __meminit adjust_zone_range_for_zone_movable(int nid,
  * Return the number of pages a zone spans in a node, including holes
  * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
  */
+
+/* This routines needs modifications
+ * Presently have made changes only to routines specific to the default config options
+ * of the panda and exynos boards
+ */
 static unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *ignored)
@@ -4111,6 +4116,37 @@ static unsigned long __meminit zone_absent_pages_in_node(int nid,
 }
 
 #else
+
+void __meminit get_pfn_range_for_region(int nid, int region,
+			unsigned long *start_pfn, unsigned long *end_pfn)
+{
+	mem_region_t *mem_region;
+
+	mem_region = &NODE_DATA(nid)->mem_regions[region];
+	*start_pfn = mem_region->start_pfn;
+	*end_pfn = *start_pfn + mem_region->spanned_pages - 1;
+}
+
+static inline unsigned long __meminit zone_spanned_pages_in_node_region(int nid,
+					int region,
+					unsigned long zone_start_pfn,
+					unsigned long zone_type,
+					unsigned long *zones_size)
+{
+	unsigned long start_pfn, end_pfn;
+	unsigned long zone_end_pfn = zone_start_pfn + zones_size[zone_type] - 1;
+
+	if (!zones_size[zone_type])
+		return 0;
+
+	get_pfn_range_for_region(nid, region, &start_pfn, &end_pfn);
+
+	zone_end_pfn = min(zone_end_pfn, end_pfn);
+	zone_start_pfn = max(start_pfn, zone_start_pfn);
+
+	return zone_end_pfn - zone_start_pfn + 1;	
+}
+
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
 					unsigned long *zones_size)
@@ -4118,14 +4154,22 @@ static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 	return zones_size[zone_type];
 }
 
+/* Returning 0 at this point. It only affects the zone watermarks as the number
+ * of present pages in the zones will be stored incorrectly.
+ * To Do: Compute the pfn ranges of holes in memory and incorporate that info
+ * when finding holes inside each zone
+ */
 static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 						unsigned long zone_type,
 						unsigned long *zholes_size)
 {
+#if 0
 	if (!zholes_size)
 		return 0;
 
 	return zholes_size[zone_type];
+#endif
+	return 0;
 }
 
 #endif
@@ -4237,7 +4281,7 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 	enum zone_type j;
 	int nid = pgdat->node_id;
 	unsigned long zone_start_pfn = pgdat->node_start_pfn;
-	int ret;
+	int ret, i;
 
 	pgdat_resize_init(pgdat);
 	pgdat->nr_zones = 0;
@@ -4246,78 +4290,84 @@ static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 	pgdat_page_cgroup_init(pgdat);
 	
 	for (j = 0; j < MAX_NR_ZONES; j++) {
-		struct zone *zone = pgdat->node_zones + j;
-		unsigned long size, realsize, memmap_pages;
-		enum lru_list l;
-
-		size = zone_spanned_pages_in_node(nid, j, zones_size);
-		realsize = size - zone_absent_pages_in_node(nid, j,
+		for_each_mem_region_in_nid(i, nid) {
+			mem_region_t *mem_region = &pgdat->mem_regions[i];
+			struct zone *zone = mem_region->zones + j;
+			unsigned long size, realsize, memmap_pages;
+			enum lru_list l;
+
+			size = zone_spanned_pages_in_node_region(nid, i, zone_start_pfn, 
+								j, zones_size);
+			realsize = size - zone_absent_pages_in_node(nid, j,
 								zholes_size);
 
-		/*
-		 * Adjust realsize so that it accounts for how much memory
-		 * is used by this zone for memmap. This affects the watermark
-		 * and per-cpu initialisations
-		 */
-		memmap_pages =
-			PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
-		if (realsize >= memmap_pages) {
-			realsize -= memmap_pages;
-			if (memmap_pages)
-				printk(KERN_DEBUG
-				       "  %s zone: %lu pages used for memmap\n",
-				       zone_names[j], memmap_pages);
-		} else
-			printk(KERN_WARNING
-				"  %s zone: %lu pages exceeds realsize %lu\n",
-				zone_names[j], memmap_pages, realsize);
-
-		/* Account for reserved pages */
-		if (j == 0 && realsize > dma_reserve) {
-			realsize -= dma_reserve;
-			printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
-					zone_names[0], dma_reserve);
-		}
+			/*
+			 * Adjust realsize so that it accounts for how much memory
+			 * is used by this zone for memmap. This affects the watermark
+			 * and per-cpu initialisations
+			 */
+			memmap_pages =
+				PAGE_ALIGN(size * sizeof(struct page)) >> PAGE_SHIFT;
+			if (realsize >= memmap_pages) {
+				realsize -= memmap_pages;
+				if (memmap_pages)
+					printk(KERN_DEBUG
+					       "  %s zone: %lu pages used for memmap\n",
+					       zone_names[j], memmap_pages);
+			} else
+				printk(KERN_WARNING
+					"  %s zone: %lu pages exceeds realsize %lu\n",
+					zone_names[j], memmap_pages, realsize);
+
+			/* Account for reserved pages */
+			if (j == 0 && realsize > dma_reserve) {
+				realsize -= dma_reserve;
+				printk(KERN_DEBUG "  %s zone: %lu pages reserved\n",
+						zone_names[0], dma_reserve);
+			}
 
-		if (!is_highmem_idx(j))
-			nr_kernel_pages += realsize;
-		nr_all_pages += realsize;
+			if (!is_highmem_idx(j))
+				nr_kernel_pages += realsize;
+			nr_all_pages += realsize;
 
-		zone->spanned_pages = size;
-		zone->present_pages = realsize;
+			zone->spanned_pages = size;
+			zone->present_pages = realsize;
 #ifdef CONFIG_NUMA
-		zone->node = nid;
-		zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
-						/ 100;
-		zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
+			zone->node = nid;
+			zone->min_unmapped_pages = (realsize*sysctl_min_unmapped_ratio)
+							/ 100;
+			zone->min_slab_pages = (realsize * sysctl_min_slab_ratio) / 100;
 #endif
-		zone->name = zone_names[j];
-		spin_lock_init(&zone->lock);
-		spin_lock_init(&zone->lru_lock);
-		zone_seqlock_init(zone);
-		zone->zone_pgdat = pgdat;
-
-		zone_pcp_init(zone);
-		for_each_lru(l) {
-			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->reclaim_stat.nr_saved_scan[l] = 0;
-		}
-		zone->reclaim_stat.recent_rotated[0] = 0;
-		zone->reclaim_stat.recent_rotated[1] = 0;
-		zone->reclaim_stat.recent_scanned[0] = 0;
-		zone->reclaim_stat.recent_scanned[1] = 0;
-		zap_zone_vm_stats(zone);
-		zone->flags = 0;
-		if (!size)
-			continue;
+			zone->region = i;
+			zone->name = zone_names[j];
+			spin_lock_init(&zone->lock);
+			spin_lock_init(&zone->lru_lock);
+			zone_seqlock_init(zone);
+			zone->zone_pgdat = pgdat;
+			zone->zone_mem_region = mem_region;
+
+			zone_pcp_init(zone);
+			for_each_lru(l) {
+				INIT_LIST_HEAD(&zone->lru[l].list);
+				zone->reclaim_stat.nr_saved_scan[l] = 0;
+			}
+			zone->reclaim_stat.recent_rotated[0] = 0;
+			zone->reclaim_stat.recent_rotated[1] = 0;
+			zone->reclaim_stat.recent_scanned[0] = 0;
+			zone->reclaim_stat.recent_scanned[1] = 0;
+			zap_zone_vm_stats(zone);
+			zone->flags = 0;
+			if (!size)
+				continue;
 
-		set_pageblock_order(pageblock_default_order());
-		setup_usemap(pgdat, zone, size);
-		ret = init_currently_empty_zone(zone, zone_start_pfn,
-						size, MEMMAP_EARLY);
-		BUG_ON(ret);
-		memmap_init(size, nid, j, zone_start_pfn);
-		zone_start_pfn += size;
+			set_pageblock_order(pageblock_default_order());
+			setup_usemap(pgdat, zone, size);
+			ret = init_currently_empty_zone(zone, zone_start_pfn,
+							size, MEMMAP_EARLY);
+			BUG_ON(ret);
+			memmap_init(size, nid, j, zone_start_pfn);
+			zone_start_pfn += size;
+		}
 	}
 }
 
-- 
1.7.4

