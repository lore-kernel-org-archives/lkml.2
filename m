Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0EKPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:39:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56792 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0EKPjm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:39:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/6] swiotlb: search and replace "int dir" with "enum dma_data_direction dir"
Date: Tue, 11 May 2010 11:39:11 -0400
Message-Id: <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BE97A2E.0131:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. to catch anybody doing something funky.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |    4 ++--
 lib/swiotlb.c           |   25 ++++++++++++++-----------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index ab005a5..f3fc331 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -43,11 +43,11 @@ extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 
 extern int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-	       int direction);
+	       enum dma_data_direction direction);
 
 extern void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg, int nents,
-		 int direction);
+		 enum dma_data_direction direction);
 
 extern int
 swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1ed01fe..a1bde96 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -374,7 +374,8 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 }
 
 void *swiotlb_tbl_map_single(struct device *hwdev, u64 tbl_dma_addr,
-			     phys_addr_t phys, size_t size, int dir)
+			     phys_addr_t phys, size_t size,
+			     enum dma_data_direction dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -481,7 +482,8 @@ found:
  */
 
 static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+map_single(struct device *hwdev, phys_addr_t phys, size_t size,
+	   enum dma_data_direction dir)
 {
 	u64 start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
 
@@ -493,7 +495,7 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
  */
 static void
 swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
-			int dir)
+			enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -534,7 +536,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 
 static void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    int dir, int target)
+	    enum dma_data_direction dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -624,7 +626,8 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
 static void
-swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
+swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
+	     int do_panic)
 {
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
@@ -702,7 +705,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
  * whatever the device wrote there.
  */
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-			 size_t size, int dir)
+			 size_t size, enum dma_data_direction dir)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -745,7 +748,7 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, int dir, int target)
+		    size_t size, enum dma_data_direction dir, int target)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -785,7 +788,7 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  int dir, int target)
+			  enum dma_data_direction dir, int target)
 {
 	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
@@ -863,7 +866,7 @@ EXPORT_SYMBOL(swiotlb_map_sg_attrs);
 
 int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+	       enum dma_data_direction dir)
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -890,7 +893,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
 void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -905,7 +908,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
  */
 static void
 swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
-		int nelems, int dir, int target)
+		int nelems, enum dma_data_direction dir, int target)
 {
 	struct scatterlist *sg;
 	int i;
-- 
1.6.2.5

