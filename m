Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2CEQRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:17:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2CEQQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:16:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.180.106.9 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 06/14] dmaengine: imx-dma: remove 'imxdma_setup_sg_hw' function.
Date: Mon,  5 Mar 2012 17:16:28 +0100
Message-Id: <1330964196-32623-7-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing this function allows moving 'ccr_to_device' and
'ccr_from_device' from internal struct to channel struct.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   97 ++++++++++++++++++-------------------------------
 1 files changed, 35 insertions(+), 62 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 5432b04..cb45aff 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -133,9 +133,6 @@ struct imxdma_channel_internal {
 
 	int in_use;
 
-	u32 ccr_from_device;
-	u32 ccr_to_device;
-
 	struct timer_list watchdog;
 
 	int hw_chaining;
@@ -180,6 +177,8 @@ struct imxdma_channel {
 	dma_cookie_t			last_completed;
 	int				dma_request;
 	struct scatterlist		*sg_list;
+	u32				ccr_from_device;
+	u32				ccr_to_device;
 };
 
 #define MAX_DMA_CHANNELS 8
@@ -313,58 +312,6 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 	local_irq_restore(flags);
 }
 
-static int
-imxdma_setup_sg_hw(struct imxdma_desc *d,
-		 struct scatterlist *sg, unsigned int sgcount,
-		 unsigned int dma_length, unsigned int dev_addr,
-		 enum dma_transfer_direction direction)
-{
-	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
-	int channel = imxdmac->channel;
-
-	if (imxdmac->internal.in_use)
-		return -EBUSY;
-
-	imxdmac->internal.sg = sg;
-	imxdmac->internal.resbytes = dma_length;
-
-	if (!sg || !sgcount) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg empty sg list\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if (!sg->length) {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg zero length\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	if (direction == DMA_DEV_TO_MEM) {
-		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
-			"dev_addr=0x%08x for read\n",
-			channel, __func__, sg, sgcount, dma_length, dev_addr);
-
-		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
-		imx_dmav1_writel(imxdmac->internal.ccr_from_device, DMA_CCR(channel));
-	} else if (direction == DMA_MEM_TO_DEV) {
-		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
-			"dev_addr=0x%08x for write\n",
-			channel, __func__, sg, sgcount, dma_length, dev_addr);
-
-		imx_dmav1_writel(dev_addr, DMA_DAR(channel));
-		imx_dmav1_writel(imxdmac->internal.ccr_to_device, DMA_CCR(channel));
-	} else {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_sg bad dmamode\n",
-		       channel);
-		return -EINVAL;
-	}
-
-	imxdma_sg_next(d, sg);
-
-	return 0;
-}
-
 static void imxdma_watchdog(unsigned long data)
 {
 	struct imxdma_channel *imxdmac = (struct imxdma_channel *)data;
@@ -548,10 +495,37 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
 	case IMXDMA_DESC_CYCLIC:
 	case IMXDMA_DESC_SLAVE_SG:
-		ret = imxdma_setup_sg_hw(d, d->sg, d->sgcount, d->len,
-					 imxdmac->per_address, d->direction);
-		if (ret < 0)
-			return ret;
+		imxdmac->internal.sg = d->sg;
+		imxdmac->internal.resbytes = d->len;
+
+		if (d->direction == DMA_DEV_TO_MEM) {
+			imx_dmav1_writel(imxdmac->per_address,
+					 DMA_SAR(imxdmac->channel));
+			imx_dmav1_writel(imxdmac->ccr_from_device,
+					 DMA_CCR(imxdmac->channel));
+
+			dev_dbg(imxdma->dev, "%s channel: %d sg=%p sgcount=%d "
+				"total length=%d dev_addr=0x%08x (dev2mem)\n",
+				__func__, imxdmac->channel, d->sg, d->sgcount,
+				d->len, imxdmac->per_address);
+		} else if (d->direction == DMA_MEM_TO_DEV) {
+			imx_dmav1_writel(imxdmac->per_address,
+					 DMA_DAR(imxdmac->channel));
+			imx_dmav1_writel(imxdmac->ccr_to_device,
+					 DMA_CCR(imxdmac->channel));
+
+			dev_dbg(imxdma->dev, "%s channel: %d sg=%p sgcount=%d "
+				"total length=%d dev_addr=0x%08x (mem2dev)\n",
+				__func__, imxdmac->channel, d->sg, d->sgcount,
+				d->len, imxdmac->per_address);
+		} else {
+			dev_err(imxdma->dev, "%s channel: %d bad dma mode\n",
+				__func__, imxdmac->channel);
+			return -EINVAL;
+		}
+
+		imxdma_sg_next(d, d->sg);
+
 		break;
 	default:
 		return -EINVAL;
@@ -641,11 +615,10 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		imxdmac->internal.hw_chaining = 1;
 		if (!imxdma_hw_chain(&imxdmac->internal))
 			return -EINVAL;
-		imxdmac->internal.ccr_from_device =
-			(mode | IMX_DMA_TYPE_FIFO) |
+		imxdmac->ccr_from_device = (mode | IMX_DMA_TYPE_FIFO) |
 			((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
 			CCR_REN;
-		imxdmac->internal.ccr_to_device =
+		imxdmac->ccr_to_device =
 			(IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) |
 			((mode | IMX_DMA_TYPE_FIFO) << 2) | CCR_REN;
 		imx_dmav1_writel(imxdmac->dma_request,
-- 
1.7.0.4

