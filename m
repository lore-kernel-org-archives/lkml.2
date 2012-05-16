Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2EPGd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:33:56 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:57646
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759121Ab2EPGd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:33:26 -0400
X-SpamScore: 18
X-BigFish: VS18(z1091vcb8kzzz1202hzz8275bh8275dhz2ei87h2a8h668h839hd24he5bhe96h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH 1/4] serial:bfin_uart: Adapt bf5xx serial driver to bf60x serial4 controller.
Date: Wed, 16 May 2012 14:22:23 +0800
Message-ID: <1337149346-5277-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The serial4 controller on bf60x is an enhanced version of serial controller
on bf5xx. MMR size is 32 bits other than 16 bits. MMR GCTL, MCR and LCR are
combined into one control MMR. MSR and LSR are combined into one status MMR.

This patch adapts current bf5xx serial driver to serial4 controller on bf60x.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/tty/serial/bfin_uart.c |   32 +++++++++++++-------------------
 1 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 5832fde..9acab11 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -1,7 +1,7 @@
 /*
  * Blackfin On-Chip Serial Driver
  *
- * Copyright 2006-2010 Analog Devices Inc.
+ * Copyright 2006-2011 Analog Devices Inc.
  *
  * Enter bugs at http://blackfin.uclinux.org/
  *
@@ -35,10 +35,6 @@
 #include <asm/portmux.h>
 #include <asm/cacheflush.h>
 #include <asm/dma.h>
-
-#define port_membase(uart)     (((struct bfin_serial_port *)(uart))->port.membase)
-#define get_lsr_cache(uart)    (((struct bfin_serial_port *)(uart))->lsr)
-#define put_lsr_cache(uart, v) (((struct bfin_serial_port *)(uart))->lsr = (v))
 #include <asm/bfin_serial.h>
 
 #ifdef CONFIG_SERIAL_BFIN_MODULE
@@ -166,7 +162,7 @@ static void bfin_serial_stop_tx(struct uart_port *port)
 	uart->tx_count = 0;
 	uart->tx_done = 1;
 #else
-#ifdef CONFIG_BF54x
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF60x)
 	/* Clear TFI bit */
 	UART_PUT_LSR(uart, TFI);
 #endif
@@ -337,7 +333,7 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart)
 	struct circ_buf *xmit = &uart->port.state->xmit;
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&uart->port)) {
-#ifdef CONFIG_BF54x
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF60x)
 		/* Clear TFI bit */
 		UART_PUT_LSR(uart, TFI);
 #endif
@@ -877,11 +873,10 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 	ier = UART_GET_IER(uart);
 	UART_DISABLE_INTS(uart);
 
-	/* Set DLAB in LCR to Access DLL and DLH */
+	/* Set DLAB in LCR to Access CLK */
 	UART_SET_DLAB(uart);
 
-	UART_PUT_DLL(uart, quot & 0xFF);
-	UART_PUT_DLH(uart, (quot >> 8) & 0xFF);
+	UART_PUT_CLK(uart, quot);
 	SSYNC();
 
 	/* Clear DLAB in LCR to Access THR RBR IER */
@@ -959,12 +954,12 @@ static void bfin_serial_set_ldisc(struct uart_port *port, int ld)
 	switch (ld) {
 	case N_IRDA:
 		val = UART_GET_GCTL(uart);
-		val |= (IREN | RPOLC);
+		val |= (UMOD_IRDA | RPOLC);
 		UART_PUT_GCTL(uart, val);
 		break;
 	default:
 		val = UART_GET_GCTL(uart);
-		val &= ~(IREN | RPOLC);
+		val &= ~(UMOD_MASK | RPOLC);
 		UART_PUT_GCTL(uart, val);
 	}
 }
@@ -975,10 +970,10 @@ static void bfin_serial_reset_irda(struct uart_port *port)
 	unsigned short val;
 
 	val = UART_GET_GCTL(uart);
-	val &= ~(IREN | RPOLC);
+	val &= ~(UMOD_MASK | RPOLC);
 	UART_PUT_GCTL(uart, val);
 	SSYNC();
-	val |= (IREN | RPOLC);
+	val |= (UMOD_IRDA | RPOLC);
 	UART_PUT_GCTL(uart, val);
 	SSYNC();
 }
@@ -1075,7 +1070,7 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 	status = UART_GET_IER(uart) & (ERBFI | ETBEI);
 	if (status == (ERBFI | ETBEI)) {
 		/* ok, the port was enabled */
-		u16 lcr, dlh, dll;
+		u16 lcr, clk;
 
 		lcr = UART_GET_LCR(uart);
 
@@ -1100,16 +1095,15 @@ bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
 			*bits = 8;
 			break;
 		}
-		/* Set DLAB in LCR to Access DLL and DLH */
+		/* Set DLAB in LCR to Access CLK */
 		UART_SET_DLAB(uart);
 
-		dll = UART_GET_DLL(uart);
-		dlh = UART_GET_DLH(uart);
+		clk = UART_GET_CLK(uart);
 
 		/* Clear DLAB in LCR to Access THR RBR IER */
 		UART_CLEAR_DLAB(uart);
 
-		*baud = get_sclk() / (16*(dll | dlh << 8));
+		*baud = get_sclk() / (16*clk);
 	}
 	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __func__, *baud, *parity, *bits);
 }
-- 
1.7.0.4


