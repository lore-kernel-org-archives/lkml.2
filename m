Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab0ENAbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:31:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52564 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab0ENAXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:23:40 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 22/35] bootmem: Add nobootmem.c to reduce the #ifdef
Date: Thu, 13 May 2010 17:19:43 -0700
Message-Id: <1273796396-29649-23-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090209.4BEC97B5.011A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce nobootmem.c to hold wrapper for CONFIG_NO_BOOTMEM=y.

that will remove related #ifdef in bootmem.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/Makefile    |    8 +-
 mm/bootmem.c   |  151 +----------------------
 mm/nobootmem.c |  389 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 397 insertions(+), 151 deletions(-)
 create mode 100644 mm/nobootmem.c

diff --git a/mm/Makefile b/mm/Makefile
index 6c2a73a..08c58d5 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -7,12 +7,18 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
 			   vmalloc.o pagewalk.o
 
-obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
+obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o \
 			   $(mmu-y)
+ifdef CONFIG_NO_BOOTMEM
+	obj-y		+= nobootmem.o
+else
+	obj-y		+= bootmem.o
+endif
+
 obj-y += init-mm.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
diff --git a/mm/bootmem.c b/mm/bootmem.c
index 2a4c8b5..2741c34 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -35,7 +35,6 @@ unsigned long max_pfn;
 unsigned long saved_max_pfn;
 #endif
 
-#ifndef CONFIG_NO_BOOTMEM
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
 static struct list_head bdata_list __initdata = LIST_HEAD_INIT(bdata_list);
@@ -146,7 +145,7 @@ unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 	min_low_pfn = start;
 	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
-#endif
+
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
  * @addr: starting address of the range
@@ -171,53 +170,6 @@ void __init free_bootmem_late(unsigned long addr, unsigned long size)
 	}
 }
 
-#ifdef CONFIG_NO_BOOTMEM
-static void __init __free_pages_memory(unsigned long start, unsigned long end)
-{
-	int i;
-	unsigned long start_aligned, end_aligned;
-	int order = ilog2(BITS_PER_LONG);
-
-	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
-	end_aligned = end & ~(BITS_PER_LONG - 1);
-
-	if (end_aligned <= start_aligned) {
-		for (i = start; i < end; i++)
-			__free_pages_bootmem(pfn_to_page(i), 0);
-
-		return;
-	}
-
-	for (i = start; i < start_aligned; i++)
-		__free_pages_bootmem(pfn_to_page(i), 0);
-
-	for (i = start_aligned; i < end_aligned; i += BITS_PER_LONG)
-		__free_pages_bootmem(pfn_to_page(i), order);
-
-	for (i = end_aligned; i < end; i++)
-		__free_pages_bootmem(pfn_to_page(i), 0);
-}
-
-unsigned long __init free_all_memory_core_early(int nodeid)
-{
-	int i;
-	u64 start, end;
-	unsigned long count = 0;
-	struct range *range = NULL;
-	int nr_range;
-
-	nr_range = get_free_all_memory_range(&range, nodeid);
-
-	for (i = 0; i < nr_range; i++) {
-		start = range[i].start;
-		end = range[i].end;
-		count += end - start;
-		__free_pages_memory(start, end);
-	}
-
-	return count;
-}
-#else
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	int aligned;
@@ -278,7 +230,6 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 
 	return count;
 }
-#endif
 
 /**
  * free_all_bootmem_node - release a node's free pages to the buddy allocator
@@ -289,12 +240,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
-#ifdef CONFIG_NO_BOOTMEM
-	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
-	return 0;
-#else
 	return free_all_bootmem_core(pgdat->bdata);
-#endif
 }
 
 /**
@@ -304,16 +250,6 @@ unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
  */
 unsigned long __init free_all_bootmem(void)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	/*
-	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
-	 *  because in some case like Node0 doesnt have RAM installed
-	 *  low ram will be on Node1
-	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
-	 *  will be used instead of only Node0 related
-	 */
-	return free_all_memory_core_early(MAX_NUMNODES);
-#else
 	unsigned long total_pages = 0;
 	bootmem_data_t *bdata;
 
@@ -321,10 +257,8 @@ unsigned long __init free_all_bootmem(void)
 		total_pages += free_all_bootmem_core(bdata);
 
 	return total_pages;
-#endif
 }
 
-#ifndef CONFIG_NO_BOOTMEM
 static void __init __free(bootmem_data_t *bdata,
 			unsigned long sidx, unsigned long eidx)
 {
@@ -419,7 +353,6 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 	}
 	BUG();
 }
-#endif
 
 /**
  * free_bootmem_node - mark a page range as usable
@@ -434,9 +367,6 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 			      unsigned long size)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	lmb_free_area(physaddr, physaddr + size);
-#else
 	unsigned long start, end;
 
 	kmemleak_free_part(__va(physaddr), size);
@@ -445,7 +375,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 	end = PFN_DOWN(physaddr + size);
 
 	mark_bootmem_node(pgdat->bdata, start, end, 0, 0);
-#endif
 }
 
 /**
@@ -459,9 +388,6 @@ void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
  */
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	lmb_free_area(addr, addr + size);
-#else
 	unsigned long start, end;
 
 	kmemleak_free_part(__va(addr), size);
@@ -470,7 +396,6 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 	end = PFN_DOWN(addr + size);
 
 	mark_bootmem(start, end, 0, 0);
-#endif
 }
 
 /**
@@ -487,17 +412,12 @@ void __init free_bootmem(unsigned long addr, unsigned long size)
 int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	panic("no bootmem");
-	return 0;
-#else
 	unsigned long start, end;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
-#endif
 }
 
 /**
@@ -513,20 +433,14 @@ int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	panic("no bootmem");
-	return 0;
-#else
 	unsigned long start, end;
 
 	start = PFN_DOWN(addr);
 	end = PFN_UP(addr + size);
 
 	return mark_bootmem(start, end, 1, flags);
-#endif
 }
 
-#ifndef CONFIG_NO_BOOTMEM
 int __weak __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
 				   int flags)
 {
@@ -683,33 +597,12 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
 #endif
 	return NULL;
 }
-#endif
 
 static void * __init ___alloc_bootmem_nopanic(unsigned long size,
 					unsigned long align,
 					unsigned long goal,
 					unsigned long limit)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	void *ptr;
-
-	if (WARN_ON_ONCE(slab_is_available()))
-		return kzalloc(size, GFP_NOWAIT);
-
-restart:
-
-	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align, goal, limit);
-
-	if (ptr)
-		return ptr;
-
-	if (goal != 0) {
-		goal = 0;
-		goto restart;
-	}
-
-	return NULL;
-#else
 	bootmem_data_t *bdata;
 	void *region;
 
@@ -735,7 +628,6 @@ restart:
 	}
 
 	return NULL;
-#endif
 }
 
 /**
@@ -756,10 +648,6 @@ void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
 {
 	unsigned long limit = 0;
 
-#ifdef CONFIG_NO_BOOTMEM
-	limit = -1UL;
-#endif
-
 	return ___alloc_bootmem_nopanic(size, align, goal, limit);
 }
 
@@ -796,14 +684,9 @@ void * __init __alloc_bootmem(unsigned long size, unsigned long align,
 {
 	unsigned long limit = 0;
 
-#ifdef CONFIG_NO_BOOTMEM
-	limit = -1UL;
-#endif
-
 	return ___alloc_bootmem(size, align, goal, limit);
 }
 
-#ifndef CONFIG_NO_BOOTMEM
 static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 				unsigned long size, unsigned long align,
 				unsigned long goal, unsigned long limit)
@@ -820,7 +703,6 @@ static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
 
 	return ___alloc_bootmem(size, align, goal, limit);
 }
-#endif
 
 /**
  * __alloc_bootmem_node - allocate boot memory from a specific node
@@ -843,12 +725,7 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-#ifdef CONFIG_NO_BOOTMEM
-	return __alloc_memory_core_early(pgdat->node_id, size, align,
-					 goal, -1ULL);
-#else
 	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
-#endif
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -869,13 +746,8 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 		unsigned long new_goal;
 
 		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
-#ifdef CONFIG_NO_BOOTMEM
-		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 new_goal, -1ULL);
-#else
 		ptr = alloc_bootmem_core(pgdat->bdata, size, align,
 						 new_goal, 0);
-#endif
 		if (ptr)
 			return ptr;
 	}
@@ -896,16 +768,6 @@ void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
-#ifdef CONFIG_NO_BOOTMEM
-	unsigned long pfn, goal, limit;
-
-	pfn = section_nr_to_pfn(section_nr);
-	goal = pfn << PAGE_SHIFT;
-	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
-
-	return __alloc_memory_core_early(early_pfn_to_nid(pfn), size,
-					 SMP_CACHE_BYTES, goal, limit);
-#else
 	bootmem_data_t *bdata;
 	unsigned long pfn, goal, limit;
 
@@ -915,7 +777,6 @@ void * __init alloc_bootmem_section(unsigned long size,
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
 	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
-#endif
 }
 #endif
 
@@ -927,16 +788,11 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-#ifdef CONFIG_NO_BOOTMEM
-	ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
-						 goal, -1ULL);
-#else
 	ptr = alloc_arch_preferred_bootmem(pgdat->bdata, size, align, goal, 0);
 	if (ptr)
 		return ptr;
 
 	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
-#endif
 	if (ptr)
 		return ptr;
 
@@ -987,11 +843,6 @@ void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
-#ifdef CONFIG_NO_BOOTMEM
-	return __alloc_memory_core_early(pgdat->node_id, size, align,
-				goal, ARCH_LOW_ADDRESS_LIMIT);
-#else
 	return ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
-#endif
 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
new file mode 100644
index 0000000..283673e
--- /dev/null
+++ b/mm/nobootmem.c
@@ -0,0 +1,389 @@
+/*
+ *  bootmem - A boot-time physical memory allocator and configurator
+ *
+ *  Copyright (C) 1999 Ingo Molnar
+ *                1999 Kanoj Sarcar, SGI
+ *                2008 Johannes Weiner
+ *
+ * Access to this subsystem has to be serialized externally (which is true
+ * for the boot process anyway).
+ */
+#include <linux/init.h>
+#include <linux/pfn.h>
+#include <linux/slab.h>
+#include <linux/bootmem.h>
+#include <linux/module.h>
+#include <linux/kmemleak.h>
+#include <linux/range.h>
+#include <linux/lmb.h>
+
+#include <asm/bug.h>
+#include <asm/io.h>
+#include <asm/processor.h>
+
+#include "internal.h"
+
+unsigned long max_low_pfn;
+unsigned long min_low_pfn;
+unsigned long max_pfn;
+
+#ifdef CONFIG_CRASH_DUMP
+/*
+ * If we have booted due to a crash, max_pfn will be a very low value. We need
+ * to know the amount of memory that the previous kernel used.
+ */
+unsigned long saved_max_pfn;
+#endif
+
+/*
+ * free_bootmem_late - free bootmem pages directly to page allocator
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are given directly
+ * to the page allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init free_bootmem_late(unsigned long addr, unsigned long size)
+{
+	unsigned long cursor, end;
+
+	kmemleak_free_part(__va(addr), size);
+
+	cursor = PFN_UP(addr);
+	end = PFN_DOWN(addr + size);
+
+	for (; cursor < end; cursor++) {
+		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		totalram_pages++;
+	}
+}
+
+static void __init __free_pages_memory(unsigned long start, unsigned long end)
+{
+	int i;
+	unsigned long start_aligned, end_aligned;
+	int order = ilog2(BITS_PER_LONG);
+
+	start_aligned = (start + (BITS_PER_LONG - 1)) & ~(BITS_PER_LONG - 1);
+	end_aligned = end & ~(BITS_PER_LONG - 1);
+
+	if (end_aligned <= start_aligned) {
+		for (i = start; i < end; i++)
+			__free_pages_bootmem(pfn_to_page(i), 0);
+
+		return;
+	}
+
+	for (i = start; i < start_aligned; i++)
+		__free_pages_bootmem(pfn_to_page(i), 0);
+
+	for (i = start_aligned; i < end_aligned; i += BITS_PER_LONG)
+		__free_pages_bootmem(pfn_to_page(i), order);
+
+	for (i = end_aligned; i < end; i++)
+		__free_pages_bootmem(pfn_to_page(i), 0);
+}
+
+unsigned long __init free_all_memory_core_early(int nodeid)
+{
+	int i;
+	u64 start, end;
+	unsigned long count = 0;
+	struct range *range = NULL;
+	int nr_range;
+
+	nr_range = get_free_all_memory_range(&range, nodeid);
+
+	for (i = 0; i < nr_range; i++) {
+		start = range[i].start;
+		end = range[i].end;
+		count += end - start;
+		__free_pages_memory(start, end);
+	}
+
+	return count;
+}
+
+/**
+ * free_all_bootmem_node - release a node's free pages to the buddy allocator
+ * @pgdat: node to be released
+ *
+ * Returns the number of pages actually released.
+ */
+unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
+{
+	register_page_bootmem_info_node(pgdat);
+
+	/* free_all_memory_core_early(MAX_NUMNODES) will be called later */
+	return 0;
+}
+
+/**
+ * free_all_bootmem - release free pages to the buddy allocator
+ *
+ * Returns the number of pages actually released.
+ */
+unsigned long __init free_all_bootmem(void)
+{
+	/*
+	 * We need to use MAX_NUMNODES instead of NODE_DATA(0)->node_id
+	 *  because in some case like Node0 doesnt have RAM installed
+	 *  low ram will be on Node1
+	 * Use MAX_NUMNODES will make sure all ranges in early_node_map[]
+	 *  will be used instead of only Node0 related
+	 */
+	return free_all_memory_core_early(MAX_NUMNODES);
+}
+
+/**
+ * free_bootmem_node - mark a page range as usable
+ * @pgdat: node the range resides on
+ * @physaddr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * Partial pages will be considered reserved and left as they are.
+ *
+ * The range must reside completely on the specified node.
+ */
+void __init free_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
+			      unsigned long size)
+{
+	lmb_free_area(physaddr, physaddr + size);
+}
+
+/**
+ * free_bootmem - mark a page range as usable
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * Partial pages will be considered reserved and left as they are.
+ *
+ * The range must be contiguous but may span node boundaries.
+ */
+void __init free_bootmem(unsigned long addr, unsigned long size)
+{
+	lmb_free_area(addr, addr + size);
+}
+
+static void * __init ___alloc_bootmem_nopanic(unsigned long size,
+					unsigned long align,
+					unsigned long goal,
+					unsigned long limit)
+{
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc(size, GFP_NOWAIT);
+
+restart:
+
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align, goal, limit);
+
+	if (ptr)
+		return ptr;
+
+	if (goal != 0) {
+		goal = 0;
+		goto restart;
+	}
+
+	return NULL;
+}
+
+/**
+ * __alloc_bootmem_nopanic - allocate boot memory without panicking
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * Returns NULL on failure.
+ */
+void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
+					unsigned long goal)
+{
+	unsigned long limit = -1UL;
+
+	return ___alloc_bootmem_nopanic(size, align, goal, limit);
+}
+
+static void * __init ___alloc_bootmem(unsigned long size, unsigned long align,
+					unsigned long goal, unsigned long limit)
+{
+	void *mem = ___alloc_bootmem_nopanic(size, align, goal, limit);
+
+	if (mem)
+		return mem;
+	/*
+	 * Whoops, we cannot satisfy the allocation request.
+	 */
+	printk(KERN_ALERT "bootmem alloc of %lu bytes failed!\n", size);
+	panic("Out of memory");
+	return NULL;
+}
+
+/**
+ * __alloc_bootmem - allocate boot memory
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem(unsigned long size, unsigned long align,
+			      unsigned long goal)
+{
+	unsigned long limit = -1UL;
+
+	return ___alloc_bootmem(size, align, goal, limit);
+}
+
+/**
+ * __alloc_bootmem_node - allocate boot memory from a specific node
+ * @pgdat: node to allocate from
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may fall back to any node in the system if the specified node
+ * can not hold the requested memory.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	return __alloc_memory_core_early(pgdat->node_id, size, align,
+					 goal, -1ULL);
+}
+
+void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+#ifdef MAX_DMA32_PFN
+	unsigned long end_pfn;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	/* update goal according ...MAX_DMA32_PFN */
+	end_pfn = pgdat->node_start_pfn + pgdat->node_spanned_pages;
+
+	if (end_pfn > MAX_DMA32_PFN + (128 >> (20 - PAGE_SHIFT)) &&
+	    (goal >> PAGE_SHIFT) < MAX_DMA32_PFN) {
+		void *ptr;
+		unsigned long new_goal;
+
+		new_goal = MAX_DMA32_PFN << PAGE_SHIFT;
+		ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
+						 new_goal, -1ULL);
+		if (ptr)
+			return ptr;
+	}
+#endif
+
+	return __alloc_bootmem_node(pgdat, size, align, goal);
+
+}
+
+#ifdef CONFIG_SPARSEMEM
+/**
+ * alloc_bootmem_section - allocate boot memory from a specific section
+ * @size: size of the request in bytes
+ * @section_nr: sparse map section to allocate from
+ *
+ * Return NULL on failure.
+ */
+void * __init alloc_bootmem_section(unsigned long size,
+				    unsigned long section_nr)
+{
+	unsigned long pfn, goal, limit;
+
+	pfn = section_nr_to_pfn(section_nr);
+	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+
+	return __alloc_memory_core_early(early_pfn_to_nid(pfn), size,
+					 SMP_CACHE_BYTES, goal, limit);
+}
+#endif
+
+void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
+				   unsigned long align, unsigned long goal)
+{
+	void *ptr;
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	ptr =  __alloc_memory_core_early(pgdat->node_id, size, align,
+						 goal, -1ULL);
+	if (ptr)
+		return ptr;
+
+	return __alloc_bootmem_nopanic(size, align, goal);
+}
+
+#ifndef ARCH_LOW_ADDRESS_LIMIT
+#define ARCH_LOW_ADDRESS_LIMIT	0xffffffffUL
+#endif
+
+/**
+ * __alloc_bootmem_low - allocate low boot memory
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may happen on any node in the system.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
+				  unsigned long goal)
+{
+	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
+}
+
+/**
+ * __alloc_bootmem_low_node - allocate low boot memory from a specific node
+ * @pgdat: node to allocate from
+ * @size: size of the request in bytes
+ * @align: alignment of the region
+ * @goal: preferred starting address of the region
+ *
+ * The goal is dropped if it can not be satisfied and the allocation will
+ * fall back to memory below @goal.
+ *
+ * Allocation may fall back to any node in the system if the specified node
+ * can not hold the requested memory.
+ *
+ * The function panics if the request can not be satisfied.
+ */
+void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
+				       unsigned long align, unsigned long goal)
+{
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
+
+	return __alloc_memory_core_early(pgdat->node_id, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+}
-- 
1.6.4.2

