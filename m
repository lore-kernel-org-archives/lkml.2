Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1IIDy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 23:54:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38644 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1IIDy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 23:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110908183544.414f3add.akpm@linux-foundation.org>
References: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
	<20110908183544.414f3add.akpm@linux-foundation.org>
Date: Thu, 8 Sep 2011 20:54:55 -0700
X-Google-Sender-Auth: SvRf1jUtuc1_-xPsLPnzT_lH7sQ
Message-ID: <CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
Subject: Re: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep() when initializing.
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-cansleep version is only supposed to be different from
__gpio_get_value() (which is virtually the same code) in that it can
inline a fast gpio operation.  So calling cansleep vs the non-cansleep
shouldn't result in any change that would break anything.  If it did
it would be flaw in that architecture's version of gpio_get_value().
It should just mean a call that could be inlined won't be.

I suppose one could ask if gpio_get_value_cansleep() needs to exist.

On Thu, Sep 8, 2011 at 6:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 30 Aug 2011 16:39:52 -0700 David Daney <david.daney@cavium.com> wrote:
>
> > I get the following warning:
> >
> > ------------[ cut here ]------------
> > WARNING: at drivers/gpio/gpiolib.c:1559 __gpio_get_value+0x90/0x98()
> > Modules linked in:
> > Call Trace:
> > [<ffffffff81440950>] dump_stack+0x8/0x34
> > [<ffffffff81141478>] warn_slowpath_common+0x78/0xa0
> > [<ffffffff812f0958>] __gpio_get_value+0x90/0x98
> > [<ffffffff81434f04>] create_gpio_led+0xdc/0x194
> > [<ffffffff8143524c>] gpio_led_probe+0x290/0x36c
> > [<ffffffff8130e8b0>] driver_probe_device+0x78/0x1b0
> > [<ffffffff8130eaa8>] __driver_attach+0xc0/0xc8
> > [<ffffffff8130d7ac>] bus_for_each_dev+0x64/0xb0
> > [<ffffffff8130e130>] bus_add_driver+0x1c8/0x2a8
> > [<ffffffff8130f100>] driver_register+0x90/0x180
> > [<ffffffff81100438>] do_one_initcall+0x38/0x160
> >
> > ---[ end trace ee38723fbefcd65c ]---
> >
> > My GPIOs are on an I2C port expander, so we must use the *_cansleep()
> > variant of the GPIO functions.  This is was not being done in
> > create_gpio_led().
> >
> > We can change gpio_get_value() to gpio_get_value_cansleep() because it
> > is only called from the platform_driver probe function, which is a
> > context where we can sleep.
> >
> > Only tested on my gpio_cansleep() system, but it seems safe for all
> > systems.
> >
> > ...
> >
> > --- a/drivers/leds/leds-gpio.c
> > +++ b/drivers/leds/leds-gpio.c
> > @@ -121,7 +121,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
> >       }
> >       led_dat->cdev.brightness_set = gpio_led_set;
> >       if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
> > -             state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
> > +             state = !!gpio_get_value_cansleep(led_dat->gpio) ^ led_dat->active_low;
> >       else
> >               state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
> >       led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
>
> gpio_get_value() is an architecture-specific function whereas
> gpio_get_value_cansleep() is not.  Hence all architectures will now be
> forced to use the same code.  Why is this OK?
>
> Asides:
>
> The duplication of code between __gpio_get_value() and
> gpio_get_value_cansleep() is daft.
>
> The comment over gpio_get_value_cansleep() sucks mud rocks.
>
