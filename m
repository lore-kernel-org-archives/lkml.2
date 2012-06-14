Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab2FNDUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 23:20:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:63166 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2FNDUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 23:20:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165424062"
Subject: Re: [PATCH] dma: coh901318: use devm allocation
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1339525164-7325-1-git-send-email-linus.walleij@stericsson.com>
References: <1339525164-7325-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jun 2012 08:43:34 +0530
Message-ID: <1339643614.1927.1639.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 20:19 +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Allocate memory, region, remap and irq for device state using
> devm_* helpers to simplify memory accounting.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Applied, thanks

> ---
>  drivers/dma/coh901318.c |   72 ++++++++++++++++-------------------------------
>  1 file changed, 24 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index e67b4e0..aa384e5 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
> @@ -1438,34 +1438,32 @@ static int __init coh901318_probe(struct platform_device *pdev)
>  
>  	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!io)
> -		goto err_get_resource;
> +		return -ENODEV;
>  
>  	/* Map DMA controller registers to virtual memory */
> -	if (request_mem_region(io->start,
> -			       resource_size(io),
> -			       pdev->dev.driver->name) == NULL) {
> -		err = -EBUSY;
> -		goto err_request_mem;
> -	}
> +	if (devm_request_mem_region(&pdev->dev,
> +				    io->start,
> +				    resource_size(io),
> +				    pdev->dev.driver->name) == NULL)
> +		return -ENOMEM;
>  
>  	pdata = pdev->dev.platform_data;
>  	if (!pdata)
> -		goto err_no_platformdata;
> +		return -ENODEV;
>  
> -	base = kmalloc(ALIGN(sizeof(struct coh901318_base), 4) +
> -		       pdata->max_channels *
> -		       sizeof(struct coh901318_chan),
> -		       GFP_KERNEL);
> +	base = devm_kzalloc(&pdev->dev,
> +			    ALIGN(sizeof(struct coh901318_base), 4) +
> +			    pdata->max_channels *
> +			    sizeof(struct coh901318_chan),
> +			    GFP_KERNEL);
>  	if (!base)
> -		goto err_alloc_coh_dma_channels;
> +		return -ENOMEM;
>  
>  	base->chans = ((void *)base) + ALIGN(sizeof(struct coh901318_base), 4);
>  
> -	base->virtbase = ioremap(io->start, resource_size(io));
> -	if (!base->virtbase) {
> -		err = -ENOMEM;
> -		goto err_no_ioremap;
> -	}
> +	base->virtbase = devm_ioremap(&pdev->dev, io->start, resource_size(io));
> +	if (!base->virtbase)
> +		return -ENOMEM;
>  
>  	base->dev = &pdev->dev;
>  	base->platform = pdata;
> @@ -1474,25 +1472,20 @@ static int __init coh901318_probe(struct platform_device *pdev)
>  
>  	COH901318_DEBUGFS_ASSIGN(debugfs_dma_base, base);
>  
> -	platform_set_drvdata(pdev, base);
> -
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
> -		goto err_no_irq;
> -
> -	err = request_irq(irq, dma_irq_handler, IRQF_DISABLED,
> -			  "coh901318", base);
> -	if (err) {
> -		dev_crit(&pdev->dev,
> -			 "Cannot allocate IRQ for DMA controller!\n");
> -		goto err_request_irq;
> -	}
> +		return irq;
> +
> +	err = devm_request_irq(&pdev->dev, irq, dma_irq_handler, IRQF_DISABLED,
> +			       "coh901318", base);
> +	if (err)
> +		return err;
>  
>  	err = coh901318_pool_create(&base->pool, &pdev->dev,
>  				    sizeof(struct coh901318_lli),
>  				    32);
>  	if (err)
> -		goto err_pool_create;
> +		return err;
>  
>  	/* init channels for device transfers */
>  	coh901318_base_init(&base->dma_slave,  base->platform->chans_slave,
> @@ -1538,6 +1531,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
>  	if (err)
>  		goto err_register_memcpy;
>  
> +	platform_set_drvdata(pdev, base);
>  	dev_info(&pdev->dev, "Initialized COH901318 DMA on virtual base 0x%08x\n",
>  		(u32) base->virtbase);
>  
> @@ -1547,19 +1541,6 @@ static int __init coh901318_probe(struct platform_device *pdev)
>  	dma_async_device_unregister(&base->dma_slave);
>   err_register_slave:
>  	coh901318_pool_destroy(&base->pool);
> - err_pool_create:
> -	free_irq(platform_get_irq(pdev, 0), base);
> - err_request_irq:
> - err_no_irq:
> -	iounmap(base->virtbase);
> - err_no_ioremap:
> -	kfree(base);
> - err_alloc_coh_dma_channels:
> - err_no_platformdata:
> -	release_mem_region(pdev->resource->start,
> -			   resource_size(pdev->resource));
> - err_request_mem:
> - err_get_resource:
>  	return err;
>  }
>  
> @@ -1570,11 +1551,6 @@ static int __exit coh901318_remove(struct platform_device *pdev)
>  	dma_async_device_unregister(&base->dma_memcpy);
>  	dma_async_device_unregister(&base->dma_slave);
>  	coh901318_pool_destroy(&base->pool);
> -	free_irq(platform_get_irq(pdev, 0), base);
> -	iounmap(base->virtbase);
> -	kfree(base);
> -	release_mem_region(pdev->resource->start,
> -			   resource_size(pdev->resource));
>  	return 0;
>  }
>  
> -- 
> 1.7.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

