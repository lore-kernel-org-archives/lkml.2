Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1AFULm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:11:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1AFULl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:11:41 -0500
Date: Thu, 6 Jan 2011 21:11:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110106201137.GY25121@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo> <1294199462.348449.192344022926.1.gpush@pororo> <20110106160752.GA2775@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110106160752.GA2775@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 05:07:52PM +0100, Richard Cochran wrote:
> On Wed, Jan 05, 2011 at 11:51:02AM +0800, Jeremy Kerr wrote:
> 
> > + * The @lock member provides either a spinlock or a mutex to protect (at least)
> > + * @enable_count. The type of lock used will depend on @flags; if CLK_ATOMIC is
> > + * set, then the core clock code will use a spinlock, otherwise a mutex. This
> > + * lock will be acquired during clk_enable and clk_disable, so for atomic
> > + * clocks, these ops callbacks must not sleep.
> > + *
> > + * The choice of atomic or non-atomic clock depends on how the clock is enabled.
> > + * Typically, you'll want to use a non-atomic clock. For clocks that need to be
> > + * enabled/disabled in interrupt context, use CLK_ATOMIC. Note that atomic
> > + * clocks with parents will typically cascade enable/disable operations to
> > + * their parent, so the parent of an atomic clock *must* be atomic too.
> 
> ...
> 
> > +struct clk {
> > +	const struct clk_ops	*ops;
> > +	unsigned int		enable_count;
> > +	int			flags;
> > +	union {
> > +		struct mutex	mutex;
> > +		spinlock_t	spinlock;
> > +	} lock;
> > +};
> 
> Here you have a "polymorphic" lock, where the clock instance knows
> which type it is supposed to be.  I got flak from David Miller and
> others trying to do the same thing with the mdio_bus:
> 
>    http://kerneltrap.org/mailarchive/linux-netdev/2010/7/6/6280618
> 
> The criticism, applied to your case, is that the clk_enable() caller
> cannot know whether it is safe to make the call or not. I was told,
> "there has got to be a better way."
Note that this is not "new".  Currently there is no convention available
if clk_enable sleeps or not.  See e.g.
http://thread.gmane.org/gmane.linux.ports.arm.kernel/100744

So if there is no consent and you want to introduce common code there is
no choice.

I don't like it, too.  IMHO clk_enable should be allowed to sleep, but I
see the concerns of the other camp, too.  If you know the better way
that has to exists, please tell us.

(Hmm, the way the gpio api does it comes to mind:

	clk_enable_atomic
	clk_enable_cansleep

(where one of these can be named clk_enable).)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
