Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1KQRPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:15:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14146 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab1KQRPT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:15:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Nov 2011 09:15:14 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Date: Thu, 17 Nov 2011 09:15:13 -0800
Subject: RE: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Topic: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
Thread-Index: AcylEEVJb+Xl9CtaTwWEopFnB0LcewAOnnig
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
 <CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
In-Reply-To: <CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
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

Linus Walleij wrote at Thursday, November 17, 2011 3:04 AM:
> On Tue, Nov 15, 2011 at 8:04 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Thomas Abraham wrote at Monday, November 14, 2011 11:00 AM:
> >> On 14 November 2011 22:48, Stephen Warren <swarren@nvidia.com> wrote:
> >> > Linus Walleij wrote at Monday, November 14, 2011 2:11 AM:
> >> >> When requesting a single GPIO pin to be muxed in, some controllers
> >> >> will need to poke a different value into the control register
> >> >> depending on whether the pin will be used for GPIO output or GPIO
> >> >> input. So pass this info along for the gpio_request_enable()
> >> >> function, we assume this is not needed for the gpio_free_disable()
> >> >> function for the time being.
> >> >
> >> > I'm not sure this API change makes sense.
> >> >
> >> > Functions gpio_direction_{input,output} already exist to configure the
> >> > direction of a GPIO, and drivers should already be using them. These have
> >> > to work to allow drivers to toggle the direction dynamically. Requiring
> >> > them to additionally pass this same information to the pinmux driver when
> >> > setting up the pinmux seems like extra redundant work.
> >>
> >> Hardware that require pinmux controller also to be programmed for
> >> setting the gpio direction would require this. Yes, there does seem to
> >> be redundancy if the driver has to call both
> >> gpio_direction_{input,output} and pinmux_request_gpio (with the new
> >> direction parameter). Also, there seems to be a redundancy if the
> >> driver calls both gpio_request and pinmux_request_gpio.
> >
> > Having all drivers call two APIs every time a GPIO needs to be configured
> > seems to be a Bad Thing. Perhaps we can get away with just gpio_request();
> > see below.
> 
> Having all drivers call it is definately not the intention. The way
> I imagine it (and have also implemented it in to-be-sent patches)
> is that
> 
> gpio_request(N, "foo);
> -> GPIOlib driver .request()
>    calls pinmux_request_gpio()
>    -> pinmux driver .gpio_request_enable() if available
>    -> pinmux driver .request() if available
> 
> Here the last two callbacks may need to know the direction.

OK, I'm fine with that concept.

However:

a) gpio_request() doesn't know the direction; only gpio_direction_*()
know that. I suggest the pinctrl API have the same set of GPIO-related
functions that gpiolib has, so each can be passed through to a pinctrl
function 1:1:

gpio_request -> pinmux_gpio_request
gpio_direction_input -> pinmux_gpio_direction_input
gpio_direction_output -> pinmux_gpio_direction_output
gpio_free -> pinmux_gpio_free

(and a pinmux driver ops entry for each too)

Rationale:

Once gpio_request returns success, the pin must be reserved for GPIO,
hence some pinmux function must be called to reserve it, and prevent
any special function from using that pin. The pinmux interaction can't
be deferred until gpio_direction_*, since those shouldn't fail due to
reservation issues.

However, gpio_request doesn't know the IO direction, so if the HW needs
to know this, it can only be programmed in response to gpio_direction_*,
hence there need to be pinmux function matching those APIs too.

For some HW, the HW programming can also happen in gpio_request, if
the pinmux HW doesn't need to know the GPIO direction, as is the case on
Tegra for example.

b) GPIO ID isn't enough for the pinmux driver to work. It covers the
following cases:

b1) A single GPIO controller, where each GPIO can only be routed to a
single pin.

b2) Multiple GPIO controllers, where each GPIO can only be routed to a
single pin; even where multiple GPIO controllers can be routed to the
same pin, the GPIO ID implies the controller, and hence gpio_request can
know which mux option to program in order to choose the correct controller.

However, it doesn't cover the following case:

b3) Some GPIO could be routed to multiple pins, just like any other pinmux
function. In this case, knowing the GPIO ID isn't enough to program the
pinmux, but you need to know both "this GPIO" (which we have) and "this
pin" (which is missing).

I'm not sure how to solve that. For such SoCs, perhaps we should treat
this as a muxing setup, and require it to be in the mapping table, and
consider all the pinmux_gpio_* functions to be "enable GPIO access to
pins" rather than "set up pin mux for GPIOs"?

> If we actively want to stop non-GPIO drivers from using this, shall
> we aim for a compromise to keep the pinmux_request_gpio() call in
> the local header in the pinctrl subsystem, i.e
> 
> drivers/pinctrl/pinmux.h
> 
> Then it can *only* be used by GPIO drivers migrated to the
> pinctrl subsystem, and these probably know what they're doing.

Tegra's GPIO driver has no reason to move into drivers/pinctrl; the HW is
entirely separate from pinmux. I'm sure many other SoCs are similar. As
such, moving the prototype like that would be unhelpful.

-- 
nvpublic

