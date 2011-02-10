Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab1BJXs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:48:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:52645 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab1BJXsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:48:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FyunQ5CptgoYKLKyKsbtsoC5kfw1xuvKekLaO2qxlV/qNEiXM9so8mVkCdgmjv5tgt
         E8BAd0ABi9MyHdmc9Nng==
MIME-Version: 1.0
In-Reply-To: <20110210223258.848294582@linutronix.de>
References: <20110210222908.661199947@linutronix.de>
	<20110210223258.848294582@linutronix.de>
Date: Thu, 10 Feb 2011 15:48:50 -0800
X-Google-Sender-Auth: Rts6e5H1ORWjmhT-MAY1ACwiXJ0
Message-ID: <AANLkTi=fx5P=nqVT8napoAdpT8_i4m-n-Ua7LmYQ1JA-@mail.gmail.com>
Subject: Re: [patch 47/75] arm: tegra: Remove unused function which fiddles
 with irq_desc
From: Colin Cross <ccross@android.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 3:37 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> These functions are unused and in the way of cleanups in the core
> code. If you have special requirements vs. irqs and PM then please
> talk to me. Access to the generic core internals is going away.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Colin Cross <ccross@android.com>
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/mach-tegra/gpio.c |   63 ---------------------------------------------
>  arch/arm/mach-tegra/irq.c  |   58 -----------------------------------------
>  2 files changed, 121 deletions(-)
>
> Index: linux-2.6-tip/arch/arm/mach-tegra/gpio.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/arm/mach-tegra/gpio.c
> +++ linux-2.6-tip/arch/arm/mach-tegra/gpio.c
> @@ -253,69 +253,6 @@ static void tegra_gpio_irq_handler(unsig
>  }
>
>  #ifdef CONFIG_PM
> -void tegra_gpio_resume(void)
> -{
> -       unsigned long flags;
> -       int b, p, i;
> -
> -       local_irq_save(flags);
> -
> -       for (b = 0; b < ARRAY_SIZE(tegra_gpio_banks); b++) {
> -               struct tegra_gpio_bank *bank = &tegra_gpio_banks[b];
> -
> -               for (p = 0; p < ARRAY_SIZE(bank->oe); p++) {
> -                       unsigned int gpio = (b<<5) | (p<<3);
> -                       __raw_writel(bank->cnf[p], GPIO_CNF(gpio));
> -                       __raw_writel(bank->out[p], GPIO_OUT(gpio));
> -                       __raw_writel(bank->oe[p], GPIO_OE(gpio));
> -                       __raw_writel(bank->int_lvl[p], GPIO_INT_LVL(gpio));
> -                       __raw_writel(bank->int_enb[p], GPIO_INT_ENB(gpio));
> -               }
> -       }
> -
> -       local_irq_restore(flags);
> -
> -       for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
> -               struct irq_desc *desc = irq_to_desc(i);
> -               if (!desc || (desc->status & IRQ_WAKEUP))
> -                       continue;
> -               enable_irq(i);
> -       }
> -}
> -
> -void tegra_gpio_suspend(void)
> -{
> -       unsigned long flags;
> -       int b, p, i;
> -
> -       for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
> -               struct irq_desc *desc = irq_to_desc(i);
> -               if (!desc)
> -                       continue;
> -               if (desc->status & IRQ_WAKEUP) {
> -                       int gpio = i - INT_GPIO_BASE;
> -                       pr_debug("gpio %d.%d is wakeup\n", gpio/8, gpio&7);
> -                       continue;
> -               }
> -               disable_irq(i);
> -       }
> -
> -       local_irq_save(flags);
> -       for (b = 0; b < ARRAY_SIZE(tegra_gpio_banks); b++) {
> -               struct tegra_gpio_bank *bank = &tegra_gpio_banks[b];
> -
> -               for (p = 0; p < ARRAY_SIZE(bank->oe); p++) {
> -                       unsigned int gpio = (b<<5) | (p<<3);
> -                       bank->cnf[p] = __raw_readl(GPIO_CNF(gpio));
> -                       bank->out[p] = __raw_readl(GPIO_OUT(gpio));
> -                       bank->oe[p] = __raw_readl(GPIO_OE(gpio));
> -                       bank->int_enb[p] = __raw_readl(GPIO_INT_ENB(gpio));
> -                       bank->int_lvl[p] = __raw_readl(GPIO_INT_LVL(gpio));
> -               }
> -       }
> -       local_irq_restore(flags);
> -}
> -
>  static int tegra_gpio_wake_enable(struct irq_data *d, unsigned int enable)
>  {
>        struct tegra_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> Index: linux-2.6-tip/arch/arm/mach-tegra/irq.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/arm/mach-tegra/irq.c
> +++ linux-2.6-tip/arch/arm/mach-tegra/irq.c
> @@ -111,61 +111,3 @@ void __init tegra_init_irq(void)
>                set_irq_flags(i, IRQF_VALID);
>        }
>  }
> -
> -#ifdef CONFIG_PM
> -static u32 cop_ier[PPI_NR];
> -static u32 cpu_ier[PPI_NR];
> -static u32 cpu_iep[PPI_NR];
> -
> -void tegra_irq_suspend(void)
> -{
> -       unsigned long flags;
> -       int i;
> -
> -       for (i = INT_PRI_BASE; i < INT_GPIO_BASE; i++) {
> -               struct irq_desc *desc = irq_to_desc(i);
> -               if (!desc)
> -                       continue;
> -               if (desc->status & IRQ_WAKEUP) {
> -                       pr_debug("irq %d is wakeup\n", i);
> -                       continue;
> -               }
> -               disable_irq(i);
> -       }
> -
> -       local_irq_save(flags);
> -       for (i = 0; i < PPI_NR; i++) {
> -               void __iomem *ictlr = ictlr_to_virt(i);
> -               cpu_ier[i] = readl(ictlr + ICTLR_CPU_IER);
> -               cpu_iep[i] = readl(ictlr + ICTLR_CPU_IEP_CLASS);
> -               cop_ier[i] = readl(ictlr + ICTLR_COP_IER);
> -               writel(~0, ictlr + ICTLR_COP_IER_CLR);
> -       }
> -       local_irq_restore(flags);
> -}
> -
> -void tegra_irq_resume(void)
> -{
> -       unsigned long flags;
> -       int i;
> -
> -       local_irq_save(flags);
> -       for (i = 0; i < PPI_NR; i++) {
> -               void __iomem *ictlr = ictlr_to_virt(i);
> -               writel(cpu_iep[i], ictlr + ICTLR_CPU_IEP_CLASS);
> -               writel(~0ul, ictlr + ICTLR_CPU_IER_CLR);
> -               writel(cpu_ier[i], ictlr + ICTLR_CPU_IER_SET);
> -               writel(0, ictlr + ICTLR_COP_IEP_CLASS);
> -               writel(~0ul, ictlr + ICTLR_COP_IER_CLR);
> -               writel(cop_ier[i], ictlr + ICTLR_COP_IER_SET);
> -       }
> -       local_irq_restore(flags);
> -
> -       for (i = INT_PRI_BASE; i < INT_GPIO_BASE; i++) {
> -               struct irq_desc *desc = irq_to_desc(i);
> -               if (!desc || (desc->status & IRQ_WAKEUP))
> -                       continue;
> -               enable_irq(i);
> -       }
> -}
> -#endif
>
>
>

Acked-by: Colin Cross <ccross@android.com>

These functions are clearly incorrectly accessing IRQ internals.  I
have replacements that have been posted for review that properly track
the wakeup state using set_wake, but they are held up on some
unrelated PM changes.
