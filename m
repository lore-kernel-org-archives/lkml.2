Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab1LLUOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:14:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41989 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab1LLUOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:14:34 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.olzabs.org
Cc: microblaze-uclinux@itee.uq.edu.au,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 4/4] of: Add device tree selftests
Date: Mon, 12 Dec 2011 13:14:12 -0700
Message-Id: <1323720852-26311-5-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
References: <1323720852-26311-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some runtime test cases for the library of device tree parsing functions.

v2: - Add testcase for phandle with 0 args
    - Don't run testcases if testcase data isn't present in device tree

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/testcases/tests-phandle.dtsi |   37 +++++++
 arch/arm/boot/dts/testcases/tests.dtsi         |    1 +
 arch/arm/boot/dts/versatile-pb.dts             |    2 +
 drivers/of/Kconfig                             |    9 ++
 drivers/of/Makefile                            |    1 +
 drivers/of/selftest.c                          |  139 ++++++++++++++++++++++++
 6 files changed, 189 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/testcases/tests-phandle.dtsi
 create mode 100644 arch/arm/boot/dts/testcases/tests.dtsi
 create mode 100644 drivers/of/selftest.c

diff --git a/arch/arm/boot/dts/testcases/tests-phandle.dtsi b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
new file mode 100644
index 0000000..ec0c4e6
--- /dev/null
+++ b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
@@ -0,0 +1,37 @@
+
+/ {
+	testcase-data {
+		phandle-tests {
+			provider0: provider0 {
+				#phandle-cells = <0>;
+			};
+
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
+						<&provider0>,
+						<&provider1 7>;
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
index 0000000..9d2b480
--- /dev/null
+++ b/drivers/of/selftest.c
@@ -0,0 +1,139 @@
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
+		pr_err("missing testcase data\n");
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
+		case 0:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == (i + 1));
+			break;
+		case 1:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == (i + 1));
+			passed &= (args.args[1] == 0);
+			break;
+		case 2:
+			passed &= (rc == -ENOENT);
+			break;
+		case 3:
+			passed &= !rc;
+			passed &= (args.args_count == 3);
+			passed &= (args.args[0] == (i + 1));
+			passed &= (args.args[1] == 4);
+			passed &= (args.args[2] == 3);
+			break;
+		case 4:
+			passed &= !rc;
+			passed &= (args.args_count == 2);
+			passed &= (args.args[0] == (i + 1));
+			passed &= (args.args[1] == 100);
+			break;
+		case 5:
+			passed &= !rc;
+			passed &= (args.args_count == 0);
+			break;
+		case 6:
+			passed &= !rc;
+			passed &= (args.args_count == 1);
+			passed &= (args.args[0] == (i + 1));
+			break;
+		case 7:
+			passed &= (rc == -EINVAL);
+			break;
+		default:
+			passed = false;
+		}
+
+		if (!passed) {
+			int j;
+			pr_err("index %i - data error on node %s rc=%i regs=[",
+				i, args.np->full_name, rc);
+			for (j = 0; j < args.args_count; j++)
+				printk(" %i", args.args[j]);
+			printk(" ]\n");
+
+			passed_all = false;
+		}
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
+	struct device_node *np;
+
+	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
+	if (!np) {
+		pr_info("No testcase data in device tree; not running tests\n");
+		return 0;
+	}
+	of_node_put(np);
+
+	pr_info("start of selftest - you will see error messages\n");
+	of_selftest_parse_phandle_with_args();
+	pr_info("end of selftest - %s\n", selftest_passed ? "PASS" : "FAIL");
+	return 0;
+}
+late_initcall(of_selftest);
-- 
1.7.5.4

