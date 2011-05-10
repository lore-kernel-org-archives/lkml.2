Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1EJX67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 19:58:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40441 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1EJX66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 19:58:58 -0400
Date: Wed, 11 May 2011 00:58:53 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        Joe Perches <joe@perches.com>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] drivers: create a pinmux subsystem v2
Message-ID: <20110510235853.GM26703@pulham.picochip.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I haven't had chance to try this on my platform yet, but I have a couple 
of questions on how to deal with a few oddities that we have.

Thanks,

Jamie

On Wed, May 11, 2011 at 01:39:43AM +0200, Linus Walleij wrote:
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.
> 
> This is being done to depopulate the arch/arm/* directory of such
> custom drivers and try to abstract the infrastructure they all
> need. See the Documentation/pinmux.txt file that is part of this
> patch for more details.
> 
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Joe Perches <joe@perches.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
[...]
> +static struct foo_pmx_func myfuncs[] = {
> +	{
> +		.name = "spi0-0",
> +		.pins = spi0_0_pins,
> +		.num_pins = ARRAY_SIZE(spi0_1_pins),
> +	},
> +	{
> +		.name = "i2c0",
> +		.pins = i2c0_pins,
> +		.num_pins = ARRAY_SIZE(i2c0_pins),
> +	},
> +	{
> +		.name = "spi0-1",
> +		.pins = spi0_1_pins,
> +		.num_pins = ARRAY_SIZE(spi0_1_pins),
> +	},
> +};

So I can see how this works well for these examples, but on our devices, 
we have some interfaces for connecting to radios and these have a pair 
of 8-bit RX and TX busses.  However, depending on what radio you 
connect, you may not need all 8 bits of each and this is dependent on 
the board.  What would be the best way to deal with that in this scheme 
where say we only wanted 4 bits of each, saving the others for GPIO?  
Would this need to be a function for each configuration?

[...]
> +/**
> + * pinmux_request_gpio() - request a single pin to be muxed in to be used
> + *	as a GPIO pin
> + * @pin: the pin to mux in as GPIO
> + * @gpio: the corresponding GPIO pin number
> + */
> +int pinmux_request_gpio(int pin, unsigned gpio)
> +{
> +	char gpiostr[16];
> +
> +	snprintf(gpiostr, 15, "gpio%d", gpio);
> +	return pin_request(pin, gpiostr, true);
> +}
> +EXPORT_SYMBOL_GPL(pinmux_request_gpio);

Our devices have two different GPIO controllers, which can be muxed to 
the same pad (they're slightly different - one is a bit slower but can 
do sigma-delta output) and our pinmux driver would need to know what 
GPIO controller it should route to the pad.  Could gpio_request_enable() 
be passed the GPIO number or is there a better way to do this?

Jamie
