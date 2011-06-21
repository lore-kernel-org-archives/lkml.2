Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1FUSpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:45:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39436 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab1FUSpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:11 -0400
Subject: [PATCH 4/5] dt/platform: allow device name to be overridden
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 21 Jun 2011 12:45:08 -0600
Message-ID: <20110621184508.18176.23292.stgit@ponder>
In-Reply-To: <20110621181127.18176.1384.stgit@ponder>
References: <20110621181127.18176.1384.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform code has specific requirements on the naming of devices.
This patch allows callers of of_platform_populate() to provide a
device name lookup table.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c       |   73 +++++++++++++++++++++++++++++++++++++------
 include/linux/of_platform.h |   35 +++++++++++++++++++++
 2 files changed, 98 insertions(+), 10 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 4192ddc..e75af39 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -177,17 +177,20 @@ struct platform_device *of_device_alloc(struct device_node *np,
 EXPORT_SYMBOL(of_device_alloc);
 
 /**
- * of_platform_device_create - Alloc, initialize and register an of_device
+ * of_platform_device_create_pdata - Alloc, initialize and register an of_device
  * @np: pointer to node to create device for
  * @bus_id: name to assign device
+ * @platform_data: pointer to populate platform_data pointer with
  * @parent: Linux device model parent device.
  *
  * Returns pointer to created platform device, or NULL if a device was not
  * registered.  Unavailable devices will not get registered.
  */
-struct platform_device *of_platform_device_create(struct device_node *np,
-					    const char *bus_id,
-					    struct device *parent)
+struct platform_device *of_platform_device_create_pdata(
+					struct device_node *np,
+					const char *bus_id,
+					void *platform_data,
+					struct device *parent)
 {
 	struct platform_device *dev;
 
@@ -203,6 +206,7 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 #endif
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	dev->dev.bus = &platform_bus_type;
+	dev->dev.platform_data = platform_data;
 
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
@@ -216,6 +220,22 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 
 	return dev;
 }
+
+/**
+ * of_platform_device_create - Alloc, initialize and register an of_device
+ * @np: pointer to node to create device for
+ * @bus_id: name to assign device
+ * @parent: Linux device model parent device.
+ *
+ * Returns pointer to created platform device, or NULL if a device was not
+ * registered.  Unavailable devices will not get registered.
+ */
+struct platform_device *of_platform_device_create(struct device_node *np,
+					    const char *bus_id,
+					    struct device *parent)
+{
+	return of_platform_device_create_pdata(np, bus_id, NULL, parent);
+}
 EXPORT_SYMBOL(of_platform_device_create);
 
 #ifdef CONFIG_ARM_AMBA
@@ -284,6 +304,28 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 #endif /* CONFIG_ARM_AMBA */
 
 /**
+ * of_devname_lookup() - Given a device node, lookup the preferred Linux name
+ */
+static const struct of_dev_auxdata *of_dev_lookup(const struct of_dev_auxdata *lookup,
+				 struct device_node *np)
+{
+	struct resource res;
+	if (lookup) {
+		for(; lookup->name != NULL; lookup++) {
+			if (!of_device_is_compatible(np, lookup->compatible))
+				continue;
+			if (of_address_to_resource(np, 0, &res))
+				continue;
+			if (res.start != lookup->phys_addr)
+				continue;
+			pr_debug("%s: devname=%s\n", np->full_name, lookup->name);
+			return lookup;
+		}
+	}
+	return NULL;
+}
+
+/**
  * of_platform_bus_create() - Create a device for a node and its children.
  * @bus: device node of the bus to instantiate
  * @matches: match table for bus nodes
@@ -295,10 +337,14 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
  */
 static int of_platform_bus_create(struct device_node *bus,
 				  const struct of_device_id *matches,
+				  const struct of_dev_auxdata *lookup,
 				  struct device *parent, bool strict)
 {
+	const struct of_dev_auxdata *auxdata;
 	struct device_node *child;
 	struct platform_device *dev;
+	const char *bus_id = NULL;
+	void *platform_data = NULL;
 	int rc = 0;
 
 	/* Make sure it has a compatible property */
@@ -308,18 +354,24 @@ static int of_platform_bus_create(struct device_node *bus,
 		return 0;
 	}
 
+	auxdata = of_dev_lookup(lookup, bus);
+	if (auxdata) {
+		bus_id = auxdata->name;
+		platform_data = auxdata->platform_data;
+	}
+
 	if (of_device_is_compatible(bus, "arm,primecell")) {
-		of_amba_device_create(bus, NULL, NULL, parent);
+		of_amba_device_create(bus, bus_id, platform_data, parent);
 		return 0;
 	}
 
-	dev = of_platform_device_create(bus, NULL, parent);
+	dev = of_platform_device_create_pdata(bus, bus_id, platform_data, parent);
 	if (!dev || !of_match_node(matches, bus))
 		return 0;
 
 	for_each_child_of_node(bus, child) {
 		pr_debug("   create child: %s\n", child->full_name);
-		rc = of_platform_bus_create(child, matches, &dev->dev, strict);
+		rc = of_platform_bus_create(child, matches, lookup, &dev->dev, strict);
 		if (rc) {
 			of_node_put(child);
 			break;
@@ -353,11 +405,11 @@ int of_platform_bus_probe(struct device_node *root,
 
 	/* Do a self check of bus type, if there's a match, create children */
 	if (of_match_node(matches, root)) {
-		rc = of_platform_bus_create(root, matches, parent, false);
+		rc = of_platform_bus_create(root, matches, NULL, parent, false);
 	} else for_each_child_of_node(root, child) {
 		if (!of_match_node(matches, child))
 			continue;
-		rc = of_platform_bus_create(child, matches, parent, false);
+		rc = of_platform_bus_create(child, matches, NULL, parent, false);
 		if (rc)
 			break;
 	}
@@ -387,6 +439,7 @@ EXPORT_SYMBOL(of_platform_bus_probe);
  */
 int of_platform_populate(struct device_node *root,
 			const struct of_device_id *matches,
+			const struct of_dev_auxdata *lookup,
 			struct device *parent)
 {
 	struct device_node *child;
@@ -397,7 +450,7 @@ int of_platform_populate(struct device_node *root,
 		return -EINVAL;
 
 	for_each_child_of_node(root, child) {
-		rc = of_platform_bus_create(child, matches, parent, true);
+		rc = of_platform_bus_create(child, matches, lookup, parent, true);
 		if (rc)
 			break;
 	}
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 8390233..5a6f458 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -20,6 +20,40 @@
 #include <linux/platform_device.h>
 
 /**
+ * struct of_dev_auxdata - lookup table entry for device names & platform_data
+ * @compatible: compatible value of node to match against node
+ * @phys_addr: Start address of registers to match against node
+ * @name: Name to assign for matching nodes
+ * @platform_data: platform_data to assign for matching nodes
+ *
+ * This lookup table allows the caller of of_platform_populate() to override
+ * the names of devices when creating devices from the device tree.  The table
+ * should be terminated with an empty entry.  It also allows the platform_data
+ * pointer to be set.
+ *
+ * The reason for this functionality is that some Linux infrastructure uses
+ * the device name to look up a specific device, but the Linux-specific names
+ * are not encoded into the device tree, so the kernel needs to provide specific
+ * values.
+ *
+ * Note: Using an auxdata lookup table should be considered a last resort when
+ * converting a platform to use the DT.  Normally the automatically generated
+ * device name will not matter, and drivers should obtain data from the device
+ * node instead of from an anonymouns platform_data pointer.
+ */
+struct of_dev_auxdata {
+	char *compatible;
+	resource_size_t phys_addr;
+	char *name;
+	void *platform_data;
+};
+
+/* Macro to simplify populating a lookup table */
+#define OF_DEV_AUXDATA(_compat,_phys,_name,_pdata) \
+	{ .compatible = _compat, .phys_addr = _phys, .name = _name, \
+	  .platform_data = _pdata }
+
+/**
  * of_platform_driver - Legacy of-aware driver for platform devices.
  *
  * An of_platform_driver driver is attached to a basic platform_device on
@@ -59,6 +93,7 @@ extern int of_platform_bus_probe(struct device_node *root,
 				 struct device *parent);
 extern int of_platform_populate(struct device_node *root,
 				const struct of_device_id *matches,
+				const struct of_dev_auxdata *lookup,
 				struct device *parent);
 #endif /* !CONFIG_SPARC */
 

