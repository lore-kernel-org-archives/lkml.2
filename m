Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1ICOkD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 10:40:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36660 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1ICOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 10:39:51 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <ccross@android.com>, <rjw@sisk.pl>, <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 3/5] ARM: gic: Use cpu pm notifiers to save gic state
Date: Sat, 3 Sep 2011 20:09:13 +0530
Message-ID: <1315060755-4613-4-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

When the cpu is powered down in a low power mode, the gic cpu
interface may be reset, and when the cpu cluster is powered
down, the gic distributor may also be reset.

This patch uses CPU_PM_ENTER and CPU_PM_EXIT notifiers to save
and restore the gic cpu interface registers, and the
CPU_CLUSTER_PM_ENTER and CPU_CLUSTER_PM_EXIT notifiers to save
and restore the gic distributor registers.

Original-author: Gary King <gking@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
[santosh.shilimkar@ti.com: Rebased against 3.1-rc4, removed gic dist. disable]
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/common/gic.c               |  187 +++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/hardware/gic.h |    8 ++
 2 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 3227ca9..66c7c48 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/smp.h>
+#include <linux/cpu_pm.h>
 #include <linux/cpumask.h>
 #include <linux/io.h>
 
@@ -276,6 +277,8 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	if (gic_irqs > 1020)
 		gic_irqs = 1020;
 
+	gic->gic_irqs = gic_irqs;
+
 	/*
 	 * Set all global interrupts to be level triggered, active low.
 	 */
@@ -343,6 +346,189 @@ static void __cpuinit gic_cpu_init(struct gic_chip_data *gic)
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
+		gic_data[gic_nr].saved_spi_target[i] =
+			readl_relaxed(dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 32); i++)
+		gic_data[gic_nr].saved_spi_enable[i] =
+			readl_relaxed(dist_base + GIC_DIST_ENABLE_SET + i * 4);
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
+		writel_relaxed(0xa0a0a0a0,
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
+	for (i = 0; i < DIV_ROUND_UP(32, 4); i++)
+		writel_relaxed(0xa0a0a0a0, dist_base + GIC_DIST_PRI + i * 4);
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
+		case CPU_CLUSTER_PM_ENTER:
+			gic_dist_save(i);
+			break;
+		case CPU_CLUSTER_PM_ENTER_FAILED:
+		case CPU_CLUSTER_PM_EXIT:
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
+static void __init gic_pm_init(struct gic_chip_data *gic)
+{
+	gic->saved_ppi_enable = __alloc_percpu(DIV_ROUND_UP(32, 32) * 4,
+		sizeof(u32));
+	BUG_ON(!gic->saved_ppi_enable);
+
+	gic->saved_ppi_conf = __alloc_percpu(DIV_ROUND_UP(32, 16) * 4,
+		sizeof(u32));
+	BUG_ON(!gic->saved_ppi_conf);
+
+	cpu_pm_register_notifier(&gic_notifier_block);
+}
+#else
+static void __init gic_pm_init(struct gic_chip_data *gic)
+{
+}
+#endif
+
 void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	void __iomem *dist_base, void __iomem *cpu_base)
 {
@@ -360,6 +546,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 
 	gic_dist_init(gic, irq_start);
 	gic_cpu_init(gic);
+	gic_pm_init(gic);
 }
 
 void __cpuinit gic_secondary_init(unsigned int gic_nr)
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 435d3f8..c562705 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -46,6 +46,14 @@ struct gic_chip_data {
 	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+#ifdef CONFIG_CPU_PM
+	u32 saved_spi_enable[DIV_ROUND_UP(1020, 32)];
+	u32 saved_spi_conf[DIV_ROUND_UP(1020, 16)];
+	u32 saved_spi_target[DIV_ROUND_UP(1020, 4)];
+	u32 __percpu *saved_ppi_enable;
+	u32 __percpu *saved_ppi_conf;
+#endif
+	unsigned int gic_irqs;
 };
 #endif
 
-- 
1.7.4.1

