Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2JXEYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 00:24:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:54727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2JXEYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 00:24:19 -0400
Subject: Re: [PATCH v2 2/4] DMA: PL330: Change allocation method to
 properly free  DMA descriptors
From: Vinod Koul <vkoul@infradead.org>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: vinod.koul@intel.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jassisinghbrar@gmail.com,
        boojin.kim@samsung.com, patches@linaro.org, kgene.kim@samsung.com
In-Reply-To: <1349432276-22919-3-git-send-email-inderpal.singh@linaro.org>
References: <1349432276-22919-1-git-send-email-inderpal.singh@linaro.org>
	 <1349432276-22919-3-git-send-email-inderpal.singh@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Oct 2012 09:40:50 +0530
Message-ID: <1351051850.5263.17.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-05 at 15:47 +0530, Inderpal Singh wrote:
> In probe, memory for multiple DMA descriptors were being allocated at once
> and then it was being split and added into DMA pool one by one. The address
> of this memory allocation is not being saved anywhere. To free this memory,
> the address is required. Initially the first node of the pool will be
> pointed by this address but as we use this pool the descs will shuffle and
> hence we will lose the track of the address.
> 
> This patch does following:
> 
> 1. Allocates DMA descs one by one and then adds them to pool so that all
>    descs can be fetched and memory freed one by one. This way runtime
>    added descs can also be freed.
> 2. Free DMA descs in case of error in probe and in module's remove function
For probe, again you have cleaner code by using devm_kzalloc.

On 1, if we use the devm_kzalloc then we don't need to allocate in
chunks right?

> 
> Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
> ---
>  drivers/dma/pl330.c |   35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 10c6b6a..bf71ff7 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -2541,20 +2541,20 @@ static int add_desc(struct dma_pl330_dmac *pdmac, gfp_t flg, int count)
>  	if (!pdmac)
>  		return 0;
>  
> -	desc = kmalloc(count * sizeof(*desc), flg);
> -	if (!desc)
> -		return 0;
> +	for (i = 0; i < count; i++) {
> +		desc = kmalloc(sizeof(*desc), flg);
> +		if (!desc)
> +			break;
> +		_init_desc(desc);
>  
> -	spin_lock_irqsave(&pdmac->pool_lock, flags);
> +		spin_lock_irqsave(&pdmac->pool_lock, flags);
>  
> -	for (i = 0; i < count; i++) {
> -		_init_desc(&desc[i]);
> -		list_add_tail(&desc[i].node, &pdmac->desc_pool);
> -	}
> +		list_add_tail(&desc->node, &pdmac->desc_pool);
>  
> -	spin_unlock_irqrestore(&pdmac->pool_lock, flags);
> +		spin_unlock_irqrestore(&pdmac->pool_lock, flags);
> +	}
>  
> -	return count;
> +	return i;
>  }
>  
>  static struct dma_pl330_desc *
> @@ -2857,6 +2857,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	struct dma_pl330_platdata *pdat;
>  	struct dma_pl330_dmac *pdmac;
>  	struct dma_pl330_chan *pch;
> +	struct dma_pl330_desc *desc;
>  	struct pl330_info *pi;
>  	struct dma_device *pd;
>  	struct resource *res;
> @@ -2978,6 +2979,12 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  probe_err5:
>  	kfree(pdmac->peripherals);
>  probe_err4:
> +	while (!list_empty(&pdmac->desc_pool)) {
> +		desc = list_entry(pdmac->desc_pool.next,
> +				struct dma_pl330_desc, node);
> +		list_del(&desc->node);
> +		kfree(desc);
> +	}
>  	pl330_del(pi);
>  probe_err3:
>  	free_irq(irq, pi);
> @@ -2994,6 +3001,7 @@ static int __devexit pl330_remove(struct amba_device *adev)
>  {
>  	struct dma_pl330_dmac *pdmac = amba_get_drvdata(adev);
>  	struct dma_pl330_chan *pch, *_p;
> +	struct dma_pl330_desc *desc;
>  	struct pl330_info *pi;
>  	struct resource *res;
>  	int irq;
> @@ -3015,6 +3023,13 @@ static int __devexit pl330_remove(struct amba_device *adev)
>  		pl330_free_chan_resources(&pch->chan);
>  	}
>  
> +	while (!list_empty(&pdmac->desc_pool)) {
> +		desc = list_entry(pdmac->desc_pool.next,
> +				struct dma_pl330_desc, node);
> +		list_del(&desc->node);
> +		kfree(desc);
> +	}
> +
>  	pi = &pdmac->pif;
>  
>  	pl330_del(pi);


-- 
Vinod Koul
Intel Corp.

