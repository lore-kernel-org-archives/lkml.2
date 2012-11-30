Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2K3LA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:00:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:38131 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab2K3LAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:00:25 -0500
Message-ID: <50B891B3.8070400@ti.com>
Date: Fri, 30 Nov 2012 12:00:03 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com> <20121126154600.765E03E1AFD@localhost> <50B5D161.6010200@ti.com> <20121129161024.EEA803E0912@localhost>
In-Reply-To: <20121129161024.EEA803E0912@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 05:10 PM, Grant Likely wrote:
>> 	/* Enable GPIO us of the PWMs */
>> 	gpio-controller = <1>;
> 
> This line should be simply (the property shouldn't have any data):
> 	gpio-controller;

Yes I know. It is like this already in my code. I just mixed up things while
hacking it together.

> 
>> 	#gpio-cells = <2>;
>> 	pwm,period_ns = <7812500>;
> 
> Nit: property names should use '-' instead of '_'.

Yes, true.

>> 	of_property_read_u32(chip->dev->of_node, "pwm,period_ns", &period_ns);
>> 	if (!period_ns) {
>> 		dev_err(chip->dev,
>> 			"period_ns is not specified for GPIO use\n");
>> 		return;
>> 	}
> 
> This property name seems ambiguous. What do you need to encode here? It
> looks like there is a specific PWM period used for the 'on' state. What
> about the 'off' state? Would different pwm outputs have different
> frequencies required for GPIO usage.
> 
> Actually, I'm a bit surprised here that a period value is needed at all.
> I would expect if a PWM is used as a GPIO then the driver would already
> know how to set it up that way.

Some PWM hw can select between different frequencies. They do that based on
the period_ns.
We can not just pass random non 0 number to them since they might fail with
the check for supported frequencies.

> Ugh, yeah this isn't the way to go. Don't register a new platform_device
> for the gpio functionality. It should be inline with the rest of the PWM
> setup and should trigger the registration of a gpio_chip directly.

We also need to take care of the non DT booted cases as well.
What we could do:
this driver with removed DT support for legacy booted systems.
GPO layer implementation within drivers/pwm/ to handle DT boot.

When we boot without DT we need to tell back to the machine driver about the
GPIO start of the gpio chip we just allocated.

Hrm, we could do this from the pwm-twl* drivers as well by adding an optional
callback and flag to the pwm core to register the gpio chip.
In this case we can move the whole whole gpio-pwm code under drivers/pwm, add
the 'struct gpio_chip' to struct pwm_chip{}
and register the gpio chip from within the pwm core.
We still have to provide the period_ns in same way to the PWM instance used as
GPIO, probably via platform data. Not sure about it right now.

-- 
Péter
