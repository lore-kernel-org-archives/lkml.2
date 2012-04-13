Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2DMJEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 05:04:38 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:47424 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864Ab2DMJEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 05:04:36 -0400
Message-ID: <4F87EBFC.90000@stericsson.com>
Date: Fri, 13 Apr 2012 11:03:56 +0200
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I realize what the intention is with this patch; but I am not sure we 
have thought about all consequence it might have.

OK, so the power domain which implement runtime PM support, shall be 
responsible for handling the vcore regualtor instead of the amba bus. 
That should be fine.

But, how should those amba drivers that implements runtime PM support be 
able to switch of the vcore regulator during normal suspend? In normal 
suspend case we can not use pm_runtime_put/pm_runtime_put_sync to 
trigger the power domain runtime functions to switch of vcore. This is 
kind of more generic problem when dealing with power domains, but as 
said this patch will have consequences.

As far as I can see, the power domain must then implement a 
suspend_noirq function to make sure same things is done as for the 
runtime_suspend function. Do you agree with this as well or is there 
another option?

Kind regards
Ulf Hansson

On 04/01/2012 08:58 PM, Mark Brown wrote:
> The AMBA bus regulator support is being used to model on/off switches
> for power domains which isn't terribly idiomatic for modern kernels with
> the generic power domain code and creates integration problems on platforms
> which don't use regulators for their power domains as it's hard to tell
> the difference between a regulator that is needed but failed to be provided
> and one that isn't supposed to be there (though DT does make that easier).
>
> Platforms that wish to use the regulator API to manage their power domains
> can indirect via the power domain interface.
>
> This feature is only used with the vape supply of the db8500 PRCMU
> driver which supplies the UARTs and MMC controllers, none of which have
> support for managing vcore at runtime in mainline (only pl022 SPI
> controller does).  Update that supply to have an always_on constraint
> until the power domain support for the system is updated so that it is
> enabled for these users, this is likely to have no impact on practical
> systems as probably at least one of these devices will be active and
> cause AMBA to hold the supply on anyway.
>
> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> ---
>
> Updated to add the always_on constraint for db8500-prcmu as discussed in
> the changelog.
>
>   drivers/amba/bus.c         |   42 +-----------------------------------------
>   drivers/mfd/db8500-prcmu.c |    1 +
>   drivers/spi/spi-pl022.c    |    2 --
>   include/linux/amba/bus.h   |    8 --------
>   4 files changed, 2 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 01c2cf4..cc27322 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -247,8 +247,7 @@ static int amba_pm_restore(struct device *dev)
>   /*
>    * Hooks to provide runtime PM of the pclk (bus clock).  It is safe to
>    * enable/disable the bus clock at runtime PM suspend/resume as this
> - * does not result in loss of context.  However, disabling vcore power
> - * would do, so we leave that to the driver.
> + * does not result in loss of context.
>    */
>   static int amba_pm_runtime_suspend(struct device *dev)
>   {
> @@ -354,39 +353,6 @@ static void amba_put_disable_pclk(struct amba_device *pcdev)
>   	clk_put(pclk);
>   }
>
> -static int amba_get_enable_vcore(struct amba_device *pcdev)
> -{
> -	struct regulator *vcore = regulator_get(&pcdev->dev, "vcore");
> -	int ret;
> -
> -	pcdev->vcore = vcore;
> -
> -	if (IS_ERR(vcore)) {
> -		/* It is OK not to supply a vcore regulator */
> -		if (PTR_ERR(vcore) == -ENODEV)
> -			return 0;
> -		return PTR_ERR(vcore);
> -	}
> -
> -	ret = regulator_enable(vcore);
> -	if (ret) {
> -		regulator_put(vcore);
> -		pcdev->vcore = ERR_PTR(-ENODEV);
> -	}
> -
> -	return ret;
> -}
> -
> -static void amba_put_disable_vcore(struct amba_device *pcdev)
> -{
> -	struct regulator *vcore = pcdev->vcore;
> -
> -	if (!IS_ERR(vcore)) {
> -		regulator_disable(vcore);
> -		regulator_put(vcore);
> -	}
> -}
> -
>   /*
>    * These are the device model conversion veneers; they convert the
>    * device model structures to our more specific structures.
> @@ -399,10 +365,6 @@ static int amba_probe(struct device *dev)
>   	int ret;
>
>   	do {
> -		ret = amba_get_enable_vcore(pcdev);
> -		if (ret)
> -			break;
> -
>   		ret = amba_get_enable_pclk(pcdev);
>   		if (ret)
>   			break;
> @@ -420,7 +382,6 @@ static int amba_probe(struct device *dev)
>   		pm_runtime_put_noidle(dev);
>
>   		amba_put_disable_pclk(pcdev);
> -		amba_put_disable_vcore(pcdev);
>   	} while (0);
>
>   	return ret;
> @@ -442,7 +403,6 @@ static int amba_remove(struct device *dev)
>   	pm_runtime_put_noidle(dev);
>
>   	amba_put_disable_pclk(pcdev);
> -	amba_put_disable_vcore(pcdev);
>
>   	return ret;
>   }
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index ebc1e86..5be3248 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -2788,6 +2788,7 @@ static struct regulator_init_data db8500_regulators[DB8500_NUM_REGULATORS] = {
>   		.constraints = {
>   			.name = "db8500-vape",
>   			.valid_ops_mask = REGULATOR_CHANGE_STATUS,
> +			.always_on = true,
>   		},
>   		.consumer_supplies = db8500_vape_consumers,
>   		.num_consumer_supplies = ARRAY_SIZE(db8500_vape_consumers),
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index 96f0da6..09c925a 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -2195,7 +2195,6 @@ static int pl022_runtime_suspend(struct device *dev)
>   	struct pl022 *pl022 = dev_get_drvdata(dev);
>
>   	clk_disable(pl022->clk);
> -	amba_vcore_disable(pl022->adev);
>
>   	return 0;
>   }
> @@ -2204,7 +2203,6 @@ static int pl022_runtime_resume(struct device *dev)
>   {
>   	struct pl022 *pl022 = dev_get_drvdata(dev);
>
> -	amba_vcore_enable(pl022->adev);
>   	clk_enable(pl022->clk);
>
>   	return 0;
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index 7847e19..63a59ac 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -19,7 +19,6 @@
>   #include<linux/mod_devicetable.h>
>   #include<linux/err.h>
>   #include<linux/resource.h>
> -#include<linux/regulator/consumer.h>
>
>   #define AMBA_NR_IRQS	2
>   #define AMBA_CID	0xb105f00d
> @@ -30,7 +29,6 @@ struct amba_device {
>   	struct device		dev;
>   	struct resource		res;
>   	struct clk		*pclk;
> -	struct regulator	*vcore;
>   	u64			dma_mask;
>   	unsigned int		periphid;
>   	unsigned int		irq[AMBA_NR_IRQS];
> @@ -75,12 +73,6 @@ void amba_release_regions(struct amba_device *);
>   #define amba_pclk_disable(d)	\
>   	do { if (!IS_ERR((d)->pclk)) clk_disable((d)->pclk); } while (0)
>
> -#define amba_vcore_enable(d)	\
> -	(IS_ERR((d)->vcore) ? 0 : regulator_enable((d)->vcore))
> -
> -#define amba_vcore_disable(d)	\
> -	do { if (!IS_ERR((d)->vcore)) regulator_disable((d)->vcore); } while (0)
> -
>   /* Some drivers don't use the struct amba_device */
>   #define AMBA_CONFIG_BITS(a) (((a)>>  24)&  0xff)
>   #define AMBA_REV_BITS(a) (((a)>>  20)&  0x0f)

