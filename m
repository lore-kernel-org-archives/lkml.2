Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2ANEax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 23:30:53 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:43831 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754158Ab2ANEaw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 23:30:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120113124659.GA17029@S2101-09.ap.freescale.net>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20120110213338.GD3226@page> <CACxGe6vqb8AZcZb5WMvfmLsUZH7=SEtBrJCSfsFmDYpKX42MzA@mail.gmail.com>
 <20120113124659.GA17029@S2101-09.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 13 Jan 2012 20:30:30 -0800
Message-ID: <CAJOA=zNGM=743zyantezVk-5q_VmJc92iGBGR8fQM4LY5jxMVQ@mail.gmail.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Jamie Iles <jamie@jamieiles.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 4:47 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Jan 11, 2012 at 09:46:58PM -0700, Grant Likely wrote:
> ...
>> >> +Required properties:
>> >> +- compatible : shall be "fixed-clock".
>> >> +- #clock-cells : from common clock binding; shall be set to 0.
>> >> +- clock-frequency : frequency of clock in Hz. May be multiple cells.
>> >> +
>> >> +Optional properties:
>> >> +- gpios : From common gpio binding; gpio connection to clock enable pin.
>> >
>> > This seems a little odd to me to have in the common binding, but I'm not
>> > that familiar with too many platforms.
>> >
>> >> +- clock-output-names : From common clock binding
>> >> +
>> >> +Example:
>> >> +     clock {
>> >> +             compatible = "fixed-clock";
>> >> +             #clock-cells = <0>;
>> >> +             clock-frequency = <1000000000>;
>> >> +     };
>> >
>> > I wonder if this should have an optional clock consumer with a standard
>> > name for parenting?  For example, on picoxcell there is a fixed 200MHz
>> > APB clock that is really a PLL from a 20MHz reference input and I'd like
>> > to represent that in the clock tree.
>>
>> If it depends on a parent clock, then it really isn't a fixed clock,
>> is it (from the perspective of the OS).  The point of this binding is
>> a trivial way to describe clocks that don't change.  If that
>> assumption doesn't hold true, then this binding isn't suitable for
>> that clock.  As you point out, even the gpio enable feature is pushing
>> things a bit.
>>
> I recently ran into a use case perfectly fitting into this discussion.
>
> We have audio codec sgtl5000 on imx51-babbage board requiring a 26 MHz
> clock input to its SYS_MCLK pin.  The board has a 26 MHz oscillator with
> a gpio control that outputs 26M_OSC_CLK.  And this clock goes through a
> 3-state buffer component with another gpio control, and then goes to
> sgtl5000 SYS_MCLK pin.  The following is what I have in my mind to
> describe them in device tree.
>
> soc_26m_clk: soc-26m-clk {
>        compatible = "fixed-clock";
>        #clock-cells = <0>;
>        clock-frequency = <26000000>;
>        clock-output-names = "soc-26m-clk";
>        gpios = <&gpio3 1 0>;
> };
>
> sgtl5000_clk: sgtl5000-sys-mclk {
>        #clock-cells = <0>;
>        gpios = <&gpio4 26 0>;
>        clocks = <&soc_26m_clk>;
>        clock-names = "soc-26m-clk";
>        clock-output-names = "sgtl5000-sys-mclk";
> };
>
> codec: sgtl5000@0a {
>        compatible = "fsl,sgtl5000";
>        reg = <0x0a>;
>        clocks = <&sgtl5000_clk>;
>        clock-names = "sgtl5000-sys-mclk";
> };
>
> The sgtl5000-sys-mclk is a clock with fixed rate, but the rate is really
> defined by its parent soc-26m-clk, which is anothe fixed-rate clock.  We
> have no doubt that soc-26m-clk is a "fixed-clock".  Is sgtl5000-sys-mclk
> a "fixed-clock"?  The following is the "fixed-clock" defined by Mike's
> implementation.
>
> /*
>  * DOC: basic fixed-rate clock that cannot gate
>  *
>  * Traits of this clock:
>  * prepare - clock never gates.  clk_prepare & clk_unprepare do nothing
>  * enable - clock never gates.  clk_enable & clk_disable do nothing
>  * rate - rate is always a fixed value.  No clk_set_rate support
>  * parent - fixed parent.  No clk_set_parent support
>  *
>  * note: parent can be NULL, which implies that this clock is a root clock.
>  */
> struct clk_hw_ops clk_hw_fixed_ops = {
>       .recalc_rate = clk_hw_fixed_recalc_rate,
>       .get_parent = clk_hw_fixed_get_parent,
> };
>
> It says that the "fixed-clock" can have a fixed parent.  So I should
> probably add compatible = "fixed-clock" for node sgtl5000-sys-mclk too.
> Then should I add clock-frequency property for it too?  I'm not sure
> about that, since the frequency is really defined by its parent.  IOW,
> should the clock-frequency property for "fixed-clock" be optional?  On
> the other hand, let clock-frequency property be optional seems a little
> illogical to the concept of "fixed-clock".  So I'm really confused here.

I had envisioned fixed clocks as being clocks whose rates could never
change; obviously this is mostly useful for root clocks like
oscillators and whatnot.

There is nothing wrong with using fixed clock for sgtl5000-sys-mclk,
but it's rate *can* change if it's parent rate ever changes.  This may
be very unlikely on your platform, in which case again it is OK to use
fixed clock here if you want to.

However... I'm inclined to say that sgtl5000-sys-mclk is good
candidate for a dummy clock: it follows it's parent rate, doesn't
gate, doesn't divide it's parent rate, only has one input.  There
isn't a common dummy clock in the v4 patches, but there is in v5.  The
key difference between the fixed rate clock and the dummy clock is
that the dummy clock looks at clk->parent->rate in it's .get_rate,
whereas a fixed rate clock will have it's rate cached in struct
clk_fixed.

Thoughts?

Mike

> With the proper clock support, I would expect that sgtl5000 driver only
> needs to make the following two calls to have its clock enabled.
>
>        mclk = clk_get(&dev, "sgtl5000-sys-mclk");
>        clk_prepare_enable(mclk);
>
> But looking at the current fixed-clock implementation, there is even
> no clk_enable operation for fixed-clock.  How can we control the clock
> with gpio?
>
> All I'm saying is that we need some level of alignment between clock
> binding and common-clk implementation.
>
> Regards,
> Shawn
>
>> That said, I'm open to extending this binding if something can be
>> defined that will have a lot of use cases.
