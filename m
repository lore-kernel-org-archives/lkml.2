Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab1BJXpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:45:44 -0500
Received: from www.tglx.de ([62.245.132.106]:44327 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234Ab1BJXht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:37:49 -0500
Message-Id: <20110210223258.848294582@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 10 Feb 2011 23:37:40 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Colin Cross <ccross@android.com>, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [patch 47/75] arm: tegra: Remove unused function which fiddles with
	irq_desc
References: <20110210222908.661199947@linutronix.de>
Content-Disposition: inline; filename=arm-tegra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These functions are unused and in the way of cleanups in the core
code. If you have special requirements vs. irqs and PM then please
talk to me. Access to the generic core internals is going away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/mach-tegra/gpio.c |   63 ---------------------------------------------
 arch/arm/mach-tegra/irq.c  |   58 -----------------------------------------
 2 files changed, 121 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-tegra/gpio.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/gpio.c
+++ linux-2.6-tip/arch/arm/mach-tegra/gpio.c
@@ -253,69 +253,6 @@ static void tegra_gpio_irq_handler(unsig
 }
 
 #ifdef CONFIG_PM
-void tegra_gpio_resume(void)
-{
-	unsigned long flags;
-	int b, p, i;
-
-	local_irq_save(flags);
-
-	for (b = 0; b < ARRAY_SIZE(tegra_gpio_banks); b++) {
-		struct tegra_gpio_bank *bank = &tegra_gpio_banks[b];
-
-		for (p = 0; p < ARRAY_SIZE(bank->oe); p++) {
-			unsigned int gpio = (b<<5) | (p<<3);
-			__raw_writel(bank->cnf[p], GPIO_CNF(gpio));
-			__raw_writel(bank->out[p], GPIO_OUT(gpio));
-			__raw_writel(bank->oe[p], GPIO_OE(gpio));
-			__raw_writel(bank->int_lvl[p], GPIO_INT_LVL(gpio));
-			__raw_writel(bank->int_enb[p], GPIO_INT_ENB(gpio));
-		}
-	}
-
-	local_irq_restore(flags);
-
-	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-		if (!desc || (desc->status & IRQ_WAKEUP))
-			continue;
-		enable_irq(i);
-	}
-}
-
-void tegra_gpio_suspend(void)
-{
-	unsigned long flags;
-	int b, p, i;
-
-	for (i = INT_GPIO_BASE; i < (INT_GPIO_BASE + TEGRA_NR_GPIOS); i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-		if (!desc)
-			continue;
-		if (desc->status & IRQ_WAKEUP) {
-			int gpio = i - INT_GPIO_BASE;
-			pr_debug("gpio %d.%d is wakeup\n", gpio/8, gpio&7);
-			continue;
-		}
-		disable_irq(i);
-	}
-
-	local_irq_save(flags);
-	for (b = 0; b < ARRAY_SIZE(tegra_gpio_banks); b++) {
-		struct tegra_gpio_bank *bank = &tegra_gpio_banks[b];
-
-		for (p = 0; p < ARRAY_SIZE(bank->oe); p++) {
-			unsigned int gpio = (b<<5) | (p<<3);
-			bank->cnf[p] = __raw_readl(GPIO_CNF(gpio));
-			bank->out[p] = __raw_readl(GPIO_OUT(gpio));
-			bank->oe[p] = __raw_readl(GPIO_OE(gpio));
-			bank->int_enb[p] = __raw_readl(GPIO_INT_ENB(gpio));
-			bank->int_lvl[p] = __raw_readl(GPIO_INT_LVL(gpio));
-		}
-	}
-	local_irq_restore(flags);
-}
-
 static int tegra_gpio_wake_enable(struct irq_data *d, unsigned int enable)
 {
 	struct tegra_gpio_bank *bank = irq_data_get_irq_chip_data(d);
Index: linux-2.6-tip/arch/arm/mach-tegra/irq.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-tegra/irq.c
+++ linux-2.6-tip/arch/arm/mach-tegra/irq.c
@@ -111,61 +111,3 @@ void __init tegra_init_irq(void)
 		set_irq_flags(i, IRQF_VALID);
 	}
 }
-
-#ifdef CONFIG_PM
-static u32 cop_ier[PPI_NR];
-static u32 cpu_ier[PPI_NR];
-static u32 cpu_iep[PPI_NR];
-
-void tegra_irq_suspend(void)
-{
-	unsigned long flags;
-	int i;
-
-	for (i = INT_PRI_BASE; i < INT_GPIO_BASE; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-		if (!desc)
-			continue;
-		if (desc->status & IRQ_WAKEUP) {
-			pr_debug("irq %d is wakeup\n", i);
-			continue;
-		}
-		disable_irq(i);
-	}
-
-	local_irq_save(flags);
-	for (i = 0; i < PPI_NR; i++) {
-		void __iomem *ictlr = ictlr_to_virt(i);
-		cpu_ier[i] = readl(ictlr + ICTLR_CPU_IER);
-		cpu_iep[i] = readl(ictlr + ICTLR_CPU_IEP_CLASS);
-		cop_ier[i] = readl(ictlr + ICTLR_COP_IER);
-		writel(~0, ictlr + ICTLR_COP_IER_CLR);
-	}
-	local_irq_restore(flags);
-}
-
-void tegra_irq_resume(void)
-{
-	unsigned long flags;
-	int i;
-
-	local_irq_save(flags);
-	for (i = 0; i < PPI_NR; i++) {
-		void __iomem *ictlr = ictlr_to_virt(i);
-		writel(cpu_iep[i], ictlr + ICTLR_CPU_IEP_CLASS);
-		writel(~0ul, ictlr + ICTLR_CPU_IER_CLR);
-		writel(cpu_ier[i], ictlr + ICTLR_CPU_IER_SET);
-		writel(0, ictlr + ICTLR_COP_IEP_CLASS);
-		writel(~0ul, ictlr + ICTLR_COP_IER_CLR);
-		writel(cop_ier[i], ictlr + ICTLR_COP_IER_SET);
-	}
-	local_irq_restore(flags);
-
-	for (i = INT_PRI_BASE; i < INT_GPIO_BASE; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
-		if (!desc || (desc->status & IRQ_WAKEUP))
-			continue;
-		enable_irq(i);
-	}
-}
-#endif


