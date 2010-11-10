Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0KJUpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:45:34 -0500
Received: from smtp-out-134.synserver.de ([212.40.180.134]:1026 "EHLO
	smtp-out-133.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753828Ab0KJUpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:45:33 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 2591
Message-ID: <4CDB0451.3090303@metafoo.de>
Date: Wed, 10 Nov 2010 21:45:05 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Trilok Soni <tsoni@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-4-git-send-email-tsoni@codeaurora.org>
In-Reply-To: <1289393281-4459-4-git-send-email-tsoni@codeaurora.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trilok Soni wrote:
> Add support for Qualcomm PMIC8058 keyboard
> backlight, flash and low current leds.
>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Trilok Soni <tsoni@codeaurora.org>
> ---
>  drivers/leds/Kconfig          |   11 +
>  drivers/leds/Makefile         |    1 +
>  drivers/leds/leds-pmic8058.c  |  405 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/leds-pmic8058.h |   63 +++++++
>  4 files changed, 480 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/leds/leds-pmic8058.c
>  create mode 100644 include/linux/leds-pmic8058.h
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index cc2a88d..e1ebcad 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -214,6 +214,17 @@ config LEDS_PCA955X
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
>  	depends on MFD_WM831X
> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
> index 9c96db4..6c51883 100644
> --- a/drivers/leds/Makefile
> +++ b/drivers/leds/Makefile
> @@ -21,6 +21,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
>  obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
>  obj-$(CONFIG_LEDS_SUNFIRE)		+= leds-sunfire.o
>  obj-$(CONFIG_LEDS_PCA9532)		+= leds-pca9532.o
> +obj-$(CONFIG_LEDS_PMIC8058)		+= leds-pmic8058.o
>  obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
>  obj-$(CONFIG_LEDS_LP3944)		+= leds-lp3944.o
>  obj-$(CONFIG_LEDS_CLEVO_MAIL)		+= leds-clevo-mail.o
> diff --git a/drivers/leds/leds-pmic8058.c b/drivers/leds/leds-pmic8058.c
> new file mode 100644
> index 0000000..2933eb0
> --- /dev/null
> +++ b/drivers/leds/leds-pmic8058.c
> @@ -0,0 +1,405 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
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
> + * @value_lock - to protect the register value writes
> + * @reg_kp - cached value of keypad led backlight register
> + * @reg_led_ctrl - cached values of low-current led registers
> + * @reg_flash_led0 - cached value of first flash led control register
> + * @reg_flash_led1 - cached value of second flash led control register
> + */
> +struct pmic8058_led_data {
> +	struct led_classdev	cdev;
> +	int			id;
"enum pmic8058_leds" instead of int
> +	enum led_brightness	brightness;
> +	struct pm8058_chip	*pm_chip;
> +	struct work_struct	work;
> +	struct mutex		lock;
> +	spinlock_t		value_lock;
> +	u8			reg_kp;
> +	u8			reg_led_ctrl[3];
> +	u8			reg_flash_led0;
> +	u8			reg_flash_led1;

You allocate a separate pmic8058_led_data for each led, so one "u8 reg" should be
sufficient.

> +};
> +
> +#define PM8058_MAX_LEDS		7
> +
> +static void led_kp_set(struct pmic8058_led_data *led, enum led_brightness value)
> +{
> +	int rc;
> +	u8 level;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
This function is only ever called from within the workqueue so there is no need for
locking.

> +	level = (value << PM8058_DRV_KEYPAD_BL_SHIFT) &
> +				 PM8058_DRV_KEYPAD_BL_MASK;
> +
> +	led->reg_kp &= ~PM8058_DRV_KEYPAD_BL_MASK;
> +	led->reg_kp |= level;
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +
> +	rc = pm8058_write(led->pm_chip, SSBI_REG_ADDR_DRV_KEYPAD,
> +				 &led->reg_kp, 1);
> +	if (rc < 0)
> +		dev_err(led->cdev.dev, "can't set keypad backlight level\n");
> +}
> +
> +static enum led_brightness led_kp_get(struct pmic8058_led_data *led)
> +{
> +	if ((led->reg_kp & PM8058_DRV_KEYPAD_BL_MASK) >>
> +			 PM8058_DRV_KEYPAD_BL_SHIFT)
> +		return LED_FULL;
> +	else
> +		return LED_OFF;
> +}
> +

Shouldn't you be returning the actual brightness here instead of only either on or
off? The brightness is btw. stored in led->brightness, so you can use the same getter
for all three types of leds.


> +static void led_lc_set(struct pmic8058_led_data *led, enum led_brightness value)
> +{
> +	unsigned long flags;
> +	int rc, offset;
> +	u8 level, tmp;
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
This function is only ever called from within the workqueue so there is no need for
locking.

> +
> +	level = (led->brightness << PM8058_DRV_LED_CTRL_SHIFT) &
> +		PM8058_DRV_LED_CTRL_MASK;
> +
> +	offset = PMIC8058_LED_OFFSET(led->id);
> +	tmp = led->reg_led_ctrl[offset];
> +
> +	tmp &= ~PM8058_DRV_LED_CTRL_MASK;
> +	tmp |= level;
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +
> +	rc = pm8058_write(led->pm_chip,	SSBI_REG_ADDR_LED_CTRL(offset),
> +			&tmp, 1);
> +	if (rc) {
> +		dev_err(led->cdev.dev, "can't set (%d) led value\n",
> +				led->id);
> +		return;
> +	}
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
> +	led->reg_led_ctrl[offset] = tmp;
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +}
> +
> +static enum led_brightness led_lc_get(struct pmic8058_led_data *led)
> +{
> +	int offset;
> +	u8 value;
> +
> +	offset = PMIC8058_LED_OFFSET(led->id);
> +	value = led->reg_led_ctrl[offset];
> +
> +	if ((value & PM8058_DRV_LED_CTRL_MASK) >>
> +			PM8058_DRV_LED_CTRL_SHIFT)
> +		return LED_FULL;
> +	else
> +		return LED_OFF;
> +}
See above.
> +
> +static void
> +led_flash_set(struct pmic8058_led_data *led, enum led_brightness value)
> +{
> +	int rc;
> +	u8 level;
> +	unsigned long flags;
> +	u8 reg_flash_led;
> +	u16 reg_addr;
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
This function is only ever called from within the workqueue so there is no need for
locking.
> +	level = (value << PM8058_DRV_FLASH_SHIFT) &
> +				 PM8058_DRV_FLASH_MASK;
> +
> +	if (led->id == PMIC8058_ID_FLASH_LED_0) {
> +		led->reg_flash_led0 &= ~PM8058_DRV_FLASH_MASK;
> +		led->reg_flash_led0 |= level;
> +		reg_flash_led	    = led->reg_flash_led0;
> +		reg_addr	    = SSBI_REG_ADDR_FLASH_DRV0;
> +	} else {
> +		led->reg_flash_led1 &= ~PM8058_DRV_FLASH_MASK;
> +		led->reg_flash_led1 |= level;
> +		reg_flash_led	    = led->reg_flash_led1;
> +		reg_addr	    = SSBI_REG_ADDR_FLASH_DRV1;
> +	}
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +
> +	rc = pm8058_write(led->pm_chip, reg_addr, &reg_flash_led, 1);
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
Since this is a workqueue and there will only one running instance per led at a time
there is no need to take a lock here.
> +	switch (led->id) {
> +	case PMIC8058_ID_LED_KB_LIGHT:
> +		led_kp_set(led, led->brightness);
> +		break;
> +	case PMIC8058_ID_LED_0:
> +	case PMIC8058_ID_LED_1:
> +	case PMIC8058_ID_LED_2:
> +		led_lc_set(led, led->brightness);
> +		break;
> +	case PMIC8058_ID_FLASH_LED_0:
> +	case PMIC8058_ID_FLASH_LED_1:
> +		led_flash_set(led, led->brightness);
> +		break;
> +	}
> +
> +	mutex_unlock(&led->lock);
> +}
> +
> +static void pmic8058_led_set(struct led_classdev *led_cdev,
> +	enum led_brightness value)
> +{
> +	struct pmic8058_led_data *led;
> +	unsigned long flags;
> +
> +	led = container_of(led_cdev, struct pmic8058_led_data, cdev);
> +
> +	spin_lock_irqsave(&led->value_lock, flags);
Locking is not really required here since it is only a single assignment...
> +	led->brightness = value;
> +	schedule_work(&led->work);
and scheudule_work does not have to be inside of the lock.
> +	spin_unlock_irqrestore(&led->value_lock, flags);
> +}
> +
> +static enum led_brightness pmic8058_led_get(struct led_classdev *led_cdev)
> +{
> +	struct pmic8058_led_data *led;
> +
> +	led = container_of(led_cdev, struct pmic8058_led_data, cdev);
return led->brightness; (See above)
> +
> +	switch (led->id) {
> +	case PMIC8058_ID_LED_KB_LIGHT:
> +		return led_kp_get(led);
> +	case PMIC8058_ID_LED_0:
> +	case PMIC8058_ID_LED_1:
> +	case PMIC8058_ID_LED_2:
> +		return led_lc_get(led);
> +	}
> +	return LED_OFF;
> +}
> +
> +static int pmic8058_led_probe(struct platform_device *pdev)
__devinit
> +{
> +	struct pmic8058_leds_platform_data *pdata = pdev->dev.platform_data;
> +	struct pmic8058_led_data *led_dat;
> +	struct pmic8058_led *curr_led;
> +	int rc, i = 0;
> +	struct pm8058_chip	*pm_chip;
> +	u8			reg_kp;
> +	u8			reg_led_ctrl[3];
> +	u8			reg_flash_led0;
> +	u8			reg_flash_led1;
> +	static struct pmic8058_led_data *led;
> +
> +	pm_chip = platform_get_drvdata(pdev);
This looks at least a bit bogus since you'll overwrite the drvdata later. Can't you
get the pm8058_chip through pdev->dev.parent somehow?
> +	if (pm_chip == NULL) {
> +		dev_err(&pdev->dev, "no parent data passed in\n");
> +		return -EFAULT;
-EINVAL
> +	}
> +
> +	if (pdata == NULL) {
> +		dev_err(&pdev->dev, "platform data not supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	if (pdata->num_leds > PMIC8058_MAX_LEDS) {
> +		dev_err(&pdev->dev, "can't handle more than %d LEDS\n",
> +				 PMIC8058_MAX_LEDS);
> +		return -EFAULT;
-EINVAL
> +	}
> +
> +	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
Use kcalloc instead of kzalloc.

> +	if (led == NULL) {
> +		dev_err(&pdev->dev, "failed to alloc memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_DRV_KEYPAD, &reg_kp,
> +				1);
> +	if (rc) {
> +		dev_err(&pdev->dev, "can't get keypad backlight level\n");
> +		goto err_reg_read;
> +	}
> +
> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_LED_CTRL_BASE,
> +			reg_led_ctrl, 3);
> +	if (rc) {
> +		dev_err(&pdev->dev, "can't get led levels\n");
> +		goto err_reg_read;
> +	}
> +
> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_FLASH_DRV0,
> +			&reg_flash_led0, 1);
> +	if (rc) {
> +		dev_err(&pdev->dev, "can't read flash led0\n");
> +		goto err_reg_read;
> +	}
> +
> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_FLASH_DRV1,
> +			&reg_flash_led1, 1);
> +	if (rc) {
> +		dev_err(&pdev->dev, "can't get flash led1\n");
> +		goto err_reg_read;
> +	}
How about adding a helper function which will initializes the leds 'reg' field
depending on its id? It will certainly to improve code readability.

> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		curr_led	= &pdata->leds[i];
> +		led_dat		= &led[curr_led->id];
> +
> +		led_dat->cdev.name		= curr_led->name;
> +		led_dat->cdev.default_trigger   = curr_led->default_trigger;
> +		led_dat->cdev.brightness_set    = pmic8058_led_set;
> +		led_dat->cdev.brightness_get    = pmic8058_led_get;
> +		led_dat->cdev.brightness	= LED_OFF;
> +		led_dat->cdev.max_brightness	= curr_led->max_brightness;
> +		led_dat->cdev.flags		= LED_CORE_SUSPENDRESUME;
> +
> +		led_dat->id		        = curr_led->id;
> +		led_dat->reg_kp			= reg_kp;
> +		memcpy(led->reg_led_ctrl, reg_led_ctrl,
> +					 sizeof(reg_led_ctrl));
> +		led_dat->reg_flash_led0		= reg_flash_led0;
> +		led_dat->reg_flash_led1		= reg_flash_led1;
> +
> +		if (!((led_dat->id >= PMIC8058_ID_LED_KB_LIGHT) &&
> +				(led_dat->id <= PMIC8058_ID_FLASH_LED_1))) {
> +			dev_err(&pdev->dev, "invalid LED ID (%d) specified\n",
> +						 led_dat->id);
> +			rc = -EINVAL;
> +			goto fail_id_check;
> +		}
> +
> +		led_dat->pm_chip		= pm_chip;
> +
> +		mutex_init(&led_dat->lock);
> +		spin_lock_init(&led_dat->value_lock);
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
> +err_reg_read:
> +	kfree(led);
> +fail_id_check:
> +	if (i > 0) {
> +		for (i = i - 1; i >= 0; i--)
> +			led_classdev_unregister(&led[i].cdev);
> +	}
> +	return rc;
> +}
> +
> +static int __devexit pmic8058_led_remove(struct platform_device *pdev)
> +{
> +	int i;
> +	struct pmic8058_leds_platform_data *pdata = pdev->dev.platform_data;
> +	struct pmic8058_led_data *led = platform_get_drvdata(pdev);
> +
> +	for (i = 0; i < pdata->num_leds; i++) {
> +		mutex_destroy(&led[led->id].lock);
> +		led_classdev_unregister(&led[led->id].cdev);
> +		cancel_work_sync(&led[led->id].work);
> +	}

You need to free the 'led' array.

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
> index 0000000..c54c7e6
> --- /dev/null
> +++ b/include/linux/leds-pmic8058.h
> @@ -0,0 +1,63 @@
> +/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
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
> + * @max_brightness - maximum brightness level supported by the led
> + * @id - supported led id
> + */
> +struct pmic8058_led {
> +	const char	*name;
> +	const char	*default_trigger;
> +	unsigned	max_brightness;
Should max_brightness not rather be hardcoded in the driver? As far as I can tell it
depend on the hardware and is 4 bits wide for flash and bl leds and 5 bits for the
others.
> +	int		id;

enum pmic8058_leds instead of int



> +};
> +
> +/**
> + * struct pmic8058_leds_platform_data - platform data for leds
> + * @num_leds - number of leds
> + * @leds - array of struct pmic8058_led
> + */
> +struct pmic8058_leds_platform_data {
> +	int			num_leds;
size_t
> +	struct pmic8058_led	*leds;
> +};


If max_brightness is hardcoded in the driver you can reuse "struct led_info" and
"struct struct led_platform_data" instead of adding your own structs.


> +
> +#endif /* __LEDS_PMIC8058_H__ */

