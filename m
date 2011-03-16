Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab1CPIeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:34:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35065 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab1CPId6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:33:58 -0400
Subject: [PATCH v2 5/5] dt: add of_platform_prepare() to match nodes with
 static platform_devices
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Mar 2011 02:33:54 -0600
Message-ID: <20110316083354.1154.52103.stgit@localhost6.localdomain6>
In-Reply-To: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
References: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements an alternate method for using device tree data
for populating machine device registration.  Traditionally, board
support has directly generated and registered devices based on nodes
in the device tree.  The board support code starts at the root of the
tree and begins allocating devices for each device node it finds.
Similarly, bus drivers (i2c, spi, etc.) use their child nodes to
register child devices.  This model can be seen in almost all the powerpc
board ports (arch/powerpc/platforms/*).

However, for many of the ARM SoCs, there already exists complete board
support for many SoCs that have their own code for registering the
basic set of platform devices with non-trivial dependencies on clock
structure and machine specific platform code.  While starting at the
base of the tree and working up is certainly possible, it requires
modifying a lot of machine support code to get it working.

This patch adds the function of_platform_prepare() to declare which
nodes will be used to create platform_devices without actually
creating them yet.  Then it uses a bus notifier to inspect
platform_device registrations.  If any match a node declared with
of_platform_prepare(), it will set the of_node pointer before the
device gets bound to a driver, making the device tree data available
at probe time.

After all the static devices are registered, the platform code can
still call either of_platform_populate or of_platform_bus_probe() on
the same nodes that were declared with of_platform_prepare().  Any
nodes that *were not* matched to a static platform_device will get
created in the normal way.

Note: Board ports using this facility are still required to provide a
fully populated device tree blob.  It is not a shortcut to providing
an accurate device tree model of the machine to the point that it
would be reasonably possible to switch to a direct registration model
for all devices without change the device tree.  ie. The SoC still
needs to be correctly identified and there should be nodes for all the
discrete devices.

v2: Complete revamp to make of_platform_populate() and
of_platform_bus_probe() respect the prepared nodes.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/mach-versatile/core.c |    1 
 drivers/of/address.c           |   14 ++
 drivers/of/platform.c          |  229 ++++++++++++++++++++++++++++++++++++++++
 include/linux/of_address.h     |    1 
 include/linux/of_platform.h    |    2 
 5 files changed, 247 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 136c32e..79f933c 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/interrupt.h>
diff --git a/drivers/of/address.c b/drivers/of/address.c
index b4559c5..b43ff66 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -556,6 +556,20 @@ static int __of_address_to_resource(struct device_node *dev,
 }
 
 /**
+ * of_address_count - Return the number of entries in the reg property
+ */
+int of_address_count(struct device_node *np)
+{
+	struct resource temp_res;
+	int num_reg = 0;
+
+	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
+		num_reg++;
+	return num_reg;
+}
+EXPORT_SYMBOL_GPL(of_address_count);
+
+/**
  * of_address_to_resource - Translate device tree address and return as resource
  *
  * Note that if your address is a PIO address, the conversion will fail if
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9b785be..899e959 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
@@ -209,6 +210,225 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 }
 EXPORT_SYMBOL(of_platform_device_create);
 
+struct of_platform_prepare_data {
+	struct list_head list;
+	struct device_node *node;
+	struct device *dev;		/* assigned device */
+
+	int num_resources;
+	struct resource resource[0];
+};
+
+static LIST_HEAD(of_platform_prepare_list);
+static struct notifier_block of_platform_nb;
+
+static struct of_platform_prepare_data *of_platform_find_prepare_data(
+						struct device_node *node)
+{
+	struct of_platform_prepare_data *prep;
+	list_for_each_entry(prep, &of_platform_prepare_list, list)
+		if (prep->node == node)
+			return prep;
+	return NULL;
+}
+
+static bool of_pdev_match_resources(struct platform_device *pdev,
+			struct of_platform_prepare_data *prep)
+{
+	struct resource *node_res = prep->resource;
+	struct resource *pdev_res;
+	int i, j;
+
+	if (prep->num_resources == 0 || pdev->num_resources == 0)
+		return false;
+
+	dev_dbg(&pdev->dev, "compare dt node %s\n", prep->node->full_name);
+
+	/* Compare both resource tables and make sure every node resource
+	 * is represented by the platform device.  Here we check that each
+	 * resource has corresponding entry with the same type and start
+	 * values, and the end value falls inside the range specified
+	 * in the device tree node. */
+	for (i = 0; i < prep->num_resources; i++, node_res++) {
+		pr_debug("        node res %2i:%.8x..%.8x[%lx]...\n", i,
+			node_res->start, node_res->end, node_res->flags);
+		pdev_res = pdev->resource;
+		for (j = 0; j < pdev->num_resources; j++, pdev_res++) {
+			pr_debug("        pdev res %2i:%.8x..%.8x[%lx]\n", j,
+				pdev_res->start, pdev_res->end, pdev_res->flags);
+			if ((pdev_res->start == node_res->start) &&
+			    (pdev_res->end >= node_res->start) &&
+			    (pdev_res->end <= node_res->end) &&
+			    (pdev_res->flags == node_res->flags)) {
+				pr_debug("    ...MATCH!  :-)\n");
+				break;
+			}
+		}
+		if (j >= pdev->num_resources)
+			return false;
+	}
+	return true;
+}
+
+static int of_platform_device_notifier_call(struct notifier_block *nb,
+					unsigned long event, void *_dev)
+{
+	struct platform_device *pdev = to_platform_device(_dev);
+	struct of_platform_prepare_data *prep;
+
+	switch (event) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		if (pdev->dev.of_node)
+			return NOTIFY_DONE;
+
+		list_for_each_entry(prep, &of_platform_prepare_list, list) {
+			if (prep->dev)
+				continue;
+
+			if (!of_pdev_match_resources(pdev, prep))
+				continue;
+
+			/* If disabled, don't let the device bind */
+			if (!of_device_is_available(prep->node)) {
+				char buf[strlen(pdev->name) + 12];
+				dev_info(&pdev->dev, "disabled by dt node %s\n",
+					prep->node->full_name);
+				sprintf(buf, "%s-disabled", pdev->name);
+				pdev->name = kstrdup(buf, GFP_KERNEL);
+				continue;
+			}
+
+			dev_info(&pdev->dev, "attaching dt node %s\n",
+				prep->node->full_name);
+			prep->dev = get_device(&pdev->dev);
+			pdev->dev.of_node = of_node_get(prep->node);
+			return NOTIFY_OK;
+		}
+		break;
+
+	case BUS_NOTIFY_DEL_DEVICE:
+		list_for_each_entry(prep, &of_platform_prepare_list, list) {
+			if (prep->dev == &pdev->dev) {
+				dev_info(&pdev->dev, "detaching dt node %s\n",
+					 prep->node->full_name);
+				of_node_put(pdev->dev.of_node);
+				put_device(prep->dev);
+				pdev->dev.of_node = NULL;
+				prep->dev = NULL;
+				return NOTIFY_OK;
+			}
+		}
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+/**
+ * of_platform_prepare - Flag nodes to be used for creating devices
+ * @root: parent of the first level to probe or NULL for the root of the tree
+ * @bus_match: match table for child bus nodes, or NULL
+ *
+ * This function sets up 'snooping' of device tree registrations and
+ * when a device registration is found that matches a node in the
+ * device tree, it populates the platform_device with a pointer to the
+ * matching node.
+ *
+ * A bus notifier is used to implement this behaviour.  When this
+ * function is called, it will parse all the child nodes of @root and
+ * create a lookup table of eligible device nodes.  A device node is
+ * considered eligible if it:
+ *    a) has a compatible property,
+ *    b) has memory mapped registers, and
+ *    c) has a mappable interrupt.
+ *
+ * It will also recursively parse child buses providing
+ *    a) the child bus node has a ranges property (children have
+ *       memory-mapped registers), and
+ *    b) it is compatible with the @matches list.
+ *
+ * The lookup table will be used as data for a platform bus notifier
+ * that will compare each new device registration with the table
+ * before a device driver is bound to it.  If there is a match, then
+ * the of_node pointer will be added to the device.  Therefore it is
+ * important to call this function *before* any platform devices get
+ * registered.
+ */
+void of_platform_prepare(struct device_node *root,
+			 const struct of_device_id *matches)
+{
+	struct device_node *child;
+	struct of_platform_prepare_data *prep;
+
+	/* register the notifier if it isn't already */
+	if (!of_platform_nb.notifier_call) {
+		of_platform_nb.notifier_call = of_platform_device_notifier_call;
+		bus_register_notifier(&platform_bus_type, &of_platform_nb);
+	}
+
+	/* If root is null, then start at the root of the tree */
+	root = root ? of_node_get(root) : of_find_node_by_path("/");
+	if (!root)
+		return;
+
+	pr_debug("of_platform_prepare()\n");
+	pr_debug(" starting at: %s\n", root->full_name);
+
+	/* Loop over children and record the details */
+	for_each_child_of_node(root, child) {
+		struct resource *res;
+		int num_irq, num_reg, i;
+
+		/* If this is a bus node, recursively inspect the children,
+		 * but *don't* prepare it.  Prepare only concerns
+		 * itself with leaf-nodes.  */
+		if (of_match_node(matches, child)) {
+			of_platform_prepare(child, matches);
+			continue;
+		}
+
+		/* Is it already in the list? */
+		if (of_platform_find_prepare_data(child))
+			continue;
+
+		/* Make sure it has a compatible property */
+		if (!of_get_property(child, "compatible", NULL))
+			continue;
+
+		/*
+		 * Count the resources.  If the device doesn't have any
+		 * register ranges, then it gets skipped because there is no
+		 * way to match such a device against static registration
+		 */
+		num_irq = of_irq_count(child);
+		num_reg = of_address_count(child);
+		if (!num_reg)
+			continue;
+
+		/* Device node looks valid; record the details */
+		prep = kzalloc(sizeof(*prep) +
+			(sizeof(prep->resource[0]) * (num_irq + num_reg)),
+			GFP_KERNEL);
+		if (!prep)
+			return; /* We're screwed if malloc doesn't work. */
+
+		INIT_LIST_HEAD(&prep->list);
+
+		res = &prep->resource[0];
+		for (i = 0; i < num_reg; i++, res++)
+			WARN_ON(of_address_to_resource(child, i, res));
+		WARN_ON(of_irq_to_resource_table(child, res, num_irq) != num_irq);
+		prep->num_resources = num_reg + num_irq;
+		prep->node = of_node_get(child);
+
+		list_add_tail(&prep->list, &of_platform_prepare_list);
+
+		pr_debug("%s() - %s prepared (%i regs, %i irqs)\n",
+			__func__, prep->node->full_name, num_reg, num_irq);
+	}
+
+}
+
 /**
  * of_platform_bus_create() - Create a device for a node and its children.
  * @bus: device node of the bus to instantiate
@@ -223,6 +443,7 @@ static int of_platform_bus_create(struct device_node *bus,
 				  const struct of_device_id *matches,
 				  struct device *parent, bool strict)
 {
+	struct of_platform_prepare_data *prep;
 	struct device_node *child;
 	struct platform_device *dev;
 	int rc = 0;
@@ -234,6 +455,14 @@ static int of_platform_bus_create(struct device_node *bus,
 		return 0;
 	}
 
+	/* Has the device already been registered manually? */
+	prep = of_platform_find_prepare_data(bus);
+	if (prep && prep->dev) {
+		pr_debug("%s() - skipping %s, already registered\n",
+			 __func__, bus->full_name);
+		return 0;
+	}
+
 	dev = of_platform_device_create(bus, NULL, parent);
 	if (!dev || !of_match_node(matches, bus))
 		return 0;
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 2feda6e..6711d5f 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -3,6 +3,7 @@
 #include <linux/ioport.h>
 #include <linux/of.h>
 
+extern int of_address_count(struct device_node *np);
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 43c723d..b8fa37b 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -52,6 +52,8 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
 						   struct device *parent);
 
+extern void of_platform_prepare(struct device_node *root,
+				const struct of_device_id *matches);
 extern int of_platform_bus_probe(struct device_node *root,
 				 const struct of_device_id *matches,
 				 struct device *parent);

