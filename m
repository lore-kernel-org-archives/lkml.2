Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BRCXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:23:05 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19400 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab1BRCXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:23:04 -0500
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 1/8] pch_uart: add multi-scatter processing
Date: Fri, 18 Feb 2011 11:23:57 +0900
Message-Id: <1297995844-11282-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, this driver can handle only single scatterlist.
Thus, it can't send data beyond FIFO size.

This patch enables this driver can handle multiple scatter list.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/serial/pch_uart.c |  117 ++++++++++++++++++++++++++++++++++-----------
 1 files changed, 89 insertions(+), 28 deletions(-)

diff --git a/drivers/serial/pch_uart.c b/drivers/serial/pch_uart.c
index 3b2fb93..c1386eb 100644
--- a/drivers/serial/pch_uart.c
+++ b/drivers/serial/pch_uart.c
@@ -226,7 +226,8 @@ struct eg20t_port {
 	struct pch_dma_slave		param_rx;
 	struct dma_chan			*chan_tx;
 	struct dma_chan			*chan_rx;
-	struct scatterlist		sg_tx;
+	struct scatterlist		*sg_tx_p;
+	int				nent;
 	struct scatterlist		sg_rx;
 	int				tx_dma_use;
 	void				*rx_buf_virt;
@@ -595,16 +596,20 @@ static void pch_dma_rx_complete(void *arg)
 	struct eg20t_port *priv = arg;
 	struct uart_port *port = &priv->port;
 	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	int count;
 
 	if (!tty) {
 		pr_debug("%s:tty is busy now", __func__);
 		return;
 	}
 
-	if (dma_push_rx(priv, priv->trigger_level))
+	dma_sync_sg_for_cpu(port->dev, &priv->sg_rx, 1, DMA_FROM_DEVICE);
+	count = dma_push_rx(priv, priv->trigger_level);
+	if (count)
 		tty_flip_buffer_push(tty);
-
 	tty_kref_put(tty);
+	async_tx_ack(priv->desc_rx);
+	pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_RX_INT);
 }
 
 static void pch_dma_tx_complete(void *arg)
@@ -612,13 +617,21 @@ static void pch_dma_tx_complete(void *arg)
 	struct eg20t_port *priv = arg;
 	struct uart_port *port = &priv->port;
 	struct circ_buf *xmit = &port->state->xmit;
+	struct scatterlist *sg = priv->sg_tx_p;
+	int i;
 
-	xmit->tail += sg_dma_len(&priv->sg_tx);
+	for (i = 0; i < priv->nent; i++, sg++) {
+		xmit->tail += sg_dma_len(sg);
+		port->icount.tx += sg_dma_len(sg);
+	}
 	xmit->tail &= UART_XMIT_SIZE - 1;
-	port->icount.tx += sg_dma_len(&priv->sg_tx);
-
 	async_tx_ack(priv->desc_tx);
+	dma_unmap_sg(port->dev, sg, priv->nent, DMA_TO_DEVICE);
 	priv->tx_dma_use = 0;
+	priv->nent = 0;
+	kfree(priv->sg_tx_p);
+	if (uart_circ_chars_pending(xmit))
+		pch_uart_hal_enable_interrupt(priv, PCH_UART_HAL_TX_INT);
 }
 
 static int pop_tx(struct eg20t_port *priv, unsigned char *buf, int size)
@@ -682,7 +695,7 @@ static int dma_handle_rx(struct eg20t_port *priv)
 
 	sg_init_table(&priv->sg_rx, 1); /* Initialize SG table */
 
-	sg_dma_len(sg) = priv->fifo_size;
+	sg_dma_len(sg) = priv->trigger_level;
 
 	sg_set_page(&priv->sg_rx, virt_to_page(priv->rx_buf_virt),
 		     sg_dma_len(sg), (unsigned long)priv->rx_buf_virt &
@@ -692,7 +705,8 @@ static int dma_handle_rx(struct eg20t_port *priv)
 
 	desc = priv->chan_rx->device->device_prep_slave_sg(priv->chan_rx,
 			sg, 1, DMA_FROM_DEVICE,
-			DMA_PREP_INTERRUPT);
+			DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+
 	if (!desc)
 		return 0;
 
@@ -731,6 +745,9 @@ static unsigned int handle_tx(struct eg20t_port *priv)
 		fifo_size--;
 	}
 	size = min(xmit->head - xmit->tail, fifo_size);
+	if (size < 0)
+		size = fifo_size;
+
 	tx_size = pop_tx(priv, xmit->buf, size);
 	if (tx_size > 0) {
 		ret = pch_uart_hal_write(priv, xmit->buf, tx_size);
@@ -740,8 +757,10 @@ static unsigned int handle_tx(struct eg20t_port *priv)
 
 	priv->tx_empty = tx_empty;
 
-	if (tx_empty)
+	if (tx_empty) {
 		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
+		uart_write_wakeup(port);
+	}
 
 	return PCH_UART_HANDLED_TX_INT;
 }
@@ -750,11 +769,16 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 {
 	struct uart_port *port = &priv->port;
 	struct circ_buf *xmit = &port->state->xmit;
-	struct scatterlist *sg = &priv->sg_tx;
+	struct scatterlist *sg;
 	int nent;
 	int fifo_size;
 	int tx_empty;
 	struct dma_async_tx_descriptor *desc;
+	int num;
+	int i;
+	int bytes;
+	int size;
+	int rem;
 
 	if (!priv->start_tx) {
 		pr_info("%s:Tx isn't started. (%lu)\n", __func__, jiffies);
@@ -772,37 +796,68 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 		fifo_size--;
 	}
 
-	pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
+	bytes = min((int)CIRC_CNT(xmit->head, xmit->tail,
+			     UART_XMIT_SIZE), CIRC_CNT_TO_END(xmit->head,
+			     xmit->tail, UART_XMIT_SIZE));
+	if (!bytes) {
+		pch_uart_hal_disable_interrupt(priv, PCH_UART_HAL_TX_INT);
+		uart_write_wakeup(port);
+		return 0;
+	}
+
+	if (bytes > fifo_size) {
+		num = bytes / fifo_size + 1;
+		size = fifo_size;
+		rem = bytes % fifo_size;
+	} else {
+		num = 1;
+		size = bytes;
+		rem = bytes;
+	}
 
 	priv->tx_dma_use = 1;
 
-	sg_init_table(&priv->sg_tx, 1); /* Initialize SG table */
+	priv->sg_tx_p = kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
+
+	sg_init_table(priv->sg_tx_p, num); /* Initialize SG table */
+	sg = priv->sg_tx_p;
 
-	sg_set_page(&priv->sg_tx, virt_to_page(xmit->buf),
-		    UART_XMIT_SIZE, (int)xmit->buf & ~PAGE_MASK);
+	for (i = 0; i < num; i++, sg++) {
+		if (i == (num - 1))
+			sg_set_page(sg, virt_to_page(xmit->buf),
+				    rem, fifo_size * i);
+		else
+			sg_set_page(sg, virt_to_page(xmit->buf),
+				    size, fifo_size * i);
+	}
 
-	nent = dma_map_sg(port->dev, &priv->sg_tx, 1, DMA_TO_DEVICE);
+	sg = priv->sg_tx_p;
+	nent = dma_map_sg(port->dev, sg, num, DMA_TO_DEVICE);
 	if (!nent) {
 		pr_err("%s:dma_map_sg Failed\n", __func__);
 		return 0;
 	}
-
-	sg->offset = xmit->tail & (UART_XMIT_SIZE - 1);
-	sg_dma_address(sg) = (sg_dma_address(sg) & ~(UART_XMIT_SIZE - 1)) +
-			      sg->offset;
-	sg_dma_len(sg) = min((int)CIRC_CNT(xmit->head, xmit->tail,
-			     UART_XMIT_SIZE), CIRC_CNT_TO_END(xmit->head,
-			     xmit->tail, UART_XMIT_SIZE));
+	priv->nent = nent;
+
+	for (i = 0; i < nent; i++, sg++) {
+		sg->offset = (xmit->tail & (UART_XMIT_SIZE - 1)) +
+			      fifo_size * i;
+		sg_dma_address(sg) = (sg_dma_address(sg) &
+				    ~(UART_XMIT_SIZE - 1)) + sg->offset;
+		if (i == (nent - 1))
+			sg_dma_len(sg) = rem;
+		else
+			sg_dma_len(sg) = size;
+	}
 
 	desc = priv->chan_tx->device->device_prep_slave_sg(priv->chan_tx,
-		sg, nent, DMA_TO_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+					priv->sg_tx_p, nent, DMA_TO_DEVICE,
+					DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!desc) {
 		pr_err("%s:device_prep_slave_sg Failed\n", __func__);
 		return 0;
 	}
-
-	dma_sync_sg_for_device(port->dev, sg, 1, DMA_TO_DEVICE);
-
+	dma_sync_sg_for_device(port->dev, priv->sg_tx_p, nent, DMA_TO_DEVICE);
 	priv->desc_tx = desc;
 	desc->callback = pch_dma_tx_complete;
 	desc->callback_param = priv;
@@ -857,10 +912,16 @@ static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
 			}
 			break;
 		case PCH_UART_IID_RDR:	/* Received Data Ready */
-			if (priv->use_dma)
+			if (priv->use_dma) {
+				pch_uart_hal_disable_interrupt(priv,
+							PCH_UART_HAL_RX_INT);
 				ret = dma_handle_rx(priv);
-			else
+				if (!ret)
+					pch_uart_hal_enable_interrupt(priv,
+							PCH_UART_HAL_RX_INT);
+			} else {
 				ret = handle_rx(priv);
+			}
 			break;
 		case PCH_UART_IID_RDR_TO:	/* Received Data Ready
 						   (FIFO Timeout) */
-- 
1.7.3.4

