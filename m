Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab1IKTnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 15:43:37 -0400
Received: from mxout2.netvision.net.il ([194.90.9.21]:39858 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab1IKTnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 15:43:35 -0400
Content-transfer-encoding: 7BIT
From: Eli Billauer <eli.billauer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: monstr@monstr.eu, Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 3/3] microblaze: Refinements on cache flushes and invalidations
 (dma.c)
Date: Sun, 11 Sep 2011 22:43:08 +0300
Message-id: <1315770188-17550-3-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-reply-to: <1315770188-17550-1-git-send-email-eli.billauer@gmail.com>
References: <1315770188-17550-1-git-send-email-eli.billauer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mapping and unmapping methods' cache syncronization calls were refined to
avoid unnecessary synchronizations of the cache. Flushing of the cache is
now made even when mapping memory as DMA_FROM_DEVICE, so that a possible
dirty cache lines don't get flushed later, and overwrite data written by
device.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 arch/microblaze/kernel/dma.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index e06ddad..2f231ee 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -76,16 +76,23 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 	for_each_sg(sgl, sg, nents, i) {
 		sg->dma_address = sg_phys(sg) + get_dma_direct_offset(dev);
 		__dma_sync(page_to_phys(sg_page(sg)) + sg->offset,
-							sg->length, direction);
+			   sg->length, DMA_TO_DEVICE);
 	}
 
 	return nents;
 }
 
-static void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sg,
+static void dma_direct_unmap_sg(struct device *dev, struct scatterlist *sgl,
 				int nents, enum dma_data_direction direction,
 				struct dma_attrs *attrs)
 {
+	struct scatterlist *sg;
+	int i;
+
+	/* FIXME this part of code is untested */
+	if (direction == DMA_FROM_DEVICE)
+		for_each_sg(sgl, sg, nents, i)
+			__dma_sync(sg->dma_address, sg->length, direction);
 }
 
 static int dma_direct_dma_supported(struct device *dev, u64 mask)
@@ -100,7 +107,16 @@ static inline dma_addr_t dma_direct_map_page(struct device *dev,
 					     enum dma_data_direction direction,
 					     struct dma_attrs *attrs)
 {
-	__dma_sync(page_to_phys(page) + offset, size, direction);
+	/*
+	 * We're before the DMA transfer, so cache invalidation makes no
+	 * sense in the case of DMA_FROM_DEVICE. Flushing is necessary
+	 * in either case, or an unflushed cache line may overwrite
+	 * data written by device, in the event of that line being allocated
+	 * for other use. Calling __dma_sync with DMA_TO_DEVICE makes this
+	 * flush.
+	 */
+
+	__dma_sync(page_to_phys(page) + offset, size, DMA_TO_DEVICE);
 	return page_to_phys(page) + offset + get_dma_direct_offset(dev);
 }
 
@@ -110,12 +126,16 @@ static inline void dma_direct_unmap_page(struct device *dev,
 					 enum dma_data_direction direction,
 					 struct dma_attrs *attrs)
 {
-/* There is not necessary to do cache cleanup
- *
- * phys_to_virt is here because in __dma_sync_page is __virt_to_phys and
- * dma_address is physical address
+
+/*
+ * On a DMA to the device, the data has already been flushed and read by
+ * the device at the point unmapping is done. No point doing anything.
+ * In the other direction, unmapping may be used just before accessing the
+ *  data on the CPU, so cache invalidation is necessary.
  */
-	__dma_sync(dma_address, size, direction);
+
+	if (direction == DMA_FROM_DEVICE)
+		__dma_sync(dma_address, size, direction);
 }
 
 static inline void 
-- 
1.7.2.3

