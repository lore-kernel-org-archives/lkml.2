Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab1KIBZD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:25:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50952 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1KIBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:23:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 4/8] of: Add device tree selftests
Date: Tue,  8 Nov 2011 18:19:39 -0700
Message-Id: <1320801583-12774-5-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some runtime test cases for the library of device tree parsing functions.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/testcases/tests-phandle.dtsi |   32 ++++++
 arch/arm/boot/dts/testcases/tests.dtsi         |    1 +
 arch/arm/boot/dts/versatile-pb.dts             |    2 +
 drivers/of/Kconfig                             |    9 ++
 drivers/of/Makefile                            |    1 +
 drivers/of/selftest.c                          |  128 ++++++++++++++++++++++++
 6 files changed, 173 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/testcases/tests-phandle.dtsi
 create mode 100644 arch/arm/boot/dts/testcases/tests.dtsi
 create mode 100644 drivers/of/selftest.c

diff --git a/arch/arm/boot/dts/testcases/tests-phandle.dtsi b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
new file mode 100644
index 0000000..d26fe99
--- /dev/null
+++ b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
@@ -0,0 +1,32 @@
+
+/ {
+	testcase-data {
+		phandle-tests {
+			provider1: provider1 {
+				#phandle-cells = <1>;
+			};
+
+			provider2: provider2 {
+				#phandle-cells = <2>;
+			};
+
+			provider3: provider3 {
+				#phandle-cells = <3>;
+			};
+
+			consumer-a {
+				phandle-list =	<&provider1 1>,
+						<&provider2 2 0>,
+						<0>,
+						<&provider3 4 4 3>,
+						<&provider2 5 100>,
+						<&provider1 6>;
+				phandle-list-names = "first", "second", "third";
+
+				phandle-list-bad-phandle = <12345678 0 0>;
+				phandle-list-bad-args = <&provider2 1 0>,
+							<&provider3 0>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/testcases/tests.dtsi b/arch/arm/boot/dts/testcases/tests.dtsi
new file mode 100644
index 0000000..a7c5067
--- /dev/null
+++ b/arch/arm/boot/dts/testcases/tests.dtsi
@@ -0,0 +1 @@
+/include/ "tests-phandle.dtsi"
diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
index 8a614e3..1664610 100644
--- a/arch/arm/boot/dts/versatile-pb.dts
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -46,3 +46,5 @@
 		};
 	};
 };
+
+/include/ "testcases/tests.dtsi"
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index cac63c9..268163d 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -15,6 +15,15 @@ config PROC_DEVICETREE
 	  an image of the device tree that the kernel copies from Open
 	  Firmware or other boot firmware. If unsure, say Y here.
 
+config OF_SELFTEST
+	bool "Device Tree Runtime self tests"
+	help
+	  This option builds in test cases for the device tree infrastructure
+	  that are executed one at boot time, and the results dumped to the
+	  console.
+
+	  If unsure, say N here, but this option is safe to enable.
+
 config OF_FLATTREE
 	bool
 	select DTC
diff --git a/drivers/of/Makefile b/drivers/of/Makefile
index dccb117..a73f5a5 100644
--- a/drivers/of/Makefile
+++ b/drivers/of/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_OF_GPIO)   += gpio.o
 obj-$(CONFIG_OF_I2C)	+= of_i2c.o
 obj-$(CONFIG_OF_NET)	+= of_net.o
 obj-$(CONFIG_OF_SPI)	+= of_spi.o
+obj-$(CONFIG_OF_SELFTEST) += selftest.o
 obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
 obj-$(CONFIG_OF_PCI)	+= of_pci.o
 obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
new file mode 100644
index 0000000..dc3b215
--- /dev/null
+++ b/drivers/of/selftest.c
@@ -0,0 +1,128 @@
+/*
+ * Self tests for device tree subsystem
+ */
+
+#define pr_fmt(fmt) "### %s(): " fmt, __func__
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_clk.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+
+static bool selftest_passed = true;
+#define selftest(result, fmt, ...) { \
+	selftest_passed &= (result); \
+	if (!(result)) \
+		pr_err("FAIL %s:%i " fmt, __FILE__, __LINE__, ##__VA_ARGS__); \
+}
+
+static void __init of_selftest_parse_phandle_with_args(void)
+{
+	struct device_node *np;
+	struct of_phandle_args args;
+	int rc, i;
+	bool passed_all = true;
+
+	pr_info("start\n");
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	if (!np) {
+		pr_err("No testcase data in device tree\n");
+		return;
+	}
+
+	for (i = 0; i < 7; i++) {
+		bool passed = true;
+		rc = of_parse_phandle_with_args(np, "phandle-list",
+						"#phandle-cells", i, &args);
+
+		/* Test the values from tests-phandle.dtsi */
+		switch (i) {
+			case 0:
+				passed &= !rc;
+				passed &= (args.args_count == 1);
+				passed &= (args.args[0] == (i + 1));
+				break;
+			case 1:
+				passed &= !rc;
+				passed &= (args.args_count == 2);
+				passed &= (args.args[0] == (i + 1));
+				passed &= (args.args[1] == 0);
+				break;
+			case 2:
+				passed &= (rc == -ENOENT);
+				break;
+			case 3:
+				passed &= !rc;
+				passed &= (args.args_count == 3);
+				passed &= (args.args[0] == (i + 1));
+				passed &= (args.args[1] == 4);
+				passed &= (args.args[2] == 3);
+				break;
+			case 4:
+				passed &= !rc;
+				passed &= (args.args_count == 2);
+				passed &= (args.args[0] == (i + 1));
+				passed &= (args.args[1] == 100);
+				break;
+			case 5:
+				passed &= !rc;
+				passed &= (args.args_count == 1);
+				passed &= (args.args[0] == (i + 1));
+				break;
+			case 6:
+				passed &= (rc == -EINVAL);
+				break;
+			default:
+				passed = false;
+		}
+
+		if (!passed) {
+			int j;
+			pr_err("index %i - data error on node %s rc=%i regs=[",
+				i, args.np->full_name, rc);
+			for (j = 0; j < args.args_count; j++)
+				printk(" %i", args.args[j]);
+			printk(" ]\n");
+		}
+
+		if (!passed)
+			passed_all = false;
+	}
+
+	/* Check for missing list property */
+	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
+					"#phandle-cells", 0, &args);
+	passed_all &= (rc == -EINVAL);
+
+	/* Check for missing cells property */
+	rc = of_parse_phandle_with_args(np, "phandle-list",
+					"#phandle-cells-missing", 0, &args);
+	passed_all &= (rc == -EINVAL);
+
+	/* Check for bad phandle in list */
+	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
+					"#phandle-cells", 0, &args);
+	passed_all &= (rc == -EINVAL);
+
+	/* Check for incorrectly formed argument list */
+	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
+					"#phandle-cells", 1, &args);
+	passed_all &= (rc == -EINVAL);
+
+	pr_info("end - %s\n", passed_all ? "PASS" : "FAIL");
+}
+
+static int __init of_selftest(void)
+{
+	pr_info("start of selftest\n");
+	of_selftest_parse_phandle_with_args();
+	pr_info("end of selftest - %s\n", selftest_passed ? "PASS" : "FAIL");
+	return 0;
+}
+late_initcall(of_selftest);
-- 
1.7.5.4

