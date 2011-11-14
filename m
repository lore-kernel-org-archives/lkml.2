Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab1KNSAb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 13:00:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56683 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab1KNSAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 13:00:30 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
References: <1321261837-31320-1-git-send-email-linus.walleij@stericsson.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1740805AAE@HQMAIL01.nvidia.com>
Date: Mon, 14 Nov 2011 23:30:29 +0530
Message-ID: <CAJuYYwTKNLh0NxfUBubGJuyLFDgkD6qPc=brd8dLObUW9p0tgA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: indicate GPIO direction on single GPIO request
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2011 22:48, Stephen Warren <swarren@nvidia.com> wrote:
> Linus Walleij wrote at Monday, November 14, 2011 2:11 AM:
>> When requesting a single GPIO pin to be muxed in, some controllers
>> will need to poke a different value into the control register
>> depending on whether the pin will be used for GPIO output or GPIO
>> input. So pass this info along for the gpio_request_enable()
>> function, we assume this is not needed for the gpio_free_disable()
>> function for the time being.
>
> I'm not sure this API change makes sense.
>
> Functions gpio_direction_{input,output} already exist to configure the
> direction of a GPIO, and drivers should already be using them. These have
> to work to allow drivers to toggle the direction dynamically. Requiring
> them to additionally pass this same information to the pinmux driver when
> setting up the pinmux seems like extra redundant work.

Hardware that require pinmux controller also to be programmed for
setting the gpio direction would require this. Yes, there does seem to
be redundancy if the driver has to call both
gpio_direction_{input,output} and pinmux_request_gpio (with the new
direction parameter). Also, there seems to be a redundancy if the
driver calls both gpio_request and pinmux_request_gpio.

>
> Instead, shouldn't it work like this:
>
> * If the pinmux driver implementation behind pinmux_request_gpio() needs
> to know the direction when configuring the HW, default to input for safety;
> that will prevent the SoC driving a signal on a GPIO that's driven by some
> other device.
>
> * Rely exclusively on gpio_direction_{input,output} to allow drivers to
> configure the direction.
>
> * If the pinmux HW needs programming in response to the gpio_direction_*
> calls, have the GPIO and pinmux driver internally communicate to achieve
> this.

If gpio_direction_* does have to setup the pinmux, then it has to be
done using one the external interfaces which the pinctrl/pinmux
subsystem provides. That has been pinmux_request_gpio for now. If
adding 'direction' to pinmux_request_gpio is redundant, then there
should be another external interface provided by pinmux subsystem for
gpio_direction_{input,output} to setup the direction.

Thanks,
Thomas.

>
> Does that seem reasonable?
>
> --
> nvpublic
>
>
