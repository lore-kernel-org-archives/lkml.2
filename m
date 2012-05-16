Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab2EPGdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:33:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:42797 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024Ab2EPGdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:33:25 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h2a8h668h839hd24he5bhe96h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 3/4] serial: bfin_uart: RTS and CTS MMRs can be either 16-bit width or 32-bit width.
Date: Wed, 16 May 2012 14:22:25 +0800
Message-ID: <1337149346-5277-3-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
References: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Change hardware flow control code to adapt to both bf5xx and bf60x.
Disabled serial device before set termios for bf60x.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/tty/serial/bfin_uart.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 56b95b0..7924ba6 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -549,7 +549,7 @@ static irqreturn_t bfin_serial_dma_tx_int(int irq, void *dev_id)
 static irqreturn_t bfin_serial_dma_rx_int(int irq, void *dev_id)
 {
 	struct bfin_serial_port *uart = dev_id;
-	unsigned short irqstat;
+	unsigned int irqstat;
 	int x_pos, pos;
 
 	spin_lock(&uart->rx_lock);
@@ -582,7 +582,7 @@ static irqreturn_t bfin_serial_dma_rx_int(int irq, void *dev_id)
 static unsigned int bfin_serial_tx_empty(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	unsigned short lsr;
+	unsigned int lsr;
 
 	lsr = UART_GET_LSR(uart);
 	if (lsr & TEMT)
@@ -741,7 +741,7 @@ static int bfin_serial_startup(struct uart_port *port)
 		}
 
 		/* CTS RTS PINs are negative assertive. */
-		UART_PUT_MCR(uart, ACTS);
+		UART_PUT_MCR(uart, UART_GET_MCR(uart) | ACTS);
 		UART_SET_IER(uart, EDSSI);
 	}
 #endif
@@ -799,7 +799,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
 	unsigned long flags;
 	unsigned int baud, quot;
-	unsigned short val, ier, lcr = 0;
+	unsigned int ier, lcr = 0;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS8:
@@ -871,6 +871,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* Disable UART */
 	ier = UART_GET_IER(uart);
+	UART_PUT_GCTL(uart, UART_GET_GCTL(uart) & ~UCEN);
 	UART_DISABLE_INTS(uart);
 
 	/* Set DLAB in LCR to Access CLK */
@@ -882,14 +883,11 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* Clear DLAB in LCR to Access THR RBR IER */
 	UART_CLEAR_DLAB(uart);
 
-	UART_PUT_LCR(uart, lcr);
+	UART_PUT_LCR(uart, (UART_GET_LCR(uart) & ~LCR_MASK) | lcr);
 
 	/* Enable UART */
 	UART_ENABLE_INTS(uart, ier);
-
-	val = UART_GET_GCTL(uart);
-	val |= UCEN;
-	UART_PUT_GCTL(uart, val);
+	UART_PUT_GCTL(uart, UART_GET_GCTL(uart) | UCEN);
 
 	/* Port speed changed, update the per-port timeout. */
 	uart_update_timeout(port, termios->c_cflag, baud);
@@ -949,7 +947,7 @@ bfin_serial_verify_port(struct uart_port *port, struct serial_struct *ser)
 static void bfin_serial_set_ldisc(struct uart_port *port, int ld)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	unsigned short val;
+	unsigned int val;
 
 	switch (ld) {
 	case N_IRDA:
@@ -967,7 +965,7 @@ static void bfin_serial_set_ldisc(struct uart_port *port, int ld)
 static void bfin_serial_reset_irda(struct uart_port *port)
 {
 	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	unsigned short val;
+	unsigned int val;
 
 	val = UART_GET_GCTL(uart);
 	val &= ~(UMOD_MASK | RPOLC);
@@ -1065,7 +1063,7 @@ static void __init
 bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 			   int *parity, int *bits)
 {
-	unsigned short status;
+	unsigned int status;
 
 	status = UART_GET_IER(uart) & (ERBFI | ETBEI);
 	if (status == (ERBFI | ETBEI)) {
-- 
1.7.0.4


