Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab2ARJgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:36:41 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:59019 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757215Ab2ARJgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:36:38 -0500
Date: Wed, 18 Jan 2012 15:06:05 +0530
From: Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amba-pl011: do not disable RTS during shutdown
Message-ID: <20120118093549.GA20412@bnru02.bnr.st.com>
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

On Tue, Jan 17, 2012 at 19:40:48 +0100, Russell King wrote:
> On Tue, Jan 17, 2012 at 03:59:49PM +0530, Shreshtha Kumar SAHU wrote:
> > From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> > 
> > In present driver, shutdown clears RTS in CR register. But the
> > documentation "Documentation/serial/driver" suggests not to
> > disable RTS in shutdown(). Also RTS is preserved between shutdown
> > and startup calls, i.e. it is restored in startup if it was enabled
> > during shutdown. So that if autorts is set and RTS is set using
> > pl011_set_mctrl then it should continue even after shutdown->startup
> > sequence. And hence during set_termios it will enable RTS only if RTS
> > bit is set in UARTx_CR register. For throttling/unthrottling user
> > should call pl011_set_mctrl.
> > 
> > Change-Id: I743f33fb10e7e655657cd5dae1ec585e914a65bc
> 
> Please get rid of this line.
> 
done.
> > Signed-off-by: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > ---
> >  drivers/tty/serial/amba-pl011.c |   17 ++++++++++++++++-
> >  1 files changed, 16 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
> > index 6958594..46a4690 100644
> > --- a/drivers/tty/serial/amba-pl011.c
> > +++ b/drivers/tty/serial/amba-pl011.c
> > @@ -160,6 +160,7 @@ struct uart_amba_port {
> >  	unsigned int		lcrh_tx;	/* vendor-specific */
> >  	unsigned int		lcrh_rx;	/* vendor-specific */
> >  	bool			autorts;
> > +	bool			rts_state;	/* state during shutdown */
> 
> Do we really need a variable to track this?
>
As register content will be reset during low power state after shutdown.
Hence we have to preserve it during shutdown.

> >  	char			type[12];
> >  	bool			interrupt_may_hang; /* vendor-specific */
> >  #ifdef CONFIG_DMA_ENGINE
> > @@ -1412,6 +1413,8 @@ static int pl011_startup(struct uart_port *port)
> >  		barrier();
> >  
> >  	cr = UART01x_CR_UARTEN | UART011_CR_RXE | UART011_CR_TXE;
> > +	if (uap->rts_state)
> > +		cr |= UART011_CR_RTS;
> >  	writew(cr, uap->port.membase + UART011_CR);
> 
> Note that this should preserve DTR as well.
>
In the attached patch, DTR is preserved and restored.

> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

Best Regards,
Shreshtha

>From 2a9062f4c3fd198a64a96779d6e74b324ddb81e4 Mon Sep 17 00:00:00 2001
From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
Date: Tue, 17 Jan 2012 11:00:26 +0530
Subject: [PATCHv2] amba-pl011: do not disable RTS during shutdown

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
index 6958594..673be75 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -160,6 +160,7 @@ struct uart_amba_port {
 	unsigned int		lcrh_tx;	/* vendor-specific */
 	unsigned int		lcrh_rx;	/* vendor-specific */
 	bool			autorts;
+	bool			old_cr;		/* state during shutdown */
 	char			type[12];
 	bool			interrupt_may_hang; /* vendor-specific */
 #ifdef CONFIG_DMA_ENGINE
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

