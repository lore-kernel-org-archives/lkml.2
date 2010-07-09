Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab0GINum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:50:42 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50443 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773Ab0GINuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:50:37 -0400
Date: Fri, 9 Jul 2010 15:50:35 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Sonic Zhang <sonic.zhang@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Mike Frysinger <vapier@gentoo.org>, Graf Yang <graf.yang@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 09/11] Removing dead SERIAL_BFIN_{HARD_,}CTSRTS
Message-ID: <2c4cc1817c05dad1183df108c35ae2e164638fc1.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SERIAL_BFIN_{HARD_,}CTSRTS doesn't exist in Kconfig, therefore
removing all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/bfin_5xx.c |  103 ---------------------------------------------
 1 files changed, 0 insertions(+), 103 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 96f7e74..2ec9e5c 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -82,53 +82,6 @@ static void bfin_serial_tx_chars(struct bfin_serial_port *uart);
 
 static void bfin_serial_reset_irda(struct uart_port *port);
 
-#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
-	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
-static unsigned int bfin_serial_get_mctrl(struct uart_port *port)
-{
-	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	if (uart->cts_pin < 0)
-		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
-
-	/* CTS PIN is negative assertive. */
-	if (UART_GET_CTS(uart))
-		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
-	else
-		return TIOCM_DSR | TIOCM_CAR;
-}
-
-static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
-{
-	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
-	if (uart->rts_pin < 0)
-		return;
-
-	/* RTS PIN is negative assertive. */
-	if (mctrl & TIOCM_RTS)
-		UART_ENABLE_RTS(uart);
-	else
-		UART_DISABLE_RTS(uart);
-}
-
-/*
- * Handle any change of modem status signal.
- */
-static irqreturn_t bfin_serial_mctrl_cts_int(int irq, void *dev_id)
-{
-	struct bfin_serial_port *uart = dev_id;
-	unsigned int status;
-
-	status = bfin_serial_get_mctrl(&uart->port);
-	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
-#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	uart->scts = 1;
-	UART_CLEAR_SCTS(uart);
-	UART_CLEAR_IER(uart, EDSSI);
-#endif
-
-	return IRQ_HANDLED;
-}
-#else
 static unsigned int bfin_serial_get_mctrl(struct uart_port *port)
 {
 	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
@@ -137,7 +90,6 @@ static unsigned int bfin_serial_get_mctrl(struct uart_port *port)
 static void bfin_serial_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 }
-#endif
 
 /*
  * interrupts are disabled on entry
@@ -727,35 +679,6 @@ static int bfin_serial_startup(struct uart_port *port)
 # endif
 #endif
 
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0) {
-		if (request_irq(gpio_to_irq(uart->cts_pin),
-			bfin_serial_mctrl_cts_int,
-			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
-			IRQF_DISABLED, "BFIN_UART_CTS", uart)) {
-			uart->cts_pin = -1;
-			pr_info("Unable to attach BlackFin UART CTS interrupt.\
-				 So, disable it.\n");
-		}
-	}
-	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, DRIVER_NAME);
-		gpio_direction_output(uart->rts_pin, 0);
-	}
-#endif
-#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (request_irq(uart->status_irq,
-		bfin_serial_mctrl_cts_int,
-		IRQF_DISABLED, "BFIN_UART_MODEM_STATUS", uart)) {
-		pr_info("Unable to attach BlackFin UART Modem \
-			Status interrupt.\n");
-	}
-
-	/* CTS RTS PINs are negative assertive. */
-	UART_PUT_MCR(uart, ACTS);
-	UART_SET_IER(uart, EDSSI);
-#endif
-
 	UART_SET_IER(uart, ERBFI);
 	return 0;
 }
@@ -790,16 +713,6 @@ static void bfin_serial_shutdown(struct uart_port *port)
 	free_irq(uart->port.irq+1, uart);
 #endif
 
-#ifdef CONFIG_SERIAL_BFIN_CTSRTS
-	if (uart->cts_pin >= 0)
-		free_irq(gpio_to_irq(uart->cts_pin), uart);
-	if (uart->rts_pin >= 0)
-		gpio_free(uart->rts_pin);
-#endif
-#ifdef CONFIG_SERIAL_BFIN_HARD_CTSRTS
-	if (UART_GET_IER(uart) && EDSSI)
-		free_irq(uart->status_irq, uart);
-#endif
 }
 
 static void
@@ -1134,13 +1047,6 @@ static void __init bfin_serial_init_ports(void)
 			bfin_serial_resource[i].uart_rx_dma_channel;
 		init_timer(&(bfin_serial_ports[i].rx_dma_timer));
 #endif
-#if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
-	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
-		bfin_serial_ports[i].cts_pin	    =
-			bfin_serial_resource[i].uart_cts_pin;
-		bfin_serial_ports[i].rts_pin	    =
-			bfin_serial_resource[i].uart_rts_pin;
-#endif
 	}
 }
 
@@ -1198,12 +1104,7 @@ bfin_serial_console_setup(struct console *co, char *options)
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
-# if defined(CONFIG_SERIAL_BFIN_CTSRTS) || \
-	defined(CONFIG_SERIAL_BFIN_HARD_CTSRTS)
-	int flow = 'r';
-# else
 	int flow = 'n';
-# endif
 
 	/*
 	 * Check whether an invalid uart number has been specified, and
@@ -1401,10 +1302,6 @@ static int bfin_serial_remove(struct platform_device *dev)
 			continue;
 		uart_remove_one_port(&bfin_serial_reg, &bfin_serial_ports[i].port);
 		bfin_serial_ports[i].port.dev = NULL;
-#if defined(CONFIG_SERIAL_BFIN_CTSRTS)
-		gpio_free(bfin_serial_ports[i].cts_pin);
-		gpio_free(bfin_serial_ports[i].rts_pin);
-#endif
 	}
 
 	return 0;
-- 
1.7.0.4

