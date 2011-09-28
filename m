Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1I1WaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:30:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5422 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab1I1WaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:30:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 28 Sep 2011 15:30:03 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v5 3/3] arm/tegra: device tree support for ventana board
Date: Thu, 29 Sep 2011 01:29:36 +0300
Message-ID: <1317248978-10829-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com>
References: <1317248978-10829-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/boot/dts/tegra-ventana.dts |   32 ++++++++++++++++++++++++++++++++
 arch/arm/mach-tegra/Kconfig         |    6 ++++++
 arch/arm/mach-tegra/Makefile.boot   |    1 +
 arch/arm/mach-tegra/board-dt.c      |   26 +++++++++++++++++++++-----
 4 files changed, 60 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra-ventana.dts

diff --git a/arch/arm/boot/dts/tegra-ventana.dts b/arch/arm/boot/dts/tegra-ventana.dts
new file mode 100644
index 0000000..9b29a62
--- /dev/null
+++ b/arch/arm/boot/dts/tegra-ventana.dts
@@ -0,0 +1,32 @@
+/dts-v1/;
+
+/memreserve/ 0x1c000000 0x04000000;
+/include/ "tegra20.dtsi"
+
+/ {
+	model = "NVIDIA Tegra2 Ventana evaluation board";
+	compatible = "nvidia,ventana", "nvidia,tegra20";
+
+	chosen {
+		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/ram rdinit=/sbin/init";
+	};
+
+	memory {
+		reg = < 0x00000000 0x40000000 >;
+	};
+
+	serial@70006300 {
+		clock-frequency = < 216000000 >;
+	};
+
+	sdhci@c8000400 {
+		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
+		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
+		power-gpios = <&gpio 155 0>; /* gpio PT3 */
+	};
+
+	sdhci@c8000600 {
+		power-gpios = <&gpio 70 0>; /* gpio PI6 */
+		support-8bit;
+	};
+};
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index d82ebab..91aff7c 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -69,6 +69,12 @@ config MACH_WARIO
        help
          Support for the Wario version of Seaboard
 
+config MACH_VENTANA
+       bool "Ventana board"
+       select MACH_TEGRA_DT
+       help
+         Support for the nVidia Ventana development platform
+
 choice
         prompt "Low-level debug console UART"
         default TEGRA_DEBUG_UART_NONE
diff --git a/arch/arm/mach-tegra/Makefile.boot b/arch/arm/mach-tegra/Makefile.boot
index 5e870d2..bd12c9f 100644
--- a/arch/arm/mach-tegra/Makefile.boot
+++ b/arch/arm/mach-tegra/Makefile.boot
@@ -4,3 +4,4 @@ initrd_phys-$(CONFIG_ARCH_TEGRA_2x_SOC)	:= 0x00800000
 
 dtb-$(CONFIG_MACH_HARMONY) += tegra-harmony.dtb
 dtb-$(CONFIG_MACH_SEABOARD) += tegra-seaboard.dtb
+dtb-$(CONFIG_MACH_VENTANA) += tegra-ventana.dtb
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 9f47e04..80008e9 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -47,7 +47,7 @@
 
 void harmony_pinmux_init(void);
 void seaboard_pinmux_init(void);
-
+void ventana_pinmux_init(void);
 
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
@@ -80,9 +80,19 @@ static struct of_device_id tegra_dt_gic_match[] __initdata = {
 	{}
 };
 
+static struct {
+	char *machine;
+	void (*init)(void);
+} pinmux_configs[] = {
+	{ "nvidia,harmony", harmony_pinmux_init() },
+	{ "nvidia,seaboard", seaboard_pinmux_init() },
+	{ "nvidia,ventana", ventana_pinmux_init() },
+};
+
 static void __init tegra_dt_init(void)
 {
 	struct device_node *node;
+	int i;
 
 	node = of_find_matching_node_by_address(NULL, tegra_dt_gic_match,
 						TEGRA_ARM_INT_DIST_BASE);
@@ -91,10 +101,15 @@ static void __init tegra_dt_init(void)
 
 	tegra_clk_init_from_table(tegra_dt_clk_init_table);
 
-	if (of_machine_is_compatible("nvidia,harmony"))
-		harmony_pinmux_init();
-	else if (of_machine_is_compatible("nvidia,seaboard"))
-		seaboard_pinmux_init();
+	for (i = 0; i < ARRAY_SIZE(pinmux_configs); i++) {
+		if (of_machine_is_compatible(pinmux_configs[i].name)) {
+			pinmux_configs[i].init();
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(pinmux_configs))
+		printk(KERN_WARNING "Unknown platform! Pinmuxing not initialized\n");
 
 	/*
 	 * Finished with the static registrations now; fill in the missing
@@ -106,6 +121,7 @@ static void __init tegra_dt_init(void)
 static const char * tegra_dt_board_compat[] = {
 	"nvidia,harmony",
 	"nvidia,seaboard",
+	"nvidia,ventana",
 	NULL
 };
 
-- 
1.7.0.4

