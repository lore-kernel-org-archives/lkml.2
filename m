Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0DGUbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:31:07 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:16939 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab0DGUbD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 16:31:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/6] swiotlb: Make internal bookkeeping functions have 'swiotlb_tbl' prefix.
Date: Wed,  7 Apr 2010 16:29:25 -0400
Message-Id: <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBCEB49.0065:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions that operate on io_tlb_list/io_tlb_start/io_tlb_orig_addr
have the prefix 'swiotlb_tbl' now.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 437eedb..1798814 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -60,8 +60,8 @@ enum dma_sync_target {
 int swiotlb_force;
 
 /*
- * Used to do a quick range check in unmap_single and
- * sync_single_*, to see if the memory was in fact allocated by this
+ * Used to do a quick range check in swiotlb_tbl_unmap_single and
+ * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 static char *io_tlb_start, *io_tlb_end;
@@ -364,7 +364,8 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys, size_t size,
+		      int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -470,7 +471,8 @@ found:
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+			int dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -510,7 +512,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 }
 
 static void
-sync_single(struct device *hwdev, char *dma_addr, size_t size,
+swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
@@ -558,11 +560,11 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	}
 	if (!ret) {
 		/*
-		 * We are either out of memory or the device can't DMA
-		 * to GFP_DMA memory; fall back on map_single(), which
+		 * We are either out of memory or the device can't DMA to
+		 * GFP_DMA memory; fall back on swiotlb_tbl_map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
-		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
+		ret = swiotlb_tbl_map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
@@ -577,7 +579,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		swiotlb_tbl_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
 	*dma_handle = dev_addr;
@@ -595,8 +597,8 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 	if (!is_swiotlb_buffer(paddr))
 		free_pages((unsigned long)vaddr, get_order(size));
 	else
-		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+		/* DMA_TO_DEVICE to avoid memcpy in swiotlb_tbl_unmap_single */
+		swiotlb_tbl_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
@@ -652,7 +654,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(dev, phys, size, dir);
+	map = swiotlb_tbl_map_single(dev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -686,7 +688,7 @@ static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		do_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
+		swiotlb_tbl_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
 		return;
 	}
 
@@ -729,7 +731,8 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		sync_single(hwdev, phys_to_virt(paddr), size, dir, target);
+		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
+				       target);
 		return;
 	}
 
@@ -817,8 +820,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length)) {
-			void *map = map_single(hwdev, sg_phys(sg),
-					       sg->length, dir);
+			void *map = swiotlb_tbl_map_single(hwdev, sg_phys(sg),
+							   sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
-- 
1.6.2.5

