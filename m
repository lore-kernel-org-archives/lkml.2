Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2F0LVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 07:21:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45843 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2F0LVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 07:21:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fcc6d000003a7a-40-4feaeccf101e
Message-id: <4FEAECCE.3050006@samsung.com>
Date: Wed, 27 Jun 2012 20:21:50 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number generator
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120627110703.GE4132@page>
In-reply-to: <20120627110703.GE4132@page>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd3zb175GyxvlbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZl57dZCp4plWxrv09cwPjYqUuRk4OCQETiZYjN5kgbDGJC/fW
	s3UxcnEICUxnlLh+8zIjSIJXQFDix+R7LF2MHBzMAvISRy5lg4SZBdQlJs1bxAxR38UkcWD/
	Q1aIei2JaWefMoPUswioSqy8kgUSZhOQk3jb9I0RJCwqECHxq58DJCwioCKx+/FTFpAxzAJ9
	TBLbXy1kBkkIC/hLrNx6BuwEIYF0iU8ft4HFOQU0JZb/msg+gVFgFpLrZiFcNwvJdQsYmVcx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAffM+kdjKsaLA4xCnAwKvHwsr545S/EmlhWXJl7
	iFGCg1lJhNf6OVCINyWxsiq1KD++qDQntfgQozQHi5I4b5P1BX+g4xJLUrNTUwtSi2CyTByc
	Ug2MJnliIcxCtmx8bn29s/9fPR4XfLTmyQNT0ZZsMa/fGtoJi0wi1S/v/ffD/s13+VZJPnaz
	bc0MFtcDugte97bsWWnIk7coYJ9ZyKmfE663XLjFIZ/3zHvjSeZXkskP59tNe6Oxn/1v3xzb
	5EfZHgZiNcmh3H9+8su//5H+wWP205U6jedq1yxTYinOSDTUYi4qTgQAYsX7zDoCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 06월 27일 20:07, Jamie Iles wrote:

> Hi Jongwha,
> 
> Just minor nits.
> 
> On Wed, Jun 27, 2012 at 07:31:01PM +0900, Jonghwa Lee wrote:
>> diff --git a/drivers/char/hw_random/Kconfig 
>> b/drivers/char/hw_random/Kconfig
>> index f45dad3..a9e3806 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
>>  	  module will be called pseries-rng.
>>  
>>  	  If unsure, say Y.
>> +
>> +config HW_RANDOM_EXYNOS
>> +	tristate "EXYNOS HW random number generator support"
>> +	depends on HW_RANDOM && ARCH_EXYNOS && HAS_IOMEM && PM_RUNTIME
> 
> I don't think this needs an ARCH_EXYNOS dependency does it?  I think you 
> do need a dependency on HAVE_CLK though then it can be built for other 
> platforms.
> 


This random number generator driver is only for Exynos SOC. And why
should I add HAVE_CLK dependency since there is no relation with?

>> diff --git a/drivers/char/hw_random/exynos-rng.c 
>> b/drivers/char/hw_random/exynos-rng.c
>> new file mode 100644
>> index 0000000..9c8d690
>> --- /dev/null
>> +++ b/drivers/char/hw_random/exynos-rng.c
>> @@ -0,0 +1,191 @@
>> +/*
>> + * exynos-rng.c - Random Number Generator driver for the exynos
>> + *
>> + * Copyright (C) 2012 Samsung Electronics
>> + * Jonghwa Lee <jonghwa3.lee@smasung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation;
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
>> + *
>> + */
>> +
>> +#include <linux/hw_random.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/delay.h>
>> +#include <linux/io.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/err.h>
>> +
>> +#define EXYNOS_PRNG_STATUS_OFFSET	0x10
>> +#define EXYNOS_PRNG_SEED_OFFSET		0x140
>> +#define EXYNOS_PRNG_OUT1_OFFSET		0x160
>> +#define SEED_SETTING_DONE		BIT(1)
>> +#define PRNG_START			0x18
>> +#define PRNG_DONE			BIT(5)
>> +
>> +struct exynos_rng {
>> +	struct device *dev;
>> +	struct hwrng rng;
>> +	void __iomem *mem;
>> +	struct clk *clk;
>> +};
>> +
>> +static u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
>> +{
>> +	return	__raw_readl(rng->mem + offset);
>> +}
>> +
>> +static void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
>> +{
>> +	__raw_writel(val, rng->mem + offset);
>> +}
>> +
>> +static int exynos_init(struct hwrng *rng)
>> +{
>> +	struct exynos_rng *exynos_rng = container_of(rng,
>> +						struct exynos_rng, rng);
>> +	int i;
>> +	int ret = 0;
>> +
>> +	pm_runtime_get_sync(exynos_rng->dev);
>> +
>> +	for (i = 0 ; i < 5 ; i++)
>> +		exynos_rng_writel(exynos_rng, i, EXYNOS_PRNG_SEED_OFFSET + 4*i);
>> +
>> +	if (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET)
>> +						 & SEED_SETTING_DONE))
>> +		ret = -EIO;
>> +
>> +	pm_runtime_put_noidle(exynos_rng->dev);
>> +
>> +	return ret;
>> +}
>> +
>> +static int exynos_read(struct hwrng *rng, void *buf,
>> +					size_t max, bool wait)
>> +{
>> +	struct exynos_rng *exynos_rng = container_of(rng,
>> +						struct exynos_rng, rng);
>> +	u32 *data = buf;
>> +
>> +	pm_runtime_get_sync(exynos_rng->dev);
>> +
>> +	exynos_rng_writel(exynos_rng, PRNG_START, 0);
>> +
>> +	do {
>> +		cpu_relax();
>> +	} while (!(exynos_rng_readl(exynos_rng,
>> +			EXYNOS_PRNG_STATUS_OFFSET) & PRNG_DONE));
> 
> A minor nit, but
> 
> 	while (!(exynos_rng_readl(exynos_rng, EXYNOS_PRNG_STATUS_OFFSET) & 
> 				  PRNG_DONE))
> 		cpu_relax();
> 
> would be a bit more conventional.
> 


Stephen Boyd suggested to me that way. Anyway I'll follow with
conventional way.

>> +
>> +	exynos_rng_writel(exynos_rng, PRNG_DONE, EXYNOS_PRNG_STATUS_OFFSET);
>> +
>> +	*data = exynos_rng_readl(exynos_rng, EXYNOS_PRNG_OUT1_OFFSET);
>> +
>> +	pm_runtime_put(exynos_rng->dev);
>> +	return 4;
>> +}
>> +
>> +static int __devinit exynos_rng_probe(struct platform_device *pdev)
>> +{
>> +	int ret;
>> +	struct exynos_rng *exynos_rng;
>> +	struct resource *res;
>> +
>> +	exynos_rng = devm_kzalloc(&pdev->dev, sizeof(struct exynos_rng),
>> +					GFP_KERNEL);
>> +	if (!exynos_rng)
>> +		return -ENOMEM;
>> +
>> +	exynos_rng->dev = &pdev->dev;
>> +	exynos_rng->rng.name = "exynos";
>> +	exynos_rng->rng.init =	exynos_init;
>> +	exynos_rng->rng.read = exynos_read;
>> +	exynos_rng->clk = devm_clk_get(&pdev->dev, "secss");
>> +	if (IS_ERR(exynos_rng->clk)) {
>> +		dev_err(&pdev->dev, "Couldn't get clock.\n");
>> +		return -ENOENT;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		clk_put(exynos_rng->clk);
> 
> Doesn't the devm_clk_get() above handle this for you?
> 


Yes, it's my mistake, I'll remove it.

Thanks.
