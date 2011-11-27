Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1K0BoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 20:44:09 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:34640 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221Ab1K0BoG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 20:44:06 -0500
MIME-Version: 1.0
In-Reply-To: <20111126084724.GB19025@S2100-06.ap.freescale.net>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-3-git-send-email-mturquette@linaro.org> <4ECC5455.6040806@codeaurora.org>
 <CAJOA=zNPNok6HG1jvg=v-_SFJCyNgYPPJbmTeyfOQ0iYdjbStQ@mail.gmail.com> <20111126084724.GB19025@S2100-06.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sat, 26 Nov 2011 17:43:44 -0800
Message-ID: <CAJOA=zPye3j=r7A8G=MV4ahxzCUEfi-fN-5Ugtx6DKAJ_U5LjA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] Documentation: common clk API
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux@arm.linux.org.uk,
        linaro-dev@lists.linaro.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, paul@pwsan.com, jeremy.kerr@canonical.com,
        Stephen Boyd <sboyd@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>, dsaxena@linaro.org,
        linux-arm-kernel@lists.infradead.org, arnd.bergmann@linaro.org,
        patches@linaro.org, tglx@linutronix.de, linux-omap@vger.kernel.org,
        richard.zhao@linaro.org, linus.walleij@stericsson.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, Colin Cross <ccross@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 12:47 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Wed, Nov 23, 2011 at 12:33:47PM -0800, Turquette, Mike wrote:
>> On Tue, Nov 22, 2011 at 6:03 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
>> > On 11/21/2011 05:40 PM, Mike Turquette wrote:
>> > No strong opinion, but can we call this clk_ops for brevity?
>>
>> I prefer clk_hw_ops, as it clearly delineates that these operations
>> know hardware-specific details.
>>
> I tend to agree with Saravana for brevity.  Looking at clk-basic.c,

I will drop "hw" for V4.

>> >> +
>> >> +clk_set_rate - Attempts to change the clk rate to the one specified.
>> >> +Depending on a variety of common flags it may fail to maintain system
>> >> +stability or result in a variety of other clk rates changing.
>> >
>> > I'm not sure if this is intentional or if it's a mistake in phrasing it. IMHO, the rates of other clocks that are actually made available to device drivers should not be changed. This call might trigger rate changes inside the tree to accommodate the request from various children, but should not affect the rate of the leaf nodes.
>> >
>> > Can you please clarify the intention and/or the wording?
>>
>> Setting the flag CLK_GATE_SET_RATE tells clk_set_rate not to change
>> the rate if the clk is enabled.  This policy is not enforced
>> abritrarily: you don't have to set the flag on your clk.  I'll update
>> the doc to make explicit mention of this flag.
>>
> I guess the concern is not about the flag but the result of clk_set_rate
> that might change a variety of other clocks, while Saravana said it
> should not.  And I agree with Saravana.

This behavior is entirely within the control of whoever ports their
platform over to the common clk fwk.

The set of clks whose rates will be directly changed by a call to
clk_set_rate is: the clk specified in the call to clk_set_rate AND any
parent clks that __clk_set_rate propagates upwards to.  The set of
clks whose rates will be indirectly changed are the children of clks
in the direct set that are not themselves in the direct set.

I'll make it clear here that CLK_PARENT_SET_RATE only steps up one
parent and then whole thing is re-evaluated: meaning that if clk sets
CLK_PARENT_SET_RATE then we might go up to clk->parent (based on the
outcome of clk's .round_rate) and then if clk->parent does NOT set
CLK_PARENT_SET_RATE then propagation ends there.

Based on your comment below where iMX6 leaf clks only need their
parent rate changed, then this will work beautifully for you as
leaf_clk->parent won't set CLK_PARENT_SET_RATE in your case.

> On the contrary, I have clocks on mxs platform which can be set rate
> only when they are enabled, while there are users call clk_set_rate
> when the clock is not enabled yet.  Do we need another flag
> CLK_ON_SET_RATE for this type of clocks?

This brings up the point of where flags belong.  The point of
CLK_GATE_SET_RATE is to either avoid changing rates across a clk that
is not glitchless, or upsetting a functional module at the end of a
chain of clks which cannot gracefully withstand sudden rate change.
This is common enough that it merits being in the common clk code.

Likewise if CLK_ON_SET_RATE is very common, it too should belong in
the common clk code.  If iMX6 is the only platform like this, maybe
your .set_rate should implement this logic and return -ESHUTDOWN or
-EPERM or something so that __clk_set_rate can bail out gracefully.
Do any other platforms need that flag?

>
> I'm unsure that clk API users will all agree with the use of the flags.
> From the code, the clock framework will make the call fail if users
> attempt to clk_set_rate an enabled clock with flag CLK_GATE_SET_RATE.
> And clk API users might argue that they do not (need to) know this
> clock details, and it's clock itself (clock framework or/and clock
> driver) who should handle this type of details.

One way around this is to have clk_set_rate call
clk_disable/__clk_unprepare if CLK_GATE_SET_RATE is set.  Then if the
usecount is still > 0 then clk_set_rate will fail.  Personally I don't
like having the common clk_set_rate making cross-calls to the
enable/disable stuff, but for the sake of exploring the topic...

In your case it will be the opposite: clk_set_rate will call
__clk_prepare/clk_enable and if the usecount is 0 then it will fail.

This starts to get really complicated though and at some point all the
permutation eventually mean that drivers will have to know some
details.

If these flags don't exist I also think that the result will be
drivers that know exactly the details.  In my case it will be:

clk_disable
clk_set_rate
clk_enable

In your case it will be:

clk_enable
clk_set_rate
clk_disable

Maybe I'm over-thinking it?

>
>                clk A
>                  |
>                  |
>                  |
>                clk B -----------\
>                  |              |
>                  |              |
>                  |              |
>                clk C           clk D
>
> You have stated "Another caveat is that child clks might run at weird
> intermediate frequencies during a complex upwards propagation".  I'm
> not sure that intermediate frequency will be safe/reasonable for all
> the clocks.

The solution to this is to set CLK_GATE_SET_RATE on any clk that also
sets CLK_PARENT_SET_RATE and cannot withstand intermediate rates.
Intermediate rates are unavoidable any time you have the following:

child is not gated
child changes its rate
parent changes its rate

The second line ("child changes its rate") is in anticipation of the
third line ("parent changes its rate") and likely results in the child
running at a frequency other than the one it ultimately desires to run
at.

>
> Another thing is what we mentioned above, the set_rate propagating
> should not change other leaf clocks' frequency.  For example, there is
> timer_clk (clk D) as another child of clk B.  When the set_rate of
> clk C gets propagated to change frequency for clk B, it will in turn
> change the frequency for timer_clk.  I'm sure that some talk need to
> happen between clk framework and timer driver before frequency of clk B
> gets actually changed.  Is this something will be handled by rate
> change notifications which is to be added?

Yes, the point you make is exactly why clk rate change notifiers
exist, which includes aborting rate changes when drivers aren't OK
with the changes.  I'll have those notifiers as part of v4.

> I'm currently looking at imx6 and mxs (imx28).  On imx6, I do not see
> the need for set_rate propagation at all.  On mxs, I do see the need,
> but it's a simple propagation, with only one level up and 1-1
> parent-child relationship.  I'm not sure if it's a good idea to support
> the full set_rate propagation from the beginning, since it makes the
> implementation difficult dramatically.

The implementation isn't that complex.  I'll try to provide better
examples in v4 to visualize everything.

I think that practically speaking most SoCs have leaf clocks which
might want to change only their direct parent's rate and that is the
extent of all of this fancy propagation stuff.  However, targeting the
complex cases makes the code better, less narrowly focused and
hopefully a bit more future-proof.

I would also like to point out that as long as your clk doesn't set
the CLK_PARENT_SET_RATE flag then propagation will NEVER happen.  This
is likely going to be the case for 90% of your clks!  You don't have
to worry about this code running wild and hosing clks behind your
back.

If there is still hesitancy with v4 then we can talk about what should
be removed in the name of getting this stuff merged for 3.3.

Thanks for reviewing,
Mike
