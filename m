Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab1INQcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:32:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41204 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab1INQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:31:58 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 3/5] of/irq: introduce of_irq_init
Date: Wed, 14 Sep 2011 11:31:38 -0500
Message-Id: <1316017900-19918-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

of_irq_init will scan the devicetree for matching interrupt controller
nodes. Then it calls an initialization function for each found controller
in the proper order with parent nodes initialized before child nodes.

Based on initial pseudo code from Grant Likely.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/irq.c       |   96 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_irq.h |    1 +
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 9f689f1..a0cd7e8 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -19,10 +19,13 @@
  */
 
 #include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/list_sort.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
 #ifndef NO_IRQ
@@ -386,3 +389,96 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 
 	return i;
 }
+
+struct intc_desc {
+	struct list_head	list;
+	struct device_node	*dev;
+	struct device_node	*parent;
+};
+
+typedef void (*irq_init_cb_t)(struct device_node *, struct device_node *);
+
+static int __init irq_cmp_intc_desc(void *unused, struct list_head *a,
+				    struct list_head *b)
+{
+	const struct intc_desc *da = list_entry(a, typeof(*da), list);
+	const struct intc_desc *db = list_entry(b, typeof(*db), list);
+
+	/* same parent, so order doesn't matter */
+	if (da->parent == db->parent)
+		return 0;
+
+	/* NULL parent comes first */
+	if (!da->parent && db->parent)
+		return -1;
+	if (!db->parent && da->parent)
+		return 1;
+
+	/* parent node must be before child node */
+	if (da->dev == db->parent)
+		return -1;
+	if (db->dev == da->parent)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * of_irq_init - Scan the device tree for matching interrupt controllers and
+ * call their initialization functions in order with parents first.
+ * @matches: 0 terminated array of nodes to match and initialization function
+ * to call on match
+ */
+void __init of_irq_init(const struct of_device_id *matches)
+{
+	struct device_node *np;
+	const struct of_device_id *match;
+	struct intc_desc *desc;
+	struct intc_desc *temp_desc;
+	struct list_head intc_desc_list;
+
+	INIT_LIST_HEAD(&intc_desc_list);
+
+	for_each_matching_node(np, matches) {
+		if (!of_find_property(np, "interrupt-controller", NULL))
+			continue;
+		/* Here, we allocate and populate an intc_desc with the node
+		* pointer, interrupt-parent device_node etc. */
+		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+		if (!desc) {
+			WARN_ON(1);
+			goto err;
+		}
+		desc->dev = np;
+		desc->parent = of_irq_find_parent(np);
+		list_add(&desc->list, &intc_desc_list);
+	}
+	if (list_empty(&intc_desc_list))
+		return;
+
+	/*
+	 * The root irq controller is the one without an interrupt-parent.
+	 * That one goes first, followed by the controllers that reference it,
+	 * followed by the ones that reference the 2nd level controllers, etc
+	 */
+	list_sort(NULL, &intc_desc_list, irq_cmp_intc_desc);
+
+	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
+		match = of_match_node(matches, desc->dev);
+		if (match && match->data) {
+			irq_init_cb_t irq_init_cb = match->data;
+			pr_debug("of_irq_init: init %s @ %p, parent %p\n",
+				 match->compatible, desc->dev, desc->parent);
+			irq_init_cb(desc->dev, desc->parent);
+		}
+		list_del(&desc->list);
+		kfree(desc);
+	}
+	return;
+
+err:
+	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
+		list_del(&desc->list);
+		kfree(desc);
+	}
+}
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index cd2e61c..032d76c 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -73,6 +73,7 @@ extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
 extern struct device_node *of_irq_find_parent(struct device_node *child);
 
+extern void of_irq_init(const struct of_device_id *matches);
 
 #endif /* CONFIG_OF_IRQ */
 #endif /* CONFIG_OF */
-- 
1.7.5.4

