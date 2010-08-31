Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0HaJ36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 05:29:58 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:56158 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962Ab0HaJ34 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 05:29:56 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Arun MURTHY <arun.murthy@stericsson.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "riku.voipio@iki.fi" <riku.voipio@iki.fi>,
        "mike@compulab.co.il" <mike@compulab.co.il>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>
Date: Tue, 31 Aug 2010 11:29:06 +0200
Subject: RE: [PATCH v2] u8500: ab8500-pwm: Add pwm driver
Thread-Topic: [PATCH v2] u8500: ab8500-pwm: Add pwm driver
Thread-Index: ActIM2hTjyDL1Ng1ScWVahF6+cL/bAAu3+Nw
Message-ID: <F45880696056844FA6A73F415B568C694ED9BE4C50@EXDCVYMBSTM006.EQ1STM.local>
References: <1283166387-19296-1-git-send-email-arun.murthy@stericsson.com>
 <1283166387-19296-2-git-send-email-arun.murthy@stericsson.com>
In-Reply-To: <1283166387-19296-2-git-send-email-arun.murthy@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any comments?

> -----Original Message-----
> From: Arun MURTHY
> Sent: Monday, August 30, 2010 4:36 PM
> To: sameo@linux.intel.com; riku.voipio@iki.fi; mike@compulab.co.il
> Cc: linux-kernel@vger.kernel.org; STEricsson_nomadik_linux; Arun MURTHY
> Subject: [PATCH v2] u8500: ab8500-pwm: Add pwm driver
> 
> This patch adds a Pulse Width Modulation driver for Analog Baseband
> Chip AB8500.
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/misc/Kconfig      |    9 ++
>  drivers/misc/Makefile     |    1 +
>  drivers/misc/ab8500-pwm.c |  195
> +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 205 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/ab8500-pwm.c
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 9df5b75..fcf2e7f 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -62,6 +62,15 @@ config ATMEL_PWM
>  	  purposes including software controlled power-efficient
> backlights
>  	  on LCD displays, motor control, and waveform generation.
> 
> +config AB8500_PWM
> +	bool "AB8500 PWM support"
> +	depends on AB8500_CORE
> +	select HAVE_PWM
> +	help
> +	  This driver exports functions to enable/disble/config/free
> Pulse
> +	  Width Modulation in the Ananlog Baseband Chip AB8500.
> +	  It is used by led and backlight driver to control the
> intensity.
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
> +
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
> +
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
> +	return 0;
> +}
> +
> +static int __devexit ab8500_pwm_remove(struct platform_device *pdev)
> +{
> +	dev = NULL;
> +	dev_info(&pdev->dev, "pwm driver removed\n");
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
> --
> 1.7.2.dirty

