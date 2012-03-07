Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073Ab2CGOf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:35:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41988 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921Ab2CGOeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:16 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 08/13] dmaengine: imx-dma: remove 'in_use' field of 'internal' structure.
Date: Wed,  7 Mar 2012 15:33:40 +0100
Message-Id: <1331130825-14947-9-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes no sense keeping an 'in_use' flag when the multiple descriptor
mechanism already prevents a new DMA transfer to be issued when another
one is in course.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index ed94207..1e66ee6 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -130,8 +130,6 @@ enum  imxdma_prep_type {
 struct imxdma_channel_internal {
 	unsigned int resbytes;
 
-	int in_use;
-
 	struct timer_list watchdog;
 
 	int hw_chaining;
@@ -266,9 +264,6 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 
 	pr_debug("imxdma%d: imx_dma_enable\n", channel);
 
-	if (imxdmac->internal.in_use)
-		return;
-
 	local_irq_save(flags);
 
 	imx_dmav1_writel(1 << channel, DMA_DISR);
@@ -287,7 +282,6 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 				DMA_CCR(channel));
 		}
 	}
-	imxdmac->internal.in_use = 1;
 
 	local_irq_restore(flags);
 }
@@ -307,7 +301,6 @@ static void imxdma_disable_hw(struct imxdma_channel *imxdmac)
 	imx_dmav1_writel(imx_dmav1_readl(DMA_CCR(channel)) & ~CCR_CEN,
 			DMA_CCR(channel));
 	imx_dmav1_writel(1 << channel, DMA_DISR);
-	imxdmac->internal.in_use = 0;
 	local_irq_restore(flags);
 }
 
@@ -317,7 +310,6 @@ static void imxdma_watchdog(unsigned long data)
 	int channel = imxdmac->channel;
 
 	imx_dmav1_writel(0, DMA_CCR(channel));
-	imxdmac->internal.in_use = 0;
 
 	/* Tasklet watchdog error handler */
 	tasklet_schedule(&imxdmac->dma_tasklet);
@@ -436,7 +428,6 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 
 out:
 	imx_dmav1_writel(0, DMA_CCR(chno));
-	imxdma->in_use = 0;
 	/* Tasklet irq */
 	tasklet_schedule(&imxdmac->dma_tasklet);
 }
@@ -470,7 +461,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
 	struct imxdma_engine *imxdma = imxdmac->imxdma;
-	int ret;
 
 	/* Configure and enable */
 	switch (d->type) {
-- 
1.7.0.4

