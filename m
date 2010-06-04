Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0FDRzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:55:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27474 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab0FDRzU (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 4 Jun 2010 13:55:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: albert_herranz@yahoo.es, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       iommu@lists.linux-foundation.org, linux@arm.linux.org.uk,
       dwmw2@infradead.org, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/5] swiotlb: Make swiotlb bookkeeping functions visible in the header file.
Date: Fri,  4 Jun 2010 13:52:35 -0400
Message-Id: <1275673955-30267-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275673955-30267-5-git-send-email-konrad.wilk@oracle.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-2-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-3-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-4-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-5-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4C093DBC.01E3:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We put the functions dealing with the operations on
the SWIOTLB buffer in the header and make those functions non-static.
And also make the functions exported via EXPORT_SYMBOL_GPL.

[v2: swiotlb_sync_single_range_for_* no more. Remove usage.]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Albert Herranz <albert_herranz@yahoo.es>
---
 include/linux/swiotlb.h |   22 ++++++++++++++++++++++
 lib/swiotlb.c           |   29 ++++++++++++++---------------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 00ff153..881cd9c 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -25,6 +25,28 @@ extern int swiotlb_force;
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
 
+/*
+ * Enumeration for sync targets
+ */
+enum dma_sync_target {
+	SYNC_FOR_CPU = 0,
+	SYNC_FOR_DEVICE = 1,
+};
+extern void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
+				    phys_addr_t phys, size_t size,
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
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5f60157..34e3082 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -50,14 +50,6 @@
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
@@ -335,8 +327,8 @@ static int is_swiotlb_buffer(phys_addr_t paddr)
 /*
  * Bounce: copy the swiotlb buffer back to the original dma location
  */
-static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
-			   enum dma_data_direction dir)
+void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+		    enum dma_data_direction dir)
 {
 	unsigned long pfn = PFN_DOWN(phys);
 
@@ -372,6 +364,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 			memcpy(phys_to_virt(phys), dma_addr, size);
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
 void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 			     phys_addr_t phys, size_t size,
@@ -476,6 +469,7 @@ found:
 
 	return dma_addr;
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
 
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
@@ -493,7 +487,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
+void
 swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 			enum dma_data_direction dir)
 {
@@ -533,10 +527,12 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	}
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_unmap_single);
 
-static void
+void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    enum dma_data_direction dir, int target)
+			enum dma_data_direction dir,
+			enum dma_sync_target target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -560,6 +556,7 @@ swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 		BUG();
 	}
 }
+EXPORT_SYMBOL_GPL(swiotlb_tbl_sync_single);
 
 void *
 swiotlb_alloc_coherent(struct device *hwdev, size_t size,
@@ -748,7 +745,8 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, enum dma_data_direction dir, int target)
+		    size_t size, enum dma_data_direction dir,
+		    enum dma_sync_target target)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -877,7 +875,8 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
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

