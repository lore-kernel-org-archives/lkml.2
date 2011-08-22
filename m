Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750Ab1HVMyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 08:54:17 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47377 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1HVMyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 08:54:13 -0400
Date: Mon, 22 Aug 2011 13:54:08 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jamie Iles <jamie@jamieiles.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110822125408.GC2796@pulham.picochip.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
 <20110819104816.GA5030@pulham.picochip.com>
 <CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
 <20110819142608.GB2800@pulham.picochip.com>
 <20110821142416.GA12272@gallagher>
 <CACRpkdbB0A6y2vFRV58vvU2DY+zMV+DjS16d71+bajBegTuRdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbB0A6y2vFRV58vvU2DY+zMV+DjS16d71+bajBegTuRdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 02:38:16PM +0200, Linus Walleij wrote:
> On Sun, Aug 21, 2011 at 4:24 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> 
> > for device tree, when the gpio
> > controllers are registered, the base is typically dynamically assigned.  I
> > suspect that this can be solved in the device tree binding for the controller
> > that references the bindings of the pinctrl, but this would require
> > registering the gpio_ranges at runtime (or at least the bases).
> 
> Oh registering ranges at runtime ... crap. But possible I think.
> 
> > So perhaps if we had:
> >
> > struct pinctrl_gpio_range {
> >    unsigned int pinctrl_base;
> >    struct gpio_chip *chip;
> > }
> >
> > and then gpio_request_enable was:
> >
> > int (*gpio_request_enable)(struct pinctrl_dev *pctldev,
> >                           struct gpio_chip *gc,
> >                           unsigned offset)
> >
> > Then have pinctrl_register_gpio_chip()?
> 
> I'm not following - the struct gpio_chip is opaque outside the gpio
> subsystem, I've proposed patches to make it public but they have
> been NAK:ed.
> 
> Which means pinctrl has no use of that pointer.
> 
> What is the intended purpose of sending that thing in?

Well even though the gpio_chip is opaque to pinctrl, the pointer can 
still be used for searching, which means that gpio_request() doesn't 
need to know the integer instance number (which would presumably be 
passed with platform_data for non-DT?).

> Right now my range struct looks like this:
> 
> /**
>  * struct pinctrl_gpio_range - each pin controller can provide subranges of
>  * the GPIO number space to be handled by the controller
>  * @name: a name for the chip in this range
>  * @id: an ID number for the chip in this range
>  * @base: base offset of the GPIO range
>  * @npins: number of pins in the GPIO range, including the base number
>  */
> struct pinctrl_gpio_range {
>         const char name[16];
>         unsigned int id;
>         unsigned int base;
>         unsigned int npins;
> };
> 
> > For the static devices case then we can require gc->base must match the
> > pinctrl gpio base. For the device tree case we could do some matching of
> > device_nodes from the gpio_chip to the pinctrl definitions?
> 
> Can't do that since we can't look into struct gpio_chip intrinsics...
> 
> But we can register ranges at runtime, I'll just make the pin controller keep
> a list of GPIO ranges, simple.

OK, I do think it would be nice to use a gpio_chip based request, but I 
don't want to create too many obstacles for getting this code merged!

Jamie
