Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2JKUed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:34:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:53045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab2JKUea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="155217303"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 5/7] swiotlb: Use physical addresses for
	swiotlb_tbl_unmap_single
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 11 Oct 2012 13:34:47 -0700
Message-ID: <20121011203447.12444.72472.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it so that the unmap functionality also uses physical
addresses.  This helps to further reduce the use of virt_to_phys and
phys_to_virt functions.

In order to clarify things since we now have 2 physical addresses in use
inside of swiotlb_tbl_unmap_single I am renaming phys to orig_addr, and
dma_addr to tlb_addr.  This way is should be clear that orig_addr is
contained within io_orig_addr and tlb_addr is an address within the
io_tlb_addr buffer.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 drivers/xen/swiotlb-xen.c |    4 ++--
 include/linux/swiotlb.h   |    3 ++-
 lib/swiotlb.c             |   37 +++++++++++++++++++------------------
 3 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 8a6035a..4cedc28 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -364,7 +364,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 * Ensure that the address returned is DMA'ble
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, phys_to_virt(map), size, dir);
+		swiotlb_tbl_unmap_single(dev, map, size, dir);
 		dev_addr = 0;
 	}
 	return dev_addr;
@@ -388,7 +388,7 @@ static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 
 	/* NOTE: We use dev_addr here, not paddr! */
 	if (is_xen_swiotlb_buffer(dev_addr)) {
-		swiotlb_tbl_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
+		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
 		return;
 	}
 
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 1995f3e..291643c 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -43,7 +43,8 @@ extern phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
 					  phys_addr_t phys, size_t size,
 					  enum dma_data_direction dir);
 
-extern void swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr,
+extern void swiotlb_tbl_unmap_single(struct device *hwdev,
+				     phys_addr_t tlb_addr,
 				     size_t size, enum dma_data_direction dir);
 
 extern void swiotlb_tbl_sync_single(struct device *hwdev, char *dma_addr,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 58d0bbd..e0e66db 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -515,20 +515,20 @@ phys_addr_t map_single(struct device *hwdev, phys_addr_t phys, size_t size,
 /*
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
-void
-swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr, size_t size,
-			enum dma_data_direction dir)
+void swiotlb_tbl_unmap_single(struct device *hwdev, phys_addr_t tlb_addr,
+			      size_t size, enum dma_data_direction dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
-	int index = (dma_addr - (char *)phys_to_virt(io_tlb_start)) >> IO_TLB_SHIFT;
-	phys_addr_t phys = io_tlb_orig_addr[index];
+	int index = (tlb_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	phys_addr_t orig_addr = io_tlb_orig_addr[index];
 
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
 	if (phys && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
-		swiotlb_bounce(phys, dma_addr, size, DMA_FROM_DEVICE);
+		swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr),
+			       size, DMA_FROM_DEVICE);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -621,17 +621,18 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 
 		ret = phys_to_virt(paddr);
 		dev_addr = phys_to_dma(hwdev, paddr);
-	}
 
-	/* Confirm address can be DMA'd by device */
-	if (dev_addr + size - 1 > dma_mask) {
-		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
-		       (unsigned long long)dma_mask,
-		       (unsigned long long)dev_addr);
+		/* Confirm address can be DMA'd by device */
+		if (dev_addr + size - 1 > dma_mask) {
+			printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
+			       (unsigned long long)dma_mask,
+			       (unsigned long long)dev_addr);
 
-		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		swiotlb_tbl_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
-		return NULL;
+			/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
+			swiotlb_tbl_unmap_single(hwdev, paddr,
+						 size, DMA_TO_DEVICE);
+			return NULL;
+		}
 	}
 
 	*dma_handle = dev_addr;
@@ -652,7 +653,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		free_pages((unsigned long)vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in swiotlb_tbl_unmap_single */
-		swiotlb_tbl_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+		swiotlb_tbl_unmap_single(hwdev, paddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
@@ -716,7 +717,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 
 	/* Ensure that the address returned is DMA'ble */
 	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, phys_to_virt(map), size, dir);
+		swiotlb_tbl_unmap_single(dev, map, size, dir);
 		return phys_to_dma(dev, io_tlb_overflow_buffer);
 	}
 
@@ -740,7 +741,7 @@ static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		swiotlb_tbl_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
+		swiotlb_tbl_unmap_single(hwdev, paddr, size, dir);
 		return;
 	}
 

