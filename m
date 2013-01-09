Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277Ab3AIUo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:44:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64701 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967Ab3AIUoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:44:20 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-tegra@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Date: Wed,  9 Jan 2013 21:43:10 +0100
Message-Id: <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:RFcI47JJL2VkEXST5vfMWzD9+Z2G7nAMLx3JDf7L3vb
 2YMm7iixOebc9vwCbwZNygvyvljUpT9V2SJx7tiDFiFXTTeQKf
 PUDDnRjGoK/innmeUif9bsftAyhOTgRPNfSD0tOTE6XzFr2dzW
 kpUjuInrtgnrt7MULm2EB55yhWb0NacdDq34wZp86Et4wQuBTl
 daS+6SaEx7vEpD5iy1ujODH1kAUF2o/2/DqWc1PemAYnL2Xw8u
 J/5sFbxbQegW9g14ShvK2v0wEarhgf11UQNKzNWVAmwUiHN9sa
 2zCuA9EJW0UDiqKzoaz8gH2ORVnnmV2h91/d0oAUDzDDbTmHg4
 /orjudUHrbYkdyt6NYAmHGPMMCGeSm5gkh0qZjLdIbKMoObwek
 TJH/JHpLM/W8dMofLL55r1DHW+hHti5R4aPzW+tpSGiWH+prLt
 qDSJY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
directory. The motivation is to collect various host controller drivers
in the same location in order to facilitate refactoring.

The Tegra PCIe driver has been largely rewritten, both in order to turn
it into a proper platform driver and to add MSI (based on code by
Krishna Kishore <kthota@nvidia.com>) as well as device tree support.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 .../bindings/pci/nvidia,tegra20-pcie.txt           |  115 ++
 arch/arm/Kconfig                                   |    2 +
 arch/arm/boot/dts/tegra20.dtsi                     |   45 +
 arch/arm/mach-tegra/Kconfig                        |    5 -
 arch/arm/mach-tegra/Makefile                       |    1 -
 arch/arm/mach-tegra/board-dt-tegra20.c             |    6 +-
 arch/arm/mach-tegra/board-harmony-pcie.c           |   26 +-
 arch/arm/mach-tegra/board.h                        |    4 +-
 arch/arm/mach-tegra/iomap.h                        |    3 -
 arch/arm/mach-tegra/pcie.c                         |  865 -------------
 drivers/pci/Kconfig                                |    2 +
 drivers/pci/Makefile                               |    3 +
 drivers/pci/host/Kconfig                           |    8 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-tegra.c                       | 1322 ++++++++++++++++++++
 15 files changed, 1517 insertions(+), 891 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
 delete mode 100644 arch/arm/mach-tegra/pcie.c
 create mode 100644 drivers/pci/host/Kconfig
 create mode 100644 drivers/pci/host/Makefile
 create mode 100644 drivers/pci/host/pci-tegra.c

diff --git a/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
new file mode 100644
index 0000000..1ebc526
--- /dev/null
+++ b/Documentation/devicetree/bindings/pci/nvidia,tegra20-pcie.txt
@@ -0,0 +1,115 @@
+NVIDIA Tegra PCIe controller
+
+Required properties:
+- compatible: "nvidia,tegra20-pcie"
+- reg: physical base address and length of the controller's registers
+- interrupts: the interrupt outputs of the controller
+- pex-clk-supply: supply voltage for internal reference clock
+- vdd-supply: power supply for controller (1.05V)
+- ranges: describes the translation of addresses for root ports
+- bus-range: range of bus numbers associated with this controller
+- #address-cells: address representation for root ports (must be 3)
+  - cell 0 specifies the bus and device numbers of the root port:
+    [23:16]: bus number
+    [15:11]: device number
+  - cell 1 denotes the upper 32 address bits and should be 0
+  - cell 2 contains the lower 32 address bits and is used to translate to the
+    CPU address space
+- #size-cells: size representation for root ports (must be 2)
+
+Root ports are defined as subnodes of the PCIe controller node.
+
+Required properties:
+- device_type: must be "pciex"
+- reg: address and size of the port configuration registers
+- #address-cells: must be 3
+- #size-cells: must be 2
+- ranges: sub-ranges distributed from the PCIe controller node
+- nvidia,num-lanes: number of lanes to use for this port
+
+Example:
+
+SoC DTSI:
+
+	pcie-controller {
+		compatible = "nvidia,tegra20-pcie";
+		reg = <0x80003000 0x00000800   /* PADS registers */
+		       0x80003800 0x00000200   /* AFI registers */
+		       0x81000000 0x01000000   /* configuration space */
+		       0x90000000 0x10000000>; /* extended configuration space */
+		interrupts = <0 98 0x04   /* controller interrupt */
+		              0 99 0x04>; /* MSI interrupt */
+		status = "disabled";
+
+		ranges = <0x000800 0 0x80000000 0x80000000 0 0x00001000   /* port 0 configuration space */
+			  0x000800 0 0x82000000 0x82000000 0 0x00010000   /* port 0 downstream I/O */
+			  0x000800 0 0xa0000000 0xa0000000 0 0x08000000   /* port 0 non-prefetchable memory */
+			  0x000800 0 0xb0000000 0xb0000000 0 0x08000000   /* port 0 prefetchable memory */
+
+			  0x001000 0 0x80001000 0x80001000 0 0x00001000   /* port 1 configuration space */
+			  0x001000 0 0x82010000 0x82010000 0 0x00010000   /* port 1 downstream I/O */
+			  0x001000 0 0xa8000000 0xa8000000 0 0x08000000   /* port 1 non-prefetchable memory */
+			  0x001000 0 0xb8000000 0xb8000000 0 0x08000000>; /* port 1 prefetchable memory */
+
+		bus-range = <0x00 0xff>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+
+		pci@1,0 {
+			device_type = "pciex";
+			reg = <0x000800 0 0x80000000 0 0x1000>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+
+			ranges = <0x81000000 0 0 0x000800 0 0x82000000 0 0x00010000   /* I/O */
+				  0x82000000 0 0 0x000800 0 0xa0000000 0 0x08000000   /* non-prefetchable memory */
+				  0xc2000000 0 0 0x000800 0 0xb0000000 0 0x08000000>; /* prefetchable memory */
+
+			nvidia,num-lanes = <2>;
+		};
+
+		pci@2,0 {
+			device_type = "pciex";
+			reg = <0x0010000 0 0x80001000 0 0x1000>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+
+			ranges = <0x81000000 0 0 0x001000 0 0x82010000 0 0x00010000   /* I/O */
+				  0x82000000 0 0 0x001000 0 0xa8000000 0 0x08000000   /* non-prefetchable memory */
+				  0xc2000000 0 0 0x001000 0 0xb8000000 0 0x08000000>; /* prefetchable memory */
+
+			nvidia,num-lanes = <2>;
+		};
+	};
+
+Board DTS:
+
+	pcie-controller {
+		vdd-supply = <&pci_vdd_reg>;
+		pex-clk-supply = <&pci_clk_reg>;
+		status = "okay";
+
+		/* root port 00:01.0 */
+		pci@1,0 {
+			status = "okay";
+
+			/* bridge 01:00.0 */
+			pci@0,0 {
+				reg = <0x010000 0 0 0 0>;
+
+				#address-cells = <3>;
+				#size-cells = <2>;
+
+				device_type = "pci";
+
+				/* endpoint 02:00.0 */
+				pci@0,0 {
+					reg = <0x020000 0 0 0 0>;
+				};
+			};
+		};
+	};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9862590..8853fef 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -653,6 +653,8 @@ config ARCH_TEGRA
 	select MIGHT_HAVE_CACHE_L2X0
 	select SPARSE_IRQ
 	select USE_OF
+	select MIGHT_HAVE_PCI
+	select ARCH_SUPPORTS_MSI
 	help
 	  This enables support for NVIDIA Tegra based systems (Tegra APX,
 	  Tegra 6xx and Tegra 2 series).
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 37973e6..1d30bf3 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -386,6 +386,51 @@
 		#size-cells = <0>;
 	};
 
+	pcie-controller {
+		compatible = "nvidia,tegra20-pcie";
+		reg = <0x80003000 0x00000800   /* PADS registers */
+		       0x80003800 0x00000200   /* AFI registers */
+		       0x90000000 0x10000000>; /* configuration space */
+		reg-names = "pads", "afi", "cs";
+		interrupts = <0 98 0x04   /* controller interrupt */
+		              0 99 0x04>; /* MSI interrupt */
+		interrupt-names = "intr", "msi";
+
+		bus-range = <0x00 0xff>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+
+		ranges = <0x00000800 0 0x80000000 0x80000000 0 0x00001000   /* port 0 registers */
+			  0x00001000 0 0x80001000 0x80001000 0 0x00001000   /* port 1 registers */
+			  0x81000000 0 0          0x82000000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0          0xa0000000 0 0x10000000   /* non-prefetchable memory */
+			  0xc2000000 0 0          0xb0000000 0 0x10000000>; /* prefetchable memory */
+
+		status = "disabled";
+
+		pci@1,0 {
+			device_type = "pciex";
+			reg = <0x000800 0 0x80000000 0 0x1000>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+
+			nvidia,num-lanes = <2>;
+		};
+
+		pci@2,0 {
+			device_type = "pciex";
+			reg = <0x001000 0 0x80001000 0 0x1000>;
+			status = "disabled";
+
+			#address-cells = <3>;
+			#size-cells = <2>;
+
+			nvidia,num-lanes = <2>;
+		};
+	};
+
 	usb@c5000000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
 		reg = <0xc5000000 0x4000>;
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 1ec7f80..79aa3bf 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -44,11 +44,6 @@ config ARCH_TEGRA_3x_SOC
 	  Support for NVIDIA Tegra T30 processor family, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
 
-config TEGRA_PCI
-	bool "PCI Express support"
-	depends on ARCH_TEGRA_2x_SOC
-	select PCI
-
 config TEGRA_AHB
 	bool "Enable AHB driver for NVIDIA Tegra SoCs"
 	default y
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 660ee03..463a77e 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -29,7 +29,6 @@ endif
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
 obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
-obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
 obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= board-dt-tegra30.o
diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 5d28db3..5644dfb 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -148,11 +148,7 @@ static void __init tegra_dt_init(void)
 static void __init trimslice_init(void)
 {
 #ifdef CONFIG_TEGRA_PCI
-	int ret;
-
-	ret = tegra_pcie_init(true, true);
-	if (ret)
-		pr_err("tegra_pci_init() failed: %d\n", ret);
+	platform_device_register(&tegra_pcie_device);
 #endif
 }
 
diff --git a/arch/arm/mach-tegra/board-harmony-pcie.c b/arch/arm/mach-tegra/board-harmony-pcie.c
index 3cdc1bb..94c0529 100644
--- a/arch/arm/mach-tegra/board-harmony-pcie.c
+++ b/arch/arm/mach-tegra/board-harmony-pcie.c
@@ -23,11 +23,12 @@
 
 #include <asm/mach-types.h>
 
+#include <mach/pci-tegra.h>
+
 #include "board.h"
 
 #ifdef CONFIG_TEGRA_PCI
-
-int __init harmony_pcie_init(void)
+static int harmony_pcie_board_init(struct platform_device *pdev)
 {
 	struct device_node *np;
 	int en_vdd_1v05;
@@ -64,21 +65,24 @@ int __init harmony_pcie_init(void)
 
 	regulator_enable(regulator);
 
-	err = tegra_pcie_init(true, true);
-	if (err) {
-		pr_err("%s: tegra_pcie_init failed: %d\n", __func__, err);
-		goto err_pcie;
-	}
-
 	return 0;
 
-err_pcie:
-	regulator_disable(regulator);
-	regulator_put(regulator);
 err_reg:
 	gpio_free(en_vdd_1v05);
 
 	return err;
 }
 
+int __init harmony_pcie_init(void)
+{
+	tegra_pcie_pdata.init = harmony_pcie_board_init;
+	platform_device_register(&tegra_pcie_device);
+
+	return 0;
+}
+#else
+int __init harmony_pcie_init(void)
+{
+	return 0;
+}
 #endif
diff --git a/arch/arm/mach-tegra/board.h b/arch/arm/mach-tegra/board.h
index da8f5a3..8294ed3 100644
--- a/arch/arm/mach-tegra/board.h
+++ b/arch/arm/mach-tegra/board.h
@@ -30,7 +30,6 @@ void __init tegra30_init_early(void);
 void __init tegra_map_common_io(void);
 void __init tegra_init_irq(void);
 void __init tegra_dt_init_irq(void);
-int __init tegra_pcie_init(bool init_port0, bool init_port1);
 
 void tegra_init_late(void);
 
@@ -49,6 +48,9 @@ static inline int tegra_powergate_debugfs_init(void) { return 0; }
 int __init harmony_regulator_init(void);
 #ifdef CONFIG_TEGRA_PCI
 int __init harmony_pcie_init(void);
+
+extern struct tegra_pcie_pdata tegra_pcie_pdata;
+extern struct platform_device tegra_pcie_device;
 #else
 static inline int harmony_pcie_init(void) { return 0; }
 #endif
diff --git a/arch/arm/mach-tegra/iomap.h b/arch/arm/mach-tegra/iomap.h
index db8be51..216046d 100644
--- a/arch/arm/mach-tegra/iomap.h
+++ b/arch/arm/mach-tegra/iomap.h
@@ -287,9 +287,6 @@
 #define IO_APB_VIRT	IOMEM(0xFE300000)
 #define IO_APB_SIZE	SZ_1M
 
-#define TEGRA_PCIE_BASE		0x80000000
-#define TEGRA_PCIE_IO_BASE	(TEGRA_PCIE_BASE + SZ_4M)
-
 #define IO_TO_VIRT_BETWEEN(p, st, sz)	((p) >= (st) && (p) < ((st) + (sz)))
 #define IO_TO_VIRT_XLATE(p, pst, vst)	(((p) - (pst) + (vst)))
 
diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
deleted file mode 100644
index c2d55f8..0000000
--- a/arch/arm/mach-tegra/pcie.c
+++ /dev/null
@@ -1,865 +0,0 @@
-/*
- * arch/arm/mach-tegra/pci.c
- *
- * PCIe host controller driver for TEGRA(2) SOCs
- *
- * Copyright (c) 2010, CompuLab, Ltd.
- * Author: Mike Rapoport <mike@compulab.co.il>
- *
- * Based on NVIDIA PCIe driver
- * Copyright (c) 2008-2009, NVIDIA Corporation.
- *
- * Bits taken from arch/arm/mach-dove/pcie.c
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- */
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/clk.h>
-#include <linux/delay.h>
-#include <linux/export.h>
-
-#include <asm/sizes.h>
-#include <asm/mach/pci.h>
-
-#include <mach/clk.h>
-#include <mach/powergate.h>
-
-#include "board.h"
-#include "iomap.h"
-#include "pmc.h"
-
-/* Hack - need to parse this from DT */
-#define INT_PCIE_INTR 130
-
-/* register definitions */
-#define AFI_OFFSET	0x3800
-#define PADS_OFFSET	0x3000
-#define RP0_OFFSET	0x0000
-#define RP1_OFFSET	0x1000
-
-#define AFI_AXI_BAR0_SZ	0x00
-#define AFI_AXI_BAR1_SZ	0x04
-#define AFI_AXI_BAR2_SZ	0x08
-#define AFI_AXI_BAR3_SZ	0x0c
-#define AFI_AXI_BAR4_SZ	0x10
-#define AFI_AXI_BAR5_SZ	0x14
-
-#define AFI_AXI_BAR0_START	0x18
-#define AFI_AXI_BAR1_START	0x1c
-#define AFI_AXI_BAR2_START	0x20
-#define AFI_AXI_BAR3_START	0x24
-#define AFI_AXI_BAR4_START	0x28
-#define AFI_AXI_BAR5_START	0x2c
-
-#define AFI_FPCI_BAR0	0x30
-#define AFI_FPCI_BAR1	0x34
-#define AFI_FPCI_BAR2	0x38
-#define AFI_FPCI_BAR3	0x3c
-#define AFI_FPCI_BAR4	0x40
-#define AFI_FPCI_BAR5	0x44
-
-#define AFI_CACHE_BAR0_SZ	0x48
-#define AFI_CACHE_BAR0_ST	0x4c
-#define AFI_CACHE_BAR1_SZ	0x50
-#define AFI_CACHE_BAR1_ST	0x54
-
-#define AFI_MSI_BAR_SZ		0x60
-#define AFI_MSI_FPCI_BAR_ST	0x64
-#define AFI_MSI_AXI_BAR_ST	0x68
-
-#define AFI_CONFIGURATION		0xac
-#define  AFI_CONFIGURATION_EN_FPCI	(1 << 0)
-
-#define AFI_FPCI_ERROR_MASKS	0xb0
-
-#define AFI_INTR_MASK		0xb4
-#define  AFI_INTR_MASK_INT_MASK	(1 << 0)
-#define  AFI_INTR_MASK_MSI_MASK	(1 << 8)
-
-#define AFI_INTR_CODE		0xb8
-#define  AFI_INTR_CODE_MASK	0xf
-#define  AFI_INTR_MASTER_ABORT	4
-#define  AFI_INTR_LEGACY	6
-
-#define AFI_INTR_SIGNATURE	0xbc
-#define AFI_SM_INTR_ENABLE	0xc4
-
-#define AFI_AFI_INTR_ENABLE		0xc8
-#define  AFI_INTR_EN_INI_SLVERR		(1 << 0)
-#define  AFI_INTR_EN_INI_DECERR		(1 << 1)
-#define  AFI_INTR_EN_TGT_SLVERR		(1 << 2)
-#define  AFI_INTR_EN_TGT_DECERR		(1 << 3)
-#define  AFI_INTR_EN_TGT_WRERR		(1 << 4)
-#define  AFI_INTR_EN_DFPCI_DECERR	(1 << 5)
-#define  AFI_INTR_EN_AXI_DECERR		(1 << 6)
-#define  AFI_INTR_EN_FPCI_TIMEOUT	(1 << 7)
-
-#define AFI_PCIE_CONFIG					0x0f8
-#define  AFI_PCIE_CONFIG_PCIEC0_DISABLE_DEVICE		(1 << 1)
-#define  AFI_PCIE_CONFIG_PCIEC1_DISABLE_DEVICE		(1 << 2)
-#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK	(0xf << 20)
-#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE	(0x0 << 20)
-#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL	(0x1 << 20)
-
-#define AFI_FUSE			0x104
-#define  AFI_FUSE_PCIE_T0_GEN2_DIS	(1 << 2)
-
-#define AFI_PEX0_CTRL			0x110
-#define AFI_PEX1_CTRL			0x118
-#define  AFI_PEX_CTRL_RST		(1 << 0)
-#define  AFI_PEX_CTRL_REFCLK_EN		(1 << 3)
-
-#define RP_VEND_XP	0x00000F00
-#define  RP_VEND_XP_DL_UP	(1 << 30)
-
-#define RP_LINK_CONTROL_STATUS			0x00000090
-#define  RP_LINK_CONTROL_STATUS_LINKSTAT_MASK	0x3fff0000
-
-#define PADS_CTL_SEL		0x0000009C
-
-#define PADS_CTL		0x000000A0
-#define  PADS_CTL_IDDQ_1L	(1 << 0)
-#define  PADS_CTL_TX_DATA_EN_1L	(1 << 6)
-#define  PADS_CTL_RX_DATA_EN_1L	(1 << 10)
-
-#define PADS_PLL_CTL				0x000000B8
-#define  PADS_PLL_CTL_RST_B4SM			(1 << 1)
-#define  PADS_PLL_CTL_LOCKDET			(1 << 8)
-#define  PADS_PLL_CTL_REFCLK_MASK		(0x3 << 16)
-#define  PADS_PLL_CTL_REFCLK_INTERNAL_CML	(0 << 16)
-#define  PADS_PLL_CTL_REFCLK_INTERNAL_CMOS	(1 << 16)
-#define  PADS_PLL_CTL_REFCLK_EXTERNAL		(2 << 16)
-#define  PADS_PLL_CTL_TXCLKREF_MASK		(0x1 << 20)
-#define  PADS_PLL_CTL_TXCLKREF_DIV10		(0 << 20)
-#define  PADS_PLL_CTL_TXCLKREF_DIV5		(1 << 20)
-
-/*
- * Tegra2 defines 1GB in the AXI address map for PCIe.
- *
- * That address space is split into different regions, with sizes and
- * offsets as follows:
- *
- * 0x80000000 - 0x80003fff - PCI controller registers
- * 0x80004000 - 0x80103fff - PCI configuration space
- * 0x80104000 - 0x80203fff - PCI extended configuration space
- * 0x80203fff - 0x803fffff - unused
- * 0x80400000 - 0x8040ffff - downstream IO
- * 0x80410000 - 0x8fffffff - unused
- * 0x90000000 - 0x9fffffff - non-prefetchable memory
- * 0xa0000000 - 0xbfffffff - prefetchable memory
- */
-#define PCIE_REGS_SZ		SZ_16K
-#define PCIE_CFG_OFF		PCIE_REGS_SZ
-#define PCIE_CFG_SZ		SZ_1M
-#define PCIE_EXT_CFG_OFF	(PCIE_CFG_SZ + PCIE_CFG_OFF)
-#define PCIE_EXT_CFG_SZ		SZ_1M
-#define PCIE_IOMAP_SZ		(PCIE_REGS_SZ + PCIE_CFG_SZ + PCIE_EXT_CFG_SZ)
-
-#define MEM_BASE_0		(TEGRA_PCIE_BASE + SZ_256M)
-#define MEM_SIZE_0		SZ_128M
-#define MEM_BASE_1		(MEM_BASE_0 + MEM_SIZE_0)
-#define MEM_SIZE_1		SZ_128M
-#define PREFETCH_MEM_BASE_0	(MEM_BASE_1 + MEM_SIZE_1)
-#define PREFETCH_MEM_SIZE_0	SZ_128M
-#define PREFETCH_MEM_BASE_1	(PREFETCH_MEM_BASE_0 + PREFETCH_MEM_SIZE_0)
-#define PREFETCH_MEM_SIZE_1	SZ_128M
-
-#define  PCIE_CONF_BUS(b)	((b) << 16)
-#define  PCIE_CONF_DEV(d)	((d) << 11)
-#define  PCIE_CONF_FUNC(f)	((f) << 8)
-#define  PCIE_CONF_REG(r)	\
-	(((r) & ~0x3) | (((r) < 256) ? PCIE_CFG_OFF : PCIE_EXT_CFG_OFF))
-
-struct tegra_pcie_port {
-	int			index;
-	u8			root_bus_nr;
-	void __iomem		*base;
-
-	bool			link_up;
-
-	char			mem_space_name[16];
-	char			prefetch_space_name[20];
-	struct resource		res[2];
-};
-
-struct tegra_pcie_info {
-	struct tegra_pcie_port	port[2];
-	int			num_ports;
-
-	void __iomem		*regs;
-	struct resource		res_mmio;
-
-	struct clk		*pex_clk;
-	struct clk		*afi_clk;
-	struct clk		*pcie_xclk;
-	struct clk		*pll_e;
-};
-
-static struct tegra_pcie_info tegra_pcie;
-
-static inline void afi_writel(u32 value, unsigned long offset)
-{
-	writel(value, offset + AFI_OFFSET + tegra_pcie.regs);
-}
-
-static inline u32 afi_readl(unsigned long offset)
-{
-	return readl(offset + AFI_OFFSET + tegra_pcie.regs);
-}
-
-static inline void pads_writel(u32 value, unsigned long offset)
-{
-	writel(value, offset + PADS_OFFSET + tegra_pcie.regs);
-}
-
-static inline u32 pads_readl(unsigned long offset)
-{
-	return readl(offset + PADS_OFFSET + tegra_pcie.regs);
-}
-
-static struct tegra_pcie_port *bus_to_port(int bus)
-{
-	int i;
-
-	for (i = tegra_pcie.num_ports - 1; i >= 0; i--) {
-		int rbus = tegra_pcie.port[i].root_bus_nr;
-		if (rbus != -1 && rbus == bus)
-			break;
-	}
-
-	return i >= 0 ? tegra_pcie.port + i : NULL;
-}
-
-static int tegra_pcie_read_conf(struct pci_bus *bus, unsigned int devfn,
-				int where, int size, u32 *val)
-{
-	struct tegra_pcie_port *pp = bus_to_port(bus->number);
-	void __iomem *addr;
-
-	if (pp) {
-		if (devfn != 0) {
-			*val = 0xffffffff;
-			return PCIBIOS_DEVICE_NOT_FOUND;
-		}
-
-		addr = pp->base + (where & ~0x3);
-	} else {
-		addr = tegra_pcie.regs + (PCIE_CONF_BUS(bus->number) +
-					  PCIE_CONF_DEV(PCI_SLOT(devfn)) +
-					  PCIE_CONF_FUNC(PCI_FUNC(devfn)) +
-					  PCIE_CONF_REG(where));
-	}
-
-	*val = readl(addr);
-
-	if (size == 1)
-		*val = (*val >> (8 * (where & 3))) & 0xff;
-	else if (size == 2)
-		*val = (*val >> (8 * (where & 3))) & 0xffff;
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static int tegra_pcie_write_conf(struct pci_bus *bus, unsigned int devfn,
-				 int where, int size, u32 val)
-{
-	struct tegra_pcie_port *pp = bus_to_port(bus->number);
-	void __iomem *addr;
-
-	u32 mask;
-	u32 tmp;
-
-	if (pp) {
-		if (devfn != 0)
-			return PCIBIOS_DEVICE_NOT_FOUND;
-
-		addr = pp->base + (where & ~0x3);
-	} else {
-		addr = tegra_pcie.regs + (PCIE_CONF_BUS(bus->number) +
-					  PCIE_CONF_DEV(PCI_SLOT(devfn)) +
-					  PCIE_CONF_FUNC(PCI_FUNC(devfn)) +
-					  PCIE_CONF_REG(where));
-	}
-
-	if (size == 4) {
-		writel(val, addr);
-		return PCIBIOS_SUCCESSFUL;
-	}
-
-	if (size == 2)
-		mask = ~(0xffff << ((where & 0x3) * 8));
-	else if (size == 1)
-		mask = ~(0xff << ((where & 0x3) * 8));
-	else
-		return PCIBIOS_BAD_REGISTER_NUMBER;
-
-	tmp = readl(addr) & mask;
-	tmp |= val << ((where & 0x3) * 8);
-	writel(tmp, addr);
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-static struct pci_ops tegra_pcie_ops = {
-	.read	= tegra_pcie_read_conf,
-	.write	= tegra_pcie_write_conf,
-};
-
-static void tegra_pcie_fixup_bridge(struct pci_dev *dev)
-{
-	u16 reg;
-
-	if ((dev->class >> 16) == PCI_BASE_CLASS_BRIDGE) {
-		pci_read_config_word(dev, PCI_COMMAND, &reg);
-		reg |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-			PCI_COMMAND_MASTER | PCI_COMMAND_SERR);
-		pci_write_config_word(dev, PCI_COMMAND, reg);
-	}
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_fixup_bridge);
-
-/* Tegra PCIE root complex wrongly reports device class */
-static void tegra_pcie_fixup_class(struct pci_dev *dev)
-{
-	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
-}
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_fixup_class);
-DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
-
-/* Tegra PCIE requires relaxed ordering */
-static void tegra_pcie_relax_enable(struct pci_dev *dev)
-{
-	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_RELAX_EN);
-}
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
-
-static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
-{
-	struct tegra_pcie_port *pp;
-
-	if (nr >= tegra_pcie.num_ports)
-		return 0;
-
-	pp = tegra_pcie.port + nr;
-	pp->root_bus_nr = sys->busnr;
-
-	pci_ioremap_io(nr * SZ_64K, TEGRA_PCIE_IO_BASE);
-
-	/*
-	 * IORESOURCE_MEM
-	 */
-	snprintf(pp->mem_space_name, sizeof(pp->mem_space_name),
-		 "PCIe %d MEM", pp->index);
-	pp->mem_space_name[sizeof(pp->mem_space_name) - 1] = 0;
-	pp->res[0].name = pp->mem_space_name;
-	if (pp->index == 0) {
-		pp->res[0].start = MEM_BASE_0;
-		pp->res[0].end = pp->res[0].start + MEM_SIZE_0 - 1;
-	} else {
-		pp->res[0].start = MEM_BASE_1;
-		pp->res[0].end = pp->res[0].start + MEM_SIZE_1 - 1;
-	}
-	pp->res[0].flags = IORESOURCE_MEM;
-	if (request_resource(&iomem_resource, &pp->res[0]))
-		panic("Request PCIe Memory resource failed\n");
-	pci_add_resource_offset(&sys->resources, &pp->res[0], sys->mem_offset);
-
-	/*
-	 * IORESOURCE_MEM | IORESOURCE_PREFETCH
-	 */
-	snprintf(pp->prefetch_space_name, sizeof(pp->prefetch_space_name),
-		 "PCIe %d PREFETCH MEM", pp->index);
-	pp->prefetch_space_name[sizeof(pp->prefetch_space_name) - 1] = 0;
-	pp->res[1].name = pp->prefetch_space_name;
-	if (pp->index == 0) {
-		pp->res[1].start = PREFETCH_MEM_BASE_0;
-		pp->res[1].end = pp->res[1].start + PREFETCH_MEM_SIZE_0 - 1;
-	} else {
-		pp->res[1].start = PREFETCH_MEM_BASE_1;
-		pp->res[1].end = pp->res[1].start + PREFETCH_MEM_SIZE_1 - 1;
-	}
-	pp->res[1].flags = IORESOURCE_MEM | IORESOURCE_PREFETCH;
-	if (request_resource(&iomem_resource, &pp->res[1]))
-		panic("Request PCIe Prefetch Memory resource failed\n");
-	pci_add_resource_offset(&sys->resources, &pp->res[1], sys->mem_offset);
-
-	return 1;
-}
-
-static int tegra_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
-{
-	return INT_PCIE_INTR;
-}
-
-static struct pci_bus __init *tegra_pcie_scan_bus(int nr,
-						  struct pci_sys_data *sys)
-{
-	struct tegra_pcie_port *pp;
-
-	if (nr >= tegra_pcie.num_ports)
-		return NULL;
-
-	pp = tegra_pcie.port + nr;
-	pp->root_bus_nr = sys->busnr;
-
-	return pci_scan_root_bus(NULL, sys->busnr, &tegra_pcie_ops, sys,
-				 &sys->resources);
-}
-
-static struct hw_pci tegra_pcie_hw __initdata = {
-	.nr_controllers	= 2,
-	.setup		= tegra_pcie_setup,
-	.scan		= tegra_pcie_scan_bus,
-	.map_irq	= tegra_pcie_map_irq,
-};
-
-
-static irqreturn_t tegra_pcie_isr(int irq, void *arg)
-{
-	const char *err_msg[] = {
-		"Unknown",
-		"AXI slave error",
-		"AXI decode error",
-		"Target abort",
-		"Master abort",
-		"Invalid write",
-		"Response decoding error",
-		"AXI response decoding error",
-		"Transcation timeout",
-	};
-
-	u32 code, signature;
-
-	code = afi_readl(AFI_INTR_CODE) & AFI_INTR_CODE_MASK;
-	signature = afi_readl(AFI_INTR_SIGNATURE);
-	afi_writel(0, AFI_INTR_CODE);
-
-	if (code == AFI_INTR_LEGACY)
-		return IRQ_NONE;
-
-	if (code >= ARRAY_SIZE(err_msg))
-		code = 0;
-
-	/*
-	 * do not pollute kernel log with master abort reports since they
-	 * happen a lot during enumeration
-	 */
-	if (code == AFI_INTR_MASTER_ABORT)
-		pr_debug("PCIE: %s, signature: %08x\n", err_msg[code], signature);
-	else
-		pr_err("PCIE: %s, signature: %08x\n", err_msg[code], signature);
-
-	return IRQ_HANDLED;
-}
-
-static void tegra_pcie_setup_translations(void)
-{
-	u32 fpci_bar;
-	u32 size;
-	u32 axi_address;
-
-	/* Bar 0: config Bar */
-	fpci_bar = ((u32)0xfdff << 16);
-	size = PCIE_CFG_SZ;
-	axi_address = TEGRA_PCIE_BASE + PCIE_CFG_OFF;
-	afi_writel(axi_address, AFI_AXI_BAR0_START);
-	afi_writel(size >> 12, AFI_AXI_BAR0_SZ);
-	afi_writel(fpci_bar, AFI_FPCI_BAR0);
-
-	/* Bar 1: extended config Bar */
-	fpci_bar = ((u32)0xfe1 << 20);
-	size = PCIE_EXT_CFG_SZ;
-	axi_address = TEGRA_PCIE_BASE + PCIE_EXT_CFG_OFF;
-	afi_writel(axi_address, AFI_AXI_BAR1_START);
-	afi_writel(size >> 12, AFI_AXI_BAR1_SZ);
-	afi_writel(fpci_bar, AFI_FPCI_BAR1);
-
-	/* Bar 2: downstream IO bar */
-	fpci_bar = ((__u32)0xfdfc << 16);
-	size = SZ_128K;
-	axi_address = TEGRA_PCIE_IO_BASE;
-	afi_writel(axi_address, AFI_AXI_BAR2_START);
-	afi_writel(size >> 12, AFI_AXI_BAR2_SZ);
-	afi_writel(fpci_bar, AFI_FPCI_BAR2);
-
-	/* Bar 3: prefetchable memory BAR */
-	fpci_bar = (((PREFETCH_MEM_BASE_0 >> 12) & 0x0fffffff) << 4) | 0x1;
-	size =  PREFETCH_MEM_SIZE_0 +  PREFETCH_MEM_SIZE_1;
-	axi_address = PREFETCH_MEM_BASE_0;
-	afi_writel(axi_address, AFI_AXI_BAR3_START);
-	afi_writel(size >> 12, AFI_AXI_BAR3_SZ);
-	afi_writel(fpci_bar, AFI_FPCI_BAR3);
-
-	/* Bar 4: non prefetchable memory BAR */
-	fpci_bar = (((MEM_BASE_0 >> 12)	& 0x0FFFFFFF) << 4) | 0x1;
-	size = MEM_SIZE_0 + MEM_SIZE_1;
-	axi_address = MEM_BASE_0;
-	afi_writel(axi_address, AFI_AXI_BAR4_START);
-	afi_writel(size >> 12, AFI_AXI_BAR4_SZ);
-	afi_writel(fpci_bar, AFI_FPCI_BAR4);
-
-	/* Bar 5: NULL out the remaining BAR as it is not used */
-	fpci_bar = 0;
-	size = 0;
-	axi_address = 0;
-	afi_writel(axi_address, AFI_AXI_BAR5_START);
-	afi_writel(size >> 12, AFI_AXI_BAR5_SZ);
-	afi_writel(fpci_bar, AFI_FPCI_BAR5);
-
-	/* map all upstream transactions as uncached */
-	afi_writel(PHYS_OFFSET, AFI_CACHE_BAR0_ST);
-	afi_writel(0, AFI_CACHE_BAR0_SZ);
-	afi_writel(0, AFI_CACHE_BAR1_ST);
-	afi_writel(0, AFI_CACHE_BAR1_SZ);
-
-	/* No MSI */
-	afi_writel(0, AFI_MSI_FPCI_BAR_ST);
-	afi_writel(0, AFI_MSI_BAR_SZ);
-	afi_writel(0, AFI_MSI_AXI_BAR_ST);
-	afi_writel(0, AFI_MSI_BAR_SZ);
-}
-
-static int tegra_pcie_enable_controller(void)
-{
-	u32 val, reg;
-	int i, timeout;
-
-	/* Enable slot clock and pulse the reset signals */
-	for (i = 0, reg = AFI_PEX0_CTRL; i < 2; i++, reg += 0x8) {
-		val = afi_readl(reg) |  AFI_PEX_CTRL_REFCLK_EN;
-		afi_writel(val, reg);
-		val &= ~AFI_PEX_CTRL_RST;
-		afi_writel(val, reg);
-
-		val = afi_readl(reg) | AFI_PEX_CTRL_RST;
-		afi_writel(val, reg);
-	}
-
-	/* Enable dual controller and both ports */
-	val = afi_readl(AFI_PCIE_CONFIG);
-	val &= ~(AFI_PCIE_CONFIG_PCIEC0_DISABLE_DEVICE |
-		 AFI_PCIE_CONFIG_PCIEC1_DISABLE_DEVICE |
-		 AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK);
-	val |= AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
-	afi_writel(val, AFI_PCIE_CONFIG);
-
-	val = afi_readl(AFI_FUSE) & ~AFI_FUSE_PCIE_T0_GEN2_DIS;
-	afi_writel(val, AFI_FUSE);
-
-	/* Initialze internal PHY, enable up to 16 PCIE lanes */
-	pads_writel(0x0, PADS_CTL_SEL);
-
-	/* override IDDQ to 1 on all 4 lanes */
-	val = pads_readl(PADS_CTL) | PADS_CTL_IDDQ_1L;
-	pads_writel(val, PADS_CTL);
-
-	/*
-	 * set up PHY PLL inputs select PLLE output as refclock,
-	 * set TX ref sel to div10 (not div5)
-	 */
-	val = pads_readl(PADS_PLL_CTL);
-	val &= ~(PADS_PLL_CTL_REFCLK_MASK | PADS_PLL_CTL_TXCLKREF_MASK);
-	val |= (PADS_PLL_CTL_REFCLK_INTERNAL_CML | PADS_PLL_CTL_TXCLKREF_DIV10);
-	pads_writel(val, PADS_PLL_CTL);
-
-	/* take PLL out of reset  */
-	val = pads_readl(PADS_PLL_CTL) | PADS_PLL_CTL_RST_B4SM;
-	pads_writel(val, PADS_PLL_CTL);
-
-	/*
-	 * Hack, set the clock voltage to the DEFAULT provided by hw folks.
-	 * This doesn't exist in the documentation
-	 */
-	pads_writel(0xfa5cfa5c, 0xc8);
-
-	/* Wait for the PLL to lock */
-	timeout = 300;
-	do {
-		val = pads_readl(PADS_PLL_CTL);
-		usleep_range(1000, 1000);
-		if (--timeout == 0) {
-			pr_err("Tegra PCIe error: timeout waiting for PLL\n");
-			return -EBUSY;
-		}
-	} while (!(val & PADS_PLL_CTL_LOCKDET));
-
-	/* turn off IDDQ override */
-	val = pads_readl(PADS_CTL) & ~PADS_CTL_IDDQ_1L;
-	pads_writel(val, PADS_CTL);
-
-	/* enable TX/RX data */
-	val = pads_readl(PADS_CTL);
-	val |= (PADS_CTL_TX_DATA_EN_1L | PADS_CTL_RX_DATA_EN_1L);
-	pads_writel(val, PADS_CTL);
-
-	/* Take the PCIe interface module out of reset */
-	tegra_periph_reset_deassert(tegra_pcie.pcie_xclk);
-
-	/* Finally enable PCIe */
-	val = afi_readl(AFI_CONFIGURATION) | AFI_CONFIGURATION_EN_FPCI;
-	afi_writel(val, AFI_CONFIGURATION);
-
-	val = (AFI_INTR_EN_INI_SLVERR | AFI_INTR_EN_INI_DECERR |
-	       AFI_INTR_EN_TGT_SLVERR | AFI_INTR_EN_TGT_DECERR |
-	       AFI_INTR_EN_TGT_WRERR | AFI_INTR_EN_DFPCI_DECERR);
-	afi_writel(val, AFI_AFI_INTR_ENABLE);
-	afi_writel(0xffffffff, AFI_SM_INTR_ENABLE);
-
-	/* FIXME: No MSI for now, only INT */
-	afi_writel(AFI_INTR_MASK_INT_MASK, AFI_INTR_MASK);
-
-	/* Disable all execptions */
-	afi_writel(0, AFI_FPCI_ERROR_MASKS);
-
-	return 0;
-}
-
-static void tegra_pcie_power_off(void)
-{
-	tegra_periph_reset_assert(tegra_pcie.pcie_xclk);
-	tegra_periph_reset_assert(tegra_pcie.afi_clk);
-	tegra_periph_reset_assert(tegra_pcie.pex_clk);
-
-	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
-	tegra_pmc_pcie_xclk_clamp(true);
-}
-
-static int tegra_pcie_power_regate(void)
-{
-	int err;
-
-	tegra_pcie_power_off();
-
-	tegra_pmc_pcie_xclk_clamp(true);
-
-	tegra_periph_reset_assert(tegra_pcie.pcie_xclk);
-	tegra_periph_reset_assert(tegra_pcie.afi_clk);
-
-	err = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_PCIE,
-						tegra_pcie.pex_clk);
-	if (err) {
-		pr_err("PCIE: powerup sequence failed: %d\n", err);
-		return err;
-	}
-
-	tegra_periph_reset_deassert(tegra_pcie.afi_clk);
-
-	tegra_pmc_pcie_xclk_clamp(false);
-
-	clk_prepare_enable(tegra_pcie.afi_clk);
-	clk_prepare_enable(tegra_pcie.pex_clk);
-	return clk_prepare_enable(tegra_pcie.pll_e);
-}
-
-static int tegra_pcie_clocks_get(void)
-{
-	int err;
-
-	tegra_pcie.pex_clk = clk_get(NULL, "pex");
-	if (IS_ERR(tegra_pcie.pex_clk))
-		return PTR_ERR(tegra_pcie.pex_clk);
-
-	tegra_pcie.afi_clk = clk_get(NULL, "afi");
-	if (IS_ERR(tegra_pcie.afi_clk)) {
-		err = PTR_ERR(tegra_pcie.afi_clk);
-		goto err_afi_clk;
-	}
-
-	tegra_pcie.pcie_xclk = clk_get(NULL, "pcie_xclk");
-	if (IS_ERR(tegra_pcie.pcie_xclk)) {
-		err =  PTR_ERR(tegra_pcie.pcie_xclk);
-		goto err_pcie_xclk;
-	}
-
-	tegra_pcie.pll_e = clk_get_sys(NULL, "pll_e");
-	if (IS_ERR(tegra_pcie.pll_e)) {
-		err = PTR_ERR(tegra_pcie.pll_e);
-		goto err_pll_e;
-	}
-
-	return 0;
-
-err_pll_e:
-	clk_put(tegra_pcie.pcie_xclk);
-err_pcie_xclk:
-	clk_put(tegra_pcie.afi_clk);
-err_afi_clk:
-	clk_put(tegra_pcie.pex_clk);
-
-	return err;
-}
-
-static void tegra_pcie_clocks_put(void)
-{
-	clk_put(tegra_pcie.pll_e);
-	clk_put(tegra_pcie.pcie_xclk);
-	clk_put(tegra_pcie.afi_clk);
-	clk_put(tegra_pcie.pex_clk);
-}
-
-static int __init tegra_pcie_get_resources(void)
-{
-	int err;
-
-	err = tegra_pcie_clocks_get();
-	if (err) {
-		pr_err("PCIE: failed to get clocks: %d\n", err);
-		return err;
-	}
-
-	err = tegra_pcie_power_regate();
-	if (err) {
-		pr_err("PCIE: failed to power up: %d\n", err);
-		goto err_pwr_on;
-	}
-
-	tegra_pcie.regs = ioremap_nocache(TEGRA_PCIE_BASE, PCIE_IOMAP_SZ);
-	if (tegra_pcie.regs == NULL) {
-		pr_err("PCIE: Failed to map PCI/AFI registers\n");
-		err = -ENOMEM;
-		goto err_map_reg;
-	}
-
-	err = request_irq(INT_PCIE_INTR, tegra_pcie_isr,
-			  IRQF_SHARED, "PCIE", &tegra_pcie);
-	if (err) {
-		pr_err("PCIE: Failed to register IRQ: %d\n", err);
-		goto err_req_io;
-	}
-	set_irq_flags(INT_PCIE_INTR, IRQF_VALID);
-
-	return 0;
-
-err_req_io:
-	iounmap(tegra_pcie.regs);
-err_map_reg:
-	tegra_pcie_power_off();
-err_pwr_on:
-	tegra_pcie_clocks_put();
-
-	return err;
-}
-
-/*
- * FIXME: If there are no PCIe cards attached, then calling this function
- * can result in the increase of the bootup time as there are big timeout
- * loops.
- */
-#define TEGRA_PCIE_LINKUP_TIMEOUT	200	/* up to 1.2 seconds */
-static bool tegra_pcie_check_link(struct tegra_pcie_port *pp, int idx,
-				  u32 reset_reg)
-{
-	u32 reg;
-	int retries = 3;
-	int timeout;
-
-	do {
-		timeout = TEGRA_PCIE_LINKUP_TIMEOUT;
-		while (timeout) {
-			reg = readl(pp->base + RP_VEND_XP);
-
-			if (reg & RP_VEND_XP_DL_UP)
-				break;
-
-			mdelay(1);
-			timeout--;
-		}
-
-		if (!timeout)  {
-			pr_err("PCIE: port %d: link down, retrying\n", idx);
-			goto retry;
-		}
-
-		timeout = TEGRA_PCIE_LINKUP_TIMEOUT;
-		while (timeout) {
-			reg = readl(pp->base + RP_LINK_CONTROL_STATUS);
-
-			if (reg & 0x20000000)
-				return true;
-
-			mdelay(1);
-			timeout--;
-		}
-
-retry:
-		/* Pulse the PEX reset */
-		reg = afi_readl(reset_reg) | AFI_PEX_CTRL_RST;
-		afi_writel(reg, reset_reg);
-		mdelay(1);
-		reg = afi_readl(reset_reg) & ~AFI_PEX_CTRL_RST;
-		afi_writel(reg, reset_reg);
-
-		retries--;
-	} while (retries);
-
-	return false;
-}
-
-static void __init tegra_pcie_add_port(int index, u32 offset, u32 reset_reg)
-{
-	struct tegra_pcie_port *pp;
-
-	pp = tegra_pcie.port + tegra_pcie.num_ports;
-
-	pp->index = -1;
-	pp->base = tegra_pcie.regs + offset;
-	pp->link_up = tegra_pcie_check_link(pp, index, reset_reg);
-
-	if (!pp->link_up) {
-		pp->base = NULL;
-		printk(KERN_INFO "PCIE: port %d: link down, ignoring\n", index);
-		return;
-	}
-
-	tegra_pcie.num_ports++;
-	pp->index = index;
-	pp->root_bus_nr = -1;
-	memset(pp->res, 0, sizeof(pp->res));
-}
-
-int __init tegra_pcie_init(bool init_port0, bool init_port1)
-{
-	int err;
-
-	if (!(init_port0 || init_port1))
-		return -ENODEV;
-
-	pcibios_min_mem = 0;
-
-	err = tegra_pcie_get_resources();
-	if (err)
-		return err;
-
-	err = tegra_pcie_enable_controller();
-	if (err)
-		return err;
-
-	/* setup the AFI address translations */
-	tegra_pcie_setup_translations();
-
-	if (init_port0)
-		tegra_pcie_add_port(0, RP0_OFFSET, AFI_PEX0_CTRL);
-
-	if (init_port1)
-		tegra_pcie_add_port(1, RP1_OFFSET, AFI_PEX1_CTRL);
-
-	pci_common_init(&tegra_pcie_hw);
-
-	return 0;
-}
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 6d51aa6..ac45398 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -119,3 +119,5 @@ config PCI_IOAPIC
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
+
+source "drivers/pci/host/Kconfig"
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 0c3efcf..6ebf5bf 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -67,3 +67,6 @@ obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
 obj-$(CONFIG_OF) += of.o
 
 ccflags-$(CONFIG_PCI_DEBUG) := -DDEBUG
+
+# PCI host controller drivers
+obj-y += host/
diff --git a/drivers/pci/host/Kconfig b/drivers/pci/host/Kconfig
new file mode 100644
index 0000000..683e105
--- /dev/null
+++ b/drivers/pci/host/Kconfig
@@ -0,0 +1,8 @@
+menu "PCI host controller drivers"
+	depends on PCI
+
+config PCI_TEGRA
+	bool "NVIDIA Tegra PCIe controller"
+	depends on ARCH_TEGRA_2x_SOC
+
+endmenu
diff --git a/drivers/pci/host/Makefile b/drivers/pci/host/Makefile
new file mode 100644
index 0000000..bf3adff
--- /dev/null
+++ b/drivers/pci/host/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
new file mode 100644
index 0000000..e1199fb
--- /dev/null
+++ b/drivers/pci/host/pci-tegra.c
@@ -0,0 +1,1322 @@
+/*
+ * PCIe host controller driver for TEGRA(2) SOCs
+ *
+ * Copyright (c) 2010, CompuLab, Ltd.
+ * Author: Mike Rapoport <mike@compulab.co.il>
+ *
+ * Based on NVIDIA PCIe driver
+ * Copyright (c) 2008-2009, NVIDIA Corporation.
+ *
+ * Bits taken from arch/arm/mach-dove/pcie.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/export.h>
+#include <linux/msi.h>
+#include <linux/of_address.h>
+#include <linux/of_pci.h>
+#include <linux/of_platform.h>
+#include <linux/regulator/consumer.h>
+
+#include <asm/sizes.h>
+#include <asm/mach/irq.h>
+#include <asm/mach/pci.h>
+
+#include <mach/clk.h>
+#include <mach/pmc.h>
+#include <mach/powergate.h>
+
+#define INT_PCI_MSI_NR (8 * 32)
+
+/* register definitions */
+
+#define AFI_AXI_BAR0_SZ	0x00
+#define AFI_AXI_BAR1_SZ	0x04
+#define AFI_AXI_BAR2_SZ	0x08
+#define AFI_AXI_BAR3_SZ	0x0c
+#define AFI_AXI_BAR4_SZ	0x10
+#define AFI_AXI_BAR5_SZ	0x14
+
+#define AFI_AXI_BAR0_START	0x18
+#define AFI_AXI_BAR1_START	0x1c
+#define AFI_AXI_BAR2_START	0x20
+#define AFI_AXI_BAR3_START	0x24
+#define AFI_AXI_BAR4_START	0x28
+#define AFI_AXI_BAR5_START	0x2c
+
+#define AFI_FPCI_BAR0	0x30
+#define AFI_FPCI_BAR1	0x34
+#define AFI_FPCI_BAR2	0x38
+#define AFI_FPCI_BAR3	0x3c
+#define AFI_FPCI_BAR4	0x40
+#define AFI_FPCI_BAR5	0x44
+
+#define AFI_CACHE_BAR0_SZ	0x48
+#define AFI_CACHE_BAR0_ST	0x4c
+#define AFI_CACHE_BAR1_SZ	0x50
+#define AFI_CACHE_BAR1_ST	0x54
+
+#define AFI_MSI_BAR_SZ		0x60
+#define AFI_MSI_FPCI_BAR_ST	0x64
+#define AFI_MSI_AXI_BAR_ST	0x68
+
+#define AFI_MSI_VEC0		0x6c
+#define AFI_MSI_VEC1		0x70
+#define AFI_MSI_VEC2		0x74
+#define AFI_MSI_VEC3		0x78
+#define AFI_MSI_VEC4		0x7c
+#define AFI_MSI_VEC5		0x80
+#define AFI_MSI_VEC6		0x84
+#define AFI_MSI_VEC7		0x88
+
+#define AFI_MSI_EN_VEC0		0x8c
+#define AFI_MSI_EN_VEC1		0x90
+#define AFI_MSI_EN_VEC2		0x94
+#define AFI_MSI_EN_VEC3		0x98
+#define AFI_MSI_EN_VEC4		0x9c
+#define AFI_MSI_EN_VEC5		0xa0
+#define AFI_MSI_EN_VEC6		0xa4
+#define AFI_MSI_EN_VEC7		0xa8
+
+#define AFI_CONFIGURATION		0xac
+#define  AFI_CONFIGURATION_EN_FPCI	(1 << 0)
+
+#define AFI_FPCI_ERROR_MASKS	0xb0
+
+#define AFI_INTR_MASK		0xb4
+#define  AFI_INTR_MASK_INT_MASK	(1 << 0)
+#define  AFI_INTR_MASK_MSI_MASK	(1 << 8)
+
+#define AFI_INTR_CODE		0xb8
+#define  AFI_INTR_CODE_MASK	0xf
+#define  AFI_INTR_MASTER_ABORT	4
+#define  AFI_INTR_LEGACY	6
+
+#define AFI_INTR_SIGNATURE	0xbc
+#define AFI_UPPER_FPCI_ADDRESS	0xc0
+#define AFI_SM_INTR_ENABLE	0xc4
+
+#define AFI_AFI_INTR_ENABLE		0xc8
+#define  AFI_INTR_EN_INI_SLVERR		(1 << 0)
+#define  AFI_INTR_EN_INI_DECERR		(1 << 1)
+#define  AFI_INTR_EN_TGT_SLVERR		(1 << 2)
+#define  AFI_INTR_EN_TGT_DECERR		(1 << 3)
+#define  AFI_INTR_EN_TGT_WRERR		(1 << 4)
+#define  AFI_INTR_EN_DFPCI_DECERR	(1 << 5)
+#define  AFI_INTR_EN_AXI_DECERR		(1 << 6)
+#define  AFI_INTR_EN_FPCI_TIMEOUT	(1 << 7)
+
+#define AFI_PCIE_CONFIG					0x0f8
+#define  AFI_PCIE_CONFIG_PCIEC0_DISABLE_DEVICE		(1 << 1)
+#define  AFI_PCIE_CONFIG_PCIEC1_DISABLE_DEVICE		(1 << 2)
+#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK	(0xf << 20)
+#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_SINGLE	(0x0 << 20)
+#define  AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL	(0x1 << 20)
+
+#define AFI_FUSE			0x104
+#define  AFI_FUSE_PCIE_T0_GEN2_DIS	(1 << 2)
+
+#define AFI_PEX0_CTRL			0x110
+#define AFI_PEX1_CTRL			0x118
+#define  AFI_PEX_CTRL_RST		(1 << 0)
+#define  AFI_PEX_CTRL_REFCLK_EN		(1 << 3)
+
+#define RP_VEND_XP	0x00000F00
+#define  RP_VEND_XP_DL_UP	(1 << 30)
+
+#define RP_LINK_CONTROL_STATUS			0x00000090
+#define  RP_LINK_CONTROL_STATUS_LINKSTAT_MASK	0x3fff0000
+
+#define PADS_CTL_SEL		0x0000009C
+
+#define PADS_CTL		0x000000A0
+#define  PADS_CTL_IDDQ_1L	(1 << 0)
+#define  PADS_CTL_TX_DATA_EN_1L	(1 << 6)
+#define  PADS_CTL_RX_DATA_EN_1L	(1 << 10)
+
+#define PADS_PLL_CTL				0x000000B8
+#define  PADS_PLL_CTL_RST_B4SM			(1 << 1)
+#define  PADS_PLL_CTL_LOCKDET			(1 << 8)
+#define  PADS_PLL_CTL_REFCLK_MASK		(0x3 << 16)
+#define  PADS_PLL_CTL_REFCLK_INTERNAL_CML	(0 << 16)
+#define  PADS_PLL_CTL_REFCLK_INTERNAL_CMOS	(1 << 16)
+#define  PADS_PLL_CTL_REFCLK_EXTERNAL		(2 << 16)
+#define  PADS_PLL_CTL_TXCLKREF_MASK		(0x1 << 20)
+#define  PADS_PLL_CTL_TXCLKREF_DIV10		(0 << 20)
+#define  PADS_PLL_CTL_TXCLKREF_DIV5		(1 << 20)
+
+/*
+ * The configuration space mapping on Tegra is somewhat similar to the ECAM
+ * defined by PCIe. However it deviates a bit in how the 4 bits for extended
+ * register accesses are mapped:
+ *
+ *    [27:24] extended register number
+ *    [23:16] bus number
+ *    [15:11] device number
+ *    [10: 8] function number
+ *    [ 7: 0] register number
+ */
+#define PCIE_CONF_BUS(b)	((b) << 16)
+#define PCIE_CONF_DEV(d)	((d) << 11)
+#define PCIE_CONF_FUNC(f)	((f) << 8)
+#define PCIE_CONF_REG(r)	((((r) & 0xf00) << 16) | (((r) & 0xff) & ~3))
+
+struct tegra_pcie_msi {
+	DECLARE_BITMAP(used, INT_PCI_MSI_NR);
+	struct irq_domain *domain;
+	unsigned long pages;
+	struct mutex lock;
+	int irq;
+};
+
+struct tegra_pcie {
+	struct device *dev;
+
+	void __iomem *pads;
+	void __iomem *afi;
+	int irq;
+
+	struct iomap_cache *csc;
+	struct resource *cs;
+
+	struct resource io;
+	struct resource mem;
+	struct resource prefetch;
+	struct resource busn;
+
+	struct clk *pex_clk;
+	struct clk *afi_clk;
+	struct clk *pcie_xclk;
+	struct clk *pll_e;
+
+	struct tegra_pcie_msi *msi;
+
+	struct list_head ports;
+	unsigned int num_ports;
+
+	struct regulator *pex_clk_supply;
+	struct regulator *vdd_supply;
+};
+
+struct tegra_pcie_port {
+	struct tegra_pcie *pcie;
+	struct list_head list;
+	void __iomem *base;
+	unsigned int index;
+};
+
+static inline struct tegra_pcie *sys_to_pcie(struct pci_sys_data *sys)
+{
+	return sys->private_data;
+}
+
+static inline void afi_writel(struct tegra_pcie *pcie, u32 value,
+			      unsigned long offset)
+{
+	writel(value, pcie->afi + offset);
+}
+
+static inline u32 afi_readl(struct tegra_pcie *pcie, unsigned long offset)
+{
+	return readl(pcie->afi + offset);
+}
+
+static inline void pads_writel(struct tegra_pcie *pcie, u32 value,
+			       unsigned long offset)
+{
+	writel(value, pcie->pads + offset);
+}
+
+static inline u32 pads_readl(struct tegra_pcie *pcie, unsigned long offset)
+{
+	return readl(pcie->pads + offset);
+}
+
+static int tegra_pcie_read_conf(struct pci_bus *bus, unsigned int devfn,
+				int where, int size, u32 *value)
+{
+	struct tegra_pcie *pcie = sys_to_pcie(bus->sysdata);
+	void __iomem *addr = NULL;
+	unsigned long offset;
+
+	offset = PCIE_CONF_BUS(bus->number) + PCIE_CONF_DEV(PCI_SLOT(devfn)) +
+		 PCIE_CONF_FUNC(PCI_FUNC(devfn)) + PCIE_CONF_REG(where);
+
+	if (bus->number == 0) {
+		unsigned int slot = PCI_SLOT(devfn);
+		struct tegra_pcie_port *port;
+
+		list_for_each_entry(port, &pcie->ports, list) {
+			if (port->index + 1 == slot) {
+				addr = port->base + (where & ~3);
+				break;
+			}
+		}
+	} else
+		addr = iomap_cache_map(pcie->csc, offset);
+
+	if (!addr) {
+		*value = 0xffffffff;
+		return PCIBIOS_DEVICE_NOT_FOUND;
+	}
+
+	*value = readl(addr);
+
+	if (size == 1)
+		*value = (*value >> (8 * (where & 3))) & 0xff;
+	else if (size == 2)
+		*value = (*value >> (8 * (where & 3))) & 0xffff;
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static int tegra_pcie_write_conf(struct pci_bus *bus, unsigned int devfn,
+				 int where, int size, u32 value)
+{
+	struct tegra_pcie *pcie = sys_to_pcie(bus->sysdata);
+	void __iomem *addr = NULL;
+	unsigned long offset;
+	u32 mask, tmp;
+
+	offset = PCIE_CONF_BUS(bus->number) + PCIE_CONF_DEV(PCI_SLOT(devfn)) +
+		 PCIE_CONF_FUNC(PCI_FUNC(devfn)) + PCIE_CONF_REG(where);
+
+	if (bus->number == 0) {
+		unsigned int slot = PCI_SLOT(devfn);
+		struct tegra_pcie_port *port;
+
+		list_for_each_entry(port, &pcie->ports, list) {
+			if (port->index + 1 == slot) {
+				addr = port->base + (where & ~3);
+				break;
+			}
+		}
+	} else
+		addr = iomap_cache_map(pcie->csc, offset);
+
+	if (size == 4) {
+		writel(value, addr);
+		return PCIBIOS_SUCCESSFUL;
+	}
+
+	if (size == 2)
+		mask = ~(0xffff << ((where & 0x3) * 8));
+	else if (size == 1)
+		mask = ~(0xff << ((where & 0x3) * 8));
+	else
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	tmp = readl(addr) & mask;
+	tmp |= value << ((where & 0x3) * 8);
+	writel(tmp, addr);
+
+	return PCIBIOS_SUCCESSFUL;
+}
+
+static struct pci_ops tegra_pcie_ops = {
+	.read	= tegra_pcie_read_conf,
+	.write	= tegra_pcie_write_conf,
+};
+
+static void tegra_pcie_fixup_bridge(struct pci_dev *dev)
+{
+	u16 reg;
+
+	if ((dev->class >> 16) == PCI_BASE_CLASS_BRIDGE) {
+		pci_read_config_word(dev, PCI_COMMAND, &reg);
+		reg |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
+			PCI_COMMAND_MASTER | PCI_COMMAND_SERR);
+		pci_write_config_word(dev, PCI_COMMAND, reg);
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_fixup_bridge);
+
+/* Tegra PCIE root complex wrongly reports device class */
+static void tegra_pcie_fixup_class(struct pci_dev *dev)
+{
+	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
+}
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf0, tegra_pcie_fixup_class);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_NVIDIA, 0x0bf1, tegra_pcie_fixup_class);
+
+/* Tegra PCIE requires relaxed ordering */
+static void tegra_pcie_relax_enable(struct pci_dev *dev)
+{
+	pcie_capability_set_word(dev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_RELAX_EN);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
+
+static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
+{
+	struct tegra_pcie *pcie = sys_to_pcie(sys);
+
+	pci_add_resource_offset(&sys->resources, &pcie->io, sys->io_offset);
+	pci_add_resource_offset(&sys->resources, &pcie->mem, sys->mem_offset);
+	pci_add_resource_offset(&sys->resources, &pcie->prefetch, sys->mem_offset);
+	pci_add_resource(&sys->resources, &pcie->busn);
+
+	pci_ioremap_io(nr * SZ_64K, pcie->io.start);
+
+	return 1;
+}
+
+static int tegra_pcie_map_irq(const struct pci_dev *pdev, u8 slot, u8 pin)
+{
+	struct tegra_pcie *pcie = sys_to_pcie(pdev->bus->sysdata);
+
+	return pcie->irq;
+}
+
+static struct pci_bus *tegra_pcie_scan_bus(int nr, struct pci_sys_data *sys)
+{
+	struct tegra_pcie *pcie = sys_to_pcie(sys);
+	struct pci_host_bridge_window *window;
+	struct pci_bus *bus;
+	bool found = false;
+
+	list_for_each_entry(window, &sys->resources, list) {
+		if (window->res->flags & IORESOURCE_BUS) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!found)
+		dev_err(pcie->dev, "no bus resource found!\n");
+
+	bus = pci_create_root_bus(pcie->dev, sys->busnr, &tegra_pcie_ops,
+				  sys, &sys->resources);
+	if (!bus)
+		return NULL;
+
+	pci_scan_child_bus(bus);
+
+	return bus;
+}
+
+static irqreturn_t tegra_pcie_isr(int irq, void *arg)
+{
+	const char *err_msg[] = {
+		"Unknown",
+		"AXI slave error",
+		"AXI decode error",
+		"Target abort",
+		"Master abort",
+		"Invalid write",
+		"Response decoding error",
+		"AXI response decoding error",
+		"Transaction timeout",
+	};
+	struct tegra_pcie *pcie = arg;
+	u32 code, signature;
+
+	code = afi_readl(pcie, AFI_INTR_CODE) & AFI_INTR_CODE_MASK;
+	signature = afi_readl(pcie, AFI_INTR_SIGNATURE);
+	afi_writel(pcie, 0, AFI_INTR_CODE);
+
+	if (code == AFI_INTR_LEGACY)
+		return IRQ_NONE;
+
+	if (code >= ARRAY_SIZE(err_msg))
+		code = 0;
+
+	/*
+	 * do not pollute kernel log with master abort reports since they
+	 * happen a lot during enumeration
+	 */
+	if (code == AFI_INTR_MASTER_ABORT) {
+		dev_dbg(pcie->dev, "%s, signature: %08x\n", err_msg[code],
+			signature);
+	} else
+		dev_err(pcie->dev, "%s, signature: %08x\n", err_msg[code],
+			signature);
+
+	if (code == 3 || code == 4 || code == 7) {
+		u32 fpci = afi_readl(pcie, AFI_UPPER_FPCI_ADDRESS) & 0xff;
+		u64 address = (u64)fpci << 32 | (signature & 0xfffffffc);
+		dev_dbg(pcie->dev, "  FPCI address: %10llx\n", address);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * FPCI map is as follows:
+ * - 0xfdfc000000: I/O space
+ * - 0xfdfe000000: type 0 configuration space
+ * - 0xfdff000000: type 1 configuration space
+ * - 0xfe00000000: type 0 extended configuration space
+ * - 0xfe10000000: type 1 extended configuration space
+ */
+static void tegra_pcie_setup_translations(struct tegra_pcie *pcie)
+{
+	u32 fpci_bar, size, axi_address;
+
+	/* Bar 0: type 1 extended configuration space */
+	fpci_bar = 0xfe100000;
+	size = resource_size(pcie->cs);
+	axi_address = pcie->cs->start;
+	afi_writel(pcie, axi_address, AFI_AXI_BAR0_START);
+	afi_writel(pcie, size >> 12, AFI_AXI_BAR0_SZ);
+	afi_writel(pcie, fpci_bar, AFI_FPCI_BAR0);
+
+	/* Bar 1: downstream IO bar */
+	fpci_bar = 0xfdfc0000;
+	size = resource_size(&pcie->io);
+	axi_address = pcie->io.start;
+	afi_writel(pcie, axi_address, AFI_AXI_BAR1_START);
+	afi_writel(pcie, size >> 12, AFI_AXI_BAR1_SZ);
+	afi_writel(pcie, fpci_bar, AFI_FPCI_BAR1);
+
+	/* Bar 2: prefetchable memory BAR */
+	fpci_bar = (((pcie->prefetch.start >> 12) & 0x0fffffff) << 4) | 0x1;
+	size = resource_size(&pcie->prefetch);
+	axi_address = pcie->prefetch.start;
+	afi_writel(pcie, axi_address, AFI_AXI_BAR2_START);
+	afi_writel(pcie, size >> 12, AFI_AXI_BAR2_SZ);
+	afi_writel(pcie, fpci_bar, AFI_FPCI_BAR2);
+
+	/* Bar 3: non prefetchable memory BAR */
+	fpci_bar = (((pcie->mem.start >> 12) & 0x0fffffff) << 4) | 0x1;
+	size = resource_size(&pcie->mem);
+	axi_address = pcie->mem.start;
+	afi_writel(pcie, axi_address, AFI_AXI_BAR3_START);
+	afi_writel(pcie, size >> 12, AFI_AXI_BAR3_SZ);
+	afi_writel(pcie, fpci_bar, AFI_FPCI_BAR3);
+
+	/* NULL out the remaining BARs as they are not used */
+	afi_writel(pcie, 0, AFI_AXI_BAR4_START);
+	afi_writel(pcie, 0, AFI_AXI_BAR4_SZ);
+	afi_writel(pcie, 0, AFI_FPCI_BAR4);
+
+	afi_writel(pcie, 0, AFI_AXI_BAR5_START);
+	afi_writel(pcie, 0, AFI_AXI_BAR5_SZ);
+	afi_writel(pcie, 0, AFI_FPCI_BAR5);
+
+	/* map all upstream transactions as uncached */
+	afi_writel(pcie, PHYS_OFFSET, AFI_CACHE_BAR0_ST);
+	afi_writel(pcie, 0, AFI_CACHE_BAR0_SZ);
+	afi_writel(pcie, 0, AFI_CACHE_BAR1_ST);
+	afi_writel(pcie, 0, AFI_CACHE_BAR1_SZ);
+
+	/* MSI translations are setup only when needed */
+	afi_writel(pcie, 0, AFI_MSI_FPCI_BAR_ST);
+	afi_writel(pcie, 0, AFI_MSI_BAR_SZ);
+	afi_writel(pcie, 0, AFI_MSI_AXI_BAR_ST);
+	afi_writel(pcie, 0, AFI_MSI_BAR_SZ);
+}
+
+static int tegra_pcie_enable_controller(struct tegra_pcie *pcie)
+{
+	unsigned int timeout;
+	unsigned long value;
+
+	/* enable dual controller and both ports */
+	value = afi_readl(pcie, AFI_PCIE_CONFIG);
+	value &= ~(AFI_PCIE_CONFIG_PCIEC0_DISABLE_DEVICE |
+		   AFI_PCIE_CONFIG_PCIEC1_DISABLE_DEVICE |
+		   AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_MASK);
+	value |= AFI_PCIE_CONFIG_SM2TMS0_XBAR_CONFIG_DUAL;
+	afi_writel(pcie, value, AFI_PCIE_CONFIG);
+
+	value = afi_readl(pcie, AFI_FUSE);
+	value &= ~AFI_FUSE_PCIE_T0_GEN2_DIS;
+	afi_writel(pcie, value, AFI_FUSE);
+
+	/* initialze internal PHY, enable up to 16 PCIE lanes */
+	pads_writel(pcie, 0x0, PADS_CTL_SEL);
+
+	/* override IDDQ to 1 on all 4 lanes */
+	value = pads_readl(pcie, PADS_CTL);
+	value |= PADS_CTL_IDDQ_1L;
+	pads_writel(pcie, value, PADS_CTL);
+
+	/*
+	 * Set up PHY PLL inputs select PLLE output as refclock,
+	 * set TX ref sel to div10 (not div5).
+	 */
+	value = pads_readl(pcie, PADS_PLL_CTL);
+	value &= ~(PADS_PLL_CTL_REFCLK_MASK | PADS_PLL_CTL_TXCLKREF_MASK);
+	value |= (PADS_PLL_CTL_REFCLK_INTERNAL_CML | PADS_PLL_CTL_TXCLKREF_DIV10);
+	pads_writel(pcie, value, PADS_PLL_CTL);
+
+	/* take PLL out of reset  */
+	value = pads_readl(pcie, PADS_PLL_CTL);
+	value |= PADS_PLL_CTL_RST_B4SM;
+	pads_writel(pcie, value, PADS_PLL_CTL);
+
+	/*
+	 * Hack, set the clock voltage to the DEFAULT provided by hw folks.
+	 * This doesn't exist in the documentation.
+	 */
+	pads_writel(pcie, 0xfa5cfa5c, 0xc8);
+
+	/* wait for the PLL to lock */
+	timeout = 300;
+	do {
+		value = pads_readl(pcie, PADS_PLL_CTL);
+		usleep_range(1000, 1000);
+		if (--timeout == 0) {
+			pr_err("Tegra PCIe error: timeout waiting for PLL\n");
+			return -EBUSY;
+		}
+	} while (!(value & PADS_PLL_CTL_LOCKDET));
+
+	/* turn off IDDQ override */
+	value = pads_readl(pcie, PADS_CTL);
+	value &= ~PADS_CTL_IDDQ_1L;
+	pads_writel(pcie, value, PADS_CTL);
+
+	/* enable TX/RX data */
+	value = pads_readl(pcie, PADS_CTL);
+	value |= PADS_CTL_TX_DATA_EN_1L | PADS_CTL_RX_DATA_EN_1L;
+	pads_writel(pcie, value, PADS_CTL);
+
+	/* take the PCIe interface module out of reset */
+	tegra_periph_reset_deassert(pcie->pcie_xclk);
+
+	/* finally enable PCIe */
+	value = afi_readl(pcie, AFI_CONFIGURATION);
+	value |= AFI_CONFIGURATION_EN_FPCI;
+	afi_writel(pcie, value, AFI_CONFIGURATION);
+
+	value = AFI_INTR_EN_INI_SLVERR | AFI_INTR_EN_INI_DECERR |
+		AFI_INTR_EN_TGT_SLVERR | AFI_INTR_EN_TGT_DECERR |
+		AFI_INTR_EN_TGT_WRERR | AFI_INTR_EN_DFPCI_DECERR;
+	afi_writel(pcie, value, AFI_AFI_INTR_ENABLE);
+	afi_writel(pcie, 0xffffffff, AFI_SM_INTR_ENABLE);
+
+	/* don't enable MSI for now, only when needed */
+	afi_writel(pcie, AFI_INTR_MASK_INT_MASK, AFI_INTR_MASK);
+
+	/* disable all exceptions */
+	afi_writel(pcie, 0, AFI_FPCI_ERROR_MASKS);
+
+	return 0;
+}
+
+static void tegra_pcie_power_off(struct tegra_pcie *pcie)
+{
+	int err;
+
+	/* TODO: disable and unprepare clocks? */
+
+	tegra_periph_reset_assert(pcie->pcie_xclk);
+	tegra_periph_reset_assert(pcie->afi_clk);
+	tegra_periph_reset_assert(pcie->pex_clk);
+
+	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
+	tegra_pmc_pcie_xclk_clamp(true);
+
+	if (!IS_ERR_OR_NULL(pcie->pex_clk_supply)) {
+		err = regulator_disable(pcie->pex_clk_supply);
+		if (err < 0) {
+			dev_err(pcie->dev,
+				"failed to disable pex-clk regulator: %d\n",
+				err);
+		}
+	}
+
+	if (!IS_ERR_OR_NULL(pcie->vdd_supply)) {
+		err = regulator_disable(pcie->vdd_supply);
+		if (err < 0) {
+			dev_err(pcie->dev,
+				"failed to disable VDD regulator: %d\n", err);
+		}
+	}
+}
+
+static int tegra_pcie_power_on(struct tegra_pcie *pcie)
+{
+	int err;
+
+	tegra_periph_reset_assert(pcie->pcie_xclk);
+	tegra_periph_reset_assert(pcie->afi_clk);
+	tegra_periph_reset_assert(pcie->pex_clk);
+
+	tegra_powergate_power_off(TEGRA_POWERGATE_PCIE);
+	tegra_pmc_pcie_xclk_clamp(true);
+
+	/* enable regulators */
+	if (!IS_ERR_OR_NULL(pcie->vdd_supply)) {
+		err = regulator_enable(pcie->vdd_supply);
+		if (err < 0) {
+			dev_err(pcie->dev,
+				"failed to enable VDD regulator: %d\n", err);
+			return err;
+		}
+	}
+
+	if (!IS_ERR_OR_NULL(pcie->pex_clk_supply)) {
+		err = regulator_enable(pcie->pex_clk_supply);
+		if (err < 0) {
+			dev_err(pcie->dev,
+				"failed to enable pex-clk regulator: %d\n",
+				err);
+			return err;
+		}
+	}
+
+	err = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_PCIE,
+						pcie->pex_clk);
+	if (err) {
+		dev_err(pcie->dev, "powerup sequence failed: %d\n", err);
+		return err;
+	}
+
+	tegra_periph_reset_deassert(pcie->afi_clk);
+
+	tegra_pmc_pcie_xclk_clamp(false);
+
+	clk_prepare_enable(pcie->afi_clk);
+	return clk_prepare_enable(pcie->pll_e);
+}
+
+static int tegra_pcie_clocks_get(struct tegra_pcie *pcie)
+{
+	pcie->pex_clk = devm_clk_get(pcie->dev, "pex");
+	if (IS_ERR(pcie->pex_clk))
+		return PTR_ERR(pcie->pex_clk);
+
+	pcie->afi_clk = devm_clk_get(pcie->dev, "afi");
+	if (IS_ERR(pcie->afi_clk))
+		return PTR_ERR(pcie->afi_clk);
+
+	pcie->pcie_xclk = devm_clk_get(pcie->dev, "pcie_xclk");
+	if (IS_ERR(pcie->pcie_xclk))
+		return PTR_ERR(pcie->pcie_xclk);
+
+	pcie->pll_e = devm_clk_get(pcie->dev, "pll_e");
+	if (IS_ERR(pcie->pll_e))
+		return PTR_ERR(pcie->pll_e);
+
+	return 0;
+}
+
+static int tegra_pcie_get_resources(struct tegra_pcie *pcie)
+{
+	struct platform_device *pdev = to_platform_device(pcie->dev);
+	struct resource *pads, *afi, *res;
+	int err;
+
+	err = tegra_pcie_clocks_get(pcie);
+	if (err) {
+		dev_err(&pdev->dev, "failed to get clocks: %d\n", err);
+		return err;
+	}
+
+	err = tegra_pcie_power_on(pcie);
+	if (err) {
+		dev_err(&pdev->dev, "failed to power up: %d\n", err);
+		return err;
+	}
+
+	/* request and remap controller registers */
+	pads = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pads");
+	if (!pads) {
+		err = -EADDRNOTAVAIL;
+		goto poweroff;
+	}
+
+	afi = platform_get_resource_byname(pdev, IORESOURCE_MEM, "afi");
+	if (!afi) {
+		err = -EADDRNOTAVAIL;
+		goto poweroff;
+	}
+
+	pcie->pads = devm_request_and_ioremap(&pdev->dev, pads);
+	if (!pcie->pads) {
+		err = -EADDRNOTAVAIL;
+		goto poweroff;
+	}
+
+	pcie->afi = devm_request_and_ioremap(&pdev->dev, afi);
+	if (!pcie->afi) {
+		err = -EADDRNOTAVAIL;
+		goto poweroff;
+	}
+
+	/* request and remap configuration space */
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cs");
+	if (!res) {
+		err = -EADDRNOTAVAIL;
+		goto poweroff;
+	}
+
+	pcie->cs = devm_request_mem_region(pcie->dev, res->start,
+					   resource_size(res), res->name);
+	if (!pcie->cs) {
+		err = -EADDRNOTAVAIL;
+		goto poweroff;
+	}
+
+	pcie->csc = devm_iomap_cache_create(pcie->dev, pcie->cs);
+	if (!pcie->csc) {
+		err = -ENOMEM;
+		goto poweroff;
+	}
+
+	/* request interrupt */
+	err = platform_get_irq_byname(pdev, "intr");
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to get IRQ: %d\n", err);
+		goto poweroff;
+	}
+
+	pcie->irq = err;
+
+	err = devm_request_irq(&pdev->dev, pcie->irq, tegra_pcie_isr,
+			       IRQF_SHARED, "PCIE", pcie);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register IRQ: %d\n", err);
+		goto poweroff;
+	}
+
+	return 0;
+
+poweroff:
+	tegra_pcie_power_off(pcie);
+	return err;
+}
+
+static int tegra_pcie_put_resources(struct tegra_pcie *pcie)
+{
+	tegra_pcie_power_off(pcie);
+	return 0;
+}
+
+static int tegra_pcie_msi_alloc(struct tegra_pcie *pcie)
+{
+	int msi;
+
+	mutex_lock(&pcie->msi->lock);
+
+	msi = find_first_zero_bit(pcie->msi->used, INT_PCI_MSI_NR);
+	if (msi < INT_PCI_MSI_NR)
+		set_bit(msi, pcie->msi->used);
+	else
+		msi = -ENOSPC;
+
+	mutex_unlock(&pcie->msi->lock);
+
+	return msi;
+}
+
+static void tegra_pcie_msi_free(struct tegra_pcie *pcie, unsigned long irq)
+{
+	mutex_lock(&pcie->msi->lock);
+
+	if (!test_bit(irq, pcie->msi->used))
+		dev_err(pcie->dev, "trying to free unused MSI#%lu\n", irq);
+	else
+		clear_bit(irq, pcie->msi->used);
+
+	mutex_unlock(&pcie->msi->lock);
+}
+
+static irqreturn_t tegra_pcie_msi_irq(int irq, void *data)
+{
+	struct tegra_pcie *pcie = data;
+	unsigned int i;
+
+	for (i = 0; i < 8; i++) {
+		unsigned long reg = afi_readl(pcie, AFI_MSI_VEC0 + i * 4);
+
+		while (reg) {
+			unsigned int offset = find_first_bit(&reg, 32);
+			unsigned int index = i * 32 + offset;
+			unsigned int irq;
+
+			/* clear the interrupt */
+			afi_writel(pcie, 1 << offset, AFI_MSI_VEC0 + i * 4);
+
+			irq = irq_find_mapping(pcie->msi->domain, index);
+			if (irq) {
+				if (test_bit(index, pcie->msi->used))
+					generic_handle_irq(irq);
+				else
+					dev_info(pcie->dev, "unhandled MSI\n");
+			} else {
+				/*
+				 * that's weird who triggered this?
+				 * just clear it
+				 */
+				dev_info(pcie->dev, "unexpected MSI\n");
+			}
+
+			/* see if there's any more pending in this vector */
+			reg = afi_readl(pcie, AFI_MSI_VEC0 + i * 4);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+/* called by arch_setup_msi_irqs in drivers/pci/msi.c */
+int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
+{
+	struct tegra_pcie *pcie = sys_to_pcie(pdev->bus->sysdata);
+	struct msi_msg msg;
+	unsigned int irq;
+	int hwirq;
+
+	hwirq = tegra_pcie_msi_alloc(pcie);
+	if (hwirq < 0)
+		return hwirq;
+
+	irq = irq_create_mapping(pcie->msi->domain, hwirq);
+	if (!irq)
+		return -EINVAL;
+
+	irq_set_msi_desc(irq, desc);
+
+	msg.address_lo = afi_readl(pcie, AFI_MSI_AXI_BAR_ST);
+	/* 32 bit address only */
+	msg.address_hi = 0;
+	msg.data = hwirq;
+
+	write_msi_msg(irq, &msg);
+
+	return 0;
+}
+
+void arch_teardown_msi_irq(unsigned int irq)
+{
+	struct tegra_pcie *pcie = irq_get_chip_data(irq);
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	tegra_pcie_msi_free(pcie, d->hwirq);
+}
+
+static struct irq_chip tegra_pcie_msi_irq_chip = {
+	.name = "Tegra PCIe MSI",
+	.irq_enable = unmask_msi_irq,
+	.irq_disable = mask_msi_irq,
+	.irq_mask = mask_msi_irq,
+	.irq_unmask = unmask_msi_irq,
+};
+
+static int tegra_pcie_msi_map(struct irq_domain *domain, unsigned int irq,
+			      irq_hw_number_t hwirq)
+{
+	irq_set_chip_and_handler(irq, &tegra_pcie_msi_irq_chip,
+				 handle_simple_irq);
+	irq_set_chip_data(irq, domain->host_data);
+	set_irq_flags(irq, IRQF_VALID);
+
+	return 0;
+}
+
+static const struct irq_domain_ops msi_domain_ops = {
+	.map = tegra_pcie_msi_map,
+};
+
+static int tegra_pcie_enable_msi(struct tegra_pcie *pcie)
+{
+	struct platform_device *pdev = to_platform_device(pcie->dev);
+	unsigned long base;
+	int err;
+	u32 reg;
+
+	pcie->msi = devm_kzalloc(&pdev->dev, sizeof(*pcie->msi), GFP_KERNEL);
+	if (!pcie->msi)
+		return -ENOMEM;
+
+	mutex_init(&pcie->msi->lock);
+
+	pcie->msi->domain = irq_domain_add_linear(pcie->dev->of_node,
+						  INT_PCI_MSI_NR,
+						  &msi_domain_ops, pcie);
+	if (!pcie->msi->domain) {
+		dev_err(&pdev->dev, "failed to create IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	err = platform_get_irq_byname(pdev, "msi");
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to get IRQ: %d\n", err);
+		goto err;
+	}
+
+	pcie->msi->irq = err;
+
+	err = devm_request_irq(&pdev->dev, pcie->msi->irq, tegra_pcie_msi_irq,
+			       0, tegra_pcie_msi_irq_chip.name, pcie);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to request IRQ: %d\n", err);
+		goto err;
+	}
+
+	/* setup AFI/FPCI range */
+	pcie->msi->pages = __get_free_pages(GFP_KERNEL, 3);
+	base = virt_to_phys((void *)pcie->msi->pages);
+
+	afi_writel(pcie, base, AFI_MSI_FPCI_BAR_ST);
+	afi_writel(pcie, base, AFI_MSI_AXI_BAR_ST);
+	/* this register is in 4K increments */
+	afi_writel(pcie, 1, AFI_MSI_BAR_SZ);
+
+	/* enable all MSI vectors */
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC0);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC1);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC2);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC3);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC4);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC5);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC6);
+	afi_writel(pcie, 0xffffffff, AFI_MSI_EN_VEC7);
+
+	/* and unmask the MSI interrupt */
+	reg = afi_readl(pcie, AFI_INTR_MASK);
+	reg |= AFI_INTR_MASK_MSI_MASK;
+	afi_writel(pcie, reg, AFI_INTR_MASK);
+
+	return 0;
+
+err:
+	irq_domain_remove(pcie->msi->domain);
+	return err;
+}
+
+static int tegra_pcie_disable_msi(struct tegra_pcie *pcie)
+{
+	unsigned int i, irq;
+	u32 value;
+
+	/* mask the MSI interrupt */
+	value = afi_readl(pcie, AFI_INTR_MASK);
+	value &= ~AFI_INTR_MASK_MSI_MASK;
+	afi_writel(pcie, value, AFI_INTR_MASK);
+
+	/* disable all MSI vectors */
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC0);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC1);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC2);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC3);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC4);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC5);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC6);
+	afi_writel(pcie, 0, AFI_MSI_EN_VEC7);
+
+	free_pages(pcie->msi->pages, 3);
+
+	for (i = 0; i < INT_PCI_MSI_NR; i++) {
+		irq = irq_find_mapping(pcie->msi->domain, i);
+		if (irq > 0)
+			irq_dispose_mapping(irq);
+	}
+
+	irq_domain_remove(pcie->msi->domain);
+
+	return 0;
+}
+
+static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
+{
+	struct device_node *np = pcie->dev->of_node;
+	const __be32 *range = NULL;
+	struct resource res;
+	int err;
+
+	pcie->vdd_supply = devm_regulator_get(pcie->dev, "vdd");
+	if (IS_ERR(pcie->vdd_supply))
+		return PTR_ERR(pcie->vdd_supply);
+
+	pcie->pex_clk_supply = devm_regulator_get(pcie->dev, "pex-clk");
+	if (IS_ERR(pcie->pex_clk_supply))
+		return PTR_ERR(pcie->pex_clk_supply);
+
+	while ((range = of_pci_process_ranges(np, &res, range)) != NULL) {
+		switch (res.flags & IORESOURCE_TYPE_BITS) {
+		case IORESOURCE_IO:
+			memcpy(&pcie->io, &res, sizeof(res));
+			pcie->io.name = "I/O";
+			break;
+
+		case IORESOURCE_MEM:
+			if (res.flags & IORESOURCE_PREFETCH) {
+				memcpy(&pcie->prefetch, &res, sizeof(res));
+				pcie->prefetch.name = "PREFETCH";
+			} else {
+				memcpy(&pcie->mem, &res, sizeof(res));
+				pcie->mem.name = "MEM";
+			}
+			break;
+		}
+	}
+
+	err = of_pci_parse_bus_range(np, &pcie->busn);
+	if (err < 0) {
+		dev_err(pcie->dev, "failed to parse ranges property: %d\n",
+			err);
+		pcie->busn.name = np->name;
+		pcie->busn.start = 0;
+		pcie->busn.end = 0xff;
+		pcie->busn.flags = IORESOURCE_BUS;
+	}
+
+	return 0;
+}
+
+static unsigned long tegra_pcie_port_get_pex_ctrl(struct tegra_pcie_port *port)
+{
+	unsigned long ret = 0;
+
+	switch (port->index) {
+	case 0:
+		ret = AFI_PEX0_CTRL;
+		break;
+
+	case 1:
+		ret = AFI_PEX1_CTRL;
+		break;
+	}
+
+	return ret;
+}
+
+/*
+ * FIXME: If there are no PCIe cards attached, then calling this function
+ * can result in the increase of the bootup time as there are big timeout
+ * loops.
+ */
+#define TEGRA_PCIE_LINKUP_TIMEOUT	200	/* up to 1.2 seconds */
+static bool tegra_pcie_port_check_link(struct tegra_pcie_port *port)
+{
+	unsigned long value, ctrl = tegra_pcie_port_get_pex_ctrl(port);
+	unsigned int retries = 3;
+
+	/* enable reference clock */
+	value = afi_readl(port->pcie, ctrl);
+	value |= AFI_PEX_CTRL_REFCLK_EN;
+	afi_writel(port->pcie, value, ctrl);
+
+	do {
+		unsigned int timeout = TEGRA_PCIE_LINKUP_TIMEOUT;
+
+		do {
+			value = readl(port->base + RP_VEND_XP);
+
+			if (value & RP_VEND_XP_DL_UP)
+				break;
+
+			usleep_range(1000, 1000);
+		} while (--timeout);
+
+		if (!timeout) {
+			dev_err(port->pcie->dev, "link %u down, retrying\n",
+				port->index);
+			goto retry;
+		}
+
+		timeout = TEGRA_PCIE_LINKUP_TIMEOUT;
+
+		do {
+			value = readl(port->base + RP_LINK_CONTROL_STATUS);
+
+			if (value & 0x20000000)
+				return true;
+
+			usleep_range(1000, 1000);
+		} while (--timeout);
+
+retry:
+		/* Pulse the PEX reset */
+		value = afi_readl(port->pcie, ctrl);
+		value |= AFI_PEX_CTRL_RST;
+		afi_writel(port->pcie, value, ctrl);
+
+		usleep_range(1000, 1000);
+
+		value = afi_readl(port->pcie, ctrl);
+		value &= ~AFI_PEX_CTRL_RST;
+		afi_writel(port->pcie, value, ctrl);
+	} while (--retries);
+
+	return false;
+}
+
+static int tegra_pcie_enable(struct tegra_pcie *pcie)
+{
+	struct hw_pci hw;
+
+	memset(&hw, 0, sizeof(hw));
+
+	hw.nr_controllers = 1;
+	hw.private_data = (void **)&pcie;
+	hw.setup = tegra_pcie_setup;
+	hw.scan = tegra_pcie_scan_bus;
+	hw.map_irq = tegra_pcie_map_irq;
+
+	pci_common_init(&hw);
+
+	return 0;
+}
+
+static int tegra_pcie_add_port(struct tegra_pcie *pcie, struct device_node *np)
+{
+	struct tegra_pcie_port *port;
+	struct resource regs;
+	unsigned int index;
+	int err;
+
+	err = of_address_to_resource(np, 0, &regs);
+	if (err < 0) {
+		dev_dbg(pcie->dev, "of_address_to_resource(): %d\n", err);
+		return err;
+	}
+
+	err = of_pci_get_devfn(np);
+	if (err < 0)
+		return err;
+
+	index = PCI_SLOT(err) - 1;
+
+	port = devm_kzalloc(pcie->dev, sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&port->list);
+	port->index = index;
+	port->pcie = pcie;
+
+	port->base = devm_request_and_ioremap(pcie->dev, &regs);
+	if (!port->base)
+		return -EADDRNOTAVAIL;
+
+	if (!tegra_pcie_port_check_link(port)) {
+		dev_info(pcie->dev, "link %u down, ignoring\n", port->index);
+		return -ENODEV;
+	}
+
+	list_add_tail(&port->list, &pcie->ports);
+
+	return 0;
+}
+
+static int tegra_pcie_probe(struct platform_device *pdev)
+{
+	struct device_node *port;
+	struct tegra_pcie *pcie;
+	int err;
+
+	pcie = devm_kzalloc(&pdev->dev, sizeof(*pcie), GFP_KERNEL);
+	if (!pcie)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&pcie->ports);
+	pcie->dev = &pdev->dev;
+
+	err = tegra_pcie_parse_dt(pcie);
+	if (err < 0)
+		return err;
+
+	pcibios_min_mem = 0;
+
+	err = tegra_pcie_get_resources(pcie);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to request resources: %d\n", err);
+		return err;
+	}
+
+	err = tegra_pcie_enable_controller(pcie);
+	if (err)
+		goto put_resources;
+
+	/* probe root ports */
+	for_each_child_of_node(pdev->dev.of_node, port) {
+		if (!of_device_is_available(port))
+			continue;
+
+		err = tegra_pcie_add_port(pcie, port);
+		if (err < 0) {
+			dev_err(&pdev->dev, "failed to add port %s: %d\n",
+				port->name, err);
+		}
+	}
+
+	/* setup the AFI address translations */
+	tegra_pcie_setup_translations(pcie);
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		err = tegra_pcie_enable_msi(pcie);
+		if (err < 0) {
+			dev_err(&pdev->dev,
+				"failed to enable MSI support: %d\n",
+				err);
+			goto put_resources;
+		}
+	}
+
+	err = tegra_pcie_enable(pcie);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to enable PCIe ports: %d\n", err);
+		goto disable_msi;
+	}
+
+	platform_set_drvdata(pdev, pcie);
+	return 0;
+
+disable_msi:
+	if (IS_ENABLED(CONFIG_PCI_MSI))
+		tegra_pcie_disable_msi(pcie);
+put_resources:
+	tegra_pcie_put_resources(pcie);
+	return err;
+}
+
+static int tegra_pcie_remove(struct platform_device *pdev)
+{
+	struct tegra_pcie *pcie = platform_get_drvdata(pdev);
+	int err;
+
+	if (IS_ENABLED(CONFIG_PCI_MSI)) {
+		err = tegra_pcie_disable_msi(pcie);
+		if (err < 0)
+			return err;
+	}
+
+	err = tegra_pcie_put_resources(pcie);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static const struct of_device_id tegra_pcie_of_match[] = {
+	{ .compatible = "nvidia,tegra20-pcie", },
+	{ },
+};
+
+static struct platform_driver tegra_pcie_driver = {
+	.driver = {
+		.name = "tegra-pcie",
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_pcie_of_match,
+	},
+	.probe = tegra_pcie_probe,
+	.remove = tegra_pcie_remove,
+};
+module_platform_driver(tegra_pcie_driver);
-- 
1.8.1

