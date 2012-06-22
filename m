Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308Ab2FVGGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 02:06:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41878 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287Ab2FVGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 02:06:44 -0400
Date: Fri, 22 Jun 2012 08:06:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v3] leds: Add MAX6956 driver
Message-ID: <20120622060639.GM5642@pengutronix.de>
References: <1337593269-2497-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1337628827-14484-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1337628827-14484-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

Linus Walleij pointed out that it's you who merges most LED stuff
nowadays. Do you have any thoughts on this patch?

Linus suggested to make this an mfd + led + gpio driver, but I think
this only adds indirections and code bloat without much benefits.

In case your mailbox doesn't contain the original patch any more, I can
bounce it to you and you can read the thread e.g. at

	http://thread.gmane.org/gmane.linux.kernel/1299625/focus=1300963

If you need it, I can bounce you the original patch.

Best regards
Uwe

On Mon, May 21, 2012 at 09:33:47PM +0200, Uwe Kleine-König wrote:
> This adds a driver for Maxim's MAX6956 28-Port LED Display Driver and
> I/O Expander.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> changes since v2:
>  - really do the changes announced for v2 (I resent v1, sigh and sorry)
>  - drop ARM: from Subject
> 
> Changes in v2 since (implicit) v1:
>  - drop #include <linux/input.h> and <linux/leds-pca9532.h>
>  - add #include <linux/err.h>
>  - fix typo pointed out by Bryan
>  - add locking
>  - added Cc: Grant Likely and Linus Walleij because the driver has some
>    gpio bits.
> 
>  drivers/leds/Kconfig                       |   10 +
>  drivers/leds/Makefile                      |    1 +
>  drivers/leds/leds-max6956.c                |  394 ++++++++++++++++++++++++++++
>  include/linux/platform_data/leds-max6956.h |   17 ++
>  4 files changed, 422 insertions(+)
>  create mode 100644 drivers/leds/leds-max6956.c
>  create mode 100644 include/linux/platform_data/leds-max6956.h
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index ff4b8cf..79ef2a1 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -387,6 +387,16 @@ config LEDS_TCA6507
>  	  LED driver chips accessed via the I2C bus.
>  	  Driver support brightness control and hardware-assisted blinking.
>  
> +config LEDS_MAX6956
> +	tristate "LED support for MAX6956 LED Display Driver and I/O Expander"
> +	depends on LEDS_CLASS
> +	depends on GPIOLIB
> +	depends on I2C
> +	select REGMAP_I2C
> +	help
> +	  This option enables support the LEDs and GPIOs connected to Maxim's
> +	  MAX6956 28-Port LED Display Driver and I/O Expander.
> +
>  config LEDS_MAX8997
>  	tristate "LED support for MAX8997 PMIC"
>  	depends on LEDS_CLASS && MFD_MAX8997
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 890481c..87ec494 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -44,6 +44,7 @@ obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
>  obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
>  obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
>  obj-$(CONFIG_LEDS_RENESAS_TPU)		+= leds-renesas-tpu.o
> +obj-$(CONFIG_LEDS_MAX6956)		+= leds-max6956.o
>  obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
>  
>  # LED SPI Drivers
> diff --git a/drivers/leds/leds-max6956.c b/drivers/leds/leds-max6956.c
> new file mode 100644
> index 0000000..326ee15
> --- /dev/null
> +++ b/drivers/leds/leds-max6956.c
> @@ -0,0 +1,394 @@
> +/*
> + * Maxim 28-Port LED Display Driver and I/O Expander
> + *
> + * Copyright (C) 2012 Pengutronix
> + * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify it under
> + * the terms of the GNU General Public License version 2 as published by the
> + * Free Software Foundation.
> + *
> + * Datasheet: http://datasheets.maxim-ic.com/en/ds/MAX6956.pdf
> + */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/leds.h>
> +#include <linux/mutex.h>
> +#include <linux/gpio.h>
> +#include <linux/regmap.h>
> +
> +#include <linux/platform_data/leds-max6956.h>
> +
> +#define MAX6956_REG_GLOBAL_CURRENT		0x02
> +#define MAX6956_REG_CONFIGURATION		0x04
> +#define MAX6956_REG_CONFIGURATION_S			0x01
> +#define MAX6956_REG_CONFIGURATION_I			0x40
> +#define MAX6956_REG_CONFIGURATION_M			0x80
> +#define MAX6956_REG_TRANSITION_DETECT_MASK	0x06
> +#define MAX6956_REG_DISPLAY_TEST		0x07
> +/*
> + * MAX6956_REG_PORT_CONFIGURATION(i) holds the configuration for ports
> + * 4 * i, 4 * i + 1, ..., 4 * i + 3 for i in [1, ... 7].
> + */
> +#define MAX6956_REG_PORT_CONFIGURATION(i)	(0x08 + (i))
> +#define MAX6956_REG_PORT_CONFIGURATION_LED		0x0
> +#define MAX6956_REG_PORT_CONFIGURATION_GPIOOUT		0x1
> +#define MAX6956_REG_PORT_CONFIGURATION_GPIOINPULLUP	0x2
> +#define MAX6956_REG_PORT_CONFIGURATION_GPIOIN		0x3
> +/*
> + * MAX6956_REG_CURRENT(i) holds the current for segments 2 * i, 2 * i + 1 for i
> + * in [2, ... 15].
> + */
> +#define MAX6956_REG_CURRENT(i)			(0x10 + (i))
> +/*
> + * MAX6956_REG_PORT(i) is valid for i in [4, ... 31]. Data bit 0 holds the value
> + * for port i.
> + */
> +#define MAX6956_REG_PORT(i)			(0x20 + (i))
> +/*
> + * MAX6956_REG_MULTIPORT(i) contains MAX6956_REG_PORT(j) for j in [i, ... i + 7]
> + * for i in [0, ... 31]. Note that data for invalid ports (i.e. 0-3 and 31-38)
> + * read as 0 and writes have no effect.
> + * Note that there is a bug in the documentation (as of revision 2) specifying
> + * that at the high end the data is contained in the lower bits.
> + */
> +#define MAX6956_REG_MULTIPORT(i)		(0x40 + (i))
> +
> +#define MAX6956_NUM_REGISTERS 0x60
> +
> +struct max6956_led_ddata {
> +	unsigned offset;
> +	struct led_classdev cdev;
> +	struct work_struct work;
> +	enum led_brightness brightness;
> +};
> +
> +struct max6956_ddata {
> +	struct device *dev;
> +
> +	struct mutex lock;
> +
> +	struct regmap *regmap;
> +
> +	struct gpio_chip gpio_chip;
> +
> +	struct max6956_pdata pdata;
> +
> +	struct max6956_led_ddata leds[32];
> +
> +	const char *gpio_names[32];
> +};
> +
> +#define ddata_from_gpio_chip(chip) \
> +	container_of(chip, struct max6956_ddata, gpio_chip)
> +#define ddata_from_led_cdev(cdev) \
> +	dev_get_drvdata(cdev->dev->parent)
> +#define ddata_from_work(_work) \
> +	ddata_from_led_cdev(&lddata_from_work(_work)->cdev)
> +
> +#define lddata_from_led_cdev(_cdev) \
> +	container_of(_cdev, struct max6956_led_ddata, cdev)
> +#define lddata_from_work(_work) \
> +	container_of(_work, struct max6956_led_ddata, work)
> +
> +static const struct regmap_config max6956_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.cache_type = REGCACHE_NONE,
> +
> +	.max_register = 0x5f,
> +};
> +
> +/* caller must hold ddata->lock */
> +static int max6956_portconfig_set(struct max6956_ddata *ddata, unsigned offset,
> +		unsigned mode)
> +{
> +	unsigned int reg = MAX6956_REG_PORT_CONFIGURATION(offset / 4);
> +	unsigned int shift = 2 * (offset % 4);
> +
> +	return regmap_update_bits(ddata->regmap, reg,
> +			0x3 << shift, mode << shift);
> +}
> +
> +/* caller must hold ddata->lock */
> +static int max6956_set_sink_current(struct max6956_ddata *ddata,
> +		unsigned offset, unsigned regcurrent)
> +{
> +	unsigned reg = MAX6956_REG_CURRENT(offset / 2);
> +	unsigned shift = offset & 1 ? 4 : 0;
> +
> +	return regmap_update_bits(ddata->regmap, reg,
> +			0xf << shift, (regcurrent - 1) << shift);
> +}
> +
> +static void max6956_led_work(struct work_struct *work)
> +{
> +	struct max6956_led_ddata *lddata = lddata_from_work(work);
> +	struct led_classdev *led_cdev = &lddata->cdev;
> +
> +	struct max6956_ddata *ddata = ddata_from_led_cdev(led_cdev);
> +
> +	BUG_ON(&ddata->leds[lddata->offset] != lddata);
> +
> +	mutex_lock(&ddata->lock);
> +
> +	if (!lddata->brightness) {
> +		regmap_write(ddata->regmap,
> +				MAX6956_REG_PORT(lddata->offset), 0);
> +	} else {
> +		max6956_set_sink_current(ddata, lddata->offset,
> +				lddata->brightness);
> +		regmap_write(ddata->regmap,
> +				MAX6956_REG_PORT(lddata->offset), 1);
> +	}
> +	max6956_portconfig_set(ddata, lddata->offset, 0);
> +
> +	mutex_unlock(&ddata->lock);
> +}
> +
> +/* caller must hold ddata->lock */
> +static unsigned max6956_get_sink_current(struct max6956_ddata *ddata,
> +		unsigned offset)
> +{
> +	unsigned reg = MAX6956_REG_CURRENT(offset / 2);
> +	unsigned shift = offset & 1 ? 4 : 0;
> +	unsigned regcurrent;
> +
> +	regmap_read(ddata->regmap, reg, &regcurrent);
> +
> +	return ((regcurrent >> shift) & 0xf) + 1;
> +}
> +
> +static void max6956_led_brightness_set(struct led_classdev *led_cdev,
> +		enum led_brightness brightness)
> +{
> +	struct max6956_led_ddata *lddata = lddata_from_led_cdev(led_cdev);
> +	lddata->brightness = brightness;
> +	schedule_work(&lddata->work);
> +}
> +
> +static enum led_brightness max6956_led_brightness_get(
> +		struct led_classdev *led_cdev)
> +{
> +	struct max6956_led_ddata *lddata = lddata_from_led_cdev(led_cdev);
> +	struct max6956_ddata *ddata = ddata_from_led_cdev(led_cdev);
> +	unsigned val;
> +	enum led_brightness ret;
> +
> +	BUG_ON(&ddata->leds[lddata->offset] != lddata);
> +
> +	mutex_lock(&ddata->lock);
> +
> +	regmap_read(ddata->regmap, MAX6956_REG_PORT(lddata->offset), &val);
> +
> +	if (!(val & 1))
> +		ret = 0;
> +	else
> +		ret = max6956_get_sink_current(ddata, lddata->offset);
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return ret;
> +}
> +
> +static int max6956_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct max6956_ddata *ddata = ddata_from_gpio_chip(chip);
> +	unsigned char type = ddata->pdata.led_pdata[offset].type;
> +
> +	if (type != MAX6956_TYPE_GPIO && type != MAX6956_TYPE_GPIOPULLUP)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +static int max6956_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct max6956_ddata *ddata = ddata_from_gpio_chip(chip);
> +	unsigned mode;
> +	int ret;
> +
> +	switch (ddata->pdata.led_pdata[offset].type) {
> +	case MAX6956_TYPE_GPIO:
> +		mode = MAX6956_REG_PORT_CONFIGURATION_GPIOIN;
> +		break;
> +	case MAX6956_TYPE_GPIOPULLUP:
> +		mode = MAX6956_REG_PORT_CONFIGURATION_GPIOINPULLUP;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&ddata->lock);
> +
> +	ret = max6956_portconfig_set(ddata, offset, mode);
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return ret;
> +}
> +
> +static int max6956_gpio_get(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct max6956_ddata *ddata = ddata_from_gpio_chip(chip);
> +	unsigned int val;
> +
> +	mutex_lock(&ddata->lock);
> +
> +	regmap_read(ddata->regmap, MAX6956_REG_PORT(offset), &val);
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return val;
> +}
> +
> +static int max6956_gpio_direction_output(struct gpio_chip *chip,
> +		unsigned offset, int value)
> +{
> +	struct max6956_ddata *ddata = ddata_from_gpio_chip(chip);
> +
> +	mutex_lock(&ddata->lock);
> +
> +	regmap_write(ddata->regmap, MAX6956_REG_PORT(offset), !!value);
> +
> +	mutex_unlock(&ddata->lock);
> +
> +	return max6956_portconfig_set(ddata, offset,
> +			MAX6956_REG_PORT_CONFIGURATION_GPIOOUT);
> +}
> +
> +static void max6956_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
> +{
> +	struct max6956_ddata *ddata = ddata_from_gpio_chip(chip);
> +
> +	mutex_lock(&ddata->lock);
> +
> +	regmap_write(ddata->regmap, MAX6956_REG_PORT(offset), !!value);
> +
> +	mutex_unlock(&ddata->lock);
> +}
> +
> +static const struct gpio_chip max6956_gpio_chip_init __devinitconst = {
> +	.label = "max6956",
> +	.owner = THIS_MODULE,
> +	.request = max6956_gpio_request,
> +	.direction_input = max6956_gpio_direction_input,
> +	.get = max6956_gpio_get,
> +	.direction_output = max6956_gpio_direction_output,
> +	.set = max6956_gpio_set,
> +	.base = -1,
> +	.ngpio = 32,
> +	.can_sleep = 1,
> +};
> +
> +static int __devinit max6956_probe(struct i2c_client *client,
> +		const struct i2c_device_id *id)
> +{
> +	struct max6956_ddata *ddata;
> +	struct max6956_pdata *pdata = client->dev.platform_data;
> +	int ret, i;
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	ddata = devm_kzalloc(&client->dev, sizeof(*ddata), GFP_KERNEL);
> +	if (!ddata) {
> +		dev_err(&client->dev, "Failed to allocate driver private data\n");
> +		return -ENOMEM;
> +	}
> +
> +	ddata->dev = &client->dev;
> +	mutex_init(&ddata->lock);
> +	ddata->regmap = devm_regmap_init_i2c(client, &max6956_regmap_config);
> +	if (IS_ERR(ddata->regmap)) {
> +		ret = PTR_ERR(ddata->regmap);
> +		dev_err(ddata->dev, "Failed to allocate register map: %d\n",
> +				ret);
> +		return ret;
> +	}
> +	ddata->pdata = *pdata;
> +	i2c_set_clientdata(client, ddata);
> +
> +	ddata->gpio_chip = max6956_gpio_chip_init;
> +	ddata->gpio_chip.names = ddata->gpio_names;
> +	ddata->gpio_chip.dev = ddata->dev;
> +
> +	regmap_write(ddata->regmap, MAX6956_REG_CONFIGURATION,
> +			MAX6956_REG_CONFIGURATION_S |
> +			MAX6956_REG_CONFIGURATION_I);
> +
> +	for (i = 4; i < 32; ++i)
> +		switch (pdata->led_pdata[i].type) {
> +		case MAX6956_TYPE_GPIO:
> +		case MAX6956_TYPE_GPIOPULLUP:
> +			ddata->gpio_names[i] = pdata->led_pdata[i].name;
> +			break;
> +		case MAX6956_TYPE_LED:
> +			ddata->leds[i] = (struct max6956_led_ddata){
> +				.offset = i,
> +				.cdev = {
> +					.name = pdata->led_pdata[i].name,
> +					.max_brightness = 16,
> +					.brightness_set =
> +						max6956_led_brightness_set,
> +					.brightness_get =
> +						max6956_led_brightness_get,
> +				},
> +			};
> +			INIT_WORK(&ddata->leds[i].work, max6956_led_work);
> +
> +			ret = led_classdev_register(ddata->dev,
> +					&ddata->leds[i].cdev);
> +			if (ret)
> +				dev_warn(ddata->dev,
> +						"Failed to register led %s\n",
> +						pdata->led_pdata[i].name);
> +			break;
> +		}
> +
> +	ret = gpiochip_add(&ddata->gpio_chip);
> +
> +	return ret;
> +}
> +
> +static int __devexit max6956_remove(struct i2c_client *client)
> +{
> +	struct max6956_ddata *ddata = i2c_get_clientdata(client);
> +	int ret, i;
> +
> +	ret = gpiochip_remove(&ddata->gpio_chip);
> +	if (ret)
> +		dev_warn(ddata->dev, "Failed to remove gpiochip: %d\n", ret);
> +
> +	for (i = 4; i < 32; ++i)
> +		if (ddata->pdata.led_pdata[i].type == MAX6956_TYPE_LED)
> +			led_classdev_unregister(&ddata->leds[i].cdev);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id max6956_device_id[] = {
> +	{ "max6956", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(i2c, max6956_device_id);
> +
> +static struct i2c_driver max6956_driver = {
> +	.driver = {
> +		.name = "leds-max6956",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = max6956_probe,
> +	.remove = max6956_remove,
> +	.id_table = max6956_device_id,
> +};
> +
> +module_i2c_driver(max6956_driver);
> +
> +MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("MAX6956 LED Display Driver and I/O Expander");
> diff --git a/include/linux/platform_data/leds-max6956.h b/include/linux/platform_data/leds-max6956.h
> new file mode 100644
> index 0000000..c7290a4
> --- /dev/null
> +++ b/include/linux/platform_data/leds-max6956.h
> @@ -0,0 +1,17 @@
> +#ifndef __LINUX_PLATFORM_DATA_LEDS_MAX6956_H__
> +#define __LINUX_PLATFORM_DATA_LEDS_MAX6956_H__
> +
> +#define MAX6956_TYPE_GPIO	0
> +#define MAX6956_TYPE_GPIOPULLUP	1
> +#define MAX6956_TYPE_LED	2
> +
> +struct max6956_led_pdata {
> +	unsigned char type;
> +	const char *name;
> +};
> +
> +struct max6956_pdata {
> +	struct max6956_led_pdata led_pdata[32];
> +};
> +
> +#endif
> -- 
> 1.7.10
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
