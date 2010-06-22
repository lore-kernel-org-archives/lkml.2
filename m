Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0FVTqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50603 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0FVTqE (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 10/19] swiotlb-xen: Make 'xen_swiotlb_[map|unmap]_page' work.
Date: Tue, 22 Jun 2010 15:42:43 -0400
Message-Id: <1277235772-26757-11-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4C2112AA.002F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We utilize the SWIOTLB proper book-keeping functions and compared
to bare-metal SWIOTLB, we use a different virt->bus address
translation. This is necessary as under Xen, the PFN is a pseudo-number
that is not necessarily the true MFN. Because of that, successive pages
might not physically contiguous, meaning mfn++ != pfn_to_mfn(pfn++), so
we have to check for that too.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index 2640052..efafcce 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -192,7 +192,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 				struct dma_attrs *attrs)
 {
 	phys_addr_t phys = page_to_phys(page) + offset;
-	dma_addr_t dev_addr = phys_to_dma(dev, phys);
+	dma_addr_t dev_addr = xen_phys_to_bus(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -201,7 +201,8 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (dma_capable(dev, dev_addr, size) && !swiotlb_force)
+	if (dma_capable(dev, dev_addr, size) &&
+	    !range_straddles_page_boundary(phys, size) && !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -236,11 +237,12 @@ EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);
 static void xen_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			     size_t size, enum dma_data_direction dir)
 {
-	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = xen_bus_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (is_xen_swiotlb_buffer(paddr)) {
+	/* NOTE: We use dev_addr here, not paddr! */
+	if (is_xen_swiotlb_buffer(dev_addr)) {
 		swiotlb_tbl_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
 		return;
 	}
-- 
1.7.0.1

