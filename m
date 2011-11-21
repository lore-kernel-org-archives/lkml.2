Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab1KUVoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:44:24 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47386 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1KUVoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C17B@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
	<CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
	<CACRpkdapm2cx=QJkPinwteCPZFNNnxVcKqR4f0D8_ikWMTea_g@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF174F08C17B@HQMAIL01.nvidia.com>
Date: Mon, 21 Nov 2011 22:44:22 +0100
Message-ID: <CACRpkdZsYrCJoEFM5_mrMCns_2AXYFxCxQc=97-1pJVvrGpiiw@mail.gmail.com>
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

On Mon, Nov 21, 2011 at 8:00 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, November 21, 2011 3:47 AM:
>> [Stephen]
>> > However, it doesn't cover the following case:
>> >
>> > b3) Some GPIO could be routed to multiple pins, just like any other pinmux
>> > function. In this case, knowing the GPIO ID isn't enough to program the
>> > pinmux, but you need to know both "this GPIO" (which we have) and "this
>> > pin" (which is missing).
>> >
>> > I'm not sure how to solve that. For such SoCs, perhaps we should treat
>> > this as a muxing setup, and require it to be in the mapping table, and
>> > consider all the pinmux_gpio_* functions to be "enable GPIO access to
>> > pins" rather than "set up pin mux for GPIOs"?
>>
>> I think we'll survive that, since the gpio range concept is supposed to
>> make the final resolution of that at runtime.
>>
>> Now ranges are dynamic, so if these pin allocation also want to
>> *change* at runtime it will be hairy, but that only reflects the actual
>> trouble in doing such re-arrangements I think...
>
> Doing this with dynamic GPIO ranges sounds complex; every time the mux
> setting gets changed for a pin which can be a GPIO, you'd have to adjust
> the dynamic ranges; this sounds like a lot of work.
>
> I thought I'd sent this on Friday, but perhaps I only thought it up over
> the weekend... Here's my proposal:
>
> 1)
>
> Add a new gpiolib API:
>
> int gpio_request_at(unsigned gpio, const char *label, unsigned at);

This has a nice look to it, I must admit.

Since the pinctrl number space is per-controller this signature
will not work. It would have to pass in a pin controller reference
too, preferably as struct device * or a string. Else "at" is just
a number without meaning. "At *which* controller?"

And I think you notice below, and then suggest how to modify
gpiolib to hold a reference to its pinctrl (which is viable).

Still is looks like hm, "at" well you're anyway encoding knowledge
about which pin you want to use you definately know which
pin controller you're dealing with anyway so then you can just
pass both pieces of information:

int gpio_request_at(unsigned gpio, const char *label, const char
*pinctrl_name, unsigned at);

as in:

foo = gpio_request_at(17, "my GPIO", "pinctrl.0", 14);

Would solve that since you can look up a controller by the name
string.

> Now, you do need to write a pinctrl_get_gpio_dev() function, so I suppose
> that pinctrl drivers will need to tell the pinctrl core their min/max
> GPIO IDs, and I suppose there could be many ranges, so we get back to
> registering ranges. Ick.
>
> (In a system with multiple pinctrl drivers, you can't just grab "the"
> pinctrl driver here, because there's more than one, and different gpiolib
> GPIO ranges will probably map to different pinctrl drivers)
>
> Perhaps we could get some help from gpiolib; for each GPIO chip that
> gets registered, can gpiolib store the pctldev and pass it into the
> pinctrl driver:
>
> /* Or some equivalent first parameter */
> int pinmux_request_gpio(struct pinctrl_dev *pctldev, unsigned gpio, unsigned at);
>
> pinctrl driver probe would probably need to do something like:
>
> pinctrl_set_gpio_driver(gpio, numgpios, <driver handle>)
>
> which internally would do nothing but call:
>
> gpiolib_set_gpiochip_pinctrl_driver(f(<driver handle>), gpio)
>
> where f(<driver handle>) is whatever gets passed as the first parameter to
> pinmux_request_gpio()?

Yes letting gpio_chip hold a reference to the pin controller
is equivalent to the pin controller GPIO range holding a
reference to the struct gpio_chip * as it can do today.

Any solution like the above needs to be anchored with the
GPIO maintainer anyway.

My past attempts to patch gpio_chip have been shot down,
pinctrl was created to get away from having to introduce any kind of
control or muxing in gpiolib drivers. The current ranges are
totally encapsulated in the pinctrl subsystem and that's a pretty
nice feature I suspect.

Yours,
Linus Walleij
