Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2CGOea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:34:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41988 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2CGOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:27 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 12/13] dmaengine: imx-dma: remove 'imx_dmav1_baseaddr' and 'dma_clk'.
Date: Wed,  7 Mar 2012 15:33:44 +0100
Message-Id: <1331130825-14947-13-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These global variables are integrated into the dmaengine structure.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |  169 +++++++++++++++++++++++++++----------------------
 1 files changed, 93 insertions(+), 76 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index d65eec6..fe0f126 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -160,6 +160,8 @@ struct imxdma_engine {
 	struct device			*dev;
 	struct device_dma_parameters	dma_parms;
 	struct dma_device		dma_device;
+	void __iomem			*base;
+	struct clk			*dma_clk;
 	struct imxdma_channel		channel[MAX_DMA_CHANNELS];
 };
 
@@ -181,18 +183,17 @@ static inline bool imxdma_chan_is_doing_cyclic(struct imxdma_channel *imxdmac)
 	return false;
 }
 
-/* TODO: put this inside any struct */
-static void __iomem *imx_dmav1_baseaddr;
-static struct clk *dma_clk;
 
-static void imx_dmav1_writel(unsigned val, unsigned offset)
+
+static void imx_dmav1_writel(struct imxdma_engine *imxdma, unsigned val,
+			     unsigned offset)
 {
-	__raw_writel(val, imx_dmav1_baseaddr + offset);
+	__raw_writel(val, imxdma->base + offset);
 }
 
-static unsigned imx_dmav1_readl(unsigned offset)
+static unsigned imx_dmav1_readl(struct imxdma_engine *imxdma, unsigned offset)
 {
-	return __raw_readl(imx_dmav1_baseaddr + offset);
+	return __raw_readl(imxdma->base + offset);
 }
 
 static int imxdma_hw_chain(struct imxdma_channel *imxdmac)
@@ -209,6 +210,7 @@ static int imxdma_hw_chain(struct imxdma_channel *imxdmac)
 static inline int imxdma_sg_next(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	struct scatterlist *sg = d->sg;
 	unsigned long now;
 
@@ -217,17 +219,19 @@ static inline int imxdma_sg_next(struct imxdma_desc *d)
 		d->len -= now;
 
 	if (d->direction == DMA_DEV_TO_MEM)
-		imx_dmav1_writel(sg->dma_address, DMA_DAR(imxdmac->channel));
+		imx_dmav1_writel(imxdma, sg->dma_address,
+				 DMA_DAR(imxdmac->channel));
 	else
-		imx_dmav1_writel(sg->dma_address, DMA_SAR(imxdmac->channel));
+		imx_dmav1_writel(imxdma, sg->dma_address,
+				 DMA_SAR(imxdmac->channel));
 
-	imx_dmav1_writel(now, DMA_CNTR(imxdmac->channel));
+	imx_dmav1_writel(imxdma, now, DMA_CNTR(imxdmac->channel));
 
 	pr_debug("imxdma%d: next sg chunk dst 0x%08x, src 0x%08x, "
 		"size 0x%08x\n", imxdmac->channel,
-		 imx_dmav1_readl(DMA_DAR(imxdmac->channel)),
-		 imx_dmav1_readl(DMA_SAR(imxdmac->channel)),
-		 imx_dmav1_readl(DMA_CNTR(imxdmac->channel)));
+		 imx_dmav1_readl(imxdma, DMA_DAR(imxdmac->channel)),
+		 imx_dmav1_readl(imxdma, DMA_SAR(imxdmac->channel)),
+		 imx_dmav1_readl(imxdma, DMA_CNTR(imxdmac->channel)));
 
 	return now;
 }
@@ -235,6 +239,7 @@ static inline int imxdma_sg_next(struct imxdma_desc *d)
 static void imxdma_enable_hw(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	int channel = imxdmac->channel;
 	unsigned long flags;
 
@@ -242,10 +247,11 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 
 	local_irq_save(flags);
 
-	imx_dmav1_writel(1 << channel, DMA_DISR);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) & ~(1 << channel), DMA_DIMR);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) | CCR_CEN |
-		CCR_ACRPT, DMA_CCR(channel));
+	imx_dmav1_writel(imxdma, 1 << channel, DMA_DISR);
+	imx_dmav1_writel(imxdma, imx_dmav1_readl(imxdma, DMA_DIMR) &
+			 ~(1 << channel), DMA_DIMR);
+	imx_dmav1_writel(imxdma, imx_dmav1_readl(imxdma, DMA_CCR(channel)) |
+			 CCR_CEN | CCR_ACRPT, DMA_CCR(channel));
 
 	if ((cpu_is_mx21() || cpu_is_mx27()) &&
 			d->sg && imxdma_hw_chain(imxdmac)) {
@@ -253,9 +259,9 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 		if (d->sg) {
 			u32 tmp;
 			imxdma_sg_next(d);
-			tmp = imx_dmav1_readl(DMA_CCR(channel));
-			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
-				DMA_CCR(channel));
+			tmp = imx_dmav1_readl(imxdma, DMA_CCR(channel));
+			imx_dmav1_writel(imxdma, tmp | CCR_RPT | CCR_ACRPT,
+					 DMA_CCR(channel));
 		}
 	}
 
@@ -264,6 +270,7 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 
 static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 {
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	int channel = imxdmac->channel;
 	unsigned long flags;
 
@@ -273,19 +280,21 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 		del_timer(&imxdmac->watchdog);
 
 	local_irq_save(flags);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) | (1 << channel), DMA_DIMR);
-	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) & ~CCR_CEN,
-			DMA_CCR(channel));
-	imx_dmav1_writel(1 << channel, DMA_DISR);
+	imx_dmav1_writel(imxdma, imx_dmav1_readl(imxdma, DMA_DIMR) |
+			 (1 << channel), DMA_DIMR);
+	imx_dmav1_writel(imxdma, imx_dmav1_readl(imxdma, DMA_CCR(channel)) &
+			 ~CCR_CEN, DMA_CCR(channel));
+	imx_dmav1_writel(imxdma, 1 << channel, DMA_DISR);
 	local_irq_restore(flags);
 }
 
 static void imxdma_watchdog(unsigned long data)
 {
 	struct imxdma_channel *imxdmac = (struct imxdma_channel *)data;
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	int channel = imxdmac->channel;
 
-	imx_dmav1_writel(0, DMA_CCR(channel));
+	imx_dmav1_writel(imxdma, 0, DMA_CCR(channel));
 
 	/* Tasklet watchdog error handler */
 	tasklet_schedule(&imxdmac->dma_tasklet);
@@ -299,37 +308,37 @@ static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
 	int i, disr;
 	int errcode;
 
-	disr = imx_dmav1_readl(DMA_DISR);
+	disr = imx_dmav1_readl(imxdma, DMA_DISR);
 
-	err_mask = imx_dmav1_readl(DMA_DBTOSR) |
-		   imx_dmav1_readl(DMA_DRTOSR) |
-		   imx_dmav1_readl(DMA_DSESR)  |
-		   imx_dmav1_readl(DMA_DBOSR);
+	err_mask = imx_dmav1_readl(imxdma, DMA_DBTOSR) |
+		   imx_dmav1_readl(imxdma, DMA_DRTOSR) |
+		   imx_dmav1_readl(imxdma, DMA_DSESR)  |
+		   imx_dmav1_readl(imxdma, DMA_DBOSR);
 
 	if (!err_mask)
 		return IRQ_HANDLED;
 
-	imx_dmav1_writel(disr & err_mask, DMA_DISR);
+	imx_dmav1_writel(imxdma, disr & err_mask, DMA_DISR);
 
 	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
 		if (!(err_mask & (1 << i)))
 			continue;
 		errcode = 0;
 
-		if (imx_dmav1_readl(DMA_DBTOSR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DBTOSR);
+		if (imx_dmav1_readl(imxdma, DMA_DBTOSR) & (1 << i)) {
+			imx_dmav1_writel(imxdma, 1 << i, DMA_DBTOSR);
 			errcode |= IMX_DMA_ERR_BURST;
 		}
-		if (imx_dmav1_readl(DMA_DRTOSR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DRTOSR);
+		if (imx_dmav1_readl(imxdma, DMA_DRTOSR) & (1 << i)) {
+			imx_dmav1_writel(imxdma, 1 << i, DMA_DRTOSR);
 			errcode |= IMX_DMA_ERR_REQUEST;
 		}
-		if (imx_dmav1_readl(DMA_DSESR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DSESR);
+		if (imx_dmav1_readl(imxdma, DMA_DSESR) & (1 << i)) {
+			imx_dmav1_writel(imxdma, 1 << i, DMA_DSESR);
 			errcode |= IMX_DMA_ERR_TRANSFER;
 		}
-		if (imx_dmav1_readl(DMA_DBOSR) & (1 << i)) {
-			imx_dmav1_writel(1 << i, DMA_DBOSR);
+		if (imx_dmav1_readl(imxdma, DMA_DBOSR) & (1 << i)) {
+			imx_dmav1_writel(imxdma, 1 << i, DMA_DBOSR);
 			errcode |= IMX_DMA_ERR_BUFFER;
 		}
 		/* Tasklet error handler */
@@ -347,6 +356,7 @@ static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
 
 static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 {
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	int chno = imxdmac->channel;
 	struct imxdma_desc *desc;
 
@@ -368,7 +378,7 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 		if (desc->sg) {
 			imxdma_sg_next(desc);
 
-			tmp = imx_dmav1_readl(DMA_CCR(chno));
+			tmp = imx_dmav1_readl(imxdma, DMA_CCR(chno));
 
 			if (imxdma_hw_chain(imxdmac)) {
 				/* FIXME: The timeout should probably be
@@ -378,13 +388,14 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 					jiffies + msecs_to_jiffies(500));
 
 				tmp |= CCR_CEN | CCR_RPT | CCR_ACRPT;
-				imx_dmav1_writel(tmp, DMA_CCR(chno));
+				imx_dmav1_writel(imxdma, tmp, DMA_CCR(chno));
 			} else {
-				imx_dmav1_writel(tmp & ~CCR_CEN, DMA_CCR(chno));
+				imx_dmav1_writel(imxdma, tmp & ~CCR_CEN,
+						 DMA_CCR(chno));
 				tmp |= CCR_CEN;
 			}
 
-			imx_dmav1_writel(tmp, DMA_CCR(chno));
+			imx_dmav1_writel(imxdma, tmp, DMA_CCR(chno));
 
 			if (imxdma_chan_is_doing_cyclic(imxdmac))
 				/* Tasklet progression */
@@ -400,7 +411,7 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 	}
 
 out:
-	imx_dmav1_writel(0, DMA_CCR(chno));
+	imx_dmav1_writel(imxdma, 0, DMA_CCR(chno));
 	/* Tasklet irq */
 	tasklet_schedule(&imxdmac->dma_tasklet);
 }
@@ -413,12 +424,12 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 	if (cpu_is_mx21() || cpu_is_mx27())
 		imxdma_err_handler(irq, dev_id);
 
-	disr = imx_dmav1_readl(DMA_DISR);
+	disr = imx_dmav1_readl(imxdma, DMA_DISR);
 
 	pr_debug("imxdma: dma_irq_handler called, disr=0x%08x\n",
 		     disr);
 
-	imx_dmav1_writel(disr, DMA_DISR);
+	imx_dmav1_writel(imxdma, disr, DMA_DISR);
 	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
 		if (disr & (1 << i))
 			dma_irq_handle_channel(&imxdma->channel[i]);
@@ -435,12 +446,12 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Configure and enable */
 	switch (d->type) {
 	case IMXDMA_DESC_MEMCPY:
-		imx_dmav1_writel(d->src, DMA_SAR(imxdmac->channel));
-		imx_dmav1_writel(d->dest, DMA_DAR(imxdmac->channel));
-		imx_dmav1_writel(d->config_mem | (d->config_port << 2),
+		imx_dmav1_writel(imxdma, d->src, DMA_SAR(imxdmac->channel));
+		imx_dmav1_writel(imxdma, d->dest, DMA_DAR(imxdmac->channel));
+		imx_dmav1_writel(imxdma, d->config_mem | (d->config_port << 2),
 			 DMA_CCR(imxdmac->channel));
 
-		imx_dmav1_writel(d->len, DMA_CNTR(imxdmac->channel));
+		imx_dmav1_writel(imxdma, d->len, DMA_CNTR(imxdmac->channel));
 
 		dev_dbg(imxdma->dev, "%s channel: %d dest=0x%08x src=0x%08x "
 			"dma_length=%d\n", __func__, imxdmac->channel,
@@ -451,9 +462,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	case IMXDMA_DESC_CYCLIC:
 	case IMXDMA_DESC_SLAVE_SG:
 		if (d->direction == DMA_DEV_TO_MEM) {
-			imx_dmav1_writel(imxdmac->per_address,
+			imx_dmav1_writel(imxdma, imxdmac->per_address,
 					 DMA_SAR(imxdmac->channel));
-			imx_dmav1_writel(imxdmac->ccr_from_device,
+			imx_dmav1_writel(imxdma, imxdmac->ccr_from_device,
 					 DMA_CCR(imxdmac->channel));
 
 			dev_dbg(imxdma->dev, "%s channel: %d sg=%p sgcount=%d "
@@ -461,9 +472,9 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 				__func__, imxdmac->channel, d->sg, d->sgcount,
 				d->len, imxdmac->per_address);
 		} else if (d->direction == DMA_MEM_TO_DEV) {
-			imx_dmav1_writel(imxdmac->per_address,
+			imx_dmav1_writel(imxdma, imxdmac->per_address,
 					 DMA_DAR(imxdmac->channel));
-			imx_dmav1_writel(imxdmac->ccr_to_device,
+			imx_dmav1_writel(imxdma, imxdmac->ccr_to_device,
 					 DMA_CCR(imxdmac->channel));
 
 			dev_dbg(imxdma->dev, "%s channel: %d sg=%p sgcount=%d "
@@ -528,6 +539,7 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct dma_slave_config *dmaengine_cfg = (void *)arg;
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
 	unsigned long flags;
 	unsigned int mode = 0;
 
@@ -573,12 +585,12 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 		imxdmac->ccr_to_device =
 			(IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) |
 			((mode | IMX_DMA_TYPE_FIFO) << 2) | CCR_REN;
-		imx_dmav1_writel(imxdmac->dma_request,
+		imx_dmav1_writel(imxdma, imxdmac->dma_request,
 				 DMA_RSSR(imxdmac->channel));
 
 		/* Set burst length */
-		imx_dmav1_writel(imxdmac->watermark_level * imxdmac->word_size,
-				 DMA_BLR(imxdmac->channel));
+		imx_dmav1_writel(imxdma, imxdmac->watermark_level *
+				imxdmac->word_size, DMA_BLR(imxdmac->channel));
 
 		return 0;
 	default:
@@ -863,27 +875,35 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	struct imxdma_engine *imxdma;
 	int ret, i;
 
-	if (cpu_is_mx1())
-		imx_dmav1_baseaddr = MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR);
-	else if (cpu_is_mx21())
-		imx_dmav1_baseaddr = MX21_IO_ADDRESS(MX21_DMA_BASE_ADDR);
-	else if (cpu_is_mx27())
-		imx_dmav1_baseaddr = MX27_IO_ADDRESS(MX27_DMA_BASE_ADDR);
-	else
+
+	imxdma = kzalloc(sizeof(*imxdma), GFP_KERNEL);
+	if (!imxdma)
+		return -ENOMEM;
+
+	if (cpu_is_mx1()) {
+		imxdma->base = MX1_IO_ADDRESS(MX1_DMA_BASE_ADDR);
+	} else if (cpu_is_mx21()) {
+		imxdma->base = MX21_IO_ADDRESS(MX21_DMA_BASE_ADDR);
+	} else if (cpu_is_mx27()) {
+		imxdma->base = MX27_IO_ADDRESS(MX27_DMA_BASE_ADDR);
+	} else {
+		kfree(imxdma);
 		return 0;
+	}
 
-	dma_clk = clk_get(NULL, "dma");
-	if (IS_ERR(dma_clk))
-		return PTR_ERR(dma_clk);
-	clk_enable(dma_clk);
+	imxdma->dma_clk = clk_get(NULL, "dma");
+	if (IS_ERR(imxdma->dma_clk))
+		return PTR_ERR(imxdma->dma_clk);
+	clk_enable(imxdma->dma_clk);
 
 	/* reset DMA module */
-	imx_dmav1_writel(DCR_DRST, DMA_DCR);
+	imx_dmav1_writel(imxdma, DCR_DRST, DMA_DCR);
 
 	if (cpu_is_mx1()) {
 		ret = request_irq(MX1_DMA_INT, dma_irq_handler, 0, "DMA", imxdma);
 		if (ret) {
 			pr_crit("Can't register IRQ for DMA\n");
+			kfree(imxdma);
 			return ret;
 		}
 
@@ -891,22 +911,19 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		if (ret) {
 			pr_crit("Can't register ERRIRQ for DMA\n");
 			free_irq(MX1_DMA_INT, NULL);
+			kfree(imxdma);
 			return ret;
 		}
 	}
 
 	/* enable DMA module */
-	imx_dmav1_writel(DCR_DEN, DMA_DCR);
+	imx_dmav1_writel(imxdma, DCR_DEN, DMA_DCR);
 
 	/* clear all interrupts */
-	imx_dmav1_writel((1 << IMX_DMA_CHANNELS) - 1, DMA_DISR);
+	imx_dmav1_writel(imxdma, (1 << IMX_DMA_CHANNELS) - 1, DMA_DISR);
 
 	/* disable interrupts */
-	imx_dmav1_writel((1 << IMX_DMA_CHANNELS) - 1, DMA_DIMR);
-
-	imxdma = kzalloc(sizeof(*imxdma), GFP_KERNEL);
-	if (!imxdma)
-		return -ENOMEM;
+	imx_dmav1_writel(imxdma, (1 << IMX_DMA_CHANNELS) - 1, DMA_DIMR);
 
 	INIT_LIST_HEAD(&imxdma->dma_device.channels);
 
-- 
1.7.0.4

