Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2LDH7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:59:35 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:13719 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2LDH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:59:32 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v2 PATCH 09/14] spi/atmel_spi: Fix spi-atmel driver to adapt to slave_config changes
Date: Tue,  4 Dec 2012 15:53:55 +0800
Message-Id: <1354607640-13229-10-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:59:11.0280 (UTC) FILETIME=[3EB42B00:01CDD1F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

This is the following of the patch e2b35f3dbfc080f15b72834d08f04f0269dbe9be

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: fix DMA: when enable both spi0 and spi1, spi0 doesn't work]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |   60 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 1de45c2..7f624b6 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -438,6 +438,37 @@ static inline int atmel_spi_xfer_can_be_chained(struct spi_transfer *xfer)
 	return xfer->delay_usecs == 0 && !xfer->cs_change;
 }
 
+static int atmel_spi_dma_slave_config(struct atmel_spi *as,
+				struct dma_slave_config *slave_config)
+{
+	int err = 0;
+
+	slave_config->dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+	slave_config->src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+
+	slave_config->dst_addr = (dma_addr_t)as->phybase + SPI_TDR;
+	slave_config->src_addr = (dma_addr_t)as->phybase + SPI_RDR;
+	slave_config->src_maxburst = 1;
+	slave_config->dst_maxburst = 1;
+	slave_config->device_fc = false;
+
+	slave_config->direction = DMA_MEM_TO_DEV;
+	if (dmaengine_slave_config(as->dma.chan_tx, slave_config)) {
+		dev_err(&as->pdev->dev,
+			"failed to configure tx dma channel\n");
+		err = -EINVAL;
+	}
+
+	slave_config->direction = DMA_DEV_TO_MEM;
+	if (dmaengine_slave_config(as->dma.chan_rx, slave_config)) {
+		dev_err(&as->pdev->dev,
+			"failed to configure rx dma channel\n");
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
 static bool filter(struct dma_chan *chan, void *slave)
 {
 	struct	at_dma_slave *sl = slave;
@@ -454,14 +485,12 @@ static int __devinit atmel_spi_configure_dma(struct atmel_spi *as)
 {
 	struct at_dma_slave *sdata
 			= (struct at_dma_slave *)&as->pdata->dma_slave;
+	struct dma_slave_config	slave_config;
+	int err;
 
 	if (sdata && sdata->dma_dev) {
 		dma_cap_mask_t mask;
 
-		/* setup DMA addresses */
-		sdata->rx_reg = (dma_addr_t)as->phybase + SPI_RDR;
-		sdata->tx_reg = (dma_addr_t)as->phybase + SPI_TDR;
-
 		/* Try to grab two DMA channels */
 		dma_cap_zero(mask);
 		dma_cap_set(DMA_SLAVE, mask);
@@ -471,21 +500,28 @@ static int __devinit atmel_spi_configure_dma(struct atmel_spi *as)
 				dma_request_channel(mask, filter, sdata);
 	}
 	if (!as->dma.chan_rx || !as->dma.chan_tx) {
-		if (as->dma.chan_rx)
-			dma_release_channel(as->dma.chan_rx);
-		if (as->dma.chan_tx)
-			dma_release_channel(as->dma.chan_tx);
 		dev_err(&as->pdev->dev, "DMA channel not available, " \
 					"unable to use SPI\n");
-		return -EBUSY;
+		err = -EBUSY;
+		goto error;
 	}
 
+	err = atmel_spi_dma_slave_config(as, &slave_config);
+	if (err)
+		goto error;
+
 	dev_info(&as->pdev->dev, "Using %s (tx) and " \
 				" %s (rx) for DMA transfers\n",
 				dma_chan_name(as->dma.chan_tx),
 				dma_chan_name(as->dma.chan_rx));
 
 	return 0;
+error:
+	if (as->dma.chan_rx)
+		dma_release_channel(as->dma.chan_rx);
+	if (as->dma.chan_tx)
+		dma_release_channel(as->dma.chan_tx);
+	return err;
 }
 
 static void atmel_spi_stop_dma(struct atmel_spi *as)
@@ -562,6 +598,7 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 	struct dma_chan		*txchan = as->dma.chan_tx;
 	struct dma_async_tx_descriptor *rxdesc;
 	struct dma_async_tx_descriptor *txdesc;
+	struct dma_slave_config	slave_config;
 	dma_cookie_t		cookie;
 	u32	len = *plen;
 
@@ -600,6 +637,10 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 
 	*plen = len;
 
+	if (atmel_spi_dma_slave_config(as, &slave_config))
+		goto err_exit;
+
+
 	/* Send both scatterlists */
 	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
 					&as->dma.sgrx,
@@ -648,6 +689,7 @@ static int atmel_spi_next_xfer_dma_submit(struct spi_master *master,
 err_dma:
 	spi_writel(as, IDR, SPI_BIT(OVRES));
 	atmel_spi_stop_dma(as);
+err_exit:
 	atmel_spi_lock(as);
 	return -ENOMEM;
 }
-- 
1.7.9.5

