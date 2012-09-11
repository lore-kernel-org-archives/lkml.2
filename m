Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2IKGno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:43:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40052 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab2IKGnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:43:42 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <spi-devel-general@lists.sourceforge.net>
CC: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH] spi: omap2-mcspi: Cleanup the omap2_mcspi_txrx_dma function
Date: Tue, 11 Sep 2012 12:13:20 +0530
Message-ID: <1347345800-4116-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in omap2_mcspi_txrx_dma the tx and the rx support is
interleaved. Make the rx related code in omap2_mcspi_rx_dma
and the tx related code omap2_mcspi_tx_dma and call the functions.

While at it remove the braces in the if statements which has only
one line.
Also fix ["foo * bar" to "foo *bar"] warn for the rx and tx variables.

Only a cleanup no functional change.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/spi/spi-omap2-mcspi.c |  256 +++++++++++++++++++++++------------------
 1 files changed, 144 insertions(+), 112 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 1c1dd34..dd8fc88 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -315,49 +315,27 @@ static void omap2_mcspi_tx_callback(void *data)
 	omap2_mcspi_set_dma_req(spi, 0, 0);
 }
 
-static unsigned
-omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
+static void omap2_mcspi_tx_dma(struct spi_device *spi,
+				struct spi_transfer *xfer,
+				struct dma_slave_config cfg)
 {
 	struct omap2_mcspi	*mcspi;
-	struct omap2_mcspi_cs	*cs = spi->controller_state;
 	struct omap2_mcspi_dma  *mcspi_dma;
 	unsigned int		count;
-	int			word_len, element_count;
-	int			elements = 0;
-	u32			l;
 	u8			* rx;
 	const u8		* tx;
 	void __iomem		*chstat_reg;
-	struct dma_slave_config	cfg;
-	enum dma_slave_buswidth width;
-	unsigned es;
+	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
 	mcspi = spi_master_get_devdata(spi->master);
 	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
-	l = mcspi_cached_chconf0(spi);
+	count = xfer->len;
 
+	rx = xfer->rx_buf;
+	tx = xfer->tx_buf;
 	chstat_reg = cs->base + OMAP2_MCSPI_CHSTAT0;
 
-	if (cs->word_len <= 8) {
-		width = DMA_SLAVE_BUSWIDTH_1_BYTE;
-		es = 1;
-	} else if (cs->word_len <= 16) {
-		width = DMA_SLAVE_BUSWIDTH_2_BYTES;
-		es = 2;
-	} else {
-		width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-		es = 4;
-	}
-
-	memset(&cfg, 0, sizeof(cfg));
-	cfg.src_addr = cs->phys + OMAP2_MCSPI_RX0;
-	cfg.dst_addr = cs->phys + OMAP2_MCSPI_TX0;
-	cfg.src_addr_width = width;
-	cfg.dst_addr_width = width;
-	cfg.src_maxburst = 1;
-	cfg.dst_maxburst = 1;
-
-	if (xfer->tx_buf && mcspi_dma->dma_tx) {
+	if (mcspi_dma->dma_tx) {
 		struct dma_async_tx_descriptor *tx;
 		struct scatterlist sg;
 
@@ -368,7 +346,7 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		sg_dma_len(&sg) = xfer->len;
 
 		tx = dmaengine_prep_slave_sg(mcspi_dma->dma_tx, &sg, 1,
-			DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 		if (tx) {
 			tx->callback = omap2_mcspi_tx_callback;
 			tx->callback_param = spi;
@@ -377,8 +355,50 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 			/* FIXME: fall back to PIO? */
 		}
 	}
+	dma_async_issue_pending(mcspi_dma->dma_tx);
+	omap2_mcspi_set_dma_req(spi, 0, 1);
 
-	if (xfer->rx_buf && mcspi_dma->dma_rx) {
+	wait_for_completion(&mcspi_dma->dma_tx_completion);
+	dma_unmap_single(mcspi->dev, xfer->tx_dma, count,
+			 DMA_TO_DEVICE);
+
+	/* for TX_ONLY mode, be sure all words have shifted out */
+	if (rx == NULL) {
+		if (mcspi_wait_for_reg_bit(chstat_reg,
+					OMAP2_MCSPI_CHSTAT_TXS) < 0)
+			dev_err(&spi->dev, "TXS timed out\n");
+		else if (mcspi_wait_for_reg_bit(chstat_reg,
+					OMAP2_MCSPI_CHSTAT_EOT) < 0)
+			dev_err(&spi->dev, "EOT timed out\n");
+	}
+}
+
+static unsigned
+omap2_mcspi_rx_dma(struct spi_device *spi, struct spi_transfer *xfer,
+				struct dma_slave_config cfg,
+				unsigned es)
+{
+	struct omap2_mcspi	*mcspi;
+	struct omap2_mcspi_dma  *mcspi_dma;
+	unsigned int		count;
+	u32			l;
+	int			elements = 0;
+	int			word_len, element_count;
+	struct omap2_mcspi_cs	*cs = spi->controller_state;
+	mcspi = spi_master_get_devdata(spi->master);
+	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	count = xfer->len;
+	word_len = cs->word_len;
+	l = mcspi_cached_chconf0(spi);
+
+	if (word_len <= 8)
+		element_count = count;
+	else if (word_len <= 16)
+		element_count = count >> 1;
+	else /* word_len <= 32 */
+		element_count = count >> 2;
+
+	if (mcspi_dma->dma_rx) {
 		struct dma_async_tx_descriptor *tx;
 		struct scatterlist sg;
 		size_t len = xfer->len - es;
@@ -393,108 +413,120 @@ omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
 		sg_dma_len(&sg) = len;
 
 		tx = dmaengine_prep_slave_sg(mcspi_dma->dma_rx, &sg, 1,
-			DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+				DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT |
+				DMA_CTRL_ACK);
 		if (tx) {
 			tx->callback = omap2_mcspi_rx_callback;
 			tx->callback_param = spi;
 			dmaengine_submit(tx);
 		} else {
-			/* FIXME: fall back to PIO? */
-		}
-	}
-
-	count = xfer->len;
-	word_len = cs->word_len;
-
-	rx = xfer->rx_buf;
-	tx = xfer->tx_buf;
-
-	if (word_len <= 8) {
-		element_count = count;
-	} else if (word_len <= 16) {
-		element_count = count >> 1;
-	} else /* word_len <= 32 */ {
-		element_count = count >> 2;
-	}
-
-	if (tx != NULL) {
-		dma_async_issue_pending(mcspi_dma->dma_tx);
-		omap2_mcspi_set_dma_req(spi, 0, 1);
-	}
-
-	if (rx != NULL) {
-		dma_async_issue_pending(mcspi_dma->dma_rx);
-		omap2_mcspi_set_dma_req(spi, 1, 1);
-	}
-
-	if (tx != NULL) {
-		wait_for_completion(&mcspi_dma->dma_tx_completion);
-		dma_unmap_single(mcspi->dev, xfer->tx_dma, count,
-				 DMA_TO_DEVICE);
-
-		/* for TX_ONLY mode, be sure all words have shifted out */
-		if (rx == NULL) {
-			if (mcspi_wait_for_reg_bit(chstat_reg,
-						OMAP2_MCSPI_CHSTAT_TXS) < 0)
-				dev_err(&spi->dev, "TXS timed out\n");
-			else if (mcspi_wait_for_reg_bit(chstat_reg,
-						OMAP2_MCSPI_CHSTAT_EOT) < 0)
-				dev_err(&spi->dev, "EOT timed out\n");
+				/* FIXME: fall back to PIO? */
 		}
 	}
 
-	if (rx != NULL) {
-		wait_for_completion(&mcspi_dma->dma_rx_completion);
-		dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
-				 DMA_FROM_DEVICE);
-		omap2_mcspi_set_enable(spi, 0);
+	dma_async_issue_pending(mcspi_dma->dma_rx);
+	omap2_mcspi_set_dma_req(spi, 1, 1);
 
-		elements = element_count - 1;
+	wait_for_completion(&mcspi_dma->dma_rx_completion);
+	dma_unmap_single(mcspi->dev, xfer->rx_dma, count,
+			 DMA_FROM_DEVICE);
+	omap2_mcspi_set_enable(spi, 0);
 
-		if (l & OMAP2_MCSPI_CHCONF_TURBO) {
-			elements--;
+	elements = element_count - 1;
 
-			if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
-				   & OMAP2_MCSPI_CHSTAT_RXS)) {
-				u32 w;
-
-				w = mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
-				if (word_len <= 8)
-					((u8 *)xfer->rx_buf)[elements++] = w;
-				else if (word_len <= 16)
-					((u16 *)xfer->rx_buf)[elements++] = w;
-				else /* word_len <= 32 */
-					((u32 *)xfer->rx_buf)[elements++] = w;
-			} else {
-				dev_err(&spi->dev,
-					"DMA RX penultimate word empty");
-				count -= (word_len <= 8)  ? 2 :
-					(word_len <= 16) ? 4 :
-					/* word_len <= 32 */ 8;
-				omap2_mcspi_set_enable(spi, 1);
-				return count;
-			}
-		}
+	if (l & OMAP2_MCSPI_CHCONF_TURBO) {
+		elements--;
 
 		if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
-				& OMAP2_MCSPI_CHSTAT_RXS)) {
+				   & OMAP2_MCSPI_CHSTAT_RXS)) {
 			u32 w;
 
 			w = mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
 			if (word_len <= 8)
-				((u8 *)xfer->rx_buf)[elements] = w;
+				((u8 *)xfer->rx_buf)[elements++] = w;
 			else if (word_len <= 16)
-				((u16 *)xfer->rx_buf)[elements] = w;
+				((u16 *)xfer->rx_buf)[elements++] = w;
 			else /* word_len <= 32 */
-				((u32 *)xfer->rx_buf)[elements] = w;
+				((u32 *)xfer->rx_buf)[elements++] = w;
 		} else {
-			dev_err(&spi->dev, "DMA RX last word empty");
-			count -= (word_len <= 8)  ? 1 :
-				 (word_len <= 16) ? 2 :
-			       /* word_len <= 32 */ 4;
+			dev_err(&spi->dev, "DMA RX penultimate word empty");
+			count -= (word_len <= 8)  ? 2 :
+				(word_len <= 16) ? 4 :
+				/* word_len <= 32 */ 8;
+			omap2_mcspi_set_enable(spi, 1);
+			return count;
 		}
-		omap2_mcspi_set_enable(spi, 1);
 	}
+	if (likely(mcspi_read_cs_reg(spi, OMAP2_MCSPI_CHSTAT0)
+				& OMAP2_MCSPI_CHSTAT_RXS)) {
+		u32 w;
+
+		w = mcspi_read_cs_reg(spi, OMAP2_MCSPI_RX0);
+		if (word_len <= 8)
+			((u8 *)xfer->rx_buf)[elements] = w;
+		else if (word_len <= 16)
+			((u16 *)xfer->rx_buf)[elements] = w;
+		else /* word_len <= 32 */
+			((u32 *)xfer->rx_buf)[elements] = w;
+	} else {
+		dev_err(&spi->dev, "DMA RX last word empty");
+		count -= (word_len <= 8)  ? 1 :
+			 (word_len <= 16) ? 2 :
+		       /* word_len <= 32 */ 4;
+	}
+	omap2_mcspi_set_enable(spi, 1);
+	return count;
+}
+
+static unsigned
+omap2_mcspi_txrx_dma(struct spi_device *spi, struct spi_transfer *xfer)
+{
+	struct omap2_mcspi	*mcspi;
+	struct omap2_mcspi_cs	*cs = spi->controller_state;
+	struct omap2_mcspi_dma  *mcspi_dma;
+	unsigned int		count;
+	u32			l;
+	u8			*rx;
+	const u8		*tx;
+	struct dma_slave_config	cfg;
+	enum dma_slave_buswidth width;
+	unsigned es;
+
+	mcspi = spi_master_get_devdata(spi->master);
+	mcspi_dma = &mcspi->dma_channels[spi->chip_select];
+	l = mcspi_cached_chconf0(spi);
+
+
+	if (cs->word_len <= 8) {
+		width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		es = 1;
+	} else if (cs->word_len <= 16) {
+		width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		es = 2;
+	} else {
+		width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		es = 4;
+	}
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.src_addr = cs->phys + OMAP2_MCSPI_RX0;
+	cfg.dst_addr = cs->phys + OMAP2_MCSPI_TX0;
+	cfg.src_addr_width = width;
+	cfg.dst_addr_width = width;
+	cfg.src_maxburst = 1;
+	cfg.dst_maxburst = 1;
+
+	rx = xfer->rx_buf;
+	tx = xfer->tx_buf;
+
+	count = xfer->len;
+
+	if (tx != NULL)
+		omap2_mcspi_tx_dma(spi, xfer, cfg);
+
+	if (rx != NULL)
+		return omap2_mcspi_rx_dma(spi, xfer, cfg, es);
+
 	return count;
 }
 
-- 
1.7.5.4

