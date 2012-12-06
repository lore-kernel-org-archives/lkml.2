Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab2LFNSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 08:18:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:63115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265Ab2LFNSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 08:18:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,230,1355126400"; 
   d="scan'208";a="259901476"
From: Dongxiao Xu <dongxiao.xu@intel.com>
To: konrad.wilk@oracle.com, xen-devel@lists.xen.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] xen/swiotlb: Exchange to contiguous memory for map_sg hook
Date: Thu,  6 Dec 2012 21:08:42 +0800
Message-Id: <1354799322-6000-1-git-send-email-dongxiao.xu@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While mapping sg buffers, checking to cross page DMA buffer is
also needed. If the guest DMA buffer crosses page boundary, Xen
should exchange contiguous memory for it.

Besides, it is needed to backup the original page contents
and copy it back after memory exchange is done.

This fixes issues if device DMA into software static buffers,
and in case the static buffer cross page boundary which pages are
not contiguous in real hardware.

Signed-off-by: Dongxiao Xu <dongxiao.xu@intel.com>
Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
---
 drivers/xen/swiotlb-xen.c |   47 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 58db6df..e8f0cfb 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -461,6 +461,22 @@ xen_swiotlb_sync_single_for_device(struct device *hwdev, dma_addr_t dev_addr,
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_sync_single_for_device);
 
+static bool
+check_continguous_region(unsigned long vstart, unsigned long order)
+{
+	unsigned long prev_ma = xen_virt_to_bus((void *)vstart);
+	unsigned long next_ma;
+	int i;
+
+	for (i = 1; i < (1 << order); i++) {
+		next_ma = xen_virt_to_bus((void *)(vstart + i * PAGE_SIZE));
+		if (next_ma != prev_ma + PAGE_SIZE)
+			return false;
+		prev_ma = next_ma;
+	}
+	return true;
+}
+
 /*
  * Map a set of buffers described by scatterlist in streaming mode for DMA.
  * This is the scatter-gather version of the above xen_swiotlb_map_page
@@ -489,7 +505,36 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = xen_phys_to_bus(paddr);
+		unsigned long vstart, order;
+		dma_addr_t dev_addr;
+
+		/*
+		 * While mapping sg buffers, checking to cross page DMA buffer
+		 * is also needed. If the guest DMA buffer crosses page
+		 * boundary, Xen should exchange contiguous memory for it.
+		 * Besides, it is needed to backup the original page contents
+		 * and copy it back after memory exchange is done.
+		 */
+		if (range_straddles_page_boundary(paddr, sg->length)) {
+			vstart = (unsigned long)__va(paddr & PAGE_MASK);
+			order = get_order(sg->length + (paddr & ~PAGE_MASK));
+			if (!check_continguous_region(vstart, order)) {
+				unsigned long buf;
+				buf = __get_free_pages(GFP_KERNEL, order);
+				memcpy((void *)buf, (void *)vstart,
+					PAGE_SIZE * (1 << order));
+				if (xen_create_contiguous_region(vstart, order,
+						fls64(paddr))) {
+					free_pages(buf, order);
+					return 0;
+				}
+				memcpy((void *)vstart, (void *)buf,
+					PAGE_SIZE * (1 << order));
+				free_pages(buf, order);
+			}
+		}
+
+		dev_addr = xen_phys_to_bus(paddr);
 
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length) ||
-- 
1.7.1

