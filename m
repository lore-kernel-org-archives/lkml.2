Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0FIH4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:56:45 -0400
Received: from mail-ew0-f223.google.com ([209.85.219.223]:62199 "EHLO
	mail-ew0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FIH4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Fjti+YcnPqnE0iiMOWpgcMzvMaJaoFWl7dLqJZMqzzQC1LkvfBN/W3TGcp/qXOcbVM
         3a7ny6nNVY9howHtqVAzN4fQR119lY4dFXH7DqDiwC6WgEoVbfXRmrnUppBaCo5RDYPm
         Nt42gug2kbaC8Z5V84pfZWzMDvFFO5yFuY+Zk=
From: ygeorgie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Yury Georgievskiy <ygeorgie@gmail.com>
Subject: [PATCH 1/1] serial: mcf: Don't take spinlocks in already protected functions
Date: Wed,  9 Jun 2010 09:56:26 +0200
Message-Id: <1276070186-11393-1-git-send-email-ygeorgie@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yury Georgievskiy <ygeorgie@gmail.com>

Don't take the port spinlock in uart functions where the serial core
already takes care of locking/unlocking them.

The code would actually lock up on architectures where spinlocks are
implemented.

Also protect calling mcf_rx_chars/mcf_tx_chars in the
interrupt handler by the port spinlock and use IRQ_RETVAL
to return from isr.

Signed-off-by: Yury Georgievskiy <ygeorgie@gmail.com>
---
 drivers/serial/mcf.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/serial/mcf.c b/drivers/serial/mcf.c
index b5aaef9..6235444 100644
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
@@ -368,11 +354,15 @@ static irqreturn_t mcf_interrupt(int irq, void *data)
 	unsigned int isr;
 
 	isr = readb(port->membase + MCFUART_UISR) & pp->imr;
+
+	spin_lock(&port->lock);
 	if (isr & MCFUART_UIR_RXREADY)
 		mcf_rx_chars(pp);
 	if (isr & MCFUART_UIR_TXREADY)
 		mcf_tx_chars(pp);
-	return IRQ_HANDLED;
+	spin_unlock(&port->lock);
+
+	return IRQ_RETVAL(isr);
 }
 
 /****************************************************************************/
-- 
1.7.0

