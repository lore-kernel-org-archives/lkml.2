Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab1BPMWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:22:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37715 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1BPMWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:22:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LMWIwo0N+YphOaDXahx+FEl0iJGPiVe8MD1/8gscRSXCd8YlNre5JjroDb6gSkqN+9
         ofLG2NFy1pfiZj54VysVmVyIylt9MCPABE4OfYBvB8glJy7LqtcC1ArM9FbYoMSmRBFE
         P2oX85VGHI7se7+3Ma39fZ4C1slDeTBHAUzUk=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 31/33] x86-64, NUMA: Emulate directly from numa_meminfo
Date: Wed, 16 Feb 2011 13:21:05 +0100
Message-Id: <1297858867-25981-32-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA emulation built physnodes[] array which could only represent
configurations from the physical meminfo and emulated nodes using the
information.  There's no reason to take this extra level of
indirection.  Update emulation functions so that they operate directly
on numa_meminfo.  This simplifies the code and makes emulation layout
behave better with interleaved physical nodes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |  171 ++++++++++++++++++++----------------------------
 1 files changed, 71 insertions(+), 100 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 040d0ff..c382ed0 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -541,8 +541,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
-static struct bootnode physnodes[MAX_NUMNODES] __initdata;
-
 static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
 static char *emu_cmdline __initdata;
 
@@ -551,6 +549,16 @@ void __init numa_emu_cmdline(char *str)
 	emu_cmdline = str;
 }
 
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
 int __init find_node_by_addr(unsigned long addr)
 {
 	const struct numa_meminfo *mi = &numa_meminfo;
@@ -568,63 +576,6 @@ int __init find_node_by_addr(unsigned long addr)
 	return NUMA_NO_NODE;
 }
 
-static int __init setup_physnodes(unsigned long start, unsigned long end)
-{
-	const struct numa_meminfo *mi = &numa_meminfo;
-	int ret = 0;
-	int i;
-
-	memset(physnodes, 0, sizeof(physnodes));
-
-	for (i = 0; i < mi->nr_blks; i++) {
-		int nid = mi->blk[i].nid;
-
-		if (physnodes[nid].start == physnodes[nid].end) {
-			physnodes[nid].start = mi->blk[i].start;
-			physnodes[nid].end = mi->blk[i].end;
-		} else {
-			physnodes[nid].start = min(physnodes[nid].start,
-						   mi->blk[i].start);
-			physnodes[nid].end = max(physnodes[nid].end,
-						 mi->blk[i].end);
-		}
-	}
-
-	/*
-	 * Basic sanity checking on the physical node map: there may be errors
-	 * if the SRAT or AMD code incorrectly reported the topology or the mem=
-	 * kernel parameter is used.
-	 */
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		if (physnodes[i].start == physnodes[i].end)
-			continue;
-		if (physnodes[i].start > end) {
-			physnodes[i].end = physnodes[i].start;
-			continue;
-		}
-		if (physnodes[i].end < start) {
-			physnodes[i].start = physnodes[i].end;
-			continue;
-		}
-		if (physnodes[i].start < start)
-			physnodes[i].start = start;
-		if (physnodes[i].end > end)
-			physnodes[i].end = end;
-		ret++;
-	}
-
-	/*
-	 * If no physical topology was detected, a single node is faked to cover
-	 * the entire address space.
-	 */
-	if (!ret) {
-		physnodes[ret].start = start;
-		physnodes[ret].end = end;
-		ret = 1;
-	}
-	return ret;
-}
-
 static void __init fake_physnodes(int acpi, int amd,
 				  const struct numa_meminfo *ei)
 {
@@ -663,9 +614,11 @@ static void __init fake_physnodes(int acpi, int amd,
  * something went wrong, 0 otherwise.
  */
 static int __init emu_setup_memblk(struct numa_meminfo *ei,
-				   int nid, int physnid, u64 start, u64 end)
+				   struct numa_meminfo *pi,
+				   int nid, int phys_blk, u64 size)
 {
 	struct numa_memblk *eb = &ei->blk[ei->nr_blks];
+	struct numa_memblk *pb = &pi->blk[phys_blk];
 
 	if (ei->nr_blks >= NR_NODE_MEMBLKS) {
 		pr_err("NUMA: Too many emulated memblks, failing emulation\n");
@@ -673,12 +626,18 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,
 	}
 
 	ei->nr_blks++;
-	eb->start = start;
-	eb->end = end;
+	eb->start = pb->start;
+	eb->end = pb->start + size;
 	eb->nid = nid;
 
 	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
-		emu_nid_to_phys[nid] = physnid;
+		emu_nid_to_phys[nid] = pb->nid;
+
+	pb->start += size;
+	if (pb->start >= pb->end) {
+		WARN_ON_ONCE(pb->start > pb->end);
+		numa_remove_memblk_from(phys_blk, pi);
+	}
 
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       eb->start, eb->end, (eb->end - eb->start) >> 20);
@@ -690,6 +649,7 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,
  * to max_addr.  The return value is the number of nodes allocated.
  */
 static int __init split_nodes_interleave(struct numa_meminfo *ei,
+					 struct numa_meminfo *pi,
 					 u64 addr, u64 max_addr, int nr_nodes)
 {
 	nodemask_t physnode_mask = NODE_MASK_NONE;
@@ -721,9 +681,8 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 		return -1;
 	}
 
-	for (i = 0; i < MAX_NUMNODES; i++)
-		if (physnodes[i].start != physnodes[i].end)
-			node_set(i, physnode_mask);
+	for (i = 0; i < pi->nr_blks; i++)
+		node_set(pi->blk[i].nid, physnode_mask);
 
 	/*
 	 * Continue to fill physical nodes with fake nodes until there is no
@@ -731,8 +690,18 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 	 */
 	while (nodes_weight(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
-			u64 end = physnodes[i].start + size;
 			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
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
 
 			if (nid < big)
 				end += FAKE_NODE_MIN_SIZE;
@@ -741,11 +710,11 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * Continue to add memory to this fake node if its
 			 * non-reserved memory is less than the per-node size.
 			 */
-			while (end - physnodes[i].start -
-				memblock_x86_hole_size(physnodes[i].start, end) < size) {
+			while (end - start -
+			       memblock_x86_hole_size(start, end) < size) {
 				end += FAKE_NODE_MIN_SIZE;
-				if (end > physnodes[i].end) {
-					end = physnodes[i].end;
+				if (end > limit) {
+					end = limit;
 					break;
 				}
 			}
@@ -764,19 +733,15 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			 * next node, this one must extend to the end of the
 			 * physical node.
 			 */
-			if (physnodes[i].end - end -
-			    memblock_x86_hole_size(end, physnodes[i].end) < size)
-				end = physnodes[i].end;
+			if (limit - end -
+			    memblock_x86_hole_size(end, limit) < size)
+				end = limit;
 
-			ret = emu_setup_memblk(ei, nid++ % nr_nodes, i,
-					       physnodes[i].start,
-					       min(end, physnodes[i].end));
+			ret = emu_setup_memblk(ei, pi, nid++ % nr_nodes,
+					       phys_blk,
+					       min(end, limit) - start);
 			if (ret < 0)
 				return ret;
-
-			physnodes[i].start = min(end, physnodes[i].end);
-			if (physnodes[i].start == physnodes[i].end)
-				node_clear(i, physnode_mask);
 		}
 	}
 	return 0;
@@ -805,6 +770,7 @@ static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
  * `addr' to `max_addr'.  The return value is the number of nodes allocated.
  */
 static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
+					      struct numa_meminfo *pi,
 					      u64 addr, u64 max_addr, u64 size)
 {
 	nodemask_t physnode_mask = NODE_MASK_NONE;
@@ -833,9 +799,9 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 	}
 	size &= FAKE_NODE_MIN_HASH_MASK;
 
-	for (i = 0; i < MAX_NUMNODES; i++)
-		if (physnodes[i].start != physnodes[i].end)
-			node_set(i, physnode_mask);
+	for (i = 0; i < pi->nr_blks; i++)
+		node_set(pi->blk[i].nid, physnode_mask);
+
 	/*
 	 * Fill physical nodes with fake nodes of size until there is no memory
 	 * left on any of them.
@@ -843,10 +809,18 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 	while (nodes_weight(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
 			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
-			u64 end;
+			u64 start, limit, end;
+			int phys_blk;
 
-			end = find_end_of_node(physnodes[i].start,
-						physnodes[i].end, size);
+			phys_blk = emu_find_memblk_by_nid(i, pi);
+			if (phys_blk < 0) {
+				node_clear(i, physnode_mask);
+				continue;
+			}
+			start = pi->blk[phys_blk].start;
+			limit = pi->blk[phys_blk].end;
+
+			end = find_end_of_node(start, limit, size);
 			/*
 			 * If there won't be at least FAKE_NODE_MIN_SIZE of
 			 * non-reserved memory in ZONE_DMA32 for the next node,
@@ -861,19 +835,15 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 			 * next node, this one must extend to the end of the
 			 * physical node.
 			 */
-			if (physnodes[i].end - end -
-			    memblock_x86_hole_size(end, physnodes[i].end) < size)
-				end = physnodes[i].end;
+			if (limit - end -
+			    memblock_x86_hole_size(end, limit) < size)
+				end = limit;
 
-			ret = emu_setup_memblk(ei, nid++ % MAX_NUMNODES, i,
-					       physnodes[i].start,
-					       min(end, physnodes[i].end));
+			ret = emu_setup_memblk(ei, pi, nid++ % MAX_NUMNODES,
+					       phys_blk,
+					       min(end, limit) - start);
 			if (ret < 0)
 				return ret;
-
-			physnodes[i].start = min(end, physnodes[i].end);
-			if (physnodes[i].start == physnodes[i].end)
-				node_clear(i, physnode_mask);
 		}
 	}
 	return 0;
@@ -886,10 +856,12 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 static bool __init numa_emulation(int acpi, int amd)
 {
 	static struct numa_meminfo ei __initdata;
+	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
 	int i, ret;
 
 	memset(&ei, 0, sizeof(ei));
+	pi = numa_meminfo;
 
 	for (i = 0; i < MAX_NUMNODES; i++)
 		emu_nid_to_phys[i] = NUMA_NO_NODE;
@@ -903,12 +875,12 @@ static bool __init numa_emulation(int acpi, int amd)
 		u64 size;
 
 		size = memparse(emu_cmdline, &emu_cmdline);
-		ret = split_nodes_size_interleave(&ei, 0, max_addr, size);
+		ret = split_nodes_size_interleave(&ei, &pi, 0, max_addr, size);
 	} else {
 		unsigned long n;
 
 		n = simple_strtoul(emu_cmdline, NULL, 0);
-		ret = split_nodes_interleave(&ei, 0, max_addr, n);
+		ret = split_nodes_interleave(&ei, &pi, 0, max_addr, n);
 	}
 
 	if (ret < 0)
@@ -980,7 +952,6 @@ void __init initmem_init(void)
 		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
 			continue;
 #ifdef CONFIG_NUMA_EMU
-		setup_physnodes(0, max_pfn << PAGE_SHIFT);
 		/*
 		 * If requested, try emulation.  If emulation is not used,
 		 * build identity emu_nid_to_phys[] for numa_add_cpu()
-- 
1.7.1

