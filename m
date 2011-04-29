Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab1D2PbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:31:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344Ab1D2P32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=CUg5qJPUmjmeQTJKGRGE+9UXzJYcqPN1kkWRarI71Sy+bF26apQDuUnfYlkTWVRmtA
         Ie6O8gJmzzHXQvPZ3kXUZ48CHvqZiVv0xihbYYSSzLH6++Ukti8JmOY3mmjks0kiUfSg
         cHCwtVm69tSo2UauP31klCwVbVKuM97gt0kmU=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/25] x86, NUMA: Initialize and use remap allocator from setup_node_bootmem()
Date: Fri, 29 Apr 2011 17:28:39 +0200
Message-Id: <1304090924-8197-21-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_node_bootmem() is taken from 64bit and doesn't use remap
allocator.  It's about to be shared with 32bit so add support for it.
If NODE_DATA is remapped, it's noted in the debug message and node
locality check is skipped as the __pa() of the remapped address
doesn't reflect the actual physical address.

On 64bit, remap allocator becomes noop and doesn't affect the
behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa.c          |   41 +++++++++++++++++++++++++++--------------
 arch/x86/mm/numa_32.c       |    2 +-
 arch/x86/mm/numa_internal.h |    6 ++++++
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index b2fca54..a37b382 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -197,7 +197,9 @@ static void __init setup_node_bootmem(int nid, u64 start, u64 end)
 	const u64 nd_low = PFN_PHYS(MAX_DMA_PFN);
 	const u64 nd_high = PFN_PHYS(max_pfn_mapped);
 	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+	bool remapped = false;
 	u64 nd_pa;
+	void *nd;
 	int tnid;
 
 	/*
@@ -207,34 +209,45 @@ static void __init setup_node_bootmem(int nid, u64 start, u64 end)
 	if (end && (end - start) < NODE_MIN_SIZE)
 		return;
 
+	/* initialize remap allocator before aligning to ZONE_ALIGN */
+	init_alloc_remap(nid, start, end);
+
 	start = roundup(start, ZONE_ALIGN);
 
 	printk(KERN_INFO "Initmem setup node %d %016Lx-%016Lx\n",
 	       nid, start, end);
 
 	/*
-	 * Try to allocate node data on local node and then fall back to
-	 * all nodes.  Never allocate in DMA zone.
+	 * Allocate node data.  Try remap allocator first, node-local
+	 * memory and then any node.  Never allocate in DMA zone.
 	 */
-	nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
+	nd = alloc_remap(nid, nd_size);
+	if (nd) {
+		nd_pa = __pa(nd);
+		remapped = true;
+	} else {
+		nd_pa = memblock_x86_find_in_range_node(nid, nd_low, nd_high,
 						nd_size, SMP_CACHE_BYTES);
-	if (nd_pa == MEMBLOCK_ERROR)
-		nd_pa = memblock_find_in_range(nd_low, nd_high,
-					       nd_size, SMP_CACHE_BYTES);
-	if (nd_pa == MEMBLOCK_ERROR) {
-		pr_err("Cannot find %zu bytes in node %d\n", nd_size, nid);
-		return;
+		if (nd_pa == MEMBLOCK_ERROR)
+			nd_pa = memblock_find_in_range(nd_low, nd_high,
+						nd_size, SMP_CACHE_BYTES);
+		if (nd_pa == MEMBLOCK_ERROR) {
+			pr_err("Cannot find %zu bytes in node %d\n",
+			       nd_size, nid);
+			return;
+		}
+		memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
+		nd = __va(nd_pa);
 	}
-	memblock_x86_reserve_range(nd_pa, nd_pa + nd_size, "NODE_DATA");
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [%016Lx - %016Lx]\n",
-	       nd_pa, nd_pa + nd_size - 1);
+	printk(KERN_INFO "  NODE_DATA [%016Lx - %016Lx]%s\n",
+	       nd_pa, nd_pa + nd_size - 1, remapped ? " (remapped)" : "");
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
-	if (tnid != nid)
+	if (!remapped && tnid != nid)
 		printk(KERN_INFO "    NODE_DATA(%d) on node %d\n", nid, tnid);
 
-	node_data[nid] = __va(nd_pa);
+	node_data[nid] = nd;
 	memset(NODE_DATA(nid), 0, sizeof(pg_data_t));
 	NODE_DATA(nid)->node_id = nid;
 	NODE_DATA(nid)->node_start_pfn = start >> PAGE_SHIFT;
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 9008632..fbd558f 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -265,7 +265,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
  * opportunistically and the callers will fall back to other memory
  * allocation mechanisms on failure.
  */
-static __init void init_alloc_remap(int nid, u64 start, u64 end)
+void __init init_alloc_remap(int nid, u64 start, u64 end)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long end_pfn = end >> PAGE_SHIFT;
diff --git a/arch/x86/mm/numa_internal.h b/arch/x86/mm/numa_internal.h
index ad86ec9..7178c3a 100644
--- a/arch/x86/mm/numa_internal.h
+++ b/arch/x86/mm/numa_internal.h
@@ -21,6 +21,12 @@ void __init numa_reset_distance(void);
 
 void __init x86_numa_init(void);
 
+#ifdef CONFIG_X86_64
+static inline void init_alloc_remap(int nid, u64 start, u64 end)	{ }
+#else
+void __init init_alloc_remap(int nid, u64 start, u64 end);
+#endif
+
 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
 			   int numa_dist_cnt);
-- 
1.7.1

