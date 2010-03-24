Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0CXKlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:41:21 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55583 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab0CXKlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:41:18 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 8/8] powerpc : use early_res/nobootmem
Date: Wed, 24 Mar 2010 03:37:09 -0700
Message-Id: <1269427029-21000-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BA9EBFE.0157,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new early_res is extension for lmb, and it could be used to replace bootmem

also even could be used to simplify the bootmem path if needed.

--NOT TESTED--

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/powerpc/Kconfig   |   14 ++++++++++++++
 arch/powerpc/mm/mem.c  |   23 +++++++++++++++++++++--
 arch/powerpc/mm/numa.c |   11 ++++++++++-
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2e19500..307c3ef 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -52,6 +52,9 @@ config HAVE_SETUP_PER_CPU_AREA
 config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool PPC64
 
+config HAVE_EARLY_RES
+	def_bool y
+
 config IRQ_PER_CPU
 	bool
 	default y
@@ -443,6 +446,17 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	depends on (SMP && PPC_PSERIES) || PPC_PS3
 
+config NO_BOOTMEM
+	default y
+	bool "Disable Bootmem code"
+	---help---
+	  Use early_res directly instead of bootmem before slab is ready.
+		- allocator (buddy) [generic]
+		- early allocator (bootmem) [generic]
+		- very early allocator (reserve_early*()/lmb)
+	  So reduce one layer between early allocator to final allocator
+
+
 config ARCH_POPULATES_NODE_MAP
 	def_bool y
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 448f972..7004f9e 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -179,9 +179,11 @@ EXPORT_SYMBOL_GPL(walk_system_ram_range);
 void __init do_init_bootmem(void)
 {
 	unsigned long i;
-	unsigned long start, bootmap_pages;
 	unsigned long total_pages;
+#ifndef CONFIG_NO_BOOTMEM
+	unsigned long start, bootmap_pages;
 	int boot_mapsize;
+#endif
 
 	max_low_pfn = max_pfn = lmb_end_of_DRAM() >> PAGE_SHIFT;
 	total_pages = (lmb_end_of_DRAM() - memstart_addr) >> PAGE_SHIFT;
@@ -189,7 +191,9 @@ void __init do_init_bootmem(void)
 	total_pages = total_lowmem >> PAGE_SHIFT;
 	max_low_pfn = lowmem_end_addr >> PAGE_SHIFT;
 #endif
+	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
 
+#ifndef CONFIG_NO_BOOTMEM
 	/*
 	 * Find an area to use for the bootmem bitmap.  Calculate the size of
 	 * bitmap required as (Total Memory) / PAGE_SIZE / BITS_PER_BYTE.
@@ -199,8 +203,8 @@ void __init do_init_bootmem(void)
 
 	start = lmb_alloc(bootmap_pages << PAGE_SHIFT, PAGE_SIZE);
 
-	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
 	boot_mapsize = init_bootmem_node(NODE_DATA(0), start >> PAGE_SHIFT, min_low_pfn, max_low_pfn);
+#endif
 
 	/* Add active regions with valid PFNs */
 	for (i = 0; i < lmb.memory.cnt; i++) {
@@ -210,6 +214,7 @@ void __init do_init_bootmem(void)
 		add_active_range(0, start_pfn, end_pfn);
 	}
 
+#ifndef CONFIG_NO_BOOTMEM
 	/* Add all physical memory to the bootmem map, mark each area
 	 * present.
 	 */
@@ -241,6 +246,7 @@ void __init do_init_bootmem(void)
 				BOOTMEM_DEFAULT);
 
 #endif
+#endif
 	/* XXX need to clip this if using highmem? */
 	sparse_memory_present_with_active_regions(0);
 
@@ -311,6 +317,16 @@ void __init paging_init(void)
 }
 #endif /* ! CONFIG_NEED_MULTIPLE_NODES */
 
+u64 __init get_max_mapped(void)
+{
+	u64 end = max_low_pfn;
+
+	end <<= PAGE_SHIFT;
+
+	return end;
+}
+
+
 void __init mem_init(void)
 {
 #ifdef CONFIG_NEED_MULTIPLE_NODES
@@ -337,6 +353,9 @@ void __init mem_init(void)
 				free_all_bootmem_node(NODE_DATA(nid));
 		}
 	}
+#ifdef CONFIG_NO_BOOTMEM
+	totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
+#endif
 #else
 	max_mapnr = max_pfn;
 	totalram_pages += free_all_bootmem();
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 64c0022..024c3ff 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -90,6 +90,7 @@ static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
 	return 0;
 }
 
+#ifndef CONFIG_NO_BOOTMEM
 /*
  * get_active_region_work_fn - A helper function for get_node_active_region
  *	Returns datax set to the start_pfn and end_pfn if they contain
@@ -131,6 +132,7 @@ static void __init get_node_active_region(unsigned long start_pfn,
 	node_ar->end_pfn = start_pfn;
 	work_with_active_regions(nid, get_active_region_work_fn, node_ar);
 }
+#endif
 
 static void __cpuinit map_cpu_to_node(int cpu, int node)
 {
@@ -845,6 +847,7 @@ static struct notifier_block __cpuinitdata ppc64_numa_nb = {
 	.priority = 1 /* Must run before sched domains notifier. */
 };
 
+#ifndef CONFIG_NO_BOOTMEM
 static void mark_reserved_regions_for_nid(int nid)
 {
 	struct pglist_data *node = NODE_DATA(nid);
@@ -911,7 +914,7 @@ static void mark_reserved_regions_for_nid(int nid)
 		}
 	}
 }
-
+#endif
 
 void __init do_init_bootmem(void)
 {
@@ -932,8 +935,10 @@ void __init do_init_bootmem(void)
 
 	for_each_online_node(nid) {
 		unsigned long start_pfn, end_pfn;
+#ifndef CONFIG_NO_BOOTMEM
 		void *bootmem_vaddr;
 		unsigned long bootmap_pages;
+#endif
 
 		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
 
@@ -951,7 +956,9 @@ void __init do_init_bootmem(void)
   		dbg("node %d\n", nid);
 		dbg("NODE_DATA() = %p\n", NODE_DATA(nid));
 
+#ifndef CONFIG_NO_BOOTMEM
 		NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
+#endif
 		NODE_DATA(nid)->node_start_pfn = start_pfn;
 		NODE_DATA(nid)->node_spanned_pages = end_pfn - start_pfn;
 
@@ -961,6 +968,7 @@ void __init do_init_bootmem(void)
   		dbg("start_paddr = %lx\n", start_pfn << PAGE_SHIFT);
   		dbg("end_paddr = %lx\n", end_pfn << PAGE_SHIFT);
 
+#ifndef CONFIG_NO_BOOTMEM
 		bootmap_pages = bootmem_bootmap_pages(end_pfn - start_pfn);
 		bootmem_vaddr = careful_zallocation(nid,
 					bootmap_pages << PAGE_SHIFT,
@@ -979,6 +987,7 @@ void __init do_init_bootmem(void)
 		 * done correctly.
 		 */
 		mark_reserved_regions_for_nid(nid);
+#endif
 		sparse_memory_present_with_active_regions(nid);
 	}
 
-- 
1.6.4.2

