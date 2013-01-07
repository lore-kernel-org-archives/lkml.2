Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab3AGKnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:43:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:3717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab3AGKlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="273733538"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 07/11] spi/pxa2xx: add support for DMA engine
Date: Mon,  7 Jan 2013 12:44:36 +0200
Message-Id: <1357555480-24022-8-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use DMA with this driver on non-PXA platforms we implement support
for the generic DMA engine API. This allows to use different DMA engines with
little or no modification to the driver.

Request lines and channel numbers can be passed to the driver from the
platform specific data.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c       |  351 +++++++++++++++++++++++++++++++++++++++-
 include/linux/spi/pxa2xx_spi.h |    6 +
 2 files changed, 350 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 2e17679..9b438ad 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -16,6 +16,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/atomic.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
@@ -25,6 +26,9 @@
 #include <linux/platform_device.h>
 #include <linux/spi/pxa2xx_spi.h>
 #include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/scatterlist.h>
+#include <linux/sizes.h>
 #include <linux/spi/spi.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
@@ -48,7 +52,6 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 /* For PXA private DMA */
 #define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)x, DMA_ALIGNMENT)
-#define MAX_DMA_LEN		8191
 #define DMA_ALIGNMENT		8
 
 /*
@@ -117,6 +120,16 @@ struct driver_data {
 	/* Message Transfer pump */
 	struct tasklet_struct pump_transfers;
 
+	/* DMA engine support */
+	struct dma_chan *rx_chan;
+	struct dma_chan *tx_chan;
+	struct sg_table rx_sgt;
+	struct sg_table tx_sgt;
+	int rx_nents;
+	int tx_nents;
+	void *dummy;
+	atomic_t dma_running;
+
 	/* Current message transfer state info */
 	struct spi_message* cur_msg;
 	struct spi_transfer* cur_transfer;
@@ -410,6 +423,8 @@ static void giveback(struct driver_data *drv_data)
 #ifdef CONFIG_ARCH_PXA
 #define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
+#define MAX_DMA_LEN		8191
+#define DEFAULT_DMA_CR1		(SSCR1_TSRE | SSCR1_RSRE | SSCR1_TINTE)
 
 static bool dma_is_possible(size_t len)
 {
@@ -869,36 +884,347 @@ static int set_dma_burst_and_threshold(struct chip_data *chip,
 	return retval;
 }
 #else
+/* An arbitrary limit so that the DMA channel doesn't run out of descriptors */
+#define MAX_DMA_LEN	SZ_64K
+#define DEFAULT_DMA_CR1	(SSCR1_TSRE | SSCR1_RSRE | SSCR1_TRAIL)
+
 static bool dma_is_possible(size_t len)
 {
-	return false;
+	return len <= MAX_DMA_LEN;
+}
+
+static int map_dma_buffer(struct driver_data *drv_data,
+			  enum dma_data_direction dir)
+{
+	int i, nents, len = drv_data->len;
+	struct scatterlist *sg;
+	struct device *dmadev;
+	struct sg_table *sgt;
+	void *buf, *pbuf;
+
+	/*
+	 * Some DMA controllers have problems transferring buffers that are
+	 * not multiple of 4 bytes. So we truncate the transfer so that it
+	 * is suitable for such controllers, and handle the trailing bytes
+	 * manually after the DMA completes.
+	 */
+	len = ALIGN(drv_data->len, 4);
+
+	if (dir == DMA_TO_DEVICE) {
+		dmadev = drv_data->tx_chan->device->dev;
+		sgt = &drv_data->tx_sgt;
+		buf = drv_data->tx;
+		drv_data->tx_map_len = len;
+	} else {
+		dmadev = drv_data->rx_chan->device->dev;
+		sgt = &drv_data->rx_sgt;
+		buf = drv_data->rx;
+		drv_data->rx_map_len = len;
+	}
+
+	nents = DIV_ROUND_UP(len, SZ_2K);
+	if (nents != sgt->nents) {
+		int ret;
+
+		sg_free_table(sgt);
+		ret = sg_alloc_table(sgt, nents, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+
+	pbuf = buf;
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		size_t bytes = min_t(size_t, len, SZ_2K);
+
+		if (buf)
+			sg_set_buf(sg, pbuf, bytes);
+		else
+			sg_set_buf(sg, drv_data->dummy, bytes);
+
+		pbuf += bytes;
+		len -= bytes;
+	}
+
+	nents = dma_map_sg(dmadev, sgt->sgl, sgt->nents, dir);
+	if (!nents)
+		return -ENOMEM;
+
+	return nents;
+}
+
+static void unmap_dma_buffer(struct driver_data *drv_data,
+			     enum dma_data_direction dir)
+{
+	struct device *dmadev;
+	struct sg_table *sgt;
+
+	if (dir == DMA_TO_DEVICE) {
+		dmadev = drv_data->tx_chan->device->dev;
+		sgt = &drv_data->tx_sgt;
+	} else {
+		dmadev = drv_data->rx_chan->device->dev;
+		sgt = &drv_data->rx_sgt;
+	}
+
+	dma_unmap_sg(dmadev, sgt->sgl, sgt->nents, dir);
 }
 
 static int map_dma_buffers(struct driver_data *drv_data)
 {
-	return 0;
+	const struct chip_data *chip = drv_data->cur_chip;
+	int ret;
+
+	if (!chip->enable_dma)
+		return 0;
+
+	/* Don't bother with DMA if we can't do even a single burst */
+	if (drv_data->len < chip->dma_burst_size)
+		return 0;
+
+	ret = map_dma_buffer(drv_data, DMA_TO_DEVICE);
+	if (ret <= 0) {
+		dev_warn(&drv_data->pdev->dev, "failed to DMA map TX\n");
+		return 0;
+	}
+
+	drv_data->tx_nents = ret;
+
+	ret = map_dma_buffer(drv_data, DMA_FROM_DEVICE);
+	if (ret <= 0) {
+		unmap_dma_buffer(drv_data, DMA_TO_DEVICE);
+		dev_warn(&drv_data->pdev->dev, "failed to DMA map RX\n");
+		return 0;
+	}
+
+	drv_data->rx_nents = ret;
+	return 1;
+}
+
+static void unmap_dma_buffers(struct driver_data *drv_data)
+{
+	if (!drv_data->dma_mapped)
+		return;
+
+	unmap_dma_buffer(drv_data, DMA_FROM_DEVICE);
+	unmap_dma_buffer(drv_data, DMA_TO_DEVICE);
+
+	drv_data->dma_mapped = 0;
+}
+
+static void dma_transfer_complete(struct driver_data *drv_data, bool error)
+{
+	struct spi_message *msg = drv_data->cur_msg;
+
+	/*
+	 * It is possible that one CPU is handling ROR interrupt and other
+	 * just gets DMA completion. Calling pump_transfers() twice for the
+	 * same transfer leads to problems thus we prevent concurrent calls
+	 * by using ->dma_running.
+	 */
+	if (atomic_dec_and_test(&drv_data->dma_running)) {
+		void __iomem *reg = drv_data->ioaddr;
+
+		/*
+		 * If the other CPU is still handling the ROR interrupt we
+		 * might not know about the error yet. So we re-check the
+		 * ROR bit here before we clear the status register.
+		 */
+		if (!error) {
+			u32 status = read_SSSR(reg) & drv_data->mask_sr;
+			error = status & SSSR_ROR;
+		}
+
+		/* Clear status & disable interrupts */
+		write_SSCR1(read_SSCR1(reg) & ~drv_data->dma_cr1, reg);
+		write_SSSR_CS(drv_data, drv_data->clear_sr);
+		if (!pxa25x_ssp_comp(drv_data))
+			write_SSTO(0, reg);
+
+		if (!error) {
+			unmap_dma_buffers(drv_data);
+
+			/* Handle the last bytes of unaligned transfer */
+			drv_data->tx += drv_data->tx_map_len;
+			drv_data->write(drv_data);
+
+			drv_data->rx += drv_data->rx_map_len;
+			drv_data->read(drv_data);
+
+			msg->actual_length += drv_data->len;
+			msg->state = next_transfer(drv_data);
+		} else {
+			/* In case we got an error we disable the SSP now */
+			write_SSCR0(read_SSCR0(reg) & ~SSCR0_SSE, reg);
+
+			msg->state = ERROR_STATE;
+		}
+
+		tasklet_schedule(&drv_data->pump_transfers);
+	}
 }
 
 static irqreturn_t dma_transfer(struct driver_data *drv_data)
 {
+	u32 status;
+
+	status = read_SSSR(drv_data->ioaddr) & drv_data->mask_sr;
+	if (status & SSSR_ROR) {
+		dev_err(&drv_data->pdev->dev, "FIFO overrun\n");
+
+		dmaengine_terminate_all(drv_data->rx_chan);
+		dmaengine_terminate_all(drv_data->tx_chan);
+
+		dma_transfer_complete(drv_data, true);
+		return IRQ_HANDLED;
+	}
+
 	return IRQ_NONE;
 }
 
-static void dma_prepare(struct driver_data *drv_data, u32 dma_burst)
+static void dma_callback(void *data)
+{
+	dma_transfer_complete(data, false);
+}
+
+static struct dma_async_tx_descriptor *
+dma_prepare_one(struct driver_data *drv_data, enum dma_transfer_direction dir)
+{
+	struct pxa2xx_spi_master *pdata = drv_data->master_info;
+	struct chip_data *chip = drv_data->cur_chip;
+	enum dma_slave_buswidth width;
+	struct dma_slave_config cfg;
+	struct dma_chan *chan;
+	struct sg_table *sgt;
+	int nents, ret;
+
+	switch (drv_data->n_bytes) {
+	case 1:
+		width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		break;
+	case 2:
+		width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+	default:
+		width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		break;
+	}
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.direction = dir;
+
+	if (dir == DMA_MEM_TO_DEV) {
+		cfg.dst_addr = drv_data->ssdr_physical;
+		cfg.dst_addr_width = width;
+		cfg.dst_maxburst = chip->dma_burst_size;
+		cfg.slave_id = pdata->tx_slave_id;
+
+		sgt = &drv_data->tx_sgt;
+		nents = drv_data->tx_nents;
+		chan = drv_data->tx_chan;
+	} else {
+		cfg.src_addr = drv_data->ssdr_physical;
+		cfg.src_addr_width = width;
+		cfg.src_maxburst = chip->dma_burst_size;
+		cfg.slave_id = pdata->rx_slave_id;
+
+		sgt = &drv_data->rx_sgt;
+		nents = drv_data->rx_nents;
+		chan = drv_data->rx_chan;
+	}
+
+	ret = dmaengine_slave_config(chan, &cfg);
+	if (ret) {
+		dev_warn(&drv_data->pdev->dev, "DMA slave config failed\n");
+		return NULL;
+	}
+
+	return dmaengine_prep_slave_sg(chan, sgt->sgl, nents, dir,
+				       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+}
+
+static int dma_prepare(struct driver_data *drv_data, u32 dma_burst)
 {
+	struct dma_async_tx_descriptor *tx_desc, *rx_desc;
+
+	tx_desc = dma_prepare_one(drv_data, DMA_MEM_TO_DEV);
+	if (!tx_desc) {
+		dev_err(&drv_data->pdev->dev,
+			"failed to get DMA TX descriptor\n");
+		return -EBUSY;
+	}
+
+	rx_desc = dma_prepare_one(drv_data, DMA_DEV_TO_MEM);
+	if (!rx_desc) {
+		dev_err(&drv_data->pdev->dev,
+			"failed to get DMA RX descriptor\n");
+		return -EBUSY;
+	}
+
+	/* We are ready when RX completes */
+	rx_desc->callback = dma_callback;
+	rx_desc->callback_param = drv_data;
+
+	dmaengine_submit(rx_desc);
+	dmaengine_submit(tx_desc);
+	return 0;
 }
 
 static void dma_start(struct driver_data *drv_data)
 {
+	dma_async_issue_pending(drv_data->rx_chan);
+	dma_async_issue_pending(drv_data->tx_chan);
+
+	atomic_set(&drv_data->dma_running, 1);
+}
+
+static bool dma_filter(struct dma_chan *chan, void *param)
+{
+	const struct pxa2xx_spi_master *pdata = param;
+
+	return chan->chan_id == pdata->tx_chan_id ||
+	       chan->chan_id == pdata->rx_chan_id;
 }
 
 static int dma_setup(struct driver_data *drv_data)
 {
-	return -ENODEV;
+	struct pxa2xx_spi_master *pdata = drv_data->master_info;
+	dma_cap_mask_t mask;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	drv_data->dummy = devm_kzalloc(&drv_data->pdev->dev, SZ_2K, GFP_KERNEL);
+	if (!drv_data->dummy)
+		return -ENOMEM;
+
+	drv_data->tx_chan = dma_request_channel(mask, dma_filter, pdata);
+	if (!drv_data->tx_chan)
+		return -ENODEV;
+
+	drv_data->rx_chan = dma_request_channel(mask, dma_filter, pdata);
+	if (!drv_data->rx_chan) {
+		dma_release_channel(drv_data->tx_chan);
+		drv_data->tx_chan = NULL;
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 static void dma_release(struct driver_data *drv_data)
 {
+	if (drv_data->rx_chan) {
+		dmaengine_terminate_all(drv_data->rx_chan);
+		dma_release_channel(drv_data->rx_chan);
+		sg_free_table(&drv_data->rx_sgt);
+		drv_data->rx_chan = NULL;
+	}
+	if (drv_data->tx_chan) {
+		dmaengine_terminate_all(drv_data->tx_chan);
+		dma_release_channel(drv_data->tx_chan);
+		sg_free_table(&drv_data->tx_sgt);
+		drv_data->tx_chan = NULL;
+	}
 }
 
 static inline void dma_resume(struct driver_data *drv_data) {}
@@ -908,7 +1234,18 @@ static int set_dma_burst_and_threshold(struct chip_data *chip,
 				u8 bits_per_word, u32 *burst_code,
 				u32 *threshold)
 {
-	return -ENODEV;
+	struct pxa2xx_spi_chip *chip_info = spi->controller_data;
+
+	/*
+	 * If the DMA burst size is given in chip_info we use that,
+	 * otherwise we use the default. Also we use the default FIFO
+	 * thresholds for now.
+	 */
+	*burst_code = chip_info ? chip_info->dma_burst_size : 16;
+	*threshold = SSCR1_RxTresh(RX_THRESH_DFLT)
+		   | SSCR1_TxTresh(TX_THRESH_DFLT);
+
+	return 0;
 }
 #endif
 
@@ -1558,7 +1895,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		drv_data->mask_sr = SSSR_RFS | SSSR_TFS | SSSR_ROR;
 	} else {
 		drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE | SSCR1_TINTE;
-		drv_data->dma_cr1 = SSCR1_TSRE | SSCR1_RSRE | SSCR1_TINTE;
+		drv_data->dma_cr1 = DEFAULT_DMA_CR1;
 		drv_data->clear_sr = SSSR_ROR | SSSR_TINT;
 		drv_data->mask_sr = SSSR_TINT | SSSR_RFS | SSSR_TFS | SSSR_ROR;
 	}
diff --git a/include/linux/spi/pxa2xx_spi.h b/include/linux/spi/pxa2xx_spi.h
index 9f8cd03..6621a06 100644
--- a/include/linux/spi/pxa2xx_spi.h
+++ b/include/linux/spi/pxa2xx_spi.h
@@ -29,6 +29,12 @@ struct pxa2xx_spi_master {
 	u16 num_chipselect;
 	u8 enable_dma;
 
+	/* DMA engine specific config */
+	int rx_chan_id;
+	int tx_chan_id;
+	int rx_slave_id;
+	int tx_slave_id;
+
 	/* For non-PXA arches */
 	struct ssp_device ssp;
 	unsigned long fixed_clk_rate;
-- 
1.7.10.4

