Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab1EaHk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:40:59 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:51705 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754064Ab1EaHk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:40:57 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1//DdCwHfIrQugBbMdfHjqV
Date: Tue, 31 May 2011 00:40:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-omap1/dma.c: Invert calls to
 platform_device_put and platform_device_del
Message-ID: <20110531074054.GL11352@atomide.com>
References: <1305305170-16922-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305305170-16922-1-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Julia Lawall <julia@diku.dk> [110513 09:42]:
> From: Julia Lawall <julia@diku.dk>
> 
> Platform_device_del should be called before platform_device_put, as
> platform_device_put can delete the structure.
> 
> Additionally, improve the error handling code for the call to ioremap, so
> that it calls platform_device_put.
> 
> The semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e1,e2;
> @@
> 
> *platform_device_put(e1);
> ... when != e1 = e2
> *platform_device_del(e1);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Thanks, applying into fixes.

> 
> ---
> Is an ioremap needed also?  Not clear, because dma_base i a global variable.

I guess you mean iounmap instead of ioremap? In this case we have static
mappings for ioremap, so iounmap is not doing anything. But should be done
for correct handling.

Regards,

Tony
 
>  arch/arm/mach-omap1/dma.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/dma.c b/arch/arm/mach-omap1/dma.c
> index d855934..f5a5220 100644
> --- a/arch/arm/mach-omap1/dma.c
> +++ b/arch/arm/mach-omap1/dma.c
> @@ -284,14 +284,15 @@ static int __init omap1_system_dma_init(void)
>  	dma_base = ioremap(res[0].start, resource_size(&res[0]));
>  	if (!dma_base) {
>  		pr_err("%s: Unable to ioremap\n", __func__);
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto exit_device_put;
>  	}
>  
>  	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
>  	if (ret) {
>  		dev_err(&pdev->dev, "%s: Unable to add resources for %s%d\n",
>  			__func__, pdev->name, pdev->id);
> -		goto exit_device_del;
> +		goto exit_device_put;
>  	}
>  
>  	p = kzalloc(sizeof(struct omap_system_dma_plat_info), GFP_KERNEL);
> @@ -299,7 +300,7 @@ static int __init omap1_system_dma_init(void)
>  		dev_err(&pdev->dev, "%s: Unable to allocate 'p' for %s\n",
>  			__func__, pdev->name);
>  		ret = -ENOMEM;
> -		goto exit_device_put;
> +		goto exit_device_del;
>  	}
>  
>  	d = kzalloc(sizeof(struct omap_dma_dev_attr), GFP_KERNEL);
> @@ -380,10 +381,10 @@ exit_release_d:
>  	kfree(d);
>  exit_release_p:
>  	kfree(p);
> -exit_device_put:
> -	platform_device_put(pdev);
>  exit_device_del:
>  	platform_device_del(pdev);
> +exit_device_put:
> +	platform_device_put(pdev);
>  
>  	return ret;
>  }
> 
