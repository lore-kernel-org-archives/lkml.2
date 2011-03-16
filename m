Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab1CPIdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:33:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1CPIdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:33:36 -0400
Subject: [PATCH v2 1/5] dt: Refactor of_platform_bus_probe()
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Mar 2011 02:33:33 -0600
Message-ID: <20110316083333.1154.48161.stgit@localhost6.localdomain6>
In-Reply-To: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
References: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation uses three copies of of basically identical
code.  This patch consolidates them to make the code simpler.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c |   55 ++++++++++++++++---------------------------------
 1 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 1ce4c45..f489e36 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -210,13 +210,16 @@ struct platform_device *of_platform_device_create(struct device_node *np,
 EXPORT_SYMBOL(of_platform_device_create);
 
 /**
- * of_platform_bus_create - Create an OF device for a bus node and all its
- * children. Optionally recursively instantiate matching busses.
+ * of_platform_bus_create() - Create a device for a node and its children.
  * @bus: device node of the bus to instantiate
  * @matches: match table, NULL to use the default, OF_NO_DEEP_PROBE to
- * disallow recursive creation of child busses
+ * disallow recursive creation of child buses
+ * @parent: parent for new device, or NULL for top level.
+ *
+ * Creates a platform_device for the provided device_node, and optionally
+ * recursively create devices for all the child nodes.
  */
-static int of_platform_bus_create(const struct device_node *bus,
+static int of_platform_bus_create(struct device_node *bus,
 				  const struct of_device_id *matches,
 				  struct device *parent)
 {
@@ -224,18 +227,13 @@ static int of_platform_bus_create(const struct device_node *bus,
 	struct platform_device *dev;
 	int rc = 0;
 
+	dev = of_platform_device_create(bus, NULL, parent);
+	if (!dev || !of_match_node(matches, bus))
+		return 0;
+
 	for_each_child_of_node(bus, child) {
 		pr_debug("   create child: %s\n", child->full_name);
-		dev = of_platform_device_create(child, NULL, parent);
-		if (dev == NULL)
-			continue;
-
-		if (!of_match_node(matches, child))
-			continue;
-		if (rc == 0) {
-			pr_debug("   and sub busses\n");
-			rc = of_platform_bus_create(child, matches, &dev->dev);
-		}
+		rc = of_platform_bus_create(child, matches, &dev->dev);
 		if (rc) {
 			of_node_put(child);
 			break;
@@ -245,7 +243,7 @@ static int of_platform_bus_create(const struct device_node *bus,
 }
 
 /**
- * of_platform_bus_probe - Probe the device-tree for platform busses
+ * of_platform_bus_probe() - Probe the device-tree for platform buses
  * @root: parent of the first level to probe or NULL for the root of the tree
  * @matches: match table, NULL to use the default
  * @parent: parent to hook devices from, NULL for toplevel
@@ -258,7 +256,6 @@ int of_platform_bus_probe(struct device_node *root,
 			  struct device *parent)
 {
 	struct device_node *child;
-	struct platform_device *dev;
 	int rc = 0;
 
 	if (WARN_ON(!matches || matches == OF_NO_DEEP_PROBE))
@@ -277,31 +274,15 @@ int of_platform_bus_probe(struct device_node *root,
 	 * children
 	 */
 	if (of_match_node(matches, root)) {
-		pr_debug(" root match, create all sub devices\n");
-		dev = of_platform_device_create(root, NULL, parent);
-		if (dev == NULL)
-			goto bail;
-
-		pr_debug(" create all sub busses\n");
-		rc = of_platform_bus_create(root, matches, &dev->dev);
-		goto bail;
-	}
-	for_each_child_of_node(root, child) {
+		rc = of_platform_bus_create(root, matches, parent);
+	} else for_each_child_of_node(root, child) {
 		if (!of_match_node(matches, child))
 			continue;
-
-		pr_debug("  match: %s\n", child->full_name);
-		dev = of_platform_device_create(child, NULL, parent);
-		if (dev == NULL)
-			continue;
-
-		rc = of_platform_bus_create(child, matches, &dev->dev);
-		if (rc) {
-			of_node_put(child);
+		rc = of_platform_bus_create(child, matches, parent);
+		if (rc)
 			break;
-		}
 	}
- bail:
+
 	of_node_put(root);
 	return rc;
 }

