Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2HVI3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:29:49 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:10857
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750952Ab2HVI3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:29:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Ic8kzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1155h)
Date: Wed, 22 Aug 2012 16:29:41 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Dong Aisheng <b29396@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linus.walleij@stericsson.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@linaro.org>, <kernel@pengutronix.de>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>,
        <devicetree-discuss@lists.ozlabs.org>, <swarren@wwwdotorg.org>,
        <paul.liu@linaro.org>
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
Message-ID: <20120822082940.GJ4011@b20223-02.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-2-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1345619928-15446-2-git-send-email-b29396@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:18:42PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Add regmap based imx syscon driver.
> This is usually used for access misc bits in registers which does not belong
> to a specific module, for example, IOMUXC GPR and ANATOP.
> With this driver, we provide a standard API for client driver to call to
> access registers which are registered into syscon.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> Currently it's just simply for IMX, however the driver really is not too
> much imx specific.
> If people want, we probably could extend it to support other platforms too.
> ---
>  .../devicetree/bindings/mfd/imx-syscon.txt         |   11 +
>  drivers/mfd/Kconfig                                |    8 +
>  drivers/mfd/Makefile                               |    1 +
>  drivers/mfd/imx-syscon.c                           |  193 ++++++++++++++++++++
>  include/linux/mfd/imx-syscon.h                     |   22 +++
>  5 files changed, 235 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/imx-syscon.txt b/Documentation/devicetree/bindings/mfd/imx-syscon.txt
> new file mode 100644
> index 0000000..4a72994
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/imx-syscon.txt
> @@ -0,0 +1,11 @@
> +* Freescale IMX System Controller Registers R/W driver
> +
> +Required properties:
> +- compatible: Should contain "fsl,imx-syscon".
> +- reg: the register range can be access from imx-syscon
> +
> +Examples:
> +gpr: iomuxc-gpr@020e0000 {
> +	compatible = "fsl,imx6q-iomuxc", "fsl,imx-syscon";
why is it compatible with iomuxc?

> +	reg = <0x020e0000 0x38>;
> +};
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index b1a1462..20a050e 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -993,6 +993,14 @@ config MFD_ANATOP
>  	  MFD controller. This controller embeds regulator and
>  	  thermal devices for Freescale i.MX platforms.
>  
> +config MFD_IMX_SYSCON
> +        bool "Freescale i.MX System Controller Register R/W Based on Regmap"
> +        depends on ARCH_MXC
> +        select REGMAP_MMIO
> +        help
> +          Select this option to enable access Freescale i.MX system control
> +	  registers like iomuxc gpr and anatop via regmap.
> +
>  config MFD_PALMAS
>  	bool "Support for the TI Palmas series chips"
>  	select MFD_CORE
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 79dd22d..82c7ee1 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -131,4 +131,5 @@ obj-$(CONFIG_MFD_PALMAS)	+= palmas.o
>  obj-$(CONFIG_MFD_RC5T583)	+= rc5t583.o rc5t583-irq.o
>  obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
>  obj-$(CONFIG_MFD_ANATOP)	+= anatop-mfd.o
> +obj-$(CONFIG_MFD_IMX_SYSCON)	+= imx-syscon.o
>  obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
> diff --git a/drivers/mfd/imx-syscon.c b/drivers/mfd/imx-syscon.c
> new file mode 100644
> index 0000000..141b456
> --- /dev/null
> +++ b/drivers/mfd/imx-syscon.c
> @@ -0,0 +1,193 @@
> +/*
> + * Freescale IMX System Control Driver
> + *
> + * Copyright (C) 2012 Freescale Semiconductor, Inc.
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +
> +static struct platform_driver imx_syscon_driver;
> +
> +struct imx_syscon {
> +	struct device *dev;
> +	void __iomem *base;
> +	struct regmap *regmap;
> +};
> +
> +static int imx_syscon_match(struct device *dev, void *data)
> +{
> +	struct imx_syscon *syscon = dev_get_drvdata(dev);
> +	struct device_node *dn = data;
> +
> +	return (syscon->dev->of_node == dn) ? 1 : 0;
> +}
> +
> +int imx_syscon_write(struct device_node *np, u32 reg, u32 val)
For API function, is it better to use struct device rather not np?
 - it won't need to search dev in below code every time it access
   registers.
> +{
> +	struct device *dev;
> +	struct imx_syscon *syscon;
> +	int ret = 0;
> +
> +	dev = driver_find_device(&imx_syscon_driver.driver, NULL, np,
> +				 imx_syscon_match);
> +	if (!dev)
> +		return -EPROBE_DEFER;
> +
> +	syscon = dev_get_drvdata(dev);
> +	ret = regmap_write(syscon->regmap, reg, val);
> +	if (ret)
> +		dev_err(dev, "failed to write regmap(%s) reg 0x%x (%d)\n",
> +			np->name, reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(imx_syscon_write);
> +
> +int imx_syscon_read(struct device_node *np, u32 reg, u32 *val)
> +{
> +	struct device *dev;
> +	struct imx_syscon *syscon;
> +	int ret = 0;
> +
> +	dev = driver_find_device(&imx_syscon_driver.driver, NULL, np,
> +				 imx_syscon_match);
> +	if (!dev)
> +		return -EPROBE_DEFER;
> +
> +	syscon = dev_get_drvdata(dev);
> +	ret = regmap_read(syscon->regmap, reg, val);
> +	if (ret)
> +		dev_err(dev, "failed to read regmap(%s) reg 0x%x (%d)\n",
> +			np->name, reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(imx_syscon_read);
> +
> +int imx_syscon_update_bits(struct device_node *np, u32 reg,
> +					u32 mask, u32 val)
> +{
> +	struct device *dev;
> +	struct imx_syscon *syscon;
> +	int ret = 0;
> +
> +	dev = driver_find_device(&imx_syscon_driver.driver, NULL, np,
> +				 imx_syscon_match);
> +	if (!dev)
> +		return -EPROBE_DEFER;
> +
> +	syscon = dev_get_drvdata(dev);
> +	ret = regmap_update_bits(syscon->regmap, reg, mask, val);
> +	if (ret)
> +		dev_err(dev, "failed to update regmap(%s) reg 0x%x (%d)\n",
> +			np->name, reg, ret);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(imx_syscon_update_bits);
> +
> +static const struct of_device_id of_imx_syscon_match[] = {
> +	{ .compatible = "fsl,imx-syscon", },
> +	{ },
> +};
> +
> +static struct regmap_config imx_syscon_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
> +};
> +
> +static int __devinit imx_syscon_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct imx_syscon *syscon;
> +	struct resource res;
> +	int ret;
> +
> +	if (!np)
> +		return -ENOENT;
> +
> +	syscon = devm_kzalloc(&pdev->dev, sizeof(struct imx_syscon),
> +			    GFP_KERNEL);
> +	if (!syscon)
> +		return -ENOMEM;
> +
> +	syscon->base = of_iomap(np, 0);
no request? use devm_request_and_ioremap?

Thanks
Richard

> +	if (!syscon->base)
> +		return -EADDRNOTAVAIL;
> +
> +	ret = of_address_to_resource(np, 0, &res);
> +	if (ret)
> +		return ret;
> +
> +	imx_syscon_regmap_config.max_register = res.end - res.start - 3;
> +	syscon->regmap = devm_regmap_init_mmio(&pdev->dev, syscon->base,
> +					&imx_syscon_regmap_config);
> +	if (IS_ERR(syscon->regmap)) {
> +		dev_err(&pdev->dev, "regmap init failed\n");
> +		return PTR_ERR(syscon->regmap);
> +	}
> +
> +	regcache_cache_only(syscon->regmap, false);
> +
> +	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> +		res.start, res.end);
> +
> +	syscon->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, syscon);
> +
> +	return 0;
> +}
> +
> +static int __devexit imx_syscon_remove(struct platform_device *pdev)
> +{
> +	struct imx_syscon *syscon;
> +
> +	syscon = platform_get_drvdata(pdev);
> +	iounmap(syscon->base);
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver imx_syscon_driver = {
> +	.driver = {
> +		.name = "imx-syscon",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_imx_syscon_match,
> +	},
> +	.probe		= imx_syscon_probe,
> +	.remove		= imx_syscon_remove,
> +};
> +
> +static int __init imx_syscon_init(void)
> +{
> +	return platform_driver_register(&imx_syscon_driver);
> +}
> +postcore_initcall(imx_syscon_init);
> +
> +static void __exit anatop_exit(void)
> +{
> +	platform_driver_unregister(&imx_syscon_driver);
> +}
> +module_exit(anatop_exit);
> +
> +MODULE_AUTHOR("Dong Aisheng <dong.aisheng@linaro.org>");
> +MODULE_DESCRIPTION("Freescale IMX System Control driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/imx-syscon.h b/include/linux/mfd/imx-syscon.h
> new file mode 100644
> index 0000000..be8b6db
> --- /dev/null
> +++ b/include/linux/mfd/imx-syscon.h
> @@ -0,0 +1,22 @@
> +/*
> + * Freescale IMX System Control Driver
> + *
> + * Copyright (C) 2012 Freescale Semiconductor, Inc.
> + * Copyright (C) 2012 Linaro Ltd.
> + *
> + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __LINUX_MFD_IMX_SYSCON_H__
> +#define __LINUX_MFD_IMX_SYSCON_H__
> +
> +extern int imx_syscon_write(struct device_node *np, u32 reg, u32 val);
> +extern int imx_syscon_read(struct device_node *np, u32 reg, u32 *val);
> +extern int imx_syscon_update_bits(struct device_node *np, u32 reg,
> +					u32 mask, u32 val);
> +#endif /* __LINUX_MFD_IMX_SYSCON_H__ */
> -- 
> 1.7.0.4
> 

