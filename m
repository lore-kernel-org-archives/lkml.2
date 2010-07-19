Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967399Ab0GTAHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:07:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64125 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760960Ab0GSX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:58:33 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 05/49] memblock: Introduce for_each_memblock() and new accessors, and use it
Date: Mon, 19 Jul 2010 16:56:14 -0700
Message-Id: <1279583818-14249-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C44E684.0051,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Walk memblock's using for_each_memblock() and use memblock_region_base/end_pfn() for
getting to PFNs. Update sparc, powerpc, microblaze and sh.

Note: This is -almost- a direct conversion. It doesn't fix some existing
crap when/if memblock's aren't page aligned in the first place. This will be
sorted out separately.

This removes memblock_find() as well, which isn't used anymore

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/microblaze/mm/init.c       |   18 +++----
 arch/powerpc/mm/hash_utils_64.c |    8 ++--
 arch/powerpc/mm/mem.c           |   92 ++++++++++++++-------------------------
 arch/powerpc/mm/numa.c          |   17 ++++---
 arch/sh/mm/init.c               |   16 ++++---
 arch/sparc/mm/init_64.c         |   30 +++++--------
 include/linux/memblock.h        |   56 ++++++++++++++++++------
 mm/memblock.c                   |   32 -------------
 8 files changed, 117 insertions(+), 152 deletions(-)

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
index afd6494..8f45b41 100644
--- a/arch/microblaze/mm/init.c
+++ b/arch/microblaze/mm/init.c
@@ -70,16 +70,16 @@ static void __init paging_init(void)
 
 void __init setup_memory(void)
 {
-	int i;
 	unsigned long map_size;
+	struct memblock_region *reg;
+
 #ifndef CONFIG_MMU
 	u32 kernel_align_start, kernel_align_size;
 
 	/* Find main memory where is the kernel */
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		memory_start = (u32) memblock.memory.regions[i].base;
-		memory_end = (u32) memblock.memory.regions[i].base
-				+ (u32) memblock.memory.region[i].size;
+	for_each_memblock(memory, reg) {
+		memory_start = (u32)reg->base;
+		memory_end = (u32) reg->base + reg->size;
 		if ((memory_start <= (u32)_text) &&
 					((u32)_text <= memory_end)) {
 			memory_size = memory_end - memory_start;
@@ -147,12 +147,10 @@ void __init setup_memory(void)
 	free_bootmem(memory_start, memory_size);
 
 	/* reserve allocate blocks */
-	for (i = 0; i < memblock.reserved.cnt; i++) {
+	for_each_memblock(reserved, reg) {
 		pr_debug("reserved %d - 0x%08x-0x%08x\n", i,
-			(u32) memblock.reserved.region[i].base,
-			(u32) memblock_size_bytes(&memblock.reserved, i));
-		reserve_bootmem(memblock.reserved.region[i].base,
-			memblock_size_bytes(&memblock.reserved, i) - 1, BOOTMEM_DEFAULT);
+			 (u32) reg->base, (u32) reg->size);
+		reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
 	}
 #ifdef CONFIG_MMU
 	init_bootmem_done = 1;
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index dbaacb7..2b0a807 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -588,7 +588,7 @@ static void __init htab_initialize(void)
 	unsigned long pteg_count;
 	unsigned long prot;
 	unsigned long base = 0, size = 0, limit;
-	int i;
+	struct memblock_region *reg;
 
 	DBG(" -> htab_initialize()\n");
 
@@ -659,9 +659,9 @@ static void __init htab_initialize(void)
 	 */
 
 	/* create bolted the linear mapping in the hash table */
-	for (i=0; i < memblock.memory.cnt; i++) {
-		base = (unsigned long)__va(memblock.memory.regions[i].base);
-		size = memblock.memory.region[i].size;
+	for_each_memblock(memory, reg) {
+		base = (unsigned long)__va(reg->base);
+		size = reg->size;
 
 		DBG("creating mapping for region: %lx..%lx (prot: %lx)\n",
 		    base, size, prot);
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index a33f5c1..52df542 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -82,18 +82,11 @@ int page_is_ram(unsigned long pfn)
 	return pfn < max_pfn;
 #else
 	unsigned long paddr = (pfn << PAGE_SHIFT);
-	int i;
-	for (i=0; i < memblock.memory.cnt; i++) {
-		unsigned long base;
+	struct memblock_region *reg;
 
-		base = memblock.memory.regions[i].base;
-
-		if ((paddr >= base) &&
-			(paddr < (base + memblock.memory.regions[i].size))) {
+	for_each_memblock(memory, reg)
+		if (paddr >= reg->base && paddr < (reg->base + reg->size))
 			return 1;
-		}
-	}
-
 	return 0;
 #endif
 }
@@ -149,23 +142,19 @@ int
 walk_system_ram_range(unsigned long start_pfn, unsigned long nr_pages,
 		void *arg, int (*func)(unsigned long, unsigned long, void *))
 {
-	struct memblock_region res;
-	unsigned long pfn, len;
-	u64 end;
+	struct memblock_region *reg;
+	unsigned long end_pfn = start_pfn + nr_pages;
+	unsigned long tstart, tend;
 	int ret = -1;
 
-	res.base = (u64) start_pfn << PAGE_SHIFT;
-	res.size = (u64) nr_pages << PAGE_SHIFT;
-
-	end = res.base + res.size - 1;
-	while ((res.base < end) && (memblock_find(&res) >= 0)) {
-		pfn = (unsigned long)(res.base >> PAGE_SHIFT);
-		len = (unsigned long)(res.size >> PAGE_SHIFT);
-		ret = (*func)(pfn, len, arg);
+	for_each_memblock(memory, reg) {
+		tstart = max(start_pfn, memblock_region_base_pfn(reg));
+		tend = min(end_pfn, memblock_region_end_pfn(reg));
+		if (tstart >= tend)
+			continue;
+		ret = (*func)(tstart, tend - tstart, arg);
 		if (ret)
 			break;
-		res.base += (res.size + 1);
-		res.size = (end - res.base + 1);
 	}
 	return ret;
 }
@@ -179,9 +168,9 @@ EXPORT_SYMBOL_GPL(walk_system_ram_range);
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 void __init do_init_bootmem(void)
 {
-	unsigned long i;
 	unsigned long start, bootmap_pages;
 	unsigned long total_pages;
+	struct memblock_region *reg;
 	int boot_mapsize;
 
 	max_low_pfn = max_pfn = memblock_end_of_DRAM() >> PAGE_SHIFT;
@@ -204,10 +193,10 @@ void __init do_init_bootmem(void)
 	boot_mapsize = init_bootmem_node(NODE_DATA(0), start >> PAGE_SHIFT, min_low_pfn, max_low_pfn);
 
 	/* Add active regions with valid PFNs */
-	for (i = 0; i < memblock.memory.cnt; i++) {
+	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock.memory.regions[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
+		start_pfn = memblock_region_base_pfn(reg);
+		end_pfn = memblock_region_end_pfn(reg);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -218,29 +207,21 @@ void __init do_init_bootmem(void)
 	free_bootmem_with_active_regions(0, lowmem_end_addr >> PAGE_SHIFT);
 
 	/* reserve the sections we're already using */
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		unsigned long addr = memblock.reserved.regions[i].base +
-				     memblock_size_bytes(&memblock.reserved, i) - 1;
-		if (addr < lowmem_end_addr)
-			reserve_bootmem(memblock.reserved.regions[i].base,
-					memblock_size_bytes(&memblock.reserved, i),
-					BOOTMEM_DEFAULT);
-		else if (memblock.reserved.regions[i].base < lowmem_end_addr) {
-			unsigned long adjusted_size = lowmem_end_addr -
-				      memblock.reserved.regions[i].base;
-			reserve_bootmem(memblock.reserved.regions[i].base,
-					adjusted_size, BOOTMEM_DEFAULT);
+	for_each_memblock(reserved, reg) {
+		unsigned long top = reg->base + reg->size - 1;
+		if (top < lowmem_end_addr)
+			reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
+		else if (reg->base < lowmem_end_addr) {
+			unsigned long trunc_size = lowmem_end_addr - reg->base;
+			reserve_bootmem(reg->base, trunc_size, BOOTMEM_DEFAULT);
 		}
 	}
 #else
 	free_bootmem_with_active_regions(0, max_pfn);
 
 	/* reserve the sections we're already using */
-	for (i = 0; i < memblock.reserved.cnt; i++)
-		reserve_bootmem(memblock.reserved.regions[i].base,
-				memblock_size_bytes(&memblock.reserved, i),
-				BOOTMEM_DEFAULT);
-
+	for_each_memblock(reserved, reg)
+		reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
 #endif
 	/* XXX need to clip this if using highmem? */
 	sparse_memory_present_with_active_regions(0);
@@ -251,22 +232,15 @@ void __init do_init_bootmem(void)
 /* mark pages that don't exist as nosave */
 static int __init mark_nonram_nosave(void)
 {
-	unsigned long memblock_next_region_start_pfn,
-		      memblock_region_max_pfn;
-	int i;
-
-	for (i = 0; i < memblock.memory.cnt - 1; i++) {
-		memblock_region_max_pfn =
-			(memblock.memory.regions[i].base >> PAGE_SHIFT) +
-			(memblock.memory.regions[i].size >> PAGE_SHIFT);
-		memblock_next_region_start_pfn =
-			memblock.memory.regions[i+1].base >> PAGE_SHIFT;
-
-		if (memblock_region_max_pfn < memblock_next_region_start_pfn)
-			register_nosave_region(memblock_region_max_pfn,
-					       memblock_next_region_start_pfn);
+	struct memblock_region *reg, *prev = NULL;
+
+	for_each_memblock(memory, reg) {
+		if (prev &&
+		    memblock_region_end_pfn(prev) < memblock_region_base_pfn(reg))
+			register_nosave_region(memblock_region_end_pfn(prev),
+					       memblock_region_base_pfn(reg));
+		prev = reg;
 	}
-
 	return 0;
 }
 
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index f473645..9eaaf22 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -746,16 +746,17 @@ static void __init setup_nonnuma(void)
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
 	unsigned long start_pfn, end_pfn;
-	unsigned int i, nid = 0;
+	unsigned int nid = 0;
+	struct memblock_region *reg;
 
 	printk(KERN_DEBUG "Top of RAM: 0x%lx, Total RAM: 0x%lx\n",
 	       top_of_ram, total_ram);
 	printk(KERN_DEBUG "Memory hole size: %ldMB\n",
 	       (top_of_ram - total_ram) >> 20);
 
-	for (i = 0; i < memblock.memory.cnt; ++i) {
-		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
+		start_pfn = memblock_region_base_pfn(reg);
+		end_pfn = memblock_region_end_pfn(reg);
 
 		fake_numa_create_new_node(end_pfn, &nid);
 		add_active_range(nid, start_pfn, end_pfn);
@@ -891,11 +892,11 @@ static struct notifier_block __cpuinitdata ppc64_numa_nb = {
 static void mark_reserved_regions_for_nid(int nid)
 {
 	struct pglist_data *node = NODE_DATA(nid);
-	int i;
+	struct memblock_region *reg;
 
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		unsigned long physbase = memblock.reserved.region[i].base;
-		unsigned long size = memblock.reserved.region[i].size;
+	for_each_memblock(reserved, reg) {
+		unsigned long physbase = reg->base;
+		unsigned long size = reg->size;
 		unsigned long start_pfn = physbase >> PAGE_SHIFT;
 		unsigned long end_pfn = PFN_UP(physbase + size);
 		struct node_active_region node_ar;
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index d0e2491..da1605a 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -226,11 +226,12 @@ static void __init bootmem_init_one_node(unsigned int nid)
 	 * reservations in other nodes.
 	 */
 	if (nid == 0) {
+		struct memblock_region *reg;
+
 		/* Reserve the sections we're already using. */
-		for (i = 0; i < memblock.reserved.cnt; i++)
-			reserve_bootmem(memblock.reserved.region[i].base,
-					memblock_size_bytes(&memblock.reserved, i),
-					BOOTMEM_DEFAULT);
+		for_each_memblock(reserved, reg) {
+			reserve_bootmem(reg->base, reg->size, BOOTMEM_DEFAULT);
+		}
 	}
 
 	sparse_memory_present_with_active_regions(nid);
@@ -238,13 +239,14 @@ static void __init bootmem_init_one_node(unsigned int nid)
 
 static void __init do_init_bootmem(void)
 {
+	struct memblock_region *reg;
 	int i;
 
 	/* Add active regions with valid PFNs. */
-	for (i = 0; i < memblock.memory.cnt; i++) {
+	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
+		start_pfn = memblock_region_base_pfn(reg);
+		end_pfn = memblock_region_end_pfn(reg);
 		__add_active_range(0, start_pfn, end_pfn);
 	}
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 16d8bee..dd68025 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -972,13 +972,13 @@ int of_node_to_nid(struct device_node *dp)
 
 static void __init add_node_ranges(void)
 {
-	int i;
+	struct memblock_region *reg;
 
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long size = memblock_size_bytes(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
+		unsigned long size = reg->size;
 		unsigned long start, end;
 
-		start = memblock.memory.regions[i].base;
+		start = reg->base;
 		end = start + size;
 		while (start < end) {
 			unsigned long this_end;
@@ -1281,7 +1281,7 @@ static void __init bootmem_init_nonnuma(void)
 {
 	unsigned long top_of_ram = memblock_end_of_DRAM();
 	unsigned long total_ram = memblock_phys_mem_size();
-	unsigned int i;
+	struct memblock_region *reg;
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1292,15 +1292,14 @@ static void __init bootmem_init_nonnuma(void)
 
 	init_node_masks_nonnuma();
 
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		unsigned long size = memblock_size_bytes(&memblock.memory, i);
+	for_each_memblock(memory, reg) {
 		unsigned long start_pfn, end_pfn;
 
-		if (!size)
+		if (!reg->size)
 			continue;
 
-		start_pfn = memblock.memory.regions[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + memblock_size_pages(&memblock.memory, i);
+		start_pfn = memblock_region_base_pfn(reg);
+		end_pfn = memblock_region_end_pfn(reg);
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
@@ -1334,17 +1333,12 @@ static void __init reserve_range_in_node(int nid, unsigned long start,
 
 static void __init trim_reserved_in_node(int nid)
 {
-	int i;
+	struct memblock_region *reg;
 
 	numadbg("  trim_reserved_in_node(%d)\n", nid);
 
-	for (i = 0; i < memblock.reserved.cnt; i++) {
-		unsigned long start = memblock.reserved.regions[i].base;
-		unsigned long size = memblock_size_bytes(&memblock.reserved, i);
-		unsigned long end = start + size;
-
-		reserve_range_in_node(nid, start, end);
-	}
+	for_each_memblock(reserved, reg)
+		reserve_range_in_node(nid, reg->base, reg->base + reg->size);
 }
 
 static void __init bootmem_init_one_node(int nid)
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 4b69313..d948857 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -58,32 +58,60 @@ extern u64 memblock_end_of_DRAM(void);
 extern void __init memblock_enforce_memory_limit(u64 memory_limit);
 extern int __init memblock_is_reserved(u64 addr);
 extern int memblock_is_region_reserved(u64 base, u64 size);
-extern int memblock_find(struct memblock_region *res);
 
 extern void memblock_dump_all(void);
 
-static inline u64
-memblock_size_bytes(struct memblock_type *type, unsigned long region_nr)
+/*
+ * pfn conversion functions
+ *
+ * While the memory MEMBLOCKs should always be page aligned, the reserved
+ * MEMBLOCKs may not be. This accessor attempt to provide a very clear
+ * idea of what they return for such non aligned MEMBLOCKs.
+ */
+
+/**
+ * memblock_region_base_pfn - Return the lowest pfn intersecting with the region
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_base_pfn(const struct memblock_region *reg)
 {
-	return type->regions[region_nr].size;
+	return reg->base >> PAGE_SHIFT;
 }
-static inline u64
-memblock_size_pages(struct memblock_type *type, unsigned long region_nr)
+
+/**
+ * memblock_region_last_pfn - Return the highest pfn intersecting with the region
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_last_pfn(const struct memblock_region *reg)
 {
-	return memblock_size_bytes(type, region_nr) >> PAGE_SHIFT;
+	return (reg->base + reg->size - 1) >> PAGE_SHIFT;
 }
-static inline u64
-memblock_start_pfn(struct memblock_type *type, unsigned long region_nr)
+
+/**
+ * memblock_region_end_pfn - Return the pfn of the first page following the region
+ *                      but not intersecting it
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_end_pfn(const struct memblock_region *reg)
 {
-	return type->regions[region_nr].base >> PAGE_SHIFT;
+	return memblock_region_last_pfn(reg) + 1;
 }
-static inline u64
-memblock_end_pfn(struct memblock_type *type, unsigned long region_nr)
+
+/**
+ * memblock_region_pages - Return the number of pages covering a region
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_pages(const struct memblock_region *reg)
 {
-	return memblock_start_pfn(type, region_nr) +
-	       memblock_size_pages(type, region_nr);
+	return memblock_region_end_pfn(reg) - memblock_region_end_pfn(reg);
 }
 
+#define for_each_memblock(memblock_type, region)					\
+	for (region = memblock.memblock_type.regions;				\
+	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
+	     region++)
+
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/mm/memblock.c b/mm/memblock.c
index 13d4a57..5df1400 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -505,35 +505,3 @@ int memblock_is_region_reserved(u64 base, u64 size)
 	return memblock_overlaps_region(&memblock.reserved, base, size);
 }
 
-/*
- * Given a <base, len>, find which memory regions belong to this range.
- * Adjust the request and return a contiguous chunk.
- */
-int memblock_find(struct memblock_region *res)
-{
-	int i;
-	u64 rstart, rend;
-
-	rstart = res->base;
-	rend = rstart + res->size - 1;
-
-	for (i = 0; i < memblock.memory.cnt; i++) {
-		u64 start = memblock.memory.regions[i].base;
-		u64 end = start + memblock.memory.regions[i].size - 1;
-
-		if (start > rend)
-			return -1;
-
-		if ((end >= rstart) && (start < rend)) {
-			/* adjust the request */
-			if (rstart < start)
-				rstart = start;
-			if (rend > end)
-				rend = end;
-			res->base = rstart;
-			res->size = rend - rstart + 1;
-			return 0;
-		}
-	}
-	return -1;
-}
-- 
1.6.4.2

