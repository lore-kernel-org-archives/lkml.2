Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab1KOTEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:04:14 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10280 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab1KOTEN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:04:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 Nov 2011 11:04:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 15 Nov 2011 11:04:07 -0800
Subject: RE: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Topic: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Index: Acyi900t9ijpl/qnRJWQ7OIAa4o0fQAz/jng
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
 <CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
In-Reply-To: <CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote at Monday, November 14, 2011 11:00 AM:
> On 14 November 2011 22:48, Stephen Warren <swarren@nvidia.com> wrote:
> > Linus Walleij wrote at Monday, November 14, 2011 2:11 AM:
> >> When requesting a single GPIO pin to be muxed in, some controllers
> >> will need to poke a different value into the control register
> >> depending on whether the pin will be used for GPIO output or GPIO
> >> input. So pass this info along for the gpio_request_enable()
> >> function, we assume this is not needed for the gpio_free_disable()
> >> function for the time being.
> >
> > I'm not sure this API change makes sense.
> >
> > Functions gpio_direction_{input,output} already exist to configure the
> > direction of a GPIO, and drivers should already be using them. These have
> > to work to allow drivers to toggle the direction dynamically. Requiring
> > them to additionally pass this same information to the pinmux driver when
> > setting up the pinmux seems like extra redundant work.
> 
> Hardware that require pinmux controller also to be programmed for
> setting the gpio direction would require this. Yes, there does seem to
> be redundancy if the driver has to call both
> gpio_direction_{input,output} and pinmux_request_gpio (with the new
> direction parameter). Also, there seems to be a redundancy if the
> driver calls both gpio_request and pinmux_request_gpio.

Having all drivers call two APIs every time a GPIO needs to be configured
seems to be a Bad Thing. Perhaps we can get away with just gpio_request();
see below.

Igor Grinberg wrote at Tuesday, November 15, 2011 12:16 AM:
> On 11/14/11 19:18, Stephen Warren wrote:
...
> > Instead, shouldn't it work like this:
> >
> > * If the pinmux driver implementation behind pinmux_request_gpio() needs
> > to know the direction when configuring the HW, default to input for safety;
> > that will prevent the SoC driving a signal on a GPIO that's driven by some
> > other device.
> 
> If the GPIO has been configured for output by boot loader
> and drives a value, and now you want Linux to take control over it,
> then configuring it for input will not be safe at all.
> I think this kind of flexibility is necessary (although it can be
> implemented in different ways).

That's true; it would be better to get to the final desired state in a
single explicit step.

So I think the solution for this is for gpio_request() to be redefined
to affect the pinmux where required.

Now I know that Documentation/gpio.txt explicitly says that gpio_request()
doesn't touch the pinmux... Does anyone know the history there; perhaps we
can revisit that.

In particular, perhaps on systems that need the pinmux programmed for
GPIO direction, pinmux_request_gpio() will just reserve the pin, and be
a no-op as far as HW is convered, whereas gpio_request_*() will call
into pinmux by a back-door to do the actual pinmux configuration?

Similarly on Tegra, to select a pin as a GPIO, you actually write a bit
to a GPIO register that overrides the pinmux function selection. Right
now, I have the pinmux driver calling into the GPIO driver to do this.
I could remove this backdoor call, and rely solely on gpio_request_*()
for this.

I suppose there's still a problem on HW that can mux multiple GPIOs onto
a single pin, /and/ needs to distinguish GPIO in vs. out while doing so.
I guess this could be handled by having pinmux_request_gpio do:

If pin is already a GPIO:
    Leave it untouched
Else:
    Configure pin pin to be a GPIO on desired controller,
    picking in/out as appropriate for HW to avoid glitches

gpio_request_*() would still call into the pinmux driver by a back door
to select the final desired IO direction.

It'd be nice to define gpio_request() as always calling pinmux_gpio_request(),
but that won't work on systems where there isn't a 1:1 mapping between
pins and GPIOs: multiple controllers, or GPIOs can routed to different
pins.

-- 
nvpublic

