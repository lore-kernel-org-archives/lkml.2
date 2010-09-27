Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab0I0W6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:58:02 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35819 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab0I0W56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:57:58 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/4] dma: add support for scatterlist to scatterlist copy
Date: Mon, 27 Sep 2010 15:57:54 -0700
Message-Id: <1285628277-26894-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
References: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Sep 2010 15:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for scatterlist to scatterlist DMA transfers. A
similar interface is exposed by the fsldma driver (through the DMA_SLAVE
API) and by the ste_dma40 driver (through an exported function).

This patch paves the way for making this type of copy operation a part
of the generic DMAEngine API. Futher patches will add support in
individual drivers.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/dmaengine.c   |    2 ++
 include/linux/dmaengine.h |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d31d5e..db403b8 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -690,6 +690,8 @@ int dma_async_device_register(struct dma_device *device)
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
+	BUG_ON(dma_has_cap(DMA_SG, device->cap_mask) &&
+		!device->device_prep_dma_sg);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
 		!device->device_prep_slave_sg);
 	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c61d4ca..7c44620 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -64,6 +64,7 @@ enum dma_transaction_type {
 	DMA_PQ_VAL,
 	DMA_MEMSET,
 	DMA_INTERRUPT,
+	DMA_SG,
 	DMA_PRIVATE,
 	DMA_ASYNC_TX,
 	DMA_SLAVE,
@@ -473,6 +474,11 @@ struct dma_device {
 		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan, unsigned long flags);
+	struct dma_async_tx_descriptor *(*device_prep_dma_sg)(
+		struct dma_chan *chan,
+		struct scatterlist *dst_sg, unsigned int dst_nents,
+		struct scatterlist *src_sg, unsigned int src_nents,
+		unsigned long flags);
 
 	struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
 		struct dma_chan *chan, struct scatterlist *sgl,
-- 
1.7.1

