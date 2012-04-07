Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2DGNuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 09:50:12 -0400
Received: from antcom.de ([188.40.178.216]:55811 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab2DGNuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 09:50:11 -0400
Message-ID: <4F80460E.50605@antcom.de>
Date: Sat, 07 Apr 2012 15:50:06 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH v2] gpio: Device tree support for LPC32xx
References: <1333497518-25838-1-git-send-email-stigge@antcom.de> <20120407035327.9D7923E246E@localhost>
In-Reply-To: <20120407035327.9D7923E246E@localhost>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

thanks for your suggestions about LPC32xx GPIO DT.

Regarding the numbering:

On 07/04/12 05:53, Grant Likely wrote:
>> +Required properties:
>> +- compatible: "nxp,lpc32xx-gpio"
>> +- reg: Physical base address and length of the controller's registers.
>> +- #address-cells: Always 1, for indexing of the subnodes (GPIO groups of the
>> +  SoC)
>> +- #size-cells: Always 0
>> +
>> +Required properties of sub-nodes which describe the GPIO groups of LPC32xx:
>> +- gpio-controller: Marks the device node as a GPIO controller.
>> +- #gpio-cells: Should be two. The first cell is the pin number and the
>> +  second cell is used to specify optional parameters:
>> +  - bit 0 specifies polarity (0 for normal, 1 for inverted)
>> +- reg: Index of the GPIO group
> 
> If these are merely contiguous register banks of 32 gpio lines, then
> established convention is pretty much to only use one node and make
> the translate function decode bank and bit out of the gpio specifier.
> There isn't a whole lot of value it having all the sub nodes when
> there isn't anything significantly different between them.

Please consider how the groups are specified in
drivers/gpio/gpio-lpc32xx.c. They each have different numbers of lines
and GPIO / GPI / GPO functionality. So they also have different callback
sets, and we need to do separate gpiochip_add()s which leads to the
separate gpio-bank specifications in the dtsi file. Separate enabling of
those banks via OF are a nice by-product.

So I would like to keep it that way.

What do you think?

Thanks in advance,

Roland

>> +	gpio: gpio@40028000 {
>> +		compatible = "nxp,lpc32xx-gpio";
>> +		reg = <0x40028000 0x1000>;
>> +		/* create a private address space for enumeration */
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		gpio_p0: gpio-bank@0 {
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			reg = <0>;
>> +		};
>> +
>> +		gpio_p1: gpio-bank@1 {
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			reg = <1>;
>> +		};
>> +
>> +		gpio_p2: gpio-bank@2 {
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			reg = <2>;
>> +		};
>> +
>> +		gpio_p3: gpio-bank@3 {
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			reg = <3>;
>> +		};
>> +
>> +		gpi_p3: gpio-bank@4 {
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			reg = <4>;
>> +		};
>> +
>> +		gpo_p3: gpio-bank@5 {
>> +			gpio-controller;
>> +			#gpio-cells = <2>;
>> +			reg = <5>;
>> +		};
>> +	};
>> --- linux-2.6.orig/arch/arm/mach-lpc32xx/include/mach/gpio.h
>> +++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/gpio.h
>> @@ -1 +1,8 @@
>> -/* empty */
>> +#ifndef __MACH_GPIO_H
>> +#define __MACH_GPIO_H
>> +
>> +#include "gpio-lpc32xx.h"
>> +
>> +#define ARCH_NR_GPIOS (LPC32XX_GPO_P3_GRP + LPC32XX_GPO_P3_MAX)
>> +
>> +#endif /* __MACH_GPIO_H */
>> --- linux-2.6.orig/drivers/gpio/gpio-lpc32xx.c
>> +++ linux-2.6/drivers/gpio/gpio-lpc32xx.c
>> @@ -21,6 +21,9 @@
>>  #include <linux/io.h>
>>  #include <linux/errno.h>
>>  #include <linux/gpio.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/module.h>
>>  
>>  #include <mach/hardware.h>
>>  #include <mach/platform.h>
>> @@ -454,10 +457,55 @@ static struct lpc32xx_gpio_chip lpc32xx_
>>  	},
>>  };
>>  
>> +/* Empty now, can be removed later when mach-lpc32xx is finally switched over
>> + * to DT support
>> + */
>>  void __init lpc32xx_gpio_init(void)
>>  {
>> +}
>> +
>> +static int __devinit lpc32xx_gpio_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *node;
>>  	int i;
>>  
>> -	for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
>> -		gpiochip_add(&lpc32xx_gpiochip[i].chip);
>> +	if (pdev->dev.of_node) {
>> +		for_each_child_of_node(pdev->dev.of_node, node) {
>> +			if (of_device_is_available(node)) {
>> +				u32 index;
>> +				struct gpio_chip *chip;
>> +				if (of_property_read_u32(node,
>> +							 "reg", &index) <  0)
>> +					continue;
>> +				if (index >= ARRAY_SIZE(lpc32xx_gpiochip))
>> +					continue;
>> +				chip = &lpc32xx_gpiochip[index].chip;
>> +				chip->of_node = of_node_get(node);
>> +				gpiochip_add(chip);
>> +			}
>> +		}
>> +	} else {
>> +		for (i = 0; i < ARRAY_SIZE(lpc32xx_gpiochip); i++)
>> +			gpiochip_add(&lpc32xx_gpiochip[i].chip);
>> +	}
>> +
>> +	return 0;
>>  }
>> +
>> +#ifdef CONFIG_OF
>> +static struct of_device_id lpc32xx_gpio_of_match[] __devinitdata = {
>> +	{ .compatible = "nxp,lpc32xx-gpio", },
>> +	{ },
>> +};
>> +#endif
>> +
>> +static struct platform_driver lpc32xx_gpio_driver = {
>> +	.driver		= {
>> +		.name	= "lpc32xx-gpio",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = lpc32xx_gpio_of_match,
>> +	},
>> +	.probe		= lpc32xx_gpio_probe,
>> +};
>> +
>> +module_platform_driver(lpc32xx_gpio_driver);
> 

