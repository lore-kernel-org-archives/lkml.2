Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab2COK4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:56:44 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:43519 "HELO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754589Ab2COK4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:56:42 -0400
From: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: open-source-review@apm.com, Duc Dang <dhdang@apm.com>,
        Sang Pham <spham@apm.com>, Mai La <mla@apm.com>,
        Thang Nguyen <tqnguyen@apm.com>, Phong Vo <pvo@apm.com>,
        Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
Subject: [PATCH 1/2] powerpc/44x: Add additional support for APM821xx SoC and Bluestone board
Date: Thu, 15 Mar 2012 17:56:32 +0700
Message-Id: <1331808992-15367-1-git-send-email-vhtnguyen@apm.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the dts file for bluestone board with support:
- UART1
- L2 cache
- NAND with NDFC
- PCI-E

Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
---
 arch/powerpc/boot/dts/bluestone.dts |  127 ++++++++++++++++++++++++++++++++++-
 1 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
index 2a56a0d..cfa23bf 100644
--- a/arch/powerpc/boot/dts/bluestone.dts
+++ b/arch/powerpc/boot/dts/bluestone.dts
@@ -33,7 +33,7 @@
 	aliases {
 		ethernet0 = &EMAC0;
 		serial0 = &UART0;
-		//serial1 = &UART1; --gcl missing UART1 label
+		serial1 = &UART1;
 	};
 
 	cpus {
@@ -52,7 +52,7 @@
 			d-cache-size = <32768>;
 			dcr-controller;
 			dcr-access-method = "native";
-			//next-level-cache = <&L2C0>; --gcl missing L2C0 label
+			next-level-cache = <&L2C0>;
 		};
 	};
 
@@ -117,6 +117,16 @@
 		dcr-reg = <0x00c 0x002>;
 	};
 
+	L2C0: l2c {
+		compatible = "ibm,l2-cache-apm82181", "ibm,l2-cache";
+		dcr-reg = <0x020 0x008
+			   0x030 0x008>;
+		cache-line-size = <32>;
+		cache-size = <262144>;
+		interrupt-parent = <&UIC1>;
+		interrupts = <11 1>;
+	};
+
 	plb {
 		compatible = "ibm,plb4";
 		#address-cells = <2>;
@@ -182,6 +192,53 @@
 						reg = <0x001a0000 0x00060000>;
 					};
 				};
+
+				ndfc@1,0 {
+					compatible = "ibm,ndfc";
+					reg = <0x00000003 0x00000000 0x00002000>;
+					ccr = <0x00001000>;
+					bank-settings = <0x80002222>;
+					#address-cells = <1>;
+					#size-cells = <1>;
+					/* 2Gb Nand Flash */
+					nand {
+						#address-cells = <1>;
+						#size-cells = <1>;
+
+						partition@0 {
+							label = "firmware";
+							reg   = <0x00000000 0x00C00000>;
+						};
+						partition@c00000 {
+							label = "environment";
+							reg   = <0x00C00000 0x00B00000>;
+						};
+						partition@1700000 {
+							label = "kernel";
+							reg   = <0x01700000 0x00E00000>;
+						};
+						partition@2500000 {
+							label = "root";
+							reg   = <0x02500000 0x08200000>;
+						};
+						partition@a700000 {
+							label = "device-tree";
+							reg   = <0x0A700000 0x00B00000>;
+						};
+						partition@b200000 {
+							label = "config";
+							reg   = <0x0B200000 0x00D00000>;
+						};
+						partition@bf00000 {
+							label = "diag";
+							reg   = <0x0BF00000 0x00C00000>;
+						};
+						partition@cb00000 {
+							label = "vendor";
+							reg   = <0x0CB00000 0x3500000>;
+						};
+					};
+				};
 			};
 
 			UART0: serial@ef600300 {
@@ -195,11 +252,36 @@
 				interrupts = <0x1 0x4>;
 			};
 
+			UART1: serial@ef600400 {
+				device_type = "serial";
+				compatible = "ns16550";
+				reg = <0xef600400 0x00000008>;
+				virtual-reg = <0xef600400>;
+				clock-frequency = <0>; /* Filled in by U-Boot */
+				current-speed = <0>; /* Filled in by U-Boot */
+				interrupt-parent = <&UIC0>;
+				interrupts = <0x1 0x4>;
+			};
+
 			IIC0: i2c@ef600700 {
 				compatible = "ibm,iic";
 				reg = <0xef600700 0x00000014>;
 				interrupt-parent = <&UIC0>;
 				interrupts = <0x2 0x4>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				rtc@68 {
+					compatible = "stm,m41t80";
+					reg = <0x68>;
+					interrupt-parent = <&UIC0>;
+					interrupts = <0x9 0x8>;
+				};
+				sttm@4C {
+					compatible = "adm,adm1032";
+					reg = <0x4C>;
+					interrupt-parent = <&UIC1>;
+					interrupts = <0x1E 0x8>; /* CPU_THERNAL_L */
+				};
 			};
 
 			IIC1: i2c@ef600800 {
@@ -250,5 +332,46 @@
 			};
 		};
 
+		PCIE0: pciex@d00000000 {
+			device_type = "pci";
+			#interrupt-cells = <1>;
+			#size-cells = <2>;
+			#address-cells = <3>;
+			compatible = "ibm,plb-pciex-apm821xx", "ibm,plb-pciex";
+			primary;
+			port = <0x0>; /* port number */
+			reg = <0x0000000d 0x00000000 0x20000000	/* Config space access */
+			       0x0000000c 0x08010000 0x00001000>;	/* Registers */
+			dcr-reg = <0x100 0x020>;
+			sdr-base = <0x300>;
+
+			/* Outbound ranges, one memory and one IO,
+			 * later cannot be changed
+			 */
+			ranges = <0x02000000 0x00000000 0x80000000 0x0000000e 0x00000000 0x00000000 0x80000000
+				  0x02000000 0x00000000 0x00000000 0x0000000f 0x00000000 0x00000000 0x00100000
+				  0x01000000 0x00000000 0x00000000 0x0000000f 0x80000000 0x00000000 0x00010000>;
+
+			/* Inbound 2GB range starting at 0 */
+			dma-ranges = <0x42000000 0x0 0x0 0x0 0x0 0x0 0x80000000>;
+
+			/* This drives busses 40 to 0x7f */
+			bus-range = <0x40 0x7f>;
+
+			/* Legacy interrupts (note the weird polarity, the bridge seems
+			 * to invert PCIe legacy interrupts).
+			 * We are de-swizzling here because the numbers are actually for
+			 * port of the root complex virtual P2P bridge. But I want
+			 * to avoid putting a node for it in the tree, so the numbers
+			 * below are basically de-swizzled numbers.
+			 * The real slot is on idsel 0, so the swizzling is 1:1
+			 */
+			interrupt-map-mask = <0x0 0x0 0x0 0x7>;
+			interrupt-map = <
+				0x0 0x0 0x0 0x1 &UIC3 0xc 0x4 /* swizzled int A */
+				0x0 0x0 0x0 0x2 &UIC3 0xd 0x4 /* swizzled int B */
+				0x0 0x0 0x0 0x3 &UIC3 0xe 0x4 /* swizzled int C */
+				0x0 0x0 0x0 0x4 &UIC3 0xf 0x4 /* swizzled int D */>;
+		};
 	};
 };
-- 
1.7.2.5

