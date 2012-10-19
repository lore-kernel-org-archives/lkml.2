Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2JSJX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:23:57 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1111 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2JSJXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:23:55 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1787
Message-ID: <50811C7C.1060605@metafoo.de>
Date: Fri, 19 Oct 2012 11:25:16 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Use devm_* for request_mem_region and ioremap
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com> <1350603664-18148-3-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1350603664-18148-3-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 01:41 AM, Marcos Paulo de Souza wrote:
> This don't change the rationale, just a cleanup.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Patch is ok in general, but it would be even better if you'd use
devm_request_and_ioremap. It does both the devm_request_mem_region and
devm_ioremap_nocache. It also checks whether the passed in memory region is
NULL and will print error messages on it's own.

Care to resend the patch with this change?

Thanks,
- Lars

> ---
>  drivers/power/jz4740-battery.c |   15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 72f6335..9d9b2a8 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -274,7 +274,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	jz_battery->mem = request_mem_region(jz_battery->mem->start,
> +	jz_battery->mem = devm_request_mem_region(&pdev->dev, jz_battery->mem->start,
>  				resource_size(jz_battery->mem),	pdev->name);
>  	if (!jz_battery->mem) {
>  		ret = -EBUSY;
> @@ -282,12 +282,12 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
> +	jz_battery->base = devm_ioremap_nocache(&pdev->dev, jz_battery->mem->start,
>  				resource_size(jz_battery->mem));
>  	if (!jz_battery->base) {
>  		ret = -EBUSY;
>  		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
> -		goto err_release_mem_region;
> +		goto err;
>  	}
>  
>  	battery = &jz_battery->battery;
> @@ -311,7 +311,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  			jz_battery);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq %d\n", ret);
> -		goto err_iounmap;
> +		goto err;
>  	}
>  	disable_irq(jz_battery->irq);
>  
> @@ -368,11 +368,7 @@ err_free_gpio:
>  		gpio_free(jz_battery->pdata->gpio_charge);
>  err_free_irq:
>  	free_irq(jz_battery->irq, jz_battery);
> -err_iounmap:
>  	platform_set_drvdata(pdev, NULL);
> -	iounmap(jz_battery->base);
> -err_release_mem_region:
> -	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
>  err:
>  	return ret;
>  }
> @@ -393,9 +389,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
>  
>  	free_irq(jz_battery->irq, jz_battery);
>  
> -	iounmap(jz_battery->base);
> -	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
> -
>  	return 0;
>  }
>  

