Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab1BPOOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 09:14:45 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37155 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab1BPOOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 09:14:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SAAWYtGCZuBhkYKYyCI90GSt+wE53OIve9mw5mQDLsGxBgJqInL+Dtq9SeWjYZxxRK
         FwNadwgIL7yNYMYk4XHoLBEHPr9DR+OGtgiXC2DncNNRoWbTqUHY75PriBulG2/m6O82
         aLWnEVeW62Er8Vt+ppXRGDBu4v+EGxV7T4iIs=
Date: Wed, 16 Feb 2011 15:14:34 +0100
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Subject: [PATCH UPDATED 28/33] x86-64, NUMA: Build and use direct emulated
 nid -> phys nid mapping
Message-ID: <20110216141434.GF19830@htj.dyndns.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <1297858867-25981-29-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297858867-25981-29-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA emulation copied physical NUMA configuration into physnodes[] and
used it to reverse-map emulated nodes to physical nodes, which is
unnecessarily convoluted.  Build emu_nid_to_phys[] array to map
emulated nids directly to the matching physical nids and use it in
numa_add_cpu().

physnodes[] will be removed with further patches.

- v2: Build failure when CONFIG_DEBUG_PER_CPU_MAPS due to missing
  local variable definition fixed.  Reported by Ingo.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
git tree updated accordingly.

Thanks.

 arch/x86/mm/numa_64.c |   64 ++++++++++++++++++++++++++----------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 20e2cfe..e9919c4 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -542,7 +542,9 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
-static struct bootnode physnodes[MAX_NUMNODES] __cpuinitdata;
+static struct bootnode physnodes[MAX_NUMNODES] __initdata;
+
+static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
 static char *emu_cmdline __initdata;
 
 void __init numa_emu_cmdline(char *str)
@@ -649,7 +651,8 @@ static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
  * allocation past addr and -1 otherwise.  addr is adjusted to be at
  * the end of the node.
  */
-static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
+static int __init setup_node_range(int nid, int physnid,
+				   u64 *addr, u64 size, u64 max_addr)
 {
 	int ret = 0;
 	nodes[nid].start = *addr;
@@ -660,6 +663,10 @@ static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
 	}
 	nodes[nid].end = *addr;
 	node_set(nid, node_possible_map);
+
+	if (emu_nid_to_phys[nid] == NUMA_NO_NODE)
+		emu_nid_to_phys[nid] = physnid;
+
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       nodes[nid].start, nodes[nid].end,
 	       (nodes[nid].end - nodes[nid].start) >> 20);
@@ -756,7 +763,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
 			if (nodes_weight(physnode_mask) + ret >= nr_nodes)
 				end = physnodes[i].end;
 
-			if (setup_node_range(ret++, &physnodes[i].start,
+			if (setup_node_range(ret++, i, &physnodes[i].start,
 						end - physnodes[i].start,
 						physnodes[i].end) < 0)
 				node_clear(i, physnode_mask);
@@ -852,7 +859,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
 			 * later.  If setup_node_range() returns non-zero, there
 			 * is no more memory available on this physical node.
 			 */
-			if (setup_node_range(ret++, &physnodes[i].start,
+			if (setup_node_range(ret++, i, &physnodes[i].start,
 						end - physnodes[i].start,
 						physnodes[i].end) < 0)
 				node_clear(i, physnode_mask);
@@ -872,6 +879,9 @@ static int __init numa_emulation(int acpi, int amd)
 	int num_nodes;
 	int i;
 
+	for (i = 0; i < MAX_NUMNODES; i++)
+		emu_nid_to_phys[i] = NUMA_NO_NODE;
+
 	/*
 	 * If the numa=fake command-line contains a 'M' or 'G', it represents
 	 * the fixed node size.  Otherwise, if it is just a single number N,
@@ -892,6 +902,11 @@ static int __init numa_emulation(int acpi, int amd)
 	if (num_nodes < 0)
 		return num_nodes;
 
+	/* make sure all emulated nodes are mapped to a physical node */
+	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
+		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
+			emu_nid_to_phys[i] = 0;
+
 	ei.nr_blks = num_nodes;
 	for (i = 0; i < ei.nr_blks; i++) {
 		ei.blk[i].start = nodes[i].start;
@@ -918,7 +933,6 @@ static int __init numa_emulation(int acpi, int amd)
 	init_memory_mapping_high();
 	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	setup_physnodes(0, max_addr);
 	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
 	numa_emu_dist = true;
@@ -976,7 +990,11 @@ void __init initmem_init(void)
 		setup_physnodes(0, max_pfn << PAGE_SHIFT);
 		if (emu_cmdline && !numa_emulation(i == 0, i == 1))
 			return;
-		setup_physnodes(0, max_pfn << PAGE_SHIFT);
+
+		/* not emulating, build identity mapping for numa_add_cpu() */
+		for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
+			emu_nid_to_phys[j] = j;
+
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 #endif
@@ -1033,7 +1051,6 @@ int __cpuinit numa_cpu_node(int cpu)
 # ifndef CONFIG_DEBUG_PER_CPU_MAPS
 void __cpuinit numa_add_cpu(int cpu)
 {
-	unsigned long addr;
 	int physnid, nid;
 
 	nid = numa_cpu_node(cpu);
@@ -1041,26 +1058,15 @@ void __cpuinit numa_add_cpu(int cpu)
 		nid = early_cpu_to_node(cpu);
 	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
 
-	/*
-	 * Use the starting address of the emulated node to find which physical
-	 * node it is allocated on.
-	 */
-	addr = node_start_pfn(nid) << PAGE_SHIFT;
-	for (physnid = 0; physnid < MAX_NUMNODES; physnid++)
-		if (addr >= physnodes[physnid].start &&
-		    addr < physnodes[physnid].end)
-			break;
+	physnid = emu_nid_to_phys[nid];
 
 	/*
 	 * Map the cpu to each emulated node that is allocated on the physical
 	 * node of the cpu's apic id.
 	 */
-	for_each_online_node(nid) {
-		addr = node_start_pfn(nid) << PAGE_SHIFT;
-		if (addr >= physnodes[physnid].start &&
-		    addr < physnodes[physnid].end)
+	for_each_online_node(nid)
+		if (emu_nid_to_phys[nid] == physnid)
 			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
-	}
 }
 
 void __cpuinit numa_remove_cpu(int cpu)
@@ -1073,21 +1079,21 @@ void __cpuinit numa_remove_cpu(int cpu)
 # else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
-	int node = early_cpu_to_node(cpu);
 	struct cpumask *mask;
-	int i;
+	int nid, physnid, i;
 
-	if (node == NUMA_NO_NODE) {
+	nid = early_cpu_to_node(cpu);
+	if (nid == NUMA_NO_NODE) {
 		/* early_cpu_to_node() already emits a warning and trace */
 		return;
 	}
-	for_each_online_node(i) {
-		unsigned long addr;
 
-		addr = node_start_pfn(i) << PAGE_SHIFT;
-		if (addr < physnodes[node].start ||
-					addr >= physnodes[node].end)
+	physnid = emu_nid_to_phys[nid];
+
+	for_each_online_node(i) {
+		if (emu_nid_to_phys[nid] != physnid)
 			continue;
+
 		mask = debug_cpumask_set_cpu(cpu, enable);
 		if (!mask)
 			return;
-- 
1.7.1

