Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0FCVlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:41:40 -0400
Received: from king.tilera.com ([72.1.168.226]:15795 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab0FCVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:41:39 -0400
Message-Id: <201006032141.o53LfZC9019335@lab-15.internal.tilera.com>
In-Reply-To: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
References: <201005290334.o4T3Y1FX029944@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 3 Jun 2010 17:32:17 -0400
Subject: [PATCH] arch/tile: respond to reviews of the second code submission.
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, lethal@linux-sh.org
X-OriginalArrivalTime: 03 Jun 2010 21:41:37.0927 (UTC) FILETIME=[8B9FB170:01CB0365]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change addresses DMA-related comments by FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> and Kconfig-related comments by Paul
Mundt <lethal@linux-sh.org>.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig                   |   20 +++-------
 arch/tile/include/asm/dma-mapping.h |    6 +---
 arch/tile/include/asm/io.h          |   65 +++++++++++++++++++++++++++++++++--
 arch/tile/include/asm/scatterlist.h |   21 +++++++++++
 arch/tile/kernel/pci-dma.c          |   23 +++++++-----
 arch/tile/kernel/setup.c            |    8 ++--
 arch/tile/mm/init.c                 |    2 +-
 7 files changed, 108 insertions(+), 37 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index b311484..290ef41 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -20,15 +20,9 @@ config GENERIC_PENDING_IRQ
 	def_bool y
 	depends on GENERIC_HARDIRQS && SMP
 
-config ZONE_DMA
-	def_bool y
-
 config SEMAPHORE_SLEEPERS
 	def_bool y
 
-config CC_OPTIMIZE_FOR_SIZE
-	def_bool y
-
 config HAVE_ARCH_ALLOC_REMAP
 	def_bool y
 
@@ -47,9 +41,6 @@ config GENERIC_TIME
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
-config CLOCKSOURCE_WATCHDOG
-	def_bool y
-
 # FIXME: tilegx can implement a more efficent rwsem.
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
@@ -74,6 +65,8 @@ config STACKTRACE_SUPPORT
 	def_bool y
 	select STACKTRACE
 
+# We use discontigmem for now; at some point we may want to switch
+# to sparsemem (Tilera bug 7996).
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
 
@@ -97,9 +90,6 @@ config SMP
 config DEBUG_COPY_FROM_USER
 	def_bool n
 
-config SERIAL_CONSOLE
-	def_bool y
-
 config HVC_TILE
 	select HVC_DRIVER
 	def_bool y
@@ -108,8 +98,8 @@ config TILE
 	def_bool y
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_FIND_NEXT_BIT
-	select RESOURCES_64BIT
 	select USE_GENERIC_SMP_HELPERS
+	select CC_OPTIMIZE_FOR_SIZE
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
@@ -325,7 +315,9 @@ endmenu  # Tilera-specific configuration
 menu "Bus options"
 
 config NO_IOMEM
-	bool
+	def_bool !PCI
+
+config NO_IOPORT
 	def_bool !PCI
 
 source "drivers/pci/Kconfig"
diff --git a/arch/tile/include/asm/dma-mapping.h b/arch/tile/include/asm/dma-mapping.h
index 7083e42..cf466b3 100644
--- a/arch/tile/include/asm/dma-mapping.h
+++ b/arch/tile/include/asm/dma-mapping.h
@@ -15,11 +15,6 @@
 #ifndef _ASM_TILE_DMA_MAPPING_H
 #define _ASM_TILE_DMA_MAPPING_H
 
-/*
- * IOMMU interface. See Documentation/PCI/PCI-DMA-mapping.txt and
- * Documentation/DMA-API.txt for documentation.
- */
-
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
 #include <linux/cache.h>
@@ -29,6 +24,7 @@
  * Note that on x86 and powerpc, there is a "struct dma_mapping_ops"
  * that is used for all the DMA operations.  For now, we don't have an
  * equivalent on tile, because we only have a single way of doing DMA.
+ * (Tilera bug 7994 to use dma_mapping_ops.)
  */
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
index f6fcf18..8c95bef 100644
--- a/arch/tile/include/asm/io.h
+++ b/arch/tile/include/asm/io.h
@@ -75,6 +75,63 @@ extern void _tile_writew(u16 val, unsigned long addr);
 extern void _tile_writel(u32 val, unsigned long addr);
 extern void _tile_writeq(u64 val, unsigned long addr);
 
+#else
+
+/*
+ * The Tile architecture does not support IOMEM unless PCI is enabled.
+ * Unfortunately we can't yet simply not declare these methods,
+ * since some generic code that compiles into the kernel, but
+ * we never run, uses them unconditionally.
+ */
+
+static inline int iomem_panic(void)
+{
+	panic("readb/writeb and friends do not exist on tile without PCI");
+	return 0;
+}
+
+static inline u8 _tile_readb(unsigned long addr)
+{
+	return iomem_panic();
+}
+
+static inline u16 _tile_readw(unsigned long addr)
+{
+	return iomem_panic();
+}
+
+static inline u32 _tile_readl(unsigned long addr)
+{
+	return iomem_panic();
+}
+
+static inline u64 _tile_readq(unsigned long addr)
+{
+	return iomem_panic();
+}
+
+static inline void _tile_writeb(u8  val, unsigned long addr)
+{
+	iomem_panic();
+}
+
+static inline void _tile_writew(u16 val, unsigned long addr)
+{
+	iomem_panic();
+}
+
+static inline void _tile_writel(u32 val, unsigned long addr)
+{
+	iomem_panic();
+}
+
+static inline void _tile_writeq(u64 val, unsigned long addr)
+{
+	iomem_panic();
+}
+
+#endif
+
 #define readb(addr) _tile_readb((unsigned long)addr)
 #define readw(addr) _tile_readw((unsigned long)addr)
 #define readl(addr) _tile_readl((unsigned long)addr)
@@ -125,8 +182,6 @@ static inline void *memcpy_toio(void *dst, void *src, int len)
 	return dst;
 }
 
-#endif
-
 /*
  * The Tile architecture does not support IOPORT, even with PCI.
  * Unfortunately we can't yet simply not declare these methods,
@@ -134,7 +189,11 @@ static inline void *memcpy_toio(void *dst, void *src, int len)
  * we never run, uses them unconditionally.
  */
 
-extern int ioport_panic(void);
+static inline int ioport_panic(void)
+{
+	panic("inb/outb and friends do not exist on tile");
+	return 0;
+}
 
 static inline u8 inb(unsigned long addr)
 {
diff --git a/arch/tile/include/asm/scatterlist.h b/arch/tile/include/asm/scatterlist.h
index 35d786f..c560424 100644
--- a/arch/tile/include/asm/scatterlist.h
+++ b/arch/tile/include/asm/scatterlist.h
@@ -1 +1,22 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _ASM_TILE_SCATTERLIST_H
+#define _ASM_TILE_SCATTERLIST_H
+
+#define ISA_DMA_THRESHOLD	(~0UL)
+
 #include <asm-generic/scatterlist.h>
+
+#endif /* _ASM_TILE_SCATTERLIST_H */
diff --git a/arch/tile/kernel/pci-dma.c b/arch/tile/kernel/pci-dma.c
index b1ddc80..ed52447 100644
--- a/arch/tile/kernel/pci-dma.c
+++ b/arch/tile/kernel/pci-dma.c
@@ -112,19 +112,20 @@ void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 }
 EXPORT_SYMBOL(dma_unmap_single);
 
-int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+int dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	   enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(!valid_dma_direction(direction));
 
-	WARN_ON(nents == 0 || sg[0].length == 0);
+	WARN_ON(nents == 0 || sglist->length == 0);
 
-	for (i = 0; i < nents; i++) {
+	for_each_sg(sglist, sg, nents, i) {
 		struct page *page;
-		sg[i].dma_address = sg_phys(sg + i);
-		page = pfn_to_page(sg[i].dma_address >> PAGE_SHIFT);
+		sg->dma_address = sg_phys(sg);
+		page = pfn_to_page(sg->dma_address >> PAGE_SHIFT);
 		homecache_flush_cache(page, 0);
 	}
 
@@ -189,17 +190,19 @@ EXPORT_SYMBOL(dma_sync_sg_for_cpu);
 /*
  * Flush and invalidate cache for scatterlist.
  */
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sglist,
 			    int nelems, enum dma_data_direction direction)
 {
+	struct scatterlist *sg;
 	int i;
 
 	BUG_ON(!valid_dma_direction(direction));
-	WARN_ON(nelems == 0 || sg[0].length == 0);
+	WARN_ON(nelems == 0 || sglist->length == 0);
 
-	for (i = 0; i < nelems; i++)
-		dma_sync_single_for_device(dev, sg[i].dma_address,
-					   sg[i].dma_length, direction);
+	for_each_sg(sglist, sg, nelems, i) {
+		dma_sync_single_for_device(dev, sg->dma_address,
+					   sg_dma_len(sg), direction);
+	}
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
 
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 333262d..934136b 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -653,14 +653,14 @@ static void __init zone_sizes_init(void)
 
 #ifdef CONFIG_HIGHMEM
 		if (start > lowmem_end) {
-			zones_size[ZONE_DMA] = 0;
+			zones_size[ZONE_NORMAL] = 0;
 			zones_size[ZONE_HIGHMEM] = end - start;
 		} else {
-			zones_size[ZONE_DMA] = lowmem_end - start;
+			zones_size[ZONE_NORMAL] = lowmem_end - start;
 			zones_size[ZONE_HIGHMEM] = end - lowmem_end;
 		}
 #else
-		zones_size[ZONE_DMA] = end - start;
+		zones_size[ZONE_NORMAL] = end - start;
 #endif
 
 		/*
@@ -679,7 +679,7 @@ static void __init zone_sizes_init(void)
 		       PFN_UP(node_percpu[i]));
 
 		/* Track the type of memory on each node */
-		if (zones_size[ZONE_DMA])
+		if (zones_size[ZONE_NORMAL])
 			node_set_state(i, N_NORMAL_MEMORY);
 #ifdef CONFIG_HIGHMEM
 		if (end != start)
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 31b5c09..125ac53 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -742,7 +742,7 @@ static void __init set_non_bootmem_pages_init(void)
 		if (start == 0)
 			continue;  /* bootmem */
 		end = start + z->spanned_pages;
-		if (zone_idx(z) == ZONE_DMA) {
+		if (zone_idx(z) == ZONE_NORMAL) {
 			BUG_ON(start != node_start_pfn[nid]);
 			start = node_free_pfn[nid];
 		}
-- 
1.6.5.2

