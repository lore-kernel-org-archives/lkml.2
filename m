Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0HAWaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 18:30:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:4937 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab0HAWay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 18:30:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,299,1278313200"; 
   d="scan'208";a="591867716"
Date: Mon, 2 Aug 2010 00:30:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mike Rapoport <mike@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] mfd: add TPS6586x driver
Message-ID: <20100801223055.GA3052@sortiz-mobl>
References: <1280227972-1781-1-git-send-email-mike@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280227972-1781-1-git-send-email-mike@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

A few comments on this driver:

On Tue, Jul 27, 2010 at 01:52:52PM +0300, Mike Rapoport wrote:

> +static int tps6586x_gpio_get(struct gpio_chip *gc, unsigned offset)
> +{
> +	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
> +	uint8_t val;
> +	int ret;
> +
> +	ret = __tps6586x_read(tps6586x->client, TPS6586X_GPIOSET2, &val);
> +	if (ret)
> +		return ret;
> +
> +	return !!(val & (1 << offset));
> +}
> +
> +
> +static void tps6586x_gpio_set(struct gpio_chip *chip, unsigned offset,
> +			      int value)
> +{
> +	struct tps6586x *tps6586x = container_of(chip, struct tps6586x, gpio);
> +
> +	__tps6586x_write(tps6586x->client, TPS6586X_GPIOSET2,
> +			 value << offset);
> +}
> +
> +static int tps6586x_gpio_output(struct gpio_chip *gc, unsigned offset,
> +				int value)
> +{
> +	struct tps6586x *tps6586x = container_of(gc, struct tps6586x, gpio);
> +	uint8_t val, mask;
> +
> +	tps6586x_gpio_set(gc, offset, value);
> +
> +	val = 0x1 << (offset * 2);
> +	mask = 0x3 << (offset * 2);
> +
> +	return tps6586x_update(tps6586x->dev, TPS6586X_GPIOSET1, val, mask);
> +}
> +
> +static void tps6586x_gpio_init(struct tps6586x *tps6586x, int gpio_base)
> +{
> +	int ret;
> +
> +	if (!gpio_base)
> +		return;
> +
> +	tps6586x->gpio.owner		= THIS_MODULE;
> +	tps6586x->gpio.label		= tps6586x->client->name;
> +	tps6586x->gpio.dev		= tps6586x->dev;
> +	tps6586x->gpio.base		= gpio_base;
> +	tps6586x->gpio.ngpio		= 4;
> +	tps6586x->gpio.can_sleep	= 1;
> +
> +	/* FIXME: add handling of GPIOs as dedicated inputs */
> +	tps6586x->gpio.direction_output	= tps6586x_gpio_output;
> +	tps6586x->gpio.set		= tps6586x_gpio_set;
> +	tps6586x->gpio.get		= tps6586x_gpio_get;
> +
> +	ret = gpiochip_add(&tps6586x->gpio);
> +	if (ret)
> +		dev_warn(tps6586x->dev, "GPIO registration failed: %d\n", ret);
> +}
All the gpio bits here should be part of a separate patch adding an entry to
drivers/gpio/, with a Kconfig dependency on this MFD driver.

> +static int __devinit tps6586x_add_subdevs(struct tps6586x *tps6586x,
> +					  struct tps6586x_platform_data *pdata)
> +{
> +	struct tps6586x_subdev_info *subdev;
> +	struct platform_device *pdev;
> +	int i, ret = 0;
> +
> +	for (i = 0; i < pdata->num_subdevs; i++) {
> +		subdev = &pdata->subdevs[i];
> +
> +		pdev = platform_device_alloc(subdev->name, subdev->id);
> +
> +		pdev->dev.parent = tps6586x->dev;
> +		pdev->dev.platform_data = subdev->platform_data;
> +
> +		ret = platform_device_add(pdev);
> +		if (ret)
> +			goto failed;
> +	}
> +	return 0;
> +
> +failed:
> +	tps6586x_remove_subdevs(tps6586x);
> +	return ret;
> +}
Although this one is correct, I'm wondering if you really have platforms
adding different subdevs for this chipset ?


> +static int __devinit tps6586x_probe(struct i2c_client *client,
> +				    const struct i2c_device_id *id)
For consistency sake, could you please rename this one to
tps6586x_i2c_probe() please ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
