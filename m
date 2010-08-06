Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab0HFLun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:50:43 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:50638 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab0HFLuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:50:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/5] ARM: add PrimeCell generic DMA to PL022 v9
Date: Fri, 6 Aug 2010 13:50:19 +0200
Message-ID: <1281095419-15600-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the PL022 SSP/SPI driver with generic DMA engine
support using the PrimeCell DMA engine interface. Also fix up the
test code for the U300 platform.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/dummyspichip.c |    1 +
 drivers/spi/amba-pl022.c          |  523 ++++++++++++++++++++++++++++++-------
 include/linux/amba/pl022.h        |    6 +
 3 files changed, 442 insertions(+), 88 deletions(-)

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
index acd35d1..59b3948 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -27,7 +27,6 @@
 /*
  * TODO:
  * - add timeout on polled transfers
- * - add generic DMA framework support
  */
 
 #include <linux/init.h>
@@ -45,6 +44,9 @@
 #include <linux/amba/pl022.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
 
 /*
  * This macro is used to define some register default values.
@@ -381,6 +383,14 @@ struct pl022 {
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
@@ -406,7 +416,7 @@ struct chip_data {
 	u16 dmacr;
 	u16 cpsr;
 	u8 n_bytes;
-	u8 enable_dma:1;
+	bool enable_dma;
 	enum ssp_reading read;
 	enum ssp_writing write;
 	void (*cs_control) (u32 command);
@@ -762,6 +772,378 @@ static void *next_transfer(struct pl022 *pl022)
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
+	struct dma_slave_config rx_conf = {
+		.src_addr = SSP_DR(pl022->phybase),
+		.direction = DMA_FROM_DEVICE,
+		.src_maxburst = pl022->vendor->fifodepth >> 1,
+	};
+	struct dma_slave_config tx_conf = {
+		.dst_addr = SSP_DR(pl022->phybase),
+		.direction = DMA_TO_DEVICE,
+		.dst_maxburst = pl022->vendor->fifodepth >> 1,
+	};
+	unsigned int pages;
+	int ret;
+	int sglen;
+	struct dma_chan *rxchan = pl022->dma_rx_channel;
+	struct dma_chan *txchan = pl022->dma_tx_channel;
+	struct dma_async_tx_descriptor *rxdesc;
+	struct dma_async_tx_descriptor *txdesc;
+	dma_cookie_t cookie;
+
+	/* Check that the channels are available */
+	if (!rxchan || !txchan)
+		return -ENODEV;
+
+	switch (pl022->read) {
+	case READING_NULL:
+		/* Use the same as for writing */
+		rx_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
+		break;
+	case READING_U8:
+		rx_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		break;
+	case READING_U16:
+		rx_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+	case READING_U32:
+		rx_conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		break;
+	}
+
+	switch (pl022->write) {
+	case WRITING_NULL:
+		/* Use the same as for reading */
+		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_UNDEFINED;
+		break;
+	case WRITING_U8:
+		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
+		break;
+	case WRITING_U16:
+		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
+		break;
+	case WRITING_U32:
+		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;;
+		break;
+	}
+
+	/* SPI pecularity: we need to read and write the same width */
+	if (rx_conf.src_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
+		rx_conf.src_addr_width = tx_conf.dst_addr_width;
+	if (tx_conf.dst_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
+		tx_conf.dst_addr_width = rx_conf.src_addr_width;
+	BUG_ON(rx_conf.src_addr_width != tx_conf.dst_addr_width);
+
+	rxchan->device->device_control(rxchan, DMA_SLAVE_CONFIG,
+				       (unsigned long) &rx_conf);
+	txchan->device->device_control(txchan, DMA_SLAVE_CONFIG,
+				       (unsigned long) &tx_conf);
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
+	cookie = rxdesc->tx_submit(rxdesc);
+	if (dma_submit_error(cookie))
+		goto err_submit_rx;
+	cookie = txdesc->tx_submit(txdesc);
+	if (dma_submit_error(cookie))
+		goto err_submit_tx;
+	rxchan->device->device_issue_pending(rxchan);
+	txchan->device->device_issue_pending(txchan);
+
+	return 0;
+
+err_submit_tx:
+err_submit_rx:
+err_txdesc:
+	txchan->device->device_control(txchan, DMA_TERMINATE_ALL, 0);
+err_rxdesc:
+	rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL, 0);
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
+	rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL, 0);
+	txchan->device->device_control(txchan, DMA_TERMINATE_ALL, 0);
+	unmap_free_dma_scatter(pl022);
+}
+
+static void pl022_dma_remove(struct pl022 *pl022)
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
@@ -793,14 +1175,17 @@ static irqreturn_t pl022_interrupt_handler(int irq, void *dev_id)
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
@@ -895,8 +1280,8 @@ static int set_up_next_transfer(struct pl022 *pl022,
 }
 
 /**
- * pump_transfers - Tasklet function which schedules next interrupt transfer
- * when running in interrupt transfer mode.
+ * pump_transfers - Tasklet function which schedules next transfer
+ * when running in interrupt or DMA transfer mode.
  * @data: SSP driver private data structure
  *
  */
@@ -953,65 +1338,23 @@ static void pump_transfers(unsigned long data)
 	}
 	/* Flush the FIFOs and let's go! */
 	flush(pl022);
-	writew(ENABLE_ALL_INTERRUPTS, SSP_IMSC(pl022->virtbase));
-}
 
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
-
-	/* Enable target chip, set up transfer */
-	pl022->cur_chip->cs_control(SSP_CHIP_SELECT);
-	if (set_up_next_transfer(pl022, pl022->cur_transfer)) {
-		/* Error path */
-		pl022->cur_msg->state = STATE_ERROR;
-		pl022->cur_msg->status = -EIO;
-		giveback(pl022);
+	if (pl022->cur_chip->enable_dma) {
+		if (configure_dma(pl022)) {
+			dev_dbg(&pl022->adev->dev,
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
@@ -1022,15 +1365,26 @@ static void do_interrupt_transfer(void *data)
 		giveback(pl022);
 		return;
 	}
+	/* If we're using DMA, set up DMA here */
+	if (pl022->cur_chip->enable_dma) {
+		/* Configure DMA transfer */
+		if (configure_dma(pl022)) {
+			dev_dbg(&pl022->adev->dev,
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
@@ -1100,7 +1454,7 @@ static void do_polling_transfer(void *data)
  *
  * This function checks if there is any spi message in the queue that
  * needs processing and delegate control to appropriate function
- * do_polling_transfer()/do_interrupt_transfer()/do_dma_transfer()
+ * do_polling_transfer()/do_interrupt_dma_transfer()
  * based on the kind of the transfer
  *
  */
@@ -1148,10 +1502,8 @@ static void pump_messages(struct work_struct *work)
 
 	if (pl022->cur_chip->xfer_type == POLLING_TRANSFER)
 		do_polling_transfer(pl022);
-	else if (pl022->cur_chip->xfer_type == INTERRUPT_TRANSFER)
-		do_interrupt_transfer(pl022);
 	else
-		do_dma_transfer(pl022);
+		do_interrupt_dma_transfer(pl022);
 }
 
 
@@ -1466,23 +1818,6 @@ static int calculate_effective_freq(struct pl022 *pl022,
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
@@ -1549,8 +1884,6 @@ static int pl022_setup(struct spi_device *spi)
 
 		dev_dbg(&spi->dev, "allocated memory for controller data\n");
 
-		/* Pointer back to the SPI device */
-		chip_info->dev = &spi->dev;
 		/*
 		 * Set controller data default values:
 		 * Polling is supported by default
@@ -1576,6 +1909,9 @@ static int pl022_setup(struct spi_device *spi)
 			"using user supplied controller_data settings\n");
 	}
 
+	/* Pointer back to the SPI device */
+	chip_info->dev = &spi->dev;
+
 	/*
 	 * We can override with custom divisors, else we use the board
 	 * frequency setting
@@ -1634,9 +1970,8 @@ static int pl022_setup(struct spi_device *spi)
 	chip->cpsr = 0;
 	if ((chip_info->com_mode == DMA_TRANSFER)
 	    && ((pl022->master_info)->enable_dma)) {
-		chip->enable_dma = 1;
+		chip->enable_dma = true;
 		dev_dbg(&spi->dev, "DMA mode set in controller state\n");
-		status = process_dma_info(chip_info, chip);
 		if (status < 0)
 			goto err_config_params;
 		SSP_WRITE_BITS(chip->dmacr, SSP_DMA_ENABLED,
@@ -1644,7 +1979,7 @@ static int pl022_setup(struct spi_device *spi)
 		SSP_WRITE_BITS(chip->dmacr, SSP_DMA_ENABLED,
 			       SSP_DMACR_MASK_TXDMAE, 1);
 	} else {
-		chip->enable_dma = 0;
+		chip->enable_dma = false;
 		dev_dbg(&spi->dev, "DMA mode NOT set in controller state\n");
 		SSP_WRITE_BITS(chip->dmacr, SSP_DMA_DISABLED,
 			       SSP_DMACR_MASK_RXDMAE, 0);
@@ -1770,6 +2105,7 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
 	if (status)
 		goto err_no_ioregion;
 
+	pl022->phybase = adev->res.start;
 	pl022->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
 	if (pl022->virtbase == NULL) {
 		status = -ENOMEM;
@@ -1798,6 +2134,14 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
 		dev_err(&adev->dev, "probe - cannot get IRQ (%d)\n", status);
 		goto err_no_irq;
 	}
+
+	/* Get DMA channels */
+	if (platform_info->enable_dma) {
+		status = pl022_dma_probe(pl022);
+		if (status != 0)
+			goto err_no_dma;
+	}
+
 	/* Initialize and start queue */
 	status = init_queue(pl022);
 	if (status != 0) {
@@ -1824,6 +2168,8 @@ pl022_probe(struct amba_device *adev, struct amba_id *id)
  err_start_queue:
  err_init_queue:
 	destroy_queue(pl022);
+	pl022_dma_remove(pl022);
+ err_no_dma:
 	free_irq(adev->irq[0], pl022);
  err_no_irq:
 	clk_put(pl022->clk);
@@ -1854,6 +2200,7 @@ pl022_remove(struct amba_device *adev)
 		return status;
 	}
 	load_ssp_default_config(pl022);
+	pl022_dma_remove(pl022);
 	free_irq(adev->irq[0], pl022);
 	clk_disable(pl022->clk);
 	clk_put(pl022->clk);
diff --git a/include/linux/amba/pl022.h b/include/linux/amba/pl022.h
index abf26cc..db6a191 100644
--- a/include/linux/amba/pl022.h
+++ b/include/linux/amba/pl022.h
@@ -228,6 +228,7 @@ enum ssp_chip_select {
 };
 
 
+struct dma_chan;
 /**
  * struct pl022_ssp_master - device.platform_data for SPI controller devices.
  * @num_chipselect: chipselects are used to distinguish individual
@@ -235,11 +236,16 @@ enum ssp_chip_select {
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

