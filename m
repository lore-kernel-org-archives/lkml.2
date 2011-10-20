Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab1JTOnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:43:32 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61736 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1JTOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <20111020141827.GB6100@sirena.org.uk>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<20111020023140.GC32007@S2100-06.ap.freescale.net>
	<CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
	<CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com>
	<20111020141827.GB6100@sirena.org.uk>
Date: Thu, 20 Oct 2011 16:43:30 +0200
Message-ID: <CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 4:18 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Oct 20, 2011 at 04:04:47PM +0200, Linus Walleij wrote:

>> I think (and of course this may be completely wrong, but it's my
>> working hypthesis) that the things that software wants to do to
>> pins are:
>
> The other question is if it's worth bouncing through too much of an
> abstraction layer when both ends of the API are fixed.

If drivers doing pinctrl are used in more than one SoC
both ends aren't fixed. But maybe I'm wrong in assuming that
such things exist?

I bet someone made a claim about regulators in its
infancy, "I just want to communicate to the regulator to set
voltage number 0x14, the framework shouldn't care what
voltage that actually is." The selectors is a good compromise
that unify expressing voltages and currents with fixed
discrete steps actually, that is why I like it so much.

And the same could probably be said about why the clock
framework insist on expressing frequencies in Hz
including all the trouble with using clk_round_rate() if all my
SoC drivers doing clk_get_rate() and clk_set_rate() already know
very well that rate 0x54 is the frequency it wants to set.

So there is some lesson abou abstraction to be learned
here, and the question is, whatever it is that pin control
is passing around, should the core or anyone else really
care, or should it be opaque in difference from regulators
and clocks?

>> Yet again, can I have some examples of what
>> PIN_CONFIG_USER may *actually* be, which would be
>> absolutely impossible to express in some neutral way, and
>> ridiculous to have in the generic enum?
>
> One fun example is that we have some devices with pins which have
> runtime controllable voltage domains, there's no obvious SI unit mapping
> for those.

If you mean they can only be switched on or off yes,
they rather need some ON vs OFF parameter setting without
any unit argument. The unit argument is already optional for a few
parameters.

(If you mean you can control the voltage I guess Volt is a nice
derived SI unit, but I guess you can't since you put the claim
that way.)

In Ux500 we model our power domain switches as regulators,
does such a property even belong in pin control? Is there
one power domain switch per pin you mean, or a power switch
for a whole group of pins?

On a related key we have the part that gpiolib is handling already,
setting a pin to input or output and driving it low or high -
I have no plans to model that through the pinconfig API by
exposing some PIN_CONFIG_SET_OUTPUT,
PIN_CONFIG_SET_INPUT, PIN_CONFIG_DRIVE_HIGH,
PIN_CONFIG_DRIVE_LOW, that would be madness, what we
do is of course expose a struct gpio_chip interface for that
stuff and register to gpiolib.

Thus it might be that pins should express their voltage domain
switches as a regulator rather than trying to do it in pin control?

Yours,
Linus Walleij
