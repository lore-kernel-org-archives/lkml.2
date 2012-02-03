Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab2BCQL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:11:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40529 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2BCQL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:11:26 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, vinod.koul@intel.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] dmaengine: i.MX: Add support for interleaved transfers.
Date: Fri,  3 Feb 2012 17:11:14 +0100
Message-Id: <1328285474-26365-2-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1328285474-26365-1-git-send-email-javier.martin@vista-silicon.com>
References: <1328285474-26365-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX2 and i.MX1 chips have the possibility to do
interleaved transfers with one constraint: only one
chunk can be used (i.e. only 2D transfers are allowed).

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 9aa6e85..366a248 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -359,6 +359,57 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
 	return &imxdmac->desc;
 }
 
+static struct dma_async_tx_descriptor *imxdma_prep_dma_interleaved(
+	struct dma_chan *chan, struct dma_interleaved_template *xt,
+	unsigned long flags)
+{
+	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	unsigned int src_config, dst_config;
+	unsigned int x, y, w;
+	int ret;
+
+	dev_dbg(imxdma->dev, "%s channel: %d src_start=0x%x dst_start=0x%x\n"
+		"   src_sgl=%s dst_sgl=%s numf=%d frame_size=%d\n", __func__,
+		imxdmac->channel, xt->src_start, xt->dst_start,
+		xt->src_sgl ? "true" : "false", xt->dst_sgl ? "true" : "false",
+		xt->numf, xt->frame_size);
+
+	if (imxdmac->status == DMA_IN_PROGRESS)
+		return NULL;
+	imxdmac->status = DMA_IN_PROGRESS;
+
+
+	if (xt->frame_size != 1 || xt->numf <= 0 || xt->dir != DMA_MEM_TO_MEM)
+		return NULL;
+
+	y = xt->numf;
+	x = xt->sgl[0].size;
+	w = xt->sgl[0].icg + x;
+	ret = imx_dma_config_2d(imxdmac->imxdma_channel, x, y, w);
+	if (ret)
+		return NULL;
+
+	src_config = IMX_DMA_MEMSIZE_32;
+	dst_config = IMX_DMA_MEMSIZE_32;
+	if (xt->src_sgl)
+		src_config |= IMX_DMA_TYPE_2D;
+	if (xt->dst_sgl)
+		dst_config |= IMX_DMA_TYPE_2D;
+
+	ret = imx_dma_config_channel(imxdmac->imxdma_channel,
+				     dst_config, src_config, 0, 0);
+	if (ret)
+		return NULL;
+
+	ret = imx_dma_setup_single(imxdmac->imxdma_channel, xt->src_start,
+				   x * y, xt->dst_start, DMA_MODE_WRITE);
+	if (ret)
+		return NULL;
+
+	return &imxdmac->desc;
+}
+
 static void imxdma_issue_pending(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
@@ -381,6 +432,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
 	dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
 	dma_cap_set(DMA_MEMCPY, imxdma->dma_device.cap_mask);
+	dma_cap_set(DMA_INTERLEAVE, imxdma->dma_device.cap_mask);
 
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
@@ -415,6 +467,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	imxdma->dma_device.device_prep_slave_sg = imxdma_prep_slave_sg;
 	imxdma->dma_device.device_prep_dma_cyclic = imxdma_prep_dma_cyclic;
 	imxdma->dma_device.device_prep_dma_memcpy = imxdma_prep_dma_memcpy;
+	imxdma->dma_device.device_prep_interleaved_dma = imxdma_prep_dma_interleaved;
 	imxdma->dma_device.device_control = imxdma_control;
 	imxdma->dma_device.device_issue_pending = imxdma_issue_pending;
 
-- 
1.7.0.4

