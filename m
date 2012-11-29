Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2K2QKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 11:10:31 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45132 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab2K2QK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 11:10:29 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
In-Reply-To: <50B5D161.6010200@ti.com>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com> <20121126154600.765E03E1AFD@localhost> <50B5D161.6010200@ti.com>
Date: Thu, 29 Nov 2012 16:10:24 +0000
Message-Id: <20121129161024.EEA803E0912@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2012 09:54:57 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi Grant, Lars, Thierry,
> 
> On 11/26/2012 04:46 PM, Grant Likely wrote:
> > You're effectively asking the pwm layer to behave like a gpio (which
> > is completely reasonable). Having a completely separate translation node
> > really doesn't make sense because it is entirely a software construct.
> > In fact, the way your using it is *entirely* to make the Linux driver
> > model instantiate the translation code. It has *nothing* to do with the
> > structure of the hardware. It makes complete sense that if a PWM is
> > going to be used as a GPIO, then the PWM node should conform to the GPIO
> > binding.
> 
> I understand your point around this. I might say I agree with it as well...
> I spent yesterday with prototyping and I'm not really convinced that it is a
> good approach from C code point of view. I got it working, yes.
> In essence this is what I have on top of the slightly modified gpio-pwm.c
> driver I have submitted:
> 
> DTS files:
> twl_pwm: pwm {
> 	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
> 	compatible = "ti,twl6030-pwm";
> 	#pwm-cells = <2>;
> 
> 	/* Enable GPIO us of the PWMs */
> 	gpio-controller = <1>;

This line should be simply (the property shouldn't have any data):
	gpio-controller;

> 	#gpio-cells = <2>;
> 	pwm,period_ns = <7812500>;

Nit: property names should use '-' instead of '_'.

> };
> 
> leds {
> 	compatible = "gpio-leds";
> 	backlight {
> 		label = "omap4::backlight";
> 		gpios = <&twl_pwm 1 0>; /* PWM1 of twl6030 */
> 	};
> 
> 	keypad {
> 		label = "omap4::keypad";
> 		gpios = <&twl_pwm 0 0>; /* PWM0 of twl6030 */
> 	};
> };
> 
> The bulk of the code in drivers/pwm/core.c to create the pwm-gpo device when
> it is requested going to look something like this. I have removed the error
> checks for now and I still don't have the code to clean up the allocated
> memory for the created device on error, or in case the module is unloaded. We
> should also prevent the pwm core from removal when the pwm-gpo driver is loaded.
> We need to create the platform device for gpo-pwm, create the pdata structure
> for it and fill it in. We also need to hand craft the pwm_lookup table so we
> can use pwm_get() to request the PWM. I have other minor changes around this
> to get things working when we booted with DT.
> So the function to do the heavy lifting is something like this:
> static void of_pwmchip_as_gpio(struct pwm_chip *chip)
> {
> 	struct platform_device *pdev;
> 	struct gpio_pwm *gpos;
> 	struct gpio_pwm_pdata *pdata;
> 	struct pwm_lookup *lookup;
> 	char gpodev_name[15];
> 	int i;
> 	u32 gpio_mode = 0;
> 	u32 period_ns = 0;
> 
> 	of_property_read_u32(chip->dev->of_node, "gpio-controller",
> 			     &gpio_mode);
> 	if (!gpio_mode)
> 		return;
> 
> 	of_property_read_u32(chip->dev->of_node, "pwm,period_ns", &period_ns);
> 	if (!period_ns) {
> 		dev_err(chip->dev,
> 			"period_ns is not specified for GPIO use\n");
> 		return;
> 	}

This property name seems ambiguous. What do you need to encode here? It
looks like there is a specific PWM period used for the 'on' state. What
about the 'off' state? Would different pwm outputs have different
frequencies required for GPIO usage.

Actually, I'm a bit surprised here that a period value is needed at all.
I would expect if a PWM is used as a GPIO then the driver would already
know how to set it up that way.

> 	lookup = devm_kzalloc(chip->dev, sizeof(*lookup) * chip->npwm,
> 			      GFP_KERNEL);
> 	pdata = devm_kzalloc(chip->dev, sizeof(*pdata), GFP_KERNEL);
> 	gpos = devm_kzalloc(chip->dev, sizeof(*gpos) * chip->npwm,
> 			    GFP_KERNEL);
> 
> 	pdata->gpos = gpos;
> 	pdata->num_gpos = chip->npwm;
> 	pdata->gpio_base = -1;
> 
> 	pdev = platform_device_alloc("pwm-gpo", chip->base);
> 	pdev->dev.parent = chip->dev;
> 
> 	sprintf(gpodev_name, "pwm-gpo.%d", chip->base);
> 	for (i = 0; i < chip->npwm; i++) {
> 		struct gpio_pwm *gpo = &gpos[i];
> 		struct pwm_lookup *pl = &lookup[i];
> 		char con_id[15];
> 
> 		sprintf(con_id, "pwm-gpo.%d", chip->base + i);
> 
> 		/* prepare GPO information */
> 		gpo->pwm_period_ns = period_ns;
> 		gpo->name = kmemdup(con_id, sizeof(con_id), GFP_KERNEL);;
> 
> 		/* prepare pwm lookup table */
> 		pl->provider = dev_name(chip->dev);
> 		pl->index = i;
> 		pl->dev_id = kmemdup(gpodev_name, sizeof(gpodev_name),
> 				     GFP_KERNEL);
> 		pl->con_id = kmemdup(con_id, sizeof(con_id), GFP_KERNEL);
> 	}
> 
> 	platform_device_add_data(pdev, pdata, sizeof(*pdata));
> 	pwm_add_table(lookup, chip->npwm);
> 	platform_device_add(pdev);

Ugh, yeah this isn't the way to go. Don't register a new platform_device
for the gpio functionality. It should be inline with the rest of the PWM
setup and should trigger the registration of a gpio_chip directly.

g.
