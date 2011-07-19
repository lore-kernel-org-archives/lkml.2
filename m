Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1GSXjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:39:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50978 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1GSXjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:39:08 -0400
Subject: [PATCH] arm/versatile: Add device tree support
To: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Jul 2011 17:39:05 -0600
Message-ID: <20110719233645.2528.50466.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For testing the dt work, define a dt-enabled versatile platform.

This patch adds a new versatile platform for when using the device
tree.  Add platform and amba devices are discovered and registered by
parsing the device tree.  Clocks and initial io mappings are still
configured statically.

This patch still depends on some static platform_data for a few devices
which is passed via the auxdata structure to of_platform_populate(),
but it is a viable starting point until the drivers can get all
configuration data out of the device tree.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi Russell,

Assuming you're okay with this, I would like to merge this Versatile
board support patch for v3.1.  It's not perfect, but it can be changed
in place after it is merged and should not break existing versatile
board support.  In fact I can build a kernel with this that boots in
both DT and non-DT configurations; very useful for debug.

It depends on patches in devicetree/next, so I'd like to merge it via
the arm-soc tree after devicetree/next gets merged.  I'll provide a
git branch with the relevant commits if it looks good to you.

g.


 Documentation/devicetree/bindings/arm/arm-boards   |   20 ++
 .../devicetree/bindings/i2c/arm-versatile.txt      |   10 +
 .../devicetree/bindings/mtd/arm-versatile.txt      |    8 +
 .../devicetree/bindings/net/smsc-lan91c111.txt     |   10 +
 arch/arm/boot/dts/versatile-ab.dts                 |  192 ++++++++++++++++++++
 arch/arm/boot/dts/versatile-pb.dts                 |   48 +++++
 arch/arm/mach-versatile/Kconfig                    |    8 +
 arch/arm/mach-versatile/Makefile                   |    1 
 arch/arm/mach-versatile/core.c                     |   61 ++++++
 arch/arm/mach-versatile/core.h                     |    2 
 arch/arm/mach-versatile/versatile_dt.c             |   51 +++++
 11 files changed, 411 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/arm-boards
 create mode 100644 Documentation/devicetree/bindings/i2c/arm-versatile.txt
 create mode 100644 Documentation/devicetree/bindings/mtd/arm-versatile.txt
 create mode 100644 Documentation/devicetree/bindings/net/smsc-lan91c111.txt
 create mode 100644 arch/arm/boot/dts/versatile-ab.dts
 create mode 100644 arch/arm/boot/dts/versatile-pb.dts
 create mode 100644 arch/arm/mach-versatile/versatile_dt.c

diff --git a/Documentation/devicetree/bindings/arm/arm-boards b/Documentation/devicetree/bindings/arm/arm-boards
new file mode 100644
index 0000000..91f2614
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/arm-boards
@@ -0,0 +1,20 @@
+ARM Versatile Application and Platform Baseboards
+-------------------------------------------------
+ARM's development hardware platform with connectors for customizable
+core tiles.  The hardware configuration of the Versatile boards is
+highly customizable.
+
+Required properties (in root node):
+	compatible = "arm,versatile-ab";  /* Application baseboard */
+	compatible = "arm,versatile-pb";  /* Platform baseboard */
+
+Interrupt controllers:
+- VIC required properties:
+	compatible = "arm,versatile-vic";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+
+- SIC required properties:
+	compatible = "arm,versatile-sic";
+	interrupt-controller;
+	#interrupt-cells = <1>;
diff --git a/Documentation/devicetree/bindings/i2c/arm-versatile.txt b/Documentation/devicetree/bindings/i2c/arm-versatile.txt
new file mode 100644
index 0000000..361d31c
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/arm-versatile.txt
@@ -0,0 +1,10 @@
+i2c Controller on ARM Versatile platform:
+
+Required properties:
+- compatible : Must be "arm,versatile-i2c";
+- reg
+- #address-cells = <1>;
+- #size-cells = <0>;
+
+Optional properties:
+- Child nodes conforming to i2c bus binding
diff --git a/Documentation/devicetree/bindings/mtd/arm-versatile.txt b/Documentation/devicetree/bindings/mtd/arm-versatile.txt
new file mode 100644
index 0000000..476845d
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/arm-versatile.txt
@@ -0,0 +1,8 @@
+Flash device on ARM Versatile board
+
+Required properties:
+- compatible : must be "arm,versatile-flash";
+- bank-width : width in bytes of flash interface.
+
+Optional properties:
+- Subnode partition map from mtd flash binding
diff --git a/Documentation/devicetree/bindings/net/smsc-lan91c111.txt b/Documentation/devicetree/bindings/net/smsc-lan91c111.txt
new file mode 100644
index 0000000..953049b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/smsc-lan91c111.txt
@@ -0,0 +1,10 @@
+SMSC LAN91c111 Ethernet mac
+
+Required properties:
+- compatible = "smsc,lan91c111";
+- reg : physical address and size of registers
+- interrupts : interrupt connection
+
+Optional properties:
+- phy-device : phandle to Ethernet phy
+- local-mac-address : Ethernet mac address to use
diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
new file mode 100644
index 0000000..0b32925
--- /dev/null
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -0,0 +1,192 @@
+/dts-v1/;
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "ARM Versatile AB";
+	compatible = "arm,versatile-ab";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&vic>;
+
+	aliases {
+		serial0 = &uart0;
+		serial1 = &uart1;
+		serial2 = &uart2;
+		i2c0 = &i2c0;
+	};
+
+	memory {
+		reg = <0x0 0x08000000>;
+	};
+
+	flash@34000000 {
+		compatible = "arm,versatile-flash";
+		reg = <0x34000000 0x4000000>;
+		bank-width = <4>;
+	};
+
+	i2c0: i2c@10002000 {
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
+	net@10010000 {
+		compatible = "smsc,lan91c111";
+		reg = <0x10010000 0x10000>;
+		interrupts = <25>;
+	};
+
+	lcd@10008000 {
+		compatible = "arm,versatile-lcd";
+		reg = <0x10008000 0x1000>;
+	};
+
+	amba {
+		compatible = "arm,amba-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		vic: intc@10140000 {
+			compatible = "arm,versatile-vic";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0x10140000 0x1000>;
+		};
+
+		sic: intc@10003000 {
+			compatible = "arm,versatile-sic";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0x10003000 0x1000>;
+			interrupt-parent = <&vic>;
+			interrupts = <31>; /* Cascaded to vic */
+		};
+
+		dma@10130000 {
+			compatible = "arm,pl081", "arm,primecell";
+			reg = <0x10130000 0x1000>;
+			interrupts = <17>;
+		};
+
+		uart0: uart@101f1000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0x101f1000 0x1000>;
+			interrupts = <12>;
+		};
+
+		uart1: uart@101f2000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0x101f2000 0x1000>;
+			interrupts = <13>;
+		};
+
+		uart2: uart@101f3000 {
+			compatible = "arm,pl011", "arm,primecell";
+			reg = <0x101f3000 0x1000>;
+			interrupts = <14>;
+		};
+
+		smc@10100000 {
+			compatible = "arm,primecell";
+			reg = <0x10100000 0x1000>;
+		};
+
+		mpmc@10110000 {
+			compatible = "arm,primecell";
+			reg = <0x10110000 0x1000>;
+		};
+
+		display@10120000 {
+			compatible = "arm,pl110", "arm,primecell";
+			reg = <0x10120000 0x1000>;
+			interrupts = <16>;
+		};
+
+		sctl@101e0000 {
+			compatible = "arm,primecell";
+			reg = <0x101e0000 0x1000>;
+		};
+
+		watchdog@101e1000 {
+			compatible = "arm,primecell";
+			reg = <0x101e1000 0x1000>;
+			interrupts = <0>;
+		};
+
+		gpio0: gpio@101e4000 {
+			compatible = "arm,pl061", "arm,primecell";
+			reg = <0x101e4000 0x1000>;
+			gpio-controller;
+			interrupts = <6>;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpio1: gpio@101e5000 {
+			compatible = "arm,pl061", "arm,primecell";
+			reg = <0x101e5000 0x1000>;
+			interrupts = <7>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		rtc@101e8000 {
+			compatible = "arm,pl030", "arm,primecell";
+			reg = <0x101e8000 0x1000>;
+			interrupts = <10>;
+		};
+
+		sci@101f0000 {
+			compatible = "arm,primecell";
+			reg = <0x101f0000 0x1000>;
+			interrupts = <15>;
+		};
+
+		ssp@101f4000 {
+			compatible = "arm,pl022", "arm,primecell";
+			reg = <0x101f4000 0x1000>;
+			interrupts = <11>;
+		};
+
+		fpga {
+			compatible = "arm,versatile-fpga", "simple-bus";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0 0x10000000 0x10000>;
+
+			aaci@4000 {
+				compatible = "arm,primecell";
+				reg = <0x4000 0x1000>;
+				interrupts = <24>;
+			};
+			mmc@5000 {
+				compatible = "arm,primecell";
+				reg = < 0x5000 0x1000>;
+				interrupts = <22>;
+			};
+			kmi@6000 {
+				compatible = "arm,pl050", "arm,primecell";
+				reg = <0x6000 0x1000>;
+				interrupt-parent = <&sic>;
+				interrupts = <3>;
+			};
+			kmi@7000 {
+				compatible = "arm,pl050", "arm,primecell";
+				reg = <0x7000 0x1000>;
+				interrupt-parent = <&sic>;
+				interrupts = <4>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
new file mode 100644
index 0000000..8a614e3
--- /dev/null
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -0,0 +1,48 @@
+/include/ "versatile-ab.dts"
+
+/ {
+	model = "ARM Versatile PB";
+	compatible = "arm,versatile-pb";
+
+	amba {
+		gpio2: gpio@101e6000 {
+			compatible = "arm,pl061", "arm,primecell";
+			reg = <0x101e6000 0x1000>;
+			interrupts = <8>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		gpio3: gpio@101e7000 {
+			compatible = "arm,pl061", "arm,primecell";
+			reg = <0x101e7000 0x1000>;
+			interrupts = <9>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
+		fpga {
+			uart@9000 {
+				compatible = "arm,pl011", "arm,primecell";
+				reg = <0x9000 0x1000>;
+				interrupt-parent = <&sic>;
+				interrupts = <6>;
+			};
+			sci@a000 {
+				compatible = "arm,primecell";
+				reg = <0xa000 0x1000>;
+				interrupt-parent = <&sic>;
+				interrupts = <5>;
+			};
+			mmc@b000 {
+				compatible = "arm,primecell";
+				reg = <0xb000 0x1000>;
+				interrupts = <23>;
+			};
+		};
+	};
+};
diff --git a/arch/arm/mach-versatile/Kconfig b/arch/arm/mach-versatile/Kconfig
index 9cdec5a..c1f38f6 100644
--- a/arch/arm/mach-versatile/Kconfig
+++ b/arch/arm/mach-versatile/Kconfig
@@ -17,4 +17,12 @@ config MACH_VERSATILE_AB
 	  Include support for the ARM(R) Versatile Application Baseboard
 	  for the ARM926EJ-S.
 
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
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 0c99cf0..4770dcd 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -24,6 +24,8 @@
 #include <linux/platform_device.h>
 #include <linux/sysdev.h>
 #include <linux/interrupt.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
 #include <linux/amba/pl061.h>
@@ -83,13 +85,26 @@ static struct fpga_irq_data sic_irq = {
 #define PIC_MASK	0
 #endif
 
+/* Lookup table for finding a DT node that represents the vic instance */
+static const struct of_device_id vic_of_match[] __initconst = {
+	{ .compatible = "arm,versatile-vic", },
+	{}
+};
+
+static const struct of_device_id sic_of_match[] __initconst = {
+	{ .compatible = "arm,versatile-sic", },
+	{}
+};
+
 void __init versatile_init_irq(void)
 {
 	vic_init(VA_VIC_BASE, IRQ_VIC_START, ~0, 0);
+	irq_domain_generate_simple(vic_of_match, VERSATILE_VIC_BASE, IRQ_VIC_START);
 
 	writel(~0, VA_SIC_BASE + SIC_IRQ_ENABLE_CLEAR);
 
 	fpga_irq_init(IRQ_VICSOURCE31, ~PIC_MASK, &sic_irq);
+	irq_domain_generate_simple(sic_of_match, VERSATILE_SIC_BASE, IRQ_SIC_START);
 
 	/*
 	 * Interrupts on secondary controller from 0 to 8 are routed to
@@ -646,6 +661,52 @@ static struct amba_device *amba_devs[] __initdata = {
 	&kmi1_device,
 };
 
+#ifdef CONFIG_OF
+/*
+ * Lookup table for attaching a specific name and platform_data pointer to
+ * devices as they get created by of_platform_populate().  Ideally this table
+ * would not exist, but the current clock implementation depends on some devices
+ * having a specific name.
+ */
+struct of_dev_auxdata versatile_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI0_BASE, "fpga:05", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI0_BASE, "fpga:06", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI1_BASE, "fpga:07", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART3_BASE, "fpga:09", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI1_BASE, "fpga:0b", NULL),
+
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_CLCD_BASE, "dev:20", &clcd_plat_data),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART0_BASE, "dev:f1", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART1_BASE, "dev:f2", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART2_BASE, "dev:f3", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SSP_BASE, "dev:f4", NULL),
+
+#if 0
+	/*
+	 * These entries are unnecessary because no clocks referencing
+	 * them.  I've left them in for now as place holders in case
+	 * any of them need to be added back, but they should be
+	 * removed before actually committing this patch.  --gcl
+	 */
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_AACI_BASE, "fpga:04", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI1_BASE, "fpga:0a", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SMC_BASE, "dev:00", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MPMC_BASE, "dev:10", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_DMAC_BASE, "dev:30", NULL),
+
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCTL_BASE, "dev:e0", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_WATCHDOG_BASE, "dev:e1", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO0_BASE, "dev:e4", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO1_BASE, "dev:e5", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO2_BASE, "dev:e6", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO3_BASE, "dev:e7", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_RTC_BASE, "dev:e8", NULL),
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI_BASE, "dev:f0", NULL),
+#endif
+	{}
+};
+#endif
+
 #ifdef CONFIG_LEDS
 #define VA_LEDS_BASE (__io_address(VERSATILE_SYS_BASE) + VERSATILE_SYS_LED_OFFSET)
 
diff --git a/arch/arm/mach-versatile/core.h b/arch/arm/mach-versatile/core.h
index fd6404e..70b1555 100644
--- a/arch/arm/mach-versatile/core.h
+++ b/arch/arm/mach-versatile/core.h
@@ -23,6 +23,7 @@
 #define __ASM_ARCH_VERSATILE_H
 
 #include <linux/amba/bus.h>
+#include <linux/of_platform.h>
 
 extern void __init versatile_init(void);
 extern void __init versatile_init_early(void);
@@ -30,6 +31,7 @@ extern void __init versatile_init_irq(void);
 extern void __init versatile_map_io(void);
 extern struct sys_timer versatile_timer;
 extern unsigned int mmc_status(struct device *dev);
+extern struct of_dev_auxdata versatile_auxdata_lookup[];
 
 #define AMBA_DEVICE(name,busid,base,plat)			\
 static struct amba_device name##_device = {			\
diff --git a/arch/arm/mach-versatile/versatile_dt.c b/arch/arm/mach-versatile/versatile_dt.c
new file mode 100644
index 0000000..54e037c
--- /dev/null
+++ b/arch/arm/mach-versatile/versatile_dt.c
@@ -0,0 +1,51 @@
+/*
+ * Versatile board support using the device tree
+ *
+ *  Copyright (C) 2010 Secret Lab Technologies Ltd.
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
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+
+#include "core.h"
+
+static void __init versatile_dt_init(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     versatile_auxdata_lookup, NULL);
+}
+
+static const char *versatile_dt_match[] __initconst = {
+	"arm,versatile-ab",
+	"arm,versatile-pb",
+	NULL,
+};
+
+DT_MACHINE_START(VERSATILE_PB, "ARM-Versatile (Device Tree Support)")
+	.map_io		= versatile_map_io,
+	.init_early	= versatile_init_early,
+	.init_irq	= versatile_init_irq,
+	.timer		= &versatile_timer,
+	.init_machine	= versatile_dt_init,
+	.dt_compat	= versatile_dt_match,
+MACHINE_END

