Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab1FPEly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:41:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50780 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab1FPEls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:41:48 -0400
Subject: [RFC PATCH 03/11] dt/irq: add irq_domain_add_simple() helper
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 15 Jun 2011 22:41:45 -0600
Message-ID: <20110616044141.29371.76366.stgit@ponder>
In-Reply-To: <20110616042653.29371.2052.stgit@ponder>
References: <20110616042653.29371.2052.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_domain_add_simple() is an easy way to generate an irq translation
domain for simple irq controllers.  It assumes a flat 1:1 mapping from
hardware irq number to an offset of the first linux irq number assigned
to the controller

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 include/linux/irq.h    |   11 +++++++++
 kernel/irq/irqdomain.c |   58 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index a103c01..50830fc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -797,6 +797,17 @@ extern unsigned int irq_domain_map(struct irq_domain *domain,
 				   irq_hw_number_t hwirq);
 extern void irq_domain_unmap(struct irq_domain *domain, irq_hw_number_t hw);
 
+struct of_device_id;
+#ifdef CONFIG_OF
+extern void irq_domain_add_simple(struct device_node *controller, int irq_base);
+extern void irq_domain_generate_simple(struct of_device_id *match,
+					u64 phys_base, unsigned int irq_start);
+#else
+static inline void irq_domain_generate_simple(struct of_device_id *match,
+					u64 phys_base, unsigned int irq_start) { }
+#endif
+
+
 #endif /* !CONFIG_S390 */
 
 #endif /* _LINUX_IRQ_H */
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 8310d6e..2d03c2d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1,7 +1,9 @@
-
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/slab.h>
 
 static LIST_HEAD(irq_domain_list);
 static DEFINE_MUTEX(irq_domain_mutex);
@@ -116,6 +118,8 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	irq = irq_domain_map(domain, hwirq);
 	if (type != IRQ_TYPE_NONE)
 		irq_set_irq_type(irq, type);
+	pr_debug("%s: mapped hwirq=%i to irq=%i, flags=%x\n",
+		 controller->full_name, (int)hwirq, irq, type);
 	return irq;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
@@ -134,4 +138,56 @@ void irq_dispose_mapping(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(irq_dispose_mapping);
 
+int irq_domain_simple_dt_translate(struct irq_domain *d,
+			    struct device_node *controller,
+			    const u32 *intspec, unsigned int intsize,
+			    irq_hw_number_t *out_hwirq, unsigned int *out_type)
+{
+	if (d->of_node != controller)
+		return -EINVAL;
+	if (intsize != 1)
+		return -EINVAL;
+
+	*out_hwirq = intspec[0];
+	*out_type = IRQ_TYPE_NONE;
+	return 0;
+}
+
+struct irq_domain_ops irq_domain_simple_ops = {
+	.dt_translate = irq_domain_simple_dt_translate,
+};
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
+void irq_domain_generate_simple(struct of_device_id *match,
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
 #endif

