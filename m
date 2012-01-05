Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2AEPRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:17:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47802 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932527Ab2AEPRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:17:43 -0500
Date: Thu, 5 Jan 2012 16:15:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.3
Message-ID: <20120105151535.GA10472@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus


out-of-topic modifications in x86-mm-for-linus:
-----------------------------------------------
include/linux/mm.h                 # 54c29c6: mm, x86: Remove debug_pagealloc_e
mm/debug-pagealloc.c               # 54c29c6: mm, x86: Remove debug_pagealloc_e

 Thanks,

	Ingo

------------------>
H Hartley Sweeten (1):
      arch/x86/kernel/e820.c: quiet sparse noise about plain integer as NULL pointer

Ludwig Nussel (1):
      x86: Fix mmap random address range

Mike Ditto (1):
      arch/x86/kernel/e820.c: Eliminate bubble sort from sanitize_e820_map()

Pekka Enberg (7):
      x86, mm: Use MAX_DMA_PFN for ZONE_DMA on 32-bit
      x86, mm: Move zone init from paging_init() on 64-bit
      x86, mm: Use max_pfn instead of highend_pfn
      x86, mm: Wrap ZONE_DMA32 with CONFIG_ZONE_DMA32
      x86, mm: Use max_low_pfn for ZONE_NORMAL on 64-bit
      x86, mm: Prepare zone_sizes_init() for unification
      x86, mm: Unify zone_sizes_init()

Petr Holasek (1):
      x86/numa: Add constraints check for nid parameters

Stanislaw Gruszka (2):
      x86/mm: Initialize high mem before free_all_bootmem()
      mm, x86: Remove debug_pagealloc_enabled


 arch/x86/include/asm/init.h |    2 +
 arch/x86/kernel/e820.c      |   59 +++++++++++++++++-------------------------
 arch/x86/mm/init.c          |   23 ++++++++++++++++
 arch/x86/mm/init_32.c       |   29 ++++++++-------------
 arch/x86/mm/init_64.c       |   11 +-------
 arch/x86/mm/mmap.c          |    4 +-
 arch/x86/mm/numa.c          |   10 ++++---
 arch/x86/mm/pageattr.c      |    6 ----
 include/linux/mm.h          |   10 -------
 init/main.c                 |    5 ---
 mm/debug-pagealloc.c        |    3 --
 11 files changed, 69 insertions(+), 93 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 8dbe353..adcc0ae 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -5,6 +5,8 @@
 extern void __init early_ioremap_page_table_range_init(void);
 #endif
 
+extern void __init zone_sizes_init(void);
+
 extern unsigned long __init
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 303a0e4..d6bd853 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -19,6 +19,7 @@
 #include <linux/acpi.h>
 #include <linux/firmware-map.h>
 #include <linux/memblock.h>
+#include <linux/sort.h>
 
 #include <asm/e820.h>
 #include <asm/proto.h>
@@ -227,22 +228,38 @@ void __init e820_print_map(char *who)
  *	   ____________________33__
  *	   ______________________4_
  */
+struct change_member {
+	struct e820entry *pbios; /* pointer to original bios entry */
+	unsigned long long addr; /* address for this change point */
+};
+
+static int __init cpcompare(const void *a, const void *b)
+{
+	struct change_member * const *app = a, * const *bpp = b;
+	const struct change_member *ap = *app, *bp = *bpp;
+
+	/*
+	 * Inputs are pointers to two elements of change_point[].  If their
+	 * addresses are unequal, their difference dominates.  If the addresses
+	 * are equal, then consider one that represents the end of its region
+	 * to be greater than one that does not.
+	 */
+	if (ap->addr != bp->addr)
+		return ap->addr > bp->addr ? 1 : -1;
+
+	return (ap->addr != ap->pbios->addr) - (bp->addr != bp->pbios->addr);
+}
 
 int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
-	struct change_member {
-		struct e820entry *pbios; /* pointer to original bios entry */
-		unsigned long long addr; /* address for this change point */
-	};
 	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
 	static struct change_member *change_point[2*E820_X_MAX] __initdata;
 	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
 	static struct e820entry new_bios[E820_X_MAX] __initdata;
-	struct change_member *change_tmp;
 	unsigned long current_type, last_type;
 	unsigned long long last_addr;
-	int chgidx, still_changing;
+	int chgidx;
 	int overlap_entries;
 	int new_bios_entry;
 	int old_nr, new_nr, chg_nr;
@@ -279,35 +296,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 	chg_nr = chgidx;
 
 	/* sort change-point list by memory addresses (low -> high) */
-	still_changing = 1;
-	while (still_changing)	{
-		still_changing = 0;
-		for (i = 1; i < chg_nr; i++)  {
-			unsigned long long curaddr, lastaddr;
-			unsigned long long curpbaddr, lastpbaddr;
-
-			curaddr = change_point[i]->addr;
-			lastaddr = change_point[i - 1]->addr;
-			curpbaddr = change_point[i]->pbios->addr;
-			lastpbaddr = change_point[i - 1]->pbios->addr;
-
-			/*
-			 * swap entries, when:
-			 *
-			 * curaddr > lastaddr or
-			 * curaddr == lastaddr and curaddr == curpbaddr and
-			 * lastaddr != lastpbaddr
-			 */
-			if (curaddr < lastaddr ||
-			    (curaddr == lastaddr && curaddr == curpbaddr &&
-			     lastaddr != lastpbaddr)) {
-				change_tmp = change_point[i];
-				change_point[i] = change_point[i-1];
-				change_point[i-1] = change_tmp;
-				still_changing = 1;
-			}
-		}
-	}
+	sort(change_point, chg_nr, sizeof *change_point, cpcompare, NULL);
 
 	/* create a new bios memory map, removing overlaps */
 	overlap_entries = 0;	 /* number of entries in the overlap table */
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 87488b9..2426b60 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -3,6 +3,7 @@
 #include <linux/ioport.h>
 #include <linux/swap.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>	/* for max_low_pfn */
 
 #include <asm/cacheflush.h>
 #include <asm/e820.h>
@@ -15,6 +16,7 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/proto.h>
+#include <asm/dma.h>		/* for MAX_DMA_PFN */
 
 unsigned long __initdata pgt_buf_start;
 unsigned long __meminitdata pgt_buf_end;
@@ -392,3 +394,24 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 	free_init_pages("initrd memory", start, PAGE_ALIGN(end));
 }
 #endif
+
+void __init zone_sizes_init(void)
+{
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+
+#ifdef CONFIG_ZONE_DMA
+	max_zone_pfns[ZONE_DMA]		= MAX_DMA_PFN;
+#endif
+#ifdef CONFIG_ZONE_DMA32
+	max_zone_pfns[ZONE_DMA32]	= MAX_DMA32_PFN;
+#endif
+	max_zone_pfns[ZONE_NORMAL]	= max_low_pfn;
+#ifdef CONFIG_HIGHMEM
+	max_zone_pfns[ZONE_HIGHMEM]	= max_pfn;
+#endif
+
+	free_area_init_nodes(max_zone_pfns);
+}
+
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 29f7c6d..a2fecb1 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -674,22 +674,6 @@ void __init initmem_init(void)
 }
 #endif /* !CONFIG_NEED_MULTIPLE_NODES */
 
-static void __init zone_sizes_init(void)
-{
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] =
-		virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-#endif
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	max_zone_pfns[ZONE_HIGHMEM] = highend_pfn;
-#endif
-
-	free_area_init_nodes(max_zone_pfns);
-}
-
 void __init setup_bootmem_allocator(void)
 {
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
@@ -760,6 +744,17 @@ void __init mem_init(void)
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
+	/*
+	 * With CONFIG_DEBUG_PAGEALLOC initialization of highmem pages has to
+	 * be done before free_all_bootmem(). Memblock use free low memory for
+	 * temporary data (see find_range_array()) and for this purpose can use
+	 * pages that was already passed to the buddy allocator, hence marked as
+	 * not accessible in the page tables when compiled with
+	 * CONFIG_DEBUG_PAGEALLOC. Otherwise order of initialization is not
+	 * important here.
+	 */
+	set_highmem_pages_init();
+
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
@@ -771,8 +766,6 @@ void __init mem_init(void)
 		if (page_is_ram(tmp) && PageReserved(pfn_to_page(tmp)))
 			reservedpages++;
 
-	set_highmem_pages_init();
-
 	codesize =  (unsigned long) &_etext - (unsigned long) &_text;
 	datasize =  (unsigned long) &_edata - (unsigned long) &_etext;
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bbaaa00..6fcce7d 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -614,15 +614,6 @@ void __init initmem_init(void)
 
 void __init paging_init(void)
 {
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA
-	max_zone_pfns[ZONE_DMA] = MAX_DMA_PFN;
-#endif
-	max_zone_pfns[ZONE_DMA32] = MAX_DMA32_PFN;
-	max_zone_pfns[ZONE_NORMAL] = max_pfn;
-
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 
@@ -634,7 +625,7 @@ void __init paging_init(void)
 	 */
 	node_clear_state(0, N_NORMAL_MEMORY);
 
-	free_area_init_nodes(max_zone_pfns);
+	zone_sizes_init();
 }
 
 /*
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 4b5ba85..845df68 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -75,9 +75,9 @@ static unsigned long mmap_rnd(void)
 	*/
 	if (current->flags & PF_RANDOMIZE) {
 		if (mmap_is_ia32())
-			rnd = (long)get_random_int() % (1<<8);
+			rnd = get_random_int() % (1<<8);
 		else
-			rnd = (long)(get_random_int() % (1<<28));
+			rnd = get_random_int() % (1<<28);
 	}
 	return rnd << PAGE_SHIFT;
 }
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index fbeaaf4..cdc0054 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -430,8 +430,9 @@ static int __init numa_alloc_distance(void)
  * calls are ignored until the distance table is reset with
  * numa_reset_distance().
  *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
+ * If @from or @to is higher than the highest known node or lower than zero
+ * at the time of table creation or @distance doesn't make sense, the call
+ * is ignored.
  * This is to allow simplification of specific NUMA config implementations.
  */
 void __init numa_set_distance(int from, int to, int distance)
@@ -439,8 +440,9 @@ void __init numa_set_distance(int from, int to, int distance)
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
-		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt ||
+			from < 0 || to < 0) {
+		pr_warn_once("NUMA: Warning: node ids are out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
 		return;
 	}
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f9e5267..5031eef 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1334,12 +1334,6 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	}
 
 	/*
-	 * If page allocator is not up yet then do not call c_p_a():
-	 */
-	if (!debug_pagealloc_enabled)
-		return;
-
-	/*
 	 * The return value is ignored as the calls cannot fail.
 	 * Large pages for identity mappings are not used at boot time
 	 * and hence no memory allocations during large page split.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3dc3a8c..0a22db1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1537,23 +1537,13 @@ static inline void vm_stat_account(struct mm_struct *mm,
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern int debug_pagealloc_enabled;
-
 extern void kernel_map_pages(struct page *page, int numpages, int enable);
-
-static inline void enable_debug_pagealloc(void)
-{
-	debug_pagealloc_enabled = 1;
-}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
 #else
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
-static inline void enable_debug_pagealloc(void)
-{
-}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif /* CONFIG_HIBERNATION */
diff --git a/init/main.c b/init/main.c
index 217ed23..99c4ba3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -282,10 +282,6 @@ static int __init unknown_bootoption(char *param, char *val)
 	return 0;
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-int __read_mostly debug_pagealloc_enabled = 0;
-#endif
-
 static int __init init_setup(char *str)
 {
 	unsigned int i;
@@ -597,7 +593,6 @@ asmlinkage void __init start_kernel(void)
 	}
 #endif
 	page_cgroup_init();
-	enable_debug_pagealloc();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index 7cea557..789ff70 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -95,9 +95,6 @@ static void unpoison_pages(struct page *page, int n)
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled)
-		return;
-
 	if (enable)
 		unpoison_pages(page, numpages);
 	else
