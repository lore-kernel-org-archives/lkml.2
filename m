Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1CPIeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:34:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51985 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1CPIdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:33:46 -0400
Subject: [PATCH v2 3/5] dt: eliminate OF_NO_DEEP_PROBE and test for NULL match
 table
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Mar 2011 02:33:43 -0600
Message-ID: <20110316083343.1154.55378.stgit@localhost6.localdomain6>
In-Reply-To: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
References: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users of OF_NO_DEEP_PROBE, and of_match_node() now
gracefully handles being passed a NULL pointer, so the checks at the
top of of_platform_bus_probe can be dropped.

While at it, consolidate the root node pointer check to be easier to
read and tidy up related comments.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c       |   17 +++++------------
 include/linux/of_platform.h |    3 ---
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index f489e36..63d3cb7 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -212,7 +212,7 @@ EXPORT_SYMBOL(of_platform_device_create);
 /**
  * of_platform_bus_create() - Create a device for a node and its children.
  * @bus: device node of the bus to instantiate
- * @matches: match table, NULL to use the default, OF_NO_DEEP_PROBE to
+ * @matches: match table for bus nodes
  * disallow recursive creation of child buses
  * @parent: parent for new device, or NULL for top level.
  *
@@ -245,7 +245,7 @@ static int of_platform_bus_create(struct device_node *bus,
 /**
  * of_platform_bus_probe() - Probe the device-tree for platform buses
  * @root: parent of the first level to probe or NULL for the root of the tree
- * @matches: match table, NULL to use the default
+ * @matches: match table for bus nodes
  * @parent: parent to hook devices from, NULL for toplevel
  *
  * Note that children of the provided root are not instantiated as devices
@@ -258,21 +258,14 @@ int of_platform_bus_probe(struct device_node *root,
 	struct device_node *child;
 	int rc = 0;
 
-	if (WARN_ON(!matches || matches == OF_NO_DEEP_PROBE))
-		return -EINVAL;
-	if (root == NULL)
-		root = of_find_node_by_path("/");
-	else
-		of_node_get(root);
-	if (root == NULL)
+	root = root ? of_node_get(root) : of_find_node_by_path("/");
+	if (!root)
 		return -EINVAL;
 
 	pr_debug("of_platform_bus_probe()\n");
 	pr_debug(" starting at: %s\n", root->full_name);
 
-	/* Do a self check of bus type, if there's a match, create
-	 * children
-	 */
+	/* Do a self check of bus type, if there's a match, create children */
 	if (of_match_node(matches, root)) {
 		rc = of_platform_bus_create(root, matches, parent);
 	} else for_each_child_of_node(root, child) {
diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 17c7e21..fb51ae3 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -52,9 +52,6 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
 						   const char *bus_id,
 						   struct device *parent);
 
-/* pseudo "matches" value to not do deep probe */
-#define OF_NO_DEEP_PROBE ((struct of_device_id *)-1)
-
 extern int of_platform_bus_probe(struct device_node *root,
 				 const struct of_device_id *matches,
 				 struct device *parent);

