Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2CEQTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:19:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab2CEQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:16:56 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 04/14] dmaengine: imx-dma: remove 'imxdma_setup_mem2mem_hw' function.
Date: Mon,  5 Mar 2012 17:16:26 +0100
Message-Id: <1330964196-32623-5-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   57 ++++++++++++-------------------------------------
 1 files changed, 14 insertions(+), 43 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 2c524e1..8a0afb1 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -260,41 +260,6 @@ static inline int imxdma_sg_next(struct imxdma_desc *d, struct scatterlist *sg)
 	return now;
 }
 
-static int
-imxdma_setup_mem2mem_hw(struct imxdma_channel *imxdmac, dma_addr_t dma_address,
-		     unsigned int dma_length, unsigned int dev_addr)
-{
-	int channel = imxdmac->channel;
-
-	imxdmac->internal.sg = NULL;
-
-	if (!dma_address) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_single null address\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if (!dma_length) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_single zero length\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
-		"dev_addr=0x%08x for write\n",
-		channel, __func__, (unsigned int)dma_address,
-		dma_length, dev_addr);
-
-	imx_dmav1_writel(dma_address, DMA_SAR(channel));
-	imx_dmav1_writel(dev_addr, DMA_DAR(channel));
-	imx_dmav1_writel(imxdmac->internal.ccr_to_device,
-			 DMA_CCR(channel));
-
-	imx_dmav1_writel(dma_length, DMA_CNTR(channel));
-
-	return 0;
-}
-
 static void imxdma_enable_hw(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
@@ -586,20 +551,26 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 static int imxdma_xfer_desc(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	int ret;
 
 	/* Configure and enable */
 	switch (d->type) {
 	case IMXDMA_DESC_MEMCPY:
-		ret = imxdma_config_channel_hw(imxdmac,
-					  d->config_port, d->config_mem, 0, 0);
-		if (ret < 0)
-			return ret;
-		ret = imxdma_setup_mem2mem_hw(imxdmac, d->src, d->len, d->dest);
-		if (ret < 0)
-			return ret;
-		break;
+		imxdmac->internal.sg = NULL;
+
+		imx_dmav1_writel(d->src, DMA_SAR(imxdmac->channel));
+		imx_dmav1_writel(d->dest, DMA_DAR(imxdmac->channel));
+		imx_dmav1_writel(d->config_mem | (d->config_port << 2),
+			 DMA_CCR(imxdmac->channel));
 
+		imx_dmav1_writel(d->len, DMA_CNTR(imxdmac->channel));
+
+		dev_dbg(imxdma->dev, "%s channel: %d dest=0x%08x src=0x%08x "
+			"dma_length=%d\n", __func__, imxdmac->channel,
+			d->dest, d->src, d->len);
+
+		break;
 	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
 	case IMXDMA_DESC_CYCLIC:
 	case IMXDMA_DESC_SLAVE_SG:
-- 
1.7.0.4

