Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab1I2WQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:16:21 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:7866 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136Ab1I2WQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:16:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAFAKfshE520ueC/2dsb2JhbABBqBt4DwEBgUIBASwTFAgjGxgcJhgFCCQICwkUBIdfuwyGMmEEh3CUP4hx
Date: Fri, 30 Sep 2011 07:46:15 +0930
From: Kevin Shanahan <kmshanah@disenchant.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ttm/dma: Implement set_page_caching implementation
 in the TTM DMA pool code.
Message-ID: <20110929221615.GF3894@cubit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-29 20:33:52, Konrad Rzeszutek Wilk wrote:
> . which is pretty much like the other TTM pool except it
> also handles moving the page to another pool list.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc_dma.c |   96 ++++++++++++++++++++++++++++++
>  1 files changed, 96 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> index 5909d28..cea031e 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
> @@ -1307,11 +1307,107 @@ static int ttm_dma_page_alloc_debugfs(struct seq_file *m, void *data)
>  	mutex_unlock(&_manager->lock);
>  	return 0;
>  }
> +#ifdef CONFIG_X86
> +static int ttm_dma_page_set_page_caching(struct page *p,
> +					 int flags,
> +					 enum ttm_caching_state c_old,
> +					 enum ttm_caching_state c_new,
> +					 struct device *dev)
> +{
> +	struct dma_pool *src, *dst;
> +	enum pool_type type;
> +	struct dma_page *dma_p;
> +	bool found = false;
> +	unsigned long irq_flags;
> +	int ret = 0;
> +
> +	if (!p)
> +		return 0;
> +
> +	if (PageHighMem(p))
> +		return 0;
> +
> +	type = ttm_to_type(flags, c_old);
> +	src = ttm_dma_find_pool(dev, type);
> +	if (!src) {
> +		WARN_ON(!src);
> +		return -ENOMEM;
> +	}
> +	type = ttm_to_type(flags, c_new);
> +	dst = ttm_dma_find_pool(dev, type);
> +	if (!dst) {
> +		gfp_t gfp_flags;
> +		if (flags & TTM_PAGE_FLAG_DMA32)
> +			gfp_flags = GFP_USER | GFP_DMA32;
> +		else
> +			gfp_flags = GFP_HIGHUSER;
> +
> +		if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
> +			gfp_flags |= __GFP_ZERO;
> +
> +		dst = ttm_dma_pool_init(dev, gfp_flags, type);
> +		if (IS_ERR_OR_NULL(dst))
> +			return -ENOMEM;
> +	}
> +
> +	dev_dbg(dev, "(%d) Caching %p (%p) from %x to %x.\n", current->pid,
> +		p, page_address(p), c_old, c_new);
> +
> +	if (c_old != tt_cached) {
> +		/* p isn't in the default caching state, set it to
> +		 * writeback first to free its current memtype. */
> +
> +		ret = set_pages_wb(p, 1);
> +		if (ret)
> +			return ret;
> +	}
>  
> +	if (c_new == tt_wc)
> +		ret = set_memory_wc((unsigned long) page_address(p), 1);
> +	else if (c_new == tt_uncached)
> +		ret = set_pages_uc(p, 1);
> +
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(src->dev, "(%s:%d) Moving %p (%p) to %s.\n", src->name,
> +		current->pid, p, page_address(p), dst->name);
> +
> +	/* To make it faster we only take the spinlock on list
> +	 * removal, and later on adding the page to the destination pool. */
> +	spin_lock_irqsave(&src->lock, irq_flags);
> +	list_for_each_entry(dma_p, &src->page_list, page_list) {
> +		if (virt_to_page(dma_p->vaddr) != p) {
> +			pr_debug("%s: (%s:%d) Skipping %p (%p) (DMA:0x%lx)\n",
> +				src->dev_name, src->name, current->pid,
> +				dma_p->vaddr,
> +				virt_to_page(dma_p->vaddr),
> +				(unsigned long)dma_p->dma);
> +			continue;
> +		}
> +		list_del(&dma_p->page_list);
> +		src->npages_in_use -= 1;
> +		found = true;
> +		break;
> +	}
> +	spin_lock_irqsave(&src->lock, irq_flags);
        ^^^^^^^^^^^^^^^^^

Was this meant to be spin_unlock_irqrestore?

Cheers,
Kevin.

> +	if (!found)
> +		return -ENODEV;
> +
> +	spin_lock_irqsave(&dst->lock, irq_flags);
> +	list_add(&dma_p->page_list, &dst->page_list);
> +	dst->npages_in_use++;
> +	spin_unlock_irqrestore(&dst->lock, irq_flags);
> +	return 0;
> +};
> +#endif
>  struct ttm_page_alloc_func ttm_page_alloc_dma = {
>  	.get_pages	= ttm_dma_get_pages,
>  	.put_pages	= ttm_dma_put_pages,
>  	.alloc_init	= ttm_dma_page_alloc_init,
>  	.alloc_fini	= ttm_dma_page_alloc_fini,
>  	.debugfs	= ttm_dma_page_alloc_debugfs,
> +#ifdef CONFIG_X86
> +	.set_caching	= ttm_dma_page_set_page_caching,
> +#endif
>  };
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/etc.
