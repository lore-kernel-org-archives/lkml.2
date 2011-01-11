Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab1AKKjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:39:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54335 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1AKKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:39:35 -0500
Date: Tue, 11 Jan 2011 11:39:29 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: Locking in the clk API
Message-ID: <20110111103929.GN24920@pengutronix.de>
References: <201101111016.42819.jeremy.kerr@canonical.com>
 <20110111091607.GI12552@n2100.arm.linux.org.uk>
 <201101111744.59712.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201101111744.59712.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 11, 2011 at 05:44:59PM +0800, Jeremy Kerr wrote:
> > I object to this as one of the purposes behind the clk API is to allow
> > power savings to be made, and unless we can perform clk enable/disable
> > from atomic contexts, the best you can do is enable the clock when the
> > device is probed and disable it when it's released.
> > 
> > [...]
> >
> > Sometimes the only point that you know you need the clock enabled is when
> > your driver has already been called in an atomic context.
> 
> .. provided that the enable (and subsequent things that depend on the clock 
> signal to be valid) can't be deferred; I'm not sure how often this will be 
> possible.
> 
> So, it sounds like the best approach is to provide an atomic clk_enable. I 
> agree with Sascha that the clk_enable and clk_enable_atomic polarity makes the 
> most sense, so how about:
> 
> int clk_enable(struct clk *clk)
> {
> 	might_sleep();
> 
> 	[...]
> }
> 
> int clk_enable_atomic(struct clk *clk)
> {
> 	BUG_ON(!(clk->flags & CLK_ATOMIC));
> 
> 	[...]
> }
> 
> Paul: even though you mention that the atomic clocks are the usual case, I 
> think that this way around illustrates the atomic 'restriction' at the call 
> site more clearly. When the drivers don't care about the atomicity, 
> clk_enable() is fine. When drivers do need an atomic clock, 
> clk_enable_atomic() shows this requirement.
I agree that we should try to make the clk api easy and consistent.  So
if we can go the atomic way we should in my opinion.

On i.mx the roots in the clk hierarchy are plls, so it would be nice to
know how long it takes to enable these.

Back when I implemented clk support for ns921x I had a clock that made
me think that a sleeping implementation would be the way to go.  I don't
remember the exact details.  (It was the rtc clk.)

A quick look into Digi's BSP (digiEL-5.0) shows they implemented
something I suggested earlier here:

	static int clk_enable_haslocknchange(struct clk *clk)
	{
		int ret = 0;

		assert_spin_locked(&clk_lock);
		BUG_ON(!test_bit(CLK_FLAG_CHANGESTATE, &clk->flags));

		if (clk->usage++ == 0) {
			if (clk->parent) {
				ret = clk_enable_haslock(clk->parent);
				if (ret)
					goto err_enable_parent;
			}

			spin_unlock(&clk_lock);

			if (clk->endisable)
				ret = clk->endisable(clk, 1);

			spin_lock(&clk_lock);

			if (ret) {
				clk_disable_parent_haslock(clk);
	err_enable_parent:
				clk->usage = 0;
			}
		}

		return ret;
	}

	static int clk_enable_haslock(struct clk *clk)
	{
		int ret;
		assert_spin_locked(&clk_lock);
		if (__test_and_set_bit(CLK_FLAG_CHANGESTATE, &clk->flags))
			return -EBUSY;

		ret = clk_enable_haslocknchange(clk);

		clear_bit(CLK_FLAG_CHANGESTATE, &clk->flags);

		return ret;
	}

	int clk_enable(struct clk *clk)
	{
		...
		spin_lock_irqsave(&clk_lock, flags);
		ret = clk_enable_haslock(clk);
		spin_unlock_irqrestore(&clk_lock, flags);
		return ret;
	}


I think the idea is nice.  At least it allows with a single lock to
implement both, sleeping and atomic clks without the need to mark the
atomicity in a global flag.

In the meantime Sascha checked on mx51 how long it takes to enable one
of the three PLLs: 50us.  Is this fast enough to accept disabled irqs
that long?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
