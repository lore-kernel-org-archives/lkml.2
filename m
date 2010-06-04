Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0FDRzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:55:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27603 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0FDRz1 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 4 Jun 2010 13:55:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: albert_herranz@yahoo.es, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       iommu@lists.linux-foundation.org, linux@arm.linux.org.uk,
       dwmw2@infradead.org, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/5] swiotlb: search and replace "int dir" with "enum dma_data_direction dir"
Date: Fri,  4 Jun 2010 13:52:34 -0400
Message-Id: <1275673955-30267-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275673955-30267-4-git-send-email-konrad.wilk@oracle.com>
References: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-2-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-3-git-send-email-konrad.wilk@oracle.com>
 <1275673955-30267-4-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C093DD2.0114:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. to catch anybody doing something funky.

[v2: swiotlb_sync_single_range_* no more - removed usage]

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Albert Herranz <albert_herranz@yahoo.es>
---
 include/linux/swiotlb.h |    4 ++--
 lib/swiotlb.c           |   23 +++++++++++++----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index b406261..00ff153 100644
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
index 1fc15bf..5f60157 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -374,7 +374,8 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 }
 
 void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
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
 	dma_addr_t start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start);
 
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
 
@@ -832,7 +835,7 @@ EXPORT_SYMBOL(swiotlb_map_sg_attrs);
 
 int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+	       enum dma_data_direction dir)
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -859,7 +862,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
 void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -874,7 +877,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
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

