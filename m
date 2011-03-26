Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1CZUMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 16:12:19 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10790 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1CZUMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 16:12:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 26 Mar 2011 13:12:11 -0700
Message-ID: <4D8E4897.5030705@nvidia.com>
Date: Sun, 27 Mar 2011 01:42:07 +0530
From: Varun Wadekar <vwadekar@nvidia.com>
Organization: NVIDIA Corporation
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [patch 02/23] arm: tegra: Remove unused function which fiddles
 with	irq_desc
References: <20110325131617.258789658@linutronix.de> <20110325132047.552074703@linutronix.de>
In-Reply-To: <20110325132047.552074703@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thomas, then how do you think we should handle restoring of gpio states
across suspend-resume cycles?

On Friday 25 March 2011 06:51 PM, Thomas Gleixner wrote:
> These functions are unused and in the way of cleanups in the core
> code. If you have special requirements vs. irqs and PM then please
> talk to me. Access to the generic core internals is going away.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Colin Cross <ccross@android.com>
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/mach-tegra/gpio.c                 |   63 -----------------------------
>  arch/arm/mach-tegra/include/mach/suspend.h |    2 
>  2 files changed, 65 deletions(-)
>
> Index: linux-2.6/arch/arm/mach-tegra/gpio.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-tegra/gpio.c
> +++ linux-2.6/arch/arm/mach-tegra/gpio.c
> @@ -254,69 +254,6 @@ static void tegra_gpio_irq_handler(unsig
>  }
>  
>  #ifdef CONFIG_PM
> -void tegra_gpio_resume(void)
> -{
> -	unsigned long flags;
> -	int b, p, i;
> -
> -	local_irq_save(flags);
> -
> -	for (b = 0; b < ARRAY_SIZE(tegra_gpio_banks); b++) {
> -		struct tegra_gpio_bank *bank = &tegra_gpio_banks[b];
> -
> -		for (p = 0; p < ARRAY_SIZE(bank->oe); p++) {
> -			unsigned int gpio = (b<<5) | (p<<3);
> -			__raw_writel(bank->cnf[p], GPIO_CNF(gpio));
> -			__raw_writel(bank->out[p], GPIO_OUT(gpio));
> -			__raw_writel(bank->oe[p], GPIO_OE(gpio));
> -			__raw_writel(bank->int_lvl[p], GPIO_INT_LVL(gpio));
> -			__raw_writel(bank->int_enb[p], GPIO_INT_ENB(gpio));
> -		}
> -	}
> -
> -	local_irq_restore(flags);
> -
> -	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
> -		struct irq_desc *desc = irq_to_desc(i);
> -		if (!desc || (desc->status & IRQ_WAKEUP))
> -			continue;
> -		enable_irq(i);
> -	}
> -}
> -
> -void tegra_gpio_suspend(void)
> -{
> -	unsigned long flags;
> -	int b, p, i;
> -
> -	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
> -		struct irq_desc *desc = irq_to_desc(i);
> -		if (!desc)
> -			continue;
> -		if (desc->status & IRQ_WAKEUP) {
> -			int gpio = i - INT_GPIO_BASE;
> -			pr_debug("gpio %d.%d is wakeup\n", gpio/8, gpio&7);
> -			continue;
> -		}
> -		disable_irq(i);
> -	}
> -
> -	local_irq_save(flags);
> -	for (b = 0; b < ARRAY_SIZE(tegra_gpio_banks); b++) {
> -		struct tegra_gpio_bank *bank = &tegra_gpio_banks[b];
> -
> -		for (p = 0; p < ARRAY_SIZE(bank->oe); p++) {
> -			unsigned int gpio = (b<<5) | (p<<3);
> -			bank->cnf[p] = __raw_readl(GPIO_CNF(gpio));
> -			bank->out[p] = __raw_readl(GPIO_OUT(gpio));
> -			bank->oe[p] = __raw_readl(GPIO_OE(gpio));
> -			bank->int_enb[p] = __raw_readl(GPIO_INT_ENB(gpio));
> -			bank->int_lvl[p] = __raw_readl(GPIO_INT_LVL(gpio));
> -		}
> -	}
> -	local_irq_restore(flags);
> -}
> -
>  static int tegra_gpio_wake_enable(struct irq_data *d, unsigned int enable)
>  {
>  	struct tegra_gpio_bank *bank = irq_data_get_irq_chip_data(d);
> Index: linux-2.6/arch/arm/mach-tegra/include/mach/suspend.h
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-tegra/include/mach/suspend.h
> +++ linux-2.6/arch/arm/mach-tegra/include/mach/suspend.h
> @@ -23,14 +23,12 @@
>  
>  void tegra_pinmux_suspend(void);
>  void tegra_irq_suspend(void);
> -void tegra_gpio_suspend(void);
>  void tegra_clk_suspend(void);
>  void tegra_dma_suspend(void);
>  void tegra_timer_suspend(void);
>  
>  void tegra_pinmux_resume(void);
>  void tegra_irq_resume(void);
> -void tegra_gpio_resume(void);
>  void tegra_clk_resume(void);
>  void tegra_dma_resume(void);
>  void tegra_timer_resume(void);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

