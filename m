Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab2EHJyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:54:55 -0400
Received: from mail.southpole.se ([193.12.106.18]:56643 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab2EHJyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:54:10 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH 5/6] openrisc: provide dma_map_ops
Date: Tue,  8 May 2012 11:54:04 +0200
Message-Id: <1336470845-13859-6-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1336470845-13859-1-git-send-email-jonas@southpole.se>
References: <1336470845-13859-1-git-send-email-jonas@southpole.se>
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 70848-09028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This switches OpenRISC over to fully using the generic dma-mapping
framework.  This was almost already the case as the architecture's
implementation was essentially a copy of the generic header.

This also brings this architecture in line with the recent changes
to dma_map_ops (adding attributes to ops->alloc).

Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/include/asm/dma-mapping.h |  147 +++++++------------------------
 arch/openrisc/kernel/dma.c              |  109 +++++++++++++++--------
 2 files changed, 107 insertions(+), 149 deletions(-)

diff --git a/arch/openrisc/include/asm/dma-mapping.h b/arch/openrisc/include/asm/dma-mapping.h
index b206ba4..fab8628 100644
--- a/arch/openrisc/include/asm/dma-mapping.h
+++ b/arch/openrisc/include/asm/dma-mapping.h
@@ -20,150 +20,71 @@
 /*
  * See Documentation/DMA-API-HOWTO.txt and
  * Documentation/DMA-API.txt for documentation.
- *
- * This file is written with the intention of eventually moving over
- * to largely using asm-generic/dma-mapping-common.h in its place.
  */
 
 #include <linux/dma-debug.h>
 #include <asm-generic/dma-coherent.h>
 #include <linux/kmemcheck.h>
+#include <linux/dma-mapping.h>
 
 #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
 
+extern struct dma_map_ops or1k_dma_map_ops;
 
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
-			      dma_addr_t *dma_handle, gfp_t flag);
-void or1k_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-			    dma_addr_t dma_handle);
-dma_addr_t or1k_map_page(struct device *dev, struct page *page,
-			 unsigned long offset, size_t size,
-			 enum dma_data_direction dir,
-			 struct dma_attrs *attrs);
-void or1k_unmap_page(struct device *dev, dma_addr_t dma_handle,
-		     size_t size, enum dma_data_direction dir,
-		     struct dma_attrs *attrs);
-int or1k_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir,
-		struct dma_attrs *attrs);
-void or1k_unmap_sg(struct device *dev, struct scatterlist *sg,
-		   int nents, enum dma_data_direction dir,
-		   struct dma_attrs *attrs);
-void or1k_sync_single_for_cpu(struct device *dev,
-			      dma_addr_t dma_handle, size_t size,
-			      enum dma_data_direction dir);
-void or1k_sync_single_for_device(struct device *dev,
-			         dma_addr_t dma_handle, size_t size,
-			         enum dma_data_direction dir);
-
-static inline void *dma_alloc_coherent(struct device *dev, size_t size,
-					dma_addr_t *dma_handle, gfp_t flag)
+static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 {
-	void *memory;
-
-	memory = or1k_dma_alloc_coherent(dev, size, dma_handle, flag);
-
-	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
-	return memory;
+	return &or1k_dma_map_ops;
 }
 
-static inline void dma_free_coherent(struct device *dev, size_t size,
-				     void *cpu_addr, dma_addr_t dma_handle)
-{
-	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-	or1k_dma_free_coherent(dev, size, cpu_addr, dma_handle);
-}
+#include <asm-generic/dma-mapping-common.h>
 
-static inline dma_addr_t dma_map_single(struct device *dev, void *ptr,
-					size_t size,
-					enum dma_data_direction dir)
-{
-	dma_addr_t addr;
-
-	kmemcheck_mark_initialized(ptr, size);
-	BUG_ON(!valid_dma_direction(dir));
-	addr = or1k_map_page(dev, virt_to_page(ptr),
-			     (unsigned long)ptr & ~PAGE_MASK, size,
-			     dir, NULL);
-	debug_dma_map_page(dev, virt_to_page(ptr),
-			   (unsigned long)ptr & ~PAGE_MASK, size,
-			   dir, addr, true);
-	return addr;
-}
+#define dma_alloc_coherent(d,s,h,f) dma_alloc_attrs(d,s,h,f,NULL) 
 
-static inline void dma_unmap_single(struct device *dev, dma_addr_t addr,
-					  size_t size,
-					  enum dma_data_direction dir)
+static inline void *dma_alloc_attrs(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    struct dma_attrs *attrs)
 {
-	BUG_ON(!valid_dma_direction(dir));
-	or1k_unmap_page(dev, addr, size, dir, NULL);
-	debug_dma_unmap_page(dev, addr, size, dir, true);
-}
+	struct dma_map_ops *ops = get_dma_ops(dev);
+	void *memory;
 
-static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
-				   int nents, enum dma_data_direction dir)
-{
-	int i, ents;
-	struct scatterlist *s;
+	memory = ops->alloc(dev, size, dma_handle, gfp, attrs);
 
-	for_each_sg(sg, s, nents, i)
-		kmemcheck_mark_initialized(sg_virt(s), s->length);
-	BUG_ON(!valid_dma_direction(dir));
-	ents = or1k_map_sg(dev, sg, nents, dir, NULL);
-	debug_dma_map_sg(dev, sg, nents, ents, dir);
+	debug_dma_alloc_coherent(dev, size, *dma_handle, memory);
 
-	return ents;
+	return memory;
 }
 
-static inline void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-				      int nents, enum dma_data_direction dir)
-{
-	BUG_ON(!valid_dma_direction(dir));
-	debug_dma_unmap_sg(dev, sg, nents, dir);
-	or1k_unmap_sg(dev, sg, nents, dir, NULL);
-}
+#define dma_free_coherent(d,s,c,h) dma_free_attrs(d,s,c,h,NULL)
 
-static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
-				      size_t offset, size_t size,
-				      enum dma_data_direction dir)
+static inline void dma_free_attrs(struct device *dev, size_t size,
+				  void *cpu_addr, dma_addr_t dma_handle,
+				  struct dma_attrs *attrs)
 {
-	dma_addr_t addr;
+	struct dma_map_ops *ops = get_dma_ops(dev);
 
-	kmemcheck_mark_initialized(page_address(page) + offset, size);
-	BUG_ON(!valid_dma_direction(dir));
-	addr = or1k_map_page(dev, page, offset, size, dir, NULL);
-	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
+	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 
-	return addr;
+	ops->free(dev, size, cpu_addr, dma_handle, attrs);
 }
 
-static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
-				  size_t size, enum dma_data_direction dir)
+static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
+					  dma_addr_t *dma_handle, gfp_t gfp)
 {
-	BUG_ON(!valid_dma_direction(dir));
-	or1k_unmap_page(dev, addr, size, dir, NULL);
-	debug_dma_unmap_page(dev, addr, size, dir, true);
-}
+	struct dma_attrs attrs;
 
-static inline void dma_sync_single_for_cpu(struct device *dev, dma_addr_t addr,
-					   size_t size,
-					   enum dma_data_direction dir)
-{
-	BUG_ON(!valid_dma_direction(dir));
-	or1k_sync_single_for_cpu(dev, addr, size, dir);
-	debug_dma_sync_single_for_cpu(dev, addr, size, dir);
+	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
+
+	return dma_alloc_attrs(dev, size, dma_handle, gfp, &attrs);
 }
 
-static inline void dma_sync_single_for_device(struct device *dev,
-					      dma_addr_t addr, size_t size,
-					      enum dma_data_direction dir)
+static inline void dma_free_noncoherent(struct device *dev, size_t size,
+					 void *cpu_addr, dma_addr_t dma_handle)
 {
-	BUG_ON(!valid_dma_direction(dir));
-	or1k_sync_single_for_device(dev, addr, size, dir);
-	debug_dma_sync_single_for_device(dev, addr, size, dir);
+	struct dma_attrs attrs;
+
+	dma_set_attr(DMA_ATTR_NON_CONSISTENT, &attrs);
+
+	dma_free_attrs(dev, size, cpu_addr, dma_handle, &attrs);
 }
 
 static inline int dma_supported(struct device *dev, u64 dma_mask)
diff --git a/arch/openrisc/kernel/dma.c b/arch/openrisc/kernel/dma.c
index f1c8ee2..0b77ddb 100644
--- a/arch/openrisc/kernel/dma.c
+++ b/arch/openrisc/kernel/dma.c
@@ -21,13 +21,16 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/dma-debug.h>
+#include <linux/export.h>
+#include <linux/dma-attrs.h>
 
 #include <asm/cpuinfo.h>
 #include <asm/spr_defs.h>
 #include <asm/tlbflush.h>
 
-static int page_set_nocache(pte_t *pte, unsigned long addr,
-			    unsigned long next, struct mm_walk *walk)
+static int
+page_set_nocache(pte_t *pte, unsigned long addr,
+		 unsigned long next, struct mm_walk *walk)
 {
 	unsigned long cl;
 
@@ -46,8 +49,9 @@ static int page_set_nocache(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
-static int page_clear_nocache(pte_t *pte, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
+static int
+page_clear_nocache(pte_t *pte, unsigned long addr,
+		   unsigned long next, struct mm_walk *walk)
 {
 	pte_val(*pte) &= ~_PAGE_CI;
 
@@ -67,9 +71,19 @@ static int page_clear_nocache(pte_t *pte, unsigned long addr,
  * cache-inhibit bit on those pages, and makes sure that the pages are
  * flushed out of the cache before they are used.
  *
+ * If the NON_CONSISTENT attribute is set, then this function just
+ * returns "normal", cachable memory.
+ *
+ * There are additional flags WEAK_ORDERING and WRITE_COMBINE to take
+ * into consideration here, too.  All current known implementations of
+ * the OR1K support only strongly ordered memory accesses, so that flag
+ * is being ignored for now; uncached but write-combined memory is a
+ * missing feature of the OR1K.
  */
-void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
-			      dma_addr_t *dma_handle, gfp_t gfp)
+static void *
+or1k_dma_alloc(struct device *dev, size_t size,
+	       dma_addr_t *dma_handle, gfp_t gfp,
+	       struct dma_attrs *attrs)
 {
 	unsigned long va;
 	void *page;
@@ -87,20 +101,23 @@ void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
 
 	va = (unsigned long)page;
 
-	/*
-	 * We need to iterate through the pages, clearing the dcache for
-	 * them and setting the cache-inhibit bit.
-	 */
-	if (walk_page_range(va, va + size, &walk)) {
-		free_pages_exact(page, size);
-		return NULL;
+	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+		/*
+		 * We need to iterate through the pages, clearing the dcache for
+		 * them and setting the cache-inhibit bit.
+		 */
+		if (walk_page_range(va, va + size, &walk)) {
+			free_pages_exact(page, size);
+			return NULL;
+		}
 	}
 
 	return (void *)va;
 }
 
-void or1k_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
-			    dma_addr_t dma_handle)
+static void
+or1k_dma_free(struct device *dev, size_t size, void *vaddr,
+	      dma_addr_t dma_handle, struct dma_attrs *attrs)
 {
 	unsigned long va = (unsigned long)vaddr;
 	struct mm_walk walk = {
@@ -108,16 +125,19 @@ void or1k_dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 		.mm = &init_mm
 	};
 
-	/* walk_page_range shouldn't be able to fail here */
-	WARN_ON(walk_page_range(va, va + size, &walk));
+	if (!dma_get_attr(DMA_ATTR_NON_CONSISTENT, attrs)) {
+		/* walk_page_range shouldn't be able to fail here */
+		WARN_ON(walk_page_range(va, va + size, &walk));
+	}
 
 	free_pages_exact(vaddr, size);
 }
 
-dma_addr_t or1k_map_page(struct device *dev, struct page *page,
-			 unsigned long offset, size_t size,
-			 enum dma_data_direction dir,
-			 struct dma_attrs *attrs)
+static dma_addr_t
+or1k_map_page(struct device *dev, struct page *page,
+	      unsigned long offset, size_t size,
+	      enum dma_data_direction dir,
+	      struct dma_attrs *attrs)
 {
 	unsigned long cl;
 	dma_addr_t addr = page_to_phys(page) + offset;
@@ -147,16 +167,18 @@ dma_addr_t or1k_map_page(struct device *dev, struct page *page,
 	return addr;
 }
 
-void or1k_unmap_page(struct device *dev, dma_addr_t dma_handle,
-		     size_t size, enum dma_data_direction dir,
-		     struct dma_attrs *attrs)
+static void
+or1k_unmap_page(struct device *dev, dma_addr_t dma_handle,
+		size_t size, enum dma_data_direction dir,
+		struct dma_attrs *attrs)
 {
 	/* Nothing special to do here... */
 }
 
-int or1k_map_sg(struct device *dev, struct scatterlist *sg,
-		int nents, enum dma_data_direction dir,
-		struct dma_attrs *attrs)
+static int
+or1k_map_sg(struct device *dev, struct scatterlist *sg,
+	    int nents, enum dma_data_direction dir,
+	    struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -169,9 +191,10 @@ int or1k_map_sg(struct device *dev, struct scatterlist *sg,
 	return nents;
 }
 
-void or1k_unmap_sg(struct device *dev, struct scatterlist *sg,
-		   int nents, enum dma_data_direction dir,
-		   struct dma_attrs *attrs)
+static void
+or1k_unmap_sg(struct device *dev, struct scatterlist *sg,
+	      int nents, enum dma_data_direction dir,
+	      struct dma_attrs *attrs)
 {
 	struct scatterlist *s;
 	int i;
@@ -181,9 +204,10 @@ void or1k_unmap_sg(struct device *dev, struct scatterlist *sg,
 	}
 }
 
-void or1k_sync_single_for_cpu(struct device *dev,
-			      dma_addr_t dma_handle, size_t size,
-			      enum dma_data_direction dir)
+static void
+or1k_sync_single_for_cpu(struct device *dev,
+			 dma_addr_t dma_handle, size_t size,
+			 enum dma_data_direction dir)
 {
 	unsigned long cl;
 	dma_addr_t addr = dma_handle;
@@ -193,9 +217,10 @@ void or1k_sync_single_for_cpu(struct device *dev,
 		mtspr(SPR_DCBIR, cl);
 }
 
-void or1k_sync_single_for_device(struct device *dev,
-			         dma_addr_t dma_handle, size_t size,
-			         enum dma_data_direction dir)
+static void
+or1k_sync_single_for_device(struct device *dev,
+			    dma_addr_t dma_handle, size_t size,
+			    enum dma_data_direction dir)
 {
 	unsigned long cl;
 	dma_addr_t addr = dma_handle;
@@ -205,6 +230,18 @@ void or1k_sync_single_for_device(struct device *dev,
 		mtspr(SPR_DCBFR, cl);
 }
 
+struct dma_map_ops or1k_dma_map_ops = {
+	.alloc = or1k_dma_alloc,
+	.free = or1k_dma_free,
+	.map_page = or1k_map_page,
+	.unmap_page = or1k_unmap_page,
+	.map_sg = or1k_map_sg,
+	.unmap_sg = or1k_unmap_sg,
+	.sync_single_for_cpu = or1k_sync_single_for_cpu,
+	.sync_single_for_device = or1k_sync_single_for_device,
+};
+EXPORT_SYMBOL(or1k_dma_map_ops);
+
 /* Number of entries preallocated for DMA-API debugging */
 #define PREALLOC_DMA_DEBUG_ENTRIES (1 << 16)
 
-- 
1.7.0.4

