Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2B0KtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:49:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45684 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2B0KtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:49:23 -0500
Date: Mon, 27 Feb 2012 10:48:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
Message-ID: <20120227104858.GR22562@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:30:20PM +0900, Chanho Min wrote:
> This is another workaroud of  'https://lkml.org/lkml/2012/1/17/104'
> with additional analysis.Bootloader can transfer control to kernel and
> there are some pending interrupts. In this case, RXFE of the flag
> register is set by clearing FEN(LCRH) even if rx data remains in the
> fifo. It seems that the fifo's status is initiailized. Interrupt
> handler can not get any data from data register because of the below
> break condtion.
> 
> pl011_fifo_to_tty
>  while (max_count--) {
>    if (status & UART01x_FR_RXFE)
> 	break;
> 
> Then, Rx interrupt is never cleared. cpu is looping in ISR. System is
> hang. If we don't guarantee that no interrupt is pended until fifo is
> disabled by calling 'writew(0, uap->port.membase + uap->lcrh_rx)',
> this misbehave of the interrupt handelr can be occurred. So, All
> pending interrupts should be cleared just after fifo is disabled under
> the protection from interrupt. Also,'clear error interrupts' routine
> can be removed becuase all interrupts are cleared before.

I'd much prefer to only clear those interrupts which actually need to be
cleared at this point.  So, I'd suggest this approach instead:

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 6800f5f..a13a825 100644
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
