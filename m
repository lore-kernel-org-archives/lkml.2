Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab0KVXco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 18:32:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16803 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab0KVXcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 18:32:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6175"; a="63741860"
Subject: Re: [PATCH 2/3] msm: iommu: Clock control for the IOMMU driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1290222154-11096-3-git-send-email-stepanm@codeaurora.org>
References: <1290222154-11096-1-git-send-email-stepanm@codeaurora.org>
	 <1290222154-11096-3-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 15:32:41 -0800
Message-ID: <1290468761.4258.26.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 19:02 -0800, Stepan Moskovchenko wrote:
> Add clock control to the IOMMU driver. The IOMMU bus clock
> (and potentially an AXI clock) need to be on to gain access
> to IOMMU registers. Actively control these clocks when
> needed instead of leaving them on.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
> Please hold off on this until the clock driver is in.
>  arch/arm/mach-msm/iommu.c |   82 ++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 70 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
> index a468ee3..83381c3 100644
> --- a/arch/arm/mach-msm/iommu.c
> +++ b/arch/arm/mach-msm/iommu.c
> @@ -26,6 +26,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/slab.h>
>  #include <linux/iommu.h>
> +#include <linux/clk.h>
> 
>  #include <asm/cacheflush.h>
>  #include <asm/sizes.h>
> @@ -50,12 +51,36 @@ struct msm_priv {
>  	struct list_head list_attached;
>  };
> 
> -static void __flush_iotlb(struct iommu_domain *domain)
> +static int __enable_clocks(struct msm_iommu_drvdata *drvdata)
> +{
> +	int ret;
> +
> +	ret = clk_enable(drvdata->pclk);

You don't need to check if pclk is null ?

> +	if (ret)
> +		goto fail;
> +
> +	if (drvdata->clk) {
> +		ret = clk_enable(drvdata->clk);
> +		if (ret)
> +			clk_disable(drvdata->pclk);
> +	}
> +fail:
> +	return ret;
> +}
> +
> +static void __disable_clocks(struct msm_iommu_drvdata *drvdata)
> +{
> +	if (drvdata->clk)
> +		clk_disable(drvdata->clk);
> +	clk_disable(drvdata->pclk);
> +}
> +
> +static int __flush_iotlb(struct iommu_domain *domain)
>  {
>  	struct msm_priv *priv = domain->priv;
>  	struct msm_iommu_drvdata *iommu_drvdata;
>  	struct msm_iommu_ctx_drvdata *ctx_drvdata;
> -
> +	int ret = 0;
>  #ifndef CONFIG_IOMMU_PGTABLES_L2
>  	unsigned long *fl_table = priv->pgtable;
>  	int i;
> @@ -77,8 +102,18 @@ static void __flush_iotlb(struct iommu_domain *domain)
>  			BUG();
> 
>  		iommu_drvdata = dev_get_drvdata(ctx_drvdata->pdev->dev.parent);
> +		if (!iommu_drvdata)
> +			BUG();

Just do,

BUG_ON(!iommu_drvdata);

> +		ret = __enable_clocks(iommu_drvdata);
> +		if (ret)
> +			goto fail;
> +
>  		SET_CTX_TLBIALL(iommu_drvdata->base, ctx_drvdata->num, 0);
> +		__disable_clocks(iommu_drvdata);
>  	}
> +fail:
> +	return ret;
>  }
> 
>  static void __reset_context(void __iomem *base, int ctx)
> @@ -263,11 +298,16 @@ static int msm_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
>  			goto fail;
>  		}
> 
> +	ret = __enable_clocks(iommu_drvdata);
> +	if (ret)
> +		goto fail;
> +
>  	__program_context(iommu_drvdata->base, ctx_dev->num,
>  			  __pa(priv->pgtable));
> 
> +	__disable_clocks(iommu_drvdata);
>  	list_add(&(ctx_drvdata->attached_elm), &priv->list_attached);
> -	__flush_iotlb(domain);
> +	ret = __flush_iotlb(domain);
> 
>  fail:
>  	spin_unlock_irqrestore(&msm_iommu_lock, flags);
> @@ -282,6 +322,7 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
>  	struct msm_iommu_drvdata *iommu_drvdata;
>  	struct msm_iommu_ctx_drvdata *ctx_drvdata;
>  	unsigned long flags;
> +	int ret;
> 
>  	spin_lock_irqsave(&msm_iommu_lock, flags);
>  	priv = domain->priv;
> @@ -296,8 +337,16 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
>  	if (!iommu_drvdata || !ctx_drvdata || !ctx_dev)
>  		goto fail;
> 
> -	__flush_iotlb(domain);
> +	ret = __flush_iotlb(domain);

What the relationship between this __flush_iotlb() and turning the
clocks on/off.

> +	if (ret)
> +		goto fail;
> +
> +	ret = __enable_clocks(iommu_drvdata);
> +	if (ret)
> +		goto fail;
> +
>  	__reset_context(iommu_drvdata->base, ctx_dev->num);
> +	__disable_clocks(iommu_drvdata);
>  	list_del_init(&ctx_drvdata->attached_elm);
> 
>  fail:
> @@ -410,7 +459,7 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
>  				SL_AP1 | SL_SHARED | SL_TYPE_LARGE | pgprot;
>  	}
> 
> -	__flush_iotlb(domain);
> +	ret = __flush_iotlb(domain);
>  fail:
>  	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>  	return ret;
> @@ -495,7 +544,7 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
>  		}
>  	}
> 
> -	__flush_iotlb(domain);
> +	ret = __flush_iotlb(domain);
>  fail:
>  	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>  	return ret;
> @@ -526,13 +575,14 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
>  	base = iommu_drvdata->base;
>  	ctx = ctx_drvdata->num;
> 
> +	ret = __enable_clocks(iommu_drvdata);
> +	if (ret)
> +		goto fail;
> +
>  	/* Invalidate context TLB */
>  	SET_CTX_TLBIALL(base, ctx, 0);
>  	SET_V2PPR_VA(base, ctx, va >> V2Pxx_VA_SHIFT);
> 
> -	if (GET_FAULT(base, ctx))
> -		goto fail;
> -
>  	par = GET_PAR(base, ctx);
> 
>  	/* We are dealing with a supersection */
> @@ -541,6 +591,10 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
>  	else	/* Upper 20 bits from PAR, lower 12 from VA */
>  		ret = (par & 0xFFFFF000) | (va & 0x00000FFF);
> 
> +	if (GET_FAULT(base, ctx))
> +		ret = 0;
> +
> +	__disable_clocks(iommu_drvdata);
>  fail:
>  	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>  	return ret;
> @@ -583,8 +637,8 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
>  {
>  	struct msm_iommu_drvdata *drvdata = dev_id;
>  	void __iomem *base;
> -	unsigned int fsr = 0;
> -	int ncb = 0, i = 0;
> +	unsigned int fsr;
> +	int ncb, i, ret;
> 
>  	spin_lock(&msm_iommu_lock);
> 
> @@ -595,10 +649,13 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
> 
>  	base = drvdata->base;
> 
> -	pr_err("===== WOAH! =====\n");

Cleanup right? It doesn't need it's own patch, but you could mention in
the description that you've done "minor cleanups" or something to that
effect.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
Forum.


