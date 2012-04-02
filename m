Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2DBT3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:29:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55937 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2DBT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:29:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] gpio: Device tree support for LPC32xx
Date: Mon, 2 Apr 2012 19:28:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com
References: <1333376464-25712-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1333376464-25712-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204021929.00107.arnd@arndb.de>
X-Provags-ID: V02:K0:+w4UklHpnJJNA2fDdzhMlYZGPRCmtB5VrgjD0zpBUux
 qzAW/PVBbAr5PiAvXt1Z2Pl6T9BuEgq4Sm9SrFQWmMqPcgOUYu
 PaJytcGGT1xtB3Q3o0IEUM1wQP5h47S27L9pDif3CbiQhjFrXs
 W1EFbsTzBf4y3Q2h+1DmPfgnQGfX0zQcjixEdf7S0Yt8C1kO4O
 soNQWXfAm41U1kNigBi9jZGHJEpx7lIbPmqEtuyqi8fuYJaGHa
 MMk01mdzq7lKIeylO/hECEqqoDRO+ep/Ej1lqOF5tJsdT2G5Iv
 erwwpCqFYu41r1w50bXWhN3U3ufFVvHenUAElJxjN/qAXEHdJx
 Z3mUA5jyY/dHqmL+jZr0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2012, Roland Stigge wrote:

> 
> I'm adding device tree support to the LPC32xx platform. Currently struggling
> with GPIO, see patch below.
> 
> Generally, it works - GPIOs registered successfully like before:
> 
> ================================================================
> gpiochip_add: registered GPIOs 0 to 7 on device: gpio_p0
> gpiochip_add: registered GPIOs 8 to 31 on device: gpio_p1
> gpiochip_add: registered GPIOs 32 to 44 on device: gpio_p2
> gpiochip_add: registered GPIOs 45 to 50 on device: gpio_p3
> gpiochip_add: registered GPIOs 51 to 78 on device: gpi_p3
> gpiochip_add: registered GPIOs 79 to 102 on device: gpo_p3
> ================================================================
> 
> But in connection with gpio-leds which I'm using like this:
> 
>         leds {
>                 compatible = "gpio-leds";
>                 led0 {
>                         gpios = <&gpio 0x50 1>; /* GPIO 80, active low */
>                         linux,default-trigger = "heartbeat";
>                         default-state = "keep";
>                 };
>         };
> 
> I get the following error:

The gpio number must be local to the gpio_chip.
> 
> I suspect the strategy to do several gpiochip_add()s, ported from the non-DT
> platform code, doesn't work well with the of_* registration - e.g.,
> gpiochip_find() compares the static structs I'm registering with gpiochip_add()
> with another (of_node's) one not in the registeded list. Should the various
> GPIO areas be moved from lpc32xx_gpiochip[] to a dts file? So many callbacks
> and memory references in there...

Well, in the end, you need to do exactly one gpiochip_add() per of_node,
and you can get there either by increasing the number of of_nodes, or
by registering only one gpio_chip.

Given the design of your hardware, I would recommend doing the first.
If you don't want to fully describe all the differences between the
chips using DT properties, you can keep the array you have now, and
use sub-nodes that do not get turned into a platform_device, like

/ {
	gpio-controller@40028000 {
		compatible = "nxp,lpc3250-gpio", "nxp,lpc32xx-gpio";
		/* create a private address space for enumeration */
		#address-cells = 1;
		#size-cells = 0;

		reg = <0x40028000 0x1000>;

		gpio-bank@0 {
			gpio-controller;
			#gpio-cells = <2>;
			gpio-lines = <8>;
			reg = <0>;
			status = "okay";
		};
		
		gpio-bank@1 {
			gpio-controller;
			#gpio-cells = <2>;
			gpio-lines = <24>;
			reg = <1>;
			status = "okay";
		};
		
		gpio-bank@2 {
			gpio-controller;
			#gpio-cells = <2>;
			gpio-lines = <13>;
			reg = <2>;
			status = "okay";
		};
		
		gpio-bank@3 {
			gpio-controller;
			#gpio-cells = <2>;
			gpio-lines = <6>;
			reg = <3>;
			status = "okay";
		};
		
		gpo-bank@4 {
			gpio-controller;
			#gpio-cells = <2>;
			gpio-lines = <28>;
			reg = <4>;
			status = "okay";
		};
		
		gpi-bank@5 {
			gpio-controller;
			#gpio-cells = <2>;
			gpio-lines = <24>;
			reg = <5>;
			status = "okay";
		};
	};
};

> -void __init lpc32xx_gpio_init(void)
> +static int __devinit lpc32xx_gpio_probe(struct platform_device *pdev)
>  {
>  	int i;
>  
> -	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
> +	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++) {
> +#ifdef CONFIG_OF_GPIO
> +		lpc32xx_gpiochip[i].chip.of_node = pdev->dev.of_node;
> +#endif
>  		gpiochip_add(&lpc32xx_gpiochip[i].chip);
> +	}
> +
> +	return 0;

Then this can become

	for_each_child_of_node(pdev->dev.of_node, node) {
		if (of_device_is_available(node)) {
			u32 index;
			struct gpio_chip *chip;
			if (of_property_read_u32(node, reg, &index) < 0)
				continue; 
			if (index >= ARRAY_SIZE(lpc32xx_gpiochip)
				continue;
			chip = &lpc32xx_gpiochip[index].chip;
			chip->of_node = of_node_get(node);
			gpiochip_add(chip);
		}
	}

	Arnd
