Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2E2P6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:58:42 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:40158 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754007Ab2E2P6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:58:40 -0400
MIME-Version: 1.0
Date: Tue, 29 May 2012 21:22:33 +0530
Message-ID: <CADysL2Y+LaWPZ0v-2Gr5Ung-z09AHAYUD9wO3M3K8QV3oZbLhw@mail.gmail.com>
Subject: [PATCH] ARM: new cache maintenance api for iommu mem flush
From: "Gupta, Ramesh" <grgupta@ti.com>
To: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: tony@atomide.com, Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ba09674260c0c6e7d7efe900bbd379195b7001e2 Mon Sep 17 00:00:00 2001
From: Ramesh Gupta G <grgupta@ti.com>
Date: Mon, 28 May 2012 20:00:15 +0530
Subject: [PATCH] ARM: new cache maintenance api for iommu mem flush

non-coherent IOMMUs need to make sure that the
data held in the caches need to be visible for the
MMU hardware. A new L1 cache maintenance api has been
created to handle this. Thanks to RMK's suggestions on
creating a dedicated API for this purpose.

ref:
http://marc.info/?l=linux-kernel&m=131316512713815&w=2

Signed-off-by: Ramesh Gupta G <grgupta@ti.com>
---
 arch/arm/include/asm/cacheflush.h |   18 ++++++++++++++++++
 arch/arm/mm/cache-v7.S            |   26 ++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h
b/arch/arm/include/asm/cacheflush.h
index 004c1bc..3c1933b 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -84,6 +84,12 @@
  *		- kaddr  - page address
  *		- size   - region size
  *
+ *	flush_mem_range(start, end)
+ *
+ *		Clean and invalidate the specified virtual address range.
+ *		- start  - virtual start address
+ *		- end    - virtual end address
+ *
  *	DMA Cache Coherency
  *	===================
  *
@@ -108,6 +114,7 @@ struct cpu_cache_fns {
 	void (*dma_unmap_area)(const void *, size_t, int);

 	void (*dma_flush_range)(const void *, const void *);
+	void (*flush_mem_range)(const void *, const void *);
 };

 /*
@@ -135,6 +142,12 @@ extern struct cpu_cache_fns cpu_cache;
 #define dmac_unmap_area			cpu_cache.dma_unmap_area
 #define dmac_flush_range		cpu_cache.dma_flush_range

+/* This API is to support non-coherent IOMMUs. The purpose of
+ * this API is to ensure that data held in the cache is visible
+ * to MMU.
+ */
+
+#define flush_mem_range			cpu_cache.flush_mem_range
 #else

 extern void __cpuc_flush_icache_all(void);
@@ -154,6 +167,11 @@ extern void __cpuc_flush_dcache_area(void *, size_t);
 extern void dmac_map_area(const void *, size_t, int);
 extern void dmac_unmap_area(const void *, size_t, int);
 extern void dmac_flush_range(const void *, const void *);
+/* This API is to support non-coherent IOMMUs. The purpose of
+ * this API is to ensure that data held in the cache is visible
+ * to MMU.
+ */
+extern void flush_mem_range(const void *, const void *);

 #endif

diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 39e3fb3..018b1d0 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -300,11 +300,11 @@ v7_dma_clean_range:
 ENDPROC(v7_dma_clean_range)

 /*
- *	v7_dma_flush_range(start,end)
+ *	v7_flush_mem_range(start,end)
  *	- start   - virtual start address of region
  *	- end     - virtual end address of region
  */
-ENTRY(v7_dma_flush_range)
+ENTRY(v7_flush_mem_range)
 	dcache_line_size r2, r3
 	sub	r3, r2, #1
 	bic	r0, r0, r3
@@ -319,6 +319,28 @@ ENTRY(v7_dma_flush_range)
 	blo	1b
 	dsb
 	mov	pc, lr
+ENDPROC(v7_flush_mem_range)
+
+/*
+ *      v7_dma_flush_range(start,end)
+ *      - start   - virtual start address of region
+ *      - end     - virtual end address of region
+ */
+ENTRY(v7_dma_flush_range)
+        dcache_line_size r2, r3
+        sub     r3, r2, #1
+        bic     r0, r0, r3
+#ifdef CONFIG_ARM_ERRATA_764369
+        ALT_SMP(W(dsb))
+        ALT_UP(W(nop))
+#endif
+1:
+        mcr     p15, 0, r0, c7, c14, 1          @ clean & invalidate D / U line
+        add     r0, r0, r2
+        cmp     r0, r1
+        blo     1b
+        dsb
+        mov     pc, lr
 ENDPROC(v7_dma_flush_range)

 /*
-- 
1.7.0.4


Thank you and regards
Ramesh Gupta G
