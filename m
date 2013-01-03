Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3ACDZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:25:31 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:50089 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3ACDZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:25:19 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] irqchip: vt8500: Move irq code to drivers/irqchip
Date: Thu,  3 Jan 2013 16:25:10 +1300
Message-Id: <1357183510-8476-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
References: <1357183510-8476-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mach-vt8500/irq.c to drivers/irqchip/irq-vt8500.c and make
necessary Makefile changes. No code changes required.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
CC: Thomas Gleixner <tglx@linutronix.de>
 arch/arm/mach-vt8500/Makefile |    2 +-
 arch/arm/mach-vt8500/common.h |    7 +-
 arch/arm/mach-vt8500/irq.c    |  253 -----------------------------------------
 drivers/irqchip/Makefile      |    1 +
 drivers/irqchip/irq-vt8500.c  |  253 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 258 insertions(+), 258 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/irq.c
 create mode 100644 drivers/irqchip/irq-vt8500.c

diff --git a/arch/arm/mach-vt8500/Makefile b/arch/arm/mach-vt8500/Makefile
index 92ceb24..4c8a846 100644
--- a/arch/arm/mach-vt8500/Makefile
+++ b/arch/arm/mach-vt8500/Makefile
@@ -1 +1 @@
-obj-$(CONFIG_ARCH_VT8500) += irq.o vt8500.o
+obj-$(CONFIG_ARCH_VT8500) += vt8500.o
diff --git a/arch/arm/mach-vt8500/common.h b/arch/arm/mach-vt8500/common.h
index 5d37a4f..b198a81 100644
--- a/arch/arm/mach-vt8500/common.h
+++ b/arch/arm/mach-vt8500/common.h
@@ -18,13 +18,12 @@
 
 #include <linux/of.h>
 
-int __init vt8500_irq_init(struct device_node *node,
-				struct device_node *parent);
-
 /* defined in drivers/clk/clk-vt8500.c */
 void __init vtwm_clk_init(void __iomem *pmc_base);
 
-/* defined in irq.c */
+/* defined in drivers/irqchip/irq.c */
+int __init vt8500_irq_init(struct device_node *node,
+				struct device_node *parent);
 asmlinkage void vt8500_handle_irq(struct pt_regs *regs);
 
 /* defined in drivers/clocksource/vt8500_timer.c */
diff --git a/arch/arm/mach-vt8500/irq.c b/arch/arm/mach-vt8500/irq.c
deleted file mode 100644
index b9cf5ce..0000000
--- a/arch/arm/mach-vt8500/irq.c
+++ /dev/null
@@ -1,253 +0,0 @@
-/*
- *  arch/arm/mach-vt8500/irq.c
- *
- *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-/*
- * This file is copied and modified from the original irq.c provided by
- * Alexey Charkov. Minor changes have been made for Device Tree Support.
- */
-
-#include <linux/slab.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/interrupt.h>
-#include <linux/bitops.h>
-
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_address.h>
-
-#include <asm/irq.h>
-#include <asm/exception.h>
-
-#define VT8500_ICPC_IRQ		0x20
-#define VT8500_ICPC_FIQ		0x24
-#define VT8500_ICDC		0x40		/* Destination Control 64*u32 */
-#define VT8500_ICIS		0x80		/* Interrupt status, 16*u32 */
-
-/* ICPC */
-#define ICPC_MASK		0x3F
-#define ICPC_ROTATE		BIT(6)
-
-/* IC_DCTR */
-#define ICDC_IRQ		0x00
-#define ICDC_FIQ		0x01
-#define ICDC_DSS0		0x02
-#define ICDC_DSS1		0x03
-#define ICDC_DSS2		0x04
-#define ICDC_DSS3		0x05
-#define ICDC_DSS4		0x06
-#define ICDC_DSS5		0x07
-
-#define VT8500_INT_DISABLE	0
-#define VT8500_INT_ENABLE	BIT(3)
-
-#define VT8500_TRIGGER_HIGH	0
-#define VT8500_TRIGGER_RISING	BIT(5)
-#define VT8500_TRIGGER_FALLING	BIT(6)
-#define VT8500_EDGE		( VT8500_TRIGGER_RISING \
-				| VT8500_TRIGGER_FALLING)
-
-/* vt8500 has 1 intc, wm8505 and wm8650 have 2 */
-#define VT8500_INTC_MAX		2
-
-struct vt8500_irq_data {
-	void __iomem 		*base;		/* IO Memory base address */
-	struct irq_domain	*domain;	/* Domain for this controller */
-};
-
-/* Global variable for accessing io-mem addresses */
-static struct vt8500_irq_data intc[VT8500_INTC_MAX];
-static u32 active_cnt = 0;
-
-static void vt8500_irq_mask(struct irq_data *d)
-{
-	struct vt8500_irq_data *priv = d->domain->host_data;
-	void __iomem *base = priv->base;
-	void __iomem *stat_reg = base + VT8500_ICIS + (d->hwirq < 32 ? 0 : 4);
-	u8 edge, dctr;
-	u32 status;
-
-	edge = readb(base + VT8500_ICDC + d->hwirq) & VT8500_EDGE;
-	if (edge) {
-		status = readl(stat_reg);
-
-		status |= (1 << (d->hwirq & 0x1f));
-		writel(status, stat_reg);
-	} else {
-		dctr = readb(base + VT8500_ICDC + d->hwirq);
-		dctr &= ~VT8500_INT_ENABLE;
-		writeb(dctr, base + VT8500_ICDC + d->hwirq);
-	}
-}
-
-static void vt8500_irq_unmask(struct irq_data *d)
-{
-	struct vt8500_irq_data *priv = d->domain->host_data;
-	void __iomem *base = priv->base;
-	u8 dctr;
-
-	dctr = readb(base + VT8500_ICDC + d->hwirq);
-	dctr |= VT8500_INT_ENABLE;
-	writeb(dctr, base + VT8500_ICDC + d->hwirq);
-}
-
-static int vt8500_irq_set_type(struct irq_data *d, unsigned int flow_type)
-{
-	struct vt8500_irq_data *priv = d->domain->host_data;
-	void __iomem *base = priv->base;
-	u8 dctr;
-
-	dctr = readb(base + VT8500_ICDC + d->hwirq);
-	dctr &= ~VT8500_EDGE;
-
-	switch (flow_type) {
-	case IRQF_TRIGGER_LOW:
-		return -EINVAL;
-	case IRQF_TRIGGER_HIGH:
-		dctr |= VT8500_TRIGGER_HIGH;
-		__irq_set_handler_locked(d->irq, handle_level_irq);
-		break;
-	case IRQF_TRIGGER_FALLING:
-		dctr |= VT8500_TRIGGER_FALLING;
-		__irq_set_handler_locked(d->irq, handle_edge_irq);
-		break;
-	case IRQF_TRIGGER_RISING:
-		dctr |= VT8500_TRIGGER_RISING;
-		__irq_set_handler_locked(d->irq, handle_edge_irq);
-		break;
-	}
-	writeb(dctr, base + VT8500_ICDC + d->hwirq);
-
-	return 0;
-}
-
-static struct irq_chip vt8500_irq_chip = {
-	.name = "vt8500",
-	.irq_ack = vt8500_irq_mask,
-	.irq_mask = vt8500_irq_mask,
-	.irq_unmask = vt8500_irq_unmask,
-	.irq_set_type = vt8500_irq_set_type,
-};
-
-static void __init vt8500_init_irq_hw(void __iomem *base)
-{
-	u32 i;
-
-	/* Enable rotating priority for IRQ */
-	writel(ICPC_ROTATE, base + VT8500_ICPC_IRQ);
-	writel(0x00, base + VT8500_ICPC_FIQ);
-
-	/* Disable all interrupts and route them to IRQ */
-	for (i = 0; i < 64; i++)
-		writeb(VT8500_INT_DISABLE | ICDC_IRQ, base + VT8500_ICDC + i);
-}
-
-static int vt8500_irq_map(struct irq_domain *h, unsigned int virq,
-							irq_hw_number_t hw)
-{
-	irq_set_chip_and_handler(virq, &vt8500_irq_chip, handle_level_irq);
-	set_irq_flags(virq, IRQF_VALID);
-
-	return 0;
-}
-
-static struct irq_domain_ops vt8500_irq_domain_ops = {
-	.map = vt8500_irq_map,
-	.xlate = irq_domain_xlate_onecell,
-};
-
-asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
-{
-	u32 stat, i;
-	int irqnr, virq;
-	void __iomem *base;
-
-	/* Loop through each active controller */
-	for (i=0; i<active_cnt; i++) {
-		base = intc[i].base;
-		irqnr = readl_relaxed(base) & 0x3F;
-		/*
-		  Highest Priority register default = 63, so check that this
-		  is a real interrupt by checking the status register
-		*/
-		if (irqnr == 63) {
-			stat = readl_relaxed(base + VT8500_ICIS + 4);
-			if (!(stat & BIT(31)))
-				continue;
-		}
-
-		virq = irq_find_mapping(intc[i].domain, irqnr);
-		handle_IRQ(virq, regs);
-	}
-}
-
-int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
-{
-	int irq, i;
-	struct device_node *np = node;
-
-	if (active_cnt == VT8500_INTC_MAX) {
-		pr_err("%s: Interrupt controllers > VT8500_INTC_MAX\n",
-								__func__);
-		goto out;
-	}
-
-	intc[active_cnt].base = of_iomap(np, 0);
-	intc[active_cnt].domain = irq_domain_add_linear(node, 64,
-			&vt8500_irq_domain_ops,	&intc[active_cnt]);
-
-	if (!intc[active_cnt].base) {
-		pr_err("%s: Unable to map IO memory\n", __func__);
-		goto out;
-	}
-
-	if (!intc[active_cnt].domain) {
-		pr_err("%s: Unable to add irq domain!\n", __func__);
-		goto out;
-	}
-
-	vt8500_init_irq_hw(intc[active_cnt].base);
-
-	pr_info("vt8500-irq: Added interrupt controller\n");
-
-	active_cnt++;
-
-	/* check if this is a slaved controller */
-	if (of_irq_count(np) != 0) {
-		/* check that we have the correct number of interrupts */
-		if (of_irq_count(np) != 8) {
-			pr_err("%s: Incorrect IRQ map for slaved controller\n",
-					__func__);
-			return -EINVAL;
-		}
-
-		for (i = 0; i < 8; i++) {
-			irq = irq_of_parse_and_map(np, i);
-			enable_irq(irq);
-		}
-
-		pr_info("vt8500-irq: Enabled slave->parent interrupts\n");
-	}
-out:
-	return 0;
-}
-
diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
index bf4609a..4b0da48 100644
--- a/drivers/irqchip/Makefile
+++ b/drivers/irqchip/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_ARCH_BCM2835)		+= irq-bcm2835.o
 obj-$(CONFIG_ARCH_SUNXI)		+= irq-sunxi.o
+obj-$(CONFIG_ARCH_VT8500)		+= irq-vt8500.o
 obj-$(CONFIG_VERSATILE_FPGA_IRQ)	+= irq-versatile-fpga.o
 obj-$(CONFIG_ARCH_SPEAR3XX)		+= spear-shirq.o
diff --git a/drivers/irqchip/irq-vt8500.c b/drivers/irqchip/irq-vt8500.c
new file mode 100644
index 0000000..b9cf5ce
--- /dev/null
+++ b/drivers/irqchip/irq-vt8500.c
@@ -0,0 +1,253 @@
+/*
+ *  arch/arm/mach-vt8500/irq.c
+ *
+ *  Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
+ *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+/*
+ * This file is copied and modified from the original irq.c provided by
+ * Alexey Charkov. Minor changes have been made for Device Tree Support.
+ */
+
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/interrupt.h>
+#include <linux/bitops.h>
+
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+
+#include <asm/irq.h>
+#include <asm/exception.h>
+
+#define VT8500_ICPC_IRQ		0x20
+#define VT8500_ICPC_FIQ		0x24
+#define VT8500_ICDC		0x40		/* Destination Control 64*u32 */
+#define VT8500_ICIS		0x80		/* Interrupt status, 16*u32 */
+
+/* ICPC */
+#define ICPC_MASK		0x3F
+#define ICPC_ROTATE		BIT(6)
+
+/* IC_DCTR */
+#define ICDC_IRQ		0x00
+#define ICDC_FIQ		0x01
+#define ICDC_DSS0		0x02
+#define ICDC_DSS1		0x03
+#define ICDC_DSS2		0x04
+#define ICDC_DSS3		0x05
+#define ICDC_DSS4		0x06
+#define ICDC_DSS5		0x07
+
+#define VT8500_INT_DISABLE	0
+#define VT8500_INT_ENABLE	BIT(3)
+
+#define VT8500_TRIGGER_HIGH	0
+#define VT8500_TRIGGER_RISING	BIT(5)
+#define VT8500_TRIGGER_FALLING	BIT(6)
+#define VT8500_EDGE		( VT8500_TRIGGER_RISING \
+				| VT8500_TRIGGER_FALLING)
+
+/* vt8500 has 1 intc, wm8505 and wm8650 have 2 */
+#define VT8500_INTC_MAX		2
+
+struct vt8500_irq_data {
+	void __iomem 		*base;		/* IO Memory base address */
+	struct irq_domain	*domain;	/* Domain for this controller */
+};
+
+/* Global variable for accessing io-mem addresses */
+static struct vt8500_irq_data intc[VT8500_INTC_MAX];
+static u32 active_cnt = 0;
+
+static void vt8500_irq_mask(struct irq_data *d)
+{
+	struct vt8500_irq_data *priv = d->domain->host_data;
+	void __iomem *base = priv->base;
+	void __iomem *stat_reg = base + VT8500_ICIS + (d->hwirq < 32 ? 0 : 4);
+	u8 edge, dctr;
+	u32 status;
+
+	edge = readb(base + VT8500_ICDC + d->hwirq) & VT8500_EDGE;
+	if (edge) {
+		status = readl(stat_reg);
+
+		status |= (1 << (d->hwirq & 0x1f));
+		writel(status, stat_reg);
+	} else {
+		dctr = readb(base + VT8500_ICDC + d->hwirq);
+		dctr &= ~VT8500_INT_ENABLE;
+		writeb(dctr, base + VT8500_ICDC + d->hwirq);
+	}
+}
+
+static void vt8500_irq_unmask(struct irq_data *d)
+{
+	struct vt8500_irq_data *priv = d->domain->host_data;
+	void __iomem *base = priv->base;
+	u8 dctr;
+
+	dctr = readb(base + VT8500_ICDC + d->hwirq);
+	dctr |= VT8500_INT_ENABLE;
+	writeb(dctr, base + VT8500_ICDC + d->hwirq);
+}
+
+static int vt8500_irq_set_type(struct irq_data *d, unsigned int flow_type)
+{
+	struct vt8500_irq_data *priv = d->domain->host_data;
+	void __iomem *base = priv->base;
+	u8 dctr;
+
+	dctr = readb(base + VT8500_ICDC + d->hwirq);
+	dctr &= ~VT8500_EDGE;
+
+	switch (flow_type) {
+	case IRQF_TRIGGER_LOW:
+		return -EINVAL;
+	case IRQF_TRIGGER_HIGH:
+		dctr |= VT8500_TRIGGER_HIGH;
+		__irq_set_handler_locked(d->irq, handle_level_irq);
+		break;
+	case IRQF_TRIGGER_FALLING:
+		dctr |= VT8500_TRIGGER_FALLING;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+		break;
+	case IRQF_TRIGGER_RISING:
+		dctr |= VT8500_TRIGGER_RISING;
+		__irq_set_handler_locked(d->irq, handle_edge_irq);
+		break;
+	}
+	writeb(dctr, base + VT8500_ICDC + d->hwirq);
+
+	return 0;
+}
+
+static struct irq_chip vt8500_irq_chip = {
+	.name = "vt8500",
+	.irq_ack = vt8500_irq_mask,
+	.irq_mask = vt8500_irq_mask,
+	.irq_unmask = vt8500_irq_unmask,
+	.irq_set_type = vt8500_irq_set_type,
+};
+
+static void __init vt8500_init_irq_hw(void __iomem *base)
+{
+	u32 i;
+
+	/* Enable rotating priority for IRQ */
+	writel(ICPC_ROTATE, base + VT8500_ICPC_IRQ);
+	writel(0x00, base + VT8500_ICPC_FIQ);
+
+	/* Disable all interrupts and route them to IRQ */
+	for (i = 0; i < 64; i++)
+		writeb(VT8500_INT_DISABLE | ICDC_IRQ, base + VT8500_ICDC + i);
+}
+
+static int vt8500_irq_map(struct irq_domain *h, unsigned int virq,
+							irq_hw_number_t hw)
+{
+	irq_set_chip_and_handler(virq, &vt8500_irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID);
+
+	return 0;
+}
+
+static struct irq_domain_ops vt8500_irq_domain_ops = {
+	.map = vt8500_irq_map,
+	.xlate = irq_domain_xlate_onecell,
+};
+
+asmlinkage void __exception_irq_entry vt8500_handle_irq(struct pt_regs *regs)
+{
+	u32 stat, i;
+	int irqnr, virq;
+	void __iomem *base;
+
+	/* Loop through each active controller */
+	for (i=0; i<active_cnt; i++) {
+		base = intc[i].base;
+		irqnr = readl_relaxed(base) & 0x3F;
+		/*
+		  Highest Priority register default = 63, so check that this
+		  is a real interrupt by checking the status register
+		*/
+		if (irqnr == 63) {
+			stat = readl_relaxed(base + VT8500_ICIS + 4);
+			if (!(stat & BIT(31)))
+				continue;
+		}
+
+		virq = irq_find_mapping(intc[i].domain, irqnr);
+		handle_IRQ(virq, regs);
+	}
+}
+
+int __init vt8500_irq_init(struct device_node *node, struct device_node *parent)
+{
+	int irq, i;
+	struct device_node *np = node;
+
+	if (active_cnt == VT8500_INTC_MAX) {
+		pr_err("%s: Interrupt controllers > VT8500_INTC_MAX\n",
+								__func__);
+		goto out;
+	}
+
+	intc[active_cnt].base = of_iomap(np, 0);
+	intc[active_cnt].domain = irq_domain_add_linear(node, 64,
+			&vt8500_irq_domain_ops,	&intc[active_cnt]);
+
+	if (!intc[active_cnt].base) {
+		pr_err("%s: Unable to map IO memory\n", __func__);
+		goto out;
+	}
+
+	if (!intc[active_cnt].domain) {
+		pr_err("%s: Unable to add irq domain!\n", __func__);
+		goto out;
+	}
+
+	vt8500_init_irq_hw(intc[active_cnt].base);
+
+	pr_info("vt8500-irq: Added interrupt controller\n");
+
+	active_cnt++;
+
+	/* check if this is a slaved controller */
+	if (of_irq_count(np) != 0) {
+		/* check that we have the correct number of interrupts */
+		if (of_irq_count(np) != 8) {
+			pr_err("%s: Incorrect IRQ map for slaved controller\n",
+					__func__);
+			return -EINVAL;
+		}
+
+		for (i = 0; i < 8; i++) {
+			irq = irq_of_parse_and_map(np, i);
+			enable_irq(irq);
+		}
+
+		pr_info("vt8500-irq: Enabled slave->parent interrupts\n");
+	}
+out:
+	return 0;
+}
+
-- 
1.7.9.5

