Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab2BPJLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52450 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2BPJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:47 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v5 15/27] irq_domain: Remove 'new' irq_domain in favour of the ppc one
Date: Thu, 16 Feb 2012 02:09:16 -0700
Message-Id: <1329383368-12122-16-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the simplistic implementation of irq_domains and enables
the powerpc infrastructure for all irq_domain users.  The powerpc
infrastructure includes support for complex mappings between Linux and
hardware irq numbers, and can manage allocation of irq_descs.

This patch also converts the few users of irq_domain_add()/irq_domain_del()
to call irq_domain_add_legacy() instead.

v3: Fix bug that set up too many irqs in translation range.
v2: Fix removal of irq_alloc_descs() call in gic driver

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Tested-by: Olof Johansson <olof@lixom.net>
---
 arch/arm/common/gic.c               |   85 ++++++++-----------
 arch/arm/common/vic.c               |   16 +---
 arch/arm/include/asm/hardware/gic.h |    4 +-
 arch/arm/include/asm/hardware/vic.h |    2 +
 arch/arm/mach-exynos/common.c       |    2 +-
 arch/arm/mach-versatile/core.c      |    7 +-
 drivers/mfd/twl-core.c              |   14 +---
 include/linux/irqdomain.h           |   45 +---------
 kernel/irq/irqdomain.c              |  159 +++--------------------------------
 9 files changed, 71 insertions(+), 263 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index dc19862..7275d80 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -51,7 +51,6 @@ union gic_base {
 };
 
 struct gic_chip_data {
-	unsigned int irq_offset;
 	union gic_base dist_base;
 	union gic_base cpu_base;
 #ifdef CONFIG_CPU_PM
@@ -61,9 +60,7 @@ struct gic_chip_data {
 	u32 __percpu *saved_ppi_enable;
 	u32 __percpu *saved_ppi_conf;
 #endif
-#ifdef CONFIG_IRQ_DOMAIN
-	struct irq_domain domain;
-#endif
+	struct irq_domain *domain;
 	unsigned int gic_irqs;
 #ifdef CONFIG_GIC_NON_BANKED
 	void __iomem *(*get_base)(union gic_base *);
@@ -282,7 +279,7 @@ asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 		irqnr = irqstat & ~0x1c00;
 
 		if (likely(irqnr > 15 && irqnr < 1021)) {
-			irqnr = irq_domain_to_irq(&gic->domain, irqnr);
+			irqnr = irq_find_mapping(gic->domain, irqnr);
 			handle_IRQ(irqnr, regs);
 			continue;
 		}
@@ -314,8 +311,8 @@ static void gic_handle_cascade_irq(unsigned int irq, struct irq_desc *desc)
 	if (gic_irq == 1023)
 		goto out;
 
-	cascade_irq = irq_domain_to_irq(&chip_data->domain, gic_irq);
-	if (unlikely(gic_irq < 32 || gic_irq > 1020 || cascade_irq >= NR_IRQS))
+	cascade_irq = irq_find_mapping(chip_data->domain, gic_irq);
+	if (unlikely(gic_irq < 32 || gic_irq > 1020))
 		do_bad_IRQ(cascade_irq, desc);
 	else
 		generic_handle_irq(cascade_irq);
@@ -348,10 +345,9 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
-	unsigned int i, irq;
+	unsigned int i;
 	u32 cpumask;
 	unsigned int gic_irqs = gic->gic_irqs;
-	struct irq_domain *domain = &gic->domain;
 	void __iomem *base = gic_data_dist_base(gic);
 	u32 cpu = cpu_logical_map(smp_processor_id());
 
@@ -386,23 +382,6 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	for (i = 32; i < gic_irqs; i += 32)
 		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 
-	/*
-	 * Setup the Linux IRQ subsystem.
-	 */
-	irq_domain_for_each_irq(domain, i, irq) {
-		if (i < 32) {
-			irq_set_percpu_devid(irq);
-			irq_set_chip_and_handler(irq, &gic_chip,
-						 handle_percpu_devid_irq);
-			set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
-		} else {
-			irq_set_chip_and_handler(irq, &gic_chip,
-						 handle_fasteoi_irq);
-			set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
-		}
-		irq_set_chip_data(irq, gic);
-	}
-
 	writel_relaxed(1, base + GIC_DIST_CTRL);
 }
 
@@ -618,7 +597,23 @@ static void __init gic_pm_init(struct gic_chip_data *gic)
 }
 #endif
 
-#ifdef CONFIG_OF
+static int gic_irq_domain_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	if (hw < 32) {
+		irq_set_percpu_devid(irq);
+		irq_set_chip_and_handler(irq, &gic_chip,
+					 handle_percpu_devid_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
+	} else {
+		irq_set_chip_and_handler(irq, &gic_chip,
+					 handle_fasteoi_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+	irq_set_chip_data(irq, d->host_data);
+	return 0;
+}
+
 static int gic_irq_domain_xlate(struct irq_domain *d,
 				struct device_node *controller,
 				const u32 *intspec, unsigned int intsize,
@@ -639,26 +634,23 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	*out_type = intspec[2] & IRQ_TYPE_SENSE_MASK;
 	return 0;
 }
-#endif
 
 struct irq_domain_ops gic_irq_domain_ops = {
-#ifdef CONFIG_OF
+	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
-#endif
 };
 
 void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 			   void __iomem *dist_base, void __iomem *cpu_base,
-			   u32 percpu_offset)
+			   u32 percpu_offset, struct device_node *node)
 {
+	irq_hw_number_t hwirq_base;
 	struct gic_chip_data *gic;
-	struct irq_domain *domain;
-	int gic_irqs;
+	int gic_irqs, irq_base;
 
 	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	gic = &gic_data[gic_nr];
-	domain = &gic->domain;
 #ifdef CONFIG_GIC_NON_BANKED
 	if (percpu_offset) { /* Frankein-GIC without banked registers... */
 		unsigned int cpu;
@@ -694,10 +686,10 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 	 * For primary GICs, skip over SGIs.
 	 * For secondary GICs, skip over PPIs, too.
 	 */
-	domain->hwirq_base = 32;
+	hwirq_base = 32;
 	if (gic_nr == 0) {
 		if ((irq_start & 31) > 0) {
-			domain->hwirq_base = 16;
+			hwirq_base = 16;
 			if (irq_start != -1)
 				irq_start = (irq_start & ~31) + 16;
 		}
@@ -713,17 +705,17 @@ void __init gic_init_bases(unsigned int gic_nr, int irq_start,
 		gic_irqs = 1020;
 	gic->gic_irqs = gic_irqs;
 
-	domain->nr_irq = gic_irqs - domain->hwirq_base;
-	domain->irq_base = irq_alloc_descs(irq_start, 16, domain->nr_irq,
-					   numa_node_id());
-	if (IS_ERR_VALUE(domain->irq_base)) {
+	gic_irqs -= hwirq_base; /* calculate # of irqs to allocate */
+	irq_base = irq_alloc_descs(irq_start, 16, gic_irqs, numa_node_id());
+	if (IS_ERR_VALUE(irq_base)) {
 		WARN(1, "Cannot allocate irq_descs @ IRQ%d, assuming pre-allocated\n",
 		     irq_start);
-		domain->irq_base = irq_start;
+		irq_base = irq_start;
 	}
-	domain->host_data = gic;
-	domain->ops = &gic_irq_domain_ops;
-	irq_domain_add(domain);
+	gic->domain = irq_domain_add_legacy(node, gic_irqs, irq_base,
+				    hwirq_base, &gic_irq_domain_ops, gic);
+	if (WARN_ON(!gic->domain))
+		return;
 
 	gic_chip.flags |= gic_arch_extn.flags;
 	gic_dist_init(gic);
@@ -768,7 +760,6 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 	void __iomem *dist_base;
 	u32 percpu_offset;
 	int irq;
-	struct irq_domain *domain = &gic_data[gic_cnt].domain;
 
 	if (WARN_ON(!node))
 		return -ENODEV;
@@ -782,9 +773,7 @@ int __init gic_of_init(struct device_node *node, struct device_node *parent)
 	if (of_property_read_u32(node, "cpu-offset", &percpu_offset))
 		percpu_offset = 0;
 
-	domain->of_node = of_node_get(node);
-
-	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset);
+	gic_init_bases(gic_cnt, -1, dist_base, cpu_base, percpu_offset, node);
 
 	if (parent) {
 		irq = irq_of_parse_and_map(node, 0);
diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
index dcb004a..7a66311 100644
--- a/arch/arm/common/vic.c
+++ b/arch/arm/common/vic.c
@@ -56,7 +56,7 @@ struct vic_device {
 	u32		int_enable;
 	u32		soft_int;
 	u32		protect;
-	struct irq_domain domain;
+	struct irq_domain *domain;
 };
 
 /* we cannot allocate memory when VICs are initially registered */
@@ -192,14 +192,8 @@ static void __init vic_register(void __iomem *base, unsigned int irq,
 	v->resume_sources = resume_sources;
 	v->irq = irq;
 	vic_id++;
-
-	v->domain.irq_base = irq;
-	v->domain.nr_irq = 32;
-#ifdef CONFIG_OF_IRQ
-	v->domain.of_node = of_node_get(node);
-#endif /* CONFIG_OF */
-	v->domain.ops = &irq_domain_simple_ops;
-	irq_domain_add(&v->domain);
+	v->domain = irq_domain_add_legacy(node, 32, irq, 0,
+					  &irq_domain_simple_ops, v);
 }
 
 static void vic_ack_irq(struct irq_data *d)
@@ -348,7 +342,7 @@ static void __init vic_init_st(void __iomem *base, unsigned int irq_start,
 	vic_register(base, irq_start, 0, node);
 }
 
-static void __init __vic_init(void __iomem *base, unsigned int irq_start,
+void __init __vic_init(void __iomem *base, unsigned int irq_start,
 			      u32 vic_sources, u32 resume_sources,
 			      struct device_node *node)
 {
@@ -444,7 +438,7 @@ static int handle_one_vic(struct vic_device *vic, struct pt_regs *regs)
 	stat = readl_relaxed(vic->base + VIC_IRQ_STATUS);
 	while (stat) {
 		irq = ffs(stat) - 1;
-		handle_IRQ(irq_domain_to_irq(&vic->domain, irq), regs);
+		handle_IRQ(irq_find_mapping(vic->domain, irq), regs);
 		stat &= ~(1 << irq);
 		handled = 1;
 	}
diff --git a/arch/arm/include/asm/hardware/gic.h b/arch/arm/include/asm/hardware/gic.h
index 4bdfe00..4b1ce6c 100644
--- a/arch/arm/include/asm/hardware/gic.h
+++ b/arch/arm/include/asm/hardware/gic.h
@@ -39,7 +39,7 @@ struct device_node;
 extern struct irq_chip gic_arch_extn;
 
 void gic_init_bases(unsigned int, int, void __iomem *, void __iomem *,
-		    u32 offset);
+		    u32 offset, struct device_node *);
 int gic_of_init(struct device_node *node, struct device_node *parent);
 void gic_secondary_init(unsigned int);
 void gic_handle_irq(struct pt_regs *regs);
@@ -49,7 +49,7 @@ void gic_raise_softirq(const struct cpumask *mask, unsigned int irq);
 static inline void gic_init(unsigned int nr, int start,
 			    void __iomem *dist , void __iomem *cpu)
 {
-	gic_init_bases(nr, start, dist, cpu, 0);
+	gic_init_bases(nr, start, dist, cpu, 0, NULL);
 }
 
 #endif
diff --git a/arch/arm/include/asm/hardware/vic.h b/arch/arm/include/asm/hardware/vic.h
index f42ebd6..e14af1a 100644
--- a/arch/arm/include/asm/hardware/vic.h
+++ b/arch/arm/include/asm/hardware/vic.h
@@ -47,6 +47,8 @@
 struct device_node;
 struct pt_regs;
 
+void __vic_init(void __iomem *base, unsigned int irq_start, u32 vic_sources,
+		u32 resume_sources, struct device_node *node);
 void vic_init(void __iomem *base, unsigned int irq_start, u32 vic_sources, u32 resume_sources);
 int vic_of_init(struct device_node *node, struct device_node *parent);
 void vic_handle_irq(struct pt_regs *regs);
diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index c59e188..6de298c 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -402,7 +402,7 @@ void __init exynos4_init_irq(void)
 	gic_bank_offset = soc_is_exynos4412() ? 0x4000 : 0x8000;
 
 	if (!of_have_populated_dt())
-		gic_init_bases(0, IRQ_PPI(0), S5P_VA_GIC_DIST, S5P_VA_GIC_CPU, gic_bank_offset);
+		gic_init_bases(0, IRQ_PPI(0), S5P_VA_GIC_DIST, S5P_VA_GIC_CPU, gic_bank_offset, NULL);
 #ifdef CONFIG_OF
 	else
 		of_irq_init(exynos4_dt_irq_match);
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 02b7b93..008ce22 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -98,8 +98,11 @@ static const struct of_device_id sic_of_match[] __initconst = {
 
 void __init versatile_init_irq(void)
 {
-	vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0);
-	irq_domain_generate_simple(vic_of_match, VERSATILE_VIC_BASE, IRQ_VIC_START);
+	struct device_node *np;
+
+	np = of_find_matching_node_by_address(NULL, vic_of_match,
+					      VERSATILE_VIC_BASE);
+	__vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0, np);
 
 	writel(~0, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
 
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 4967733..66f9bff 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -263,10 +263,6 @@ struct twl_client {
 
 static struct twl_client twl_modules[TWL_NUM_SLAVES];
 
-#ifdef CONFIG_IRQ_DOMAIN
-static struct irq_domain domain;
-#endif
-
 /* mapping the module id to slave id and base address */
 struct twl_mapping {
 	unsigned char sid;	/* Slave ID */
@@ -1227,14 +1223,8 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	pdata->irq_base = status;
 	pdata->irq_end = pdata->irq_base + nr_irqs;
-
-#ifdef CONFIG_IRQ_DOMAIN
-	domain.irq_base = pdata->irq_base;
-	domain.nr_irq = nr_irqs;
-	domain.of_node = of_node_get(node);
-	domain.ops = &irq_domain_simple_ops;
-	irq_domain_add(&domain);
-#endif
+	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
+			      &irq_domain_simple_ops, NULL);
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 7fef39e..624e9ac 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -55,9 +55,6 @@ typedef unsigned long irq_hw_number_t;
  * @map: Create or update a mapping between a virtual irq number and a hw
  *       irq number. This is called only once for a given mapping.
  * @unmap: Dispose of such a mapping
- * @to_irq: (optional) given a local hardware irq number, return the linux
- *          irq number.  If to_irq is not implemented, then the irq_domain
- *          will use this translation: irq = (domain->irq_base + hwirq)
  * @xlate: Given a device tree node and interrupt specifier, decode
  *         the hardware irq number and linux irq type value.
  *
@@ -70,7 +67,6 @@ struct irq_domain_ops {
 	int (*match)(struct irq_domain *d, struct device_node *node);
 	int (*map)(struct irq_domain *d, unsigned int virq, irq_hw_number_t hw);
 	void (*unmap)(struct irq_domain *d, unsigned int virq);
-	unsigned int (*to_irq)(struct irq_domain *d, unsigned long hwirq);
 	int (*xlate)(struct irq_domain *d, struct device_node *node,
 		     const u32 *intspec, unsigned int intsize,
 		     unsigned long *out_hwirq, unsigned int *out_type);
@@ -114,16 +110,11 @@ struct irq_domain {
 	void *host_data;
 	irq_hw_number_t inval_irq;
 
-	unsigned int irq_base;
-	unsigned int nr_irq;
-	unsigned int hwirq_base;
-
 	/* Optional device node pointer */
 	struct device_node *of_node;
 };
 
 #ifdef CONFIG_IRQ_DOMAIN
-#ifdef CONFIG_PPC
 struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 					 unsigned int size,
 					 unsigned int first_irq,
@@ -153,6 +144,10 @@ static inline struct irq_domain *irq_domain_add_legacy_isa(
 	return irq_domain_add_legacy(of_node, NUM_ISA_INTERRUPTS, 0, 0, ops,
 				     host_data);
 }
+extern struct irq_domain *irq_find_host(struct device_node *node);
+extern void irq_set_default_host(struct irq_domain *host);
+extern void irq_set_virq_count(unsigned int count);
+
 
 extern unsigned int irq_create_mapping(struct irq_domain *host,
 				       irq_hw_number_t hwirq);
@@ -167,38 +162,7 @@ extern unsigned int irq_radix_revmap_lookup(struct irq_domain *host,
 extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
-#else /* CONFIG_PPC */
-
-/**
- * irq_domain_to_irq() - Translate from a hardware irq to a linux irq number
- *
- * Returns the linux irq number associated with a hardware irq.  By default,
- * the mapping is irq == domain->irq_base + hwirq, but this mapping can
- * be overridden if the irq_domain implements a .to_irq() hook.
- */
-static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
-					     unsigned long hwirq)
-{
-	if (d->ops->to_irq)
-		return d->ops->to_irq(d, hwirq);
-	if (WARN_ON(hwirq < d->hwirq_base))
-		return 0;
-	return d->irq_base + hwirq - d->hwirq_base;
-}
-
-#define irq_domain_for_each_hwirq(d, hw) \
-	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
-
-#define irq_domain_for_each_irq(d, hw, irq) \
-	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
-	     hw < d->hwirq_base + d->nr_irq; \
-	     hw++, irq = irq_domain_to_irq(d, hw))
-
-extern void irq_domain_add(struct irq_domain *domain);
-extern void irq_domain_del(struct irq_domain *domain);
-
 extern struct irq_domain_ops irq_domain_simple_ops;
-
 #if defined(CONFIG_OF_IRQ)
 extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
 extern void irq_domain_generate_simple(const struct of_device_id *match,
@@ -207,7 +171,6 @@ extern void irq_domain_generate_simple(const struct of_device_id *match,
 static inline void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start) { }
 #endif /* !CONFIG_OF_IRQ */
-#endif /* !CONFIG_PPC */
 #endif /* CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 92ec291..dad793f 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -22,7 +22,6 @@
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 
-#ifdef CONFIG_PPC
 static DEFINE_MUTEX(revmap_trees_mutex);
 static unsigned int irq_virq_count = NR_IRQS;
 static struct irq_domain *irq_default_domain;
@@ -694,124 +693,11 @@ static int __init irq_debugfs_init(void)
 __initcall(irq_debugfs_init);
 #endif /* CONFIG_VIRQ_DEBUG */
 
-#else /* CONFIG_PPC */
-
-/**
- * irq_domain_add() - Register an irq_domain
- * @domain: ptr to initialized irq_domain structure
- *
- * Registers an irq_domain structure.  The irq_domain must at a minimum be
- * initialized with an ops structure pointer, and either a ->to_irq hook or
- * a valid irq_base value.  Everything else is optional.
- */
-void irq_domain_add(struct irq_domain *domain)
-{
-	struct irq_data *d;
-	int hwirq, irq;
-
-	/*
-	 * This assumes that the irq_domain owner has already allocated
-	 * the irq_descs.  This block will be removed when support for dynamic
-	 * allocation of irq_descs is added to irq_domain.
-	 */
-	irq_domain_for_each_irq(domain, hwirq, irq) {
-		d = irq_get_irq_data(irq);
-		if (!d) {
-			WARN(1, "error: assigning domain to non existant irq_desc");
-			return;
-		}
-		if (d->domain) {
-			/* things are broken; just report, don't clean up */
-			WARN(1, "error: irq_desc already assigned to a domain");
-			return;
-		}
-		d->domain = domain;
-		d->hwirq = hwirq;
-	}
-
-	mutex_lock(&irq_domain_mutex);
-	list_add(&domain->link, &irq_domain_list);
-	mutex_unlock(&irq_domain_mutex);
-}
-
-/**
- * irq_domain_del() - Unregister an irq_domain
- * @domain: ptr to registered irq_domain.
- */
-void irq_domain_del(struct irq_domain *domain)
-{
-	struct irq_data *d;
-	int hwirq, irq;
-
-	mutex_lock(&irq_domain_mutex);
-	list_del(&domain->link);
-	mutex_unlock(&irq_domain_mutex);
-
-	/* Clear the irq_domain assignments */
-	irq_domain_for_each_irq(domain, hwirq, irq) {
-		d = irq_get_irq_data(irq);
-		d->domain = NULL;
-	}
-}
-
-#if defined(CONFIG_OF_IRQ)
-/**
- * irq_create_of_mapping() - Map a linux irq number from a DT interrupt spec
- *
- * Used by the device tree interrupt mapping code to translate a device tree
- * interrupt specifier to a valid linux irq number.  Returns either a valid
- * linux IRQ number or 0.
- *
- * When the caller no longer need the irq number returned by this function it
- * should arrange to call irq_dispose_mapping().
- */
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
-{
-	struct irq_domain *domain;
-	unsigned long hwirq;
-	unsigned int irq, type;
-	int rc = -EINVAL;
-
-	/* Find a domain which can translate the irq spec */
-	mutex_lock(&irq_domain_mutex);
-	list_for_each_entry(domain, &irq_domain_list, link) {
-		if (!domain->ops->xlate)
-			continue;
-		rc = domain->ops->xlate(domain, controller,
-					intspec, intsize, &hwirq, &type);
-		if (rc == 0)
-			break;
-	}
-	mutex_unlock(&irq_domain_mutex);
-
-	if (rc != 0)
-		return 0;
-
-	irq = irq_domain_to_irq(domain, hwirq);
-	if (type != IRQ_TYPE_NONE)
-		irq_set_irq_type(irq, type);
-	pr_debug("%s: mapped hwirq=%i to irq=%i, flags=%x\n",
-		 controller->full_name, (int)hwirq, irq, type);
-	return irq;
-}
-EXPORT_SYMBOL_GPL(irq_create_of_mapping);
-
-/**
- * irq_dispose_mapping() - Discard a mapping created by irq_create_of_mapping()
- * @irq: linux irq number to be discarded
- *
- * Calling this function indicates the caller no longer needs a reference to
- * the linux irq number returned by a prior call to irq_create_of_mapping().
- */
-void irq_dispose_mapping(unsigned int irq)
+int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
+			  irq_hw_number_t hwirq)
 {
-	/*
-	 * nothing yet; will be filled when support for dynamic allocation of
-	 * irq_descs is added to irq_domain
-	 */
+	return 0;
 }
-EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
 int irq_domain_simple_xlate(struct irq_domain *d,
 			    struct device_node *controller,
@@ -822,10 +708,6 @@ int irq_domain_simple_xlate(struct irq_domain *d,
 		return -EINVAL;
 	if (intsize < 1)
 		return -EINVAL;
-	if (d->nr_irq && ((intspec[0] < d->hwirq_base) ||
-	    (intspec[0] >= d->hwirq_base + d->nr_irq)))
-		return -EINVAL;
-
 	*out_hwirq = intspec[0];
 	*out_type = IRQ_TYPE_NONE;
 	if (intsize > 1)
@@ -833,23 +715,17 @@ int irq_domain_simple_xlate(struct irq_domain *d,
 	return 0;
 }
 
-/**
- * irq_domain_create_simple() - Set up a 'simple' translation range
- */
+struct irq_domain_ops irq_domain_simple_ops = {
+	.map = irq_domain_simple_map,
+	.xlate = irq_domain_simple_xlate,
+};
+EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
+
+#ifdef CONFIG_OF_IRQ
 void irq_domain_add_simple(struct device_node *controller, int irq_base)
 {
-	struct irq_domain *domain;
-
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain) {
-		WARN_ON(1);
-		return;
-	}
-
-	domain->irq_base = irq_base;
-	domain->of_node = of_node_get(controller);
-	domain->ops = &irq_domain_simple_ops;
-	irq_domain_add(domain);
+	irq_domain_add_legacy(controller, 32, irq_base, 0,
+			      &irq_domain_simple_ops, NULL);
 }
 EXPORT_SYMBOL_GPL(irq_domain_add_simple);
 
@@ -864,13 +740,4 @@ void irq_domain_generate_simple(const struct of_device_id *match,
 		irq_domain_add_simple(node, irq_start);
 }
 EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
-#endif /* CONFIG_OF_IRQ */
-
-struct irq_domain_ops irq_domain_simple_ops = {
-#ifdef CONFIG_OF_IRQ
-	.xlate = irq_domain_simple_xlate,
-#endif /* CONFIG_OF_IRQ */
-};
-EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
-
-#endif /* !CONFIG_PPC */
+#endif
-- 
1.7.9

