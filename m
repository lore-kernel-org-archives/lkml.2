Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab1JQLcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:32:05 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:48281 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1JQLcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:32:03 -0400
X-SpamScore: -9
X-BigFish: VS-9(z1039oz9371K1432N98dK4015Lzz1202hzz8275bh8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 17 Oct 2011 19:31:51 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, <sboyd@quicinc.com>,
        <broonie@opensource.wolfsonmicro.com>, <magnus.damm@gmail.com>,
        <linux-kernel@vger.kernel.org>, <amit.kucheria@linaro.org>,
        <grant.likely@secretlab.ca>, <dsaxena@linaro.org>,
        <tglx@linutronix.de>, <eric.miao@linaro.org>, <linux@arm.linux.org.uk>,
        <skannan@quicinc.com>, <jeremy.kerr@canonical.com>,
        <shawn.guo@freescale.com>, <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111017113150.GD20184@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <CAJOA=zM9k7_z_PUoF0tZ_OrgdDTgMjZLftqtW0ra3G9C08Th7g@mail.gmail.com>
 <20111015022448.GA17872@b20223-02.ap.freescale.net>
 <CAJOA=zOvAV1f+rXP1jYNPOXAchyJPEEAvCdrNfGVg=iZn3Q3Ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAJOA=zOvAV1f+rXP1jYNPOXAchyJPEEAvCdrNfGVg=iZn3Q3Ag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 02:17:29PM -0700, Turquette, Mike wrote:
> On Fri, Oct 14, 2011 at 7:24 PM, Richard Zhao <richard.zhao@linaro.org> wrote:
> > On Fri, Oct 14, 2011 at 11:14:19AM -0700, Turquette, Mike wrote:
> >> On Thu, Sep 22, 2011 at 3:26 PM, Mike Turquette <mturquette@ti.com> wrote:
> >> unsigned long omap_recalc_rate(struct clk_hw *hw)
> >> {
> >>         struct clk *parent;
> >>         struct clk_hw_omap *oclk;
> >>
> >>         parent = hw->clk->parent;
> > clk drivers can not see struct clk details. I use clk_get_parent.
> 
> clk_get_parent should query the hardware to see what the parent is.
> This can have undesireable overhead.  It is quite acceptable to
> reference a clock's parent through clk->parent, just as it is
> acceptable to get a clock rate through clk->rate.
IMHO, we only need to get parent from hw at register/init time.
clk_get_parent can get it from cache, like current code.
> 
> An analogous situation is a clk_get_rate call which uses a clk's
> .recalc.  There is undesirable overhead involved in .recalc for clocks
> whose rates won't change behind our backs, so best to just treat the
> data in struct clk as cache and reference it directly.
> 
> >>         oclk = to_clk_omap(hw);
> >>         ...
> >> }
> >>
> ...
> >>
> >> unsigned long omap_recalc_rate(struct clk *clk)
> >> {
> >>         struct clk *parent;
> >>         struct clk_hw_omap *oclk;
> >>
> >>         parent = clk->parent;
> >>         oclk = to_clk_omap(clk->hw);
> >>         ...
> >> }
> > In my understanding, struct clk stores things specific to clk core,
> > struct clk_hw stores common things needed by clk drivers. For static clk driver
> > there' some problems:
> >  - For clocks without mux, I need duplicate a  .parent and set .get_parent.
> >   Even when we adopt DT and dynamicly create clk, it's still a problem.
> >   Moving .parent to clk_hw can fix it.
> 
> For clocks with a fixed parent we should just pass it in at
> register-time.  We should definitely not move .parent out of struct
> clk, since struct clk should be the platform agnostic bit that lets us
> do tree walks, build topology, etc etc.
> 
> If you really want a .parent outside of struct clk then duplicate it
> in your struct clk_hw_imx
I don't have clk_hw_imx. I just use generic clks like clk_hw_gate, clk_hw_divider,
clk_hw_mux, and some specific clks.
>  and teach your .ops about it (analogous to
> struct clk_hw_fixed->rate).
I have to define things like below:
stuct pair {
	struct clk_hw *clk = clk_hw_gate.hw;
	struct clk_hw_ops *ops;
};
and use for (.. ) to register the clk array.
> 
> >  - When I define a clk array, I don't need to find another place to store .ops.
> >   It's not problem for dynamic creating clock.
> 
> Something like the following?
> 
> static struct clk aess_fclk;
> 
> static const clk_hw_ops aess_fclk_ops = {
>         .recalc = &omap2_clksel_recalc,
>         .round_rate = &omap2_clksel_round_rate,
>         .set_rate = &omap2_clksel_set_rate,
> };
> 
> static struct clk_hw_omap aess_fclk_hw = {
>         .hw = {
>                 .clk = &aess_fclk,
>         },
>         .clksel = &aess_fclk_div,
>         .clksel_reg = OMAP4430_CM1_ABE_AESS_CLKCTRL,
>         .clksel_mask = OMAP4430_CLKSEL_AESS_FCLK_MASK,
> };
> 
> static struct clk aess_fclk = {
>         .name = "aess_fclk",
>         .ops = &aess_fclk_ops,
>         .hw = &aess_fclk_hw.hw,
>         .parent = &abe_clk,
> };
If we don't protect struct clk members, how about the below:
struct clk_hw_omap aess_fclk = {
	.clk = {
		.name = "aess_fclk",
		.ops = &aess_fclk_ops,
		.parent = &abe_clk,
		};
         .clksel = &aess_fclk_div,
         .clksel_reg = OMAP4430_CM1_ABE_AESS_CLKCTRL,
         .clksel_mask = OMAP4430_CLKSEL_AESS_FCLK_MASK,
};

> 
> >  - As I mentioned in another mail, clk group need no lock version prepare/unprepare
> >   and enable/disable functions
> 
> Clock groups are out of scope for this first series.  We should
> discuss more what the needs are for your clock groups.  If it boils
> down to just enabling all of the clocks for a given device then you
> might want to abstract that away with pm_runtime_* calls, and maybe a
> supplementary layer like OMAP's hwmod.  But I might be way off base, I
> really don't understand your use case for clock groups.
clk group is clk function dependency. I talked about it in another email in this thread.
That's ok to leave it to other framework.
> 
> >   Another way is, add a "{struct clk_hw *clks; int count}" in clk_hw, let clk
> >   core handle it.
> >   I prefer the second way, but I'm not sure whether it's common enough. It's
> >   still a problem for dynamic creating clock.
> 
> struct clk_hw is just a pointer for navigating from struct clk ->
> struct your_custom_clk and vice versa.  Again can you elaborate on
> your needs for managing multiple clocks with a single struct clk_hw?

> 
> Thanks,
> Mike
> 
> >
> > Thanks
> > Richard
> >>
> >> It is a small nitpick, but it affects the API for everybody so best to
> >> get it right now before folks start migrating over to it.
> >>
> >> Thanks,
> >> Mike
> >>
> >> >        int             (*set_rate)(struct clk_hw *,
> >> >                                        unsigned long, unsigned long *);
> >> >        long            (*round_rate)(struct clk_hw *, unsigned long);
> >> >        int             (*set_parent)(struct clk_hw *, struct clk *);
> >> >        struct clk *    (*get_parent)(struct clk_hw *);
> >> >  };
> >>
> >> _______________________________________________
> >> linux-arm-kernel mailing list
> >> linux-arm-kernel@lists.infradead.org
> >> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> >>
> >
> >
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

