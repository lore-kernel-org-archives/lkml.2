Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab2FFVum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:50:42 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57131 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2FFVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:50:40 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, marco.stornelli@gmail.com,
        grant.likely@secretlab.ca, anton.vorontsov@linaro.org,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v3] pstore/ram: Add ramoops support for the Flattened Device Tree.
Date: Wed,  6 Jun 2012 14:50:19 -0700
Message-Id: <1339019419-29120-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When called with a non-zero of_node, fill out a new ramoops_platform_data
with data from the specified Flattened Device Tree node.
Update ramoops documentation with the new FDT interface.
Update devicetree/binding documentation with pstore/ramoops.txt.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 .../devicetree/bindings/pstore/ramoops.txt         |   27 +++++++++++
 Documentation/ramoops.txt                          |   19 +++++++-
 fs/pstore/ram.c                                    |   50 ++++++++++++++++++++
 3 files changed, 94 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pstore/ramoops.txt

diff --git a/Documentation/devicetree/bindings/pstore/ramoops.txt b/Documentation/devicetree/bindings/pstore/ramoops.txt
new file mode 100644
index 0000000..39be90a
--- /dev/null
+++ b/Documentation/devicetree/bindings/pstore/ramoops.txt
@@ -0,0 +1,27 @@
+Ramoops oops/panic logger
+
+Required properties:
+- compatible: Must be "ramoops".
+- reg: Specifies the base physical address and size of preserved memory.
+- record-size: Specifies the size of each record in preserved memory.
+
+Optional properties:
+- dump-oops: Default 0 (false), a nonzero (true) value causes ramoops to
+	also preserve Oopses in addition to panics.
+- ecc: Default 0 (false), a nonzero (true) value tells ramoops to
+	turn on ECC protection.
+
+Example:
+
+ramoops {
+	compatible = "ramoops";
+	reg = <0x41f00000 0x00100000>;
+	record-size = <0x00020000>;
+	dump-oops = <1>;
+	ecc = <0>;
+};
+The "reg = <0x41f00000 0x00100000>" line specifies a preserved memory
+size of 1MB at physical address 0x41f00000.
+The "record-size = <0x00020000>" line specifies a record size of 128KB.
+The "dump-oops = <1>" line tells us to dump oopses as well as panics.
+The "ecc = <0>" line tells us to turn off ECC protection.
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
index 9123cce..1b44be3 100644
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
@@ -329,11 +372,18 @@ static int __exit ramoops_remove(struct platform_device *pdev)
 	return -EBUSY;
 }
 
+static const struct of_device_id ramoops_of_match[] = {
+	{ .compatible = "ramoops", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ramoops_of_match);
+
 static struct platform_driver ramoops_driver = {
 	.remove		= __exit_p(ramoops_remove),
 	.driver		= {
 		.name	= "ramoops",
 		.owner	= THIS_MODULE,
+		.of_match_table = ramoops_of_match,
 	},
 };
 
-- 
1.7.7.3

