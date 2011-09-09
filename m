Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1IIEDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 00:03:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab1IIEDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 00:03:22 -0400
Date: Thu, 8 Sep 2011 21:07:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep()
 when initializing.
Message-Id: <20110908210732.2a85c0f7.akpm@linux-foundation.org>
In-Reply-To: <CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
References: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
	<20110908183544.414f3add.akpm@linux-foundation.org>
	<CA+7tXiiHBsFYwSY5VRY=HQ40+TkBhHm0K5uT_=0-UW2Mx=r6vg@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011 20:54:55 -0700 Trent Piepho <xyzzy@speakeasy.org> wrote:

> On Thu, Sep 8, 2011 at 6:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 30 Aug 2011 16:39:52 -0700 David Daney <david.daney@cavium.com> wrote:
> >
> > > I get the following warning:
> > >
> > > ------------[ cut here ]------------
> > > WARNING: at drivers/gpio/gpiolib.c:1559  gpio_get_value+0x90/0x98()
> > > Modules linked in:
> > > Call Trace:
> > > [<ffffffff81440950>] dump_stack+0x8/0x34
> > > [<ffffffff81141478>] warn_slowpath_common+0x78/0xa0
> > > [<ffffffff812f0958>]  gpio_get_value+0x90/0x98
> > > [<ffffffff81434f04>] create_gpio_led+0xdc/0x194
> > > [<ffffffff8143524c>] gpio_led_probe+0x290/0x36c
> > > [<ffffffff8130e8b0>] driver_probe_device+0x78/0x1b0
> > > [<ffffffff8130eaa8>]  driver_attach+0xc0/0xc8
> > > [<ffffffff8130d7ac>] bus_for_each_dev+0x64/0xb0
> > > [<ffffffff8130e130>] bus_add_driver+0x1c8/0x2a8
> > > [<ffffffff8130f100>] driver_register+0x90/0x180
> > > [<ffffffff81100438>] do_one_initcall+0x38/0x160
> > >
> > > ---[ end trace ee38723fbefcd65c ]---
> > >
> > > My GPIOs are on an I2C port expander, so we must use the *_cansleep()
> > > variant of the GPIO functions.  This is was not being done in
> > > create_gpio_led().
> > >
> > > We can change gpio_get_value() to gpio_get_value_cansleep() because it
> > > is only called from the platform_driver probe function, which is a
> > > context where we can sleep.
> > >
> > > Only tested on my gpio_cansleep() system, but it seems safe for all
> > > systems.
> > >
> > > ...
> > >
> > > --- a/drivers/leds/leds-gpio.c
> > > +++ b/drivers/leds/leds-gpio.c
> > > @@ -121,7 +121,7 @@ static int  devinit create_gpio_led(const struct gpio_led *template,
> > >       }
> > >       led_dat->cdev.brightness_set = gpio_led_set;
> > >       if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
> > > -             state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
> > > +             state = !!gpio_get_value_cansleep(led_dat->gpio) ^ led_dat->active_low;
> > >       else
> > >               state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
> > >       led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
> >
> > gpio_get_value() is an architecture-specific function whereas
> > gpio_get_value_cansleep() is not.  Hence all architectures will now be
> > forced to use the same code.  Why is this OK?

(top-posting repaired.  Please don't do that)

> The non-cansleep version is only supposed to be different from
>  gpio_get_value() (which is virtually the same code) in that it can
> inline a fast gpio operation.  So calling cansleep vs the non-cansleep
> shouldn't result in any change that would break anything.  If it did
> it would be flaw in that architecture's version of gpio_get_value().
> It should just mean a call that could be inlined won't be.
> 
> I suppose one could ask if gpio_get_value_cansleep() needs to exist.

Here's the unicore gpio_get_value():

: static inline int gpio_get_value(unsigned gpio)
: {
: 	if (__builtin_constant_p(gpio) && (gpio <= GPIO_MAX))
: 		return readl(GPIO_GPLR) & GPIO_GPIO(gpio);
: 	else
: 		return __gpio_get_value(gpio);
: }

blackfin:

: static inline int gpio_get_value(unsigned int gpio)
: {
: 	if (gpio < MAX_BLACKFIN_GPIOS)
: 		return bfin_gpio_get_value(gpio);
: 	else
: 		return __gpio_get_value(gpio);
: }

m68k:

: static inline int gpio_get_value(unsigned gpio)
: {
: 	if (__builtin_constant_p(gpio) && gpio < MCFGPIO_PIN_MAX)
: 		return mcfgpio_read(__mcf_gpio_ppdr(gpio)) & mcfgpio_bit(gpio);
: 	else
: 		return __gpio_get_value(gpio);
: }
: 

etcetera.

And here's gpio_get_value_cansleep()

int gpio_get_value_cansleep(unsigned gpio)
{
	struct gpio_chip	*chip;
	int value;

	might_sleep_if(extra_checks);
	chip = gpio_to_chip(gpio);
	value = chip->get ? chip->get(chip, gpio - chip->base) : 0;
	trace_gpio_value(gpio, 1, value);
	return value;
}

They're very different.  Why is it OK to replace one with the other??

> > Asides:
> >
> > The duplication of code between  gpio_get_value() and
> > gpio_get_value_cansleep() is daft.
> >
> > The comment over gpio_get_value_cansleep() sucks mud rocks.

Preserving this...
