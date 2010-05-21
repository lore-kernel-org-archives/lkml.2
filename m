Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212Ab0EUQyI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:08 -0400
Received: from kroah.org ([198.145.64.141]:50331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934117Ab0EUQwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Linn <john.linn@xilinx.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/25] serial: uartlite: move from byte accesses to word accesses
Date: Fri, 21 May 2010 09:51:46 -0700
Message-Id: <1274460714-11277-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Linn <john.linn@xilinx.com>

Byte accesses for I/O devices in Xilinx IP is going to be less
desired in the future such that the driver is being changed to
use 32 bit accesses.

This change facilitates using the uartlite IP over a PCIe bus
which only allows 32 bit accesses.

Signed-off-by: John Linn <john.linn@xilinx.com>
Tested-by: Michal Simek <monstr@monstr.eu>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/uartlite.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index f0a6c61..e6639a9 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -86,7 +86,7 @@ static int ulite_receive(struct uart_port *port, int stat)
 	/* stats */
 	if (stat & ULITE_STATUS_RXVALID) {
 		port->icount.rx++;
-		ch = readb(port->membase + ULITE_RX);
+		ch = ioread32be(port->membase + ULITE_RX);
 
 		if (stat & ULITE_STATUS_PARITY)
 			port->icount.parity++;
@@ -131,7 +131,7 @@ static int ulite_transmit(struct uart_port *port, int stat)
 		return 0;
 
 	if (port->x_char) {
-		writeb(port->x_char, port->membase + ULITE_TX);
+		iowrite32be(port->x_char, port->membase + ULITE_TX);
 		port->x_char = 0;
 		port->icount.tx++;
 		return 1;
@@ -140,7 +140,7 @@ static int ulite_transmit(struct uart_port *port, int stat)
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
 		return 0;
 
-	writeb(xmit->buf[xmit->tail], port->membase + ULITE_TX);
+	iowrite32be(xmit->buf[xmit->tail], port->membase + ULITE_TX);
 	xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE-1);
 	port->icount.tx++;
 
@@ -157,7 +157,7 @@ static irqreturn_t ulite_isr(int irq, void *dev_id)
 	int busy, n = 0;
 
 	do {
-		int stat = readb(port->membase + ULITE_STATUS);
+		int stat = ioread32be(port->membase + ULITE_STATUS);
 		busy  = ulite_receive(port, stat);
 		busy |= ulite_transmit(port, stat);
 		n++;
@@ -178,7 +178,7 @@ static unsigned int ulite_tx_empty(struct uart_port *port)
 	unsigned int ret;
 
 	spin_lock_irqsave(&port->lock, flags);
-	ret = readb(port->membase + ULITE_STATUS);
+	ret = ioread32be(port->membase + ULITE_STATUS);
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	return ret & ULITE_STATUS_TXEMPTY ? TIOCSER_TEMT : 0;
@@ -201,7 +201,7 @@ static void ulite_stop_tx(struct uart_port *port)
 
 static void ulite_start_tx(struct uart_port *port)
 {
-	ulite_transmit(port, readb(port->membase + ULITE_STATUS));
+	ulite_transmit(port, ioread32be(port->membase + ULITE_STATUS));
 }
 
 static void ulite_stop_rx(struct uart_port *port)
@@ -230,17 +230,17 @@ static int ulite_startup(struct uart_port *port)
 	if (ret)
 		return ret;
 
-	writeb(ULITE_CONTROL_RST_RX | ULITE_CONTROL_RST_TX,
+	iowrite32be(ULITE_CONTROL_RST_RX | ULITE_CONTROL_RST_TX,
 	       port->membase + ULITE_CONTROL);
-	writeb(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
+	iowrite32be(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
 
 	return 0;
 }
 
 static void ulite_shutdown(struct uart_port *port)
 {
-	writeb(0, port->membase + ULITE_CONTROL);
-	readb(port->membase + ULITE_CONTROL); /* dummy */
+	iowrite32be(0, port->membase + ULITE_CONTROL);
+	ioread32be(port->membase + ULITE_CONTROL); /* dummy */
 	free_irq(port->irq, port);
 }
 
@@ -352,7 +352,7 @@ static void ulite_console_wait_tx(struct uart_port *port)
 
 	/* Spin waiting for TX fifo to have space available */
 	for (i = 0; i < 100000; i++) {
-		val = readb(port->membase + ULITE_STATUS);
+		val = ioread32be(port->membase + ULITE_STATUS);
 		if ((val & ULITE_STATUS_TXFULL) == 0)
 			break;
 		cpu_relax();
@@ -362,7 +362,7 @@ static void ulite_console_wait_tx(struct uart_port *port)
 static void ulite_console_putchar(struct uart_port *port, int ch)
 {
 	ulite_console_wait_tx(port);
-	writeb(ch, port->membase + ULITE_TX);
+	iowrite32be(ch, port->membase + ULITE_TX);
 }
 
 static void ulite_console_write(struct console *co, const char *s,
@@ -379,8 +379,8 @@ static void ulite_console_write(struct console *co, const char *s,
 		spin_lock_irqsave(&port->lock, flags);
 
 	/* save and disable interrupt */
-	ier = readb(port->membase + ULITE_STATUS) & ULITE_STATUS_IE;
-	writeb(0, port->membase + ULITE_CONTROL);
+	ier = ioread32be(port->membase + ULITE_STATUS) & ULITE_STATUS_IE;
+	iowrite32be(0, port->membase + ULITE_CONTROL);
 
 	uart_console_write(port, s, count, ulite_console_putchar);
 
@@ -388,7 +388,7 @@ static void ulite_console_write(struct console *co, const char *s,
 
 	/* restore interrupt state */
 	if (ier)
-		writeb(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
+		iowrite32be(ULITE_CONTROL_IE, port->membase + ULITE_CONTROL);
 
 	if (locked)
 		spin_unlock_irqrestore(&port->lock, flags);
@@ -601,7 +601,7 @@ ulite_of_probe(struct of_device *op, const struct of_device_id *match)
 
 	id = of_get_property(op->node, "port-number", NULL);
 
-	return ulite_assign(&op->dev, id ? *id : -1, res.start+3, irq);
+	return ulite_assign(&op->dev, id ? *id : -1, res.start, irq);
 }
 
 static int __devexit ulite_of_remove(struct of_device *op)
-- 
1.7.0.3

