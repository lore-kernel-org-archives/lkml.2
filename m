Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964799Ab2CGOf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 09:35:26 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758752Ab2CGOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 09:34:18 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 09/13] dmaengine: imx-dma: remove 'resbytes' field of 'internal' structure.
Date: Wed,  7 Mar 2012 15:33:41 +0100
Message-Id: <1331130825-14947-10-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use per-descriptor 'len' field to keep track of the remaining bytes
instead. This goes on the direction of eventually removing the
'internal' structure.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 1e66ee6..d525f1e 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -128,8 +128,6 @@ enum  imxdma_prep_type {
  */
 
 struct imxdma_channel_internal {
-	unsigned int resbytes;
-
 	struct timer_list watchdog;
 
 	int hw_chaining;
@@ -233,12 +231,11 @@ static int imxdma_hw_chain(struct imxdma_channel_internal *imxdma)
 static inline int imxdma_sg_next(struct imxdma_desc *d, struct scatterlist *sg)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
-	struct imxdma_channel_internal *imxdma = &imxdmac->internal;
 	unsigned long now;
 
-	now = min(imxdma->resbytes, sg->length);
-	if (imxdma->resbytes != IMX_DMA_LENGTH_LOOP)
-		imxdma->resbytes -= now;
+	now = min(d->len, sg->length);
+	if (d->len != IMX_DMA_LENGTH_LOOP)
+		d->len -= now;
 
 	if (d->direction == DMA_DEV_TO_MEM)
 		imx_dmav1_writel(sg->dma_address, DMA_DAR(imxdmac->channel));
@@ -480,8 +477,6 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 	/* Cyclic transfer is the same as slave_sg with special sg configuration. */
 	case IMXDMA_DESC_CYCLIC:
 	case IMXDMA_DESC_SLAVE_SG:
-		imxdmac->internal.resbytes = d->len;
-
 		if (d->direction == DMA_DEV_TO_MEM) {
 			imx_dmav1_writel(imxdmac->per_address,
 					 DMA_SAR(imxdmac->channel));
-- 
1.7.0.4

