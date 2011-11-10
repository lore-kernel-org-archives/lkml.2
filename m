Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1KJKBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:01:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:17622 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1KJKBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,488,1315206000"; 
   d="scan'208";a="35263833"
Subject: Re: [PATCH] dmaengine/ste_dma40: support pm in dma40
From: Vinod Koul <vinod.koul@intel.com>
To: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        rabin.vincent@stericsson.com
In-Reply-To: <1320813384-13651-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
References: <1320813384-13651-1-git-send-email-narayanan.gopalakrishnan@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 15:26:36 +0530
Message-ID: <1320918996.32205.1214.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 10:06 +0530, Narayanan G wrote:
> This patch adds power management support to the dma40
> driver. The DMA registers are backed up and restored,
> during suspend/resume. Also flags to track the dma usage
> have been introduced to facilitate this. Patch also includes
> few other minor changes, related to formatting, grammar.
> 
> Signed-off-by: Narayanan G <narayanan.gopalakrishnan@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/dma/ste_dma40.c    |  412 +++++++++++++++++++++++++++++++++++++++-----
>  drivers/dma/ste_dma40_ll.h |   11 ++
>  2 files changed, 378 insertions(+), 45 deletions(-)
> 
>  struct d40_base {
>  	spinlock_t			 interrupt_lock;
> @@ -282,6 +343,14 @@ struct d40_base {
>  	dma_addr_t			  phy_lcpa;
>  	resource_size_t			  lcpa_size;
>  	struct kmem_cache		 *desc_slab;
> +	int				  usage;
> +	spinlock_t			  usage_lock;
> +	u32				  reg_val_backup
> +					  [ARRAY_SIZE(d40_backup_regs)];
> +	u32				  reg_val_backup_v3
> +					  [ARRAY_SIZE(d40_backup_regs_v3)];
> +	u32				 *reg_val_backup_chan;
> +	bool				  initialized;
>  };
This is terribly hard to read :(

>  
> +static void d40_power_off(struct d40_base *base, int phy_num)
> +{
> +	u32 gcc;
> +	int i;
> +	int j;
> +	int p;
> +
> +	/*
> +	 * Disable the rest of the code because of GCC register HW bugs on v1
> +	 * which are not worth working around.  Revisit later.
> +	 */
> +	return;
unconditional return? Then what is the point in having dead code below?

> +
> +	/*
> +	 * Power off event group related to physical channel, if
> +	 * the other physical channels that belong to the same
> +	 * event group are not in use
> +	 */
> +
> +	for (j = 0; j < base->num_phy_chans; j += D40_GROUP_SIZE) {
> +
> +		for (i = 0; i < 2; i++) {
> +			p = (((phy_num & (base->num_phy_chans - 1)) + i)
> +			     & (D40_GROUP_SIZE - 1)) + j;
> +			if (p == phy_num)
> +				continue;
> +			/*
> +			 * If another physical channel in the same group is
> +			 * allocated, just return.
> +			 */
> +			if (base->phy_res[p].allocated_dst == D40_ALLOC_PHY ||
> +			    base->phy_res[p].allocated_src == D40_ALLOC_PHY) {
> +				return;
> +			}
> +		}
> +	}
> +
> +	/* The GCC register is protected via the usage_lock */
> +	gcc = readl(base->virtbase + D40_DREG_GCC);
> +
> +	gcc &= ~D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
> +					D40_DREG_GCC_SRC);
> +	gcc &= ~D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
> +					D40_DREG_GCC_DST);
> +
> +	writel(gcc, base->virtbase + D40_DREG_GCC);
> +}
> +
> +static void d40_power_on(struct d40_base *base, int phy_num)
> +{
> +	u32 gcc;
> +
> +	/*
> +	 * Disable the rest of the code because of GCC register HW bugs on v1
> +	 * which are not worth working around.  Revisit later.
> +	 */
> +	return;
again...

> +
> +	/* The GCC register is protected via the usage_lock */
> +	gcc = readl(base->virtbase + D40_DREG_GCC);
> +
> +	gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
> +				       D40_DREG_GCC_SRC);
> +	gcc |= D40_DREG_GCC_EVTGRP_ENA(D40_PHYS_TO_GROUP(phy_num),
> +				       D40_DREG_GCC_DST);
> +
> +	writel(gcc, base->virtbase + D40_DREG_GCC);
> +}
> +
> +static void d40_usage_inc(struct d40_chan *d40c)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&d40c->base->usage_lock, flags);
> +
> +	d40c->base->usage++;
> +
> +	if (d40c->base->usage == 1)
> +		pm_runtime_get_sync(d40c->base->dev);
i am not sure why you are doing your own counting when runtime_pm
already does that. Just make sure you call pm_runtime_get/put and every
inc/dec path.

> @@ -2741,9 +3050,9 @@ failure:
>  static void __init d40_hw_init(struct d40_base *base)
>  {
>  
> -	static const struct d40_reg_val dma_init_reg[] = {
> +	static struct d40_reg_val dma_init_reg[] = {
>  		/* Clock every part of the DMA block from start */
> -		{ .reg = D40_DREG_GCC,    .val = 0x0000ff01},
> +		{ .reg = D40_DREG_GCC,    .val = D40_DREG_GCC_ENABLE_ALL},
>  
>  		/* Interrupts on all logical channels */
>  		{ .reg = D40_DREG_LCMIS0, .val = 0xFFFFFFFF},
> @@ -2853,8 +3162,8 @@ static int __init d40_lcla_allocate(struct d40_base *base)
>  		base->lcla_pool.base = (void *)page_list[i];
>  	} else {
>  		/*
> -		 * After many attempts and no succees with finding the correct
> -		 * alignment, try with allocating a big buffer.
> +		 * After many attempts, no succees with finding the correct
succeed?
> +		 * alignment try with allocating a big buffer.
>  		 */
>  		dev_warn(base->dev,
>  			 "[%s] Failed to get %d pages @ 18 bit align.\n",




-- 
~Vinod

