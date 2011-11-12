Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1KLBu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:50:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54473 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1KLBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:50:26 -0500
From: ddaney.cavm@gmail.com
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        tglx@linutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 1/2] irq/of/ARM: Enhance irq iteration capability of irq_domain code.
Date: Fri, 11 Nov 2011 17:50:15 -0800
Message-Id: <1321062616-28317-2-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1321062616-28317-1-git-send-email-ddaney.cavm@gmail.com>
References: <1321062616-28317-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Not all irq_domain have linear sequences of irq numbers, so add hooks
for domain specific iteration of the irqs in the domain.

There are two new optional functions in irq_domain_ops that iterate
over the irqs in the domain calling a callback function on each one.
If these are not present, the new helper functions
irq_domain_each_irq() and irq_domain_each_hwirq() iterate using the
existing semantics.

arch/arm/common/gic.c had to be modified to use the new iteration
method as part of the change.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/arm/common/gic.c     |   32 +++++++++------
 include/linux/irqdomain.h |   29 +++++++++----
 kernel/irq/irqdomain.c    |   97 +++++++++++++++++++++++++++++++++------------
 3 files changed, 111 insertions(+), 47 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 0e6ae47..64095c9 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -264,6 +264,24 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 	irq_set_chained_handler(irq, gic_handle_cascade_irq);
 }
 
+static int __init gic_dist_init_domain_cb(struct irq_domain *domain,
+					  unsigned int irq,
+					  unsigned int hwirq)
+{
+	if (hwirq < 32) {
+		irq_set_percpu_devid(irq);
+		irq_set_chip_and_handler(irq, &gic_chip,
+					 handle_percpu_devid_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_NOAUTOEN);
+	} else {
+		irq_set_chip_and_handler(irq, &gic_chip,
+					 handle_fasteoi_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+	irq_set_chip_data(irq, gic);
+	return 0;
+}
+
 static void __init gic_dist_init(struct gic_chip_data *gic)
 {
 	unsigned int i, irq;
@@ -311,19 +329,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
 	/*
 	 * Setup the Linux IRQ subsystem.
 	 */
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
+	irq_domain_each_irq(domain, gic_dist_init_domain_cb);
 
 	writel_relaxed(1, base + GIC_DIST_CTRL);
 }
diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 99834e58..f8dceb6 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -27,16 +27,26 @@ struct irq_domain;
  * @to_irq: (optional) given a local hardware irq number, return the linux
  *          irq number.  If to_irq is not implemented, then the irq_domain
  *          will use this translation: irq = (domain->irq_base + hwirq)
+ * @each_irq: (optional) call the cb function for each irq that is a
+ *            member of the domain.
+ * @each_hwirq: (optional) call the cb function for each hwirq that is a
+ *              member of the domain.
  * @dt_translate: Given a device tree node and interrupt specifier, decode
  *                the hardware irq number and linux irq type value.
  */
 struct irq_domain_ops {
-	unsigned int (*to_irq)(struct irq_domain *d, unsigned long hwirq);
+	unsigned int (*to_irq)(struct irq_domain *d, unsigned int hwirq);
+	int (*each_irq)(struct irq_domain *d,
+			int (*cb)(struct irq_domain *d,
+				  unsigned int irq, unsigned int hwirq));
+	int (*each_hwirq)(struct irq_domain *d,
+			  int (*cb)(struct irq_domain *d,
+				    unsigned int hwirq));
 
 #ifdef CONFIG_OF
 	int (*dt_translate)(struct irq_domain *d, struct device_node *node,
 			    const u32 *intspec, unsigned int intsize,
-			    unsigned long *out_hwirq, unsigned int *out_type);
+			    unsigned int *out_hwirq, unsigned int *out_type);
 #endif /* CONFIG_OF */
 };
 
@@ -72,7 +82,7 @@ struct irq_domain {
  * be overridden if the irq_domain implements a .to_irq() hook.
  */
 static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
-					     unsigned long hwirq)
+					     unsigned int hwirq)
 {
 	if (d->ops->to_irq)
 		return d->ops->to_irq(d, hwirq);
@@ -81,13 +91,14 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 	return d->irq_base + hwirq - d->hwirq_base;
 }
 
-#define irq_domain_for_each_hwirq(d, hw) \
-	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++)
+extern int irq_domain_each_hwirq(struct irq_domain *d,
+				 int (*cb)(struct irq_domain *d,
+					   unsigned int hwirq));
 
-#define irq_domain_for_each_irq(d, hw, irq) \
-	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw); \
-	     hw < d->hwirq_base + d->nr_irq; \
-	     hw++, irq = irq_domain_to_irq(d, hw))
+extern int irq_domain_each_irq(struct irq_domain *d,
+			       int (*cb)(struct irq_domain *d,
+					 unsigned int irq,
+					 unsigned int hwirq));
 
 extern void irq_domain_add(struct irq_domain *domain);
 extern void irq_domain_del(struct irq_domain *domain);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 200ce83..528450e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -9,6 +9,25 @@
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
 
+static int irq_domain_add_per_irq(struct irq_domain *domain, unsigned int irq,
+				  unsigned int hwirq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	if (!d) {
+		WARN(1, "error: assigning domain to non existant irq_desc");
+		return 1;
+	}
+	if (d->domain) {
+		/* things are broken; just report, don't clean up */
+		WARN(1, "error: irq_desc already assigned to a domain");
+		return 1;
+	}
+	d->domain = domain;
+	d->hwirq = hwirq;
+	return 0;
+}
+
 /**
  * irq_domain_add() - Register an irq_domain
  * @domain: ptr to initialized irq_domain structure
@@ -19,52 +38,77 @@ static DEFINE_MUTEX(irq_domain_mutex);
  */
 void irq_domain_add(struct irq_domain *domain)
 {
-	struct irq_data *d;
-	int hwirq, irq;
-
 	/*
 	 * This assumes that the irq_domain owner has already allocated
 	 * the irq_descs.  This block will be removed when support for dynamic
 	 * allocation of irq_descs is added to irq_domain.
 	 */
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
+	irq_domain_each_irq(domain, irq_domain_add_per_irq);
 
 	mutex_lock(&irq_domain_mutex);
 	list_add(&domain->list, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 }
 
+static int irq_domain_del_per_irq(struct irq_domain *domain, unsigned int irq,
+				  unsigned int hwirq)
+{
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	d->domain = NULL;
+	return 0;
+}
+
 /**
  * irq_domain_del() - Unregister an irq_domain
  * @domain: ptr to registered irq_domain.
  */
 void irq_domain_del(struct irq_domain *domain)
 {
-	struct irq_data *d;
-	int hwirq, irq;
-
 	mutex_lock(&irq_domain_mutex);
 	list_del(&domain->list);
 	mutex_unlock(&irq_domain_mutex);
 
 	/* Clear the irq_domain assignments */
-	irq_domain_for_each_irq(domain, hwirq, irq) {
-		d = irq_get_irq_data(irq);
-		d->domain = NULL;
+	irq_domain_each_irq(domain, irq_domain_del_per_irq);
+}
+
+int irq_domain_each_hwirq(struct irq_domain *d,
+			  int (*cb)(struct irq_domain *d, unsigned int hwirq))
+{
+	unsigned int hw;
+	int ret = 0;
+
+	if (d->ops->each_hwirq)
+		return d->ops->each_hwirq(d, cb);
+
+	for (hw = d->hwirq_base; hw < d->hwirq_base + d->nr_irq; hw++) {
+		ret = cb(d, hw);
+		if (ret)
+			break;
+	}
+	return ret;
+}
+
+int irq_domain_each_irq(struct irq_domain *d,
+			int (*cb)(struct irq_domain *d,	unsigned int irq,
+				  unsigned int hwirq))
+{
+	unsigned int hw, irq;
+	int ret = 0;
+
+	if (d->ops->each_irq)
+		return d->ops->each_irq(d, cb);
+
+	for (hw = d->hwirq_base, irq = irq_domain_to_irq(d, hw);
+	     hw < d->hwirq_base + d->nr_irq;
+	     hw++, irq = irq_domain_to_irq(d, hw)) {
+		ret = cb(d, irq, hw);
+		if (ret)
+			break;
 	}
+
+	return 0;
 }
 
 #if defined(CONFIG_OF_IRQ)
@@ -82,13 +126,16 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 				   const u32 *intspec, unsigned int intsize)
 {
 	struct irq_domain *domain;
-	unsigned long hwirq;
+	unsigned int hwirq;
 	unsigned int irq, type;
 	int rc = -EINVAL;
 
 	/* Find a domain which can translate the irq spec */
 	mutex_lock(&irq_domain_mutex);
 	list_for_each_entry(domain, &irq_domain_list, list) {
+		if (domain->of_node != controller)
+			continue;
+
 		if (!domain->ops->dt_translate)
 			continue;
 		rc = domain->ops->dt_translate(domain, controller,
@@ -129,7 +176,7 @@ EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 int irq_domain_simple_dt_translate(struct irq_domain *d,
 			    struct device_node *controller,
 			    const u32 *intspec, unsigned int intsize,
-			    unsigned long *out_hwirq, unsigned int *out_type)
+			    unsigned int *out_hwirq, unsigned int *out_type)
 {
 	if (d->of_node != controller)
 		return -EINVAL;
-- 
1.7.2.3

