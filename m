Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab0FDUsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:48:10 -0400
Received: from kroah.org ([198.145.64.141]:44023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab0FDUsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:48:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tobias Klauser <tklauser@distanz.ch>, Ian Abbott <abbotti@mev.co.uk>,
       Thomas Chou <thomas@wytron.com.tw>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/11] altera_uart: Don't take spinlock in already protected functions
Date: Fri,  4 Jun 2010 13:47:52 -0700
Message-Id: <1275684477-20172-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100604204445.GB19761@kroah.com>
References: <20100604204445.GB19761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.1

