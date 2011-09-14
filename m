Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab1INQcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:32:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41204 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab1INQcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:32:03 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 5/5] ARM: gic: add OF based initialization
Date: Wed, 14 Sep 2011 11:31:40 -0500
Message-Id: <1316017900-19918-6-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds gic initialization using device tree data. The initialization
functions are intended to be called by a generic OF interrupt
controller parsing function once the right pieces are in place.

PPIs are handled using 3rd cell of interrupts properties to specify the cpu
mask the PPI is assigned to.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++++++++++++
 arch/arm/common/gic.c                         |   55 +++++++++++++++++++++++--
 arch/arm/include/asm/hardware/gic.h           |   10 +++++
 3 files changed, 114 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/gic.txt

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
new file mode 100644
index 0000000..6c513de
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -0,0 +1,53 @@
+* ARM Generic Interrupt Controller
+
+ARM SMP cores are often associated with a GIC, providing per processor
+interrupts (PPI), shared processor interrupts (SPI) and software
+generated interrupts (SGI).
+
+Primary GIC is attached directly to the CPU and typically has PPIs and SGIs.
+Secondary GICs are cascaded into the upward interrupt controller and do not
+have PPIs or SGIs.
+
+Main node required properties:
+
+- compatible : should be one of:
+	"arm,cortex-a9-gic"
+	"arm,arm11mp-gic"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source.  The type shall be a <u32> and the value shall be 3.
+
+  The 1st cell is the interrupt number. 0-15 are reserved for SGIs. 16-31 are
+  for PPIs.
+
+  The 2nd cell is the level-sense information, encoded as follows:
+                    1 = low-to-high edge triggered
+                    2 = high-to-low edge triggered
+                    4 = active high level-sensitive
+                    8 = active low level-sensitive
+
+  Only values of 1 and 4 are valid for GIC 1.0 spec.
+
+  The 3rd cell contains the mask of the cpu number for the interrupt source.
+  The cpu mask is only valid for PPIs and shall be 0 for SPIs. This value shall
+  be 0 for PPIs.
+
+- reg : Specifies base physical address(s) and size of the GIC registers. The
+  first 2 values are the GIC distributor register base and size. The 2nd 2
+  values are the GIC cpu interface register base and size.
+
+Optional
+- interrupts	: Interrupt source of the parent interrupt controller. Only
+  present on secondary GICs.
+
+Example:
+
+	intc: interrupt-controller@fff11000 {
+		compatible = "arm,cortex-a9-gic";
+		#interrupt-cells = <3>;
+		#address-cells = <1>;
+		interrupt-controller;
+		reg = <0xfff11000 0x1000>,
+		      <0xfff10100 0x100>;
+	};
+
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index d1ccc72..14de380 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -28,6 +28,10 @@
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
 
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
@@ -255,6 +259,15 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
 
+static int gic_irq_count(void __iomem *dist_base)
+{
+	int gic_irqs = readl_relaxed(dist_base + GIC_DIST_CTR) & 0x1f;
+	gic_irqs = (gic_irqs + 1) * 32;
+	if (gic_irqs > 1020)
+		gic_irqs = 1020;
+	return gic_irqs;
+}
+
 static void __init gic_dist_init(struct gic_chip_data *gic,
 	unsigned int irq_start)
 {
@@ -277,10 +290,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	 * Find out how many interrupts are supported.
 	 * The GIC only supports up to 1020 interrupt sources.
 	 */
-	gic_irqs = readl_relaxed(base + GIC_DIST_CTR) & 0x1f;
-	gic_irqs = (gic_irqs + 1) * 32;
-	if (gic_irqs > 1020)
-		gic_irqs = 1020;
+	gic_irqs = gic_irq_count(base);
 
 	/*
 	 * Set all global interrupts to be level triggered, active low.
@@ -405,3 +415,40 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	writel_relaxed(map << 16 | irq, gic_data[0].dist_base + GIC_DIST_SOFTINT);
 }
 #endif
+
+#ifdef CONFIG_OF
+static int gic_cnt __initdata = 0;
+
+extern struct irq_domain_ops irq_domain_simple_ops;
+
+void __init gic_of_init(struct device_node *node, struct device_node *parent)
+{
+	void __iomem *cpu_base;
+	void __iomem *dist_base;
+	int irq;
+	struct irq_domain *domain = &gic_data[gic_cnt].domain;
+
+	if (WARN_ON(!node))
+		return;
+
+	dist_base = of_iomap(node, 0);
+	WARN(!dist_base, "unable to map gic dist registers\n");
+
+	cpu_base = of_iomap(node, 1);
+	WARN(!cpu_base, "unable to map gic cpu registers\n");
+
+	domain->nr_irq = gic_irq_count(dist_base);
+	domain->irq_base = irq_alloc_descs(-1, 0, domain->nr_irq, numa_node_id());
+	domain->of_node = of_node_get(node);
+	domain->ops = &irq_domain_simple_ops;
+	irq_domain_add(domain);
+
+	gic_init(gic_cnt, domain->irq_base, dist_base, cpu_base);
+
+	if (parent) {
+		irq = irq_of_parse_and_map(node, 0);
+		gic_cascade_irq(gic_cnt, irq);
+	}
+	gic_cnt++;
+}
+#endif
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 435d3f8..ea1ca08 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -33,10 +33,19 @@
 #define GIC_DIST_SOFTINT		0xf00
 
 #ifndef __ASSEMBLY__
+#include <linux/irqdomain.h>
+
 extern void __iomem *gic_cpu_base_addr;
 extern struct irq_chip gic_arch_extn;
 
 void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
+#ifdef CONFIG_OF
+void gic_of_init(struct device_node *node, struct device_node *parent);
+#else
+static inline void gic_of_init(struct device_node *node,
+			       struct device_node *parent)
+{}
+#endif
 void gic_secondary_init(unsigned int);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
@@ -46,6 +55,7 @@ struct gic_chip_data {
 	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+	struct irq_domain domain;
 };
 #endif
 
-- 
1.7.5.4

