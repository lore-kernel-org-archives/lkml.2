Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1FMAo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:44:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26268 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1FMAoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:44:22 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: [PATCH 2/3] ARM: gic: Use cpu pm notifiers to save gic state
Date: Sun, 12 Jun 2011 17:43:44 -0700
Message-Id: <1307925825-28566-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307925825-28566-1-git-send-email-ccross@android.com>
References: <1307925825-28566-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the cpu is powered down in a low power mode, the gic cpu
interface may be reset, and when the cpu complex is powered
down, the gic distributor may also be reset.

This patch uses CPU_PM_ENTER and CPU_PM_EXIT notifiers to save
and restore the gic cpu interface registers, and the
CPU_COMPLEX_PM_ENTER and CPU_COMPLEX_PM_EXIT notifiers to save
and restore the gic distributor registers.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/common/gic.c |  212 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 212 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 4ddd0a6..8d62e07 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -29,6 +29,7 @@
 #include <linux/cpumask.h>
 #include <linux/io.h>
 
+#include <asm/cpu_pm.h>
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
 #include <asm/hardware/gic.h>
@@ -42,6 +43,17 @@ struct gic_chip_data {
 	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+#ifdef CONFIG_CPU_PM
+	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
+	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
+	u32 saved_spi_pri[DIV_ROUND_UP(1020, 4)];
+	u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
+	u32 __percpu *saved_ppi_enable;
+	u32 __percpu *saved_ppi_conf;
+	u32 __percpu *saved_ppi_pri;
+#endif
+
+	unsigned int gic_irqs;
 };
 
 /*
@@ -283,6 +295,8 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	if (gic_irqs > 1020)
 		gic_irqs = 1020;
 
+	gic->gic_irqs = gic_irqs;
+
 	/*
 	 * Set all global interrupts to be level triggered, active low.
 	 */
@@ -350,6 +364,203 @@ static void __cpuinit gic_cpu_init(struct gic_chip_data *gic)
 	writel_relaxed(1, base + GIC_CPU_CTRL);
 }
 
+#ifdef CONFIG_CPU_PM
+/*
+ * Saves the GIC distributor registers during suspend or idle.  Must be called
+ * with interrupts disabled but before powering down the GIC.  After calling
+ * this function, no interrupts will be delivered by the GIC, and another
+ * platform-specific wakeup source must be enabled.
+ */
+static void gic_dist_save(unsigned int gic_nr)
+{
+	unsigned int gic_irqs;
+	void __iomem *dist_base;
+	int i;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	gic_irqs = gic_data[gic_nr].gic_irqs;
+	dist_base = gic_data[gic_nr].dist_base;
+
+	if (!dist_base)
+		return;
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
+		gic_data[gic_nr].saved_spi_conf[i] =
+			readl_relaxed(dist_base + GIC_DIST_CONFIG + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		gic_data[gic_nr].saved_spi_pri[i] =
+			readl_relaxed(dist_base + GIC_DIST_PRI + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		gic_data[gic_nr].saved_spi_target[i] =
+			readl_relaxed(dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 32); i++)
+		gic_data[gic_nr].saved_spi_enable[i] =
+			readl_relaxed(dist_base + GIC_DIST_ENABLE_SET + i * 4);
+
+	writel_relaxed(0, dist_base + GIC_DIST_CTRL);
+}
+
+/*
+ * Restores the GIC distributor registers during resume or when coming out of
+ * idle.  Must be called before enabling interrupts.  If a level interrupt
+ * that occured while the GIC was suspended is still present, it will be
+ * handled normally, but any edge interrupts that occured will not be seen by
+ * the GIC and need to be handled by the platform-specific wakeup source.
+ */
+static void gic_dist_restore(unsigned int gic_nr)
+{
+	unsigned int gic_irqs;
+	unsigned int i;
+	void __iomem *dist_base;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	gic_irqs = gic_data[gic_nr].gic_irqs;
+	dist_base = gic_data[gic_nr].dist_base;
+
+	if (!dist_base)
+		return;
+
+	writel_relaxed(0, dist_base + GIC_DIST_CTRL);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
+		writel_relaxed(gic_data[gic_nr].saved_spi_conf[i],
+			dist_base + GIC_DIST_CONFIG + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		writel_relaxed(gic_data[gic_nr].saved_spi_pri[i],
+			dist_base + GIC_DIST_PRI + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		writel_relaxed(gic_data[gic_nr].saved_spi_target[i],
+			dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 32); i++)
+		writel_relaxed(gic_data[gic_nr].saved_spi_enable[i],
+			dist_base + GIC_DIST_ENABLE_SET + i * 4);
+
+	writel_relaxed(1, dist_base + GIC_DIST_CTRL);
+}
+
+static void gic_cpu_save(unsigned int gic_nr)
+{
+	int i;
+	u32 *ptr;
+	void __iomem *dist_base;
+	void __iomem *cpu_base;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	dist_base = gic_data[gic_nr].dist_base;
+	cpu_base = gic_data[gic_nr].cpu_base;
+
+	if (!dist_base || !cpu_base)
+		return;
+
+	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
+	for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
+		ptr[i] = readl_relaxed(dist_base + GIC_DIST_ENABLE_SET + i * 4);
+
+	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
+	for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
+		ptr[i] = readl_relaxed(dist_base + GIC_DIST_CONFIG + i * 4);
+
+	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_pri);
+	for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
+		ptr[i] = readl_relaxed(dist_base + GIC_DIST_PRI + i * 4);
+}
+
+static void gic_cpu_restore(unsigned int gic_nr)
+{
+	int i;
+	u32 *ptr;
+	void __iomem *dist_base;
+	void __iomem *cpu_base;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	dist_base = gic_data[gic_nr].dist_base;
+	cpu_base = gic_data[gic_nr].cpu_base;
+
+	if (!dist_base || !cpu_base)
+		return;
+
+	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_enable);
+	for (i = 0; i < DIV_ROUND_UP(32, 32); i++)
+		writel_relaxed(ptr[i], dist_base + GIC_DIST_ENABLE_SET + i * 4);
+
+	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_conf);
+	for (i = 0; i < DIV_ROUND_UP(32, 16); i++)
+		writel_relaxed(ptr[i], dist_base + GIC_DIST_CONFIG + i * 4);
+
+	ptr = __this_cpu_ptr(gic_data[gic_nr].saved_ppi_pri);
+	for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
+		writel_relaxed(ptr[i], dist_base + GIC_DIST_PRI + i * 4);
+
+	writel_relaxed(0xf0, cpu_base + GIC_CPU_PRIMASK);
+	writel_relaxed(1, cpu_base + GIC_CPU_CTRL);
+}
+
+static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)
+{
+	int i;
+
+	for (i = 0; i < MAX_GIC_NR; i++) {
+		switch (cmd) {
+		case CPU_PM_ENTER:
+			gic_cpu_save(i);
+			break;
+		case CPU_PM_ENTER_FAILED:
+		case CPU_PM_EXIT:
+			gic_cpu_restore(i);
+			break;
+		case CPU_COMPLEX_PM_ENTER:
+			gic_dist_save(i);
+			break;
+		case CPU_COMPLEX_PM_ENTER_FAILED:
+		case CPU_COMPLEX_PM_EXIT:
+			gic_dist_restore(i);
+			break;
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block gic_notifier_block = {
+	.notifier_call = gic_notifier,
+};
+
+static void __init gic_cpu_pm_init(struct gic_chip_data *gic)
+{
+	gic->saved_ppi_enable = __alloc_percpu(DIV_ROUND_UP(32, 32) * 4,
+		sizeof(u32));
+	BUG_ON(!gic->saved_ppi_enable);
+
+	gic->saved_ppi_conf = __alloc_percpu(DIV_ROUND_UP(32, 16) * 4,
+		sizeof(u32));
+	BUG_ON(!gic->saved_ppi_conf);
+
+	gic->saved_ppi_pri = __alloc_percpu(DIV_ROUND_UP(32, 4) * 4,
+		sizeof(u32));
+	BUG_ON(!gic->saved_ppi_pri);
+
+	cpu_pm_register_notifier(&gic_notifier_block);
+}
+#else
+static void __init gic_cpu_pm_init(struct gic_chip_data *gic)
+{
+}
+#endif
+
 void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	void __iomem *dist_base, void __iomem *cpu_base)
 {
@@ -367,6 +578,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 
 	gic_dist_init(gic, irq_start);
 	gic_cpu_init(gic);
+	gic_cpu_pm_init(gic);
 }
 
 void __cpuinit gic_secondary_init(unsigned int gic_nr)
-- 
1.7.4.1

