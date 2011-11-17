Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1KQKES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 05:04:18 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52439 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab1KQKER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 05:04:17 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
Date: Thu, 17 Nov 2011 11:04:16 +0100
Message-ID: <CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 8:04 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Thomas Abraham wrote at Monday, November 14, 2011 11:00 AM:
>> On 14 November 2011 22:48, Stephen Warren <swarren@nvidia.com> wrote:
>> > Linus Walleij wrote at Monday, November 14, 2011 2:11 AM:
>> >> When requesting a single GPIO pin to be muxed in, some controllers
>> >> will need to poke a different value into the control register
>> >> depending on whether the pin will be used for GPIO output or GPIO
>> >> input. So pass this info along for the gpio_request_enable()
>> >> function, we assume this is not needed for the gpio_free_disable()
>> >> function for the time being.
>> >
>> > I'm not sure this API change makes sense.
>> >
>> > Functions gpio_direction_{input,output} already exist to configure the
>> > direction of a GPIO, and drivers should already be using them. These have
>> > to work to allow drivers to toggle the direction dynamically. Requiring
>> > them to additionally pass this same information to the pinmux driver when
>> > setting up the pinmux seems like extra redundant work.
>>
>> Hardware that require pinmux controller also to be programmed for
>> setting the gpio direction would require this. Yes, there does seem to
>> be redundancy if the driver has to call both
>> gpio_direction_{input,output} and pinmux_request_gpio (with the new
>> direction parameter). Also, there seems to be a redundancy if the
>> driver calls both gpio_request and pinmux_request_gpio.
>
> Having all drivers call two APIs every time a GPIO needs to be configured
> seems to be a Bad Thing. Perhaps we can get away with just gpio_request();
> see below.

Having all drivers call it is definately not the intention. The way
I imagine it (and have also implemented it in to-be-sent patches)
is that

gpio_request(N, "foo);
-> GPIOlib driver .request()
   calls pinmux_request_gpio()
   -> pinmux driver .gpio_request_enable() if available
   -> pinmux driver .request() if available

Here the last two callbacks may need to know the direction.

If we actively want to stop non-GPIO drivers from using this, shall
we aim for a compromise to keep the pinmux_request_gpio() call in
the local header in the pinctrl subsystem, i.e

drivers/pinctrl/pinmux.h

Then it can *only* be used by GPIO drivers migrated to the
pinctrl subsystem, and these probably know what they're doing.

> Igor Grinberg wrote at Tuesday, November 15, 2011 12:16 AM:
>> On 11/14/11 19:18, Stephen Warren wrote:
> ...
>> > Instead, shouldn't it work like this:
>> >
>> > * If the pinmux driver implementation behind pinmux_request_gpio() needs
>> > to know the direction when configuring the HW, default to input for safety;
>> > that will prevent the SoC driving a signal on a GPIO that's driven by some
>> > other device.
>>
>> If the GPIO has been configured for output by boot loader
>> and drives a value, and now you want Linux to take control over it,
>> then configuring it for input will not be safe at all.
>> I think this kind of flexibility is necessary (although it can be
>> implemented in different ways).
>
> That's true; it would be better to get to the final desired state in a
> single explicit step.
>
> So I think the solution for this is for gpio_request() to be redefined
> to affect the pinmux where required.

That was my idea all along, and the intention of that API
pinmux_request_gpio() is for GPIO drivers to use it to set up the
muxing. Maybe I need to think about how to make that clear :-/

> Now I know that Documentation/gpio.txt explicitly says that gpio_request()
> doesn't touch the pinmux... Does anyone know the history there; perhaps we
> can revisit that.

The person who knew what that meant was David Brownell, rest in
peace old friend, now we need to figure this out on our own :-(

My best guess is that this  means "please don't put pinmux drivers into
drivers/gpio/*" which is anyway false since some of them already
do that.

GPIO drivers in drivers/pinctrl is another thing.

> In particular, perhaps on systems that need the pinmux programmed for
> GPIO direction, pinmux_request_gpio() will just reserve the pin, and be
> a no-op as far as HW is convered, whereas gpio_request_*() will call
> into pinmux by a back-door to do the actual pinmux configuration?

IMO it's better to make the pinmux_request_gpio() a backend for GPIO
drivers and GPIO drivers only.

I'll fix some patch.

> It'd be nice to define gpio_request() as always calling pinmux_gpio_request(),

That is what we should do.

> but that won't work on systems where there isn't a 1:1 mapping between
> pins and GPIOs: multiple controllers, or GPIOs can routed to different
> pins.

I think we can handle this (I might be deluded as usual...) since
we have the GPIO range definitions to rely upon. These can be
runtime-assigned.

Yours,
Linus Walleij
