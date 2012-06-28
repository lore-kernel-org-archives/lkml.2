Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2F1JcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:32:22 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:36260 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932671Ab2F1JcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:32:20 -0400
MIME-Version: 1.0
Date: Thu, 28 Jun 2012 15:02:08 +0530
Message-ID: <CADysL2awug0-69kKF9_q9tsJg9dWAOJ5BrXFYRfTE=LMeaSZyg@mail.gmail.com>
Subject: [PATCH v3 1/2] ARM: new cache maintenance api for iommu
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 95b900d845537ab755bfcef50e956ee03e89a2c5 Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Wed, 27 Jun 2012 16:50:32 +0530
Subject: [PATCH v3 1/2] ARM: new cache maintenance api for iommu

Non-coherent IOMMU drivers need to make sure
that the data held in the caches is available
for the slave processor MMU hardware whenever
there is an update to the page table memory of
the slave processor.

The page table memory is always updated from
the main processor and read from the slave
processor MMU.

A new cache maintenance api flush_iommu_mem is
added to handle this.The api clean and invalidate
the specified virtual address range (the page table
memory range that need to be flushed).The
implementation is based on the dma cache apis.

Thanks to RMK's suggestions on creating a
dedicated API for this purpose.

ref:http://marc.info/?l=linux-kernel&m=131316512713815&w=2

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 arch/arm/include/asm/cacheflush.h |   26 ++++++++++++++++++++++++++
 arch/arm/include/asm/glue-cache.h |    1 +
 arch/arm/mm/cache-fa.S            |   15 +++++++++++++++
 arch/arm/mm/cache-v3.S            |   14 +++++++++++++-
 arch/arm/mm/cache-v4.S            |   15 +++++++++++++++
 arch/arm/mm/cache-v4wb.S          |   21 +++++++++++++++++++++
 arch/arm/mm/cache-v4wt.S          |   17 +++++++++++++++++
 arch/arm/mm/cache-v6.S            |   20 ++++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   21 +++++++++++++++++++++
 arch/arm/mm/proc-arm1020.S        |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm1020e.S       |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm1022.S        |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm1026.S        |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm920.S         |   17 +++++++++++++++++
 arch/arm/mm/proc-arm922.S         |   17 +++++++++++++++++
 arch/arm/mm/proc-arm925.S         |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm926.S         |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm940.S         |   25 +++++++++++++++++++++++++
 arch/arm/mm/proc-arm946.S         |   24 ++++++++++++++++++++++++
 arch/arm/mm/proc-feroceon.S       |   30 ++++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 arch/arm/mm/proc-mohawk.S         |   18 ++++++++++++++++++
 arch/arm/mm/proc-xsc3.S           |   17 +++++++++++++++++
 arch/arm/mm/proc-xscale.S         |   19 +++++++++++++++++++
 24 files changed, 443 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h
b/arch/arm/include/asm/cacheflush.h
index d5d8d5c..64700e0 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -84,6 +84,16 @@
  *		- kaddr  - page address
  *		- size   - region size
  *
+ *	flush_iommu_mem(start, end)
+ *
+ *		Clean and invalidate the specified virtual address range.
+ *		This is	to support the non coherent iommu drivers.
+ *		The iommu driver need to call this api with the page
+ *		table memory address range to ensure the data held in
+ *		the cache is visible to the slave processor MMU.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
  *	DMA Cache Coherency
  *	===================
  *
@@ -108,6 +118,7 @@ struct cpu_cache_fns {
 	void (*dma_unmap_area)(const void *, size_t, int);

 	void (*dma_flush_range)(const void *, const void *);
+	void (*flush_iommu_mem)(const void *, const void *);
 };

 /*
@@ -135,6 +146,14 @@ extern struct cpu_cache_fns cpu_cache;
 #define dmac_unmap_area			cpu_cache.dma_unmap_area
 #define dmac_flush_range		cpu_cache.dma_flush_range

+/* This API is to support non-coherent IOMMUs. The purpose of
+ * this API is to ensure that the data held in the cache is visible
+ * to the MMU of the slave processor. This is called from
+ * the IOMMU driver whenever there is an update in the page tables
+ * for the slave processor.
+ */
+#define flush_iommu_mem			cpu_cache.flush_iommu_mem
+
 #else

 extern void __cpuc_flush_icache_all(void);
@@ -155,6 +174,13 @@ extern void dmac_map_area(const void *, size_t, int);
 extern void dmac_unmap_area(const void *, size_t, int);
 extern void dmac_flush_range(const void *, const void *);

+/* This API is to support non-coherent IOMMUs. The purpose of
+ * this API is to ensure that the data held in the cache is visible
+ * to the MMU of the slave processor. This is called from
+ * the IOMMU driver whenever there is an update in the page tables
+ * for the slave processor.
+ */
+extern void flush_iommu_mem(const void *, const void *);
 #endif

 /*
diff --git a/arch/arm/include/asm/glue-cache.h
b/arch/arm/include/asm/glue-cache.h
index 7e30874..2c2213b 100644
--- a/arch/arm/include/asm/glue-cache.h
+++ b/arch/arm/include/asm/glue-cache.h
@@ -141,6 +141,7 @@
 #define dmac_map_area			__glue(_CACHE,_dma_map_area)
 #define dmac_unmap_area			__glue(_CACHE,_dma_unmap_area)
 #define dmac_flush_range		__glue(_CACHE,_dma_flush_range)
+#define flush_iommu_mem			__glue(_CACHE,_flush_iommu_mem)
 #endif

 #endif
diff --git a/arch/arm/mm/cache-fa.S b/arch/arm/mm/cache-fa.S
index 0720163..83f646c 100644
--- a/arch/arm/mm/cache-fa.S
+++ b/arch/arm/mm/cache-fa.S
@@ -217,6 +217,21 @@ ENTRY(fa_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush__iommu_mem(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(fa_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v3.S b/arch/arm/mm/cache-v3.S
index c2301f2..a8827e8 100644
--- a/arch/arm/mm/cache-v3.S
+++ b/arch/arm/mm/cache-v3.S
@@ -20,7 +20,6 @@
 ENTRY(v3_flush_icache_all)
 	mov	pc, lr
 ENDPROC(v3_flush_icache_all)
-
 /*
  *	flush_user_cache_all()
  *
@@ -106,6 +105,19 @@ ENTRY(v3_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start  - virtual start address
+ *	- end	 - virtual end address
+ */
+ENTRY(v3_flush_iommu_range)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c0, 0		@ flush ID cache
+	mov	pc, lr
+
+/*
  *	dma_unmap_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v4.S b/arch/arm/mm/cache-v4.S
index fd9bb7a..b051856 100644
--- a/arch/arm/mm/cache-v4.S
+++ b/arch/arm/mm/cache-v4.S
@@ -118,6 +118,21 @@ ENTRY(v4_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mmu(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start  - virtual start address
+ *	- end	 - virtual end address
+ */
+ENTRY(v4_flush_iommu_mem)
+#ifdef CONFIG_CPU_CP15
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c7, 0		@ flush ID cache
+#endif
+	mov	pc, lr
+
+/*
  *	dma_unmap_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v4wb.S b/arch/arm/mm/cache-v4wb.S
index 4f2c141..cf153a2 100644
--- a/arch/arm/mm/cache-v4wb.S
+++ b/arch/arm/mm/cache-v4wb.S
@@ -228,6 +228,27 @@ v4wb_dma_clean_range:
 	.set	v4wb_dma_flush_range, v4wb_coherent_kern_range

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start  - virtual start address
+ *	- end	 - virtual end address
+ */
+ENTRY(v4wb_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mov	ip, #0
+	mcr	p15, 0, ip, c7, c5, 0		@ invalidate I cache
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+ENDPROC(v4wb_flush_iommu_mem)
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v4wt.S b/arch/arm/mm/cache-v4wt.S
index 4d7b467..e75f523 100644
--- a/arch/arm/mm/cache-v4wt.S
+++ b/arch/arm/mm/cache-v4wt.S
@@ -173,6 +173,23 @@ v4wt_dma_inv_range:
 	.equ	v4wt_dma_flush_range, v4wt_dma_inv_range

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start  - virtual start address
+ *	- end	 - virtual end address
+ */
+ENTRY(v4wt_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mov	pc, lr
+ENDPROC(v4wt_flush_iommu_mem)
+
+/*
  *	dma_unmap_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 74c2e5a..c6e0a6f 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -328,6 +328,26 @@ ENTRY(v6_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v6_dma_unmap_area)

+/*
+ *	v6_flush_iommu_mem(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(v6_flush_iommu_mem)
+	bic	r0, r0, #D_CACHE_LINE_SIZE - 1
+1:
+#ifdef HARVARD_CACHE
+	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D line
+#else
+	mcr	p15, 0, r0, c7, c15, 1		@ clean & invalidate line
+#endif
+	add	r0, r0, #D_CACHE_LINE_SIZE
+	cmp	r0, r1
+	blo	1b
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c10, 4		@ drain write buffer
+	mov	pc, lr
+ENDPROC(v6_flush_iommu_mem)
 	__INITDATA

 	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index a655d3d..9b30cf5 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -322,6 +322,27 @@ ENTRY(v7_dma_flush_range)
 	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_flush_range)
+/*
+ *	v7_flush_iommu_mem(start,end)
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+ENTRY(v7_flush_iommu_mem)
+	dcache_line_size r2, r3
+	sub	r3, r2, #1
+	bic	r0, r0, r3
+#ifdef CONFIG_ARM_ERRATA_764369
+	ALT_SMP(W(dsb))
+	ALT_UP(W(nop))
+#endif
+1:
+	mcr	p15, 0, r0, c7, c14, 1		@ clean & invalidate D / U line
+	add	r0, r0, r2
+	cmp	r0, r1
+	blo	1b
+	dsb
+	mov	pc, lr
+ENDPROC(v7_flush_iommu_mem)

 /*
  *	dma_map_area(start, size, dir)
diff --git a/arch/arm/mm/proc-arm1020.S b/arch/arm/mm/proc-arm1020.S
index 2349513..5ee0272 100644
--- a/arch/arm/mm/proc-arm1020.S
+++ b/arch/arm/mm/proc-arm1020.S
@@ -344,6 +344,28 @@ ENTRY(arm1020_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm1020_flush_iommu_mem)
+	mov	ip, #0
+#ifndef CONFIG_CPU_DCACHE_DISABLE
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+	mcr	p15, 0, ip, c7, c10, 4
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+#endif
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm1020e.S b/arch/arm/mm/proc-arm1020e.S
index c244b06..7888f6e 100644
--- a/arch/arm/mm/proc-arm1020e.S
+++ b/arch/arm/mm/proc-arm1020e.S
@@ -330,6 +330,26 @@ ENTRY(arm1020e_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm1020e_flush_iommu_mem)
+	mov	ip, #0
+#ifndef CONFIG_CPU_DCACHE_DISABLE
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+#endif
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm1022.S b/arch/arm/mm/proc-arm1022.S
index 38fe22e..6a48074 100644
--- a/arch/arm/mm/proc-arm1022.S
+++ b/arch/arm/mm/proc-arm1022.S
@@ -319,6 +319,26 @@ ENTRY(arm1022_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm1022_flush_iommu_mem)
+	mov	ip, #0
+#ifndef CONFIG_CPU_DCACHE_DISABLE
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+#endif
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm1026.S b/arch/arm/mm/proc-arm1026.S
index 3eb9c3c..b5574d7 100644
--- a/arch/arm/mm/proc-arm1026.S
+++ b/arch/arm/mm/proc-arm1026.S
@@ -313,6 +313,26 @@ ENTRY(arm1026_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm1026_flush_iommu_mem)
+	mov	ip, #0
+#ifndef CONFIG_CPU_DCACHE_DISABLE
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+#endif
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm920.S b/arch/arm/mm/proc-arm920.S
index cb941ae..fa4adcd 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -295,6 +295,23 @@ ENTRY(arm920_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm920_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm922.S b/arch/arm/mm/proc-arm922.S
index 4ec0e07..83810ab 100644
--- a/arch/arm/mm/proc-arm922.S
+++ b/arch/arm/mm/proc-arm922.S
@@ -297,6 +297,23 @@ ENTRY(arm922_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm922_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm925.S b/arch/arm/mm/proc-arm925.S
index 9dccd9a..31115a2 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -352,6 +352,28 @@ ENTRY(arm925_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm925_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:
+#ifndef CONFIG_CPU_DCACHE_WRITETHROUGH
+	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+#else
+	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+#endif
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index 820259b..3d8b2a8 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -315,6 +315,28 @@ ENTRY(arm926_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm926_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:
+#ifndef CONFIG_CPU_DCACHE_WRITETHROUGH
+	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+#else
+	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+#endif
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm940.S b/arch/arm/mm/proc-arm940.S
index 9fdc0a1..d788119 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -244,6 +244,31 @@ ENTRY(arm940_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate a specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(arm940_flush_iommu_mem)
+	mov	ip, #0
+	mov	r1, #(CACHE_DSEGMENTS - 1) << 4	@ 4 segments
+1:	orr	r3, r1, #(CACHE_DENTRIES - 1) << 26 @ 64 entries
+2:
+#ifndef CONFIG_CPU_DCACHE_WRITETHROUGH
+	mcr	p15, 0, r3, c7, c14, 2		@ clean/flush D entry
+#else
+	mcr	p15, 0, r3, c7, c6, 2		@ invalidate D entry
+#endif
+	subs	r3, r3, #1 << 26
+	bcs	2b				@ entries 63 to 0
+	subs	r1, r1, #1 << 4
+	bcs	1b				@ segments 7 to 0
+	mcr	p15, 0, ip, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-arm946.S b/arch/arm/mm/proc-arm946.S
index f684cfe..7276759 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -286,6 +286,30 @@ ENTRY(arm946_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ *
+ * (same as arm926)
+ */
+ENTRY(arm946_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:
+#ifndef CONFIG_CPU_DCACHE_WRITETHROUGH
+	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+#else
+	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+#endif
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-feroceon.S b/arch/arm/mm/proc-feroceon.S
index ba3c500..29f52ea 100644
--- a/arch/arm/mm/proc-feroceon.S
+++ b/arch/arm/mm/proc-feroceon.S
@@ -363,6 +363,24 @@ ENTRY(feroceon_dma_flush_range)
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr

+/*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+	.align	5
+ENTRY(feroceon_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
 	.align	5
 ENTRY(feroceon_range_dma_flush_range)
 	mrs	r2, cpsr
@@ -376,6 +394,18 @@ ENTRY(feroceon_range_dma_flush_range)
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr

+	.align	5
+ENTRY(feroceon_range_flush_iommu_mem)
+	mrs	r2, cpsr
+	cmp	r1, r0
+	subne	r1, r1, #1			@ top address is inclusive
+	orr	r3, r2, #PSR_I_BIT
+	msr	cpsr_c, r3			@ disable interrupts
+	mcr	p15, 5, r0, c15, c15, 0		@ D clean/inv range start
+	mcr	p15, 5, r1, c15, c15, 1		@ D clean/inv range top
+	msr	cpsr_c, r2			@ restore interrupts
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
 /*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index 2d8ff3a..a602b6a 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -307,6 +307,7 @@ ENTRY(\name\()_cache_fns)
 	.long	\name\()_dma_map_area
 	.long	\name\()_dma_unmap_area
 	.long	\name\()_dma_flush_range
+	.long	\name\()_flush_iommu_mem
 	.size	\name\()_cache_fns, . - \name\()_cache_fns
 .endm

diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index cdfedc5..ccbc929 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -279,6 +279,24 @@ ENTRY(mohawk_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start	- virtual start address
+ *	- end	- virtual end address
+ */
+ENTRY(mohawk_flush_iommu_mem)
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:
+	mcr	p15, 0, r0, c7, c14, 1		@ clean+invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-xsc3.S b/arch/arm/mm/proc-xsc3.S
index b0d5786..0422d7a 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -314,6 +314,23 @@ ENTRY(xsc3_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start  - virtual start address
+ *	- end	 - virtual end address
+ */
+ENTRY(xsc3_flush_iommu_mem)
+	bic	r0, r0, #CACHELINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c14, 1		@ clean/invalidate L1 D line
+	add	r0, r0, #CACHELINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ data write barrier
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/proc-xscale.S b/arch/arm/mm/proc-xscale.S
index 4ffebaa..03f30cb 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -374,6 +374,24 @@ ENTRY(xscale_dma_flush_range)
 	mov	pc, lr

 /*
+ *	flush_iommu_mem(start, end)
+ *
+ *	Clean and invalidate the specified virtual address range.
+ *
+ *	- start  - virtual start address
+ *	- end	 - virtual end address
+ */
+ENTRY(xscale_flush_iommu_mem)
+	bic	r0, r0, #CACHELINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c10, 1		@ clean D entry
+	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+	add	r0, r0, #CACHELINESIZE
+	cmp	r0, r1
+	blo	1b
+	mcr	p15, 0, r0, c7, c10, 4		@ Drain Write (& Fill) Buffer
+	mov	pc, lr
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
@@ -445,6 +463,7 @@ ENDPROC(xscale_dma_unmap_area)
 	a0_alias flush_kern_dcache_area
 	a0_alias dma_flush_range
 	a0_alias dma_unmap_area
+	a0_alias flush_iommu_mem

 	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
 	define_cache_functions xscale_80200_A0_A1
-- 
1.7.0.4
