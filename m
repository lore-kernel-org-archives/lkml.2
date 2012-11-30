Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588Ab2K3KUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:20:47 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59348 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2K3KUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:20:43 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
In-Reply-To: <20121130064752.GB26474@avionic-0098.adnet.avionic-design.de>
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com> <20121126154600.765E03E1AFD@localhost> <50B5D161.6010200@ti.com> <20121129161024.EEA803E0912@localhost> <20121130064752.GB26474@avionic-0098.adnet.avionic-design.de>
Date: Fri, 30 Nov 2012 10:20:38 +0000
Message-Id: <20121130102039.0267E3E129E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 07:47:52 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> On Thu, Nov 29, 2012 at 04:10:24PM +0000, Grant Likely wrote:
> > On Wed, 28 Nov 2012 09:54:57 +0100, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> > > Hi Grant, Lars, Thierry,
> > > 
> > > On 11/26/2012 04:46 PM, Grant Likely wrote:
> > > > You're effectively asking the pwm layer to behave like a gpio (which
> > > > is completely reasonable). Having a completely separate translation node
> > > > really doesn't make sense because it is entirely a software construct.
> > > > In fact, the way your using it is *entirely* to make the Linux driver
> > > > model instantiate the translation code. It has *nothing* to do with the
> > > > structure of the hardware. It makes complete sense that if a PWM is
> > > > going to be used as a GPIO, then the PWM node should conform to the GPIO
> > > > binding.
> > > 
> > > I understand your point around this. I might say I agree with it as well...
> > > I spent yesterday with prototyping and I'm not really convinced that it is a
> > > good approach from C code point of view. I got it working, yes.
> > > In essence this is what I have on top of the slightly modified gpio-pwm.c
> > > driver I have submitted:
> > > 
> > > DTS files:
> > > twl_pwm: pwm {
> > > 	/* provides two PWMs (id 0, 1 for PWM1 and PWM2) */
> > > 	compatible = "ti,twl6030-pwm";
> > > 	#pwm-cells = <2>;
> > > 
> > > 	/* Enable GPIO us of the PWMs */
> > > 	gpio-controller = <1>;
> > 
> > This line should be simply (the property shouldn't have any data):
> > 	gpio-controller;
> > 
> > > 	#gpio-cells = <2>;
> > > 	pwm,period_ns = <7812500>;
> > 
> > Nit: property names should use '-' instead of '_'.
> > 
> > > };
> > > 
> > > leds {
> > > 	compatible = "gpio-leds";
> > > 	backlight {
> > > 		label = "omap4::backlight";
> > > 		gpios = <&twl_pwm 1 0>; /* PWM1 of twl6030 */
> > > 	};
> > > 
> > > 	keypad {
> > > 		label = "omap4::keypad";
> > > 		gpios = <&twl_pwm 0 0>; /* PWM0 of twl6030 */
> > > 	};
> > > };
> > > 
> > > The bulk of the code in drivers/pwm/core.c to create the pwm-gpo device when
> > > it is requested going to look something like this. I have removed the error
> > > checks for now and I still don't have the code to clean up the allocated
> > > memory for the created device on error, or in case the module is unloaded. We
> > > should also prevent the pwm core from removal when the pwm-gpo driver is loaded.
> > > We need to create the platform device for gpo-pwm, create the pdata structure
> > > for it and fill it in. We also need to hand craft the pwm_lookup table so we
> > > can use pwm_get() to request the PWM. I have other minor changes around this
> > > to get things working when we booted with DT.
> > > So the function to do the heavy lifting is something like this:
> > > static void of_pwmchip_as_gpio(struct pwm_chip *chip)
> > > {
> > > 	struct platform_device *pdev;
> > > 	struct gpio_pwm *gpos;
> > > 	struct gpio_pwm_pdata *pdata;
> > > 	struct pwm_lookup *lookup;
> > > 	char gpodev_name[15];
> > > 	int i;
> > > 	u32 gpio_mode = 0;
> > > 	u32 period_ns = 0;
> > > 
> > > 	of_property_read_u32(chip->dev->of_node, "gpio-controller",
> > > 			     &gpio_mode);
> > > 	if (!gpio_mode)
> > > 		return;
> > > 
> > > 	of_property_read_u32(chip->dev->of_node, "pwm,period_ns", &period_ns);
> > > 	if (!period_ns) {
> > > 		dev_err(chip->dev,
> > > 			"period_ns is not specified for GPIO use\n");
> > > 		return;
> > > 	}
> > 
> > This property name seems ambiguous. What do you need to encode here? It
> > looks like there is a specific PWM period used for the 'on' state. What
> > about the 'off' state? Would different pwm outputs have different
> > frequencies required for GPIO usage.
> > 
> > Actually, I'm a bit surprised here that a period value is needed at all.
> > I would expect if a PWM is used as a GPIO then the driver would already
> > know how to set it up that way.
> 
> Just to make sure we're talking about the same thing here: if a PWM is
> used as GPIO the assumption is that it would be set to 0% duty-cycle
> when the GPIO value is set to 0 and 100% duty-cycle when set to the 1.
> The period will still need to be set here, otherwise how would the PWM
> core know what the hardware even supports?

Umm, I agree with you on duty cycle, but that's got nothing to do with
period. 100% duty cycle looks exactly the same whether the period is
10ns or 100s.

> Unless you're proposing to not include that in the PWM core but rather
> in individual drivers. Then I suppose the driver could choose some
> sensible default.

Mostly I'm asking questions because I'm not familiar with the subsystem.
If the property is needed then I have no objections, but at the moment
it doesn't make any sense to me.

> One other problem is that some PWM devices cannot be setup to achieve a
> 0% or 100% duty-cycle but instead will toggle for at least one period.
> This would be another argument in favour of moving the functionality to
> the individual drivers, perhaps with some functionality provided by the
> core to do the gpio_chip registration (a period could be passed to that
> function at registration time), which will likely be the same for all
> hardware that can and wants to support this feature.

It is a bit of an oddball case where if the hardware engineer wires up a
PWM to use as a GPIO, then he better be sure that it is actually fit for
the purpose. That doesn't prevent the PWM core having some
gpio-emulation helper functionality, but do need to be careful about it.

g.
