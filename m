Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2EJXlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:41:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2EJXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:41:04 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND v8] gpio: Device tree support for LPC32xx
To: Roland Stigge <stigge@antcom.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Cc: Roland Stigge <stigge@antcom.de>
In-Reply-To: <1336679838-30738-1-git-send-email-stigge@antcom.de>
References: <1336679838-30738-1-git-send-email-stigge@antcom.de>
Date: Thu, 10 May 2012 17:41:00 -0600
Message-Id: <20120510234100.7F5463E04A6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 21:57:18 +0200, Roland Stigge <stigge@antcom.de> wrote:
> This patch adds device tree support for gpio-lpc32xx.c.
> 
> The various GPIO groups correspond to the different irregular GPIO banks of the
> LPC32xx hardware. Most importantly, there are the GPI(0-27), GPO(0-23) and
> GPIO(0-5) banks. Each bank must be registered individually since they are
> implemented with different functions. Registration is done via gpiochip_add()
> which requires an individual gpio bank subnode in the device tree for each
> call.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
> 
> Applies to v3.4-rc6
> 
> Changes since last version:
> * Updated patch description (above)
> 
> Thanks to Jean-Christophe PLAGNIOL-VILLARD, Grant Likely, Arnd Bergmann, Jon
> Smirl, Mark Brown for reviewing!
> 
> I can also provide a git branch to pull from. On top of which one should I
> provide it, if not mainline rc?
>  
>  Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt |   65 ++++++++++++++++
>  arch/arm/mach-lpc32xx/include/mach/gpio.h               |    9 +-
>  drivers/gpio/gpio-lpc32xx.c                             |   56 +++++++++++++
>  3 files changed, 127 insertions(+), 3 deletions(-)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/devicetree/bindings/gpio/gpio_lpc32xx.txt
> @@ -0,0 +1,65 @@
> +NXP LPC32xx SoC GPIO controller
> +
> +Required properties:
> +- compatible: must be "nxp,lpc3220-gpio"
> +- reg: Physical base address and length of the controller's registers.
> +- #address-cells: Always 1, for indexing of the subnodes (GPIO groups of the
> +  SoC)
> +- #size-cells: Always 0
> +
> +Required properties of sub-nodes which describe the GPIO groups of LPC32xx:
> +- gpio-controller: Marks the device node as a GPIO controller.
> +- #gpio-cells: Should be two. The first cell is the pin number and the
> +  second cell is used to specify optional parameters:
> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
> +- reg: Index of the GPIO group
> +
> +Optional properties of sub-nodes which describe the GPIO groups of LPC32xx:
> +- status: Set to "disabled" if you don't use the respective GPIO group
> +  of the LPC32xx SoC
> +
> +Example:
> +
> +	gpio: gpio@40028000 {
> +		compatible = "nxp,lpc3220-gpio";
> +		reg = <0x40028000 0x1000>;
> +		/* create a private address space for enumeration */
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		gpio_p0: gpio-bank@0 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <0>;
> +		};
> +
> +		gpio_p1: gpio-bank@1 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <1>;
> +		};
> +
> +		gpio_p2: gpio-bank@2 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <2>;
> +		};
> +
> +		gpio_p3: gpio-bank@3 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <3>;
> +		};
> +
> +		gpi_p3: gpio-bank@4 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <4>;
> +		};
> +
> +		gpo_p3: gpio-bank@5 {
> +			gpio-controller;
> +			#gpio-cells = <2>;
> +			reg = <5>;
> +		};
> +	};

Ugh.  I know this patch has been around for a while, but I can't help
it, this binding is just really ugly.  It results in a big chunk of
boilerplate for the gpio controller node just to enumerate the banks
which will *always* be there.

The real problem is that one of_xlate function cannot currently be
used for multiple banks, but there is no good reason why that should
be so.

How about the following instead (very rough, there should be a cleaner
way to update the gc pointer in of_xlate):

	gpio: gpio@40028000 {
		compatible = "nxp,lpc3220-gpio";
		reg = <0x40028000 0x1000>;
		gpio-controller;
		#gpio-cells = <3>; /* bank, pin, flags */
	}

Modify gpiolib-of to use:
of_xlate(struct gpio_chip **gc, const struct of_phandle_args *gpiospec, u32 *flags);
(so that the value of gc can be modified)

And then in the driver:

static int lpc32xx_of_xlate(struct gpio_chip **gc, const struct
                            of_phandle_args *gpiospec, u32 *flags)
{
	if (WARN_ON(gpiospec->args_count < 3))
		return -EINVAL;

	*gc = &lpc32xx_gpiochip[gpiospec->args[0]].chip;
	if (flags)
		*flags = gpiospec->args[2];
	return gpiospec->args[1];
}

Make all the gpiochips use the same of_xlate function and of_node
pointer so that it doesn't matter which one gets matched because the
xlate always completely resolves the gpio_chip.

Another way to do it would be to split the of_xlate functions out of
gpio_chip entirely and have a separate registry for gpio device_nodes
and their xlate functions.

g.

