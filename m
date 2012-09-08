Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2IHFbt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 01:31:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39180 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2IHFbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 01:31:45 -0400
Date: Fri, 7 Sep 2012 22:29:10 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Bryan Freed <bfreed@chromium.org>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, marco.stornelli@gmail.com, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
Message-ID: <20120908052907.GA4724@lizard>
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347042576-17675-1-git-send-email-bfreed@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:29:36AM -0700, Bryan Freed wrote:
> When called with a non-zero of_node, fill out a new ramoops_platform_data
> with data from the specified Flattened Device Tree node.
> Update ramoops documentation with the new FDT interface.
> Update devicetree/binding documentation with pstore/ramoops.txt.

Thanks for your work, Bryan! There were a few issues, I fixed
them myself but I need your confirmation if you're OK w/ all
the changes.

First of, the Signed-off-by tag is missing, but I see it in v5.
I also see that v5 had an Ack from Kees Cook, you did not preserve it,
but generally it's a good idea to do so (if vX -> v(X+1) changes
aren't drastic).

[...]
> +Optional properties:
> +- record-size: Specifies the size of each record in preserved memory.
> +- console-size: Specifies the size of the console log.
> +- ftrace-size: Specifies the size of the ftrace log.
> +- ecc-size: Specifies the size of each record's ECC buffer.
> +- dump-oops: Specifies to dump oops in addition to panics.

Personally, I don't see how this fits into device tree. It doesn't
describe hardware, instead it's more a configuration stuff, which
usually we try to not put into the device tree.

It would be better to have a sane defaults in ramoops, instead of
introducing more "virtual" stuff in the device tree. That is, feel
free to change defaults if they seem to be not enough for most your
setups.

The only property that I see which is truly hardware-specific is
ecc-size. E.g. if we're pretty sure that a specific hw does not
need ecc, it's OK to avoid it. And some hw setups might require
bigger ECC sizes, so it's OK to have it in the device-tree.

> static struct ramoops_platform_data * __init
> of_ramoops_platform_data(struct device *dev)

You call this function from __devinit section, so using __init
is an error.

WARNING: fs/pstore/ramoops.o(.devinit.text+0x37): Section mismatch in reference from the function ramoops_probe() to the function .init.text:of_ramoops_platform_data()
The function __devinit ramoops_probe() references

I changed this to __devnit.

[...]
> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
> +	if (pdata == NULL)

I wonder why people prefer to not write !pdata, which is more
natural when reading the code.. :-)

[...]
> +#else
> +#define of_ramoops_platform_data(dev) NULL

Using static inline would be better, i.e. type-safe.

>+               .of_match_table = of_match_ptr(ramoops_of_match),

This fails to build:

fs/pstore/ram.c: At top level:
fs/pstore/ram.c:540:22: error: ‘ramoops_of_match’ undeclared here (not in a function)

For some reason you lost ramoops_of_match hunk from the v5.

So I made these changes on top of your patch (note, there's more
text at the end of the email):

- - - -
diff --git a/Documentation/devicetree/bindings/pstore/ramoops.txt b/Documentation/devicetree/bindings/pstore/ramoops.txt
index 2fddba4..1d43305 100644
--- a/Documentation/devicetree/bindings/pstore/ramoops.txt
+++ b/Documentation/devicetree/bindings/pstore/ramoops.txt
@@ -1,30 +1,17 @@
-Ramoops oops/panic/console logger
+Ramoops oops/panic/console/trace logger
 
 Required properties:
 - compatible: Must be "ramoops".
 - reg: Specifies the base physical address and size of preserved memory.
 
 Optional properties:
-- record-size: Specifies the size of each record in preserved memory.
-- console-size: Specifies the size of the console log.
-- ftrace-size: Specifies the size of the ftrace log.
 - ecc-size: Specifies the size of each record's ECC buffer.
-- dump-oops: Specifies to dump oops in addition to panics.
 
 Example:
 
 ramoops {
 	compatible = "ramoops";
 	reg = <0x41f00000 0x00100000>;
-	record-size = <0x00020000>;
-	ftrace-size = <0x00020000>;
-	dump-oops;
 };
 The "reg = <0x41f00000 0x00100000>" line specifies a preserved memory
 size of 1MB at physical address 0x41f00000.
-The "record-size = <0x00020000>" line specifies a record size of 128KB.
-The "ftrace-size = <0x00020000>" line specifies an ftrace log size of 128KB.
-The optional "dump-oops" line tells ramoops to dump oopses as well as panics.
-At least one of record, console, or ftrace size must be specified.
-In this example, 128KB is allocated to the ftrace log, and 896KB
-(1024KB - 128KB) is allocated to oops and panic records.
diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 82d825d..a9d0c6a 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -3,7 +3,7 @@ Ramoops oops/panic logger
 
 Sergiu Iordache <sergiu@chromium.org>
 
-Updated: 5 June 2012
+Updated: 7 September 2012
 
 0. Introduction
 
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index b272473..c6e4485 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/version.h>
 #include <linux/pstore.h>
 #include <linux/time.h>
@@ -34,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/compiler.h>
 #include <linux/pstore_ram.h>
+#include <linux/of.h>
 #include <linux/of_address.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
@@ -354,7 +356,8 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 }
 
 #ifdef CONFIG_OF
-static struct ramoops_platform_data * __init
+
+static struct ramoops_platform_data * __devinit
 of_ramoops_platform_data(struct device *dev)
 {
 	struct device_node *node = dev->of_node;
@@ -364,30 +367,36 @@ of_ramoops_platform_data(struct device *dev)
 	u32 val;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
-	if (pdata == NULL)
+	if (!pdata)
 		return NULL;
 
 	addrp = of_get_address(node, 0, &size, NULL);
-	if (addrp == NULL)
+	if (!addrp)
 		return NULL;
+
 	pdata->mem_address = of_translate_address(node, addrp);
 	pdata->mem_size = size;
 
-	if (!of_property_read_u32(node, "record-size", &val))
-		pdata->record_size = val;
-	if (!of_property_read_u32(node, "console-size", &val))
-		pdata->console_size = val;
-	if (!of_property_read_u32(node, "ftrace-size", &val))
-		pdata->ftrace_size = val;
+	pdata->record_size = record_size;
+	pdata->console_size = ramoops_console_size;
+	pdata->ftrace_size = ramoops_ftrace_size;
+	pdata->dump_oops = dump_oops;
+
 	if (!of_property_read_u32(node, "ecc-size", &val))
 		pdata->ecc_size = val;
-	if (of_get_property(node, "dump-oops", NULL))
-		pdata->dump_oops = 1;
 
 	return pdata;
 }
+
+static const struct of_device_id ramoops_of_match[] = {
+	{ .compatible = "ramoops", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ramoops_of_match);
+
 #else
-#define of_ramoops_platform_data(dev) NULL
+static inline struct ramoops_platform_data *
+of_ramoops_platform_data(struct device *dev) { return NULL; }
 #endif
 
 static int __devinit ramoops_probe(struct platform_device *pdev)
- - - -



So, the resulting patch is down below. But I have not pushed
it out yet, I'm waiting for your sign off. If you're OK with the
changes, please reply with
'Signed-off-by: Bryan Freed <bfreed@chromium.org>'

Thanks!

- - - -
From: Bryan Freed <bfreed@chromium.org>
Subject: pstore/ram: Add ramoops support for the Flattened Device Tree

When called with a non-zero of_node, fill out a new ramoops_platform_data
with data from the specified Flattened Device Tree node.
Update ramoops documentation with the new FDT interface.
Update devicetree/binding documentation with pstore/ramoops.txt.

Not-yet-signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 .../devicetree/bindings/pstore/ramoops.txt         | 17 +++++++
 Documentation/ramoops.txt                          |  7 ++-
 fs/pstore/ram.c                                    | 56 ++++++++++++++++++++++
 3 files changed, 78 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pstore/ramoops.txt

diff --git a/Documentation/devicetree/bindings/pstore/ramoops.txt b/Documentation/devicetree/bindings/pstore/ramoops.txt
new file mode 100644
index 0000000..1d43305
--- /dev/null
+++ b/Documentation/devicetree/bindings/pstore/ramoops.txt
@@ -0,0 +1,17 @@
+Ramoops oops/panic/console/trace logger
+
+Required properties:
+- compatible: Must be "ramoops".
+- reg: Specifies the base physical address and size of preserved memory.
+
+Optional properties:
+- ecc-size: Specifies the size of each record's ECC buffer.
+
+Example:
+
+ramoops {
+	compatible = "ramoops";
+	reg = <0x41f00000 0x00100000>;
+};
+The "reg = <0x41f00000 0x00100000>" line specifies a preserved memory
+size of 1MB at physical address 0x41f00000.
diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
index 69b3cac..a9d0c6a 100644
--- a/Documentation/ramoops.txt
+++ b/Documentation/ramoops.txt
@@ -3,7 +3,7 @@ Ramoops oops/panic logger
 
 Sergiu Iordache <sergiu@chromium.org>
 
-Updated: 17 November 2011
+Updated: 7 September 2012
 
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
index 1a4f6da..c6e4485 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/version.h>
 #include <linux/pstore.h>
 #include <linux/time.h>
@@ -34,6 +35,8 @@
 #include <linux/slab.h>
 #include <linux/compiler.h>
 #include <linux/pstore_ram.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
 #define MIN_MEM_SIZE 4096UL
@@ -352,6 +355,50 @@ static int ramoops_init_prz(struct device *dev, struct ramoops_context *cxt,
 	return 0;
 }
 
+#ifdef CONFIG_OF
+
+static struct ramoops_platform_data * __devinit
+of_ramoops_platform_data(struct device *dev)
+{
+	struct device_node *node = dev->of_node;
+	struct ramoops_platform_data *pdata;
+	const __be32 *addrp;
+	u64 size;
+	u32 val;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return NULL;
+
+	addrp = of_get_address(node, 0, &size, NULL);
+	if (!addrp)
+		return NULL;
+
+	pdata->mem_address = of_translate_address(node, addrp);
+	pdata->mem_size = size;
+
+	pdata->record_size = record_size;
+	pdata->console_size = ramoops_console_size;
+	pdata->ftrace_size = ramoops_ftrace_size;
+	pdata->dump_oops = dump_oops;
+
+	if (!of_property_read_u32(node, "ecc-size", &val))
+		pdata->ecc_size = val;
+
+	return pdata;
+}
+
+static const struct of_device_id ramoops_of_match[] = {
+	{ .compatible = "ramoops", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, ramoops_of_match);
+
+#else
+static inline struct ramoops_platform_data *
+of_ramoops_platform_data(struct device *dev) { return NULL; }
+#endif
+
 static int __devinit ramoops_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -367,6 +414,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
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
@@ -492,6 +547,7 @@ static struct platform_driver ramoops_driver = {
 	.driver		= {
 		.name	= "ramoops",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(ramoops_of_match),
 	},
 };
 
-- 
1.7.11.5

