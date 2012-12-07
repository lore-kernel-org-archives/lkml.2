Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424737Ab2LGXKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 18:10:20 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:51361 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab2LGXKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 18:10:19 -0500
Date: Fri, 7 Dec 2012 16:10:17 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] gpio/gpio-generic: Add OF bindings
Message-ID: <20121207231017.GC29262@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the platform driver to bind through OF. The existing
OF machinery for setting the resource names through OF is used to
configure the device, so the change is minimally intrusive and
fully featured.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 .../devicetree/bindings/gpio/gpio-generic.txt      |   28 ++++++++++++++++++++
 drivers/gpio/gpio-generic.c                        |   18 ++++++++++++-
 2 files changed, 45 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-generic.txt

diff --git a/Documentation/devicetree/bindings/gpio/gpio-generic.txt b/Documentation/devicetree/bindings/gpio/gpio-generic.txt
new file mode 100644
index 0000000..12b4989
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-generic.txt
@@ -0,0 +1,28 @@
+* General purpose MMIO GPIO controller
+
+Required properties:
+- compatible: "linux,basic-mmio-gpio" or "linux,basic-mmio-gpio-be",
+  the choice determines which bit is considered GPIO #0
+- reg and reg-names: An array of named register ranges describing the windows,
+  in one of these combinations:
+   * 'dat' - Single input/output data register.
+   * 'dat', 'set' and 'clr' - 'dat' is the input and drive 1 writes high to 'set'
+                              and drive 0 writes high to 'clr'
+   * 'dat' and 'set' - 'dat' is the input and drive 1 write high to 'set' and
+                       drive 0 writes low to set
+  Additionally one of these may be specified:
+   * dirout - Write 1 to set as output, 0 to set as input
+   * dirin - Write 1 to set as input, 0 to set as output
+
+  The size of the registers should be 1, 4 or 8.
+- #gpio-cells: Should be two.
+- gpio-controller: Marks the device node as a GPIO controller.
+
+Example:
+	gpio0: gpio@8 {
+	        #gpio-cells = <2>;
+		compatible = "linux,basic-mmio-gpio";
+		gpio-controller;
+		reg-names = "dat", "set", "dirin";
+		reg = <0x8 4>, <0xc 4>, <0x10 4>;
+	};
diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
index 82e2e4f..f71a917 100644
--- a/drivers/gpio/gpio-generic.c
+++ b/drivers/gpio/gpio-generic.c
@@ -458,6 +458,7 @@ static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
 	int err;
 	struct bgpio_chip *bgc;
 	struct bgpio_pdata *pdata = dev_get_platdata(dev);
+	const char *name;
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dat");
 	if (!r)
@@ -485,7 +486,13 @@ static int __devinit bgpio_pdev_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	if (!strcmp(platform_get_device_id(pdev)->name, "basic-mmio-gpio-be"))
+	name = platform_get_device_id(pdev)->name;
+	if (name && !strcmp(name, "basic-mmio-gpio-be"))
+		flags |= BGPIOF_BIG_ENDIAN;
+
+	if (pdev->dev.of_node &&
+	    of_device_is_compatible(pdev->dev.of_node,
+				    "linux,basic-mmio-gpio-be"))
 		flags |= BGPIOF_BIG_ENDIAN;
 
 	bgc = devm_kzalloc(&pdev->dev, sizeof(*bgc), GFP_KERNEL);
@@ -521,9 +528,18 @@ static const struct platform_device_id bgpio_id_table[] = {
 };
 MODULE_DEVICE_TABLE(platform, bgpio_id_table);
 
+static const struct of_device_id bgpio_ofid_table[] __devinitdata = {
+	{.compatible = "linux,basic-mmio-gpio"},
+	{.compatible = "linux,basic-mmio-gpio-be"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, bgpio_ofid_table);
+
 static struct platform_driver bgpio_driver = {
 	.driver = {
 		.name = "basic-mmio-gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(bgpio_ofid_table),
 	},
 	.id_table = bgpio_id_table,
 	.probe = bgpio_pdev_probe,
-- 
1.7.5.4

