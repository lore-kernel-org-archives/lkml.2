Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab1BPM3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:29:03 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab1BPMVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:21:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=bcYXGjUEHGR3pHGBJuZj3xHoeMFnh9qHkv1yYaTqAe1BXYqeMQ1+7J5FQBrhiaCUu9
         PzkUPbki9wBufu+CqFLjSDsQknUZZUPElxqnPAGiD3bj26huJ2EuucOiDmZI16vy/wzv
         uLTTI/CGmf1s10iaKRKf67KaFdOvMpoG4+JuU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/33] x86-64, NUMA: Simplify hotplug node handling in acpi_numa_memory_affinity_init()
Date: Wed, 16 Feb 2011 13:20:36 +0100
Message-Id: <1297858867-25981-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
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
index 23498f8..988b0b7 100644
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

