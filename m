Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0IAH3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:29:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40672 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab0IAH3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ucV5lJlCP1z8UOnsRmItSpcw6GiEk60NFvcXADgLaFFU2kdV1zYOXS8IPsMB5/nXzT
         M7uD+6fx1YXdD90qLY15Kv52Uiphr6Ad0YjCxIawAaSQXkCz4B8HAX6SK81QhDpWkOLe
         jHCdymXY9mRrmQFNXD5XTfMmImoEBINvRCG44=
From: Florian Fainelli <f.fainelli@gmail.com>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v3] GPIO: add support for 74x164 serial-in/parallel-out 8-bit shift register
Date: Wed, 1 Sep 2010 09:25:50 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-server; KDE/4.4.2; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, Juhos Gabor <juhosg@openwrt.org>,
        dbrownell@users.sourceforge.net
References: <887649.75421.qm@web180316.mail.gq1.yahoo.com> <201008311017.30445.florian@openwrt.org> <201008311244.07567.florian@openwrt.org>
In-Reply-To: <201008311244.07567.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009010925.50906.f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 August 2010 12:44:07 Florian Fainelli wrote:
> From: Miguel Gaio <miguel.gaio@efixo.com>
> 
> This patch adds support for generic 74x164 serial-in/parallel-out 8-bits
> shift register. This driver can be used as a GPIO output expander.
> 
> Signed-off-by: Miguel Gaio <miguel.gaio@efixo.com>
> Signed-off-by: Juhos Gabor <juhosg@openwrt.org>
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> Changes since v1:
> - renamed nxp_ to gen_ since this driver is generic to all 74HC164 chips
> - added comment on this driver not handling the 74HC164 daisy-chaining
> - renamed misused GPIO expanders to Shift registers
> 
> Changes since v2:
> - rename 74hc164 to 74x164

Miguel sent me a 4th version supporting daisy-chaining, I will resubmit it 
right away.

> 
> diff --git a/drivers/gpio/74x164.c b/drivers/gpio/74x164.c
> new file mode 100644
> index 0000000..9adeed4
> --- /dev/null
> +++ b/drivers/gpio/74x164.c
> @@ -0,0 +1,228 @@
> +/*
> + *  74Hx164 - Generic serial-in/parallel-out 8-bits shift register GPIO
> driver + *
> + *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
> + *  Copyright (C) 2010 Miguel Gaio <miguel.gaio@efixo.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + *  Note: this driver does not support the way 74x164 chips can be
> + *  daisy-chained.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/bitops.h>
> +#include <linux/platform_device.h>
> +#include <linux/74x164.h>
> +
> +#define GEN_74X164_NUM_GPIOS	8
> +
> +struct gen_74x164_chip {
> +	struct device		*parent;
> +	struct gpio_chip	gpio_chip;
> +	struct mutex		lock;
> +	long			mask;
> +};
> +
> +static void gen_74x164_set_value(struct gpio_chip *, unsigned, int);
> +
> +static struct gen_74x164_chip *gpio_to_chip(struct gpio_chip *gc)
> +{
> +	return container_of(gc, struct gen_74x164_chip, gpio_chip);
> +}
> +
> +static int gen_74x164_direction_input(struct gpio_chip *gc, unsigned
> offset) +{
> +	WARN_ON(1);
> +	return -EINVAL;
> +}
> +
> +static int gen_74x164_direction_output(struct gpio_chip *gc,
> +					unsigned offset, int val)
> +{
> +	gen_74x164_set_value(gc, offset, val);
> +	return 0;
> +}
> +
> +static int gen_74x164_get_value(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct gen_74x164_chip *chip = gpio_to_chip(gc);
> +	int ret;
> +
> +	mutex_lock(&chip->lock);
> +	ret = test_bit(offset, &chip->mask);
> +	mutex_unlock(&chip->lock);
> +
> +	return ret;
> +}
> +
> +static void gen_74x164_set_value(struct gpio_chip *gc,
> +				  unsigned offset, int val)
> +{
> +	struct gen_74x164_chip *chip;
> +	struct gen_74x164_platform_data *pdata;
> +	long mask;
> +	int refresh;
> +	int i;
> +
> +	chip = gpio_to_chip(gc);
> +	pdata = chip->parent->platform_data;
> +
> +	mutex_lock(&chip->lock);
> +	if (val)
> +		refresh = (test_and_set_bit(offset, &chip->mask) != val);
> +	else
> +		refresh = (test_and_clear_bit(offset, &chip->mask) != val);
> +
> +	if (refresh) {
> +		mask = chip->mask;
> +		for (i = 8; i > 0; --i, mask <<= 1) {
> +			gpio_set_value(pdata->gpio_pin_data, mask & 0x80);
> +			gpio_set_value(pdata->gpio_pin_clk, 1);
> +			gpio_set_value(pdata->gpio_pin_clk, 0);
> +		}
> +	}
> +	mutex_unlock(&chip->lock);
> +}
> +
> +static int __devinit gen_74x164_probe(struct platform_device *pdev)
> +{
> +	struct gen_74x164_platform_data *pdata;
> +	struct gen_74x164_chip *chip;
> +	struct gpio_chip *gc;
> +	int err;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (pdata == NULL) {
> +		dev_dbg(&pdev->dev, "no platform data specified\n");
> +		return -EINVAL;
> +	}
> +
> +	chip = kzalloc(sizeof(struct gen_74x164_chip), GFP_KERNEL);
> +	if (chip == NULL) {
> +		dev_err(&pdev->dev, "no memory for private data\n");
> +		return -ENOMEM;
> +	}
> +
> +	err = gpio_request(pdata->gpio_pin_clk, dev_name(&pdev->dev));
> +	if (err) {
> +		dev_err(&pdev->dev, "unable to claim gpio %u, err=%d\n",
> +			pdata->gpio_pin_clk, err);
> +		goto err_free_chip;
> +	}
> +
> +	err = gpio_request(pdata->gpio_pin_data, dev_name(&pdev->dev));
> +	if (err) {
> +		dev_err(&pdev->dev, "unable to claim gpio %u, err=%d\n",
> +			pdata->gpio_pin_data, err);
> +		goto err_free_clk;
> +	}
> +
> +	err = gpio_direction_output(pdata->gpio_pin_clk, 0);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"unable to set direction of gpio %u, err=%d\n",
> +			pdata->gpio_pin_clk, err);
> +		goto err_free_data;
> +	}
> +
> +	err = gpio_direction_output(pdata->gpio_pin_data, 0);
> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"unable to set direction of gpio %u, err=%d\n",
> +			pdata->gpio_pin_data, err);
> +		goto err_free_data;
> +	}
> +
> +	chip->parent = &pdev->dev;
> +	mutex_init(&chip->lock);
> +
> +	gc = &chip->gpio_chip;
> +
> +	gc->direction_input  = gen_74x164_direction_input;
> +	gc->direction_output = gen_74x164_direction_output;
> +	gc->get = gen_74x164_get_value;
> +	gc->set = gen_74x164_set_value;
> +	gc->can_sleep = 1;
> +
> +	gc->base = pdata->gpio_base;
> +	gc->ngpio = GEN_74X164_NUM_GPIOS;
> +	gc->label = dev_name(chip->parent);
> +	gc->dev = chip->parent;
> +	gc->owner = THIS_MODULE;
> +
> +	err = gpiochip_add(&chip->gpio_chip);
> +	if (err) {
> +		dev_err(&pdev->dev, "unable to add gpio chip, err=%d\n", err);
> +		goto err_free_data;
> +	}
> +
> +	platform_set_drvdata(pdev, chip);
> +	return 0;
> +
> +err_free_data:
> +	gpio_free(pdata->gpio_pin_data);
> +err_free_clk:
> +	gpio_free(pdata->gpio_pin_clk);
> +err_free_chip:
> +	kfree(chip);
> +	return err;
> +}
> +
> +static int gen_74x164_remove(struct platform_device *pdev)
> +{
> +	struct gen_74x164_chip *chip = platform_get_drvdata(pdev);
> +	struct gen_74x164_platform_data *pdata = pdev->dev.platform_data;
> +
> +	if (chip) {
> +		int err;
> +
> +		err = gpiochip_remove(&chip->gpio_chip);
> +		if (err) {
> +			dev_err(&pdev->dev,
> +				"unable to remove gpio chip, err=%d\n",
> +				err);
> +			return err;
> +		}
> +
> +		gpio_free(pdata->gpio_pin_clk);
> +		gpio_free(pdata->gpio_pin_data);
> +
> +		kfree(chip);
> +		platform_set_drvdata(pdev, NULL);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver gen_74x164_driver = {
> +	.probe		= gen_74x164_probe,
> +	.remove		= __devexit_p(gen_74x164_remove),
> +	.driver = {
> +		.name	= GEN_74X164_DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init gen_74x164_init(void)
> +{
> +	return platform_driver_register(&gen_74x164_driver);
> +}
> +subsys_initcall(gen_74x164_init);
> +
> +static void __exit gen_74x164_exit(void)
> +{
> +	platform_driver_unregister(&gen_74x164_driver);
> +}
> +module_exit(gen_74x164_exit);
> +
> +MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org>");
> +MODULE_AUTHOR("Miguel Gaio <miguel.gaio@efixo.com>");
> +MODULE_DESCRIPTION("GPIO expander driver for 74X164 8-bits shift
> register"); +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" GEN_74X164_DRIVER_NAME);
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 510aa20..fc82c23 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -361,4 +361,13 @@ config GPIO_JANZ_TTL
>  	  This driver provides support for driving the pins in output
>  	  mode only. Input mode is not supported.
> 
> +comment "Shift registers:"
> +
> +config GPIO_74X164
> +       tristate "74x164 serial-in/parallel-out 8-bits shift register"
> +       help
> +         Platform driver for 74x164 compatible serial-in/parallel-out
> +	 8-outputs shift registers. This driver can be used to provide access
> +	 to more gpio outputs.
> +
>  endif
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index fc6019d..60456a4 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -17,6 +17,7 @@ obj-$(CONFIG_GPIO_MAX7301)	+= max7301.o
>  obj-$(CONFIG_GPIO_MAX732X)	+= max732x.o
>  obj-$(CONFIG_GPIO_MC33880)	+= mc33880.o
>  obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
> +obj-$(CONFIG_GPIO_74X164)	+= 74x164.o
>  obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
>  obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
>  obj-$(CONFIG_GPIO_PL061)	+= pl061.o
> diff --git a/include/linux/74x164.h b/include/linux/74x164.h
> new file mode 100644
> index 0000000..1705732
> --- /dev/null
> +++ b/include/linux/74x164.h
> @@ -0,0 +1,22 @@
> +/*
> + *  74x164 - Serial-in/parallel-out 8-bits shift register
> + *
> + *  Copyright (C) 2010 Gabor Juhos <juhosg@openwrt.org>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + */
> +
> +#ifndef __74X164_H
> +#define __74X164_H
> +
> +#define GEN_74X164_DRIVER_NAME "74x164"
> +
> +struct gen_74x164_platform_data {
> +	unsigned	gpio_base;
> +	unsigned	gpio_pin_data;
> +	unsigned	gpio_pin_clk;
> +};
> +
> +#endif /* __74x164_H */

-- 
Florian
