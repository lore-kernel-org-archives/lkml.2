Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2CEQRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:17:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65482 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2CEQRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:17:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.180.95.1 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 07/14] dmaengine: imx-dma: remove sg member from internal structure.
Date: Mon,  5 Mar 2012 17:16:29 +0100
Message-Id: <1330964196-32623-8-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   42 ++++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index cb45aff..ed94207 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -128,7 +128,6 @@ enum  imxdma_prep_type {
  */
 
 struct imxdma_channel_internal {
-	struct scatterlist *sg;
 	unsigned int resbytes;
 
 	int in_use;
@@ -278,11 +277,11 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 		CCR_ACRPT, DMA_CCR(channel));
 
 	if ((cpu_is_mx21() || cpu_is_mx27()) &&
-			imxdmac->internal.sg && imxdma_hw_chain(&imxdmac->internal)) {
-		imxdmac->internal.sg = sg_next(imxdmac->internal.sg);
-		if (imxdmac->internal.sg) {
+			d->sg && imxdma_hw_chain(&imxdmac->internal)) {
+		d->sg = sg_next(d->sg);
+		if (d->sg) {
 			u32 tmp;
-			imxdma_sg_next(d, imxdmac->internal.sg);
+			imxdma_sg_next(d, d->sg);
 			tmp = imx_dmav1_readl(DMA_CCR(channel));
 			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
 				DMA_CCR(channel));
@@ -319,7 +318,6 @@ static void imxdma_watchdog(unsigned long data)
 
 	imx_dmav1_writel(0, DMA_CCR(channel));
 	imxdmac->internal.in_use = 0;
-	imxdmac->internal.sg = NULL;
 
 	/* Tasklet watchdog error handler */
 	tasklet_schedule(&imxdmac->dma_tasklet);
@@ -387,24 +385,23 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 	int chno = imxdmac->channel;
 	struct imxdma_desc *desc;
 
-	if (imxdma->sg) {
-		u32 tmp;
-		imxdma->sg = sg_next(imxdma->sg);
-
-		if (imxdma->sg) {
+	spin_lock(&imxdmac->lock);
+	if (list_empty(&imxdmac->ld_active)) {
+		spin_unlock(&imxdmac->lock);
+		goto out;
+	}
 
-			spin_lock(&imxdmac->lock);
-			if (list_empty(&imxdmac->ld_active)) {
-				spin_unlock(&imxdmac->lock);
-				goto out;
-			}
+	desc = list_first_entry(&imxdmac->ld_active,
+				struct imxdma_desc,
+				node);
+	spin_unlock(&imxdmac->lock);
 
-			desc = list_first_entry(&imxdmac->ld_active,
-						struct imxdma_desc,
-						node);
-			spin_unlock(&imxdmac->lock);
+	if (desc->sg) {
+		u32 tmp;
+		desc->sg = sg_next(desc->sg);
 
-			imxdma_sg_next(desc, imxdma->sg);
+		if (desc->sg) {
+			imxdma_sg_next(desc, desc->sg);
 
 			tmp = imx_dmav1_readl(DMA_CCR(chno));
 
@@ -478,8 +475,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Configure and enable */
 	switch (d->type) {
 	case IMXDMA_DESC_MEMCPY:
-		imxdmac->internal.sg = NULL;
-
 		imx_dmav1_writel(d->src, DMA_SAR(imxdmac->channel));
 		imx_dmav1_writel(d->dest, DMA_DAR(imxdmac->channel));
 		imx_dmav1_writel(d->config_mem | (d->config_port << 2),
@@ -495,7 +490,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
 	case IMXDMA_DESC_CYCLIC:
 	case IMXDMA_DESC_SLAVE_SG:
-		imxdmac->internal.sg = d->sg;
 		imxdmac->internal.resbytes = d->len;
 
 		if (d->direction == DMA_DEV_TO_MEM) {
-- 
1.7.0.4

