Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2FEUAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:00:40 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:63031 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab2FEUAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:00:38 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, marco.stornelli@gmail.com,
        grant.likely@secretlab.ca, anton.vorontsov@linaro.org,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] pstore/ram: Add ramoops support for the Flattened Device Tree.
Date: Tue,  5 Jun 2012 12:59:55 -0700
Message-Id: <1338926395-26298-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When called with a non-zero of_node, fill out a new ramoops_platform_data
with data from the specified Flattened Device Tree node.
Update ramoops documentation with the new FDT interface.

Change-Id: Id8f9f0abc5b564375c1b6d5d30c92d57d76520b7
Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 Documentation/ramoops.txt |   19 +++++++++++++++++--
 fs/pstore/ram.c           |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 4ba7db2..9ed3ab7 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -3,7 +3,7 @@ Ramoops oops/panic logger
 
 Sergiu Iordache <sergiu@chromium.org>
 
-Updated: 17 November 2011
+Updated: 5 June 2012
 
 0. Introduction
 
@@ -37,7 +37,7 @@ corrupt, but usually it is restorable.
 
 2. Setting the parameters
 
-Setting the ramoops parameters can be done in 2 different manners:
+Setting the ramoops parameters can be done in 3 different manners:
  1. Use the module parameters (which have the names of the variables described
  as before).
  2. Use a platform device and set the platform data. The parameters can then
@@ -70,6 +70,21 @@ if (ret) {
 	return ret;
 }
 
+ 3. Use the Flattened Device Tree to set the platform data.  For example:
+  arch/arm/boot/dts/$BOARD.dts:
+        ramoops {
+                compatible = "ramoops";
+                reg = <0x41f00000 0x00100000>;
+                record-size = <0x00020000>;
+                dump-oops = <1>;
+                ecc = <0>;
+        };
+ The "reg = <0x41f00000 0x00100000>" line specifies a mem_size of 1MB at
+  mem_address 0x41f00000.
+ The "record-size = <0x00020000>" line specifies a record size of 128KB.
+ The "dump-oops = <1>" line tells us to dump oopses as well as panics.
+ The "ecc = <0>" line tells us to turn off ECC protection.
+
 3. Dump format
 
 The data dump begins with a header, currently defined as "====" followed by a
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 9123cce..bf0f882 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -32,6 +32,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/pstore_ram.h>
+#include <linux/of_address.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
@@ -199,10 +200,44 @@ static struct ramoops_context oops_cxt = {
 	},
 };
 
+static int __init of_ramoops_platform_data(struct device_node *node,
+					struct ramoops_platform_data *pdata)
+{
+	const __be32 *addrp;
+	const __be32 *prop;
+	u64 size;
+
+	addrp = of_get_address(node, 0, &size, NULL);
+	if (addrp == NULL)
+		return -EINVAL;
+	pdata->mem_address = of_translate_address(node, addrp);
+	pdata->mem_size = size;
+
+	prop = of_get_property(node, "record-size", NULL);
+	if (!prop)
+		return -EINVAL;
+	pdata->record_size = be32_to_cpup(prop);
+
+	prop = of_get_property(node, "dump-oops", NULL);
+	if (!prop)
+		pdata->dump_oops = 0;
+	else
+		pdata->dump_oops = be32_to_cpup(prop);
+
+	prop = of_get_property(node, "ecc", NULL);
+	if (!prop)
+		pdata->ecc = 0;
+	else
+		pdata->ecc = be32_to_cpup(prop);
+
+	return 0;
+}
+
 static int __init ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ramoops_platform_data *pdata = pdev->dev.platform_data;
+	struct ramoops_platform_data of_pdata;
 	struct ramoops_context *cxt = &oops_cxt;
 	int err = -EINVAL;
 	int i;
@@ -213,6 +248,14 @@ static int __init ramoops_probe(struct platform_device *pdev)
 	if (cxt->max_count)
 		goto fail_out;
 
+	if (pdev->dev.of_node) {
+		if (of_ramoops_platform_data(pdev->dev.of_node, &of_pdata)) {
+			pr_err("Invalid ramoops device tree data\n");
+			goto fail_out;
+		}
+		pdata = &of_pdata;
+	}
+
 	if (!pdata->mem_size || !pdata->record_size) {
 		pr_err("The memory size and the record size must be "
 			"non-zero\n");
-- 
1.7.7.3

