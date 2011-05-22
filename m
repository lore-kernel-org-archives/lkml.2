Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1EVRGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 13:06:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37414 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1EVRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 13:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=u9tEZI5S1aop4qpD3/SDQiPiYbLrfzl7LIE5cVuXRNI4hXSq0iNTOjlDbRWmWuxdAU
         jrN3a0kAzqKRV92dSY3NGzDd++QI6fg2GZIYZ93ASFntEZTlL9k4R7DiIF5MnDoM5OB6
         DF++PUrWSYfoiESadC5I+zXoVcMsPN6Z3V0Ak=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: hsweeten@visionengravers.com, ryan@bluewatersys.com,
        linux-kernel@vger.kernel.org, Mika Westerberg <mika.westerberg@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 5/5] spi/ep93xx: add DMA support
Date: Sun, 22 May 2011 20:03:08 +0300
Message-Id: <f05f92e531fdb613657bc16c8fd4a2f8653ece55.1306082097.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1306082097.git.mika.westerberg@iki.fi>
References: <cover.1306082097.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMA support for the EP93xx SPI driver. By default the DMA is
not enabled but it can be enabled by setting ep93xx_spi_info.use_dma to true
in board configuration file.

Note that the SPI driver still uses PIO for small transfers (<= 8 bytes) for
performance reasons.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/spi/ep93xx_spi                   |   10 +
 arch/arm/mach-ep93xx/core.c                    |    6 +-
 arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
 drivers/spi/ep93xx_spi.c                       |  303 +++++++++++++++++++++++-
 4 files changed, 308 insertions(+), 13 deletions(-)

diff --git a/Documentation/spi/ep93xx_spi b/Documentation/spi/ep93xx_spi
index 6325f5b..fc43818 100644
--- a/Documentation/spi/ep93xx_spi
+++ b/Documentation/spi/ep93xx_spi
@@ -88,6 +88,16 @@ static void __init ts72xx_init_machine(void)
 			    ARRAY_SIZE(ts72xx_spi_devices));
 }
 
+The driver can use DMA for the transfers also. In this case ts72xx_spi_info
+becomes:
+
+static struct ep93xx_spi_info ts72xx_spi_info = {
+	.num_chipselect	= ARRAY_SIZE(ts72xx_spi_devices),
+	.use_dma	= true;
+};
+
+Note that CONFIG_DMA_ENGINE and CONFIG_EP93XX_DMA should be enabled as well.
+
 Thanks to
 =========
 Martin Guy, H. Hartley Sweeten and others who helped me during development of
diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
index 8207954..cc9f1d4 100644
--- a/arch/arm/mach-ep93xx/core.c
+++ b/arch/arm/mach-ep93xx/core.c
@@ -488,11 +488,15 @@ static struct resource ep93xx_spi_resources[] = {
 	},
 };
 
+static u64 ep93xx_spi_dma_mask = DMA_BIT_MASK(32);
+
 static struct platform_device ep93xx_spi_device = {
 	.name		= "ep93xx-spi",
 	.id		= 0,
 	.dev		= {
-		.platform_data = &ep93xx_spi_master_data,
+		.platform_data		= &ep93xx_spi_master_data,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.dma_mask		= &ep93xx_spi_dma_mask,
 	},
 	.num_resources	= ARRAY_SIZE(ep93xx_spi_resources),
 	.resource	= ep93xx_spi_resources,
diff --git a/arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h b/arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h
index 0a37961..9bb63ac 100644
--- a/arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h
+++ b/arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h
@@ -7,9 +7,11 @@ struct spi_device;
  * struct ep93xx_spi_info - EP93xx specific SPI descriptor
  * @num_chipselect: number of chip selects on this board, must be
  *                  at least one
+ * @use_dma: use DMA for the transfers
  */
 struct ep93xx_spi_info {
 	int	num_chipselect;
+	bool	use_dma;
 };
 
 /**
diff --git a/drivers/spi/ep93xx_spi.c b/drivers/spi/ep93xx_spi.c
index d357007..1cf6454 100644
--- a/drivers/spi/ep93xx_spi.c
+++ b/drivers/spi/ep93xx_spi.c
@@ -1,7 +1,7 @@
 /*
  * Driver for Cirrus Logic EP93xx SPI controller.
  *
- * Copyright (c) 2010 Mika Westerberg
+ * Copyright (C) 2010-2011 Mika Westerberg
  *
  * Explicit FIFO handling code was inspired by amba-pl022 driver.
  *
@@ -21,13 +21,16 @@
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/dmaengine.h>
 #include <linux/bitops.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/scatterlist.h>
 #include <linux/spi/spi.h>
 
+#include <mach/dma.h>
 #include <mach/ep93xx_spi.h>
 
 #define SSPCR0			0x0000
@@ -71,6 +74,7 @@
  * @pdev: pointer to platform device
  * @clk: clock for the controller
  * @regs_base: pointer to ioremap()'d registers
+ * @sspdr_phys: physical address of the SSPDR register
  * @irq: IRQ number used by the driver
  * @min_rate: minimum clock rate (in Hz) supported by the controller
  * @max_rate: maximum clock rate (in Hz) supported by the controller
@@ -84,6 +88,14 @@
  * @rx: current byte in transfer to receive
  * @fifo_level: how full is FIFO (%0..%SPI_FIFO_SIZE - %1). Receiving one
  *              frame decreases this level and sending one frame increases it.
+ * @dma_rx: RX DMA channel
+ * @dma_tx: TX DMA channel
+ * @dma_rx_data: RX parameters passed to the DMA engine
+ * @dma_tx_data: TX parameters passed to the DMA engine
+ * @rx_sgt: sg table for RX transfers
+ * @tx_sgt: sg table for TX transfers
+ * @zeropage: dummy page used as RX buffer when only TX buffer is passed in by
+ *            the client
  *
  * This structure holds EP93xx SPI controller specific information. When
  * @running is %true, driver accepts transfer requests from protocol drivers.
@@ -100,6 +112,7 @@ struct ep93xx_spi {
 	const struct platform_device	*pdev;
 	struct clk			*clk;
 	void __iomem			*regs_base;
+	unsigned long			sspdr_phys;
 	int				irq;
 	unsigned long			min_rate;
 	unsigned long			max_rate;
@@ -112,6 +125,13 @@ struct ep93xx_spi {
 	size_t				tx;
 	size_t				rx;
 	size_t				fifo_level;
+	struct dma_chan			*dma_rx;
+	struct dma_chan			*dma_tx;
+	struct ep93xx_dma_data		dma_rx_data;
+	struct ep93xx_dma_data		dma_tx_data;
+	struct sg_table			rx_sgt;
+	struct sg_table			tx_sgt;
+	void				*zeropage;
 };
 
 /**
@@ -496,14 +516,195 @@ static int ep93xx_spi_read_write(struct ep93xx_spi *espi)
 		espi->fifo_level++;
 	}
 
-	if (espi->rx == t->len) {
-		msg->actual_length += t->len;
+	if (espi->rx == t->len)
 		return 0;
-	}
 
 	return -EINPROGRESS;
 }
 
+static void ep93xx_spi_pio_transfer(struct ep93xx_spi *espi)
+{
+	/*
+	 * Now everything is set up for the current transfer. We prime the TX
+	 * FIFO, enable interrupts, and wait for the transfer to complete.
+	 */
+	if (ep93xx_spi_read_write(espi)) {
+		ep93xx_spi_enable_interrupts(espi);
+		wait_for_completion(&espi->wait);
+	}
+}
+
+/**
+ * ep93xx_spi_dma_prepare() - prepares a DMA transfer
+ * @espi: ep93xx SPI controller struct
+ * @dir: DMA transfer direction
+ *
+ * Function configures the DMA, maps the buffer and prepares the DMA
+ * descriptor. Returns a valid DMA descriptor in case of success and ERR_PTR
+ * in case of failure.
+ */
+static struct dma_async_tx_descriptor *
+ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_data_direction dir)
+{
+	struct spi_transfer *t = espi->current_msg->state;
+	struct dma_async_tx_descriptor *txd;
+	enum dma_slave_buswidth buswidth;
+	struct dma_slave_config conf;
+	struct scatterlist *sg;
+	struct sg_table *sgt;
+	struct dma_chan *chan;
+	const void *buf, *pbuf;
+	size_t len = t->len;
+	int i, ret, nents;
+
+	if (bits_per_word(espi) > 8)
+		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
+	else
+		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
+
+	memset(&conf, 0, sizeof(conf));
+	conf.direction = dir;
+
+	if (dir == DMA_FROM_DEVICE) {
+		chan = espi->dma_rx;
+		buf = t->rx_buf;
+		sgt = &espi->rx_sgt;
+
+		conf.src_addr = espi->sspdr_phys;
+		conf.src_addr_width = buswidth;
+	} else {
+		chan = espi->dma_tx;
+		buf = t->tx_buf;
+		sgt = &espi->tx_sgt;
+
+		conf.dst_addr = espi->sspdr_phys;
+		conf.dst_addr_width = buswidth;
+	}
+
+	ret = dmaengine_slave_config(chan, &conf);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/*
+	 * We need to split the transfer into PAGE_SIZE'd chunks. This is
+	 * because we are using @espi->zeropage to provide a zero RX buffer
+	 * for the TX transfers and we have only allocated one page for that.
+	 *
+	 * For performance reasons we allocate a new sg_table only when
+	 * needed. Otherwise we will re-use the current one. Eventually the
+	 * last sg_table is released in ep93xx_spi_release_dma().
+	 */
+
+	nents = DIV_ROUND_UP(len, PAGE_SIZE);
+	if (nents != sgt->nents) {
+		sg_free_table(sgt);
+
+		ret = sg_alloc_table(sgt, nents, GFP_KERNEL);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+
+	pbuf = buf;
+	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
+		size_t bytes = min_t(size_t, len, PAGE_SIZE);
+
+		if (buf) {
+			sg_set_page(sg, virt_to_page(pbuf), bytes,
+				    offset_in_page(pbuf));
+		} else {
+			sg_set_page(sg, virt_to_page(espi->zeropage),
+				    bytes, 0);
+		}
+
+		pbuf += bytes;
+		len -= bytes;
+	}
+
+	if (WARN_ON(len)) {
+		dev_warn(&espi->pdev->dev, "len = %d expected 0!", len);
+		return ERR_PTR(-EINVAL);
+	}
+
+	nents = dma_map_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
+	if (!nents)
+		return ERR_PTR(-ENOMEM);
+
+	txd = chan->device->device_prep_slave_sg(chan, sgt->sgl, nents,
+						 dir, DMA_CTRL_ACK);
+	if (!txd) {
+		dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
+		return ERR_PTR(-ENOMEM);
+	}
+	return txd;
+}
+
+/**
+ * ep93xx_spi_dma_finish() - finishes with a DMA transfer
+ * @espi: ep93xx SPI controller struct
+ * @dir: DMA transfer direction
+ *
+ * Function finishes with the DMA transfer. After this, the DMA buffer is
+ * unmapped.
+ */
+static void ep93xx_spi_dma_finish(struct ep93xx_spi *espi,
+				  enum dma_data_direction dir)
+{
+	struct dma_chan *chan;
+	struct sg_table *sgt;
+
+	if (dir == DMA_FROM_DEVICE) {
+		chan = espi->dma_rx;
+		sgt = &espi->rx_sgt;
+	} else {
+		chan = espi->dma_tx;
+		sgt = &espi->tx_sgt;
+	}
+
+	dma_unmap_sg(chan->device->dev, sgt->sgl, sgt->nents, dir);
+}
+
+static void ep93xx_spi_dma_callback(void *callback_param)
+{
+	complete(callback_param);
+}
+
+static void ep93xx_spi_dma_transfer(struct ep93xx_spi *espi)
+{
+	struct spi_message *msg = espi->current_msg;
+	struct dma_async_tx_descriptor *rxd, *txd;
+
+	rxd = ep93xx_spi_dma_prepare(espi, DMA_FROM_DEVICE);
+	if (IS_ERR(rxd)) {
+		dev_err(&espi->pdev->dev, "DMA RX failed: %ld\n", PTR_ERR(rxd));
+		msg->status = PTR_ERR(rxd);
+		return;
+	}
+
+	txd = ep93xx_spi_dma_prepare(espi, DMA_TO_DEVICE);
+	if (IS_ERR(txd)) {
+		ep93xx_spi_dma_finish(espi, DMA_FROM_DEVICE);
+		dev_err(&espi->pdev->dev, "DMA TX failed: %ld\n", PTR_ERR(rxd));
+		msg->status = PTR_ERR(txd);
+		return;
+	}
+
+	/* We are ready when RX is done */
+	rxd->callback = ep93xx_spi_dma_callback;
+	rxd->callback_param = &espi->wait;
+
+	/* Now submit both descriptors and wait while they finish */
+	dmaengine_submit(rxd);
+	dmaengine_submit(txd);
+
+	dma_async_issue_pending(espi->dma_rx);
+	dma_async_issue_pending(espi->dma_tx);
+
+	wait_for_completion(&espi->wait);
+
+	ep93xx_spi_dma_finish(espi, DMA_TO_DEVICE);
+	ep93xx_spi_dma_finish(espi, DMA_FROM_DEVICE);
+}
+
 /**
  * ep93xx_spi_process_transfer() - processes one SPI transfer
  * @espi: ep93xx SPI controller struct
@@ -556,13 +757,14 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 	espi->tx = 0;
 
 	/*
-	 * Now everything is set up for the current transfer. We prime the TX
-	 * FIFO, enable interrupts, and wait for the transfer to complete.
+	 * There is no point of setting up DMA for the transfers which will
+	 * fit into the FIFO and can be transferred with a single interrupt.
+	 * So in these cases we will be using PIO and don't bother for DMA.
 	 */
-	if (ep93xx_spi_read_write(espi)) {
-		ep93xx_spi_enable_interrupts(espi);
-		wait_for_completion(&espi->wait);
-	}
+	if (espi->dma_rx && t->len > SPI_FIFO_SIZE)
+		ep93xx_spi_dma_transfer(espi);
+	else
+		ep93xx_spi_pio_transfer(espi);
 
 	/*
 	 * In case of error during transmit, we bail out from processing
@@ -571,6 +773,8 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
 	if (msg->status)
 		return;
 
+	msg->actual_length += t->len;
+
 	/*
 	 * After this transfer is finished, perform any possible
 	 * post-transfer actions requested by the protocol driver.
@@ -752,6 +956,75 @@ static irqreturn_t ep93xx_spi_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static bool ep93xx_spi_dma_filter(struct dma_chan *chan, void *filter_param)
+{
+	if (ep93xx_dma_chan_is_m2p(chan))
+		return false;
+
+	chan->private = filter_param;
+	return true;
+}
+
+static int ep93xx_spi_setup_dma(struct ep93xx_spi *espi)
+{
+	dma_cap_mask_t mask;
+	int ret;
+
+	espi->zeropage = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!espi->zeropage)
+		return -ENOMEM;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	espi->dma_rx_data.port = EP93XX_DMA_SSP;
+	espi->dma_rx_data.direction = DMA_FROM_DEVICE;
+	espi->dma_rx_data.name = "ep93xx-spi-rx";
+
+	espi->dma_rx = dma_request_channel(mask, ep93xx_spi_dma_filter,
+					   &espi->dma_rx_data);
+	if (!espi->dma_rx) {
+		ret = -ENODEV;
+		goto fail_free_page;
+	}
+
+	espi->dma_tx_data.port = EP93XX_DMA_SSP;
+	espi->dma_tx_data.direction = DMA_TO_DEVICE;
+	espi->dma_tx_data.name = "ep93xx-spi-tx";
+
+	espi->dma_tx = dma_request_channel(mask, ep93xx_spi_dma_filter,
+					   &espi->dma_tx_data);
+	if (!espi->dma_tx) {
+		ret = -ENODEV;
+		goto fail_release_rx;
+	}
+
+	return 0;
+
+fail_release_rx:
+	dma_release_channel(espi->dma_rx);
+	espi->dma_rx = NULL;
+fail_free_page:
+	free_page((unsigned long)espi->zeropage);
+
+	return ret;
+}
+
+static void ep93xx_spi_release_dma(struct ep93xx_spi *espi)
+{
+	if (espi->dma_rx) {
+		dma_release_channel(espi->dma_rx);
+		sg_free_table(&espi->rx_sgt);
+	}
+	if (espi->dma_tx) {
+		dma_release_channel(espi->dma_tx);
+		sg_free_table(&espi->tx_sgt);
+	}
+
+	if (espi->zeropage)
+		free_page((unsigned long)espi->zeropage);
+}
+
 static int __init ep93xx_spi_probe(struct platform_device *pdev)
 {
 	struct spi_master *master;
@@ -818,6 +1091,7 @@ static int __init ep93xx_spi_probe(struct platform_device *pdev)
 		goto fail_put_clock;
 	}
 
+	espi->sspdr_phys = res->start + SSPDR;
 	espi->regs_base = ioremap(res->start, resource_size(res));
 	if (!espi->regs_base) {
 		dev_err(&pdev->dev, "failed to map resources\n");
@@ -832,10 +1106,13 @@ static int __init ep93xx_spi_probe(struct platform_device *pdev)
 		goto fail_unmap_regs;
 	}
 
+	if (info->use_dma && ep93xx_spi_setup_dma(espi))
+		dev_warn(&pdev->dev, "DMA setup failed. Falling back to PIO\n");
+
 	espi->wq = create_singlethread_workqueue("ep93xx_spid");
 	if (!espi->wq) {
 		dev_err(&pdev->dev, "unable to create workqueue\n");
-		goto fail_free_irq;
+		goto fail_free_dma;
 	}
 	INIT_WORK(&espi->msg_work, ep93xx_spi_work);
 	INIT_LIST_HEAD(&espi->msg_queue);
@@ -857,7 +1134,8 @@ static int __init ep93xx_spi_probe(struct platform_device *pdev)
 
 fail_free_queue:
 	destroy_workqueue(espi->wq);
-fail_free_irq:
+fail_free_dma:
+	ep93xx_spi_release_dma(espi);
 	free_irq(espi->irq, espi);
 fail_unmap_regs:
 	iounmap(espi->regs_base);
@@ -901,6 +1179,7 @@ static int __exit ep93xx_spi_remove(struct platform_device *pdev)
 	}
 	spin_unlock_irq(&espi->lock);
 
+	ep93xx_spi_release_dma(espi);
 	free_irq(espi->irq, espi);
 	iounmap(espi->regs_base);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.4.4

