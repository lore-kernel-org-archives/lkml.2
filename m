Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1KWJpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 04:45:04 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:50482 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752287Ab1KWJo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 04:44:57 -0500
From: Tanmay Inamdar <tinamdar@apm.com>
To: jwboyer@gmail.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Tanmay Inamdar <tinamdar@apm.com>
Subject: [PATCH] powerpc/40x: Add APM8018X SOC support
Date: Wed, 23 Nov 2011 15:14:24 +0530
Message-Id: <1322041464-20605-1-git-send-email-tinamdar@apm.com>
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

Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
---
 arch/powerpc/Kconfig                        |    6 +
 arch/powerpc/boot/dcr.h                     |    6 +
 arch/powerpc/boot/dts/klondike.dts          |  668 +++++++++++++
 arch/powerpc/configs/40x/klondike_defconfig | 1353 +++++++++++++++++++++++++++
 arch/powerpc/include/asm/dcr-regs.h         |   20 +
 arch/powerpc/kernel/cputable.c              |   52 +
 arch/powerpc/kernel/udbg_16550.c            |   22 +
 arch/powerpc/platforms/40x/Kconfig          |   11 +
 arch/powerpc/platforms/40x/ppc40x_simple.c  |    4 +-
 9 files changed, 2141 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/klondike.dts
 create mode 100644 arch/powerpc/configs/40x/klondike_defconfig

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b177caa..3f2cc36 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -978,3 +978,9 @@ config PPC_LIB_RHEAP
 	bool
 
 source "arch/powerpc/kvm/Kconfig"
+
+config UART_16550_WORD_ADDRESSABLE
+	bool
+	default n
+	help
+	   Enable this if your UART 16550 is word addressable.
diff --git a/arch/powerpc/boot/dcr.h b/arch/powerpc/boot/dcr.h
index 645a7c9..6dd498f 100644
--- a/arch/powerpc/boot/dcr.h
+++ b/arch/powerpc/boot/dcr.h
@@ -132,9 +132,15 @@ static const unsigned long sdram_bxcr[] = { SDRAM0_B0CR, SDRAM0_B1CR,
 #define DCRN_MAL0_CFG					0x180
 #define MAL_RESET 0x80000000
 
+#if defined(CONFIG_APM8018X)
+#define DCRN_CPR0_ADDR	0xa
+#define DCRN_CPR0_DATA	0xb
+#else
 /* 440EP Clock/Power-on Reset regs */
 #define DCRN_CPR0_ADDR	0xc
 #define DCRN_CPR0_DATA	0xd
+#endif /* CONFIG_APM8018X */
+
 #define CPR0_PLLD0	0x60
 #define CPR0_OPBD0	0xc0
 #define CPR0_PERD0	0xe0
diff --git a/arch/powerpc/boot/dts/klondike.dts b/arch/powerpc/boot/dts/klondike.dts
new file mode 100644
index 0000000..9372a52
--- /dev/null
+++ b/arch/powerpc/boot/dts/klondike.dts
@@ -0,0 +1,668 @@
+/*
+ * Device Tree Source for AMCC Klondike (405)
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
+	model = "amcc,klondike";
+	compatible = "amcc,klondike";
+	dcr-parent = <&{/cpus/cpu@0}>;
+
+	aliases {
+		ethernet0 = &EMAC0;
+		ethernet1 = &EMAC1;
+		serial0 = &UART0;
+		serial1 = &UART1;
+	};
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@0 {
+			device_type = "cpu";
+			model = "PowerPC,405EX";
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
+		compatible = "ibm,uic-405ex", "ibm,uic";
+		interrupt-controller;
+		cell-index = <0>;
+		dcr-reg = <0x0c0 0x010>;
+		#address-cells = <0>;
+		#size-cells = <0>;
+		#interrupt-cells = <2>;
+	};
+
+	UIC1: interrupt-controller1 {
+		compatible = "ibm,uic-405ex","ibm,uic";
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
+		compatible = "ibm,uic-405ex","ibm,uic";
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
+		compatible = "ibm,uic-405ex","ibm,uic";
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
+	OCM: ocm@20000000 {
+		compatible = "ibm,ocm";
+		status = "enabled";
+		cell-index = <1>;
+		reg = < 0x20000000 0x1f000   /* 128K - 4K NAND */
+			0xfffe0000 0x1f000>; /* 128K - 4K I2C  */
+		bootmode = "nand";
+	};
+
+	plb {
+		compatible = "ibm,plb-405ex", "ibm,plb4";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+		clock-frequency = <0>; /* Filled in by U-Boot */
+
+		SDRAM0: memory-controller {
+			compatible = "ibm,sdram-405ex", "ibm,sdram-4xx-ddr2";
+			dcr-reg = <0x010 0x002>;
+			interrupt-parent = <&UIC2>;
+			interrupts = <0x5 0x4	/* ECC DED Error */
+				      0x6 0x4>;	/* ECC SEC Error */
+		};
+		crypto: crypto@40000000 {
+			device_type = "crypto";
+			compatible = "405ex-crypto", "amcc,ppc405ex-crypto", "amcc,ppc4xx-crypto";
+			reg = <0x40000000 0x00080000>; /* 512KB */
+			interrupt-parent = <&UIC0>;
+			interrupts = <0x19 0x4>;
+		};
+		EDMA: edma@40080000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "amcc,edma";
+			device_type = "dma";
+			/*complQ-fifo-memory = "ocm";*/
+			cell-index = <0>;
+			reg = <0x40080000 0x00010000>;
+			dcr-reg = <0x060 0x09f>;
+
+			interrupt-parent = <&UIC0>;
+			interrupts = </*complQ A */  0x4 4
+					/*EDMA Err */  0x6 4 >;
+
+			dma-channel@0 {
+				compatible = "amcc,edma-channel";
+				/*descriptor-memory = "ocm";*/
+				cell-index = <0>;
+				dcr-reg = <0x0000006a 0x0000006b>;
+			};
+		};
+
+		MAL0: mcmal {
+			compatible = "ibm,mcmal-405ex", "ibm,mcmal2";
+			descriptor-memory = "ocm";
+			dcr-reg = <0x180 0x062>;
+			num-tx-chans = <2>;
+			num-rx-chans = <16>;
+			interrupt-parent = <&MAL0>;
+			interrupts = <0x0 0x1 0x2 0x3 0x4 0x5 0x6 0x7 0x8>;
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-map = </*TXEOB*/ 0x0 &UIC1 0x6 0x4
+					/*RXEOB*/ 0x1 &UIC1 0x7 0x4
+					/*SERR*/  0x2 &UIC1 0x1 0x4
+					/*TXDE*/  0x3 &UIC1 0x2 0x4
+					/*RXDE*/  0x4 &UIC1 0x3 0x4
+					/*TX0 COAL*/  0x5 &UIC1 0x18 0x2
+					/*TX1 COAL*/  0x6 &UIC1 0x19 0x2
+					/*RX0 COAL*/  0x7 &UIC1 0x1a 0x2
+					/*RX1 COAL*/  0x8 &UIC1 0x1b 0x2 >;
+			interrupt-map-mask = <0xffffffff>;
+		};
+
+		MSI: dwc_pcie-msi@40090000 {
+			compatible = "amcc,dwc_pcie-msi", "dwc_pcie-msi";
+			status = "ok";
+			reg = <0x40090000 0x100>;
+			interrupts =<0x0 0x1 0x2 0x3>;
+			interrupt-parent = <&MSI>;
+			#interrupt-cells = <1>;
+			#address-cells = <0>;
+			#size-cells = <0>;
+			interrupt-map = <0x0 &UIC0 0x0C 0x1
+					 0x1 &UIC0 0x0D 0x1
+					 0x2 &UIC0 0x0E 0x1
+					 0x3 &UIC0 0x0F 0x1>;
+		};
+
+		AHB: ahb {
+			device_type = "ahb";
+			compatible = "amcc,405ex-ahb", "ibm,ahb";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			clock-frequency = <0>; /* Filled in by U-Boot */
+
+			lcd: lcd@58060000 {
+				device_type = "lcd";
+				compatible = "apm,apm-lcd","apm,db9000";
+				version = "apm-1.1";
+				reg = <0x58060000 0x00001000>;
+				interrupt-parent = <&UIC0>;
+				/*
+				 * interrupt index 0 for chip 1.0
+				 * interrupt index 1 for chip 1.1
+				 */
+				interrupts = <0x1c 2 0x1c 4>;
+			};
+
+			sdhc0: sdhc@58050000 {
+				device_type = "sdhc";
+				compatible = "amcc,ahb-sdhc";
+				#interrupt-cells = <1>;
+			       	reg = <0x58050000 0x100>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x18 0x4>;
+				bootmode = "i2c";
+			};
+
+			tdm0: tdm@58010000 {
+				device_type = "tdm";
+				status = "disabled";
+				compatible = "apm,ahb-tdm";
+				#interrupt-cells = <1>;
+				reg = <0x58010000 0x100>;
+				interrupt-parent = <&UIC1>;
+				interrupts = <0x15 0x1>;
+			};
+
+			usbotg0: usbotg@58080000 {
+				device_type = "usb";
+				compatible = "apm,usb-otg";
+				reg = <0x58080000 0x10000>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x1B 4>;
+				mode = "host";
+			};
+			spi0: spi@50000000 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				device_type = "spi";
+				compatible = "apm,apm-spi";
+				reg = <0x50000000 0x100>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x7 1>;  /* interrupt number->0x7 Polarity->HIGH Sensitivity->LEVEL */
+				half_duplex = <0x1>;   /*0 = rx/tx mode, 1 = eprom read mode */
+				sysclk = <100000000>;   /* input clock */
+				bus_num = <0x0>;       /* SPI = 0 */
+
+				m25p80@0 {
+					cell-index = <0>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					compatible = "stm,m25p80", "jedec-flash";
+					reg = <0>;
+					spi-max-frequency = <4000000>;
+					spi-cpha;
+					spi-cpol;
+
+					partition@0x00000000 {
+						label = "m25p80-u-boot";
+						reg = <0x00000000 0x00080000>; /* 512KB */
+					};
+					partition@0x00080000 {
+						label = "m25p80-u-boot-env";
+						reg = <0x00080000 0x00080000>; /* 512KB */
+					};
+					partition@0x00100000 {
+						label = "m25p80-kernel";
+						reg = <0x00100000 0x00300000>; /* 3MB */
+					};
+					partition@0x00400000 {
+						label = "m25p80-dtb";
+						reg = <0x00400000 0x00100000>; /* 1MB */
+					};
+					partition@0x00500000 {
+						label = "m25p80-ramdisk";
+						reg = <0x00500000 0x00B00000>; /* 11MB */
+					};
+				};
+
+					mt29f@0 {
+						status = "ok";
+						cell-index = <0>;
+						#address-cells = <1>;
+						#size-cells = <0>;
+						compatible = "micron,mt29f";
+						reg = <1>;
+						spi-max-frequency = <4000000>;
+						spi-cpha;
+						spi-cpol;
+
+						partition@0x00000000 {
+							label = "mt29f-u-boot";
+							reg = <0x00000000 0x00080000>; /* 512KB */
+						};
+						partition@0x00080000 {
+							label = "mt29f-u-boot-env";
+							reg = <0x00080000 0x00080000>; /* 512KB */
+						};
+						partition@0x00100000 {
+							label = "mt29f-kernel";
+							reg = <0x00100000 0x00300000>; /* 3MB */
+						};
+						partition@0x00400000 {
+							label = "mt29f-dtb";
+							reg = <0x00400000 0x00100000>; /* 1MB */
+						};
+						partition@0x00500000 {
+							label = "mt29f-ramdisk";
+							reg = <0x00500000 0x01900000>; /* 25MB */
+						};
+						partition@0x01e00000 {
+							label = "mt29f-data";
+							reg = <0x01e00000 0x06200000>; /* 98MB */
+						};
+					};
+			};
+
+			PCIE0: pciex@58020000 {
+				device_type = "pci";
+				compatible = "ibm,plb-pciex", "dwc-pciex", "amcc,dwc-pciex";
+				#interrupt-cells = <1>;
+				#size-cells = <2>;
+				#address-cells = <3>;
+				primary;
+				port = <0>; /* port number */
+				status = "ok";
+
+				reg = < 0xa0000000 0x01000000 /* CFG Region Space */
+					0x58020000 0x8000>;   /* CSR registers */
+
+				/* Outbound ranges, two memory and one IO,
+				 * <type> <pci> <cpu> <size>
+				 */
+
+				ranges = <0x02000000 0x0 0x80000000 0x70000000 0x0 0x10000000
+					  0x01000000 0x0 0x00000000 0x80000000 0x0 0x00010000>;
+
+				/* Inbound 512MB range starting at 0
+				 * <type> <pci> <cpu> <size>
+				 */
+				dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x80000000>;
+
+				/* This drives busses 0 to 0x10 */
+				bus-range = <0x0 0x0f>;
+
+				/* Legacy interrupts (note the weird polarity, the bridge seems
+				 * to invert PCIe legacy interrupts).
+				 * We are de-swizzling here because the numbers are actually for
+				 * port of the root complex virtual P2P bridge. But I want
+				 * to avoid putting a node for it in the tree, so the numbers
+		 		 * below are basically de-swizzled numbers.
+				 * The real slot is on idsel 0, so the swizzling is 1:1
+				 */
+				interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+				interrupt-map = <
+					0x0 0x0 0x0 0x1 &UIC2 0x2 0x4 /* swizzled int A */
+					0x0 0x0 0x0 0x2 &UIC2 0x3 0x4 /* swizzled int B */
+					0x0 0x0 0x0 0x3 &UIC2 0x4 0x4 /* swizzled int C */
+					0x0 0x0 0x0 0x4 &UIC2 0x5 0x4 /* swizzled int D */>;
+			};
+
+			PCIE1: pciex@58030000 {
+				device_type = "pci";
+				compatible = "ibm,plb-pciex", "dwc-pciex", "amcc,dwc-pciex";
+				#interrupt-cells = <1>;
+				#size-cells = <2>;
+				#address-cells = <3>;
+				primary;
+				port = <1>; /* port number */
+				status = "disabled";
+
+				reg = < 0xe0000000 0x01000000 /* CFG Region Space */
+					0x58030000 0x8000>;   /* CSR registers */
+
+				/* Outbound ranges, one memory and one IO,
+				 * <type> <pci> <cpu> <size>
+				 */
+
+				ranges = <0x02000000 0x0 0x80000000 0xB0000000 0x0 0x10000000
+					  0x01000000 0x0 0x00000000 0xC0000000 0x0 0x00010000>;
+
+				/* Inbound 512MB range starting at 0
+				 * <type> <pci> <cpu> <size>
+				 */
+				dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x80000000>;
+
+				/* This drives busses 10 to 0x1f */
+				bus-range = <0x10 0x1f>;
+
+				/* Legacy interrupts (note the weird polarity, the bridge seems
+				 * to invert PCIe legacy interrupts).
+				 * We are de-swizzling here because the numbers are actually for
+				 * port of the root complex virtual P2P bridge. But I want
+				 * to avoid putting a node for it in the tree, so the numbers
+		 		 * below are basically de-swizzled numbers.
+				 * The real slot is on idsel 0, so the swizzling is 1:1
+				 */
+				interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+				interrupt-map = <
+					0x0 0x0 0x0 0x1 &UIC2 0xa 0x1 /* swizzled int A */
+					0x0 0x0 0x0 0x2 &UIC2 0xb 0x2 /* swizzled int B */
+					0x0 0x0 0x0 0x3 &UIC2 0xc 0x4 /* swizzled int C */
+					0x0 0x0 0x0 0x4 &UIC2 0xd 0x2 /* swizzled int D */>;
+			};
+
+			sata@58040000 {
+				compatible = "sata-ahci";
+				reg =  <0x58040000 0x2000>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x1a 1>;
+			};
+
+
+			gpio@5000a000 {
+				compatible = "dwc,gpio";
+				reg = <0x5000a000 0x80>;
+			};
+
+			gpt@50007000 {
+				compatible = "dwc,gpt";
+				reg = <0x50007000 0xff>;
+				interrupt-parent = <&UIC1>;
+				interrupts = <
+						0x0c 1
+						0x0d 1
+						0x0e 1
+						0x0f 1
+						0x10 1
+						0x11 1
+						0x12 1
+					 >;
+			};
+		};
+
+		POB0: opb {
+			compatible = "ibm,opb-405ex", "ibm,opb";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges = <0x20000000 0x20000000 0x30000000
+				  0x50000000 0x50000000 0x10000000
+				  0x60000000 0x60000000 0x10000000
+				  0xFE000000 0xFE000000 0x00010000>;
+			dcr-reg = <0x100 0x020>;
+			clock-frequency = <300000000>; /* Filled in by U-Boot */
+
+			EBC0: ebc {
+				compatible = "ibm,ebc-405ex", "ibm,ebc";
+				dcr-reg = <0x012 0x002>;
+				#address-cells = <1>;
+				#size-cells = <1>;
+				clock-frequency = <3000000000>; /* Filled in by U-Boot */
+				/* ranges property is supplied by U-Boot */
+				ranges = <0xFE000000 0xFE000000 0x00010000>;
+				interrupts = <0x5 0x1>;
+				interrupt-parent = <&UIC1>;
+
+				ufc@0xFE000000 {
+					compatible = "ibm,ufc";
+					reg = <0xFE000000 0x00010000>;
+					#address-cells = <1>;
+					#size-cells = <1>;
+					bootmode = "nand";
+					nand {
+						#address-cells = <1>;
+						#size-cells = <1>;
+						partition@0x00000000 {
+							label = "ufc-u-boot";
+							reg = <0x00000000 0x00080000>; /* 512 KB */
+						};
+						partition@0x00080000 {
+							label = "ufc-u-boot-env";
+							reg = <0x00080000 0x00080000>; /* 512 KB */
+						};
+						partition@0x200000 {
+							label = "ufc-kernel";
+							reg = <0x00100000 0x00300000>; /* 3 MB */
+						};
+						partition@0x00480000 {
+							label = "ufc-dtb";
+							reg = <0x00400000 0x00100000>; /* 1 MB */
+						};
+						partition@0x00500000 {
+							label = "ufc-ramdisk";
+							reg = <0x00500000 0x01900000>; /* 25 MB */
+						};
+						partition@0x01e00000 {
+							label = "ufc-jffs2-0";
+							reg = <0x01e00000 0x0e200000>; /* 226 MB */
+						};
+					};
+				};
+			};
+
+			UART0: serial@50001000 {
+				device_type = "serial";
+				compatible = "ns16550";
+				reg = <0x50001000 0x00000100>;
+				virtual-reg = <0x50001000>;
+				clock-frequency = <300000000>; /* Filled in by U-Boot */
+				current-speed = <115200>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x0 0x4>;
+				/*reg-shift = <2>;*/
+			};
+
+
+			UART1: serial@50002000 {
+				device_type = "serial";
+				compatible = "ns16550";
+				reg = <0x50002000 0x00000100>;
+				virtual-reg = <0x50002000>;
+				clock-frequency = <300000000>; /* Filled in by U-Boot */
+				current-speed = <115200>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x1 0x4>;
+				/*reg-shift = <2>;*/
+			};
+
+
+			IIC0: i2c@50005000 {
+				status = "ok";
+				compatible = "dw,i2c", "amcc,dw-i2c";
+				reg = <0x50005000 0x00000100>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x2 0x4>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				rtc@68 {
+					compatible = "stm,m41t80";
+					reg = <0x68>;
+				};
+			};
+
+			IIC1: i2c@50006000 {
+				status = "ok";
+				compatible = "dw,i2c", "amcc,dw-i2c";
+				reg = <0x50006000 0x00000100>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x3 0x4>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				eeprom@54 {
+					compatible = "eeprom";
+					reg = <0x54>;
+				};
+			};
+
+			RGMII0: emac-rgmii@400a2000 {
+				compatible = "ibm,rgmii-460sx", "ibm,rgmii";
+				reg = <0x400a2000 0x00000010>;
+				has-mdio;
+			};
+
+			EMAC0: ethernet@400a0000 {
+				device_type = "network";
+				compatible = "ibm,emac-460sx", "ibm,emac4", "ibm-emac4sync";
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
+				device_type = "network";
+				compatible = "ibm,emac-460sx", "ibm,emac4", "ibm-emac4sync";
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
+
+			TAH0: emac-tah@400a3000 {
+				compatible = "ibm,tah-460sx", "ibm,tah";
+				reg = <0x400a3000 0x100>;
+			};
+
+			TAH1: emac-tah@400a4000 {
+				compatible = "ibm,tah-460sx", "ibm,tah";
+				reg = <0x400a4000 0x100>;
+			};
+
+			IEEE1588_0: ieee1588ts0@400a5000 {
+				status = "ok";
+				compatible = "ieee1588-ts";
+				reg = <0x400a5000 0x400>;
+				interrupt-parent = <&UIC1>;
+				interrupts = <0x1e 0x1 0x1c 0x1>;
+			};
+
+			IEEE1588_1: ieee1588ts1@400a7000 {
+				status = "disabled";  /* Enabled by U-boot */
+				compatible = "ieee1588-ts";
+				reg = <0x400a7000 0x400>;
+				interrupt-parent = <&UIC1>;
+				interrupts = <0x1f 0x1 0x1d 0x1>;
+			};
+
+			ADC: adc@50009000 {
+				compatible = "adc405ex", "amcc,adc405ex";
+				reg = <0x50009000 0x80>;
+				channels = <3>;
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x8 0x1>;
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
index 0000000..840f438
--- /dev/null
+++ b/arch/powerpc/configs/40x/klondike_defconfig
@@ -0,0 +1,1353 @@
+#
+# Automatically generated file; DO NOT EDIT.
+# Linux/powerpc 3.2.0-rc2 Kernel Configuration
+#
+# CONFIG_PPC64 is not set
+
+#
+# Processor support
+#
+# CONFIG_PPC_BOOK3S_32 is not set
+# CONFIG_PPC_85xx is not set
+# CONFIG_PPC_8xx is not set
+CONFIG_40x=y
+# CONFIG_44x is not set
+# CONFIG_E200 is not set
+CONFIG_4xx=y
+CONFIG_PPC_MMU_NOHASH=y
+# CONFIG_PPC_MM_SLICES is not set
+CONFIG_NOT_COHERENT_CACHE=y
+CONFIG_PPC32=y
+CONFIG_32BIT=y
+CONFIG_WORD_SIZE=32
+# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
+# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
+CONFIG_MMU=y
+CONFIG_GENERIC_CMOS_UPDATE=y
+CONFIG_GENERIC_TIME_VSYSCALL=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
+# CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK is not set
+CONFIG_NR_IRQS=512
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_HAVE_LATENCYTOP_SUPPORT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_RWSEM_XCHGADD_ALGORITHM=y
+CONFIG_ARCH_HAS_ILOG2_U32=y
+CONFIG_GENERIC_HWEIGHT=y
+# CONFIG_ARCH_NO_VIRT_TO_BUS is not set
+CONFIG_PPC=y
+CONFIG_EARLY_PRINTK=y
+CONFIG_GENERIC_NVRAM=y
+CONFIG_SCHED_OMIT_FRAME_POINTER=y
+CONFIG_ARCH_MAY_HAVE_PC_FDC=y
+CONFIG_PPC_OF=y
+CONFIG_PPC_UDBG_16550=y
+# CONFIG_GENERIC_TBSYNC is not set
+CONFIG_AUDIT_ARCH=y
+CONFIG_GENERIC_BUG=y
+# CONFIG_EPAPR_BOOT is not set
+# CONFIG_DEFAULT_UIMAGE is not set
+CONFIG_ARCH_HIBERNATION_POSSIBLE=y
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+CONFIG_PPC_DCR_NATIVE=y
+# CONFIG_PPC_DCR_MMIO is not set
+CONFIG_PPC_DCR=y
+CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
+CONFIG_PPC_ADV_DEBUG_REGS=y
+CONFIG_PPC_ADV_DEBUG_IACS=2
+CONFIG_PPC_ADV_DEBUG_DACS=2
+CONFIG_PPC_ADV_DEBUG_DVCS=0
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_HAVE_IRQ_WORK=y
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_CROSS_COMPILE=""
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_DEFAULT_HOSTNAME="(none)"
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_POSIX_MQUEUE_SYSCTL=y
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_FHANDLE is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_AUDIT is not set
+CONFIG_HAVE_GENERIC_HARDIRQS=y
+
+#
+# IRQ subsystem
+#
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_HAVE_SPARSE_IRQ=y
+CONFIG_GENERIC_IRQ_SHOW=y
+CONFIG_GENERIC_IRQ_SHOW_LEVEL=y
+# CONFIG_SPARSE_IRQ is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_TINY_RCU=y
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_RCU_TRACE is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+# CONFIG_NAMESPACES is not set
+# CONFIG_SCHED_AUTOGROUP is not set
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+# CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+# CONFIG_RD_BZIP2 is not set
+# CONFIG_RD_LZMA is not set
+# CONFIG_RD_XZ is not set
+# CONFIG_RD_LZO is not set
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
+CONFIG_EXPERT=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_ALL is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+CONFIG_SHMEM=y
+CONFIG_AIO=y
+CONFIG_EMBEDDED=y
+CONFIG_HAVE_PERF_EVENTS=y
+
+#
+# Kernel Performance Events And Counters
+#
+# CONFIG_PERF_EVENTS is not set
+# CONFIG_PERF_COUNTERS is not set
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_PCI_QUIRKS=y
+CONFIG_COMPAT_BRK=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_KPROBES is not set
+# CONFIG_JUMP_LABEL is not set
+CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
+CONFIG_HAVE_IOREMAP_PROT=y
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_ARCH_TRACEHOOK=y
+CONFIG_HAVE_DMA_ATTRS=y
+CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
+CONFIG_HAVE_DMA_API_DEBUG=y
+CONFIG_HAVE_ARCH_JUMP_LABEL=y
+CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
+
+#
+# GCOV-based kernel profiling
+#
+# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+# CONFIG_MODULE_FORCE_LOAD is not set
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_BLOCK=y
+CONFIG_LBDAF=y
+CONFIG_BLK_DEV_BSG=y
+# CONFIG_BLK_DEV_BSGLIB is not set
+# CONFIG_BLK_DEV_INTEGRITY is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+# CONFIG_INLINE_SPIN_TRYLOCK is not set
+# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK is not set
+# CONFIG_INLINE_SPIN_LOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
+CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
+CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
+# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_READ_TRYLOCK is not set
+# CONFIG_INLINE_READ_LOCK is not set
+# CONFIG_INLINE_READ_LOCK_BH is not set
+# CONFIG_INLINE_READ_LOCK_IRQ is not set
+# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
+CONFIG_INLINE_READ_UNLOCK=y
+# CONFIG_INLINE_READ_UNLOCK_BH is not set
+CONFIG_INLINE_READ_UNLOCK_IRQ=y
+# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_WRITE_TRYLOCK is not set
+# CONFIG_INLINE_WRITE_LOCK is not set
+# CONFIG_INLINE_WRITE_LOCK_BH is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
+CONFIG_INLINE_WRITE_UNLOCK=y
+# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
+CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
+# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
+# CONFIG_MUTEX_SPIN_ON_OWNER is not set
+CONFIG_FREEZER=y
+# CONFIG_PPC4xx_PCI_EXPRESS is not set
+# CONFIG_PPC_XICS is not set
+# CONFIG_PPC_ICP_NATIVE is not set
+# CONFIG_PPC_ICP_HV is not set
+# CONFIG_PPC_ICS_RTAS is not set
+
+#
+# Platform support
+#
+# CONFIG_PPC_CELL is not set
+# CONFIG_PPC_CELL_NATIVE is not set
+# CONFIG_PQ2ADS is not set
+# CONFIG_ISS4xx is not set
+# CONFIG_PPC4xx_GPIO is not set
+# CONFIG_ACADIA is not set
+# CONFIG_EP405 is not set
+# CONFIG_HOTFOOT is not set
+# CONFIG_KILAUEA is not set
+# CONFIG_MAKALU is not set
+# CONFIG_WALNUT is not set
+# CONFIG_XILINX_VIRTEX_GENERIC_BOARD is not set
+CONFIG_PPC40x_SIMPLE=y
+CONFIG_APM8018X=y
+# CONFIG_PPC_WSP is not set
+# CONFIG_KVM_GUEST is not set
+# CONFIG_IPIC is not set
+# CONFIG_MPIC is not set
+# CONFIG_PPC_EPAPR_HV_PIC is not set
+# CONFIG_MPIC_WEIRD is not set
+# CONFIG_PPC_I8259 is not set
+# CONFIG_PPC_RTAS is not set
+# CONFIG_MMIO_NVRAM is not set
+# CONFIG_MPIC_U3_HT_IRQS is not set
+# CONFIG_PPC_MPC106 is not set
+# CONFIG_PPC_970_NAP is not set
+# CONFIG_PPC_P7_NAP is not set
+
+#
+# CPU Frequency scaling
+#
+# CONFIG_CPU_FREQ is not set
+# CONFIG_FSL_ULI1575 is not set
+# CONFIG_SIMPLE_GPIO is not set
+
+#
+# Kernel options
+#
+# CONFIG_HIGHMEM is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+# CONFIG_SCHED_HRTICK is not set
+CONFIG_PREEMPT_NONE=y
+# CONFIG_PREEMPT_VOLUNTARY is not set
+# CONFIG_PREEMPT is not set
+CONFIG_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+# CONFIG_HAVE_AOUT is not set
+# CONFIG_BINFMT_MISC is not set
+CONFIG_MATH_EMULATION=y
+# CONFIG_IOMMU_HELPER is not set
+# CONFIG_SWIOTLB is not set
+CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
+CONFIG_ARCH_HAS_WALK_MEMORY=y
+CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
+CONFIG_MAX_ACTIVE_REGIONS=32
+CONFIG_ARCH_FLATMEM_ENABLE=y
+CONFIG_ARCH_POPULATES_NODE_MAP=y
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_HAVE_MEMBLOCK=y
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_COMPACTION is not set
+# CONFIG_MIGRATION is not set
+# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_BOUNCE=y
+CONFIG_VIRT_TO_BUS=y
+# CONFIG_KSM is not set
+CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
+CONFIG_NEED_PER_CPU_KM=y
+# CONFIG_CLEANCACHE is not set
+CONFIG_PPC_4K_PAGES=y
+CONFIG_FORCE_MAX_ZONEORDER=11
+# CONFIG_CMDLINE_BOOL is not set
+CONFIG_EXTRA_TARGETS=""
+CONFIG_SUSPEND=y
+CONFIG_SUSPEND_FREEZER=y
+# CONFIG_HIBERNATION is not set
+CONFIG_PM_SLEEP=y
+# CONFIG_PM_RUNTIME is not set
+CONFIG_PM=y
+# CONFIG_PM_DEBUG is not set
+CONFIG_SECCOMP=y
+CONFIG_ISA_DMA_API=y
+
+#
+# Bus options
+#
+CONFIG_ZONE_DMA=y
+CONFIG_NEED_DMA_MAP_STATE=y
+CONFIG_NEED_SG_DMA_LENGTH=y
+CONFIG_GENERIC_ISA_DMA=y
+CONFIG_PPC_INDIRECT_PCI=y
+CONFIG_PPC4xx_CPM=y
+CONFIG_4xx_SOC=y
+CONFIG_PPC_PCI_CHOICE=y
+CONFIG_PCI=y
+CONFIG_PCI_DOMAINS=y
+CONFIG_PCI_SYSCALL=y
+# CONFIG_PCIEPORTBUS is not set
+CONFIG_ARCH_SUPPORTS_MSI=y
+# CONFIG_PCI_MSI is not set
+# CONFIG_PCI_DEBUG is not set
+# CONFIG_PCI_STUB is not set
+# CONFIG_PCI_IOV is not set
+# CONFIG_PCI_PRI is not set
+# CONFIG_PCI_PASID is not set
+# CONFIG_PCCARD is not set
+# CONFIG_HOTPLUG_PCI is not set
+# CONFIG_HAS_RAPIDIO is not set
+# CONFIG_RAPIDIO is not set
+
+#
+# Advanced setup
+#
+# CONFIG_ADVANCED_OPTIONS is not set
+
+#
+# Default settings for advanced configuration options are used
+#
+CONFIG_LOWMEM_SIZE=0x30000000
+CONFIG_PAGE_OFFSET=0xc0000000
+CONFIG_KERNEL_START=0xc0000000
+CONFIG_PHYSICAL_START=0x00000000
+CONFIG_TASK_SIZE=0xc0000000
+CONFIG_CONSISTENT_SIZE=0x00200000
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+CONFIG_XFRM_USER=y
+CONFIG_XFRM_SUB_POLICY=y
+CONFIG_XFRM_MIGRATE=y
+# CONFIG_XFRM_STATISTICS is not set
+CONFIG_XFRM_IPCOMP=y
+CONFIG_NET_KEY=y
+# CONFIG_NET_KEY_MIGRATE is not set
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+CONFIG_NET_IPIP=y
+# CONFIG_NET_IPGRE_DEMUX is not set
+# CONFIG_IP_MROUTE is not set
+CONFIG_ARPD=y
+# CONFIG_SYN_COOKIES is not set
+CONFIG_INET_AH=y
+CONFIG_INET_ESP=y
+CONFIG_INET_IPCOMP=y
+CONFIG_INET_XFRM_TUNNEL=y
+CONFIG_INET_TUNNEL=y
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+CONFIG_IPV6=y
+# CONFIG_IPV6_PRIVACY is not set
+# CONFIG_IPV6_ROUTER_PREF is not set
+# CONFIG_IPV6_OPTIMISTIC_DAD is not set
+# CONFIG_INET6_AH is not set
+# CONFIG_INET6_ESP is not set
+# CONFIG_INET6_IPCOMP is not set
+# CONFIG_IPV6_MIP6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+CONFIG_INET6_XFRM_MODE_TRANSPORT=y
+CONFIG_INET6_XFRM_MODE_TUNNEL=y
+CONFIG_INET6_XFRM_MODE_BEET=y
+# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
+CONFIG_IPV6_SIT=y
+# CONFIG_IPV6_SIT_6RD is not set
+CONFIG_IPV6_NDISC_NODETYPE=y
+# CONFIG_IPV6_TUNNEL is not set
+# CONFIG_IPV6_MULTIPLE_TABLES is not set
+# CONFIG_IPV6_MROUTE is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_RDS is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_L2TP is not set
+CONFIG_STP=y
+CONFIG_BRIDGE=y
+CONFIG_BRIDGE_IGMP_SNOOPING=y
+# CONFIG_NET_DSA is not set
+CONFIG_VLAN_8021Q=y
+# CONFIG_VLAN_8021Q_GVRP is not set
+# CONFIG_DECNET is not set
+CONFIG_LLC=y
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
+# CONFIG_IEEE802154 is not set
+# CONFIG_NET_SCHED is not set
+# CONFIG_DCB is not set
+# CONFIG_BATMAN_ADV is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+CONFIG_WIRELESS=y
+CONFIG_WEXT_CORE=y
+CONFIG_WEXT_PROC=y
+CONFIG_CFG80211=m
+# CONFIG_NL80211_TESTMODE is not set
+# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
+# CONFIG_CFG80211_REG_DEBUG is not set
+CONFIG_CFG80211_DEFAULT_PS=y
+# CONFIG_CFG80211_INTERNAL_REGDB is not set
+CONFIG_CFG80211_WEXT=y
+CONFIG_WIRELESS_EXT_SYSFS=y
+# CONFIG_LIB80211 is not set
+CONFIG_MAC80211=m
+CONFIG_MAC80211_HAS_RC=y
+# CONFIG_MAC80211_RC_PID is not set
+CONFIG_MAC80211_RC_MINSTREL=y
+CONFIG_MAC80211_RC_MINSTREL_HT=y
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
+# CONFIG_MAC80211_MESH is not set
+# CONFIG_MAC80211_DEBUG_MENU is not set
+# CONFIG_WIMAX is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+# CONFIG_CAIF is not set
+# CONFIG_CEPH_LIB is not set
+# CONFIG_NFC is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+# CONFIG_DEVTMPFS is not set
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=y
+CONFIG_FIRMWARE_IN_KERNEL=y
+CONFIG_EXTRA_FIRMWARE=""
+# CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
+# CONFIG_SYS_HYPERVISOR is not set
+CONFIG_CONNECTOR=y
+CONFIG_PROC_EVENTS=y
+# CONFIG_MTD is not set
+CONFIG_DTC=y
+CONFIG_OF=y
+
+#
+# Device Tree and Open Firmware support
+#
+CONFIG_PROC_DEVICETREE=y
+CONFIG_OF_FLATTREE=y
+CONFIG_OF_EARLY_FLATTREE=y
+CONFIG_OF_DYNAMIC=y
+CONFIG_OF_ADDRESS=y
+CONFIG_OF_IRQ=y
+CONFIG_OF_DEVICE=y
+CONFIG_OF_NET=y
+CONFIG_OF_PCI=y
+CONFIG_OF_PCI_IRQ=y
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_FD is not set
+# CONFIG_BLK_CPQ_DA is not set
+# CONFIG_BLK_CPQ_CISS_DA is not set
+# CONFIG_BLK_DEV_DAC960 is not set
+# CONFIG_BLK_DEV_UMEM is not set
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_DRBD is not set
+# CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_SX8 is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=35000
+# CONFIG_BLK_DEV_XIP is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_XILINX_SYSACE is not set
+# CONFIG_BLK_DEV_HD is not set
+# CONFIG_BLK_DEV_RBD is not set
+# CONFIG_MISC_DEVICES is not set
+CONFIG_HAVE_IDE=y
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+CONFIG_SCSI_MOD=y
+# CONFIG_RAID_ATTRS is not set
+CONFIG_SCSI=y
+CONFIG_SCSI_DMA=y
+# CONFIG_SCSI_TGT is not set
+# CONFIG_SCSI_NETLINK is not set
+CONFIG_SCSI_PROC_FS=y
+
+#
+# SCSI support type (disk, tape, CD-ROM)
+#
+CONFIG_BLK_DEV_SD=y
+# CONFIG_CHR_DEV_ST is not set
+# CONFIG_CHR_DEV_OSST is not set
+# CONFIG_BLK_DEV_SR is not set
+CONFIG_CHR_DEV_SG=y
+# CONFIG_CHR_DEV_SCH is not set
+# CONFIG_SCSI_MULTI_LUN is not set
+# CONFIG_SCSI_CONSTANTS is not set
+# CONFIG_SCSI_LOGGING is not set
+# CONFIG_SCSI_SCAN_ASYNC is not set
+CONFIG_SCSI_WAIT_SCAN=m
+
+#
+# SCSI Transports
+#
+# CONFIG_SCSI_SPI_ATTRS is not set
+# CONFIG_SCSI_FC_ATTRS is not set
+# CONFIG_SCSI_ISCSI_ATTRS is not set
+CONFIG_SCSI_SAS_ATTRS=y
+# CONFIG_SCSI_SAS_LIBSAS is not set
+# CONFIG_SCSI_SRP_ATTRS is not set
+CONFIG_SCSI_LOWLEVEL=y
+# CONFIG_ISCSI_TCP is not set
+# CONFIG_ISCSI_BOOT_SYSFS is not set
+# CONFIG_SCSI_CXGB3_ISCSI is not set
+# CONFIG_SCSI_CXGB4_ISCSI is not set
+# CONFIG_SCSI_BNX2_ISCSI is not set
+# CONFIG_SCSI_BNX2X_FCOE is not set
+# CONFIG_BE2ISCSI is not set
+# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
+# CONFIG_SCSI_HPSA is not set
+# CONFIG_SCSI_3W_9XXX is not set
+# CONFIG_SCSI_3W_SAS is not set
+# CONFIG_SCSI_ACARD is not set
+# CONFIG_SCSI_AACRAID is not set
+# CONFIG_SCSI_AIC7XXX is not set
+# CONFIG_SCSI_AIC7XXX_OLD is not set
+# CONFIG_SCSI_AIC79XX is not set
+# CONFIG_SCSI_AIC94XX is not set
+# CONFIG_SCSI_MVSAS is not set
+# CONFIG_SCSI_MVUMI is not set
+# CONFIG_SCSI_DPT_I2O is not set
+# CONFIG_SCSI_ADVANSYS is not set
+# CONFIG_SCSI_ARCMSR is not set
+# CONFIG_MEGARAID_NEWGEN is not set
+# CONFIG_MEGARAID_LEGACY is not set
+# CONFIG_MEGARAID_SAS is not set
+# CONFIG_SCSI_MPT2SAS is not set
+# CONFIG_SCSI_HPTIOP is not set
+# CONFIG_SCSI_BUSLOGIC is not set
+# CONFIG_LIBFC is not set
+# CONFIG_LIBFCOE is not set
+# CONFIG_FCOE is not set
+# CONFIG_SCSI_DMX3191D is not set
+# CONFIG_SCSI_EATA is not set
+# CONFIG_SCSI_FUTURE_DOMAIN is not set
+# CONFIG_SCSI_GDTH is not set
+# CONFIG_SCSI_IPS is not set
+# CONFIG_SCSI_INITIO is not set
+# CONFIG_SCSI_INIA100 is not set
+# CONFIG_SCSI_STEX is not set
+# CONFIG_SCSI_SYM53C8XX_2 is not set
+# CONFIG_SCSI_QLOGIC_1280 is not set
+# CONFIG_SCSI_QLA_FC is not set
+# CONFIG_SCSI_QLA_ISCSI is not set
+# CONFIG_SCSI_LPFC is not set
+# CONFIG_SCSI_DC395x is not set
+# CONFIG_SCSI_DC390T is not set
+# CONFIG_SCSI_NSP32 is not set
+# CONFIG_SCSI_DEBUG is not set
+# CONFIG_SCSI_PMCRAID is not set
+# CONFIG_SCSI_PM8001 is not set
+# CONFIG_SCSI_SRP is not set
+# CONFIG_SCSI_BFA_FC is not set
+# CONFIG_SCSI_DH is not set
+# CONFIG_SCSI_OSD_INITIATOR is not set
+# CONFIG_ATA is not set
+CONFIG_MD=y
+CONFIG_BLK_DEV_MD=y
+CONFIG_MD_AUTODETECT=y
+# CONFIG_MD_LINEAR is not set
+CONFIG_MD_RAID0=y
+CONFIG_MD_RAID1=y
+CONFIG_MD_RAID10=y
+CONFIG_MD_RAID456=y
+# CONFIG_MD_MULTIPATH is not set
+# CONFIG_MD_FAULTY is not set
+# CONFIG_BLK_DEV_DM is not set
+# CONFIG_TARGET_CORE is not set
+CONFIG_FUSION=y
+# CONFIG_FUSION_SPI is not set
+# CONFIG_FUSION_FC is not set
+CONFIG_FUSION_SAS=y
+CONFIG_FUSION_MAX_SGE=128
+# CONFIG_FUSION_CTL is not set
+# CONFIG_FUSION_LOGGING is not set
+
+#
+# IEEE 1394 (FireWire) support
+#
+# CONFIG_FIREWIRE is not set
+# CONFIG_FIREWIRE_NOSY is not set
+# CONFIG_I2O is not set
+# CONFIG_MACINTOSH_DRIVERS is not set
+CONFIG_NETDEVICES=y
+CONFIG_NET_CORE=y
+# CONFIG_BONDING is not set
+# CONFIG_DUMMY is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_NET_FC is not set
+# CONFIG_MII is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+# CONFIG_ARCNET is not set
+
+#
+# CAIF transport drivers
+#
+CONFIG_ETHERNET=y
+# CONFIG_NET_VENDOR_3COM is not set
+# CONFIG_NET_VENDOR_ADAPTEC is not set
+# CONFIG_NET_VENDOR_ALTEON is not set
+# CONFIG_NET_VENDOR_AMD is not set
+# CONFIG_NET_VENDOR_ATHEROS is not set
+# CONFIG_NET_VENDOR_BROADCOM is not set
+# CONFIG_NET_VENDOR_BROCADE is not set
+# CONFIG_NET_VENDOR_CHELSIO is not set
+# CONFIG_NET_VENDOR_CISCO is not set
+# CONFIG_DNET is not set
+# CONFIG_NET_VENDOR_DEC is not set
+# CONFIG_NET_VENDOR_DLINK is not set
+# CONFIG_NET_VENDOR_EMULEX is not set
+# CONFIG_NET_VENDOR_EXAR is not set
+# CONFIG_NET_VENDOR_HP is not set
+CONFIG_NET_VENDOR_IBM=y
+CONFIG_IBM_EMAC=y
+CONFIG_IBM_EMAC_RXB=128
+CONFIG_IBM_EMAC_TXB=64
+CONFIG_IBM_EMAC_POLL_WEIGHT=32
+CONFIG_IBM_EMAC_RX_COPY_THRESHOLD=256
+CONFIG_IBM_EMAC_RX_SKB_HEADROOM=0
+# CONFIG_IBM_EMAC_DEBUG is not set
+# CONFIG_IBM_EMAC_ZMII is not set
+# CONFIG_IBM_EMAC_RGMII is not set
+# CONFIG_IBM_EMAC_TAH is not set
+# CONFIG_IBM_EMAC_EMAC4 is not set
+# CONFIG_IBM_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_EMAC_MAL_COMMON_ERR is not set
+CONFIG_NET_VENDOR_INTEL=y
+# CONFIG_E100 is not set
+# CONFIG_E1000 is not set
+CONFIG_E1000E=y
+CONFIG_IGB=y
+# CONFIG_IGBVF is not set
+# CONFIG_IXGB is not set
+# CONFIG_IXGBE is not set
+CONFIG_NET_VENDOR_I825XX=y
+# CONFIG_ZNET is not set
+# CONFIG_IP1000 is not set
+# CONFIG_JME is not set
+# CONFIG_NET_VENDOR_MARVELL is not set
+# CONFIG_NET_VENDOR_MELLANOX is not set
+# CONFIG_NET_VENDOR_MICREL is not set
+# CONFIG_NET_VENDOR_MYRI is not set
+# CONFIG_FEALNX is not set
+# CONFIG_NET_VENDOR_NATSEMI is not set
+# CONFIG_NET_VENDOR_NVIDIA is not set
+# CONFIG_NET_VENDOR_OKI is not set
+# CONFIG_ETHOC is not set
+# CONFIG_NET_PACKET_ENGINE is not set
+# CONFIG_NET_VENDOR_QLOGIC is not set
+# CONFIG_NET_VENDOR_REALTEK is not set
+# CONFIG_NET_VENDOR_RDC is not set
+# CONFIG_NET_VENDOR_SEEQ is not set
+# CONFIG_NET_VENDOR_SILAN is not set
+# CONFIG_NET_VENDOR_SIS is not set
+# CONFIG_SFC is not set
+# CONFIG_NET_VENDOR_SMSC is not set
+# CONFIG_NET_VENDOR_STMICRO is not set
+# CONFIG_NET_VENDOR_SUN is not set
+# CONFIG_NET_VENDOR_TEHUTI is not set
+# CONFIG_NET_VENDOR_TI is not set
+# CONFIG_NET_VENDOR_VIA is not set
+# CONFIG_NET_VENDOR_XILINX is not set
+# CONFIG_FDDI is not set
+# CONFIG_PHYLIB is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_TR is not set
+CONFIG_WLAN=y
+# CONFIG_LIBERTAS_THINFIRM is not set
+# CONFIG_AIRO is not set
+# CONFIG_ATMEL is not set
+# CONFIG_PRISM54 is not set
+# CONFIG_RTL8180 is not set
+# CONFIG_ADM8211 is not set
+# CONFIG_MAC80211_HWSIM is not set
+# CONFIG_MWL8K is not set
+# CONFIG_ATH_COMMON is not set
+# CONFIG_B43 is not set
+# CONFIG_B43LEGACY is not set
+# CONFIG_BRCMSMAC is not set
+# CONFIG_HOSTAP is not set
+# CONFIG_IPW2100 is not set
+# CONFIG_IPW2200 is not set
+# CONFIG_IWLWIFI is not set
+# CONFIG_IWL4965 is not set
+# CONFIG_IWL3945 is not set
+# CONFIG_LIBERTAS is not set
+# CONFIG_HERMES is not set
+# CONFIG_P54_COMMON is not set
+# CONFIG_RT2X00 is not set
+# CONFIG_RTL8192CE is not set
+# CONFIG_RTL8192SE is not set
+# CONFIG_RTL8192DE is not set
+# CONFIG_WL1251 is not set
+# CONFIG_WL12XX_MENU is not set
+# CONFIG_MWIFIEX is not set
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+# CONFIG_WAN is not set
+# CONFIG_VMXNET3 is not set
+# CONFIG_ISDN is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_VT is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_SERIAL_NONSTANDARD is not set
+# CONFIG_NOZOMI is not set
+# CONFIG_N_GSM is not set
+# CONFIG_TRACE_SINK is not set
+# CONFIG_PPC_EPAPR_HV_BYTECHAN is not set
+CONFIG_DEVKMEM=y
+
+#
+# Serial drivers
+#
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_PCI=y
+CONFIG_SERIAL_8250_NR_UARTS=4
+CONFIG_SERIAL_8250_RUNTIME_UARTS=4
+CONFIG_SERIAL_8250_EXTENDED=y
+# CONFIG_SERIAL_8250_MANY_PORTS is not set
+CONFIG_SERIAL_8250_SHARE_IRQ=y
+# CONFIG_SERIAL_8250_DETECT_IRQ is not set
+# CONFIG_SERIAL_8250_RSA is not set
+# CONFIG_SERIAL_8250_DW is not set
+
+#
+# Non-8250 serial port support
+#
+# CONFIG_SERIAL_MFD_HSU is not set
+# CONFIG_SERIAL_UARTLITE is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_JSM is not set
+# CONFIG_SERIAL_OF_PLATFORM is not set
+# CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL is not set
+# CONFIG_SERIAL_TIMBERDALE is not set
+# CONFIG_SERIAL_ALTERA_JTAGUART is not set
+# CONFIG_SERIAL_ALTERA_UART is not set
+# CONFIG_SERIAL_PCH_UART is not set
+# CONFIG_SERIAL_XILINX_PS_UART is not set
+# CONFIG_TTY_PRINTK is not set
+# CONFIG_HVC_UDBG is not set
+# CONFIG_IPMI_HANDLER is not set
+# CONFIG_HW_RANDOM is not set
+# CONFIG_NVRAM is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_APPLICOM is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_DEVPORT=y
+# CONFIG_RAMOOPS is not set
+# CONFIG_I2C is not set
+# CONFIG_SPI is not set
+
+#
+# PPS support
+#
+# CONFIG_PPS is not set
+
+#
+# PPS generators support
+#
+
+#
+# PTP clock support
+#
+
+#
+# Enable Device Drivers -> PPS to see the PTP clock options.
+#
+CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
+# CONFIG_GPIOLIB is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
+# CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
+CONFIG_BCMA_POSSIBLE=y
+
+#
+# Broadcom specific AMBA
+#
+# CONFIG_BCMA is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_CORE is not set
+# CONFIG_MFD_SM501 is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_ABX500_CORE is not set
+# CONFIG_LPC_SCH is not set
+# CONFIG_MFD_RDC321X is not set
+# CONFIG_MFD_JANZ_CMODIO is not set
+# CONFIG_MFD_VX855 is not set
+# CONFIG_REGULATOR is not set
+# CONFIG_MEDIA_SUPPORT is not set
+
+#
+# Graphics support
+#
+# CONFIG_AGP is not set
+# CONFIG_VGA_ARB is not set
+# CONFIG_DRM is not set
+# CONFIG_STUB_POULSBO is not set
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_SOUND is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_UWB is not set
+# CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_ACCESSIBILITY is not set
+# CONFIG_INFINIBAND is not set
+# CONFIG_EDAC is not set
+# CONFIG_RTC_CLASS is not set
+# CONFIG_DMADEVICES is not set
+# CONFIG_AUXDISPLAY is not set
+# CONFIG_UIO is not set
+
+#
+# Virtio drivers
+#
+# CONFIG_VIRTIO_PCI is not set
+# CONFIG_VIRTIO_BALLOON is not set
+# CONFIG_VIRTIO_MMIO is not set
+# CONFIG_STAGING is not set
+
+#
+# Hardware Spinlock drivers
+#
+# CONFIG_IOMMU_SUPPORT is not set
+# CONFIG_VIRT_DRIVERS is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+# CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT3_FS_XATTR=y
+# CONFIG_EXT3_FS_POSIX_ACL is not set
+# CONFIG_EXT3_FS_SECURITY is not set
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_XATTR=y
+# CONFIG_EXT4_FS_POSIX_ACL is not set
+# CONFIG_EXT4_FS_SECURITY is not set
+# CONFIG_EXT4_DEBUG is not set
+CONFIG_JBD=y
+CONFIG_JBD2=y
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
+# CONFIG_NILFS2_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
+CONFIG_DNOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_FANOTIFY is not set
+# CONFIG_QUOTA is not set
+# CONFIG_QUOTACTL is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+CONFIG_FAT_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
+# CONFIG_TMPFS_XATTR is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+CONFIG_MISC_FILESYSTEMS=y
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_LOGFS is not set
+CONFIG_CRAMFS=y
+# CONFIG_SQUASHFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_OMFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_PSTORE is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+CONFIG_ROOT_NFS=y
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_CEPH_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_CODEPAGE_437=y
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+CONFIG_NLS_ASCII=y
+CONFIG_NLS_ISO8859_1=y
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+CONFIG_NLS_UTF8=y
+# CONFIG_BINARY_PRINTF is not set
+
+#
+# Library routines
+#
+CONFIG_RAID6_PQ=y
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+CONFIG_CRC16=y
+# CONFIG_CRC_T10DIF is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+# CONFIG_CRC8 is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+# CONFIG_XZ_DEC is not set
+# CONFIG_XZ_DEC_BCJ is not set
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
+CONFIG_NLATTR=y
+CONFIG_GENERIC_ATOMIC64=y
+CONFIG_AVERAGE=y
+# CONFIG_CORDIC is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
+CONFIG_MAGIC_SYSRQ=y
+# CONFIG_STRIP_ASM_SYMS is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_SECTION_MISMATCH is not set
+CONFIG_DEBUG_KERNEL=y
+# CONFIG_DEBUG_SHIRQ is not set
+# CONFIG_LOCKUP_DETECTOR is not set
+# CONFIG_HARDLOCKUP_DETECTOR is not set
+# CONFIG_DETECT_HUNG_TASK is not set
+# CONFIG_SCHED_DEBUG is not set
+# CONFIG_SCHEDSTATS is not set
+# CONFIG_TIMER_STATS is not set
+# CONFIG_DEBUG_OBJECTS is not set
+# CONFIG_DEBUG_SLAB is not set
+# CONFIG_DEBUG_KMEMLEAK is not set
+# CONFIG_DEBUG_RT_MUTEXES is not set
+# CONFIG_RT_MUTEX_TESTER is not set
+# CONFIG_DEBUG_SPINLOCK is not set
+# CONFIG_DEBUG_MUTEXES is not set
+# CONFIG_DEBUG_LOCK_ALLOC is not set
+# CONFIG_PROVE_LOCKING is not set
+# CONFIG_SPARSE_RCU_POINTER is not set
+# CONFIG_LOCK_STAT is not set
+# CONFIG_DEBUG_ATOMIC_SLEEP is not set
+# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
+# CONFIG_DEBUG_STACK_USAGE is not set
+# CONFIG_DEBUG_KOBJECT is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_INFO is not set
+# CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_WRITECOUNT is not set
+# CONFIG_DEBUG_MEMORY_INIT is not set
+# CONFIG_DEBUG_LIST is not set
+# CONFIG_TEST_LIST_SORT is not set
+# CONFIG_DEBUG_SG is not set
+# CONFIG_DEBUG_NOTIFIERS is not set
+# CONFIG_DEBUG_CREDENTIALS is not set
+# CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
+# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
+# CONFIG_FAULT_INJECTION is not set
+# CONFIG_LATENCYTOP is not set
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+# CONFIG_DEBUG_PAGEALLOC is not set
+CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
+CONFIG_HAVE_DYNAMIC_FTRACE=y
+CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
+CONFIG_TRACING_SUPPORT=y
+# CONFIG_FTRACE is not set
+# CONFIG_DMA_API_DEBUG is not set
+# CONFIG_ATOMIC64_SELFTEST is not set
+# CONFIG_ASYNC_RAID6_TEST is not set
+# CONFIG_SAMPLES is not set
+CONFIG_HAVE_ARCH_KGDB=y
+# CONFIG_KGDB is not set
+# CONFIG_TEST_KSTRTOX is not set
+# CONFIG_PPC_DISABLE_WERROR is not set
+CONFIG_PPC_WERROR=y
+CONFIG_PRINT_STACK_DEPTH=64
+# CONFIG_DEBUG_STACKOVERFLOW is not set
+# CONFIG_CODE_PATCHING_SELFTEST is not set
+# CONFIG_FTR_FIXUP_SELFTEST is not set
+# CONFIG_MSI_BITMAP_SELFTEST is not set
+# CONFIG_XMON is not set
+# CONFIG_BDI_SWITCH is not set
+# CONFIG_PPC_EARLY_DEBUG is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY_DMESG_RESTRICT is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
+CONFIG_DEFAULT_SECURITY_DAC=y
+CONFIG_DEFAULT_SECURITY=""
+CONFIG_XOR_BLOCKS=y
+CONFIG_ASYNC_CORE=y
+CONFIG_ASYNC_MEMCPY=y
+CONFIG_ASYNC_XOR=y
+CONFIG_ASYNC_PQ=y
+CONFIG_ASYNC_RAID6_RECOV=y
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_AEAD=y
+CONFIG_CRYPTO_AEAD2=y
+CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_BLKCIPHER2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+CONFIG_CRYPTO_RNG=y
+CONFIG_CRYPTO_RNG2=y
+CONFIG_CRYPTO_PCOMP2=y
+CONFIG_CRYPTO_MANAGER=y
+CONFIG_CRYPTO_MANAGER2=y
+# CONFIG_CRYPTO_USER is not set
+CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
+CONFIG_CRYPTO_GF128MUL=y
+# CONFIG_CRYPTO_NULL is not set
+CONFIG_CRYPTO_WORKQUEUE=y
+CONFIG_CRYPTO_CRYPTD=y
+CONFIG_CRYPTO_AUTHENC=y
+CONFIG_CRYPTO_TEST=m
+
+#
+# Authenticated Encryption with Associated Data
+#
+CONFIG_CRYPTO_CCM=y
+CONFIG_CRYPTO_GCM=y
+CONFIG_CRYPTO_SEQIV=y
+
+#
+# Block modes
+#
+CONFIG_CRYPTO_CBC=y
+CONFIG_CRYPTO_CTR=y
+# CONFIG_CRYPTO_CTS is not set
+CONFIG_CRYPTO_ECB=y
+# CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_PCBC is not set
+CONFIG_CRYPTO_XTS=y
+
+#
+# Hash modes
+#
+CONFIG_CRYPTO_HMAC=y
+CONFIG_CRYPTO_XCBC=y
+# CONFIG_CRYPTO_VMAC is not set
+
+#
+# Digest
+#
+# CONFIG_CRYPTO_CRC32C is not set
+CONFIG_CRYPTO_GHASH=y
+# CONFIG_CRYPTO_MD4 is not set
+CONFIG_CRYPTO_MD5=y
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_RMD128 is not set
+# CONFIG_CRYPTO_RMD160 is not set
+# CONFIG_CRYPTO_RMD256 is not set
+# CONFIG_CRYPTO_RMD320 is not set
+CONFIG_CRYPTO_SHA1=y
+CONFIG_CRYPTO_SHA256=y
+CONFIG_CRYPTO_SHA512=y
+# CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_WP512 is not set
+
+#
+# Ciphers
+#
+CONFIG_CRYPTO_AES=y
+# CONFIG_CRYPTO_ANUBIS is not set
+CONFIG_CRYPTO_ARC4=y
+# CONFIG_CRYPTO_BLOWFISH is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
+CONFIG_CRYPTO_DES=y
+# CONFIG_CRYPTO_FCRYPT is not set
+# CONFIG_CRYPTO_KHAZAD is not set
+# CONFIG_CRYPTO_SALSA20 is not set
+# CONFIG_CRYPTO_SEED is not set
+# CONFIG_CRYPTO_SERPENT is not set
+# CONFIG_CRYPTO_TEA is not set
+# CONFIG_CRYPTO_TWOFISH is not set
+
+#
+# Compression
+#
+CONFIG_CRYPTO_DEFLATE=y
+# CONFIG_CRYPTO_ZLIB is not set
+# CONFIG_CRYPTO_LZO is not set
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+# CONFIG_CRYPTO_USER_API_HASH is not set
+# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
+CONFIG_CRYPTO_HW=y
+# CONFIG_CRYPTO_DEV_HIFN_795X is not set
+# CONFIG_CRYPTO_DEV_PPC4XX is not set
+# CONFIG_PPC_CLOCK is not set
+# CONFIG_VIRTUALIZATION is not set
+CONFIG_UART_16550_WORD_ADDRESSABLE=y
diff --git a/arch/powerpc/include/asm/dcr-regs.h b/arch/powerpc/include/asm/dcr-regs.h
index 380274d..c900cfd 100644
--- a/arch/powerpc/include/asm/dcr-regs.h
+++ b/arch/powerpc/include/asm/dcr-regs.h
@@ -24,9 +24,18 @@
  * of the driver main register set
  */
 
+#if defined(CONFIG_APM8018X)
+/* CPR */
+#define DCRN_CPR0_CONFIG_ADDR	0xa
+#define DCRN_CPR1_CONFIG_DATA	0xb
+/* AHB */
+#define DCRN_SDR1_CONFIG_ADDR	0xc
+#define DCRN_SDR1_CONFIG_DATA	0xd
+#else
 /* CPRs (440GX and 440SP/440SPe) */
 #define DCRN_CPR0_CONFIG_ADDR	0xc
 #define DCRN_CPR0_CONFIG_DATA	0xd
+#endif /* CONFIG_APM8018X */
 
 /* SDRs (440GX and 440SP/440SPe) */
 #define DCRN_SDR0_CONFIG_ADDR 	0xe
@@ -79,6 +88,17 @@
 #define SDR0_ETH_CFG		0x4103
 #define SDR0_ETH_CFG_ECS	0x00000100	/* EMAC int clk source */
 
+#ifdef CONFIG_APM8018X
+#define SDR0_ETH_CFG_1588SPD0	(1 << 29)
+#define SDR0_ETH_CFG_1588SPD1	(1 << 28)
+#define SDR0_ETH_CFG_DIS	(1 << 20)
+#define GPIO_SDR0_CFG0		0x30
+#define GPIO_SDR0_CFG1		0x31
+#define GPIO_SDR0_CFG2		0x32
+#define GPIO_SDR0_CFG3		0x33
+#define GPIO_SDR0_CFG4		0x34
+#endif /* CONFIG_APM8018X */
+
 /*
  * All those DCR register addresses are offsets from the base address
  * for the SRAM0 controller (e.g. 0x20 on 440GX). The base address is
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index edae5bb..e5c51a6 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -1505,6 +1505,58 @@ static struct cpu_spec __initdata cpu_specs[] = {
 		.machine_check		= machine_check_4xx,
 		.platform		= "ppc405",
 	},
+	{	/* APM80186-SK */
+		.pvr_mask		= 0xffffffff,
+		.pvr_value		= 0x7ff11432,
+		.cpu_name		= "APM80186-SK",
+		.cpu_features		= CPU_FTRS_40X,
+		.cpu_user_features	= PPC_FEATURE_32 |
+			PPC_FEATURE_HAS_MMU | PPC_FEATURE_HAS_4xxMAC,
+		.mmu_features		= MMU_FTR_TYPE_40x,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.machine_check		= machine_check_4xx,
+		.platform		= "ppc405",
+	},
+	{	/* APM80186-NK */
+		.pvr_mask		= 0xffffffff,
+		.pvr_value		= 0x7ff11433,
+		.cpu_name		= "APM80186-NK",
+		.cpu_features		= CPU_FTRS_40X,
+		.cpu_user_features	= PPC_FEATURE_32 |
+			PPC_FEATURE_HAS_MMU | PPC_FEATURE_HAS_4xxMAC,
+		.mmu_features		= MMU_FTR_TYPE_40x,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.machine_check		= machine_check_4xx,
+		.platform		= "ppc405",
+	},
+	{	/* APM80187-SK */
+		.pvr_mask		= 0xffffffff,
+		.pvr_value		= 0x7ff11434,
+		.cpu_name		= "APM80187-SK",
+		.cpu_features		= CPU_FTRS_40X,
+		.cpu_user_features	= PPC_FEATURE_32 |
+			PPC_FEATURE_HAS_MMU | PPC_FEATURE_HAS_4xxMAC,
+		.mmu_features		= MMU_FTR_TYPE_40x,
+		.icache_bsize		= 32,
+		.dcache_bsize		= 32,
+		.machine_check		= machine_check_4xx,
+		.platform		= "ppc405",
+	},
+	{	/* APM80187-NK */
+		.pvr_mask		= 0xffffffff,
+		.pvr_value		= 0x7ff11435,
+		.cpu_name		= "APM80187-NK",
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
diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
index 6837f83..dd3bce9 100644
--- a/arch/powerpc/kernel/udbg_16550.c
+++ b/arch/powerpc/kernel/udbg_16550.c
@@ -18,6 +18,19 @@ extern void real_writeb(u8 data, volatile u8 __iomem *addr);
 extern u8 real_205_readb(volatile u8 __iomem  *addr);
 extern void real_205_writeb(u8 data, volatile u8 __iomem *addr);
 
+#ifdef CONFIG_UART_16550_WORD_ADDRESSABLE
+struct NS16550 {
+	/* this struct must be packed */
+	unsigned char rbr;  /* 0 */ u8 s0[3];
+	unsigned char ier;  /* 1 */ u8 s1[3];
+	unsigned char fcr;  /* 2 */ u8 s2[3];
+	unsigned char lcr;  /* 3 */ u8 s3[3];
+	unsigned char mcr;  /* 4 */ u8 s4[3];
+	unsigned char lsr;  /* 5 */ u8 s5[3];
+	unsigned char msr;  /* 6 */ u8 s6[3];
+	unsigned char scr;  /* 7 */ u8 s7[3];
+};
+#else
 struct NS16550 {
 	/* this struct must be packed */
 	unsigned char rbr;  /* 0 */
@@ -29,6 +42,7 @@ struct NS16550 {
 	unsigned char msr;  /* 6 */
 	unsigned char scr;  /* 7 */
 };
+#endif /* CONFIG_UART_16550_WORD_ADDRESSABLE */
 
 #define thr rbr
 #define iir fcr
@@ -52,8 +66,16 @@ static struct NS16550 __iomem *udbg_comport;
 static void udbg_550_flush(void)
 {
 	if (udbg_comport) {
+#if defined(CONFIG_APM8018X)
+		int index;
+		for (index = 0; index < 3500; index++) {
+			if ((in_8(&udbg_comport->lsr) & LSR_THRE) == LSR_THRE)
+				break;
+		}
+#else
 		while ((in_8(&udbg_comport->lsr) & LSR_THRE) == 0)
 			/* wait for idle */;
+#endif /* CONFIG_APM8018X */
 	}
 }
 
diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
index 1530229..3d0d1d9 100644
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
+	default y
+	select PPC40x_SIMPLE
+	select UART_16550_WORD_ADDRESSABLE
+	help
+	  This option enables support for the AppliedMicro Klondike board.
+
diff --git a/arch/powerpc/platforms/40x/ppc40x_simple.c b/arch/powerpc/platforms/40x/ppc40x_simple.c
index e8dd5c5..c8576af 100644
--- a/arch/powerpc/platforms/40x/ppc40x_simple.c
+++ b/arch/powerpc/platforms/40x/ppc40x_simple.c
@@ -17,7 +17,7 @@
 #include <asm/pci-bridge.h>
 #include <asm/ppc4xx.h>
 #include <asm/prom.h>
-#include <asm/time.h>
+#include <linux/time.h>
 #include <asm/udbg.h>
 #include <asm/uic.h>
 
@@ -29,6 +29,7 @@ static __initdata struct of_device_id ppc40x_of_bus[] = {
 	{ .compatible = "ibm,plb4", },
 	{ .compatible = "ibm,opb", },
 	{ .compatible = "ibm,ebc", },
+	{ .compatible = "ibm,ahb", },
 	{ .compatible = "simple-bus", },
 	{},
 };
@@ -55,6 +56,7 @@ static const char *board[] __initdata = {
 	"amcc,haleakala",
 	"amcc,kilauea",
 	"amcc,makalu",
+	"amcc,klondike",
 	"est,hotfoot"
 };
 
-- 
1.6.1.rc3

