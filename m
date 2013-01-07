Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3AGKnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:43:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:26455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647Ab3AGKlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="273733533"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 06/11] spi/pxa2xx: use the private DMA API only when CONFIG_ARCH_PXA is set
Date: Mon,  7 Jan 2013 12:44:35 +0200
Message-Id: <1357555480-24022-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PXA SPI driver uses PXA platform specific private DMA implementation
which does not work on non-PXA platforms. In order to use this driver on
other platforms we need to move the private DMA implementation into a
separate functions that get stubbed out when !CONFIG_ARCH_PXA.

While we are there we can kill the dummy DMA bits in pxa2xx_spi.h as they
are not needed anymore for CE4100.

Once this is done we can add the generic DMA engine support to the driver
that allows usage of any DMA controller that implements DMA engine API.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c       |  612 +++++++++++++++++++++++-----------------
 include/linux/spi/pxa2xx_spi.h |   80 ------
 2 files changed, 349 insertions(+), 343 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 3dedebd..2e17679 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -46,8 +46,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define TIMOUT_DFLT		1000
 
-#define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
-#define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
+/* For PXA private DMA */
 #define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)x, DMA_ALIGNMENT)
 #define MAX_DMA_LEN		8191
 #define DMA_ALIGNMENT		8
@@ -100,7 +99,7 @@ struct driver_data {
 	/* PXA hookup */
 	struct pxa2xx_spi_master *master_info;
 
-	/* DMA setup stuff */
+	/* PXA private DMA setup stuff */
 	int rx_channel;
 	int tx_channel;
 	u32 *null_dma_buf;
@@ -133,7 +132,6 @@ struct driver_data {
 	size_t rx_map_len;
 	size_t tx_map_len;
 	u8 n_bytes;
-	u32 dma_width;
 	int (*write)(struct driver_data *drv_data);
 	int (*read)(struct driver_data *drv_data);
 	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
@@ -146,7 +144,6 @@ struct chip_data {
 	u32 psp;
 	u32 timeout;
 	u8 n_bytes;
-	u32 dma_width;
 	u32 dma_burst_size;
 	u32 threshold;
 	u32 dma_threshold;
@@ -358,6 +355,80 @@ static void *next_transfer(struct driver_data *drv_data)
 		return DONE_STATE;
 }
 
+/* caller already set message->status; dma and pio irqs are blocked */
+static void giveback(struct driver_data *drv_data)
+{
+	struct spi_transfer* last_transfer;
+	struct spi_message *msg;
+
+	msg = drv_data->cur_msg;
+	drv_data->cur_msg = NULL;
+	drv_data->cur_transfer = NULL;
+
+	last_transfer = list_entry(msg->transfers.prev,
+					struct spi_transfer,
+					transfer_list);
+
+	/* Delay if requested before any change in chip select */
+	if (last_transfer->delay_usecs)
+		udelay(last_transfer->delay_usecs);
+
+	/* Drop chip select UNLESS cs_change is true or we are returning
+	 * a message with an error, or next message is for another chip
+	 */
+	if (!last_transfer->cs_change)
+		cs_deassert(drv_data);
+	else {
+		struct spi_message *next_msg;
+
+		/* Holding of cs was hinted, but we need to make sure
+		 * the next message is for the same chip.  Don't waste
+		 * time with the following tests unless this was hinted.
+		 *
+		 * We cannot postpone this until pump_messages, because
+		 * after calling msg->complete (below) the driver that
+		 * sent the current message could be unloaded, which
+		 * could invalidate the cs_control() callback...
+		 */
+
+		/* get a pointer to the next message, if any */
+		next_msg = spi_get_next_queued_message(drv_data->master);
+
+		/* see if the next and current messages point
+		 * to the same chip
+		 */
+		if (next_msg && next_msg->spi != msg->spi)
+			next_msg = NULL;
+		if (!next_msg || msg->state == ERROR_STATE)
+			cs_deassert(drv_data);
+	}
+
+	spi_finalize_current_message(drv_data->master);
+	drv_data->cur_chip = NULL;
+}
+
+#ifdef CONFIG_ARCH_PXA
+#define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
+#define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
+
+static bool dma_is_possible(size_t len)
+{
+	/* Try to map dma buffer and do a dma transfer if successful, but
+	 * only if the length is non-zero and less than MAX_DMA_LEN.
+	 *
+	 * Zero-length non-descriptor DMA is illegal on PXA2xx; force use
+	 * of PIO instead.  Care is needed above because the transfer may
+	 * have have been passed with buffers that are already dma mapped.
+	 * A zero-length transfer in PIO mode will not try to write/read
+	 * to/from the buffers
+	 *
+	 * REVISIT large transfers are exactly where we most want to be
+	 * using DMA.  If this happens much, split those transfers into
+	 * multiple DMA segments rather than forcing PIO.
+	 */
+	return len > 0 && len <= MAX_DMA_LEN;
+}
+
 static int map_dma_buffers(struct driver_data *drv_data)
 {
 	struct spi_message *msg = drv_data->cur_msg;
@@ -428,58 +499,6 @@ static void unmap_dma_buffers(struct driver_data *drv_data)
 	drv_data->dma_mapped = 0;
 }
 
-/* caller already set message->status; dma and pio irqs are blocked */
-static void giveback(struct driver_data *drv_data)
-{
-	struct spi_transfer* last_transfer;
-	struct spi_message *msg;
-
-	msg = drv_data->cur_msg;
-	drv_data->cur_msg = NULL;
-	drv_data->cur_transfer = NULL;
-
-	last_transfer = list_entry(msg->transfers.prev,
-					struct spi_transfer,
-					transfer_list);
-
-	/* Delay if requested before any change in chip select */
-	if (last_transfer->delay_usecs)
-		udelay(last_transfer->delay_usecs);
-
-	/* Drop chip select UNLESS cs_change is true or we are returning
-	 * a message with an error, or next message is for another chip
-	 */
-	if (!last_transfer->cs_change)
-		cs_deassert(drv_data);
-	else {
-		struct spi_message *next_msg;
-
-		/* Holding of cs was hinted, but we need to make sure
-		 * the next message is for the same chip.  Don't waste
-		 * time with the following tests unless this was hinted.
-		 *
-		 * We cannot postpone this until pump_messages, because
-		 * after calling msg->complete (below) the driver that
-		 * sent the current message could be unloaded, which
-		 * could invalidate the cs_control() callback...
-		 */
-
-		/* get a pointer to the next message, if any */
-		next_msg = spi_get_next_queued_message(drv_data->master);
-
-		/* see if the next and current messages point
-		 * to the same chip
-		 */
-		if (next_msg && next_msg->spi != msg->spi)
-			next_msg = NULL;
-		if (!next_msg || msg->state == ERROR_STATE)
-			cs_deassert(drv_data);
-	}
-
-	spi_finalize_current_message(drv_data->master);
-	drv_data->cur_chip = NULL;
-}
-
 static int wait_ssp_rx_stall(void const __iomem *ioaddr)
 {
 	unsigned long limit = loops_per_jiffy << 1;
@@ -635,6 +654,264 @@ static irqreturn_t dma_transfer(struct driver_data *drv_data)
 	return IRQ_NONE;
 }
 
+static int dma_prepare(struct driver_data *drv_data, u32 dma_burst)
+{
+	u32 dma_width;
+
+	switch (drv_data->n_bytes) {
+	case 1:
+		dma_width = DCMD_WIDTH1;
+		break;
+	case 2:
+		dma_width = DCMD_WIDTH2;
+		break;
+	default:
+		dma_width = DCMD_WIDTH4;
+		break;
+	}
+
+	/* Setup rx DMA Channel */
+	DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
+	DSADR(drv_data->rx_channel) = drv_data->ssdr_physical;
+	DTADR(drv_data->rx_channel) = drv_data->rx_dma;
+	if (drv_data->rx == drv_data->null_dma_buf)
+		/* No target address increment */
+		DCMD(drv_data->rx_channel) = DCMD_FLOWSRC
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+	else
+		DCMD(drv_data->rx_channel) = DCMD_INCTRGADDR
+						| DCMD_FLOWSRC
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+
+	/* Setup tx DMA Channel */
+	DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
+	DSADR(drv_data->tx_channel) = drv_data->tx_dma;
+	DTADR(drv_data->tx_channel) = drv_data->ssdr_physical;
+	if (drv_data->tx == drv_data->null_dma_buf)
+		/* No source address increment */
+		DCMD(drv_data->tx_channel) = DCMD_FLOWTRG
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+	else
+		DCMD(drv_data->tx_channel) = DCMD_INCSRCADDR
+						| DCMD_FLOWTRG
+						| dma_width
+						| dma_burst
+						| drv_data->len;
+
+	/* Enable dma end irqs on SSP to detect end of transfer */
+	if (drv_data->ssp_type == PXA25x_SSP)
+		DCMD(drv_data->tx_channel) |= DCMD_ENDIRQEN;
+
+	return 0;
+}
+
+static void dma_start(struct driver_data *drv_data)
+{
+	DCSR(drv_data->rx_channel) |= DCSR_RUN;
+	DCSR(drv_data->tx_channel) |= DCSR_RUN;
+}
+
+static int dma_setup(struct driver_data *drv_data)
+{
+	struct device *dev = &drv_data->pdev->dev;
+	struct ssp_device *ssp = drv_data->ssp;
+
+	/* Get two DMA channels	(rx and tx) */
+	drv_data->rx_channel = pxa_request_dma("pxa2xx_spi_ssp_rx",
+						DMA_PRIO_HIGH,
+						dma_handler,
+						drv_data);
+	if (drv_data->rx_channel < 0) {
+		dev_err(dev, "problem (%d) requesting rx channel\n",
+			drv_data->rx_channel);
+		return -ENODEV;
+	}
+	drv_data->tx_channel = pxa_request_dma("pxa2xx_spi_ssp_tx",
+						DMA_PRIO_MEDIUM,
+						dma_handler,
+						drv_data);
+	if (drv_data->tx_channel < 0) {
+		dev_err(dev, "problem (%d) requesting tx channel\n",
+			drv_data->tx_channel);
+		pxa_free_dma(drv_data->rx_channel);
+		return -ENODEV;
+	}
+
+	DRCMR(ssp->drcmr_rx) = DRCMR_MAPVLD | drv_data->rx_channel;
+	DRCMR(ssp->drcmr_tx) = DRCMR_MAPVLD | drv_data->tx_channel;
+
+	return 0;
+}
+
+static void dma_release(struct driver_data *drv_data)
+{
+	struct ssp_device *ssp = drv_data->ssp;
+
+	DRCMR(ssp->drcmr_rx) = 0;
+	DRCMR(ssp->drcmr_tx) = 0;
+
+	if (drv_data->tx_channel != 0)
+		pxa_free_dma(drv_data->tx_channel);
+	if (drv_data->rx_channel != 0)
+		pxa_free_dma(drv_data->rx_channel);
+}
+
+static void dma_resume(struct driver_data *drv_data)
+{
+	if (drv_data->rx_channel != -1)
+		DRCMR(drv_data->ssp->drcmr_rx) =
+			DRCMR_MAPVLD | drv_data->rx_channel;
+	if (drv_data->tx_channel != -1)
+		DRCMR(drv_data->ssp->drcmr_tx) =
+			DRCMR_MAPVLD | drv_data->tx_channel;
+}
+
+static int set_dma_burst_and_threshold(struct chip_data *chip,
+				struct spi_device *spi,
+				u8 bits_per_word, u32 *burst_code,
+				u32 *threshold)
+{
+	struct pxa2xx_spi_chip *chip_info =
+			(struct pxa2xx_spi_chip *)spi->controller_data;
+	int bytes_per_word;
+	int burst_bytes;
+	int thresh_words;
+	int req_burst_size;
+	int retval = 0;
+
+	/* Set the threshold (in registers) to equal the same amount of data
+	 * as represented by burst size (in bytes).  The computation below
+	 * is (burst_size rounded up to nearest 8 byte, word or long word)
+	 * divided by (bytes/register); the tx threshold is the inverse of
+	 * the rx, so that there will always be enough data in the rx fifo
+	 * to satisfy a burst, and there will always be enough space in the
+	 * tx fifo to accept a burst (a tx burst will overwrite the fifo if
+	 * there is not enough space), there must always remain enough empty
+	 * space in the rx fifo for any data loaded to the tx fifo.
+	 * Whenever burst_size (in bytes) equals bits/word, the fifo threshold
+	 * will be 8, or half the fifo;
+	 * The threshold can only be set to 2, 4 or 8, but not 16, because
+	 * to burst 16 to the tx fifo, the fifo would have to be empty;
+	 * however, the minimum fifo trigger level is 1, and the tx will
+	 * request service when the fifo is at this level, with only 15 spaces.
+	 */
+
+	/* find bytes/word */
+	if (bits_per_word <= 8)
+		bytes_per_word = 1;
+	else if (bits_per_word <= 16)
+		bytes_per_word = 2;
+	else
+		bytes_per_word = 4;
+
+	/* use struct pxa2xx_spi_chip->dma_burst_size if available */
+	if (chip_info)
+		req_burst_size = chip_info->dma_burst_size;
+	else {
+		switch (chip->dma_burst_size) {
+		default:
+			/* if the default burst size is not set,
+			 * do it now */
+			chip->dma_burst_size = DCMD_BURST8;
+		case DCMD_BURST8:
+			req_burst_size = 8;
+			break;
+		case DCMD_BURST16:
+			req_burst_size = 16;
+			break;
+		case DCMD_BURST32:
+			req_burst_size = 32;
+			break;
+		}
+	}
+	if (req_burst_size <= 8) {
+		*burst_code = DCMD_BURST8;
+		burst_bytes = 8;
+	} else if (req_burst_size <= 16) {
+		if (bytes_per_word == 1) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST8;
+			burst_bytes = 8;
+			retval = 1;
+		} else {
+			*burst_code = DCMD_BURST16;
+			burst_bytes = 16;
+		}
+	} else {
+		if (bytes_per_word == 1) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST8;
+			burst_bytes = 8;
+			retval = 1;
+		} else if (bytes_per_word == 2) {
+			/* don't burst more than 1/2 the fifo */
+			*burst_code = DCMD_BURST16;
+			burst_bytes = 16;
+			retval = 1;
+		} else {
+			*burst_code = DCMD_BURST32;
+			burst_bytes = 32;
+		}
+	}
+
+	thresh_words = burst_bytes / bytes_per_word;
+
+	/* thresh_words will be between 2 and 8 */
+	*threshold = (SSCR1_RxTresh(thresh_words) & SSCR1_RFT)
+			| (SSCR1_TxTresh(16-thresh_words) & SSCR1_TFT);
+
+	return retval;
+}
+#else
+static bool dma_is_possible(size_t len)
+{
+	return false;
+}
+
+static int map_dma_buffers(struct driver_data *drv_data)
+{
+	return 0;
+}
+
+static irqreturn_t dma_transfer(struct driver_data *drv_data)
+{
+	return IRQ_NONE;
+}
+
+static void dma_prepare(struct driver_data *drv_data, u32 dma_burst)
+{
+}
+
+static void dma_start(struct driver_data *drv_data)
+{
+}
+
+static int dma_setup(struct driver_data *drv_data)
+{
+	return -ENODEV;
+}
+
+static void dma_release(struct driver_data *drv_data)
+{
+}
+
+static inline void dma_resume(struct driver_data *drv_data) {}
+
+static int set_dma_burst_and_threshold(struct chip_data *chip,
+				struct spi_device *spi,
+				u8 bits_per_word, u32 *burst_code,
+				u32 *threshold)
+{
+	return -ENODEV;
+}
+#endif
+
 static void reset_sccr1(struct driver_data *drv_data)
 {
 	void __iomem *reg = drv_data->ioaddr;
@@ -795,103 +1072,6 @@ static irqreturn_t ssp_int(int irq, void *dev_id)
 	return drv_data->transfer_handler(drv_data);
 }
 
-static int set_dma_burst_and_threshold(struct chip_data *chip,
-				struct spi_device *spi,
-				u8 bits_per_word, u32 *burst_code,
-				u32 *threshold)
-{
-	struct pxa2xx_spi_chip *chip_info =
-			(struct pxa2xx_spi_chip *)spi->controller_data;
-	int bytes_per_word;
-	int burst_bytes;
-	int thresh_words;
-	int req_burst_size;
-	int retval = 0;
-
-	/* Set the threshold (in registers) to equal the same amount of data
-	 * as represented by burst size (in bytes).  The computation below
-	 * is (burst_size rounded up to nearest 8 byte, word or long word)
-	 * divided by (bytes/register); the tx threshold is the inverse of
-	 * the rx, so that there will always be enough data in the rx fifo
-	 * to satisfy a burst, and there will always be enough space in the
-	 * tx fifo to accept a burst (a tx burst will overwrite the fifo if
-	 * there is not enough space), there must always remain enough empty
-	 * space in the rx fifo for any data loaded to the tx fifo.
-	 * Whenever burst_size (in bytes) equals bits/word, the fifo threshold
-	 * will be 8, or half the fifo;
-	 * The threshold can only be set to 2, 4 or 8, but not 16, because
-	 * to burst 16 to the tx fifo, the fifo would have to be empty;
-	 * however, the minimum fifo trigger level is 1, and the tx will
-	 * request service when the fifo is at this level, with only 15 spaces.
-	 */
-
-	/* find bytes/word */
-	if (bits_per_word <= 8)
-		bytes_per_word = 1;
-	else if (bits_per_word <= 16)
-		bytes_per_word = 2;
-	else
-		bytes_per_word = 4;
-
-	/* use struct pxa2xx_spi_chip->dma_burst_size if available */
-	if (chip_info)
-		req_burst_size = chip_info->dma_burst_size;
-	else {
-		switch (chip->dma_burst_size) {
-		default:
-			/* if the default burst size is not set,
-			 * do it now */
-			chip->dma_burst_size = DCMD_BURST8;
-		case DCMD_BURST8:
-			req_burst_size = 8;
-			break;
-		case DCMD_BURST16:
-			req_burst_size = 16;
-			break;
-		case DCMD_BURST32:
-			req_burst_size = 32;
-			break;
-		}
-	}
-	if (req_burst_size <= 8) {
-		*burst_code = DCMD_BURST8;
-		burst_bytes = 8;
-	} else if (req_burst_size <= 16) {
-		if (bytes_per_word == 1) {
-			/* don't burst more than 1/2 the fifo */
-			*burst_code = DCMD_BURST8;
-			burst_bytes = 8;
-			retval = 1;
-		} else {
-			*burst_code = DCMD_BURST16;
-			burst_bytes = 16;
-		}
-	} else {
-		if (bytes_per_word == 1) {
-			/* don't burst more than 1/2 the fifo */
-			*burst_code = DCMD_BURST8;
-			burst_bytes = 8;
-			retval = 1;
-		} else if (bytes_per_word == 2) {
-			/* don't burst more than 1/2 the fifo */
-			*burst_code = DCMD_BURST16;
-			burst_bytes = 16;
-			retval = 1;
-		} else {
-			*burst_code = DCMD_BURST32;
-			burst_bytes = 32;
-		}
-	}
-
-	thresh_words = burst_bytes / bytes_per_word;
-
-	/* thresh_words will be between 2 and 8 */
-	*threshold = (SSCR1_RxTresh(thresh_words) & SSCR1_RFT)
-			| (SSCR1_TxTresh(16-thresh_words) & SSCR1_TFT);
-
-	return retval;
-}
-
 static unsigned long pxa2xx_spi_clk_rate(struct driver_data *drv_data)
 {
 	const struct pxa2xx_spi_master *pdata = drv_data->master_info;
@@ -961,8 +1141,8 @@ static void pump_transfers(unsigned long data)
 			cs_deassert(drv_data);
 	}
 
-	/* Check for transfers that need multiple DMA segments */
-	if (transfer->len > MAX_DMA_LEN && chip->enable_dma) {
+	/* Check if we can DMA this transfer */
+	if (!dma_is_possible(transfer->len) && chip->enable_dma) {
 
 		/* reject already-mapped transfers; PIO won't always work */
 		if (message->is_dma_mapped
@@ -992,14 +1172,13 @@ static void pump_transfers(unsigned long data)
 		return;
 	}
 	drv_data->n_bytes = chip->n_bytes;
-	drv_data->dma_width = chip->dma_width;
 	drv_data->tx = (void *)transfer->tx_buf;
 	drv_data->tx_end = drv_data->tx + transfer->len;
 	drv_data->rx = transfer->rx_buf;
 	drv_data->rx_end = drv_data->rx + transfer->len;
 	drv_data->rx_dma = transfer->rx_dma;
 	drv_data->tx_dma = transfer->tx_dma;
-	drv_data->len = transfer->len & DCMD_LENGTH;
+	drv_data->len = transfer->len;
 	drv_data->write = drv_data->tx ? chip->write : null_writer;
 	drv_data->read = drv_data->rx ? chip->read : null_reader;
 
@@ -1020,21 +1199,18 @@ static void pump_transfers(unsigned long data)
 
 		if (bits <= 8) {
 			drv_data->n_bytes = 1;
-			drv_data->dma_width = DCMD_WIDTH1;
 			drv_data->read = drv_data->read != null_reader ?
 						u8_reader : null_reader;
 			drv_data->write = drv_data->write != null_writer ?
 						u8_writer : null_writer;
 		} else if (bits <= 16) {
 			drv_data->n_bytes = 2;
-			drv_data->dma_width = DCMD_WIDTH2;
 			drv_data->read = drv_data->read != null_reader ?
 						u16_reader : null_reader;
 			drv_data->write = drv_data->write != null_writer ?
 						u16_writer : null_writer;
 		} else if (bits <= 32) {
 			drv_data->n_bytes = 4;
-			drv_data->dma_width = DCMD_WIDTH4;
 			drv_data->read = drv_data->read != null_reader ?
 						u32_reader : null_reader;
 			drv_data->write = drv_data->write != null_writer ?
@@ -1062,70 +1238,21 @@ static void pump_transfers(unsigned long data)
 
 	message->state = RUNNING_STATE;
 
-	/* Try to map dma buffer and do a dma transfer if successful, but
-	 * only if the length is non-zero and less than MAX_DMA_LEN.
-	 *
-	 * Zero-length non-descriptor DMA is illegal on PXA2xx; force use
-	 * of PIO instead.  Care is needed above because the transfer may
-	 * have have been passed with buffers that are already dma mapped.
-	 * A zero-length transfer in PIO mode will not try to write/read
-	 * to/from the buffers
-	 *
-	 * REVISIT large transfers are exactly where we most want to be
-	 * using DMA.  If this happens much, split those transfers into
-	 * multiple DMA segments rather than forcing PIO.
-	 */
 	drv_data->dma_mapped = 0;
-	if (drv_data->len > 0 && drv_data->len <= MAX_DMA_LEN)
+	if (dma_is_possible(drv_data->len))
 		drv_data->dma_mapped = map_dma_buffers(drv_data);
 	if (drv_data->dma_mapped) {
 
 		/* Ensure we have the correct interrupt handler */
 		drv_data->transfer_handler = dma_transfer;
 
-		/* Setup rx DMA Channel */
-		DCSR(drv_data->rx_channel) = RESET_DMA_CHANNEL;
-		DSADR(drv_data->rx_channel) = drv_data->ssdr_physical;
-		DTADR(drv_data->rx_channel) = drv_data->rx_dma;
-		if (drv_data->rx == drv_data->null_dma_buf)
-			/* No target address increment */
-			DCMD(drv_data->rx_channel) = DCMD_FLOWSRC
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-		else
-			DCMD(drv_data->rx_channel) = DCMD_INCTRGADDR
-							| DCMD_FLOWSRC
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-
-		/* Setup tx DMA Channel */
-		DCSR(drv_data->tx_channel) = RESET_DMA_CHANNEL;
-		DSADR(drv_data->tx_channel) = drv_data->tx_dma;
-		DTADR(drv_data->tx_channel) = drv_data->ssdr_physical;
-		if (drv_data->tx == drv_data->null_dma_buf)
-			/* No source address increment */
-			DCMD(drv_data->tx_channel) = DCMD_FLOWTRG
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-		else
-			DCMD(drv_data->tx_channel) = DCMD_INCSRCADDR
-							| DCMD_FLOWTRG
-							| drv_data->dma_width
-							| dma_burst
-							| drv_data->len;
-
-		/* Enable dma end irqs on SSP to detect end of transfer */
-		if (drv_data->ssp_type == PXA25x_SSP)
-			DCMD(drv_data->tx_channel) |= DCMD_ENDIRQEN;
+		dma_prepare(drv_data, dma_burst);
 
 		/* Clear status and start DMA engine */
 		cr1 = chip->cr1 | dma_thresh | drv_data->dma_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
-		DCSR(drv_data->rx_channel) |= DCSR_RUN;
-		DCSR(drv_data->tx_channel) |= DCSR_RUN;
+
+		dma_start(drv_data);
 	} else {
 		/* Ensure we have the correct interrupt handler	*/
 		drv_data->transfer_handler = interrupt_transfer;
@@ -1267,8 +1394,6 @@ static int setup(struct spi_device *spi)
 			chip->gpio_cs = -1;
 		chip->enable_dma = 0;
 		chip->timeout = TIMOUT_DFLT;
-		chip->dma_burst_size = drv_data->master_info->enable_dma ?
-					DCMD_BURST8 : 0;
 	}
 
 	/* protocol drivers may change the chip settings, so...
@@ -1333,18 +1458,15 @@ static int setup(struct spi_device *spi)
 
 	if (spi->bits_per_word <= 8) {
 		chip->n_bytes = 1;
-		chip->dma_width = DCMD_WIDTH1;
 		chip->read = u8_reader;
 		chip->write = u8_writer;
 	} else if (spi->bits_per_word <= 16) {
 		chip->n_bytes = 2;
-		chip->dma_width = DCMD_WIDTH2;
 		chip->read = u16_reader;
 		chip->write = u16_writer;
 	} else if (spi->bits_per_word <= 32) {
 		chip->cr0 |= SSCR0_EDSS;
 		chip->n_bytes = 4;
-		chip->dma_width = DCMD_WIDTH4;
 		chip->read = u32_reader;
 		chip->write = u32_writer;
 	} else {
@@ -1452,31 +1574,11 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	drv_data->tx_channel = -1;
 	drv_data->rx_channel = -1;
 	if (platform_info->enable_dma) {
-
-		/* Get two DMA channels	(rx and tx) */
-		drv_data->rx_channel = pxa_request_dma("pxa2xx_spi_ssp_rx",
-							DMA_PRIO_HIGH,
-							dma_handler,
-							drv_data);
-		if (drv_data->rx_channel < 0) {
-			dev_err(dev, "problem (%d) requesting rx channel\n",
-				drv_data->rx_channel);
-			status = -ENODEV;
-			goto out_error_irq_alloc;
-		}
-		drv_data->tx_channel = pxa_request_dma("pxa2xx_spi_ssp_tx",
-							DMA_PRIO_MEDIUM,
-							dma_handler,
-							drv_data);
-		if (drv_data->tx_channel < 0) {
-			dev_err(dev, "problem (%d) requesting tx channel\n",
-				drv_data->tx_channel);
-			status = -ENODEV;
-			goto out_error_dma_alloc;
+		status = dma_setup(drv_data);
+		if (status) {
+			dev_warn(dev, "failed to setup DMA, using PIO\n");
+			platform_info->enable_dma = false;
 		}
-
-		DRCMR(ssp->drcmr_rx) = DRCMR_MAPVLD | drv_data->rx_channel;
-		DRCMR(ssp->drcmr_tx) = DRCMR_MAPVLD | drv_data->tx_channel;
 	}
 
 	/* Enable SOC clock */
@@ -1510,14 +1612,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 
 out_error_clock_enabled:
 	clk_disable(ssp->clk);
-
-out_error_dma_alloc:
-	if (drv_data->tx_channel != -1)
-		pxa_free_dma(drv_data->tx_channel);
-	if (drv_data->rx_channel != -1)
-		pxa_free_dma(drv_data->rx_channel);
-
-out_error_irq_alloc:
+	dma_release(drv_data);
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
@@ -1540,12 +1635,8 @@ static int pxa2xx_spi_remove(struct platform_device *pdev)
 	clk_disable(ssp->clk);
 
 	/* Release DMA */
-	if (drv_data->master_info->enable_dma) {
-		DRCMR(ssp->drcmr_rx) = 0;
-		DRCMR(ssp->drcmr_tx) = 0;
-		pxa_free_dma(drv_data->tx_channel);
-		pxa_free_dma(drv_data->rx_channel);
-	}
+	if (drv_data->master_info->enable_dma)
+		dma_release(drv_data);
 
 	/* Release IRQ */
 	free_irq(ssp->irq, drv_data);
@@ -1592,12 +1683,7 @@ static int pxa2xx_spi_resume(struct device *dev)
 	struct ssp_device *ssp = drv_data->ssp;
 	int status = 0;
 
-	if (drv_data->rx_channel != -1)
-		DRCMR(drv_data->ssp->drcmr_rx) =
-			DRCMR_MAPVLD | drv_data->rx_channel;
-	if (drv_data->tx_channel != -1)
-		DRCMR(drv_data->ssp->drcmr_tx) =
-			DRCMR_MAPVLD | drv_data->tx_channel;
+	dma_resume(drv_data);
 
 	/* Enable the SSP clock */
 	clk_enable(ssp->clk);
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 83b73f5..9f8cd03 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -54,85 +54,5 @@ struct pxa2xx_spi_chip {
 
 extern void pxa2xx_set_spi_info(unsigned id, struct pxa2xx_spi_master *info);
 
-#else
-/*
- * This is the implemtation for CE4100 on x86. ARM defines them in mach/ or
- * plat/ include path.
- * The CE4100 does not provide DMA support. This bits are here to let the driver
- * compile and will never be used. Maybe we get DMA support at a later point in
- * time.
- */
-
-#define DCSR(n)         (n)
-#define DSADR(n)        (n)
-#define DTADR(n)        (n)
-#define DCMD(n)         (n)
-#define DRCMR(n)        (n)
-
-#define DCSR_RUN	(1 << 31)	/* Run Bit */
-#define DCSR_NODESC	(1 << 30)	/* No-Descriptor Fetch */
-#define DCSR_STOPIRQEN	(1 << 29)	/* Stop Interrupt Enable */
-#define DCSR_REQPEND	(1 << 8)	/* Request Pending (read-only) */
-#define DCSR_STOPSTATE	(1 << 3)	/* Stop State (read-only) */
-#define DCSR_ENDINTR	(1 << 2)	/* End Interrupt */
-#define DCSR_STARTINTR	(1 << 1)	/* Start Interrupt */
-#define DCSR_BUSERR	(1 << 0)	/* Bus Error Interrupt */
-
-#define DCSR_EORIRQEN	(1 << 28)	/* End of Receive Interrupt Enable */
-#define DCSR_EORJMPEN	(1 << 27)	/* Jump to next descriptor on EOR */
-#define DCSR_EORSTOPEN	(1 << 26)	/* STOP on an EOR */
-#define DCSR_SETCMPST	(1 << 25)	/* Set Descriptor Compare Status */
-#define DCSR_CLRCMPST	(1 << 24)	/* Clear Descriptor Compare Status */
-#define DCSR_CMPST	(1 << 10)	/* The Descriptor Compare Status */
-#define DCSR_EORINTR	(1 << 9)	/* The end of Receive */
-
-#define DRCMR_MAPVLD	(1 << 7)	/* Map Valid */
-#define DRCMR_CHLNUM	0x1f		/* mask for Channel Number */
-
-#define DDADR_DESCADDR	0xfffffff0	/* Address of next descriptor */
-#define DDADR_STOP	(1 << 0)	/* Stop */
-
-#define DCMD_INCSRCADDR	(1 << 31)	/* Source Address Increment Setting. */
-#define DCMD_INCTRGADDR	(1 << 30)	/* Target Address Increment Setting. */
-#define DCMD_FLOWSRC	(1 << 29)	/* Flow Control by the source. */
-#define DCMD_FLOWTRG	(1 << 28)	/* Flow Control by the target. */
-#define DCMD_STARTIRQEN	(1 << 22)	/* Start Interrupt Enable */
-#define DCMD_ENDIRQEN	(1 << 21)	/* End Interrupt Enable */
-#define DCMD_ENDIAN	(1 << 18)	/* Device Endian-ness. */
-#define DCMD_BURST8	(1 << 16)	/* 8 byte burst */
-#define DCMD_BURST16	(2 << 16)	/* 16 byte burst */
-#define DCMD_BURST32	(3 << 16)	/* 32 byte burst */
-#define DCMD_WIDTH1	(1 << 14)	/* 1 byte width */
-#define DCMD_WIDTH2	(2 << 14)	/* 2 byte width (HalfWord) */
-#define DCMD_WIDTH4	(3 << 14)	/* 4 byte width (Word) */
-#define DCMD_LENGTH	0x01fff		/* length mask (max = 8K - 1) */
-
-/*
- * Descriptor structure for PXA's DMA engine
- * Note: this structure must always be aligned to a 16-byte boundary.
- */
-
-typedef enum {
-	DMA_PRIO_HIGH = 0,
-	DMA_PRIO_MEDIUM = 1,
-	DMA_PRIO_LOW = 2
-} pxa_dma_prio;
-
-/*
- * DMA registration
- */
-
-static inline int pxa_request_dma(char *name,
-		pxa_dma_prio prio,
-		void (*irq_handler)(int, void *),
-		void *data)
-{
-	return -ENODEV;
-}
-
-static inline void pxa_free_dma(int dma_ch)
-{
-}
-
 #endif
 #endif
-- 
1.7.10.4

