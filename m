Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab1I3FFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:05:06 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62780 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1I3FFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:05:02 -0400
Date: Thu, 29 Sep 2011 20:12:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2 v7] pinmux: add a driver for the U300 pinmux
Message-ID: <20110930021239.GL12606@ponder.secretlab.ca>
References: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316175249-10780-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 02:14:09PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This adds a driver for the U300 pinmux portions of the system
> controller "SYSCON". It also serves as an example of how to use
> the pinmux subsystem. This driver also houses the platform data
> for the only supported platform.

Hi Linus, comments below.

> diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
> index 32a7b0f..449fd6a 100644
> --- a/arch/arm/mach-u300/Kconfig
> +++ b/arch/arm/mach-u300/Kconfig
> @@ -6,6 +6,8 @@ comment "ST-Ericsson Mobile Platform Products"
>  
>  config MACH_U300
>  	bool "U300"
> +	select PINCTRL
> +	select PINMUX_U300

Shouldn't PINMUX_U300 select PINCTRL?

> +#include "pinmux-u300.h"

There is only one file that uses this header data.  Just put it into
the .c file.

> +static int __init u300_pmx_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct u300_pmx *upmx;
> +	struct resource *res;
> +
> +	/* Create state holders etc for this driver */
> +	upmx = kzalloc(sizeof(struct u300_pmx), GFP_KERNEL);

devm_kzalloc()

> +	if (!upmx)
> +		return -ENOMEM;
> +
> +	upmx->dev = &pdev->dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		ret = -ENOENT;
> +		goto out_no_resource;
> +	}
> +	upmx->phybase = res->start;
> +	upmx->physize = resource_size(res);
> +
> +	if (request_mem_region(upmx->phybase, upmx->physize,
> +			       DRIVER_NAME) == NULL) {
> +		ret = -EBUSY;
> +		goto out_no_memregion;
> +	}
> +
> +	upmx->virtbase = ioremap(upmx->phybase, upmx->physize);
> +	if (!upmx->virtbase) {
> +		ret = -ENOMEM;
> +		goto out_no_remap;
> +	}
> +
> +	upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
> +	if (IS_ERR(upmx->pctl)) {
> +		dev_err(&pdev->dev, "could not register U300 pinmux driver\n");
> +		ret = PTR_ERR(upmx->pctl);
> +		goto out_no_pmx;
> +	}
> +
> +	/* We will handle a range of GPIO pins */
> +	pinctrl_add_gpio_range(upmx->pctl, &u300_gpio_range);
> +
> +	platform_set_drvdata(pdev, upmx);
> +
> +	u300_pmx_dumpregs(upmx);
> +
> +	dev_info(&pdev->dev, "initialized U300 pinmux driver\n");
> +
> +	return 0;
> +
> +out_no_pmx:
> +	iounmap(upmx->virtbase);
> +out_no_remap:
> +	platform_set_drvdata(pdev, NULL);
> +out_no_memregion:
> +	release_mem_region(upmx->phybase, upmx->physize);
> +out_no_resource:
> +	kfree(upmx);
> +	return ret;
> +}
> +
> +static int __exit u300_pmx_remove(struct platform_device *pdev)

__devexit

> +{
> +	struct u300_pmx *upmx = platform_get_drvdata(pdev);
> +
> +	pinctrl_remove_gpio_range(upmx->pctl, &u300_gpio_range);
> +	pinctrl_unregister(upmx->pctl);
> +	iounmap(upmx->virtbase);
> +	release_mem_region(upmx->phybase, upmx->physize);
> +	platform_set_drvdata(pdev, NULL);
> +	kfree(upmx);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver u300_pmx_driver = {
> +	.driver = {
> +		.name = DRIVER_NAME,
> +		.owner = THIS_MODULE,
> +	},
> +	.remove = __exit_p(u300_pmx_remove),

__devexit_p

