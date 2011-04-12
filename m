Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1DLH2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:28:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43913 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab1DLH2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:28:46 -0400
Date: Tue, 12 Apr 2011 09:28:43 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-serial@vger.kernel.org,
        torvalds@linux-foundation.org, kernel@pengutronix.de
Subject: Re: Wrong GIT author ? also bugs: serial: Add uart driver for
 i.MX23/28
Message-ID: <20110412072843.GE7771@pengutronix.de>
References: <201103180302.p2I326tA020159@hera.kernel.org>
 <20110318112920.07148450@lxorguk.ukuu.org.uk>
 <20110329091456.GI30938@pengutronix.de>
 <20110329103335.7a5ff37d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110329103335.7a5ff37d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:33:35AM +0100, Alan Cox wrote:
> > I don't understand how to do this and didn't find something like that in
> > other drivers. (I checked amba-pl011.c and imx.c.) Also
> > Documentation/serial/driver doesn't describe this. (It is also silent
> > about CMSPAR and doesn't even advise to clear unsupported bits.)
> > Can you be a bit more verbose here?
> 
> 8250.c is the best place to look.
> 
> Basically on return from your routine the _hardware_ bits of the termios
> struct should be the ones set.
> 
> So eg if you only supported 8bit characters you'd wipe the CSx bits and
> set CS8.
> 
> For the speed there is a helper so you probably want
> 
>         /* Don't rewrite B0 */
>         if (tty_termios_baud_rate(termios))
>                 tty_termios_encode_baud_rate(termios, baud, baud);
OK, I will review the function to assert that the other bits are updated
accordingly.

> > @@ -286,6 +283,9 @@ static void mxs_auart_settermios(struct uart_port *u,
> >  {
> >  	u32 bm, ctrl, ctrl2, div;
> >  	unsigned int cflag, baud;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&u->lock, flags);
> 
> Termios you don't need the lock - just the IRQ handler and you still
> really want the tty_port_tty_get()/tty_kref_put() if that wasn't already
> dealt with.
If I look at 8250.c spin_lock_irqsave seems OK :-)

To be honest, it felt much better when a simpler driver than 8250 could
be used to copy from. Documentation/serial/driver (which is IMHO very
helpful) declares amba_pl011.c to be the reference implementation. It
uses neither tty_termios_encode_baud_rate nor
tty_port_tty_get()/tty_kref_put() :-(

Anyhow, I'll do my best to implement both requests.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
