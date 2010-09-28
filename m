Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0I1Nfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:35:46 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47083 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0I1Nfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vvh5jyNqDi15AMw4G2XsyWB2XzQPJ+v8PGMqErN65gETp4z4H81sWMOQqHwOG8IPY9
         bH/0Ty0sMZp1ZYBEYbDrnCSfpffP7XfZNi0nX/Y+fgaHW616dKpi+rvWUqX8Qi9yJZjQ
         K6W9Xd+f3T9gwRHMV+1O8BAVGWP/FFL2Y8MAQ=
Date: Tue, 28 Sep 2010 17:35:37 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] altera_uart: Add support for different address strides
Message-ID: <20100928133537.GD8289@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some controllers implement registers with a stride, to support
those we must implement the proper IO accessors.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/serial/altera_uart.c |   59 +++++++++++++++++++++++++++---------------
 include/linux/altera_uart.h  |    1 +
 2 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/altera_uart.c b/drivers/serial/altera_uart.c
index 7686aaa..0a1a066 100644
--- a/drivers/serial/altera_uart.c
+++ b/drivers/serial/altera_uart.c
@@ -78,13 +78,28 @@
 struct altera_uart {
 	struct uart_port port;
 	struct timer_list tmr;
+	int bus_shift;
 	unsigned int sigs;	/* Local copy of line sigs */
 	unsigned short imr;	/* Local IMR mirror */
 };
 
+static u32 altera_uart_readl(struct uart_port *port, int reg)
+{
+	struct altera_uart_platform_uart *platp = port->private_data;
+
+	return readl(port->membase + (reg << platp->bus_shift));
+}
+
+static void altera_uart_writel(struct uart_port *port, u32 dat, int reg)
+{
+	struct altera_uart_platform_uart *platp = port->private_data;
+
+	writel(dat, port->membase + (reg << platp->bus_shift));
+}
+
 static unsigned int altera_uart_tx_empty(struct uart_port *port)
 {
-	return (readl(port->membase + ALTERA_UART_STATUS_REG) &
+	return (altera_uart_readl(port, ALTERA_UART_STATUS_REG) &
 		ALTERA_UART_STATUS_TMT_MSK) ? TIOCSER_TEMT : 0;
 }
 
@@ -93,8 +108,7 @@ static unsigned int altera_uart_get_mctrl(struct uart_port *port)
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
 	unsigned int sigs;
 
-	sigs =
-	    (readl(port->membase + ALTERA_UART_STATUS_REG) &
+	sigs = (altera_uart_readl(port, ALTERA_UART_STATUS_REG) &
 	     ALTERA_UART_STATUS_CTS_MSK) ? TIOCM_CTS : 0;
 	sigs |= (pp->sigs & TIOCM_RTS);
 
@@ -110,7 +124,7 @@ static void altera_uart_set_mctrl(struct uart_port *port, unsigned int sigs)
 		pp->imr |= ALTERA_UART_CONTROL_RTS_MSK;
 	else
 		pp->imr &= ~ALTERA_UART_CONTROL_RTS_MSK;
-	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
+	altera_uart_writel(port, pp->imr, ALTERA_UART_CONTROL_REG);
 }
 
 static void altera_uart_start_tx(struct uart_port *port)
@@ -118,7 +132,7 @@ static void altera_uart_start_tx(struct uart_port *port)
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
 
 	pp->imr |= ALTERA_UART_CONTROL_TRDY_MSK;
-	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
+	altera_uart_writel(port, pp->imr, ALTERA_UART_CONTROL_REG);
 }
 
 static void altera_uart_stop_tx(struct uart_port *port)
@@ -126,7 +140,7 @@ static void altera_uart_stop_tx(struct uart_port *port)
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
 
 	pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
-	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
+	altera_uart_writel(port, pp->imr, ALTERA_UART_CONTROL_REG);
 }
 
 static void altera_uart_stop_rx(struct uart_port *port)
@@ -134,7 +148,7 @@ static void altera_uart_stop_rx(struct uart_port *port)
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
 
 	pp->imr &= ~ALTERA_UART_CONTROL_RRDY_MSK;
-	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
+	altera_uart_writel(port, pp->imr, ALTERA_UART_CONTROL_REG);
 }
 
 static void altera_uart_break_ctl(struct uart_port *port, int break_state)
@@ -147,7 +161,7 @@ static void altera_uart_break_ctl(struct uart_port *port, int break_state)
 		pp->imr |= ALTERA_UART_CONTROL_TRBK_MSK;
 	else
 		pp->imr &= ~ALTERA_UART_CONTROL_TRBK_MSK;
-	writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
+	altera_uart_writel(port, pp->imr, ALTERA_UART_CONTROL_REG);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -171,7 +185,7 @@ static void altera_uart_set_termios(struct uart_port *port,
 
 	spin_lock_irqsave(&port->lock, flags);
 	uart_update_timeout(port, termios->c_cflag, baud);
-	writel(baudclk, port->membase + ALTERA_UART_DIVISOR_REG);
+	altera_uart_writel(port, baudclk, ALTERA_UART_DIVISOR_REG);
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
@@ -181,14 +195,15 @@ static void altera_uart_rx_chars(struct altera_uart *pp)
 	unsigned char ch, flag;
 	unsigned short status;
 
-	while ((status = readl(port->membase + ALTERA_UART_STATUS_REG)) &
+	while ((status = altera_uart_readl(port, ALTERA_UART_STATUS_REG)) &
 	       ALTERA_UART_STATUS_RRDY_MSK) {
-		ch = readl(port->membase + ALTERA_UART_RXDATA_REG);
+		ch = altera_uart_readl(port, ALTERA_UART_RXDATA_REG);
 		flag = TTY_NORMAL;
 		port->icount.rx++;
 
 		if (status & ALTERA_UART_STATUS_E_MSK) {
-			writel(status, port->membase + ALTERA_UART_STATUS_REG);
+			altera_uart_writel(port, status,
+					   ALTERA_UART_STATUS_REG);
 
 			if (status & ALTERA_UART_STATUS_BRK_MSK) {
 				port->icount.brk++;
@@ -228,18 +243,18 @@ static void altera_uart_tx_chars(struct altera_uart *pp)
 
 	if (port->x_char) {
 		/* Send special char - probably flow control */
-		writel(port->x_char, port->membase + ALTERA_UART_TXDATA_REG);
+		altera_uart_writel(port, port->x_char, ALTERA_UART_TXDATA_REG);
 		port->x_char = 0;
 		port->icount.tx++;
 		return;
 	}
 
-	while (readl(port->membase + ALTERA_UART_STATUS_REG) &
+	while (altera_uart_readl(port, ALTERA_UART_STATUS_REG) &
 	       ALTERA_UART_STATUS_TRDY_MSK) {
 		if (xmit->head == xmit->tail)
 			break;
-		writel(xmit->buf[xmit->tail],
-		       port->membase + ALTERA_UART_TXDATA_REG);
+		altera_uart_writel(port, xmit->buf[xmit->tail],
+		       ALTERA_UART_TXDATA_REG);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
 	}
@@ -249,7 +264,7 @@ static void altera_uart_tx_chars(struct altera_uart *pp)
 
 	if (xmit->head == xmit->tail) {
 		pp->imr &= ~ALTERA_UART_CONTROL_TRDY_MSK;
-		writel(pp->imr, port->membase + ALTERA_UART_CONTROL_REG);
+		altera_uart_writel(port, pp->imr, ALTERA_UART_CONTROL_REG);
 	}
 }
 
@@ -259,7 +274,7 @@ static irqreturn_t altera_uart_interrupt(int irq, void *data)
 	struct altera_uart *pp = container_of(port, struct altera_uart, port);
 	unsigned int isr;
 
-	isr = readl(port->membase + ALTERA_UART_STATUS_REG) & pp->imr;
+	isr = altera_uart_readl(port, ALTERA_UART_STATUS_REG) & pp->imr;
 
 	spin_lock(&port->lock);
 	if (isr & ALTERA_UART_STATUS_RRDY_MSK)
@@ -285,9 +300,9 @@ static void altera_uart_config_port(struct uart_port *port, int flags)
 	port->type = PORT_ALTERA_UART;
 
 	/* Clear mask, so no surprise interrupts. */
-	writel(0, port->membase + ALTERA_UART_CONTROL_REG);
+	altera_uart_writel(port, 0, ALTERA_UART_CONTROL_REG);
 	/* Clear status register */
-	writel(0, port->membase + ALTERA_UART_STATUS_REG);
+	altera_uart_writel(port, 0, ALTERA_UART_STATUS_REG);
 }
 
 static int altera_uart_startup(struct uart_port *port)
@@ -406,6 +421,7 @@ int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
 		port->uartclk = platp[i].uartclk;
 		port->flags = ASYNC_BOOT_AUTOCONF;
 		port->ops = &altera_uart_ops;
+		port->private_data = platp;
 	}
 
 	return 0;
@@ -413,7 +429,7 @@ int __init early_altera_uart_setup(struct altera_uart_platform_uart *platp)
 
 static void altera_uart_console_putc(struct uart_port *port, const char c)
 {
-	while (!(readl(port->membase + ALTERA_UART_STATUS_REG) &
+	while (!(altera_uart_readl(port, ALTERA_UART_STATUS_REG) &
 		 ALTERA_UART_STATUS_TRDY_MSK))
 		cpu_relax();
 
@@ -531,6 +547,7 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
 	port->uartclk = platp->uartclk;
 	port->ops = &altera_uart_ops;
 	port->flags = ASYNC_BOOT_AUTOCONF;
+	port->private_data = platp;
 
 	uart_add_one_port(&altera_uart_driver, port);
 
diff --git a/include/linux/altera_uart.h b/include/linux/altera_uart.h
index 8d44106..c022c82 100644
--- a/include/linux/altera_uart.h
+++ b/include/linux/altera_uart.h
@@ -9,6 +9,7 @@ struct altera_uart_platform_uart {
 	unsigned long mapbase;	/* Physical address base */
 	unsigned int irq;	/* Interrupt vector */
 	unsigned int uartclk;	/* UART clock rate */
+	unsigned int bus_shift;	/* Bus shift (address stride) */
 };
 
 #endif /* __ALTUART_H */
-- 
1.7.0.5

