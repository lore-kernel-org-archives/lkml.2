Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab0DGUbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:31:12 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:17177 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0DGUbF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 16:31:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible in the header file.
Date: Wed,  7 Apr 2010 16:29:29 -0400
Message-Id: <1270672170-31833-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270672170-31833-5-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-5-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BBCEB4B.008C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We put the init, free, and functions dealing with the operations on
the SWIOTLB buffer at the top of the header. Also we export some of the
variables that are used by the dma_ops functions.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |   33 +++++++++++++++++++++++++++++++++
 lib/swiotlb.c           |   42 ++++++++++++++++++++----------------------
 2 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 2a98e6a..42df529 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -24,6 +24,39 @@ extern int swiotlb_force;
 
 extern void swiotlb_init(int verbose);
 
+/* Internal book-keeping functions. Must be linked against the library
+ * to take advantage of them.*/
+#ifdef CONFIG_SWIOTLB
+/*
+ * Enumeration for sync targets
+ */
+enum dma_sync_target {
+	SYNC_FOR_CPU = 0,
+	SYNC_FOR_DEVICE = 1,
+};
+extern char *swiotlb_tbl_start;
+extern unsigned long swiotlb_tbl_nslabs;
+extern int is_swiotlb_buffer(phys_addr_t paddr);
+extern void *swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
+				    unsigned long start_dma_addr, size_t size,
+				    enum dma_data_direction dir);
+
+extern void swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr,
+				     size_t size, enum dma_data_direction dir);
+
+extern void swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr,
+				    size_t size, enum dma_data_direction dir,
+				    enum dma_sync_target target);
+
+/* Accessory functions. */
+extern void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir);
+extern void swiotlb_full(struct device *dev, size_t size,
+			 enum dma_data_direction dir, int do_panic);
+
+#endif
+
+/* swiotlb.c: dma_ops functions. */
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 94fc749..5443ad5 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -49,14 +49,6 @@
  */
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 
-/*
- * Enumeration for sync targets
- */
-enum dma_sync_target {
-	SYNC_FOR_CPU = 0,
-	SYNC_FOR_DEVICE = 1,
-};
-
 int swiotlb_force;
 
 /*
@@ -64,13 +56,14 @@ int swiotlb_force;
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
-static char *swiotlb_tbl_start, *io_tlb_end;
+char *swiotlb_tbl_start;
+static char *io_tlb_end;
 
 /*
  * The number of IO TLB blocks (in groups of 64) betweeen swiotlb_tbl_start and
  * io_tlb_end.  This is command line adjustable via setup_io_tlb_npages.
  */
-static unsigned long swiotlb_tbl_nslabs;
+unsigned long swiotlb_tbl_nslabs;
 
 /*
  * When the IOMMU overflows we return a fallback buffer. This sets the size.
@@ -315,7 +308,7 @@ void __init swiotlb_free(void)
 	}
 }
 
-static int is_swiotlb_buffer(phys_addr_t paddr)
+int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= virt_to_phys(swiotlb_tbl_start) &&
 		paddr < virt_to_phys(io_tlb_end);
@@ -324,7 +317,7 @@ static int is_swiotlb_buffer(phys_addr_t paddr)
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			   enum dma_data_direction dir)
 {
 	unsigned long pfn = PFN_DOWN(phys);
@@ -365,7 +358,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
-static void *
+void *
 swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
 		       unsigned long start_dma_addr, size_t size,
 		       enum dma_data_direction dir)
@@ -472,9 +465,9 @@ found:
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
+void
 swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
-			enum dma_data_direction dir)
+			 enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -514,9 +507,10 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-static void
+void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    enum dma_data_direction dir, int target)
+			enum dma_data_direction dir,
+			enum dma_sync_target target)
 {
 	int index = (dma_addr - swiotlb_tbl_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -608,7 +602,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
-static void
+void
 swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
 	     int do_panic)
 {
@@ -733,7 +727,8 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, enum dma_data_direction dir, int target)
+		    size_t size, enum dma_data_direction dir,
+		    enum dma_sync_target target)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -773,7 +768,8 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  enum dma_data_direction dir, int target)
+			  enum dma_data_direction dir,
+			  enum dma_sync_target target)
 {
 	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
@@ -866,7 +862,8 @@ EXPORT_SYMBOL(swiotlb_map_sg);
  */
 void
 swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
-		       int nelems, enum dma_data_direction dir, struct dma_attrs *attrs)
+		       int nelems, enum dma_data_direction dir,
+		       struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
 	int i;
@@ -896,7 +893,8 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
  */
 static void
 swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
-		int nelems, enum dma_data_direction dir, int target)
+		int nelems, enum dma_data_direction dir,
+		enum dma_sync_target target)
 {
 	struct scatterlist *sg;
 	int i;
-- 
1.6.2.5

