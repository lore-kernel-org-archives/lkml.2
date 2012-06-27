Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2F0Rwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:52:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12259 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2F0Rwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:52:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6755"; a="202841322"
Message-ID: <4FEB486C.7000408@codeaurora.org>
Date: Wed, 27 Jun 2012 10:52:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
CC: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number generator
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
In-Reply-To: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor comments, otherwise this looks much better than the previous
patch.

On 06/27/12 03:31, Jonghwa Lee wrote:
> This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5 seeds and
> 5 random number outputs. Module is excuted under runtime power management control,
> so it activates only while it's in use. Otherwise it will be suspended generally.
> It was tested on PQ board by rngtest program.
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This is an incorrect signoff chain. Kyungmin is not sending this so why
are you not the last one to sign off? Who is the author, Kyungmin or
yourself?

> +
> +config HW_RANDOM_EXYNOS
> +	tristate "EXYNOS HW random number generator support"
> +	depends on HW_RANDOM && ARCH_EXYNOS && HAS_IOMEM && PM_RUNTIME

There is no need to depend on PM_RUNTIME or ARCH_EXYNOS.

> +
> +static int exynos_read(struct hwrng *rng, void *buf,
> +					size_t max, bool wait)
> +{
> +	struct exynos_rng *exynos_rng = container_of(rng,
> +						struct exynos_rng, rng);
> +	u32 *data = buf;
> +
> +	pm_runtime_get_sync(exynos_rng->dev);
> +
> +	exynos_rng_writel(exynos_rng, PRNG_START, 0);
> +
> +	do {
> +		cpu_relax();
> +	} while (!(exynos_rng_readl(exynos_rng,
> +			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE));
> +
> +	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);

Curious, is this actually required? You poll for the status to say done
and the hardware requires you to write back the done bit after it
signals done?

> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		clk_put(exynos_rng->clk);
> +		return -ENODEV;
> +	}

Pass this through directly to devm_request_and_ioremap() without
checking the return value to save some lines.

> +
> +	exynos_rng->mem = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!exynos_rng->mem) {
> +		dev_err(&pdev->dev, "Ioremap failed.\n");

devm_request_and_ioremap() already prints a message on failure to remap
so this is unnecessary printk.

> +		return -EBUSY;
> +	}
> +
> +	platform_set_drvdata(pdev, exynos_rng);
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = hwrng_register(&exynos_rng->rng);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

Why not just 'return hwrng_register()'?

> +
> +static int exynos_rng_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
> +
> +	clk_prepare_enable(exynos_rng->clk);
> +	return 0;

Perhaps return the value of clk_prepare_enable() in case it fails for
some reason?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

