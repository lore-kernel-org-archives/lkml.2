Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1BPMVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:21:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759053Ab1BPMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VT9Gy6dnM0i0W39EShTvzv352qb7r69dnkeEjT1czPDU8KErERHCATRKRmMVKJwFoe
         HExKC3iUVAhT3beqaheCzhmTxPRSUyVhGJBW3pzHuq4uzFhKTc3zd2OXIROI1D9otfgR
         y+K+RLNcJDNg9CaHOKFdK7GkdNXrTIP9/y7Z4=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/33] x86-64, NUMA: Unify use of memblk in all init methods
Date: Wed, 16 Feb 2011 13:20:48 +0100
Message-Id: <1297858867-25981-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make both amd and dummy use numa_add_memblk() to describe the detected
memory blocks.  This allows initmem_init() to call
numa_register_memblk() regardless of init method in use.  Drop custom
memory registration codes from amd and dummy.

After this change, memblk merge/cleanup in numa_register_memblks() is
applied to all init methods.

As this makes compute_hash_shift() and numa_register_memblks() used
only inside numa_64.c, make them static.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/numa_64.h |    4 ----
 arch/x86/mm/amdtopology_64.c   |   13 +------------
 arch/x86/mm/numa_64.c          |   15 +++++++--------
 arch/x86/mm/srat_64.c          |    5 -----
 4 files changed, 8 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 2b6a1c5..fbc9d33 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -8,9 +8,6 @@ struct bootnode {
 	u64 end;
 };
 
-extern int compute_hash_shift(struct bootnode *nodes, int numblks,
-			      int *nodeids);
-
 #define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 extern int numa_off;
@@ -34,7 +31,6 @@ extern struct bootnode numa_nodes[MAX_NUMNODES] __initdata;
 
 extern int __cpuinit numa_cpu_node(int cpu);
 extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
-extern int __init numa_register_memblks(void);
 
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index cf29527..d6d7aa4 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -167,6 +167,7 @@ int __init amd_numa_init(void)
 
 		numa_nodes[nodeid].start = base;
 		numa_nodes[nodeid].end = limit;
+		numa_add_memblk(nodeid, base, limit);
 
 		prevbase = base;
 
@@ -263,18 +264,6 @@ int __init amd_scan_nodes(void)
 {
 	int i;
 
-	memnode_shift = compute_hash_shift(numa_nodes, 8, NULL);
-	if (memnode_shift < 0) {
-		pr_err("No NUMA node hash function found. Contact maintainer\n");
-		return -1;
-	}
-	pr_info("Using node hash shift of %d\n", memnode_shift);
-
-	/* use the coreid bits from early_identify_cpu */
-	for_each_node_mask(i, node_possible_map)
-		memblock_x86_register_active_regions(i,
-				numa_nodes[i].start >> PAGE_SHIFT,
-				numa_nodes[i].end >> PAGE_SHIFT);
 	init_memory_mapping_high();
 	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, numa_nodes[i].start, numa_nodes[i].end);
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index a1d702d..552080e 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -131,8 +131,8 @@ static int __init extract_lsb_from_nodes(const struct bootnode *nodes,
 	return i;
 }
 
-int __init compute_hash_shift(struct bootnode *nodes, int numnodes,
-			      int *nodeids)
+static int __init compute_hash_shift(struct bootnode *nodes, int numnodes,
+				     int *nodeids)
 {
 	int shift;
 
@@ -287,7 +287,7 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	node_set_online(nodeid);
 }
 
-int __init numa_register_memblks(void)
+static int __init numa_register_memblks(void)
 {
 	int i;
 
@@ -713,17 +713,13 @@ static int dummy_numa_init(void)
 
 	node_set(0, cpu_nodes_parsed);
 	node_set(0, mem_nodes_parsed);
+	numa_add_memblk(0, 0, (u64)max_pfn << PAGE_SHIFT);
 
 	return 0;
 }
 
 static int dummy_scan_nodes(void)
 {
-	/* setup dummy node covering all memory */
-	memnode_shift = 63;
-	memnodemap = memnode.embedded_map;
-	memnodemap[0] = 0;
-	memblock_x86_register_active_regions(0, 0, max_pfn);
 	init_memory_mapping_high();
 	setup_node_bootmem(0, 0, max_pfn << PAGE_SHIFT);
 	numa_init_array();
@@ -784,6 +780,9 @@ void __init initmem_init(void)
 		if (WARN_ON(nodes_empty(node_possible_map)))
 			continue;
 
+		if (numa_register_memblks() < 0)
+			continue;
+
 		if (!scan_nodes[i]())
 			return;
 	}
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 341b371..69f1471 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -308,11 +308,6 @@ int __init acpi_scan_nodes(void)
 	if (acpi_numa <= 0)
 		return -1;
 
-	if (numa_register_memblks() < 0) {
-		bad_srat();
-		return -1;
-	}
-
 	/* for out of order entries in SRAT */
 	sort_node_map();
 	if (!nodes_cover_memory(numa_nodes)) {
-- 
1.7.1

