Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab0KLVyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:54:20 -0500
Received: from smtp-out.google.com ([74.125.121.35]:27688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab0KLVyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qGm2JdVVsJXtq0h58YeTn1P/WNlwZPTF8+JOkCbfOgG980KJ5VkEkqr+FO6cp9ReQ1
         PJhxdP1fQ/QXmXO0eU/w==
Date: Fri, 12 Nov 2010 13:54:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/5] x86: fake node-to-cpumask for NUMA emulation
In-Reply-To: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011121353180.13699@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/mm/numa_64.c |   99 +++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
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
