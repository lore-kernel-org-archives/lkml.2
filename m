Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1KUKrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:47:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63794 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1KUKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:47:30 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
	<CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805E0A@HQMAIL01.nvidia.com>
	<CACRpkdYz_gOP22cHgtdo5GqY6P_DeCbykFm1MS6Kua_ERVKEpQ@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740D74BC3@HQMAIL01.nvidia.com>
Date: Mon, 21 Nov 2011 11:47:29 +0100
Message-ID: <CACRpkdapm2cx=QJkPinwteCPZFNNnxVcKqR4f0D8_ikWMTea_g@mail.gmail.com>
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

On Thu, Nov 17, 2011 at 6:15 PM, Stephen Warren <swarren@nvidia.com> wrote:

> a) gpio_request() doesn't know the direction; only gpio_direction_*()
> know that. I suggest the pinctrl API have the same set of GPIO-related
> functions that gpiolib has, so each can be passed through to a pinctrl
> function 1:1:
>
> gpio_request -> pinmux_gpio_request
> gpio_direction_input -> pinmux_gpio_direction_input
> gpio_direction_output -> pinmux_gpio_direction_output
> gpio_free -> pinmux_gpio_free
>
> (and a pinmux driver ops entry for each too)

You are right, the current solution is messy, and this is way more
elegant and to the point. I'll fix up the patch set and resubmit it.

> However, it doesn't cover the following case:
>
> b3) Some GPIO could be routed to multiple pins, just like any other pinmux
> function. In this case, knowing the GPIO ID isn't enough to program the
> pinmux, but you need to know both "this GPIO" (which we have) and "this
> pin" (which is missing).
>
> I'm not sure how to solve that. For such SoCs, perhaps we should treat
> this as a muxing setup, and require it to be in the mapping table, and
> consider all the pinmux_gpio_* functions to be "enable GPIO access to
> pins" rather than "set up pin mux for GPIOs"?

I think we'll survive that, since the gpio range concept is supposed to
make the final resolution of that at runtime.

Now ranges are dynamic, so if these pin allocation also want to
*change* at runtime it will be hairy, but that only reflects the actual
trouble in doing such re-arrangements I think...

Changing pin allocation at runtime seems dangerous but if you
only have a few limited GPIO blocks but many GPIO pins it could
happen, but I think we can deal with that the day it surfaces.

>> If we actively want to stop non-GPIO drivers from using this, shall
>> we aim for a compromise to keep the pinmux_request_gpio() call in
>> the local header in the pinctrl subsystem, i.e
>>
>> drivers/pinctrl/pinmux.h
>>
>> Then it can *only* be used by GPIO drivers migrated to the
>> pinctrl subsystem, and these probably know what they're doing.
>
> Tegra's GPIO driver has no reason to move into drivers/pinctrl; the HW is
> entirely separate from pinmux. I'm sure many other SoCs are similar. As
> such, moving the prototype like that would be unhelpful.

OK it never seemed like a good idea anyway, I'm keeping in in
<pinctrl/pinmux.h>

Yours,
Linus Walleij
