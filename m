Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2LGHCH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:02:07 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9861 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2LGHCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:02:05 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Dec 2012 23:00:57 -0800
From: Alex Courbot <acourbot@nvidia.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
Date: Fri, 7 Dec 2012 16:02:02 +0900
Message-ID: <2562815.JQOcF2Dmj3@percival>
Organization: NVIDIA
User-Agent: KMail/4.9.3 (Linux/3.6.8-1-ARCH; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121207024947.GA25121@roeck-us.net>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com> <1354779918-4028-2-git-send-email-acourbot@nvidia.com> <20121207024947.GA25121@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Friday 07 December 2012 10:49:47 Guenter Roeck wrote:
> My own idea for a solution was to keep integer based handles, but replace
> gpio_desc[] with a hash table. But ultimately I don't really care how
> it is done.
> 
> Do you have a solution for gpiochip_find_base() in mind, and how to handle
> reservations ? I had thought about using bit maps, but maybe there is
> a better solution.

My plan so far is to use a sorted linked list of gpio_chips. Each chip 
contains its base address and size, so this will make it possible to find 
usable areas through a single parse. Current gpiochip_find_base() start from 
ARCH_NR_GPIOS and look backwards in the integer space to find a free range, a 
similar behavior can also be done if this is deemed better (GPIO numbers might 
become high, but since we want to hide them this should not matter).

The counterpart of the list is that fetching the descriptor corresponding to a 
GPIO number is going to be linear instead of constant, but (1) the number of 
gpio_chips on the system should never grow very high and (2) this is a good 
incentive to use the descriptor-based API instead. :) Existing code could 
easily be converted - once a GPIO is acquired, its number should be converted 
immediatly to a descriptor and the gpiod_* functions used from them on. We can 
probably write a sed or Coccinelle rule to do that through the whole kernel.

gpiochip_reserve() will require some more thinking using this model, but 
something like a dummy chip can probably be introduced in the list. It will 
need to be statically allocated however since memory allocation cannot be used 
there.

Actually the only user of gpiochip_reserve() seems to be Tosa, so I wonder if 
there would be no way to simply get rid of it?

> If/when you have some code to test, please let me know.

Sure!

> > +     mutex_lock(&sysfs_lock);
> > 
> >       /* can't export until sysfs is available ... */
> >       if (!gpio_class.p) {
> > 
> > @@ -713,13 +743,7 @@ int gpio_export(unsigned gpio, bool
> > direction_may_change)> 
> >               return -ENOENT;
> 
> mutex is not released here.

Oops.

> > -     chip = gpio_to_chip(gpio);
> > +     chip = desc->chip;
> > +     gpio = gpio_chip_offset(desc);
> 
> Might be better to use a separate variable named 'offset' when dealing with
> the offset, to avoid confusion and accidential bugs. You are doing it
> below, so you might as well do it everywhere. This would also simplify the
> code in a couple of places where gpio is first converted into an offset
> only to use "chip->base + gpio" later on.

Makes sense. Fixed, thanks.

> > -                                     __func__, gpio, err);
> > +                                     __func__, offset + chip->base, err);
> 
> I know I am nitpicking, but everywhere in the existing code it is
> "chip->base + offset/gpio".

Fixed.

> >       return chip->to_irq ? chip->to_irq(chip, gpio - chip->base) :
> >       -ENXIO;
> 
> s/gpio - chip->base/gpio_chip_offset(desc)/
> 
> then you don't need gpio at all.

Done, thanks.

> > -     chip = gpio_to_chip(gpio);
> > +     chip = desc->chip;
> > +     gpio = desc_to_gpio(desc);
> > 
> >       trace_gpio_value(gpio, 0, value);
> >       if (test_bit(FLAG_OPEN_DRAIN,  &gpio_desc[gpio].flags))
> 
> Use desc directly.
> 
> > -             _gpio_set_open_drain_value(gpio, chip, value);
> > +             _gpio_set_open_drain_value(desc, value);
> > 
> >       else if (test_bit(FLAG_OPEN_SOURCE,  &gpio_desc[gpio].flags))
> 
> Use desc directly.

Right.

Thanks,
Alex.

