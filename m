Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1FMKT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:19:56 -0400
Received: from service87.mimecast.com ([94.185.240.25]:47002 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751791Ab1FMKTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:19:55 -0400
Date: Mon, 13 Jun 2011 11:19:42 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Colin Cross <ccross@android.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
Message-ID: <20110613101942.GA7924@e102568-lin.cambridge.arm.com>
References: <1307926019-28958-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
In-Reply-To: <1307926019-28958-1-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Jun 2011 10:20:25.0937 (UTC) FILETIME=[82ED3410:01CC29B3]
X-MC-Unique: 111061311195103701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 01:46:58AM +0100, Colin Cross wrote:
> Remove __init annotation from l2x0_init so it can be used to
> reinitialize the l2x0 after it has been reset during suspend.
> 
> Only print the init messages the first time l2x0_init is called.
> 
> Add l2x0_enable to re-enable the l2x0 after l2x0_disable if
> the l2x0 was not reset.
> 
> l2x0_disable cannot use writel, as writel calls wmb(), and wmb()
> may call outer_cache_sync, which takes the same spinlock as
> l2x0_disable.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  arch/arm/include/asm/hardware/cache-l2x0.h |    3 ++-
>  arch/arm/mm/cache-l2x0.c                   |   18 ++++++++++++++----
>  2 files changed, 16 insertions(+), 5 deletions(-)
>

[...]

> +/* enables l2x0 after l2x0_disable, does not invalidate */
> +void l2x0_enable(void)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&l2x0_lock, flags);
> +	writel_relaxed(1, l2x0_base + L2X0_CTRL);
> +	spin_unlock_irqrestore(&l2x0_lock, flags);
> +}
> +
>  static void l2x0_disable(void)
>  {
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&l2x0_lock, flags);
> -	writel(0, l2x0_base + L2X0_CTRL);
> +	writel_relaxed(0, l2x0_base + L2X0_CTRL);
>  	spin_unlock_irqrestore(&l2x0_lock, flags);
>  }

This function is still dodgy to use, since we are disabling L2
possibly with current function stack lines allocated, which might wreak havoc.

>  
> -void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
> +void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
>  {
>  	__u32 aux;
>  	__u32 cache_id;
> @@ -340,7 +350,7 @@ void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask)
>  	outer_cache.disable = l2x0_disable;
>  	outer_cache.set_debug = l2x0_set_debug;
>  
> -	printk(KERN_INFO "%s cache controller enabled\n", type);
> -	printk(KERN_INFO "l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache size: %d B\n",
> +	pr_info_once("%s cache controller enabled\n", type);
> +	pr_info_once("l2x0: %d ways, CACHE_ID 0x%08x, AUX_CTRL 0x%08x, Cache size: %d B\n",
>  			ways, cache_id, aux, l2x0_size);
>  }

We might still need hooks to save/restore PL310 context since registers
like tag and data RAM control are gone on reset. Furthermore, on L2 RAM
retention we want to reinit L2 without having to invalidate L2 RAM(s),
which means we cannot use l2x0_init as it is. I added a couple of hooks to
outer_cache in order to carry out this task, patch coming.

Lorenzo

