Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2IRSYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:24:52 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55345 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2IRSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:24:36 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 5/7] spi: s3c64xx: Allow use with SPI ports without dma
Date: Tue, 18 Sep 2012 11:21:57 -0700
Message-Id: <1347992519-6904-6-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1347992519-6904-1-git-send-email-sjg@chromium.org>
References: <1347992519-6904-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ISP SPI ports appear not to support dma. Allow these to work
to some extent.

The current driver will not permit transfers larger than the FIFO
size, which is 256 bytes in the case of the ISP SPI ports, unless dma
is enabled.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/spi/spi-s3c64xx.c |   54 ++++++++++++++++++++++++++++----------------
 1 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index db79d87..ed12872 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -675,6 +675,7 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 	int status = 0, cs_toggle = 0;
 	u32 speed;
 	u8 bpw;
+	bool have_dma;
 
 	/* If Master's(controller) state differs from that needed by Slave */
 	if (sdd->cur_speed != spi->max_speed_hz
@@ -686,12 +687,14 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 		s3c64xx_spi_config(sdd);
 	}
 
+	have_dma = (sdd->rx_dma.direction != DMA_NONE);
+
 	/* Map all the transfers if needed */
-	if (s3c64xx_spi_map_mssg(sdd, msg)) {
+	if (have_dma && s3c64xx_spi_map_mssg(sdd, msg)) {
 		dev_err(&spi->dev,
 			"Xfer: Unable to map message buffers!\n");
 		status = -ENOMEM;
-		goto out;
+		goto out_nomap;
 	}
 
 	/* Configure feedback delay */
@@ -722,8 +725,12 @@ static int s3c64xx_spi_transfer_one_message(struct spi_master *master,
 			s3c64xx_spi_config(sdd);
 		}
 
-		/* Polling method for xfers not bigger than FIFO capacity */
-		if (xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1))
+		/*
+		 * Polling method if we have no DMA support and for xfers
+		 * not bigger than FIFO capacity
+		 */
+		if (xfer->len <= ((FIFO_LVL_MASK(sdd) >> 1) + 1) ||
+			sdd->rx_dma.direction == DMA_NONE)
 			use_dma = 0;
 		else
 			use_dma = 1;
@@ -794,8 +801,9 @@ out:
 	else
 		sdd->tgl_spi = spi;
 
-	s3c64xx_spi_unmap_mssg(sdd, msg);
-
+	if (have_dma)
+		s3c64xx_spi_unmap_mssg(sdd, msg);
+out_nomap:
 	msg->status = status;
 
 	spi_finalize_current_message(master);
@@ -807,9 +815,11 @@ static int s3c64xx_spi_prepare_transfer(struct spi_master *spi)
 {
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
-	/* Acquire DMA channels */
-	while (!acquire_dma(sdd))
-		msleep(10);
+	if (sdd->rx_dma.direction != DMA_NONE) {
+		/* Acquire DMA channels */
+		while (!acquire_dma(sdd))
+			msleep(10);
+	}
 
 	pm_runtime_get_sync(&sdd->pdev->dev);
 
@@ -820,9 +830,11 @@ static int s3c64xx_spi_unprepare_transfer(struct spi_master *spi)
 {
 	struct s3c64xx_spi_driver_data *sdd = spi_master_get_devdata(spi);
 
-	/* Free DMA channels */
-	sdd->ops->release(sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
-	sdd->ops->release(sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
+	if (sdd->rx_dma.direction != DMA_NONE) {
+		/* Free DMA channels */
+		sdd->ops->release(sdd->rx_dma.ch, &s3c64xx_spi_dma_client);
+		sdd->ops->release(sdd->tx_dma.ch, &s3c64xx_spi_dma_client);
+	}
 
 	pm_runtime_put(&sdd->pdev->dev);
 
@@ -1095,8 +1107,9 @@ static int __devinit s3c64xx_spi_get_dmares(
 	sprintf(prop_name, "%s-dma-channel", chan_str);
 	prop = of_find_property(pdev->dev.of_node, prop_name, NULL);
 	if (!prop) {
-		dev_err(&pdev->dev, "%s dma channel property not specified\n",
-					chan_str);
+		dma_data->direction = DMA_NONE;
+		dev_warn(&pdev->dev, "%s no dma channel property"
+			" - falling back to PIO\n", chan_str);
 		return -ENXIO;
 	}
 
@@ -1209,7 +1222,7 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 	struct s3c64xx_spi_driver_data *sdd;
 	struct s3c64xx_spi_info *sci = pdev->dev.platform_data;
 	struct spi_master *master;
-	int ret, irq;
+	int ret, irq, ret_tx;
 	char clk_name[16];
 
 	if (!sci && pdev->dev.of_node) {
@@ -1264,13 +1277,14 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 
 	sdd->cur_bpw = 8;
 
-	ret = s3c64xx_spi_get_dmares(sdd, true);
-	if (ret)
-		goto err0;
-
+	/* These may fail, in which case we fall back to PIO */
+	ret_tx = s3c64xx_spi_get_dmares(sdd, true);
 	ret = s3c64xx_spi_get_dmares(sdd, false);
-	if (ret)
+	if (!!ret_tx != !!ret) {
+		dev_err(&pdev->dev, "dma rx/tx channels must either both be"
+			"enabled or disabled\n");
 		goto err0;
+	}
 
 	master->dev.of_node = pdev->dev.of_node;
 	master->bus_num = sdd->port_id;
-- 
1.7.7.3

