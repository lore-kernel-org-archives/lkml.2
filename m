Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914Ab0GWUCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:02:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42770 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631Ab0GWUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:02:20 -0400
Subject: [PATCH] of: make of_find_device_by_node generic
To: jonas@southpole.se, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        benh@kernel.crashing.org, sparclinux@vger.kernel.org,
        davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 23 Jul 2010 14:02:17 -0600
Message-ID: <20100723200217.18363.48627.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Bonn <jonas@southpole.se>

There's no need for this function to be architecture specific and all four
architectures defining it had the same definition.  The function has been
moved to drivers/of/platform.c.

Signed-off-by: Jonas Bonn <jonas@southpole.se>
[grant.likely@secretlab.ca: moved to drivers/of/platform.c, simplified code, and added kerneldoc comment]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/microblaze/kernel/of_platform.c |   16 ----------------
 arch/powerpc/kernel/of_platform.c    |   16 ----------------
 arch/sparc/kernel/of_device_common.c |   20 --------------------
 drivers/of/platform.c                |   20 ++++++++++++++++++++
 4 files changed, 20 insertions(+), 52 deletions(-)

diff --git a/arch/microblaze/kernel/of_platform.c b/arch/microblaze/kernel/of_platform.c
index c664b27..6cffadb 100644
--- a/arch/microblaze/kernel/of_platform.c
+++ b/arch/microblaze/kernel/of_platform.c
@@ -47,19 +47,3 @@ const struct of_device_id of_default_bus_ids[] = {
 	{ .type = "simple", },
 	{},
 };
-
-static int of_dev_node_match(struct device *dev, void *data)
-{
-	return to_platform_device(dev)->dev.of_node == data;
-}
-
-struct platform_device *of_find_device_by_node(struct device_node *np)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
-	if (dev)
-		return to_platform_device(dev);
-	return NULL;
-}
-EXPORT_SYMBOL(of_find_device_by_node);
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 84439d1..760a7af 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -52,22 +52,6 @@ const struct of_device_id of_default_bus_ids[] = {
 	{},
 };
 
-static int of_dev_node_match(struct device *dev, void *data)
-{
-	return to_platform_device(dev)->dev.of_node == data;
-}
-
-struct platform_device *of_find_device_by_node(struct device_node *np)
-{
-	struct device *dev;
-
-	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
-	if (dev)
-		return to_platform_device(dev);
-	return NULL;
-}
-EXPORT_SYMBOL(of_find_device_by_node);
-
 #ifdef CONFIG_PPC_OF_PLATFORM_PCI
 
 /* The probing of PCI controllers from of_platform is currently
diff --git a/arch/sparc/kernel/of_device_common.c b/arch/sparc/kernel/of_device_common.c
index e80729b..49ddff5 100644
--- a/arch/sparc/kernel/of_device_common.c
+++ b/arch/sparc/kernel/of_device_common.c
@@ -11,26 +11,6 @@
 
 #include "of_device_common.h"
 
-static int node_match(struct device *dev, void *data)
-{
-	struct platform_device *op = to_platform_device(dev);
-	struct device_node *dp = data;
-
-	return (op->dev.of_node == dp);
-}
-
-struct platform_device *of_find_device_by_node(struct device_node *dp)
-{
-	struct device *dev = bus_find_device(&platform_bus_type, NULL,
-					     dp, node_match);
-
-	if (dev)
-		return to_platform_device(dev);
-
-	return NULL;
-}
-EXPORT_SYMBOL(of_find_device_by_node);
-
 unsigned int irq_of_parse_and_map(struct device_node *node, int index)
 {
 	struct platform_device *op = of_find_device_by_node(node);
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9b2d5b1..9126064 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -22,6 +22,26 @@
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
+static int of_dev_node_match(struct device *dev, void *data)
+{
+	return dev->of_node == data;
+}
+
+/**
+ * of_find_device_by_node - Find the platform_device associated with a node
+ * @np: Pointer to device tree node
+ *
+ * Returns platform_device pointer, or NULL if not found
+ */
+struct platform_device *of_find_device_by_node(struct device_node *np)
+{
+	struct device *dev;
+
+	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
+	return dev ? to_platform_device(dev) : NULL;
+}
+EXPORT_SYMBOL(of_find_device_by_node);
+
 static int platform_driver_probe_shim(struct platform_device *pdev)
 {
 	struct platform_driver *pdrv;

