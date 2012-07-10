Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2GJPHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:07:34 -0400
Received: from antcom.de ([188.40.178.216]:51633 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab2GJPHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:07:30 -0400
Message-ID: <4FFC4530.3030307@antcom.de>
Date: Tue, 10 Jul 2012 17:07:28 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] PWM: add lpc32xx PWM support
References: <1341931090-18296-1-git-send-email-aletes.xgr@gmail.com>
In-Reply-To: <1341931090-18296-1-git-send-email-aletes.xgr@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 04:38 PM, Alexandre Pereira da Silva wrote:
> Add lpc32xx SOC PWM driver.
> 
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

Acked-by: Roland Stigge <stigge@antcom.de>

> ---
> Changes since v2:
> * Update commit message
> * Change the driver to handle the two PWM's of the SOC
> * Disable clock on removal
> 
> Changes since v1:
> * Style fixes
> * Better error handling
> * Improved Kconfig and DT descriptions
> 
>  .../devicetree/bindings/pwm/lpc32xx-pwm.txt        |   12 ++
>  drivers/pwm/Kconfig                                |   10 ++
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-lpc32xx.c                          |  148 ++++++++++++++++++++
>  4 files changed, 171 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
>  create mode 100644 drivers/pwm/pwm-lpc32xx.c
> 
> diff --git a/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
> new file mode 100644
> index 0000000..cfe1db3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/lpc32xx-pwm.txt
> @@ -0,0 +1,12 @@
> +LPC32XX PWM controller
> +
> +Required properties:
> +- compatible: should be "nxp,lpc3220-pwm"
> +- reg: physical base address and length of the controller's registers
> +
> +Examples:
> +
> +pwm@0x4005C000 {
> +	compatible = "nxp,lpc3220-pwm";
> +	reg = <0x4005C000 0x8>;
> +};
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 0b2800f..94e176e 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -28,6 +28,16 @@ config PWM_IMX
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called pwm-imx.
>  
> +config PWM_LPC32XX
> +	tristate "LPC32XX PWM support"
> +	depends on ARCH_LPC32XX
> +	help
> +	  Generic PWM framework driver for LPC32XX. The LPC32XX SOC has two
> +	  PWM controllers.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called pwm-lpc32xx.
> +
>  config PWM_MXS
>  	tristate "Freescale MXS PWM support"
>  	depends on ARCH_MXS && OF
> diff --git a/drivers/pwm/Makefile b/drivers/pwm/Makefile
> index cec2500..5459702 100644
> --- a/drivers/pwm/Makefile
> +++ b/drivers/pwm/Makefile
> @@ -1,6 +1,7 @@
>  obj-$(CONFIG_PWM)		+= core.o
>  obj-$(CONFIG_PWM_BFIN)		+= pwm-bfin.o
>  obj-$(CONFIG_PWM_IMX)		+= pwm-imx.o
> +obj-$(CONFIG_PWM_LPC32XX)	+= pwm-lpc32xx.o
>  obj-$(CONFIG_PWM_MXS)		+= pwm-mxs.o
>  obj-$(CONFIG_PWM_PXA)		+= pwm-pxa.o
>  obj-$(CONFIG_PWM_SAMSUNG)	+= pwm-samsung.o
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> new file mode 100644
> index 0000000..adb87f0
> --- /dev/null
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -0,0 +1,148 @@
> +/*
> + * Copyright 2012 Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2.
> + *
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/pwm.h>
> +#include <linux/slab.h>
> +
> +struct lpc32xx_pwm_chip {
> +	struct pwm_chip chip;
> +	struct clk *clk;
> +	void __iomem *base;
> +};
> +
> +#define PWM_ENABLE	(1 << 31)
> +#define PWM_RELOADV(x)	(((x) & 0xFF) << 8)
> +#define PWM_DUTY(x)	((x) & 0xFF)
> +
> +#define to_lpc32xx_pwm_chip(_chip) \
> +	container_of(_chip, struct lpc32xx_pwm_chip, chip)
> +
> +static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
> +			      int duty_ns, int period_ns)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
> +	unsigned long long c;
> +	int period_cycles, duty_cycles;
> +
> +	c = clk_get_rate(lpc32xx->clk) / 256;
> +	c = c * period_ns;
> +	do_div(c, NSEC_PER_SEC);
> +
> +	/* Handle high and low extremes */
> +	if (c == 0)
> +		c = 1;
> +	if (c > 255)
> +		c = 0; /* 0 set division by 256 */
> +	period_cycles = c;
> +
> +	c = 256 * duty_ns;
> +	do_div(c, period_ns);
> +	duty_cycles = c;
> +
> +	writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
> +		lpc32xx->base + (pwm->hwpwm << 2));
> +
> +	return 0;
> +}
> +
> +static int lpc32xx_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
> +
> +	return clk_enable(lpc32xx->clk);
> +}
> +
> +static void lpc32xx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx = to_lpc32xx_pwm_chip(chip);
> +
> +	writel(0, lpc32xx->base + (pwm->hwpwm << 2));
> +	clk_disable(lpc32xx->clk);
> +}
> +
> +static const struct pwm_ops lpc32xx_pwm_ops = {
> +	.config = lpc32xx_pwm_config,
> +	.enable = lpc32xx_pwm_enable,
> +	.disable = lpc32xx_pwm_disable,
> +	.owner = THIS_MODULE,
> +};
> +
> +static int lpc32xx_pwm_probe(struct platform_device *pdev)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx;
> +	struct resource *res;
> +	int ret;
> +
> +	lpc32xx = devm_kzalloc(&pdev->dev, sizeof(*lpc32xx), GFP_KERNEL);
> +	if (!lpc32xx)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -EINVAL;
> +
> +	lpc32xx->base = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!lpc32xx->base)
> +		return -EADDRNOTAVAIL;
> +
> +	lpc32xx->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(lpc32xx->clk))
> +		return PTR_ERR(lpc32xx->clk);
> +
> +	lpc32xx->chip.dev = &pdev->dev;
> +	lpc32xx->chip.ops = &lpc32xx_pwm_ops;
> +	lpc32xx->chip.npwm = 2;
> +
> +	ret = pwmchip_add(&lpc32xx->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip, error %d\n", ret);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, lpc32xx);
> +
> +	return 0;
> +}
> +
> +static int __devexit lpc32xx_pwm_remove(struct platform_device *pdev)
> +{
> +	struct lpc32xx_pwm_chip *lpc32xx = platform_get_drvdata(pdev);
> +
> +	clk_disable(lpc32xx->clk);
> +	return pwmchip_remove(&lpc32xx->chip);
> +}
> +
> +static struct of_device_id lpc32xx_pwm_dt_ids[] = {
> +	{ .compatible = "nxp,lpc3220-pwm", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, lpc32xx_pwm_dt_ids);
> +
> +static struct platform_driver lpc32xx_pwm_driver = {
> +	.driver = {
> +		.name = "lpc32xx-pwm",
> +		.of_match_table = of_match_ptr(lpc32xx_pwm_dt_ids),
> +	},
> +	.probe = lpc32xx_pwm_probe,
> +	.remove = __devexit_p(lpc32xx_pwm_remove),
> +};
> +module_platform_driver(lpc32xx_pwm_driver);
> +
> +MODULE_ALIAS("platform:lpc32xx-pwm");
> +MODULE_AUTHOR("Alexandre Pereira da Silva <aletes.xgr@gmail.com>");
> +MODULE_DESCRIPTION("LPC32XX PWM Driver");
> +MODULE_LICENSE("GPL v2");

