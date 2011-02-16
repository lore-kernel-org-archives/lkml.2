Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab1BPMYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:24:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab1BPMVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DFwyd9+RIltKd+grWFIqcR2lyWeqUBxj91J8MmHKD/mRXjCtoMSrPXhshFxwrw2yel
         xkHomQ5mLGxpG+ZRyQuB3BdQ2jHBUF2ov6U1++HO7yKODSDc9hS0pvZlnNXhaT6IPy5t
         geGBrA42a5gkLu0CXALclcIskCzKqDb8fChgQ=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 24/33] x86-64, NUMA: Rename cpu_nodes_parsed to numa_nodes_parsed
Date: Wed, 16 Feb 2011 13:20:58 +0100
Message-Id: <1297858867-25981-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's no longer necessary to keep both cpu_nodes_parsed and
mem_nodes_parsed.  In preparation for merge, rename cpu_nodes_parsed
to numa_nodes_parsed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    2 +-
 arch/x86/mm/amdtopology_64.c   |    4 ++--
 arch/x86/mm/numa_64.c          |    8 ++++----
 arch/x86/mm/srat_64.c          |    6 +++---
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index da5c501..da57c70 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -25,7 +25,7 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 #define NODE_MIN_SIZE		(4*1024*1024)
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
 
-extern nodemask_t cpu_nodes_parsed __initdata;
+extern nodemask_t numa_nodes_parsed __initdata;
 extern nodemask_t mem_nodes_parsed __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index 0cb59e5..e76bffa 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -168,7 +168,7 @@ int __init amd_numa_init(void)
 		prevbase = base;
 		numa_add_memblk(nodeid, base, limit);
 		node_set(nodeid, mem_nodes_parsed);
-		node_set(nodeid, cpu_nodes_parsed);
+		node_set(nodeid, numa_nodes_parsed);
 	}
 
 	if (!nodes_weight(mem_nodes_parsed))
@@ -189,7 +189,7 @@ int __init amd_numa_init(void)
 		apicid_base = boot_cpu_physical_apicid;
 	}
 
-	for_each_node_mask(i, cpu_nodes_parsed)
+	for_each_node_mask(i, numa_nodes_parsed)
 		for (j = apicid_base; j < cores + apicid_base; j++)
 			set_apicid_to_node((i << bits) + j, i);
 
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index c490448..6e4fbd7 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -36,7 +36,7 @@ struct numa_meminfo {
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
-nodemask_t cpu_nodes_parsed __initdata;
+nodemask_t numa_nodes_parsed __initdata;
 nodemask_t mem_nodes_parsed __initdata;
 
 struct memnode memnode;
@@ -379,7 +379,7 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	int i, j, nid;
 
 	/* Account for nodes with cpus and no memory */
-	nodes_or(node_possible_map, mem_nodes_parsed, cpu_nodes_parsed);
+	nodes_or(node_possible_map, mem_nodes_parsed, numa_nodes_parsed);
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
@@ -823,7 +823,7 @@ static int dummy_numa_init(void)
 	printk(KERN_INFO "Faking a node at %016lx-%016lx\n",
 	       0LU, max_pfn << PAGE_SHIFT);
 
-	node_set(0, cpu_nodes_parsed);
+	node_set(0, numa_nodes_parsed);
 	node_set(0, mem_nodes_parsed);
 	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
 
@@ -851,7 +851,7 @@ void __init initmem_init(void)
 		for (j = 0; j < MAX_LOCAL_APIC; j++)
 			set_apicid_to_node(j, NUMA_NO_NODE);
 
-		nodes_clear(cpu_nodes_parsed);
+		nodes_clear(numa_nodes_parsed);
 		nodes_clear(mem_nodes_parsed);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index e8b3b3c..8185189 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -94,7 +94,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	}
 	set_apicid_to_node(apic_id, node);
-	node_set(node, cpu_nodes_parsed);
+	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
 	       pxm, apic_id, node);
@@ -134,7 +134,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 	}
 
 	set_apicid_to_node(apic_id, node);
-	node_set(node, cpu_nodes_parsed);
+	node_set(node, numa_nodes_parsed);
 	acpi_numa = 1;
 	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
 	       pxm, apic_id, node);
@@ -196,7 +196,7 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 	}
 
 	if (changed) {
-		node_set(node, cpu_nodes_parsed);
+		node_set(node, numa_nodes_parsed);
 		printk(KERN_INFO "SRAT: hot plug zone found %Lx - %Lx\n",
 				 nd->start, nd->end);
 	}
-- 
1.7.1

