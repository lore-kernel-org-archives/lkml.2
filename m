Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1I3T2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:28:19 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43828 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083Ab1I3T2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:28:17 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/3] ARM: gic: add irq_domain support
Date: Fri, 30 Sep 2011 14:27:59 -0500
Message-Id: <1317410880-24828-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
References: <1317410880-24828-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Convert the gic interrupt controller to use irq domains in preparation
for device-tree binding and MULTI_IRQ. This allows for translation between
GIC interrupt IDs and Linux irq numbers.

The meaning of irq_offset has changed. It now is just the number of skipped
GIC interrupt IDs for the controller. It will be 16 for primary GIC and 32
for secondary GICs.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/common/Kconfig             |    1 +
 arch/arm/common/gic.c               |   81 ++++++++++++++++++++---------------
 arch/arm/include/asm/hardware/gic.h |    4 +-
 3 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/arch/arm/common/Kconfig b/arch/arm/common/Kconfig
index 4b71766..74df9ca 100644
--- a/arch/arm/common/Kconfig
+++ b/arch/arm/common/Kconfig
@@ -1,4 +1,5 @@
 config ARM_GIC
+	select IRQ_DOMAIN
 	bool
 
 config ARM_VIC
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 8b5be72..6fbe1db 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -29,6 +29,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/cpumask.h>
 #include <linux/io.h>
+#include <linux/irqdomain.h>
 
 #include <asm/irq.h>
 #include <asm/mach/irq.h>
@@ -72,8 +73,7 @@ static inline void __iomem *gic_cpu_base(struct irq_data *d)
 
 static inline unsigned int gic_irq(struct irq_data *d)
 {
-	struct gic_chip_data *gic_data = irq_data_get_irq_chip_data(d);
-	return d->irq - gic_data->irq_offset;
+	return d->hwirq;
 }
 
 /*
@@ -81,7 +81,7 @@ static inline unsigned int gic_irq(struct irq_data *d)
  */
 static void gic_mask_irq(struct irq_data *d)
 {
-	u32 mask = 1 << (d->irq % 32);
+	u32 mask = 1 << (gic_irq(d) % 32);
 
 	spin_lock(&irq_controller_lock);
 	writel_relaxed(mask, gic_dist_base(d) + GIC_DIST_ENABLE_CLEAR + (gic_irq(d) / 32) * 4);
@@ -92,7 +92,7 @@ static void gic_mask_irq(struct irq_data *d)
 
 static void gic_unmask_irq(struct irq_data *d)
 {
-	u32 mask = 1 << (d->irq % 32);
+	u32 mask = 1 << (gic_irq(d) % 32);
 
 	spin_lock(&irq_controller_lock);
 	if (gic_arch_extn.irq_unmask)
@@ -173,7 +173,7 @@ static int gic_set_affinity(struct irq_data *d, const struct cpumask *mask_val,
 			    bool force)
 {
 	void __iomem *reg = gic_dist_base(d) + GIC_DIST_TARGET + (gic_irq(d) & ~3);
-	unsigned int shift = (d->irq % 4) * 8;
+	unsigned int shift = (gic_irq(d) % 4) * 8;
 	unsigned int cpu = cpumask_any_and(mask_val, cpu_online_mask);
 	u32 val, mask, bit;
 
@@ -224,7 +224,7 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	if (gic_irq == 1023)
 		goto out;
 
-	cascade_irq = gic_irq + chip_data->irq_offset;
+	cascade_irq = irq_domain_to_irq(&chip_data->domain, gic_irq);
 	if (unlikely(gic_irq < 32 || gic_irq > 1020 || cascade_irq >= NR_IRQS))
 		do_bad_IRQ(cascade_irq, desc);
 	else
@@ -256,10 +256,11 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
 
-static void __init gic_dist_init(struct gic_chip_data *gic,
-	unsigned int irq_start)
+static void __init gic_dist_init(struct gic_chip_data *gic)
 {
-	unsigned int gic_irqs, irq_limit, i;
+	unsigned int gic_irqs = gic->gic_irqs;
+	struct irq_domain *domain = &gic->domain;
+	unsigned int i, irq;
 	u32 cpumask;
 	void __iomem *base = gic->dist_base;
 	u32 cpu = 0;
@@ -275,17 +276,6 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 	writel_relaxed(0, base + GIC_DIST_CTRL);
 
 	/*
-	 * Find out how many interrupts are supported.
-	 * The GIC only supports up to 1020 interrupt sources.
-	 */
-	gic_irqs = readl_relaxed(base + GIC_DIST_CTR) & 0x1f;
-	gic_irqs = (gic_irqs + 1) * 32;
-	if (gic_irqs > 1020)
-		gic_irqs = 1020;
-
-	gic->gic_irqs = gic_irqs;
-
-	/*
 	 * Set all global interrupts to be level triggered, active low.
 	 */
 	for (i = 32; i < gic_irqs; i += 16)
@@ -311,19 +301,12 @@ static void __init gic_dist_init(struct gic_chip_data *gic,
 		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 
 	/*
-	 * Limit number of interrupts registered to the platform maximum
-	 */
-	irq_limit = gic->irq_offset + gic_irqs;
-	if (WARN_ON(irq_limit > NR_IRQS))
-		irq_limit = NR_IRQS;
-
-	/*
 	 * Setup the Linux IRQ subsystem.
 	 */
-	for (i = irq_start; i < irq_limit; i++) {
-		irq_set_chip_and_handler(i, &gic_chip, handle_fasteoi_irq);
-		irq_set_chip_data(i, gic);
-		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
+	irq_domain_for_each_irq(domain, i, irq) {
+		irq_set_chip_and_handler(irq, &gic_chip, handle_fasteoi_irq);
+		irq_set_chip_data(irq, gic);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
 	}
 
 	writel_relaxed(1, base + GIC_DIST_CTRL);
@@ -535,23 +518,53 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 }
 #endif
 
+const struct irq_domain_ops gic_irq_domain_ops = {
+};
+
 void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
 	void __iomem *dist_base, void __iomem *cpu_base)
 {
 	struct gic_chip_data *gic;
+	struct irq_domain *domain;
+	int gic_irqs;
 
 	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	gic = &gic_data[gic_nr];
+	domain = &gic->domain;
 	gic->dist_base = dist_base;
 	gic->cpu_base = cpu_base;
-	gic->irq_offset = (irq_start - 1) & ~31;
 
-	if (gic_nr == 0)
+	/*
+	 * For primary GICs, skip over SGIs.
+	 * For secondary GICs, skip over PPIs, too.
+	 */
+	if (gic_nr == 0) {
 		gic_cpu_base_addr = cpu_base;
+		domain->hwirq_base = 16;
+		irq_start = (irq_start & ~31) + 16;
+	} else
+		domain->hwirq_base = 32;
+
+	/*
+	 * Find out how many interrupts are supported.
+	 * The GIC only supports up to 1020 interrupt sources.
+	 */
+	gic_irqs = readl_relaxed(dist_base + GIC_DIST_CTR) & 0x1f;
+	gic_irqs = (gic_irqs + 1) * 32;
+	if (gic_irqs > 1020)
+		gic_irqs = 1020;
+	gic->gic_irqs = gic_irqs;
+
+	domain->nr_irq = gic_irqs - domain->hwirq_base;
+	domain->irq_base = irq_alloc_descs(-1, irq_start, domain->nr_irq,
+					   numa_node_id());
+	domain->priv = gic;
+	domain->ops = &gic_irq_domain_ops;
+	irq_domain_add(domain);
 
 	gic_chip.flags |= gic_arch_extn.flags;
-	gic_dist_init(gic, irq_start);
+	gic_dist_init(gic);
 	gic_cpu_init(gic);
 	gic_pm_init(gic);
 }
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index c562705..ade84a4 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -33,6 +33,8 @@
 #define GIC_DIST_SOFTINT		0xf00
 
 #ifndef __ASSEMBLY__
+#include <linux/irqdomain.h>
+
 extern void __iomem *gic_cpu_base_addr;
 extern struct irq_chip gic_arch_extn;
 
@@ -43,7 +45,6 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
 void gic_enable_ppi(unsigned int);
 
 struct gic_chip_data {
-	unsigned int irq_offset;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
 #ifdef CONFIG_CPU_PM
@@ -53,6 +54,7 @@ struct gic_chip_data {
 	u32 __percpu *saved_ppi_enable;
 	u32 __percpu *saved_ppi_conf;
 #endif
+	struct irq_domain domain;
 	unsigned int gic_irqs;
 };
 #endif
-- 
1.7.5.4

