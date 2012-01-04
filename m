Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2ADCRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:17:51 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:34533
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab2ADCRt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:17:49 -0500
X-SpamScore: -17
X-BigFish: VS-17(zz9371I148cM168aJ1432N98dKzz1202hzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Wed, 4 Jan 2012 10:15:42 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: "Turquette, Mike" <mturquette@ti.com>
CC: Thomas Gleixner <tglx@linutronix.de>, <andrew@lunn.ch>,
        <linaro-dev@lists.linaro.org>, <eric.miao@linaro.org>,
        <grant.likely@secretlab.ca>, Colin Cross <ccross@google.com>,
        <jeremy.kerr@canonical.com>, <linux@arm.linux.org.uk>,
        <sboyd@quicinc.com>, <magnus.damm@gmail.com>, <dsaxena@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <arnd.bergmann@linaro.org>,
        <patches@linaro.org>, <linux-omap@vger.kernel.org>,
        <richard.zhao@linaro.org>, <shawn.guo@freescale.com>, <paul@pwsan.com>,
        <linus.walleij@stericsson.com>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <amit.kucheria@linaro.org>,
        <skannan@quicinc.com>
Subject: Re: [PATCH v4 3/6] clk: introduce the common clock framework
Message-ID: <20120104021541.GI2414@b20223-02.ap.freescale.net>
References: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
 <1323834838-2206-4-git-send-email-mturquette@linaro.org>
 <alpine.LFD.2.02.1112141007550.3020@ionos>
 <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAJOA=zO=gM2r4pCVo+orLqE9Q1SSw4h5nXsAHo-e_SHZAfvKDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 04:45:48PM -0800, Turquette, Mike wrote:
> On Wed, Dec 14, 2011 at 5:18 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 13 Dec 2011, Mike Turquette wrote:
> >> +void __clk_unprepare(struct clk *clk)
> >> +{
> >> +     if (!clk)
> >> +             return;
> >> +
> >> +     if (WARN_ON(clk->prepare_count == 0))
> >> +             return;
> >> +
> >> +     if (--clk->prepare_count > 0)
> >> +             return;
> >> +
> >> +     WARN_ON(clk->enable_count > 0);
> >
> > So this leaves the clock enable count set. I'm a bit wary about
> > that. Shouldn't it either return (including bumping the prepare_count
> > again) or call clk_disable() ?
> 
> I've hit this in my port of OMAP.  It comes from this simple situation:
> 
> driver 1 (adapted for clk_prepare/clk_unprepare):
> clk_prepare(clk);
> clk_enable(clk);
> 
> ...
> 
> driver2 (not adapted for clk_prepare/clk_unprepare):
> clk_enable(clk);
> 
> ...
> 
> driver1:
> clk_disable(clk);
> clk_unprepare(clk);
> 
> In such a case we don't want to bump the prepare_count, since the
> offending driver2 won't decrement that count.  Also we don't want to
> shut down that clk since driver2 is using it.
> 
> Returning after the WARN is maybe OK, but the point of this check is
> really to find code which hasn't yet been made prepare-aware, and the
> current implementation is noisy enough about it.
> 
> >> +/**
> >> + * clk_get_parent - return the parent of a clk
> >> + * @clk: the clk whose parent gets returned
> >> + *
> >> + * Simply returns clk->parent.  It is up to the caller to hold the
> >> + * prepare_lock, if desired.  Returns NULL if clk is NULL.
> >
> > Holding the prepare lock in the caller will deadlock. So it's not a
> > real good idea to document it as an option :)
> 
> Oops.  That comment is left over from before clk_get_parent held the
> lock.  Will remove.
> 
> >
> >> + */
> >> +struct clk *clk_get_parent(struct clk *clk)
> >> +{
> >> +     struct clk *parent;
> >> +
> >> +     if (!clk)
> >> +             return NULL;
> >> +
> >> +     mutex_lock(&prepare_lock);
> >
> >> +/**
> >> + * clk_init - initialize the data structures in a struct clk
> >> + * @dev: device initializing this clk, placeholder for now
> >> + * @clk: clk being initialized
> >> + *
> >> + * Initializes the lists in struct clk, queries the hardware for the
> >> + * parent and rate and sets them both.  Adds the clk to the sysfs tree
> >> + * topology.
> >> + *
> >> + * Caller must populate clk->name and clk->flags before calling
> >
> > I'm not too happy about this construct. That leaves struct clk and its
> > members exposed to the world instead of making it a real opaque
> > cookie. I know from my own painful experience, that this will lead to
> > random fiddling in that data structure in drivers and arch code just
> > because the core code has a shortcoming.
> >
> > Why can't we make struct clk a real cookie and confine the data
> > structure to the core code ?
> >
> > That would change the init call to something like:
> >
> > struct clk *clk_init(struct device *dev, const struct clk_hw *hw,
> >                     struct clk *parent)
> >
> > And have:
> > struct clk_hw {
> >       struct clk_hw_ops *ops;
> >       const char        *name;
> >       unsigned long     flags;
> > };
> >
> > Implementers can do:
> > struct my_clk_hw {
> >       struct clk_hw    hw;
> >       mydata;
> > };
> >
> > And then change the clk ops callbacks to take struct clk_hw * as an
> > argument.
We have to define static clocks before we adopt DT binding.
If clk is opaque and allocate memory in clk core, it'll make hard
to define static clocks. And register/init will pass a long parameter
list.
> >
> > So the core code can allocate the clk data structure and you return a
> > real opaque cookie. You do the same thing for the basic gated clock in
> > one of the next patches, so doing it for struct clk itself is just
> > consequent.
> 
> The opaque cookie would work if platform code never needs any
> information outside of the data a single clk_hw_whatever provides.
> Unfortunately hardware doesn't make things that easy on us and the
> operations we do for a single clk are affected by the state of other
> clks.
> 
> Here is an example I've been using a lot lately: on OMAP we have two
> clock inputs to our PLLs: a bypass clk and reference clk (actually we
> can have more than this).  When changing the PLL rate both clks must
> be enabled, regardless of which clk ends up driving the PLL.  To
> illustrate, the PLL may be driven by clk_ref at 400MHz, and then we
> call clk_set_rate(pll_clk, 196000000); which will also leave it
> clocked by clk_ref but at 196MHz.  For this to happen however, the
> clk_bypass had to be enabled during the rate change operation.  Here
> is the relevant .set_rate implementation:
> http://git.linaro.org/gitweb?p=people/mturquette/linux.git;a=blob;f=arch/arm/mach-omap2/dpll3xxx.c;h=b2412574b63829944593c1a7a6eda5fa4350686f;hb=738bde65918ae1ac743b1498801da0b860e2ee32#l461
> 
> In order for the OMAP platform code to do this, we have to have two
> things: firstly we need the struct clk so that we can call
> clk_enable/disable and __clk_prepare/unprepare on the ref and bypass
> clks from within .set_rate.  The second thing is that we need
> __clk_prepare and __clk_unprepare to be visible by this code so that
> we don't nest the prepare_lock mutex.
> 
> Is there a good way to solve such problems if we hide struct clk from
> the platform code/clk driver implementation?
You can add a function clk_to_hw to convert struct clk to struct clk_hw.
It's the way I did with the patch you didn't expose struct clk.

clock driver gate2b needs to access clk_hw. clk_gate2b_set_val can set
value for enable and disable at runtime. At opaque time, it have to get
clk_hw first and then get struct clk_gate2b.
> 
> Also note that if top-level clk APIs are going to be holding
> prepare_lock (clk_get_rate, clk_get_parent, etc) then we can't call
> these APIs to get the info we want from within the platform code.  For
> example, today most .recalc_rate implementations reference
> clk->parent->rate and apply it to some divider or something.  To get
> around having an opaque cookie .recalc_rate would have to have
> parent->rate passed into it since the implementation cannot call
> clk_get_rate(clk_get_parent(clk)) due to not having 'clk' in the first
> place, and also because of mutex nesting.
why do we need lock in clk_get_rate?
> 
> I agree that by not using an opaque cookie we open ourselves up to the
> possibility of badness, but we'll just have to catch it in code
> review.
> 
> >
> >> + * clk_init.  A key assumption in the call to .get_parent is that clks
> >> + * are being initialized in-order.
> >
> > We should not require that, see below.
> >
> >> + */
> >
> >> +void clk_init(struct device *dev, struct clk *clk)
> >> +{
> >> +     if (!clk)
> >> +             return;
> >> +
> >> +     INIT_HLIST_HEAD(&clk->children);
> >> +     INIT_HLIST_NODE(&clk->child_node);
> >> +
> >> +     mutex_lock(&prepare_lock);
> >> +
> >> +     /*
> >> +      * .get_parent is mandatory for populating .parent for clks with
> >> +      * multiple possible parents.  For clks with a fixed parent
> >> +      * .get_parent is not mandatory and .parent can be statically
> >> +      * initialized
> >> +      */
> >> +     if (clk->ops->get_parent)
> >> +             clk->parent = clk->ops->get_parent(clk);
> >> +
> >> +     /* clks without a parent are considered root clks */
> >
> > I'd rather prefer that root clocks are explicitely marked with a flag
> > instead of relying on clk->parent being NULL.
> 
> I originally had CLK_IS_ROOT flag but removed it after thinking that
> some clks might be a root sometimes, or a child at other times and I
> had considered the flags to be constant.
I didn't see part-time root clock in IMX.
> 
> If the flags aren't going to be constant and can change at run-time
> then I can move this back to a flag.  Also if there are no use cases
> where a clk can change from a root to a child then again this can
> safely go into flags.  Thoughts?
> 
> >
> >> +     if (clk->parent)
> >> +             hlist_add_head(&clk->child_node,
> >> +                             &clk->parent->children);
> >> +     else
> >> +             hlist_add_head(&clk->child_node, &clk_root_list);
> >
> > You could put clocks which have no parent and are not marked as root
> > clock onto a separate list clk_orphaned or such. You might need this
> > for handling clocks which are disconnected from any parent runtime as
> > well.
> 
> Agreed, that is a more well-defined approach.
> 
> > And to avoid the whole in-order initialization issue, you could change
> > clk_init to:
> >
> > struct clk *clk_init(struct device *dev, const struct clk_hw *hw,
> >                     unsigned long flags, const char *parent_name)
> >
> > Then you can lookup the requested parent by name. If that fails, you
> > put the clock into the orphaned list. When a new clock is initialized,
> > then you walk the orphaned list and check whether something is waiting
> > for that clock.
> >
> > To handle multi-parent clocks you need to go one step further and add:
> >
> > struct clk_hw {
> >       struct clk_hw_ops *ops;
> >       const char        *name;
> >       const char        **possible_parents;
> > };
> >
> > You also require a get_parent_idx() function in clk_hw_ops. So when
> > clk_init() is called with parent_name = NULL and get_parent_idx() is
> > implemented, then you call it and the clock returns you the index of
> > the possible_parents array. If that parent clock is not yet
> > registered, you store the requested name and do the lookup when new
> > clocks are registered.
> 
> This approach ends up having something like O(n^2) (similar to
> discussion around driver re-probing).
Split it to two functions? clk_add can add clks in any order, and
clk_tree_init call .get_parent (if possible) create the tree.
Adding clk after clk_tree_init must be in strong order.
> 
> However, I agree that forcing folks to register/init clks in-order is
> asking for trouble.  I also think that for groups of well defined clks
> (SoC clks, or clks in the same device) that are statically initialized
> we should allow for having clk->parent populated statically and leave
> it at that (mux clks will still need to run clk->get_parent() in
> clk_init of course, since we can't trust the bootloader).
right.
> 
> >
> > That has also the advantage, that you can validate parent settings
> > upfront and for setting the parent during runtime, you don't have to
> > acquire a pointer to the parent clock. It's enough to call
> > clk_set_named_parent().
That'll cause clk core to call clkdev functions. But looks fine.

Thanks
Richard
> 
> Right, but the usefulness of this last point hinges on whether or not
> we want to hide struct clk from the rest of the world.  I still think
> that doing so will end up being a limitation that platforms end up
> having to hack around.  I'd like a lot more input from the folks
> porting their platforms to this code on that point, as it is a
> critical design element.
> 
> Thanks for reviewing,
> Mike
> 
> >
> > Thoughts ?
> >
> >         tglx
> >
> >
> >
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

