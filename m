Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab1D2PaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:30:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47758 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab1D2PaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:30:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=MZja4otfpzX5503OwNF2+O02tk6tlTidLazOMFOmjLDTtSKEmWJOC3nsgQEkx6VlPf
         gFXEsa3CcZKf2qGdHD7xgGhobPzcGOZxvUw/PgvKVzM9Z8tOud9PvvxjQjeXSOZA8WHq
         41TN1jPOfWAjHZHzBsa6TNZiDpGYft/V5KX2E=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/25] x86-32, NUMA: use sparse_memory_present_with_active_regions()
Date: Fri, 29 Apr 2011 17:28:26 +0200
Message-Id: <1304090924-8197-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling memory_present() for each region from NUMA init,
call sparse_memory_present_with_active_regions() from paging_init()
similarly to x86-64.

For flat and numaq, this results in exactly the same memory_present()
calls.  For srat, if there are multiple memory chunks for a node,
after this change, memory_present() will be called separately for each
chunk instead of being called once to encompass the whole range, which
doesn't cause any harm and actually is the better behavior.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/apic/numaq_32.c |    2 --
 arch/x86/mm/init_32.c           |    1 +
 arch/x86/mm/numa_32.c           |    1 -
 arch/x86/mm/srat_32.c           |    8 +-------
 4 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 0aced70..41b8b29 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -91,8 +91,6 @@ static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 
 	memblock_x86_register_active_regions(node, node_start_pfn[node],
 						node_end_pfn[node]);
-
-	memory_present(node, node_start_pfn[node], node_end_pfn[node]);
 }
 
 /*
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 80088f9..2cde0a3 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -716,6 +716,7 @@ void __init paging_init(void)
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 	olpc_dt_build_devicetree();
+	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	zone_sizes_init();
 }
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index e0d9716..f847fa1 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -119,7 +119,6 @@ int __init get_memcfg_numa_flat(void)
 	node_start_pfn[0] = 0;
 	node_end_pfn[0] = max_pfn;
 	memblock_x86_register_active_regions(0, 0, max_pfn);
-	memory_present(0, 0, max_pfn);
 
         /* Indicate there is one node available. */
 	nodes_clear(node_online_map);
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index ae20046..6b9bfd7 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -209,7 +209,7 @@ static __init int node_read_chunk(int nid, struct node_memory_chunk_s *memory_ch
 
 int __init get_memcfg_from_srat(void)
 {
-	int i, j, nid;
+	int i, j;
 
 	if (srat_disabled())
 		goto out_fail;
@@ -273,12 +273,6 @@ int __init get_memcfg_from_srat(void)
 	/* for out of order entries in SRAT */
 	sort_node_map();
 
-	for_each_online_node(nid) {
-		unsigned long start = node_start_pfn[nid];
-		unsigned long end = min(node_end_pfn[nid], max_pfn);
-
-		memory_present(nid, start, end);
-	}
 	return 1;
 out_fail:
 	printk(KERN_DEBUG "failed to get NUMA memory information from SRAT"
-- 
1.7.1

