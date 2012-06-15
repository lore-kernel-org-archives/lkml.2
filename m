Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab2FOJtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 05:49:46 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50450 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2FOJto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 05:49:44 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19ybhOlZLBVrzsm4vebyg5W
Date: Fri, 15 Jun 2012 02:49:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] pinctrl: Add one-register-per-pin type device tree
 based pinctrl driver
Message-ID: <20120615094938.GQ12766@atomide.com>
References: <20120611135826.GB12766@atomide.com>
 <4FDA6FCD.1020605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDA6FCD.1020605@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Stephen Warren <swarren@wwwdotorg.org> [120614 16:16]:
> On 06/11/2012 07:58 AM, Tony Lindgren wrote:
> > Add one-register-per-pin type device tree based pinctrl driver.
> > 
> > Currently this driver only works on omap2+ series of processors,
> > where there is either an 8 or 16-bit padconf register for each pin.
> > Support for other similar pinmux controllers can be added.
> 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-omap2plus.txt
> 
> I'm not sure why you'd need an explicit OMAP2 binding document or
> compatible values if it just uses the plain pinctrl-single binding
> unmodified.

Hmm I thought that's what you wanted with your earlier comments at [1]:

* Stephen Warren <swarren@wwwdotorg.org> [120504 12:27]:
>
> If this is truly intended to be generic, I would not document any of the
> ti compatible values here. Instead, I'd create a binding document for
> the TI controllers that basically just says "this uses the bindings in
> pinctrl-simple.txt, with the following additions", and list the
> compatible values as an addition.

Care to clarify a bit what you had in mind there?
 
> > diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
> 
> > +- pinctrl-single,function-off : function off mode for disabled state
> 
> Might that not vary per register? Admittedly, Tegra isn't something that
> could be covered by pinctrl-single, but the safe/off/non-conflicting mux
> selection values for Tegra certainly are not all the same value.

Yeah it might be best to remove function-off, and just rely on alternative
pin modes for setting this up in a register specific way. For example,
omaps don't have clearly defined off mode, there is safe mode for most
registers, but not all of them.
 
> > +- pinctrl-single,pinconf-mask : mask of allowed pinconf bits
> > +
> > +This driver uses the common pinctrl bindings as specified in the
> > +pinctrl-bindings.txt document in this directory.
> > +
> > +The pinctrl register offsets and default values are specified as pairs
> 
> Why "default values" not just "values"; they can only be "default" if
> you're talking about something that can be changed by some other
> optional mechanism, which I don't believe is the case here.

Sure let's do that.
 
> > +using pinctrl-single,pins. For example, setting uart2_rx pin on omap2plus
> > +can be done with:
> > +
> > +	pinctrl-single,pins = <0xdc 0x118>;
> > +
> > +Where 0xdc is the offset from the pinctrl ioremapped area for the
> 
> "ioremapped area" is a Linux-specific term. "register base address"
> would be more generic.

OK
 
> > +uart2_rx register, and 0x118 contains the desired default value for
> > +for the pin setting it to INPUT_PULLUP | MODE0. See the uart example and
> 
> Any mention of "uart2_rx" or "setting it to INPUT_PULLUP | MODE0" is
> OMAP-specific; I'd say "0xdc" and just delete "setting it ...".

Alright, I'll make it anonymous.
 
> > +static board pins example below for more information.
> > +
> > +If you are concerned about the boot time, set up the static pins in
> > +the bootloader, and only set up selected pins as device tree entries.
> 
> I'm not sure if it's really appropriate to state that kind of thing in a
> DT binding document.

Sure, I can move that to comments in the driver.
 
> > +This driver assumes that there is only one register for each pin. If you
> > +have some pins with more complicated configuration,
> 
> OK ...
> 
> > you can set up a separate
> > +hardware specific driver for those pins.
> 
> But for that, it seems more correct to say that pinctrl-single simply
> isn't an appropriate model for your HW.

It is possible to create a wrapper pinctrl driver that requests pins from
pinctrl-single and adds functionality to handle the extra registers.
Let's say you have 200 similar registers, and only few have additional
configuration registers. You may still want to handle the basic configuration
using this driver. But I can move that to the driver comments too.

> > +Note that this driver tries to avoid understanding pin and function
> > +names because of the extra bloat they would cause especially in the
> > +omap2plus case. This driver just sets what is specified for the board
> 
> Again, I'd remove reference to any specific SoC from a generic binding.

OK
 
> > +in the .dts file. Further user space debugging tools can be developed
> > +to decipher the pin and function names using debugfs.
> > +
> > +Example:
> > +
> > +/* SoC common file, such as omap4.dtsi */
> 
> But just to be clear, having an example for a specific SoC seems fine to
> me; just not the generic descriptive text.

Sure.
 
> I don't see anywhere that describes how the function-mask and
> pinconf-mask properties interact with the values in pinctrl-single,pins
> property; are both masks OR'd together, then AND'd with the pins values,
> then written to the registers? If so, why have 2 masks?

I'll add some more documentation. The reason why I set two masks is
if the driver wants to modify settings with pin_config_set. I'll do some
testing on that, let's see if it's actually needed.
 
> > diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> 
> > +struct pcs_device {
> 
> > +	struct pinctrl_desc *desc;
> 
> Why not make that a struct rather than a pointer. That way, you wouldn't
> have to dynamically allocate it separately. It's always needed.

Good point, will check.
 
> > +static int __devinit pcs_probe(struct platform_device *pdev)
> 
> > +	ret = of_address_to_resource(pdev->dev.of_node, 0, &res);
> 
> It's much more common to use platform_get_resource(); doesn't calling
> of_address_to_resource() duplicate all the work that the OF core already
> did to set up the platform resource structures?

OK sounds right.
 
> > +	ret = pcs_register(pcs);
> 
> Why not just inline that function here; it's not shared with anything.

Yeah good point, pcs_register is pretty minimal now, no need to have
it as a separate function any longer.
 
> > +static int __devexit pcs_remove(struct platform_device *pdev)
> 
> > +	platform_set_drvdata(pdev, NULL);
> 
> There's no need to explicitly clear that; nothing should be using that
> value when the device is removed, so the value shouldn't matter.

Will check if that's needed. There are certainly quite a few calls like
that in the kernel.
 
> > +static struct of_device_id pcs_of_match[] __devinitdata = {
> > +	{ .compatible = DRIVER_NAME, },
> > +	{ .compatible = "ti,omap2420-padconf", },
> > +	{ .compatible = "ti,omap2430-padconf", },
> > +	{ .compatible = "ti,omap3-padconf", },
> > +	{ .compatible = "ti,omap4-padconf", },
> > +	{ },
> > +};
> 
> Shouldn't that contain just one entry for "pinctrl-single", and no others?

It's best to describe the hardware in case we need to set up some hardware
specific things in the driver.
 
> > +MODULE_LICENSE("GPL");
> 
> The license header implies that should be "GPL v2" not just "GPL" (which
> means GPLv2+)

Sure, that's what it says at top of the file.
 
> One final comment: A little while before Linaro Connect in San
> Francisco, we were all having difficulty coming up with any kind of DT
> binding for pinctrl. I had suggested the possibility of creating a
> binding which just said "write value X to register Y, write value P to
> register Q, ...". This was rejected at connect, because a raw list of
> register writes didn't document anything or describe semantics - it was
> too much of a binary blob. This driver seems to be doing almost the
> exact same thing. In order to avoid that assertion, it'd need to truly
> have individual representations of which pins exist, which pingroups
> exist, which functions exist, and which functions can be selected onto
> which pins/pingroups. That would be a radically different binding. I
> wonder what's changed such that this kind of driver wasn't acceptable
> then, but is now?

Well that's why I had two bindings earlier: The current binding for the
bulk pins that's faster to parse, and a more verbose binding for drivers that
allows naming the functions.

In your previous comments at [1] you seemed to prefer this current binding
based on the "Why not only allow (1)?" comment. Maybe you had something else
in mind, care to clarify that a bit too?

Using either binding is fine with me, this is just faster to parse.

For your question regarding pins, pingroups and functions, the logic in
this driver is following:

1. The pin names are package specific, and not needed in the kernel except
   for debugging. And that can be done with user space tools using debugfs.

2. The pingroup names can be the names of devices requesting the pins in
   this case. Trying to define any other pingroup names would be artificial
   and would have too many permutations at least in the omap case to list.

3. The pin functions and pinconf values become readable if we ever get
   the .dts preprocessing patches merged. If we want to further define
   function names, then using binding 2 at [1] would need to be used. But
   again, kernel does not need to know the function names, those too can
   be debugged with user space tools via debugfs.

Regards,

Tony

[1] http://article.gmane.org/gmane.linux.kernel/1291838
