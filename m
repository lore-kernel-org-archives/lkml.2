Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2B0JaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:30:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44391 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2B0JaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:30:21 -0500
MIME-Version: 1.0
Date: Mon, 27 Feb 2012 18:30:20 +0900
Message-ID: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
Subject: [PATCH] Clear previous interrupts after fifo is disabled
From: Chanho Min <chanho0207@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is another workaroud of  'https://lkml.org/lkml/2012/1/17/104'
with additional analysis.Bootloader can transfer control to kernel and
there are some pending interrupts. In this case, RXFE of the flag
register is set by clearing FEN(LCRH) even if rx data remains in the
fifo. It seems that the fifo's status is initiailized. Interrupt
handler can not get any data from data register because of the below
break condtion.

pl011_fifo_to_tty
 while (max_count--) {
   if (status & UART01x_FR_RXFE)
	break;

Then, Rx interrupt is never cleared. cpu is looping in ISR. System is
hang. If we don't guarantee that no interrupt is pended until fifo is
disabled by calling 'writew(0, uap->port.membase + uap->lcrh_rx)',
this misbehave of the interrupt handelr can be occurred. So, All
pending interrupts should be cleared just after fifo is disabled under
the protection from interrupt. Also,'clear error interrupts' routine
can be removed becuase all interrupts are cleared before.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/tty/serial/amba-pl011.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6800f5f..8b5a824 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1397,7 +1397,11 @@ static int pl011_startup(struct uart_port *port)
 	writew(cr, uap->port.membase + UART011_CR);
 	writew(0, uap->port.membase + UART011_FBRD);
 	writew(1, uap->port.membase + UART011_IBRD);
+	spin_lock_irq(&uap->port.lock);
 	writew(0, uap->port.membase + uap->lcrh_rx);
+	/* Clear all pending interrupts. */
+	writew(0xffff, uap->port.membase + UART011_ICR);
+	spin_unlock_irq(&uap->port.lock);
 	if (uap->lcrh_tx != uap->lcrh_rx) {
 		int i;
 		/*
@@ -1417,10 +1421,6 @@ static int pl011_startup(struct uart_port *port)
 	cr |= UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);

-	/* Clear pending error interrupts */
-	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS,
-	       uap->port.membase + UART011_ICR);
-
 	/*
 	 * initialise the old status of the modem signals
 	 */
-- 
1.7.0.4
