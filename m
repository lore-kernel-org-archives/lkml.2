Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1DDWYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47295 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1DDWYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=dx+f12g2EN6OYPyQo09fPQ3w2aFnmIe7LE+vRddzu3cXfP/Qdx6XG9pc3hOaK/btNF
         eOSYQISQk1mp3ElRPBrmQFbuzj1DueWyjXM4mTNE3eJ5jE9XURfxS1Ro1kdBbQMgrrPf
         8FRNvA/+2Oqxq3rnfKoeQ54dZQTcVRGVIGS30=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/14] x86-32, NUMA: Calculate remap size in common code
Date: Tue,  5 Apr 2011 00:23:53 +0200
Message-Id: <1301955840-7246-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only pgdat and memmap use remap area and there isn't much benefit in
allowing per-node override.  In addition, the use of node_remap_size[]
is confusing in that it contains number of bytes before remap
initialization and then number of pages afterwards.

Move remap size calculation for memap from specific NUMA config
implementations to init_alloc_remap() and make node_remap_size[]
static.

The only behavior difference is that, before this patch, numaq_32
didn't consider max_pfn when calculating the memmap size but it's
enforced after this patch, which is the right thing to do.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/topology.h |    1 -
 arch/x86/kernel/apic/numaq_32.c |    4 ----
 arch/x86/mm/numa_32.c           |   10 ++++------
 arch/x86/mm/srat_32.c           |    1 -
 4 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 910a708..8dba769 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -95,7 +95,6 @@ extern void setup_node_to_cpumask_map(void);
 #ifdef CONFIG_X86_32
 extern unsigned long node_start_pfn[];
 extern unsigned long node_end_pfn[];
-extern unsigned long node_remap_size[];
 #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
 
 # define SD_CACHE_NICE_TRIES	1
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 6273eee..0aced70 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -93,10 +93,6 @@ static inline void numaq_register_node(int node, struct sys_cfg_data *scd)
 						node_end_pfn[node]);
 
 	memory_present(node, node_start_pfn[node], node_end_pfn[node]);
-
-	node_remap_size[node] = node_memmap_size_bytes(node,
-					node_start_pfn[node],
-					node_end_pfn[node]);
 }
 
 /*
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 99310d2..9a73365 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -104,7 +104,7 @@ extern unsigned long highend_pfn, highstart_pfn;
 
 #define LARGE_PAGE_BYTES (PTRS_PER_PTE * PAGE_SIZE)
 
-unsigned long node_remap_size[MAX_NUMNODES];
+static unsigned long node_remap_size[MAX_NUMNODES];
 static void *node_remap_start_vaddr[MAX_NUMNODES];
 void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
 
@@ -129,7 +129,6 @@ int __init get_memcfg_numa_flat(void)
 	node_end_pfn[0] = max_pfn;
 	memblock_x86_register_active_regions(0, 0, max_pfn);
 	memory_present(0, 0, max_pfn);
-	node_remap_size[0] = node_memmap_size_bytes(0, 0, max_pfn);
 
         /* Indicate there is one node available. */
 	nodes_clear(node_online_map);
@@ -282,11 +281,10 @@ static __init unsigned long init_alloc_remap(int nid, unsigned long offset)
 	if (node_end_pfn[nid] > max_pfn)
 		node_end_pfn[nid] = max_pfn;
 
-	/* ensure the remap includes space for the pgdat. */
-	size = node_remap_size[nid];
+	/* calculate the necessary space aligned to large page size */
+	size = node_memmap_size_bytes(nid, node_start_pfn[nid],
+				      min(node_end_pfn[nid], max_pfn));
 	size += ALIGN(sizeof(pg_data_t), PAGE_SIZE);
-
-	/* align to large page */
 	size = ALIGN(size, LARGE_PAGE_BYTES);
 
 	node_pa = memblock_find_in_range(node_start_pfn[nid] << PAGE_SHIFT,
diff --git a/arch/x86/mm/srat_32.c b/arch/x86/mm/srat_32.c
index 48651c6..1b9e82c 100644
--- a/arch/x86/mm/srat_32.c
+++ b/arch/x86/mm/srat_32.c
@@ -276,7 +276,6 @@ int __init get_memcfg_from_srat(void)
 		unsigned long end = min(node_end_pfn[nid], max_pfn);
 
 		memory_present(nid, start, end);
-		node_remap_size[nid] = node_memmap_size_bytes(nid, start, end);
 	}
 	return 1;
 out_fail:
-- 
1.7.1

