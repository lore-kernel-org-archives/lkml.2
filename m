Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2ICIPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:15:13 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42052 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2ICIPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:15:06 -0400
Message-ID: <5044671F.2030303@ti.com>
Date: Mon, 03 Sep 2012 11:15:27 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pwm: Move TWL6030 PWM driver to PWM framework
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de> <1346582458-7890-3-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1346582458-7890-3-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 01:40 PM, Thierry Reding wrote:
> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index 5fbb2a6..1b1a789 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -638,6 +638,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned irq_base,
>  			return PTR_ERR(child);
>  	}
>  
> +	if (IS_ENABLED(CONFIG_PWM_TWL6030)) {

I think you should also check for the PMIC versions here before adding the child:
	if (IS_ENABLED(CONFIG_PWM_TWL6030) && twl_class_is_6030()) {

To avoid loading the twl6030-pwm driver for twl4030 class.

> +		child = add_child(TWL6030_MODULE_ID1, "twl6030-pwm", NULL, 0,
> +				  false, 0, 0);
> +		if (IS_ERR(child))
> +			return PTR_ERR(child);
> +	}
> +
>  	if (IS_ENABLED(CONFIG_TWL4030_USB) && pdata->usb &&
>  	    twl_class_is_4030()) {
>  
> diff --git a/drivers/mfd/twl6030-pwm.c b/drivers/mfd/twl6030-pwm.c
> deleted file mode 100644
> index e8fee14..0000000
> --- a/drivers/mfd/twl6030-pwm.c
> +++ /dev/null
> @@ -1,165 +0,0 @@
> -/*
> - * twl6030_pwm.c
> - * Driver for PHOENIX (TWL6030) Pulse Width Modulator
> - *
> - * Copyright (C) 2010 Texas Instruments
> - * Author: Hemanth V <hemanthv@ti.com>
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms of the GNU General Public License version 2 as published by
> - * the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program.  If not, see <http://www.gnu.org/licenses/>.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/i2c/twl.h>
> -#include <linux/slab.h>
> -
> -#define LED_PWM_CTRL1	0xF4
> -#define LED_PWM_CTRL2	0xF5
> -
> -/* Max value for CTRL1 register */
> -#define PWM_CTRL1_MAX	255
> -
> -/* Pull down disable */
> -#define PWM_CTRL2_DIS_PD	(1 << 6)
> -
> -/* Current control 2.5 milli Amps */
> -#define PWM_CTRL2_CURR_02	(2 << 4)
> -
> -/* LED supply source */
> -#define PWM_CTRL2_SRC_VAC	(1 << 2)
> -
> -/* LED modes */
> -#define PWM_CTRL2_MODE_HW	(0 << 0)
> -#define PWM_CTRL2_MODE_SW	(1 << 0)
> -#define PWM_CTRL2_MODE_DIS	(2 << 0)
> -
> -#define PWM_CTRL2_MODE_MASK	0x3
> -
> -struct pwm_device {
> -	const char *label;
> -	unsigned int pwm_id;
> -};
> -
> -int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> -{
> -	u8 duty_cycle;
> -	int ret;
> -
> -	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
> -		return -EINVAL;
> -
> -	duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
> -
> -	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
> -
> -	if (ret < 0) {
> -		pr_err("%s: Failed to configure PWM, Error %d\n",
> -			pwm->label, ret);
> -		return ret;
> -	}
> -	return 0;
> -}
> -EXPORT_SYMBOL(pwm_config);
> -
> -int pwm_enable(struct pwm_device *pwm)
> -{
> -	u8 val;
> -	int ret;
> -
> -	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
> -	if (ret < 0) {
> -		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
> -		return ret;
> -	}
> -
> -	/* Change mode to software control */
> -	val &= ~PWM_CTRL2_MODE_MASK;
> -	val |= PWM_CTRL2_MODE_SW;
> -
> -	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
> -	if (ret < 0) {
> -		pr_err("%s: Failed to enable PWM, Error %d\n", pwm->label, ret);
> -		return ret;
> -	}
> -
> -	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
> -	return 0;
> -}
> -EXPORT_SYMBOL(pwm_enable);
> -
> -void pwm_disable(struct pwm_device *pwm)
> -{
> -	u8 val;
> -	int ret;
> -
> -	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
> -	if (ret < 0) {
> -		pr_err("%s: Failed to disable PWM, Error %d\n",
> -			pwm->label, ret);
> -		return;
> -	}
> -
> -	val &= ~PWM_CTRL2_MODE_MASK;
> -	val |= PWM_CTRL2_MODE_HW;
> -
> -	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
> -	if (ret < 0) {
> -		pr_err("%s: Failed to disable PWM, Error %d\n",
> -			pwm->label, ret);
> -		return;
> -	}
> -	return;
> -}
> -EXPORT_SYMBOL(pwm_disable);
> -
> -struct pwm_device *pwm_request(int pwm_id, const char *label)
> -{
> -	u8 val;
> -	int ret;
> -	struct pwm_device *pwm;
> -
> -	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
> -	if (pwm == NULL) {
> -		pr_err("%s: failed to allocate memory\n", label);
> -		return NULL;
> -	}
> -
> -	pwm->label = label;
> -	pwm->pwm_id = pwm_id;
> -
> -	/* Configure PWM */
> -	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
> -		PWM_CTRL2_MODE_HW;
> -
> -	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
> -
> -	if (ret < 0) {
> -		pr_err("%s: Failed to configure PWM, Error %d\n",
> -			 pwm->label, ret);
> -
> -		kfree(pwm);
> -		return NULL;
> -	}
> -
> -	return pwm;
> -}
> -EXPORT_SYMBOL(pwm_request);
> -
> -void pwm_free(struct pwm_device *pwm)
> -{
> -	pwm_disable(pwm);
> -	kfree(pwm);
> -}
> -EXPORT_SYMBOL(pwm_free);
> -
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index e678005..ed81720 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -142,6 +142,15 @@ config  PWM_TIEHRPWM
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-tiehrpwm.
>  
> +config PWM_TWL6030
> +	tristate "TWL6030 PWM support"
> +	depends on TWL4030_CORE
> +	help
> +	  Generic PWM framework driver for TWL6030.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-twl6030.
> +
>  config PWM_VT8500
>  	tristate "vt8500 pwm support"
>  	depends on ARCH_VT8500
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index 29cf57e..acfe482 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -11,4 +11,5 @@ obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
>  obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
>  obj-$(CONFIG_PWM_TIECAP)	+= pwm-tiecap.o
>  obj-$(CONFIG_PWM_TIEHRPWM)	+= pwm-tiehrpwm.o
> +obj-$(CONFIG_PWM_TWL6030)	+= pwm-twl6030.o
>  obj-$(CONFIG_PWM_VT8500)	+= pwm-vt8500.o
> diff --git a/drivers/pwm/pwm-twl6030.c b/drivers/pwm/pwm-twl6030.c
> new file mode 100644
> index 0000000..8e63878
> --- /dev/null
> +++ b/drivers/pwm/pwm-twl6030.c
> @@ -0,0 +1,184 @@
> +/*
> + * twl6030_pwm.c
> + * Driver for PHOENIX (TWL6030) Pulse Width Modulator
> + *
> + * Copyright (C) 2010 Texas Instruments
> + * Author: Hemanth V <hemanthv@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/i2c/twl.h>
> +#include <linux/slab.h>
> +
> +#define LED_PWM_CTRL1	0xF4
> +#define LED_PWM_CTRL2	0xF5
> +
> +/* Max value for CTRL1 register */
> +#define PWM_CTRL1_MAX	255
> +
> +/* Pull down disable */
> +#define PWM_CTRL2_DIS_PD	(1 << 6)
> +
> +/* Current control 2.5 milli Amps */
> +#define PWM_CTRL2_CURR_02	(2 << 4)
> +
> +/* LED supply source */
> +#define PWM_CTRL2_SRC_VAC	(1 << 2)
> +
> +/* LED modes */
> +#define PWM_CTRL2_MODE_HW	(0 << 0)
> +#define PWM_CTRL2_MODE_SW	(1 << 0)
> +#define PWM_CTRL2_MODE_DIS	(2 << 0)
> +
> +#define PWM_CTRL2_MODE_MASK	0x3
> +
> +struct twl6030_pwm_chip {
> +	struct pwm_chip chip;
> +};
> +
> +static int twl6030_pwm_request(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	int ret;
> +	u8 val;
> +
> +	/* Configure PWM */
> +	val = PWM_CTRL2_DIS_PD | PWM_CTRL2_CURR_02 | PWM_CTRL2_SRC_VAC |
> +	      PWM_CTRL2_MODE_HW;
> +
> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to configure PWM, Error %d\n",
> +			pwm->label, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int twl6030_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	u8 duty_cycle = (duty_ns * PWM_CTRL1_MAX) / period_ns;
> +	int ret;
> +
> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, duty_cycle, LED_PWM_CTRL1);
> +	if (ret < 0) {
> +		pr_err("%s: Failed to configure PWM, Error %d\n",
> +			pwm->label, ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
> +			pwm->label, ret);
> +		return ret;
> +	}
> +
> +	/* Change mode to software control */
> +	val &= ~PWM_CTRL2_MODE_MASK;
> +	val |= PWM_CTRL2_MODE_SW;
> +
> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to enable PWM, Error %d\n",
> +			pwm->label, ret);
> +		return ret;
> +	}
> +
> +	twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
> +	return 0;
> +}
> +
> +static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	int ret;
> +	u8 val;
> +
> +	ret = twl_i2c_read_u8(TWL6030_MODULE_ID1, &val, LED_PWM_CTRL2);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
> +			pwm->label, ret);
> +		return;
> +	}
> +
> +	val &= ~PWM_CTRL2_MODE_MASK;
> +	val |= PWM_CTRL2_MODE_HW;
> +
> +	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, val, LED_PWM_CTRL2);
> +	if (ret < 0) {
> +		dev_err(chip->dev, "%s: Failed to disable PWM, Error %d\n",
> +			pwm->label, ret);
> +	}
> +}
> +
> +static const struct pwm_ops twl6030_pwm_ops = {
> +	.request = twl6030_pwm_request,
> +	.config = twl6030_pwm_config,
> +	.enable = twl6030_pwm_enable,
> +	.disable = twl6030_pwm_disable,
> +};
> +
> +static int twl6030_pwm_probe(struct platform_device *pdev)
> +{
> +	struct twl6030_pwm_chip *twl6030;
> +	int ret;
> +
> +	twl6030 = devm_kzalloc(&pdev->dev, sizeof(*twl6030), GFP_KERNEL);
> +	if (!twl6030)
> +		return -ENOMEM;
> +
> +	twl6030->chip.dev = &pdev->dev;
> +	twl6030->chip.ops = &twl6030_pwm_ops;
> +	twl6030->chip.base = -1;
> +	twl6030->chip.npwm = 1;
> +
> +	ret = pwmchip_add(&twl6030->chip);
> +	if (ret < 0)
> +		return ret;
> +
> +	platform_set_drvdata(pdev, twl6030);
> +
> +	return 0;
> +}
> +
> +static int twl6030_pwm_remove(struct platform_device *pdev)
> +{
> +	struct twl6030_pwm_chip *twl6030 = platform_get_drvdata(pdev);
> +
> +	return pwmchip_remove(&twl6030->chip);
> +}
> +
> +static struct platform_driver twl6030_pwm_driver = {
> +	.driver = {
> +		.name = "twl6030-pwm",
> +	},
> +	.probe = twl6030_pwm_probe,
> +	.remove = __devexit_p(twl6030_pwm_remove),
> +};
> +module_platform_driver(twl6030_pwm_driver);
> +
> +MODULE_ALIAS("platform:twl6030-pwm");
> +MODULE_LICENSE("GPL");
> 


-- 
Péter
