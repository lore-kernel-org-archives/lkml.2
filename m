Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2J3IAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:00:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37523 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab2J3IAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:00:14 -0400
X-AuditID: cbfee61b-b7f616d00000319b-ca-508f88ecd8b9
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com
Subject: [PATCH] ARM: Exynos: move interrupt combiner controller driver to
 drivers/irqchip
Date: Tue, 30 Oct 2012 13:52:36 +0530
Message-id: <1351585356-13008-1-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t9jAd03Hf0BBl8eiVpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU83nKLtWBGaUXP75ssDYwvEroYOTkkBEwk/kyezAxh
	i0lcuLeeDcQWEljEKHGhK72LkQvIbmOS2N72mB0kwSZgIPFo4TswW0RAVeJz2wIwm1kgXmL9
	8ldMILawQIzEwm0/WEFsFqCa57M2g9XwCnhKtHyZxA6xTEliQ+9RpgmM3AsYGVYxiqYWJBcU
	J6XnGukVJ+YWl+al6yXn525iBPvymfQOxlUNFocYBTgYlXh4N67pCxBiTSwrrsw9xCjBwawk
	wpvv3R8gxJuSWFmVWpQfX1Sak1p8iFGag0VJnLfZIyVASCA9sSQ1OzW1ILUIJsvEwSnVwDj3
	78pdKdHs/fkPD7/JvXG74LxitpyJR1bF/GtvXoUffusZOEXh29FyhyCJsrhb/38lHfaM9eFv
	E85/uNtBtc53nYO/+t65h1oeBPhJhD05sFPY5aJpeZrM3dBJdaonRYvmO6zq22bxuuuAp92T
	h3qrHxiudG9NF3vXVfFGZunixvsV1o/XP1ViKc5INNRiLipOBABgvrGA4QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irqchip support for interrupt combiner controller is moved into
drivers/irqchip directory from arch/arm/mach-exynos/common.c file.

While at it, the use of soc_is_exynos4/5() macro in the combiner controller
driver (used to determine the number of combiners) is removed. Instead, a new
parameter is added to combiner_init function that allows non-dt platform code
to specify the number of combiners available.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/common.c           |  210 +------------------------------
 drivers/irqchip/Makefile                |    1 +
 drivers/irqchip/irq-exynos-combiner.c   |  212 +++++++++++++++++++++++++++++++
 include/linux/irqchip/exynos-combiner.h |   18 +++
 4 files changed, 234 insertions(+), 207 deletions(-)
 create mode 100644 drivers/irqchip/irq-exynos-combiner.c
 create mode 100644 include/linux/irqchip/exynos-combiner.h

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index 5c75815..56844d1 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -17,11 +17,9 @@
 #include <linux/gpio.h>
 #include <linux/sched.h>
 #include <linux/serial_core.h>
-#include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/export.h>
-#include <linux/irqdomain.h>
-#include <linux/of_address.h>
+#include <linux/irqchip/exynos-combiner.h>
 
 #include <asm/proc-fns.h>
 #include <asm/exception.h>
@@ -384,210 +382,7 @@ static void __init exynos5_init_clocks(int xtal)
 	exynos5_setup_clocks();
 }
 
-#define COMBINER_ENABLE_SET	0x0
-#define COMBINER_ENABLE_CLEAR	0x4
-#define COMBINER_INT_STATUS	0xC
-
-static DEFINE_SPINLOCK(irq_controller_lock);
-
-struct combiner_chip_data {
-	unsigned int irq_offset;
-	unsigned int irq_mask;
-	void __iomem *base;
-};
-
-static struct irq_domain *combiner_irq_domain;
-static struct combiner_chip_data combiner_data[MAX_COMBINER_NR];
-
-static inline void __iomem *combiner_base(struct irq_data *data)
-{
-	struct combiner_chip_data *combiner_data =
-		irq_data_get_irq_chip_data(data);
-
-	return combiner_data->base;
-}
-
-static void combiner_mask_irq(struct irq_data *data)
-{
-	u32 mask = 1 << (data->hwirq % 32);
-
-	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_CLEAR);
-}
-
-static void combiner_unmask_irq(struct irq_data *data)
-{
-	u32 mask = 1 << (data->hwirq % 32);
-
-	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_SET);
-}
-
-static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
-{
-	struct combiner_chip_data *chip_data = irq_get_handler_data(irq);
-	struct irq_chip *chip = irq_get_chip(irq);
-	unsigned int cascade_irq, combiner_irq;
-	unsigned long status;
-
-	chained_irq_enter(chip, desc);
-
-	spin_lock(&irq_controller_lock);
-	status = __raw_readl(chip_data->base + COMBINER_INT_STATUS);
-	spin_unlock(&irq_controller_lock);
-	status &= chip_data->irq_mask;
-
-	if (status == 0)
-		goto out;
-
-	combiner_irq = __ffs(status);
-
-	cascade_irq = combiner_irq + (chip_data->irq_offset & ~31);
-	if (unlikely(cascade_irq >= NR_IRQS))
-		do_bad_IRQ(cascade_irq, desc);
-	else
-		generic_handle_irq(cascade_irq);
-
- out:
-	chained_irq_exit(chip, desc);
-}
-
-static struct irq_chip combiner_chip = {
-	.name		= "COMBINER",
-	.irq_mask	= combiner_mask_irq,
-	.irq_unmask	= combiner_unmask_irq,
-};
-
-static void __init combiner_cascade_irq(unsigned int combiner_nr, unsigned int irq)
-{
-	unsigned int max_nr;
-
-	if (soc_is_exynos5250())
-		max_nr = EXYNOS5_MAX_COMBINER_NR;
-	else
-		max_nr = EXYNOS4_MAX_COMBINER_NR;
-
-	if (combiner_nr >= max_nr)
-		BUG();
-	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
-		BUG();
-	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
-}
-
-static void __init combiner_init_one(unsigned int combiner_nr,
-				     void __iomem *base)
-{
-	combiner_data[combiner_nr].base = base;
-	combiner_data[combiner_nr].irq_offset = irq_find_mapping(
-		combiner_irq_domain, combiner_nr * MAX_IRQ_IN_COMBINER);
-	combiner_data[combiner_nr].irq_mask = 0xff << ((combiner_nr % 4) << 3);
-
-	/* Disable all interrupts */
-	__raw_writel(combiner_data[combiner_nr].irq_mask,
-		     base + COMBINER_ENABLE_CLEAR);
-}
-
 #ifdef CONFIG_OF
-static int combiner_irq_domain_xlate(struct irq_domain *d,
-				     struct device_node *controller,
-				     const u32 *intspec, unsigned int intsize,
-				     unsigned long *out_hwirq,
-				     unsigned int *out_type)
-{
-	if (d->of_node != controller)
-		return -EINVAL;
-
-	if (intsize < 2)
-		return -EINVAL;
-
-	*out_hwirq = intspec[0] * MAX_IRQ_IN_COMBINER + intspec[1];
-	*out_type = 0;
-
-	return 0;
-}
-#else
-static int combiner_irq_domain_xlate(struct irq_domain *d,
-				     struct device_node *controller,
-				     const u32 *intspec, unsigned int intsize,
-				     unsigned long *out_hwirq,
-				     unsigned int *out_type)
-{
-	return -EINVAL;
-}
-#endif
-
-static int combiner_irq_domain_map(struct irq_domain *d, unsigned int irq,
-				   irq_hw_number_t hw)
-{
-	irq_set_chip_and_handler(irq, &combiner_chip, handle_level_irq);
-	irq_set_chip_data(irq, &combiner_data[hw >> 3]);
-	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-
-	return 0;
-}
-
-static struct irq_domain_ops combiner_irq_domain_ops = {
-	.xlate	= combiner_irq_domain_xlate,
-	.map	= combiner_irq_domain_map,
-};
-
-static void __init combiner_init(void __iomem *combiner_base,
-				 struct device_node *np)
-{
-	int i, irq, irq_base;
-	unsigned int max_nr, nr_irq;
-
-	if (np) {
-		if (of_property_read_u32(np, "samsung,combiner-nr", &max_nr)) {
-			pr_warning("%s: number of combiners not specified, "
-				"setting default as %d.\n",
-				__func__, EXYNOS4_MAX_COMBINER_NR);
-			max_nr = EXYNOS4_MAX_COMBINER_NR;
-		}
-	} else {
-		max_nr = soc_is_exynos5250() ? EXYNOS5_MAX_COMBINER_NR :
-						EXYNOS4_MAX_COMBINER_NR;
-	}
-	nr_irq = max_nr * MAX_IRQ_IN_COMBINER;
-
-	irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
-	if (IS_ERR_VALUE(irq_base)) {
-		irq_base = COMBINER_IRQ(0, 0);
-		pr_warning("%s: irq desc alloc failed. Continuing with %d as linux irq base\n", __func__, irq_base);
-	}
-
-	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
-				&combiner_irq_domain_ops, &combiner_data);
-	if (WARN_ON(!combiner_irq_domain)) {
-		pr_warning("%s: irq domain init failed\n", __func__);
-		return;
-	}
-
-	for (i = 0; i < max_nr; i++) {
-		combiner_init_one(i, combiner_base + (i >> 2) * 0x10);
-		irq = IRQ_SPI(i);
-#ifdef CONFIG_OF
-		if (np)
-			irq = irq_of_parse_and_map(np, i);
-#endif
-		combiner_cascade_irq(i, irq);
-	}
-}
-
-#ifdef CONFIG_OF
-int __init combiner_of_init(struct device_node *np, struct device_node *parent)
-{
-	void __iomem *combiner_base;
-
-	combiner_base = of_iomap(np, 0);
-	if (!combiner_base) {
-		pr_err("%s: failed to map combiner registers\n", __func__);
-		return -ENXIO;
-	}
-
-	combiner_init(combiner_base, np);
-
-	return 0;
-}
-
 static const struct of_device_id exynos4_dt_irq_match[] = {
 	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
 	{ .compatible = "samsung,exynos4210-combiner",
@@ -610,7 +405,8 @@ void __init exynos4_init_irq(void)
 #endif
 
 	if (!of_have_populated_dt())
-		combiner_init(S5P_VA_COMBINER_BASE, NULL);
+		combiner_init(S5P_VA_COMBINER_BASE, EXYNOS4_MAX_COMBINER_NR,
+					NULL);
 
 	/*
 	 * The parameters of s5p_init_irq() are for VIC init.
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index 054321d..8501eaa 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_ARCH_BCM2835) += irq-bcm2835.o
+obj-$(CONFIG_ARCH_EXYNOS) += irq-exynos-combiner.o
diff --git a/drivers/irqchip/irq-exynos-combiner.c b/drivers/irqchip/irq-exynos-combiner.c
new file mode 100644
index 0000000..86caa98
--- /dev/null
+++ b/drivers/irqchip/irq-exynos-combiner.c
@@ -0,0 +1,212 @@
+/*
+ * Copyright (c) 2012-2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * Interrupt combiner controller driver for Samsung Exynos platforms.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/export.h>
+#include <linux/irqdomain.h>
+#include <linux/of_address.h>
+#include <linux/err.h>
+#include <asm/mach/irq.h>
+
+#define COMBINER_ENABLE_SET	0x0
+#define COMBINER_ENABLE_CLEAR	0x4
+#define COMBINER_INT_STATUS	0xC
+
+struct combiner_chip_data {
+	unsigned int irq_offset;
+	unsigned int irq_mask;
+	void __iomem *base;
+};
+
+static DEFINE_SPINLOCK(irq_controller_lock);
+static struct irq_domain *combiner_irq_domain;
+static struct combiner_chip_data combiner_data[MAX_COMBINER_NR];
+
+static inline void __iomem *combiner_base(struct irq_data *data)
+{
+	struct combiner_chip_data *combiner_data =
+		irq_data_get_irq_chip_data(data);
+
+	return combiner_data->base;
+}
+
+static void combiner_mask_irq(struct irq_data *data)
+{
+	u32 mask = 1 << (data->hwirq % 32);
+
+	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_CLEAR);
+}
+
+static void combiner_unmask_irq(struct irq_data *data)
+{
+	u32 mask = 1 << (data->hwirq % 32);
+
+	__raw_writel(mask, combiner_base(data) + COMBINER_ENABLE_SET);
+}
+
+static void combiner_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct combiner_chip_data *chip_data = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_get_chip(irq);
+	unsigned int cascade_irq, combiner_irq;
+	unsigned long status;
+
+	chained_irq_enter(chip, desc);
+
+	spin_lock(&irq_controller_lock);
+	status = __raw_readl(chip_data->base + COMBINER_INT_STATUS);
+	spin_unlock(&irq_controller_lock);
+	status &= chip_data->irq_mask;
+
+	if (status == 0)
+		goto out;
+
+	combiner_irq = __ffs(status);
+
+	cascade_irq = combiner_irq + (chip_data->irq_offset & ~31);
+	if (unlikely(cascade_irq >= NR_IRQS))
+		do_bad_IRQ(cascade_irq, desc);
+	else
+		generic_handle_irq(cascade_irq);
+
+ out:
+	chained_irq_exit(chip, desc);
+}
+
+static struct irq_chip combiner_chip = {
+	.name		= "COMBINER",
+	.irq_mask	= combiner_mask_irq,
+	.irq_unmask	= combiner_unmask_irq,
+};
+
+static void __init combiner_cascade_irq(unsigned int combiner_nr,
+						unsigned int irq)
+{
+	if (irq_set_handler_data(irq, &combiner_data[combiner_nr]) != 0)
+		BUG();
+	irq_set_chained_handler(irq, combiner_handle_cascade_irq);
+}
+
+static void __init combiner_init_one(unsigned int combiner_nr,
+				     void __iomem *base)
+{
+	combiner_data[combiner_nr].base = base;
+	combiner_data[combiner_nr].irq_offset = irq_find_mapping(
+		combiner_irq_domain, combiner_nr * MAX_IRQ_IN_COMBINER);
+	combiner_data[combiner_nr].irq_mask = 0xff << ((combiner_nr % 4) << 3);
+
+	/* Disable all interrupts */
+	__raw_writel(combiner_data[combiner_nr].irq_mask,
+		     base + COMBINER_ENABLE_CLEAR);
+}
+
+#ifdef CONFIG_OF
+static int combiner_irq_domain_xlate(struct irq_domain *d,
+				     struct device_node *controller,
+				     const u32 *intspec, unsigned int intsize,
+				     unsigned long *out_hwirq,
+				     unsigned int *out_type)
+{
+	if (d->of_node != controller)
+		return -EINVAL;
+
+	if (intsize < 2)
+		return -EINVAL;
+
+	*out_hwirq = intspec[0] * MAX_IRQ_IN_COMBINER + intspec[1];
+	*out_type = 0;
+
+	return 0;
+}
+#else
+static int combiner_irq_domain_xlate(struct irq_domain *d,
+				     struct device_node *controller,
+				     const u32 *intspec, unsigned int intsize,
+				     unsigned long *out_hwirq,
+				     unsigned int *out_type)
+{
+	return -EINVAL;
+}
+#endif
+
+static int combiner_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				   irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(irq, &combiner_chip, handle_level_irq);
+	irq_set_chip_data(irq, &combiner_data[hw >> 3]);
+	set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+
+	return 0;
+}
+
+static struct irq_domain_ops combiner_irq_domain_ops = {
+	.xlate	= combiner_irq_domain_xlate,
+	.map	= combiner_irq_domain_map,
+};
+
+void __init combiner_init(void __iomem *combiner_base, unsigned int nr_combiner,
+					struct device_node *np)
+{
+	int i, irq, irq_base;
+	unsigned int nr_irq;
+
+	nr_irq = nr_combiner * MAX_IRQ_IN_COMBINER;
+
+	irq_base = irq_alloc_descs(COMBINER_IRQ(0, 0), 1, nr_irq, 0);
+	if (IS_ERR_VALUE(irq_base)) {
+		irq_base = COMBINER_IRQ(0, 0);
+		pr_warn("%s: irq desc alloc failed. Continuing with %d as "
+				"linux irq base\n", __func__, irq_base);
+	}
+
+	combiner_irq_domain = irq_domain_add_legacy(np, nr_irq, irq_base, 0,
+				&combiner_irq_domain_ops, &combiner_data);
+	if (WARN_ON(!combiner_irq_domain)) {
+		pr_warn("%s: irq domain init failed\n", __func__);
+		return;
+	}
+
+	for (i = 0; i < nr_combiner; i++) {
+		combiner_init_one(i, combiner_base + (i >> 2) * 0x10);
+		irq = IRQ_SPI(i);
+#ifdef CONFIG_OF
+		if (np)
+			irq = irq_of_parse_and_map(np, i);
+#endif
+		combiner_cascade_irq(i, irq);
+	}
+}
+
+#ifdef CONFIG_OF
+int __init combiner_of_init(struct device_node *np, struct device_node *parent)
+{
+	void __iomem *combiner_base;
+	unsigned int nr_combiner;
+
+	combiner_base = of_iomap(np, 0);
+	if (!combiner_base) {
+		pr_err("%s: failed to map combiner registers\n", __func__);
+		return -ENXIO;
+	}
+
+	if (of_property_read_u32(np, "samsung,combiner-nr", &nr_combiner)) {
+			pr_warn("%s: number of combiners not specified, "
+			"setting default as %d.\n",
+			__func__, EXYNOS4_MAX_COMBINER_NR);
+		nr_combiner = EXYNOS4_MAX_COMBINER_NR;
+	}
+
+	combiner_init(combiner_base, nr_combiner, np);
+	return 0;
+}
+#endif
diff --git a/include/linux/irqchip/exynos-combiner.h b/include/linux/irqchip/exynos-combiner.h
new file mode 100644
index 0000000..faa781c
--- /dev/null
+++ b/include/linux/irqchip/exynos-combiner.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (c) 2012-2013 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_IRQCHIP_EXYNOS_COMBINER_H_
+#define __LINUX_IRQCHIP_EXYNOS_COMBINER_H_
+
+extern void __init combiner_init(void __iomem *combiner_base,
+			unsigned int nr_combiner, struct device_node *np);
+extern int __init combiner_of_init(struct device_node *np,
+			struct device_node *parent);
+
+#endif /* __LINUX_IRQCHIP_EXYNOS_COMBINER_H_ */
-- 
1.6.6.rc2

