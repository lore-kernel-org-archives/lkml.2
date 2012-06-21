Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2FUAri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:47:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18117 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab2FUArg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:47:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6748"; a="200724077"
Message-ID: <4FE26F27.4010106@codeaurora.org>
Date: Wed, 20 Jun 2012 17:47:35 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Exynos : Add support for Exynos random number generator
References: <1340180526-24542-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1340180526-24542-1-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/12 01:22, Jonghwa Lee wrote:
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index f45dad3..8220026 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
>  	  module will be called pseries-rng.
>  
>  	  If unsure, say Y.
> +
> +config HW_RANDOM_EXYNOS
> +	tristate "EXYNOS Random Number Generator support"
> +	depends on HW_RANDOM && ARCH_EXYNOS4

I don't see how this actually depends on ARCH_EXYNOS4 to be compiled. I
obviously wouldn't want to compile in this driver if I didn't have the
hardware but the driver seems generic enough to be compiled anywhere
(e.g. in an x86 allmodconfig). I suppose you need to add HAS_IOMEM though.

> +	---help---
> +	  This driver provides kernel-side support for the Random Number
> +	  Generator hardware found on EXYNOS SOCs.

Why is 'random number generator' capitalized?

> diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
> new file mode 100644
> index 0000000..b58a28b
> --- /dev/null
> +++ b/drivers/char/hw_random/exynos-rng.c
> @@ -0,0 +1,204 @@
[snip]
> +#include <linux/clk.h>
> +#include <linux/pm_runtime.h>
> +
> +#define	EXYNOS_PRNG_STATUS_OFFSET	0x10
> +#define EXYNOS_PRNG_SEED_OFFSET		0x140
> +#define EXYNOS_PRNG_OUT1_OFFSET		0x160
> +#define SEED_SETTING_DONE		BIT(1)
> +#define PRNG_START			0x18
> +#define	PRNG_DONE			BIT(5)

Please consistently use tabs or spaces here between the '#define' and
the name.

> +
> +struct exynos_rng {
> +	struct device *dev;
> +	struct hwrng rng;
> +	void __iomem *mem;
> +	struct clk *clk;
> +};
> +
> +static u32 exynos_rng_readl(void __iomem *base, u32 offset)
> +{
> +	return	__raw_readl(base + offset);
> +}

There seems to be a tab here? Also, why don't these read/write functions
take the exynos_rng struct so that you don't have to pass the base
pointer. That would make these functions more useful than just being a
wrapper around __raw_{readl,writel}()

    u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
    void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)

> +
> +static void exynos_rng_writel(u32 val, void __iomem *base, u32 offset)
> +{
> +	__raw_writel(val, base + offset);
> +}
> +
> +static int exynos_init(struct hwrng *rng)
> +{
> +	struct exynos_rng *exynos_rng = container_of(rng,
> +						struct exynos_rng, rng);
> +	int i;
> +	int ret = 0;
> +	u32 PRND_SEED[5];
> +
> +	pm_runtime_put_noidle(exynos_rng->dev);
> +	pm_runtime_get_sync(exynos_rng->dev);

This looks very odd. Why are you calling pm_runtime_put_noidle()?

> +
> +	for (i = 0 ; i < 5 ; i++) {
> +		PRND_SEED[i] = i;
> +		exynos_rng_writel(PRND_SEED[i], exynos_rng->mem,
> +					EXYNOS_PRNG_SEED_OFFSET + 4*i);
> +	}

Is this just writing 0,1,2,3,4 to registers? What is the array for?

> +
> +	if (!(exynos_rng_readl(exynos_rng->mem, EXYNOS_PRNG_STATUS_OFFSET)
> +						 & SEED_SETTING_DONE))
> +		ret = -EIO;
> +
> +	pm_runtime_put(exynos_rng->dev);
> +	pm_runtime_get_noresume(exynos_rng->dev);
> +
> +	return ret;
> +}
> +
> +static int exynos_read(struct hwrng *rng, void *buf,
> +					size_t max, bool wait)
> +{
> +	struct exynos_rng *exynos_rng = container_of(rng,
> +						struct exynos_rng, rng);
> +	u32 *data = buf;
> +	u32 status = 0;

Drop this assignment here.

> +
> +	pm_runtime_get_sync(exynos_rng->dev);
> +	exynos_rng_writel(PRNG_START, exynos_rng->mem, 0);
> +
> +	while (!status) {
> +		status = exynos_rng_readl(exynos_rng->mem,
> +					EXYNOS_PRNG_STATUS_OFFSET);
> +		status &= PRNG_DONE;
> +	}

And make this into a do while with a cpu_relax() thrown in there.

> +
> +	exynos_rng_writel(PRNG_DONE, exynos_rng->mem,
> +					EXYNOS_PRNG_STATUS_OFFSET);
> +
> +	*data = exynos_rng_readl(exynos_rng->mem,
> +					EXYNOS_PRNG_OUT1_OFFSET);
> +
> +	pm_runtime_put(exynos_rng->dev);
> +	return 4;
> +}
> +
> +static int __init exynos_rng_probe(struct platform_device *pdev)

__devinit

> +{
> +	int ret;
> +	struct exynos_rng *exynos_rng;
> +	struct resource *res;
> +
> +	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
> +					GFP_KERNEL);
> +	if (!exynos_rng)
> +		return -ENOMEM;
> +
> +	exynos_rng->dev = &pdev->dev;
> +	exynos_rng->rng.name = "exynos";
> +	exynos_rng->rng.init =	exynos_init;
> +	exynos_rng->rng.read = exynos_read;
> +	exynos_rng->clk = clk_get(NULL, "secss");

Can you please pass &pdev->dev to clk_get()?

> +	if (!exynos_rng->clk) {

NULL is a valid clock. Please check for IS_ERR() only. Also you may want
to use devm_clk_get().

> +		dev_err(&pdev->dev, "Couldn't get clock.\n");
> +		return -ENOENT;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		clk_put(exynos_rng->clk);
> +		return -ENODEV;
> +	}
> +
> +	exynos_rng->mem = devm_ioremap(&pdev->dev, res->start,
> +						 resource_size(res));

It might be a good idea to use devm_request_and_ioremap() here instead.

> +	if (!exynos_rng->mem) {
> +		dev_err(&pdev->dev, "Ioremap failed.\n");
> +		return -EBUSY;
> +	}
> +
> +	platform_set_drvdata(pdev, exynos_rng);
> +
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_irq_safe(&pdev->dev);

It doesn't seem like you need to run runtime PM calls in irq context.
Why is this here?

> +
> +	ret = hwrng_register(&exynos_rng->rng);
> +	if (ret) {
> +		clk_put(exynos_rng->clk);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __exit exynos_rng_remove(struct platform_device *pdev)

__devexit

> +{
> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
> +
> +	hwrng_unregister(&exynos_rng->rng);
> +	clk_put(exynos_rng->clk);
> +	return 0;
> +}
> +
> +static int exynos_rng_runtime_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
> +
> +	clk_disable(exynos_rng->clk);
> +	return 0;
> +}
> +
> +static int exynos_rng_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
> +
> +	clk_enable(exynos_rng->clk);

Please use clk_prepare_enable()/clk_disable_unprepare() so we don't have
to convert this driver later.

> +
> +static const struct dev_pm_ops exynos_rng_pm_ops = {
> +	.runtime_suspend = exynos_rng_runtime_suspend,
> +	.runtime_resume = exynos_rng_runtime_resume,
> +};

You should use something like UNIVERSAL_DEV_PM_OPS here so that you can
#ifdef CONFIG_PM the runtime suspend/resume functions. If CONFIG_PM=n
does this driver work? I wonder if the clocks are assumed to be on in
that case?

> +
> +static struct platform_driver exynos_rng_driver = {
> +	.driver		= {
> +		.name	= "exynos-rng",
> +		.owner	= THIS_MODULE,
> +		.pm	= &exynos_rng_pm_ops,
> +	},
> +	.probe		= exynos_rng_probe,
> +	.remove		= exynos_rng_remove,

__devexit_p()

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

