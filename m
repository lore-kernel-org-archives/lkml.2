Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab1DGCJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:09:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:51067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab1DGCJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:09:20 -0400
Date: Thu, 7 Apr 2011 02:09:13 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tj@kernel.org, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1301955840-7246-15-git-send-email-tj@kernel.org>
References: <1301955840-7246-15-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86-32, numa: Update remap allocator comments
Message-ID: <tip-993ba1585cbb03fab012e41d1a5d24330a283b31@git.kernel.org>
Git-Commit-ID: 993ba1585cbb03fab012e41d1a5d24330a283b31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Apr 2011 02:09:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  993ba1585cbb03fab012e41d1a5d24330a283b31
Gitweb:     http://git.kernel.org/tip/993ba1585cbb03fab012e41d1a5d24330a283b31
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 5 Apr 2011 00:24:00 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 6 Apr 2011 17:57:56 -0700

x86-32, numa: Update remap allocator comments

Now that remap allocator is cleaned up, update comments such that they
are in docbook function description format and reflect the actual
implementation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1301955840-7246-15-git-send-email-tj@kernel.org
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
