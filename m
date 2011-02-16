Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab1BPMVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab1BPMV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qPnjf8YTuC4PojEVzqg1M4gsDSFm0aTr3DsC3ruBjUupqHSLtr/mn6fIJkE7NO+/8F
         mFbsneBwPQjDmnf3n5kbo8ccXxsZqnafbi9NJO1CCZwP3zrvXVYj9tHpFdyTqTZ2hHLB
         KZZUkWrIVnvYv2unBR9vTipQoTl1SnqLbhi8w=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/33] x86-64, NUMA: Use common {cpu|mem}_nodes_parsed
Date: Wed, 16 Feb 2011 13:20:42 +0100
Message-Id: <1297858867-25981-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI and amd are using separate nodes_parsed masks.  Add
{cpu|mem}_nodes_parsed and use them in all NUMA init methods.
Initialization of the masks and building node_possible_map are now
handled commonly by initmem_init().

dummy_numa_init() is updated to set node 0 on both masks.  While at
it, move the info messages from scan to init.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    3 +++
 arch/x86/mm/amdtopology_64.c   |   10 ++++------
 arch/x86/mm/numa_64.c          |   25 ++++++++++++++++++-------
 arch/x86/mm/srat_64.c          |   17 ++++++-----------
 4 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 2819afa..de45936 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -27,6 +27,9 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
  */
 #define NODE_MIN_SIZE (4*1024*1024)
 
+extern nodemask_t cpu_nodes_parsed __initdata;
+extern nodemask_t mem_nodes_parsed __initdata;
+
 extern int __cpuinit numa_cpu_node(int cpu);
 
 #ifdef CONFIG_NUMA_EMU
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 655ccff..4f822a2 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -28,7 +28,6 @@
 
 static struct bootnode __initdata nodes[8];
 static unsigned char __initdata nodeids[8];
-static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
 
 static __init int find_northbridge(void)
 {
@@ -123,7 +122,7 @@ int __init amd_numa_init(void)
 			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -EINVAL;
 		}
-		if (node_isset(nodeid, nodes_parsed)) {
+		if (node_isset(nodeid, mem_nodes_parsed)) {
 			pr_info("Node %d already present, skipping\n",
 				nodeid);
 			continue;
@@ -173,7 +172,8 @@ int __init amd_numa_init(void)
 
 		prevbase = base;
 
-		node_set(nodeid, nodes_parsed);
+		node_set(nodeid, mem_nodes_parsed);
+		node_set(nodeid, cpu_nodes_parsed);
 	}
 
 	if (!found)
@@ -190,7 +190,7 @@ void __init amd_get_nodes(struct bootnode *physnodes)
 {
 	int i;
 
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
 		physnodes[i].start = nodes[i].start;
 		physnodes[i].end = nodes[i].end;
 	}
@@ -258,8 +258,6 @@ int __init amd_scan_nodes(void)
 	unsigned int apicid_base;
 	int i;
 
-	BUG_ON(nodes_empty(nodes_parsed));
-	node_possible_map = nodes_parsed;
 	memnode_shift = compute_hash_shift(nodes, 8, NULL);
 	if (memnode_shift < 0) {
 		pr_err("No NUMA node hash function found. Contact maintainer\n");
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index c984e34..4404e1d 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -25,6 +25,9 @@
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
+nodemask_t cpu_nodes_parsed __initdata;
+nodemask_t mem_nodes_parsed __initdata;
+
 struct memnode memnode;
 
 static unsigned long __initdata nodemap_addr;
@@ -582,22 +585,23 @@ static int __init numa_emulation(unsigned long start_pfn,
 
 static int dummy_numa_init(void)
 {
-	return 0;
-}
-
-static int dummy_scan_nodes(void)
-{
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
 	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
 	       0LU, max_pfn << PAGE_SHIFT);
 
+	node_set(0, cpu_nodes_parsed);
+	node_set(0, mem_nodes_parsed);
+
+	return 0;
+}
+
+static int dummy_scan_nodes(void)
+{
 	/* setup dummy node covering all memory */
 	memnode_shift = 63;
 	memnodemap = memnode.embedded_map;
 	memnodemap[0] = 0;
-	node_set_online(0);
-	node_set(0, node_possible_map);
 	memblock_x86_register_active_regions(0, 0, max_pfn);
 	init_memory_mapping_high();
 	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
@@ -630,6 +634,8 @@ void __init initmem_init(void)
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
 			set_apicid_to_node(j, NUMA_NO_NODE);
 
+		nodes_clear(cpu_nodes_parsed);
+		nodes_clear(mem_nodes_parsed);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 
@@ -643,6 +649,11 @@ void __init initmem_init(void)
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 #endif
+		/* Account for nodes with cpus and no memory */
+		nodes_or(node_possible_map, mem_nodes_parsed, cpu_nodes_parsed);
+		if (WARN_ON(nodes_empty(node_possible_map)))
+			continue;
+
 		if (!scan_nodes[i]())
 			return;
 	}
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 597e011..33e72ec 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -28,8 +28,6 @@ int acpi_numa __initdata;
 
 static struct acpi_table_slit *acpi_slit;
 
-static nodemask_t nodes_parsed __initdata;
-static nodemask_t cpu_nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 
@@ -293,7 +291,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 
 	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
 		nd = &nodes[node];
-		if (!node_test_and_set(node, nodes_parsed)) {
+		if (!node_test_and_set(node, mem_nodes_parsed)) {
 			nd->start = start;
 			nd->end = end;
 		} else {
@@ -319,7 +317,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 	unsigned long pxmram, e820ram;
 
 	pxmram = 0;
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
@@ -348,7 +346,7 @@ void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
 {
 	int i;
 
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
 		cutoff_node(i, start, end);
 		physnodes[i].start = nodes[i].start;
 		physnodes[i].end = nodes[i].end;
@@ -449,9 +447,6 @@ int __init acpi_scan_nodes(void)
 
 	init_memory_mapping_high();
 
-	/* Account for nodes with cpus and no memory */
-	nodes_or(node_possible_map, nodes_parsed, cpu_nodes_parsed);
-
 	/* Finally register nodes */
 	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
@@ -485,7 +480,7 @@ static int __init find_node_by_addr(unsigned long addr)
 	int ret = NUMA_NO_NODE;
 	int i;
 
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, mem_nodes_parsed) {
 		/*
 		 * Find the real node that this emulated node appears on.  For
 		 * the sake of simplicity, we only use a real node's starting
@@ -545,10 +540,10 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
 	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 
-	nodes_clear(nodes_parsed);
+	nodes_clear(mem_nodes_parsed);
 	for (i = 0; i < num_nodes; i++)
 		if (fake_nodes[i].start != fake_nodes[i].end)
-			node_set(i, nodes_parsed);
+			node_set(i, mem_nodes_parsed);
 }
 
 static int null_slit_node_compare(int a, int b)
-- 
1.7.1

