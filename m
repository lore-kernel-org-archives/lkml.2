Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182Ab1BPMYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:24:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37715 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932474Ab1BPMVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=W37DP3U5093kCVJ+97IF4DebcegoCXGsv9aH4U/mLkEFxGYS2Qgyr82dQZeuSXxYcp
         MAJI/0D71MeW1S9c41eDFYPUzGBOweTquoNeJ0l1Z6XgtFMRy8OEu9pvzuhO75F5oRDN
         lbEKC/Y/M5Q663eVHvJ7ZhVqt71rpm9C0N+rA=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/33] x86-64, NUMA: Kill mem_nodes_parsed
Date: Wed, 16 Feb 2011 13:20:59 +0100
Message-Id: <1297858867-25981-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all memory configuration information now carried in numa_meminfo,
there's no need to keep mem_nodes_parsed separate.  Drop it and use
numa_nodes_parsed for CPU / memory-less nodes.

A new helper numa_nodemask_from_meminfo() is added to calculate
memnode mask on the fly which is currently used to set
node_possible_map.

This simplifies NUMA init methods a bit and removes a source of
possible inconsistencies.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    1 -
 arch/x86/mm/amdtopology_64.c   |    5 ++---
 arch/x86/mm/numa_64.c          |   20 ++++++++++++++++----
 arch/x86/mm/srat_64.c          |    7 ++-----
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index da57c70..04e74d8 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -26,7 +26,6 @@ extern void setup_node_bootmem(int nodeid, unsigned long start,
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
 
 extern nodemask_t numa_nodes_parsed __initdata;
-extern nodemask_t mem_nodes_parsed __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
 extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index e76bffa..fd7b609 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -122,7 +122,7 @@ int __init amd_numa_init(void)
 			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
 			return -EINVAL;
 		}
-		if (node_isset(nodeid, mem_nodes_parsed)) {
+		if (node_isset(nodeid, numa_nodes_parsed)) {
 			pr_info("Node %d already present, skipping\n",
 				nodeid);
 			continue;
@@ -167,11 +167,10 @@ int __init amd_numa_init(void)
 
 		prevbase = base;
 		numa_add_memblk(nodeid, base, limit);
-		node_set(nodeid, mem_nodes_parsed);
 		node_set(nodeid, numa_nodes_parsed);
 	}
 
-	if (!nodes_weight(mem_nodes_parsed))
+	if (!nodes_weight(numa_nodes_parsed))
 		return -ENOENT;
 
 	/*
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 6e4fbd7..8b1f178 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -37,7 +37,6 @@ struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
 nodemask_t numa_nodes_parsed __initdata;
-nodemask_t mem_nodes_parsed __initdata;
 
 struct memnode memnode;
 
@@ -344,6 +343,20 @@ static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 }
 
 /*
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
+/*
  * Sanity check to catch more bad NUMA configurations (they are amazingly
  * common).  Make sure the nodes cover all memory.
  */
@@ -379,7 +392,8 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	int i, j, nid;
 
 	/* Account for nodes with cpus and no memory */
-	nodes_or(node_possible_map, mem_nodes_parsed, numa_nodes_parsed);
+	node_possible_map = numa_nodes_parsed;
+	numa_nodemask_from_meminfo(&node_possible_map, mi);
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
@@ -824,7 +838,6 @@ static int dummy_numa_init(void)
 	       0LU, max_pfn << PAGE_SHIFT);
 
 	node_set(0, numa_nodes_parsed);
-	node_set(0, mem_nodes_parsed);
 	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
 
 	return 0;
@@ -852,7 +865,6 @@ void __init initmem_init(void)
 			set_apicid_to_node(j, NUMA_NO_NODE);
 
 		nodes_clear(numa_nodes_parsed);
-		nodes_clear(mem_nodes_parsed);
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 		memset(&numa_meminfo, 0, sizeof(numa_meminfo));
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 8185189..4f8e6cd 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -238,9 +238,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
 
-	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE))
-		node_set(node, mem_nodes_parsed);
-	else
+	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)
 		update_nodes_add(node, start, end);
 }
 
@@ -310,10 +308,9 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
 	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 
-	nodes_clear(mem_nodes_parsed);
 	for (i = 0; i < num_nodes; i++)
 		if (fake_nodes[i].start != fake_nodes[i].end)
-			node_set(i, mem_nodes_parsed);
+			node_set(i, numa_nodes_parsed);
 }
 
 static int null_slit_node_compare(int a, int b)
-- 
1.7.1

