Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1CRPXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:23:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39990 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1CRPW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=hSzR4eyK4os/BEGTESU06kJoTmDF4LS8T4y6NpcqW0PNVqC8qAfWAP3sBmpbh5nVVm
         dB2bBkbtOSq+6d+dWnIAGSBf2ZSHbgWSAtGbcB2PLKPgcvCdW7S/izUeSE47T0ZDRZqn
         vuQRci14rs4s4N69a9/NLIsavjwqujQXMQ1Wc=
MIME-Version: 1.0
In-Reply-To: <20110318123637.GB2155@pengutronix.de>
References: <1300318163.12970.66.camel@desinto> <20110317212542.GB29231@pengutronix.de>
 <AANLkTimy3Qu=KiPp8mhAiuL=GzqUHuNLTZ3cwmNKkrF7@mail.gmail.com> <20110318123637.GB2155@pengutronix.de>
From: "vooon341@gmail.com" <vooon341@gmail.com>
Date: Fri, 18 Mar 2011 18:22:33 +0300
Message-ID: <AANLkTimDDpCHf7Cpjt5mi=d18OpX2Q4yiwNDK_26j0kD@mail.gmail.com>
Subject: Re: [PATCH 1/4,v3] powerpc/mpc512x: Add initial support for TWR-MPC5125
To: Wolfram Sang <w.sang@pengutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 3b94215206569d5c2bad20397cebfa9570c921bc
Author: Ermakov Vladimir <ermakov@tecon.ru>
Date:   Thu Mar 17 11:10:49 2011 +0300

    Adds Freescale TWR-MPC5125 device tree and platform code.

    Currently following is supported:
     - NAND
     - FEC1 and FEC2
     - RTC
     - PSC UART

    Signed-off-by: Vladimir Ermakov <vooon341@gmail.com>
    ---
    v2:
     - add PSC compat string selection
     - add ioctl defines

    v3:
     - less verbose interrupt-parent
     - move mpc512x_select_psc_compat() to mpc512x_shared.c
     - remove unneded mpc5125_psc_iopad_init()
     - fix board prefixes

diff --git a/arch/powerpc/boot/dts/mpc5125twr.dts
b/arch/powerpc/boot/dts/mpc5125twr.dts
new file mode 100644
index 0000000..d899f92
--- /dev/null
+++ b/arch/powerpc/boot/dts/mpc5125twr.dts
@@ -0,0 +1,368 @@
+/*
+ * STx/Freescale ADS5125 MPC5125 silicon
+ *
+ * Copyright (C) 2009 Freescale Semiconductor Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+/dts-v1/;
+
+/ {
+	model = "mpc5125twr"; // In BSP "mpc5125ads"
+	compatible = "fsl,mpc5125ads";
+	#address-cells = <1>;
+	#size-cells = <1>;
+	interrupt-parent = <&ipic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		PowerPC,5125@0 {
+			device_type = "cpu";
+			reg = <0>;
+			d-cache-line-size = <0x20>;	// 32 bytes
+			i-cache-line-size = <0x20>;	// 32 bytes
+			d-cache-size = <0x8000>;	// L1, 32K
+			i-cache-size = <0x8000>;	// L1, 32K
+			timebase-frequency = <49500000>;// 49.5 MHz (csb/4)
+			bus-frequency = <198000000>;	// 198 MHz csb bus
+			clock-frequency = <396000000>;	// 396 MHz ppc core
+		};
+	};
+
+	memory {
+		device_type = "memory";
+		reg = <0x00000000 0x10000000>;	// 256MB at 0
+	};
+
+	sram@30000000 {
+		compatible = "fsl,mpc5121-sram";
+		reg = <0x30000000 0x08000>;		// 32K at 0x30000000
+	};
+
+	nfc@40000000 {
+		compatible = "fsl,mpc5125-nfc";
+		reg = <0x40000000 0x100000>;	// 1M at 0x40000000
+		interrupts = <6 0x8>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		bank-width = <1>;
+		write-size = <4096>;
+		spare-size = <128>;
+		chips = <1>;
+		// NOTE: partition map different than in BSP
+		// First three is the same as in BSP, other differ.
+		nand-spl@0 {
+			label = "loader";
+			reg = <0x00000000 0x00100000>;
+			read-only;
+		};
+		uboot@100000 {
+			label = "uboot";
+			reg = <0x00100000 0x00100000>;
+			read-only;
+		};
+		uboot-env@200000 {
+			label = "uboot-env";
+			reg = <0x00200000 0x00100000>;
+			read-only;
+		};
+		kernel@300000 {
+			label = "kernel";
+			reg = <0x00300000 0x00800000>;
+		};
+		device-tree@b00000 {
+			label = "device-tree";
+			reg = <0x00b00000 0x00100000>;
+		};
+		ramboot-rootfs@c00000 {
+			label = "ramboot-rootfs";
+			reg = <0x00c00000 0x00800000>;
+		};
+		rootfs@1400000 {
+			label = "rootfs";
+			reg = <0x01400000 0x01400000>;
+		};
+		user@2800000 {
+			label = "user";
+			reg = <0x02800000 0x01400000>;
+		};
+		SRAM@4200000 {
+			label = "SRAM"; // NVRAM emul
+			reg = <0x04200000 0x01400000>;
+		};
+		prom@5600000 {
+			label = "prom";
+			reg = <0x05600000 0x01400000>;
+		};
+		//data@2800000 {
+		//	label = "data";
+		//	reg = <0x28000000 0xeac00000>;
+		//};
+	};
+
+	soc@80000000 {
+		compatible = "fsl,mpc5121-immr";
+		device_type = "soc";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		#interrupt-cells = <2>;
+		ranges = <0x0 0x80000000 0x400000>;
+		reg = <0x80000000 0x400000>;
+		bus-frequency = <66000000>;	// 66 MHz ips bus
+
+		// IPIC
+		// interrupts cell = <intr #, sense>
+		// sense values match linux IORESOURCE_IRQ_* defines:
+		// sense == 8: Level, low assertion
+		// sense == 2: Edge, high-to-low change
+		//
+		ipic: interrupt-controller@c00 {
+			compatible = "fsl,mpc5121-ipic", "fsl,ipic";
+			interrupt-controller;
+			#address-cells = <0>;
+			#interrupt-cells = <2>;
+			reg = <0xc00 0x100>;
+		};
+
+		rtc@a00 {	// Real time clock
+			compatible = "fsl,mpc5121-rtc";
+			reg = <0xa00 0x100>;
+			interrupts = <79 0x8 80 0x8>;
+		};
+
+		reset@e00 {	// Reset module
+			compatible = "fsl,mpc5121-reset";
+			reg = <0xe00 0x100>;
+		};
+
+		clock@f00 {	// Clock control
+			compatible = "fsl,mpc5121rev2-clock", "fsl,mpc5121-clock";
+			reg = <0xf00 0x100>;
+		};
+
+		pmc@1000{  // Power Management Controller
+			compatible = "fsl,mpc5121-pmc";
+			reg = <0x1000 0x100>;
+			interrupts = <83 0x2>;
+		};
+
+		gpio@1100 {
+			compatible = "fsl,mpc5125-gpio";
+			cell-index = <0>;
+			reg = <0x1100 0x080>;
+			interrupts = <78 0x8>;
+		};
+
+		gpio@1180 {
+			compatible = "fsl,mpc5125-gpio1";
+			cell-index = <1>;
+			reg = <0x1180 0x080>;
+			interrupts = <78 0x8>;
+		};
+
+		can@1300 { // CAN rev.2
+			compatible = "fsl,mpc5121-mscan";
+			cell-index = <0>;
+			interrupts = <12 0x8>;
+			reg = <0x1300 0x80>;
+		};
+
+		can@1380 {
+			compatible = "fsl,mpc5121-mscan";
+			cell-index = <1>;
+			interrupts = <13 0x8>;
+			reg = <0x1380 0x80>;
+		};
+
+		sdhc@1500 {
+			compatible = "fsl,mpc5125-sdhc";
+			interrupts = <8 0x8>;
+			reg = <0x1500 0x100>;
+		};
+
+		i2c@1700 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl-i2c";
+			cell-index = <0>;
+			reg = <0x1700 0x20>;
+			interrupts = <0x9 0x8>;
+			fsl5200-clocking;
+		};
+
+		i2c@1720 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl-i2c";
+			cell-index = <1>;
+			reg = <0x1720 0x20>;
+			interrupts = <0xa 0x8>;
+			fsl5200-clocking;
+		};
+
+		i2c@1740 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			compatible = "fsl-i2c";
+			cell-index = <2>;
+			reg = <0x1740 0x20>;
+			interrupts = <0xb 0x8>;
+			fsl5200-clocking;
+		};
+
+		i2ccontrol@1760 {
+			compatible = "fsl,mpc5121-i2c-ctrl";
+			reg = <0x1760 0x8>;
+		};
+
+		//diu@2100 {
+		//	device_type = "display";
+		//	compatible = "fsl-diu";
+		//	reg = <0x2100 0x100>;
+		//	interrupts = <64 0x8>;
+		//};
+
+		// MPC5125e has two more CAN ports
+		// but they are not used on ADS5125
+		//can@2300 {
+		//	compatible = "fsl,mpc5121-mscan";
+		//	cell-index = <2>;
+		//	interrupts = <90 0x8>;
+		//	reg = <0x2300 0x80>;
+		//};
+
+		//can@2380 {
+		//	compatible = "fsl,mpc5121-mscan";
+		//	cell-index = <3>;
+		//	interrupts = <91 0x8>;
+		//	reg = <0x2380 0x80>;
+		//};
+
+		mdio@2800 {
+			compatible = "fsl,mpc5121-fec-mdio";
+			reg = <0x2800 0x800>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			phy0: ethernet-phy@0 {
+				reg = <1>;
+				device_type = "ethernet-phy";
+			};
+		};
+
+		ethernet@2800 {
+			compatible = "fsl,mpc5121-fec";
+			reg = <0x2800 0x800>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			interrupts = <4 0x8>;
+			phy-handle = < &phy0 >;
+		};
+
+		// USB ULPI1
+		//usb@3000 {
+		//	device_type = "usb";
+		//	compatible = "fsl-usb2-dr";
+		//	reg = <0x3000 0x400>;
+		//	#address-cells = <1>;
+		//	#size-cells = <0>;
+		//	interrupts = <43 0x8>;
+		//	dr_mode = "host";
+		//	phy_type = "ulpi";
+		//	big-endian-regs;
+		//};
+
+		// USB ULPI2
+		//usb@4000 {
+		//	device_type = "usb";
+		//	compatible = "fsl-usb2-dr";
+		//	reg = <0x4000 0x400>;
+		//	#address-cells = <1>;
+		//	#size-cells = <0>;
+		//	interrupts = <44 0x8>;
+		//	dr_mode = "otg";
+		//	phy_type = "ulpi";
+		//	big-endian-regs;
+		//};
+
+		mdio@4800 {
+			compatible = "fsl,mpc5121-fec-mdio";
+			reg = <0x4800 0x800>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			phy1: ethernet-phy@0 {
+				reg = <1>;
+				device_type = "ethernet-phy";
+			};
+		};
+
+		ethernet@4800 {
+			compatible = "fsl,mpc5121-fec";
+			reg = <0x4800 0x800>;
+			local-mac-address = [ 00 00 00 00 00 00 ];
+			interrupts = <5 0x8>;
+			phy-handle = < &phy1 >;
+		};
+
+		// IO control
+		ioctl@a000 {
+			compatible = "fsl,mpc5125-ioctl";
+			reg = <0xA000 0x1000>;
+		};
+
+		// PSC0 in ac97 mode
+		//ac97@11000 {
+		//	device_type = "sound";
+		//	compatible = "fsl,mpc5125-psc-ac97", "fsl,mpc5125-psc";
+		//	cell-index = <0>;
+		//	reg = <0x11000 0x100>;
+		//	interrupts = <40 0x8>;
+		//	fsl,mode = "ac97-slave";
+		//	rx-fifo-size = <384>;
+		//	tx-fifo-size = <384>;
+		//};
+
+		// 5125 PSCs are not 52xx or 5121 PSC compatible
+		// PSC1 uart0 aka ttyPSC0
+		serial@11100 {
+			device_type = "serial";
+			compatible = "fsl,mpc5125-psc-uart", "fsl,mpc5125-psc";
+			port-number = <0>;
+			cell-index = <1>;
+			reg = <0x11100 0x100>;
+			interrupts = <40 0x8 71 0x8>;
+			fsl,rx-fifo-size = <16>;
+			fsl,tx-fifo-size = <16>;
+			nodcd;
+		};
+
+		// PSC9 uart1 aka ttyPSC1
+		serial@11900 {
+			device_type = "serial";
+			compatible = "fsl,mpc5125-psc-uart", "fsl,mpc5125-psc";
+			port-number = <1>;
+			cell-index = <9>;
+			reg = <0x11900 0x100>;
+			interrupts = <40 0x8 32 0x8>;
+			fsl,rx-fifo-size = <16>;
+			fsl,tx-fifo-size = <16>;
+			nodcd;
+		};
+
+		pscfifo@11f00 {
+			compatible = "fsl,mpc5121-psc-fifo";
+			reg = <0x11f00 0x100>;
+			interrupts = <40 0x8>;
+		};
+
+		dma@14000 {
+			compatible = "fsl,mpc5121-dma"; // BSP name: "mpc512x-dma2"
+			reg = <0x14000 0x1800>;
+			interrupts = <65 0x8>;
+		};
+	};
+};
diff --git a/arch/powerpc/platforms/512x/Kconfig
b/arch/powerpc/platforms/512x/Kconfig
index 27b0651..0dde4b0 100644
--- a/arch/powerpc/platforms/512x/Kconfig
+++ b/arch/powerpc/platforms/512x/Kconfig
@@ -26,6 +26,20 @@ config MPC5121_GENERIC
 	  Compatible boards include:  Protonic LVT base boards (ZANMCU
 	  and VICVT2).

+config PPC_MPC5125
+	bool "Generic support for MPC5125 based boards"
+	depends on PPC_MPC512x
+	select DEFAULT_UIMAGE
+	select PPC_INDIRECT_PCI
+	default n
+
+config MPC5125_TWR
+	bool "Freescale MPC5125 Tower system"
+	depends on PPC_MPC512x
+	select PPC_MPC5125
+	help
+	  This option enables support for the MPC5125 TWR board.
+
 config PDM360NG
 	bool "ifm PDM360NG board"
 	depends on PPC_MPC512x
diff --git a/arch/powerpc/platforms/512x/Makefile
b/arch/powerpc/platforms/512x/Makefile
index 4efc1c4..5c17561 100644
--- a/arch/powerpc/platforms/512x/Makefile
+++ b/arch/powerpc/platforms/512x/Makefile
@@ -5,3 +5,4 @@ obj-y				+= clock.o mpc512x_shared.o
 obj-$(CONFIG_MPC5121_ADS)	+= mpc5121_ads.o mpc5121_ads_cpld.o
 obj-$(CONFIG_MPC5121_GENERIC)	+= mpc5121_generic.o
 obj-$(CONFIG_PDM360NG)		+= pdm360ng.o
+obj-$(CONFIG_MPC5125_TWR)	+= mpc5125_twr.o
diff --git a/arch/powerpc/platforms/512x/clock.c
b/arch/powerpc/platforms/512x/clock.c
index 3dc2a8d..07e0bc0 100644
--- a/arch/powerpc/platforms/512x/clock.c
+++ b/arch/powerpc/platforms/512x/clock.c
@@ -27,6 +27,8 @@
 #include <asm/mpc5xxx.h>
 #include <asm/clk_interface.h>

+#include "mpc512x.h"
+
 #undef CLK_DEBUG

 static int clocks_initialized;
@@ -679,8 +681,13 @@ static void psc_clks_init(void)
 	struct device_node *np;
 	const u32 *cell_index;
 	struct platform_device *ofdev;
+	char *psc_compat;
+
+	psc_compat = mpc512x_select_psc_compat();
+	if (!psc_compat)
+		return;

-	for_each_compatible_node(np, NULL, "fsl,mpc5121-psc") {
+	for_each_compatible_node(np, NULL, psc_compat) {
 		cell_index = of_get_property(np, "cell-index", NULL);
 		if (cell_index) {
 			int pscnum = *cell_index;
diff --git a/arch/powerpc/platforms/512x/mpc5125_twr.c
b/arch/powerpc/platforms/512x/mpc5125_twr.c
new file mode 100644
index 0000000..7c7facf
--- /dev/null
+++ b/arch/powerpc/platforms/512x/mpc5125_twr.c
@@ -0,0 +1,142 @@
+/*
+ * Copyright (C) 2010 LimePC Multimedia Technologies Co., Limited
+ * Copyright (C) 2011 Vladimir Ermakov <vooon341@gmail.com>
+ *
+ * Based on original Freescale Semiconductor BSP
+ * written by Cloudy Chen <chen_yunsong@mtcera.com>
+ *
+ * MPC5125 Tower board setup
+ *
+ * This is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/of_platform.h>
+
+#include <asm/machdep.h>
+#include <asm/ipic.h>
+#include <asm/prom.h>
+#include <asm/time.h>
+
+#include <sysdev/fsl_soc.h>
+
+#include <linux/bootmem.h>
+#include <asm/rheap.h>
+
+#include "mpc512x.h"
+
+/* IOCTL registers for USB1/FEC2 */
+#define IOCTL_USB1_DATA0	0x63
+#define IOCTL_USB1_DATA1	0x64
+#define IOCTL_USB1_DATA2	0x65
+#define IOCTL_USB1_DATA3	0x66
+#define IOCTL_USB1_DATA4	0x67
+#define IOCTL_USB1_DATA5	0x68
+#define IOCTL_USB1_DATA6	0x69
+#define IOCTL_USB1_DATA7	0x6A
+#define IOCTL_USB1_STOP		0x6B
+#define IOCTL_USB1_CLK		0x6C
+#define IOCTL_USB1_NEXT		0x6D
+#define IOCTL_USB1_DIR		0x6E
+
+/* Pin modes */
+#define IOCTL_DEFAULT_MODE	0x03 /* FUNCMUX=0, PUD=0, PUE=0, DS=3 */
+#define IOCTL_FEC2_MODE		0x43 /* FUNCMUX=2, PUD=0, PUE=0, DS=3 */
+
+/* Select mode of USB1 pads.
+ * They could be configured as USB (default), FEC2
+ * and several PSC's and/or GPIO's.
+ * Board specific. It can be platform specific in the future.
+ */
+static void mpc5125_twr_fec2_usb_iopad_init(void __iomem *ioctl, int isusb)
+{
+	int i;
+	const u8 offset[12] = {
+		IOCTL_USB1_DATA0, IOCTL_USB1_DATA1,
+		IOCTL_USB1_DATA2, IOCTL_USB1_DATA3,
+		IOCTL_USB1_DATA4, IOCTL_USB1_DATA5,
+		IOCTL_USB1_DATA6, IOCTL_USB1_DATA7,
+		IOCTL_USB1_STOP, IOCTL_USB1_CLK,
+		IOCTL_USB1_NEXT, IOCTL_USB1_DIR
+	};
+	u8 mode;
+
+	mode = (isusb) ? IOCTL_DEFAULT_MODE : IOCTL_FEC2_MODE;
+	for (i = 0; i < ARRAY_SIZE(offset); i++)
+		out_8(ioctl + offset[i], mode);
+}
+
+static void __init mpc5125_twr_setup_arch(void)
+{
+	struct device_node *np;
+
+	printk(KERN_INFO "TWR-MPC5125 board from Freescale Semiconductor\n");
+
+	/*
+	 * io pad config
+	 */
+	np = of_find_compatible_node(NULL, NULL, "fsl,mpc5125-ioctl");
+	if (np) {
+		void __iomem *ioctl = of_iomap(np, 0);
+
+		mpc5125_twr_fec2_usb_iopad_init(ioctl, 0);
+
+		of_node_put(np);
+		iounmap(ioctl);
+	}
+}
+
+static struct of_device_id __initdata of_bus_ids[] = {
+	{ .name = "soc", },
+	{},
+};
+
+static void __init mpc5125_twr_declare_of_platform_devices(void)
+{
+	struct device_node *np;
+
+	if (of_platform_bus_probe(NULL, of_bus_ids, NULL))
+		printk(KERN_ERR __FILE__ ": "
+			"Error while probing of_platform bus\n");
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,mpc5125-nfc");
+	if (np) {
+		of_platform_device_create(np, NULL, NULL);
+		of_node_put(np);
+	}
+}
+
+static void __init mpc5125_twr_init(void)
+{
+	mpc5125_twr_declare_of_platform_devices();
+	mpc5121_clk_init();
+	mpc512x_restart_init();
+	mpc512x_psc_fifo_init();
+}
+
+/*
+ * Called very early, MMU is off, device-tree isn't unflattened
+ */
+static int __init mpc5125_twr_probe(void)
+{
+	unsigned long root = of_get_flat_dt_root();
+
+	return of_flat_dt_is_compatible(root, "fsl,mpc5125ads");
+}
+
+define_machine(mpc5125_twr) {
+	.name			= "TWR-MPC5125",
+	.probe			= mpc5125_twr_probe,
+	.setup_arch		= mpc5125_twr_setup_arch,
+	.init			= mpc5125_twr_init,
+	.init_IRQ		= mpc512x_init_IRQ,
+	.get_irq		= ipic_get_irq,
+	.calibrate_decr		= generic_calibrate_decr,
+	.restart		= mpc512x_restart,
+};
diff --git a/arch/powerpc/platforms/512x/mpc512x.h
b/arch/powerpc/platforms/512x/mpc512x.h
index 1ab6d11..91c903f 100644
--- a/arch/powerpc/platforms/512x/mpc512x.h
+++ b/arch/powerpc/platforms/512x/mpc512x.h
@@ -13,8 +13,11 @@
 #define __MPC512X_H__
 extern void __init mpc512x_init_IRQ(void);
 extern void __init mpc512x_init(void);
+extern void __init mpc512x_restart_init(void);
 extern int __init mpc5121_clk_init(void);
-void __init mpc512x_declare_of_platform_devices(void);
+extern void __init mpc512x_declare_of_platform_devices(void);
+extern void __init mpc512x_psc_fifo_init(void);
+extern char *mpc512x_select_psc_compat(void);
 extern void mpc512x_restart(char *cmd);
 extern void mpc512x_init_diu(void);
 extern void mpc512x_setup_diu(void);
diff --git a/arch/powerpc/platforms/512x/mpc512x_shared.c
b/arch/powerpc/platforms/512x/mpc512x_shared.c
index e41ebbd..e79d8ae 100644
--- a/arch/powerpc/platforms/512x/mpc512x_shared.c
+++ b/arch/powerpc/platforms/512x/mpc512x_shared.c
@@ -32,7 +32,7 @@

 static struct mpc512x_reset_module __iomem *reset_module_base;

-static void __init mpc512x_restart_init(void)
+void __init mpc512x_restart_init(void)
 {
 	struct device_node *np;

@@ -382,6 +382,21 @@ void __init mpc512x_declare_of_platform_devices(void)

 #define DEFAULT_FIFO_SIZE 16

+char *mpc512x_select_psc_compat(void)
+{
+	char *psc_compats[] = {
+		"fsl,mpc5121-psc",
+		"fsl,mpc5125-psc"
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(psc_compats); i++)
+		if (of_find_compatible_node(NULL, NULL, psc_compats[i]))
+			return psc_compats[i];
+
+	return NULL;
+}
+
 static unsigned int __init get_fifo_size(struct device_node *np,
 					 char *prop_name)
 {
@@ -407,9 +422,16 @@ void __init mpc512x_psc_fifo_init(void)
 	void __iomem *psc;
 	unsigned int tx_fifo_size;
 	unsigned int rx_fifo_size;
+	char *psc_compat;
 	int fifobase = 0; /* current fifo address in 32 bit words */

-	for_each_compatible_node(np, NULL, "fsl,mpc5121-psc") {
+	psc_compat = mpc512x_select_psc_compat();
+	if (!psc_compat) {
+		pr_err("%s: no compatible devices found\n", __func__);
+		return;
+	}
+
+	for_each_compatible_node(np, NULL, psc_compat) {
 		tx_fifo_size = get_fifo_size(np, "fsl,tx-fifo-size");
 		rx_fifo_size = get_fifo_size(np, "fsl,rx-fifo-size");


2011/3/18 Wolfram Sang <w.sang@pengutronix.de>:
> On Fri, Mar 18, 2011 at 02:35:24PM +0300, vooon341@gmail.com wrote:
>
>> diff --git a/arch/powerpc/platforms/512x/clock.c
>> b/arch/powerpc/platforms/512x/clock.c
>> index 3dc2a8d..5cadf8e 100644
>> --- a/arch/powerpc/platforms/512x/clock.c
>> +++ b/arch/powerpc/platforms/512x/clock.c
>> @@ -606,6 +606,21 @@ static void rate_clks_init(void)
>>   */
>>  struct clk dev_clks[2][32];
>>
>> +char *mpc512x_select_psc_compat(void)
>> +{
>> +     char *psc_compats[] = {
>> +             "fsl,mpc5121-psc",
>> +             "fsl,mpc5125-psc"
>> +     };
>> +     int i;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(psc_compats); i++)
>> +             if (of_find_compatible_node(NULL, NULL, psc_compats[i]))
>> +                     return psc_compats[i];
>> +
>> +     return NULL;
>> +}
>
> Function looks good to me. Shouldn't that rather be in mpc512x_shared?
>
>> +// IOCTL registers for USB1/FEC2
>
> No c++-style comments, please (here and later).
>
>> +static void mpc5125_psc_iopad_init(void __iomem *ioctl, char *name)
>> +{
>> +     struct device_node *np;
>> +     const u32 *cell_index;
>> +     char *default_psc = "fsl,mpc5125-psc";
>> +     char *psc_name;
>> +
>> +     if (name)
>> +             psc_name = name;
>> +     else
>> +             psc_name = default_psc;
>
> Caller sets name to NULL. Is this really used?
>
>> +
>> +     for_each_compatible_node(np, NULL, psc_name) {
>> +             cell_index = of_get_property(np, "cell-index", NULL);
>
> I seem to recall 'cell-index' is deprecated. Grant?
>
>> +             if (cell_index) {
>> +                     u8 __iomem *pscioctl;
>> +                     int psc_num = *cell_index;
>> +                     if (psc_num > 1)
>> +                             continue;
>> +
>> +                     pscioctl = ioctl + PSC_TO_IOCTL_OFFSET(psc_num);
>> +                     out_8(pscioctl + IOCTL_PSCx_0, IOCTL_PSCx_0_MODE); // NOTE maybe wrong
>
> Why is it 'maybe wrong'? Can it be improved somehow?
>
>> +                     out_8(pscioctl + IOCTL_PSCx_1, IOCTL_DEFAULT_MODE);
>> +                     out_8(pscioctl + IOCTL_PSCx_2, IOCTL_DEFAULT_MODE);
>> +                     out_8(pscioctl + IOCTL_PSCx_3, IOCTL_DEFAULT_MODE);
>> +                     out_8(pscioctl + IOCTL_PSCx_4, IOCTL_DEFAULT_MODE);
>
> The defines make it much more readable, thanks.
>
>> +             }
>> +     }
>> +}
>
> Is this function really board-specific or platform specific?
>
>
>> +static void mpc5125_fec2_usb_io_init(void __iomem *ioctl, int isusb)
>> +{
>> +     int i;
>> +     const u8 offset[12] = {
>> +             IOCTL_USB1_DATA0, IOCTL_USB1_DATA1,
>> +             IOCTL_USB1_DATA2, IOCTL_USB1_DATA3,
>> +             IOCTL_USB1_DATA4, IOCTL_USB1_DATA5,
>> +             IOCTL_USB1_DATA6, IOCTL_USB1_DATA7,
>> +             IOCTL_USB1_STOP, IOCTL_USB1_CLK,
>> +             IOCTL_USB1_NEXT, IOCTL_USB1_DIR
>> +     };
>> +     u8 mode;
>> +
>> +     mode = (isusb) ? IOCTL_DEFAULT_MODE : IOCTL_FEC2_MODE;
>> +     for (i = 0; i < ARRAY_SIZE(offset); i++)
>> +             out_8(ioctl + offset[i], mode);
>> +}
>
> Same question here and later. If it is board specific, the function name should
> have something like 'twr' in it; but a few things seem mpc5125-generic
> to me, if I am not mistaken?
>
> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk2DUdUACgkQD27XaX1/VRtRhwCfU5saH7ThSl1WsdlSseySqvbF
> BFEAoKskDlkkz53myb4FpvOBlMdAtUS1
> =554E
> -----END PGP SIGNATURE-----
>
>
