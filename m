Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338Ab2JKUe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 16:34:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:8922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab2JKUeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 16:34:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,573,1344236400"; 
   d="scan'208";a="232887972"
From: Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 4/7] swiotlb: Return physical addresses when calling
	swiotlb_tbl_map_single
To: konrad.wilk@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rob@landley.net, akpm@linux-foundation.org,
        joerg.roedel@amd.com, bhelgaas@google.com, shuahkhan@gmail.com,
        fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 11 Oct 2012 13:34:41 -0700
Message-ID: <20121011203441.12444.31453.stgit@gitlad.jf.intel.com>
In-Reply-To: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
References: <20121011203010.12444.15503.stgit@gitlad.jf.intel.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes it so that swiotlb_tbl_map_single will return a physical
address instead of a virtual address when called.  The advantage to this once
again is that we are avoiding a number of virt_to_phys and phys_to_virt
translations by working with everything as a physical address.

One change I had to make in order to support using physical addresses is that
I could no longer trust 0 to be a invalid physical address on all platforms.
So instead I made it so that ~0 is returned on error.  This should never be a
valid return value as it implies that only one byte would be available for
use.

In order to clarify things since we now have 2 physical addresses in use
inside of swiotlb_tbl_map_single I am renaming phys to orig_addr, and
dma_addr to tlb_addr.  This way is should be clear that orig_addr is
contained within io_orig_addr and tlb_addr is an address within the
io_tlb_addr buffer.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---

 drivers/xen/swiotlb-xen.c |   22 ++++++-------
 include/linux/swiotlb.h   |   11 +++++-
 lib/swiotlb.c             |   78 +++++++++++++++++++++++----------------------
 3 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 58db6df..8a6035a 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -338,9 +338,8 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				enum dma_data_direction dir,
 				struct dma_attrs *attrs)
 {
-	phys_addr_t phys = page_to_phys(page) + offset;
+	phys_addr_t map, phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = xen_phys_to_bus(phys);
-	void *map;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -356,16 +355,16 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
 	map = swiotlb_tbl_map_single(dev, start_dma_addr, phys, size, dir);
-	if (!map)
+	if (map == SWIOTLB_MAP_ERROR)
 		return DMA_ERROR_CODE;
 
-	dev_addr = xen_virt_to_bus(map);
+	dev_addr = xen_phys_to_bus(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
 	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		swiotlb_tbl_unmap_single(dev, phys_to_virt(map), size, dir);
 		dev_addr = 0;
 	}
 	return dev_addr;
@@ -494,11 +493,12 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
 		    range_straddles_page_boundary(paddr, sg->length)) {
-			void *map = swiotlb_tbl_map_single(hwdev,
-							   start_dma_addr,
-							   sg_phys(sg),
-							   sg->length, dir);
-			if (!map) {
+			phys_addr_t map = swiotlb_tbl_map_single(hwdev,
+								 start_dma_addr,
+								 sg_phys(sg),
+								 sg->length,
+								 dir);
+			if (map == SWIOTLB_MAP_ERROR) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				xen_swiotlb_unmap_sg_attrs(hwdev, sgl, i, dir,
@@ -506,7 +506,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 				sgl[0].dma_length = 0;
 				return DMA_ERROR_CODE;
 			}
-			sg->dma_address = xen_virt_to_bus(map);
+			sg->dma_address = xen_phys_to_bus(map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 8d08b3e..1995f3e 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -34,9 +34,14 @@ enum dma_sync_target {
 	SYNC_FOR_CPU = 0,
 	SYNC_FOR_DEVICE = 1,
 };
-extern void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
-				    phys_addr_t phys, size_t size,
-				    enum dma_data_direction dir);
+
+/* define the last possible byte of physical address space as a mapping error */
+#define SWIOTLB_MAP_ERROR (~(phys_addr_t)0x0)
+
+extern phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
+					  dma_addr_t tbl_dma_addr,
+					  phys_addr_t phys, size_t size,
+					  enum dma_data_direction dir);
 
 extern void swiotlb_tbl_unmap_single(struct device *hwdev, char *dma_addr,
 				     size_t size, enum dma_data_direction dir);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 383f780..58d0bbd 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -393,12 +393,13 @@ void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
 }
 EXPORT_SYMBOL_GPL(swiotlb_bounce);
 
-void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
-			     phys_addr_t phys, size_t size,
-			     enum dma_data_direction dir)
+phys_addr_t swiotlb_tbl_map_single(struct device *hwdev,
+				   dma_addr_t tbl_dma_addr,
+				   phys_addr_t orig_addr, size_t size,
+				   enum dma_data_direction dir)
 {
 	unsigned long flags;
-	char *dma_addr;
+	phys_addr_t tlb_addr;
 	unsigned int nslots, stride, index, wrap;
 	int i;
 	unsigned long mask;
@@ -462,7 +463,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 				io_tlb_list[i] = 0;
 			for (i = index - 1; (OFFSET(i, IO_TLB_SEGSIZE) != IO_TLB_SEGSIZE - 1) && io_tlb_list[i]; i--)
 				io_tlb_list[i] = ++count;
-			dma_addr = (char *)phys_to_virt(io_tlb_start) + (index << IO_TLB_SHIFT);
+			tlb_addr = io_tlb_start + (index << IO_TLB_SHIFT);
 
 			/*
 			 * Update the indices to avoid searching in the next
@@ -480,7 +481,7 @@ void *swiotlb_tbl_map_single(struct device *hwdev, dma_addr_t tbl_dma_addr,
 
 not_found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
-	return NULL;
+	return SWIOTLB_MAP_ERROR;
 found:
 	spin_unlock_irqrestore(&io_tlb_lock, flags);
 
@@ -490,11 +491,12 @@ found:
 	 * needed.
 	 */
 	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = phys + (i << IO_TLB_SHIFT);
+		io_tlb_orig_addr[index+i] = orig_addr + (i << IO_TLB_SHIFT);
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		swiotlb_bounce(phys, dma_addr, size, DMA_TO_DEVICE);
+		swiotlb_bounce(orig_addr, phys_to_virt(tlb_addr), size,
+			       DMA_TO_DEVICE);
 
-	return dma_addr;
+	return tlb_addr;
 }
 EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
 
@@ -502,9 +504,8 @@ EXPORT_SYMBOL_GPL(swiotlb_tbl_map_single);
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 
-static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size,
-	   enum dma_data_direction dir)
+phys_addr_t map_single(struct device *hwdev, phys_addr_t phys, size_t size,
+		       enum dma_data_direction dir)
 {
 	dma_addr_t start_dma_addr = phys_to_dma(hwdev, io_tlb_start);
 
@@ -598,12 +599,15 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size - 1 > dma_mask) {
-		/*
-		 * The allocated memory isn't reachable by the device.
-		 */
-		free_pages((unsigned long) ret, order);
-		ret = NULL;
+	if (ret) {
+		dev_addr = swiotlb_virt_to_bus(hwdev, ret);
+		if (dev_addr + size - 1 > dma_mask) {
+			/*
+			 * The allocated memory isn't reachable by the device.
+			 */
+			free_pages((unsigned long) ret, order);
+			ret = NULL;
+		}
 	}
 	if (!ret) {
 		/*
@@ -611,13 +615,13 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * GFP_DMA memory; fall back on map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
-		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
-		if (!ret)
+		phys_addr_t paddr = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
+		if (paddr == SWIOTLB_MAP_ERROR)
 			return NULL;
-	}
 
-	memset(ret, 0, size);
-	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
+		ret = phys_to_virt(paddr);
+		dev_addr = phys_to_dma(hwdev, paddr);
+	}
 
 	/* Confirm address can be DMA'd by device */
 	if (dev_addr + size - 1 > dma_mask) {
@@ -629,7 +633,10 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		swiotlb_tbl_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
+
 	*dma_handle = dev_addr;
+	memset(ret, 0, size);
+
 	return ret;
 }
 EXPORT_SYMBOL(swiotlb_alloc_coherent);
@@ -686,9 +693,8 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 			    enum dma_data_direction dir,
 			    struct dma_attrs *attrs)
 {
-	phys_addr_t phys = page_to_phys(page) + offset;
+	phys_addr_t map, phys = page_to_phys(page) + offset;
 	dma_addr_t dev_addr = phys_to_dma(dev, phys);
-	void *map;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -699,22 +705,18 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	if (dma_capable(dev, dev_addr, size) && !swiotlb_force)
 		return dev_addr;
 
-	/*
-	 * Oh well, have to allocate and map a bounce buffer.
-	 */
+	/* Oh well, have to allocate and map a bounce buffer. */
 	map = map_single(dev, phys, size, dir);
-	if (!map) {
+	if (map == SWIOTLB_MAP_ERROR) {
 		swiotlb_full(dev, size, dir, 1);
 		return phys_to_dma(dev, io_tlb_overflow_buffer);
 	}
 
-	dev_addr = swiotlb_virt_to_bus(dev, map);
+	dev_addr = phys_to_dma(dev, map);
 
-	/*
-	 * Ensure that the address returned is DMA'ble
-	 */
+	/* Ensure that the address returned is DMA'ble */
 	if (!dma_capable(dev, dev_addr, size)) {
-		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		swiotlb_tbl_unmap_single(dev, phys_to_virt(map), size, dir);
 		return phys_to_dma(dev, io_tlb_overflow_buffer);
 	}
 
@@ -840,9 +842,9 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length)) {
-			void *map = map_single(hwdev, sg_phys(sg),
-					       sg->length, dir);
-			if (!map) {
+			phys_addr_t map = map_single(hwdev, sg_phys(sg),
+						     sg->length, dir);
+			if (map == SWIOTLB_MAP_ERROR) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
 				swiotlb_full(hwdev, sg->length, dir, 0);
@@ -851,7 +853,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = swiotlb_virt_to_bus(hwdev, map);
+			sg->dma_address = phys_to_dma(hwdev, map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;

