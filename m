Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab2A0EUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:20:09 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:34225 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759Ab2A0EUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:20:08 -0500
Message-ID: <4F2225E2.4090808@st.com>
Date: Fri, 27 Jan 2012 09:49:46 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christopher BLAIR <chris.blair@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2 v2] gpio/stmpe: support no-irq mode
References: <1327612635-9171-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1327612635-9171-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/2012 2:47 AM, Linus WALLEIJ wrote:
> From: Chris Blair <chris.blair@stericsson.com>
> 
> Adds support for boards which have an STMPE GPIO device without the
> interrupt pin connected. This means that no interrupt can be received
> but the GPIO pins can still be driven and read.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Viresh Kumar <viresh.kumar@st.com>
> Tested-by: Michel Jaouen <michel.jaouen@stericsson.com>
> Signed-off-by: Chris Blair <chris.blair@stericsson.com>
> ---
> ChangeLog v1->v2:
> - Removes the use of the new no_irq platform data member and
>   instead uses the value obtained for the cell irq to know if irqs
>   are supported or not. If irqs are not supported, the device
>   will not have been given an irq resource and the irq value
>   will be invalid.
> 
> This depends on the previous patch to the MFD
> code so should better be merged into the MFD tree with the
> previous patch.
> ---
>  drivers/gpio/gpio-stmpe.c |   41 +++++++++++++++++++++++++----------------
>  1 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
> index 87a68a8..094c5c4 100644
> --- a/drivers/gpio/gpio-stmpe.c
> +++ b/drivers/gpio/gpio-stmpe.c
> @@ -307,13 +307,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
>  	struct stmpe_gpio_platform_data *pdata;
>  	struct stmpe_gpio *stmpe_gpio;
>  	int ret;
> -	int irq;
> +	int irq = 0;
>  
>  	pdata = stmpe->pdata->gpio;
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0)
> -		return irq;
>  
>  	stmpe_gpio = kzalloc(sizeof(struct stmpe_gpio), GFP_KERNEL);
>  	if (!stmpe_gpio)
> @@ -330,21 +328,28 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
>  	stmpe_gpio->chip.dev = &pdev->dev;
>  	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
>  
> -	stmpe_gpio->irq_base = stmpe->irq_base + STMPE_INT_GPIO(0);
> +	if (irq >= 0)
> +		stmpe_gpio->irq_base = stmpe->irq_base + STMPE_INT_GPIO(0);
> +	else
> +		dev_info(&pdev->dev,
> +			"device configured in no-irq mode; "
> +			"irqs are not available\n");
>  
>  	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
>  	if (ret)
>  		goto out_free;
>  
> -	ret = stmpe_gpio_irq_init(stmpe_gpio);
> -	if (ret)
> -		goto out_disable;
> +	if (irq >= 0) {
> +		ret = stmpe_gpio_irq_init(stmpe_gpio);
> +		if (ret)
> +			goto out_disable;
>  
> -	ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq, IRQF_ONESHOT,
> -				   "stmpe-gpio", stmpe_gpio);
> -	if (ret) {
> -		dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
> -		goto out_removeirq;
> +		ret = request_threaded_irq(irq, NULL, stmpe_gpio_irq,
> +				IRQF_ONESHOT, "stmpe-gpio", stmpe_gpio);
> +		if (ret) {
> +			dev_err(&pdev->dev, "unable to get irq: %d\n", ret);
> +			goto out_removeirq;
> +		}
>  	}
>  
>  	ret = gpiochip_add(&stmpe_gpio->chip);
> @@ -361,9 +366,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
>  	return 0;
>  
>  out_freeirq:
> -	free_irq(irq, stmpe_gpio);
> +	if (irq >= 0)
> +		free_irq(irq, stmpe_gpio);
>  out_removeirq:
> -	stmpe_gpio_irq_remove(stmpe_gpio);
> +	if (irq >= 0)
> +		stmpe_gpio_irq_remove(stmpe_gpio);
>  out_disable:
>  	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
>  out_free:
> @@ -391,8 +398,10 @@ static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
>  
>  	stmpe_disable(stmpe, STMPE_BLOCK_GPIO);
>  
> -	free_irq(irq, stmpe_gpio);
> -	stmpe_gpio_irq_remove(stmpe_gpio);
> +	if (irq >= 0) {
> +		free_irq(irq, stmpe_gpio);
> +		stmpe_gpio_irq_remove(stmpe_gpio);
> +	}
>  	platform_set_drvdata(pdev, NULL);
>  	kfree(stmpe_gpio);
>  

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
