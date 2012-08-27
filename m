Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2H0UML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:12:11 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:57469 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2H0UMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:12:09 -0400
Message-ID: <503BD497.9020400@kernel.org>
Date: Mon, 27 Aug 2012 21:12:07 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] drivers/iio/adc/at91_adc.c: use clk_prepare_enable
 and clk_disable_unprepare
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr> <1345996865-32082-7-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1345996865-32082-7-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2012 05:00 PM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
> clk_enable, and clk_disable and clk_unprepare.  They make the code more
> concise, and ensure that clk_unprepare is called when clk_enable fails.
> 
> A simplified version of the semantic patch that introduces calls to these
> functions is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> 
> - clk_prepare(e);
> - clk_enable(e);
> + clk_prepare_enable(e);
> 
> @@
> expression e;
> @@
> 
> - clk_disable(e);
> - clk_unprepare(e);
> + clk_disable_unprepare(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
merged to togreg branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,

Jonathan
> 
> ---
>  drivers/iio/adc/at91_adc.c |   33 +++++++++------------------------
>  1 file changed, 9 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index 98c96f9..c1e4690 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -589,18 +589,13 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
>  		goto error_free_irq;
>  	}
>  
> -	ret = clk_prepare(st->clk);
> +	ret = clk_prepare_enable(st->clk);
>  	if (ret) {
> -		dev_err(&pdev->dev, "Could not prepare the clock.\n");
> +		dev_err(&pdev->dev,
> +			"Could not prepare or enable the clock.\n");
>  		goto error_free_irq;
>  	}
>  
> -	ret = clk_enable(st->clk);
> -	if (ret) {
> -		dev_err(&pdev->dev, "Could not enable the clock.\n");
> -		goto error_unprepare_clk;
> -	}
> -
>  	st->adc_clk = devm_clk_get(&pdev->dev, "adc_op_clk");
>  	if (IS_ERR(st->adc_clk)) {
>  		dev_err(&pdev->dev, "Failed to get the ADC clock.\n");
> @@ -608,18 +603,13 @@ static int __devinit at91_adc_probe(struct platform_device *pdev)
>  		goto error_disable_clk;
>  	}
>  
> -	ret = clk_prepare(st->adc_clk);
> +	ret = clk_prepare_enable(st->adc_clk);
>  	if (ret) {
> -		dev_err(&pdev->dev, "Could not prepare the ADC clock.\n");
> +		dev_err(&pdev->dev,
> +			"Could not prepare or enable the ADC clock.\n");
>  		goto error_disable_clk;
>  	}
>  
> -	ret = clk_enable(st->adc_clk);
> -	if (ret) {
> -		dev_err(&pdev->dev, "Could not enable the ADC clock.\n");
> -		goto error_unprepare_adc_clk;
> -	}
> -
>  	/*
>  	 * Prescaler rate computation using the formula from the Atmel's
>  	 * datasheet : ADC Clock = MCK / ((Prescaler + 1) * 2), ADC Clock being
> @@ -681,13 +671,9 @@ error_remove_triggers:
>  error_unregister_buffer:
>  	at91_adc_buffer_remove(idev);
>  error_disable_adc_clk:
> -	clk_disable(st->adc_clk);
> -error_unprepare_adc_clk:
> -	clk_unprepare(st->adc_clk);
> +	clk_disable_unprepare(st->adc_clk);
>  error_disable_clk:
> -	clk_disable(st->clk);
> -error_unprepare_clk:
> -	clk_unprepare(st->clk);
> +	clk_disable_unprepare(st->clk);
>  error_free_irq:
>  	free_irq(st->irq, idev);
>  error_free_device:
> @@ -705,8 +691,7 @@ static int __devexit at91_adc_remove(struct platform_device *pdev)
>  	at91_adc_trigger_remove(idev);
>  	at91_adc_buffer_remove(idev);
>  	clk_disable_unprepare(st->adc_clk);
> -	clk_disable(st->clk);
> -	clk_unprepare(st->clk);
> +	clk_disable_unprepare(st->clk);
>  	free_irq(st->irq, idev);
>  	iio_device_free(idev);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
