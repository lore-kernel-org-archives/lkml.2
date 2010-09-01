Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0IAFUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 01:20:48 -0400
Received: from compulab.co.il ([67.18.134.219]:42514 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0IAFUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 01:20:47 -0400
Message-ID: <4C7DE26B.7050304@compulab.co.il>
Date: Wed, 01 Sep 2010 08:19:39 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Arun Murthy <arun.murthy@stericsson.com>
CC: sameo@linux.intel.com, riku.voipio@iki.fi, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v2] u8500: ab8500-pwm: Add pwm driver
References: <1283166387-19296-1-git-send-email-arun.murthy@stericsson.com> <1283166387-19296-2-git-send-email-arun.murthy@stericsson.com>
In-Reply-To: <1283166387-19296-2-git-send-email-arun.murthy@stericsson.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arun Murthy wrote:
> This patch adds a Pulse Width Modulation driver for Analog Baseband
> Chip AB8500.
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/misc/Kconfig      |    9 ++
>  drivers/misc/Makefile     |    1 +
>  drivers/misc/ab8500-pwm.c |  195 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 205 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/ab8500-pwm.c
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 9df5b75..fcf2e7f 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -62,6 +62,15 @@ config ATMEL_PWM
>  	  purposes including software controlled power-efficient backlights
>  	  on LCD displays, motor control, and waveform generation.
>  
> +config AB8500_PWM
> +	bool "AB8500 PWM support"
> +	depends on AB8500_CORE
> +	select HAVE_PWM
> +	help
> +	  This driver exports functions to enable/disble/config/free Pulse
> +	  Width Modulation in the Ananlog Baseband Chip AB8500.
> +	  It is used by led and backlight driver to control the intensity.
> +
>  config ATMEL_TCLIB
>  	bool "Atmel AT32/AT91 Timer/Counter Library"
>  	depends on (AVR32 || ARCH_AT91)
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 255a80d..33bc441 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -35,3 +35,4 @@ obj-y				+= eeprom/
>  obj-y				+= cb710/
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
>  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
> +obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
> diff --git a/drivers/misc/ab8500-pwm.c b/drivers/misc/ab8500-pwm.c
> new file mode 100644
> index 0000000..258a2be
> --- /dev/null
> +++ b/drivers/misc/ab8500-pwm.c
> @@ -0,0 +1,195 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2010
> + *
> + * Author: Arun R Murthy <arun.murthy@stericsson.com>
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/pwm.h>
> +#include <linux/mfd/ab8500.h>
> +#include <linux/mfd/abx500.h>
> +
> +/*
> + * PWM Out generators
> + * Bank: 0x10
> + */
> +#define AB8500_PWM_OUT_CTRL1_REG	0x60
> +#define AB8500_PWM_OUT_CTRL2_REG	0x61
> +#define AB8500_PWM_OUT_CTRL3_REG	0x62
> +#define AB8500_PWM_OUT_CTRL4_REG	0x63
> +#define AB8500_PWM_OUT_CTRL5_REG	0x64
> +#define AB8500_PWM_OUT_CTRL6_REG	0x65
> +#define AB8500_PWM_OUT_CTRL7_REG	0x66
> +
> +/* backlight driver constants */
> +#define ENABLE_PWM			1
> +#define DISABLE_PWM			0
> +
> +static struct device *dev;

Is the static device pointer really necessary? Shouldn't it be encapsulated to 
the driver info structure that is allocated during probe?

> +struct pwm_device {
> +	const char *label;
> +	unsigned int pwm_id;
> +};
> +
> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> +{
> +	int ret = 0;
> +	unsigned int higher_val, lower_val, pwm_val;
> +
> +	if (!dev)
> +		return -EAGAIN;
> +	/*
> +	 * get the first 8 bits that are be written to
> +	 * AB8500_PWM_OUT_CTRL1_REG[0:7]
> +	 */
> +	lower_val = duty_ns & 0x00FF;
> +	/*
> +	 * get bits [9:10] that are to be written to
> +	 * AB8500_PWM_OUT_CTRL2_REG[0:1]
> +	 */
> +	higher_val = ((duty_ns & 0x0300) >> 8);
> +	switch (pwm->pwm_id) {
> +	case 1:
> +		/* pwm-1 */
> +		ret = abx500_set_register_interruptible(dev,
> +					AB8500_MISC, AB8500_PWM_OUT_CTRL1_REG,
> +					(u8)lower_val);
> +		if (ret < 0)
> +			return ret;
> +		ret = abx500_set_register_interruptible(dev,
> +					AB8500_MISC, AB8500_PWM_OUT_CTRL2_REG,
> +					(u8)higher_val);
> +		break;
> +	case 2:
> +		/* pwm-2 */
> +		ret = abx500_set_register_interruptible(dev,
> +					AB8500_MISC, AB8500_PWM_OUT_CTRL3_REG,
> +					(u8)lower_val);
> +		if (ret < 0)
> +			return ret;
> +		ret = abx500_set_register_interruptible(dev,
> +					AB8500_MISC, AB8500_PWM_OUT_CTRL4_REG,
> +					(u8)higher_val);
> +		break;
> +	case 3:
> +		/* pwm-3 */
> +		ret = abx500_set_register_interruptible(dev,
> +					AB8500_MISC, AB8500_PWM_OUT_CTRL5_REG,
> +					(u8)lower_val);
> +		if (ret < 0)
> +			return ret;
> +		ret = abx500_set_register_interruptible(dev,
> +					AB8500_MISC, AB8500_PWM_OUT_CTRL6_REG,
> +					(u8)higher_val);
> +		break;
> +	default:
> +		dev_err(dev, "%s: invalid pwm entry = %d\n", __func__,
> +								pwm->pwm_id);
> +		return -EINVAL;
> +	}

You can calculate the register address from the pwm_id and then the switch is 
not needed, e.g.

reg = AB8500_PWM_OUT_CTRL1_REG + (pwm->pwm_id - 1) * 2;
ret = abx500_set_register_interruptible(dev, AB8500_MISC, reg,
					(u8)lower_val);
if (ret < 0)
	return ret;
ret = abx500_set_register_interruptible(dev, AB8500_MISC, reg + 1,
					(u8)higher_val);


> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_config);
> +
> +int pwm_enable(struct pwm_device *pwm)
> +{
> +	int ret;
> +
> +	if (!dev)
> +		return -EAGAIN;
> +
> +	ret = abx500_mask_and_set_register_interruptible(dev,
> +				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
> +				1 << (pwm->pwm_id-1), ENABLE_PWM);
> +	if (ret < 0)
> +		dev_err(dev, "%s: Failed to disable PWM, Error %d\n",
> +							pwm->label, ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_enable);
> +
> +void pwm_disable(struct pwm_device *pwm)
> +{
> +	int ret;
> +
> +	ret = abx500_mask_and_set_register_interruptible(dev,
> +				AB8500_MISC, AB8500_PWM_OUT_CTRL7_REG,
> +				1 << (pwm->pwm_id-1), DISABLE_PWM);
> +	if (ret < 0)
> +		dev_err(dev, "%s: Failed to disable PWM, Error %d\n",
> +							pwm->label, ret);
> +	return;
> +}
> +EXPORT_SYMBOL(pwm_disable);
> +
> +struct pwm_device *pwm_request(int pwm_id, const char *label)
> +{
> +	struct pwm_device *pwm;
> +
> +	pwm = kzalloc(sizeof(struct pwm_device), GFP_KERNEL);
> +	if (pwm == NULL) {
> +		dev_err(dev, "%s: failed to allocate memory\n", label);
> +		return NULL;
> +	}
> +
> +	pwm->label = label;
> +	pwm->pwm_id = pwm_id;
> +
> +	return pwm;
> +}
> +EXPORT_SYMBOL(pwm_request);
> +
> +void pwm_free(struct pwm_device *pwm)
> +{
> +	pwm_disable(pwm);
> +	kfree(pwm);
> +}
> +EXPORT_SYMBOL(pwm_free);
> +
> +static int __devinit ab8500_pwm_probe(struct platform_device *pdev)
> +{
> +	/*
> +	 * Nothing to be done in probe, this is required to get the
> +	 * device which is required for ab8500 read and write
> +	 */
> +	dev = &pdev->dev;
> +	dev_info(dev, "pwm probe successful\n");

dev_debug?

> +	return 0;
> +}
> +
> +static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
> +{
> +	dev = NULL;
> +	dev_info(&pdev->dev, "pwm driver removed\n");

dev_debug?

> +	return 0;
> +}
> +
> +static struct platform_driver ab8500_pwm_driver = {
> +	.driver = {
> +		.name = "ab8500-pwm",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = ab8500_pwm_probe,
> +	.remove = __devexit_p(ab8500_pwm_remove),
> +};
> +
> +static int __init ab8500_pwm_init(void)
> +{
> +	return platform_driver_register(&ab8500_pwm_driver);
> +}
> +
> +static void __exit ab8500_pwm_exit(void)
> +{
> +	platform_driver_unregister(&ab8500_pwm_driver);
> +}
> +
> +subsys_initcall(ab8500_pwm_init);
> +module_exit(ab8500_pwm_exit);
> +MODULE_AUTHOR("Arun MURTHY <arun.murthy@stericsson.com>");
> +MODULE_DESCRIPTION("AB8500 Pulse Width Modulation Driver");
> +MODULE_ALIAS("AB8500 PWM driver");
> +MODULE_LICENSE("GPL v2");


-- 
Sincerely yours,
Mike.
