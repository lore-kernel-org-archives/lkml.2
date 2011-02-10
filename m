Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab1BJGoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 01:44:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17383 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1BJGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 01:44:11 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/15] ARM: tegra: irq: Add support for suspend wake sources
Date: Wed,  9 Feb 2011 22:43:17 -0800
Message-Id: <1297320204-31882-9-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297320204-31882-1-git-send-email-ccross@android.com>
References: <1297320204-31882-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/include/mach/legacy_irq.h |    4 +
 arch/arm/mach-tegra/irq.c                     |  176 +++++++++++--------------
 arch/arm/mach-tegra/legacy_irq.c              |  109 +++++++++++++++-
 3 files changed, 184 insertions(+), 105 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/legacy_irq.h b/arch/arm/mach-tegra/include/mach/legacy_irq.h
index db1eb3d..d898c0e 100644
--- a/arch/arm/mach-tegra/include/mach/legacy_irq.h
+++ b/arch/arm/mach-tegra/include/mach/legacy_irq.h
@@ -27,5 +27,9 @@ int tegra_legacy_force_irq_status(unsigned int irq);
 void tegra_legacy_select_fiq(unsigned int irq, bool fiq);
 unsigned long tegra_legacy_vfiq(int nr);
 unsigned long tegra_legacy_class(int nr);
+int tegra_legacy_irq_set_wake(int irq, int enable);
+void tegra_legacy_irq_set_lp1_wake_mask(void);
+void tegra_legacy_irq_restore_mask(void);
+void tegra_init_legacy_irq(void);
 
 #endif
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 5f065f9..7fb7349 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
@@ -26,74 +27,104 @@
 #include <asm/hardware/gic.h>
 
 #include <mach/iomap.h>
+#include <mach/legacy_irq.h>
 #include <mach/suspend.h>
 
 #include "board.h"
 
-#define INT_SYS_NR	(INT_GPIO_BASE - INT_PRI_BASE)
-#define INT_SYS_SZ	(INT_SEC_BASE - INT_PRI_BASE)
-#define PPI_NR		((INT_SYS_NR+INT_SYS_SZ-1)/INT_SYS_SZ)
+#define PMC_CTRL		0x0
+#define PMC_CTRL_LATCH_WAKEUPS	(1 << 5)
+#define PMC_WAKE_MASK		0xc
+#define PMC_WAKE_LEVEL		0x10
+#define PMC_WAKE_STATUS		0x14
+#define PMC_SW_WAKE_STATUS	0x18
+#define PMC_DPD_SAMPLE		0x20
 
-#define APBDMA_IRQ_STA_CPU  0x14
-#define APBDMA_IRQ_MASK_SET 0x20
-#define APBDMA_IRQ_MASK_CLR 0x24
+static void __iomem *pmc = IO_ADDRESS(TEGRA_PMC_BASE);
 
-#define ICTLR_CPU_IER		0x20
-#define ICTLR_CPU_IER_SET	0x24
-#define ICTLR_CPU_IER_CLR	0x28
-#define ICTLR_CPU_IEP_CLASS	0x2c
-#define ICTLR_COP_IER		0x30
-#define ICTLR_COP_IER_SET	0x34
-#define ICTLR_COP_IER_CLR	0x38
-#define ICTLR_COP_IEP_CLASS	0x3c
+static u32 tegra_lp0_wake_enb;
+static u32 tegra_lp0_wake_level;
+static u32 tegra_lp0_wake_level_any;
 
 static void (*tegra_gic_mask_irq)(struct irq_data *d);
 static void (*tegra_gic_unmask_irq)(struct irq_data *d);
 
-#define irq_to_ictlr(irq) (((irq) - 32) >> 5)
-static void __iomem *tegra_ictlr_base = IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE);
-#define ictlr_to_virt(ictlr) (tegra_ictlr_base + (ictlr) * 0x100)
+/* ensures that sufficient time is passed for a register write to
+ * serialize into the 32KHz domain */
+static void pmc_32kwritel(u32 val, unsigned long offs)
+{
+	writel(val, pmc + offs);
+	udelay(130);
+}
 
-static void tegra_mask(struct irq_data *d)
+int tegra_set_lp1_wake(int irq, int enable)
 {
-	void __iomem *addr = ictlr_to_virt(irq_to_ictlr(d->irq));
-	tegra_gic_mask_irq(d);
-	writel(1 << (d->irq & 31), addr+ICTLR_CPU_IER_CLR);
+	return tegra_legacy_irq_set_wake(irq, enable);
 }
 
-static void tegra_unmask(struct irq_data *d)
+void tegra_set_lp0_wake_pads(u32 wake_enb, u32 wake_level, u32 wake_any)
 {
-	void __iomem *addr = ictlr_to_virt(irq_to_ictlr(d->irq));
-	tegra_gic_unmask_irq(d);
-	writel(1<<(d->irq&31), addr+ICTLR_CPU_IER_SET);
+	u32 temp;
+	u32 status;
+	u32 lvl;
+
+	wake_level &= wake_enb;
+	wake_any &= wake_enb;
+
+	wake_level |= (tegra_lp0_wake_level & tegra_lp0_wake_enb);
+	wake_any |= (tegra_lp0_wake_level_any & tegra_lp0_wake_enb);
+
+	wake_enb |= tegra_lp0_wake_enb;
+
+	pmc_32kwritel(0, PMC_SW_WAKE_STATUS);
+	temp = readl(pmc + PMC_CTRL);
+	temp |= PMC_CTRL_LATCH_WAKEUPS;
+	pmc_32kwritel(temp, PMC_CTRL);
+	temp &= ~PMC_CTRL_LATCH_WAKEUPS;
+	pmc_32kwritel(temp, PMC_CTRL);
+	status = readl(pmc + PMC_SW_WAKE_STATUS);
+	lvl = readl(pmc + PMC_WAKE_LEVEL);
+
+	/* flip the wakeup trigger for any-edge triggered pads
+	 * which are currently asserting as wakeups */
+	lvl ^= status;
+	lvl &= wake_any;
+
+	wake_level |= lvl;
+
+	writel(wake_level, pmc + PMC_WAKE_LEVEL);
+	/* Enable DPD sample to trigger sampling pads data and direction
+	 * in which pad will be driven during lp0 mode*/
+	writel(0x1, pmc + PMC_DPD_SAMPLE);
+
+	writel(wake_enb, pmc + PMC_WAKE_MASK);
 }
 
-#ifdef CONFIG_PM
+static void tegra_mask(struct irq_data *d)
+{
+	tegra_gic_mask_irq(d);
+	tegra_legacy_mask_irq(d->irq);
+}
 
-static int tegra_set_wake(struct irq_data *d, unsigned int on)
+static void tegra_unmask(struct irq_data *d)
 {
-	return 0;
+	tegra_gic_unmask_irq(d);
+	tegra_legacy_unmask_irq(d->irq);
 }
-#endif
 
 static struct irq_chip tegra_irq = {
-	.name		= "PPI",
-	.irq_mask	= tegra_mask,
-	.irq_unmask	= tegra_unmask,
-#ifdef CONFIG_PM
-	.irq_set_wake	= tegra_set_wake,
-#endif
+	.name			= "PPI",
+	.irq_mask		= tegra_mask,
+	.irq_unmask		= tegra_unmask,
 };
 
 void __init tegra_init_irq(void)
 {
 	struct irq_chip *gic;
 	unsigned int i;
+	int irq;
 
-	for (i = 0; i < PPI_NR; i++) {
-		writel(~0, ictlr_to_virt(i) + ICTLR_CPU_IER_CLR);
-		writel(0, ictlr_to_virt(i) + ICTLR_CPU_IEP_CLASS);
-	}
+	tegra_init_legacy_irq();
 
 	gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
 		 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
@@ -106,67 +137,10 @@ void __init tegra_init_irq(void)
 	tegra_irq.irq_set_affinity = gic->irq_set_affinity;
 #endif
 
-	for (i = INT_PRI_BASE; i < INT_GPIO_BASE; i++) {
-		set_irq_chip(i, &tegra_irq);
-		set_irq_handler(i, handle_level_irq);
-		set_irq_flags(i, IRQF_VALID);
-	}
-}
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
+	for (i = 0; i < INT_MAIN_NR; i++) {
+		irq = INT_PRI_BASE + i;
+		set_irq_chip(irq, &tegra_irq);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID);
 	}
-	local_irq_restore(flags);
 }
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
diff --git a/arch/arm/mach-tegra/legacy_irq.c b/arch/arm/mach-tegra/legacy_irq.c
index 7cc8601..38eb719 100644
--- a/arch/arm/mach-tegra/legacy_irq.c
+++ b/arch/arm/mach-tegra/legacy_irq.c
@@ -18,17 +18,30 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <mach/iomap.h>
+#include <mach/irqs.h>
 #include <mach/legacy_irq.h>
 
-#define ICTLR_CPU_IER		0x20
-#define ICTLR_CPU_IER_SET	0x24
-#define ICTLR_CPU_IER_CLR	0x28
-#define ICTLR_CPU_IEP_CLASS	0x2C
+#define INT_SYS_NR	(INT_GPIO_BASE - INT_PRI_BASE)
+#define INT_SYS_SZ	(INT_SEC_BASE - INT_PRI_BASE)
+#define PPI_NR		((INT_SYS_NR+INT_SYS_SZ-1)/INT_SYS_SZ)
+
 #define ICTLR_CPU_IEP_VFIQ	0x08
 #define ICTLR_CPU_IEP_FIR	0x14
 #define ICTLR_CPU_IEP_FIR_SET	0x18
 #define ICTLR_CPU_IEP_FIR_CLR	0x1c
 
+#define ICTLR_CPU_IER		0x20
+#define ICTLR_CPU_IER_SET	0x24
+#define ICTLR_CPU_IER_CLR	0x28
+#define ICTLR_CPU_IEP_CLASS	0x2C
+
+#define ICTLR_COP_IER		0x30
+#define ICTLR_COP_IER_SET	0x34
+#define ICTLR_COP_IER_CLR	0x38
+#define ICTLR_COP_IEP_CLASS	0x3c
+
+#define NUM_ICTLRS 4
+
 static void __iomem *ictlr_reg_base[] = {
 	IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE),
 	IO_ADDRESS(TEGRA_SECONDARY_ICTLR_BASE),
@@ -36,6 +49,9 @@ static void __iomem *ictlr_reg_base[] = {
 	IO_ADDRESS(TEGRA_QUATERNARY_ICTLR_BASE),
 };
 
+static u32 tegra_legacy_wake_mask[4];
+static u32 tegra_legacy_saved_mask[4];
+
 /* When going into deep sleep, the CPU is powered down, taking the GIC with it
    In order to wake, the wake interrupts need to be enabled in the legacy
    interrupt controller. */
@@ -112,3 +128,88 @@ unsigned long tegra_legacy_class(int nr)
 	base = ictlr_reg_base[nr];
 	return readl(base + ICTLR_CPU_IEP_CLASS);
 }
+
+int tegra_legacy_irq_set_wake(int irq, int enable)
+{
+	irq -= 32;
+	if (enable)
+		tegra_legacy_wake_mask[irq >> 5] |= 1 << (irq & 31);
+	else
+		tegra_legacy_wake_mask[irq >> 5] &= ~(1 << (irq & 31));
+
+	return 0;
+}
+
+void tegra_legacy_irq_set_lp1_wake_mask(void)
+{
+	void __iomem *base;
+	int i;
+
+	for (i = 0; i < NUM_ICTLRS; i++) {
+		base = ictlr_reg_base[i];
+		tegra_legacy_saved_mask[i] = readl(base + ICTLR_CPU_IER);
+		writel(tegra_legacy_wake_mask[i], base + ICTLR_CPU_IER);
+	}
+}
+
+void tegra_legacy_irq_restore_mask(void)
+{
+	void __iomem *base;
+	int i;
+
+	for (i = 0; i < NUM_ICTLRS; i++) {
+		base = ictlr_reg_base[i];
+		writel(tegra_legacy_saved_mask[i], base + ICTLR_CPU_IER);
+	}
+}
+
+void tegra_init_legacy_irq(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_ICTLRS; i++) {
+		void __iomem *ictlr = ictlr_reg_base[i];
+		writel(~0, ictlr + ICTLR_CPU_IER_CLR);
+		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
+	}
+}
+
+#ifdef CONFIG_PM
+static u32 cop_ier[NUM_ICTLRS];
+static u32 cpu_ier[NUM_ICTLRS];
+static u32 cpu_iep[NUM_ICTLRS];
+
+void tegra_irq_suspend(void)
+{
+	unsigned long flags;
+	int i;
+
+	local_irq_save(flags);
+	for (i = 0; i < NUM_ICTLRS; i++) {
+		void __iomem *ictlr = ictlr_reg_base[i];
+		cpu_ier[i] = readl(ictlr + ICTLR_CPU_IER);
+		cpu_iep[i] = readl(ictlr + ICTLR_CPU_IEP_CLASS);
+		cop_ier[i] = readl(ictlr + ICTLR_COP_IER);
+		writel(~0, ictlr + ICTLR_COP_IER_CLR);
+	}
+	local_irq_restore(flags);
+}
+
+void tegra_irq_resume(void)
+{
+	unsigned long flags;
+	int i;
+
+	local_irq_save(flags);
+	for (i = 0; i < NUM_ICTLRS; i++) {
+		void __iomem *ictlr = ictlr_reg_base[i];
+		writel(cpu_iep[i], ictlr + ICTLR_CPU_IEP_CLASS);
+		writel(~0ul, ictlr + ICTLR_CPU_IER_CLR);
+		writel(cpu_ier[i], ictlr + ICTLR_CPU_IER_SET);
+		writel(0, ictlr + ICTLR_COP_IEP_CLASS);
+		writel(~0ul, ictlr + ICTLR_COP_IER_CLR);
+		writel(cop_ier[i], ictlr + ICTLR_COP_IER_SET);
+	}
+	local_irq_restore(flags);
+}
+#endif
-- 
1.7.3.1

