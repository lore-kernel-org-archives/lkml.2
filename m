Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1LOCcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:32:23 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39846 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab1LOCcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:32:18 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH v2 3/4] irq/of/ARM: Enhance irq iteration capability of irq_domain code.
Date: Wed, 14 Dec 2011 18:32:09 -0800
Message-Id: <1323916330-8865-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1323916330-8865-1-git-send-email-ddaney.cavm@gmail.com>
References: <1323916330-8865-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Not all irq_domain have linear sequences of irq numbers, so add hooks
for domain specific iteration of the irqs in the domain.

There is an optional function in irq_domain_ops (each_irq) that iterates over the
irqs in the domain calling a callback function on each one.  If it is
not present, the new helper functions irq_domain_each_irq() and
irq_domain_each_hwirq() iterate using the existing semantics.

arch/arm/common/gic.c had to be modified to use the new iteration
method as part of the change.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/arm/common/gic.c     |   32 ++++++++++-------
 include/linux/irqdomain.h |   14 +++++---
 kernel/irq/irqdomain.c    |   84 ++++++++++++++++++++++++++++++++------------
 3 files changed, 89 insertions(+), 41 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 171061f..2e091b7 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -345,6 +345,24 @@ void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
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
@@ -392,19 +410,7 @@ static void __init gic_dist_init(struct gic_chip_data *gic)
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
index 16ba5a9..68d031b 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -27,12 +27,16 @@ struct irq_domain;
  * @to_irq: (optional) given a local hardware irq number, return the linux
  *          irq number.  If to_irq is not implemented, then the irq_domain
  *          will use this translation: irq = (domain->irq_base + hwirq)
+ * @each_irq: (optional) call the cb function for each irq that is a
+ *            member of the domain.
  * @dt_translate: Given a device tree node and interrupt specifier, decode
  *                the hardware irq number and linux irq type value.
  */
 struct irq_domain_ops {
 	unsigned int (*to_irq)(struct irq_domain *d, unsigned int hwirq);
-
+	int (*each_irq)(struct irq_domain *d,
+			int (*cb)(struct irq_domain *d,
+				  unsigned int irq, unsigned int hwirq));
 #ifdef CONFIG_OF
 	int (*dt_translate)(struct irq_domain *d, struct device_node *node,
 			    const u32 *intspec, unsigned int intsize,
@@ -81,10 +85,10 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 	return d->irq_base + hwirq - d->hwirq_base;
 }
 
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
index 7bae422..c9cec12 100644
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
@@ -19,52 +38,71 @@ static DEFINE_MUTEX(irq_domain_mutex);
  */
 void irq_domain_add(struct irq_domain *domain)
 {
-	struct irq_data *d;
-	unsigned int hwirq, irq;
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
-	unsigned int hwirq, irq;
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
+/**
+ * irq_domain_each_irq() - Iterate over each irq in an irq_domain
+ * @d: Pointer to the irq_domain to iterate over.
+ * @cb: Pointer to a function to be called for each irq in the
+ *      irq_domain.
+ *
+ * The cb() function is called for each irq in the irq_domain.  If it
+ * returns non-zero, the iteration is stopped.
+ *
+ * Returns: The value returned by the last invocation of cb().
+ */
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
+	return ret;
 }
 
 #if defined(CONFIG_OF_IRQ)
-- 
1.7.2.3

