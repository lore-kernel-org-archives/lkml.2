Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab2JVHAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:00:21 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:55220 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab2JVHAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:00:17 -0400
Message-ID: <5084EF0E.20300@metafoo.de>
Date: Mon, 22 Oct 2012 09:00:30 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120922 Icedove/3.0.11
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] drivers: power: jz4740_battery: Use devm_request_and_ioremap
References: <1350868425-26852-1-git-send-email-marcos.souza.org@gmail.com> <1350868425-26852-3-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1350868425-26852-3-git-send-email-marcos.souza.org@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 03:13 AM, Marcos Paulo de Souza wrote:
> And remove all checks abvout request_mem_region and ioremap.
> This is just a cleanup. Not functional changes here.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Thanks, looks almost good. But you could also have removed the check and error
message after platform_get_resource since devm_request_and_ioremap also does
this internally. Also you can remove the mem field from jz_battery struct since
it now only is used in the probe function.

> ---
>  drivers/power/jz4740-battery.c |   23 +++++------------------
>  1 file changed, 5 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 59900c6..1df7be8 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -272,19 +272,12 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		return -ENOENT;
>  	}
>  
> -	jz_battery->mem = request_mem_region(jz_battery->mem->start,
> -				resource_size(jz_battery->mem),	pdev->name);
> -	if (!jz_battery->mem) {
> -		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
> -		return -EBUSY;
> -	}
> +	jz_battery->base = devm_request_and_ioremap(&pdev->dev
> +							, jz_battery->mem);

The comma should go on the previous line, after the dev.

>  
> -	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
> -				resource_size(jz_battery->mem));
>  	if (!jz_battery->base) {
> -		ret = -EBUSY;
>  		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> -		goto err_release_mem_region;
> +		return -EBUSY;
>  	}
>  
>  	battery = &jz_battery->battery;
> @@ -308,7 +301,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  			jz_battery);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
> -		goto err_iounmap;
> +		goto err_irq;
>  	}
>  	disable_irq(jz_battery->irq);
>  
> @@ -365,11 +358,8 @@ err_free_gpio:
>  		gpio_free(jz_battery->pdata->gpio_charge);
>  err_free_irq:
>  	free_irq(jz_battery->irq, jz_battery);
> -err_iounmap:
> +err_irq:
>  	platform_set_drvdata(pdev, NULL);
> -	iounmap(jz_battery->base);
> -err_release_mem_region:
> -	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
>  	return ret;
>  }
>  
> @@ -389,9 +379,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
>  
>  	free_irq(jz_battery->irq, jz_battery);
>  
> -	iounmap(jz_battery->base);
> -	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
> -
>  	return 0;
>  }
>  

