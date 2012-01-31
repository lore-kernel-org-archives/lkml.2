Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab2AaKr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:47:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44306 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2AaKr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:47:28 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, dan.j.williams@intel.com,
        s.hauer@pengutronix.de, vinod.koul@intel.com,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3] dmaengine: Add support for MEMCPY for imx-dma.
Date: Tue, 31 Jan 2012 11:47:20 +0100
Message-Id: <1328006840-7345-1-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MEMCPY transfers allow DMA copies from memory to
memory. This patch has been tested with dmatest
device driver.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 3296a73..9aa6e85 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -196,7 +196,8 @@ static int imxdma_alloc_chan_resources(struct dma_chan *chan)
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
 	struct imx_dma_data *data = chan->private;
 
-	imxdmac->dma_request = data->dma_request;
+	if (data != NULL)
+		imxdmac->dma_request = data->dma_request;
 
 	dma_async_tx_descriptor_init(&imxdmac->desc, chan);
 	imxdmac->desc.tx_submit = imxdma_tx_submit;
@@ -328,6 +329,36 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
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
+	if (imxdmac->status == DMA_IN_PROGRESS)
+		return NULL;
+	imxdmac->status = DMA_IN_PROGRESS;
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
+	return &imxdmac->desc;
+}
+
 static void imxdma_issue_pending(struct dma_chan *chan)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(chan);
@@ -349,6 +380,7 @@ static int __init imxdma_probe(struct platform_device *pdev)
 
 	dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
 	dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
+	dma_cap_set(DMA_MEMCPY, imxdma->dma_device.cap_mask);
 
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
@@ -382,11 +414,13 @@ static int __init imxdma_probe(struct platform_device *pdev)
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

