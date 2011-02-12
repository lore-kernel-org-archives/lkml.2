Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1BLRLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:11:36 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1BLRLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=S40+IOY/SzYkcBRIQkAll76TSTxrDlbcfUr0Kmr1bVMwN+XvsiKY7K1hu0Sz6/pkDo
         G7xhhqcBjM36SzI3nBUj9PaSIbgAHOq9beVGdzTOUqPd9ltMA5emnv37JWoRlaXuikit
         zszVShdYo1zUGJLJEUMol76glCrzWRbJAzxY4=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in acpi_numa_memory_affinity_init()
Date: Sat, 12 Feb 2011 18:10:39 +0100
Message-Id: <1297530663-26234-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hotplug node handling in acpi_numa_memory_affinity_init() was
unnecessarily complicated with storing the original nodes[] entry and
restoring it afterwards.  Simplify it by not modifying the nodes[]
entry for hotplug nodes from the beginning.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/srat_64.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 9a97261..e3e0dd3 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -251,7 +251,7 @@ update_nodes_add(int node, unsigned long start, unsigned long end)
 void __init
 acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 {
-	struct bootnode *nd, oldnode;
+	struct bootnode *nd;
 	unsigned long start, end;
 	int node, pxm;
 	int i;
@@ -289,28 +289,23 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		bad_srat();
 		return;
 	}
-	nd = &nodes[node];
-	oldnode = *nd;
-	if (!node_test_and_set(node, nodes_parsed)) {
-		nd->start = start;
-		nd->end = end;
-	} else {
-		if (start < nd->start)
-			nd->start = start;
-		if (nd->end < end)
-			nd->end = end;
-	}
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
 	       start, end);
 
-	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
+	if (!(ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)) {
+		nd = &nodes[node];
+		if (!node_test_and_set(node, nodes_parsed)) {
+			nd->start = start;
+			nd->end = end;
+		} else {
+			if (start < nd->start)
+				nd->start = start;
+			if (nd->end < end)
+				nd->end = end;
+		}
+	} else
 		update_nodes_add(node, start, end);
-		/* restore nodes[node] */
-		*nd = oldnode;
-		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
-	}
 
 	node_memblk_range[num_node_memblks].start = start;
 	node_memblk_range[num_node_memblks].end = end;
-- 
1.7.1

