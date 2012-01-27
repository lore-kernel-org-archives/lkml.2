Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2A0Vjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:39:54 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36198 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2A0Vgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:36:45 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 15/25] irq_domain: Create common xlate functions that device drivers can use
Date: Fri, 27 Jan 2012 14:36:09 -0700
Message-Id: <1327700179-17454-16-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having each interrupt controller driver creating its own barely
unique .xlate function for irq_domain, create a library of translators which
any driver can use directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
---
 include/linux/irqdomain.h |   15 ++++++++
 kernel/irq/irqdomain.c    |   83 +++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index e7379a3..1db30df 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -163,6 +163,21 @@ extern unsigned int irq_linear_revmap(struct irq_domain *host,
 				      irq_hw_number_t hwirq);
 
 extern struct irq_domain_ops irq_domain_simple_ops;
+
+/* stock xlate functions */
+int irq_domain_xlate_onecell(struct irq_domain *d, struct device_node *ctrlr,
+			const u32 *intspec, unsigned int intsize,
+			irq_hw_number_t *out_hwirq, unsigned int *out_type);
+int irq_domain_xlate_twocell(struct irq_domain *d, struct device_node *ctrlr,
+			const u32 *intspec, unsigned int intsize,
+			irq_hw_number_t *out_hwirq, unsigned int *out_type);
+int irq_domain_xlate_onetwocell(struct irq_domain *d, struct device_node *ctrlr,
+			const u32 *intspec, unsigned int intsize,
+			irq_hw_number_t *out_hwirq, unsigned int *out_type);
+int irq_domain_xlate_pci(struct irq_domain *d, struct device_node *ctrlr,
+			const u32 *intspec, unsigned int intsize,
+			irq_hw_number_t *out_hwirq, unsigned int *out_type);
+
 #if defined(CONFIG_OF_IRQ)
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 6627dc7..b0ed3be 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -687,25 +687,88 @@ int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
 	return 0;
 }
 
-int irq_domain_simple_xlate(struct irq_domain *d,
-			    struct device_node *controller,
-			    const u32 *intspec, unsigned int intsize,
-			    unsigned long *out_hwirq, unsigned int *out_type)
+/**
+ * irq_domain_xlate_onecell() - Generic xlate for direct one cell bindings
+ *
+ * Device Tree IRQ specifier translation function which works with one cell
+ * bindings where the cell value maps directly to the hwirq number.
+ */
+int irq_domain_xlate_onecell(struct irq_domain *d, struct device_node *ctrlr,
+			     const u32 *intspec, unsigned int intsize,
+			     unsigned long *out_hwirq, unsigned int *out_type)
 {
-	if (d->of_node != controller)
-		return -EINVAL;
-	if (intsize < 1)
+	if (WARN_ON(intsize < 1))
 		return -EINVAL;
 	*out_hwirq = intspec[0];
 	*out_type = IRQ_TYPE_NONE;
-	if (intsize > 1)
-		*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(irq_domain_xlate_onecell);
+
+/**
+ * irq_domain_xlate_twocell() - Generic xlate for direct two cell bindings
+ *
+ * Device Tree IRQ specifier translation function which works with two cell
+ * bindings where the cell values map directly to the hwirq number
+ * and linux irq flags.
+ */
+int irq_domain_xlate_twocell(struct irq_domain *d, struct device_node *ctrlr,
+			const u32 *intspec, unsigned int intsize,
+			irq_hw_number_t *out_hwirq, unsigned int *out_type)
+{
+	if (WARN_ON(intsize < 2))
+		return -EINVAL;
+	*out_hwirq = intspec[0];
+	*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_domain_xlate_twocell);
+
+/**
+ * irq_domain_xlate_onetwocell() - Generic xlate for one or two cell bindings
+ *
+ * Device Tree IRQ specifier translation function which works with either one
+ * or two cell bindings where the cell values map directly to the hwirq number
+ * and linux irq flags.
+ *
+ * Note: don't use this function unless your interrupt controller explicitly
+ * supports both one and two cell bindings.  For the majority of controllers
+ * the _onecell() or _twocell() variants above should be used.
+ */
+int irq_domain_xlate_onetwocell(struct irq_domain *d,
+				struct device_node *ctrlr,
+				const u32 *intspec, unsigned int intsize,
+				unsigned long *out_hwirq, unsigned int *out_type)
+{
+	if (WARN_ON(intsize < 1))
+		return -EINVAL;
+	*out_hwirq = intspec[0];
+	*out_type = (intsize > 1) ? intspec[1] : IRQ_TYPE_NONE;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_domain_xlate_onetwocell);
+
+/**
+ * irq_domain_xlate_pci() - Generic xlate for the PCI binding
+ *
+ * Device Tree IRQ specifier translation function which works with one cell
+ * bindings where the cell value maps directly to the hwirq number.
+ */
+int irq_domain_xlate_pci(struct irq_domain *d, struct device_node *ctrlr,
+			 const u32 *intspec, unsigned int intsize,
+			 unsigned long *out_hwirq, unsigned int *out_type)
+{
+	if (WARN_ON(intsize != 1))
+		return -EINVAL;
+	*out_hwirq = intspec[0];
+	*out_type = IRQ_TYPE_LEVEL_HIGH;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_domain_xlate_pci);
 
 struct irq_domain_ops irq_domain_simple_ops = {
 	.map = irq_domain_simple_map,
-	.xlate = irq_domain_simple_xlate,
+	.xlate = irq_domain_xlate_onetwocell,
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
 
-- 
1.7.5.4

