Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2AQQvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:51:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:5940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab2AQQvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:51:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="97474266"
Subject: Re: [PATCH 4/15] drivers/dma/pl330.c: add missing iounmap
From: Vinod Koul <vinod.koul@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Dan Williams <dan.j.williams@intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1326362117-29371-4-git-send-email-Julia.Lawall@lip6.fr>
References: <1326362117-29371-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 22:21:44 +0530
Message-ID: <1326819104.1540.166.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 10:55 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Add missing iounmap in error handling code, in a case where the function
> already preforms iounmap on some other execution path.
> 
> This patch additionally adds calls to clk_disable and clk_put.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> statement S,S1;
> int ret;
> @@
> e = \(ioremap\|ioremap_nocache\)(...)
> ... when != iounmap(e)
> if (<+...e...+>) S
> ... when any
>     when != iounmap(e)
> *if (...)
>    { ... when != iounmap(e)
>      return ...; }
> ... when any
> iounmap(e);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Acked by Vinod Koul <vinod.koul@linux.intel.com>

Which tree is this intended for?
> 
> ---
> Perhaps clk_put is not needed?  It is not present in the remove function.
> 
>  drivers/dma/pl330.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2b3aab3..2f83094 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2690,7 +2690,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	if (IS_ERR(pdmac->clk)) {
>  		dev_err(&adev->dev, "Cannot get operation clock.\n");
>  		ret = -EINVAL;
> -		goto probe_err1;
> +		goto probe_err2;
>  	}
>  
>  	amba_set_drvdata(adev, pdmac);
> @@ -2704,11 +2704,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	ret = request_irq(irq, pl330_irq_handler, 0,
>  			dev_name(&adev->dev), pi);
>  	if (ret)
> -		goto probe_err2;
> +		goto probe_err3;
>  
>  	ret = pl330_add(pi);
>  	if (ret)
> -		goto probe_err3;
> +		goto probe_err4;
>  
>  	INIT_LIST_HEAD(&pdmac->desc_pool);
>  	spin_lock_init(&pdmac->pool_lock);
> @@ -2765,7 +2765,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	ret = dma_async_device_register(pd);
>  	if (ret) {
>  		dev_err(&adev->dev, "unable to register DMAC\n");
> -		goto probe_err4;
> +		goto probe_err5;
>  	}
>  
>  	dev_info(&adev->dev,
> @@ -2778,10 +2778,15 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  
>  	return 0;
>  
> -probe_err4:
> +probe_err5:
>  	pl330_del(pi);
> -probe_err3:
> +probe_err4:
>  	free_irq(irq, pi);
> +probe_err3:
> +#ifndef CONFIG_PM_RUNTIME
> +	clk_disable(pdmac->clk);
> +#endif
> +	clk_put(pdmac->clk);
>  probe_err2:
>  	iounmap(pi->base);
>  probe_err1:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
~Vinod

