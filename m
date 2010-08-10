Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab0HJWBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:01:04 -0400
Received: from kroah.org ([198.145.64.141]:45030 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463Ab0HJWAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Yury Georgievskiy <ygeorgie@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 55/68] serial: mcf: don't take spinlocks in already protected functions
Date: Tue, 10 Aug 2010 14:59:17 -0700
Message-Id: <1281477570-18944-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yury Georgievskiy <ygeorgie@gmail.com>

Don't take the port spinlock in uart functions where the serial core
already takes care of locking/unlocking them.

The code would actually lock up on architectures where spinlocks are
implemented.

Also protect calling mcf_rx_chars/mcf_tx_chars in the interrupt handler by
the port spinlock and use IRQ_RETVAL to return from isr.

[akpm@linux-foundation.org: make irq-handler return value more explicit]
Signed-off-by: Yury Georgievskiy <ygeorgie@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/mcf.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
index b5aaef9..3394b7c 100644
--- a/drivers/serial/mcf.c
+++ b/drivers/serial/mcf.c
@@ -70,16 +70,14 @@ static unsigned int mcf_tx_empty(struct uart_port *port)
 static unsigned int mcf_get_mctrl(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 	unsigned int sigs;
 
-	spin_lock_irqsave(&port->lock, flags);
 	sigs = (readb(port->membase + MCFUART_UIPR) & MCFUART_UIPR_CTS) ?
 		0 : TIOCM_CTS;
 	sigs |= (pp->sigs & TIOCM_RTS);
 	sigs |= (mcf_getppdcd(port->line) ? TIOCM_CD : 0);
 	sigs |= (mcf_getppdtr(port->line) ? TIOCM_DTR : 0);
-	spin_unlock_irqrestore(&port->lock, flags);
+
 	return sigs;
 }
 
@@ -88,16 +86,13 @@ static unsigned int mcf_get_mctrl(struct uart_port *port)
 static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->sigs = sigs;
 	mcf_setppdtr(port->line, (sigs & TIOCM_DTR));
 	if (sigs & TIOCM_RTS)
 		writeb(MCFUART_UOP_RTS, port->membase + MCFUART_UOP1);
 	else
 		writeb(MCFUART_UOP_RTS, port->membase + MCFUART_UOP0);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -105,12 +100,9 @@ static void mcf_set_mctrl(struct uart_port *port, unsigned int sigs)
 static void mcf_start_tx(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr |= MCFUART_UIR_TXREADY;
 	writeb(pp->imr, port->membase + MCFUART_UIMR);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -118,12 +110,9 @@ static void mcf_start_tx(struct uart_port *port)
 static void mcf_stop_tx(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~MCFUART_UIR_TXREADY;
 	writeb(pp->imr, port->membase + MCFUART_UIMR);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -131,12 +120,9 @@ static void mcf_stop_tx(struct uart_port *port)
 static void mcf_stop_rx(struct uart_port *port)
 {
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~MCFUART_UIR_RXREADY;
 	writeb(pp->imr, port->membase + MCFUART_UIMR);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 /****************************************************************************/
@@ -366,13 +352,22 @@ static irqreturn_t mcf_interrupt(int irq, void *data)
 	struct uart_port *port = data;
 	struct mcf_uart *pp = container_of(port, struct mcf_uart, port);
 	unsigned int isr;
+	irqreturn_t ret = IRQ_NONE;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
-	if (isr & MCFUART_UIR_RXREADY)
+
+	spin_lock(&port->lock);
+	if (isr & MCFUART_UIR_RXREADY) {
 		mcf_rx_chars(pp);
-	if (isr & MCFUART_UIR_TXREADY)
+		ret = IRQ_HANDLED;
+	}
+	if (isr & MCFUART_UIR_TXREADY) {
 		mcf_tx_chars(pp);
-	return IRQ_HANDLED;
+		ret = IRQ_HANDLED;
+	}
+	spin_unlock(&port->lock);
+
+	return ret;
 }
 
 /****************************************************************************/
-- 
1.7.2

