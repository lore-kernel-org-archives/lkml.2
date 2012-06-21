Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2FUCkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:40:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17647 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2FUCkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:40:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7fcc6d000003a7a-42-4fe2897d7267
Message-id: <4FE2897C.6050002@samsung.com>
Date: Thu, 21 Jun 2012 11:39:56 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Exynos : Add support for Exynos random number generator
References: <1340180526-24542-1-git-send-email-jonghwa3.lee@samsung.com>
 <4FE26F27.4010106@codeaurora.org>
In-reply-to: <4FE26F27.4010106@codeaurora.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd3azkf+Bl/eKVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MM4eWMxe8dKqY/6KBpYHxpUkXIyeHhICJxL2VL1khbDGJC/fW
	s3UxcnEICUxnlJjavJcZJMErICjxY/I9li5GDg5mAXmJI5eyQcLMAuoSk+YtYoao72OS2LN/
	IRtIDa+AlsSDuZwgNSwCqhJP308Dm88mICfxtukbI0iJqECExK9+DpCwCNCY7ztOgq1lFuhm
	ktj9ewsjSEJYwEdiyrr/YGuFBHIk+naAncwpoCdx9u5kpgmMArOQHDcL4bhZSI5bwMi8ilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM49J5J72Bc1WBxiFGAg1GJh3dm6SN/IdbEsuLK3EOM
	EhzMSiK8y9WAQrwpiZVVqUX58UWlOanFhxilOViUxHmbrC/4CwmkJ5akZqemFqQWwWSZODil
	Ghg3JlezvLlxTkkz3P/S4xzB4K4dE/3TCz8lTUyripkpL8P0+nah5b79HtypNXLtVxUrVfld
	zi96er1vc36y6olSuXDNQP1Ziy2OfV1dZe1hO/GEzI+21Tc27Wardb3wfNkWl8WOoesiblX/
	1Wm6JdirNYM32M7inOgKkZaMzUeEPpdc2PqgjUmJpTgj0VCLuag4EQD0BlWAOQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Stephen.
Thanks for quick reviewing.

On 2012년 06월 21일 09:47, Stephen Boyd wrote:

> On 06/20/12 01:22, Jonghwa Lee wrote:
>> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
>> index f45dad3..8220026 100644
>> --- a/drivers/char/hw_random/Kconfig
>> +++ b/drivers/char/hw_random/Kconfig
>> @@ -263,3 +263,15 @@ config HW_RANDOM_PSERIES
>>  	  module will be called pseries-rng.
>>  
>>  	  If unsure, say Y.
>> +
>> +config HW_RANDOM_EXYNOS
>> +	tristate "EXYNOS Random Number Generator support"
>> +	depends on HW_RANDOM && ARCH_EXYNOS4
> 
> I don't see how this actually depends on ARCH_EXYNOS4 to be compiled. I
> obviously wouldn't want to compile in this driver if I didn't have the
> hardware but the driver seems generic enough to be compiled anywhere
> (e.g. in an x86 allmodconfig). I suppose you need to add HAS_IOMEM though.
> 


I just add this condition only because EXYNOS series has PRNG in it
generally. But, I'll fix it as you mentioned.

>> +	---help---
>> +	  This driver provides kernel-side support for the Random Number
>> +	  Generator hardware found on EXYNOS SOCs.
> 
> Why is 'random number generator' capitalized?
> 


I'll modify it.

>> diff --git a/drivers/char/hw_random/exynos-rng.c b/drivers/char/hw_random/exynos-rng.c
>> new file mode 100644
>> index 0000000..b58a28b
>> --- /dev/null
>> +++ b/drivers/char/hw_random/exynos-rng.c
>> @@ -0,0 +1,204 @@
> [snip]
>> +#include <linux/clk.h>
>> +#include <linux/pm_runtime.h>
>> +
>> +#define	EXYNOS_PRNG_STATUS_OFFSET	0x10
>> +#define EXYNOS_PRNG_SEED_OFFSET		0x140
>> +#define EXYNOS_PRNG_OUT1_OFFSET		0x160
>> +#define SEED_SETTING_DONE		BIT(1)
>> +#define PRNG_START			0x18
>> +#define	PRNG_DONE			BIT(5)
> 
> Please consistently use tabs or spaces here between the '#define' and
> the name.
> 


Okay,

>> +
>> +struct exynos_rng {
>> +	struct device *dev;
>> +	struct hwrng rng;
>> +	void __iomem *mem;
>> +	struct clk *clk;
>> +};
>> +
>> +static u32 exynos_rng_readl(void __iomem *base, u32 offset)
>> +{
>> +	return	__raw_readl(base + offset);
>> +}
> 
> There seems to be a tab here? Also, why don't these read/write functions
> take the exynos_rng struct so that you don't have to pass the base
> pointer. That would make these functions more useful than just being a
> wrapper around __raw_{readl,writel}()
> 
>     u32 exynos_rng_readl(struct exynos_rng *rng, u32 offset)
>     void exynos_rng_writel(struct exynos_rng *rng, u32 val, u32 offset)
> 


Okay, I'll apply it.

>> +
>> +static void exynos_rng_writel(u32 val, void __iomem *base, u32 offset)
>> +{
>> +	__raw_writel(val, base + offset);
>> +}
>> +
>> +static int exynos_init(struct hwrng *rng)
>> +{
>> +	struct exynos_rng *exynos_rng = container_of(rng,
>> +						struct exynos_rng, rng);
>> +	int i;
>> +	int ret = 0;
>> +	u32 PRND_SEED[5];
>> +
>> +	pm_runtime_put_noidle(exynos_rng->dev);
>> +	pm_runtime_get_sync(exynos_rng->dev);
> 
> This looks very odd. Why are you calling pm_runtime_put_noidle()?
> 


When this callback function is called, the status of power state is
'suspended' and use_count is 1. To perform pm_runtime_get_sync()
correctly, it requires to have 'suspended' status and use_count is 0.
Thus i force to decrease use_count only with using
pm_runtime_put_noidle. I know it looks odd, but i couldn't find better
way. Otherwise it can use clk_enable() directly, but i think that it
isn't good neither.

>> +
>> +	for (i = 0 ; i < 5 ; i++) {
>> +		PRND_SEED[i] = i;
>> +		exynos_rng_writel(PRND_SEED[i], exynos_rng->mem,
>> +					EXYNOS_PRNG_SEED_OFFSET + 4*i);
>> +	}
> 
> Is this just writing 0,1,2,3,4 to registers? What is the array for?
> 


I'll modify it.

>> +
>> +	if (!(exynos_rng_readl(exynos_rng->mem, EXYNOS_PRNG_STATUS_OFFSET)
>> +						 & SEED_SETTING_DONE))
>> +		ret = -EIO;
>> +
>> +	pm_runtime_put(exynos_rng->dev);
>> +	pm_runtime_get_noresume(exynos_rng->dev);
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
>> +	u32 status = 0;
> 
> Drop this assignment here.
> 


Okay,

>> +
>> +	pm_runtime_get_sync(exynos_rng->dev);
>> +	exynos_rng_writel(PRNG_START, exynos_rng->mem, 0);
>> +
>> +	while (!status) {
>> +		status = exynos_rng_readl(exynos_rng->mem,
>> +					EXYNOS_PRNG_STATUS_OFFSET);
>> +		status &= PRNG_DONE;
>> +	}
> 
> And make this into a do while with a cpu_relax() thrown in there.
> 


Okay

>> +
>> +	exynos_rng_writel(PRNG_DONE, exynos_rng->mem,
>> +					EXYNOS_PRNG_STATUS_OFFSET);
>> +
>> +	*data = exynos_rng_readl(exynos_rng->mem,
>> +					EXYNOS_PRNG_OUT1_OFFSET);
>> +
>> +	pm_runtime_put(exynos_rng->dev);
>> +	return 4;
>> +}
>> +
>> +static int __init exynos_rng_probe(struct platform_device *pdev)
> 
> __devinit
> 


Okay,

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
>> +	exynos_rng->clk = clk_get(NULL, "secss");
> 
> Can you please pass &pdev->dev to clk_get()?
>


But, this clock is not only used in PRNG. Should i put it in?

 
>> +	if (!exynos_rng->clk) {
> 
> NULL is a valid clock. Please check for IS_ERR() only. Also you may want
> to use devm_clk_get().
> 


Okay

>> +		dev_err(&pdev->dev, "Couldn't get clock.\n");
>> +		return -ENOENT;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		clk_put(exynos_rng->clk);
>> +		return -ENODEV;
>> +	}
>> +
>> +	exynos_rng->mem = devm_ioremap(&pdev->dev, res->start,
>> +						 resource_size(res));
> 
> It might be a good idea to use devm_request_and_ioremap() here instead.
> 


Okay,

>> +	if (!exynos_rng->mem) {
>> +		dev_err(&pdev->dev, "Ioremap failed.\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, exynos_rng);
>> +
>> +	pm_runtime_enable(&pdev->dev);
>> +	pm_runtime_irq_safe(&pdev->dev);
> 
> It doesn't seem like you need to run runtime PM calls in irq context.
> Why is this here?
> 


I think i misunderstood to use pm_runtime_sync(). I understood it is
needed for using pm_runtime_sync() for any condition. I'll remove it.

>> +
>> +	ret = hwrng_register(&exynos_rng->rng);
>> +	if (ret) {
>> +		clk_put(exynos_rng->clk);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int __exit exynos_rng_remove(struct platform_device *pdev)
> 
> __devexit
> 


Okay,

>> +{
>> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
>> +
>> +	hwrng_unregister(&exynos_rng->rng);
>> +	clk_put(exynos_rng->clk);
>> +	return 0;
>> +}
>> +
>> +static int exynos_rng_runtime_suspend(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
>> +
>> +	clk_disable(exynos_rng->clk);
>> +	return 0;
>> +}
>> +
>> +static int exynos_rng_runtime_resume(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct exynos_rng *exynos_rng = platform_get_drvdata(pdev);
>> +
>> +	clk_enable(exynos_rng->clk);
> 
> Please use clk_prepare_enable()/clk_disable_unprepare() so we don't have
> to convert this driver later.
> 


Okay,

>> +
>> +static const struct dev_pm_ops exynos_rng_pm_ops = {
>> +	.runtime_suspend = exynos_rng_runtime_suspend,
>> +	.runtime_resume = exynos_rng_runtime_resume,
>> +};
> 
> You should use something like UNIVERSAL_DEV_PM_OPS here so that you can
> #ifdef CONFIG_PM the runtime suspend/resume functions. If CONFIG_PM=n
> does this driver work? I wonder if the clocks are assumed to be on in
> that case?
> 


Okay, I'll fix it.

>> +
>> +static struct platform_driver exynos_rng_driver = {
>> +	.driver		= {
>> +		.name	= "exynos-rng",
>> +		.owner	= THIS_MODULE,
>> +		.pm	= &exynos_rng_pm_ops,
>> +	},
>> +	.probe		= exynos_rng_probe,
>> +	.remove		= exynos_rng_remove,
> 
> __devexit_p()
> 

Okay


Regards.


