Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0EKPkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:40:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57768 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0EKPkv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:40:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions visible in the header file.
Date: Tue, 11 May 2010 11:39:12 -0400
Message-Id: <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BE97A76.00EA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We put the functions dealing with the operations on
the SWIOTLB buffer in the header and make those functions non-static.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |   22 ++++++++++++++++++++++
 lib/swiotlb.c           |   28 ++++++++++++----------------
 2 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index f3fc331..dabfd0b 100644
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
+extern void *swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
+				    u64 tbl_dma_addr, size_t size,
+				    enum dma_data_direction dir);
+
+extern void swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr,
+				     size_t size, enum dma_data_direction dir);
+
+extern void swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr,
+				    size_t size, enum dma_data_direction dir,
+				    enum dma_sync_target target);
+
+/* Accessory function. */
+extern void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
+			   enum dma_data_direction dir);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index a1bde96..dc1776c 100644
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
 
@@ -493,7 +485,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-static void
+void
 swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 			enum dma_data_direction dir)
 {
@@ -534,9 +526,10 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 }
 
-static void
+void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    enum dma_data_direction dir, int target)
+			enum dma_data_direction dir,
+			enum dma_sync_target target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -748,7 +741,8 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, enum dma_data_direction dir, int target)
+		    size_t size, enum dma_data_direction dir,
+		    enum dma_sync_target target)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -788,7 +782,8 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  enum dma_data_direction dir, int target)
+			  enum dma_data_direction dir,
+			  enum dma_sync_target target)
 {
 	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
@@ -908,7 +903,8 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
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

