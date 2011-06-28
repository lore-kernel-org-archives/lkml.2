Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab1F1KuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:50:21 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:59277 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab1F1KtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:49:06 -0400
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 06:49:05 EDT
Message-ID: <19977.44219.214485.118656@ipc1.ka-ro>
Date: Tue, 28 Jun 2011 12:28:11 +0200
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ryan Mallon <ryan@bluewatersys.com>, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] pwm: Add a i.MX23/28 pwm driver
In-Reply-To: <1309255368-9775-3-git-send-email-s.hauer@pengutronix.de>
References: <1309255368-9775-1-git-send-email-s.hauer@pengutronix.de>
	<1309255368-9775-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just some nitpicks...

Sascha Hauer writes:
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  drivers/pwm/mxs-pwm.c |  275 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 275 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/pwm/mxs-pwm.c
> 
> diff --git a/drivers/pwm/mxs-pwm.c b/drivers/pwm/mxs-pwm.c
> new file mode 100644
> index 0000000..052cb0c
> --- /dev/null
> +++ b/drivers/pwm/mxs-pwm.c
> @@ -0,0 +1,275 @@
> +/*
> + * Copyright (C) 2011 Pengutronix
> + * Sascha Hauer <s.hauer@pengutronix.de>
> + *
> + * simple driver for PWM (Pulse Width Modulator) controller
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Derived from pxa PWM driver by eric miao <eric.miao@marvell.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/err.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/pwm.h>
> +#include <mach/hardware.h>
> +#include <mach/mxs.h>
> +#include <mach/mx23.h>
> +#include <mach/mx28.h>
> +#include <asm/div64.h>
> +
> +struct mxs_pwm_device {
> +	struct device		*dev;
> +
> +	struct clk	*clk;
> +
> +	int		enabled;
> +	void __iomem	*mmio_base;
> +
> +	unsigned int	pwm_id;
> +
> +	u32		val_active;
> +	u32		val_period;
> +	int		period_us;
> +	struct pwm_chip chip;
> +};
> +
> +/* common register space */
> +static void __iomem *pwm_base_common;
> +#define REG_PWM_CTRL	0x0
> +#define PWM_SFTRST	(1 << 31)
> +#define PWM_CLKGATE	(1 << 30)
> +#define PWM_ENABLE(p)	(1 << (p))
> +
> +/* per pwm register space */
> +#define REG_ACTIVE	0x0
> +#define REG_PERIOD	0x10
> +
> +#define PERIOD_PERIOD(p)	((p) & 0xffff)
> +#define PERIOD_ACTIVE_HIGH	(3 << 16)
> +#define PERIOD_INACTIVE_LOW	(2 << 18)
> +#define PERIOD_CDIV(div)	(((div) & 0x7) << 20)
> +
[...]
> +static int __devinit mxs_pwm_probe(struct platform_device *pdev)
> +{
> +	struct mxs_pwm_device *pwm;
> +	struct resource *r;
> +	int ret = 0;
> +
> +	pwm = devm_kzalloc(&pdev->dev, sizeof(struct mxs_pwm_device), GFP_KERNEL);
> +	if (pwm == NULL) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	pwm->clk = clk_get(&pdev->dev, NULL);
> +
> +	if (IS_ERR(pwm->clk)) {
Why an empty line here, but not in other similar places?

> +		ret = PTR_ERR(pwm->clk);
> +		goto err_free;
> +	}
> +
> +	pwm->chip.ops = &mxs_pwm_ops;
> +
> +	pwm->enabled = 0;
is already 0 due to kzalloc().

> +
> +	pwm->chip.pwm_id = pdev->id;
> +	pwm->chip.owner = THIS_MODULE;
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (r == NULL) {
> +		dev_err(&pdev->dev, "no memory resource defined\n");
> +		ret = -ENODEV;
> +		goto err_free_clk;
> +	}
> +
> +	r = request_mem_region(r->start, resource_size(r), pdev->name);
> +	if (r == NULL) {
> +		dev_err(&pdev->dev, "failed to request memory resource\n");
> +		ret = -EBUSY;
> +		goto err_free_clk;
> +	}
> +
> +	pwm->mmio_base = ioremap(r->start, resource_size(r));
> +	if (pwm->mmio_base == NULL) {
> +		dev_err(&pdev->dev, "failed to ioremap() registers\n");
> +		ret = -ENODEV;
-ENOMEM?.

> +	if (ret)
> +		goto err_free_mem;
> +
> +	platform_set_drvdata(pdev, pwm);
> +	return 0;
> +
> +err_free_mem:
> +	release_mem_region(r->start, resource_size(r));
> +err_free_clk:
> +	clk_put(pwm->clk);
> +err_free:
> +	kfree(pwm);
> +	return ret;
> +}
> +
> +static int __devexit mxs_pwm_remove(struct platform_device *pdev)
> +{
> +	struct mxs_pwm_device *pwm;
> +	struct resource *r;
> +	int ret;
> +
> +	pwm = platform_get_drvdata(pdev);
> +
> +	ret = pwmchip_remove(&pwm->chip);
> +	if (ret)
> +		return ret;
> +
> +	iounmap(pwm->mmio_base);
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	release_mem_region(r->start, resource_size(r));
> +
> +	clk_put(pwm->clk);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver mxs_pwm_driver = {
> +	.driver		= {
> +		.name	= "mxs-pwm",
> +	},
> +	.probe		= mxs_pwm_probe,
> +	.remove		= __devexit_p(mxs_pwm_remove),
> +};
> +
> +static int __init mxs_pwm_init(void)
> +{
> +	if (cpu_is_mx28())
> +		pwm_base_common = MX28_IO_ADDRESS(MX28_PWM_BASE_ADDR);
> +	else
> +		pwm_base_common = MX23_IO_ADDRESS(MX23_PWM_BASE_ADDR);
> +
> +	__mxs_clrl(PWM_SFTRST | PWM_CLKGATE, pwm_base_common + REG_PWM_CTRL);
> +
Shouldn't CLKGATE be set again in the remove() function?



Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
