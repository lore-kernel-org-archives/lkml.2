Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab1I0RLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:11:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2209 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1I0RLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:11:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 27 Sep 2011 10:10:49 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v2 3/3] arm/tegra: device tree support for ventana board
Date: Tue, 27 Sep 2011 20:10:21 +0300
Message-ID: <1317143421-27286-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1317143421-27286-1-git-send-email-pdeschrijver@nvidia.com>
References: <1317143421-27286-1-git-send-email-pdeschrijver@nvidia.com>
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
 arch/arm/mach-tegra/board-dt.c      |    5 ++++-
 4 files changed, 43 insertions(+), 1 deletions(-)
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
index 9f47e04..5885102 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -47,7 +47,7 @@
 
 void harmony_pinmux_init(void);
 void seaboard_pinmux_init(void);
-
+void ventana_pinmux_init(void);
 
 struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
@@ -95,6 +95,8 @@ static void __init tegra_dt_init(void)
 		harmony_pinmux_init();
 	else if (of_machine_is_compatible("nvidia,seaboard"))
 		seaboard_pinmux_init();
+	else if (of_machine_is_compatible("nvidia,ventana"))
+		ventana_pinmux_init();
 
 	/*
 	 * Finished with the static registrations now; fill in the missing
@@ -106,6 +108,7 @@ static void __init tegra_dt_init(void)
 static const char * tegra_dt_board_compat[] = {
 	"nvidia,harmony",
 	"nvidia,seaboard",
+	"nvidia,ventana",
 	NULL
 };
 
-- 
1.7.0.4

