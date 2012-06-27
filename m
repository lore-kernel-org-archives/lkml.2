Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2F0LHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:07:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54407 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab2F0LHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:07:07 -0400
Date: Wed, 27 Jun 2012 12:07:03 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number
 generator
Message-ID: <20120627110703.GE4132@page>
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jongwha,

Just minor nits.

On Wed, Jun 27, 2012 at 07:31:01PM +0900, Jonghwa Lee wrote:
> diff --git a/drivers/char/hw_random/Kconfig 
> b/drivers/char/hw_random/Kconfig
> index f45dad3..a9e3806 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
>  	  module will be called pseries-rng.
>  
>  	  If unsure, say Y.
> +
> +config HW_RANDOM_EXYNOS
> +	tristate "EXYNOS HW random number generator support"
> +	depends on HW_RANDOM && ARCH_EXYNOS && HAS_IOMEM && PM_RUNTIME

I don't think this needs an ARCH_EXYNOS dependency does it?  I think you 
do need a dependency on HAVE_CLK though then it can be built for other 
platforms.

> diff --git a/drivers/char/hw_random/exynos-rng.c 
> b/drivers/char/hw_random/exynos-rng.c
> new file mode 100644
> index 0000000..9c8d690
> --- /dev/null
> +++ b/drivers/char/hw_random/exynos-rng.c
> @@ -0,0 +1,191 @@
> +/*
> + * exynos-rng.c - Random Number Generator driver for the exynos
> + *
> + * Copyright (C) 2012 Samsung Electronics
> + * Jonghwa Lee <jonghwa3.lee@smasung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation;
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + */
> +
> +#include <linux/hw_random.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/clk.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/err.h>
> +
> +#define EXYNOS_PRNG_STATUS_OFFSET	0x10
> +#define EXYNOS_PRNG_SEED_OFFSET		0x140
> +#define EXYNOS_PRNG_OUT1_OFFSET		0x160
> +#define SEED_SETTING_DONE		BIT(1)
> +#define PRNG_START			0x18
> +#define PRNG_DONE			BIT(5)
> +
> +struct exynos_rng {
> +	struct device *dev;
> +	struct hwrng rng;
> +	void __iomem *mem;
> +	struct clk *clk;
> +};
> +
> +static u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
> +{
> +	return	__raw_readl(rng->mem + offset);
> +}
> +
> +static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
> +{
> +	__raw_writel(val, rng->mem + offset);
> +}
> +
> +static int exynos_init(struct hwrng *rng)
> +{
> +	struct exynos_rng *exynos_rng = container_of(rng,
> +						struct exynos_rng, rng);
> +	int i;
> +	int ret = 0;
> +
> +	pm_runtime_get_sync(exynos_rng->dev);
> +
> +	for (i = 0 ; i < 5 ; i++)
> +		exynos_rng_writel(exynos_rng, i, EXYNOS_PRNG_SEED_OFFSET + 4*i);
> +
> +	if (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET)
> +						 & SEED_SETTING_DONE))
> +		ret = -EIO;
> +
> +	pm_runtime_put_noidle(exynos_rng->dev);
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
> +
> +	pm_runtime_get_sync(exynos_rng->dev);
> +
> +	exynos_rng_writel(exynos_rng, PRNG_START, 0);
> +
> +	do {
> +		cpu_relax();
> +	} while (!(exynos_rng_readl(exynos_rng,
> +			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE));

A minor nit, but

	while (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET) & 
				  PRNG_DONE))
		cpu_relax();

would be a bit more conventional.

> +
> +	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
> +
> +	*data = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_OUT1_OFFSET);
> +
> +	pm_runtime_put(exynos_rng->dev);
> +	return 4;
> +}
> +
> +static int __devinit exynos_rng_probe(struct platform_device *pdev)
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
> +	exynos_rng->clk = devm_clk_get(&pdev->dev, "secss");
> +	if (IS_ERR(exynos_rng->clk)) {
> +		dev_err(&pdev->dev, "Couldn't get clock.\n");
> +		return -ENOENT;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		clk_put(exynos_rng->clk);

Doesn't the devm_clk_get() above handle this for you?

Otherwise looks good to me!

Jamie
