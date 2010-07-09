Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0GINuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 09:50:50 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:50461 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773Ab0GINus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 09:50:48 -0400
Date: Fri, 9 Jul 2010 15:50:46 +0200
From: Christoph Egger <siccegge@cs.fau.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
       Sonic Zhang <sonic.zhang@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 10/11] Removing dead SERIAL_BFIN_SPORT_CTSRTS
Message-ID: <ed2d69ca06335b2bad6f03a94f78b06be5e4061a.1278682303.git.siccegge@cs.fau.de>
References: <cover.1278682302.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1278682302.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SERIAL_BFIN_SPORT_CTSRTS doesn't exist in Kconfig, therefore removing
all references for it from the source code.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
---
 drivers/serial/bfin_sport_uart.c |   85 --------------------------------------
 1 files changed, 0 insertions(+), 85 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index e57fb3d..05cd3a6 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -49,10 +49,6 @@ struct sport_uart_port {
 	unsigned short		txmask2;
 	unsigned char		stopb;
 /*	unsigned char		parib; */
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
-	int cts_pin;
-	int rts_pin;
-#endif
 };
 
 static int sport_uart_tx_chars(struct sport_uart_port *up);
@@ -203,47 +199,6 @@ static irqreturn_t sport_uart_err_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
-static unsigned int sport_get_mctrl(struct uart_port *port)
-{
-	struct sport_uart_port *up = (struct sport_uart_port *)port;
-	if (up->cts_pin < 0)
-		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
-
-	/* CTS PIN is negative assertive. */
-	if (SPORT_UART_GET_CTS(up))
-		return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
-	else
-		return TIOCM_DSR | TIOCM_CAR;
-}
-
-static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
-{
-	struct sport_uart_port *up = (struct sport_uart_port *)port;
-	if (up->rts_pin < 0)
-		return;
-
-	/* RTS PIN is negative assertive. */
-	if (mctrl & TIOCM_RTS)
-		SPORT_UART_ENABLE_RTS(up);
-	else
-		SPORT_UART_DISABLE_RTS(up);
-}
-
-/*
- * Handle any change of modem status signal.
- */
-static irqreturn_t sport_mctrl_cts_int(int irq, void *dev_id)
-{
-	struct sport_uart_port *up = (struct sport_uart_port *)dev_id;
-	unsigned int status;
-
-	status = sport_get_mctrl(&up->port);
-	uart_handle_cts_change(&up->port, status & TIOCM_CTS);
-
-	return IRQ_HANDLED;
-}
-#else
 static unsigned int sport_get_mctrl(struct uart_port *port)
 {
 	pr_debug("%s enter\n", __func__);
@@ -254,7 +209,6 @@ static void sport_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	pr_debug("%s enter\n", __func__);
 }
-#endif
 
 /* Reqeust IRQ, Setup clock */
 static int sport_startup(struct uart_port *port)
@@ -284,21 +238,6 @@ static int sport_startup(struct uart_port *port)
 		goto fail2;
 	}
 
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
-	if (up->cts_pin >= 0) {
-		if (request_irq(gpio_to_irq(up->cts_pin),
-			sport_mctrl_cts_int,
-			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
-			IRQF_DISABLED, "BFIN_SPORT_UART_CTS", up)) {
-			up->cts_pin = -1;
-			dev_info(port->dev, "Unable to attach BlackFin UART \
-				over SPORT CTS interrupt. So, disable it.\n");
-		}
-	}
-	if (up->rts_pin >= 0)
-		gpio_direction_output(up->rts_pin, 0);
-#endif
-
 	return 0;
  fail2:
 	free_irq(up->port.irq+1, up);
@@ -438,10 +377,6 @@ static void sport_shutdown(struct uart_port *port)
 	free_irq(up->port.irq, up);
 	free_irq(up->port.irq+1, up);
 	free_irq(up->err_irq, up);
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
-	if (up->cts_pin >= 0)
-		free_irq(gpio_to_irq(up->cts_pin), up);
-#endif
 }
 
 static const char *sport_type(struct uart_port *port)
@@ -599,11 +534,7 @@ sport_uart_console_setup(struct console *co, char *options)
 	int baud = 57600;
 	int bits = 8;
 	int parity = 'n';
-# ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
-	int flow = 'r';
-# else
 	int flow = 'n';
-# endif
 
 	/* Check whether an invalid uart number has been specified */
 	if (co->index < 0 || co->index >= BFIN_SPORT_UART_MAX_PORTS)
@@ -795,22 +726,6 @@ static int __devinit sport_uart_probe(struct platform_device *pdev)
 			ret = -ENOENT;
 			goto out_error_unmap;
 		}
-#ifdef CONFIG_SERIAL_BFIN_SPORT_CTSRTS
-		res = platform_get_resource(pdev, IORESOURCE_IO, 0);
-		if (res == NULL)
-			sport->cts_pin = -1;
-		else
-			sport->cts_pin = res->start;
-
-		res = platform_get_resource(pdev, IORESOURCE_IO, 1);
-		if (res == NULL)
-			sport->rts_pin = -1;
-		else
-			sport->rts_pin = res->start;
-
-		if (sport->rts_pin >= 0)
-			gpio_request(sport->rts_pin, DRV_NAME);
-#endif
 	}
 
 #ifdef CONFIG_SERIAL_BFIN_SPORT_CONSOLE
-- 
1.7.0.4

