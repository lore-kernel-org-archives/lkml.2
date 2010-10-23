Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0JWM6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 08:58:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61161 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab0JWM6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 08:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FlsuNmg+J7gDmFycvSenesenZdRQlheInzNSfR4ucnEkE3U9R/+lmkc08Bfr/CpeTc
         u84SxSbga48YUU63Jg24fzr6uEqig7lEMiBeVSMDAmymWAh9rjUSPz19Gfb7EGlYZOIW
         bJcm/2qfJnQbECfyZOYZfWBfQ0igawMlB94pw=
MIME-Version: 1.0
In-Reply-To: <1287838179-8872-1-git-send-email-felipe.contreras@gmail.com>
References: <1287838179-8872-1-git-send-email-felipe.contreras@gmail.com>
Date: Sat, 23 Oct 2010 15:58:18 +0300
Message-ID: <AANLkTi=dcx57shzuAUvw0eJwE0u4QQYRdBMPUXu4xH4a@mail.gmail.com>
Subject: Re: [PATCH] arm: mm: use memblock for memory init
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 3:49 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> From: Russell King <rmk+kernel@arm.linux.org.uk>
>
> The advantage with this is that memblock is now used as the basis for
> determining where memory is, setting up the maps, freeing memory into
> the pools, etc.

Here is the interdiff from Russell's patch.

Also, CC'ing some other people that might be interested.

And BTW, I didn't test the highmem changes.

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c3a9cf0..e3a2fb0 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -127,19 +127,22 @@ static void __init find_limits(unsigned long
*min, unsigned long *max_low,
 	struct meminfo *mi = &meminfo;
 	int i;

-	*min = memblock_start_pfn(&memblock.memory, 0);
-	*max_high = PFN_DOWN(memblock_end_of_DRAM());
+	*min = -1UL;
+	*max_low = *max_high = 0;

-	/* Use the old method to find the top of lowmem */
-	*max_low = 0;
 	for_each_bank (i, mi) {
 		struct membank *bank = &mi->bank[i];
-		unsigned long end;
+		unsigned long start, end;

+		start = bank_pfn_start(bank);
+		end = bank_pfn_end(bank);
+
+		if (*min > start)
+			*min = start;
+		if (*max_high < end)
+			*max_high = end;
 		if (bank->highmem)
 			continue;
-
-		end = bank_pfn_end(bank);
 		if (*max_low < end)
 			*max_low = end;
 	}
@@ -152,7 +155,6 @@ static void __init arm_bootmem_init(unsigned long start_pfn,
 	unsigned int boot_pages;
 	phys_addr_t bitmap;
 	pg_data_t *pgdat;
-	int i;

 	/*
 	 * Allocate the bootmem bitmap page.  This must be in a region
@@ -171,9 +173,9 @@ static void __init arm_bootmem_init(unsigned long start_pfn,
 	init_bootmem_node(pgdat, __phys_to_pfn(bitmap), start_pfn, end_pfn);

 	/* Free the lowmem regions from memblock into bootmem. */
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long start = memblock_start_pfn(&memblock.memory, i);
-		unsigned long end = memblock_end_pfn(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);

 		if (end >= end_pfn)
 			end = end_pfn;
@@ -187,8 +189,8 @@ static void __init arm_bootmem_init(unsigned long start_pfn,
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
@@ -200,7 +202,7 @@ static void __init arm_bootmem_free(unsigned long
min, unsigned long max_low,
 	unsigned long max_high)
 {
 	unsigned long zone_size[MAX_NR_ZONES], zhole_size[MAX_NR_ZONES];
-	int i;
+	struct memblock_region *reg;

 	/*
 	 * initialise the zones.
@@ -222,20 +224,18 @@ static void __init arm_bootmem_free(unsigned
long min, unsigned long max_low,
 	 *  holes = node_size - sum(bank_sizes)
 	 */
 	memcpy(zhole_size, zone_size, sizeof(zhole_size));
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long start = memblock_start_pfn(&memblock.memory, i);
-		unsigned long end = memblock_end_pfn(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
+		unsigned long start = memblock_region_memory_base_pfn(reg);
+		unsigned long end = memblock_region_memory_end_pfn(reg);

 		if (start < max_low) {
 			unsigned long low_end = min(end, max_low);
-
 			zhole_size[0] -= low_end - start;
 		}

 #ifdef CONFIG_HIGHMEM
 		if (end > max_low) {
 			unsigned long high_start = max(start, max_low);
-
 			zhole_size[ZONE_HIGHMEM] -= end - high_start;
 		}
 #endif
@@ -429,12 +429,12 @@ static void __init free_highpages(void)
 {
 #ifdef CONFIG_HIGHMEM
 	unsigned long max_low = max_low_pfn + PHYS_PFN_OFFSET;
-	int i, j;
+	struct memblock_region *mem_reg, *res_reg;

 	/* set highmem page free */
-	for (i = j = 0; i < memblock.memory.cnt; i++) {
-		unsigned long start = memblock_start_pfn(&memblock.memory, i);
-		unsigned long end = memblock_end_pfn(&memblock.memory, i);
+	for_each_memblock(memory, mem_reg) {
+		unsigned long start = memblock_region_memory_base_pfn(mem_reg);
+		unsigned long end = memblock_region_memory_end_pfn(mem_reg);

 		/* Ignore complete lowmem entries */
 		if (end <= max_low)
@@ -445,12 +445,11 @@ static void __init free_highpages(void)
 			start = max_low;

 		/* Find and exclude any reserved regions */
-		for (; j < memblock.reserved.cnt; j++) {
-			unsigned long res_start;
-			unsigned long res_end;
-
-			res_start = memblock_start_pfn(&memblock.reserved, j);
-			res_end = res_start + PFN_UP(memblock_size_bytes(&memblock.reserved, j));
+		for_each_memblock(reserved, res_reg) {
+			unsigned long res_start =
+				memblock_region_reserved_base_pfn(res_reg);
+			unsigned long res_end =
+				memblock_region_reserved_end_pfn(res_reg);

 			if (res_end < start)
 				continue;
@@ -484,6 +483,7 @@ static void __init free_highpages(void)
 void __init mem_init(void)
 {
 	unsigned long reserved_pages, free_pages;
+	struct memblock_region *reg;
 	int i;
 #ifdef CONFIG_HAVE_TCM
 	/* These pointers are filled in on TCM detection */
@@ -534,8 +534,8 @@ void __init mem_init(void)
 	 */
 	printk(KERN_INFO "Memory:");
 	num_physpages = 0;
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long pages = memblock_size_pages(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
+		unsigned long pages = reg->size >> PAGE_SHIFT;
 		num_physpages += pages;
 		printk(" %luMB", pages >> (20 - PAGE_SHIFT));
 	}
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 3825b4f..e45a241 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -875,7 +875,7 @@ static inline void prepare_page_table(void)
 	 * Find the end of the first block of lowmem.  This is complicated
 	 * when we use memblock.
 	 */
-	end = memblock.memory.region[0].base + memblock.memory.region[0].size;
+	end = memblock.memory.regions[0].base + memblock.memory.regions[0].size;
 	if (end >= lowmem_end_addr)
 		end = lowmem_end_addr;

@@ -1002,12 +1002,12 @@ static void __init kmap_init(void)

 static void __init map_lowmem(void)
 {
-	int i;
+	struct memblock_region *reg;

 	/* Map all the lowmem memory banks. */
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		phys_addr_t start = memblock.memory.region[i].base;
-		phys_addr_t end = start + memblock.memory.region[i].size;
+	for_each_memblock(memory, reg) {
+		phys_addr_t start = reg->base;
+		phys_addr_t end = start + reg->size;
 		struct map_desc map;

 		if (end >= lowmem_end_addr)

-- 
Felipe Contreras
