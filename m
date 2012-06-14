Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab2FNXMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:12:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52017 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab2FNXMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:12:16 -0400
Message-ID: <4FDA6FCD.1020605@wwwdotorg.org>
Date: Thu, 14 Jun 2012 17:12:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree based
 pinctrl driver
References: <20120611135826.GB12766@atomide.com>
In-Reply-To: <20120611135826.GB12766@atomide.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 07:58 AM, Tony Lindgren wrote:
> Add one-register-per-pin type device tree based pinctrl driver.
> 
> Currently this driver only works on omap2+ series of processors,
> where there is either an 8 or 16-bit padconf register for each pin.
> Support for other similar pinmux controllers can be added.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt

I'm not sure why you'd need an explicit OMAP2 binding document or
compatible values if it just uses the plain pinctrl-single binding
unmodified.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt

> +- pinctrl-single,function-off : function off mode for disabled state

Might that not vary per register? Admittedly, Tegra isn't something that
could be covered by pinctrl-single, but the safe/off/non-conflicting mux
selection values for Tegra certainly are not all the same value.

> +- pinctrl-single,pinconf-mask : mask of allowed pinconf bits
> +
> +This driver uses the common pinctrl bindings as specified in the
> +pinctrl-bindings.txt document in this directory.
> +
> +The pinctrl register offsets and default values are specified as pairs

Why "default values" not just "values"; they can only be "default" if
you're talking about something that can be changed by some other
optional mechanism, which I don't believe is the case here.

> +using pinctrl-single,pins. For example, setting uart2_rx pin on omap2plus
> +can be done with:
> +
> +	pinctrl-single,pins = <0xdc 0x118>;
> +
> +Where 0xdc is the offset from the pinctrl ioremapped area for the

"ioremapped area" is a Linux-specific term. "register base address"
would be more generic.

> +uart2_rx register, and 0x118 contains the desired default value for
> +for the pin setting it to INPUT_PULLUP | MODE0. See the uart example and

Any mention of "uart2_rx" or "setting it to INPUT_PULLUP | MODE0" is
OMAP-specific; I'd say "0xdc" and just delete "setting it ...".

> +static board pins example below for more information.
> +
> +If you are concerned about the boot time, set up the static pins in
> +the bootloader, and only set up selected pins as device tree entries.

I'm not sure if it's really appropriate to state that kind of thing in a
DT binding document.

> +This driver assumes that there is only one register for each pin. If you
> +have some pins with more complicated configuration,

OK ...

> you can set up a separate
> +hardware specific driver for those pins.

But for that, it seems more correct to say that pinctrl-single simply
isn't an appropriate model for your HW.

> +Note that this driver tries to avoid understanding pin and function
> +names because of the extra bloat they would cause especially in the
> +omap2plus case. This driver just sets what is specified for the board

Again, I'd remove reference to any specific SoC from a generic binding.

> +in the .dts file. Further user space debugging tools can be developed
> +to decipher the pin and function names using debugfs.
> +
> +Example:
> +
> +/* SoC common file, such as omap4.dtsi */

But just to be clear, having an example for a specific SoC seems fine to
me; just not the generic descriptive text.

I don't see anywhere that describes how the function-mask and
pinconf-mask properties interact with the values in pinctrl-single,pins
property; are both masks OR'd together, then AND'd with the pins values,
then written to the registers? If so, why have 2 masks?

> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c

> +struct pcs_device {

> +	struct pinctrl_desc *desc;

Why not make that a struct rather than a pointer. That way, you wouldn't
have to dynamically allocate it separately. It's always needed.

> +static int __devinit pcs_probe(struct platform_device *pdev)

> +	ret = of_address_to_resource(pdev->dev.of_node, 0, &res);

It's much more common to use platform_get_resource(); doesn't calling
of_address_to_resource() duplicate all the work that the OF core already
did to set up the platform resource structures?

> +	ret = pcs_register(pcs);

Why not just inline that function here; it's not shared with anything.

> +static int __devexit pcs_remove(struct platform_device *pdev)

> +	platform_set_drvdata(pdev, NULL);

There's no need to explicitly clear that; nothing should be using that
value when the device is removed, so the value shouldn't matter.

> +static struct of_device_id pcs_of_match[] __devinitdata = {
> +	{ .compatible = DRIVER_NAME, },
> +	{ .compatible = "ti,omap2420-padconf", },
> +	{ .compatible = "ti,omap2430-padconf", },
> +	{ .compatible = "ti,omap3-padconf", },
> +	{ .compatible = "ti,omap4-padconf", },
> +	{ },
> +};

Shouldn't that contain just one entry for "pinctrl-single", and no others?

> +MODULE_LICENSE("GPL");

The license header implies that should be "GPL v2" not just "GPL" (which
means GPLv2+)

One final comment: A little while before Linaro Connect in San
Francisco, we were all having difficulty coming up with any kind of DT
binding for pinctrl. I had suggested the possibility of creating a
binding which just said "write value X to register Y, write value P to
register Q, ...". This was rejected at connect, because a raw list of
register writes didn't document anything or describe semantics - it was
too much of a binary blob. This driver seems to be doing almost the
exact same thing. In order to avoid that assertion, it'd need to truly
have individual representations of which pins exist, which pingroups
exist, which functions exist, and which functions can be selected onto
which pins/pingroups. That would be a radically different binding. I
wonder what's changed such that this kind of driver wasn't acceptable
then, but is now?
