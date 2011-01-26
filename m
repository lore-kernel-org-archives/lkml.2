Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab1AZEof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 23:44:35 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52305 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1AZEod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 23:44:33 -0500
Subject: [RFC PATCH 5/5] arm/versatile: add a device tree versatile platform
To: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: nicolas.pitre@linaro.org
Date: Tue, 25 Jan 2011 21:44:27 -0700
Message-ID: <20110126044427.16410.89126.stgit@localhost6.localdomain6>
In-Reply-To: <20110126043338.16410.75019.stgit@localhost6.localdomain6>
References: <20110126043338.16410.75019.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For testing the dt work, define a dt-enabled versatile platform.

This patch includes some fixed clk parsing logic that really would be
better as common code, but that depends on the common struct clk
getting merged.  In the mean time it is easy enough to implement it
here.

Based on work originally written by Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/versatile.dts        |  138 ++++++++++++++++++++++++++++++++
 arch/arm/mach-versatile/Kconfig        |    8 ++
 arch/arm/mach-versatile/Makefile       |    1 
 arch/arm/mach-versatile/versatile_ab.c |    6 -
 arch/arm/mach-versatile/versatile_dt.c |  108 +++++++++++++++++++++++++
 arch/arm/mach-versatile/versatile_pb.c |    6 -
 arch/arm/plat-versatile/clock.c        |    2 
 drivers/of/clock.c                     |    1 
 8 files changed, 257 insertions(+), 13 deletions(-)
 create mode 100644 arch/arm/boot/dts/versatile.dts
 create mode 100644 arch/arm/mach-versatile/versatile_dt.c

diff --git a/arch/arm/boot/dts/versatile.dts b/arch/arm/boot/dts/versatile.dts
new file mode 100644
index 0000000..6ff9ee2
--- /dev/null
+++ b/arch/arm/boot/dts/versatile.dts
@@ -0,0 +1,138 @@
+/dts-v1/;
+
+/ {
+	model = "ARM Versatile-PB";
+	compatible = "arm,versatile-pb";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&vic>;
+
+	aliases {
+		uart0 = &uart0;
+		uart1 = &uart1;
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x0 0x08000000>;
+	};
+
+	chosen {
+		bootargs = "console=ttyAMA0 debug";
+	};
+
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ref24_clk: clock@0 {
+			compatible = "fixed-clock";
+			clock-frequency = <24000000>;
+			clock-outputs = "ref";
+		};
+
+		osc4_clk: clock@1 {
+			compatible = "ics,icst307";
+			ref = <24000>;
+			vco-max = <200000>;
+			vd-range = <12 519>;
+			rd-range = <3 129>;
+			clock-outputs = "osc4";
+		};
+	};
+
+	vic: intc {
+		compatible = "arm,versatile-vic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x10140000 0x1000>;
+	};
+
+	sic: intc@10003000 {
+		compatible = "arm,versatile-vic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0x10003000 0x1000>;
+		interrupts = <31>; /* Cascaded to vic */
+	};
+
+	amba {
+		compatible = "arm,amba-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		fpga {
+			compatible = "arm,versatile-fpga", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x10000000 0x10000>;
+
+			fpga@5000 {
+				compatible = "arm,amba-device";
+				reg = < 0x5000 0x1000 >;
+			};
+			fpga@6000 {
+				compatible = "arm,pl050", "arm,amba-device";
+				reg = < 0x6000 0x1000 >;
+			};
+			fpga@7000 {
+				compatible = "arm,pl050", "arm,amba-device";
+				reg = < 0x7000 0x1000 >;
+			};
+			fpga@9000 {
+				compatible = "arm,pl011", "arm,amba-device";
+				reg = < 0x9000 0x1000 >;
+			};
+			fpga@b000 {
+				compatible = "arm,amba-device";
+				reg = < 0xb000 0x1000 >;
+			};
+		};
+
+		uart0: uart@101f1000 {
+			compatible = "arm,pl011", "arm,amba-device";
+			reg = <0x101f1000 0x1000>;
+			arm,amba-deviceid = <0x00141011>;
+			interrupts = <12>;
+			bus-clock = <&ref24_clk>, "ref";
+		};
+
+		uart1: uart@101f2000 {
+			compatible = "arm,pl011", "arm,amba-device";
+			reg = <0x101f2000 0x1000>;
+			arm,amba-deviceid = <0x00141011>;
+			interrupts = <13>;
+			bus-clock = <&ref24_clk>, "ref";
+		};
+	};
+
+	flash@34000000 {
+		compatible = "arm,versatile-flash";
+		reg = <0x34000000 0x4000000>;
+		bank-width = <4>;
+	};
+
+	net@10010000 {
+		compatible = "smsc,smc91c111";
+		reg = <0x10010000 0x10000>;
+		interrupts = <25>;
+	};
+
+	i2c@10002000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "arm,versatile-i2c";
+		reg = <0x10002000 0x1000>;
+
+		rtc@68 {
+			compatible = "dallas,ds1338";
+			reg = <0x68>;
+		};
+	};
+
+	lcd@10008000 {
+		compatible = "arm,versatile-lcd";
+		reg = <0x10008000 0x1000>;
+	};
+};
diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
index 3f7b5e9..3b417f4 100644
--- a/arch/arm/mach-versatile/Kconfig
+++ b/arch/arm/mach-versatile/Kconfig
@@ -15,4 +15,12 @@ config MACH_VERSATILE_AB
 	help
 	  Include support for the ARM(R) Versatile/AP platform.
 
+config MACH_VERSATILE_DT
+	bool "Support Versatile platform from device tree"
+	select USE_OF
+	select CPU_ARM926T
+	help
+	  Include support for the ARM(R) Versatile/PB platform,
+	  using the device tree for discovery
+
 endmenu
diff --git a/arch/arm/mach-versatile/Makefile b/arch/arm/mach-versatile/Makefile
index 97cf4d8..81fa3fe 100644
--- a/arch/arm/mach-versatile/Makefile
+++ b/arch/arm/mach-versatile/Makefile
@@ -5,4 +5,5 @@
 obj-y					:= core.o
 obj-$(CONFIG_ARCH_VERSATILE_PB)		+= versatile_pb.o
 obj-$(CONFIG_MACH_VERSATILE_AB)		+= versatile_ab.o
+obj-$(CONFIG_MACH_VERSATILE_DT)		+= versatile_dt.o
 obj-$(CONFIG_PCI)			+= pci.o
diff --git a/arch/arm/mach-versatile/versatile_ab.c b/arch/arm/mach-versatile/versatile_ab.c
index 62053df..aa9730f 100644
--- a/arch/arm/mach-versatile/versatile_ab.c
+++ b/arch/arm/mach-versatile/versatile_ab.c
@@ -33,11 +33,6 @@
 
 #include "core.h"
 
-static const char *versatile_ab_match[] __initdata = {
-	"arm,versatile-ab",
-	NULL,
-};
-
 MACHINE_START(VERSATILE_AB, "ARM-Versatile AB")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.boot_params	= 0x00000100,
@@ -45,5 +40,4 @@ MACHINE_START(VERSATILE_AB, "ARM-Versatile AB")
 	.init_irq	= versatile_init_irq,
 	.timer		= &versatile_timer,
 	.init_machine	= versatile_init,
-	.dt_compat	= versatile_ab_match,
 MACHINE_END
diff --git a/arch/arm/mach-versatile/versatile_dt.c b/arch/arm/mach-versatile/versatile_dt.c
new file mode 100644
index 0000000..7eacc2d
--- /dev/null
+++ b/arch/arm/mach-versatile/versatile_dt.c
@@ -0,0 +1,108 @@
+/*
+ *  linux/arch/arm/mach-versatile/versatile_dt.c
+ *
+ *  Copyright (C) 2009 Jeremy Kerr <jeremy.kerr@canonical.com>
+ *  Copyright (C) 2004 ARM Limited
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/sysdev.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/amba/bus.h>
+#include <linux/amba/pl061.h>
+#include <linux/amba/mmci.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_fdt.h>
+#include <linux/of_clk.h>
+
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm/mach-types.h>
+
+#include <asm/mach/arch.h>
+
+#include "core.h"
+
+/* Dummy AMBA bus clock; can be overridden */
+static struct clk versatile_dt_dummy_apb_pclk;
+static struct clk_lookup versatile_dt_dummy_apb_cl = {
+	.con_id = "apb_pclk",
+	.clk = &versatile_dt_dummy_apb_pclk,
+};
+
+/* Scan for fixed clocks */
+static struct clk *versatile_dt_clk_get(struct device_node *np,
+					const char *output_id, void *data)
+{
+	return data;
+}
+
+static __init void versatile_dt_scan_clks(void)
+{
+	struct device_node *node;
+	const __be32 *rate;
+	struct clk *clk;
+	int rc;
+
+	for_each_compatible_node(node, NULL, "fixed-clock") {
+		rate = of_get_property(node, "clock-frequency", NULL);
+		if (!rate)
+			continue;
+
+		clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+		if (!clk)
+			panic("out of memory\n");
+		clk->rate = be32_to_cpup(rate);
+
+		rc = of_clk_add_provider(node, versatile_dt_clk_get, clk);
+		if (rc) {
+			kfree(clk);
+			pr_err("error adding fixed clk %s\n", node->name);
+		}
+	}
+}
+static void __init versatile_dt_init(void)
+{
+	struct device_node *node;
+
+	clkdev_add(&versatile_dt_dummy_apb_cl);
+	versatile_dt_scan_clks();
+
+	node = of_find_node_by_path("/amba");
+	if (node)
+		of_amba_bus_populate(node, NULL);
+}
+
+static const char *versatile_dt_match[] __initdata = {
+	"arm,versatile-ab",
+	"arm,versatile-pb",
+	NULL,
+};
+
+DT_MACHINE_START(VERSATILE_PB, "ARM-Versatile (Device Tree Support)")
+	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
+	.boot_params	= 0x00000100,
+	.map_io		= versatile_map_io,
+	.init_irq	= versatile_init_irq,
+	.timer		= &versatile_timer,
+	.init_machine	= versatile_dt_init,
+	.dt_compat	= versatile_dt_match,
+MACHINE_END
diff --git a/arch/arm/mach-versatile/versatile_pb.c b/arch/arm/mach-versatile/versatile_pb.c
index eba12fa..bf46964 100644
--- a/arch/arm/mach-versatile/versatile_pb.c
+++ b/arch/arm/mach-versatile/versatile_pb.c
@@ -106,11 +106,6 @@ static void __init versatile_pb_init(void)
 	}
 }
 
-static const char *versatile_pb_match[] __initdata = {
-	"arm,versatile-pb",
-	NULL,
-};
-
 MACHINE_START(VERSATILE_PB, "ARM-Versatile PB")
 	/* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
 	.boot_params	= 0x00000100,
@@ -118,5 +113,4 @@ MACHINE_START(VERSATILE_PB, "ARM-Versatile PB")
 	.init_irq	= versatile_init_irq,
 	.timer		= &versatile_timer,
 	.init_machine	= versatile_pb_init,
-	.dt_compat	= versatile_pb_match,
 MACHINE_END
diff --git a/arch/arm/plat-versatile/clock.c b/arch/arm/plat-versatile/clock.c
index 5c8b656..44545de 100644
--- a/arch/arm/plat-versatile/clock.c
+++ b/arch/arm/plat-versatile/clock.c
@@ -13,6 +13,8 @@
 #include <linux/errno.h>
 #include <linux/clk.h>
 #include <linux/mutex.h>
+#include <linux/err.h>
+#include <linux/slab.h>
 
 #include <asm/hardware/icst.h>
 
diff --git a/drivers/of/clock.c b/drivers/of/clock.c
index 3e2b221..7b5ea67 100644
--- a/drivers/of/clock.c
+++ b/drivers/of/clock.c
@@ -131,4 +131,3 @@ struct clk *of_clk_get(struct device *dev, const char *id)
 
 	return clk;
 }
-

