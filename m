Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab1BLRNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:13:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1BLRLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ansNw0cbpbhrvexThIs8elWTpABpzOBYPLPHuvc5xHIwn0ioNcGU2p22S7oUhnVDms
         vJz/aYb86DWZVizIKXUrvo0+NlABEq1aqe7NFU0HscCctsDeE5mQwtCPKBs7nQG2rmP1
         av4BEObsRH5bbebqqOltYNlMtgldST08N3ad8=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 19/26] x86-64, NUMA: Separate out numa_cleanup_meminfo()
Date: Sat, 12 Feb 2011 18:10:56 +0100
Message-Id: <1297530663-26234-20-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out numa_cleanup_meminfo() from numa_register_memblks().
node_possible_map initialization is moved to the top of the split
numa_register_memblks().

This patch doesn't cause behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   83 +++++++++++++++++++++++++++----------------------
 1 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 04ea17b..4f173a5 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -292,40 +292,8 @@ setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
 	node_set_online(nodeid);
 }
 
-/*
- * Sanity check to catch more bad NUMA configurations (they are amazingly
- * common).  Make sure the nodes cover all memory.
- */
-static int __init nodes_cover_memory(const struct bootnode *nodes)
+static int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 {
-	unsigned long numaram, e820ram;
-	int i;
-
-	numaram = 0;
-	for_each_node_mask(i, mem_nodes_parsed) {
-		unsigned long s = nodes[i].start >> PAGE_SHIFT;
-		unsigned long e = nodes[i].end >> PAGE_SHIFT;
-		numaram += e - s;
-		numaram -= __absent_pages_in_range(i, s, e);
-		if ((long)numaram < 0)
-			numaram = 0;
-	}
-
-	e820ram = max_pfn -
-		(memblock_x86_hole_size(0, max_pfn<<PAGE_SHIFT) >> PAGE_SHIFT);
-	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
-	if ((long)(e820ram - numaram) >= (1<<(20 - PAGE_SHIFT))) {
-		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
-			(numaram << PAGE_SHIFT) >> 20,
-			(e820ram << PAGE_SHIFT) >> 20);
-		return 0;
-	}
-	return 1;
-}
-
-static int __init numa_register_memblks(void)
-{
-	struct numa_meminfo *mi = &numa_meminfo;
 	int i;
 
 	/*
@@ -368,6 +336,49 @@ static int __init numa_register_memblks(void)
 		}
 	}
 
+	return 0;
+}
+
+/*
+ * Sanity check to catch more bad NUMA configurations (they are amazingly
+ * common).  Make sure the nodes cover all memory.
+ */
+static int __init nodes_cover_memory(const struct bootnode *nodes)
+{
+	unsigned long numaram, e820ram;
+	int i;
+
+	numaram = 0;
+	for_each_node_mask(i, mem_nodes_parsed) {
+		unsigned long s = nodes[i].start >> PAGE_SHIFT;
+		unsigned long e = nodes[i].end >> PAGE_SHIFT;
+		numaram += e - s;
+		numaram -= __absent_pages_in_range(i, s, e);
+		if ((long)numaram < 0)
+			numaram = 0;
+	}
+
+	e820ram = max_pfn - (memblock_x86_hole_size(0,
+					max_pfn << PAGE_SHIFT) >> PAGE_SHIFT);
+	/* We seem to lose 3 pages somewhere. Allow 1M of slack. */
+	if ((long)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
+		printk(KERN_ERR "NUMA: nodes only cover %luMB of your %luMB e820 RAM. Not used.\n",
+		       (numaram << PAGE_SHIFT) >> 20,
+		       (e820ram << PAGE_SHIFT) >> 20);
+		return 0;
+	}
+	return 1;
+}
+
+static int __init numa_register_memblks(struct numa_meminfo *mi)
+{
+	int i;
+
+	/* Account for nodes with cpus and no memory */
+	nodes_or(node_possible_map, mem_nodes_parsed, cpu_nodes_parsed);
+	if (WARN_ON(nodes_empty(node_possible_map)))
+		return -EINVAL;
+
 	memnode_shift = compute_hash_shift(mi);
 	if (memnode_shift < 0) {
 		printk(KERN_ERR "NUMA: No NUMA node hash function found. Contact maintainer\n");
@@ -820,12 +831,10 @@ void __init initmem_init(void)
 		nodes_clear(node_possible_map);
 		nodes_clear(node_online_map);
 #endif
-		/* Account for nodes with cpus and no memory */
-		nodes_or(node_possible_map, mem_nodes_parsed, cpu_nodes_parsed);
-		if (WARN_ON(nodes_empty(node_possible_map)))
+		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
 			continue;
 
-		if (numa_register_memblks() < 0)
+		if (numa_register_memblks(&numa_meminfo) < 0)
 			continue;
 
 		for (j = 0; j < nr_cpu_ids; j++) {
-- 
1.7.1

