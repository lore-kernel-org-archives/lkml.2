Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1GLJSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 05:18:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61601 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1GLJQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 05:16:17 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/13] x86: Use HAVE_MEMBLOCK_NODE_MAP
Date: Tue, 12 Jul 2011 11:15:57 +0200
Message-Id: <1310462166-31469-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310462166-31469-1-git-send-email-tj@kernel.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert x86 to HAVE_MEMBLOCK_NODE_MAP.  The only difference in memory
handling is that allocations can't no longer cross node boundaries
whether they're node affine or not, which shouldn't matter at all.

This conversion will enable further simplification of boot memory
handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig                |    1 +
 arch/x86/include/asm/memblock.h |    2 --
 arch/x86/mm/memblock.c          |   14 --------------
 arch/x86/mm/numa.c              |   15 +++++++--------
 4 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 37357a5..91aa1b4e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -25,6 +25,7 @@ config X86
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
 	select HAVE_DMA_ATTRS
diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 161792e..1460db2 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -12,8 +12,6 @@ int __get_free_all_memory_range(struct range **range, int nodeid,
 			 unsigned long start_pfn, unsigned long end_pfn);
 int get_free_all_memory_range(struct range **rangep, int nodeid);
 
-void memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long last_pfn);
 u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index e4569f8..97fbc39 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -283,20 +283,6 @@ static int __init memblock_x86_find_active_region(const struct memblock_region *
 	return 1;
 }
 
-/* Walk the memblock.memory map and register active regions within a node */
-void __init memblock_x86_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long last_pfn)
-{
-	unsigned long ei_startpfn;
-	unsigned long ei_endpfn;
-	struct memblock_region *r;
-
-	for_each_memblock(memory, r)
-		if (memblock_x86_find_active_region(r, start_pfn, last_pfn,
-					   &ei_startpfn, &ei_endpfn))
-			add_active_range(nid, ei_startpfn, ei_endpfn);
-}
-
 /*
  * Find the hole size (in bytes) in the memory range.
  * @start: starting address of the memory range to scan
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 824efad..f4a40bd 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -498,13 +498,10 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
-	for (i = 0; i < mi->nr_blks; i++)
-		memblock_x86_register_active_regions(mi->blk[i].nid,
-					mi->blk[i].start >> PAGE_SHIFT,
-					mi->blk[i].end >> PAGE_SHIFT);
-
-	/* for out of order entries */
-	sort_node_map();
+	for (i = 0; i < mi->nr_blks; i++) {
+		struct numa_memblk *mb = &mi->blk[i];
+		memblock_set_node(mb->start, mb->end - mb->start, mb->nid);
+	}
 
 	/*
 	 * If sections array is gonna be used for pfn -> nid mapping, check
@@ -538,6 +535,8 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 			setup_node_data(nid, start, end);
 	}
 
+	/* Dump memblock with node info and return. */
+	memblock_dump_all();
 	return 0;
 }
 
@@ -575,7 +574,7 @@ static int __init numa_init(int (*init_func)(void))
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-	remove_all_active_ranges();
+	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
 	ret = init_func();
-- 
1.7.6

