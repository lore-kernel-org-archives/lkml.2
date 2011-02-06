Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab1BFBpt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 20:45:49 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58049 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700Ab1BFBps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 20:45:48 -0500
Message-ID: <4D4DFD9D.7020507@metafoo.de>
Date: Sun, 06 Feb 2011 02:47:09 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Anirudh Ghayal <aghayal@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Trilok Soni <tsoni@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC v2 PATCH 3/7] led: pmic8058: Add PMIC8058 leds driver
References: <1296568063-12010-1-git-send-email-aghayal@codeaurora.org> <1296568063-12010-4-git-send-email-aghayal@codeaurora.org>
In-Reply-To: <1296568063-12010-4-git-send-email-aghayal@codeaurora.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 02:47 PM, Anirudh Ghayal wrote:
> From: Trilok Soni <tsoni@codeaurora.org>
> 
> Add support for Qualcomm PMIC8058 keyboard
> backlight, flash and low current leds.
> 
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> ---
> Changes from v1:
> Addressed review comments from Peter and Dmitry.
> 
>  drivers/leds/Kconfig          |   11 ++
>  drivers/leds/Makefile         |    1 +
>  drivers/leds/leds-pmic8058.c  |  360 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/leds-pmic8058.h |   61 +++++++
>  4 files changed, 433 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/leds-pmic8058.c
>  create mode 100644 include/linux/leds-pmic8058.h
> 
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 6f190f4..235a1e5 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -250,6 +250,17 @@ config LEDS_PCA955X
>  	  LED driver chips accessed via the I2C bus.  Supported
>  	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
>  
> +config LEDS_PMIC8058
> +	tristate "LED Support for Qualcomm PMIC8058"
> +	depends on PMIC8058
> +	help
> +	  This option enables support for LEDs connected over PMIC8058
> +	  (Power Management IC) chip on Qualcomm reference boards,
> +	  for example SURF and FFAs.
> +
> +	  To compile this driver as a module, choose M here: the module will
> +	  be called leds-pmic8058.
> +
>  config LEDS_WM831X_STATUS
>  	tristate "LED support for status LEDs on WM831x PMICs"
>  	depends on LEDS_CLASS
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index aae6989..9706739 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
>  obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
>  obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
>  obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
> +obj-$(CONFIG_LEDS_PMIC8058)		+= leds-pmic8058.o
>  obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
>  obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
>  obj-$(CONFIG_LEDS_LP5521)		+= leds-lp5521.o
> diff --git a/drivers/leds/leds-pmic8058.c b/drivers/leds/leds-pmic8058.c
> new file mode 100644
> index 0000000..fb3d7be
> --- /dev/null
> +++ b/drivers/leds/leds-pmic8058.c
> @@ -0,0 +1,360 @@
> +/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/leds.h>
> +#include <linux/workqueue.h>
> +#include <linux/spinlock.h>
> +#include <linux/mfd/pmic8058.h>
> +#include <linux/leds-pmic8058.h>
> +
> +#define SSBI_REG_ADDR_DRV_KEYPAD	0x48
> +#define PM8058_DRV_KEYPAD_BL_MASK	0xf0
> +#define PM8058_DRV_KEYPAD_BL_SHIFT	0x04
> +
> +#define SSBI_REG_ADDR_FLASH_DRV0        0x49
> +#define PM8058_DRV_FLASH_MASK           0xf0
> +#define PM8058_DRV_FLASH_SHIFT          0x04
> +
> +#define SSBI_REG_ADDR_FLASH_DRV1        0xFB
> +
> +#define SSBI_REG_ADDR_LED_CTRL_BASE	0x131
> +#define SSBI_REG_ADDR_LED_CTRL(n)	(SSBI_REG_ADDR_LED_CTRL_BASE + (n))
> +#define PM8058_DRV_LED_CTRL_MASK	0xf8
> +#define PM8058_DRV_LED_CTRL_SHIFT	0x03
> +
> +#define MAX_FLASH_LED_CURRENT	300
> +#define MAX_LC_LED_CURRENT	40
> +#define MAX_KP_BL_LED_CURRENT	300
> +
> +#define MAX_KEYPAD_BL_LEVEL	(1 << 4)
> +#define MAX_LED_DRV_LEVEL	20 /* 2 * 20 mA */
> +
> +#define PMIC8058_LED_OFFSET(id) ((id) - PMIC8058_ID_LED_0)
> +
> +#define MAX_KB_LED_BRIGHTNESS		15
> +#define MAX_LC_LED_BRIGHTNESS		20
> +#define MAX_FLASH_LED_BRIGHTNESS	15
> +
> +#define PMIC8058_MAX_LEDS	7
> +
> +/**
> + * struct pmic8058_led_data - internal led data structure
> + * @led_classdev - led class device
> + * @id	- led index
> + * @led_brightness - led brightness levels
> + * @pm_chip - parent MFD core device
> + * @work - workqueue for led
> + * @lock - to protect the transactions
> + * @reg - cached value of led register
> + */
> +struct pmic8058_led_data {
> +	struct led_classdev	cdev;
> +	int			id;
> +	u8			reg;
> +	enum led_brightness	brightness;
> +	struct pm8058_chip	*pm_chip;
> +	struct work_struct	work;
> +	struct mutex		lock;
> +};
> +
> +#define PM8058_MAX_LEDS		7
This is unused

> +
> +static void led_kp_set(struct pmic8058_led_data *led, enum led_brightness value)
> +{
> +	int rc;
> +	u8 level;
> +
> +	level = (value << PM8058_DRV_KEYPAD_BL_SHIFT) &
> +				 PM8058_DRV_KEYPAD_BL_MASK;
> +
> +	led->reg &= ~PM8058_DRV_KEYPAD_BL_MASK;
> +	led->reg |= level;
> +
> +	rc = pm8058_write(led->pm_chip, SSBI_REG_ADDR_DRV_KEYPAD,
> +				 &led->reg, 1);
> +	if (rc < 0)
> +		dev_err(led->cdev.dev, "can't set keypad backlight level\n");
> +}
> +
> +static void led_lc_set(struct pmic8058_led_data *led, enum led_brightness value)
> +{
> +	int rc, offset;
> +	u8 level;
> +
> +	level = (value << PM8058_DRV_LED_CTRL_SHIFT) &
> +				PM8058_DRV_LED_CTRL_MASK;
> +
> +	offset = PMIC8058_LED_OFFSET(led->id);
> +
> +	led->reg &= ~PM8058_DRV_LED_CTRL_MASK;
> +	led->reg |= level;
> +
> +	rc = pm8058_write(led->pm_chip,	SSBI_REG_ADDR_LED_CTRL(offset),
> +			&led->reg, 1);
> +	if (rc)
> +		dev_err(led->cdev.dev, "can't set (%d) led value\n",
> +				led->id);
> +}
> +
> +static void
> +led_flash_set(struct pmic8058_led_data *led, enum led_brightness value)
> +{
> +	int rc;
> +	u8 level;
> +	u16 reg_addr;
> +
> +	level = (value << PM8058_DRV_FLASH_SHIFT) &
> +				 PM8058_DRV_FLASH_MASK;
> +
> +	led->reg &= ~PM8058_DRV_FLASH_MASK;
> +	led->reg |= level;
> +
> +	if (led->id == PMIC8058_ID_FLASH_LED_0)
> +		reg_addr    = SSBI_REG_ADDR_FLASH_DRV0;
> +	else
> +		reg_addr    = SSBI_REG_ADDR_FLASH_DRV1;
> +
> +	rc = pm8058_write(led->pm_chip, reg_addr, &led->reg, 1);
> +	if (rc < 0)
> +		dev_err(led->cdev.dev, "can't set flash led%d level\n",
> +			 led->id);
> +}
> +
> +static void pmic8058_led_work(struct work_struct *work)
> +{
> +	struct pmic8058_led_data *led = container_of(work,
> +					 struct pmic8058_led_data, work);
> +
> +	mutex_lock(&led->lock);
> +
> +	switch (led->id) {
> +	case PMIC8058_ID_LED_KB_LIGHT:
> +		led_kp_set(led, led->brightness);
> +	break;
> +	case PMIC8058_ID_LED_0:
> +	case PMIC8058_ID_LED_1:
> +	case PMIC8058_ID_LED_2:
> +		led_lc_set(led, led->brightness);
> +	break;
> +	case PMIC8058_ID_FLASH_LED_0:
> +	case PMIC8058_ID_FLASH_LED_1:
> +		led_flash_set(led, led->brightness);
> +	break;
> +	}
> +
> +	mutex_unlock(&led->lock);
> +}
> +
> +static void pmic8058_led_set(struct led_classdev *led_cdev,
> +	enum led_brightness value)
> +{
> +	struct pmic8058_led_data *led;
> +
> +	led = container_of(led_cdev, struct pmic8058_led_data, cdev);
> +
> +	led->brightness = value;
> +	schedule_work(&led->work);
As discussed last time it might be a good idea to schedule the work on the
system_nrt_wq work queue and remove the mutex in the work function.

> +}
> +
> +static enum led_brightness pmic8058_led_get(struct led_classdev *led_cdev)
> +{
> +	struct pmic8058_led_data *led;
> +
> +	led = container_of(led_cdev, struct pmic8058_led_data, cdev);
> +
> +	return led->brightness;
> +}
> +
> +static int get_max_brightness(enum pmic8058_leds id)
> +{
> +	switch (id) {
> +	case PMIC8058_ID_LED_KB_LIGHT:
> +		return MAX_KB_LED_BRIGHTNESS;
> +	case PMIC8058_ID_LED_0:
> +	case PMIC8058_ID_LED_1:
> +	case PMIC8058_ID_LED_2:
> +		return MAX_LC_LED_BRIGHTNESS;
> +	case PMIC8058_ID_FLASH_LED_0:
> +	case PMIC8058_ID_FLASH_LED_1:
> +		return MAX_FLASH_LED_CURRENT;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static int get_init_value(struct pmic8058_led_data *led, u8 *val)
> +{
> +	int rc, offset;
> +	u16 addr;
> +
> +	switch (led->id) {
> +	case PMIC8058_ID_LED_KB_LIGHT:
> +		addr = SSBI_REG_ADDR_DRV_KEYPAD;
> +	break;
> +	case PMIC8058_ID_LED_0:
> +	case PMIC8058_ID_LED_1:
> +	case PMIC8058_ID_LED_2:
> +		offset = PMIC8058_LED_OFFSET(led->id);
> +		addr = SSBI_REG_ADDR_LED_CTRL(offset);
> +	break;
> +	case PMIC8058_ID_FLASH_LED_0:
> +		addr = SSBI_REG_ADDR_FLASH_DRV0;
> +	break;
> +	case PMIC8058_ID_FLASH_LED_1:
> +		addr = SSBI_REG_ADDR_FLASH_DRV1;
> +	break;
> +	}
> +
> +	rc = pm8058_read(led->pm_chip, addr, val, 1);
> +	if (rc)
> +		dev_err(led->cdev.dev, "can't get led(%d) level\n", led->id);
> +
> +	return rc;
> +}
> +
> +static int __devinit pmic8058_led_probe(struct platform_device *pdev)
> +{
> +	const struct pmic8058_leds_platform_data *pdata =
> +				pdev->dev.platform_data;
> +	struct pmic8058_led_data *led_dat;
> +	struct pmic8058_led *curr_led;
> +	int rc, i;
> +	struct pm8058_chip	*pm_chip;
> +	struct pmic8058_led_data *led;
> +
> +	pm_chip = platform_get_drvdata(pdev);
> +	if (pm_chip == NULL) {
> +		dev_err(&pdev->dev, "no parent data passed in\n");
> +		return -EINVAL;
> +	}
> +
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "platform data not supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	if (pdata->num_leds > PMIC8058_MAX_LEDS) {
> +		dev_err(&pdev->dev, "can't handle more than %d LEDs\n",
> +				 PMIC8058_MAX_LEDS);
> +		return -EFAULT;
> +	}
> +
> +	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
> +	if (led == NULL) {
> +		dev_err(&pdev->dev, "failed to alloc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		curr_led	= &pdata->leds[i];
> +		led_dat		= &led[curr_led->id];
> +
> +		led_dat->id     = curr_led->id;
> +
> +		if (!((led_dat->id >= PMIC8058_ID_LED_KB_LIGHT) &&
> +				(led_dat->id <= PMIC8058_ID_FLASH_LED_1))) {
> +			dev_err(&pdev->dev, "invalid LED ID (%d) specified\n",
> +						 led_dat->id);
> +			rc = -EINVAL;
> +			goto fail_id_check;
> +		}
> +
> +		led_dat->cdev.name		= curr_led->name;
> +		led_dat->cdev.default_trigger   = curr_led->default_trigger;
> +		led_dat->cdev.brightness_set    = pmic8058_led_set;
> +		led_dat->cdev.brightness_get    = pmic8058_led_get;
> +		led_dat->cdev.brightness	= LED_OFF;
> +		led_dat->cdev.flags		= LED_CORE_SUSPENDRESUME;
> +
> +		led_dat->cdev.max_brightness = get_max_brightness(led_dat->id);
> +		led_dat->pm_chip = pm_chip;
> +
> +		rc =  get_init_value(led_dat, &led_dat->reg);
> +		if (rc < 0)
> +			goto fail_id_check;
> +
> +		mutex_init(&led_dat->lock);
> +		INIT_WORK(&led_dat->work, pmic8058_led_work);
> +
> +		rc = led_classdev_register(&pdev->dev, &led_dat->cdev);
> +		if (rc) {
> +			dev_err(&pdev->dev, "unable to register led %d\n",
> +						 led_dat->id);
> +			goto fail_id_check;
> +		}
> +	}
> +
> +	platform_set_drvdata(pdev, led);
> +
> +	return 0;
> +
> +fail_id_check:
> +	if (i > 0) {
> +		for (i = i - 1; i >= 0; i--)
> +			led_classdev_unregister(&led[i].cdev);
> +	}
> +	kfree(led);
> +	return rc;
> +}
> +
> +static int __devexit pmic8058_led_remove(struct platform_device *pdev)
> +{
> +	int i;
> +	const struct pmic8058_leds_platform_data *pdata =
> +				pdev->dev.platform_data;
> +	struct pmic8058_led_data *led = platform_get_drvdata(pdev);
> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		mutex_destroy(&led[led->id].lock);
Since the mutex is used in the work function it should be destroyed after canceling
the work.
> +		led_classdev_unregister(&led[led->id].cdev);
> +		cancel_work_sync(&led[led->id].work);
This looks wrong. I guess it should be "&led[i]..."
> +	}
> +
> +	kfree(led);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver pmic8058_led_driver = {
> +	.probe		= pmic8058_led_probe,
> +	.remove		= __devexit_p(pmic8058_led_remove),
> +	.driver		= {
> +		.name	= "pm8058-led",
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init pmic8058_led_init(void)
> +{
> +	return platform_driver_register(&pmic8058_led_driver);
> +}
> +module_init(pmic8058_led_init);
> +
> +static void __exit pmic8058_led_exit(void)
> +{
> +	platform_driver_unregister(&pmic8058_led_driver);
> +}
> +module_exit(pmic8058_led_exit);
> +
> +MODULE_DESCRIPTION("PMIC8058 LEDs driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_VERSION("1.0");
> +MODULE_ALIAS("platform:pmic8058-led");
> +MODULE_AUTHOR("Trilok Soni <tsoni@codeaurora.org>");
> diff --git a/include/linux/leds-pmic8058.h b/include/linux/leds-pmic8058.h
> new file mode 100644
> index 0000000..42a3ae7
> --- /dev/null
> +++ b/include/linux/leds-pmic8058.h
> @@ -0,0 +1,61 @@
> +/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +
> +#ifndef __LEDS_PMIC8058_H__
> +#define __LEDS_PMIC8058_H__
> +
> +/**
> + * enum pmic8058_leds - PMIC8058 supported led ids
> + * @PMIC8058_ID_LED_KB_LIGHT - keyboard backlight led
> + * @PMIC8058_ID_LED_0 - First low current led
> + * @PMIC8058_ID_LED_1 - Second low current led
> + * @PMIC8058_ID_LED_2 - Third low current led
> + * @PMIC8058_ID_FLASH_LED_0 - First flash led
> + * @PMIC8058_ID_FLASH_LED_0 - Second flash led
> + */
> +enum pmic8058_leds {
> +	PMIC8058_ID_LED_KB_LIGHT = 1,
> +	PMIC8058_ID_LED_0,
> +	PMIC8058_ID_LED_1,
> +	PMIC8058_ID_LED_2,
> +	PMIC8058_ID_FLASH_LED_0,
> +	PMIC8058_ID_FLASH_LED_1,
> +};
> +
> +/**
> + * struct pmic8058_led - per led data
> + * @name - name of the led
> + * @default_trigger - default trigger which needs to e attached
> + * @id - supported led id
> + */
> +struct pmic8058_led {
> +	const char		*name;
> +	const char		*default_trigger;
> +	enum pmic8058_leds	id;
> +};
> +
> +/**
> + * struct pmic8058_leds_platform_data - platform data for leds
> + * @num_leds - number of leds
> + * @leds - array of struct pmic8058_led
> + */
> +struct pmic8058_leds_platform_data {
> +	int			num_leds;
> +	struct pmic8058_led	*leds;
> +};
> +

Wasn't it the idea to reuse led_info and led_platform_data?

> +#endif /* __LEDS_PMIC8058_H__ */

Otherwise it looks good to me.

- Lars
