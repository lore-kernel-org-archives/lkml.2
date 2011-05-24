Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1EXHvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:51:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab1EXHvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=etENRir2htOrcxbsvf/JnU4g9L+LpN+lS/f59rt2DYVJr9/3vpyOHd/NqzXD3h90ok
         Tbdz83+V4VJE9JpTZU2g==
MIME-Version: 1.0
In-Reply-To: <20110524070236.GB22096@pengutronix.de>
References: <1305876469.325655.313573683829.0.gpush@pororo>
	<1305876469.326305.518470530485.1.gpush@pororo>
	<BANLkTin2Ho-Ce-4RurtHfAST7hqTLDrJ+g@mail.gmail.com>
	<20110524070236.GB22096@pengutronix.de>
Date: Tue, 24 May 2011 00:51:10 -0700
Message-ID: <BANLkTinmRt_fv1oJwFuJQ34aAky_5SB4Rw@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: Add a generic clock infrastructure
From: Colin Cross <ccross@google.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 12:02 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Mon, May 23, 2011 at 04:55:15PM -0700, Colin Cross wrote:
>> On Fri, May 20, 2011 at 12:27 AM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
>> > We currently have ~21 definitions of struct clk in the ARM architecture,
>> > each defined on a per-platform basis. This makes it difficult to define
>> > platform- (or architecture-) independent clock sources without making
>> > assumptions about struct clk, and impossible to compile two
>> > platforms with different struct clks into a single image.
>> >
>> > This change is an effort to unify struct clk where possible, by defining
>> > a common struct clk, and a set of clock operations. Different clock
>> > implementations can set their own operations, and have a standard
>> > interface for generic code. The callback interface is exposed to the
>> > kernel proper, while the clock implementations only need to be seen by
>> > the platform internals.
>> >
>> > The interface is split into two halves:
>> >
>> >  * struct clk, which is the generic-device-driver interface. This
>> >   provides a set of functions which drivers may use to request
>> >   enable/disable, query or manipulate in a hardware-independent manner.
>> >
>> >  * struct clk_hw and struct clk_hw_ops, which is the hardware-specific
>> >   interface. Clock drivers implement the ops, which allow the core
>> >   clock code to implement the generic 'struct clk' API.
>> >
>> > This allows us to share clock code among platforms, and makes it
>> > possible to dynamically create clock devices in platform-independent
>> > code.
>> >
>> > Platforms can enable the generic struct clock through
>> > CONFIG_GENERIC_CLK. In this case, the clock infrastructure consists of a
>> > common, opaque struct clk, and a set of clock operations (defined per
>> > type of clock):
>> >
>> >  struct clk_hw_ops {
>> >        int             (*prepare)(struct clk_hw *);
>> >        void            (*unprepare)(struct clk_hw *);
>> >        int             (*enable)(struct clk_hw *);
>> >        void            (*disable)(struct clk_hw *);
>> >        unsigned long   (*recalc_rate)(struct clk_hw *);
>> >        int             (*set_rate)(struct clk_hw *,
>> >                                        unsigned long, unsigned long *);
>> >        long            (*round_rate)(struct clk_hw *, unsigned long);
>> >        int             (*set_parent)(struct clk_hw *, struct clk *);
>> >        struct clk *    (*get_parent)(struct clk_hw *);
>> >  };
>>
>> You might want to split these into three separate structs, for mux
>> ops, rate ops, and gate ops.  That way, multiple building blocks (a
>> gate and a divider, for example), can be easily combined into a single
>> clock node.  Also, an init op that reads the clock tree state from the
>> hardware has been very useful on Tegra - there are often clocks that
>> you can't or won't change, and being able to view their state as
>> configured by the bootloader, and base other clocks off of them, is
>> helpful.
>
> The clock state is read initially from the hardware with the
> recalc_rate/get_parent ops. What do we need an additional init op for?

I see - I would rename them to make it clear they are for init, maybe
init_rate and init_parent, and not call them later - reading clock
state can be very expensive on some platforms, if not impossible -
Qualcomm requires RPCs to the modem to get clock state.  If every
clk_set_rate triggers state reads all the way through the descendants,
that could be a huge performance hit.  If you separate init and
recalculate, mux implementations can store their divider settings and
very easily recalculate their rate.

>> It also allows you to turn off clocks that are enabled by
>> the bootloader, but never enabled by the kernel (enabled=1,
>> enable_count=0).
>
> The enable count indeed is a problem. I don't think an init hook
> would be the right solution for this though as this sounds platform
> specific. struct clk_hw_ops should be specific to the type of clock
> (mux, divider, gate) and should be present only once per type.
>
> For the enable count (and whether a clock should initially be enabled or
> not) I can think of something like this:
>
> - A platform/SoC registers all clocks.
> - It then calls clk_prepare/enable for all vital core clocks
>  (SDRAM, CPU,...). At this time the enable counters are correct.
> - Then some hook in the generic clock layer is called. This hook
>  iterates over the tree and disables all clocks in hardware which
>  have a enable count of 0.

Is it always safe to disable a clock that is already disabled?  An
init_enable hook that set an enabled flag would let you only disable
clocks that were actually left on by the bootloader, and report to the
user which ones are actually being turned off (which has caught a lot
of problems on Tegra).

>> > +
>> > +struct clk {
>> > +       const char              *name;
>> > +       struct clk_hw_ops       *ops;
>> > +       struct clk_hw           *hw;
>> > +       unsigned int            enable_count;
>> > +       unsigned int            prepare_count;
>> > +       struct clk              *parent;
>>
>> Storing the list of possible parents at this level can help abstract
>> some common code from mux ops if you pass the index into the list of
>> the new parent into the op - most mux ops only need to know which of
>> their mux inputs needs to be enabled.
>
> Please don't. Only muxes have more than one possible parent, so this
> should be handled there.

The cost is one pointer per clock that is not actually a mux, and the
benefit is that you can move a very common search loop out of every
mux implementation into the framework.  It also lets you determine
which clocks are connected, which becomes necessary if you try to do
per-tree locking or sysfs controls for clocks.

>>
>> > +       unsigned long           rate;
>>
>> If you add an init op, an enabled flag here is also useful to track
>> whether the bootloader left the clock on, which allows turning off
>> unnecessary clocks.
>>
>> I think you also need a list of current children of the clock to allow
>> propagating rate changes from parent to children.
>
> This is added in another patch in this series implementing clk_set_rate.

Thanks, I'll take a look.

>> > +
>> > +static void __clk_unprepare(struct clk *clk)
>> > +{
>> > +       if (!clk)
>> > +               return;
>> > +
>> > +       if (WARN_ON(clk->prepare_count == 0))
>> > +               return;
>> > +
>> > +       if (--clk->prepare_count > 0)
>> > +               return;
>> > +
>> > +       WARN_ON(clk->enable_count > 0);
>> > +
>> > +       if (clk->ops->unprepare)
>> > +               clk->ops->unprepare(clk->hw);
>> > +
>> > +       __clk_unprepare(clk->parent);
>> > +}
>> Are there any cases where the unlocked versions of the clk calls need
>> to be exposed to the ops implementations?  For example, a set_rate op
>> may want to call clk_set_parent on itself to change its parent to a
>> better source, and then set its rate.  It would need to call
>> __clk_set_parent to avoid deadlocking on the prepare_lock.
>
> I hope we can avoid that. The decision of the best parent should be left
> up to the user. Doing this in the mux/divider implementation would
> torpedo attempts to implement generic building blocks.

I agree it would be nice, but it does push some knowledge of the clock
tree into device drivers.  For example, on Tegra the display driver
may need to change the source pll of the display clock to get the
required pclk, which requires passing all the possible parents of the
display clock into the display driver.  If this is a common usage
pattern, there needs to be a hook in the ops to allow the clock or
clock chip to make a more global decision.

>> > +
>> > +unsigned long clk_get_rate(struct clk *clk)
>> > +{
>> > +       if (!clk)
>> > +               return 0;
>> > +       return clk->rate;
>> > +}
>> > +EXPORT_SYMBOL_GPL(clk_get_rate);
>> > +
>> > +long clk_round_rate(struct clk *clk, unsigned long rate)
>> > +{
>> > +       if (clk && clk->ops->round_rate)
>> > +               return clk->ops->round_rate(clk->hw, rate);
>> > +       return rate;
>> > +}
>> > +EXPORT_SYMBOL_GPL(clk_round_rate);
>>
>> I think you should hold the prepare mutex around calls to
>> clk_round_rate, which will allow some code simplification similar to
>> what Russell suggested in another thread.  If you hold the mutex here,
>> as well as in clk_set_rate, and you call the round_rate op before the
>> set_rate op in clk_set_rate, op implementers can compute the rate in
>> their round_rate op, and save the register values needed to get that
>> rate in private temporary storage.  The set_rate op can then assume
>> that those register values are correct, because the lock is still
>> held, and just write them.  That moves all the computation to one
>> place, and it only needs to run once.
>
> This won't work in the case of cascaded dividers. These have to call
> clk_round_rate in their set_rate op for each possible divider value
> to get the best result. They can't do this when both set_rate and
> round_rate acquire the lock.

Then they call __clk_round_rate if they already have the lock?

> [...]
>
>> > +struct clk *clk_register(struct clk_hw_ops *ops, struct clk_hw *hw,
>> > +               const char *name)
>> > +{
>> > +       struct clk *clk;
>> > +
>> > +       clk = kzalloc(sizeof(*clk), GFP_KERNEL);
>> > +       if (!clk)
>> > +               return NULL;
>> > +
>> > +       clk->name = name;
>> > +       clk->ops = ops;
>> > +       clk->hw = hw;
>> > +       hw->clk = clk;
>> > +
>> > +       /* Query the hardware for parent and initial rate */
>> > +
>> > +       if (clk->ops->get_parent)
>> > +               /* We don't to lock against prepare/enable here, as
>> > +                * the clock is not yet accessible from anywhere */
>> > +               clk->parent = clk->ops->get_parent(clk->hw);
>> > +
>> > +       if (clk->ops->recalc_rate)
>> > +               clk->rate = clk->ops->recalc_rate(clk->hw);
>> > +
>> > +
>> > +       return clk;
>> > +}
>> > +EXPORT_SYMBOL_GPL(clk_register);
>>
>> If you are requiring clk's parents (or possible parents?) to be
>> registered before clk, you could put the clk_lookup struct inside the
>> clk struct and call clkdev_add from clk_register, saving some
>> boilerplate in the platforms.
>
> There can be multiple struct clk_lookup for each clock.

Sure, and that could be handled by clk_register_alias.  Most of the
clocks have a single clk_lookup.

>> > + *
>> > + * @prepare:   Prepare the clock for enabling. This must not return until
>> > + *             the clock is fully prepared, and it's safe to call clk_enable.
>> > + *             This callback is intended to allow clock implementations to
>> > + *             do any initialisation that may sleep. Called with
>> > + *             prepare_lock held.
>> > + *
>> > + * @unprepare: Release the clock from its prepared state. This will typically
>> > + *             undo any work done in the @prepare callback. Called with
>> > + *             prepare_lock held.
>> > + *
>> > + * @enable:    Enable the clock atomically. This must not return until the
>> > + *             clock is generating a valid clock signal, usable by consumer
>> > + *             devices. Called with enable_lock held. This function must not
>> > + *             sleep.
>> > + *
>> > + * @disable:   Disable the clock atomically. Called with enable_lock held.
>> > + *             This function must not sleep.
>> > + *
>> > + * @recalc_rate        Recalculate the rate of this clock, by quering hardware
>> > + *             and/or the clock's parent. Called with the global clock mutex
>> > + *             held. Optional, but recommended - if this op is not set,
>> > + *             clk_get_rate will return 0.
>> You need a callback to update the rate when the parent or parent's
>> rate changes, which I would call recalc_rate, as well as this
>> init-type call.
>
> This is already done on framework level, I think in the clk_set_rate
> patch.

I'll comment there.

> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
>
