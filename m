Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195Ab2JSMP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:15:27 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1104 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2JSMP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:15:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18914
Message-ID: <50814454.5040603@metafoo.de>
Date: Fri, 19 Oct 2012 14:15:16 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.9) Gecko/20121014 Icedove/10.0.9
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] power/jz4740.c: Simplify exit of function
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com> <1350603664-18148-5-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1350603664-18148-5-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 01:41 AM, Marcos Paulo de Souza wrote:
> This commit simplifies the exit of probe function, by returning
> directly when it don't need to release any resources.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Looks good, but I'd just fold the relevant parts in the previous patches.

> ---
>  drivers/power/jz4740-battery.c |   17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index b80f7ed..0d6c9e4 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -262,32 +262,28 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  
>  	jz_battery->irq = platform_get_irq(pdev, 0);
>  	if (jz_battery->irq < 0) {
> -		ret = jz_battery->irq;
>  		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
> -		goto err;
> +		return jz_battery->irq;
>  	}
>  
>  	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!jz_battery->mem) {
> -		ret = -ENOENT;
>  		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
> -		goto err;
> +		return -ENOENT;
>  	}
>  
>  	jz_battery->mem = devm_request_mem_region(&pdev->dev, jz_battery->mem->start,
>  				resource_size(jz_battery->mem),	pdev->name);
>  	if (!jz_battery->mem) {
> -		ret = -EBUSY;
>  		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
> -		goto err;
> +		return -EBUSY;
>  	}
>  
>  	jz_battery->base = devm_ioremap_nocache(&pdev->dev, jz_battery->mem->start,
>  				resource_size(jz_battery->mem));
>  	if (!jz_battery->base) {
> -		ret = -EBUSY;
>  		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> -		goto err;
> +		return -EBUSY;
>  	}
>  
>  	battery = &jz_battery->battery;
> @@ -311,7 +307,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  				0, pdev->name, jz_battery);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
> -		goto err;
> +		return ret;
>  	}
>  	disable_irq(jz_battery->irq);
>  
> @@ -319,7 +315,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		ret = gpio_request(pdata->gpio_charge, dev_name(&pdev->dev));
>  		if (ret) {
>  			dev_err(&pdev->dev, "charger state gpio request failed.\n");
> -			goto err;
> +			return ret;
>  		}
>  		ret = gpio_direction_input(pdata->gpio_charge);
>  		if (ret) {
> @@ -364,7 +360,6 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  err_free_gpio:
>  	if (gpio_is_valid(pdata->gpio_charge))
>  		gpio_free(jz_battery->pdata->gpio_charge);
> -err:
>  	platform_set_drvdata(pdev, NULL);
>  	return ret;
>  }

