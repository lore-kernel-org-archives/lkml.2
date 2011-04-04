Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1DDWYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:24:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1DDWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=d05V+glFhNjHfu+PGil3M6UHfyMBnVEbAgETzIKX6R+W+5pCUza9Ud6fPLBZP1QtDy
         qSVeN05RNUcc/9zL71PYI43XDR+1TzHE8kqgqtpK9drdezNvZvAM1EoZpi4HKB4vIhBb
         pSQGY106Q05f+Df/gVOMQw58rUvx3Fk46NXDc=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, rientjes@google.com,
        yinghai@kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/14] x86-32, NUMA: Update remap allocator comments
Date: Tue,  5 Apr 2011 00:24:00 +0200
Message-Id: <1301955840-7246-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301955840-7246-1-git-send-email-tj@kernel.org>
References: <1301955840-7246-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that remap allocator is cleaned up, update comments such that they
are in docbook function description format and reflect the actual
implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/numa_32.c |   56 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index f325e6f..c757c0a 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -176,17 +176,31 @@ static void __init allocate_pgdat(int nid)
 }
 
 /*
- * In the DISCONTIGMEM and SPARSEMEM memory model, a portion of the kernel
- * virtual address space (KVA) is reserved and portions of nodes are mapped
- * using it. This is to allow node-local memory to be allocated for
- * structures that would normally require ZONE_NORMAL. The memory is
- * allocated with alloc_remap() and callers should be prepared to allocate
- * from the bootmem allocator instead.
+ * Remap memory allocator
  */
 static unsigned long node_remap_start_pfn[MAX_NUMNODES];
 static void *node_remap_end_vaddr[MAX_NUMNODES];
 static void *node_remap_alloc_vaddr[MAX_NUMNODES];
 
+/**
+ * alloc_remap - Allocate remapped memory
+ * @nid: NUMA node to allocate memory from
+ * @size: The size of allocation
+ *
+ * Allocate @size bytes from the remap area of NUMA node @nid.  The
+ * size of the remap area is predetermined by init_alloc_remap() and
+ * only the callers considered there should call this function.  For
+ * more info, please read the comment on top of init_alloc_remap().
+ *
+ * The caller must be ready to handle allocation failure from this
+ * function and fall back to regular memory allocator in such cases.
+ *
+ * CONTEXT:
+ * Single CPU early boot context.
+ *
+ * RETURNS:
+ * Pointer to the allocated memory on success, %NULL on failure.
+ */
 void *alloc_remap(int nid, unsigned long size)
 {
 	void *allocation = node_remap_alloc_vaddr[nid];
@@ -238,6 +252,28 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
+/**
+ * init_alloc_remap - Initialize remap allocator for a NUMA node
+ * @nid: NUMA node to initizlie remap allocator for
+ *
+ * NUMA nodes may end up without any lowmem.  As allocating pgdat and
+ * memmap on a different node with lowmem is inefficient, a special
+ * remap allocator is implemented which can be used by alloc_remap().
+ *
+ * For each node, the amount of memory which will be necessary for
+ * pgdat and memmap is calculated and two memory areas of the size are
+ * allocated - one in the node and the other in lowmem; then, the area
+ * in the node is remapped to the lowmem area.
+ *
+ * As pgdat and memmap must be allocated in lowmem anyway, this
+ * doesn't waste lowmem address space; however, the actual lowmem
+ * which gets remapped over is wasted.  The amount shouldn't be
+ * problematic on machines this feature will be used.
+ *
+ * Initialization failure isn't fatal.  alloc_remap() is used
+ * opportunistically and the callers will fall back to other memory
+ * allocation mechanisms on failure.
+ */
 static __init void init_alloc_remap(int nid)
 {
 	unsigned long size, pfn;
@@ -306,14 +342,6 @@ void __init initmem_init(void)
 {
 	int nid;
 
-	/*
-	 * When mapping a NUMA machine we allocate the node_mem_map arrays
-	 * from node local memory.  They are then mapped directly into KVA
-	 * between zone normal and vmalloc space.  Calculate the size of
-	 * this space and use it to adjust the boundary between ZONE_NORMAL
-	 * and ZONE_HIGHMEM.
-	 */
-
 	get_memcfg_numa();
 	numa_init_array();
 
-- 
1.7.1

