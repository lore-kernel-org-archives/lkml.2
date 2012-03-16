Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2CPGWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:22:31 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51175 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717Ab2CPGW1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:22:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120315094357.GX3852@pengutronix.de>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org>
 <1331366064-1273-3-git-send-email-mturquette@linaro.org> <20120311113414.GM3852@pengutronix.de>
 <CAJOA=zMdkLB-DCPOk=kz5mn6BK6A_swocyCHJHeGE6H7FxBbmQ@mail.gmail.com>
 <20120312115117.GN3852@pengutronix.de> <CAJOA=zPx0ARsoO4ueSTMe_z2Gs4xG4P2qn1=-vHFf7_k=+K6hQ@mail.gmail.com>
 <20120313120507.GS3852@pengutronix.de> <CAJOA=zMT4vK7WPF7iEH9kN6GHHAv-LChHoadzieqV-Wd3Qj=WQ@mail.gmail.com>
 <20120315094357.GX3852@pengutronix.de>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 15 Mar 2012 23:22:00 -0700
Message-ID: <CAJOA=zOLaFJ3xoaL2EtX=rkA1XM2gEzyns6meiiGLrbX8HFujQ@mail.gmail.com>
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

On Thu, Mar 15, 2012 at 2:43 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Wed, Mar 14, 2012 at 05:51:48PM -0700, Turquette, Mike wrote:
>> @@ -84,9 +78,9 @@ static int clk_divider_bestdiv(struct clk_hw *hw,
>> unsigned long rate,
>>
>>       for (i = 1; i <= maxdiv; i++) {
>>               parent_rate = __clk_round_rate(__clk_get_parent(hw->clk),
>> -                             MULT_ROUND_UP(rate, i));
>> +                             (rate * i));
>
> I think MULT_ROUND_UP is the right thing to use here (not sure if this
> is a good name though)
> Consider we want to have an output rate of 33Hz. Now acceptable input
> rates for a divider value of 3 would be 99, 100 and 101Hz, so we have
> to call round_rate for the parent with 101Hz which includes 100 and
> 99Hz.

We're back to the point Rob brought up about .round_rate rounding up
or down.  We really need a least-upper-bounds or greatest-lower-bounds
flag, similar to how CPUfreq selects target frequencies today.  I'm
freezing features for this patchset now, so I'll keep your
MULT_ROUND_UP approach and some day I'll fix .round_rate for good.

> If you have problems with your PLL than most likely because it does
> something different on clk_round_rate than it does in clk_set_rate,
> for example clk_round_rate(10000) returns 10000, but clk_set_rate then
> sets the rate 9999 due to some rounding error. Being consistent between
> round_rate and set_rate is very important for this mechanism to work
> properly. It did cost me some nerves to get it right for the divider
> (and even more nerves to figure out why it is correct the way it works)

What I'd like to do is request the *exact* frequency I want when
passing in a rate to my PLLs .round_rate.  Due to the way that my MN
dividers are calculated, and due to some jitter avoidance code, it is
bad for me to request 600000001 Hz when I really want 600MHz exactly.
Anyways I fixed this up on my end enough to work with MULT_ROUND_UP,
so that can stay for the immediate future.

>
>>               now = parent_rate / i;
>> -             if (now <= rate && now >= best) {
>> +             if (now <= rate && now > best) {
>
> This change is an optimization, but should be unrelated to your PLL
> problem, right?

MULT_ROUND_UP yields multiples of 'rate' plus an incrementing value (m
- 1).  Without that incrementing value added to the rate passed into
__clk_round_rate the for loop above will always max out the divider.
To illustrate:

The rate we want is 300MHz.  Without MULT_ROUND_UP the for loop will
start yielding these combinations:

__clk_round_rate(parent, 300MHz), divide-by-1
__clk_round_rate(parent, 600MHz), divide-by-2
__clk_round_rate(parent, 900MHz), divide-by-3
__clk_round_rate(parent, 1200MHz), divide-by-4
...etc...

These all yield the desired 300MHz for our divider so it just keeps
going until you max out the divider and requests some crazy rate for
the parent.  On most hardware that I am aware of it is desirable to
keep the divider as low as possible so the change to the conditional
prevents us from overwriting best every single time while keeping the
divider low.  So yes, it is an optimization, but it is also quite
necessary without MULT_ROUND_UP.

Anyways I've kept MULT_ROUND_UP exactly as-is with the exception that
I've added that small optimization to keep dividers low.  I hope there
are no objections to that.

Regards,
Mike

>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
