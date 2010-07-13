Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0GMHRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:17:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29277 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab0GMHQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:16:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 50/50] x86: remove old bootmem code
Date: Tue, 13 Jul 2010 00:10:44 -0700
Message-Id: <1279005044-24777-51-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
References: <1279005044-24777-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C3C12C0.0239,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Requested by Ingo, Thomas and HPA.

it mean 2.6.34 and 2.6.35 have them bootmem and nobootmem for x86.
and later for x86 will only have nobootmem

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/Kconfig        |   10 +-------
 arch/x86/kernel/setup.c |    4 ---
 arch/x86/mm/init_32.c   |   56 -----------------------------------------------
 arch/x86/mm/init_64.c   |   41 ----------------------------------
 arch/x86/mm/memblock.c  |   31 --------------------------
 arch/x86/mm/numa_32.c   |    3 --
 arch/x86/mm/numa_64.c   |   47 ---------------------------------------
 7 files changed, 1 insertions(+), 191 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 542bb26..ce07615 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -585,15 +585,7 @@ config PARAVIRT_DEBUG
 	  a paravirt_op is missing when it is called.
 
 config NO_BOOTMEM
-	default y
-	bool "Disable Bootmem code"
-	---help---
-	  Use memblock directly instead of bootmem before slab is ready.
-		- allocator (buddy) [generic]
-		- early allocator (bootmem) [generic]
-		- very early allocator (memblock) [some generic]
-		- very very early allocator (early brk model) [x86]
-	  So reduce one layer between early allocator to final allocator
+	def_bool y
 
 config MEMTEST
 	bool "Memtest"
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 924c8f7..1d114ff 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1014,10 +1014,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 	memblock_find_dma_reserve();
-#ifndef CONFIG_NO_BOOTMEM
-	memblock_x86_to_bootmem(0, max_low_pfn<<PAGE_SHIFT);
-#endif
-
 	dma32_reserve_bootmem();
 
 #ifdef CONFIG_KVM_CLOCK
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 49adf16..c2385d7 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -751,68 +751,12 @@ static void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
-#ifndef CONFIG_NO_BOOTMEM
-static unsigned long __init setup_node_bootmem(int nodeid,
-				 unsigned long start_pfn,
-				 unsigned long end_pfn,
-				 unsigned long bootmap)
-{
-	unsigned long bootmap_size;
-
-	/* don't touch min_low_pfn */
-	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
-					 bootmap >> PAGE_SHIFT,
-					 start_pfn, end_pfn);
-	printk(KERN_INFO "  node %d low ram: %08lx - %08lx\n",
-		nodeid, start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
-	printk(KERN_INFO "  node %d bootmap %08lx - %08lx\n",
-		 nodeid, bootmap, bootmap + bootmap_size);
-	free_bootmem_with_active_regions(nodeid, end_pfn);
-
-	return bootmap + bootmap_size;
-}
-#endif
-
 void __init setup_bootmem_allocator(void)
 {
-#ifndef CONFIG_NO_BOOTMEM
-	int nodeid;
-	unsigned long bootmap_size, bootmap;
-	/*
-	 * Initialize the boot-time allocator (with low memory only):
-	 */
-	bootmap_size = bootmem_bootmap_pages(max_low_pfn)<<PAGE_SHIFT;
-	bootmap = memblock_find_in_range(0, max_pfn_mapped<<PAGE_SHIFT, bootmap_size,
-				 PAGE_SIZE);
-	if (bootmap == MEMBLOCK_ERROR)
-		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	memblock_x86_reserve_range(bootmap, bootmap + bootmap_size, "BOOTMAP");
-#endif
-
 	printk(KERN_INFO "  mapped low ram: 0 - %08lx\n",
 		 max_pfn_mapped<<PAGE_SHIFT);
 	printk(KERN_INFO "  low ram: 0 - %08lx\n", max_low_pfn<<PAGE_SHIFT);
 
-#ifndef CONFIG_NO_BOOTMEM
-	for_each_online_node(nodeid) {
-		 unsigned long start_pfn, end_pfn;
-
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-		start_pfn = node_start_pfn[nodeid];
-		end_pfn = node_end_pfn[nodeid];
-		if (start_pfn > max_low_pfn)
-			continue;
-		if (end_pfn > max_low_pfn)
-			end_pfn = max_low_pfn;
-#else
-		start_pfn = 0;
-		end_pfn = max_low_pfn;
-#endif
-		bootmap = setup_node_bootmem(nodeid, start_pfn, end_pfn,
-						 bootmap);
-	}
-#endif
-
 	after_bootmem = 1;
 }
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d6d4084..690b8d1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -572,23 +572,7 @@ kernel_physical_mapping_init(unsigned long start,
 void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 				int acpi, int k8)
 {
-#ifndef CONFIG_NO_BOOTMEM
-	unsigned long bootmap_size, bootmap;
-
-	bootmap_size = bootmem_bootmap_pages(end_pfn)<<PAGE_SHIFT;
-	bootmap = memblock_find_in_range(0, end_pfn<<PAGE_SHIFT, bootmap_size,
-				 PAGE_SIZE);
-	if (bootmap == MEMBLOCK_ERROR)
-		panic("Cannot find bootmem map of size %ld\n", bootmap_size);
-	memblock_x86_reserve_range(bootmap, bootmap + bootmap_size, "BOOTMAP");
-	/* don't touch min_low_pfn */
-	bootmap_size = init_bootmem_node(NODE_DATA(0), bootmap >> PAGE_SHIFT,
-					 0, end_pfn);
 	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
-	free_bootmem_with_active_regions(0, end_pfn);
-#else
-	memblock_x86_register_active_regions(0, start_pfn, end_pfn);
-#endif
 }
 #endif
 
@@ -798,31 +782,6 @@ void mark_rodata_ro(void)
 
 #endif
 
-#ifndef CONFIG_NO_BOOTMEM
-int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
-				   int flags)
-{
-	unsigned long pfn = phys >> PAGE_SHIFT;
-
-	if (pfn >= max_pfn) {
-		/*
-		 * This can happen with kdump kernels when accessing
-		 * firmware tables:
-		 */
-		if (pfn < max_pfn_mapped)
-			return -EFAULT;
-
-		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %lu\n",
-				phys, len);
-		return -EFAULT;
-	}
-
-	reserve_bootmem(phys, len, flags);
-
-	return 0;
-}
-#endif
-
 int kern_addr_valid(unsigned long addr)
 {
 	unsigned long above = ((long)addr) >> __VIRTUAL_MASK_SHIFT;
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 70a6bba..104701b 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -109,7 +109,6 @@ static __init struct range *find_range_array(int count)
 	return range;
 }
 
-#ifdef CONFIG_NO_BOOTMEM
 static void __init memblock_x86_subtract_reserved(struct range *range, int az)
 {
 	int count;
@@ -186,36 +185,6 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 	*rangep = range;
 	return nr_range;
 }
-#else
-void __init memblock_x86_to_bootmem(u64 start, u64 end)
-{
-	int count;
-	u64 final_start, final_end;
-	struct memblock_region *r;
-
-	/* Take out region array itself */
-	if (memblock.reserved.regions != memblock_reserved_init_regions)
-		memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
-
-	count  = memblock.reserved.cnt;
-	memblock_dbg("(%d early reservations) ==> bootmem [%#010llx-%#010llx]\n", count, start, end - 1);
-	for_each_memblock(reserved, r) {
-		memblock_dbg("  [%#010llx-%#010llx] ", (u64)r->base, (u64)r->base + r->size - 1);
-		final_start = max(start, r->base);
-		final_end = min(end, r->base + r->size);
-		if (final_start >= final_end) {
-			memblock_dbg("\n");
-			continue;
-		}
-		memblock_dbg(" ==> [%#010llx-%#010llx]\n", final_start, final_end - 1);
-		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
-	}
-
-	/* Put region array back ? */
-	if (memblock.reserved.regions != memblock_reserved_init_regions)
-		memblock_reserve(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
-}
-#endif
 
 static u64 __init __memblock_x86_memory_in_range(u64 addr, u64 limit, bool get_free)
 {
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index ddf9730..70ddeb7 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -420,9 +420,6 @@ void __init initmem_init(unsigned long start_pfn, unsigned long end_pfn,
 	for_each_online_node(nid) {
 		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 		NODE_DATA(nid)->node_id = nid;
-#ifndef CONFIG_NO_BOOTMEM
-		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
-#endif
 	}
 
 	setup_bootmem_allocator();
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 984b1ff..aef0ff7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -199,10 +199,6 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	unsigned long start_pfn, last_pfn, nodedata_phys;
 	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
 	int nid;
-#ifndef CONFIG_NO_BOOTMEM
-	unsigned long bootmap_start, bootmap_pages, bootmap_size;
-	void *bootmap;
-#endif
 
 	if (!end)
 		return;
@@ -239,47 +235,6 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	NODE_DATA(nodeid)->node_start_pfn = start_pfn;
 	NODE_DATA(nodeid)->node_spanned_pages = last_pfn - start_pfn;
 
-#ifndef CONFIG_NO_BOOTMEM
-	NODE_DATA(nodeid)->bdata = &bootmem_node_data[nodeid];
-
-	/*
-	 * Find a place for the bootmem map
-	 * nodedata_phys could be on other nodes by alloc_bootmem,
-	 * so need to sure bootmap_start not to be small, otherwise
-	 * early_node_mem will get that with memblock_find_in_range instead
-	 * of alloc_bootmem, that could clash with reserved range
-	 */
-	bootmap_pages = bootmem_bootmap_pages(last_pfn - start_pfn);
-	bootmap_start = roundup(nodedata_phys + pgdat_size, PAGE_SIZE);
-	/*
-	 * SMP_CACHE_BYTES could be enough, but init_bootmem_node like
-	 * to use that to align to PAGE_SIZE
-	 */
-	bootmap = early_node_mem(nodeid, bootmap_start, end,
-				 bootmap_pages<<PAGE_SHIFT, PAGE_SIZE);
-	if (bootmap == NULL)  {
-		memblock_x86_free_range(nodedata_phys, nodedata_phys + pgdat_size);
-		node_data[nodeid] = NULL;
-		return;
-	}
-	bootmap_start = __pa(bootmap);
-	memblock_x86_reserve_range(bootmap_start, bootmap_start+(bootmap_pages<<PAGE_SHIFT),
-			"BOOTMAP");
-
-	bootmap_size = init_bootmem_node(NODE_DATA(nodeid),
-					 bootmap_start >> PAGE_SHIFT,
-					 start_pfn, last_pfn);
-
-	printk(KERN_INFO "  bootmap [%016lx -  %016lx] pages %lx\n",
-		 bootmap_start, bootmap_start + bootmap_size - 1,
-		 bootmap_pages);
-	nid = phys_to_nid(bootmap_start);
-	if (nid != nodeid)
-		printk(KERN_INFO "    bootmap(%d) on node %d\n", nodeid, nid);
-
-	free_bootmem_with_active_regions(nodeid, end);
-#endif
-
 	node_set_online(nodeid);
 }
 
@@ -704,9 +659,7 @@ unsigned long __init numa_free_all_bootmem(void)
 	for_each_online_node(i)
 		pages += free_all_bootmem_node(NODE_DATA(i));
 
-#ifdef CONFIG_NO_BOOTMEM
 	pages += free_all_memory_core_early(MAX_NUMNODES);
-#endif
 
 	return pages;
 }
-- 
1.6.4.2

