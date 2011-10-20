Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab1JTPms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:42:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39237 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221Ab1JTPmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:42:46 -0400
Date: Thu, 20 Oct 2011 16:42:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
Message-ID: <20111020154244.GA26083@opensource.wolfsonmicro.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com> <20111020023140.GC32007@S2100-06.ap.freescale.net> <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com> <CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com> <20111020141827.GB6100@sirena.org.uk> <CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaaUmze+W1n4NkApTX0Se1VJAmD+AJSm36QbsKVDzdnRA@mail.gmail.com>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 04:43:30PM +0200, Linus Walleij wrote:
> On Thu, Oct 20, 2011 at 4:18 PM, Mark Brown

> > The other question is if it's worth bouncing through too much of an
> > abstraction layer when both ends of the API are fixed.

> If drivers doing pinctrl are used in more than one SoC
> both ends aren't fixed. But maybe I'm wrong in assuming that
> such things exist?

There's definitely drivers that will be used over multiple SoCs,
although I'm not sure what the overlap is between them and devices that
need to fiddle with their pin settings at runtime (and how much of the
pin settings they can usefully fiddle with).

> I bet someone made a claim about regulators in its
> infancy, "I just want to communicate to the regulator to set
> voltage number 0x14, the framework shouldn't care what

Not really, actually - with regulators there's a blatantly obvious
abstraction layer to set up as they're physically distinct devices.

> voltage that actually is." The selectors is a good compromise
> that unify expressing voltages and currents with fixed
> discrete steps actually, that is why I like it so much.

That's mostly just a reflection of the reality of how one interacts with
devices of course - at the end of the day you have to translate the
settings into a register write so...

> So there is some lesson abou abstraction to be learned
> here, and the question is, whatever it is that pin control
> is passing around, should the core or anyone else really
> care, or should it be opaque in difference from regulators
> and clocks?

Yes, much of this depends on how much generic drivers (as opposed to
SoCs or boards) are going to need to know about their pin configuration
and talk about it to something else.

> > One fun example is that we have some devices with pins which have
> > runtime controllable voltage domains, there's no obvious SI unit mapping
> > for those.

> If you mean they can only be switched on or off yes,
> they rather need some ON vs OFF parameter setting without
> any unit argument. The unit argument is already optional for a few
> parameters.

> (If you mean you can control the voltage I guess Volt is a nice
> derived SI unit, but I guess you can't since you put the claim
> that way.)

Neither of these things.  As with all pins these are referenced to
particular supply voltages but fairly unusually these devices are able
to change the supply the pin is referenced to.  This changes the level
that outputs are driven at and the levels used for identification of
logic levels on input.

> In Ux500 we model our power domain switches as regulators,
> does such a property even belong in pin control? Is there
> one power domain switch per pin you mean, or a power switch
> for a whole group of pins?

This isn't an on/off control and in this cae it's per pin.
