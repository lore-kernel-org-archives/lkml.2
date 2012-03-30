Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628Ab2C3VK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:10:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935613Ab2C3VKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:10:53 -0400
Message-Id: <20120330194842.690111192@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Chanho Min <chanho0207@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jong-Sung Kim <neidhard.kim@lge.com>
Subject: [ 042/149] serial: PL011: clear pending interrupts
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit 9b96fbacda34079dea0638ee1e92c56286f6114a upstream.

Chanho Min reported that when the boot loader transfers
control to the kernel, there may be pending interrupts
causing the UART to lock up in an eternal loop trying to
pick tokens from the FIFO (since the RX interrupt flag
indicates there are tokens) while in practice there are
no tokens - in fact there is only a pending IRQ flag.

This patch address the issue with a combination of two
patches suggested by Russell King that clears and mask
all interrupts at probe() and clears any pending error
and RX interrupts at port startup time.

We suspect the spurious interrupts are a side-effect of
switching the UART from FIFO to non-FIFO mode.

Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Reported-by: Chanho Min <chanho0207@gmail.com>
Suggested-by: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Jong-Sung Kim <neidhard.kim@lge.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/amba-pl011.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1380,6 +1380,10 @@ static int pl011_startup(struct uart_por
 
 	uap->port.uartclk = clk_get_rate(uap->clk);
 
+	/* Clear pending error and receive interrupts */
+	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
+	       UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
+
 	/*
 	 * Allocate the IRQ
 	 */
@@ -1414,10 +1418,6 @@ static int pl011_startup(struct uart_por
 	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
 	writew(cr, uap->port.membase + UART011_CR);
 
-	/* Clear pending error interrupts */
-	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS,
-	       uap->port.membase + UART011_ICR);
-
 	/*
 	 * initialise the old status of the modem signals
 	 */
@@ -1432,6 +1432,9 @@ static int pl011_startup(struct uart_por
 	 * as well.
 	 */
 	spin_lock_irq(&uap->port.lock);
+	/* Clear out any spuriously appearing RX interrupts */
+	 writew(UART011_RTIS | UART011_RXIS,
+		uap->port.membase + UART011_ICR);
 	uap->im = UART011_RTIM;
 	if (!pl011_dma_rx_running(uap))
 		uap->im |= UART011_RXIM;
@@ -1916,6 +1919,10 @@ static int pl011_probe(struct amba_devic
 		goto unmap;
 	}
 
+	/* Ensure interrupts from this UART are masked and cleared */
+	writew(0, uap->port.membase + UART011_IMSC);
+	writew(0xffff, uap->port.membase + UART011_ICR);
+
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;


