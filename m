Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1GNVdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:33:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:34031 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344Ab1GNVdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:33:33 -0400
Date: Thu, 14 Jul 2011 21:33:21 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-0608f70c78a384c2f225f2de226ca057a196f108@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110714094423.GG3455@htj.dyndns.org>
References: <20110714094423.GG3455@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] x86: Use HAVE_MEMBLOCK_NODE_MAP
Git-Commit-ID: 0608f70c78a384c2f225f2de226ca057a196f108
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:33:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0608f70c78a384c2f225f2de226ca057a196f108
Gitweb:     http://git.kernel.org/tip/0608f70c78a384c2f225f2de226ca057a196f108
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Thu, 14 Jul 2011 11:44:23 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:47:43 -0700

x86: Use HAVE_MEMBLOCK_NODE_MAP

>From 5732e1247898d67cbf837585150fe9f68974671d Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 14 Jul 2011 11:22:16 +0200

Convert x86 to HAVE_MEMBLOCK_NODE_MAP.  The only difference in memory
handling is that allocations can't no longer cross node boundaries
whether they're node affine or not, which shouldn't matter at all.

This conversion will enable further simplification of boot memory
handling.

-v2: Fix build failure on !NUMA configurations discovered by hpa.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20110714094423.GG3455@htj.dyndns.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig                |    1 +
 arch/x86/include/asm/memblock.h |    2 --
 arch/x86/mm/init_32.c           |    8 ++++----
 arch/x86/mm/init_64.c           |    2 +-
 arch/x86/mm/memblock.c          |   14 --------------
 arch/x86/mm/numa.c              |   15 +++++++--------
 6 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index da34972..97f0894 100644
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
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 29f7c6d..5d173db 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -650,18 +650,18 @@ void __init initmem_init(void)
 	highstart_pfn = highend_pfn = max_pfn;
 	if (max_pfn > max_low_pfn)
 		highstart_pfn = max_low_pfn;
-	memblock_x86_register_active_regions(0, 0, highend_pfn);
-	sparse_memory_present_with_active_regions(0);
 	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
 		pages_to_mb(highend_pfn - highstart_pfn));
 	num_physpages = highend_pfn;
 	high_memory = (void *) __va(highstart_pfn * PAGE_SIZE - 1) + 1;
 #else
-	memblock_x86_register_active_regions(0, 0, max_low_pfn);
-	sparse_memory_present_with_active_regions(0);
 	num_physpages = max_low_pfn;
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE - 1) + 1;
 #endif
+
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
+	sparse_memory_present_with_active_regions(0);
+
 #ifdef CONFIG_FLATMEM
 	max_mapnr = num_physpages;
 #endif
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d865c4a..7fb064c 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -607,7 +607,7 @@ kernel_physical_mapping_init(unsigned long start,
 #ifndef CONFIG_NUMA
 void __init initmem_init(void)
 {
-	memblock_x86_register_active_regions(0, 0, max_pfn);
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 }
 #endif
 
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
