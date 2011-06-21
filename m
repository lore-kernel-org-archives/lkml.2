Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab1FUSpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:45:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39841 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab1FUSpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:45:01 -0400
Subject: [PATCH 2/5] dt: add of_platform_populate() for creating device from
 the device tree
To: Nicolas Pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Date: Tue, 21 Jun 2011 12:44:58 -0600
Message-ID: <20110621184458.18176.25421.stgit@ponder>
In-Reply-To: <20110621181127.18176.1384.stgit@ponder>
References: <20110621181127.18176.1384.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_platform_populate() is similar to of_platform_bus_probe() except
that it strictly enforces that all device nodes must have a compatible
property, and it can be used to register devices (not buses) which are
children of the root node.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c       |   54 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/of_platform.h |    3 ++
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index bb483ef..1f4a5d3 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -229,19 +229,26 @@ EXPORT_SYMBOL(of_platform_device_create);
  */
 static int of_platform_bus_create(struct device_node *bus,
 				  const struct of_device_id *matches,
-				  struct device *parent)
+				  struct device *parent, bool strict)
 {
 	struct device_node *child;
 	struct platform_device *dev;
 	int rc = 0;
 
+	/* Make sure it has a compatible property */
+	if (strict && (!of_get_property(bus, "compatible", NULL))) {
+		pr_debug("%s() - skipping %s, no compatible prop\n",
+			 __func__, bus->full_name);
+		return 0;
+	}
+
 	dev = of_platform_device_create(bus, NULL, parent);
 	if (!dev || !of_match_node(matches, bus))
 		return 0;
 
 	for_each_child_of_node(bus, child) {
 		pr_debug("   create child: %s\n", child->full_name);
-		rc = of_platform_bus_create(child, matches, &dev->dev);
+		rc = of_platform_bus_create(child, matches, &dev->dev, strict);
 		if (rc) {
 			of_node_put(child);
 			break;
@@ -275,11 +282,11 @@ int of_platform_bus_probe(struct device_node *root,
 
 	/* Do a self check of bus type, if there's a match, create children */
 	if (of_match_node(matches, root)) {
-		rc = of_platform_bus_create(root, matches, parent);
+		rc = of_platform_bus_create(root, matches, parent, false);
 	} else for_each_child_of_node(root, child) {
 		if (!of_match_node(matches, child))
 			continue;
-		rc = of_platform_bus_create(child, matches, parent);
+		rc = of_platform_bus_create(child, matches, parent, false);
 		if (rc)
 			break;
 	}
@@ -288,4 +295,43 @@ int of_platform_bus_probe(struct device_node *root,
 	return rc;
 }
 EXPORT_SYMBOL(of_platform_bus_probe);
+
+/**
+ * of_platform_populate() - Populate platform_devices from device tree data
+ * @root: parent of the first level to probe or NULL for the root of the tree
+ * @matches: match table, NULL to use the default
+ * @parent: parent to hook devices from, NULL for toplevel
+ *
+ * Similar to of_platform_bus_probe(), this function walks the device tree
+ * and creates devices from nodes.  It differs in that it follows the modern
+ * convention of requiring all device nodes to have a 'compatible' property,
+ * and it is suitable for creating devices which are children of the root
+ * node (of_platform_bus_probe will only create children of the root which
+ * are selected by the @matches argument).
+ *
+ * New board support should be using this function instead of
+ * of_platform_bus_probe().
+ *
+ * Returns 0 on success, < 0 on failure.
+ */
+int of_platform_populate(struct device_node *root,
+			const struct of_device_id *matches,
+			struct device *parent)
+{
+	struct device_node *child;
+	int rc = 0;
+
+	root = root ? of_node_get(root) : of_find_node_by_path("/");
+	if (!root)
+		return -EINVAL;
+
+	for_each_child_of_node(root, child) {
+		rc = of_platform_bus_create(child, matches, parent, true);
+		if (rc)
+			break;
+	}
+
+	of_node_put(root);
+	return rc;
+}
 #endif /* !CONFIG_SPARC */
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 8f023f8..8390233 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -57,6 +57,9 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
 extern int of_platform_bus_probe(struct device_node *root,
 				 const struct of_device_id *matches,
 				 struct device *parent);
+extern int of_platform_populate(struct device_node *root,
+				const struct of_device_id *matches,
+				struct device *parent);
 #endif /* !CONFIG_SPARC */
 
 #endif /* CONFIG_OF_DEVICE */

