Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0JKPZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:25:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50062 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab0JKPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:25:33 -0400
Date: Mon, 11 Oct 2010 16:25:16 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101011152516.GF27153@n2100.arm.linux.org.uk>
References: <20101007192245.GC26435@n2100.arm.linux.org.uk> <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com> <20101008175308.GA10975@n2100.arm.linux.org.uk> <AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com> <20101008230451.GB10975@n2100.arm.linux.org.uk> <20101008232539.GA28697@kroah.com> <20101008234448.GD10975@n2100.arm.linux.org.uk> <AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com> <20101009092127.GB20975@n2100.arm.linux.org.uk> <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 04:52:36AM +0300, Felipe Contreras wrote:
> At the time 'fixup' is called, 'meminfo' is empty; the tags haven't
> been parsed. So my solution is to move the memblock_add() after
> 'reserve', and pass 'meminfo' as an argument:

Here's a different approach which will work.  This pushes ARM further
towards using memblock for everything relating to memory init (although
we still have the old membank stuff around.)

The advantage with this is that memblock is now used as the basis for
determining where memory is, setting up the maps, freeing memory into
the pools, etc.

What this also means is that this code in the ->reserve callback:

	size = min(size, SZ_2M);
	base = memblock_alloc(size, min(align, SZ_2M));
	memblock_free(base, size);
	memblock_remove(base, size);

will result in [base+size] being removed from the available memory,
using highmem if available, if not from lowmem and removing it from
the lowmem memory map - which is exactly the behaviour we want.

 arch/arm/mm/init.c |  160 +++++++++++++++++++++++++++++++++++-----------------
 arch/arm/mm/mmu.c  |   43 ++++++++------
 mm/memblock.c      |    4 +
 3 files changed, 138 insertions(+), 69 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 36c4553..66db6b2 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -121,34 +121,32 @@ void show_mem(void)
 	printk("%d pages swap cached\n", cached);
 }
 
-static void __init find_limits(struct meminfo *mi,
-	unsigned long *min, unsigned long *max_low, unsigned long *max_high)
+static void __init find_limits(unsigned long *min, unsigned long *max_low,
+	unsigned long *max_high)
 {
+	struct meminfo *mi = &meminfo;
 	int i;
 
-	*min = -1UL;
-	*max_low = *max_high = 0;
+	*min = memblock_start_pfn(&memblock.memory, 0);
+	*max_high = PFN_DOWN(memblock_end_of_DRAM());
 
+	/* Use the old method to find the top of lowmem */
+	*max_low = 0;
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
-		unsigned long start, end;
-
-		start = bank_pfn_start(bank);
-		end = bank_pfn_end(bank);
+		unsigned long end;
 
-		if (*min > start)
-			*min = start;
-		if (*max_high < end)
-			*max_high = end;
 		if (bank->highmem)
 			continue;
+
+		end = bank_pfn_end(bank);
 		if (*max_low < end)
 			*max_low = end;
 	}
 }
 
-static void __init arm_bootmem_init(struct meminfo *mi,
-	unsigned long start_pfn, unsigned long end_pfn)
+static void __init arm_bootmem_init(unsigned long start_pfn,
+	unsigned long end_pfn)
 {
 	unsigned int boot_pages;
 	phys_addr_t bitmap;
@@ -171,27 +169,35 @@ static void __init arm_bootmem_init(struct meminfo *mi,
 	pgdat = NODE_DATA(0);
 	init_bootmem_node(pgdat, __phys_to_pfn(bitmap), start_pfn, end_pfn);
 
-	for_each_bank(i, mi) {
-		struct membank *bank = &mi->bank[i];
-		if (!bank->highmem)
-			free_bootmem(bank_phys_start(bank), bank_phys_size(bank));
+	/* Free the lowmem regions from memblock into bootmem. */
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		unsigned long start = memblock_start_pfn(&memblock.memory, i);
+		unsigned long end = memblock_end_pfn(&memblock.memory, i);
+
+		if (end >= end_pfn)
+			end = end_pfn;
+		if (start >= end)
+			break;
+
+		free_bootmem(__pfn_to_phys(start), (end - start) << PAGE_SHIFT);
 	}
 
-	/*
-	 * Reserve the memblock reserved regions in bootmem.
-	 */
+	/* Reserve the lowmem memblock reserved regions in bootmem. */
 	for (i = 0; i < memblock.reserved.cnt; i++) {
-		phys_addr_t start = memblock_start_pfn(&memblock.reserved, i);
-		if (start >= start_pfn &&
-		    memblock_end_pfn(&memblock.reserved, i) <= end_pfn)
-			reserve_bootmem_node(pgdat, __pfn_to_phys(start),
-				memblock_size_bytes(&memblock.reserved, i),
-				BOOTMEM_DEFAULT);
+		unsigned long start = memblock_start_pfn(&memblock.reserved, i);
+		unsigned long size = memblock_size_bytes(&memblock.reserved, i);
+
+		if (start >= end_pfn)
+			break;
+		if (start + PFN_UP(size) > end_pfn)
+			size = (end_pfn - start) << PAGE_SHIFT;
+
+		reserve_bootmem(__pfn_to_phys(start), size, BOOTMEM_DEFAULT);
 	}
 }
 
-static void __init arm_bootmem_free(struct meminfo *mi, unsigned long min,
-	unsigned long max_low, unsigned long max_high)
+static void __init arm_bootmem_free(unsigned long min, unsigned long max_low,
+	unsigned long max_high)
 {
 	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
 	int i;
@@ -216,13 +222,23 @@ static void __init arm_bootmem_free(struct meminfo *mi, unsigned long min,
 	 *  holes = node_size - sum(bank_sizes)
 	 */
 	memcpy(zhole_size, zone_size, sizeof(zhole_size));
-	for_each_bank(i, mi) {
-		int idx = 0;
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		unsigned long start = memblock_start_pfn(&memblock.memory, i);
+		unsigned long end = memblock_end_pfn(&memblock.memory, i);
+
+		if (start < max_low) {
+			unsigned long low_end = min(end, max_low);
+
+			zhole_size[0] -= low_end - start;
+		}
+
 #ifdef CONFIG_HIGHMEM
-		if (mi->bank[i].highmem)
-			idx = ZONE_HIGHMEM;
+		if (end > max_low) {
+			unsigned long high_start = max(start, max_low);
+
+			zhole_size[ZONE_HIGHMEM] -= end - high_start;
+		}
 #endif
-		zhole_size[idx] -= bank_pfn_size(&mi->bank[i]);
 	}
 
 	/*
@@ -303,14 +319,13 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 
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
@@ -328,7 +343,7 @@ void __init bootmem_init(void)
 	 * the sparse mem_map arrays initialized by sparse_init()
 	 * for memmap_init_zone(), otherwise all PFNs are invalid.
 	 */
-	arm_bootmem_free(mi, min, max_low, max_high);
+	arm_bootmem_free(min, max_low, max_high);
 
 	high_memory = __va((max_low << PAGE_SHIFT) - 1) + 1;
 
@@ -422,6 +437,57 @@ static void __init free_unused_memmap(struct meminfo *mi)
 	}
 }
 
+static void __init free_highpages(void)
+{
+#ifdef CONFIG_HIGHMEM
+	unsigned long max_low = max_low_pfn + PHYS_PFN_OFFSET;
+	int i, j;
+
+	/* set highmem page free */
+	for (i = j = 0; i < memblock.memory.cnt; i++) {
+		unsigned long start = memblock_start_pfn(&memblock.memory, i);
+		unsigned long end = memblock_end_pfn(&memblock.memory, i);
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
+		for (; j < memblock.reserved.cnt; j++) {
+			unsigned long res_start;
+			unsigned long res_end;
+
+			res_start = memblock_start_pfn(&memblock.reserved, j);
+			res_end = res_start + PFN_UP(memblock_size_bytes(&memblock.reserved, j));
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
@@ -450,16 +516,7 @@ void __init mem_init(void)
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
 
@@ -489,9 +546,10 @@ void __init mem_init(void)
 	 */
 	printk(KERN_INFO "Memory:");
 	num_physpages = 0;
-	for (i = 0; i < meminfo.nr_banks; i++) {
-		num_physpages += bank_pfn_size(&meminfo.bank[i]);
-		printk(" %ldMB", bank_phys_size(&meminfo.bank[i]) >> 20);
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		unsigned long pages = memblock_size_pages(&memblock.memory, i);
+		num_physpages += pages;
+		printk(" %luMB", pages >> (20 - PAGE_SHIFT));
 	}
 	printk(" = %luMB total\n", num_physpages >> (20 - PAGE_SHIFT));
 
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e233581..6176e11 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -852,6 +852,7 @@ static void __init sanity_check_meminfo(void)
 static inline void prepare_page_table(void)
 {
 	unsigned long addr;
+	phys_addr_t end;
 
 	/*
 	 * Clear out all the mappings below the kernel image.
@@ -867,10 +868,18 @@ static inline void prepare_page_table(void)
 		pmd_clear(pmd_off_k(addr));
 
 	/*
+	 * Find the end of the first block of lowmem.  This is complicated
+	 * when we use memblock.
+	 */
+	end = memblock.memory.region[0].base + memblock.memory.region[0].size;
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
@@ -987,29 +996,27 @@ static void __init kmap_init(void)
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
 	int i;
 
 	/* Map all the lowmem memory banks. */
-	for (i = 0; i < mi->nr_banks; i++) {
-		struct membank *bank = &mi->bank[i];
+	for (i = 0; i < memblock.memory.cnt; i++) {
+		phys_addr_t start = memblock.memory.region[i].base;
+		phys_addr_t end = start + memblock.memory.region[i].size;
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
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 43840b3..aa69191 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -196,6 +196,10 @@ static long memblock_add_region(struct memblock_region *rgn, u64 base, u64 size)
 long memblock_add(u64 base, u64 size)
 {
 	struct memblock_region *_rgn = &memblock.memory;
+	u64 end = base + size;
+
+	base = PAGE_ALIGN(base);
+	size = (end & PAGE_MASK) - base;
 
 	/* On pSeries LPAR systems, the first MEMBLOCK is our RMO region. */
 	if (base == 0)
