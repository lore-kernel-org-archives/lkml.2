Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab1F3IYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:24:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758790Ab1F3IX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:23:58 -0400
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/6] Samsung SoC ADC: use regulator (VDD for ADC).
Date: Thu, 30 Jun 2011 11:22:50 +0300
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo-anarsoul; KDE/4.6.3; i686; ; )
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassi.brar@samsung.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@gmail.com,
        Ben Dooks <ben-linux@fluff.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Seungwhan Youn <sw.youn@samsung.com>,
        Changhwan Youn <chaos.youn@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1309420175-10301-1-git-send-email-myungjoo.ham@samsung.com> <1309420175-10301-2-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1309420175-10301-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301122.50800.anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 June 2011 10:49:30 MyungJoo Ham wrote:
> This patch allows the Samsung ADC driver to enable VDD regulator at
> probe and resume and to disable at exit and suspend.
> In a platform where ADC's VDD regulator is not "always-on", this control
> is required although this patch does not provide fine-grained power
> control (turning on the regulator only when being accessed).
> 
> However, if VDD regulator ("vdd" for the adc device) is not provided,
> the regulator control will not be activated because there are platforms
> that do not provide regulator for ADC device.
> 
> arch_initcall has been modified to module_init in order to allow
> regulators to be available at probe.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>


> --
> changed from v2 with valuable comments from Mark Brown.
> - Bugfix on error handling
> - Faster escape when error at resume function
> changes from v1
> - Removed macro defining the name of regulator.
> - Handle error from regulator_enable.
> - Do not allow not to have the regulator if CONFIG_REGULATOR.
> - Seperate a patch dealing with "arch_initcall->module_init"
> ---
>  arch/arm/plat-samsung/adc.c |   31 +++++++++++++++++++++++++++----
>  1 files changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/adc.c b/arch/arm/plat-samsung/adc.c
> index e8f2be2..2224128 100644
> --- a/arch/arm/plat-samsung/adc.c
> +++ b/arch/arm/plat-samsung/adc.c
> @@ -21,6 +21,7 @@
>  #include <linux/clk.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/regulator/consumer.h>
> 
>  #include <plat/regs-adc.h>
>  #include <plat/adc.h>
> @@ -71,6 +72,7 @@ struct adc_device {
>  	unsigned int		 prescale;
> 
>  	int			 irq;
> +	struct regulator	*vdd;
>  };
> 
>  static struct adc_device *adc_dev;
> @@ -338,17 +340,24 @@ static int s3c_adc_probe(struct platform_device
> *pdev) adc->pdev = pdev;
>  	adc->prescale = S3C2410_ADCCON_PRSCVL(49);
> 
> +	adc->vdd = regulator_get(dev, "vdd");
> +	if (IS_ERR(adc->vdd)) {
> +		dev_err(dev, "operating without regulator \"vdd\" .\n");
> +		ret = PTR_ERR(adc->vdd);
> +		goto err_alloc;
> +	}
> +

NACK. Make it optional, otherwise it breaks s3c24xx.

>  	adc->irq = platform_get_irq(pdev, 1);
>  	if (adc->irq <= 0) {
>  		dev_err(dev, "failed to get adc irq\n");
>  		ret = -ENOENT;
> -		goto err_alloc;
> +		goto err_reg;
>  	}
> 
>  	ret = request_irq(adc->irq, s3c_adc_irq, 0, dev_name(dev), adc);
>  	if (ret < 0) {
>  		dev_err(dev, "failed to attach adc irq\n");
> -		goto err_alloc;
> +		goto err_reg;
>  	}
> 
>  	adc->clk = clk_get(dev, "adc");
> @@ -372,6 +381,10 @@ static int s3c_adc_probe(struct platform_device *pdev)
>  		goto err_clk;
>  	}
> 
> +	ret = regulator_enable(adc->vdd);
> +	if (ret)
> +		goto err_ioremap;
> +
>  	clk_enable(adc->clk);
> 
>  	tmp = adc->prescale | S3C2410_ADCCON_PRSCEN;
> @@ -388,12 +401,15 @@ static int s3c_adc_probe(struct platform_device
> *pdev)
> 
>  	return 0;
> 
> + err_ioremap:
> +	iounmap(adc->regs);
>   err_clk:
>  	clk_put(adc->clk);
> 
>   err_irq:
>  	free_irq(adc->irq, adc);
> -
> + err_reg:
> +	regulator_put(adc->vdd);
>   err_alloc:
>  	kfree(adc);
>  	return ret;
> @@ -406,6 +422,8 @@ static int __devexit s3c_adc_remove(struct
> platform_device *pdev) iounmap(adc->regs);
>  	free_irq(adc->irq, adc);
>  	clk_disable(adc->clk);
> +	regulator_disable(adc->vdd);
> +	regulator_put(adc->vdd);
>  	clk_put(adc->clk);
>  	kfree(adc);
> 
> @@ -428,6 +446,7 @@ static int s3c_adc_suspend(struct platform_device
> *pdev, pm_message_t state) disable_irq(adc->irq);
>  	spin_unlock_irqrestore(&adc->lock, flags);
>  	clk_disable(adc->clk);
> +	regulator_disable(adc->vdd);
> 
>  	return 0;
>  }
> @@ -435,7 +454,11 @@ static int s3c_adc_suspend(struct platform_device
> *pdev, pm_message_t state) static int s3c_adc_resume(struct
> platform_device *pdev)
>  {
>  	struct adc_device *adc = platform_get_drvdata(pdev);
> +	int ret;
> 
> +	ret = regulator_enable(adc->vdd);
> +	if (ret)
> +		return ret;
>  	clk_enable(adc->clk);
>  	enable_irq(adc->irq);
> 
> @@ -485,4 +508,4 @@ static int __init adc_init(void)
>  	return ret;
>  }
> 
> -arch_initcall(adc_init);
> +module_init(adc_init);
