Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0LUW2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:28:52 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61391 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391Ab0LUW2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:28:50 -0500
Message-ID: <4D112A15.2050609@metafoo.de>
Date: Tue, 21 Dec 2010 23:28:37 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: dd diasemi <dd.diasemi@gmail.com>
CC: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 10/11] LEDS: LED module of DA9052 device driver
References: <AANLkTim=MPhwuc4M3SKOJEckJuJ15=ojq8kMEfBaGyOc@mail.gmail.com>
In-Reply-To: <AANLkTim=MPhwuc4M3SKOJEckJuJ15=ojq8kMEfBaGyOc@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

Comments inline.

On 12/21/2010 06:56 PM, dd diasemi wrote:
> LED module for DA9052 PMIC device from Dialog Semiconductor.
>
> Changes made since last submission:
> . early invocation of SSC lock
> . deffered invocation of the function da9052_leds_prepare()
>
> Linux Kernel Version: 2.6.34
>
> Signed-off-by: D. Chen <dchen@diasemi.com>
> ---
> diff -urpN linux-2.6.34/drivers/leds/Kconfig
> linux-2.6.34_test/drivers/leds/Kconfig
> --- linux-2.6.34/drivers/leds/Kconfig	2010-05-17 02:17:36.000000000 +0500
> +++ linux-2.6.34_test/drivers/leds/Kconfig	2010-07-01 18:16:37.000000000 +0500
> @@ -225,6 +225,13 @@ config LEDS_DA903X
>  	  This option enables support for on-chip LED drivers found
>  	  on Dialog Semiconductor DA9030/DA9034 PMICs.
>
> +config LEDS_DA9052
> +	tristate "Dialog DA9052 LEDS"
> +	depends on PMIC_DA9052
> +	help
> +	  This option enables support for on-chip LED drivers found
> +	  on Dialog Semiconductor DA9052 PMICs.
> +
>  config LEDS_DAC124S085
>  	tristate "LED Support for DAC124S085 SPI DAC"
>  	depends on SPI
> diff -Naur linux-2.6.34-orig2/drivers/leds/leds-da9052.c
> linux-2.6.34/drivers/leds/leds-da9052.c
> --- linux-2.6.34-orig2/drivers/leds/leds-da9052.c	1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34/drivers/leds/leds-da9052.c	2010-10-13 09:20:26.000000000 +0500
> @@ -0,0 +1,306 @@
> +/*
> + * leds-da9052.c  --  LED Driver for Dialog DA9052
> + *
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * Author: Dialog Semiconductor Ltd <dchen@diasemi.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/leds.h>
> +#include <linux/workqueue.h>
> +#include <linux/slab.h>
> +
> +#include <linux/mfd/da9052/reg.h>
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/led.h>
> +
> +#define DRIVER_NAME		"da9052-leds"
> +
> +#define DA9052_LED4_PRESENT	1
> +#define DA9052_LED5_PRESENT	1
> +
> +
> +struct da9052_led_data {
> +	struct led_classdev cdev;
> +	struct work_struct work;
> +	struct da9052 *da9052;
> +	int id;
unsigned int

> +	int new_brightness;
enum led_brightness

> +	int is_led4_present;
> +	int is_led5_present;
The last two fields are not really used. Only in the probe function where they are
always true. So I think they should be dropped.
> +};
> +
> +#define GPIO14_PIN		2 /* GPO Open Drain */
> +#define GPIO14_TYPE		0 /* VDD_IO1 */
> +#define GPIO14_MODE		1 /* Output High */
I wonder after reading the code: are those constants board specific? If yes they
should go into the drivers platform data.

> +
> +#define GPIO15_PIN		2 /* GPO Open Drain */
> +#define GPIO15_TYPE		0 /* VDD_IO1 */
> +#define GPIO15_MODE		1 /* Output High */
Same here.
> +
> +#define MAXIMUM_PWM		95
> +#define MASK_GPIO14		0x0F
> +#define MASK_GPIO15		0xF0
> +#define GPIO15_PIN_BIT_POSITION	4
> +
> +static void da9052_led_work(struct work_struct *work)
> +{
> +	struct da9052_led_data *led = container_of(work,
> +				 struct da9052_led_data, work);
> +	int reg = 0;
> +	int led_dim_bit = 0;
> +	struct da9052_ssc_msg msg;
> +	int ret = 0;
> +
> +	switch (led->id) {
> +	case DA9052_LED_4:
> +		reg = DA9052_LED4CONT_REG;
> +		led_dim_bit = DA9052_LED4CONT_LED4DIM;
> +	break;
> +	case DA9052_LED_5:
> +		reg = DA9052_LED5CONT_REG;
> +		led_dim_bit = DA9052_LED5CONT_LED5DIM;
> +	break;
> +	}
> +
> +	if (led->new_brightness > MAXIMUM_PWM)
> +		led->new_brightness = MAXIMUM_PWM;
> +
You should set the led devices max_brightness field to MAXIMUM_PWM, then you can drop
this check.

> +	/* Always enable DIM feature
> +	 * This feature can be disabled if required
> +	 */
> +	msg.addr = reg;
> +	msg.data = led->new_brightness | led_dim_bit;
> +	da9052_lock(led->da9052);
> +	ret = led->da9052->write(led->da9052, &msg);
> +	if (ret) {
> +		da9052_unlock(led->da9052);
> +		return;
> +	}
You do exactly the same if ret is 0, so you can remove this if block.

> +	da9052_unlock(led->da9052);
> +}
> +
> +static void da9052_led_set(struct led_classdev *led_cdev,
> +			   enum led_brightness value)
> +{
> +	struct da9052_led_data *led;
> +
> +	led = container_of(led_cdev, struct da9052_led_data, cdev);
> +	led->new_brightness = value;
> +	schedule_work(&led->work);
> +}
> +
> +static int __devinit da9052_led_setup(struct da9052_led_data *led)
> +{
> +	int reg = 0;
> +	int ret = 0;
> +
> +	struct da9052_ssc_msg msg;
> +
> +	switch (led->id) {
> +	case DA9052_LED_4:
> +		reg = DA9052_LED4CONT_REG;
> +	break;
> +	case DA9052_LED_5:
> +		reg = DA9052_LED5CONT_REG;
> +	break;
> +	}
> +
> +	msg.addr = reg;
> +	msg.data = 0;
> +
> +	da9052_lock(led->da9052);
> +	ret = led->da9052->write(led->da9052, &msg);
> +	if (ret) {
> +		da9052_unlock(led->da9052);
> +		return ret;
> +	}
> +	da9052_unlock(led->da9052);
> +	return ret;
> +}
> +
> +static int da9052_leds_prepare(struct da9052_led_data *led)
This setup routine is for the whole chip not only a single led, so I think it should
rather be:
static int da9052_leds_prepare(struct da9052 *da9052, unsigned int leds_present)

While leds_present is a bit-field set to init_led from your probe function.

> +{
> +	int ret = 0;
> +	struct da9052_ssc_msg msg;
> +
> +	da9052_lock(led->da9052);
> +
> +	if (1 == led->is_led4_present) {
> +		msg.addr = DA9052_GPIO1415_REG;
> +		msg.data = 0;
> +
> +		ret = led->da9052->read(led->da9052, &msg);
> +		if (ret)
> +			goto out;
> +		msg.data = msg.data & ~(MASK_GPIO14);
> +		msg.data = msg.data | (
> +				GPIO14_PIN |
> +				(GPIO14_TYPE ? DA9052_GPIO1415_GPIO14TYPE : 0) |
> +				(GPIO14_MODE ? DA9052_GPIO1415_GPIO14MODE : 0));
> +
> +		ret = led->da9052->write(led->da9052, &msg);
> +		if (ret)
> +			goto out;
> +	}
Shouldn't you disable the led if it's not present?
> +
> +	if (1 == led->is_led5_present) {
> +		msg.addr = DA9052_GPIO1415_REG;
> +		msg.data = 0;
> +
> +		ret = led->da9052->read(led->da9052, &msg);
You read the DA9052_GPIO1415_REG register twice and write it twice in this function,
if both leds are present.
It would be better to read it once at the beginning, then modify according to which
leds are present and write it back at the end of the function.

> +		if (ret)
> +			goto out;
> +		msg.data = msg.data & ~(MASK_GPIO15);
> +		msg.data = msg.data |
> +			(((GPIO15_PIN << GPIO15_PIN_BIT_POSITION) |
> +				(GPIO15_TYPE ? DA9052_GPIO1415_GPIO15TYPE : 0) |
> +				(GPIO15_MODE ? DA9052_GPIO1415_GPIO15MODE : 0))
> +				);
> +		ret = led->da9052->write(led->da9052, &msg);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	da9052_unlock(led->da9052);
> +	return ret;
Drop these two lines, the result ist the same.

> +out:
> +	da9052_unlock(led->da9052);
> +	return ret;
> +}
> +
> +static int __devinit da9052_led_probe(struct platform_device *pdev)
> +{
> +	struct da9052_leds_platform_data *pdata = (pdev->dev.platform_data);
No need for the parentheses

> +	struct da9052_led_platform_data *led_cur;
> +	struct da9052_led_data *led, *led_dat;
> +	int ret, i;
> +	int init_led = 0;
unsigned int

> +
> +	if (pdata->num_leds < 1 || pdata->num_leds > DA9052_LED_MAX) {
> +		dev_err(&pdev->dev, "Invalid led count %d\n", pdata->num_leds);
> +		return -EINVAL;
> +	}
> +
> +	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
kcalloc
> +	if (led == NULL) {
> +		dev_err(&pdev->dev, "failed to alloc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	led->is_led4_present = DA9052_LED4_PRESENT;
> +	led->is_led5_present = DA9052_LED5_PRESENT;
Shouldn't those be set according to wheter led4 or led5 are actually present in the
platform_datas led list?
> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		led_dat = &led[i];
> +		led_cur = &pdata->led[i];
> +		if (led_cur->id < 0) {
Arn't the only valid values for id DA9052_LED_4	and DA9052_LED_5?

> +			dev_err(&pdev->dev, "invalid id %d\n", led_cur->id);
> +			ret = -EINVAL;
> +			goto err_register;
> +		}
> +
> +		if (init_led & (1 << led_cur->id)) {
> +			dev_err(&pdev->dev, "led %d already initialized\n",
> +					led_cur->id);
> +			ret = -EINVAL;
> +			goto err_register;
> +		}
> +
> +		init_led |= 1 << led_cur->id;
> +
> +		led_dat->cdev.name = led_cur->name;
> +		led_dat->cdev.brightness_set = da9052_led_set;
> +		led_dat->cdev.brightness = LED_OFF;
> +		led_dat->id = led_cur->id;
> +		led_dat->da9052 = dev_get_drvdata(pdev->dev.parent);
> +
> +		INIT_WORK(&led_dat->work, da9052_led_work);
> +
> +		ret = led_classdev_register(pdev->dev.parent, &led_dat->cdev);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to register led %d\n",
> +					led_dat->id);
> +			goto err_register;
> +
> +		}
> +		ret = da9052_led_setup(led_dat);
> +		if (ret) {
> +			dev_err(&pdev->dev, "unable to init led %d\n",
> +					led_dat->id);
> +			i++;
> +			goto err_register;
> +		}
> +	}
> +	ret = da9052_leds_prepare(led);
> +	if (ret) {
> +		dev_err(&pdev->dev, "unable to init led driver\n");
> +		goto err_free;
goto err_register;

> +	}
> +
> +	platform_set_drvdata(pdev, led);
> +	return 0;
> +
> +err_register:
> +	for (i = i - 1; i >= 0; i--) {
> +		led_classdev_unregister(&led[i].cdev);
> +		cancel_work_sync(&led[i].work);
> +	}
> +
> +err_free:
> +	kfree(led);
> +	return ret;
> +}
> +
> +static int __devexit da9052_led_remove(struct platform_device *pdev)
> +{
> +	struct da9052_leds_platform_data *pdata =
> +		(struct da9052_leds_platform_data *)pdev->dev.platform_data;
> +	struct da9052_led_data *led = platform_get_drvdata(pdev);
> +	int i;
> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		da9052_led_setup(&led[i]);
> +		led_classdev_unregister(&led[i].cdev);
> +		cancel_work_sync(&led[i].work);
> +	}
> +
> +	kfree(led);
> +	return 0;
> +}
> +
> +static struct platform_driver da9052_led_driver = {
> +	.driver	= {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe		= da9052_led_probe,
> +	.remove		= __devexit_p(da9052_led_remove),
> +};
> +
> +static int __init da9052_led_init(void)
> +{
> +	return platform_driver_register(&da9052_led_driver);
> +}
> +module_init(da9052_led_init);
> +
> +static void __exit da9052_led_exit(void)
> +{
> +	platform_driver_unregister(&da9052_led_driver);
> +}
> +module_exit(da9052_led_exit);
> +
> +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>	");
> +MODULE_DESCRIPTION("LED driver for Dialog DA9052 PMIC");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:" DRIVER_NAME);
> diff -Naur linux-2.6.34-orig2/drivers/leds/Makefile
> linux-2.6.34/drivers/leds/Makefile
> --- linux-2.6.34-orig2/drivers/leds/Makefile	2010-10-13 09:32:50.000000000 +0500
> +++ linux-2.6.34/drivers/leds/Makefile	2010-10-13 10:06:18.000000000 +0500
> @@ -27,6 +27,7 @@
>  obj-$(CONFIG_LEDS_FSG)			+= leds-fsg.o
>  obj-$(CONFIG_LEDS_PCA955X)		+= leds-pca955x.o
>  obj-$(CONFIG_LEDS_DA903X)		+= leds-da903x.o
> +obj-$(CONFIG_LEDS_DA9052)		+= leds-da9052.o
>  obj-$(CONFIG_LEDS_WM831X_STATUS)	+= leds-wm831x-status.o
>  obj-$(CONFIG_LEDS_WM8350)		+= leds-wm8350.o
>  obj-$(CONFIG_LEDS_PWM)			+= leds-pwm.o
> diff -Naur linux-2.6.34-orig2/include/linux/mfd/da9052/led.h
> linux-2.6.34/include/linux/mfd/da9052/led.h
> --- linux-2.6.34-orig2/include/linux/mfd/da9052/led.h	1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34/include/linux/mfd/da9052/led.h	2010-10-12
> 09:55:03.000000000 +0500
> @@ -0,0 +1,39 @@
> +/*
> + * da9052 LED module declarations.
> + *
> + * Copyright(c) 2009 Dialog Semiconductor Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +#ifndef __LINUX_MFD_DA9052_LED_H
> +#define __LINUX_MFD_DA9052_LED_H
> +
> +struct da9052_led_platform_data {
> +#define DA9052_LED_4			4
> +#define DA9052_LED_5			5
> +#define DA9052_LED_MAX			2
> +	int id;
> +	const char *name;
> +	const char *default_trigger;
> +};
> +
> +struct da9052_leds_platform_data {
> +	int num_leds;
> +	struct da9052_led_platform_data *led;
> +};

You could reuse the led_info and led_platform_data structs instead of introducing
your own.

> +
> +#endif /* __LINUX_MFD_DA9052_LED_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0RKhUACgkQBX4mSR26RiMUUgCePMQ7G01tddKmXuRerTrjhKpY
LAIAn0as4+zgwnqiNDrmOzQ90dn2SwSV
=st1O
-----END PGP SIGNATURE-----
