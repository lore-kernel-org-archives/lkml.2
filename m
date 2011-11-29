Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1K2HCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 02:02:38 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:53275 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814Ab1K2HCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 02:02:37 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: benh@kernel.crashing.org
Cc: jwboyer@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH v2] powerpc/40x: Add APM8018X SOC support
Date: Tue, 29 Nov 2011 12:31:41 +0530
Message-Id: <1322550101-28520-1-git-send-email-tinamdar@apm.com>
X-Mailer: git-send-email 1.6.1.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AppliedMicro APM8018X embedded processor targets embedded applications that
require low power and a small footprint. It features a PowerPC 405 processor
core built in a 65nm low-power CMOS process with a five-stage pipeline executing
up to one instruction per cycle. The family has 128-kbytes of on-chip memory,
a 128-bit local bus and on-chip DDR2 SDRAM controller with 16-bit interface.

Features:
*CPU speed (frequency): up to 600 MHz
*Five-stage pipeline, executes up to one instruction per cycle
*16 KB-I/16 KB-D L1 caches, two-way set-associative
*128 KB on-chip memory
*128-bit processor local bus (PLB)
*Separate 128-bit read and 128-bit write data bus
*Up to 6.4 GBps of peak on-chip bandwidth at 200 MHz
*On-chip DDR2 SDRAM controller with 16-bit interface
*Support for one rank of DDR2 SDRAM up to 512 MB
*One Gen 1 single-lane PCI Express interface
*One Gen 1 single lane miniPCIe interface
*Configurable as root or endpoint
*One SATA controller operating at up to 3.0 Gbps with integrated SerDes
*Two Ethernet 10/100/1000 Mbps, full-duplex MACs (RGMII/TMII/MII)
*TCP/IP acceleration hardware, QoS, and jumbo frame support
*IEEE 1588 V1 and V2 support
*On-chip IPsec acceleration with header/trailer processing
*Supports DES, 3DES, and AES encryption
*Operates at 1.5/12/480 Mbps bus speeds

version 2:
	1. compressed defconfig.
	2. cleaned dts.
	3. cputable with single cpu entry instead of 4 similar entries.
	4. removed uart specific changes.

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/powerpc/boot/dts/klondike.dts          |  227 +++++++++++++++++++++++++++
 arch/powerpc/configs/40x/klondike_defconfig |   55 +++++++
 arch/powerpc/kernel/cputable.c              |   13 ++
 arch/powerpc/platforms/40x/Kconfig          |   11 ++
 arch/powerpc/platforms/40x/ppc40x_simple.c  |    1 +
 5 files changed, 307 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/klondike.dts
 create mode 100644 arch/powerpc/configs/40x/klondike_defconfig

diff --git a/arch/powerpc/boot/dts/klondike.dts b/arch/powerpc/boot/dts/klondike.dts
new file mode 100644
index 0000000..8c94290
--- /dev/null
+++ b/arch/powerpc/boot/dts/klondike.dts
@@ -0,0 +1,227 @@
+/*
+ * Device Tree for Klondike (APM8018X) board.
+ *
+ * Copyright (c) 2010, Applied Micro Circuits Corporation
+ * Author: Tanmay Inamdar <tinamdar@apm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+/dts-v1/;
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	model = "apm,klondike";
+	compatible = "apm,klondike";
+	dcr-parent = <&{/cpus/cpu@0}>;
+
+	aliases {
+		ethernet0 = &EMAC0;
+		ethernet1 = &EMAC1;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			model = "PowerPC,apm8018x";
+			reg = <0x00000000>;
+			clock-frequency = <300000000>; /* Filled in by U-Boot */
+			timebase-frequency = <300000000>; /* Filled in by U-Boot */
+			i-cache-line-size = <32>;
+			d-cache-line-size = <32>;
+			i-cache-size = <16384>; /* 16 kB */
+			d-cache-size = <16384>; /* 16 kB */
+			dcr-controller;
+			dcr-access-method = "native";
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x20000000>; /* Filled in by U-Boot */
+	};
+
+	UIC0: interrupt-controller {
+		compatible = "ibm,uic";
+		interrupt-controller;
+		cell-index = <0>;
+		dcr-reg = <0x0c0 0x010>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#interrupt-cells = <2>;
+	};
+
+	UIC1: interrupt-controller1 {
+		compatible = "ibm,uic";
+		interrupt-controller;
+		cell-index = <1>;
+		dcr-reg = <0x0d0 0x010>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#interrupt-cells = <2>;
+		interrupts = <0x1e 0x4 0x1f 0x4>; /* cascade */
+		interrupt-parent = <&UIC0>;
+	};
+
+	UIC2: interrupt-controller2 {
+		compatible = "ibm,uic";
+		interrupt-controller;
+		cell-index = <2>;
+		dcr-reg = <0x0e0 0x010>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#interrupt-cells = <2>;
+		interrupts = <0x0a 0x4 0x0b 0x4>; /* cascade */
+		interrupt-parent = <&UIC0>;
+	};
+
+	UIC3: interrupt-controller3 {
+		compatible = "ibm,uic";
+		interrupt-controller;
+		cell-index = <3>;
+		dcr-reg = <0x0f0 0x010>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#interrupt-cells = <2>;
+		interrupts = <0x10 0x4 0x11 0x4>; /* cascade */
+		interrupt-parent = <&UIC0>;
+	};
+
+	plb {
+		compatible = "ibm,plb4";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		clock-frequency = <0>; /* Filled in by U-Boot */
+
+		SDRAM0: memory-controller {
+			compatible = "ibm,sdram-apm8018x";
+			dcr-reg = <0x010 0x002>;
+		};
+
+		MAL0: mcmal {
+			compatible = "ibm,mcmal2";
+			dcr-reg = <0x180 0x062>;
+			num-tx-chans = <2>;
+			num-rx-chans = <16>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-parent = <&UIC1>;
+			interrupts = </*TXEOB*/   0x6 0x4
+					/*RXEOB*/ 0x7 0x4
+					/*SERR*/  0x1 0x4
+					/*TXDE*/  0x2 0x4
+					/*RXDE*/  0x3 0x4>;
+		};
+
+		POB0: opb {
+			compatible = "ibm,opb";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x20000000 0x20000000 0x30000000
+				  0x50000000 0x50000000 0x10000000
+				  0x60000000 0x60000000 0x10000000
+				  0xFE000000 0xFE000000 0x00010000>;
+			dcr-reg = <0x100 0x020>;
+			clock-frequency = <300000000>; /* Filled in by U-Boot */
+
+			RGMII0: emac-rgmii@400a2000 {
+				compatible = "ibm,rgmii";
+				reg = <0x400a2000 0x00000010>;
+				has-mdio;
+			};
+
+			TAH0: emac-tah@400a3000 {
+				compatible = "ibm,tah";
+				reg = <0x400a3000 0x100>;
+			};
+
+			TAH1: emac-tah@400a4000 {
+				compatible = "ibm,tah";
+				reg = <0x400a4000 0x100>;
+			};
+
+			EMAC0: ethernet@400a0000 {
+				compatible = "ibm,emac4", "ibm-emac4sync";
+				interrupt-parent = <&EMAC0>;
+				interrupts = <0x0>;
+				#interrupt-cells = <1>;
+				#address-cells = <0>;
+				#size-cells = <0>;
+				interrupt-map = </*Status*/ 0x0 &UIC0 0x13 0x4>;
+				reg = <0x400a0000 0x00000100>;
+				local-mac-address = [000000000000]; /* Filled in by U-Boot */
+				mal-device = <&MAL0>;
+				mal-tx-channel = <0x0>;
+				mal-rx-channel = <0x0>;
+				cell-index = <0>;
+				max-frame-size = <9000>;
+				rx-fifo-size = <4096>;
+				tx-fifo-size = <2048>;
+				phy-mode = "rgmii";
+				phy-address = <0x2>;
+				turbo = "no";
+				phy-map = <0x00000000>;
+				rgmii-device = <&RGMII0>;
+				rgmii-channel = <0>;
+				tah-device = <&TAH0>;
+				tah-channel = <0>;
+				has-inverted-stacr-oc;
+				has-new-stacr-staopc;
+			};
+
+			EMAC1: ethernet@400a1000 {
+				compatible = "ibm,emac4", "ibm-emac4sync";
+				status = "disabled";
+				interrupt-parent = <&EMAC1>;
+				interrupts = <0x0>;
+				#interrupt-cells = <1>;
+				#address-cells = <0>;
+				#size-cells = <0>;
+				interrupt-map = </*Status*/ 0x0 &UIC0 0x14 0x4>;
+				reg = <0x400a1000 0x00000100>;
+				local-mac-address = [000000000000]; /* Filled in by U-Boot */
+				mal-device = <&MAL0>;
+				mal-tx-channel = <1>;
+				mal-rx-channel = <8>;
+				cell-index = <1>;
+				max-frame-size = <9000>;
+				rx-fifo-size = <4096>;
+				tx-fifo-size = <2048>;
+				phy-mode = "rgmii";
+				phy-address = <0x3>;
+				turbo = "no";
+				phy-map = <0x00000000>;
+				rgmii-device = <&RGMII0>;
+				rgmii-channel = <1>;
+				tah-device = <&TAH1>;
+				tah-channel = <0>;
+				has-inverted-stacr-oc;
+				has-new-stacr-staopc;
+				mdio-device = <&EMAC0>;
+			};
+		};
+	};
+
+	chosen {
+		linux,stdout-path = "/plb/opb/serial@50001000";
+	};
+};
diff --git a/arch/powerpc/configs/40x/klondike_defconfig b/arch/powerpc/configs/40x/klondike_defconfig
new file mode 100644
index 0000000..c0d228d
--- /dev/null
+++ b/arch/powerpc/configs/40x/klondike_defconfig
@@ -0,0 +1,55 @@
+CONFIG_40x=y
+CONFIG_EXPERIMENTAL=y
+CONFIG_SYSVIPC=y
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_EMBEDDED=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_WALNUT is not set
+CONFIG_APM8018X=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_MATH_EMULATION=y
+# CONFIG_MIGRATION is not set
+# CONFIG_SUSPEND is not set
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_PROC_DEVICETREE=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=35000
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_CHR_DEV_SG=y
+CONFIG_SCSI_SAS_ATTRS=y
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_UNIX98_PTYS is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_DEVKMEM is not set
+# CONFIG_HW_RANDOM is not set
+# CONFIG_HWMON is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_IOMMU_SUPPORT is not set
+CONFIG_EXT2_FS=y
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT4_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_TMPFS=y
+CONFIG_CRAMFS=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ASCII=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_UTF8=y
+CONFIG_AVERAGE=y
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+# CONFIG_FTRACE is not set
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index edae5bb..ce59693 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -1505,6 +1505,19 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.machine_check		= machine_check_4xx,
 		.platform		= "ppc405",
 	},
+	{	/* APM8018X */
+		.pvr_mask		= 0xffff0000,
+		.pvr_value		= 0x7ff11432,
+		.cpu_name		= "APM8018X",
+		.cpu_features		= CPU_FTRS_40X,
+		.cpu_user_features	= PPC_FEATURE_32 |
+			PPC_FEATURE_HAS_MMU | PPC_FEATURE_HAS_4xxMAC,
+		.mmu_features		= MMU_FTR_TYPE_40x,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.machine_check		= machine_check_4xx,
+		.platform		= "ppc405",
+	},
 	{	/* default match */
 		.pvr_mask		= 0x00000000,
 		.pvr_value		= 0x00000000,
diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index 1530229..8883f2c 100644
--- a/arch/powerpc/platforms/40x/Kconfig
+++ b/arch/powerpc/platforms/40x/Kconfig
@@ -186,3 +186,14 @@ config IBM405_ERR51
 #	bool
 #	depends on !STB03xxx && PPC4xx_DMA
 #	default y
+#
+
+config APM8018X
+	bool "APM8018X"
+	depends on 40x
+	default n
+	select PPC40x_SIMPLE
+	help
+	  This option enables support for the AppliedMicro APM8018X evaluation
+	  board.
+
diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
index e8dd5c5..2f8fde6 100644
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -55,6 +55,7 @@ static const char *board[] __initdata = {
 	"amcc,haleakala",
 	"amcc,kilauea",
 	"amcc,makalu",
+	"apm,klondike",
 	"est,hotfoot"
 };
 
-- 
1.6.1.rc3

