Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1EAVLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 17:11:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1EAVKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 17:10:44 -0400
From: Colin Cross <ccross@android.com>
To: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] ARM: tegra: irq: Remove PM support
Date: Sun,  1 May 2011 14:10:11 -0700
Message-Id: <1304284213-11950-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304284213-11950-1-git-send-email-ccross@android.com>
References: <1304284213-11950-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra PM irq support is being improved, remove it for now
until the rest of the platform gets PM support.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/legacy_irq.h |    3 -
 arch/arm/mach-tegra/irq.c                     |   66 ---------------------
 arch/arm/mach-tegra/legacy_irq.c              |   77 -------------------------
 3 files changed, 0 insertions(+), 146 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/legacy_irq.h b/arch/arm/mach-tegra/include/mach/legacy_irq.h
index d898c0e..4c1f535 100644
--- a/arch/arm/mach-tegra/include/mach/legacy_irq.h
+++ b/arch/arm/mach-tegra/include/mach/legacy_irq.h
@@ -27,9 +27,6 @@ int tegra_legacy_force_irq_status(unsigned int irq);
 void tegra_legacy_select_fiq(unsigned int irq, bool fiq);
 unsigned long tegra_legacy_vfiq(int nr);
 unsigned long tegra_legacy_class(int nr);
-int tegra_legacy_irq_set_wake(int irq, int enable);
-void tegra_legacy_irq_set_lp1_wake_mask(void);
-void tegra_legacy_irq_restore_mask(void);
 void tegra_init_legacy_irq(void);
 
 #endif
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 567b75c..4fa7a37 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -28,75 +28,9 @@
 
 #include <mach/iomap.h>
 #include <mach/legacy_irq.h>
-#include <mach/suspend.h>
 
 #include "board.h"
 
-#define PMC_CTRL		0x0
-#define PMC_CTRL_LATCH_WAKEUPS	(1 << 5)
-#define PMC_WAKE_MASK		0xc
-#define PMC_WAKE_LEVEL		0x10
-#define PMC_WAKE_STATUS		0x14
-#define PMC_SW_WAKE_STATUS	0x18
-#define PMC_DPD_SAMPLE		0x20
-
-static void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
-
-static u32 tegra_lp0_wake_enb;
-static u32 tegra_lp0_wake_level;
-static u32 tegra_lp0_wake_level_any;
-
-/* ensures that sufficient time is passed for a register write to
- * serialize into the 32KHz domain */
-static void pmc_32kwritel(u32 val, unsigned long offs)
-{
-	writel(val, pmc + offs);
-	udelay(130);
-}
-
-int tegra_set_lp1_wake(int irq, int enable)
-{
-	return tegra_legacy_irq_set_wake(irq, enable);
-}
-
-void tegra_set_lp0_wake_pads(u32 wake_enb, u32 wake_level, u32 wake_any)
-{
-	u32 temp;
-	u32 status;
-	u32 lvl;
-
-	wake_level &= wake_enb;
-	wake_any &= wake_enb;
-
-	wake_level |= (tegra_lp0_wake_level & tegra_lp0_wake_enb);
-	wake_any |= (tegra_lp0_wake_level_any & tegra_lp0_wake_enb);
-
-	wake_enb |= tegra_lp0_wake_enb;
-
-	pmc_32kwritel(0, PMC_SW_WAKE_STATUS);
-	temp = readl(pmc + PMC_CTRL);
-	temp |= PMC_CTRL_LATCH_WAKEUPS;
-	pmc_32kwritel(temp, PMC_CTRL);
-	temp &= ~PMC_CTRL_LATCH_WAKEUPS;
-	pmc_32kwritel(temp, PMC_CTRL);
-	status = readl(pmc + PMC_SW_WAKE_STATUS);
-	lvl = readl(pmc + PMC_WAKE_LEVEL);
-
-	/* flip the wakeup trigger for any-edge triggered pads
-	 * which are currently asserting as wakeups */
-	lvl ^= status;
-	lvl &= wake_any;
-
-	wake_level |= lvl;
-
-	writel(wake_level, pmc + PMC_WAKE_LEVEL);
-	/* Enable DPD sample to trigger sampling pads data and direction
-	 * in which pad will be driven during lp0 mode*/
-	writel(0x1, pmc + PMC_DPD_SAMPLE);
-
-	writel(wake_enb, pmc + PMC_WAKE_MASK);
-}
-
 static void tegra_mask(struct irq_data *d)
 {
 	if (d->irq >= 32)
diff --git a/arch/arm/mach-tegra/legacy_irq.c b/arch/arm/mach-tegra/legacy_irq.c
index 38eb719..cb31669 100644
--- a/arch/arm/mach-tegra/legacy_irq.c
+++ b/arch/arm/mach-tegra/legacy_irq.c
@@ -49,9 +49,6 @@ static void __iomem *ictlr_reg_base[] = {
 	IO_ADDRESS(TEGRA_QUATERNARY_ICTLR_BASE),
 };
 
-static u32 tegra_legacy_wake_mask[4];
-static u32 tegra_legacy_saved_mask[4];
-
 /* When going into deep sleep, the CPU is powered down, taking the GIC with it
    In order to wake, the wake interrupts need to be enabled in the legacy
    interrupt controller. */
@@ -129,40 +126,6 @@ unsigned long tegra_legacy_class(int nr)
 	return readl(base + ICTLR_CPU_IEP_CLASS);
 }
 
-int tegra_legacy_irq_set_wake(int irq, int enable)
-{
-	irq -= 32;
-	if (enable)
-		tegra_legacy_wake_mask[irq >> 5] |= 1 << (irq & 31);
-	else
-		tegra_legacy_wake_mask[irq >> 5] &= ~(1 << (irq & 31));
-
-	return 0;
-}
-
-void tegra_legacy_irq_set_lp1_wake_mask(void)
-{
-	void __iomem *base;
-	int i;
-
-	for (i = 0; i < NUM_ICTLRS; i++) {
-		base = ictlr_reg_base[i];
-		tegra_legacy_saved_mask[i] = readl(base + ICTLR_CPU_IER);
-		writel(tegra_legacy_wake_mask[i], base + ICTLR_CPU_IER);
-	}
-}
-
-void tegra_legacy_irq_restore_mask(void)
-{
-	void __iomem *base;
-	int i;
-
-	for (i = 0; i < NUM_ICTLRS; i++) {
-		base = ictlr_reg_base[i];
-		writel(tegra_legacy_saved_mask[i], base + ICTLR_CPU_IER);
-	}
-}
-
 void tegra_init_legacy_irq(void)
 {
 	int i;
@@ -173,43 +136,3 @@ void tegra_init_legacy_irq(void)
 		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
 	}
 }
-
-#ifdef CONFIG_PM
-static u32 cop_ier[NUM_ICTLRS];
-static u32 cpu_ier[NUM_ICTLRS];
-static u32 cpu_iep[NUM_ICTLRS];
-
-void tegra_irq_suspend(void)
-{
-	unsigned long flags;
-	int i;
-
-	local_irq_save(flags);
-	for (i = 0; i < NUM_ICTLRS; i++) {
-		void __iomem *ictlr = ictlr_reg_base[i];
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
-	for (i = 0; i < NUM_ICTLRS; i++) {
-		void __iomem *ictlr = ictlr_reg_base[i];
-		writel(cpu_iep[i], ictlr + ICTLR_CPU_IEP_CLASS);
-		writel(~0ul, ictlr + ICTLR_CPU_IER_CLR);
-		writel(cpu_ier[i], ictlr + ICTLR_CPU_IER_SET);
-		writel(0, ictlr + ICTLR_COP_IEP_CLASS);
-		writel(~0ul, ictlr + ICTLR_COP_IER_CLR);
-		writel(cop_ier[i], ictlr + ICTLR_COP_IER_SET);
-	}
-	local_irq_restore(flags);
-}
-#endif
-- 
1.7.4.1

