Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1AXCGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 21:06:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43108 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1AXCCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 21:02:17 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, olof@lixom.net, konkers@android.com,
        Colin Cross <ccross@android.com>, Gary King <gking@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/28] ARM: gic: Add functions to save and restore gic state
Date: Sun, 23 Jan 2011 18:01:07 -0800
Message-Id: <1295834493-5019-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1295834493-5019-1-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on systems with idle states which power-gate the logic including
the gic, such as tegra, the gic distributor needs to be shut down
and restored on entry and exit from the architecture idle code

Original-author: Gary King <gking@nvidia.com>
Signed-off-by: Gary King <gking@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
v2: Updated on top of changes to gic initialization

This patch depends on patch 1: 
ARM: tegra: irq: Rename gic pointers to avoid conflicts

 arch/arm/common/gic.c               |  127 +++++++++++++++++++++++++++++++++--
 arch/arm/include/asm/hardware/gic.h |    3 +
 2 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 2243772..a6f8c58 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -42,6 +42,13 @@ struct gic_chip_data {
 	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+#ifdef CONFIG_PM
+	u32 saved_enable[DIV_ROUND_UP(1020, 32)];
+	u32 saved_conf[DIV_ROUND_UP(1020, 16)];
+	u32 saved_pri[DIV_ROUND_UP(1020, 4)];
+	u32 saved_target[DIV_ROUND_UP(1020, 4)];
+#endif
+	unsigned int gic_irqs;
 };
 
 #ifndef MAX_GIC_NR
@@ -216,10 +223,9 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	set_irq_chained_handler(irq, gic_handle_cascade_irq);
 }
 
-static void __init gic_dist_init(struct gic_chip_data *gic,
-	unsigned int irq_start)
+static unsigned int _gic_dist_init(struct gic_chip_data *gic)
 {
-	unsigned int gic_irqs, irq_limit, i;
+	unsigned int gic_irqs, i;
 	void __iomem *base = gic->dist_base;
 	u32 cpumask = 1 << smp_processor_id();
 
@@ -262,10 +268,25 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	for (i = 32; i < gic_irqs; i += 32)
 		writel(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 
+	return gic_irqs;
+}
+
+static void _gic_dist_exit(unsigned int gic_nr)
+{
+	writel(0, gic_data[gic_nr].dist_base + GIC_DIST_CTRL);
+}
+
+void __init gic_dist_init(struct gic_chip_data *gic, unsigned int irq_start)
+{
+	unsigned int irq_limit;
+	unsigned int i;
+
+	gic->gic_irqs = _gic_dist_init(gic);
+
 	/*
 	 * Limit number of interrupts registered to the platform maximum
 	 */
-	irq_limit = gic->irq_offset + gic_irqs;
+	irq_limit = gic->irq_offset + gic->gic_irqs;
 	if (WARN_ON(irq_limit > NR_IRQS))
 		irq_limit = NR_IRQS;
 
@@ -279,7 +300,15 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
 	}
 
-	writel(1, base + GIC_DIST_CTRL);
+	writel(1, gic->dist_base + GIC_DIST_CTRL);
+}
+
+void gic_dist_exit(unsigned int gic_nr)
+{
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	_gic_dist_exit(gic_nr);
 }
 
 static void __cpuinit gic_cpu_init(struct gic_chip_data *gic)
@@ -305,6 +334,14 @@ static void __cpuinit gic_cpu_init(struct gic_chip_data *gic)
 	writel(1, base + GIC_CPU_CTRL);
 }
 
+void gic_cpu_exit(unsigned int gic_nr)
+{
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	writel(0, gic_data[gic_nr].cpu_base + GIC_CPU_CTRL);
+}
+
 void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	void __iomem *dist_base, void __iomem *cpu_base)
 {
@@ -350,3 +387,83 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	writel(map << 16 | irq, gic_data[0].dist_base + GIC_DIST_SOFTINT);
 }
 #endif
+
+#ifdef CONFIG_PM
+/*
+ * Saves the GIC distributor registers during suspend or idle.  Must be called
+ * with interrupts disabled but before powering down the GIC.  After calling
+ * this function, no interrupts will be delivered by the GIC, and another
+ * platform-specific wakeup source must be enabled.
+ */
+void gic_dist_save(unsigned int gic_nr)
+{
+	unsigned int gic_irqs = gic_data[gic_nr].gic_irqs;
+	void __iomem *dist_base = gic_data[gic_nr].dist_base;
+	int i;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	_gic_dist_exit(gic_nr);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
+		gic_data[gic_nr].saved_conf[i] =
+			readl(dist_base + GIC_DIST_CONFIG + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		gic_data[gic_nr].saved_pri[i] =
+			readl(dist_base + GIC_DIST_PRI + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		gic_data[gic_nr].saved_target[i] =
+			readl(dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 32); i++)
+		gic_data[gic_nr].saved_enable[i] =
+			readl(dist_base + GIC_DIST_ENABLE_SET + i * 4);
+}
+
+/*
+ * Restores the GIC distributor registers during resume or when coming out of
+ * idle.  Must be called before enabling interrupts.  If a level interrupt
+ * that occured while the GIC was suspended is still present, it will be
+ * handled normally, but any edge interrupts that occured will not be seen by
+ * the GIC and need to be handled by the platform-specific wakeup source.
+ */
+void gic_dist_restore(unsigned int gic_nr)
+{
+	unsigned int gic_irqs;
+	unsigned int i;
+	void __iomem *dist_base;
+	void __iomem *cpu_base;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	_gic_dist_init(&gic_data[gic_nr]);
+
+	gic_irqs = gic_data[gic_nr].gic_irqs;
+	dist_base = gic_data[gic_nr].dist_base;
+	cpu_base = gic_data[gic_nr].cpu_base;
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 16); i++)
+		writel(gic_data[gic_nr].saved_conf[i],
+			dist_base + GIC_DIST_CONFIG + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		writel(gic_data[gic_nr].saved_pri[i],
+			dist_base + GIC_DIST_PRI + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 4); i++)
+		writel(gic_data[gic_nr].saved_target[i],
+			dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(gic_irqs, 32); i++)
+		writel(gic_data[gic_nr].saved_enable[i],
+			dist_base + GIC_DIST_ENABLE_SET + i * 4);
+
+	writel(1, dist_base + GIC_DIST_CTRL);
+	writel(0xf0, cpu_base + GIC_CPU_PRIMASK);
+	writel(1, cpu_base + GIC_CPU_CTRL);
+}
+#endif
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 84557d3..d0c2ba9 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -37,6 +37,9 @@ extern void __iomem *gic_cpu_base_addr;
 
 void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
 void gic_secondary_init(unsigned int);
+void gic_dist_save(unsigned int gic_nr);
+void gic_dist_restore(unsigned int gic_nr);
+void gic_cpu_exit(unsigned int gic_nr);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
 void gic_enable_ppi(unsigned int);
-- 
1.7.3.1

