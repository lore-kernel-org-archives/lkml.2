Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0DGXOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:14:48 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65530 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756424Ab0DGXOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:14:44 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 09/11] ARM: add PrimeCell generic DMA to PL022 v5
Date: Thu,  8 Apr 2010 01:14:11 +0200
Message-Id: <1270682051-7058-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the PL022 UART driver with generic DMA engine support
using the PrimeCell DMA engine interface. Also fix up the test
code for the U300 platform.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/dummyspichip.c |    1 +
 drivers/spi/amba-pl022.c          |  517 +++++++++++++++++++++++++++++++------
 include/linux/amba/pl022.h        |    6 +
 3 files changed, 438 insertions(+), 86 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c b/arch/arm/mach-u300/dummyspichip.c
index 5f55012..5672189 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -268,6 +268,7 @@ static struct spi_driver pl022_dummy_driver = {
 	.driver = {
 		.name	= "spi-dummy",
 		.owner	= THIS_MODULE,
+		.bus = &spi_bus_type,
 	},
 	.probe	= pl022_dummy_probe,
 	.remove	= __devexit_p(pl022_dummy_remove),
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index e9aeee1..09a701c 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -27,7 +27,6 @@
 /*
  * TODO:
  * - add timeout on polled transfers
- * - add generic DMA framework support
  */
 
 #include <linux/init.h>
@@ -45,6 +44,10 @@
 #include <linux/amba/pl022.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/amba/dma.h>
 
 /*
  * This macro is used to define some register default values.
@@ -365,6 +368,14 @@ struct pl022 {
 	enum ssp_reading		read;
 	enum ssp_writing		write;
 	u32				exp_fifo_level;
+	/* DMA settings */
+#ifdef CONFIG_DMADEVICES
+	struct dma_chan			*dma_rx_channel;
+	struct dma_chan			*dma_tx_channel;
+	struct sg_table			sgt_rx;
+	struct sg_table			sgt_tx;
+	char				*dummypage;
+#endif
 };
 
 /**
@@ -699,6 +710,367 @@ static void *next_transfer(struct pl022 *pl022)
 	}
 	return STATE_DONE;
 }
+
+/*
+ * This DMA functionality is only compiled in if we have
+ * access to the generic DMA devices/DMA engine.
+ */
+#ifdef CONFIG_DMADEVICES
+static void unmap_free_dma_scatter(struct pl022 *pl022)
+{
+	/* Unmap and free the SG tables */
+	dma_unmap_sg(&pl022->adev->dev, pl022->sgt_tx.sgl,
+		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
+	dma_unmap_sg(&pl022->adev->dev, pl022->sgt_rx.sgl,
+		     pl022->sgt_rx.nents, DMA_FROM_DEVICE);
+	sg_free_table(&pl022->sgt_rx);
+	sg_free_table(&pl022->sgt_tx);
+}
+
+static void dma_callback(void *data)
+{
+	struct pl022 *pl022 = data;
+	struct spi_message *msg = pl022->cur_msg;
+
+	/* Sync in RX buffer to CPU */
+	BUG_ON(!pl022->sgt_rx.sgl);
+	dma_sync_sg_for_cpu(&pl022->adev->dev,
+			    pl022->sgt_rx.sgl,
+			    pl022->sgt_rx.nents,
+			    DMA_FROM_DEVICE);
+
+#ifdef VERBOSE_DEBUG
+	/*
+	 * Optionally dump out buffers to inspect contents, this is
+	 * good if you want to convince yourself that the loopback
+	 * read/write contents are the same, when adopting to a new
+	 * DMA engine.
+	 */
+	{
+		struct scatterlist *sg;
+		unsigned int i;
+
+		for_each_sg(pl022->sgt_rx.sgl, sg, pl022->sgt_rx.nents, i) {
+			dev_dbg(&pl022->adev->dev, "SPI RX SG ENTRY: %d", i);
+			print_hex_dump(KERN_ERR, "SPI RX: ",
+				       DUMP_PREFIX_OFFSET,
+				       16,
+				       1,
+				       sg_virt(sg),
+				       sg_dma_len(sg),
+				       1);
+		}
+		for_each_sg(pl022->sgt_tx.sgl, sg, pl022->sgt_tx.nents, i) {
+			dev_dbg(&pl022->adev->dev, "SPI TX SG ENTRY: %d", i);
+			print_hex_dump(KERN_ERR, "SPI TX: ",
+				       DUMP_PREFIX_OFFSET,
+				       16,
+				       1,
+				       sg_virt(sg),
+				       sg_dma_len(sg),
+				       1);
+		}
+	}
+#endif
+
+	unmap_free_dma_scatter(pl022);
+
+	/* Update total bytes transfered */
+	msg->actual_length += pl022->cur_transfer->len;
+	if (pl022->cur_transfer->cs_change)
+		pl022->cur_chip->
+			cs_control(SSP_CHIP_DESELECT);
+
+	/* Move to next transfer */
+	msg->state = next_transfer(pl022);
+	tasklet_schedule(&pl022->pump_transfers);
+}
+
+static void setup_dma_scatter(struct pl022 *pl022,
+			      void *buffer,
+			      unsigned int length,
+			      struct sg_table *sgtab)
+{
+	struct scatterlist *sg;
+	int bytesleft = length;
+	void *bufp = buffer;
+	int mapbytes;
+	int i;
+
+	if (buffer) {
+		for_each_sg(sgtab->sgl, sg, sgtab->nents, i) {
+			/*
+			 * If there are less bytes left than what fits
+			 * in the current page (plus page alignment offset)
+			 * we just feed in this, else we stuff in as much
+			 * as we can.
+			 */
+			if (bytesleft < (PAGE_SIZE - offset_in_page(bufp)))
+				mapbytes = bytesleft;
+			else
+				mapbytes = PAGE_SIZE - offset_in_page(bufp);
+			sg_set_page(sg, virt_to_page(bufp),
+				    mapbytes, offset_in_page(bufp));
+			bufp += mapbytes;
+			bytesleft -= mapbytes;
+			dev_dbg(&pl022->adev->dev,
+				"set RX/TX target page @ %p, %d bytes, %d left\n",
+				bufp, mapbytes, bytesleft);
+		}
+	} else {
+		/* Map the dummy buffer on every page */
+		for_each_sg(sgtab->sgl, sg, sgtab->nents, i) {
+			if (bytesleft < PAGE_SIZE)
+				mapbytes = bytesleft;
+			else
+				mapbytes = PAGE_SIZE;
+			sg_set_page(sg, virt_to_page(pl022->dummypage),
+				    mapbytes, 0);
+			bytesleft -= mapbytes;
+			dev_dbg(&pl022->adev->dev,
+				"set RX/TX to dummy page %d bytes, %d left\n",
+				mapbytes, bytesleft);
+
+		}
+	}
+	BUG_ON(bytesleft);
+}
+
+/**
+ * configure_dma - configures the channels for the next transfer
+ * @data: SSP driver's private data structure
+ *
+ */
+static int configure_dma(struct pl022 *pl022)
+{
+	struct amba_dma_channel_config rx_conf = {
+		.addr = SSP_DR(pl022->phybase),
+		.direction = DMA_FROM_DEVICE,
+		.maxburst = pl022->vendor->fifodepth >> 1,
+	};
+	struct amba_dma_channel_config tx_conf = {
+		.addr = SSP_DR(pl022->phybase),
+		.direction = DMA_TO_DEVICE,
+		.maxburst = pl022->vendor->fifodepth >> 1,
+	};
+	unsigned int pages;
+	int ret;
+	int sglen;
+	struct dma_chan *rxchan = pl022->dma_rx_channel;
+	struct dma_chan *txchan = pl022->dma_tx_channel;
+	struct dma_async_tx_descriptor *rxdesc;
+	struct dma_async_tx_descriptor *txdesc;
+
+	/* Check that the channels are available */
+	if (!rxchan || !txchan)
+		return -ENODEV;
+
+	switch (pl022->read) {
+	case READING_NULL:
+		/* Use the same as for writing */
+		rx_conf.addr_width = 0;
+		break;
+	case READING_U8:
+		rx_conf.addr_width = 1;
+		break;
+	case READING_U16:
+		rx_conf.addr_width = 2;
+		break;
+	case READING_U32:
+		rx_conf.addr_width = 4;
+		break;
+	}
+
+	switch (pl022->write) {
+	case WRITING_NULL:
+		/* Use the same as for reading */
+		tx_conf.addr_width = 0;
+		break;
+	case WRITING_U8:
+		tx_conf.addr_width = 1;
+		break;
+	case WRITING_U16:
+		tx_conf.addr_width = 2;
+		break;
+	case WRITING_U32:
+		tx_conf.addr_width = 4;
+		break;
+	}
+
+	/* SPI pecularity: we need to read and write the same width */
+	if (rx_conf.addr_width == 0)
+		rx_conf.addr_width = tx_conf.addr_width;
+	if (tx_conf.addr_width == 0)
+		tx_conf.addr_width = rx_conf.addr_width;
+	BUG_ON(rx_conf.addr_width != tx_conf.addr_width);
+
+	dma_set_ambaconfig(pl022->dma_rx_channel, &rx_conf);
+	dma_set_ambaconfig(pl022->dma_tx_channel, &tx_conf);
+
+	/* Create sglists for the transfers */
+	pages = (pl022->cur_transfer->len >> PAGE_SHIFT) + 1;
+	dev_dbg(&pl022->adev->dev, "using %d pages for transfer\n", pages);
+
+	ret = sg_alloc_table(&pl022->sgt_rx, pages, GFP_KERNEL);
+	if (ret)
+		goto err_alloc_rx_sg;
+
+	ret = sg_alloc_table(&pl022->sgt_tx, pages, GFP_KERNEL);
+	if (ret)
+		goto err_alloc_tx_sg;
+
+	/* Fill in the scatterlists for the RX+TX buffers */
+	setup_dma_scatter(pl022, pl022->rx,
+			  pl022->cur_transfer->len, &pl022->sgt_rx);
+	setup_dma_scatter(pl022, pl022->tx,
+			  pl022->cur_transfer->len, &pl022->sgt_tx);
+
+	/* Map DMA buffers */
+	sglen = dma_map_sg(&pl022->adev->dev, pl022->sgt_rx.sgl,
+			   pl022->sgt_rx.nents, DMA_FROM_DEVICE);
+	if (sglen != pages)
+		goto err_rx_sgmap;
+
+	sglen = dma_map_sg(&pl022->adev->dev, pl022->sgt_tx.sgl,
+			   pl022->sgt_tx.nents, DMA_TO_DEVICE);
+	if (sglen != pages)
+		goto err_tx_sgmap;
+
+	/* Synchronize the TX scatterlist, invalidate buffers, caches etc */
+	dma_sync_sg_for_device(&pl022->adev->dev,
+			       pl022->sgt_tx.sgl,
+			       pl022->sgt_tx.nents,
+			       DMA_TO_DEVICE);
+
+	/* Send both scatterlists */
+	rxdesc = rxchan->device->device_prep_slave_sg(rxchan,
+				      pl022->sgt_rx.sgl,
+				      pl022->sgt_rx.nents,
+				      DMA_FROM_DEVICE,
+				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!rxdesc)
+		goto err_rxdesc;
+
+	txdesc = txchan->device->device_prep_slave_sg(txchan,
+				      pl022->sgt_tx.sgl,
+				      pl022->sgt_tx.nents,
+				      DMA_TO_DEVICE,
+				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!txdesc)
+		goto err_txdesc;
+
+	/* Put the callback on the RX transfer only, that should finish last */
+	rxdesc->callback = dma_callback;
+	rxdesc->callback_param = pl022;
+
+	/* Submit and fire RX and TX with TX last so we're ready to read! */
+	rxdesc->tx_submit(rxdesc);
+	txdesc->tx_submit(txdesc);
+	rxchan->device->device_issue_pending(rxchan);
+	txchan->device->device_issue_pending(txchan);
+
+	return 0;
+
+err_txdesc:
+err_rxdesc:
+	dma_unmap_sg(&pl022->adev->dev, pl022->sgt_tx.sgl,
+		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
+err_tx_sgmap:
+	dma_unmap_sg(&pl022->adev->dev, pl022->sgt_rx.sgl,
+		     pl022->sgt_tx.nents, DMA_FROM_DEVICE);
+err_rx_sgmap:
+	sg_free_table(&pl022->sgt_tx);
+err_alloc_tx_sg:
+	sg_free_table(&pl022->sgt_rx);
+err_alloc_rx_sg:
+	return -ENOMEM;
+}
+
+static int __init pl022_dma_probe(struct pl022 *pl022)
+{
+	dma_cap_mask_t mask;
+
+	/* Try to acquire a generic DMA engine slave channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	/*
+	 * We need both RX and TX channels to do DMA, else do none
+	 * of them.
+	 */
+	pl022->dma_rx_channel = dma_request_channel(mask,
+					    pl022->master_info->dma_filter,
+					    pl022->master_info->dma_rx_param);
+	if (!pl022->dma_rx_channel) {
+		dev_err(&pl022->adev->dev, "no RX DMA channel!\n");
+		goto err_no_rxchan;
+	}
+
+	pl022->dma_tx_channel = dma_request_channel(mask,
+					    pl022->master_info->dma_filter,
+					    pl022->master_info->dma_tx_param);
+	if (!pl022->dma_tx_channel) {
+		dev_err(&pl022->adev->dev, "no TX DMA channel!\n");
+		goto err_no_txchan;
+	}
+
+	pl022->dummypage = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!pl022->dummypage) {
+		dev_err(&pl022->adev->dev, "no DMA dummypage!\n");
+		goto err_no_dummypage;
+	}
+
+	dev_info(&pl022->adev->dev, "setup for DMA on RX %s, TX %s\n",
+		 dma_chan_name(pl022->dma_rx_channel),
+		 dma_chan_name(pl022->dma_tx_channel));
+
+	return 0;
+
+err_no_dummypage:
+	dma_release_channel(pl022->dma_tx_channel);
+err_no_txchan:
+	dma_release_channel(pl022->dma_rx_channel);
+	pl022->dma_rx_channel = NULL;
+err_no_rxchan:
+	return -ENODEV;
+}
+
+static void terminate_dma(struct pl022 *pl022)
+{
+	struct dma_chan *rxchan = pl022->dma_rx_channel;
+	struct dma_chan *txchan = pl022->dma_tx_channel;
+
+	rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL);
+	txchan->device->device_control(txchan, DMA_TERMINATE_ALL);
+	unmap_free_dma_scatter(pl022);
+}
+
+static void inline pl022_dma_remove(struct pl022 *pl022)
+{
+	if (pl022->busy)
+		terminate_dma(pl022);
+	if (pl022->dma_tx_channel)
+		dma_release_channel(pl022->dma_tx_channel);
+	if (pl022->dma_rx_channel)
+		dma_release_channel(pl022->dma_rx_channel);
+	kfree(pl022->dummypage);
+}
+
+#else
+static inline int configure_dma(struct pl022 *pl022)
+{
+	return -ENODEV;
+}
+
+static inline int pl022_dma_probe(struct pl022 *pl022)
+{
+	return 0;
+}
+
+static inline void pl022_dma_remove(struct pl022 *pl022)
+{
+}
+#endif
+
 /**
  * pl022_interrupt_handler - Interrupt handler for SSP controller
  *
@@ -724,20 +1096,34 @@ static irqreturn_t pl022_interrupt_handler(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
+	/*
+	 * In DMA mode, this interrupt handler is only
+	 * used for handling error conditions.
+	 */
+	if (unlikely(pl022->cur_chip->enable_dma)) {
+		dev_err(&pl022->adev->dev,
+			"stray interrupt in DMA mode (0x%08x)", irq_status);
+		writew(CLEAR_ALL_INTERRUPTS, SSP_ICR(pl022->virtbase));
+		return IRQ_HANDLED;
+	}
+
 	/* Read the Interrupt Status Register */
 	irq_status = readw(SSP_MIS(pl022->virtbase));
 
 	if (unlikely(!irq_status))
 		return IRQ_NONE;
 
-	/* This handles the error code interrupts */
+	/*
+	 * This handles the FIFO interrupts, the timeout
+	 * interrupts are flatly ignored, they cannot be
+	 * trusted.
+	 */
 	if (unlikely(irq_status & SSP_MIS_MASK_RORMIS)) {
 		/*
 		 * Overrun interrupt - bail out since our Data has been
 		 * corrupted
 		 */
-		dev_err(&pl022->adev->dev,
-			"FIFO overrun\n");
+		dev_err(&pl022->adev->dev, "FIFO overrun\n");
 		if (readw(SSP_SR(pl022->virtbase)) & SSP_SR_MASK_RFF)
 			dev_err(&pl022->adev->dev,
 				"RXFIFO is full\n");
@@ -832,8 +1218,8 @@ static int set_up_next_transfer(struct pl022 *pl022,
 }
 
 /**
- * pump_transfers - Tasklet function which schedules next interrupt transfer
- * when running in interrupt transfer mode.
+ * pump_transfers - Tasklet function which schedules next transfer
+ * when running in interrupt or DMA transfer mode.
  * @data: SSP driver private data structure
  *
  */
@@ -890,65 +1276,23 @@ static void pump_transfers(unsigned long data)
 	}
 	/* Flush the FIFOs and let's go! */
 	flush(pl022);
-	writew(ENABLE_ALL_INTERRUPTS, SSP_IMSC(pl022->virtbase));
-}
-
-/**
- * NOT IMPLEMENTED
- * configure_dma - It configures the DMA pipes for DMA transfers
- * @data: SSP driver's private data structure
- *
- */
-static int configure_dma(void *data)
-{
-	struct pl022 *pl022 = data;
-	dev_dbg(&pl022->adev->dev, "configure DMA\n");
-	return -ENOTSUPP;
-}
-
-/**
- * do_dma_transfer - It handles transfers of the current message
- * if it is DMA xfer.
- * NOT FULLY IMPLEMENTED
- * @data: SSP driver's private data structure
- */
-static void do_dma_transfer(void *data)
-{
-	struct pl022 *pl022 = data;
-
-	if (configure_dma(data)) {
-		dev_dbg(&pl022->adev->dev, "configuration of DMA Failed!\n");
-		goto err_config_dma;
-	}
-
-	/* TODO: Implememt DMA setup of pipes here */
 
-	/* Enable target chip, set up transfer */
-	pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
-	if (set_up_next_transfer(pl022, pl022->cur_transfer)) {
-		/* Error path */
-		pl022->cur_msg->state = STATE_ERROR;
-		pl022->cur_msg->status = -EIO;
-		giveback(pl022);
+	if (pl022->cur_chip->enable_dma) {
+		if (configure_dma(pl022)) {
+			dev_err(&pl022->adev->dev,
+				"configuration of DMA failed, fall back to interrupt mode\n");
+			goto err_config_dma;
+		}
 		return;
 	}
-	/* Enable SSP */
-	writew((readw(SSP_CR1(pl022->virtbase)) | SSP_CR1_MASK_SSE),
-	       SSP_CR1(pl022->virtbase));
-
-	/* TODO: Enable the DMA transfer here */
-	return;
 
- err_config_dma:
-	pl022->cur_msg->state = STATE_ERROR;
-	pl022->cur_msg->status = -EIO;
-	giveback(pl022);
-	return;
+err_config_dma:
+	writew(ENABLE_ALL_INTERRUPTS, SSP_IMSC(pl022->virtbase));
 }
 
-static void do_interrupt_transfer(void *data)
+static void do_interrupt_dma_transfer(struct pl022 *pl022)
 {
-	struct pl022 *pl022 = data;
+	u32 irqflags = ENABLE_ALL_INTERRUPTS;
 
 	/* Enable target chip */
 	pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
@@ -959,15 +1303,26 @@ static void do_interrupt_transfer(void *data)
 		giveback(pl022);
 		return;
 	}
+	/* If we're using DMA, set up DMA here */
+	if (pl022->cur_chip->enable_dma) {
+		/* Configure DMA transfer */
+		if (configure_dma(pl022)) {
+			dev_err(&pl022->adev->dev,
+				"configuration of DMA failed, fall back to interrupt mode\n");
+			goto err_config_dma;
+		}
+		/* Disable interrupts in DMA mode, IRQ from DMA controller */
+		irqflags = DISABLE_ALL_INTERRUPTS;
+	}
+err_config_dma:
 	/* Enable SSP, turn on interrupts */
 	writew((readw(SSP_CR1(pl022->virtbase)) | SSP_CR1_MASK_SSE),
 	       SSP_CR1(pl022->virtbase));
-	writew(ENABLE_ALL_INTERRUPTS, SSP_IMSC(pl022->virtbase));
+	writew(irqflags, SSP_IMSC(pl022->virtbase));
 }
 
-static void do_polling_transfer(void *data)
+static void do_polling_transfer(struct pl022 *pl022)
 {
-	struct pl022 *pl022 = data;
 	struct spi_message *message = NULL;
 	struct spi_transfer *transfer = NULL;
 	struct spi_transfer *previous = NULL;
@@ -1037,7 +1392,7 @@ static void do_polling_transfer(void *data)
  *
  * This function checks if there is any spi message in the queue that
  * needs processing and delegate control to appropriate function
- * do_polling_transfer()/do_interrupt_transfer()/do_dma_transfer()
+ * do_polling_transfer()/do_interrupt_dma_transfer()
  * based on the kind of the transfer
  *
  */
@@ -1085,10 +1440,8 @@ static void pump_messages(struct work_struct *work)
 
 	if (pl022->cur_chip->xfer_type == POLLING_TRANSFER)
 		do_polling_transfer(pl022);
-	else if (pl022->cur_chip->xfer_type == INTERRUPT_TRANSFER)
-		do_interrupt_transfer(pl022);
 	else
-		do_dma_transfer(pl022);
+		do_interrupt_dma_transfer(pl022);
 }
 
 
@@ -1393,23 +1746,6 @@ static int calculate_effective_freq(struct pl022 *pl022,
 }
 
 /**
- * NOT IMPLEMENTED
- * process_dma_info - Processes the DMA info provided by client drivers
- * @chip_info: chip info provided by client device
- * @chip: Runtime state maintained by the SSP controller for each spi device
- *
- * This function processes and stores DMA config provided by client driver
- * into the runtime state maintained by the SSP controller driver
- */
-static int process_dma_info(struct pl022_config_chip *chip_info,
-			    struct chip_data *chip)
-{
-	dev_err(chip_info->dev,
-		"cannot process DMA info, DMA not implemented!\n");
-	return -ENOTSUPP;
-}
-
-/**
  * pl022_setup - setup function registered to SPI master framework
  * @spi: spi device which is requesting setup
  *
@@ -1563,7 +1899,6 @@ static int pl022_setup(struct spi_device *spi)
 	    && ((pl022->master_info)->enable_dma)) {
 		chip->enable_dma = 1;
 		dev_dbg(&spi->dev, "DMA mode set in controller state\n");
-		status = process_dma_info(chip_info, chip);
 		if (status < 0)
 			goto err_config_params;
 		SSP_WRITE_BITS(chip->dmacr, SSP_DMA_ENABLED,
@@ -1623,7 +1958,7 @@ static void pl022_cleanup(struct spi_device *spi)
 }
 
 
-static int __init
+static int __devinit
 pl022_probe(struct amba_device *adev, struct amba_id *id)
 {
 	struct device *dev = &adev->dev;
@@ -1670,6 +2005,7 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
 	if (status)
 		goto err_no_ioregion;
 
+	pl022->phybase = adev->res.start;
 	pl022->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
 	if (pl022->virtbase == NULL) {
 		status = -ENOMEM;
@@ -1698,6 +2034,12 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
 		dev_err(&adev->dev, "probe - cannot get IRQ (%d)\n", status);
 		goto err_no_irq;
 	}
+
+	/* Get DMA channels */
+	status = pl022_dma_probe(pl022);
+	if (status != 0)
+		goto err_no_dma;
+
 	/* Initialize and start queue */
 	status = init_queue(pl022);
 	if (status != 0) {
@@ -1724,6 +2066,8 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
  err_start_queue:
  err_init_queue:
 	destroy_queue(pl022);
+	pl022_dma_remove(pl022);
+ err_no_dma:
 	free_irq(adev->irq[0], pl022);
  err_no_irq:
 	clk_put(pl022->clk);
@@ -1738,7 +2082,7 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
 	return status;
 }
 
-static int __exit
+static int __devexit
 pl022_remove(struct amba_device *adev)
 {
 	struct pl022 *pl022 = amba_get_drvdata(adev);
@@ -1754,6 +2098,7 @@ pl022_remove(struct amba_device *adev)
 		return status;
 	}
 	load_ssp_default_config(pl022);
+	pl022_dma_remove(pl022);
 	free_irq(adev->irq[0], pl022);
 	clk_disable(pl022->clk);
 	clk_put(pl022->clk);
@@ -1846,7 +2191,7 @@ static struct amba_driver pl022_driver = {
 	},
 	.id_table	= pl022_ids,
 	.probe		= pl022_probe,
-	.remove		= __exit_p(pl022_remove),
+	.remove		= __devexit_p(pl022_remove),
 	.suspend        = pl022_suspend,
 	.resume         = pl022_resume,
 };
diff --git a/include/linux/amba/pl022.h b/include/linux/amba/pl022.h
index e4836c6..95f8d17 100644
--- a/include/linux/amba/pl022.h
+++ b/include/linux/amba/pl022.h
@@ -201,6 +201,7 @@ enum ssp_chip_select {
 };
 
 
+struct dma_chan;
 /**
  * struct pl022_ssp_master - device.platform_data for SPI controller devices.
  * @num_chipselect: chipselects are used to distinguish individual
@@ -208,11 +209,16 @@ enum ssp_chip_select {
  *     each slave has a chipselect signal, but it's common that not
  *     every chipselect is connected to a slave.
  * @enable_dma: if true enables DMA driven transfers.
+ * @dma_rx_param: parameter to locate an RX DMA channel.
+ * @dma_tx_param: parameter to locate a TX DMA channel.
  */
 struct pl022_ssp_controller {
 	u16 bus_id;
 	u8 num_chipselect;
 	u8 enable_dma:1;
+	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
+	void *dma_rx_param;
+	void *dma_tx_param;
 };
 
 /**
-- 
1.6.3.3

