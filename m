Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1I2Dy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 23:54:28 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:40379 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1I2DyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 23:54:18 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/2] ARM: gic: add OF based initialization
Date: Wed, 28 Sep 2011 22:53:56 -0500
Message-Id: <1317268436-1613-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
References: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds ARM gic interrupt controller initialization using device tree
data.

The initialization function is intended to be called by of_irq_init
function like this:

const static struct of_device_id irq_match[] = {
	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
	{}
};

static void __init init_irqs(void)
{
	of_irq_init(irq_match);
}

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 Documentation/devicetree/bindings/arm/gic.txt |   55 +++++++++++++++++++++
 arch/arm/common/gic.c                         |   64 +++++++++++++++++++++++++
 arch/arm/include/asm/hardware/gic.h           |    1 +
 3 files changed, 120 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/gic.txt

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
new file mode 100644
index 0000000..52916b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -0,0 +1,55 @@
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
+  The 1st cell is the interrupt type; 0 for SPI interrupts, 1 for PPI
+  interrupts.
+
+  The 2nd cell contains the interrupt number for the interrupt type.
+  SPI interrupts are in the range [0-987].  PPI interrupts are in the
+  range [0-15].
+
+  The 3rd cell is the flags, encoded as follows:
+	bits[3:0] trigger type and level flags.
+		1 = low-to-high edge triggered
+		2 = high-to-low edge triggered
+		4 = active high level-sensitive
+		8 = active low level-sensitive
+	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
+	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
+	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
+
+- reg : Specifies base physical address(s) and size of the GIC registers. The
+  first region is the GIC distributor register base and size. The 2nd region is
+  the GIC cpu interface register base and size.
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
index fa59c99..505ced7 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -29,6 +29,9 @@
 #include <linux/cpu_pm.h>
 #include <linux/cpumask.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include <linux/irqdomain.h>
 
 #include <asm/irq.h>
@@ -519,7 +522,36 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 }
 #endif
 
+#ifdef CONFIG_OF
+static int gic_irq_domain_dt_translate(struct irq_domain *d,
+				       struct device_node *controller,
+				       const u32 *intspec, unsigned int intsize,
+				       unsigned long *out_hwirq, unsigned int *out_type)
+{
+	struct gic_chip_data *gic_data = d->priv;
+
+	if (d->of_node != controller)
+		return -EINVAL;
+	if (intsize < 3)
+		return -EINVAL;
+
+	*out_hwirq = intspec[1];
+	/*
+	 * We've already skipped over SGIs, so PPIs need no translation.
+	 * For SPIs, we need to skip over 16 PPIs on primary GICs.
+	 */
+	if (!intspec[0] && (gic_data->irq_offset == 16))
+		*out_hwirq += 16;
+
+	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
+	return 0;
+}
+#endif
+
 const struct irq_domain_ops gic_irq_domain_ops = {
+#ifdef CONFIG_OF
+	.dt_translate = gic_irq_domain_dt_translate,
+#endif
 };
 
 void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
@@ -607,3 +639,35 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	writel_relaxed(map << 16 | irq, gic_data[0].dist_base + GIC_DIST_SOFTINT);
 }
 #endif
+
+#ifdef CONFIG_OF
+static int gic_cnt __initdata = 0;
+
+int __init gic_of_init(struct device_node *node, struct device_node *parent)
+{
+	void __iomem *cpu_base;
+	void __iomem *dist_base;
+	int irq;
+	struct irq_domain *domain = &gic_data[gic_cnt].domain;
+
+	if (WARN_ON(!node))
+		return -ENODEV;
+
+	dist_base = of_iomap(node, 0);
+	WARN(!dist_base, "unable to map gic dist registers\n");
+
+	cpu_base = of_iomap(node, 1);
+	WARN(!cpu_base, "unable to map gic cpu registers\n");
+
+	domain->of_node = of_node_get(node);
+
+	gic_init(gic_cnt, 16, dist_base, cpu_base);
+
+	if (parent) {
+		irq = irq_of_parse_and_map(node, 0);
+		gic_cascade_irq(gic_cnt, irq);
+	}
+	gic_cnt++;
+	return 0;
+}
+#endif
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 4893b10..a343c96 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -39,6 +39,7 @@ extern void __iomem *gic_cpu_base_addr;
 extern struct irq_chip gic_arch_extn;
 
 void gic_init(unsigned int, unsigned int, void __iomem *, void __iomem *);
+int gic_of_init(struct device_node *node, struct device_node *parent);
 void gic_secondary_init(unsigned int);
 void gic_cascade_irq(unsigned int gic_nr, unsigned int irq);
 void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
-- 
1.7.5.4

