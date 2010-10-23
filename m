Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab0JWMtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 08:49:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35927 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab0JWMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 08:49:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kFFFnSlO+56asL+6uZzhDcVdUt4lWr+/7vWCYpKhg7JClYPWuurLFs53nE5PBxORhz
         0pVsYoC8erTex1TV7xmtkhrgEof0S/veng1IF62dMIyMzHo/a/926I+gF3WCf3FrD7R1
         zjTAgGG6noOVDCtZ4dWxITkWKYzopvEpwwI9s=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH] arm: mm: use memblock for memory init
Date: Sat, 23 Oct 2010 15:49:39 +0300
Message-Id: <1287838179-8872-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.3.2.2.g0dc5c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

The advantage with this is that memblock is now used as the basis for
determining where memory is, setting up the maps, freeing memory into
the pools, etc.

This allows code in ->reserve callback to remove some chunks of memory
from the normal kernel managed memory:

	size = min(size, SZ_2M);
	base = memblock_alloc(size, min(align, SZ_2M));
	memblock_free(base, size);
	memblock_remove(base, size);

This allows drivers to issue ioremap() calls and avoid the memory to
have multiple mappings.

Ported by Felipe Contreras, comments by Catalin Marinas.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 arch/arm/mm/init.c |  129 +++++++++++++++++++++++++++++++++++++--------------
 arch/arm/mm/mmu.c  |   45 ++++++++++--------
 2 files changed, 119 insertions(+), 55 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 63f4417..e3a2fb0 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -121,9 +121,10 @@ void show_mem(void)
 	printk("%d pages swap cached\n", cached);
 }
 
-static void __init find_limits(struct meminfo *mi,
-	unsigned long *min, unsigned long *max_low, unsigned long *max_high)
+static void __init find_limits(unsigned long *min, unsigned long *max_low,
+	unsigned long *max_high)
 {
+	struct meminfo *mi = &meminfo;
 	int i;
 
 	*min = -1UL;
@@ -147,14 +148,13 @@ static void __init find_limits(struct meminfo *mi,
 	}
 }
 
-static void __init arm_bootmem_init(struct meminfo *mi,
-	unsigned long start_pfn, unsigned long end_pfn)
+static void __init arm_bootmem_init(unsigned long start_pfn,
+	unsigned long end_pfn)
 {
 	struct memblock_region *reg;
 	unsigned int boot_pages;
 	phys_addr_t bitmap;
 	pg_data_t *pgdat;
-	int i;
 
 	/*
 	 * Allocate the bootmem bitmap page.  This must be in a region
@@ -172,18 +172,25 @@ static void __init arm_bootmem_init(struct meminfo *mi,
 	pgdat = NODE_DATA(0);
 	init_bootmem_node(pgdat, __phys_to_pfn(bitmap), start_pfn, end_pfn);
 
-	for_each_bank(i, mi) {
-		struct membank *bank = &mi->bank[i];
-		if (!bank->highmem)
-			free_bootmem(bank_phys_start(bank), bank_phys_size(bank));
+	/* Free the lowmem regions from memblock into bootmem. */
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);
+
+		if (end >= end_pfn)
+			end = end_pfn;
+		if (start >= end)
+			break;
+
+		free_bootmem(__pfn_to_phys(start), (end - start) << PAGE_SHIFT);
 	}
 
 	/*
 	 * Reserve the memblock reserved regions in bootmem.
 	 */
 	for_each_memblock(reserved, reg) {
-		phys_addr_t start = memblock_region_reserved_base_pfn(reg);
-		phys_addr_t end = memblock_region_reserved_end_pfn(reg);
+		unsigned long start = memblock_region_reserved_base_pfn(reg);
+		unsigned long end = memblock_region_reserved_end_pfn(reg);
 		if (start >= start_pfn && end <= end_pfn)
 			reserve_bootmem_node(pgdat, __pfn_to_phys(start),
 					     (end - start) << PAGE_SHIFT,
@@ -191,11 +198,11 @@ static void __init arm_bootmem_init(struct meminfo *mi,
 	}
 }
 
-static void __init arm_bootmem_free(struct meminfo *mi, unsigned long min,
-	unsigned long max_low, unsigned long max_high)
+static void __init arm_bootmem_free(unsigned long min, unsigned long max_low,
+	unsigned long max_high)
 {
 	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
-	int i;
+	struct memblock_region *reg;
 
 	/*
 	 * initialise the zones.
@@ -217,13 +224,21 @@ static void __init arm_bootmem_free(struct meminfo *mi, unsigned long min,
 	 *  holes = node_size - sum(bank_sizes)
 	 */
 	memcpy(zhole_size, zone_size, sizeof(zhole_size));
-	for_each_bank(i, mi) {
-		int idx = 0;
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);
+
+		if (start < max_low) {
+			unsigned long low_end = min(end, max_low);
+			zhole_size[0] -= low_end - start;
+		}
+
 #ifdef CONFIG_HIGHMEM
-		if (mi->bank[i].highmem)
-			idx = ZONE_HIGHMEM;
+		if (end > max_low) {
+			unsigned long high_start = max(start, max_low);
+			zhole_size[ZONE_HIGHMEM] -= end - high_start;
+		}
 #endif
-		zhole_size[idx] -= bank_pfn_size(&mi->bank[i]);
 	}
 
 	/*
@@ -292,14 +307,13 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 
 void __init bootmem_init(void)
 {
-	struct meminfo *mi = &meminfo;
 	unsigned long min, max_low, max_high;
 
 	max_low = max_high = 0;
 
-	find_limits(mi, &min, &max_low, &max_high);
+	find_limits(&min, &max_low, &max_high);
 
-	arm_bootmem_init(mi, min, max_low);
+	arm_bootmem_init(min, max_low);
 
 	/*
 	 * Sparsemem tries to allocate bootmem in memory_present(),
@@ -317,7 +331,7 @@ void __init bootmem_init(void)
 	 * the sparse mem_map arrays initialized by sparse_init()
 	 * for memmap_init_zone(), otherwise all PFNs are invalid.
 	 */
-	arm_bootmem_free(mi, min, max_low, max_high);
+	arm_bootmem_free(min, max_low, max_high);
 
 	high_memory = __va((max_low << PAGE_SHIFT) - 1) + 1;
 
@@ -411,6 +425,56 @@ static void __init free_unused_memmap(struct meminfo *mi)
 	}
 }
 
+static void __init free_highpages(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long max_low = max_low_pfn + PHYS_PFN_OFFSET;
+	struct memblock_region *mem_reg, *res_reg;
+
+	/* set highmem page free */
+	for_each_memblock(memory, mem_reg) {
+		unsigned long start = memblock_region_memory_base_pfn(mem_reg);
+		unsigned long end = memblock_region_memory_end_pfn(mem_reg);
+
+		/* Ignore complete lowmem entries */
+		if (end <= max_low)
+			continue;
+
+		/* Truncate partial highmem entries */
+		if (start < max_low)
+			start = max_low;
+
+		/* Find and exclude any reserved regions */
+		for_each_memblock(reserved, res_reg) {
+			unsigned long res_start =
+				memblock_region_reserved_base_pfn(res_reg);
+			unsigned long res_end =
+				memblock_region_reserved_end_pfn(res_reg);
+
+			if (res_end < start)
+				continue;
+			if (res_start < start)
+				res_start = start;
+			if (res_start > end)
+				res_start = end;
+			if (res_end > end)
+				res_end = end;
+			if (res_start != start)
+				totalhigh_pages += free_area(start, res_start,
+							     NULL);
+			start = res_end;
+			if (start == end)
+				break;
+		}
+
+		/* And now free anything which remains */
+		if (start < end)
+			totalhigh_pages += free_area(start, end, NULL);
+	}
+	totalram_pages += totalhigh_pages;
+#endif
+}
+
 /*
  * mem_init() marks the free areas in the mem_map and tells us how much
  * memory is free.  This is done after various parts of the system have
@@ -419,6 +483,7 @@ static void __init free_unused_memmap(struct meminfo *mi)
 void __init mem_init(void)
 {
 	unsigned long reserved_pages, free_pages;
+	struct memblock_region *reg;
 	int i;
 #ifdef CONFIG_HAVE_TCM
 	/* These pointers are filled in on TCM detection */
@@ -439,16 +504,7 @@ void __init mem_init(void)
 				    __phys_to_pfn(__pa(swapper_pg_dir)), NULL);
 #endif
 
-#ifdef CONFIG_HIGHMEM
-	/* set highmem page free */
-	for_each_bank (i, &meminfo) {
-		unsigned long start = bank_pfn_start(&meminfo.bank[i]);
-		unsigned long end = bank_pfn_end(&meminfo.bank[i]);
-		if (start >= max_low_pfn + PHYS_PFN_OFFSET)
-			totalhigh_pages += free_area(start, end, NULL);
-	}
-	totalram_pages += totalhigh_pages;
-#endif
+	free_highpages();
 
 	reserved_pages = free_pages = 0;
 
@@ -478,9 +534,10 @@ void __init mem_init(void)
 	 */
 	printk(KERN_INFO "Memory:");
 	num_physpages = 0;
-	for (i = 0; i < meminfo.nr_banks; i++) {
-		num_physpages += bank_pfn_size(&meminfo.bank[i]);
-		printk(" %ldMB", bank_phys_size(&meminfo.bank[i]) >> 20);
+	for_each_memblock(memory, reg) {
+		unsigned long pages = reg->size >> PAGE_SHIFT;
+		num_physpages += pages;
+		printk(" %luMB", pages >> (20 - PAGE_SHIFT));
 	}
 	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e8ed9dc..e45a241 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -856,6 +856,7 @@ static void __init sanity_check_meminfo(void)
 static inline void prepare_page_table(void)
 {
 	unsigned long addr;
+	phys_addr_t end;
 
 	/*
 	 * Clear out all the mappings below the kernel image.
@@ -871,10 +872,18 @@ static inline void prepare_page_table(void)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
+	 * Find the end of the first block of lowmem.  This is complicated
+	 * when we use memblock.
+	 */
+	end = memblock.memory.regions[0].base + memblock.memory.regions[0].size;
+	if (end >= lowmem_end_addr)
+		end = lowmem_end_addr;
+
+	/*
 	 * Clear out all the kernel space mappings, except for the first
 	 * memory bank, up to the end of the vmalloc region.
 	 */
-	for (addr = __phys_to_virt(bank_phys_end(&meminfo.bank[0]));
+	for (addr = __phys_to_virt(end);
 	     addr < VMALLOC_END; addr += PGDIR_SIZE)
 		pmd_clear(pmd_off_k(addr));
 }
@@ -991,29 +1000,27 @@ static void __init kmap_init(void)
 #endif
 }
 
-static inline void map_memory_bank(struct membank *bank)
-{
-	struct map_desc map;
-
-	map.pfn = bank_pfn_start(bank);
-	map.virtual = __phys_to_virt(bank_phys_start(bank));
-	map.length = bank_phys_size(bank);
-	map.type = MT_MEMORY;
-
-	create_mapping(&map);
-}
-
 static void __init map_lowmem(void)
 {
-	struct meminfo *mi = &meminfo;
-	int i;
+	struct memblock_region *reg;
 
 	/* Map all the lowmem memory banks. */
-	for (i = 0; i < mi->nr_banks; i++) {
-		struct membank *bank = &mi->bank[i];
+	for_each_memblock(memory, reg) {
+		phys_addr_t start = reg->base;
+		phys_addr_t end = start + reg->size;
+		struct map_desc map;
+
+		if (end >= lowmem_end_addr)
+			end = lowmem_end_addr;
+		if (start >= end)
+			break;
+
+		map.pfn = __phys_to_pfn(start);
+		map.virtual = __phys_to_virt(start);
+		map.length = end - start;
+		map.type = MT_MEMORY;
 
-		if (!bank->highmem)
-			map_memory_bank(bank);
+		create_mapping(&map);
 	}
 }
 
-- 
1.7.3.2.2.g0dc5c

