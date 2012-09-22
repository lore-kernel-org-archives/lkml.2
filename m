Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2IVDzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 23:55:55 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:53173 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab2IVDzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 23:55:53 -0400
From: guanxuetao@mprc.pku.edu.cn
Message-ID: <50867.162.105.203.8.1348282729.squirrel@mprc.pku.edu.cn>
In-Reply-To: <1347956633-15667-6-git-send-email-thierry.reding@avionic-design.de>
References: <1347956633-15667-1-git-send-email-thierry.reding@avionic-design.de>
    <1347956633-15667-6-git-send-email-thierry.reding@avionic-design.de>
Date: Sat, 22 Sep 2012 10:58:49 +0800 (CST)
Subject: Re: [PATCH v2 5/5] pwm: Move PUV3 PWM driver to PWM framework
To: "Thierry Reding" <thierry.reding@avionic-design.de>
Cc: "Guan Xuetao" <gxt@mprc.pku.edu.cn>, "Qin Rui" <qinrui@mprc.pku.edu.cn>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el5
MIME-Version: 1.0
Content-Type: text/plain;charset=GB2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This commit moves the driver to drivers/pwm and converts it to the new
> PWM framework.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Tested-by: Qin Rui <qinrui@mprc.pku.edu.cn>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Thanks & Regards,
Guan Xuetao


> ---
>  arch/unicore32/Kconfig         |  12 +--
>  arch/unicore32/kernel/Makefile |   1 -
>  arch/unicore32/kernel/pwm.c    | 219
> -----------------------------------------
>  drivers/pwm/Kconfig            |  10 +-
>  drivers/pwm/Makefile           |   1 +
>  drivers/pwm/pwm-puv3.c         | 161 ++++++++++++++++++++++++++++++
>  6 files changed, 173 insertions(+), 231 deletions(-)
>  delete mode 100644 arch/unicore32/kernel/pwm.c
>  create mode 100644 drivers/pwm/pwm-puv3.c
>
> diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
> index b0a4743..91e2037 100644
> --- a/arch/unicore32/Kconfig
> +++ b/arch/unicore32/Kconfig
> @@ -20,9 +20,6 @@ config UNICORE32
>  	  designs licensed by PKUnity Ltd.
>  	  Please see web page at <http://www.pkunity.com/>.
>
> -config HAVE_PWM
> -	bool
> -
>  config GENERIC_GPIO
>  	def_bool y
>
> @@ -105,7 +102,8 @@ config PUV3_DB0913
>
>  config PUV3_NB0916
>  	bool "NetBook board (0916)"
> -	select HAVE_PWM
> +	select PWM
> +	select PWM_PUV3
>
>  config PUV3_SMW0919
>  	bool "Security Mini-Workstation board (0919)"
> @@ -219,12 +217,6 @@ config PUV3_GPIO
>  	select GPIO_SYSFS if EXPERIMENTAL
>  	default y
>
> -config PUV3_PWM
> -	tristate
> -	default BACKLIGHT_PWM
> -	help
> -	  Enable support for NB0916 PWM controllers
> -
>  if PUV3_NB0916
>
>  menu "PKUnity NetBook-0916 Features"
> diff --git a/arch/unicore32/kernel/Makefile
> b/arch/unicore32/kernel/Makefile
> index 3240101..fa497e0 100644
> --- a/arch/unicore32/kernel/Makefile
> +++ b/arch/unicore32/kernel/Makefile
> @@ -16,7 +16,6 @@ obj-$(CONFIG_UNICORE_FPU_F64)	+= fpu-ucf64.o
>  obj-$(CONFIG_ARCH_PUV3)		+= clock.o irq.o time.o
>
>  obj-$(CONFIG_PUV3_GPIO)		+= gpio.o
> -obj-$(CONFIG_PUV3_PWM)		+= pwm.o
>  obj-$(CONFIG_PUV3_PM)		+= pm.o sleep.o
>  obj-$(CONFIG_HIBERNATION)	+= hibernate.o hibernate_asm.o
>
> diff --git a/arch/unicore32/kernel/pwm.c b/arch/unicore32/kernel/pwm.c
> deleted file mode 100644
> index 724e860..0000000
> --- a/arch/unicore32/kernel/pwm.c
> +++ /dev/null
> @@ -1,219 +0,0 @@
> -/*
> - * linux/arch/unicore32/kernel/pwm.c
> - *
> - * Code specific to PKUnity SoC and UniCore ISA
> - *
> - *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
> - *	Copyright (C) 2001-2010 Guan Xuetao
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> -#include <linux/platform_device.h>
> -#include <linux/slab.h>
> -#include <linux/err.h>
> -#include <linux/clk.h>
> -#include <linux/io.h>
> -#include <linux/pwm.h>
> -
> -#include <asm/div64.h>
> -#include <mach/hardware.h>
> -
> -struct pwm_device {
> -	struct list_head	node;
> -	struct platform_device *pdev;
> -
> -	void __iomem	*base;
> -
> -	const char	*label;
> -	struct clk	*clk;
> -	int		clk_enabled;
> -
> -	unsigned int	use_count;
> -	unsigned int	pwm_id;
> -};
> -
> -/*
> - * period_ns = 10^9 * (PRESCALE + 1) * (PV + 1) / PWM_CLK_RATE
> - * duty_ns   = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
> - */
> -int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> -{
> -	unsigned long long c;
> -	unsigned long period_cycles, prescale, pv, dc;
> -
> -	if (pwm == NULL || period_ns == 0 || duty_ns > period_ns)
> -		return -EINVAL;
> -
> -	c = clk_get_rate(pwm->clk);
> -	c = c * period_ns;
> -	do_div(c, 1000000000);
> -	period_cycles = c;
> -
> -	if (period_cycles < 1)
> -		period_cycles = 1;
> -	prescale = (period_cycles - 1) / 1024;
> -	pv = period_cycles / (prescale + 1) - 1;
> -
> -	if (prescale > 63)
> -		return -EINVAL;
> -
> -	if (duty_ns == period_ns)
> -		dc = OST_PWMDCCR_FDCYCLE;
> -	else
> -		dc = (pv + 1) * duty_ns / period_ns;
> -
> -	/* NOTE: the clock to PWM has to be enabled first
> -	 * before writing to the registers
> -	 */
> -	clk_enable(pwm->clk);
> -
> -	writel(prescale, pwm->base + OST_PWM_PWCR);
> -	writel(pv - dc, pwm->base + OST_PWM_DCCR);
> -	writel(pv, pwm->base + OST_PWM_PCR);
> -
> -	clk_disable(pwm->clk);
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(pwm_config);
> -
> -int pwm_enable(struct pwm_device *pwm)
> -{
> -	int rc = 0;
> -
> -	if (!pwm->clk_enabled) {
> -		rc = clk_enable(pwm->clk);
> -		if (!rc)
> -			pwm->clk_enabled = 1;
> -	}
> -	return rc;
> -}
> -EXPORT_SYMBOL(pwm_enable);
> -
> -void pwm_disable(struct pwm_device *pwm)
> -{
> -	if (pwm->clk_enabled) {
> -		clk_disable(pwm->clk);
> -		pwm->clk_enabled = 0;
> -	}
> -}
> -EXPORT_SYMBOL(pwm_disable);
> -
> -static DEFINE_MUTEX(pwm_lock);
> -static LIST_HEAD(pwm_list);
> -
> -struct pwm_device *pwm_request(int pwm_id, const char *label)
> -{
> -	struct pwm_device *pwm;
> -	int found = 0;
> -
> -	mutex_lock(&pwm_lock);
> -
> -	list_for_each_entry(pwm, &pwm_list, node) {
> -		if (pwm->pwm_id == pwm_id) {
> -			found = 1;
> -			break;
> -		}
> -	}
> -
> -	if (found) {
> -		if (pwm->use_count == 0) {
> -			pwm->use_count++;
> -			pwm->label = label;
> -		} else
> -			pwm = ERR_PTR(-EBUSY);
> -	} else
> -		pwm = ERR_PTR(-ENOENT);
> -
> -	mutex_unlock(&pwm_lock);
> -	return pwm;
> -}
> -EXPORT_SYMBOL(pwm_request);
> -
> -void pwm_free(struct pwm_device *pwm)
> -{
> -	mutex_lock(&pwm_lock);
> -
> -	if (pwm->use_count) {
> -		pwm->use_count--;
> -		pwm->label = NULL;
> -	} else
> -		pr_warning("PWM device already freed\n");
> -
> -	mutex_unlock(&pwm_lock);
> -}
> -EXPORT_SYMBOL(pwm_free);
> -
> -static inline void __add_pwm(struct pwm_device *pwm)
> -{
> -	mutex_lock(&pwm_lock);
> -	list_add_tail(&pwm->node, &pwm_list);
> -	mutex_unlock(&pwm_lock);
> -}
> -
> -static int __devinit pwm_probe(struct platform_device *pdev)
> -{
> -	struct pwm_device *pwm;
> -	struct resource *r;
> -
> -	pwm = devm_kzalloc(&pdev->dev, sizeof(struct pwm_device), GFP_KERNEL);
> -	if (pwm == NULL) {
> -		dev_err(&pdev->dev, "failed to allocate memory\n");
> -		return -ENOMEM;
> -	}
> -
> -	pwm->clk = devm_clk_get(&pdev->dev, "OST_CLK");
> -	if (IS_ERR(pwm->clk))
> -		return PTR_ERR(pwm->clk);
> -
> -	pwm->clk_enabled = 0;
> -
> -	pwm->use_count = 0;
> -	pwm->pwm_id = pdev->id;
> -	pwm->pdev = pdev;
> -
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (r == NULL) {
> -		dev_err(&pdev->dev, "no memory resource defined\n");
> -		return -ENODEV;
> -	}
> -
> -	pwm->base = devm_request_and_ioremap(&pdev->dev, r);
> -	if (pwm->base == NULL)
> -		return -EADDRNOTAVAIL;
> -
> -	__add_pwm(pwm);
> -	platform_set_drvdata(pdev, pwm);
> -	return 0;
> -}
> -
> -static int __devexit pwm_remove(struct platform_device *pdev)
> -{
> -	struct pwm_device *pwm;
> -
> -	pwm = platform_get_drvdata(pdev);
> -	if (pwm == NULL)
> -		return -ENODEV;
> -
> -	mutex_lock(&pwm_lock);
> -	list_del(&pwm->node);
> -	mutex_unlock(&pwm_lock);
> -
> -	return 0;
> -}
> -
> -static struct platform_driver puv3_pwm_driver = {
> -	.driver		= {
> -		.name	= "PKUnity-v3-PWM",
> -	},
> -	.probe		= pwm_probe,
> -	.remove		= __devexit_p(pwm_remove),
> -};
> -module_platform_driver(puv3_pwm_driver);
> -
> -MODULE_LICENSE("GPL v2");
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 5c663df..007c225 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -1,6 +1,5 @@
>  menuconfig PWM
>  	bool "Pulse-Width Modulation (PWM) Support"
> -	depends on !PUV3_PWM
>  	help
>  	  Generic Pulse-Width Modulation (PWM) support.
>
> @@ -77,6 +76,15 @@ config PWM_MXS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-mxs.
>
> +config PWM_PUV3
> +	tristate "PKUnity NetBook-0916 PWM support"
> +	depends on ARCH_PUV3
> +	help
> +	  Generic PWM framework driver for PKUnity NetBook-0916.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-puv3.
> +
>  config PWM_PXA
>  	tristate "PXA PWM support"
>  	depends on ARCH_PXA
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index a1d6169..c8e521b 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -4,6 +4,7 @@ obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
>  obj-$(CONFIG_PWM_JZ4740)	+= pwm-jz4740.o
>  obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
>  obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
> +obj-$(CONFIG_PWM_PUV3)		+= pwm-puv3.o
>  obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
>  obj-$(CONFIG_PWM_TEGRA)		+= pwm-tegra.o
> diff --git a/drivers/pwm/pwm-puv3.c b/drivers/pwm/pwm-puv3.c
> new file mode 100644
> index 0000000..2a93f37
> --- /dev/null
> +++ b/drivers/pwm/pwm-puv3.c
> @@ -0,0 +1,161 @@
> +/*
> + * linux/arch/unicore32/kernel/pwm.c
> + *
> + * Code specific to PKUnity SoC and UniCore ISA
> + *
> + *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
> + *	Copyright (C) 2001-2010 Guan Xuetao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/pwm.h>
> +
> +#include <asm/div64.h>
> +#include <mach/hardware.h>
> +
> +struct puv3_pwm_chip {
> +	struct pwm_chip chip;
> +	void __iomem *base;
> +	struct clk *clk;
> +	bool enabled;
> +};
> +
> +static inline struct puv3_pwm_chip *to_puv3(struct pwm_chip *chip)
> +{
> +	return container_of(chip, struct puv3_pwm_chip, chip);
> +}
> +
> +/*
> + * period_ns = 10^9 * (PRESCALE + 1) * (PV + 1) / PWM_CLK_RATE
> + * duty_ns   = 10^9 * (PRESCALE + 1) * DC / PWM_CLK_RATE
> + */
> +static int puv3_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			   int duty_ns, int period_ns)
> +{
> +	unsigned long period_cycles, prescale, pv, dc;
> +	struct puv3_pwm_chip *puv3 = to_puv3(chip);
> +	unsigned long long c;
> +
> +	c = clk_get_rate(puv3->clk);
> +	c = c * period_ns;
> +	do_div(c, 1000000000);
> +	period_cycles = c;
> +
> +	if (period_cycles < 1)
> +		period_cycles = 1;
> +
> +	prescale = (period_cycles - 1) / 1024;
> +	pv = period_cycles / (prescale + 1) - 1;
> +
> +	if (prescale > 63)
> +		return -EINVAL;
> +
> +	if (duty_ns == period_ns)
> +		dc = OST_PWMDCCR_FDCYCLE;
> +	else
> +		dc = (pv + 1) * duty_ns / period_ns;
> +
> +	/*
> +	 * NOTE: the clock to PWM has to be enabled first
> +	 * before writing to the registers
> +	 */
> +	clk_prepare_enable(puv3->clk);
> +
> +	writel(prescale, puv3->base + OST_PWM_PWCR);
> +	writel(pv - dc, puv3->base + OST_PWM_DCCR);
> +	writel(pv, puv3->base + OST_PWM_PCR);
> +
> +	clk_disable_unprepare(puv3->clk);
> +
> +	return 0;
> +}
> +
> +static int puv3_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct puv3_pwm_chip *puv3 = to_puv3(chip);
> +
> +	return clk_prepare_enable(puv3->clk);
> +}
> +
> +static void puv3_pwm_disable(struct pwm_chip *chip, struct pwm_device
> *pwm)
> +{
> +	struct puv3_pwm_chip *puv3 = to_puv3(chip);
> +
> +	clk_disable_unprepare(puv3->clk);
> +}
> +
> +static const struct pwm_ops puv3_pwm_ops = {
> +	.config = puv3_pwm_config,
> +	.enable = puv3_pwm_enable,
> +	.disable = puv3_pwm_disable,
> +	.owner = THIS_MODULE,
> +};
> +
> +static int __devinit pwm_probe(struct platform_device *pdev)
> +{
> +	struct puv3_pwm_chip *puv3;
> +	struct resource *r;
> +	int ret;
> +
> +	puv3 = devm_kzalloc(&pdev->dev, sizeof(*puv3), GFP_KERNEL);
> +	if (puv3 == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	puv3->clk = devm_clk_get(&pdev->dev, "OST_CLK");
> +	if (IS_ERR(puv3->clk))
> +		return PTR_ERR(puv3->clk);
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (r == NULL) {
> +		dev_err(&pdev->dev, "no memory resource defined\n");
> +		return -ENODEV;
> +	}
> +
> +	puv3->base = devm_request_and_ioremap(&pdev->dev, r);
> +	if (puv3->base == NULL)
> +		return -EADDRNOTAVAIL;
> +
> +	puv3->chip.dev = &pdev->dev;
> +	puv3->chip.ops = &puv3_pwm_ops;
> +	puv3->chip.base = -1;
> +	puv3->chip.npwm = 1;
> +
> +	ret = pwmchip_add(&puv3->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, puv3);
> +	return 0;
> +}
> +
> +static int __devexit pwm_remove(struct platform_device *pdev)
> +{
> +	struct puv3_pwm_chip *puv3 = platform_get_drvdata(pdev);
> +
> +	return pwmchip_remove(&puv3->chip);
> +}
> +
> +static struct platform_driver puv3_pwm_driver = {
> +	.driver = {
> +		.name = "PKUnity-v3-PWM",
> +	},
> +	.probe = pwm_probe,
> +	.remove = __devexit_p(pwm_remove),
> +};
> +module_platform_driver(puv3_pwm_driver);
> +
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.12
>

