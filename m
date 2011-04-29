Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab1D2P3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab1D2P3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=q8hoGQuzNHvGqOpEMruwO+D+0ou0d/0ee8CXTu8EQzWtRaztDSLXnoXD50npk15dKK
         cuyxQNivOZ/xGFjJLBvvH0RB5xaL85SyF8Y8Z4DMb57QKkfWipHL3w5RZ4Ikt63eyzws
         iX5aYW77/HWzc7QpiBn20FokRdAQX7Wy1GCGU=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 25/25] x86, NUMA: Enable emulation on 32bit too
Date: Fri, 29 Apr 2011 17:28:44 +0200
Message-Id: <1304090924-8197-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that NUMA init path is unified, NUMA emulation can be enabled on
32bit.  Make numa_emluation.c safe on 32bit by doing the followings.

* Define MAX_DMA32_PFN on 32bit too.

* Include bootmem.h for max_pfn declaration.

* Use u64 explicitly and always use PFN_PHYS() when converting page
  number to address.

* Avoid __udivdi3() generation on 32bit by doing number of pages
  calculation instead in split_nodes_interleave().

And drop X86_64 dependency from Kconfig.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/Kconfig             |    2 +-
 arch/x86/include/asm/dma.h   |   10 +++-------
 arch/x86/mm/numa_emulation.c |   16 +++++++++++-----
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50cb68d..648fca4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1201,7 +1201,7 @@ config NODES_SPAN_OTHER_NODES
 
 config NUMA_EMU
 	bool "NUMA emulation"
-	depends on X86_64 && NUMA
+	depends on NUMA
 	---help---
 	  Enable NUMA emulation. A flat machine will be split
 	  into virtual nodes when booted with "numa=fake=N", where N is the
diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index d1a314b..0bdb0c5 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -72,19 +72,15 @@
 /* 16MB ISA DMA zone */
 #define MAX_DMA_PFN   ((16 * 1024 * 1024) >> PAGE_SHIFT)
 
-#ifdef CONFIG_X86_32
+/* 4GB broken PCI/AGP hardware bus master zone */
+#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
 
+#ifdef CONFIG_X86_32
 /* The maximum address that we can perform a DMA transfer to on this platform */
 #define MAX_DMA_ADDRESS      (PAGE_OFFSET + 0x1000000)
-
 #else
-
-/* 4GB broken PCI/AGP hardware bus master zone */
-#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)
-
 /* Compat define for old dma zone */
 #define MAX_DMA_ADDRESS ((unsigned long)__va(MAX_DMA_PFN << PAGE_SHIFT))
-
 #endif
 
 /* 8237 DMA controllers */
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index ad091e4..c0040f8 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>
 #include <asm/dma.h>
 
 #include "numa_internal.h"
@@ -84,7 +85,13 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 		nr_nodes = MAX_NUMNODES;
 	}
 
-	size = (max_addr - addr - memblock_x86_hole_size(addr, max_addr)) / nr_nodes;
+	/*
+	 * Calculate target node size.  x86_32 freaks on __udivdi3() so do
+	 * the division in ulong number of pages and convert back.
+	 */
+	size = max_addr - addr - memblock_x86_hole_size(addr, max_addr);
+	size = PFN_PHYS((unsigned long)(size >> PAGE_SHIFT) / nr_nodes);
+
 	/*
 	 * Calculate the number of big nodes that can be allocated as a result
 	 * of consolidating the remainder.
@@ -226,7 +233,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 	 */
 	while (nodes_weight(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
-			u64 dma32_end = MAX_DMA32_PFN << PAGE_SHIFT;
+			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
 			u64 start, limit, end;
 			int phys_blk;
 
@@ -298,7 +305,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 {
 	static struct numa_meminfo ei __initdata;
 	static struct numa_meminfo pi __initdata;
-	const u64 max_addr = max_pfn << PAGE_SHIFT;
+	const u64 max_addr = PFN_PHYS(max_pfn);
 	u8 *phys_dist = NULL;
 	size_t phys_size = numa_dist_cnt * numa_dist_cnt * sizeof(phys_dist[0]);
 	int max_emu_nid, dfl_phys_nid;
@@ -342,8 +349,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 	if (numa_dist_cnt) {
 		u64 phys;
 
-		phys = memblock_find_in_range(0,
-					      (u64)max_pfn_mapped << PAGE_SHIFT,
+		phys = memblock_find_in_range(0, PFN_PHYS(max_pfn_mapped),
 					      phys_size, PAGE_SIZE);
 		if (phys == MEMBLOCK_ERROR) {
 			pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
-- 
1.7.1

