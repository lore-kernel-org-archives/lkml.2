Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2CGOec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:34:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab2CGOea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:30 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 13/13] dmaengine: imx-dma: use 'dev_dbg' and 'dev_warn' for messages.
Date: Wed,  7 Mar 2012 15:33:45 +0100
Message-Id: <1331130825-14947-14-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some 'pr_crit' and 'pr_debug' messages due to the
initial merge. Replace them by 'dev_dbg' and 'dev_warn' to be
consistent.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index fe0f126..d1dee86 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -227,8 +227,8 @@ static inline int imxdma_sg_next(struct imxdma_desc *d)
 
 	imx_dmav1_writel(imxdma, now, DMA_CNTR(imxdmac->channel));
 
-	pr_debug("imxdma%d: next sg chunk dst 0x%08x, src 0x%08x, "
-		"size 0x%08x\n", imxdmac->channel,
+	dev_dbg(imxdma->dev, " %s channel: %d dst 0x%08x, src 0x%08x, "
+		"size 0x%08x\n", __func__, imxdmac->channel,
 		 imx_dmav1_readl(imxdma, DMA_DAR(imxdmac->channel)),
 		 imx_dmav1_readl(imxdma, DMA_SAR(imxdmac->channel)),
 		 imx_dmav1_readl(imxdma, DMA_CNTR(imxdmac->channel)));
@@ -243,7 +243,7 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 	int channel = imxdmac->channel;
 	unsigned long flags;
 
-	pr_debug("imxdma%d: imx_dma_enable\n", channel);
+	dev_dbg(imxdma->dev, "%s channel %d\n", __func__, channel);
 
 	local_irq_save(flags);
 
@@ -274,7 +274,7 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 	int channel = imxdmac->channel;
 	unsigned long flags;
 
-	pr_debug("imxdma%d: imx_dma_disable\n", channel);
+	dev_dbg(imxdma->dev,"%s channel %d\n", __func__, channel);
 
 	if (imxdma_hw_chain(imxdmac))
 		del_timer(&imxdmac->watchdog);
@@ -298,7 +298,8 @@ static void imxdma_watchdog(unsigned long data)
 
 	/* Tasklet watchdog error handler */
 	tasklet_schedule(&imxdmac->dma_tasklet);
-	pr_debug("imxdma%d: watchdog timeout!\n", imxdmac->channel);
+	dev_dbg(imxdma->dev, "channel %d: watchdog timeout!\n",
+		imxdmac->channel);
 }
 
 static irqreturn_t imxdma_err_handler(int irq, void *dev_id)
@@ -426,8 +427,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 	disr = imx_dmav1_readl(imxdma, DMA_DISR);
 
-	pr_debug("imxdma: dma_irq_handler called, disr=0x%08x\n",
-		     disr);
+	dev_dbg(imxdma->dev, "%s called, disr=0x%08x\n", __func__, disr);
 
 	imx_dmav1_writel(imxdma, disr, DMA_DISR);
 	for (i = 0; i < IMX_DMA_CHANNELS; i++) {
@@ -902,14 +902,14 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	if (cpu_is_mx1()) {
 		ret = request_irq(MX1_DMA_INT, dma_irq_handler, 0, "DMA", imxdma);
 		if (ret) {
-			pr_crit("Can't register IRQ for DMA\n");
+			dev_warn(imxdma->dev, "Can't register IRQ for DMA\n");
 			kfree(imxdma);
 			return ret;
 		}
 
 		ret = request_irq(MX1_DMA_ERR, imxdma_err_handler, 0, "DMA", imxdma);
 		if (ret) {
-			pr_crit("Can't register ERRIRQ for DMA\n");
+			dev_warn(imxdma->dev, "Can't register ERRIRQ for DMA\n");
 			free_irq(MX1_DMA_INT, NULL);
 			kfree(imxdma);
 			return ret;
@@ -939,8 +939,9 @@ static int __init imxdma_probe(struct platform_device *pdev)
 			ret = request_irq(MX2x_INT_DMACH0 + i,
 					dma_irq_handler, 0, "DMA", imxdma);
 			if (ret) {
-				pr_crit("Can't register IRQ %d for DMA channel %d\n",
-						MX2x_INT_DMACH0 + i, i);
+				dev_warn(imxdma->dev, "Can't register IRQ %d "
+					 "for DMA channel %d\n",
+					 MX2x_INT_DMACH0 + i, i);
 				goto err_init;
 			}
 			init_timer(&imxdmac->watchdog);
-- 
1.7.0.4

