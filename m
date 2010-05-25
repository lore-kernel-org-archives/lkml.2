Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab0EYPAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:00:06 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:49462 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab0EYPAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:00:04 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Tobias Klauser <tklauser@distanz.ch>,
       Ian Abbott <abbotti@mev.co.uk>, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 1/2] altera_uart: Don't take spinlock in already protected functions
Date: Tue, 25 May 2010 16:59:55 +0200
Message-Id: <1274799595-4150-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.25.145116
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __FRAUD_REFNUM 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS '
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't take the port spinlock in uart functions where the serial core
already takes care of locking/unlocking them.

The code would actually lock up on architectures where spinlocks are
implemented (not the case on nios2 where this driver is primarily used
for now, thus this bug didn't trigger).

Also protect calling altera_uart_rx_chars/altera_uart_tx_chars in the
interrupt handler by the port spinlock.

Thanks to Ian Abbott for pointing these issues out.

Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Thomas Chou <thomas@wytron.com.tw>
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/serial/altera_uart.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index bcee156..b1609cc 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -89,15 +89,12 @@ static unsigned int altera_uart_tx_empty(struct uart_port *port)
 static unsigned int altera_uart_get_mctrl(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 	unsigned int sigs;
 
-	spin_lock_irqsave(&port->lock, flags);
 	sigs =
 	    (readl(port->membase + ALTERA_UART_STATUS_REG) &
 	     ALTERA_UART_STATUS_CTS_MSK) ? TIOCM_CTS : 0;
 	sigs |= (pp->sigs & TIOCM_RTS);
-	spin_unlock_irqrestore(&port->lock, flags);
 
 	return sigs;
 }
@@ -105,49 +102,37 @@ static unsigned int altera_uart_get_mctrl(struct uart_port *port)
 static void altera_uart_set_mctrl(struct uart_port *port, unsigned int sigs)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->sigs = sigs;
 	if (sigs & TIOCM_RTS)
 		pp->imr |= ALTERA_UART_CONTROL_RTS_MSK;
 	else
 		pp->imr &= ~ALTERA_UART_CONTROL_RTS_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_start_tx(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr |= ALTERA_UART_CONTROL_TRDY_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_stop_tx(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_stop_rx(struct uart_port *port)
 {
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
-	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
 	pp->imr &= ~ALTERA_UART_CONTROL_RRDY_MSK;
 	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
-	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void altera_uart_break_ctl(struct uart_port *port, int break_state)
@@ -272,10 +257,14 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
 	unsigned int isr;
 
 	isr = readl(port->membase + ALTERA_UART_STATUS_REG) & pp->imr;
+
+	spin_lock(&port->lock);
 	if (isr & ALTERA_UART_STATUS_RRDY_MSK)
 		altera_uart_rx_chars(pp);
 	if (isr & ALTERA_UART_STATUS_TRDY_MSK)
 		altera_uart_tx_chars(pp);
+	spin_unlock(&port->lock);
+
 	return IRQ_RETVAL(isr);
 }
 
-- 
1.6.3.3

