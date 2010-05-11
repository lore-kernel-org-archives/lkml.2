Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0EKPjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:39:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56795 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab0EKPjm (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:39:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/6] swiotlb: Make internal bookkeeping functions have 'swiotlb_tbl' prefix.
Date: Tue, 11 May 2010 11:39:10 -0400
Message-Id: <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com>
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com>
 <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BE97A2D.00BB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions that operate on io_tlb_list/io_tlb_start/io_tlb_orig_addr
have the prefix 'swiotlb_tbl' now.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 843aa54..1ed01fe 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -61,8 +61,8 @@ enum dma_sync_target {
 int swiotlb_force;
 
 /*
- * Used to do a quick range check in unmap_single and
- * sync_single_*, to see if the memory was in fact allocated by this
+ * Used to do a quick range check in swiotlb_tbl_unmap_single and
+ * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 static char *io_tlb_start, *io_tlb_end;
@@ -492,7 +492,8 @@ map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
+			int dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -532,7 +533,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 }
 
 static void
-sync_single(struct device *hwdev, char *dma_addr, size_t size,
+swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
@@ -580,8 +581,8 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	}
 	if (!ret) {
 		/*
-		 * We are either out of memory or the device can't DMA
-		 * to GFP_DMA memory; fall back on map_single(), which
+		 * We are either out of memory or the device can't DMA to
+		 * GFP_DMA memory; fall back on map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
 		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
@@ -599,7 +600,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		swiotlb_tbl_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
 	*dma_handle = dev_addr;
@@ -617,8 +618,8 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 	if (!is_swiotlb_buffer(paddr))
 		free_pages((unsigned long)vaddr, get_order(size));
 	else
-		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+		/* DMA_TO_DEVICE to avoid memcpy in swiotlb_tbl_unmap_single */
+		swiotlb_tbl_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
@@ -708,7 +709,7 @@ static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		do_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
+		swiotlb_tbl_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
 		return;
 	}
 
@@ -751,7 +752,8 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		sync_single(hwdev, phys_to_virt(paddr), size, dir, target);
+		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
+				       target);
 		return;
 	}
 
-- 
1.6.2.5

