Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3AJSge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:36:34 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:63329 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3AJSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:36:32 -0500
From: Matt Porter <mporter@ti.com>
To: vinod.koul@intel.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>
Subject: [RESEND][PATCH] dma: edma: fix slave config dependency on direction
Date: Thu, 10 Jan 2013 13:41:04 -0500
Message-Id: <1357843264-27045-1-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The edma_slave_config() implementation depends on the
direction field such that it will not properly configure
a slave channel when called without direction set.

This fixes the implementation so that the slave config
is copied as is and prep_slave_sg() handles the
direction dependent handling. spi-omap2-mcspi and
omap_hsmmc both expose this bug as they configure the
slave channel config from a common path with an unconfigured
direction field.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/dma/edma.c |   55 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 05aea3c..fdcf079 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -69,9 +69,7 @@ struct edma_chan {
 	int				ch_num;
 	bool				alloced;
 	int				slot[EDMA_MAX_SLOTS];
-	dma_addr_t			addr;
-	int				addr_width;
-	int				maxburst;
+	struct dma_slave_config		cfg;
 };
 
 struct edma_cc {
@@ -178,29 +176,14 @@ static int edma_terminate_all(struct edma_chan *echan)
 	return 0;
 }
 
-
 static int edma_slave_config(struct edma_chan *echan,
-	struct dma_slave_config *config)
+	struct dma_slave_config *cfg)
 {
-	if ((config->src_addr_width > DMA_SLAVE_BUSWIDTH_4_BYTES) ||
-	    (config->dst_addr_width > DMA_SLAVE_BUSWIDTH_4_BYTES))
+	if (cfg->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
+	    cfg->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
 		return -EINVAL;
 
-	if (config->direction == DMA_MEM_TO_DEV) {
-		if (config->dst_addr)
-			echan->addr = config->dst_addr;
-		if (config->dst_addr_width)
-			echan->addr_width = config->dst_addr_width;
-		if (config->dst_maxburst)
-			echan->maxburst = config->dst_maxburst;
-	} else if (config->direction == DMA_DEV_TO_MEM) {
-		if (config->src_addr)
-			echan->addr = config->src_addr;
-		if (config->src_addr_width)
-			echan->addr_width = config->src_addr_width;
-		if (config->src_maxburst)
-			echan->maxburst = config->src_maxburst;
-	}
+	memcpy(&echan->cfg, cfg, sizeof(echan->cfg));
 
 	return 0;
 }
@@ -235,6 +218,9 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	struct edma_chan *echan = to_edma_chan(chan);
 	struct device *dev = chan->device->dev;
 	struct edma_desc *edesc;
+	dma_addr_t dev_addr;
+	enum dma_slave_buswidth dev_width;
+	u32 burst;
 	struct scatterlist *sg;
 	int i;
 	int acnt, bcnt, ccnt, src, dst, cidx;
@@ -243,7 +229,20 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 	if (unlikely(!echan || !sgl || !sg_len))
 		return NULL;
 
-	if (echan->addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
+	if (direction == DMA_DEV_TO_MEM) {
+		dev_addr = echan->cfg.src_addr;
+		dev_width = echan->cfg.src_addr_width;
+		burst = echan->cfg.src_maxburst;
+	} else if (direction == DMA_MEM_TO_DEV) {
+		dev_addr = echan->cfg.dst_addr;
+		dev_width = echan->cfg.dst_addr_width;
+		burst = echan->cfg.dst_maxburst;
+	} else {
+		dev_err(dev, "%s: bad direction?\n", __func__);
+		return NULL;
+	}
+
+	if (dev_width == DMA_SLAVE_BUSWIDTH_UNDEFINED) {
 		dev_err(dev, "Undefined slave buswidth\n");
 		return NULL;
 	}
@@ -275,14 +274,14 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 			}
 		}
 
-		acnt = echan->addr_width;
+		acnt = dev_width;
 
 		/*
 		 * If the maxburst is equal to the fifo width, use
 		 * A-synced transfers. This allows for large contiguous
 		 * buffer transfers using only one PaRAM set.
 		 */
-		if (echan->maxburst == 1) {
+		if (burst == 1) {
 			edesc->absync = false;
 			ccnt = sg_dma_len(sg) / acnt / (SZ_64K - 1);
 			bcnt = sg_dma_len(sg) / acnt - ccnt * (SZ_64K - 1);
@@ -302,7 +301,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 		 */
 		} else {
 			edesc->absync = true;
-			bcnt = echan->maxburst;
+			bcnt = burst;
 			ccnt = sg_dma_len(sg) / (acnt * bcnt);
 			if (ccnt > (SZ_64K - 1)) {
 				dev_err(dev, "Exceeded max SG segment size\n");
@@ -313,13 +312,13 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 
 		if (direction == DMA_MEM_TO_DEV) {
 			src = sg_dma_address(sg);
-			dst = echan->addr;
+			dst = dev_addr;
 			src_bidx = acnt;
 			src_cidx = cidx;
 			dst_bidx = 0;
 			dst_cidx = 0;
 		} else {
-			src = echan->addr;
+			src = dev_addr;
 			dst = sg_dma_address(sg);
 			src_bidx = 0;
 			src_cidx = 0;
-- 
1.7.9.5

