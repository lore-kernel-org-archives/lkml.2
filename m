Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2CKVZS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 17:25:18 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:55278 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab2CKVZM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 17:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120311113414.GM3852@pengutronix.de>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org> <20120311113414.GM3852@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 11 Mar 2012 14:24:46 -0700
Message-ID: <CAJOA=zMdkLB-DCPOk=kz5mn6BK6A_swocyCHJHeGE6H7FxBbmQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 4:34 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Mike,
>
> I was about to give my tested-by when I decided to test the set_rate
> function. Unfortunately this is broken for several reasons. I'll try
> to come up with a fixup series later the day.

I haven't tested clk_set_rate since V4, but I also haven't changed the
code appreciably.  I'll retest on my end also.

> On Fri, Mar 09, 2012 at 11:54:23PM -0800, Mike Turquette wrote:
>> +     /* find the new rate and see if parent rate should change too */
>> +     WARN_ON(!clk->ops->round_rate);
>> +
>> +     new_rate = clk->ops->round_rate(clk->hw, rate, &parent_new_rate);
>
> You don't need a WARN_ON when you derefence clk->ops->round_rate anyway.

Agreed that the WARN_ON should not be there.

The v6 Documentation/clk.txt states that .round_rate is mandatory for
clocks that can adjust their rate, but I need to clarify this a bit
more.  Ideally we want to be able to call clk_set_rate on any clock
and get a changed rate (if possible) by either adjusting that clocks
rate direction (e.g. a PLL or an adjustable divider) or by propagating
__clk_set_rate up the parents (assuming of course that
CLK_SET_RATE_PARENT flag is set appropriately).

> Also, even when the current clock does not have a set_rate function it
> can still change its rate when the CLK_SET_RATE_PARENT is set.

Correct.  I'll clean this up and make the documentation a bit more
verbose on when .set_rate/.round_rate/.recalc_rate are mandatory.

>
>> +
>> +     /* NOTE: pre-rate change notifications will stack */
>> +     if (clk->notifier_count)
>> +             ret = __clk_notify(clk, PRE_RATE_CHANGE, clk->rate, new_rate);
>> +
>> +     if (ret == NOTIFY_BAD)
>> +             return clk;
>> +
>> +     /* speculate rate changes down the tree */
>> +     hlist_for_each_entry(child, tmp, &clk->children, child_node) {
>> +             ret = __clk_speculate_rates(child, new_rate);
>> +             if (ret == NOTIFY_BAD)
>> +                     return clk;
>> +     }
>> +
>> +     /* change the rate of this clk */
>> +     if (clk->ops->set_rate)
>> +             ret = clk->ops->set_rate(clk->hw, new_rate);
>
> I don't know the reason why you change the child clock before the parent
> clock, but it cannot work since this clock will change its rate based on
> the old parent rate and not the new one.

This depends on the .round_rate implementation, which I admit to
having lost some sleep over.  A clever .round_rate will request the
"intermediate" rate for a clock when propagating a request to change
the parent rate later on.  Take for instance the following:

pll @ 200MHz (locked)
    |
parent @ 100MHz (can divide by 1 or 2; currently divider is 2)
    |
child @ 25MHz (can divide by 2 or 4; currently divider is 4)

If we want child to run at 100MHz then the desirable configuration
would be to have parent divide-by-1 and child divide-by-2.  When we
call,

clk_set_rate(child, 100MHz);

Its .round_rate should return 50MHz, and &parent_new_rate should be
200MHz.  So 50MHz is an "intermediate" rate, but it gets us the
divider we want.  And in fact 50MHz reflects reality because that will
be the rate of child until the parent propagation completes and we can
adjust parent's dividers.  (this is one reason why I prefer for
pre-rate change notifiers to stack on top of each other).

So now that &parent_new_rate is > 0, __clk_set_rate will propagate the
request up and parent's .round_rate will simply return 200MHz and
leave it's own &parent_new_rate at 0.  This will change from
divide-by-2 to divide-by-1 and from this highest point in the tree we
will propagate post-rate change notifiers downstream, as part of the
recalc_rate tree walk.

I have tested this with OMAP4's CPUfreq driver and I think, while
complicated, it is a sound way to approach the problem.  Maybe the API
can be cleaned up, if you have any suggestions.

Regards,
Mike

>
> There are more things, as said I'll try to come up with a fixup series.
>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
