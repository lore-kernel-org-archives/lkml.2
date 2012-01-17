Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2AQKaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 05:30:14 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:51699 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab2AQKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 05:30:11 -0500
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: <gregkh@suse.de>, <linux-serial@vger.kernel.org>,
        <rmk+kernel@arm.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Subject: [PATCH] amba-pl011: do not disable RTS during shutdown
Date: Tue, 17 Jan 2012 15:59:49 +0530
Message-ID: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>

In present driver, shutdown clears RTS in CR register. But the
documentation "Documentation/serial/driver" suggests not to
disable RTS in shutdown(). Also RTS is preserved between shutdown
and startup calls, i.e. it is restored in startup if it was enabled
during shutdown. So that if autorts is set and RTS is set using
pl011_set_mctrl then it should continue even after shutdown->startup
sequence. And hence during set_termios it will enable RTS only if RTS
bit is set in UARTx_CR register. For throttling/unthrottling user
should call pl011_set_mctrl.

Change-Id: I743f33fb10e7e655657cd5dae1ec585e914a65bc
Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/tty/serial/amba-pl011.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6958594..46a4690 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -160,6 +160,7 @@ struct uart_amba_port {
 	unsigned int		lcrh_tx;	/* vendor-specific */
 	unsigned int		lcrh_rx;	/* vendor-specific */
 	bool			autorts;
+	bool			rts_state;	/* state during shutdown */
 	char			type[12];
 	bool			interrupt_may_hang; /* vendor-specific */
 #ifdef CONFIG_DMA_ENGINE
@@ -1412,6 +1413,8 @@ static int pl011_startup(struct uart_port *port)
 		barrier();
 
 	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
+	if (uap->rts_state)
+		cr |= UART011_CR_RTS;
 	writew(cr, uap->port.membase + UART011_CR);
 
 	/* Clear pending error interrupts */
@@ -1469,6 +1472,7 @@ static void pl011_shutdown_channel(struct uart_amba_port *uap,
 static void pl011_shutdown(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int cr;
 
 	/*
 	 * disable all interrupts
@@ -1488,9 +1492,19 @@ static void pl011_shutdown(struct uart_port *port)
 
 	/*
 	 * disable the port
+	 * disable the port. It should not disable RTS.
+	 * Also RTS state should be preserved to restore
+	 * it during startup().
 	 */
 	uap->autorts = false;
-	writew(UART01x_CR_UARTEN | UART011_CR_TXE, uap->port.membase + UART011_CR);
+	cr = readw(uap->port.membase + UART011_CR);
+	if (cr & UART011_CR_RTS) {
+		uap->rts_state = true;
+		cr = UART011_CR_RTS;
+	} else
+		uap->rts_state = false;
+	cr |= UART01x_CR_UARTEN | UART011_CR_TXE;
+	writew(cr, uap->port.membase + UART011_CR);
 
 	/*
 	 * disable break condition and fifos
@@ -1905,6 +1919,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
+	uap->rts_state = false;
 	uap->fifosize = vendor->fifosize;
 	uap->interrupt_may_hang = vendor->interrupt_may_hang;
 	uap->port.dev = &dev->dev;
-- 
1.7.4.3

