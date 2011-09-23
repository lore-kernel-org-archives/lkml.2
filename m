Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1IWCVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 22:21:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56375 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab1IWCVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 22:21:23 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3] of/irq: introduce of_irq_init
Date: Thu, 22 Sep 2011 21:21:13 -0500
Message-Id: <1316744473-13158-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1316550244-3655-3-git-send-email-robherring2@gmail.com>
References: <1316550244-3655-3-git-send-email-robherring2@gmail.com>
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
Changes from v2:
- add missing kfree's found by Jamie
- Implement Grant's comments to simplify the init loop
- fix function comments

 drivers/of/irq.c       |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_irq.h |    3 +
 2 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 6a5b5e7..aedd39b 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -19,10 +19,12 @@
  */
 
 #include <linux/errno.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /* For archs that don't support NO_IRQ (such as x86), provide a dummy value */
 #ifndef NO_IRQ
@@ -386,3 +388,107 @@ int of_irq_to_resource_table(struct device_node *dev, struct resource *res,
 
 	return i;
 }
+
+struct intc_desc {
+	struct list_head	list;
+	struct device_node	*dev;
+	struct device_node	*interrupt_parent;
+};
+
+/**
+ * of_irq_init - Scan and init matching interrupt controllers in DT
+ * @matches: 0 terminated array of nodes to match and init function to call
+ *
+ * This function scans the device tree for matching interrupt controller nodes,
+ * and calls their initialization functions in order with parents first.
+ */
+void __init of_irq_init(const struct of_device_id *matches)
+{
+	struct device_node *np, *parent = NULL;
+	struct intc_desc *desc, *temp_desc;
+	struct list_head intc_desc_list, intc_parent_list;
+
+	INIT_LIST_HEAD(&intc_desc_list);
+	INIT_LIST_HEAD(&intc_parent_list);
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
+		desc->interrupt_parent = of_irq_find_parent(np);
+		list_add_tail(&desc->list, &intc_desc_list);
+	}
+	if (list_empty(&intc_desc_list))
+		return;
+
+	/*
+	 * The root irq controller is the one without an interrupt-parent.
+	 * That one goes first, followed by the controllers that reference it,
+	 * followed by the ones that reference the 2nd level controllers, etc
+	 */
+	while (!list_empty(&intc_desc_list)) {
+		/*
+		 * Process all controllers with the current 'parent'.
+		 * First pass will be looking for NULL as the parent.
+		 * The assumption is that NULL parent means a root controller.
+		 */
+		list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
+			const struct of_device_id *match;
+			int ret;
+			of_irq_init_cb_t irq_init_cb;
+
+			if (desc->interrupt_parent != parent)
+				continue;
+
+			list_del(&desc->list);
+			match = of_match_node(matches, desc->dev);
+			if (!match || !match->data) {
+				kfree(desc);
+				continue;
+			}
+
+			pr_debug("of_irq_init: init %s @ %p, parent %p\n",
+				 match->compatible,
+				 desc->dev, desc->interrupt_parent);
+			irq_init_cb = match->data;
+			ret = irq_init_cb(desc->dev, desc->interrupt_parent);
+			if (ret) {
+				kfree(desc);
+				continue;
+			}
+
+			/*
+			 * This one is now set up; add it to the parent list so
+			 * its children can get processed in a subsequent pass.
+			 */
+			list_add_tail(&desc->list, &intc_parent_list);
+		}
+
+		/* Get the next pending parent that might have children */
+		desc = list_first_entry(&intc_parent_list, typeof(*desc), list);
+		if (list_empty(&intc_parent_list) || !desc) {
+			pr_debug("of_irq_init: children remain, but no parents\n");
+			break;
+		}
+		list_del(&desc->list);
+		parent = desc->dev;
+		kfree(desc);
+	}
+
+	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
+		list_del(&desc->list);
+		kfree(desc);
+	}
+err:
+	list_for_each_entry_safe(desc, temp_desc, &intc_desc_list, list) {
+		list_del(&desc->list);
+		kfree(desc);
+	}
+}
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index cd2e61c..d0307ee 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -33,6 +33,8 @@ struct of_irq {
 	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
 };
 
+typedef int (*of_irq_init_cb_t)(struct device_node *, struct device_node *);
+
 /*
  * Workarounds only applied to 32bit powermac machines
  */
@@ -73,6 +75,7 @@ extern int of_irq_to_resource_table(struct device_node *dev,
 		struct resource *res, int nr_irqs);
 extern struct device_node *of_irq_find_parent(struct device_node *child);
 
+extern void of_irq_init(const struct of_device_id *matches);
 
 #endif /* CONFIG_OF_IRQ */
 #endif /* CONFIG_OF */
-- 
1.7.5.4

