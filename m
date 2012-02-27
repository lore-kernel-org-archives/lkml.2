Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2B0LC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:02:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60268 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2B0LCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:02:25 -0500
Date: Mon, 27 Feb 2012 11:02:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
Message-ID: <20120227110204.GA30199@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com> <20120227104858.GR22562@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227104858.GR22562@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 10:48:58AM +0000, Russell King - ARM Linux wrote:
> I'd much prefer to only clear those interrupts which actually need to be
> cleared at this point.  So, I'd suggest this approach instead:

Thinking about this a little more, we definitely want to mask and clear
interrupts at probe time as well:

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6800f5f..6b781bd 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1381,6 +1381,10 @@ static int pl011_startup(struct uart_port *port)
 
 	uap->port.uartclk = clk_get_rate(uap->clk);
 
+	/* Clear pending error and receive interrupts */
+	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
+	       UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
+
 	/*
 	 * Allocate the IRQ
 	 */
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
@@ -1927,6 +1927,10 @@ static int pl011_probe(struct amba_device *dev, const struct amba_id *id)
 		goto unmap;
 	}
 
+	/* Ensure interrupts from this UART are masked and cleared */
+	writew(0, uap->port.membase + UART011_IMSC);
+	writew(0xffff, uap->port.membase + UART011_ICR);
+
 	uap->vendor = vendor;
 	uap->lcrh_rx = vendor->lcrh_rx;
 	uap->lcrh_tx = vendor->lcrh_tx;
