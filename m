Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1GSXnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:43:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54895 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1GSXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:43:21 -0400
Subject: [PATCH] arm/dt: tegra devicetree support
To: Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Russell King <linux@arm.linux.org.uk>, swarren@nvidia.com,
        Arnd Bergmann <arnd@arndb.de>
Date: Tue, 19 Jul 2011 17:43:17 -0600
Message-ID: <20110719234158.2779.15394.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everything required to populate NVIDIA Tegra devices from the device
tree.  This patch adds a new DT_MACHINE_DESC() which matches against
a tegra20 device tree.  So far it only registers the on-chip devices,
but it will be refined in follow on patches to configure clocks and
pin IO from the device tree also.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Hi all,

Similar to the versatile patch I just posted, this is certainly not
complete board support, but it is enough to be useful.  I'd like to
merge this for v3.1.  It should not break any existing board support.

g.

 arch/arm/boot/dts/tegra-harmony.dts  |   70 ++++++++++++++++
 arch/arm/boot/dts/tegra-seaboard.dts |   28 ++++++
 arch/arm/boot/dts/tegra20.dtsi       |  148 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/Kconfig          |    6 +
 arch/arm/mach-tegra/Makefile         |    3 +
 arch/arm/mach-tegra/Makefile.boot    |    3 +
 arch/arm/mach-tegra/board-dt.c       |  117 +++++++++++++++++++++++++++
 7 files changed, 375 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra-harmony.dts
 create mode 100644 arch/arm/boot/dts/tegra-seaboard.dts
 create mode 100644 arch/arm/boot/dts/tegra20.dtsi
 create mode 100644 arch/arm/mach-tegra/board-dt.c

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
new file mode 100644
index 0000000..4c05334
--- /dev/null
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -0,0 +1,70 @@
+/dts-v1/;
+
+/memreserve/ 0x1c000000 0x04000000;
+/include/ "tegra20.dtsi"
+
+/ {
+	model = "NVIDIA Tegra2 Harmony evaluation board";
+	compatible = "nvidia,harmony", "nvidia,tegra20";
+
+	chosen {
+		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/mmcblk0p2 rw rootwait";
+	};
+
+	memory@0 {
+		reg = < 0x00000000 0x40000000 >;
+	};
+
+	i2c@7000c000 {
+		clock-frequency = <400000>;
+
+		codec: wm8903@1a {
+			compatible = "wlf,wm8903";
+			reg = <0x1a>;
+			interrupts = < 347 >;
+
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			/* 0x8000 = Not configured */
+			gpio-cfg = < 0x8000 0x8000 0 0x8000 0x8000 >;
+		};
+	};
+
+	i2c@7000c400 {
+		clock-frequency = <400000>;
+	};
+
+	i2c@7000c500 {
+		clock-frequency = <400000>;
+	};
+
+	i2c@7000d000 {
+		clock-frequency = <400000>;
+	};
+
+	sound {
+		compatible = "nvidia,harmony-sound", "nvidia,tegra-wm8903";
+
+		spkr-en-gpios = <&codec 2 0>;
+		hp-det-gpios = <&gpio 178 0>;
+		int-mic-en-gpios = <&gpio 184 0>;
+		ext-mic-en-gpios = <&gpio 185 0>;
+	};
+
+	serial@70006300 {
+		clock-frequency = < 216000000 >;
+	};
+
+	sdhci@c8000200 {
+		gpios = <&gpio 69 0>, /* cd, gpio PI5 */
+			<&gpio 57 0>, /* wp, gpio PH1 */
+			<&gpio 155 0>; /* power, gpio PT3 */
+	};
+
+	sdhci@c8000600 {
+		gpios = <&gpio 58 0>, /* cd, gpio PH2 */
+			<&gpio 59 0>, /* wp, gpio PH3 */
+			<&gpio 70 0>; /* power, gpio PI6 */
+	};
+};
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
new file mode 100644
index 0000000..1940cae
--- /dev/null
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -0,0 +1,28 @@
+/dts-v1/;
+
+/memreserve/ 0x1c000000 0x04000000;
+/include/ "tegra20.dtsi"
+
+/ {
+	model = "NVIDIA Seaboard";
+	compatible = "nvidia,seaboard", "nvidia,tegra20";
+
+	chosen {
+		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/mmcblk1p3 rw rootwait";
+	};
+
+	memory {
+		device_type = "memory";
+		reg = < 0x00000000 0x40000000 >;
+	};
+
+	serial@70006300 {
+		clock-frequency = < 216000000 >;
+	};
+
+	sdhci@c8000400 {
+		gpios = <&gpio 69 0>, /* cd, gpio PI5 */
+			<&gpio 57 0>, /* wp, gpio PH1 */
+			<&gpio 70 0>; /* power, gpio PI6 */
+	};
+};
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
new file mode 100644
index 0000000..18a1f45
--- /dev/null
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -0,0 +1,148 @@
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "NVIDIA Tegra 250";
+	compatible = "nvidia,tegra20";
+	interrupt-parent = <&intc>;
+
+	amba {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		intc: interrupt-controller@50041000 {
+			compatible = "nvidia,tegra20-gic", "arm,gic";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = < 0x50041000 0x1000 >,
+			      < 0x50040100 0x0100 >;
+		};
+	};
+
+
+	i2c@7000c000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000C000 0x100>;
+		interrupts = < 70 >;
+	};
+
+	i2c@7000c400 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000C400 0x100>;
+		interrupts = < 116 >;
+	};
+
+	i2c@7000c500 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000C500 0x100>;
+		interrupts = < 124 >;
+	};
+
+	i2c@7000d000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000D000 0x200>;
+		interrupts = < 85 >;
+	};
+
+	i2s@70002800 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2s";
+		reg = <0x70002800 0x200>;
+		interrupts = < 45 >;
+		dma-channel = < 2 >;
+	};
+
+	i2s@70002a00 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2s";
+		reg = <0x70002a00 0x200>;
+		interrupts = < 35 >;
+		dma-channel = < 1 >;
+	};
+
+	das@70000c00 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-das";
+		reg = <0x70000c00 0x80>;
+	};
+
+	gpio: gpio@6000d000 {
+		compatible = "nvidia,tegra20-gpio";
+		reg = < 0x6000d000 0x1000 >;
+		interrupts = < 64 65 66 67 87 119 121 >;
+		#gpio-cells = <2>;
+		gpio-controller;
+	};
+
+	serial@70006000 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006000 0x40>;
+		reg-shift = <2>;
+		interrupts = < 68 >;
+	};
+
+	serial@70006040 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006040 0x40>;
+		reg-shift = <2>;
+		interrupts = < 69 >;
+	};
+
+	serial@70006200 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006200 0x100>;
+		reg-shift = <2>;
+		interrupts = < 78 >;
+	};
+
+	serial@70006300 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006300 0x100>;
+		reg-shift = <2>;
+		interrupts = < 122 >;
+	};
+
+	serial@70006400 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006400 0x100>;
+		reg-shift = <2>;
+		interrupts = < 123 >;
+	};
+
+	sdhci@c8000000 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000000 0x200>;
+		interrupts = < 46 >;
+	};
+
+	sdhci@c8000200 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000200 0x200>;
+		interrupts = < 47 >;
+	};
+
+	sdhci@c8000400 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000400 0x200>;
+		interrupts = < 51 >;
+	};
+
+	sdhci@c8000600 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000600 0x200>;
+		interrupts = < 63 >;
+	};
+};
+
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 5ec1846..4b8abf9 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -51,6 +51,12 @@ config MACH_SEABOARD
 	 also be included for some of the derivative boards that
 	 have large similarities with the seaboard design.
 
+config MACH_TEGRA_DT
+	bool "Generic Tegra board (FDT support)"
+	select USE_OF
+	help
+	  Support for generic nVidia Tegra boards using Flattened Device Tree
+
 config MACH_TRIMSLICE
        bool "TrimSlice board"
        select TEGRA_PCI
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 823c703..6d3d695 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -30,5 +30,8 @@ obj-${CONFIG_MACH_PAZ00}		+= board-paz00-pinmux.o
 obj-${CONFIG_MACH_SEABOARD}             += board-seaboard.o
 obj-${CONFIG_MACH_SEABOARD}             += board-seaboard-pinmux.o
 
+obj-${CONFIG_MACH_TEGRA_DT}             += board-dt.o
+obj-${CONFIG_MACH_TEGRA_DT}             += board-harmony-pinmux.o
+
 obj-${CONFIG_MACH_TRIMSLICE}            += board-trimslice.o
 obj-${CONFIG_MACH_TRIMSLICE}            += board-trimslice-pinmux.o
diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
index db52d61..428ad12 100644
--- a/arch/arm/mach-tegra/Makefile.boot
+++ b/arch/arm/mach-tegra/Makefile.boot
@@ -1,3 +1,6 @@
 zreladdr-$(CONFIG_ARCH_TEGRA_2x_SOC)	:= 0x00008000
 params_phys-$(CONFIG_ARCH_TEGRA_2x_SOC)	:= 0x00000100
 initrd_phys-$(CONFIG_ARCH_TEGRA_2x_SOC)	:= 0x00800000
+
+dtb-$(CONFIG_MACH_HARMONY) += tegra-harmony.dtb
+dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
new file mode 100644
index 0000000..1e3fbc3
--- /dev/null
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -0,0 +1,117 @@
+/*
+ * nVidia Tegra device tree board support
+ *
+ * Copyright (C) 2010 Secret Lab Technologies, Ltd.
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/serial_8250.h>
+#include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_fdt.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/pda_power.h>
+#include <linux/io.h>
+#include <linux/i2c.h>
+#include <linux/i2c-tegra.h>
+
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <asm/setup.h>
+
+#include <mach/iomap.h>
+#include <mach/irqs.h>
+
+#include "board.h"
+#include "board-harmony.h"
+#include "clock.h"
+#include "devices.h"
+
+void harmony_pinmux_init(void);
+void seaboard_pinmux_init(void);
+
+
+struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC4_BASE, "sdhci-tegra.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C2_BASE, "tegra-i2c.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C3_BASE, "tegra-i2c.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_DVC_BASE, "tegra-i2c.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra-das", NULL),
+	{}
+};
+
+static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
+	/* name		parent		rate		enabled */
+	{ "uartd",	"pll_p",	216000000,	true },
+	{ NULL,		NULL,		0,		0},
+};
+
+static struct of_device_id tegra_dt_match_table[] __initdata = {
+	{ .compatible = "simple-bus", },
+	{}
+};
+
+static struct of_device_id tegra_dt_gic_match[] __initdata = {
+	{ .compatible = "nvidia,tegra20-gic", },
+	{}
+};
+
+static void __init tegra_dt_init(void)
+{
+	struct device_node *node;
+
+	node = of_find_matching_node_by_address(NULL, tegra_dt_gic_match,
+						TEGRA_ARM_INT_DIST_BASE);
+	if (node)
+		irq_domain_add_simple(node, INT_GIC_BASE);
+
+	tegra_clk_init_from_table(tegra_dt_clk_init_table);
+
+	if (of_machine_is_compatible("nvidia,harmony"))
+		harmony_pinmux_init();
+	else if (of_machine_is_compatible("nvidia,seaboard"))
+		seaboard_pinmux_init();
+
+	/*
+	 * Finished with the static registrations now; fill in the missing
+	 * devices
+	 */
+	of_platform_populate(NULL, tegra_dt_match_table, tegra20_auxdata_lookup, NULL);
+}
+
+static const char * tegra_dt_board_compat[] = {
+	"nvidia,tegra20",
+	NULL
+};
+
+DT_MACHINE_START(TEGRA_DT, "nVidia Tegra (Flattened Device Tree)")
+	.map_io		= tegra_map_common_io,
+	.init_early	= tegra_init_early,
+	.init_irq	= tegra_init_irq,
+	.timer		= &tegra_timer,
+	.init_machine	= tegra_dt_init,
+	.dt_compat	= tegra_dt_board_compat,
+MACHINE_END

