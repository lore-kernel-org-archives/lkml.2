Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab2CEQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:16:59 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50087 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2CEQQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:16:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.216.134.205 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 05/14] dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
Date: Mon,  5 Mar 2012 17:16:27 +0100
Message-Id: <1330964196-32623-6-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   46 +++++++++++++---------------------------------
 1 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 8a0afb1..5432b04 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -314,32 +314,6 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
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
@@ -628,7 +602,6 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct dma_slave_config *dmaengine_cfg = (void *)arg;
-	int ret;
 	unsigned long flags;
 	unsigned int mode = 0;
 
@@ -664,13 +637,20 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
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

