Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576Ab0LVA7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:59:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:49211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab0LVA7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:59:13 -0500
Date: Wed, 22 Dec 2010 00:58:52 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.00.1012011735170.1040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012011735170.1040@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Fake node-to-cpumask for NUMA emulation
Message-ID: <tip-d845c04a7a53f6b90a0f5473d0a1ad72873e77c8@git.kernel.org>
Git-Commit-ID: d845c04a7a53f6b90a0f5473d0a1ad72873e77c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 00:58:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d845c04a7a53f6b90a0f5473d0a1ad72873e77c8
Gitweb:     http://git.kernel.org/tip/d845c04a7a53f6b90a0f5473d0a1ad72873e77c8
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 1 Dec 2010 17:36:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Dec 2010 16:09:06 -0800

x86, numa: Fake node-to-cpumask for NUMA emulation

It's necessary to fake the node-to-cpumask mapping so that an emulated
node ID returns a cpumask that includes all cpus that have affinity to
the memory it represents.

This is a little intrusive because it requires knowledge of the physical
topology of the system.  setup_physnodes() gives us that information, but
since NUMA emulation ends up altering the physnodes array, it's necessary
to reset it before cpus are brought online.

Accordingly, the physnodes array is moved out of init.data and into
cpuinit.data since it will be needed on cpuup callbacks.

This works regardless of whether numa=fake is used on the command line,
or the setup of the fake node succeeds or fails.  The physnodes array
always contains the physical topology of the machine if CONFIG_NUMA_EMU
is enabled and can be used to setup the correct node-to-cpumask mappings
in all cases since setup_physnodes() is called whenever the array needs
to be repopulated with the correct data.

To fake the actual mappings, numa_add_cpu() and numa_remove_cpu() are
rewritten for CONFIG_NUMA_EMU so that we first find the physical node to
which each cpu has local affinity, then iterate through all online nodes
to find the emulated nodes that have local affinity to that physical
node, and then finally map the cpu to each of those emulated nodes.

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1012011735170.1040@chino.kir.corp.google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   99 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index f0b0bdc..d312db6 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -260,7 +260,7 @@ void __init numa_init_array(void)
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
-static struct bootnode physnodes[MAX_NUMNODES] __initdata;
+static struct bootnode physnodes[MAX_NUMNODES] __cpuinitdata;
 static char *cmdline __initdata;
 
 static int __init setup_physnodes(unsigned long start, unsigned long end,
@@ -270,6 +270,7 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
 	int ret = 0;
 	int i;
 
+	memset(physnodes, 0, sizeof(physnodes));
 #ifdef CONFIG_ACPI_NUMA
 	if (acpi)
 		nr_nodes = acpi_get_nodes(physnodes);
@@ -370,8 +371,7 @@ static int __init setup_node_range(int nid, u64 *addr, u64 size, u64 max_addr)
  * Sets up nr_nodes fake nodes interleaved over physical nodes ranging from addr
  * to max_addr.  The return value is the number of nodes allocated.
  */
-static int __init split_nodes_interleave(u64 addr, u64 max_addr,
-						int nr_phys_nodes, int nr_nodes)
+static int __init split_nodes_interleave(u64 addr, u64 max_addr, int nr_nodes)
 {
 	nodemask_t physnode_mask = NODE_MASK_NONE;
 	u64 size;
@@ -402,7 +402,7 @@ static int __init split_nodes_interleave(u64 addr, u64 max_addr,
 		return -1;
 	}
 
-	for (i = 0; i < nr_phys_nodes; i++)
+	for (i = 0; i < MAX_NUMNODES; i++)
 		if (physnodes[i].start != physnodes[i].end)
 			node_set(i, physnode_mask);
 
@@ -571,11 +571,9 @@ static int __init numa_emulation(unsigned long start_pfn,
 {
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
-	int num_phys_nodes;
 	int num_nodes;
 	int i;
 
-	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
 	/*
 	 * If the numa=fake command-line contains a 'M' or 'G', it represents
 	 * the fixed node size.  Otherwise, if it is just a single number N,
@@ -590,7 +588,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 		unsigned long n;
 
 		n = simple_strtoul(cmdline, NULL, 0);
-		num_nodes = split_nodes_interleave(addr, max_addr, num_phys_nodes, n);
+		num_nodes = split_nodes_interleave(addr, max_addr, n);
 	}
 
 	if (num_nodes < 0)
@@ -613,6 +611,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 						nodes[i].end >> PAGE_SHIFT);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
+	setup_physnodes(addr, max_addr, acpi, k8);
 	fake_physnodes(acpi, k8, num_nodes);
 	numa_init_array();
 	return 0;
@@ -628,8 +627,12 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
+	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
+			acpi, k8);
 	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
 		return;
+	setup_physnodes(start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT,
+			acpi, k8);
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -785,6 +788,7 @@ void __cpuinit numa_clear_node(int cpu)
 
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
+#ifndef CONFIG_NUMA_EMU
 void __cpuinit numa_add_cpu(int cpu)
 {
 	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
@@ -794,6 +798,51 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
+#else
+void __cpuinit numa_add_cpu(int cpu)
+{
+	unsigned long addr;
+	u16 apicid;
+	int physnid;
+	int nid = NUMA_NO_NODE;
+
+	apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+	if (apicid != BAD_APICID)
+		nid = apicid_to_node[apicid];
+	if (nid == NUMA_NO_NODE)
+		nid = early_cpu_to_node(cpu);
+	BUG_ON(nid == NUMA_NO_NODE || !node_online(nid));
+
+	/*
+	 * Use the starting address of the emulated node to find which physical
+	 * node it is allocated on.
+	 */
+	addr = node_start_pfn(nid) << PAGE_SHIFT;
+	for (physnid = 0; physnid < MAX_NUMNODES; physnid++)
+		if (addr >= physnodes[physnid].start &&
+		    addr < physnodes[physnid].end)
+			break;
+
+	/*
+	 * Map the cpu to each emulated node that is allocated on the physical
+	 * node of the cpu's apic id.
+	 */
+	for_each_online_node(nid) {
+		addr = node_start_pfn(nid) << PAGE_SHIFT;
+		if (addr >= physnodes[physnid].start &&
+		    addr < physnodes[physnid].end)
+			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
+	}
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	int i;
+
+	for_each_online_node(i)
+		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
+}
+#endif /* !CONFIG_NUMA_EMU */
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
 
@@ -805,22 +854,32 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 	int node = early_cpu_to_node(cpu);
 	struct cpumask *mask;
 	char buf[64];
+	int i;
 
-	mask = node_to_cpumask_map[node];
-	if (mask == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map[%i] NULL\n", node);
-		dump_stack();
-		return;
-	}
+	for_each_online_node(i) {
+		unsigned long addr;
 
-	if (enable)
-		cpumask_set_cpu(cpu, mask);
-	else
-		cpumask_clear_cpu(cpu, mask);
+		addr = node_start_pfn(i) << PAGE_SHIFT;
+		if (addr < physnodes[node].start ||
+					addr >= physnodes[node].end)
+			continue;
+		mask = node_to_cpumask_map[node];
+		if (mask == NULL) {
+			pr_err("node_to_cpumask_map[%i] NULL\n", i);
+			dump_stack();
+			return;
+		}
+
+		if (enable)
+			cpumask_set_cpu(cpu, mask);
+		else
+			cpumask_clear_cpu(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
+		cpulist_scnprintf(buf, sizeof(buf), mask);
+		printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+			enable ? "numa_add_cpu" : "numa_remove_cpu",
+			cpu, node, buf);
+	}
 }
 
 void __cpuinit numa_add_cpu(int cpu)
