Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1AGAcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:32:23 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45909 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab1AGAcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:32:22 -0500
Date: Fri, 7 Jan 2011 00:32:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110107003205.GL31708@n2100.arm.linux.org.uk>
References: <1294199462.347935.472473715866.0.gpush@pororo> <20110106160752.GA2775@riccoc20.at.omicron.at> <20110106201137.GY25121@pengutronix.de> <201101070810.21398.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101070810.21398.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 08:10:20AM +0800, Jeremy Kerr wrote:
> Hi Richard,
> 
> > > > +struct clk {
> > > > +	const struct clk_ops	*ops;
> > > > +	unsigned int		enable_count;
> > > > +	int			flags;
> > > > +	union {
> > > > +		struct mutex	mutex;
> > > > +		spinlock_t	spinlock;
> > > > +	} lock;
> > > > +};
> > > 
> > > Here you have a "polymorphic" lock, where the clock instance knows
> > > which type it is supposed to be.  I got flak from David Miller and
> > > 
> > > others trying to do the same thing with the mdio_bus:
> > >    http://kerneltrap.org/mailarchive/linux-netdev/2010/7/6/6280618
> > > 
> > > The criticism, applied to your case, is that the clk_enable() caller
> > > cannot know whether it is safe to make the call or not. I was told,
> > > "there has got to be a better way."
> > 
> > Note that this is not "new".  Currently there is no convention available
> > if clk_enable sleeps or not.  See e.g.
> > http://thread.gmane.org/gmane.linux.ports.arm.kernel/100744
> 
> As Uwe says, the common clock does not change these semantics; I would prefer 
> to keep the driver API changes at a minimum with these patches.
> 
> But yes, it would be a good idea to:
> 
>  * introduce clk_enable_atomic, which requires clk->flags & CLK_ATOMIC
> 
>  * add might_sleep to clk_enable(), encouraging clk uses in atomic contexts
>    to switch to clk_enable_atomic.
> 
> We'd still be able to handle CLK_ATOMIC clocks in clk_enable(), so the 
> enforcement only needs to be one-way.

I think the atomic stuff should be the norm through and through - otherwise
we're going to end up with problems in drivers where they use the _atomic()
stuff, but the clocks behind are coded to sleep.

I hate the GPIO APIs for doing this _cansleep crap as the decision of
whether to use the _cansleep or normal APIs normally can't be made at
the time when the API is used, but sometime later.  Many people just use
the non-_cansleep versions irrespective of the context they're in -
which is unnecessarily restrictive - consider what happens if you then
have that driver use a GPIO on an I2C peripheral...

By inventing two interfaces, you're asking for the same thing to happen
with clocks.
