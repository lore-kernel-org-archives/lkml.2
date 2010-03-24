Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab0CXKi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:38:26 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:50871 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab0CXKiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:38:14 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/8] x86: remove find_e820_area
Date: Wed, 24 Mar 2010 03:34:19 -0700
Message-Id: <1269426861-20903-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
References: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BA9EB08.0015,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@@kernel.org>

and e820_register_active_region, e820_hole_size

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h     |   17 -----------------
 arch/x86/kernel/acpi/sleep.c    |    2 +-
 arch/x86/kernel/apic/numaq_32.c |    2 +-
 arch/x86/kernel/setup.c         |    6 +++---
 arch/x86/kernel/trampoline.c    |    4 ++--
 arch/x86/mm/init.c              |    2 +-
 arch/x86/mm/init_32.c           |    6 +++---
 arch/x86/mm/init_64.c           |    6 +++---
 arch/x86/mm/k8topology_64.c     |    2 +-
 arch/x86/mm/numa_32.c           |    8 ++++----
 arch/x86/mm/numa_64.c           |   24 ++++++++++++------------
 arch/x86/mm/srat_32.c           |    2 +-
 arch/x86/mm/srat_64.c           |    6 +++---
 13 files changed, 35 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index e957101..9234c78 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -116,23 +116,6 @@ extern unsigned long e820_end_of_low_ram_pfn(void);
 #include <linux/early_res.h>
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
 
-/*
- * next three functions will be removed, esp find_e820_area()
- * can not be used before fill_lmb_memory()
- */
-static inline u64 find_e820_area(u64 start, u64 end, u64 size, u64 align)
-{
-	return find_lmb_area(start, end, size, align);
-}
-static inline void e820_register_active_regions(int nid, unsigned long start_pfn, unsigned long end_pfn)
-{
-	lmb_register_active_regions(nid, start_pfn, end_pfn);
-}
-static inline u64 e820_hole_size(u64 start, u64 end)
-{
-	return lmb_hole_size(start, end);
-}
-
 void init_lmb_memory(void);
 void fill_lmb_memory(void);
 extern void finish_e820_parsing(void);
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index f996103..700a3b7 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -133,7 +133,7 @@ void __init acpi_reserve_wakeup_memory(void)
 		return;
 	}
 
-	mem = find_e820_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
+	mem = find_lmb_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
 
 	if (mem == -1L) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 3e28401..d021cd4 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -88,7 +88,7 @@ static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 	node_end_pfn[node] =
 		 MB_TO_PAGES(eq->hi_shrd_mem_start + eq->hi_shrd_mem_size);
 
-	e820_register_active_regions(node, node_start_pfn[node],
+	lmb_register_active_regions(node, node_start_pfn[node],
 						node_end_pfn[node]);
 
 	memory_present(node, node_start_pfn[node], node_end_pfn[node]);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a9e99e6..b716ea3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -323,7 +323,7 @@ static void __init relocate_initrd(void)
 	char *p, *q;
 
 	/* We need to move the initrd down into lowmem */
-	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
+	ramdisk_here = find_lmb_area(0, end_of_lowmem, ramdisk_size,
 					 PAGE_SIZE);
 
 	if (ramdisk_here == -1ULL)
@@ -517,7 +517,7 @@ static void __init reserve_crashkernel(void)
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = find_e820_area(alignment, ULONG_MAX, crash_size,
+		crash_base = find_lmb_area(alignment, ULONG_MAX, crash_size,
 				 alignment);
 		if (crash_base == -1ULL) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
@@ -526,7 +526,7 @@ static void __init reserve_crashkernel(void)
 	} else {
 		unsigned long long start;
 
-		start = find_e820_area(crash_base, ULONG_MAX, crash_size,
+		start = find_lmb_area(crash_base, ULONG_MAX, crash_size,
 				 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index c652ef6..2276e8b 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -1,7 +1,7 @@
 #include <linux/io.h>
+#include <linux/early_res.h>
 
 #include <asm/trampoline.h>
-#include <asm/e820.h>
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_ACPI_SLEEP)
 #define __trampinit
@@ -19,7 +19,7 @@ void __init reserve_trampoline_memory(void)
 	unsigned long mem;
 
 	/* Has to be in very low memory so we can execute real-mode AP code. */
-	mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
+	mem = find_lmb_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
 	if (mem == -1L)
 		panic("Cannot allocate trampoline\n");
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e71c5cb..7d40e37 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -74,7 +74,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #else
 	start = 0x8000;
 #endif
-	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
+	e820_table_start = find_lmb_area(start, max_pfn_mapped<<PAGE_SHIFT,
 					tables, PAGE_SIZE);
 	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5cb3f0f..a7625d5 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -712,14 +712,14 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	e820_register_active_regions(0, 0, highend_pfn);
+	lmb_register_active_regions(0, 0, highend_pfn);
 	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	e820_register_active_regions(0, 0, max_low_pfn);
+	lmb_register_active_regions(0, 0, max_low_pfn);
 	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
@@ -781,7 +781,7 @@ void __init setup_bootmem_allocator(void)
 	 * Initialize the boot-time allocator (with low memory only):
 	 */
 	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
+	bootmap = find_lmb_area(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index e9b040e..dd88ef9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -576,7 +576,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	unsigned long bootmap_size, bootmap;
 
 	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
-	bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
+	bootmap = find_lmb_area(0, end_pfn<<PAGE_SHIFT, bootmap_size,
 				 PAGE_SIZE);
 	if (bootmap == -1L)
 		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
@@ -584,10 +584,10 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	/* don't touch min_low_pfn */
 	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
 					 0, end_pfn);
-	e820_register_active_regions(0, start_pfn, end_pfn);
+	lmb_register_active_regions(0, start_pfn, end_pfn);
 	free_bootmem_with_active_regions(0, end_pfn);
 #else
-	e820_register_active_regions(0, start_pfn, end_pfn);
+	lmb_register_active_regions(0, start_pfn, end_pfn);
 #endif
 }
 #endif
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 970ed57..1c5b234 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -222,7 +222,7 @@ int __init k8_scan_nodes(void)
 	for_each_node_mask(i, node_possible_map) {
 		int j;
 
-		e820_register_active_regions(i,
+		lmb_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
 		for (j = apicid_base; j < cores + apicid_base; j++)
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 809baaa..8780f4d 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -120,7 +120,7 @@ int __init get_memcfg_numa_flat(void)
 
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
-	e820_register_active_regions(0, 0, max_pfn);
+	lmb_register_active_regions(0, 0, max_pfn);
 	memory_present(0, 0, max_pfn);
 	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
 
@@ -161,7 +161,7 @@ static void __init allocate_pgdat(int nid)
 		NODE_DATA(nid) = (pg_data_t *)node_remap_start_vaddr[nid];
 	else {
 		unsigned long pgdat_phys;
-		pgdat_phys = find_e820_area(min_low_pfn<<PAGE_SHIFT,
+		pgdat_phys = find_lmb_area(min_low_pfn<<PAGE_SHIFT,
 				 max_pfn_mapped<<PAGE_SHIFT,
 				 sizeof(pg_data_t),
 				 PAGE_SIZE);
@@ -291,7 +291,7 @@ static __init unsigned long calculate_numa_remap_pages(void)
 						 PTRS_PER_PTE);
 		node_kva_target <<= PAGE_SHIFT;
 		do {
-			node_kva_final = find_e820_area(node_kva_target,
+			node_kva_final = find_lmb_area(node_kva_target,
 					((u64)node_end_pfn[nid])<<PAGE_SHIFT,
 						((u64)size)<<PAGE_SHIFT,
 						LARGE_PAGE_BYTES);
@@ -367,7 +367,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 
 	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
 	do {
-		kva_start_pfn = find_e820_area(kva_target_pfn<<PAGE_SHIFT,
+		kva_start_pfn = find_lmb_area(kva_target_pfn<<PAGE_SHIFT,
 					max_low_pfn<<PAGE_SHIFT,
 					kva_pages<<PAGE_SHIFT,
 					PTRS_PER_PTE<<PAGE_SHIFT) >> PAGE_SHIFT;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 45ac950..12c1268 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -89,7 +89,7 @@ static int __init allocate_cachealigned_memnodemap(void)
 
 	addr = 0x8000;
 	nodemap_size = roundup(sizeof(s16) * memnodemapsize, L1_CACHE_BYTES);
-	nodemap_addr = find_e820_area(addr, max_pfn<<PAGE_SHIFT,
+	nodemap_addr = find_lmb_area(addr, max_pfn<<PAGE_SHIFT,
 				      nodemap_size, L1_CACHE_BYTES);
 	if (nodemap_addr == -1UL) {
 		printk(KERN_ERR
@@ -248,7 +248,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	 * Find a place for the bootmem map
 	 * nodedata_phys could be on other nodes by alloc_bootmem,
 	 * so need to sure bootmap_start not to be small, otherwise
-	 * early_node_mem will get that with find_e820_area instead
+	 * early_node_mem will get that with find_lmb_area instead
 	 * of alloc_bootmem, that could clash with reserved range
 	 */
 	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
@@ -419,7 +419,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 		nr_nodes = MAX_NUMNODES;
 	}
 
-	size = (max_addr - addr - e820_hole_size(addr, max_addr)) / nr_nodes;
+	size = (max_addr - addr - lmb_hole_size(addr, max_addr)) / nr_nodes;
 	/*
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
@@ -455,7 +455,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 			 * non-reserved memory is less than the per-node size.
 			 */
 			while (end - physnodes[i].start -
-				e820_hole_size(physnodes[i].start, end) < size) {
+				lmb_hole_size(physnodes[i].start, end) < size) {
 				end += FAKE_NODE_MIN_SIZE;
 				if (end > physnodes[i].end) {
 					end = physnodes[i].end;
@@ -469,7 +469,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    e820_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    lmb_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -478,7 +478,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 			 * physical node.
 			 */
 			if (physnodes[i].end - end -
-			    e820_hole_size(end, physnodes[i].end) < size)
+			    lmb_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
 			/*
@@ -506,7 +506,7 @@ static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
 {
 	u64 end = start + size;
 
-	while (end - start - e820_hole_size(start, end) < size) {
+	while (end - start - lmb_hole_size(start, end) < size) {
 		end += FAKE_NODE_MIN_SIZE;
 		if (end > max_addr) {
 			end = max_addr;
@@ -535,7 +535,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 	 * creates a uniform distribution of node sizes across the entire
 	 * machine (but not necessarily over physical nodes).
 	 */
-	min_size = (max_addr - addr - e820_hole_size(addr, max_addr)) /
+	min_size = (max_addr - addr - lmb_hole_size(addr, max_addr)) /
 						MAX_NUMNODES;
 	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
 	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
@@ -568,7 +568,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 			 * this one must extend to the boundary.
 			 */
 			if (end < dma32_end && dma32_end - end -
-			    e820_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+			    lmb_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
 				end = dma32_end;
 
 			/*
@@ -577,7 +577,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 			 * physical node.
 			 */
 			if (physnodes[i].end - end -
-			    e820_hole_size(end, physnodes[i].end) < size)
+			    lmb_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
 			/*
@@ -641,7 +641,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 	 */
 	remove_all_active_ranges();
 	for_each_node_mask(i, node_possible_map) {
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
+		lmb_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
@@ -694,7 +694,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	node_set(0, node_possible_map);
 	for (i = 0; i < nr_cpu_ids; i++)
 		numa_set_node(i, 0);
-	e820_register_active_regions(0, start_pfn, last_pfn);
+	lmb_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
 }
 
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 9324f13..a97c922 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -264,7 +264,7 @@ int __init get_memcfg_from_srat(void)
 		if (node_read_chunk(chunk->nid, chunk))
 			continue;
 
-		e820_register_active_regions(chunk->nid, chunk->start_pfn,
+		lmb_register_active_regions(chunk->nid, chunk->start_pfn,
 					     min(chunk->end_pfn, max_pfn));
 	}
 	/* for out of order entries in SRAT */
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 28c6876..634392d 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -98,7 +98,7 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 	unsigned long phys;
 
 	length = slit->header.length;
-	phys = find_e820_area(0, max_pfn_mapped<<PAGE_SHIFT, length,
+	phys = find_lmb_area(0, max_pfn_mapped<<PAGE_SHIFT, length,
 		 PAGE_SIZE);
 
 	if (phys == -1L)
@@ -324,7 +324,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 			pxmram = 0;
 	}
 
-	e820ram = max_pfn - (e820_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
+	e820ram = max_pfn - (lmb_hole_size(0, max_pfn<<PAGE_SHIFT)>>PAGE_SHIFT);
 	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
 	if ((long)(e820ram - pxmram) >= (1<<(20 - PAGE_SHIFT))) {
 		printk(KERN_ERR
@@ -373,7 +373,7 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	}
 
 	for_each_node_mask(i, nodes_parsed)
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
+		lmb_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
 	/* for out of order entries in SRAT */
 	sort_node_map();
-- 
1.6.4.2

