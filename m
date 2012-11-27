Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2K0XHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:07:50 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51416 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2K0XHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:07:49 -0500
Date: Wed, 28 Nov 2012 00:07:47 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers/uio/uio_pdrv_genirq.c: Fix memory leak &
 confusing labels
Message-ID: <20121127230747.GB2605@local>
References: <201211271929.32315.vitas@nppfactor.kiev.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211271929.32315.vitas@nppfactor.kiev.ua>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 07:29:32PM +0200, Vitalii Demianets wrote:
> Memory leak was caused by jumping to the wrong exit label. So, it is good time
> to improve misleading label names too.

I agree that bad0, bad1, and bad2 are not the best choice for label names...
I don't have any objections to your renaming.

But there's a more serious bug, maybe you can fix that as well while you're
at it? (See below)

Thanks,
Hans

> 
> Signed-off-by: Vitalii Demianets <vitas@nppfactor.kiev.ua>
> ---
>  drivers/uio/uio_pdrv_genirq.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
> index 42202cd..b88cf7b 100644
> --- a/drivers/uio/uio_pdrv_genirq.c
> +++ b/drivers/uio/uio_pdrv_genirq.c
> @@ -110,7 +110,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  		if (!uioinfo) {
>  			ret = -ENOMEM;
>  			dev_err(&pdev->dev, "unable to kmalloc\n");
> -			goto bad2;
> +			goto out;
>  		}
>  		uioinfo->name = pdev->dev.of_node->name;
>  		uioinfo->version = "devicetree";
> @@ -125,20 +125,20 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  
>  	if (!uioinfo || !uioinfo->name || !uioinfo->version) {
>  		dev_err(&pdev->dev, "missing platform_data\n");
> -		goto bad0;
> +		goto out_uioinfo;
>  	}
>  
>  	if (uioinfo->handler || uioinfo->irqcontrol ||
>  	    uioinfo->irq_flags & IRQF_SHARED) {
>  		dev_err(&pdev->dev, "interrupt configuration error\n");
> -		goto bad0;
> +		goto out_uioinfo;
>  	}
>  
>  	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>  	if (!priv) {
>  		ret = -ENOMEM;
>  		dev_err(&pdev->dev, "unable to kmalloc\n");
> -		goto bad0;
> +		goto out_uioinfo;
>  	}
>  
>  	priv->uioinfo = uioinfo;
> @@ -150,7 +150,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  		ret = platform_get_irq(pdev, 0);
>  		if (ret < 0) {
>  			dev_err(&pdev->dev, "failed to get IRQ\n");
> -			goto bad0;
> +			goto out_priv;
>  		}
>  		uioinfo->irq = ret;
>  	}
> @@ -205,19 +205,20 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
>  	ret = uio_register_device(&pdev->dev, priv->uioinfo);
>  	if (ret) {
>  		dev_err(&pdev->dev, "unable to register uio device\n");
> -		goto bad1;
> +		goto out_pm;
>  	}
>  
>  	platform_set_drvdata(pdev, priv);
>  	return 0;
> - bad1:
> -	kfree(priv);
> +out_pm:
>  	pm_runtime_disable(&pdev->dev);
> - bad0:
> +out_priv:
> +	kfree(priv);
> +out_uioinfo:
>  	/* kfree uioinfo for OF */
>  	if (pdev->dev.of_node)
>  		kfree(uioinfo);

The free() depends on pdev->dev.of_node, while the allocation doesn't!!!!
That's another source of memory leaks.

> - bad2:
> +out:
>  	return ret;
>  }
>  
> -- 
> 1.7.8.6
> 
