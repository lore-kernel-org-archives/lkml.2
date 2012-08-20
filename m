Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2HTGiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 02:38:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48315 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2HTGiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 02:38:18 -0400
Message-ID: <5031DB52.9030806@gmail.com>
Date: Mon, 20 Aug 2012 14:38:10 +0800
From: wujianguo <wujianguo106@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: tony.luck@intel.com, fenghua.yu@intel.com, dhowells@redhat.com,
        tj@kernel.org, mgorman@suse.de, yinghai@kernel.org,
        minchan.kim@gmail.com
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, aarcange@redhat.com,
        davem@davemloft.net, hannes@cmpxchg.org, liuj97@gmail.com,
        wency@cn.fujitsu.com, rientjes@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ptesarik@suse.cz, jiang.liu@huawei.com,
        guohanjun@huawei.com, qiuxishi@huawei.com
Subject: [PATCH]mm: fix-up zone present pages
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianguo Wu <wujianguo@huawei.com>

Hi all,
	I think zone->present_pages indicates pages that buddy system can management,
it should be:
	zone->present_pages = spanned pages - absent pages - bootmem pages,
but now:
	zone->present_pages = spanned pages - absent pages - memmap pages.
spanned pages：total size, including holes.
absent pages: holes.
bootmem pages: pages used in system boot, managed by bootmem allocator.
memmap pages: pages used by page structs.

This may cause zone->present_pages less than it should be.
For example, numa node 1 has ZONE_NORMAL and ZONE_MOVABLE,
it's memmap and other bootmem will be allocated from ZONE_MOVABLE,
so ZONE_NORMAL's present_pages should be spanned pages - absent pages,
but now it also minus memmap pages(free_area_init_core), which are actually allocated
from ZONE_MOVABLE. When offline all memory of a zone, This will cause zone->present_pages
less than 0, because present_pages is unsigned long type, it is actually
a very large integer, it indirectly caused zone->watermark[WMARK_MIN]
become a large integer(setup_per_zone_wmarks()), than cause totalreserve_pages
become a large integer(calculate_totalreserve_pages()), and finally cause memory
allocating failure when fork process(__vm_enough_memory()).

[root@localhost ~]# dmesg
-bash: fork: Cannot allocate memory

I think bug described in http://marc.info/?l=linux-mm&m=134502182714186&w=2 is also
caused by wrong zone present pages.

This patch intends to fix-up zone->present_pages when memory are freed to
buddy system in x86_64 and IA64 platform.

Thanks.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/ia64/mm/init.c |    1 +
 include/linux/mm.h  |    4 ++++
 mm/bootmem.c        |    9 ++++++++-
 mm/memory_hotplug.c |    7 +++++++
 mm/nobootmem.c      |    3 +++
 mm/page_alloc.c     |   34 ++++++++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index b960ba0..c78e3fd 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -640,6 +640,7 @@ mem_init (void)
 	free_floating_node_bootmem();
 #endif

+	reset_zone_present_pages();
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 311be90..a1bd8ea 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1662,5 +1662,9 @@ static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */

+extern void reset_zone_present_pages(void);
+extern void fixup_zone_present_pages(int nid, unsigned long start_pfn,
+				unsigned long end_pfn);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/bootmem.c b/mm/bootmem.c
index bcb63ac..e00b491 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -198,6 +198,8 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 			int order = ilog2(BITS_PER_LONG);

 			__free_pages_bootmem(pfn_to_page(start), order);
+			fixup_zone_present_pages(page_to_nid(pfn_to_page(start)),
+					start, start + BITS_PER_LONG);
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
@@ -208,6 +210,8 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 				if (vec & 1) {
 					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
+					fixup_zone_present_pages(page_to_nid(page),
+							start + off, start + off + 1);
 					count++;
 				}
 				vec >>= 1;
@@ -221,8 +225,11 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 	pages = bdata->node_low_pfn - bdata->node_min_pfn;
 	pages = bootmem_bootmap_pages(pages);
 	count += pages;
-	while (pages--)
+	while (pages--) {
+		fixup_zone_present_pages(page_to_nid(page),
+				page_to_pfn(page), page_to_pfn(page) + 1);
 		__free_pages_bootmem(page++, 0);
+	}

 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 3ad25f9..bc7e7a2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -106,6 +106,7 @@ static void get_page_bootmem(unsigned long info,  struct page *page,
 void __ref put_page_bootmem(struct page *page)
 {
 	unsigned long type;
+	struct zone *zone;

 	type = (unsigned long) page->lru.next;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
@@ -116,6 +117,12 @@ void __ref put_page_bootmem(struct page *page)
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
 		__free_pages_bootmem(page, 0);
+
+		zone = page_zone(page);
+		zone_span_writelock(zone);
+		zone->present_pages++;
+		zone_span_writeunlock(zone);
+		totalram_pages++;
 	}

 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 4055730..8027861 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -116,6 +116,8 @@ static unsigned long __init __free_memory_core(phys_addr_t start,
 		return 0;

 	__free_pages_memory(start_pfn, end_pfn);
+	fixup_zone_present_pages(pfn_to_nid(start >> PAGE_SHIFT),
+			start_pfn, end_pfn);

 	return end_pfn - start_pfn;
 }
@@ -126,6 +128,7 @@ unsigned long __init free_low_memory_core_early(int nodeid)
 	phys_addr_t start, end, size;
 	u64 i;

+	reset_zone_present_pages();
 	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
 		count += __free_memory_core(start, end);

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fcb0932..36c35bb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6074,3 +6074,37 @@ void dump_page(struct page *page)
 	dump_page_flags(page->flags);
 	mem_cgroup_print_bad_page(page);
 }
+
+/* reset zone->present_pages */
+void reset_zone_present_pages(void)
+{
+	struct zone *z;
+	int i, nid;
+
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			z = NODE_DATA(nid)->node_zones + i;
+			z->present_pages = 0;
+		}
+	}
+}
+
+/* calculate zone's present pages in buddy system */
+void fixup_zone_present_pages(int nid, unsigned long start_pfn,
+				unsigned long end_pfn)
+{
+	struct zone *z;
+	unsigned long zone_start_pfn, zone_end_pfn;
+	int i;
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		z = NODE_DATA(nid)->node_zones + i;
+		zone_start_pfn = z->zone_start_pfn;
+		zone_end_pfn = zone_start_pfn + z->spanned_pages;
+
+		/* if the two regions intersect */
+		if (!(zone_start_pfn >= end_pfn	|| zone_end_pfn <= start_pfn))
+			z->present_pages += min(end_pfn, zone_end_pfn) -
+								max(start_pfn, zone_start_pfn);
+	}
+}
-- 
1.7.6.1



.
