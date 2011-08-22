Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab1HVMiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:38:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34518 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1HVMiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110821142416.GA12272@gallagher>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
	<20110819104816.GA5030@pulham.picochip.com>
	<CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
	<20110819142608.GB2800@pulham.picochip.com>
	<20110821142416.GA12272@gallagher>
Date: Mon, 22 Aug 2011 14:38:16 +0200
Message-ID: <CACRpkdbB0A6y2vFRV58vvU2DY+zMV+DjS16d71+bajBegTuRdQ@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 4:24 PM, Jamie Iles <jamie@jamieiles.com> wrote:

> for device tree, when the gpio
> controllers are registered, the base is typically dynamically assigned.  I
> suspect that this can be solved in the device tree binding for the controller
> that references the bindings of the pinctrl, but this would require
> registering the gpio_ranges at runtime (or at least the bases).

Oh registering ranges at runtime ... crap. But possible I think.

> So perhaps if we had:
>
> struct pinctrl_gpio_range {
>    unsigned int pinctrl_base;
>    struct gpio_chip *chip;
> }
>
> and then gpio_request_enable was:
>
> int (*gpio_request_enable)(struct pinctrl_dev *pctldev,
>                           struct gpio_chip *gc,
>                           unsigned offset)
>
> Then have pinctrl_register_gpio_chip()?

I'm not following - the struct gpio_chip is opaque outside the gpio
subsystem, I've proposed patches to make it public but they have
been NAK:ed.

Which means pinctrl has no use of that pointer.

What is the intended purpose of sending that thing in?

Right now my range struct looks like this:

/**
 * struct pinctrl_gpio_range - each pin controller can provide subranges of
 * the GPIO number space to be handled by the controller
 * @name: a name for the chip in this range
 * @id: an ID number for the chip in this range
 * @base: base offset of the GPIO range
 * @npins: number of pins in the GPIO range, including the base number
 */
struct pinctrl_gpio_range {
        const char name[16];
        unsigned int id;
        unsigned int base;
        unsigned int npins;
};

> For the static devices case then we can require gc->base must match the
> pinctrl gpio base. For the device tree case we could do some matching of
> device_nodes from the gpio_chip to the pinctrl definitions?

Can't do that since we can't look into struct gpio_chip intrinsics...

But we can register ranges at runtime, I'll just make the pin controller keep
a list of GPIO ranges, simple.

Thanks,
Linus Walleij
