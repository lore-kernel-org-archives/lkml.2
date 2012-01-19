Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2ASLIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 06:08:10 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:48118 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591Ab2ASLIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 06:08:07 -0500
Date: Thu, 19 Jan 2012 16:37:38 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: clear previous interrupts before
	request_irq
Message-ID: <20120119110737.GA6115@bnru02.bnr.st.com>
References: <1326796493-16080-1-git-send-email-shreshthakumar.sahu@stericsson.com>
 <20120118100410.GB889@bnru02.bnr.st.com>
 <20120118101555.GG22472@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120118101555.GG22472@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 11:15:55 +0100, Russell King wrote:
> On Wed, Jan 18, 2012 at 03:34:11PM +0530, Shreshtha Kumar SAHU wrote:
> > 
> > >From 0742fc49405b2a6f562981f61d93198e1595f30d Mon Sep 17 00:00:00 2001
> > From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> > Date: Tue, 17 Jan 2012 12:23:19 +0530
> > Subject: [PATCH v2] amba-pl011: clear previous interrupts before request_irq
> > 
> > All previous interrupts should be cleared before installing
> > interrupt handler i.e. before request_irq. pl011_shutdown
> > clears the interrupt register but there may be case where
> > bootloader transfers control to kernel and there are some
> > pending interrupts. In this case interrupt handler will get
> > called even before interrupt mask is enabled.
> > 
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> No sign-off, and I don't understand the problem being aluded to in the
> description above - particularly the last sentence.
> 
Sorry for late reply and missing sign-off.
In the setup where console is disabled and logs are diverted to buffer, it is
observed that, continuous uart interrupts are coming. Even before IMSC
(Interrupt mask set/clear register) is enabled for TX or RX interrupts,
it is seen that interrupt handler getting called just after request_irq.
It was found that this situation happens when RIS (raw interrupt register)
has some pending interrupts (e.g. RI, CTS, DCD, RX etc. but IMO RX is main)
when control gets transferred to kernel from bootloader. This refers that
GIC (global interrupt controller) is providing interrupt even if interrupts
for UART are masked/disabled in IMSC register.
In this state problem elivated when cpu is looping in interrupt handler
because of Rx interrupt set but Rx fifo is empty (hence rx_char is simply
returning). How UART goes in to this state is still not completely
understood.

> In theory, we should be prepared for the interrupt handler to be called
> immediately after request_irq() returns, and not have the driver misbehave
> because of that.  Maybe a better solution would be to move request_irq()
> a bit later?
>
I tried doing this but problem persists.
I understand that module should be robust enough and should not depend
on state left by previous user of soc. I am still investigating and will
come back with analysis.

> But first, having a clearer description of the problem you're seeing
> would be beneficial.
> 
> > ---
> >  drivers/tty/serial/amba-pl011.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> > index 6958594..6dafaa2 100644
> > --- a/drivers/tty/serial/amba-pl011.c
> > +++ b/drivers/tty/serial/amba-pl011.c
> > @@ -1381,6 +1381,15 @@ static int pl011_startup(struct uart_port *port)
> >  	uap->port.uartclk = clk_get_rate(uap->clk);
> >  
> >  	/*
> > +	 * Clear previous interrupts before installing interrupt handler
> > +	 */
> > +	spin_lock_irq(&uap->port.lock);
> > +	uap->im = 0;
> > +	writew(uap->im, uap->port.membase + UART011_IMSC);
> > +	writew(0xffff, uap->port.membase + UART011_ICR);
> > +	spin_unlock_irq(&uap->port.lock);
> > +
> > +	/*
> >  	 * Allocate the IRQ
> >  	 */
> >  	retval = request_irq(uap->port.irq, pl011_int, 0, "uart-pl011", uap);
> > -- 
> > 1.7.4.3
> > 
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

Thanks and Regards
Shreshtha
