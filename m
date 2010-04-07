Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0DGXOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:14:22 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65511 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756779Ab0DGXOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:14:18 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 08/11] ARM: add PrimeCell generic DMA to PL011 v5
Date: Thu,  8 Apr 2010 01:13:24 +0200
Message-Id: <1270682004-6542-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the PL011 UART driver with generic DMA engine support
using the PrimeCell DMA engine interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/serial/amba-pl011.c |  713 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/amba/serial.h |    6 +
 2 files changed, 712 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/amba-pl011.c b/drivers/serial/amba-pl011.c
index eb4cb48..0cdce9e 100644
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
+#include <linux/amba/dma.h>
 
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
@@ -73,6 +97,15 @@ struct uart_amba_port {
 	unsigned int		old_status;
 	unsigned int		ifls;	/* vendor-specific */
 	bool			autorts;
+	unsigned int		fifosize;
+	/* DMA stuff */
+	bool			use_dma;
+#ifdef CONFIG_DMADEVICES
+	struct dma_chan		*dma_rx_channel;
+	struct dma_chan		*dma_tx_channel;
+	struct pl011_dma_rx_transaction dmarx;
+	struct pl011_dma_tx_transaction dmatx;
+#endif
 };
 
 /* There is by now at least one vendor with differing details, so handle it */
@@ -91,18 +124,641 @@ static struct vendor_data vendor_st = {
 	.fifosize		= 64,
 };
 
+
+/*
+ * All the DMA operation mode stuff goes inside this ifdef.
+ * This assumes that you have a generic DMA device interface,
+ * no custom DMA interfaces are supported.
+ */
+#ifdef CONFIG_DMADEVICES
+
+#define PL011_DMA_BUFFER_SIZE PAGE_SIZE
+
+static void __init pl011_dma_probe_initcall(struct uart_amba_port *uap)
+{
+	/* DMA is the sole user of the platform data right now */
+	struct amba_pl011_data *plat = uap->port.dev->platform_data;
+	struct pl011_dma_rx_transaction *dmarx = &uap->dmarx;
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+	struct amba_dma_channel_config rx_conf = {
+		.addr = uap->port.mapbase + UART01x_DR,
+		.addr_width = 1,
+		.direction = DMA_FROM_DEVICE,
+		.maxburst = uap->port.fifosize >> 1,
+	};
+	struct amba_dma_channel_config tx_conf = {
+		.addr = uap->port.mapbase + UART01x_DR,
+		.addr_width = 1,
+		.direction = DMA_TO_DEVICE,
+		.maxburst = uap->port.fifosize >> 1,
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
+	dma_set_ambaconfig(uap->dma_rx_channel, &rx_conf);
+
+	uap->dma_tx_channel = dma_request_channel(mask,
+						  plat->dma_filter,
+						  plat->dma_tx_param);
+	if (!uap->dma_tx_channel) {
+		dev_err(uap->port.dev, "no TX DMA channel!\n");
+		goto err_no_txchan;
+	}
+	dma_set_ambaconfig(uap->dma_tx_channel, &tx_conf);
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
+	uap->use_dma = true;
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
+struct list_head __initdata pl011_dma_uarts = LIST_HEAD_INIT(pl011_dma_uarts);
+
+static int __init pl011_dma_initcall(void)
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
+static void pl011_dma_tx_refill(struct uart_amba_port *uap);
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
+
+	/* Refill the TX if the buffer is not empty */
+	if (!uart_circ_empty(xmit))
+		pl011_dma_tx_refill(uap);
+	else
+		complete(&dmatx->complete);
+}
+
+static void pl011_dma_tx_refill(struct uart_amba_port *uap)
+{
+	struct pl011_dma_tx_transaction *dmatx = &uap->dmatx;
+	struct dma_chan *chan = uap->dma_tx_channel;
+	struct dma_async_tx_descriptor *desc;
+	struct circ_buf *xmit = &uap->port.state->xmit;
+	unsigned int count;
+	unsigned long flags;
+
+	/* Don't bother about using DMA on XON/XOFF */
+	if (uap->port.x_char) {
+		/* If we can't get it into the FIFO, retry later */
+		if (readw(uap->port.membase + UART01x_FR) &
+		    UART01x_FR_TXFF) {
+			complete(&dmatx->complete);
+			return;
+		}
+		writew(uap->port.x_char, uap->port.membase + UART01x_DR);
+		uap->port.icount.tx++;
+		uap->port.x_char = 0;
+		complete(&dmatx->complete);
+		return;
+	}
+
+	/*
+	 * Try to avoid the overhead involved in using DMA if the
+	 * transaction fits in the first half of the FIFO and it's not
+	 * full. Unfortunately there is only one single bit in the
+	 * hardware to tell whether the FIFO is full or not, so
+	 * we don't know exactly how many chars we can fit in.
+	 */
+	if (!(readw(uap->port.membase + UART01x_FR) &
+	      UART01x_FR_TXFF) &&
+	    uart_circ_chars_pending(xmit) < (uap->fifosize >> 1)) {
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
+		return;
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
+	/* Advance the ring buffer with the stuff we just dispatched */
+	xmit->tail = (xmit->tail + count) & (UART_XMIT_SIZE - 1);
+	uap->port.icount.tx += count;
+	dmatx->scatter.length = count;
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(&uap->port);
+
+	/* Synchronize the scatterlist, invalidate buffers, caches etc */
+	dma_sync_sg_for_device(uap->port.dev,
+			       &dmatx->scatter,
+			       1,
+			       DMA_TO_DEVICE);
+
+	/* Send the scatterlist */
+	desc = chan->device->device_prep_slave_sg(chan,
+						  &dmatx->scatter,
+						  1,
+						  DMA_TO_DEVICE,
+						  DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc) {
+		/* "Complete" DMA (errorpath) */
+		complete(&dmatx->complete);
+		return;
+	}
+
+	/* Some data to go along to the callback */
+	desc->callback = pl011_dma_tx_callback;
+	desc->callback_param = uap;
+	dmatx->cookie = desc->tx_submit(desc);
+	chan->device->device_issue_pending(chan);
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
+
+	/* Start the RX DMA job */
+	desc = rxchan->device->device_prep_slave_sg(rxchan,
+						    scatter,
+						    1,
+						    DMA_FROM_DEVICE,
+						    DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc)
+		return -EIO;
+
+	/* Some data to go along to the callback */
+	desc->callback = pl011_dma_rx_callback;
+	desc->callback_param = uap;
+	dmarx->cookie = desc->tx_submit(desc);
+	rxchan->device->device_issue_pending(rxchan);
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
+			ch = (unsigned int) buf[bufp];
+			bufp++;
+			count--;
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
+
+	/* Use PrimeCell DMA extensions to stop the transfer */
+	ret = rxchan->device->device_control(rxchan, DMA_PAUSE);
+	if (ret)
+		dev_err(uap->port.dev, "unable to pause DMA transfer\n");
+	dmastat = rxchan->device->device_tx_status(rxchan,
+						   dmarx->cookie, &state);
+	if (dmastat != DMA_PAUSED)
+		dev_err(uap->port.dev, "unable to pause DMA transfer\n");
+	pending = scatter->length - state.residue;
+	ret = rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL);
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
+	if (ret)
+		dev_err(uap->port.dev, "could not retrigger RX DMA job\n");
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
+	dmarx->use_buffer_b = !lastbuf;
+	ret = pl011_dma_rx_trigger_dma(uap);
+	if (ret)
+		dev_err(uap->port.dev, "could not retrigger RX DMA job\n");
+
+	spin_lock_irq(&uap->port.lock);
+	pl011_dma_rx_chars(uap, PL011_DMA_BUFFER_SIZE, lastbuf, false);
+	spin_unlock_irq(&uap->port.lock);
+}
+
+static void pl011_dma_startup(struct uart_amba_port *uap)
+{
+	u16 val;
+	int ret;
+
+	if (!uap->use_dma)
+		return;
+
+	ret = pl011_dma_rx_trigger_dma(uap);
+	if (ret) {
+		uap->use_dma = false;
+		return;
+	}
+
+	/* Turn on DMA for RX and TX */
+	val = readw(uap->port.membase + UART011_DMACR);
+	val |= (UART011_RXDMAE | UART011_TXDMAE | UART011_DMAONERR);
+	writew(val, uap->port.membase + UART011_DMACR);
+}
+
+static void pl011_dma_shutdown(struct uart_amba_port *uap)
+{
+	struct dma_chan *rxchan = uap->dma_rx_channel;
+	struct dma_chan *txchan = uap->dma_tx_channel;
+	u16 val;
+
+	if (!uap->use_dma)
+		return;
+
+	/* Disable RX and TX DMA */
+	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_BUSY)
+		barrier();
+	val = readw(uap->port.membase + UART011_DMACR);
+	val &= ~(UART011_RXDMAE | UART011_TXDMAE);
+	writew(val, uap->port.membase + UART011_DMACR);
+	/* Terminate any RX and TX DMA jobs */
+	rxchan->device->device_control(rxchan, DMA_TERMINATE_ALL);
+	txchan->device->device_control(txchan, DMA_TERMINATE_ALL);
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
+	pl011_dma_tx_refill(uap);
+
+	return 0;
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
+static void pl011_dma_rx_irq(struct uart_amba_port *uap)
+{
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
+
+static inline void pl011_dma_rx_timeout(struct uart_amba_port *uap)
+{
+}
+#endif
+
+
 static void pl011_stop_tx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 
+	if (uap->use_dma)
+		return;
 	uap->im &= ~UART011_TXIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 }
 
+static void pl011_tx_chars(struct uart_amba_port *uap);
+
 static void pl011_start_tx(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 
+	if (uap->use_dma) {
+		pl011_tx_chars(uap);
+		return;
+	}
 	uap->im |= UART011_TXIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 }
@@ -180,6 +836,22 @@ static void pl011_tx_chars(struct uart_amba_port *uap)
 	struct circ_buf *xmit = &uap->port.state->xmit;
 	int count;
 
+	if (uap->use_dma) {
+		int ret;
+
+		ret = pl011_dma_tx_chars(uap);
+		if (!ret)
+			return;
+		if (ret == -EINPROGRESS)
+			return;
+
+		/* On error we fall through to interrupt mode */
+		dev_err(uap->port.dev, "error %d using TX DMA\n", ret);
+		uap->use_dma = false;
+		uap->im |= UART011_TXIM | UART011_RXIM;
+		writew(uap->im, uap->port.membase + UART011_IMSC);
+	}
+
 	if (uap->port.x_char) {
 		writew(uap->port.x_char, uap->port.membase + UART01x_DR);
 		uap->port.icount.tx++;
@@ -237,7 +909,7 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 	unsigned int status, pass_counter = AMBA_ISR_PASS_LIMIT;
 	int handled = 0;
 
-	spin_lock(&uap->port.lock);
+	spin_lock_irq(&uap->port.lock);
 
 	status = readw(uap->port.membase + UART011_MIS);
 	if (status) {
@@ -246,13 +918,29 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 					  UART011_RXIS),
 			       uap->port.membase + UART011_ICR);
 
-			if (status & (UART011_RTIS|UART011_RXIS))
-				pl011_rx_chars(uap);
+			if (status & (UART011_RTIS|UART011_RXIS)) {
+				if (uap->use_dma)
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
+				 * interrupt to send small amounts of data.
+				 * This interrupt is cleared here and will
+				 * be enabled when it's needed.
+				 */
+				if (uap->use_dma) {
+					uap->im &= ~UART011_TXIM;
+					writew(uap->im,
+					       uap->port.membase + UART011_IMSC);
+				}
 				pl011_tx_chars(uap);
+			}
 
 			if (pass_counter-- == 0)
 				break;
@@ -262,7 +950,7 @@ static irqreturn_t pl011_int(int irq, void *dev_id)
 		handled = 1;
 	}
 
-	spin_unlock(&uap->port.lock);
+	spin_unlock_irq(&uap->port.lock);
 
 	return IRQ_RETVAL(handled);
 }
@@ -407,13 +1095,18 @@ static int pl011_startup(struct uart_port *port)
 	uap->old_status = readw(uap->port.membase + UART01x_FR) & UART01x_FR_MODEM_ANY;
 
 	/*
-	 * Finally, enable interrupts
+	 * Finally, enable interrupts, only timeouts when using DMA
 	 */
 	spin_lock_irq(&uap->port.lock);
-	uap->im = UART011_RXIM | UART011_RTIM;
+	if (uap->use_dma)
+		uap->im = UART011_RTIM;
+	else
+		uap->im = UART011_RXIM | UART011_RTIM;
 	writew(uap->im, uap->port.membase + UART011_IMSC);
 	spin_unlock_irq(&uap->port.lock);
 
+	pl011_dma_startup(uap);
+
 	return 0;
 
  clk_dis:
@@ -427,6 +1120,8 @@ static void pl011_shutdown(struct uart_port *port)
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 	unsigned long val;
 
+	pl011_dma_shutdown(uap);
+
 	/*
 	 * disable all interrupts
 	 */
@@ -809,6 +1504,8 @@ static int pl011_probe(struct amba_device *dev, struct amba_id *id)
 	uap->port.ops = &amba_pl011_pops;
 	uap->port.flags = UPF_BOOT_AUTOCONF;
 	uap->port.line = i;
+	uap->fifosize = vendor->fifosize;
+	pl011_dma_probe(uap);
 
 	amba_ports[i] = uap;
 
@@ -817,6 +1514,7 @@ static int pl011_probe(struct amba_device *dev, struct amba_id *id)
 	if (ret) {
 		amba_set_drvdata(dev, NULL);
 		amba_ports[i] = NULL;
+		pl011_dma_remove(uap);
 		clk_put(uap->clk);
  unmap:
 		iounmap(base);
@@ -840,6 +1538,7 @@ static int pl011_remove(struct amba_device *dev)
 		if (amba_ports[i] == uap)
 			amba_ports[i] = NULL;
 
+	pl011_dma_remove(uap);
 	iounmap(uap->port.membase);
 	clk_put(uap->clk);
 	kfree(uap);
diff --git a/include/linux/amba/serial.h b/include/linux/amba/serial.h
index 5a5a7fd..2ce6a75 100644
--- a/include/linux/amba/serial.h
+++ b/include/linux/amba/serial.h
@@ -166,6 +166,12 @@ struct amba_device; /* in uncompress this is included but amba/bus.h is not */
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

