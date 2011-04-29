Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1D2Pb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:31:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060Ab1D2P3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=tKm3g7BEF4IPCVCkLfO8UHdKRxiBdK98xY9C284S0T/oXA/JcqgSgqQm//JlOhNCf+
         l1mOAZ6/tPl7TYrSccw85A5LhkAGZiQvxJHa8vb/ZcMZuIEN9I9nIe58gM31rGhY3AzH
         cis/hG4t9t34b9zrPfgqXdbryxh8sTGC6pyVM=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/25] x86, NUMA: Move NUMA init logic from numa_64.c to numa.c
Date: Fri, 29 Apr 2011 17:28:35 +0200
Message-Id: <1304090924-8197-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the generic 64bit NUMA init machinery from numa_64.c to numa.c.

* node_data[], numa_mem_info and numa_distance
* numa_add_memblk[_to](), numa_remove_memblk[_from]()
* numa_set_distance() and friends
* numa_init() and all the numa_meminfo handling helpers called from it
* dummy_numa_init()
* memory_add_physaddr_to_nid()

A new function x86_numa_init() is added and the content of
numa_64.c::initmem_init() is moved into it.  initmem_init() now simply
calls x86_numa_init().

Constants and numa_off declaration are moved from numa_{32|64}.h to
numa.h.

This is code reorganization and doesn't involve any functional change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/numa.h    |   16 ++
 arch/x86/include/asm/numa_32.h |    2 -
 arch/x86/include/asm/numa_64.h |   19 --
 arch/x86/mm/numa.c             |  523 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/mm/numa_64.c          |  503 +--------------------------------------
 arch/x86/mm/numa_internal.h    |    2 +
 6 files changed, 539 insertions(+), 526 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 6959c27..c1934fc 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -9,6 +9,16 @@
 #ifdef CONFIG_NUMA
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
+#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
+
+/*
+ * Too small node sizes may confuse the VM badly. Usually they
+ * result from BIOS bugs. So dont recognize nodes as standalone
+ * NUMA entities that have less than this amount of RAM listed:
+ */
+#define NODE_MIN_SIZE (4*1024*1024)
+
+extern int numa_off;
 
 /*
  * __apicid_to_node[] stores the raw mapping between physical apicid and
@@ -68,4 +78,10 @@ static inline void numa_remove_cpu(int cpu)		{ }
 struct cpumask __cpuinit *debug_cpumask_set_cpu(int cpu, int enable);
 #endif
 
+#ifdef CONFIG_NUMA_EMU
+#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+void numa_emu_cmdline(char *);
+#endif /* CONFIG_NUMA_EMU */
+
 #endif	/* _ASM_X86_NUMA_H */
diff --git a/arch/x86/include/asm/numa_32.h b/arch/x86/include/asm/numa_32.h
index 7e54b64..e7d6b82 100644
--- a/arch/x86/include/asm/numa_32.h
+++ b/arch/x86/include/asm/numa_32.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_NUMA_32_H
 #define _ASM_X86_NUMA_32_H
 
-extern int numa_off;
-
 #ifdef CONFIG_HIGHMEM
 extern void set_highmem_pages_init(void);
 #else
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 506dd05..0c05f7a 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -1,25 +1,6 @@
 #ifndef _ASM_X86_NUMA_64_H
 #define _ASM_X86_NUMA_64_H
 
-#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
-
-extern int numa_off;
-
 extern unsigned long numa_free_all_bootmem(void);
 
-#ifdef CONFIG_NUMA
-/*
- * Too small node sizes may confuse the VM badly. Usually they
- * result from BIOS bugs. So dont recognize nodes as standalone
- * NUMA entities that have less than this amount of RAM listed:
- */
-#define NODE_MIN_SIZE (4*1024*1024)
-
-#ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
-void numa_emu_cmdline(char *);
-#endif /* CONFIG_NUMA_EMU */
-#endif
-
 #endif /* _ASM_X86_NUMA_64_H */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 74d8f90..3b20547 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -1,13 +1,42 @@
 /* Common code for 32 and 64-bit NUMA */
-#include <linux/topology.h>
-#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/init.h>
 #include <linux/bootmem.h>
-#include <asm/numa.h>
+#include <linux/memblock.h>
+#include <linux/mmzone.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/nodemask.h>
+#include <linux/sched.h>
+#include <linux/topology.h>
+
+#include <asm/e820.h>
+#include <asm/proto.h>
+#include <asm/dma.h>
 #include <asm/acpi.h>
+#include <asm/amd_nb.h>
+
+#include "numa_internal.h"
 
 int __initdata numa_off;
 nodemask_t numa_nodes_parsed __initdata;
 
+#ifdef CONFIG_X86_64
+struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_data);
+
+static struct numa_meminfo numa_meminfo
+#ifndef CONFIG_MEMORY_HOTPLUG
+__initdata
+#endif
+;
+
+static int numa_distance_cnt;
+static u8 *numa_distance;
+#endif
+
 static __init int numa_setup(char *opt)
 {
 	if (!opt)
@@ -105,6 +134,392 @@ void __init setup_node_to_cpumask_map(void)
 	pr_debug("Node to cpumask map for %d nodes\n", nr_node_ids);
 }
 
+#ifdef CONFIG_X86_64
+static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
+				     struct numa_meminfo *mi)
+{
+	/* ignore zero length blks */
+	if (start == end)
+		return 0;
+
+	/* whine about and ignore invalid blks */
+	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
+		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
+			   nid, start, end);
+		return 0;
+	}
+
+	if (mi->nr_blks >= NR_NODE_MEMBLKS) {
+		pr_err("NUMA: too many memblk ranges\n");
+		return -EINVAL;
+	}
+
+	mi->blk[mi->nr_blks].start = start;
+	mi->blk[mi->nr_blks].end = end;
+	mi->blk[mi->nr_blks].nid = nid;
+	mi->nr_blks++;
+	return 0;
+}
+
+/**
+ * numa_remove_memblk_from - Remove one numa_memblk from a numa_meminfo
+ * @idx: Index of memblk to remove
+ * @mi: numa_meminfo to remove memblk from
+ *
+ * Remove @idx'th numa_memblk from @mi by shifting @mi->blk[] and
+ * decrementing @mi->nr_blks.
+ */
+void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
+{
+	mi->nr_blks--;
+	memmove(&mi->blk[idx], &mi->blk[idx + 1],
+		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
+}
+
+/**
+ * numa_add_memblk - Add one numa_memblk to numa_meminfo
+ * @nid: NUMA node ID of the new memblk
+ * @start: Start address of the new memblk
+ * @end: End address of the new memblk
+ *
+ * Add a new memblk to the default numa_meminfo.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init numa_add_memblk(int nid, u64 start, u64 end)
+{
+	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+}
+
+/* Initialize bootmem allocator for a node */
+static void __init
+setup_node_bootmem(int nid, unsigned long start, unsigned long end)
+{
+	const u64 nd_low = (u64)MAX_DMA_PFN << PAGE_SHIFT;
+	const u64 nd_high = (u64)max_pfn_mapped << PAGE_SHIFT;
+	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+	unsigned long nd_pa;
+	int tnid;
+
+	/*
+	 * Don't confuse VM with a node that doesn't have the
+	 * minimum amount of memory:
+	 */
+	if (end && (end - start) < NODE_MIN_SIZE)
+		return;
+
+	start = roundup(start, ZONE_ALIGN);
+
+	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n",
+	       nid, start, end);
+
+	/*
+	 * Try to allocate node data on local node and then fall back to
+	 * all nodes.  Never allocate in DMA zone.
+	 */
+	nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
+						nd_size, SMP_CACHE_BYTES);
+	if (nd_pa == MEMBLOCK_ERROR)
+		nd_pa = memblock_find_in_range(nd_low, nd_high,
+					       nd_size, SMP_CACHE_BYTES);
+	if (nd_pa == MEMBLOCK_ERROR) {
+		pr_err("Cannot find %lu bytes in node %d\n", nd_size, nid);
+		return;
+	}
+	memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
+
+	/* report and initialize */
+	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n",
+	       nd_pa, nd_pa + nd_size - 1);
+	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
+	if (tnid != nid)
+		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
+
+	node_data[nid] = __va(nd_pa);
+	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
+	NODE_DATA(nid)->node_id = nid;
+	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
+	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
+
+	node_set_online(nid);
+}
+
+/**
+ * numa_cleanup_meminfo - Cleanup a numa_meminfo
+ * @mi: numa_meminfo to clean up
+ *
+ * Sanitize @mi by merging and removing unncessary memblks.  Also check for
+ * conflicts and clear unused memblks.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
+{
+	const u64 low = 0;
+	const u64 high = (u64)max_pfn << PAGE_SHIFT;
+	int i, j, k;
+
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *bi = &mi->blk[i];
+
+		/* make sure all blocks are inside the limits */
+		bi->start = max(bi->start, low);
+		bi->end = min(bi->end, high);
+
+		/* and there's no empty block */
+		if (bi->start == bi->end) {
+			numa_remove_memblk_from(i--, mi);
+			continue;
+		}
+
+		for (j = i + 1; j < mi->nr_blks; j++) {
+			struct numa_memblk *bj = &mi->blk[j];
+			unsigned long start, end;
+
+			/*
+			 * See whether there are overlapping blocks.  Whine
+			 * about but allow overlaps of the same nid.  They
+			 * will be merged below.
+			 */
+			if (bi->end > bj->start && bi->start < bj->end) {
+				if (bi->nid != bj->nid) {
+					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
+					       bi->nid, bi->start, bi->end,
+					       bj->nid, bj->start, bj->end);
+					return -EINVAL;
+				}
+				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
+					   bi->nid, bi->start, bi->end,
+					   bj->start, bj->end);
+			}
+
+			/*
+			 * Join together blocks on the same node, holes
+			 * between which don't overlap with memory on other
+			 * nodes.
+			 */
+			if (bi->nid != bj->nid)
+				continue;
+			start = max(min(bi->start, bj->start), low);
+			end = min(max(bi->end, bj->end), high);
+			for (k = 0; k < mi->nr_blks; k++) {
+				struct numa_memblk *bk = &mi->blk[k];
+
+				if (bi->nid == bk->nid)
+					continue;
+				if (start < bk->end && end > bk->start)
+					break;
+			}
+			if (k < mi->nr_blks)
+				continue;
+			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
+			       bi->nid, bi->start, bi->end, bj->start, bj->end,
+			       start, end);
+			bi->start = start;
+			bi->end = end;
+			numa_remove_memblk_from(j--, mi);
+		}
+	}
+
+	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
+		mi->blk[i].start = mi->blk[i].end = 0;
+		mi->blk[i].nid = NUMA_NO_NODE;
+	}
+
+	return 0;
+}
+
+/*
+ * Set nodes, which have memory in @mi, in *@nodemask.
+ */
+static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
+					      const struct numa_meminfo *mi)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
+		if (mi->blk[i].start != mi->blk[i].end &&
+		    mi->blk[i].nid != NUMA_NO_NODE)
+			node_set(mi->blk[i].nid, *nodemask);
+}
+
+/**
+ * numa_reset_distance - Reset NUMA distance table
+ *
+ * The current table is freed.  The next numa_set_distance() call will
+ * create a new one.
+ */
+void __init numa_reset_distance(void)
+{
+	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
+
+	/* numa_distance could be 1LU marking allocation failure, test cnt */
+	if (numa_distance_cnt)
+		memblock_x86_free_range(__pa(numa_distance),
+					__pa(numa_distance) + size);
+	numa_distance_cnt = 0;
+	numa_distance = NULL;	/* enable table creation */
+}
+
+static int __init numa_alloc_distance(void)
+{
+	nodemask_t nodes_parsed;
+	size_t size;
+	int i, j, cnt = 0;
+	u64 phys;
+
+	/* size the new table and allocate it */
+	nodes_parsed = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
+
+	for_each_node_mask(i, nodes_parsed)
+		cnt = i;
+	cnt++;
+	size = cnt * cnt * sizeof(numa_distance[0]);
+
+	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
+				      size, PAGE_SIZE);
+	if (phys == MEMBLOCK_ERROR) {
+		pr_warning("NUMA: Warning: can't allocate distance table!\n");
+		/* don't retry until explicitly reset */
+		numa_distance = (void *)1LU;
+		return -ENOMEM;
+	}
+	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
+
+	numa_distance = __va(phys);
+	numa_distance_cnt = cnt;
+
+	/* fill with the default distances */
+	for (i = 0; i < cnt; i++)
+		for (j = 0; j < cnt; j++)
+			numa_distance[i * cnt + j] = i == j ?
+				LOCAL_DISTANCE : REMOTE_DISTANCE;
+	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
+
+	return 0;
+}
+
+/**
+ * numa_set_distance - Set NUMA distance from one NUMA to another
+ * @from: the 'from' node to set distance
+ * @to: the 'to'  node to set distance
+ * @distance: NUMA distance
+ *
+ * Set the distance from node @from to @to to @distance.  If distance table
+ * doesn't exist, one which is large enough to accommodate all the currently
+ * known nodes will be created.
+ *
+ * If such table cannot be allocated, a warning is printed and further
+ * calls are ignored until the distance table is reset with
+ * numa_reset_distance().
+ *
+ * If @from or @to is higher than the highest known node at the time of
+ * table creation or @distance doesn't make sense, the call is ignored.
+ * This is to allow simplification of specific NUMA config implementations.
+ */
+void __init numa_set_distance(int from, int to, int distance)
+{
+	if (!numa_distance && numa_alloc_distance() < 0)
+		return;
+
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
+		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
+			    from, to, distance);
+		return;
+	}
+
+	if ((u8)distance != distance ||
+	    (from == to && distance != LOCAL_DISTANCE)) {
+		pr_warn_once("NUMA: Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
+			     from, to, distance);
+		return;
+	}
+
+	numa_distance[from * numa_distance_cnt + to] = distance;
+}
+
+int __node_distance(int from, int to)
+{
+	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
+	return numa_distance[from * numa_distance_cnt + to];
+}
+EXPORT_SYMBOL(__node_distance);
+
+/*
+ * Sanity check to catch more bad NUMA configurations (they are amazingly
+ * common).  Make sure the nodes cover all memory.
+ */
+static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
+{
+	unsigned long numaram, e820ram;
+	int i;
+
+	numaram = 0;
+	for (i = 0; i < mi->nr_blks; i++) {
+		unsigned long s = mi->blk[i].start >> PAGE_SHIFT;
+		unsigned long e = mi->blk[i].end >> PAGE_SHIFT;
+		numaram += e - s;
+		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
+		if ((long)numaram < 0)
+			numaram = 0;
+	}
+
+	e820ram = max_pfn - (memblock_x86_hole_size(0,
+					max_pfn << PAGE_SHIFT) >> PAGE_SHIFT);
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
+		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
+		       (numaram << PAGE_SHIFT) >> 20,
+		       (e820ram << PAGE_SHIFT) >> 20);
+		return false;
+	}
+	return true;
+}
+
+static int __init numa_register_memblks(struct numa_meminfo *mi)
+{
+	int i, nid;
+
+	/* Account for nodes with cpus and no memory */
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
+	if (WARN_ON(nodes_empty(node_possible_map)))
+		return -EINVAL;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		memblock_x86_register_active_regions(mi->blk[i].nid,
+					mi->blk[i].start >> PAGE_SHIFT,
+					mi->blk[i].end >> PAGE_SHIFT);
+
+	/* for out of order entries */
+	sort_node_map();
+	if (!numa_meminfo_cover_memory(mi))
+		return -EINVAL;
+
+	/* Finally register nodes. */
+	for_each_node_mask(nid, node_possible_map) {
+		u64 start = (u64)max_pfn << PAGE_SHIFT;
+		u64 end = 0;
+
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
+				continue;
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
+		}
+
+		if (start < end)
+			setup_node_bootmem(nid, start, end);
+	}
+
+	return 0;
+}
+#endif
+
 /*
  * There are unfortunately some poorly designed mainboards around that
  * only connect memory to a single CPU. This breaks the 1:1 cpu->node
@@ -127,6 +542,93 @@ void __init numa_init_array(void)
 	}
 }
 
+#ifdef CONFIG_X86_64
+static int __init numa_init(int (*init_func)(void))
+{
+	int i;
+	int ret;
+
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, NUMA_NO_NODE);
+
+	nodes_clear(numa_nodes_parsed);
+	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
+	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
+	remove_all_active_ranges();
+	numa_reset_distance();
+
+	ret = init_func();
+	if (ret < 0)
+		return ret;
+	ret = numa_cleanup_meminfo(&numa_meminfo);
+	if (ret < 0)
+		return ret;
+
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
+
+	ret = numa_register_memblks(&numa_meminfo);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < nr_cpu_ids; i++) {
+		int nid = early_cpu_to_node(i);
+
+		if (nid == NUMA_NO_NODE)
+			continue;
+		if (!node_online(nid))
+			numa_clear_node(i);
+	}
+	numa_init_array();
+	return 0;
+}
+
+/**
+ * dummy_numa_init - Fallback dummy NUMA init
+ *
+ * Used if there's no underlying NUMA architecture, NUMA initialization
+ * fails, or NUMA is disabled on the command line.
+ *
+ * Must online at least one node and add memory blocks that cover all
+ * allowed memory.  This function must not fail.
+ */
+static int __init dummy_numa_init(void)
+{
+	printk(KERN_INFO "%s\n",
+	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
+	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
+	       0LU, max_pfn << PAGE_SHIFT);
+
+	node_set(0, numa_nodes_parsed);
+	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
+
+	return 0;
+}
+
+/**
+ * x86_numa_init - Initialize NUMA
+ *
+ * Try each configured NUMA initialization method until one succeeds.  The
+ * last fallback is dummy single node config encomapssing whole memory and
+ * never fails.
+ */
+void __init x86_numa_init(void)
+{
+	if (!numa_off) {
+#ifdef CONFIG_ACPI_NUMA
+		if (!numa_init(x86_acpi_numa_init))
+			return;
+#endif
+#ifdef CONFIG_AMD_NUMA
+		if (!numa_init(amd_numa_init))
+			return;
+#endif
+	}
+
+	numa_init(dummy_numa_init);
+}
+#endif
+
 static __init int find_near_online_node(int node)
 {
 	int n, val;
@@ -297,3 +799,18 @@ const struct cpumask *cpumask_of_node(int node)
 EXPORT_SYMBOL(cpumask_of_node);
 
 #endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_MEMORY_HOTPLUG)
+int memory_add_physaddr_to_nid(u64 start)
+{
+	struct numa_meminfo *mi = &numa_meminfo;
+	int nid = mi->blk[0].nid;
+	int i;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (mi->blk[i].start <= start && mi->blk[i].end > start)
+			nid = mi->blk[i].nid;
+	return nid;
+}
+EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+#endif
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 8d84f9c..dd27f40 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -2,499 +2,13 @@
  * Generic VM initialization for x86-64 NUMA setups.
  * Copyright 2002,2003 Andi Kleen, SuSE Labs.
  */
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/string.h>
-#include <linux/init.h>
 #include <linux/bootmem.h>
-#include <linux/memblock.h>
-#include <linux/mmzone.h>
-#include <linux/ctype.h>
-#include <linux/module.h>
-#include <linux/nodemask.h>
-#include <linux/sched.h>
-#include <linux/acpi.h>
-
-#include <asm/e820.h>
-#include <asm/proto.h>
-#include <asm/dma.h>
-#include <asm/acpi.h>
-#include <asm/amd_nb.h>
 
 #include "numa_internal.h"
 
-struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_data);
-
-static struct numa_meminfo numa_meminfo
-#ifndef CONFIG_MEMORY_HOTPLUG
-__initdata
-#endif
-;
-
-static int numa_distance_cnt;
-static u8 *numa_distance;
-
-static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
-				     struct numa_meminfo *mi)
-{
-	/* ignore zero length blks */
-	if (start == end)
-		return 0;
-
-	/* whine about and ignore invalid blks */
-	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
-		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
-			   nid, start, end);
-		return 0;
-	}
-
-	if (mi->nr_blks >= NR_NODE_MEMBLKS) {
-		pr_err("NUMA: too many memblk ranges\n");
-		return -EINVAL;
-	}
-
-	mi->blk[mi->nr_blks].start = start;
-	mi->blk[mi->nr_blks].end = end;
-	mi->blk[mi->nr_blks].nid = nid;
-	mi->nr_blks++;
-	return 0;
-}
-
-/**
- * numa_remove_memblk_from - Remove one numa_memblk from a numa_meminfo
- * @idx: Index of memblk to remove
- * @mi: numa_meminfo to remove memblk from
- *
- * Remove @idx'th numa_memblk from @mi by shifting @mi->blk[] and
- * decrementing @mi->nr_blks.
- */
-void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
-{
-	mi->nr_blks--;
-	memmove(&mi->blk[idx], &mi->blk[idx + 1],
-		(mi->nr_blks - idx) * sizeof(mi->blk[0]));
-}
-
-/**
- * numa_add_memblk - Add one numa_memblk to numa_meminfo
- * @nid: NUMA node ID of the new memblk
- * @start: Start address of the new memblk
- * @end: End address of the new memblk
- *
- * Add a new memblk to the default numa_meminfo.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int __init numa_add_memblk(int nid, u64 start, u64 end)
-{
-	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
-}
-
-/* Initialize bootmem allocator for a node */
-static void __init
-setup_node_bootmem(int nid, unsigned long start, unsigned long end)
-{
-	const u64 nd_low = (u64)MAX_DMA_PFN << PAGE_SHIFT;
-	const u64 nd_high = (u64)max_pfn_mapped << PAGE_SHIFT;
-	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
-	unsigned long nd_pa;
-	int tnid;
-
-	/*
-	 * Don't confuse VM with a node that doesn't have the
-	 * minimum amount of memory:
-	 */
-	if (end && (end - start) < NODE_MIN_SIZE)
-		return;
-
-	start = roundup(start, ZONE_ALIGN);
-
-	printk(KERN_INFO "Initmem setup node %d %016lx-%016lx\n",
-	       nid, start, end);
-
-	/*
-	 * Try to allocate node data on local node and then fall back to
-	 * all nodes.  Never allocate in DMA zone.
-	 */
-	nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
-						nd_size, SMP_CACHE_BYTES);
-	if (nd_pa == MEMBLOCK_ERROR)
-		nd_pa = memblock_find_in_range(nd_low, nd_high,
-					       nd_size, SMP_CACHE_BYTES);
-	if (nd_pa == MEMBLOCK_ERROR) {
-		pr_err("Cannot find %lu bytes in node %d\n", nd_size, nid);
-		return;
-	}
-	memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
-
-	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [%016lx - %016lx]\n",
-	       nd_pa, nd_pa + nd_size - 1);
-	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
-		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
-
-	node_data[nid] = __va(nd_pa);
-	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
-	NODE_DATA(nid)->node_id = nid;
-	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
-	NODE_DATA(nid)->node_spanned_pages = (end - start) >> PAGE_SHIFT;
-
-	node_set_online(nid);
-}
-
-/**
- * numa_cleanup_meminfo - Cleanup a numa_meminfo
- * @mi: numa_meminfo to clean up
- *
- * Sanitize @mi by merging and removing unncessary memblks.  Also check for
- * conflicts and clear unused memblks.
- *
- * RETURNS:
- * 0 on success, -errno on failure.
- */
-int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
-{
-	const u64 low = 0;
-	const u64 high = (u64)max_pfn << PAGE_SHIFT;
-	int i, j, k;
-
-	for (i = 0; i < mi->nr_blks; i++) {
-		struct numa_memblk *bi = &mi->blk[i];
-
-		/* make sure all blocks are inside the limits */
-		bi->start = max(bi->start, low);
-		bi->end = min(bi->end, high);
-
-		/* and there's no empty block */
-		if (bi->start == bi->end) {
-			numa_remove_memblk_from(i--, mi);
-			continue;
-		}
-
-		for (j = i + 1; j < mi->nr_blks; j++) {
-			struct numa_memblk *bj = &mi->blk[j];
-			unsigned long start, end;
-
-			/*
-			 * See whether there are overlapping blocks.  Whine
-			 * about but allow overlaps of the same nid.  They
-			 * will be merged below.
-			 */
-			if (bi->end > bj->start && bi->start < bj->end) {
-				if (bi->nid != bj->nid) {
-					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
-					       bi->nid, bi->start, bi->end,
-					       bj->nid, bj->start, bj->end);
-					return -EINVAL;
-				}
-				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
-					   bi->nid, bi->start, bi->end,
-					   bj->start, bj->end);
-			}
-
-			/*
-			 * Join together blocks on the same node, holes
-			 * between which don't overlap with memory on other
-			 * nodes.
-			 */
-			if (bi->nid != bj->nid)
-				continue;
-			start = max(min(bi->start, bj->start), low);
-			end = min(max(bi->end, bj->end), high);
-			for (k = 0; k < mi->nr_blks; k++) {
-				struct numa_memblk *bk = &mi->blk[k];
-
-				if (bi->nid == bk->nid)
-					continue;
-				if (start < bk->end && end > bk->start)
-					break;
-			}
-			if (k < mi->nr_blks)
-				continue;
-			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
-			       bi->nid, bi->start, bi->end, bj->start, bj->end,
-			       start, end);
-			bi->start = start;
-			bi->end = end;
-			numa_remove_memblk_from(j--, mi);
-		}
-	}
-
-	for (i = mi->nr_blks; i < ARRAY_SIZE(mi->blk); i++) {
-		mi->blk[i].start = mi->blk[i].end = 0;
-		mi->blk[i].nid = NUMA_NO_NODE;
-	}
-
-	return 0;
-}
-
-/*
- * Set nodes, which have memory in @mi, in *@nodemask.
- */
-static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
-					      const struct numa_meminfo *mi)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
-		if (mi->blk[i].start != mi->blk[i].end &&
-		    mi->blk[i].nid != NUMA_NO_NODE)
-			node_set(mi->blk[i].nid, *nodemask);
-}
-
-/**
- * numa_reset_distance - Reset NUMA distance table
- *
- * The current table is freed.  The next numa_set_distance() call will
- * create a new one.
- */
-void __init numa_reset_distance(void)
-{
-	size_t size = numa_distance_cnt * numa_distance_cnt * sizeof(numa_distance[0]);
-
-	/* numa_distance could be 1LU marking allocation failure, test cnt */
-	if (numa_distance_cnt)
-		memblock_x86_free_range(__pa(numa_distance),
-					__pa(numa_distance) + size);
-	numa_distance_cnt = 0;
-	numa_distance = NULL;	/* enable table creation */
-}
-
-static int __init numa_alloc_distance(void)
-{
-	nodemask_t nodes_parsed;
-	size_t size;
-	int i, j, cnt = 0;
-	u64 phys;
-
-	/* size the new table and allocate it */
-	nodes_parsed = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
-
-	for_each_node_mask(i, nodes_parsed)
-		cnt = i;
-	cnt++;
-	size = cnt * cnt * sizeof(numa_distance[0]);
-
-	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
-				      size, PAGE_SIZE);
-	if (phys == MEMBLOCK_ERROR) {
-		pr_warning("NUMA: Warning: can't allocate distance table!\n");
-		/* don't retry until explicitly reset */
-		numa_distance = (void *)1LU;
-		return -ENOMEM;
-	}
-	memblock_x86_reserve_range(phys, phys + size, "NUMA DIST");
-
-	numa_distance = __va(phys);
-	numa_distance_cnt = cnt;
-
-	/* fill with the default distances */
-	for (i = 0; i < cnt; i++)
-		for (j = 0; j < cnt; j++)
-			numa_distance[i * cnt + j] = i == j ?
-				LOCAL_DISTANCE : REMOTE_DISTANCE;
-	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
-
-	return 0;
-}
-
-/**
- * numa_set_distance - Set NUMA distance from one NUMA to another
- * @from: the 'from' node to set distance
- * @to: the 'to'  node to set distance
- * @distance: NUMA distance
- *
- * Set the distance from node @from to @to to @distance.  If distance table
- * doesn't exist, one which is large enough to accommodate all the currently
- * known nodes will be created.
- *
- * If such table cannot be allocated, a warning is printed and further
- * calls are ignored until the distance table is reset with
- * numa_reset_distance().
- *
- * If @from or @to is higher than the highest known node at the time of
- * table creation or @distance doesn't make sense, the call is ignored.
- * This is to allow simplification of specific NUMA config implementations.
- */
-void __init numa_set_distance(int from, int to, int distance)
-{
-	if (!numa_distance && numa_alloc_distance() < 0)
-		return;
-
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
-		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
-			    from, to, distance);
-		return;
-	}
-
-	if ((u8)distance != distance ||
-	    (from == to && distance != LOCAL_DISTANCE)) {
-		pr_warn_once("NUMA: Warning: invalid distance parameter, from=%d to=%d distance=%d\n",
-			     from, to, distance);
-		return;
-	}
-
-	numa_distance[from * numa_distance_cnt + to] = distance;
-}
-
-int __node_distance(int from, int to)
-{
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
-		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
-	return numa_distance[from * numa_distance_cnt + to];
-}
-EXPORT_SYMBOL(__node_distance);
-
-/*
- * Sanity check to catch more bad NUMA configurations (they are amazingly
- * common).  Make sure the nodes cover all memory.
- */
-static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
-{
-	unsigned long numaram, e820ram;
-	int i;
-
-	numaram = 0;
-	for (i = 0; i < mi->nr_blks; i++) {
-		unsigned long s = mi->blk[i].start >> PAGE_SHIFT;
-		unsigned long e = mi->blk[i].end >> PAGE_SHIFT;
-		numaram += e - s;
-		numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
-		if ((long)numaram < 0)
-			numaram = 0;
-	}
-
-	e820ram = max_pfn - (memblock_x86_hole_size(0,
-					max_pfn << PAGE_SHIFT) >> PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
-		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
-		       (numaram << PAGE_SHIFT) >> 20,
-		       (e820ram << PAGE_SHIFT) >> 20);
-		return false;
-	}
-	return true;
-}
-
-static int __init numa_register_memblks(struct numa_meminfo *mi)
-{
-	int i, nid;
-
-	/* Account for nodes with cpus and no memory */
-	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
-	if (WARN_ON(nodes_empty(node_possible_map)))
-		return -EINVAL;
-
-	for (i = 0; i < mi->nr_blks; i++)
-		memblock_x86_register_active_regions(mi->blk[i].nid,
-					mi->blk[i].start >> PAGE_SHIFT,
-					mi->blk[i].end >> PAGE_SHIFT);
-
-	/* for out of order entries */
-	sort_node_map();
-	if (!numa_meminfo_cover_memory(mi))
-		return -EINVAL;
-
-	/* Finally register nodes. */
-	for_each_node_mask(nid, node_possible_map) {
-		u64 start = (u64)max_pfn << PAGE_SHIFT;
-		u64 end = 0;
-
-		for (i = 0; i < mi->nr_blks; i++) {
-			if (nid != mi->blk[i].nid)
-				continue;
-			start = min(mi->blk[i].start, start);
-			end = max(mi->blk[i].end, end);
-		}
-
-		if (start < end)
-			setup_node_bootmem(nid, start, end);
-	}
-
-	return 0;
-}
-
-/**
- * dummy_numma_init - Fallback dummy NUMA init
- *
- * Used if there's no underlying NUMA architecture, NUMA initialization
- * fails, or NUMA is disabled on the command line.
- *
- * Must online at least one node and add memory blocks that cover all
- * allowed memory.  This function must not fail.
- */
-static int __init dummy_numa_init(void)
-{
-	printk(KERN_INFO "%s\n",
-	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
-	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
-	       0LU, max_pfn << PAGE_SHIFT);
-
-	node_set(0, numa_nodes_parsed);
-	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
-
-	return 0;
-}
-
-static int __init numa_init(int (*init_func)(void))
-{
-	int i;
-	int ret;
-
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		set_apicid_to_node(i, NUMA_NO_NODE);
-
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	remove_all_active_ranges();
-	numa_reset_distance();
-
-	ret = init_func();
-	if (ret < 0)
-		return ret;
-	ret = numa_cleanup_meminfo(&numa_meminfo);
-	if (ret < 0)
-		return ret;
-
-	numa_emulation(&numa_meminfo, numa_distance_cnt);
-
-	ret = numa_register_memblks(&numa_meminfo);
-	if (ret < 0)
-		return ret;
-
-	for (i = 0; i < nr_cpu_ids; i++) {
-		int nid = early_cpu_to_node(i);
-
-		if (nid == NUMA_NO_NODE)
-			continue;
-		if (!node_online(nid))
-			numa_clear_node(i);
-	}
-	numa_init_array();
-	return 0;
-}
-
 void __init initmem_init(void)
 {
-	if (!numa_off) {
-#ifdef CONFIG_ACPI_NUMA
-		if (!numa_init(x86_acpi_numa_init))
-			return;
-#endif
-#ifdef CONFIG_AMD_NUMA
-		if (!numa_init(amd_numa_init))
-			return;
-#endif
-	}
-
-	numa_init(dummy_numa_init);
+	x86_numa_init();
 }
 
 unsigned long __init numa_free_all_bootmem(void)
@@ -509,18 +23,3 @@ unsigned long __init numa_free_all_bootmem(void)
 
 	return pages;
 }
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-int memory_add_physaddr_to_nid(u64 start)
-{
-	struct numa_meminfo *mi = &numa_meminfo;
-	int nid = mi->blk[0].nid;
-	int i;
-
-	for (i = 0; i < mi->nr_blks; i++)
-		if (mi->blk[i].start <= start && mi->blk[i].end > start)
-			nid = mi->blk[i].nid;
-	return nid;
-}
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
-#endif
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
index ef2d973..ad86ec9 100644
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -19,6 +19,8 @@ void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
 void __init numa_reset_distance(void);
 
+void __init x86_numa_init(void);
+
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
 			   int numa_dist_cnt);
-- 
1.7.1

