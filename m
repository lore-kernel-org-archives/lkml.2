Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1EPJgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:36:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43773 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1EPJgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:36:11 -0400
Date: Mon, 16 May 2011 10:36:02 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jamie Iles <jamie@jamieiles.com>, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Martin Persson <martin.persson@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] drivers: create a pinmux subsystem v2
Message-ID: <20110516093602.GC17104@pulham.picochip.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
 <20110510235853.GM26703@pulham.picochip.com>
 <BANLkTim5wurV7aFSm4ae6+HBpGZO1z_=XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTim5wurV7aFSm4ae6+HBpGZO1z_=XA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:09:20AM +0200, Linus Walleij wrote:
> 2011/5/11 Jamie Iles <jamie@jamieiles.com>:
> > [...]
> >> +static struct foo_pmx_func myfuncs[] = {
> >> +     {
> >> +             .name = "spi0-0",
> >> +             .pins = spi0_0_pins,
> >> +             .num_pins = ARRAY_SIZE(spi0_1_pins),
> >> +     },
> >> +     {
> >> +             .name = "i2c0",
> >> +             .pins = i2c0_pins,
> >> +             .num_pins = ARRAY_SIZE(i2c0_pins),
> >> +     },
> >> +     {
> >> +             .name = "spi0-1",
> >> +             .pins = spi0_1_pins,
> >> +             .num_pins = ARRAY_SIZE(spi0_1_pins),
> >> +     },
> >> +};
> >
> > So I can see how this works well for these examples, but on our devices,
> > we have some interfaces for connecting to radios and these have a pair
> > of 8-bit RX and TX busses.  However, depending on what radio you
> > connect, you may not need all 8 bits of each and this is dependent on
> > the board.  What would be the best way to deal with that in this scheme
> > where say we only wanted 4 bits of each, saving the others for GPIO?
> > Would this need to be a function for each configuration?
> 
> Yes. Define a function containing the pins you need, then when that
> function is muxed in by pinmux_get() the remaining pins are still
> available for GPIO.
> 
> The framework only deals with functions as groups of pins and
> individual GPIO pins, defining the groups is currently up to each
> platform.

OK, from this and your other emails I think I understand this now.  So 
for this (using the current, non-device-tree method) case I guess we 
could leave the registration of these pins to the board code rather than 
the chip specific stuff.

> > [...]
> >> +/**
> >> + * pinmux_request_gpio() - request a single pin to be muxed in to be used
> >> + *   as a GPIO pin
> >> + * @pin: the pin to mux in as GPIO
> >> + * @gpio: the corresponding GPIO pin number
> >> + */
> >> +int pinmux_request_gpio(int pin, unsigned gpio)
> >> +{
> >> +     char gpiostr[16];
> >> +
> >> +     snprintf(gpiostr, 15, "gpio%d", gpio);
> >> +     return pin_request(pin, gpiostr, true);
> >> +}
> >> +EXPORT_SYMBOL_GPL(pinmux_request_gpio);
> >
> > Our devices have two different GPIO controllers, which can be muxed to
> > the same pad (they're slightly different - one is a bit slower but can
> > do sigma-delta output) and our pinmux driver would need to know what
> > GPIO controller it should route to the pad.  Could gpio_request_enable()
> > be passed the GPIO number or is there a better way to do this?
> 
> Hmmmm that was really new!
> 
> But like we have the more complex config function for pinmux groups:
> extern int pinmux_config(struct pinmux *pmx, u16 param, unsigned long *data);
> 
> I believe your case could be handled with a similar more complex
> per-pin config function like this:
> extern int pinmux_config_gpio(int pin, unsigned gpio, u16 param,
> unsigned long *data);
> 
> Would that work?

Yes, I think it probably would.  I'm travelling for a bit now so won't 
get chance to try this for a week or two but I'll try porting our 
platform over to this system; it would be great to have a standardized 
way of handling pin muxing.

Jamie
