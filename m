Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab2CGOeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:34:07 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41988 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758742Ab2CGOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:05 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 03/13] dmaengine: imx-dma: remove dma_mode member of internal structure.
Date: Wed,  7 Mar 2012 15:33:35 +0100
Message-Id: <1331130825-14947-4-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmaengine now provides 'enum dma_transfer_direction' to properly
specify DMA transfer direction. For this reason, DMA_MODE_* defines
are replaced by this new type and therefore dma_mode member becomes
redundant.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |  103 +++++++++++++++++++++---------------------------
 1 files changed, 45 insertions(+), 58 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 1a9be6d..2c524e1 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -35,10 +35,6 @@
 #define IMXDMA_MAX_CHAN_DESCRIPTORS	16
 #define IMX_DMA_CHANNELS  16
 
-#define DMA_MODE_READ		0
-#define DMA_MODE_WRITE		1
-#define DMA_MODE_MASK		1
-
 #define IMX_DMA_LENGTH_LOOP	((unsigned int)-1)
 #define IMX_DMA_MEMSIZE_32	(0 << 4)
 #define IMX_DMA_MEMSIZE_8	(1 << 4)
@@ -132,7 +128,6 @@ enum  imxdma_prep_type {
  */
 
 struct imxdma_channel_internal {
-	unsigned int dma_mode;
 	struct scatterlist *sg;
 	unsigned int resbytes;
 
@@ -153,7 +148,7 @@ struct imxdma_desc {
 	dma_addr_t			src;
 	dma_addr_t			dest;
 	size_t				len;
-	unsigned int			dmamode;
+	enum dma_transfer_direction	direction;
 	enum imxdma_prep_type		type;
 	/* For memcpy and interleaved */
 	unsigned int			config_port;
@@ -239,8 +234,9 @@ static int imxdma_hw_chain(struct imxdma_channel_internal *imxdma)
 /*
  * imxdma_sg_next - prepare next chunk for scatter-gather DMA emulation
  */
-static inline int imxdma_sg_next(struct imxdma_channel *imxdmac, struct scatterlist *sg)
+static inline int imxdma_sg_next(struct imxdma_desc *d, struct scatterlist *sg)
 {
+	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
 	struct imxdma_channel_internal *imxdma = &imxdmac->internal;
 	unsigned long now;
 
@@ -248,7 +244,7 @@ static inline int imxdma_sg_next(struct imxdma_channel *imxdmac, struct scatterl
 	if (imxdma->resbytes != IMX_DMA_LENGTH_LOOP)
 		imxdma->resbytes -= now;
 
-	if ((imxdma->dma_mode & DMA_MODE_MASK) == DMA_MODE_READ)
+	if (d->direction == DMA_DEV_TO_MEM)
 		imx_dmav1_writel(sg->dma_address, DMA_DAR(imxdmac->channel));
 	else
 		imx_dmav1_writel(sg->dma_address, DMA_SAR(imxdmac->channel));
@@ -265,14 +261,12 @@ static inline int imxdma_sg_next(struct imxdma_channel *imxdmac, struct scatterl
 }
 
 static int
-imxdma_setup_single_hw(struct imxdma_channel *imxdmac, dma_addr_t dma_address,
-		     unsigned int dma_length, unsigned int dev_addr,
-		     unsigned int dmamode)
+imxdma_setup_mem2mem_hw(struct imxdma_channel *imxdmac, dma_addr_t dma_address,
+		     unsigned int dma_length, unsigned int dev_addr)
 {
 	int channel = imxdmac->channel;
 
 	imxdmac->internal.sg = NULL;
-	imxdmac->internal.dma_mode = dmamode;
 
 	if (!dma_address) {
 		printk(KERN_ERR "imxdma%d: imx_dma_setup_single null address\n",
@@ -286,38 +280,24 @@ imxdma_setup_single_hw(struct imxdma_channel *imxdmac, dma_addr_t dma_address,
 		return -EINVAL;
 	}
 
-	if ((dmamode & DMA_MODE_MASK) == DMA_MODE_READ) {
-		pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
-			"dev_addr=0x%08x for read\n",
-			channel, __func__, (unsigned int)dma_address,
-			dma_length, dev_addr);
+	pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
+		"dev_addr=0x%08x for write\n",
+		channel, __func__, (unsigned int)dma_address,
+		dma_length, dev_addr);
 
-		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
-		imx_dmav1_writel(dma_address, DMA_DAR(channel));
-		imx_dmav1_writel(imxdmac->internal.ccr_from_device, DMA_CCR(channel));
-	} else if ((dmamode & DMA_MODE_MASK) == DMA_MODE_WRITE) {
-		pr_debug("imxdma%d: %s dma_addressg=0x%08x dma_length=%d "
-			"dev_addr=0x%08x for write\n",
-			channel, __func__, (unsigned int)dma_address,
-			dma_length, dev_addr);
-
-		imx_dmav1_writel(dma_address, DMA_SAR(channel));
-		imx_dmav1_writel(dev_addr, DMA_DAR(channel));
-		imx_dmav1_writel(imxdmac->internal.ccr_to_device,
-				DMA_CCR(channel));
-	} else {
-		printk(KERN_ERR "imxdma%d: imx_dma_setup_single bad dmamode\n",
-		       channel);
-		return -EINVAL;
-	}
+	imx_dmav1_writel(dma_address, DMA_SAR(channel));
+	imx_dmav1_writel(dev_addr, DMA_DAR(channel));
+	imx_dmav1_writel(imxdmac->internal.ccr_to_device,
+			 DMA_CCR(channel));
 
 	imx_dmav1_writel(dma_length, DMA_CNTR(channel));
 
 	return 0;
 }
 
-static void imxdma_enable_hw(struct imxdma_channel *imxdmac)
+static void imxdma_enable_hw(struct imxdma_desc *d)
 {
+	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
 	int channel = imxdmac->channel;
 	unsigned long flags;
 
@@ -338,7 +318,7 @@ static void imxdma_enable_hw(struct imxdma_channel *imxdmac)
 		imxdmac->internal.sg = sg_next(imxdmac->internal.sg);
 		if (imxdmac->internal.sg) {
 			u32 tmp;
-			imxdma_sg_next(imxdmac, imxdmac->internal.sg);
+			imxdma_sg_next(d, imxdmac->internal.sg);
 			tmp = imx_dmav1_readl(DMA_CCR(channel));
 			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
 				DMA_CCR(channel));
@@ -395,18 +375,18 @@ imxdma_config_channel_hw(struct imxdma_channel *imxdmac, unsigned int config_por
 }
 
 static int
-imxdma_setup_sg_hw(struct imxdma_channel *imxdmac,
+imxdma_setup_sg_hw(struct imxdma_desc *d,
 		 struct scatterlist *sg, unsigned int sgcount,
 		 unsigned int dma_length, unsigned int dev_addr,
-		 unsigned int dmamode)
+		 enum dma_transfer_direction direction)
 {
+	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
 	int channel = imxdmac->channel;
 
 	if (imxdmac->internal.in_use)
 		return -EBUSY;
 
 	imxdmac->internal.sg = sg;
-	imxdmac->internal.dma_mode = dmamode;
 	imxdmac->internal.resbytes = dma_length;
 
 	if (!sg || !sgcount) {
@@ -421,14 +401,14 @@ imxdma_setup_sg_hw(struct imxdma_channel *imxdmac,
 		return -EINVAL;
 	}
 
-	if ((dmamode & DMA_MODE_MASK) == DMA_MODE_READ) {
+	if (direction == DMA_DEV_TO_MEM) {
 		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
 			"dev_addr=0x%08x for read\n",
 			channel, __func__, sg, sgcount, dma_length, dev_addr);
 
 		imx_dmav1_writel(dev_addr, DMA_SAR(channel));
 		imx_dmav1_writel(imxdmac->internal.ccr_from_device, DMA_CCR(channel));
-	} else if ((dmamode & DMA_MODE_MASK) == DMA_MODE_WRITE) {
+	} else if (direction == DMA_MEM_TO_DEV) {
 		pr_debug("imxdma%d: %s sg=%p sgcount=%d total length=%d "
 			"dev_addr=0x%08x for write\n",
 			channel, __func__, sg, sgcount, dma_length, dev_addr);
@@ -441,7 +421,7 @@ imxdma_setup_sg_hw(struct imxdma_channel *imxdmac,
 		return -EINVAL;
 	}
 
-	imxdma_sg_next(imxdmac, sg);
+	imxdma_sg_next(d, sg);
 
 	return 0;
 }
@@ -519,13 +499,26 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 {
 	struct imxdma_channel_internal *imxdma = &imxdmac->internal;
 	int chno = imxdmac->channel;
+	struct imxdma_desc *desc;
 
 	if (imxdma->sg) {
 		u32 tmp;
 		imxdma->sg = sg_next(imxdma->sg);
 
 		if (imxdma->sg) {
-			imxdma_sg_next(imxdmac, imxdma->sg);
+
+			spin_lock(&imxdmac->lock);
+			if (list_empty(&imxdmac->ld_active)) {
+				spin_unlock(&imxdmac->lock);
+				goto out;
+			}
+
+			desc = list_first_entry(&imxdmac->ld_active,
+						struct imxdma_desc,
+						node);
+			spin_unlock(&imxdmac->lock);
+
+			imxdma_sg_next(desc, imxdma->sg);
 
 			tmp = imx_dmav1_readl(DMA_CCR(chno));
 
@@ -558,6 +551,7 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 		}
 	}
 
+out:
 	imx_dmav1_writel(0, DMA_CCR(chno));
 	imxdma->in_use = 0;
 	/* Tasklet irq */
@@ -601,8 +595,7 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 					  d->config_port, d->config_mem, 0, 0);
 		if (ret < 0)
 			return ret;
-		ret = imxdma_setup_single_hw(imxdmac, d->src,
-					   d->len, d->dest, d->dmamode);
+		ret = imxdma_setup_mem2mem_hw(imxdmac, d->src, d->len, d->dest);
 		if (ret < 0)
 			return ret;
 		break;
@@ -610,19 +603,15 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
 	case IMXDMA_DESC_CYCLIC:
 	case IMXDMA_DESC_SLAVE_SG:
-		if (d->dmamode == DMA_MODE_READ)
-			ret = imxdma_setup_sg_hw(imxdmac, d->sg,
-				       d->sgcount, d->len, d->src, d->dmamode);
-		else
-			ret = imxdma_setup_sg_hw(imxdmac, d->sg,
-				      d->sgcount, d->len, d->dest, d->dmamode);
+		ret = imxdma_setup_sg_hw(d, d->sg, d->sgcount, d->len,
+					 imxdmac->per_address, d->direction);
 		if (ret < 0)
 			return ret;
 		break;
 	default:
 		return -EINVAL;
 	}
-	imxdma_enable_hw(imxdmac);
+	imxdma_enable_hw(d);
 	return 0;
 }
 
@@ -867,11 +856,10 @@ static struct dma_async_tx_descriptor *imxdma_prep_slave_sg(
 	desc->sg = sgl;
 	desc->sgcount = sg_len;
 	desc->len = dma_length;
+	desc->direction = direction;
 	if (direction == DMA_DEV_TO_MEM) {
-		desc->dmamode = DMA_MODE_READ;
 		desc->src = imxdmac->per_address;
 	} else {
-		desc->dmamode = DMA_MODE_WRITE;
 		desc->dest = imxdmac->per_address;
 	}
 	desc->desc.callback = NULL;
@@ -927,11 +915,10 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	desc->sg = imxdmac->sg_list;
 	desc->sgcount = periods;
 	desc->len = IMX_DMA_LENGTH_LOOP;
+	desc->direction = direction;
 	if (direction == DMA_DEV_TO_MEM) {
-		desc->dmamode = DMA_MODE_READ;
 		desc->src = imxdmac->per_address;
 	} else {
-		desc->dmamode = DMA_MODE_WRITE;
 		desc->dest = imxdmac->per_address;
 	}
 	desc->desc.callback = NULL;
@@ -961,7 +948,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
 	desc->src = src;
 	desc->dest = dest;
 	desc->len = len;
-	desc->dmamode = DMA_MODE_WRITE;
+	desc->direction = DMA_MEM_TO_MEM;
 	desc->config_port = IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR;
 	desc->config_mem = IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR;
 	desc->desc.callback = NULL;
-- 
1.7.0.4

