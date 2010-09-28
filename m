Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab0I1Oeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:34:37 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:60852 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab0I1Oee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:34:34 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/7] ARM: add PrimeCell generic DMA to PL011 v12
Date: Tue, 28 Sep 2010 16:33:56 +0200
Message-ID: <1285684441-21700-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
References: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the PL011 UART driver with generic DMA engine support
using the PrimeCell DMA engine interface.

Tested-by: Jerzy Kasenberg <jerzy.kasenberg@tieto.com>
Tested-by: Grzegorz Sygieda <grzegorz.sygieda@tieto.com>
Tested-by: Marcin Mielczarczyk <marcin.mielczarczyk@tieto.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Changes:
- Swapped ifdef conditional from CONFIG_DMADEVICES to
  CONFIG_DMA_ENGINE as is proper.
---
 drivers/serial/amba-pl011.c |  851 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/amba/serial.h |    6 +
 2 files changed, 848 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index 6ca7a44..48de812 100644
--- a/drivers/serial/amba-pl011.c
+++ b/drivers/serial/amba-pl011.c
@@ -7,6 +7,7 @@
  *
  *  Copyright 1999 ARM Limited
  *  Copyright (C) 2000 Deep Blue Solutions Ltd.
+ *  Copyright (C) 2010 ST-Ericsson SA
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -48,6 +49,11 @@
 #include <linux/amba/serial.h>
 #include <linux/clk.h>
 #include <linux/slab.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/sizes.h>
@@ -63,6 +69,24 @@
 #define UART_DR_ERROR		(UART011_DR_OE|UART011_DR_BE|UART011_DR_PE|UART011_DR_FE)
 #define UART_DUMMY_DR_RX	(1 << 16)
 
+/* Deals with DMA transactions */
+struct pl011_dma_rx_transaction {
+	struct completion complete;
+	bool use_buffer_b;
+	struct scatterlist scatter_a;
+	struct scatterlist scatter_b;
+	char *rx_dma_buf_a;
+	char *rx_dma_buf_b;
+	dma_cookie_t cookie;
+};
+
+struct pl011_dma_tx_transaction {
+	struct completion complete;
+	struct scatterlist scatter;
+	char *tx_dma_buf;
+	dma_cookie_t cookie;
+};
+
 /*
  * We wrap our port structure around the generic uart_port.
  */
@@ -76,6 +100,16 @@ struct uart_amba_port {
 	unsigned int		lcrh_rx;	/* vendor-specific */
 	bool			oversampling;   /* vendor-specific */
 	bool			autorts;
+	unsigned int		fifosize;
+	/* DMA stuff */
+	bool			enable_dma;
+	bool			rx_dma_running;
+#ifdef CONFIG_DMA_ENGINE
+	struct dma_chan		*dma_rx_channel;
+	struct dma_chan		*dma_tx_channel;
+	struct pl011_dma_rx_transaction dmarx;
+	struct pl011_dma_tx_transaction dmatx;
+#endif
 };
 
 /* There is by now at least one vendor with differing details, so handle it */
@@ -103,6 +137,725 @@ static struct vendor_data vendor_st = {
 	.oversampling		= true,
 };
 
+/*
+ * All the DMA operation mode stuff goes inside this ifdef.
+ * This assumes that you have a generic DMA device interface,
+ * no custom DMA interfaces are supported.
+ *
+ * If we had discardable probe() functions akin to
+ * platform_device_probe() in the PrimeCell/AMBA bus, we could
+ * discard most of this code after use, but since we haven't,
+ * we have to keep it all around.
+ */
+#ifdef CONFIG_DMA_ENGINE
+
+#define PL011_DMA_BUFFER_SIZE PAGE_SIZE
+
+static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
+{
+	/* DMA is the sole user of the platform data right now */
+	struct amba_pl011_data *plat = uap->port.dev->platform_data;
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+	struct dma_slave_config rx_conf = {
+		.src_addr = uap->port.mapbase + UART01x_DR,
+		.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
+		.direction = DMA_FROM_DEVICE,
+		.src_maxburst = uap->fifosize >> 1,
+	};
+	struct dma_slave_config tx_conf = {
+		.dst_addr = uap->port.mapbase + UART01x_DR,
+		.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
+		.direction = DMA_TO_DEVICE,
+		.dst_maxburst = uap->fifosize >> 1,
+	};
+	dma_cap_mask_t mask;
+	int sglen;
+
+	/* We need platform data */
+	if (!plat) {
+		dev_err(uap->port.dev, "no DMA platform data!\n");
+		return;
+	}
+
+	/* Try to acquire a generic DMA engine slave channel */
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_SLAVE, mask);
+
+	/*
+	 * We need both RX and TX channels to do DMA, else do none
+	 * of them.
+	 */
+	uap->dma_rx_channel = dma_request_channel(mask,
+						  plat->dma_filter,
+						  plat->dma_rx_param);
+	if (!uap->dma_rx_channel) {
+		dev_err(uap->port.dev, "no RX DMA channel!\n");
+		return;
+	}
+	uap->dma_rx_channel->device->device_control(uap->dma_rx_channel,
+						    DMA_SLAVE_CONFIG,
+						    (unsigned long) &rx_conf);
+
+	uap->dma_tx_channel = dma_request_channel(mask,
+						  plat->dma_filter,
+						  plat->dma_tx_param);
+	if (!uap->dma_tx_channel) {
+		dev_err(uap->port.dev, "no TX DMA channel!\n");
+		goto err_no_txchan;
+	}
+	uap->dma_tx_channel->device->device_control(uap->dma_tx_channel,
+						    DMA_SLAVE_CONFIG,
+						    (unsigned long) &tx_conf);
+
+	/* Allocate DMA RX and TX buffers */
+	dmarx->rx_dma_buf_a = kmalloc(PL011_DMA_BUFFER_SIZE, GFP_KERNEL);
+	if (!dmarx->rx_dma_buf_a) {
+		dev_err(uap->port.dev, "failed to allocate DMA RX buffer A\n");
+		goto err_no_rxbuf_a;
+	}
+
+	dmarx->rx_dma_buf_b = kmalloc(PL011_DMA_BUFFER_SIZE, GFP_KERNEL);
+	if (!dmarx->rx_dma_buf_b) {
+		dev_err(uap->port.dev, "failed to allocate DMA RX buffer B\n");
+		goto err_no_rxbuf_b;
+	}
+
+	dmatx->tx_dma_buf = kmalloc(PL011_DMA_BUFFER_SIZE, GFP_KERNEL);
+	if (!dmatx->tx_dma_buf) {
+		dev_err(uap->port.dev, "failed to allocate DMA TX buffer\n");
+		goto err_no_txbuf;
+	}
+
+	/* Provide single SG list with one item to the buffers */
+	sg_init_one(&dmarx->scatter_a, dmarx->rx_dma_buf_a,
+		    PL011_DMA_BUFFER_SIZE);
+	sg_init_one(&dmarx->scatter_b, dmarx->rx_dma_buf_b,
+		    PL011_DMA_BUFFER_SIZE);
+	sg_init_one(&dmatx->scatter, dmatx->tx_dma_buf, PL011_DMA_BUFFER_SIZE);
+
+	/* Map DMA buffers */
+	sglen = dma_map_sg(uap->port.dev, &dmarx->scatter_a,
+			   1, DMA_FROM_DEVICE);
+	if (sglen != 1)
+		goto err_rx_sgmap_a;
+
+	sglen = dma_map_sg(uap->port.dev, &dmarx->scatter_b,
+			   1, DMA_FROM_DEVICE);
+	if (sglen != 1)
+		goto err_rx_sgmap_b;
+
+	sglen = dma_map_sg(uap->port.dev, &dmatx->scatter,
+			   1, DMA_TO_DEVICE);
+	if (sglen != 1)
+		goto err_tx_sgmap;
+
+	/* Initially we say the transfers are incomplete */
+	init_completion(&uap->dmatx.complete);
+	complete(&uap->dmatx.complete);
+
+	/* The DMA buffer is now the FIFO the TTY subsystem can use */
+	uap->port.fifosize = PL011_DMA_BUFFER_SIZE;
+
+	uap->enable_dma = true;
+	dev_info(uap->port.dev, "setup for DMA on RX %s, TX %s\n",
+		 dma_chan_name(uap->dma_rx_channel),
+		 dma_chan_name(uap->dma_tx_channel));
+	return;
+
+err_tx_sgmap:
+	dma_unmap_sg(uap->port.dev, &dmarx->scatter_b,
+		     1, DMA_FROM_DEVICE);
+err_rx_sgmap_b:
+	dma_unmap_sg(uap->port.dev, &dmarx->scatter_a,
+		     1, DMA_FROM_DEVICE);
+err_rx_sgmap_a:
+	kfree(dmatx->tx_dma_buf);
+err_no_txbuf:
+	kfree(dmarx->rx_dma_buf_b);
+err_no_rxbuf_b:
+	kfree(dmarx->rx_dma_buf_a);
+err_no_rxbuf_a:
+	dma_release_channel(uap->dma_tx_channel);
+	uap->dma_tx_channel = NULL;
+err_no_txchan:
+	dma_release_channel(uap->dma_rx_channel);
+	uap->dma_rx_channel = NULL;
+	return;
+}
+
+/*
+ * Stack up the UARTs and let the above initcall be done at
+ * device initcall time, because the serial driver is called as
+ * an arch initcall, and at this time the DMA subsystem is not yet
+ * registered. At this point the driver will switch over to using
+ * DMA where desired.
+ */
+
+struct dma_uap {
+	struct list_head node;
+	struct uart_amba_port *uap;
+};
+
+struct list_head pl011_dma_uarts = LIST_HEAD_INIT(pl011_dma_uarts);
+
+static int pl011_dma_initcall(void)
+{
+	struct list_head *node, *tmp;
+
+	list_for_each_safe(node, tmp, &pl011_dma_uarts) {
+		struct dma_uap *dmau = list_entry(node, struct dma_uap, node);
+		pl011_dma_probe_initcall(dmau->uap);
+		list_del(node);
+		kfree(dmau);
+	}
+	return 0;
+}
+
+device_initcall(pl011_dma_initcall);
+
+static void pl011_dma_probe(struct uart_amba_port *uap)
+{
+	struct dma_uap *dmau = kzalloc(sizeof(struct dma_uap), GFP_KERNEL);
+
+	if (dmau == NULL)
+		return;
+	dmau->uap = uap;
+	list_add_tail(&dmau->node, &pl011_dma_uarts);
+}
+
+static void pl011_dma_remove(struct uart_amba_port *uap)
+{
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+
+	/* TODO: remove the initcall if it has not yet executed */
+	/* Unmap and free DMA buffers */
+	if (uap->dma_rx_channel)
+		dma_release_channel(uap->dma_rx_channel);
+	if (uap->dma_tx_channel)
+		dma_release_channel(uap->dma_tx_channel);
+	if (dmatx->tx_dma_buf) {
+		dma_unmap_sg(uap->port.dev, &dmatx->scatter,
+			     1, DMA_TO_DEVICE);
+		kfree(dmatx->tx_dma_buf);
+	}
+	if (dmarx->rx_dma_buf_b) {
+		dma_unmap_sg(uap->port.dev, &dmarx->scatter_b,
+			     1, DMA_FROM_DEVICE);
+		kfree(dmarx->rx_dma_buf_b);
+	}
+	if (dmarx->rx_dma_buf_a) {
+		dma_unmap_sg(uap->port.dev, &dmarx->scatter_a,
+			     1, DMA_FROM_DEVICE);
+		kfree(dmarx->rx_dma_buf_a);
+	}
+}
+
+/* Forward declare this for the refill routine */
+static int pl011_dma_tx_refill(struct uart_amba_port *uap);
+
+/*
+ * Move the tail when this IRQ occurs, if not empty refill and
+ * fire another transaction
+ */
+static void pl011_dma_tx_callback(void *data)
+{
+	struct uart_amba_port *uap = data;
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+	struct circ_buf *xmit = &uap->port.state->xmit;
+	u16 val;
+	int ret;
+
+	/* Temporarily disable TX DMA */
+	val = readw(uap->port.membase + UART011_DMACR);
+	val &= ~(UART011_TXDMAE);
+	writew(val, uap->port.membase + UART011_DMACR);
+
+	/* Refill the TX if the buffer is not empty */
+	if (!uart_circ_empty(xmit)) {
+		ret = pl011_dma_tx_refill(uap);
+		if (ret == -EBUSY)
+			/*
+			 * If DMA cannot be used right now, we complete this
+			 * transaction and let the TTY layer retry. If the
+			 * firs following xfer fails to set up for DMA, it
+			 * will fall through to interrupt mode.
+			 */
+			dev_dbg(uap->port.dev, "DMA busy\n");
+	} else {
+		complete(&dmatx->complete);
+	}
+}
+
+static int pl011_dma_tx_refill(struct uart_amba_port *uap)
+{
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+	struct dma_chan *chan = uap->dma_tx_channel;
+	struct dma_async_tx_descriptor *desc;
+	struct circ_buf *xmit = &uap->port.state->xmit;
+	unsigned int count;
+	unsigned long flags;
+	u16 val;
+
+	/* Don't bother about using DMA on XON/XOFF */
+	if (uap->port.x_char) {
+		/* If we can't get it into the FIFO, retry later */
+		if (readw(uap->port.membase + UART01x_FR) &
+		    UART01x_FR_TXFF) {
+			complete(&dmatx->complete);
+			return 0;
+		}
+		writew(uap->port.x_char, uap->port.membase + UART01x_DR);
+		uap->port.icount.tx++;
+		uap->port.x_char = 0;
+		complete(&dmatx->complete);
+		return 0;
+	}
+
+	/*
+	 * Try to avoid the overhead involved in using DMA if the
+	 * transaction fits in the first half of the FIFO and it's not
+	 * full. Unfortunately there is only one single bit in the
+	 * hardware to tell whether the FIFO is full or not, so
+	 * we don't know exactly how many chars we can fit in.
+	 */
+	if (uart_circ_chars_pending(xmit) < (uap->fifosize >> 1)) {
+		while (uart_circ_chars_pending(xmit)) {
+			if (readw(uap->port.membase + UART01x_FR) &
+			    UART01x_FR_TXFF) {
+				/*
+				 * Ooops TX FIFO is full, we'd better stop
+				 * this. Let's enable TX interrupt here to get
+				 * informed when there is again some space in
+				 * the TX FIFO so we can continue the transfer.
+				 * This interrupt will be cleared just before
+				 * setting up DMA, as it could interfere with
+				 * TX interrupt handling routine.
+				 */
+				uap->im |= UART011_TXIM;
+				writew(uap->im,
+				       uap->port.membase + UART011_IMSC);
+				break;
+			}
+			writew(xmit->buf[xmit->tail],
+			       uap->port.membase + UART01x_DR);
+			uap->port.icount.tx++;
+			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		}
+		complete(&dmatx->complete);
+		return 0;
+	}
+
+	/*
+	 * Clear TX interrupt to be sure that DMA will not interfere with
+	 * TX ISR
+	 */
+	local_irq_save(flags);
+	uap->im &= ~UART011_TXIM;
+	writew(uap->im, uap->port.membase + UART011_IMSC);
+	local_irq_restore(flags);
+
+	/* Sync the buffer for the CPU so we can write into it */
+	dma_sync_sg_for_cpu(uap->port.dev,
+			    &dmatx->scatter,
+			    1,
+			    DMA_TO_DEVICE);
+
+	/* Else proceed to copy the TX chars to the DMA buffer and fire DMA */
+	count = uart_circ_chars_pending(xmit);
+	if (count > PL011_DMA_BUFFER_SIZE)
+		count = PL011_DMA_BUFFER_SIZE;
+
+	if (xmit->tail < xmit->head)
+		memcpy(&dmatx->tx_dma_buf[0], &xmit->buf[xmit->tail], count);
+	else {
+		size_t first = UART_XMIT_SIZE - xmit->tail;
+		size_t second = xmit->head;
+
+		memcpy(&dmatx->tx_dma_buf[0], &xmit->buf[xmit->tail], first);
+		memcpy(&dmatx->tx_dma_buf[first], &xmit->buf[0], second);
+	}
+
+	dmatx->scatter.length = count;
+
+	/* Synchronize the scatterlist, invalidate buffers, caches etc */
+	dma_sync_sg_for_device(uap->port.dev,
+			       &dmatx->scatter,
+			       1,
+			       DMA_TO_DEVICE);
+
+	/* Prepare the scatterlist */
+	desc = chan->device->device_prep_slave_sg(chan,
+						  &dmatx->scatter,
+						  1,
+						  DMA_TO_DEVICE,
+						  DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		/* "Complete" DMA (errorpath) */
+		complete(&dmatx->complete);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		return -EBUSY;
+	}
+
+	/* Some data to go along to the callback */
+	desc->callback = pl011_dma_tx_callback;
+	desc->callback_param = uap;
+
+	/* Here is where overloaded DMA controllers can fail */
+	dmatx->cookie = desc->tx_submit(desc);
+	if (dma_submit_error(dmatx->cookie)) {
+		/* "Complete" DMA (errorpath) */
+		complete(&dmatx->complete);
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		return dmatx->cookie;
+	}
+
+	/*
+	 * Now we know that DMA will fire, so advance the ring buffer
+	 * with the stuff we just dispatched
+	 */
+	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uap->port.icount.tx += count;
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&uap->port);
+
+	/* Fire the DMA transaction */
+	chan->device->device_issue_pending(chan);
+
+	val = readw(uap->port.membase + UART011_DMACR);
+	val |= UART011_TXDMAE;
+	writew(val, uap->port.membase + UART011_DMACR);
+	return 0;
+}
+
+static void pl011_dma_rx_callback(void *data);
+
+static int pl011_dma_rx_trigger_dma(struct uart_amba_port *uap)
+{
+	struct dma_chan *rxchan = uap->dma_rx_channel;
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	struct dma_async_tx_descriptor *desc;
+	struct scatterlist *scatter = dmarx->use_buffer_b ?
+		&dmarx->scatter_b : &dmarx->scatter_a;
+	u16 val;
+
+	/* Start the RX DMA job */
+	desc = rxchan->device->device_prep_slave_sg(rxchan,
+						    scatter,
+						    1,
+						    DMA_FROM_DEVICE,
+						    DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	/*
+	 * If the DMA engine is busy and cannot prepare a
+	 * channel, no big deal, the driver will fall back
+	 * to interrupt mode as a result of this error code.
+	 */
+	if (!desc) {
+		uap->rx_dma_running = false;
+		rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL, 0);
+		return -EBUSY;
+	}
+
+	/* Some data to go along to the callback */
+	desc->callback = pl011_dma_rx_callback;
+	desc->callback_param = uap;
+	/* This is another point where an overloaded engine can fail */
+	dmarx->cookie = desc->tx_submit(desc);
+	if (dma_submit_error(dmarx->cookie)) {
+		uap->rx_dma_running = false;
+		rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL, 0);
+		return -EBUSY;
+	}
+
+	rxchan->device->device_issue_pending(rxchan);
+
+	val = readw(uap->port.membase + UART011_DMACR);
+	val |= UART011_RXDMAE;
+	writew(val, uap->port.membase + UART011_DMACR);
+	uap->rx_dma_running = true;
+
+	return 0;
+}
+
+/*
+ * This is called when either the DMA job is complete, or
+ * the FIFO timeout interrupt occurred. This must be called
+ * with the port spinlock uap->port.lock held.
+ */
+static void pl011_dma_rx_chars(struct uart_amba_port *uap,
+			       u32 pending, bool use_buffer_b,
+			       bool readfifo)
+{
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	struct tty_struct *tty = uap->port.state->port.tty;
+	char *buf = use_buffer_b ? dmarx->rx_dma_buf_b : dmarx->rx_dma_buf_a;
+	struct scatterlist *scatter = use_buffer_b ?
+		&dmarx->scatter_b : &dmarx->scatter_a;
+	unsigned int status, ch, flag;
+	u32 count = pending;
+	u32 bufp = 0;
+	u32 fifotaken = 0; /* only used for vdbg() */
+
+	/* Sync in buffer */
+	dma_sync_sg_for_cpu(uap->port.dev,
+			    scatter,
+			    1,
+			    DMA_FROM_DEVICE);
+
+	status = readw(uap->port.membase + UART01x_FR);
+
+	/*
+	 * First take all chars in the DMA pipe, then look
+	 * in the FIFO. So loop while we have chars in the
+	 * DMA buffer or the FIFO. If we came here from a
+	 * DMA buffer full interrupt, there is already another
+	 * DMA job triggered to read the FIFO, so don't look
+	 * at it.
+	 */
+	while (count ||
+	       (readfifo && (status & UART01x_FR_RXFE) == 0)) {
+
+		flag = TTY_NORMAL;
+		uap->port.icount.rx++;
+
+		if (count) {
+			/* Take chars from the DMA buffer */
+			int inserted = tty_insert_flip_string(
+					uap->port.state->port.tty, buf, count);
+
+			/*
+			 * Check if insertion is successful to avoid
+			 * infinite loop. This can happen when TTY is full.
+			 */
+			if (unlikely(inserted == 0))
+				count = 0;
+			else {
+				count -= inserted;
+				bufp += inserted;
+			}
+			continue;
+		} else {
+			/* Take chars from the FIFO and update status */
+			ch = readw(uap->port.membase + UART01x_DR);
+			status = readw(uap->port.membase + UART01x_FR);
+			fifotaken++;
+
+			/*
+			 * Error conditions will only occur in the FIFO,
+			 * these will trigger an immediate interrupt and
+			 * stop the DMA job, so we will always find the
+			 * error in the FIFO, never in the DMA buffer.
+			 */
+			if (unlikely(ch & UART_DR_ERROR)) {
+				if (ch & UART011_DR_BE) {
+					ch &= ~(UART011_DR_FE | UART011_DR_PE);
+					uap->port.icount.brk++;
+					if (uart_handle_break(&uap->port))
+						continue;
+				} else if (ch & UART011_DR_PE)
+					uap->port.icount.parity++;
+				else if (ch & UART011_DR_FE)
+					uap->port.icount.frame++;
+				if (ch & UART011_DR_OE)
+					uap->port.icount.overrun++;
+
+				ch &= uap->port.read_status_mask;
+
+				if (ch & UART011_DR_BE)
+					flag = TTY_BREAK;
+				else if (ch & UART011_DR_PE)
+					flag = TTY_PARITY;
+				else if (ch & UART011_DR_FE)
+					flag = TTY_FRAME;
+			}
+		}
+
+		if (uart_handle_sysrq_char(&uap->port, ch & 255))
+			continue;
+
+		uart_insert_char(&uap->port, ch, UART011_DR_OE, ch, flag);
+	}
+
+	spin_unlock(&uap->port.lock);
+	dev_vdbg(uap->port.dev,
+		 "Took %d chars from DMA buffer and %d chars from the FIFO\n",
+		 bufp, fifotaken);
+	tty_flip_buffer_push(tty);
+	spin_lock(&uap->port.lock);
+}
+
+static void pl011_dma_rx_irq(struct uart_amba_port *uap)
+{
+	struct dma_chan *rxchan = uap->dma_rx_channel;
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	struct scatterlist *scatter = dmarx->use_buffer_b ?
+		&dmarx->scatter_b : &dmarx->scatter_a;
+	u32 pending;
+	int ret;
+	struct dma_tx_state state;
+	enum dma_status dmastat;
+	u16 val;
+
+	/* Use PrimeCell DMA extensions to stop the transfer */
+	ret = rxchan->device->device_control(rxchan, DMA_PAUSE, 0);
+	if (ret)
+		dev_err(uap->port.dev, "unable to pause DMA transfer\n");
+	dmastat = rxchan->device->device_tx_status(rxchan,
+						   dmarx->cookie, &state);
+
+	/* Disable RX DMA temporarily */
+	val = readw(uap->port.membase + UART011_DMACR);
+	val &= ~(UART011_RXDMAE);
+	writew(val, uap->port.membase + UART011_DMACR);
+	uap->rx_dma_running = false;
+
+	if (dmastat != DMA_PAUSED)
+		dev_err(uap->port.dev, "unable to pause DMA transfer\n");
+	pending = scatter->length - state.residue;
+
+	BUG_ON(pending > PL011_DMA_BUFFER_SIZE);
+
+	ret = rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL, 0);
+	if (ret)
+		dev_err(uap->port.dev, "unable to terminate DMA transfer\n");
+
+	/*
+	 * This will take the chars we have so far and insert
+	 * into the framework.
+	 */
+	pl011_dma_rx_chars(uap, pending, dmarx->use_buffer_b, true);
+
+	/* Switch buffer & re-trigger DMA job */
+	dmarx->use_buffer_b = !dmarx->use_buffer_b;
+	ret = pl011_dma_rx_trigger_dma(uap);
+	if (ret) {
+		dev_dbg(uap->port.dev, "could not retrigger RX DMA job "
+			"fall back to interrupt mode\n");
+		uap->im |= UART011_RXIM;
+		writew(uap->im, uap->port.membase + UART011_IMSC);
+	}
+}
+
+static void pl011_dma_rx_callback(void *data)
+{
+	struct uart_amba_port *uap = data;
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	bool lastbuf = dmarx->use_buffer_b;
+	int ret;
+
+	/*
+	 * This completion interrupt occurs typically when the
+	 * RX buffer is totally stuffed but no timeout has yet
+	 * occurred. When that happens, we just want the RX
+	 * routine to flush out the secondary DMA buffer while
+	 * we immediately trigger the next DMA job.
+	 */
+	uap->rx_dma_running = false;
+	dmarx->use_buffer_b = !lastbuf;
+	ret = pl011_dma_rx_trigger_dma(uap);
+
+	spin_lock_irq(&uap->port.lock);
+	pl011_dma_rx_chars(uap, PL011_DMA_BUFFER_SIZE, lastbuf, false);
+	spin_unlock_irq(&uap->port.lock);
+	/*
+	 * Do this check after we picked the DMA chars so we don't
+	 * get some IRQ immediately from RX.
+	 */
+	if (ret) {
+		dev_dbg(uap->port.dev, "could not retrigger RX DMA job "
+			"fall back to interrupt mode\n");
+		uap->im |= UART011_RXIM;
+		writew(uap->im, uap->port.membase + UART011_IMSC);
+	}
+}
+
+static void pl011_dma_startup(struct uart_amba_port *uap)
+{
+	u16 val;
+	int ret = 0;
+
+	if (!uap->enable_dma)
+		return;
+
+	/* Turn on DMA error (RX/TX will be enabled on demand) */
+	val = readw(uap->port.membase + UART011_DMACR);
+	val |= UART011_DMAONERR;
+	writew(val, uap->port.membase + UART011_DMACR);
+
+	ret = pl011_dma_rx_trigger_dma(uap);
+	if (ret)
+		dev_dbg(uap->port.dev, "could not trigger initial "
+			"RX DMA job, fall back to interrupt mode\n");
+}
+
+static void pl011_dma_shutdown(struct uart_amba_port *uap)
+{
+	struct dma_chan *rxchan = uap->dma_rx_channel;
+	struct dma_chan *txchan = uap->dma_tx_channel;
+	u16 val;
+
+	if (!uap->enable_dma)
+		return;
+
+	/* Disable RX and TX DMA */
+	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_BUSY)
+		barrier();
+	val = readw(uap->port.membase + UART011_DMACR);
+	val &= ~(UART011_DMAONERR | UART011_RXDMAE | UART011_TXDMAE);
+	writew(val, uap->port.membase + UART011_DMACR);
+	/* Terminate any RX and TX DMA jobs */
+	rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL, 0);
+	txchan->device->device_control(txchan, DMA_TERMINATE_ALL, 0);
+}
+
+static int pl011_dma_tx_chars(struct uart_amba_port *uap)
+{
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+
+	/* Try to wait for completion, return if something is in progress */
+	if (!try_wait_for_completion(&dmatx->complete))
+		return -EINPROGRESS;
+
+	/* Set up and fire the DMA job */
+	init_completion(&dmatx->complete);
+	return pl011_dma_tx_refill(uap);
+}
+
+#else
+/* Blank functions if the DMA engine is not available */
+static inline void pl011_dma_probe(struct uart_amba_port *uap)
+{
+}
+
+static inline void pl011_dma_remove(struct uart_amba_port *uap)
+{
+}
+
+static inline void pl011_dma_rx_irq(struct uart_amba_port *uap)
+{
+}
+
+static inline int pl011_dma_rx_trigger_dma(struct uart_amba_port *uap)
+{
+	return -EIO;
+}
+
+static inline void pl011_dma_startup(struct uart_amba_port *uap)
+{
+}
+
+static inline void pl011_dma_shutdown(struct uart_amba_port *uap)
+{
+}
+
+static inline int pl011_dma_tx_chars(struct uart_amba_port *uap)
+{
+	return -EIO;
+}
+#endif
+
+
 static void pl011_stop_tx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
@@ -111,10 +864,18 @@ static void pl011_stop_tx(struct uart_port *port)
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 }
 
+static void pl011_tx_chars(struct uart_amba_port *uap);
+
 static void pl011_start_tx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 
+	if (uap->enable_dma) {
+		/* Immediately push out chars in DMA mode */
+		pl011_tx_chars(uap);
+		return;
+	}
+	/* In interrupt mode, let the interrupt pull chars */
 	uap->im |= UART011_TXIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 }
@@ -140,6 +901,7 @@ static void pl011_rx_chars(struct uart_amba_port *uap)
 {
 	struct tty_struct *tty = uap->port.state->port.tty;
 	unsigned int status, ch, flag, max_count = 256;
+	int ret;
 
 	status = readw(uap->port.membase + UART01x_FR);
 	while ((status & UART01x_FR_RXFE) == 0 && max_count--) {
@@ -184,6 +946,21 @@ static void pl011_rx_chars(struct uart_amba_port *uap)
 	}
 	spin_unlock(&uap->port.lock);
 	tty_flip_buffer_push(tty);
+	/*
+	 * If we were temporarily out of DMA mode for a while,
+	 * attempt to switch back to DMA mode again.
+	 */
+	if (uap->enable_dma) {
+		uap->im &= ~UART011_RXIM;
+		writew(uap->im, uap->port.membase + UART011_IMSC);
+		ret = pl011_dma_rx_trigger_dma(uap);
+		if (ret) {
+			dev_dbg(uap->port.dev, "could not trigger RX DMA job "
+				"fall back to interrupt mode again\n");
+			uap->im |= UART011_RXIM;
+			writew(uap->im, uap->port.membase + UART011_IMSC);
+		}
+	}
 	spin_lock(&uap->port.lock);
 }
 
@@ -192,6 +969,25 @@ static void pl011_tx_chars(struct uart_amba_port *uap)
 	struct circ_buf *xmit = &uap->port.state->xmit;
 	int count;
 
+	if (uap->enable_dma) {
+		int ret;
+
+		ret = pl011_dma_tx_chars(uap);
+		if (!ret)
+			return;
+		if (ret == -EINPROGRESS)
+			return;
+
+		/*
+		 * On any other error (including -EBUSY which is emitted
+		 * in case the DMA engine is out of physical channels
+		 * for example) we fall through to interrupt mode
+		 */
+		dev_dbg(uap->port.dev, "DMA unavailable for TX\n");
+		uap->im |= UART011_TXIM;
+		writew(uap->im, uap->port.membase + UART011_IMSC);
+	}
+
 	if (uap->port.x_char) {
 		writew(uap->port.x_char, uap->port.membase + UART01x_DR);
 		uap->port.icount.tx++;
@@ -203,8 +999,10 @@ static void pl011_tx_chars(struct uart_amba_port *uap)
 		return;
 	}
 
-	count = uap->port.fifosize >> 1;
+	count = uap->fifosize >> 1;
 	do {
+		if (readw(uap->port.membase + UART01x_FR) & UART01x_FR_TXFF)
+			break;
 		writew(xmit->buf[xmit->tail], uap->port.membase + UART01x_DR);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		uap->port.icount.tx++;
@@ -249,7 +1047,7 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 	unsigned int status, pass_counter = AMBA_ISR_PASS_LIMIT;
 	int handled = 0;
 
-	spin_lock(&uap->port.lock);
+	spin_lock_irq(&uap->port.lock);
 
 	status = readw(uap->port.membase + UART011_MIS);
 	if (status) {
@@ -258,13 +1056,30 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 					  UART011_RXIS),
 			       uap->port.membase + UART011_ICR);
 
-			if (status & (UART011_RTIS|UART011_RXIS))
-				pl011_rx_chars(uap);
+			if (status & (UART011_RTIS|UART011_RXIS)) {
+				if (uap->enable_dma && uap->rx_dma_running)
+					pl011_dma_rx_irq(uap);
+				else
+					pl011_rx_chars(uap);
+			}
 			if (status & (UART011_DSRMIS|UART011_DCDMIS|
 				      UART011_CTSMIS|UART011_RIMIS))
 				pl011_modem_status(uap);
-			if (status & UART011_TXIS)
+			if (status & UART011_TXIS) {
+				/*
+				 * When DMA is enabled we still use TX
+				 * interrupt to send small amounts of data,
+				 * and as a fallback when the DMA channel is
+				 * not available. This interrupt is cleared
+				 * here and will be enabled when it's needed.
+				 */
+				if (uap->enable_dma) {
+					uap->im &= ~UART011_TXIM;
+					writew(uap->im,
+					       uap->port.membase + UART011_IMSC);
+				}
 				pl011_tx_chars(uap);
+			}
 
 			if (pass_counter-- == 0)
 				break;
@@ -274,7 +1089,7 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 		handled = 1;
 	}
 
-	spin_unlock(&uap->port.lock);
+	spin_unlock_irq(&uap->port.lock);
 
 	return IRQ_RETVAL(handled);
 }
@@ -423,16 +1238,28 @@ static int pl011_startup(struct uart_port *port)
 	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
 
+	/* Clear pending error interrupts*/
+	writew(0xFFFF & ~(UART011_TXIS | UART011_RTIS | UART011_RXIS),
+	       uap->port.membase + UART011_ICR);
+
 	/*
 	 * initialise the old status of the modem signals
 	 */
 	uap->old_status = readw(uap->port.membase + UART01x_FR) & UART01x_FR_MODEM_ANY;
 
+	/* Startup DMA */
+	pl011_dma_startup(uap);
+
 	/*
-	 * Finally, enable interrupts
+	 * Finally, enable interrupts, only timeouts when using DMA
+	 * if initial RX DMA job failed, start in interrupt mode
+	 * as well.
 	 */
 	spin_lock_irq(&uap->port.lock);
-	uap->im = UART011_RXIM | UART011_RTIM;
+	if (uap->enable_dma && uap->rx_dma_running)
+		uap->im = UART011_RTIM;
+	else
+		uap->im = UART011_RXIM | UART011_RTIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 	spin_unlock_irq(&uap->port.lock);
 
@@ -467,6 +1294,8 @@ static void pl011_shutdown(struct uart_port *port)
 	writew(0xffff, uap->port.membase + UART011_ICR);
 	spin_unlock_irq(&uap->port.lock);
 
+	pl011_dma_shutdown(uap);
+
 	/*
 	 * Free the interrupt
 	 */
@@ -532,7 +1361,7 @@ pl011_set_termios(struct uart_port *port, struct ktermios *termios,
 		if (!(termios->c_cflag & PARODD))
 			lcr_h |= UART01x_LCRH_EPS;
 	}
-	if (port->fifosize > 1)
+	if (uap->fifosize > 1)
 		lcr_h |= UART01x_LCRH_FEN;
 
 	spin_lock_irqsave(&port->lock, flags);
@@ -871,6 +1700,8 @@ static int pl011_probe(struct amba_device *dev, struct amba_id *id)
 	uap->port.ops = &amba_pl011_pops;
 	uap->port.flags = UPF_BOOT_AUTOCONF;
 	uap->port.line = i;
+	uap->fifosize = vendor->fifosize;
+	pl011_dma_probe(uap);
 
 	amba_ports[i] = uap;
 
@@ -879,6 +1710,7 @@ static int pl011_probe(struct amba_device *dev, struct amba_id *id)
 	if (ret) {
 		amba_set_drvdata(dev, NULL);
 		amba_ports[i] = NULL;
+		pl011_dma_remove(uap);
 		clk_put(uap->clk);
  unmap:
 		iounmap(base);
@@ -902,6 +1734,7 @@ static int pl011_remove(struct amba_device *dev)
 		if (amba_ports[i] == uap)
 			amba_ports[i] = NULL;
 
+	pl011_dma_remove(uap);
 	iounmap(uap->port.membase);
 	clk_put(uap->clk);
 	kfree(uap);
diff --git a/include/linux/amba/serial.h b/include/linux/amba/serial.h
index e1b634b..e00744f 100644
--- a/include/linux/amba/serial.h
+++ b/include/linux/amba/serial.h
@@ -169,6 +169,12 @@ struct amba_device; /* in uncompress this is included but amba/bus.h is not */
 struct amba_pl010_data {
 	void (*set_mctrl)(struct amba_device *dev, void __iomem *base, unsigned int mctrl);
 };
+struct dma_chan;
+struct amba_pl011_data {
+	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
+	void *dma_rx_param;
+	void *dma_tx_param;
+};
 #endif
 
 #endif
-- 
1.6.3.3

