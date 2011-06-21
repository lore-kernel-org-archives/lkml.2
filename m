Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab1FUKoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:44:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38436 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751401Ab1FUKoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:44:00 -0400
Date: Tue, 21 Jun 2011 11:43:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 1/5] Samsung SoC ADC: use regulator (VDD for ADC).
Message-ID: <20110621104357.GE22177@opensource.wolfsonmicro.com>
References: <20110620101737.GA31864@opensource.wolfsonmicro.com>
 <1308621527-2457-1-git-send-email-myungjoo.ham@samsung.com>
 <1308621527-2457-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308621527-2457-2-git-send-email-myungjoo.ham@samsung.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:58:43AM +0900, MyungJoo Ham wrote:

> +	ret = regulator_enable(adc->vdd);
> +	if (!ret)
> +		goto err_ioremap;
> +

This test looks the wrong way round?  regulator_enable() should return 0
on success but this will treat that as an error.

>  static int s3c_adc_resume(struct platform_device *pdev)
>  {
>  	struct adc_device *adc = platform_get_drvdata(pdev);
> +	int ret;
>  
> +	ret = regulator_enable(adc->vdd);
>  	clk_enable(adc->clk);
>  	enable_irq(adc->irq);
>  
>  	writel(adc->prescale | S3C2410_ADCCON_PRSCEN,
>  	       adc->regs + S3C2410_ADCCON);
>  
> -	return 0;
> +	return ret;

Seems better to return as soon as we notice the error, no point in
starting anything else up if we don't have power.
