Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0DGUbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:31:45 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:19319 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab0DGUbk (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 16:31:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/6] swiotlb: search and replace "int dir" with "enum dma_data_direction dir"
Date: Wed,  7 Apr 2010 16:29:28 -0400
Message-Id: <1270672170-31833-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com>
 <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BBCEB67.0193:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. to catch anybody doing something funky.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/swiotlb.h |    4 ++--
 lib/swiotlb.c           |   22 ++++++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index febedcf..2a98e6a 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -42,11 +42,11 @@ extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 
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
index 5451517..94fc749 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -367,7 +367,8 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
  */
 static void *
 swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
-		      unsigned long start_dma_addr, size_t size, int dir)
+		       unsigned long start_dma_addr, size_t size,
+		       enum dma_data_direction dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -473,7 +474,7 @@ found:
  */
 static void
 swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
-			int dir)
+			enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -515,7 +516,7 @@ swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
 
 static void
 swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
-	    int dir, int target)
+	    enum dma_data_direction dir, int target)
 {
 	int index = (dma_addr - swiotlb_tbl_start) >> IO_TLB_SHIFT;
 	phys_addr_t phys = io_tlb_orig_addr[index];
@@ -608,7 +609,8 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
 static void
-swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
+swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
+	     int do_panic)
 {
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
@@ -688,7 +690,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
  * whatever the device wrote there.
  */
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-			 size_t size, int dir)
+			 size_t size, enum dma_data_direction dir)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -731,7 +733,7 @@ EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
  */
 static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
-		    size_t size, int dir, int target)
+		    size_t size, enum dma_data_direction dir, int target)
 {
 	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
 
@@ -771,7 +773,7 @@ EXPORT_SYMBOL(swiotlb_sync_single_for_device);
 static void
 swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
-			  int dir, int target)
+			  enum dma_data_direction dir, int target)
 {
 	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
@@ -852,7 +854,7 @@ EXPORT_SYMBOL(swiotlb_map_sg_attrs);
 
 int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-	       int dir)
+	       enum dma_data_direction dir)
 {
 	return swiotlb_map_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -879,7 +881,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
 void
 swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sgl, int nelems,
-		 int dir)
+		 enum dma_data_direction dir)
 {
 	return swiotlb_unmap_sg_attrs(hwdev, sgl, nelems, dir, NULL);
 }
@@ -894,7 +896,7 @@ EXPORT_SYMBOL(swiotlb_unmap_sg);
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

