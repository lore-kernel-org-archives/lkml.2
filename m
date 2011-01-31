Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1AaMAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:00:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53494 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab1AaL7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:59:40 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 5/5] dmaengine i.MX SDMA: reserve channel 0 by not registering it
Date: Mon, 31 Jan 2011 12:59:32 +0100
Message-Id: <1296475172-23900-6-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296475172-23900-1-git-send-email-s.hauer@pengutronix.de>
References: <1296475172-23900-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need channel 0 of the sdma engine for internal purposes. We
accomplished this by calling dma_request_channel() in the probe
function. This does not work when multiple dma engines are
present which is the case when IPU support for i.MX31/35 is
compiled in. So instead of registering channel 0 and reserving
it afterwards simply do not register it in the first place.
With this the dmaengine channel counting does not match sdma
channel counting anymore, so we have to use sdma channel counting
in the driver.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index eb25068..1eb3f00 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -230,7 +230,7 @@ struct sdma_engine;
  * struct sdma_channel - housekeeping for a SDMA channel
  *
  * @sdma		pointer to the SDMA engine for this channel
- * @channel		the channel number, matches dmaengine chan_id
+ * @channel		the channel number, matches dmaengine chan_id + 1
  * @direction		transfer type. Needed for setting SDMA script
  * @peripheral_type	Peripheral type. Needed for setting SDMA script
  * @event_id0		aka dma request line
@@ -799,7 +799,7 @@ static dma_cookie_t sdma_tx_submit(struct dma_async_tx_descriptor *tx)
 
 	cookie = sdma_assign_cookie(sdmac);
 
-	sdma_enable_channel(sdma, tx->chan->chan_id);
+	sdma_enable_channel(sdma, sdmac->channel);
 
 	spin_unlock_irq(&sdmac->lock);
 
@@ -812,10 +812,6 @@ static int sdma_alloc_chan_resources(struct dma_chan *chan)
 	struct imx_dma_data *data = chan->private;
 	int prio, ret;
 
-	/* No need to execute this for internal channel 0 */
-	if (chan->chan_id == 0)
-		return 0;
-
 	if (!data)
 		return -EINVAL;
 
@@ -880,7 +876,7 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
 	int ret, i, count;
-	int channel = chan->chan_id;
+	int channel = sdmac->channel;
 	struct scatterlist *sg;
 
 	if (sdmac->status == DMA_IN_PROGRESS)
@@ -978,7 +974,7 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 	struct sdma_channel *sdmac = to_sdma_chan(chan);
 	struct sdma_engine *sdma = sdmac->sdma;
 	int num_periods = buf_len / period_len;
-	int channel = chan->chan_id;
+	int channel = sdmac->channel;
 	int ret, i = 0, buf = 0;
 
 	dev_dbg(sdma->dev, "%s channel: %d\n", __func__, channel);
@@ -1252,7 +1248,6 @@ static int __init sdma_probe(struct platform_device *pdev)
 	struct resource *iores;
 	struct sdma_platform_data *pdata = pdev->dev.platform_data;
 	int i;
-	dma_cap_mask_t mask;
 	struct sdma_engine *sdma;
 
 	sdma = kzalloc(sizeof(*sdma), GFP_KERNEL);
@@ -1309,8 +1304,14 @@ static int __init sdma_probe(struct platform_device *pdev)
 		sdmac->chan.device = &sdma->dma_device;
 		sdmac->channel = i;
 
-		/* Add the channel to the DMAC list */
-		list_add_tail(&sdmac->chan.device_node, &sdma->dma_device.channels);
+		/*
+		 * Add the channel to the DMAC list. Do not add channel 0 though
+		 * because we need it internally in the SDMA driver. This also means
+		 * that channel 0 in dmaengine counting matches sdma channel 1.
+		 */
+		if (i)
+			list_add_tail(&sdmac->chan.device_node,
+					&sdma->dma_device.channels);
 	}
 
 	ret = sdma_init(sdma);
@@ -1340,13 +1341,6 @@ static int __init sdma_probe(struct platform_device *pdev)
 		goto err_init;
 	}
 
-	/* request channel 0. This is an internal control channel
-	 * to the SDMA engine and not available to clients.
-	 */
-	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
-	dma_request_channel(mask, NULL, NULL);
-
 	dev_info(sdma->dev, "initialized\n");
 
 	return 0;
-- 
1.7.2.3

