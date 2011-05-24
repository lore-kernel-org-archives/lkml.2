Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1EXIiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:38:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab1EXIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:38:12 -0400
Date: Tue, 24 May 2011 10:38:04 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Colin Cross <ccross@google.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
Message-ID: <20110524083804.GJ20715@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
 <1305876469.326305.518470530485.1.gpush@pororo>
 <BANLkTin2Ho-Ce-4RurtHfAST7hqTLDrJ+g@mail.gmail.com>
 <20110524070236.GB22096@pengutronix.de>
 <BANLkTinmRt_fv1oJwFuJQ34aAky_5SB4Rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinmRt_fv1oJwFuJQ34aAky_5SB4Rw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:12:50 up 3 days, 21:52, 49 users,  load average: 2.22, 2.89, 2.53
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:51:10AM -0700, Colin Cross wrote:
> On Tue, May 24, 2011 at 12:02 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Mon, May 23, 2011 at 04:55:15PM -0700, Colin Cross wrote:
> >> On Fri, May 20, 2011 at 12:27 AM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> >> >
> >> >  struct clk_hw_ops {
> >> >        int             (*prepare)(struct clk_hw *);
> >> >        void            (*unprepare)(struct clk_hw *);
> >> >        int             (*enable)(struct clk_hw *);
> >> >        void            (*disable)(struct clk_hw *);
> >> >        unsigned long   (*recalc_rate)(struct clk_hw *);
> >> >        int             (*set_rate)(struct clk_hw *,
> >> >                                        unsigned long, unsigned long *);
> >> >        long            (*round_rate)(struct clk_hw *, unsigned long);
> >> >        int             (*set_parent)(struct clk_hw *, struct clk *);
> >> >        struct clk *    (*get_parent)(struct clk_hw *);
> >> >  };
> >>
> >> You might want to split these into three separate structs, for mux
> >> ops, rate ops, and gate ops.  That way, multiple building blocks (a
> >> gate and a divider, for example), can be easily combined into a single
> >> clock node.  Also, an init op that reads the clock tree state from the
> >> hardware has been very useful on Tegra - there are often clocks that
> >> you can't or won't change, and being able to view their state as
> >> configured by the bootloader, and base other clocks off of them, is
> >> helpful.
> >
> > The clock state is read initially from the hardware with the
> > recalc_rate/get_parent ops. What do we need an additional init op for?
> 
> I see - I would rename them to make it clear they are for init, maybe
> init_rate and init_parent, and not call them later - reading clock
> state can be very expensive on some platforms, if not impossible -
> Qualcomm requires RPCs to the modem to get clock state.  If every
> clk_set_rate triggers state reads all the way through the descendants,
> that could be a huge performance hit.  If you separate init and
> recalculate, mux implementations can store their divider settings and
> very easily recalculate their rate.

Even without additional hooks divider and muxes can decide to cache
the actual register values.

> 
> >> It also allows you to turn off clocks that are enabled by
> >> the bootloader, but never enabled by the kernel (enabled=1,
> >> enable_count=0).
> >
> > The enable count indeed is a problem. I don't think an init hook
> > would be the right solution for this though as this sounds platform
> > specific. struct clk_hw_ops should be specific to the type of clock
> > (mux, divider, gate) and should be present only once per type.
> >
> > For the enable count (and whether a clock should initially be enabled or
> > not) I can think of something like this:
> >
> > - A platform/SoC registers all clocks.
> > - It then calls clk_prepare/enable for all vital core clocks
> >  (SDRAM, CPU,...). At this time the enable counters are correct.
> > - Then some hook in the generic clock layer is called. This hook
> >  iterates over the tree and disables all clocks in hardware which
> >  have a enable count of 0.
> 
> Is it always safe to disable a clock that is already disabled?

I'm not aware of any clock where that's not the case, but your mileage
may vary. At least the implementation should be able to determine
whether a clock already is disabled and just skip another disable.

>  An
> init_enable hook that set an enabled flag would let you only disable
> clocks that were actually left on by the bootloader, and report to the
> user which ones are actually being turned off (which has caught a lot
> of problems on Tegra).
> 
> >> > +
> >> > +struct clk {
> >> > +       const char              *name;
> >> > +       struct clk_hw_ops       *ops;
> >> > +       struct clk_hw           *hw;
> >> > +       unsigned int            enable_count;
> >> > +       unsigned int            prepare_count;
> >> > +       struct clk              *parent;
> >>
> >> Storing the list of possible parents at this level can help abstract
> >> some common code from mux ops if you pass the index into the list of
> >> the new parent into the op - most mux ops only need to know which of
> >> their mux inputs needs to be enabled.
> >
> > Please don't. Only muxes have more than one possible parent, so this
> > should be handled there.
> 
> The cost is one pointer per clock that is not actually a mux, and the
> benefit is that you can move a very common search loop out of every
> mux implementation into the framework.  It also lets you determine
> which clocks are connected, which becomes necessary if you try to do
> per-tree locking or sysfs controls for clocks.

I agree that some sort of possible_parents iteration would be nice.

> 
> >>
> >> > +
> >> > +       if (WARN_ON(clk->prepare_count == 0))
> >> > +               return;
> >> > +
> >> > +       if (--clk->prepare_count > 0)
> >> > +               return;
> >> > +
> >> > +       WARN_ON(clk->enable_count > 0);
> >> > +
> >> > +       if (clk->ops->unprepare)
> >> > +               clk->ops->unprepare(clk->hw);
> >> > +
> >> > +       __clk_unprepare(clk->parent);
> >> > +}
> >> Are there any cases where the unlocked versions of the clk calls need
> >> to be exposed to the ops implementations?  For example, a set_rate op
> >> may want to call clk_set_parent on itself to change its parent to a
> >> better source, and then set its rate.  It would need to call
> >> __clk_set_parent to avoid deadlocking on the prepare_lock.
> >
> > I hope we can avoid that. The decision of the best parent should be left
> > up to the user. Doing this in the mux/divider implementation would
> > torpedo attempts to implement generic building blocks.
> 
> I agree it would be nice, but it does push some knowledge of the clock
> tree into device drivers.  For example, on Tegra the display driver
> may need to change the source pll of the display clock to get the
> required pclk, which requires passing all the possible parents of the
> display clock into the display driver.  If this is a common usage
> pattern, there needs to be a hook in the ops to allow the clock or
> clock chip to make a more global decision.

I think this is a common pattern. Another solution to this would be that
the platform implements a clock whose only purpose is to build a bridge
between the driver and the clock tree. There may be more constrains, for
example in some cases you may need a clock which also runs in different
sleep states whereas sometimes you may need a clock which is turned of
when in sleep mode. I agree that this must be handled somewhere, but
the clock framework is not the place to implement this stuff.

> >>
> >> I think you should hold the prepare mutex around calls to
> >> clk_round_rate, which will allow some code simplification similar to
> >> what Russell suggested in another thread.  If you hold the mutex here,
> >> as well as in clk_set_rate, and you call the round_rate op before the
> >> set_rate op in clk_set_rate, op implementers can compute the rate in
> >> their round_rate op, and save the register values needed to get that
> >> rate in private temporary storage.  The set_rate op can then assume
> >> that those register values are correct, because the lock is still
> >> held, and just write them.  That moves all the computation to one
> >> place, and it only needs to run once.
> >
> > This won't work in the case of cascaded dividers. These have to call
> > clk_round_rate in their set_rate op for each possible divider value
> > to get the best result. They can't do this when both set_rate and
> > round_rate acquire the lock.
> 
> Then they call __clk_round_rate if they already have the lock?

I think this is an implementation detail. As our idea of how a clock
framework should work still is quite different we can discuss this later ;)

> 
> > [...]
> >
> >> > +struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
> >> > +               const char *name)
> >> > +{
> >> > +       struct clk *clk;
> >> > +
> >> > +       clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> >> > +       if (!clk)
> >> > +               return NULL;
> >> > +
> >> > +       clk->name = name;
> >> > +       clk->ops = ops;
> >> > +       clk->hw = hw;
> >> > +       hw->clk = clk;
> >> > +
> >> > +       /* Query the hardware for parent and initial rate */
> >> > +
> >> > +       if (clk->ops->get_parent)
> >> > +               /* We don't to lock against prepare/enable here, as
> >> > +                * the clock is not yet accessible from anywhere */
> >> > +               clk->parent = clk->ops->get_parent(clk->hw);
> >> > +
> >> > +       if (clk->ops->recalc_rate)
> >> > +               clk->rate = clk->ops->recalc_rate(clk->hw);
> >> > +
> >> > +
> >> > +       return clk;
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(clk_register);
> >>
> >> If you are requiring clk's parents (or possible parents?) to be
> >> registered before clk, you could put the clk_lookup struct inside the
> >> clk struct and call clkdev_add from clk_register, saving some
> >> boilerplate in the platforms.
> >
> > There can be multiple struct clk_lookup for each clock.
> 
> Sure, and that could be handled by clk_register_alias.  Most of the
> clocks have a single clk_lookup.

In my idea only few of the clocks have a clk_lookup (you mentioned a
clock between the i2c divider and i2c gate elsewhere, this would never
be passed to a device).

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
