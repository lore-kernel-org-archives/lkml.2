Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257Ab2B2CrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:47:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966223Ab2B2CrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:47:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120228102337.GF18045@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
	<20120227104858.GR22562@n2100.arm.linux.org.uk>
	<20120227110204.GA30199@n2100.arm.linux.org.uk>
	<CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com>
	<20120228083545.GA18045@n2100.arm.linux.org.uk>
	<CAOAMb1CJ=G45G3JsxwP23GSdEOnDmY5xVoQmWLXaKJJv2cLOLg@mail.gmail.com>
	<20120228092140.GD18045@n2100.arm.linux.org.uk>
	<CAOAMb1Cqfrk-b-yd1CMt2Hac7_j3i6WL8D8yQJDWjg_S18dAsw@mail.gmail.com>
	<20120228102337.GF18045@n2100.arm.linux.org.uk>
Date: Wed, 29 Feb 2012 11:47:02 +0900
Message-ID: <CAOAMb1CvjxGHSekURXAhw5DL2W2-3Smw3ZTWuAi2E-1UBxHEFg@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Chanho Min <chanho0207@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which is why my patch explicitly clears the receive interrupt status
> before requesting the interrupt.  Have you read my patch?
This is the hang-up scenario with your patch.

pl011_startup(struct uart_port *port)
 	uap->port.uartclk = clk_get_rate(uap->clk);

	/* Clear pending error and receive interrupts */
	writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
	       UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
...
1. RX Interrupt is occurred after interrupt is cleared. Even if
interrupt is masked/disabled before(or probe time), RIS's Rx interrupt
is set to 1. Of course, masked status is zero.
...
2. RXFE of flag register is zero and fifo is not empty before LCRH is cleared.
	writew(0, uap->port.membase + uap->lcrh_rx);
3. RXFE of flag register is changed to '1'  after LCRH is cleared. but
the fifo is not actually empty.
...
4. Finally, We enable interrupts.
	spin_lock_irq(&uap->port.lock);
	uap->im = UART011_RTIM;
	if (!pl011_dma_rx_running(uap))
		uap->im |= UART011_RXIM;
	writew(uap->im, uap->port.membase + UART011_IMSC);
	spin_unlock_irq(&uap->port.lock);
5. The RIS's field which is enabled by IMSC is reflected to MIS as
soon as the interrupt enable. (We checked this on our ARM platform )
6. IRQ context is started. pl011_fifo_to_tty is called by pl011_int.
static int pl011_fifo_to_tty(struct uart_amba_port *uap)
...
	while (max_count--) {
		status = readw(uap->port.membase + UART01x_FR);
		if (status & UART01x_FR_RXFE)
			break;
...
7. pl011_fifo_to_tty can't read any data from DR because of the break
condition for RXFE. Rx interrupt can't be cleared. cpu is looping in
irq context.

This is why we need to be cleared just after LCRH is cleared not
before irq_request. Let's get back to my patch. Even if data is
received before or after interrupt is cleared, flag register will show
actual fifo status. Interrupt handler runs normally after the uart
operation is started up by enabling interrupt.

+       spin_lock_irq(&uap->port.lock);
        writew(0, uap->port.membase + uap->lcrh_rx);
+       /* Clear pending error and receive interrupts */
+       writew(UART011_OEIS | UART011_BEIS | UART011_PEIS | UART011_FEIS |
+               UART011_RTIS | UART011_RXIS, uap->port.membase + UART011_ICR);
+       spin_unlock_irq(&uap->port.lock);

Thanks,
Chanho Min
