Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1G1Hnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 03:43:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52960 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1G1Hnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 03:43:46 -0400
MIME-Version: 1.0
In-Reply-To: <1307926019-28958-1-git-send-email-ccross@android.com>
References: <1307926019-28958-1-git-send-email-ccross@android.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 28 Jul 2011 15:43:25 +0800
Message-ID: <CAGsJ_4xX=XhuyRZyMra+e1nuLXGYABcug49T8tYMwqkJ7urf7g@mail.gmail.com>
Subject: Re: [PATCH] ARM: mm: cache-l2x0: Add support for re-enabling l2x0
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rongjun Ying <rongjun.ying@csr.com>, "yuping.luo" <yuping.luo@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/13 Colin Cross <ccross@android.com>:
> Remove __init annotation from l2x0_init so it can be used to
> reinitialize the l2x0 after it has been reset during suspend.

__init before l2x0_init can be deleted and make it available after resume.

We just tried the following flow for l2 cache on CSR SiRFprimaII, it
seems to be working:

suspend: sync and invalidate l2 cache, then disable L2

        v7_flush_kern_cache_all

#ifdef CONFIG_CACHE_L2X0
        ldr     r0, =SIRFSOC_L2CC_VA_BASE
        ldr     r1, =L2X0_CLEAN_INV_WAY
        mov     r2, #0xff
        str     r2, [r0,r1]
        mov     r2, #0
1:
        ldr     r3, [r0,r1]
        cmp     r2,r3
        bne     1b
        ldr     r1, =L2X0_CACHE_SYNC
        mov     r2, #0
        str     r2, [r0,r1]

        ldr     r1, =L2X0_CTRL
        mov     r2, #0
        str     r2, [r0,r1]
#endif

resume:  re-initilized l2x:

 l2x0_init((void __iomem *)SIRFSOC_L2CC_VA_BASE, 0x00040000, 0x00000000);

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
>  arch/arm/include/asm/hardware/cache-l2x0.h |    3 ++-
>  arch/arm/mm/cache-l2x0.c                   |   18 ++++++++++++++----
>  2 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm/include/asm/hardware/cache-l2x0.h b/arch/arm/include/asm/hardware/cache-l2x0.h
> index 16bd480..8fd87fe 100644
> --- a/arch/arm/include/asm/hardware/cache-l2x0.h
> +++ b/arch/arm/include/asm/hardware/cache-l2x0.h
> @@ -73,7 +73,8 @@
>  #define L2X0_AUX_CTRL_EARLY_BRESP_SHIFT                30
>
>  #ifndef __ASSEMBLY__
> -extern void __init l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
> +extern void l2x0_init(void __iomem *base, __u32 aux_val, __u32 aux_mask);
> +extern void l2x0_enable(void);
>  #endif
>
>  #endif
> diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
> index ef59099..4db0d9c 100644
> --- a/arch/arm/mm/cache-l2x0.c
> +++ b/arch/arm/mm/cache-l2x0.c
> @@ -261,16 +261,26 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
>        spin_unlock_irqrestore(&l2x0_lock, flags);
>  }
>
> +/* enables l2x0 after l2x0_disable, does not invalidate */
> +void l2x0_enable(void)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&l2x0_lock, flags);
> +       writel_relaxed(1, l2x0_base + L2X0_CTRL);
> +       spin_unlock_irqrestore(&l2x0_lock, flags);
> +}
> +
>  static void l2x0_disable(void)
>  {
>        unsigned long flags;
>
>        spin_lock_irqsave(&l2x0_lock, flags);
> -       writel(0, l2x0_base + L2X0_CTRL);
> +       writel_relaxed(0, l2x0_base + L2X0_CTRL);
>        spin_unlock_irqrestore(&l2x0_lock, flags);
>  }
>

can you show your context calling l2x0_disable and l2x0_enable?

-barry
