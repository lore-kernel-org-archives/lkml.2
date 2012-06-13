Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2FPUhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:37:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:39468 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2FPUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:37:11 -0400
Message-ID: <201206162037.q5GKbBaU017780@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 13 Jun 2012 14:46:40 -0400
Subject: [PATCH 2/3] arch/tile: enable ZONE_DMA for tilegx
In-Reply-To: <201206162036.q5GKacEK017774@lab-41.internal.tilera.com>
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for PCI root complex legacy support and USB OHCI root
complex support.  With this change tilegx now supports allocating memory
whose PA fits in 32 bits.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig          |    3 +++
 arch/tile/kernel/pci-dma.c |   15 +++++++++------
 arch/tile/kernel/setup.c   |   12 +++++++++++-
 arch/tile/mm/init.c        |   11 +++++------
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index a5302d3..0ad771f 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -212,6 +212,9 @@ config HIGHMEM
 
 	  If unsure, say "true".
 
+config ZONE_DMA
+	def_bool y
+
 # We do not currently support disabling NUMA.
 config NUMA
 	bool # "NUMA Memory Allocation and Scheduler Support"
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index 9814d70..edd856a 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -45,14 +45,17 @@ void *dma_alloc_coherent(struct device *dev,
 	gfp |= __GFP_ZERO;
 
 	/*
-	 * By forcing NUMA node 0 for 32-bit masks we ensure that the
-	 * high 32 bits of the resulting PA will be zero.  If the mask
-	 * size is, e.g., 24, we may still not be able to guarantee a
-	 * suitable memory address, in which case we will return NULL.
-	 * But such devices are uncommon.
+	 * If the mask specifies that the memory be in the first 4 GB, then
+	 * we force the allocation to come from the DMA zone.  We also
+	 * force the node to 0 since that's the only node where the DMA
+	 * zone isn't empty.  If the mask size is smaller than 32 bits, we
+	 * may still not be able to guarantee a suitable memory address, in
+	 * which case we will return NULL.  But such devices are uncommon.
 	 */
-	if (dma_mask <= DMA_BIT_MASK(32))
+	if (dma_mask <= DMA_BIT_MASK(32)) {
+		gfp |= GFP_DMA;
 		node = 0;
+	}
 
 	pg = homecache_alloc_pages_node(node, gfp, order, PAGE_HOME_DMA);
 	if (pg == NULL)
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6d179df..fdde3b6 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -658,6 +658,8 @@ static void __init zone_sizes_init(void)
 	unsigned long zones_size[MAX_NR_ZONES] = { 0 };
 	int size = percpu_size();
 	int num_cpus = smp_height * smp_width;
+	const unsigned long dma_end = (1UL << (32 - PAGE_SHIFT));
+
 	int i;
 
 	for (i = 0; i < num_cpus; ++i)
@@ -729,6 +731,14 @@ static void __init zone_sizes_init(void)
 		zones_size[ZONE_NORMAL] = end - start;
 #endif
 
+		if (start < dma_end) {
+			zones_size[ZONE_DMA] = min(zones_size[ZONE_NORMAL],
+						   dma_end - start);
+			zones_size[ZONE_NORMAL] -= zones_size[ZONE_DMA];
+		} else {
+			zones_size[ZONE_DMA] = 0;
+		}
+
 		/* Take zone metadata from controller 0 if we're isolnode. */
 		if (node_isset(i, isolnodes))
 			NODE_DATA(i)->bdata = &bootmem_node_data[0];
@@ -738,7 +748,7 @@ static void __init zone_sizes_init(void)
 		       PFN_UP(node_percpu[i]));
 
 		/* Track the type of memory on each node */
-		if (zones_size[ZONE_NORMAL])
+		if (zones_size[ZONE_NORMAL] || zones_size[ZONE_DMA])
 			node_set_state(i, N_NORMAL_MEMORY);
 #ifdef CONFIG_HIGHMEM
 		if (end != start)
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index a2417a0..ef29d6c 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -733,16 +733,15 @@ static void __init set_non_bootmem_pages_init(void)
 	for_each_zone(z) {
 		unsigned long start, end;
 		int nid = z->zone_pgdat->node_id;
+#ifdef CONFIG_HIGHMEM
 		int idx = zone_idx(z);
+#endif
 
 		start = z->zone_start_pfn;
-		if (start == 0)
-			continue;  /* bootmem */
 		end = start + z->spanned_pages;
-		if (idx == ZONE_NORMAL) {
-			BUG_ON(start != node_start_pfn[nid]);
-			start = node_free_pfn[nid];
-		}
+		start = max(start, node_free_pfn[nid]);
+		start = max(start, max_low_pfn);
+
 #ifdef CONFIG_HIGHMEM
 		if (idx == ZONE_HIGHMEM)
 			totalhigh_pages += z->spanned_pages;
-- 
1.7.10.3

