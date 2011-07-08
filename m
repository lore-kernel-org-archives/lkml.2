Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1GHI4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:56:03 -0400
Received: from service87.mimecast.com ([94.185.240.25]:50311 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754613Ab1GHIy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:29 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC PATCH v2 3/4] Core devices: add OF interrupt controller sorting method
Date: Fri,  8 Jul 2011 09:54:09 +0100
Message-Id: <1310115250-3859-4-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
References: <1310115250-3859-1-git-send-email-marc.zyngier@arm.com>
X-OriginalArrivalTime: 08 Jul 2011 08:54:16.0506 (UTC) FILETIME=[9E0861A0:01CC3D4C]
X-MC-Unique: 111070809542605701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p688u75d032467

When several interrupt controllers are initialized, it is
necessary to probe them in the order described by their
cascading interrupts (or interrupt-parent in OF parlance).

This patch introduces a method that can be passed to
core_driver_init_class() at runtime and that will
reorder the device list according to the OF properties.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/base/core_device.c  |  109 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/core_device.h |    2 +
 2 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core_device.c b/drivers/base/core_device.c
index 9262145..a8df59d 100644
--- a/drivers/base/core_device.c
+++ b/drivers/base/core_device.c
@@ -10,7 +10,9 @@
  */
 #include <linux/core_device.h>
 #include <linux/of_platform.h>
+#include <linux/of_irq.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 
 static struct list_head anchors[CORE_DEV_CLASS_MAX] __initdata = {
 	[CORE_DEV_CLASS_IRQ]   = LIST_HEAD_INIT(anchors[CORE_DEV_CLASS_IRQ]),
@@ -105,4 +107,111 @@ void __init of_core_device_populate(enum core_device_class class,
 		core_device_register(class, dev);
 	}
 }
+
+struct intc_desc {
+	struct core_device	*dev;
+	struct intc_desc	*parent;
+	int			order;
+};
+
+static struct intc_desc * __init irq_find_parent(struct core_device *dev,
+						 struct intc_desc *intcs,
+						 int nr)
+{
+	struct device_node *np;
+	int i;
+
+	if (!dev->of_node)
+		return NULL;
+
+	np = of_irq_find_parent(dev->of_node);
+	if (!np || dev->of_node == np) {
+		pr_debug("%s has no interrupt-parent\n",
+			dev->of_node->full_name);
+		return NULL;
+	}
+
+	of_node_put(np);
+	for (i = 0; i < nr; i++)
+		if (intcs[i].dev->of_node == np) {
+			pr_debug("%s interrupt-parent %s found in probe list\n",
+				 dev->of_node->full_name, np->full_name);
+			return &intcs[i];
+		}
+
+	pr_warning("%s interrupt-parent %s not in probe list\n",
+		   dev->of_node->full_name, np->full_name);
+	return NULL;
+}
+
+static int __init irq_cmp_intc_desc(const void *x1, const void *x2)
+{
+	const struct intc_desc *d1 = x1, *d2 = x2;
+	return d1->order - d2->order;
+}
+
+void __init core_device_irq_sort(struct list_head *head)
+{
+	struct intc_desc *intcs;
+	struct core_device *dev, *tmp;
+	int count = 0, i = 0, inc, max_order = 0;
+
+	if (list_empty(head))
+		return;
+
+	/* Count the number of interrupt controllers */
+	list_for_each_entry(dev, head, entry)
+		count++;
+
+	if (count == 1)
+		return;
+
+	/* Allocate a big enough array */
+	intcs = kmalloc(sizeof(*intcs) * count, GFP_KERNEL);
+	if (!intcs) {
+		pr_err("irq_core_device_sort: allocation failed");
+		return;
+	}
+
+	/* Populate the array */
+	i = 0;
+	list_for_each_entry(dev, head, entry) {
+		intcs[i].dev = dev;
+		intcs[i].parent = NULL;
+		intcs[i].order = 0;
+		i++;
+	}
+
+	/* Find out the interrupt-parents */
+	for (i = 0; i < count; i++)
+		intcs[i].parent = irq_find_parent(intcs[i].dev, intcs, count);
+
+	/* Compute the orders */
+	do {
+		inc = 0;
+		for (i = 0; i < count; i++)
+			if (intcs[i].parent &&
+			    intcs[i].order <= intcs[i].parent->order) {
+				intcs[i].order =  intcs[i].parent->order + 1;
+				if (max_order < intcs[i].order)
+					max_order = intcs[i].order;
+				inc = 1;
+			}
+	} while (inc);
+
+	if (max_order) {
+		/* Sort the array according to the order, if necessary */
+		sort(intcs, count, sizeof(*intcs), irq_cmp_intc_desc, NULL);
+
+		/* Empty the list... */
+		list_for_each_entry_safe(dev, tmp, head, entry)
+			list_del(&dev->entry);
+
+		/* ... and populate the list back, preserving the ordering */
+		for (i = 0; i < count; i++)
+			list_add_tail(&intcs[i].dev->entry, head);
+	}
+	/* Free the array */
+	kfree(intcs);
+}
 #endif
diff --git a/include/linux/core_device.h b/include/linux/core_device.h
index ca67e5e..e632868 100644
--- a/include/linux/core_device.h
+++ b/include/linux/core_device.h
@@ -48,11 +48,13 @@ void core_driver_init_class(enum core_device_class class,
 #ifdef CONFIG_OF
 void of_core_device_populate(enum core_device_class class,
 			     struct of_device_id *matches);
+void core_device_irq_sort(struct list_head *head);
 #else
 static inline void of_core_device_populate(enum core_device_class class,
 					   struct of_device_id *matches)
 {
 }
+#define core_device_irq_sort	NULL
 #endif
 
 struct core_driver_setup_block {
-- 
1.7.0.4


