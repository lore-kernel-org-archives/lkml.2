Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab0CSV63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 17:58:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060Ab0CSV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 17:58:28 -0400
Date: Fri, 19 Mar 2010 14:57:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: John Ogness <john.ogness@linutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] serial: fix possible imx deadlock
Message-Id: <20100319145721.0af2203c.akpm@linux-foundation.org>
In-Reply-To: <20100315134556.GX19843@pengutronix.de>
References: <80k4tehryt.fsf@merkur.tec.linutronix.de>
	<20100315134556.GX19843@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 14:45:57 +0100
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> On Mon, Mar 15, 2010 at 10:08:58AM +0100, John Ogness wrote:
> > This patch fixes a possible deadlock situation with the port and timer
> > locks. The calling paths for the deadlock situation are:
> > 
> > 1. imx_set_termios() -> LOCK(port.lock)
> >       -> del_timer_sync() -> LOCK(timer.base.lock)
> > 
> > 2. run_timer_softirq() -> LOCK(timer.base.lock)
> >       -> imx_timeout() -> LOCK(port.lock)
> > 
> > This patch is against 2.6.34-rc1.
> > 
> > Signed-off-by: John Ogness <john.ogness@linutronix.de>
> > ---
> >  drivers/serial/imx.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > diff -Naurp a/drivers/serial/imx.c b/drivers/serial/imx.c
> > --- a/drivers/serial/imx.c	2010-03-08 19:45:44.000000000 +0100
> > +++ b/drivers/serial/imx.c	2010-03-15 09:52:39.855261060 +0100
> > @@ -836,6 +836,12 @@ imx_set_termios(struct uart_port *port, 
> >  	baud = uart_get_baud_rate(port, termios, old, 50, port->uartclk / 16);
> >  	quot = uart_get_divisor(port, baud);
> >  
> > +	/*
> > +	 * Stop our timer. This is done with the port unlocked
> > +	 * to avoid possible deadlock against the timer function.
> > +	 */
> > +	del_timer_sync(&sport->timer);
> > +
> 
> Is this call needed here anyway? Only few drivers have it. Does anyone
> have more insights on this?

The other drivers might be buggy ;)

I think the del_timer can probably be removed, as the later
imx_enable_ms() will do a mod_timer() on it.  Unless that
imx_enable_ms() doesn't get performed, of course..

Plus it could be that we want to kill the timer because we're about to
change various pieces of state and we don't want the timer handler
running while that state is in flux.  Presumably that's why it's all
done under the spinlock.

Moving the del_timer_sync() to outside the spinlock might introduce
races though - perhaps userspace can cause the timer to get re-enabled
after it's been del_timer()'ed.

