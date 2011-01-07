Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1AGJky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:40:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38535 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab1AGJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:40:52 -0500
Date: Fri, 7 Jan 2011 10:40:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110107094042.GA25121@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo> <20110106160752.GA2775@riccoc20.at.omicron.at> <20110106201137.GY25121@pengutronix.de> <201101070810.21398.jeremy.kerr@canonical.com> <20110107003205.GL31708@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110107003205.GL31708@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Fri, Jan 07, 2011 at 12:32:05AM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 07, 2011 at 08:10:20AM +0800, Jeremy Kerr wrote:
> > Hi Richard,
> > 
> > > > > +struct clk {
> > > > > +	const struct clk_ops	*ops;
> > > > > +	unsigned int		enable_count;
> > > > > +	int			flags;
> > > > > +	union {
> > > > > +		struct mutex	mutex;
> > > > > +		spinlock_t	spinlock;
> > > > > +	} lock;
> > > > > +};
> > > > 
> > > > Here you have a "polymorphic" lock, where the clock instance knows
> > > > which type it is supposed to be.  I got flak from David Miller and
> > > > 
> > > > others trying to do the same thing with the mdio_bus:
> > > >    http://kerneltrap.org/mailarchive/linux-netdev/2010/7/6/6280618
> > > > 
> > > > The criticism, applied to your case, is that the clk_enable() caller
> > > > cannot know whether it is safe to make the call or not. I was told,
> > > > "there has got to be a better way."
> > > 
> > > Note that this is not "new".  Currently there is no convention available
> > > if clk_enable sleeps or not.  See e.g.
> > > http://thread.gmane.org/gmane.linux.ports.arm.kernel/100744
> > 
> > As Uwe says, the common clock does not change these semantics; I would prefer 
> > to keep the driver API changes at a minimum with these patches.
> > 
> > But yes, it would be a good idea to:
> > 
> >  * introduce clk_enable_atomic, which requires clk->flags & CLK_ATOMIC
> > 
> >  * add might_sleep to clk_enable(), encouraging clk uses in atomic contexts
> >    to switch to clk_enable_atomic.
> > 
> > We'd still be able to handle CLK_ATOMIC clocks in clk_enable(), so the 
> > enforcement only needs to be one-way.
> 
> I think the atomic stuff should be the norm through and through - otherwise
> we're going to end up with problems in drivers where they use the _atomic()
> stuff, but the clocks behind are coded to sleep.
> 
> I hate the GPIO APIs for doing this _cansleep crap as the decision of
> whether to use the _cansleep or normal APIs normally can't be made at
> the time when the API is used, but sometime later.  Many people just use
> the non-_cansleep versions irrespective of the context they're in -
> which is unnecessarily restrictive - consider what happens if you then
> have that driver use a GPIO on an I2C peripheral...
I'd prefer it the other way around, too.  (That is an atomic
gpio_set_value_atomic and a sleeping gpio_set_value.)  So if someone
uses the wrong one it's more likely that (s)he notices it.  Other than
that I agree that not having to do this would be preferable.

When applying the clk_enable_atomic stuff to the amba-pl011 driver (see
link above), I would just get a different error (clk_enable_atomic would
return -ESOMETHING instead of a backtrace about sleeping in atomic
context).  Hmm, not very useful.

On the other hand fixing the clk API to the sleeping or non-sleeping
approach has disadvantages, too:

 - sleeping
   doesn't allow enabling a clk in atomic context which (e.g. in the
   case of amba-pl011) provides maximal power saving.
 - atomic
   some clocks need long to become enabled, so long critical sections
   are introduced

Having a maxtracer for the clk_enable/disable functions would be great
to get some numbers.  I volunteer to try to add something like that to
the common clk thing when it is merged.  (Yes, I still think that
merging Jeremy's patches for .38 is good.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
