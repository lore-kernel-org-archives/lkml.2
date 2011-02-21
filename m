Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1BUI1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:27:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56654 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1BUI1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CDc024NlLZp3Nq/q/TFI7GI4Qut/x+HAfDIl+WrhIU6YCQbHkmHOr9Ez0qWOmaAIfe
         bo2FDMsILoBhy+JavtQiRqvGZQoXrptE9hz8O8riD3QJh7qokPYJkxJKILifv9OqIEI/
         eHggExNQikM18V9kZT2YTA7mfTpqjM8P3C0js=
Date: Mon, 21 Feb 2011 09:26:57 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH UPDATED 2/3 tip:x86/mm] x86-64, NUMA: Move NUMA emulation
 into numa_emulation.c
Message-ID: <20110221082657.GA31267@htj.dyndns.org>
References: <20110218135836.GG21209@htj.dyndns.org>
 <20110218135939.GH21209@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218135939.GH21209@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create numa_emulation.c and move all NUMA emulation code there.  The
definitions of struct numa_memblk and numa_meminfo are moved to
numa_64.h.  Also, numa_remove_memblk_from(), numa_cleanup_meminfo(),
numa_reset_distance() along with numa_emulation() are made global.

- v2: Internal declarations moved to numa_internal.h as suggested by
      Yinghai.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
Yinghai, does it look okay to you?

Thanks.

 arch/x86/mm/Makefile         |    1 
 arch/x86/mm/numa_64.c        |  480 -------------------------------------------
 arch/x86/mm/numa_emulation.c |  452 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/numa_internal.h  |   31 ++
 4 files changed, 488 insertions(+), 476 deletions(-)

Index: work/arch/x86/mm/Makefile
===================================================================
--- work.orig/arch/x86/mm/Makefile
+++ work/arch/x86/mm/Makefile
@@ -25,6 +25,7 @@ obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmio
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
 obj-$(CONFIG_AMD_NUMA)		+= amdtopology_64.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
+obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
 
Index: work/arch/x86/mm/numa_64.c
===================================================================
--- work.orig/arch/x86/mm/numa_64.c
+++ work/arch/x86/mm/numa_64.c
@@ -18,20 +18,10 @@
 #include <asm/e820.h>
 #include <asm/proto.h>
 #include <asm/dma.h>
-#include <asm/numa.h>
 #include <asm/acpi.h>
 #include <asm/amd_nb.h>
 
-struct numa_memblk {
-	u64			start;
-	u64			end;
-	int			nid;
-};
-
-struct numa_meminfo {
-	int			nr_blks;
-	struct numa_memblk	blk[NR_NODE_MEMBLKS];
-};
+#include "numa_internal.h"
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
@@ -215,7 +205,7 @@ static int __init numa_add_memblk_to(int
 	return 0;
 }
 
-static void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
+void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi)
 {
 	mi->nr_blks--;
 	memmove(&mi->blk[idx], &mi->blk[idx + 1],
@@ -273,7 +263,7 @@ setup_node_bootmem(int nodeid, unsigned
 	node_set_online(nodeid);
 }
 
-static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
+int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
 	const u64 low = 0;
 	const u64 high = (u64)max_pfn << PAGE_SHIFT;
@@ -367,7 +357,7 @@ static void __init numa_nodemask_from_me
  * Reset distance table.  The current table is freed.  The next
  * numa_set_distance() call will create a new one.
  */
-static void __init numa_reset_distance(void)
+void __init numa_reset_distance(void)
 {
 	size_t size;
 
@@ -533,388 +523,6 @@ static int __init numa_register_memblks(
 	return 0;
 }
 
-#ifdef CONFIG_NUMA_EMU
-/* Numa emulation */
-static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
-static char *emu_cmdline __initdata;
-
-void __init numa_emu_cmdline(char *str)
-{
-	emu_cmdline = str;
-}
-
-static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
-{
-	int i;
-
-	for (i = 0; i < mi->nr_blks; i++)
-		if (mi->blk[i].nid == nid)
-			return i;
-	return -ENOENT;
-}
-
-/*
- * Sets up nid to range from @start to @end.  The return value is -errno if
- * something went wrong, 0 otherwise.
- */
-static int __init emu_setup_memblk(struct numa_meminfo *ei,
-				   struct numa_meminfo *pi,
-				   int nid, int phys_blk, u64 size)
-{
-	struct numa_memblk *eb = &ei->blk[ei->nr_blks];
-	struct numa_memblk *pb = &pi->blk[phys_blk];
-
-	if (ei->nr_blks >= NR_NODE_MEMBLKS) {
-		pr_err("NUMA: Too many emulated memblks, failing emulation\n");
-		return -EINVAL;
-	}
-
-	ei->nr_blks++;
-	eb->start = pb->start;
-	eb->end = pb->start + size;
-	eb->nid = nid;
-
-	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
-		emu_nid_to_phys[nid] = pb->nid;
-
-	pb->start += size;
-	if (pb->start >= pb->end) {
-		WARN_ON_ONCE(pb->start > pb->end);
-		numa_remove_memblk_from(phys_blk, pi);
-	}
-
-	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
-	       eb->start, eb->end, (eb->end - eb->start) >> 20);
-	return 0;
-}
-
-/*
- * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
- * to max_addr.  The return value is the number of nodes allocated.
- */
-static int __init split_nodes_interleave(struct numa_meminfo *ei,
-					 struct numa_meminfo *pi,
-					 u64 addr, u64 max_addr, int nr_nodes)
-{
-	nodemask_t physnode_mask = NODE_MASK_NONE;
-	u64 size;
-	int big;
-	int nid = 0;
-	int i, ret;
-
-	if (nr_nodes <= 0)
-		return -1;
-	if (nr_nodes > MAX_NUMNODES) {
-		pr_info("numa=fake=%d too large, reducing to %d\n",
-			nr_nodes, MAX_NUMNODES);
-		nr_nodes = MAX_NUMNODES;
-	}
-
-	size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) / nr_nodes;
-	/*
-	 * Calculate the number of big nodes that can be allocated as a result
-	 * of consolidating the remainder.
-	 */
-	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
-		FAKE_NODE_MIN_SIZE;
-
-	size &= FAKE_NODE_MIN_HASH_MASK;
-	if (!size) {
-		pr_err("Not enough memory for each node.  "
-			"NUMA emulation disabled.\n");
-		return -1;
-	}
-
-	for (i = 0; i < pi->nr_blks; i++)
-		node_set(pi->blk[i].nid, physnode_mask);
-
-	/*
-	 * Continue to fill physical nodes with fake nodes until there is no
-	 * memory left on any of them.
-	 */
-	while (nodes_weight(physnode_mask)) {
-		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
-			u64 start, limit, end;
-			int phys_blk;
-
-			phys_blk = emu_find_memblk_by_nid(i, pi);
-			if (phys_blk < 0) {
-				node_clear(i, physnode_mask);
-				continue;
-			}
-			start = pi->blk[phys_blk].start;
-			limit = pi->blk[phys_blk].end;
-			end = start + size;
-
-			if (nid < big)
-				end += FAKE_NODE_MIN_SIZE;
-
-			/*
-			 * Continue to add memory to this fake node if its
-			 * non-reserved memory is less than the per-node size.
-			 */
-			while (end - start -
-			       memblock_x86_hole_size(start, end) < size) {
-				end += FAKE_NODE_MIN_SIZE;
-				if (end > limit) {
-					end = limit;
-					break;
-				}
-			}
-
-			/*
-			 * If there won't be at least FAKE_NODE_MIN_SIZE of
-			 * non-reserved memory in ZONE_DMA32 for the next node,
-			 * this one must extend to the boundary.
-			 */
-			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
-				end = dma32_end;
-
-			/*
-			 * If there won't be enough non-reserved memory for the
-			 * next node, this one must extend to the end of the
-			 * physical node.
-			 */
-			if (limit - end -
-			    memblock_x86_hole_size(end, limit) < size)
-				end = limit;
-
-			ret = emu_setup_memblk(ei, pi, nid++ % nr_nodes,
-					       phys_blk,
-					       min(end, limit) - start);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	return 0;
-}
-
-/*
- * Returns the end address of a node so that there is at least `size' amount of
- * non-reserved memory or `max_addr' is reached.
- */
-static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
-{
-	u64 end = start + size;
-
-	while (end - start - memblock_x86_hole_size(start, end) < size) {
-		end += FAKE_NODE_MIN_SIZE;
-		if (end > max_addr) {
-			end = max_addr;
-			break;
-		}
-	}
-	return end;
-}
-
-/*
- * Sets up fake nodes of `size' interleaved over physical nodes ranging from
- * `addr' to `max_addr'.  The return value is the number of nodes allocated.
- */
-static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
-					      struct numa_meminfo *pi,
-					      u64 addr, u64 max_addr, u64 size)
-{
-	nodemask_t physnode_mask = NODE_MASK_NONE;
-	u64 min_size;
-	int nid = 0;
-	int i, ret;
-
-	if (!size)
-		return -1;
-	/*
-	 * The limit on emulated nodes is MAX_NUMNODES, so the size per node is
-	 * increased accordingly if the requested size is too small.  This
-	 * creates a uniform distribution of node sizes across the entire
-	 * machine (but not necessarily over physical nodes).
-	 */
-	min_size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) /
-						MAX_NUMNODES;
-	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
-	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
-		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
-						FAKE_NODE_MIN_HASH_MASK;
-	if (size < min_size) {
-		pr_err("Fake node size %LuMB too small, increasing to %LuMB\n",
-			size >> 20, min_size >> 20);
-		size = min_size;
-	}
-	size &= FAKE_NODE_MIN_HASH_MASK;
-
-	for (i = 0; i < pi->nr_blks; i++)
-		node_set(pi->blk[i].nid, physnode_mask);
-
-	/*
-	 * Fill physical nodes with fake nodes of size until there is no memory
-	 * left on any of them.
-	 */
-	while (nodes_weight(physnode_mask)) {
-		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
-			u64 start, limit, end;
-			int phys_blk;
-
-			phys_blk = emu_find_memblk_by_nid(i, pi);
-			if (phys_blk < 0) {
-				node_clear(i, physnode_mask);
-				continue;
-			}
-			start = pi->blk[phys_blk].start;
-			limit = pi->blk[phys_blk].end;
-
-			end = find_end_of_node(start, limit, size);
-			/*
-			 * If there won't be at least FAKE_NODE_MIN_SIZE of
-			 * non-reserved memory in ZONE_DMA32 for the next node,
-			 * this one must extend to the boundary.
-			 */
-			if (end < dma32_end && dma32_end - end -
-			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
-				end = dma32_end;
-
-			/*
-			 * If there won't be enough non-reserved memory for the
-			 * next node, this one must extend to the end of the
-			 * physical node.
-			 */
-			if (limit - end -
-			    memblock_x86_hole_size(end, limit) < size)
-				end = limit;
-
-			ret = emu_setup_memblk(ei, pi, nid++ % MAX_NUMNODES,
-					       phys_blk,
-					       min(end, limit) - start);
-			if (ret < 0)
-				return ret;
-		}
-	}
-	return 0;
-}
-
-/*
- * Sets up the system RAM area from start_pfn to last_pfn according to the
- * numa=fake command-line option.
- */
-static void __init numa_emulation(struct numa_meminfo *numa_meminfo,
-				  int numa_dist_cnt)
-{
-	static struct numa_meminfo ei __initdata;
-	static struct numa_meminfo pi __initdata;
-	const u64 max_addr = max_pfn << PAGE_SHIFT;
-	u8 *phys_dist = NULL;
-	int i, j, ret;
-
-	if (!emu_cmdline)
-		goto no_emu;
-
-	memset(&ei, 0, sizeof(ei));
-	pi = *numa_meminfo;
-
-	for (i = 0; i < MAX_NUMNODES; i++)
-		emu_nid_to_phys[i] = NUMA_NO_NODE;
-
-	/*
-	 * If the numa=fake command-line contains a 'M' or 'G', it represents
-	 * the fixed node size.  Otherwise, if it is just a single number N,
-	 * split the system RAM into N fake nodes.
-	 */
-	if (strchr(emu_cmdline, 'M') || strchr(emu_cmdline, 'G')) {
-		u64 size;
-
-		size = memparse(emu_cmdline, &emu_cmdline);
-		ret = split_nodes_size_interleave(&ei, &pi, 0, max_addr, size);
-	} else {
-		unsigned long n;
-
-		n = simple_strtoul(emu_cmdline, NULL, 0);
-		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
-	}
-
-	if (ret < 0)
-		goto no_emu;
-
-	if (numa_cleanup_meminfo(&ei) < 0) {
-		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
-		goto no_emu;
-	}
-
-	/*
-	 * Copy the original distance table.  It's temporary so no need to
-	 * reserve it.
-	 */
-	if (numa_dist_cnt) {
-		size_t size = numa_dist_cnt * sizeof(phys_dist[0]);
-		u64 phys;
-
-		phys = memblock_find_in_range(0,
-					      (u64)max_pfn_mapped << PAGE_SHIFT,
-					      size, PAGE_SIZE);
-		if (phys == MEMBLOCK_ERROR) {
-			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
-			goto no_emu;
-		}
-		phys_dist = __va(phys);
-
-		for (i = 0; i < numa_dist_cnt; i++)
-			for (j = 0; j < numa_dist_cnt; j++)
-				phys_dist[i * numa_dist_cnt + j] =
-					node_distance(i, j);
-	}
-
-	/* commit */
-	*numa_meminfo = ei;
-
-	/*
-	 * Transform __apicid_to_node table to use emulated nids by
-	 * reverse-mapping phys_nid.  The maps should always exist but fall
-	 * back to zero just in case.
-	 */
-	for (i = 0; i < ARRAY_SIZE(__apicid_to_node); i++) {
-		if (__apicid_to_node[i] == NUMA_NO_NODE)
-			continue;
-		for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
-			if (__apicid_to_node[i] == emu_nid_to_phys[j])
-				break;
-		__apicid_to_node[i] = j < ARRAY_SIZE(emu_nid_to_phys) ? j : 0;
-	}
-
-	/* make sure all emulated nodes are mapped to a physical node */
-	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
-		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
-			emu_nid_to_phys[i] = 0;
-
-	/* transform distance table */
-	numa_reset_distance();
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		for (j = 0; j < MAX_NUMNODES; j++) {
-			int physi = emu_nid_to_phys[i];
-			int physj = emu_nid_to_phys[j];
-			int dist;
-
-			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
-				dist = physi == physj ?
-					LOCAL_DISTANCE : REMOTE_DISTANCE;
-			else
-				dist = phys_dist[physi * numa_dist_cnt + physj];
-
-			numa_set_distance(i, j, dist);
-		}
-	}
-	return;
-
-no_emu:
-	/* No emulation.  Build identity emu_nid_to_phys[] for numa_add_cpu() */
-	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
-		emu_nid_to_phys[i] = i;
-}
-#else	/* CONFIG_NUMA_EMU */
-static inline void numa_emulation(struct numa_meminfo *numa_meminfo,
-				  int numa_dist_cnt)
-{ }
-#endif	/* CONFIG_NUMA_EMU */
-
 static int __init dummy_numa_init(void)
 {
 	printk(KERN_INFO "%s\n",
@@ -1002,83 +610,3 @@ int __cpuinit numa_cpu_node(int cpu)
 		return __apicid_to_node[apicid];
 	return NUMA_NO_NODE;
 }
-
-/*
- * UGLINESS AHEAD: Currently, CONFIG_NUMA_EMU is 64bit only and makes use
- * of 64bit specific data structures.  The distinction is artificial and
- * should be removed.  numa_{add|remove}_cpu() are implemented in numa.c
- * for both 32 and 64bit when CONFIG_NUMA_EMU is disabled but here when
- * enabled.
- *
- * NUMA emulation is planned to be made generic and the following and other
- * related code should be moved to numa.c.
- */
-#ifdef CONFIG_NUMA_EMU
-# ifndef CONFIG_DEBUG_PER_CPU_MAPS
-void __cpuinit numa_add_cpu(int cpu)
-{
-	int physnid, nid;
-
-	nid = numa_cpu_node(cpu);
-	if (nid == NUMA_NO_NODE)
-		nid = early_cpu_to_node(cpu);
-	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
-
-	physnid = emu_nid_to_phys[nid];
-
-	/*
-	 * Map the cpu to each emulated node that is allocated on the physical
-	 * node of the cpu's apic id.
-	 */
-	for_each_online_node(nid)
-		if (emu_nid_to_phys[nid] == physnid)
-			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	int i;
-
-	for_each_online_node(i)
-		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
-}
-# else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	struct cpumask *mask;
-	int nid, physnid, i;
-
-	nid = early_cpu_to_node(cpu);
-	if (nid == NUMA_NO_NODE) {
-		/* early_cpu_to_node() already emits a warning and trace */
-		return;
-	}
-
-	physnid = emu_nid_to_phys[nid];
-
-	for_each_online_node(i) {
-		if (emu_nid_to_phys[nid] != physnid)
-			continue;
-
-		mask = debug_cpumask_set_cpu(cpu, enable);
-		if (!mask)
-			return;
-
-		if (enable)
-			cpumask_set_cpu(cpu, mask);
-		else
-			cpumask_clear_cpu(cpu, mask);
-	}
-}
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
-}
-# endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
-#endif	/* CONFIG_NUMA_EMU */
Index: work/arch/x86/mm/numa_emulation.c
===================================================================
--- /dev/null
+++ work/arch/x86/mm/numa_emulation.c
@@ -0,0 +1,452 @@
+/*
+ * NUMA emulation
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/topology.h>
+#include <linux/memblock.h>
+#include <asm/dma.h>
+
+#include "numa_internal.h"
+
+static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
+static char *emu_cmdline __initdata;
+
+void __init numa_emu_cmdline(char *str)
+{
+	emu_cmdline = str;
+}
+
+static int __init emu_find_memblk_by_nid(int nid, const struct numa_meminfo *mi)
+{
+	int i;
+
+	for (i = 0; i < mi->nr_blks; i++)
+		if (mi->blk[i].nid == nid)
+			return i;
+	return -ENOENT;
+}
+
+/*
+ * Sets up nid to range from @start to @end.  The return value is -errno if
+ * something went wrong, 0 otherwise.
+ */
+static int __init emu_setup_memblk(struct numa_meminfo *ei,
+				   struct numa_meminfo *pi,
+				   int nid, int phys_blk, u64 size)
+{
+	struct numa_memblk *eb = &ei->blk[ei->nr_blks];
+	struct numa_memblk *pb = &pi->blk[phys_blk];
+
+	if (ei->nr_blks >= NR_NODE_MEMBLKS) {
+		pr_err("NUMA: Too many emulated memblks, failing emulation\n");
+		return -EINVAL;
+	}
+
+	ei->nr_blks++;
+	eb->start = pb->start;
+	eb->end = pb->start + size;
+	eb->nid = nid;
+
+	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
+		emu_nid_to_phys[nid] = pb->nid;
+
+	pb->start += size;
+	if (pb->start >= pb->end) {
+		WARN_ON_ONCE(pb->start > pb->end);
+		numa_remove_memblk_from(phys_blk, pi);
+	}
+
+	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
+	       eb->start, eb->end, (eb->end - eb->start) >> 20);
+	return 0;
+}
+
+/*
+ * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
+ * to max_addr.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_interleave(struct numa_meminfo *ei,
+					 struct numa_meminfo *pi,
+					 u64 addr, u64 max_addr, int nr_nodes)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 size;
+	int big;
+	int nid = 0;
+	int i, ret;
+
+	if (nr_nodes <= 0)
+		return -1;
+	if (nr_nodes > MAX_NUMNODES) {
+		pr_info("numa=fake=%d too large, reducing to %d\n",
+			nr_nodes, MAX_NUMNODES);
+		nr_nodes = MAX_NUMNODES;
+	}
+
+	size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) / nr_nodes;
+	/*
+	 * Calculate the number of big nodes that can be allocated as a result
+	 * of consolidating the remainder.
+	 */
+	big = ((size & ~FAKE_NODE_MIN_HASH_MASK) * nr_nodes) /
+		FAKE_NODE_MIN_SIZE;
+
+	size &= FAKE_NODE_MIN_HASH_MASK;
+	if (!size) {
+		pr_err("Not enough memory for each node.  "
+			"NUMA emulation disabled.\n");
+		return -1;
+	}
+
+	for (i = 0; i < pi->nr_blks; i++)
+		node_set(pi->blk[i].nid, physnode_mask);
+
+	/*
+	 * Continue to fill physical nodes with fake nodes until there is no
+	 * memory left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
+			u64 start, limit, end;
+			int phys_blk;
+
+			phys_blk = emu_find_memblk_by_nid(i, pi);
+			if (phys_blk < 0) {
+				node_clear(i, physnode_mask);
+				continue;
+			}
+			start = pi->blk[phys_blk].start;
+			limit = pi->blk[phys_blk].end;
+			end = start + size;
+
+			if (nid < big)
+				end += FAKE_NODE_MIN_SIZE;
+
+			/*
+			 * Continue to add memory to this fake node if its
+			 * non-reserved memory is less than the per-node size.
+			 */
+			while (end - start -
+			       memblock_x86_hole_size(start, end) < size) {
+				end += FAKE_NODE_MIN_SIZE;
+				if (end > limit) {
+					end = limit;
+					break;
+				}
+			}
+
+			/*
+			 * If there won't be at least FAKE_NODE_MIN_SIZE of
+			 * non-reserved memory in ZONE_DMA32 for the next node,
+			 * this one must extend to the boundary.
+			 */
+			if (end < dma32_end && dma32_end - end -
+			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+				end = dma32_end;
+
+			/*
+			 * If there won't be enough non-reserved memory for the
+			 * next node, this one must extend to the end of the
+			 * physical node.
+			 */
+			if (limit - end -
+			    memblock_x86_hole_size(end, limit) < size)
+				end = limit;
+
+			ret = emu_setup_memblk(ei, pi, nid++ % nr_nodes,
+					       phys_blk,
+					       min(end, limit) - start);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Returns the end address of a node so that there is at least `size' amount of
+ * non-reserved memory or `max_addr' is reached.
+ */
+static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
+{
+	u64 end = start + size;
+
+	while (end - start - memblock_x86_hole_size(start, end) < size) {
+		end += FAKE_NODE_MIN_SIZE;
+		if (end > max_addr) {
+			end = max_addr;
+			break;
+		}
+	}
+	return end;
+}
+
+/*
+ * Sets up fake nodes of `size' interleaved over physical nodes ranging from
+ * `addr' to `max_addr'.  The return value is the number of nodes allocated.
+ */
+static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
+					      struct numa_meminfo *pi,
+					      u64 addr, u64 max_addr, u64 size)
+{
+	nodemask_t physnode_mask = NODE_MASK_NONE;
+	u64 min_size;
+	int nid = 0;
+	int i, ret;
+
+	if (!size)
+		return -1;
+	/*
+	 * The limit on emulated nodes is MAX_NUMNODES, so the size per node is
+	 * increased accordingly if the requested size is too small.  This
+	 * creates a uniform distribution of node sizes across the entire
+	 * machine (but not necessarily over physical nodes).
+	 */
+	min_size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) /
+						MAX_NUMNODES;
+	min_size = max(min_size, FAKE_NODE_MIN_SIZE);
+	if ((min_size & FAKE_NODE_MIN_HASH_MASK) < min_size)
+		min_size = (min_size + FAKE_NODE_MIN_SIZE) &
+						FAKE_NODE_MIN_HASH_MASK;
+	if (size < min_size) {
+		pr_err("Fake node size %LuMB too small, increasing to %LuMB\n",
+			size >> 20, min_size >> 20);
+		size = min_size;
+	}
+	size &= FAKE_NODE_MIN_HASH_MASK;
+
+	for (i = 0; i < pi->nr_blks; i++)
+		node_set(pi->blk[i].nid, physnode_mask);
+
+	/*
+	 * Fill physical nodes with fake nodes of size until there is no memory
+	 * left on any of them.
+	 */
+	while (nodes_weight(physnode_mask)) {
+		for_each_node_mask(i, physnode_mask) {
+			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
+			u64 start, limit, end;
+			int phys_blk;
+
+			phys_blk = emu_find_memblk_by_nid(i, pi);
+			if (phys_blk < 0) {
+				node_clear(i, physnode_mask);
+				continue;
+			}
+			start = pi->blk[phys_blk].start;
+			limit = pi->blk[phys_blk].end;
+
+			end = find_end_of_node(start, limit, size);
+			/*
+			 * If there won't be at least FAKE_NODE_MIN_SIZE of
+			 * non-reserved memory in ZONE_DMA32 for the next node,
+			 * this one must extend to the boundary.
+			 */
+			if (end < dma32_end && dma32_end - end -
+			    memblock_x86_hole_size(end, dma32_end) < FAKE_NODE_MIN_SIZE)
+				end = dma32_end;
+
+			/*
+			 * If there won't be enough non-reserved memory for the
+			 * next node, this one must extend to the end of the
+			 * physical node.
+			 */
+			if (limit - end -
+			    memblock_x86_hole_size(end, limit) < size)
+				end = limit;
+
+			ret = emu_setup_memblk(ei, pi, nid++ % MAX_NUMNODES,
+					       phys_blk,
+					       min(end, limit) - start);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return 0;
+}
+
+/*
+ * Sets up the system RAM area from start_pfn to last_pfn according to the
+ * numa=fake command-line option.
+ */
+void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
+{
+	static struct numa_meminfo ei __initdata;
+	static struct numa_meminfo pi __initdata;
+	const u64 max_addr = max_pfn << PAGE_SHIFT;
+	u8 *phys_dist = NULL;
+	int i, j, ret;
+
+	if (!emu_cmdline)
+		goto no_emu;
+
+	memset(&ei, 0, sizeof(ei));
+	pi = *numa_meminfo;
+
+	for (i = 0; i < MAX_NUMNODES; i++)
+		emu_nid_to_phys[i] = NUMA_NO_NODE;
+
+	/*
+	 * If the numa=fake command-line contains a 'M' or 'G', it represents
+	 * the fixed node size.  Otherwise, if it is just a single number N,
+	 * split the system RAM into N fake nodes.
+	 */
+	if (strchr(emu_cmdline, 'M') || strchr(emu_cmdline, 'G')) {
+		u64 size;
+
+		size = memparse(emu_cmdline, &emu_cmdline);
+		ret = split_nodes_size_interleave(&ei, &pi, 0, max_addr, size);
+	} else {
+		unsigned long n;
+
+		n = simple_strtoul(emu_cmdline, NULL, 0);
+		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
+	}
+
+	if (ret < 0)
+		goto no_emu;
+
+	if (numa_cleanup_meminfo(&ei) < 0) {
+		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
+		goto no_emu;
+	}
+
+	/*
+	 * Copy the original distance table.  It's temporary so no need to
+	 * reserve it.
+	 */
+	if (numa_dist_cnt) {
+		size_t size = numa_dist_cnt * sizeof(phys_dist[0]);
+		u64 phys;
+
+		phys = memblock_find_in_range(0,
+					      (u64)max_pfn_mapped << PAGE_SHIFT,
+					      size, PAGE_SIZE);
+		if (phys == MEMBLOCK_ERROR) {
+			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
+			goto no_emu;
+		}
+		phys_dist = __va(phys);
+
+		for (i = 0; i < numa_dist_cnt; i++)
+			for (j = 0; j < numa_dist_cnt; j++)
+				phys_dist[i * numa_dist_cnt + j] =
+					node_distance(i, j);
+	}
+
+	/* commit */
+	*numa_meminfo = ei;
+
+	/*
+	 * Transform __apicid_to_node table to use emulated nids by
+	 * reverse-mapping phys_nid.  The maps should always exist but fall
+	 * back to zero just in case.
+	 */
+	for (i = 0; i < ARRAY_SIZE(__apicid_to_node); i++) {
+		if (__apicid_to_node[i] == NUMA_NO_NODE)
+			continue;
+		for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
+			if (__apicid_to_node[i] == emu_nid_to_phys[j])
+				break;
+		__apicid_to_node[i] = j < ARRAY_SIZE(emu_nid_to_phys) ? j : 0;
+	}
+
+	/* make sure all emulated nodes are mapped to a physical node */
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
+		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
+			emu_nid_to_phys[i] = 0;
+
+	/* transform distance table */
+	numa_reset_distance();
+	for (i = 0; i < MAX_NUMNODES; i++) {
+		for (j = 0; j < MAX_NUMNODES; j++) {
+			int physi = emu_nid_to_phys[i];
+			int physj = emu_nid_to_phys[j];
+			int dist;
+
+			if (physi >= numa_dist_cnt || physj >= numa_dist_cnt)
+				dist = physi == physj ?
+					LOCAL_DISTANCE : REMOTE_DISTANCE;
+			else
+				dist = phys_dist[physi * numa_dist_cnt + physj];
+
+			numa_set_distance(i, j, dist);
+		}
+	}
+	return;
+
+no_emu:
+	/* No emulation.  Build identity emu_nid_to_phys[] for numa_add_cpu() */
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
+		emu_nid_to_phys[i] = i;
+}
+
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+void __cpuinit numa_add_cpu(int cpu)
+{
+	int physnid, nid;
+
+	nid = numa_cpu_node(cpu);
+	if (nid == NUMA_NO_NODE)
+		nid = early_cpu_to_node(cpu);
+	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
+
+	physnid = emu_nid_to_phys[nid];
+
+	/*
+	 * Map the cpu to each emulated node that is allocated on the physical
+	 * node of the cpu's apic id.
+	 */
+	for_each_online_node(nid)
+		if (emu_nid_to_phys[nid] == physnid)
+			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	int i;
+
+	for_each_online_node(i)
+		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
+}
+#else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	struct cpumask *mask;
+	int nid, physnid, i;
+
+	nid = early_cpu_to_node(cpu);
+	if (nid == NUMA_NO_NODE) {
+		/* early_cpu_to_node() already emits a warning and trace */
+		return;
+	}
+
+	physnid = emu_nid_to_phys[nid];
+
+	for_each_online_node(i) {
+		if (emu_nid_to_phys[nid] != physnid)
+			continue;
+
+		mask = debug_cpumask_set_cpu(cpu, enable);
+		if (!mask)
+			return;
+
+		if (enable)
+			cpumask_set_cpu(cpu, mask);
+		else
+			cpumask_clear_cpu(cpu, mask);
+	}
+}
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
+#endif	/* !CONFIG_DEBUG_PER_CPU_MAPS */
Index: work/arch/x86/mm/numa_internal.h
===================================================================
--- /dev/null
+++ work/arch/x86/mm/numa_internal.h
@@ -0,0 +1,31 @@
+#ifndef __X86_MM_NUMA_INTERNAL_H
+#define __X86_MM_NUMA_INTERNAL_H
+
+#include <linux/types.h>
+#include <asm/numa.h>
+
+struct numa_memblk {
+	u64			start;
+	u64			end;
+	int			nid;
+};
+
+struct numa_meminfo {
+	int			nr_blks;
+	struct numa_memblk	blk[NR_NODE_MEMBLKS];
+};
+
+void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
+int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
+void __init numa_reset_distance(void);
+
+#ifdef CONFIG_NUMA_EMU
+void __init numa_emulation(struct numa_meminfo *numa_meminfo,
+			   int numa_dist_cnt);
+#else
+static inline void numa_emulation(struct numa_meminfo *numa_meminfo,
+				  int numa_dist_cnt)
+{ }
+#endif
+
+#endif	/* __X86_MM_NUMA_INTERNAL_H */
