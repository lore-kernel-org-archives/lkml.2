Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2ABMTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:19:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:46023 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2ABMSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:18:42 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: dan.j.williams@intel.com, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, vinod.koul@intel.com,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] [v2] dmaengine: Add support for MEMCPY for imx-dma.
Date: Mon,  2 Jan 2012 13:18:26 +0100
Message-Id: <1325506706-10028-2-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
References: <1325506706-10028-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEMCPY transfers allow DMA copies from memory to
memory. This patch has been tested with dmatest
device driver.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 9a0ac14..8e6d680 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -201,7 +201,8 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imx_dma_data *data = chan->private;
 
-	imxdmac->dma_request = data->dma_request;
+	if (data != NULL)
+		imxdmac->dma_request = data->dma_request;
 
 	dma_async_tx_descriptor_init(&imxdmac->desc, chan);
 	imxdmac->desc.tx_submit = imxdma_tx_submit;
@@ -334,6 +335,37 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
 	return &imxdmac->desc;
 }
 
+static struct dma_async_tx_descriptor *imxdma_prep_dma_memcpy(
+	struct dma_chan *chan, dma_addr_t dest,
+	dma_addr_t src, size_t len, unsigned long flags)
+{
+	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
+	struct imxdma_engine *imxdma = imxdmac->imxdma;
+	int ret;
+
+	dev_dbg(imxdma->dev, "%s channel: %d src=0x%x dst=0x%x len=%d\n",
+			__func__, imxdmac->channel, src, dest, len);
+
+	if (imxdmac->prepared)
+		return NULL;
+
+	ret = imx_dma_config_channel(imxdmac->imxdma_channel,
+			       IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
+			       IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
+			       0, 0);
+	if (ret)
+		return NULL;
+
+	ret = imx_dma_setup_single(imxdmac->imxdma_channel, src, len,
+				   dest, DMA_MODE_WRITE);
+	if (ret)
+		return NULL;
+
+	imxdmac->prepared = true;
+
+	return &imxdmac->desc;
+}
+
 static void imxdma_issue_pending(struct dma_chan *chan)
 {
 	/*
@@ -356,6 +388,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 
 	dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
 	dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
+	dma_cap_set(DMA_MEMCPY, imxdma->dma_device.cap_mask);
 
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
@@ -389,11 +422,13 @@ static int __init imxdma_probe(struct platform_device *pdev)
 	imxdma->dma_device.device_tx_status = imxdma_tx_status;
 	imxdma->dma_device.device_prep_slave_sg = imxdma_prep_slave_sg;
 	imxdma->dma_device.device_prep_dma_cyclic = imxdma_prep_dma_cyclic;
+	imxdma->dma_device.device_prep_dma_memcpy = imxdma_prep_dma_memcpy;
 	imxdma->dma_device.device_control = imxdma_control;
 	imxdma->dma_device.device_issue_pending = imxdma_issue_pending;
 
 	platform_set_drvdata(pdev, imxdma);
 
+	imxdma->dma_device.copy_align = 2; /* 2^2 = 4 bytes alignment */
 	imxdma->dma_device.dev->dma_parms = &imxdma->dma_parms;
 	dma_set_max_seg_size(imxdma->dma_device.dev, 0xffffff);
 
-- 
1.7.0.4

