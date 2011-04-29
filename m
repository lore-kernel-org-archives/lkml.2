Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab1D2PaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:30:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488Ab1D2P33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YJcNttkW3X8x+BaYeWvCg2i6AaHx/PxJYTf46gXZ7ZRCTV1tu5cCTtUCSMtuCfk/WG
         sJZHqxFOvDW1MgTSR3tOHio4sDCN7wlJTstroWUxqPnHwTAu0U7sZCP0kmigzA53m4df
         y2RkLyz6ZpXFZtrJhucFkFavehUGtWzLuGNH0=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 21/25] x86, NUMA: Make 32bit use common NUMA init path
Date: Fri, 29 Apr 2011 17:28:40 +0200
Message-Id: <1304090924-8197-22-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With both _numa_init() methods converted and the rest of init code
adjusted, numa_32.c now can switch from the 32bit only init code to
the common one in numa.c.

* Shim get_memcfg_*()'s are dropped and initmem_init() calls
  x86_numa_init(), which is updated to handle NUMAQ.

* All boilerplate operations including node range limiting, pgdat
  alloc/init are handled by numa_init().  32bit only implementation is
  removed.

* 32bit numa_add_memblk(), numa_set_distance() and
  memory_add_physaddr_to_nid() removed and common versions in
  numa_32.c enabled for 32bit.

This change causes the following behavior changes.

* NODE_DATA()->node_start_pfn/node_spanned_pages properly initialized
  for 32bit too.

* Much more sanity checks and configuration cleanups.

* Proper handling of node distances.

* The same NUMA init messages as 64bit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/topology.h |    7 -
 arch/x86/mm/numa.c              |   10 +-
 arch/x86/mm/numa_32.c           |  232 +--------------------------------------
 3 files changed, 7 insertions(+), 242 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 8dba769..c006924 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -93,18 +93,11 @@ extern void setup_node_to_cpumask_map(void);
 #define pcibus_to_node(bus) __pcibus_to_node(bus)
 
 #ifdef CONFIG_X86_32
-extern unsigned long node_start_pfn[];
-extern unsigned long node_end_pfn[];
-#define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
-
 # define SD_CACHE_NICE_TRIES	1
 # define SD_IDLE_IDX		1
-
 #else
-
 # define SD_CACHE_NICE_TRIES	2
 # define SD_IDLE_IDX		2
-
 #endif
 
 /* sched_domains SD_NODE_INIT for NUMA machines */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a37b382..e6bc804 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -173,7 +173,6 @@ void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
 		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
 }
 
-#ifdef CONFIG_X86_64
 /**
  * numa_add_memblk - Add one numa_memblk to numa_meminfo
  * @nid: NUMA node ID of the new memblk
@@ -189,7 +188,6 @@ int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
 	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
 }
-#endif
 
 /* Initialize bootmem allocator for a node */
 static void __init setup_node_bootmem(int nid, u64 start, u64 end)
@@ -413,7 +411,6 @@ static int __init numa_alloc_distance(void)
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
 /**
  * numa_set_distance - Set NUMA distance from one NUMA to another
  * @from: the 'from' node to set distance
@@ -452,7 +449,6 @@ void __init numa_set_distance(int from, int to, int distance)
 
 	numa_distance[from * numa_distance_cnt + to] = distance;
 }
-#endif
 
 int __node_distance(int from, int to)
 {
@@ -626,6 +622,10 @@ static int __init dummy_numa_init(void)
 void __init x86_numa_init(void)
 {
 	if (!numa_off) {
+#ifdef CONFIG_X86_NUMAQ
+		if (!numa_init(numaq_numa_init))
+			return;
+#endif
 #ifdef CONFIG_ACPI_NUMA
 		if (!numa_init(x86_acpi_numa_init))
 			return;
@@ -810,7 +810,7 @@ EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_MEMORY_HOTPLUG)
+#ifdef CONFIG_MEMORY_HOTPLUG
 int memory_add_physaddr_to_nid(u64 start)
 {
 	struct numa_meminfo *mi = &numa_meminfo;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index fbd558f..c930e41 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -22,36 +22,10 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/memblock.h>
-#include <linux/mmzone.h>
-#include <linux/highmem.h>
-#include <linux/initrd.h>
-#include <linux/nodemask.h>
-#include <linux/module.h>
-#include <linux/kexec.h>
-#include <linux/pfn.h>
-#include <linux/swap.h>
-#include <linux/acpi.h>
-
-#include <asm/e820.h>
-#include <asm/setup.h>
-#include <asm/mmzone.h>
-#include <asm/bios_ebda.h>
-#include <asm/proto.h>
-
-/*
- * numa interface - we expect the numa architecture specific code to have
- *                  populated the following initialisation.
- *
- * 1) node_online_map  - the map of all nodes configured (online) in the system
- * 2) node_start_pfn   - the starting page frame number for a node
- * 3) node_end_pfn     - the ending page fram number for a node
- */
-unsigned long node_start_pfn[MAX_NUMNODES] __read_mostly;
-unsigned long node_end_pfn[MAX_NUMNODES] __read_mostly;
 
+#include "numa_internal.h"
 
 #ifdef CONFIG_DISCONTIGMEM
 /*
@@ -96,7 +70,6 @@ unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
 }
 #endif
 
-extern unsigned long find_max_low_pfn(void);
 extern unsigned long highend_pfn, highstart_pfn;
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
@@ -105,68 +78,6 @@ static void *node_remap_start_vaddr[MAX_NUMNODES];
 void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
 /*
- * FLAT - support for basic PC memory model with discontig enabled, essentially
- *        a single node with all available processors in it with a flat
- *        memory map.
- */
-static int __init get_memcfg_numa_flat(void)
-{
-	printk(KERN_DEBUG "NUMA - single node, flat memory mode\n");
-
-	node_start_pfn[0] = 0;
-	node_end_pfn[0] = max_pfn;
-	memblock_x86_register_active_regions(0, 0, max_pfn);
-
-        /* Indicate there is one node available. */
-	nodes_clear(node_online_map);
-	node_set_online(0);
-	return 1;
-}
-
-/*
- * Find the highest page frame number we have available for the node
- */
-static void __init propagate_e820_map_node(int nid)
-{
-	if (node_end_pfn[nid] > max_pfn)
-		node_end_pfn[nid] = max_pfn;
-	/*
-	 * if a user has given mem=XXXX, then we need to make sure 
-	 * that the node _starts_ before that, too, not just ends
-	 */
-	if (node_start_pfn[nid] > max_pfn)
-		node_start_pfn[nid] = max_pfn;
-	BUG_ON(node_start_pfn[nid] > node_end_pfn[nid]);
-}
-
-/* 
- * Allocate memory for the pg_data_t for this node via a crude pre-bootmem
- * method.  For node zero take this from the bottom of memory, for
- * subsequent nodes place them at node_remap_start_vaddr which contains
- * node local data in physically node local memory.  See setup_memory()
- * for details.
- */
-static void __init allocate_pgdat(int nid)
-{
-	char buf[16];
-
-	NODE_DATA(nid) = alloc_remap(nid, ALIGN(sizeof(pg_data_t), PAGE_SIZE));
-	if (!NODE_DATA(nid)) {
-		unsigned long pgdat_phys;
-		pgdat_phys = memblock_find_in_range(min_low_pfn<<PAGE_SHIFT,
-				 max_pfn_mapped<<PAGE_SHIFT,
-				 sizeof(pg_data_t),
-				 PAGE_SIZE);
-		NODE_DATA(nid) = (pg_data_t *)(pfn_to_kaddr(pgdat_phys>>PAGE_SHIFT));
-		memset(buf, 0, sizeof(buf));
-		sprintf(buf, "NODE_DATA %d",  nid);
-		memblock_x86_reserve_range(pgdat_phys, pgdat_phys + sizeof(pg_data_t), buf);
-	}
-	printk(KERN_DEBUG "allocate_pgdat: node %d NODE_DATA %08lx\n",
-		nid, (unsigned long)NODE_DATA(nid));
-}
-
-/*
  * Remap memory allocator
  */
 static unsigned long node_remap_start_pfn[MAX_NUMNODES];
@@ -322,76 +233,9 @@ void __init init_alloc_remap(int nid, u64 start, u64 end)
 	       nid, node_pa, node_pa + size, remap_va, remap_va + size);
 }
 
-static int get_memcfg_numaq(void)
-{
-#ifdef CONFIG_X86_NUMAQ
-	int nid;
-
-	if (numa_off)
-		return 0;
-
-	if (numaq_numa_init() < 0) {
-		nodes_clear(numa_nodes_parsed);
-		remove_all_active_ranges();
-		return 0;
-	}
-
-	for_each_node_mask(nid, numa_nodes_parsed)
-		node_set_online(nid);
-	sort_node_map();
-	return 1;
-#else
-	return 0;
-#endif
-}
-
-static int get_memcfg_from_srat(void)
-{
-#ifdef CONFIG_ACPI_NUMA
-	int nid;
-
-	if (numa_off)
-		return 0;
-
-	if (x86_acpi_numa_init() < 0) {
-		nodes_clear(numa_nodes_parsed);
-		remove_all_active_ranges();
-		return 0;
-	}
-
-	for_each_node_mask(nid, numa_nodes_parsed)
-		node_set_online(nid);
-	sort_node_map();
-	return 1;
-#else
-	return 0;
-#endif
-}
-
-static void get_memcfg_numa(void)
-{
-	if (get_memcfg_numaq())
-		return;
-	if (get_memcfg_from_srat())
-		return;
-	get_memcfg_numa_flat();
-}
-
 void __init initmem_init(void)
 {
-	int nid;
-
-	get_memcfg_numa();
-	numa_init_array();
-
-	for_each_online_node(nid) {
-		u64 start = (u64)node_start_pfn[nid] << PAGE_SHIFT;
-		u64 end = min((u64)node_end_pfn[nid] << PAGE_SHIFT,
-			      (u64)max_pfn << PAGE_SHIFT);
-
-		if (start < end)
-			init_alloc_remap(nid, start, end);
-	}
+	x86_numa_init();
 
 #ifdef CONFIG_HIGHMEM
 	highstart_pfn = highend_pfn = max_pfn;
@@ -412,81 +256,9 @@ void __init initmem_init(void)
 
 	printk(KERN_DEBUG "Low memory ends at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(max_low_pfn));
-	for_each_online_node(nid)
-		allocate_pgdat(nid);
 
 	printk(KERN_DEBUG "High memory starts at vaddr %08lx\n",
 			(ulong) pfn_to_kaddr(highstart_pfn));
-	for_each_online_node(nid)
-		propagate_e820_map_node(nid);
-
-	for_each_online_node(nid) {
-		memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
-		NODE_DATA(nid)->node_id = nid;
-	}
 
 	setup_bootmem_allocator();
 }
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-static int paddr_to_nid(u64 addr)
-{
-	int nid;
-	unsigned long pfn = PFN_DOWN(addr);
-
-	for_each_node(nid)
-		if (node_start_pfn[nid] <= pfn &&
-		    pfn < node_end_pfn[nid])
-			return nid;
-
-	return -1;
-}
-
-/*
- * This function is used to ask node id BEFORE memmap and mem_section's
- * initialization (pfn_to_nid() can't be used yet).
- * If _PXM is not defined on ACPI's DSDT, node id must be found by this.
- */
-int memory_add_physaddr_to_nid(u64 addr)
-{
-	int nid = paddr_to_nid(addr);
-	return (nid >= 0) ? nid : 0;
-}
-
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
-
-/* temporary shim, will go away soon */
-int __init numa_add_memblk(int nid, u64 start, u64 end)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long end_pfn = end >> PAGE_SHIFT;
-
-	printk(KERN_DEBUG "nid %d start_pfn %08lx end_pfn %08lx\n",
-	       nid, start_pfn, end_pfn);
-
-	if (start >= (u64)max_pfn << PAGE_SHIFT) {
-		printk(KERN_INFO "Ignoring SRAT pfns: %08lx - %08lx\n",
-		       start_pfn, end_pfn);
-		return 0;
-	}
-
-	node_set_online(nid);
-	memblock_x86_register_active_regions(nid, start_pfn,
-					     min(end_pfn, max_pfn));
-
-	if (!node_has_online_mem(nid)) {
-		node_start_pfn[nid] = start_pfn;
-		node_end_pfn[nid] = end_pfn;
-	} else {
-		node_start_pfn[nid] = min(node_start_pfn[nid], start_pfn);
-		node_end_pfn[nid] = max(node_end_pfn[nid], end_pfn);
-	}
-	return 0;
-}
-
-/* temporary shim, will go away soon */
-void __init numa_set_distance(int from, int to, int distance)
-{
-	/* nada */
-}
-- 
1.7.1

