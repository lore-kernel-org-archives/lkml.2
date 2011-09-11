Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933862Ab1IKTne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 15:43:34 -0400
Received: from mxout2.netvision.net.il ([194.90.9.21]:39853 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab1IKTnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 15:43:31 -0400
Content-transfer-encoding: 7BIT
From: Eli Billauer <eli.billauer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: monstr@monstr.eu, Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 2/3] microblaze: Added DMA sync operations
Date: Sun, 11 Sep 2011 22:43:07 +0300
Message-id: <1315770188-17550-2-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-reply-to: <1315770188-17550-1-git-send-email-eli.billauer@gmail.com>
References: <1315770188-17550-1-git-send-email-eli.billauer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support gor dma_direct_sync_single_for_*() and dma_direct_sync_sg_for_*()

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 arch/microblaze/kernel/dma.c |   60 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/kernel/dma.c b/arch/microblaze/kernel/dma.c
index 595130b..e06ddad 100644
--- a/arch/microblaze/kernel/dma.c
+++ b/arch/microblaze/kernel/dma.c
@@ -118,6 +118,62 @@ static inline void dma_direct_unmap_page(struct device *dev,
 	__dma_sync(dma_address, size, direction);
 }
 
+static inline void
+dma_direct_sync_single_for_cpu(struct device *dev,
+			       dma_addr_t dma_handle, size_t size,
+			       enum dma_data_direction direction)
+{
+	/*
+	 *  It's pointless to flush the cache as the memory segment
+	 *  is given to the CPU
+	 */
+
+	if (direction == DMA_FROM_DEVICE)
+		__dma_sync(dma_handle, size, direction);
+}
+
+static inline void
+dma_direct_sync_single_for_device(struct device *dev,
+				  dma_addr_t dma_handle, size_t size,
+				  enum dma_data_direction direction)
+{
+	/*
+	 *  It's pointless to invalidate the cache if the device isn't
+	 *  supposed to write to the relevant region
+	 */
+
+	if (direction == DMA_TO_DEVICE)
+		__dma_sync(dma_handle, size, direction);
+}
+
+static inline void
+dma_direct_sync_sg_for_cpu(struct device *dev,
+			   struct scatterlist *sgl, int nents,
+			   enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+	/* FIXME this part of code is untested */
+	if (direction == DMA_FROM_DEVICE)
+		for_each_sg(sgl, sg, nents, i)
+			__dma_sync(sg->dma_address, sg->length, direction);
+}
+
+static inline void
+dma_direct_sync_sg_for_device(struct device *dev,
+			      struct scatterlist *sgl, int nents,
+			      enum dma_data_direction direction)
+{
+	struct scatterlist *sg;
+	int i;
+
+	/* FIXME this part of code is untested */
+	if (direction == DMA_TO_DEVICE)
+		for_each_sg(sgl, sg, nents, i)
+			__dma_sync(sg->dma_address, sg->length, direction);
+}
+
 struct dma_map_ops dma_direct_ops = {
 	.alloc_coherent	= dma_direct_alloc_coherent,
 	.free_coherent	= dma_direct_free_coherent,
@@ -126,6 +182,10 @@ struct dma_map_ops dma_direct_ops = {
 	.dma_supported	= dma_direct_dma_supported,
 	.map_page	= dma_direct_map_page,
 	.unmap_page	= dma_direct_unmap_page,
+	.sync_single_for_cpu		= dma_direct_sync_single_for_cpu,
+	.sync_single_for_device		= dma_direct_sync_single_for_device,
+	.sync_sg_for_cpu		= dma_direct_sync_sg_for_cpu,
+	.sync_sg_for_device		= dma_direct_sync_sg_for_device,
 };
 EXPORT_SYMBOL(dma_direct_ops);
 
-- 
1.7.2.3

