Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934083Ab2JXMy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:54:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36067 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab2JXMyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:54:24 -0400
MIME-Version: 1.0
In-Reply-To: <20121023200249.GA2712@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<508660D4.9030507@ti.com>
	<20121023200249.GA2712@core.coreip.homeip.net>
Date: Wed, 24 Oct 2012 14:54:23 +0200
Message-ID: <CACRpkdYwA7O8AqB8YFCK-c3e6-7FcbhMOiPEUq-cKJni_PO-Ow@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Benoit Cousson <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        tony@atomide.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:02 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> I have seen just in a few days 3 or 4 drivers having exactly the same
> change - call to devm_pinctrl_get_select_default(), and I guess I will
> receive the same patches for the rest of input drivers shortly.
> This suggests that the operation is done at the wrong level. Do the
> pin configuration as you parse DT data, the same way you set up i2c
> devices registers in of_i2c.c, and leave the individual drivers that do
> not care about specifics alone.

Exactly this can be done with pinctrl hogs.

The problem with that is that it removes the cross-reference
between the device and it's pinctrl handle (also from the device
tree). Instead the pinctrl handle gets referenced to the pin controller
itself. So from a modelling perpective this looks a bit ugly.

So we have two kinds of ugly:

- Sprinke devm_pinctrl_get_select_default() over all drivers
  which makes pinctrl handles properly reference their devices

- Use hogs and loose coupling between pinctrl handles and their
  devices

A third alternative as outlined is to use notifiers and some
resource core in drivers/base/*

>> That's why it is named "get_select_default" and not "get" only.
>> This API ensure that the pin will be set to the default state, and this
>> is all we need to do during the probe.
>
> Why during the probe and not by default? Realistically, the driver will
> be loaded as long as there is a matching device and pins will need to be
> configured.

Hogs will do it by default but will disassociate the pinctrl from its
device as described.

>> There is no point to change the mux if the driver is not probed, because
>> potentially the pin can be use be another driver.
>
> What other driver would use it? Who would chose what driver to load?

I don't know about this specific driver, but for the SKE
keypad driver we have a runtime case switching around the
pins.

We recently patched the pinctrl core for a specific usecase like
this, and in that case both drivers are loaded, but one will be
disabled at runtime and the other become active.

In the ux500, if you need to perform deep debugging on a running
system (an ordinary cell phone, say) you can at runtime convert
the SD card output into an STM trace port and start monitoring
different messages coming out on a MIPI-type bus.

So basically it is not an SD card slot anymore, it turns into
something else, the silicon core for MMC/SD is decoupled from its
pins, and they are re-routed to the STM tracer. And you plug
a special piece of hardware into the SD-card slot and it
has a USB cord or something collection standard MIPI
traces.

We have the same for the SKE keypad actually. We can shunt
the STM tracing signals out on this as well, you "just" unmount
the physical keypad and start using the lines on the PCB as
a trace collecting mechanism.

Thus we need - at runtime, in systems produced in the the
millions, it's not "just for fun" - to recouple pins from one IP
block to another and turn it into a totally different thing.

Yours,
Linus Walleij
