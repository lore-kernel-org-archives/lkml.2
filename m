Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab1BNT3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 14:29:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1BNT2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 14:28:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=npkxoZKqc4MjYQqfPwJ5UdYxj722qwzboSlrRjjYYOglIetKn+I287X9f3oo/9tufh
         E5mp/K2UtKnU6KEqj/I8592W2uWhh6t616SteOHOJAckKDR4PHIfQ987NGL05GhIZLMj
         Frd36yb7virfm2l66L11oYq21SSGjmLlYAsV4=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] x86-64, NUMA: Make emulation code build numa_meminfo and share the registration path
Date: Mon, 14 Feb 2011 20:28:31 +0100
Message-Id: <1297711715-3086-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297711715-3086-1-git-send-email-tj@kernel.org>
References: <1297711715-3086-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA emulation code built nodes[] array and had its own registration
path to set up the emulated nodes.  Update it such that it generates
emulated numa_meminfo and returns control to initmem_init() and shares
the same registration path with non-emulated cases.

Because {acpi|amd}_fake_nodes() expect nodes[] parameter,
fake_physnodes() now generates nodes[] from numa_meminfo.  This will
go away with further updates.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |  172 ++++++++++++++++++++++++------------------------
 1 files changed, 86 insertions(+), 86 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 253a5c3..093530f 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -539,7 +539,6 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
-static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode physnodes[MAX_NUMNODES] __initdata;
 
 static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
@@ -624,9 +623,24 @@ static int __init setup_physnodes(unsigned long start, unsigned long end)
 	return ret;
 }
 
-static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
+static void __init fake_physnodes(int acpi, int amd,
+				  const struct numa_meminfo *ei)
 {
-	int i;
+	static struct bootnode nodes[MAX_NUMNODES] __initdata;
+	int i, nr_nodes = 0;
+
+	for (i = 0; i < ei->nr_blks; i++) {
+		int nid = ei->blk[i].nid;
+
+		if (nodes[nid].start == nodes[nid].end) {
+			nodes[nid].start = ei->blk[i].start;
+			nodes[nid].end = ei->blk[i].end;
+			nr_nodes++;
+		} else {
+			nodes[nid].start = min(ei->blk[i].start, nodes[nid].start);
+			nodes[nid].end = max(ei->blk[i].end, nodes[nid].end);
+		}
+	}
 
 	BUG_ON(acpi && amd);
 #ifdef CONFIG_ACPI_NUMA
@@ -643,45 +657,44 @@ static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
 }
 
 /*
- * Setups up nid to range from addr to addr + size.  If the end
- * boundary is greater than max_addr, then max_addr is used instead.
- * The return value is 0 if there is additional memory left for
- * allocation past addr and -1 otherwise.  addr is adjusted to be at
- * the end of the node.
+ * Sets up nid to range from @start to @end.  The return value is -errno if
+ * something went wrong, 0 otherwise.
  */
-static int __init setup_node_range(int nid, int physnid,
-				   u64 *addr, u64 size, u64 max_addr)
+static int __init emu_setup_memblk(struct numa_meminfo *ei,
+				   int nid, int physnid, u64 start, u64 end)
 {
-	int ret = 0;
-	nodes[nid].start = *addr;
-	*addr += size;
-	if (*addr >= max_addr) {
-		*addr = max_addr;
-		ret = -1;
+	struct numa_memblk *eb = &ei->blk[ei->nr_blks];
+
+	if (ei->nr_blks >= NR_NODE_MEMBLKS) {
+		pr_err("NUMA: Too many emulated memblks, failing emulation\n");
+		return -EINVAL;
 	}
-	nodes[nid].end = *addr;
-	node_set(nid, node_possible_map);
+
+	ei->nr_blks++;
+	eb->start = start;
+	eb->end = end;
+	eb->nid = nid;
 
 	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
 		emu_nid_to_phys[nid] = physnid;
 
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
-	       nodes[nid].start, nodes[nid].end,
-	       (nodes[nid].end - nodes[nid].start) >> 20);
-	return ret;
+	       eb->start, eb->end, (eb->end - eb->start) >> 20);
+	return 0;
 }
 
 /*
  * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
  * to max_addr.  The return value is the number of nodes allocated.
  */
-static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
+static int __init split_nodes_interleave(struct numa_meminfo *ei,
+					 u64 addr, u64 max_addr, int nr_nodes)
 {
 	nodemask_t physnode_mask = NODE_MASK_NONE;
 	u64 size;
 	int big;
-	int ret = 0;
-	int i;
+	int nid = 0;
+	int i, ret;
 
 	if (nr_nodes <= 0)
 		return -1;
@@ -719,7 +732,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
 			u64 end = physnodes[i].start + size;
 			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
 
-			if (ret < big)
+			if (nid < big)
 				end += FAKE_NODE_MIN_SIZE;
 
 			/*
@@ -758,16 +771,21 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
 			 * happen as a result of rounding down each node's size
 			 * to FAKE_NODE_MIN_SIZE.
 			 */
-			if (nodes_weight(physnode_mask) + ret >= nr_nodes)
+			if (nodes_weight(physnode_mask) + nid >= nr_nodes)
 				end = physnodes[i].end;
 
-			if (setup_node_range(ret++, i, &physnodes[i].start,
-						end - physnodes[i].start,
-						physnodes[i].end) < 0)
+			ret = emu_setup_memblk(ei, nid++, i,
+					       physnodes[i].start,
+					       min(end, physnodes[i].end));
+			if (ret < 0)
+				return ret;
+
+			physnodes[i].start = min(end, physnodes[i].end);
+			if (physnodes[i].start == physnodes[i].end)
 				node_clear(i, physnode_mask);
 		}
 	}
-	return ret;
+	return 0;
 }
 
 /*
@@ -792,12 +810,13 @@ static u64 __init find_end_of_node(u64 start, u64 max_addr, u64 size)
  * Sets up fake nodes of `size' interleaved over physical nodes ranging from
  * `addr' to `max_addr'.  The return value is the number of nodes allocated.
  */
-static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
+static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
+					      u64 addr, u64 max_addr, u64 size)
 {
 	nodemask_t physnode_mask = NODE_MASK_NONE;
 	u64 min_size;
-	int ret = 0;
-	int i;
+	int nid = 0;
+	int i, ret;
 
 	if (!size)
 		return -1;
@@ -852,30 +871,31 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 			    memblock_x86_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
-			/*
-			 * Setup the fake node that will be allocated as bootmem
-			 * later.  If setup_node_range() returns non-zero, there
-			 * is no more memory available on this physical node.
-			 */
-			if (setup_node_range(ret++, i, &physnodes[i].start,
-						end - physnodes[i].start,
-						physnodes[i].end) < 0)
+			ret = emu_setup_memblk(ei, nid++, i,
+					       physnodes[i].start,
+					       min(end, physnodes[i].end));
+			if (ret < 0)
+				return ret;
+
+			physnodes[i].start = min(end, physnodes[i].end);
+			if (physnodes[i].start == physnodes[i].end)
 				node_clear(i, physnode_mask);
 		}
 	}
-	return ret;
+	return 0;
 }
 
 /*
  * Sets up the system RAM area from start_pfn to last_pfn according to the
  * numa=fake command-line option.
  */
-static int __init numa_emulation(int acpi, int amd)
+static bool __init numa_emulation(int acpi, int amd)
 {
 	static struct numa_meminfo ei __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
-	int num_nodes;
-	int i;
+	int i, ret;
+
+	memset(&ei, 0, sizeof(ei));
 
 	for (i = 0; i < MAX_NUMNODES; i++)
 		emu_nid_to_phys[i] = NUMA_NO_NODE;
@@ -889,51 +909,33 @@ static int __init numa_emulation(int acpi, int amd)
 		u64 size;
 
 		size = memparse(emu_cmdline, &emu_cmdline);
-		num_nodes = split_nodes_size_interleave(0, max_addr, size);
+		ret = split_nodes_size_interleave(&ei, 0, max_addr, size);
 	} else {
 		unsigned long n;
 
 		n = simple_strtoul(emu_cmdline, NULL, 0);
-		num_nodes = split_nodes_interleave(0, max_addr, n);
+		ret = split_nodes_interleave(&ei, 0, max_addr, n);
+	}
+
+	if (ret < 0)
+		return false;
+
+	if (numa_cleanup_meminfo(&ei) < 0) {
+		pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
+		return false;
 	}
 
-	if (num_nodes < 0)
-		return num_nodes;
+	/* commit */
+	numa_meminfo = ei;
 
 	/* make sure all emulated nodes are mapped to a physical node */
 	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
 			emu_nid_to_phys[i] = 0;
 
-	ei.nr_blks = num_nodes;
-	for (i = 0; i < ei.nr_blks; i++) {
-		ei.blk[i].start = nodes[i].start;
-		ei.blk[i].end = nodes[i].end;
-		ei.blk[i].nid = i;
-	}
-
-	memnode_shift = compute_hash_shift(&ei);
-	if (memnode_shift < 0) {
-		memnode_shift = 0;
-		printk(KERN_ERR "No NUMA hash function found.  NUMA emulation "
-		       "disabled.\n");
-		return -1;
-	}
-
-	/*
-	 * We need to vacate all active ranges that may have been registered for
-	 * the e820 memory map.
-	 */
-	remove_all_active_ranges();
-	for_each_node_mask(i, node_possible_map) {
-		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
-						nodes[i].end >> PAGE_SHIFT);
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	}
-	fake_physnodes(acpi, amd, num_nodes);
-	numa_init_array();
+	fake_physnodes(acpi, amd, &ei);
 	numa_emu_dist = true;
-	return 0;
+	return true;
 }
 #endif /* CONFIG_NUMA_EMU */
 
@@ -985,15 +987,13 @@ void __init initmem_init(void)
 			continue;
 #ifdef CONFIG_NUMA_EMU
 		setup_physnodes(0, max_pfn << PAGE_SHIFT);
-		if (emu_cmdline && !numa_emulation(i == 0, i == 1))
-			return;
-
-		/* not emulating, build identity mapping for numa_add_cpu() */
-		for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
-			emu_nid_to_phys[j] = j;
-
-		nodes_clear(node_possible_map);
-		nodes_clear(node_online_map);
+		/*
+		 * If requested, try emulation.  If emulation is not used,
+		 * build identity emu_nid_to_phys[] for numa_add_cpu()
+		 */
+		if (!emu_cmdline || !numa_emulation(i == 0, i == 1))
+			for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
+				emu_nid_to_phys[j] = j;
 #endif
 		if (numa_register_memblks(&numa_meminfo) < 0)
 			continue;
-- 
1.7.1

