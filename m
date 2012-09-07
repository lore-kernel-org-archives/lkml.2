Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2IGS3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:29:50 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:50006 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IGS3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:29:48 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, anton.vorontsov@linaro.org,
        marco.stornelli@gmail.com, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v6] pstore/ram: Add ramoops support for the Flattened Device Tree.
Date: Fri,  7 Sep 2012 11:29:36 -0700
Message-Id: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When called with a non-zero of_node, fill out a new ramoops_platform_data
with data from the specified Flattened Device Tree node.
Update ramoops documentation with the new FDT interface.
Update devicetree/binding documentation with pstore/ramoops.txt.

---
I did not see any tree activity since I sent PATCH v5 on 6/26.
So I cleaned up the code a bit and added support for the new
console and ftrace logs as well.

bryan.

 .../devicetree/bindings/pstore/ramoops.txt         |   30 ++++++++++++
 Documentation/ramoops.txt                          |    7 ++-
 fs/pstore/ram.c                                    |   47 ++++++++++++++++++++
 3 files changed, 82 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pstore/ramoops.txt

diff --git a/Documentation/devicetree/bindings/pstore/ramoops.txt b/Documentation/devicetree/bindings/pstore/ramoops.txt
new file mode 100644
index 0000000..2fddba4
--- /dev/null
+++ b/Documentation/devicetree/bindings/pstore/ramoops.txt
@@ -0,0 +1,30 @@
+Ramoops oops/panic/console logger
+
+Required properties:
+- compatible: Must be "ramoops".
+- reg: Specifies the base physical address and size of preserved memory.
+
+Optional properties:
+- record-size: Specifies the size of each record in preserved memory.
+- console-size: Specifies the size of the console log.
+- ftrace-size: Specifies the size of the ftrace log.
+- ecc-size: Specifies the size of each record's ECC buffer.
+- dump-oops: Specifies to dump oops in addition to panics.
+
+Example:
+
+ramoops {
+	compatible = "ramoops";
+	reg = <0x41f00000 0x00100000>;
+	record-size = <0x00020000>;
+	ftrace-size = <0x00020000>;
+	dump-oops;
+};
+The "reg = <0x41f00000 0x00100000>" line specifies a preserved memory
+size of 1MB at physical address 0x41f00000.
+The "record-size = <0x00020000>" line specifies a record size of 128KB.
+The "ftrace-size = <0x00020000>" line specifies an ftrace log size of 128KB.
+The optional "dump-oops" line tells ramoops to dump oopses as well as panics.
+At least one of record, console, or ftrace size must be specified.
+In this example, 128KB is allocated to the ftrace log, and 896KB
+(1024KB - 128KB) is allocated to oops and panic records.
diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 197ad59..20ab20a 100644
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
  For quick debugging, you can also reserve parts of memory during boot
@@ -84,6 +84,9 @@ very early in the architecture code, e.g.:
 
 memblock_reserve(ramoops_data.mem_address, ramoops_data.mem_size);
 
+ 3. Use the Flattened Device Tree to set the platform data.
+ This is described in devicetree/bindings/pstore/ramoops.txt.
+
 3. Dump format
 
 The data dump begins with a header, currently defined as "====" followed by a
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 0b311bc..876cc32 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -33,6 +33,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/pstore_ram.h>
+#include <linux/of_address.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
@@ -352,6 +353,43 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static struct ramoops_platform_data * __init
+of_ramoops_platform_data(struct device *dev)
+{
+	struct device_node *node = dev->of_node;
+	struct ramoops_platform_data *pdata;
+	const __be32 *addrp;
+	u64 size;
+	u32 val;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (pdata == NULL)
+		return NULL;
+
+	addrp = of_get_address(node, 0, &size, NULL);
+	if (addrp == NULL)
+		return NULL;
+	pdata->mem_address = of_translate_address(node, addrp);
+	pdata->mem_size = size;
+
+	if (!of_property_read_u32(node, "record-size", &val))
+		pdata->record_size = val;
+	if (!of_property_read_u32(node, "console-size", &val))
+		pdata->console_size = val;
+	if (!of_property_read_u32(node, "ftrace-size", &val))
+		pdata->ftrace_size = val;
+	if (!of_property_read_u32(node, "ecc-size", &val))
+		pdata->ecc_size = val;
+	if (of_get_property(node, "dump-oops", NULL))
+		pdata->dump_oops = 1;
+
+	return pdata;
+}
+#else
+#define of_ramoops_platform_data(dev) NULL
+#endif
+
 static int __devinit ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -367,6 +405,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 	if (cxt->max_dump_cnt)
 		goto fail_out;
 
+	if (!pdata && pdev->dev.of_node) {
+		pdata = of_ramoops_platform_data(&pdev->dev);
+		if (!pdata) {
+			pr_err("Invalid ramoops device tree data\n");
+			goto fail_out;
+		}
+	}
+
 	if (!pdata->mem_size || (!pdata->record_size && !pdata->console_size &&
 			!pdata->ftrace_size)) {
 		pr_err("The memory size and the record/console size must be "
@@ -491,6 +537,7 @@ static struct platform_driver ramoops_driver = {
 	.driver		= {
 		.name	= "ramoops",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ramoops_of_match),
 	},
 };
 
-- 
1.7.7.3

