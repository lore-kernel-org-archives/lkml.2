Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab2ARJpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:45:30 -0500
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:54305 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757104Ab2ARJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:45:28 -0500
Date: Wed, 18 Jan 2012 15:15:06 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: do not disable RTS during shutdown
Message-ID: <20120118094505.GA889@bnru02.bnr.st.com>
References: <1326796189-21722-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20120117184047.GE22472@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120117184047.GE22472@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

data type of old_cr was bool in patchv2, corrected in this patchv3

>From 5500b7d25b5382026bc9392a9b44c3c69bf172b0 Mon Sep 17 00:00:00 2001
From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Date: Tue, 17 Jan 2012 11:00:26 +0530
Subject: [PATCHv3] amba-pl011: do not disable RTS during shutdown

In present driver, shutdown clears RTS and DTR in CR register. But the
documentation "Documentation/serial/driver" suggests not to disable
RTS and DTR in shutdown(). Also RTS and DTR is preserved between shutdown
and startup calls, i.e. these are restored in startup if they were enabled
while doing shutdown. So that if RTS and DTR are set using pl011_set_mctrl
then it should continue even after shutdown->startup sequence.
For throttling/unthrottling user should call pl011_set_mctrl.

Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/tty/serial/amba-pl011.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6958594..62ff7da 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -159,6 +159,7 @@ struct uart_amba_port {
 	unsigned int		fifosize;	/* vendor-specific */
 	unsigned int		lcrh_tx;	/* vendor-specific */
 	unsigned int		lcrh_rx;	/* vendor-specific */
+	unsigned int		old_cr;		/* state during shutdown */
 	bool			autorts;
 	char			type[12];
 	bool			interrupt_may_hang; /* vendor-specific */
@@ -1411,7 +1412,9 @@ static int pl011_startup(struct uart_port *port)
 	while (readw(uap->port.membase + UART01x_FR) & UART01x_FR_BUSY)
 		barrier();
 
-	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
+	/* restore RTS and DTR */
+	cr = (uap->old_cr & (UART011_CR_RTS | UART011_CR_DTR));
+	cr |= UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
 
 	/* Clear pending error interrupts */
@@ -1469,6 +1472,7 @@ static void pl011_shutdown_channel(struct uart_amba_port *uap,
 static void pl011_shutdown(struct uart_port *port)
 {
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	unsigned int cr;
 
 	/*
 	 * disable all interrupts
@@ -1488,9 +1492,16 @@ static void pl011_shutdown(struct uart_port *port)
 
 	/*
 	 * disable the port
+	 * disable the port. It should not disable RTS and DTR.
+	 * Also RTS and DTR state should be preserved to restore
+	 * it during startup().
 	 */
 	uap->autorts = false;
-	writew(UART01x_CR_UARTEN | UART011_CR_TXE, uap->port.membase + UART011_CR);
+	cr = readw(uap->port.membase + UART011_CR);
+	uap->old_cr = cr;
+	cr &= (UART011_CR_RTS | UART011_CR_DTR);
+	cr |= UART01x_CR_UARTEN | UART011_CR_TXE;
+	writew(cr, uap->port.membase + UART011_CR);
 
 	/*
 	 * disable break condition and fifos
@@ -1905,6 +1916,7 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
+	uap->old_cr = 0;
 	uap->fifosize = vendor->fifosize;
 	uap->interrupt_may_hang = vendor->interrupt_may_hang;
 	uap->port.dev = &dev->dev;
-- 
1.7.4.3

