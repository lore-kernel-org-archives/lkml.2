Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2CIP0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:26:24 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33137 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab2CIP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:26:22 -0500
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 10:26:22 EST
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3 05/13] dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
Date: Fri,  9 Mar 2012 16:20:41 +0100
Message-Id: <1331306449-28591-6-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only used once in the driver and uses some
intermediary variables that are not needed anymore. For this
reason it's been merged with 'imxdma_control'.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   46 +++++++++++++---------------------------------
 1 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index f86ac06..d86b3d5 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -312,32 +312,6 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 }
 
 static int
-imxdma_config_channel_hw(struct imxdma_channel *imxdmac, unsigned int config_port,
-	unsigned int config_mem, unsigned int dmareq, int hw_chaining)
-{
-	int channel = imxdmac->channel;
-	u32 dreq = 0;
-
-	imxdmac->internal.hw_chaining = 0;
-
-	if (hw_chaining) {
-		imxdmac->internal.hw_chaining = 1;
-		if (!imxdma_hw_chain(&imxdmac->internal))
-			return -EINVAL;
-	}
-
-	if (dmareq)
-		dreq = CCR_REN;
-
-	imxdmac->internal.ccr_from_device = config_port | (config_mem << 2) | dreq;
-	imxdmac->internal.ccr_to_device = config_mem | (config_port << 2) | dreq;
-
-	imx_dmav1_writel(dmareq, DMA_RSSR(channel));
-
-	return 0;
-}
-
-static int
 imxdma_setup_sg_hw(struct imxdma_desc *d,
 		 struct scatterlist *sg, unsigned int sgcount,
 		 unsigned int dma_length, unsigned int dev_addr,
@@ -626,7 +600,6 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct dma_slave_config *dmaengine_cfg = (void *)arg;
-	int ret;
 	unsigned long flags;
 	unsigned int mode = 0;
 
@@ -662,13 +635,20 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			mode = IMX_DMA_MEMSIZE_32;
 			break;
 		}
-		ret = imxdma_config_channel_hw(imxdmac,
-				mode | IMX_DMA_TYPE_FIFO,
-				IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
-				imxdmac->dma_request, 1);
 
-		if (ret)
-			return ret;
+		imxdmac->internal.hw_chaining = 1;
+		if (!imxdma_hw_chain(&imxdmac->internal))
+			return -EINVAL;
+		imxdmac->internal.ccr_from_device =
+			(mode | IMX_DMA_TYPE_FIFO) |
+			((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
+			CCR_REN;
+		imxdmac->internal.ccr_to_device =
+			(IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) |
+			((mode | IMX_DMA_TYPE_FIFO) << 2) | CCR_REN;
+		imx_dmav1_writel(imxdmac->dma_request,
+				 DMA_RSSR(imxdmac->channel));
+
 		/* Set burst length */
 		imx_dmav1_writel(imxdmac->watermark_level * imxdmac->word_size,
 				 DMA_BLR(imxdmac->channel));
-- 
1.7.0.4

