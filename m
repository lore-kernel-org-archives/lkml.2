Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0JACtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 22:49:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0JACtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 22:49:14 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Gary King <gking@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] gic: Add functions to save and restore gic state
Date: Thu, 30 Sep 2010 19:48:53 -0700
Message-Id: <1285901335-26354-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on systems with idle states which power-gate the logic including
the gic, such as tegra, the gic distributor needs to be shut down
and restored on entry and exit from the architecture idle code

Change-Id: I17603f5ac70d65c05587d0647cce3ba87675e117
Original-author: Gary King <gking@nvidia.com>
Signed-off-by: Gary King <gking@nvidia.com>
Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/common/gic.c               |  123 ++++++++++++++++++++++++++++++++--
 arch/arm/include/asm/hardware/gic.h |    4 +
 2 files changed, 119 insertions(+), 8 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 7dfa9a8..cfbe8b1 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -39,6 +39,13 @@ struct gic_chip_data {
 	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+#ifdef CONFIG_PM
+	u32 saved_enable[DIV_ROUND_UP(1020, 32)];
+	u32 saved_conf[DIV_ROUND_UP(1020, 16)];
+	u32 saved_pri[DIV_ROUND_UP(1020, 4)];
+	u32 saved_target[DIV_ROUND_UP(1020, 4)];
+#endif
+	unsigned int max_irq;
 };
 
 #ifndef MAX_GIC_NR
@@ -221,21 +228,15 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	set_irq_chained_handler(irq, gic_handle_cascade_irq);
 }
 
-void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
-			  unsigned int irq_start)
+static unsigned int _gic_dist_init(unsigned int gic_nr)
 {
 	unsigned int max_irq, i;
+	void __iomem *base = gic_data[gic_nr].dist_base;
 	u32 cpumask = 1 << smp_processor_id();
 
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
-
 	cpumask |= cpumask << 8;
 	cpumask |= cpumask << 16;
 
-	gic_data[gic_nr].dist_base = base;
-	gic_data[gic_nr].irq_offset = (irq_start - 1) & ~31;
-
 	writel(0, base + GIC_DIST_CTRL);
 
 	/*
@@ -276,6 +277,96 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	for (i = 0; i < max_irq; i += 32)
 		writel(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 
+	return max_irq;
+}
+
+static void _gic_dist_exit(unsigned int gic_nr)
+{
+	writel(0, gic_data[gic_nr].dist_base + GIC_DIST_CTRL);
+}
+
+#ifdef CONFIG_PM
+void gic_dist_save(unsigned int gic_nr)
+{
+	unsigned int max_irq = gic_data[gic_nr].max_irq;
+	void __iomem *dist_base = gic_data[gic_nr].dist_base;
+	int i;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	_gic_dist_exit(gic_nr);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 16); i++)
+		gic_data[gic_nr].saved_conf[i] =
+			readl(dist_base + GIC_DIST_CONFIG + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
+		gic_data[gic_nr].saved_pri[i] =
+			readl(dist_base + GIC_DIST_PRI + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
+		gic_data[gic_nr].saved_target[i] =
+			readl(dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 32); i++)
+		gic_data[gic_nr].saved_enable[i] =
+			readl(dist_base + GIC_DIST_ENABLE_SET + i * 4);
+}
+
+void gic_dist_restore(unsigned int gic_nr)
+{
+	unsigned int max_irq;
+	unsigned int i;
+	void __iomem *dist_base;
+	void __iomem *cpu_base;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	_gic_dist_init(gic_nr);
+
+	max_irq = gic_data[gic_nr].max_irq;
+	dist_base = gic_data[gic_nr].dist_base;
+	cpu_base = gic_data[gic_nr].cpu_base;
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 16); i++)
+		writel(gic_data[gic_nr].saved_conf[i],
+			dist_base + GIC_DIST_CONFIG + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
+		writel(gic_data[gic_nr].saved_pri[i],
+			dist_base + GIC_DIST_PRI + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 4); i++)
+		writel(gic_data[gic_nr].saved_target[i],
+			dist_base + GIC_DIST_TARGET + i * 4);
+
+	for (i = 0; i < DIV_ROUND_UP(max_irq, 32); i++)
+		writel(gic_data[gic_nr].saved_enable[i],
+			dist_base + GIC_DIST_ENABLE_SET + i * 4);
+
+	writel(1, dist_base + GIC_DIST_CTRL);
+	writel(0xf0, cpu_base + GIC_CPU_PRIMASK);
+	writel(1, cpu_base + GIC_CPU_CTRL);
+}
+#endif
+
+void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
+			  unsigned int irq_start)
+{
+	unsigned int max_irq;
+	unsigned int i;
+
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	gic_data[gic_nr].dist_base = base;
+	gic_data[gic_nr].irq_offset = (irq_start - 1) & ~31;
+
+	max_irq = _gic_dist_init(gic_nr);
+	gic_data[gic_nr].max_irq = max_irq;
+
 	/*
 	 * Setup the Linux IRQ subsystem.
 	 */
@@ -289,6 +380,14 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	writel(1, base + GIC_DIST_CTRL);
 }
 
+void gic_dist_exit(unsigned int gic_nr)
+{
+	if (gic_nr >= MAX_GIC_NR)
+		BUG();
+
+	_gic_dist_exit(gic_nr);
+}
+
 void __cpuinit gic_cpu_init(unsigned int gic_nr, void __iomem *base)
 {
 	if (gic_nr >= MAX_GIC_NR)
@@ -300,6 +399,14 @@ void __cpuinit gic_cpu_init(unsigned int gic_nr, void __iomem *base)
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
 #ifdef CONFIG_SMP
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 {
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 7f34333..0a198b0 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -34,7 +34,11 @@
 
 #ifndef __ASSEMBLY__
 void gic_dist_init(unsigned int gic_nr, void __iomem *base, unsigned int irq_start);
+void gic_dist_save(unsigned int gic_nr);
+void gic_dist_restore(unsigned int gic_nr);
+void gic_dist_exit(unsigned int gic_nr);
 void gic_cpu_init(unsigned int gic_nr, void __iomem *base);
+void gic_cpu_exit(unsigned int gic_nr);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
 #endif
-- 
1.7.1

