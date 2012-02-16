Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2BPJLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43876 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab2BPJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:46 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Mark Salter <msalter@redhat.com>
Subject: [PATCH v5 17/27] irq_domain: Create common xlate functions that device drivers can use
Date: Thu, 16 Feb 2012 02:09:18 -0700
Message-Id: <1329383368-12122-18-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than having each interrupt controller driver creating its own barely
unique .xlate function for irq_domain, create a library of translators which
any driver can use directly.

v5: - Remove irq_domain_xlate_pci().  It was incorrect.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Milton Miller <miltonm@bga.com>
Tested-by: Olof Johansson <olof@lixom.net>
---
 include/linux/irqdomain.h |   12 ++++++++
 kernel/irq/irqdomain.c    |   65 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index e7379a3..ea58f36 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -163,6 +163,18 @@ extern unsigned int irq_linear_revmap(struct irq_domain *host,
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
+
 #if defined(CONFIG_OF_IRQ)
 extern void irq_domain_generate_simple(const struct of_device_id *match,
 					u64 phys_base, unsigned int irq_start);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 03f571a..9a8f95e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -699,25 +699,70 @@ int irq_domain_simple_map(struct irq_domain *d, unsigned int irq,
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
 
 struct irq_domain_ops irq_domain_simple_ops = {
 	.map = irq_domain_simple_map,
-	.xlate = irq_domain_simple_xlate,
+	.xlate = irq_domain_xlate_onetwocell,
 };
 EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
 
-- 
1.7.9

