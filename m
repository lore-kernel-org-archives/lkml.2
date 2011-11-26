Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1KZIfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 03:35:18 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:14106
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752569Ab1KZIfP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 03:35:15 -0500
X-SpamScore: -17
X-BigFish: VS-17(zzbb2dK9371K168aJ1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Sat, 26 Nov 2011 16:47:25 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: "Turquette, Mike" <mturquette@ti.com>
CC: Saravana Kannan <skannan@codeaurora.org>, <linux@arm.linux.org.uk>,
        <linaro-dev@lists.linaro.org>, <eric.miao@linaro.org>,
        <grant.likely@secretlab.ca>, <aul@pwsan.com>,
        <jeremy.kerr@canonical.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>, <dsaxena@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <arnd.bergmann@linaro.org>,
        <patches@linaro.org>, <tglx@linutronix.de>,
        <linux-omap@vger.kernel.org>, <richard.zhao@linaro.org>,
        <linus.walleij@stericsson.com>, <broonie@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, <amit.kucheria@linaro.org>
Subject: Re: [PATCH v3 2/5] Documentation: common clk API
Message-ID: <20111126084724.GB19025@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-3-git-send-email-mturquette@linaro.org>
 <4ECC5455.6040806@codeaurora.org>
 <CAJOA=zNPNok6HG1jvg=v-_SFJCyNgYPPJbmTeyfOQ0iYdjbStQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAJOA=zNPNok6HG1jvg=v-_SFJCyNgYPPJbmTeyfOQ0iYdjbStQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 12:33:47PM -0800, Turquette, Mike wrote:
> On Tue, Nov 22, 2011 at 6:03 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> > On 11/21/2011 05:40 PM, Mike Turquette wrote:

[...]

> >> +is modified slightly for brevity:
> >> +
> >> +struct clk {
> >> +       const char              *name;
> >> +       const struct clk_hw_ops *ops;
> >
> > No strong opinion, but can we call this clk_ops for brevity?
> 
> I prefer clk_hw_ops, as it clearly delineates that these operations
> know hardware-specific details.
> 
I tend to agree with Saravana for brevity.  Looking at clk-basic.c,
I do not think it's necessary to encode 'hw' in naming of clk_hw_fixed,
clk_hw_gate and any clocks wrapping 'struct clk' in there.  For
example, naming like clk_dummy, clk_imx seems brevity and clear,
and we do not need clk_hw_dummy and clk_hw_imx necessarily.

[...]

> >> +
> >> +clk_set_rate - Attempts to change the clk rate to the one specified.
> >> +Depending on a variety of common flags it may fail to maintain system
> >> +stability or result in a variety of other clk rates changing.
> >
> > I'm not sure if this is intentional or if it's a mistake in phrasing it. IMHO, the rates of other clocks that are actually made available to device drivers should not be changed. This call might trigger rate changes inside the tree to accommodate the request from various children, but should not affect the rate of the leaf nodes.
> >
> > Can you please clarify the intention and/or the wording?
> 
> Setting the flag CLK_GATE_SET_RATE tells clk_set_rate not to change
> the rate if the clk is enabled.  This policy is not enforced
> abritrarily: you don't have to set the flag on your clk.  I'll update
> the doc to make explicit mention of this flag.
> 
I guess the concern is not about the flag but the result of clk_set_rate
that might change a variety of other clocks, while Saravana said it
should not.  And I agree with Saravana.

> >> +clk_set_rate deserves a special mention because it is more complex than
> >> +the other operations.  There are three key concepts to the common
> >> +clk_set_rate implementation:
> >> +
> >> +1) recursively traversing up the clk tree and changing clk rates, one
> >> +parent at a time, if each clk allows it
> >> +2) failing to change rate if the clk is enabled and must only change
> >> +rates while disabled
> >
> > Is this really true? Based on a quick glance at the other patches, it doesn't look it disallows set rate if the clock is enabled. Which is correct, because clock rates can be change while they are enabled (I'm referring to leaf clocks) as long as the hardware supports doing it correctly. So, this needs rewording? I'm guessing you are trying to say that you can't change the parent rate if it has multiple enabled child clocks running off of it and one of them wants to cause a parent rate change? I'm not sure if even that should be enforced in the common code -- doesn't look like you do either.
> 
> Same as my answer above.  There is a flag which allows you to control
> this behavior.
> 
On the contrary, I have clocks on mxs platform which can be set rate
only when they are enabled, while there are users call clk_set_rate
when the clock is not enabled yet.  Do we need another flag
CLK_ON_SET_RATE for this type of clocks?

I'm unsure that clk API users will all agree with the use of the flags.
>From the code, the clock framework will make the call fail if users
attempt to clk_set_rate an enabled clock with flag CLK_GATE_SET_RATE.
And clk API users might argue that they do not (need to) know this
clock details, and it's clock itself (clock framework or/and clock
driver) who should handle this type of details.

> >
> >> +2) using clk rate change notifiers to allow devices to handle dynamic
> >
> > Must be 3)
> 
> Haha good catch.
> 
> >>
> >> +rate changes for clks which do support changing rates while enabled
> >
> > Again, I guess this applies to the other clock. Not the one for which clk_set_rate() is being called.
> 
> This applies to ANY clk which has the flag set and is called by
> __clk_set_rate (which may be called many times in a recursive path).
> 
> >> +clk_set_rate(C, 26MHz);
> >> +       __clk_set_rate(C, 26MHz);
> >> +               clk->round_rate(C, 26MHz, *parent_rate);
> >> +               [ round_rate returns 50MHz ]
> >> +               [&parent_rate is 52MHz ]
> >> +               clk->set_rate(C, 50Mhz);
> >> +               [ clk C is set to 50MHz, which sets divider to 2 ]
> >> +               __clk_set_rate(clk->parent, parent_rate);
> >> +                       clk->round_rate(B, 52MHz, *parent_rate);
> >> +                       [ round_rate returns 100MHz ]
> >> +                       [&parent_rate is 104MHz ]
> >> +                       clk->set_rate(B, 100MHz);
> >> +                       [ clk B stays at 100MHz, divider stays at 2 ]
> >> +                       __clk_set_rate(clk->parent, parent_rate);
> >> +                               [ round_rate returns 104MHz ]
> >> +                               [&parent_rate is ignored ]
> >> +                               clk->set_rate(A, 104MHz);
> >> +                               [ clk A is set to 104MHz]
> >> +
> >
> > I will come back to this topic later on. I like the idea of propagating the needs to the parent, but not sure if the current implementation will work for all types of clock trees/set rates even though the HW might actually allow it to be done right.
> 
> I'll need more to go on than "it may not work".

		clk A
		  |
		  |
		  |
		clk B -----------\
		  |		 |
		  |		 |
		  |		 |
		clk C		clk D

You have stated "Another caveat is that child clks might run at weird
intermediate frequencies during a complex upwards propagation".  I'm
not sure that intermediate frequency will be safe/reasonable for all
the clocks.

Another thing is what we mentioned above, the set_rate propagating
should not change other leaf clocks' frequency.  For example, there is
timer_clk (clk D) as another child of clk B.  When the set_rate of
clk C gets propagated to change frequency for clk B, it will in turn
change the frequency for timer_clk.  I'm sure that some talk need to
happen between clk framework and timer driver before frequency of clk B
gets actually changed.  Is this something will be handled by rate
change notifications which is to be added?

> As proof of concept I
> converted OMAP4's CPUfreq driver to use this strategy.  Quick
> explanation:
> 
> OMAP4's CPUfreq driver currently adjusts the rate of a PLL via
> clk_set_rate.  However the PLL isn't *really* the clk closest to the
> ARM IP, there are other divider clocks after the PLL, which typically
> divide by 1.  So practically speaking the PLL is the one that matters
> with respect to getting the Cortex-A9 rates to change.
> 
> To test the recursive clk_set_rate I wrote a new .round_rate for the
> clks below the PLL and set the CLK_PARENT_SET_RATE flag on those clks.
>  Then I changed the CPUfreq driver to call clk_set_rate on the lowest
> clk in that path (instead of the PLL) which better reflects reality.
> The code worked perfectly, propagating the request up to the PLL where
> the rate was finally set.
> 
> This was a simple test since that PLL is dedicated to the Cortex-A9s,
> but the code does work.  If there is a sequencing issue please let me
> know and I'll see how things can be re-arranged or made more flexible
> for your platform.
> 
I'm currently looking at imx6 and mxs (imx28).  On imx6, I do not see
the need for set_rate propagation at all.  On mxs, I do see the need,
but it's a simple propagation, with only one level up and 1-1
parent-child relationship.  I'm not sure if it's a good idea to support
the full set_rate propagation from the beginning, since it makes the
implementation difficult dramatically.

-- 
Regards,
Shawn

