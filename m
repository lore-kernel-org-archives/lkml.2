Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2IMHKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:10:36 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56097 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792Ab2IMHKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:10:33 -0400
MIME-Version: 1.0
Date: Thu, 13 Sep 2012 12:40:32 +0530
Message-ID: <CADysL2bCHAzkK4mRmc1Z_OdUiAor9cvEAKRV+zPUvURd_wQiFQ@mail.gmail.com>
Subject: [PATCH v6 1/2] ARM: new cache maintenance api for iommu
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e88037801393f86ade3c79bcc900d3c84d989655 Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Wed, 12 Sep 2012 13:07:26 +0530
Subject: [PATCH v6 1/2] ARM: new cache maintenance api for iommu

Non-coherent IOMMU drivers need to make sure
that the data held in the caches is available
for the slave processor MMU hardware whenever
there is an update to the page table memory of
the slave processor.

The page table memory is always updated from
the main processor and read from the slave
processor MMU.

A new cache maintenance api iommu_flush_area is
added to handle this.The implementation is based
on the dma cache apis.

Thanks to RMK's suggestions on creating a
dedicated API for this purpose.

ref:http://marc.info/?l=linux-kernel&m=131316512713815&w=2

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 arch/arm/include/asm/cacheflush.h |   21 +++++++++++++++++++++
 arch/arm/include/asm/glue-cache.h |    1 +
 arch/arm/mm/cache-fa.S            |   16 ++++++++++++++++
 arch/arm/mm/cache-v3.S            |   14 +++++++++++++-
 arch/arm/mm/cache-v4.S            |   15 +++++++++++++++
 arch/arm/mm/cache-v4wb.S          |   22 ++++++++++++++++++++++
 arch/arm/mm/cache-v4wt.S          |   18 ++++++++++++++++++
 arch/arm/mm/cache-v6.S            |   21 +++++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   22 ++++++++++++++++++++++
 arch/arm/mm/proc-arm1020.S        |   23 +++++++++++++++++++++++
 arch/arm/mm/proc-arm1020e.S       |   21 +++++++++++++++++++++
 arch/arm/mm/proc-arm1022.S        |   21 +++++++++++++++++++++
 arch/arm/mm/proc-arm1026.S        |   20 ++++++++++++++++++++
 arch/arm/mm/proc-arm920.S         |   18 ++++++++++++++++++
 arch/arm/mm/proc-arm922.S         |   18 ++++++++++++++++++
 arch/arm/mm/proc-arm925.S         |   23 +++++++++++++++++++++++
 arch/arm/mm/proc-arm926.S         |   23 +++++++++++++++++++++++
 arch/arm/mm/proc-arm940.S         |   26 ++++++++++++++++++++++++++
 arch/arm/mm/proc-arm946.S         |   25 +++++++++++++++++++++++++
 arch/arm/mm/proc-feroceon.S       |   32 ++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-macros.S         |    1 +
 arch/arm/mm/proc-mohawk.S         |   19 +++++++++++++++++++
 arch/arm/mm/proc-xsc3.S           |   18 ++++++++++++++++++
 arch/arm/mm/proc-xscale.S         |   20 ++++++++++++++++++++
 24 files changed, 457 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h
b/arch/arm/include/asm/cacheflush.h
index e4448e1..c772d75 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -84,6 +84,15 @@
  *		- kaddr  - page address
  *		- size   - region size
  *
+ *	iommu_flush_area(start, size)
+ *
+ *		Perform CPU specific cache operations are required to ensure
+ *		that the IOMMU page table mappings covering the speified block
+ *		memory are visible to the IOMMU. This api is intended for the
+ *		IOMMU page table memory, do not use this for the general data.
+ *		- start  - virtual start address
+ *		- size   - region size
+ *
  *	DMA Cache Coherency
  *	===================
  *
@@ -108,6 +117,7 @@ struct cpu_cache_fns {
 	void (*dma_unmap_area)(const void *, size_t, int);

 	void (*dma_flush_range)(const void *, const void *);
+	void (*iommu_flush_area)(const void *, size_t);
 };

 /*
@@ -135,6 +145,12 @@ extern struct cpu_cache_fns cpu_cache;
 #define dmac_unmap_area			cpu_cache.dma_unmap_area
 #define dmac_flush_range		cpu_cache.dma_flush_range

+/* This API is to support non-coherent IOMMUs. The purpose of
+ * this API is to ensure that the data held in the cache is visible
+ * to the MMU of the slave processor. Do not use this for general data.
+ */
+#define iommu_flush_area		(cpu_cache.iommu_flush_area)
+
 #else

 extern void __cpuc_flush_icache_all(void);
@@ -155,6 +171,11 @@ extern void dmac_map_area(const void *, size_t, int);
 extern void dmac_unmap_area(const void *, size_t, int);
 extern void dmac_flush_range(const void *, const void *);

+/* This API is to support non-coherent IOMMUs. The purpose of
+ * this API is to ensure that the data held in the cache is visible
+ * to the MMU of the slave processor. Do not use this for general data.
+ */
+extern void iommu_flush_area(const void *, size_t);
 #endif

 /*
diff --git a/arch/arm/include/asm/glue-cache.h
b/arch/arm/include/asm/glue-cache.h
index 7e30874..64f00b2 100644
--- a/arch/arm/include/asm/glue-cache.h
+++ b/arch/arm/include/asm/glue-cache.h
@@ -141,6 +141,7 @@
 #define dmac_map_area			__glue(_CACHE,_dma_map_area)
 #define dmac_unmap_area			__glue(_CACHE,_dma_unmap_area)
 #define dmac_flush_range		__glue(_CACHE,_dma_flush_range)
+#define iommu_flush_area		__glue(_CACHE, _iommu_flush_area)
 #endif

 #endif
diff --git a/arch/arm/mm/cache-fa.S b/arch/arm/mm/cache-fa.S
index 0720163..08f4761 100644
--- a/arch/arm/mm/cache-fa.S
+++ b/arch/arm/mm/cache-fa.S
@@ -217,6 +217,22 @@ ENTRY(fa_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *	- start   - virtual start address
+ *	- size    - size of region
+ */
+ENTRY(fa_iommu_flush_area)
+	add	r1, r1, r0
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
index 52e35f3..6a5a7f4 100644
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
@@ -107,6 +106,19 @@ ENTRY(v3_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start  - virtual start address
+ *	- size	 - size of region
+ */
+ENTRY(v3_iommu_flush_area)
+	mov	r0, #0
+	mcr	p15, 0, r0, c7, c0, 0		@ flush ID cache
+	mov	pc, lr
+
+/*
  *	dma_unmap_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v4.S b/arch/arm/mm/cache-v4.S
index 022135d..0c0877f 100644
--- a/arch/arm/mm/cache-v4.S
+++ b/arch/arm/mm/cache-v4.S
@@ -119,6 +119,21 @@ ENTRY(v4_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start  - virtual start address
+ *	- size	 - size of region
+ */
+ENTRY(v4_iommu_flush_area)
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
index 8f1eeae..e86bbbf 100644
--- a/arch/arm/mm/cache-v4wb.S
+++ b/arch/arm/mm/cache-v4wb.S
@@ -228,6 +228,28 @@ v4wb_dma_clean_range:
 	.set	v4wb_dma_flush_range, v4wb_coherent_kern_range

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start  - virtual start address
+ *	- size	 - size of region
+ */
+ENTRY(v4wb_iommu_flush_area)
+	add	r1, r1, r0
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
+ENDPROC(v4wb_iommu_flush_area)
+
+/*
  *	dma_map_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v4wt.S b/arch/arm/mm/cache-v4wt.S
index b34a5f9..36b9a37 100644
--- a/arch/arm/mm/cache-v4wt.S
+++ b/arch/arm/mm/cache-v4wt.S
@@ -174,6 +174,24 @@ v4wt_dma_inv_range:
 	.equ	v4wt_dma_flush_range, v4wt_dma_inv_range

 /*
+ *	iommu_flush_area(start, end)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start  - virtual start address
+ *	- size	 - size of region
+ */
+ENTRY(v4wt_iommu_flush_area)
+	add	r1, r1, r0
+	bic	r0, r0, #CACHE_DLINESIZE - 1
+1:	mcr	p15, 0, r0, c7, c6, 1		@ invalidate D entry
+	add	r0, r0, #CACHE_DLINESIZE
+	cmp	r0, r1
+	blo	1b
+	mov	pc, lr
+ENDPROC(v4wt_iommu_flush_area)
+
+/*
  *	dma_unmap_area(start, size, dir)
  *	- start	- kernel virtual start address
  *	- size	- size of region
diff --git a/arch/arm/mm/cache-v6.S b/arch/arm/mm/cache-v6.S
index 4b10760..9b516cc 100644
--- a/arch/arm/mm/cache-v6.S
+++ b/arch/arm/mm/cache-v6.S
@@ -326,6 +326,27 @@ ENTRY(v6_dma_unmap_area)
 	mov	pc, lr
 ENDPROC(v6_dma_unmap_area)

+/*
+ *	v6_iommu_flush_area(start, size)
+ *	- start   - virtual start address
+ *	- size    - size of region
+ */
+ENTRY(v6_iommu_flush_area)
+	add	r1, r1, r0
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
+ENDPROC(v6_iommu_flush_area)
 	__INITDATA

 	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 39e3fb3..6645d85 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -320,6 +320,28 @@ ENTRY(v7_dma_flush_range)
 	dsb
 	mov	pc, lr
 ENDPROC(v7_dma_flush_range)
+/*
+ *	v7_iommu_flush_area(start, size)
+ *	- start   - virtual start address
+ *	- size    - size of region
+ */
+ENTRY(v7_iommu_flush_area)
+	dcache_line_size r2, r3
+	add	r1, r0, r1
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
+ENDPROC(v7_iommu_flush_area)

 /*
  *	dma_map_area(start, size, dir)
diff --git a/arch/arm/mm/proc-arm1020.S b/arch/arm/mm/proc-arm1020.S
index 0650bb8..c10977b 100644
--- a/arch/arm/mm/proc-arm1020.S
+++ b/arch/arm/mm/proc-arm1020.S
@@ -345,6 +345,29 @@ ENTRY(arm1020_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm1020_iommu_flush_area)
+	add	r1, r1, r0
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
index 4188478..42d74d7 100644
--- a/arch/arm/mm/proc-arm1020e.S
+++ b/arch/arm/mm/proc-arm1020e.S
@@ -331,6 +331,27 @@ ENTRY(arm1020e_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm1020e_iommu_flush_area)
+	add	r1, r1, r0
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
index 33c6882..c1ce3f8 100644
--- a/arch/arm/mm/proc-arm1022.S
+++ b/arch/arm/mm/proc-arm1022.S
@@ -320,6 +320,27 @@ ENTRY(arm1022_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm1022_iommu_flush_area)
+	add	r1, r1, r0
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
index fbc1d5f..6ff2600 100644
--- a/arch/arm/mm/proc-arm1026.S
+++ b/arch/arm/mm/proc-arm1026.S
@@ -314,6 +314,26 @@ ENTRY(arm1026_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm1026_iommu_flush_area)
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
index 1a8c138..b8503fb 100644
--- a/arch/arm/mm/proc-arm920.S
+++ b/arch/arm/mm/proc-arm920.S
@@ -296,6 +296,24 @@ ENTRY(arm920_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm920_iommu_flush_area)
+	add	r1, r1, r0
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
index 4c44d7e..6e3bdc5 100644
--- a/arch/arm/mm/proc-arm922.S
+++ b/arch/arm/mm/proc-arm922.S
@@ -298,6 +298,24 @@ ENTRY(arm922_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm922_iommu_flush_area)
+	add	r1, r1, r0
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
index ec5b118..40e9f60 100644
--- a/arch/arm/mm/proc-arm925.S
+++ b/arch/arm/mm/proc-arm925.S
@@ -353,6 +353,29 @@ ENTRY(arm925_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size 	- size of region
+ */
+ENTRY(arm925_iommu_flush_area)
+	add	r1, r1, r0
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
index c31e62c..bef5b4c 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -316,6 +316,29 @@ ENTRY(arm926_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm926_iommu_flush_area)
+	add	r1, r1, r0
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
index a613a7d..fdc2fd9 100644
--- a/arch/arm/mm/proc-arm940.S
+++ b/arch/arm/mm/proc-arm940.S
@@ -244,6 +244,32 @@ ENTRY(arm940_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate a specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(arm940_iommu_flush_area)
+	add	r1, r1, r0
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
index 9f4f299..6fdfa92 100644
--- a/arch/arm/mm/proc-arm946.S
+++ b/arch/arm/mm/proc-arm946.S
@@ -287,6 +287,31 @@ ENTRY(arm946_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ *
+ * (same as arm926)
+ */
+ENTRY(arm946_iommu_flush_area)
+	add	r1, r1, r0
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
index 23a8e4c..0cb21cb 100644
--- a/arch/arm/mm/proc-feroceon.S
+++ b/arch/arm/mm/proc-feroceon.S
@@ -364,6 +364,25 @@ ENTRY(feroceon_dma_flush_range)
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr

+/*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+	.align	5
+ENTRY(feroceon_iommu_flush_area)
+	add	r1, r1, r0
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
@@ -377,6 +396,19 @@ ENTRY(feroceon_range_dma_flush_range)
 	mcr	p15, 0, r0, c7, c10, 4		@ drain WB
 	mov	pc, lr

+	.align	5
+ENTRY(feroceon_range_iommu_flush_area)
+	add	r1, r1, r0
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
index 2d8ff3a..e9b9c7e 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -307,6 +307,7 @@ ENTRY(\name\()_cache_fns)
 	.long	\name\()_dma_map_area
 	.long	\name\()_dma_unmap_area
 	.long	\name\()_dma_flush_range
+	.long	\name\()_iommu_flush_area
 	.size	\name\()_cache_fns, . - \name\()_cache_fns
 .endm

diff --git a/arch/arm/mm/proc-mohawk.S b/arch/arm/mm/proc-mohawk.S
index fbb2124..5e9f5b1 100644
--- a/arch/arm/mm/proc-mohawk.S
+++ b/arch/arm/mm/proc-mohawk.S
@@ -280,6 +280,25 @@ ENTRY(mohawk_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start	- virtual start address
+ *	- size	- size of region
+ */
+ENTRY(mohawk_iommu_flush_area)
+	add	r1, r1, r0
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
index b0d5786..073e91a 100644
--- a/arch/arm/mm/proc-xsc3.S
+++ b/arch/arm/mm/proc-xsc3.S
@@ -314,6 +314,24 @@ ENTRY(xsc3_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start  - virtual start address
+ *	- size	 - size of region
+ */
+ENTRY(xsc3_iommu_flush_area)
+	add	r1, r1, r0
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
index 4ffebaa..89b6e3e 100644
--- a/arch/arm/mm/proc-xscale.S
+++ b/arch/arm/mm/proc-xscale.S
@@ -374,6 +374,25 @@ ENTRY(xscale_dma_flush_range)
 	mov	pc, lr

 /*
+ *	iommu_flush_area(start, size)
+ *
+ *	Clean and invalidate the specified virtual address area.
+ *
+ *	- start  - virtual start address
+ *	- size	 - size of region
+ */
+ENTRY(xscale_iommu_flush_area)
+	add	r1, r1, r0
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
@@ -445,6 +464,7 @@ ENDPROC(xscale_dma_unmap_area)
 	a0_alias flush_kern_dcache_area
 	a0_alias dma_flush_range
 	a0_alias dma_unmap_area
+	a0_alias iommu_flush_area

 	@ define struct cpu_cache_fns (see <asm/cacheflush.h> and proc-macros.S)
 	define_cache_functions xscale_80200_A0_A1
-- 
1.7.0.4


-- 
regards
Ramesh Gupta G
