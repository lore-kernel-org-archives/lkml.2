Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2JSJne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:43:34 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1048 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2JSJnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:43:33 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12997
Message-ID: <50812112.2020709@metafoo.de>
Date: Fri, 19 Oct 2012 11:44:50 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Use devm_request_irq to avoid some checks
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com> <1350603664-18148-4-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1350603664-18148-4-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 01:41 AM, Marcos Paulo de Souza wrote:
> With this we can remove a lot of checks.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

This one is a bit more tricky and the driver currently gets it (partially
wrong). The issue is that since the power supply is referenced in the
interrupt handler, the IRQs should be requested after the power supply has
been registered and be freed before the power supply is unregistered.

So devm can't really be used here. But as I said the current driver already
gets it wrong.

- Lars

> ---
>  drivers/power/jz4740-battery.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 9d9b2a8..b80f7ed 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -307,8 +307,8 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  
>  	INIT_DELAYED_WORK(&jz_battery->work, jz_battery_work);
>  
> -	ret = request_irq(jz_battery->irq, jz_battery_irq_handler, 0, pdev->name,
> -			jz_battery);
> +	ret = devm_request_irq(&pdev->dev, jz_battery->irq, jz_battery_irq_handler, 
> +				0, pdev->name, jz_battery);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
>  		goto err;
> @@ -319,7 +319,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		ret = gpio_request(pdata->gpio_charge, dev_name(&pdev->dev));
>  		if (ret) {
>  			dev_err(&pdev->dev, "charger state gpio request failed.\n");
> -			goto err_free_irq;
> +			goto err;
>  		}
>  		ret = gpio_direction_input(pdata->gpio_charge);
>  		if (ret) {
> @@ -330,7 +330,8 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		jz_battery->charge_irq = gpio_to_irq(pdata->gpio_charge);
>  
>  		if (jz_battery->charge_irq >= 0) {
> -			ret = request_irq(jz_battery->charge_irq,
> +			ret = devm_request_irq(&pdev->dev,
> +				    jz_battery->charge_irq,
>  				    jz_battery_charge_irq,
>  				    IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
>  				    dev_name(&pdev->dev), jz_battery);
> @@ -352,7 +353,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  	ret = power_supply_register(&pdev->dev, &jz_battery->battery);
>  	if (ret) {
>  		dev_err(&pdev->dev, "power supply battery register failed.\n");
> -		goto err_free_charge_irq;
> +		goto err_free_gpio;
>  	}
>  
>  	platform_set_drvdata(pdev, jz_battery);
> @@ -360,16 +361,11 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> -err_free_charge_irq:
> -	if (jz_battery->charge_irq >= 0)
> -		free_irq(jz_battery->charge_irq, jz_battery);
>  err_free_gpio:
>  	if (gpio_is_valid(pdata->gpio_charge))
>  		gpio_free(jz_battery->pdata->gpio_charge);
> -err_free_irq:
> -	free_irq(jz_battery->irq, jz_battery);
> -	platform_set_drvdata(pdev, NULL);
>  err:
> +	platform_set_drvdata(pdev, NULL);
>  	return ret;
>  }
>  
> @@ -379,16 +375,11 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
>  
>  	cancel_delayed_work_sync(&jz_battery->work);
>  
> -	if (gpio_is_valid(jz_battery->pdata->gpio_charge)) {
> -		if (jz_battery->charge_irq >= 0)
> -			free_irq(jz_battery->charge_irq, jz_battery);
> +	if (gpio_is_valid(jz_battery->pdata->gpio_charge))
>  		gpio_free(jz_battery->pdata->gpio_charge);
> -	}
>  
>  	power_supply_unregister(&jz_battery->battery);
>  
> -	free_irq(jz_battery->irq, jz_battery);
> -
>  	return 0;
>  }
>  

