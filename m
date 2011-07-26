Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1GZJhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:37:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44665 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1GZJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:36:54 -0400
Subject: [PATCH v3 2/2] dt/irq: add irq_domain_generate_simple() helper
To: devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 26 Jul 2011 03:36:47 -0600
Message-ID: <20110726093646.12508.68128.stgit@ponder>
In-Reply-To: <20110726093141.12508.48108.stgit@ponder>
References: <20110726093141.12508.48108.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain_generate_simple() is an easy way to generate an irq translation
domain for simple irq controllers.  It assumes a flat 1:1 mapping from
hardware irq number to an offset of the first linux irq number assigned
to the controller

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 include/linux/irqdomain.h |   12 +++++++++
 kernel/irq/irqdomain.c    |   59 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 8f2c10a..8e3ea36 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -16,6 +16,7 @@
 #define _LINUX_IRQDOMAIN_H
 
 #include <linux/irq.h>
+#include <linux/mod_devicetable.h>
 
 #ifdef CONFIG_IRQ_DOMAIN
 struct device_node;
@@ -76,6 +77,17 @@ static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 
 extern void irq_domain_add(struct irq_domain *domain);
 extern void irq_domain_del(struct irq_domain *domain);
+
+#ifdef CONFIG_OF_IRQ
+extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
+extern void irq_domain_generate_simple(const struct of_device_id *match,
+					u64 phys_base, unsigned int irq_start);
+#else /* CONFIG_OF_IRQ */
+static inline void irq_domain_generate_simple(const struct of_device_id *match,
+					u64 phys_base, unsigned int irq_start) { }
+#endif /* CONFIG_OF_IRQ */
+
+
 #endif /* CONFIG_IRQ_DOMAIN */
 
 #endif /* _LINUX_IRQDOMAIN_H */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 171b754..d5828da 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1,9 +1,10 @@
-
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
 
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
@@ -120,4 +121,60 @@ void irq_dispose_mapping(unsigned int irq)
 	 */
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
+
+int irq_domain_simple_dt_translate(struct irq_domain *d,
+			    struct device_node *controller,
+			    const u32 *intspec, unsigned int intsize,
+			    unsigned long *out_hwirq, unsigned int *out_type)
+{
+	if (d->of_node != controller)
+		return -EINVAL;
+	if (intsize < 1)
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = IRQ_TYPE_NONE;
+	if (intsize > 1)
+		*out_type = intspec[1] & IRQ_TYPE_SENSE_MASK;
+	return 0;
+}
+
+struct irq_domain_ops irq_domain_simple_ops = {
+	.dt_translate = irq_domain_simple_dt_translate,
+};
+EXPORT_SYMBOL_GPL(irq_domain_simple_ops);
+
+/**
+ * irq_domain_create_simple() - Set up a 'simple' translation range
+ */
+void irq_domain_add_simple(struct device_node *controller, int irq_base)
+{
+	struct irq_domain *domain;
+
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!domain) {
+		WARN_ON(1);
+		return;
+	}
+
+	domain->irq_base = irq_base;
+	domain->of_node = of_node_get(controller);
+	domain->ops = &irq_domain_simple_ops;
+	irq_domain_add(domain);
+}
+EXPORT_SYMBOL_GPL(irq_domain_add_simple);
+
+void irq_domain_generate_simple(const struct of_device_id *match,
+				u64 phys_base, unsigned int irq_start)
+{
+	struct device_node *node;
+	pr_info("looking for phys_base=%llx, irq_start=%i\n",
+		(unsigned long long) phys_base, (int) irq_start);
+	node = of_find_matching_node_by_address(NULL, match, phys_base);
+	if (node)
+		irq_domain_add_simple(node, irq_start);
+	else
+		pr_info("no node found\n");
+}
+EXPORT_SYMBOL_GPL(irq_domain_generate_simple);
 #endif /* CONFIG_OF_IRQ */

