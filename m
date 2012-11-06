Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2KFJAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:00:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37540 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab2KFJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:00:46 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Reorder the wait_for_completion for tx
Date: Tue, 6 Nov 2012 14:30:19 +0530
Message-ID: <1352192419-22872-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit  d7b4394e[Cleanup the omap2_mcspi_txrx_dma function]
changed the wait_for_completion order. Move the wait so that the
rx doesnot wait for the tx to complete.

Reported-and-tested-by: Sørensen, Stefan <Sorensen@polycom.com>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |   39 +++++++++++++++++++--------------------
 1 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index bcfd062..251f6d0 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -323,18 +323,13 @@ static void omap2_mcspi_tx_dma(struct spi_device *spi,
 	struct omap2_mcspi	*mcspi;
 	struct omap2_mcspi_dma  *mcspi_dma;
 	unsigned int		count;
-	u8			* rx;
 	const u8		* tx;
-	void __iomem		*chstat_reg;
-	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
 	count = xfer->len;
 
-	rx = xfer->rx_buf;
 	tx = xfer->tx_buf;
-	chstat_reg = cs->base + OMAP2_MCSPI_CHSTAT0;
 
 	if (mcspi_dma->dma_tx) {
 		struct dma_async_tx_descriptor *tx;
@@ -359,19 +354,6 @@ static void omap2_mcspi_tx_dma(struct spi_device *spi,
 	dma_async_issue_pending(mcspi_dma->dma_tx);
 	omap2_mcspi_set_dma_req(spi, 0, 1);
 
-	wait_for_completion(&mcspi_dma->dma_tx_completion);
-	dma_unmap_single(mcspi->dev, xfer->tx_dma, count,
-			 DMA_TO_DEVICE);
-
-	/* for TX_ONLY mode, be sure all words have shifted out */
-	if (rx == NULL) {
-		if (mcspi_wait_for_reg_bit(chstat_reg,
-					OMAP2_MCSPI_CHSTAT_TXS) < 0)
-			dev_err(&spi->dev, "TXS timed out\n");
-		else if (mcspi_wait_for_reg_bit(chstat_reg,
-					OMAP2_MCSPI_CHSTAT_EOT) < 0)
-			dev_err(&spi->dev, "EOT timed out\n");
-	}
 }
 
 static unsigned
@@ -492,6 +474,7 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 	struct dma_slave_config	cfg;
 	enum dma_slave_buswidth width;
 	unsigned es;
+	void __iomem		*chstat_reg;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
@@ -526,8 +509,24 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		omap2_mcspi_tx_dma(spi, xfer, cfg);
 
 	if (rx != NULL)
-		return omap2_mcspi_rx_dma(spi, xfer, cfg, es);
-
+		count = omap2_mcspi_rx_dma(spi, xfer, cfg, es);
+
+	if (tx != NULL) {
+		chstat_reg = cs->base + OMAP2_MCSPI_CHSTAT0;
+		wait_for_completion(&mcspi_dma->dma_tx_completion);
+		dma_unmap_single(mcspi->dev, xfer->tx_dma, xfer->len,
+				 DMA_TO_DEVICE);
+
+		/* for TX_ONLY mode, be sure all words have shifted out */
+		if (rx == NULL) {
+			if (mcspi_wait_for_reg_bit(chstat_reg,
+						OMAP2_MCSPI_CHSTAT_TXS) < 0)
+				dev_err(&spi->dev, "TXS timed out\n");
+			else if (mcspi_wait_for_reg_bit(chstat_reg,
+						OMAP2_MCSPI_CHSTAT_EOT) < 0)
+				dev_err(&spi->dev, "EOT timed out\n");
+		}
+	}
 	return count;
 }
 
-- 
1.7.5.4

