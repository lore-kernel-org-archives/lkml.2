Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1LUPiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:38:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:59489 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab1LUPiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:38:13 -0500
Date: Wed, 21 Dec 2011 16:38:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] kvm tool: Implement a serial FIFO emulation
Message-ID: <alpine.LFD.2.02.1112211632490.3020@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding FIFO functionality to the serial emulator to speed up the
console handling.

This also restricts sysrq functionality to the first serial port and
fixes the sysrq injection, which was broken because nothing ever reset
the BI status bit in the LSR.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 tools/kvm/hw/serial.c |  124 ++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 90 insertions(+), 34 deletions(-)

Index: linux-kvm/tools/kvm/hw/serial.c
===================================================================
--- linux-kvm.orig/tools/kvm/hw/serial.c
+++ linux-kvm/tools/kvm/hw/serial.c
@@ -12,6 +12,15 @@
 
 #include <pthread.h>
 
+/*
+ * This fakes a U6_16550A. The fifo len needs to be 64 as the kernel
+ * expects that for autodetection.
+ */
+#define FIFO_LEN		64
+#define FIFO_MASK		(FIFO_LEN - 1)
+
+#define UART_IIR_TYPE_BITS	0xc0
+
 struct serial8250_device {
 	pthread_mutex_t		mutex;
 	u8			id;
@@ -20,8 +29,11 @@ struct serial8250_device {
 	u8			irq;
 	u8			irq_state;
 	int			txcnt;
+	int			rxcnt;
+	int			rxdone;
+	char			txbuf[FIFO_LEN];
+	char			rxbuf[FIFO_LEN];
 
-	u8			rbr;		/* receive buffer */
 	u8			dll;
 	u8			dlm;
 	u8			iir;
@@ -83,10 +95,34 @@ static struct serial8250_device devices[
 	},
 };
 
+static void serial8250_flush_tx(struct serial8250_device *dev)
+{
+	dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
+
+	if (dev->txcnt) {
+		term_putc(CONSOLE_8250, dev->txbuf, dev->txcnt, dev->id);
+		dev->txcnt = 0;
+	}
+}
+
 static void serial8250_update_irq(struct kvm *kvm, struct serial8250_device *dev)
 {
 	u8 iir = 0;
 
+	/* Handle clear rx */
+	if (dev->lcr & UART_FCR_CLEAR_RCVR) {
+		dev->lcr &= ~UART_FCR_CLEAR_RCVR;
+		dev->rxcnt = dev->rxdone = 0;
+		dev->lsr &= ~UART_LSR_DR;
+	}
+
+	/* Handle clear tx */
+	if (dev->lcr & UART_FCR_CLEAR_XMIT) {
+		dev->lcr &= ~UART_FCR_CLEAR_XMIT;
+		dev->txcnt = 0;
+		dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
+	}
+
 	/* Data ready and rcv interrupt enabled ? */
 	if ((dev->ier & UART_IER_RDI) && (dev->lsr & UART_LSR_DR))
 		iir |= UART_IIR_RDI;
@@ -112,66 +148,57 @@ static void serial8250_update_irq(struct
 	 * is nothing more to transmit, so we can reset our tx logic
 	 * here.
 	 */
-	if (!(dev->ier & UART_IER_THRI)) {
-		dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
-		dev->txcnt = 0;
-	}
+	if (!(dev->ier & UART_IER_THRI))
+		serial8250_flush_tx(dev);
 }
 
 #define SYSRQ_PENDING_NONE		0
 #define SYSRQ_PENDING_BREAK		1
-#define SYSRQ_PENDING_CMD		2
 
 static int sysrq_pending;
 
 static void serial8250__sysrq(struct kvm *kvm, struct serial8250_device *dev)
 {
-	switch (sysrq_pending) {
-	case SYSRQ_PENDING_BREAK:
-		dev->lsr |= UART_LSR_DR | UART_LSR_BI;
-
-		sysrq_pending = SYSRQ_PENDING_CMD;
-		break;
-	case SYSRQ_PENDING_CMD:
-		dev->rbr = 'p';
-		dev->lsr |= UART_LSR_DR;
-
-		sysrq_pending	= SYSRQ_PENDING_NONE;
-		break;
-	}
+	dev->lsr |= UART_LSR_DR | UART_LSR_BI;
+	dev->rxbuf[dev->rxcnt++] = 'p';
+	sysrq_pending	= SYSRQ_PENDING_NONE;
 }
 
-static void serial8250__receive(struct kvm *kvm, struct serial8250_device *dev)
+static void serial8250__receive(struct kvm *kvm, struct serial8250_device *dev,
+				bool handle_sysrq)
 {
 	int c;
 
 	/*
-	 * If the guest transmitted 16 chars in a row, we clear the
+	 * If the guest transmitted a full fifo, we clear the
 	 * TEMT/THRE bits to let the kernel escape from the 8250
 	 * interrupt handler. We come here only once a ms, so that
-	 * should give the kernel the desired pause.
+	 * should give the kernel the desired pause. That also flushes
+	 * the tx fifo to the terminal.
 	 */
-	dev->lsr |= UART_LSR_TEMT | UART_LSR_THRE;
-	dev->txcnt = 0;
+	serial8250_flush_tx(dev);
 
-	if (dev->lsr & UART_LSR_DR)
+	if (dev->mcr & UART_MCR_LOOP)
 		return;
 
-	if (sysrq_pending) {
-		serial8250__sysrq(kvm, dev);
+	if ((dev->lsr & UART_LSR_DR) || dev->rxcnt)
 		return;
-	}
 
-	if (!term_readable(CONSOLE_8250, dev->id))
+	if (handle_sysrq && sysrq_pending) {
+		serial8250__sysrq(kvm, dev);
 		return;
+	}
 
-	c = term_getc(CONSOLE_8250, dev->id);
+	while (term_readable(CONSOLE_8250, dev->id) &&
+	       dev->rxcnt < FIFO_LEN) {
 
-	if (c < 0)
-		return;
+		c = term_getc(CONSOLE_8250, dev->id);
 
-	dev->rbr = c;
-	dev->lsr |= UART_LSR_DR;
+		if (c < 0)
+			break;
+		dev->rxbuf[dev->rxcnt++] = c;
+		dev->lsr |= UART_LSR_DR;
+	}
 }
 
 void serial8250__update_consoles(struct kvm *kvm)
@@ -183,7 +210,8 @@ void serial8250__update_consoles(struct 
 
 		mutex_lock(&dev->mutex);
 
-		serial8250__receive(kvm, dev);
+		/* Restrict sysrq injection to the first port */
+		serial8250__receive(kvm, dev, i == 0);
 
 		serial8250_update_irq(kvm, dev);
 
@@ -209,11 +237,13 @@ static struct serial8250_device *find_de
 	return NULL;
 }
 
-static bool serial8250_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
+static bool serial8250_out(struct ioport *ioport, struct kvm *kvm, u16 port,
+			   void *data, int size)
 {
 	struct serial8250_device *dev;
 	u16 offset;
 	bool ret = true;
+	char *addr = data;
 
 	dev = find_device(port);
 	if (!dev)
@@ -225,23 +255,33 @@ static bool serial8250_out(struct ioport
 
 	switch (offset) {
 	case UART_TX:
-		if (!(dev->lcr & UART_LCR_DLAB)) {
-			char *addr = data;
-
-			if (!(dev->mcr & UART_MCR_LOOP))
-				term_putc(CONSOLE_8250, addr, size, dev->id);
-			/* else FIXME: Inject data into rcv path for LOOP */
+		if (dev->lcr & UART_LCR_DLAB) {
+			dev->dll = ioport__read8(data);
+			break;
+		}
 
-			if (++dev->txcnt == 16)
-				dev->lsr &= ~(UART_LSR_TEMT | UART_LSR_THRE);
+		/* Loopback mode */
+		if (dev->mcr & UART_MCR_LOOP) {
+			if (dev->rxcnt < FIFO_LEN) {
+				dev->rxbuf[dev->rxcnt++] = *addr;
+				dev->lsr |= UART_LSR_DR;
+			}
 			break;
+		}
+
+		if (dev->txcnt < FIFO_LEN) {
+			dev->txbuf[dev->txcnt++] = *addr;
+			dev->lsr &= ~UART_LSR_TEMT;
+			if (dev->txcnt == FIFO_LEN / 2)
+				dev->lsr &= ~UART_LSR_THRE;
 		} else {
-			dev->dll = ioport__read8(data);
+			/* Should never happpen */
+			dev->lsr &= ~(UART_LSR_TEMT | UART_LSR_THRE);
 		}
 		break;
 	case UART_IER:
 		if (!(dev->lcr & UART_LCR_DLAB))
-			dev->ier = ioport__read8(data) & 0x3f;
+			dev->ier = ioport__read8(data) & 0x0f;
 		else
 			dev->dlm = ioport__read8(data);
 		break;
@@ -275,6 +315,25 @@ static bool serial8250_out(struct ioport
 	return ret;
 }
 
+static void serial8250_rx(struct serial8250_device *dev, void *data)
+{
+	if (dev->rxdone == dev->rxcnt)
+		return;
+
+	/* Break issued ? */
+	if (dev->lsr & UART_LSR_BI) {
+		dev->lsr &= ~UART_LSR_BI;
+		ioport__write8(data, 0);
+		return;
+	}
+
+	ioport__write8(data, dev->rxbuf[dev->rxdone++]);
+	if (dev->rxcnt == dev->rxdone) {
+		dev->lsr &= ~UART_LSR_DR;
+		dev->rxcnt = dev->rxdone = 0;
+	}
+}
+
 static bool serial8250_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
 {
 	struct serial8250_device *dev;
@@ -291,12 +350,10 @@ static bool serial8250_in(struct ioport 
 
 	switch (offset) {
 	case UART_RX:
-		if (dev->lcr & UART_LCR_DLAB) {
+		if (dev->lcr & UART_LCR_DLAB)
 			ioport__write8(data, dev->dll);
-		} else {
-			ioport__write8(data, dev->rbr);
-			dev->lsr &= ~UART_LSR_DR;
-		}
+		else
+			serial8250_rx(dev, data);
 		break;
 	case UART_IER:
 		if (dev->lcr & UART_LCR_DLAB)
@@ -305,7 +362,7 @@ static bool serial8250_in(struct ioport 
 			ioport__write8(data, dev->ier);
 		break;
 	case UART_IIR:
-		ioport__write8(data, dev->iir);
+		ioport__write8(data, dev->iir | UART_IIR_TYPE_BITS);
 		break;
 	case UART_LCR:
 		ioport__write8(data, dev->lcr);
