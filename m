Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2CGOeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:34:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63488 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2CGOeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:21 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 10/13] dmaengine: imx-dma: remove internal structure.
Date: Wed,  7 Mar 2012 15:33:42 +0100
Message-Id: <1331130825-14947-11-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This structure was created to allow an smoothless
merge but was meant to be removed. Remaining members
'hw_chaining' and 'watchdog' are moved to the channel
structure.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   64 +++++++++++++-----------------------------------
 1 files changed, 18 insertions(+), 46 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index d525f1e..2f72447 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -110,29 +110,6 @@ enum  imxdma_prep_type {
 	IMXDMA_DESC_CYCLIC,
 };
 
-/*
- * struct imxdma_channel_internal - i.MX specific DMA extension
- * @name: name specified by DMA client
- * @irq_handler: client callback for end of transfer
- * @err_handler: client callback for error condition
- * @data: clients context data for callbacks
- * @dma_mode: direction of the transfer %DMA_MODE_READ or %DMA_MODE_WRITE
- * @sg: pointer to the actual read/written chunk for scatter-gather emulation
- * @resbytes: total residual number of bytes to transfer
- *            (it can be lower or same as sum of SG mapped chunk sizes)
- * @sgcount: number of chunks to be read/written
- *
- * Structure is used for IMX DMA processing. It would be probably good
- * @struct dma_struct in the future for external interfacing and use
- * @struct imxdma_channel_internal only as extension to it.
- */
-
-struct imxdma_channel_internal {
-	struct timer_list watchdog;
-
-	int hw_chaining;
-};
-
 struct imxdma_desc {
 	struct list_head		node;
 	struct dma_async_tx_descriptor	desc;
@@ -155,7 +132,8 @@ struct imxdma_desc {
 };
 
 struct imxdma_channel {
-	struct imxdma_channel_internal	internal;
+	int				hw_chaining;
+	struct timer_list		watchdog;
 	struct imxdma_engine		*imxdma;
 	unsigned int			channel;
 
@@ -217,10 +195,10 @@ static unsigned imx_dmav1_readl(unsigned offset)
 	return __raw_readl(imx_dmav1_baseaddr + offset);
 }
 
-static int imxdma_hw_chain(struct imxdma_channel_internal *imxdma)
+static int imxdma_hw_chain(struct imxdma_channel *imxdmac)
 {
 	if (cpu_is_mx27())
-		return imxdma->hw_chaining;
+		return imxdmac->hw_chaining;
 	else
 		return 0;
 }
@@ -269,7 +247,7 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 		CCR_ACRPT, DMA_CCR(channel));
 
 	if ((cpu_is_mx21() || cpu_is_mx27()) &&
-			d->sg && imxdma_hw_chain(&imxdmac->internal)) {
+			d->sg && imxdma_hw_chain(imxdmac)) {
 		d->sg = sg_next(d->sg);
 		if (d->sg) {
 			u32 tmp;
@@ -290,8 +268,8 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 
 	pr_debug("imxdma%d: imx_dma_disable\n", channel);
 
-	if (imxdma_hw_chain(&imxdmac->internal))
-		del_timer(&imxdmac->internal.watchdog);
+	if (imxdma_hw_chain(imxdmac))
+		del_timer(&imxdmac->watchdog);
 
 	local_irq_save(flags);
 	imx_dmav1_writel(imx_dmav1_readl(DMA_DIMR) | (1 << channel), DMA_DIMR);
@@ -316,7 +294,6 @@ static void imxdma_watchdog(unsigned long data)
 static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
 {
 	struct imxdma_engine *imxdma = dev_id;
-	struct imxdma_channel_internal *internal;
 	unsigned int err_mask;
 	int i, disr;
 	int errcode;
@@ -336,7 +313,6 @@ static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
 	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
 		if (!(err_mask & (1 << i)))
 			continue;
-		internal = &imxdma->channel[i].internal;
 		errcode = 0;
 
 		if (imx_dmav1_readl(DMA_DBTOSR) & (1 << i)) {
@@ -370,7 +346,6 @@ static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
 
 static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 {
-	struct imxdma_channel_internal *imxdma = &imxdmac->internal;
 	int chno = imxdmac->channel;
 	struct imxdma_desc *desc;
 
@@ -394,11 +369,11 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 
 			tmp = imx_dmav1_readl(DMA_CCR(chno));
 
-			if (imxdma_hw_chain(imxdma)) {
+			if (imxdma_hw_chain(imxdmac)) {
 				/* FIXME: The timeout should probably be
 				 * configurable
 				 */
-				mod_timer(&imxdma->watchdog,
+				mod_timer(&imxdmac->watchdog,
 					jiffies + msecs_to_jiffies(500));
 
 				tmp |= CCR_CEN | CCR_RPT | CCR_ACRPT;
@@ -417,8 +392,8 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 			return;
 		}
 
-		if (imxdma_hw_chain(imxdma)) {
-			del_timer(&imxdma->watchdog);
+		if (imxdma_hw_chain(imxdmac)) {
+			del_timer(&imxdmac->watchdog);
 			return;
 		}
 	}
@@ -432,7 +407,6 @@ out:
 static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
 	struct imxdma_engine *imxdma = dev_id;
-	struct imxdma_channel_internal *internal;
 	int i, disr;
 
 	if (cpu_is_mx21() || cpu_is_mx27())
@@ -445,10 +419,8 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 	imx_dmav1_writel(disr, DMA_DISR);
 	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
-		if (disr & (1 << i)) {
-			internal = &imxdma->channel[i].internal;
+		if (disr & (1 << i))
 			dma_irq_handle_channel(&imxdma->channel[i]);
-		}
 	}
 
 	return IRQ_HANDLED;
@@ -591,8 +563,8 @@ static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 			break;
 		}
 
-		imxdmac->internal.hw_chaining = 1;
-		if (!imxdma_hw_chain(&imxdmac->internal))
+		imxdmac->hw_chaining = 1;
+		if (!imxdma_hw_chain(imxdmac))
 			return -EINVAL;
 		imxdmac->ccr_from_device = (mode | IMX_DMA_TYPE_FIFO) |
 			((IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR) << 2) |
@@ -944,7 +916,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
 		struct imxdma_channel *imxdmac = &imxdma->channel[i];
-		memset(&imxdmac->internal, 0, sizeof(imxdmac->internal));
+
 		if (cpu_is_mx21() || cpu_is_mx27()) {
 			ret = request_irq(MX2x_INT_DMACH0 + i,
 					dma_irq_handler, 0, "DMA", imxdma);
@@ -953,9 +925,9 @@ static int __init imxdma_probe(struct platform_device *pdev)
 						MX2x_INT_DMACH0 + i, i);
 				goto err_init;
 			}
-			init_timer(&imxdmac->internal.watchdog);
-			imxdmac->internal.watchdog.function = &imxdma_watchdog;
-			imxdmac->internal.watchdog.data = (unsigned long)imxdmac;
+			init_timer(&imxdmac->watchdog);
+			imxdmac->watchdog.function = &imxdma_watchdog;
+			imxdmac->watchdog.data = (unsigned long)imxdmac;
 		}
 
 		imxdmac->imxdma = imxdma;
-- 
1.7.0.4

