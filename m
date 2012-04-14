Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2DNKzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 06:55:38 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:30637 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754230Ab2DNKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 06:54:14 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, axel.lin@gmail.com,
        broonie@opensource.wolfsonmicro.com, marek.vasut@gmail.com,
        thierry.reding@avionic-design.de, devel@driverdev.osuosl.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 4/4] ARM: LPC32xx: Device tree support
Date: Sat, 14 Apr 2012 12:53:10 +0200
Message-Id: <1334400790-10892-5-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334400790-10892-1-git-send-email-stigge@antcom.de>
References: <1334400790-10892-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support for the LPC32xx SoC

arch/arm/boot/dts/lpc32xx.dtsi: Include for devices based on LPC32xx
arch/arm/boot/dts/phy3250.dts: Board support for PHYTEC phyCORE-LPC3250
arch/arm/boot/mach-lpc32xx/irq.c: irq domain conversion

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc2 and requires the previously posted lpc32xx driver dt
patches (Set 1: 1..8 + GPIO patch)

 Documentation/devicetree/bindings/arm/lpc32xx-mic.txt |   38 ++
 Documentation/devicetree/bindings/arm/lpc32xx.txt     |    8 
 arch/arm/Kconfig                                      |    1 
 arch/arm/boot/dts/lpc32xx.dtsi                        |  303 ++++++++++++++++++
 arch/arm/boot/dts/phy3250.dts                         |  108 ++++++
 arch/arm/mach-lpc32xx/Kconfig                         |   26 -
 arch/arm/mach-lpc32xx/clock.c                         |   77 ++--
 arch/arm/mach-lpc32xx/common.c                        |  192 -----------
 arch/arm/mach-lpc32xx/common.h                        |   14 
 arch/arm/mach-lpc32xx/irq.c                           |   78 +++-
 arch/arm/mach-lpc32xx/phy3250.c                       |  146 +++-----
 11 files changed, 613 insertions(+), 378 deletions(-)

--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/arm/lpc32xx-mic.txt
@@ -0,0 +1,38 @@
+* NXP LPC32xx Main Interrupt Controller
+  (MIC, including SIC1 and SIC2 secondary controllers)
+
+Required properties:
+- compatible: Should be "nxp,lpc32xx-mic"
+- interrupt-controller: Identifies the node as an interrupt controller.
+- interrupt-parent: Empty for the interrupt controller itself
+- #interrupt-cells: The number of cells to define the interrupts. Should be 2.
+  The first cell is the IRQ number
+  The second cell is used to specify mode:
+      1 = low-to-high edge triggered
+      2 = high-to-low edge triggered
+      4 = active high level-sensitive
+      8 = active low level-sensitive
+      Default for internal sources should be set to 4 (active high).
+- reg: Should contain MIC registers location and length
+
+Examples:
+	/*
+	 * MIC
+	 */
+	mic: interrupt-controller@40008000 {
+		compatible = "nxp,lpc32xx-mic";
+		interrupt-controller;
+		interrupt-parent;
+		#interrupt-cells = <2>;
+		reg = <0x40008000 0xC000>;
+	};
+
+	/*
+	 * ADC
+	 */
+	adc@40048000 {
+		compatible = "nxp,lpc32xx-adc";
+		reg = <0x40048000 0x1000>;
+		interrupt-parent = <&mic>;
+		interrupts = <39 4>;
+	};
--- /dev/null
+++ linux-2.6/Documentation/devicetree/bindings/arm/lpc32xx.txt
@@ -0,0 +1,8 @@
+NXP LPC32xx Platforms Device Tree Bindings
+------------------------------------------
+
+Boards with the NXP LPC32xx SoC shall have the following properties:
+
+Required root node property:
+
+compatible = "nxp,lpc32xx";
--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -597,6 +597,7 @@ config ARCH_LPC32XX
 	select USB_ARCH_HAS_OHCI
 	select CLKDEV_LOOKUP
 	select GENERIC_CLOCKEVENTS
+	select USE_OF
 	help
 	  Support for the NXP LPC32XX family of processors
 
--- /dev/null
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -0,0 +1,303 @@
+/*
+ * NXP LPC32xx SoC
+ *
+ * Copyright 2012 Roland Stigge <stigge@antcom.de>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "nxp,lpc32xx";
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,arm926ejs";
+		};
+	};
+
+	ahb {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "simple-bus";
+		ranges = <0x20000000 0x20000000 0x30000000>;
+
+		slc: flash@20020000 {
+			compatible = "nxp,nand-slc";
+			reg = <0x20020000 0x1000>;
+			status = "disable";
+		};
+
+		mlc: flash@200B0000 {
+			compatible = "nxp,nand-mlc";
+			reg = <0x200B0000 0x1000>;
+			status = "disable";
+		};
+
+		dma@31000000 {
+			compatible = "arm,pl080", "arm,primecell";
+			reg = <0x31000000 0x1000>;
+			interrupt-parent = <&mic>;
+			interrupts = <0x1c 0>;
+		};
+
+		/*
+		 * Enable either ohci or usbd (gadget)!
+		 */
+		ohci@31020000 {
+			compatible = "nxp,ohci-nxp", "usb-ohci";
+			reg = <0x31020000 0x300>;
+			interrupt-parent = <&mic>;
+			interrupts = <0x3b 0>;
+			status = "disable";
+		};
+
+		usbd@31020000 {
+			compatible = "nxp,lpc32xx-udc";
+			reg = <0x31020000 0x300>;
+			interrupt-parent = <&mic>;
+			interrupts = <0x3d 0>, <0x3e 0>, <0x3c 0>, <0x3a 0>;
+			status = "disable";
+		};
+
+		clcd@31040000 {
+			compatible = "arm,pl110", "arm,primecell";
+			reg = <0x31040000 0x1000>;
+			interrupt-parent = <&mic>;
+			interrupts = <0x0e 0>;
+			status = "disable";
+		};
+
+		mac: ethernet@31060000 {
+			compatible = "nxp,lpc-eth";
+			reg = <0x31060000 0x1000>;
+			interrupt-parent = <&mic>;
+			interrupts = <0x1d 0>;
+		};
+
+		apb {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "simple-bus";
+			ranges = <0x20000000 0x20000000 0x30000000>;
+
+			ssp0: ssp@20084000 {
+				compatible = "arm,pl022", "arm,primecell";
+				reg = <0x20084000 0x1000>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x14 0>;
+			};
+
+			spi1: spi@20088000 {
+				compatible = "nxp,spi";
+				reg = <0x20088000 0x1000>;
+			};
+
+			ssp1: ssp@2008c000 {
+				compatible = "arm,pl022", "arm,primecell";
+				reg = <0x2008c000 0x1000>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x15 0>;
+			};
+
+			spi2: spi@20090000 {
+				compatible = "nxp,spi";
+				reg = <0x20090000 0x1000>;
+			};
+
+			i2s0: i2s@20094000 {
+				compatible = "nxp,i2s";
+				reg = <0x20094000 0x1000>;
+			};
+
+			sd@20098000 {
+				compatible = "arm,pl180", "arm,primecell";
+				reg = <0x20098000 0x1000>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x0f 0>, <0x0d 0>;
+			};
+
+			i2s1: i2s@2009C000 {
+				compatible = "nxp,i2s";
+				reg = <0x2009C000 0x1000>;
+			};
+
+			uart3: serial@40080000 {
+				compatible = "nxp,serial";
+				reg = <0x40080000 0x1000>;
+			};
+
+			uart4: serial@40088000 {
+				compatible = "nxp,serial";
+				reg = <0x40088000 0x1000>;
+			};
+
+			uart5: serial@40090000 {
+				compatible = "nxp,serial";
+				reg = <0x40090000 0x1000>;
+			};
+
+			uart6: serial@40098000 {
+				compatible = "nxp,serial";
+				reg = <0x40098000 0x1000>;
+			};
+
+			i2c1: i2c@400A0000 {
+				compatible = "nxp,pnx-i2c";
+				reg = <0x400A0000 0x100>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x33 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				pnx,timeout = <0x64>;
+			};
+
+			i2c2: i2c@400A8000 {
+				compatible = "nxp,pnx-i2c";
+				reg = <0x400A8000 0x100>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x32 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				pnx,timeout = <0x64>;
+			};
+
+			i2cusb: i2c@31020300 {
+				compatible = "nxp,pnx-i2c";
+				reg = <0x31020300 0x100>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x3f 0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+				pnx,timeout = <0x64>;
+			};
+		};
+
+		fab {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "simple-bus";
+			ranges = <0x20000000 0x20000000 0x30000000>;
+
+			/*
+			 * MIC Interrupt controller includes:
+			 *   MIC @40008000
+			 *   SIC1 @4000C000
+			 *   SIC2 @40010000
+			 */
+			mic: interrupt-controller@40008000 {
+				compatible = "nxp,lpc32xx-mic";
+				interrupt-controller;
+				interrupt-parent;
+				reg = <0x40008000 0xC000>;
+				#interrupt-cells = <2>;
+			};
+
+			uart1: serial@40014000 {
+				compatible = "nxp,serial";
+				reg = <0x40014000 0x1000>;
+			};
+
+			uart2: serial@40018000 {
+				compatible = "nxp,serial";
+				reg = <0x40018000 0x1000>;
+			};
+
+			uart7: serial@4001C000 {
+				compatible = "nxp,serial";
+				reg = <0x4001C000 0x1000>;
+			};
+
+			rtc@40024000 {
+				compatible = "nxp,lpc32xx-rtc";
+				reg = <0x40024000 0x1000>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x34 0>;
+			};
+
+			gpio: gpio@40028000 {
+				compatible = "nxp,lpc32xx-gpio";
+				reg = <0x40028000 0x1000>;
+				/* create a private address space for enumeration */
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				gpio_p0: gpio-bank@0 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <0>;
+				};
+
+				gpio_p1: gpio-bank@1 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <1>;
+				};
+
+				gpio_p2: gpio-bank@2 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <2>;
+				};
+
+				gpio_p3: gpio-bank@3 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <3>;
+				};
+
+				gpi_p3: gpio-bank@4 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <4>;
+				};
+
+				gpo_p3: gpio-bank@5 {
+					gpio-controller;
+					#gpio-cells = <2>;
+					reg = <5>;
+				};
+			};
+
+			watchdog@4003C000 {
+				compatible = "nxp,pnx4008-wdt";
+				reg = <0x4003C000 0x1000>;
+			};
+
+			/*
+			 * TSC vs. ADC: Since those two share the same
+			 * hardware, you need to choose from one of the
+			 * following two and do 'status = "okay";" for one of
+			 * them
+			 */
+
+			adc@40048000 {
+				compatible = "nxp,lpc32xx-adc";
+				reg = <0x40048000 0x1000>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x27 0>;
+				status = "disable";
+			};
+
+			tsc@40048000 {
+				compatible = "nxp,lpc32xx-tsc";
+				reg = <0x40048000 0x1000>;
+				interrupt-parent = <&mic>;
+				interrupts = <0x27 0>;
+				status = "disable";
+			};
+
+			key@40050000 {
+				compatible = "nxp,key";
+				reg = <0x40050000 0x1000>;
+			};
+
+		};
+	};
+};
--- /dev/null
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -0,0 +1,108 @@
+/*
+ * PHYTEC phyCORE-LPC3250 board
+ *
+ * Copyright 2012 Roland Stigge <stigge@antcom.de>
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+/dts-v1/;
+/include/ "lpc32xx.dtsi"
+
+/ {
+	model = "PHYTEC phyCORE-LPC3250 board based on NXP LPC3250";
+	compatible = "phytec,phy3250", "nxp,lpc32xx";
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	memory {
+		device_type = "memory";
+		reg = <0 0x4000000>;
+	};
+
+	ahb {
+		mac: ethernet@31060000 {
+			phy-mode = "rmii";
+			use-iram;
+		};
+
+		/* Here, choose from: ohci, usbd */
+		ohci@31020000 {
+			status = "okay";
+		};
+
+/*
+		usbd@31020000 {
+			status = "okay";
+		};
+*/
+
+		clcd@31040000 {
+			status = "okay";
+		};
+
+		apb {
+			i2c1: i2c@400A0000 {
+				clock-frequency = <0x186a0>;
+
+				pcf8563: rtc@51 {
+					compatible = "nxp,pcf8563";
+					reg = <0x51>;
+				};
+
+				uda1380: uda1380@18 {
+					compatible = "nxp,uda1380";
+					reg = <0x18>;
+					power-gpio = <&gpio 0x59 0>;
+					reset-gpio = <&gpio 0x51 0>;
+					dac-clk = "wspll";
+				};
+			};
+
+			i2c2: i2c@400A8000 {
+				clock-frequency = <0x186a0>;
+			};
+
+			i2cusb: i2c@31020300 {
+				clock-frequency = <0x186a0>;
+			};
+
+			ssp0: ssp@20084000 {
+				eeprom: at25@0 {
+					compatible = "atmel,at25";
+				};
+			};
+		};
+
+		fab {
+			tsc@40048000 {
+				status = "okay";
+			};
+		};
+	};
+
+	leds {
+		compatible = "gpio-leds";
+
+		led0 {
+			gpios = <&gpo_p3 1 1>; /* GPO_P3 1, GPIO 80, active low */
+			linux,default-trigger = "heartbeat";
+			default-state = "off";
+		};
+
+		led1 {
+			gpios = <&gpo_p3 14 1>; /* GPO_P3 14, GPIO 93, active low */
+			linux,default-trigger = "timer";
+			default-state = "off";
+		};
+	};
+
+	chosen {
+		bootargs = "console=ttyS0,115200n81 root=/dev/ram0";
+	};
+};
--- linux-2.6.orig/arch/arm/mach-lpc32xx/Kconfig
+++ linux-2.6/arch/arm/mach-lpc32xx/Kconfig
@@ -29,30 +29,4 @@ config ARCH_LPC32XX_UART6_SELECT
 
 endmenu
 
-menu "LPC32XX chip components"
-
-config ARCH_LPC32XX_IRAM_FOR_NET
-	bool "Use IRAM for network buffers"
-	default y
-	help
-	  Say Y here to use the LPC internal fast IRAM (i.e. 256KB SRAM) as
-	  network buffer.  If the total combined required buffer sizes is
-	  larger than the size of IRAM, then SDRAM will be used instead.
-
-	  This can be enabled safely if the IRAM is not intended for other
-	  uses.
-
-config ARCH_LPC32XX_MII_SUPPORT
-	bool "Check to enable MII support or leave disabled for RMII support"
-	help
-	  Say Y here to enable MII support, or N for RMII support. Regardless of
-	  which support is selected, the ethernet interface driver needs to be
-	  selected in the device driver networking section.
-
-	  The PHY3250 reference board uses RMII, so users of this board should
-	  say N.
-
-endmenu
-
 endif
-
--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1095,49 +1095,42 @@ struct clk *clk_get_parent(struct clk *c
 }
 EXPORT_SYMBOL(clk_get_parent);
 
-#define _REGISTER_CLOCK(d, n, c) \
-	{ \
-		.dev_id = (d), \
-		.con_id = (n), \
-		.clk = &(c), \
-	},
-
 static struct clk_lookup lookups[] = {
-	_REGISTER_CLOCK(NULL, "osc_32KHz", osc_32KHz)
-	_REGISTER_CLOCK(NULL, "osc_pll397", osc_pll397)
-	_REGISTER_CLOCK(NULL, "osc_main", osc_main)
-	_REGISTER_CLOCK(NULL, "sys_ck", clk_sys)
-	_REGISTER_CLOCK(NULL, "arm_pll_ck", clk_armpll)
-	_REGISTER_CLOCK(NULL, "ck_pll5", clk_usbpll)
-	_REGISTER_CLOCK(NULL, "hclk_ck", clk_hclk)
-	_REGISTER_CLOCK(NULL, "pclk_ck", clk_pclk)
-	_REGISTER_CLOCK(NULL, "timer0_ck", clk_timer0)
-	_REGISTER_CLOCK(NULL, "timer1_ck", clk_timer1)
-	_REGISTER_CLOCK(NULL, "timer2_ck", clk_timer2)
-	_REGISTER_CLOCK(NULL, "timer3_ck", clk_timer3)
-	_REGISTER_CLOCK(NULL, "vfp9_ck", clk_vfp9)
-	_REGISTER_CLOCK(NULL, "clk_dmac", clk_dma)
-	_REGISTER_CLOCK("pnx4008-watchdog", NULL, clk_wdt)
-	_REGISTER_CLOCK(NULL, "uart3_ck", clk_uart3)
-	_REGISTER_CLOCK(NULL, "uart4_ck", clk_uart4)
-	_REGISTER_CLOCK(NULL, "uart5_ck", clk_uart5)
-	_REGISTER_CLOCK(NULL, "uart6_ck", clk_uart6)
-	_REGISTER_CLOCK("pnx-i2c.0", NULL, clk_i2c0)
-	_REGISTER_CLOCK("pnx-i2c.1", NULL, clk_i2c1)
-	_REGISTER_CLOCK("pnx-i2c.2", NULL, clk_i2c2)
-	_REGISTER_CLOCK("dev:ssp0", NULL, clk_ssp0)
-	_REGISTER_CLOCK("dev:ssp1", NULL, clk_ssp1)
-	_REGISTER_CLOCK("lpc32xx_keys.0", NULL, clk_kscan)
-	_REGISTER_CLOCK("lpc32xx-nand.0", "nand_ck", clk_nand)
-	_REGISTER_CLOCK("lpc32xx-adc", NULL, clk_adc)
-	_REGISTER_CLOCK(NULL, "i2s0_ck", clk_i2s0)
-	_REGISTER_CLOCK(NULL, "i2s1_ck", clk_i2s1)
-	_REGISTER_CLOCK("ts-lpc32xx", NULL, clk_tsc)
-	_REGISTER_CLOCK("dev:mmc0", NULL, clk_mmc)
-	_REGISTER_CLOCK("lpc-eth.0", NULL, clk_net)
-	_REGISTER_CLOCK("dev:clcd", NULL, clk_lcd)
-	_REGISTER_CLOCK("lpc32xx_udc", "ck_usbd", clk_usbd)
-	_REGISTER_CLOCK("lpc32xx_rtc", NULL, clk_rtc)
+	CLKDEV_INIT(NULL, "osc_32KHz", &osc_32KHz),
+	CLKDEV_INIT(NULL, "osc_pll397", &osc_pll397),
+	CLKDEV_INIT(NULL, "osc_main", &osc_main),
+	CLKDEV_INIT(NULL, "sys_ck", &clk_sys),
+	CLKDEV_INIT(NULL, "arm_pll_ck", &clk_armpll),
+	CLKDEV_INIT(NULL, "ck_pll5", &clk_usbpll),
+	CLKDEV_INIT(NULL, "hclk_ck", &clk_hclk),
+	CLKDEV_INIT(NULL, "pclk_ck", &clk_pclk),
+	CLKDEV_INIT(NULL, "timer0_ck", &clk_timer0),
+	CLKDEV_INIT(NULL, "timer1_ck", &clk_timer1),
+	CLKDEV_INIT(NULL, "timer2_ck", &clk_timer2),
+	CLKDEV_INIT(NULL, "timer3_ck", &clk_timer3),
+	CLKDEV_INIT(NULL, "vfp9_ck", &clk_vfp9),
+	CLKDEV_INIT("pl08xdmac", NULL, &clk_dma),
+	CLKDEV_INIT("pnx4008-watchdog", NULL, &clk_wdt),
+	CLKDEV_INIT(NULL, "uart3_ck", &clk_uart3),
+	CLKDEV_INIT(NULL, "uart4_ck", &clk_uart4),
+	CLKDEV_INIT(NULL, "uart5_ck", &clk_uart5),
+	CLKDEV_INIT(NULL, "uart6_ck", &clk_uart6),
+	CLKDEV_INIT("pnx-i2c.0", NULL, &clk_i2c0),
+	CLKDEV_INIT("pnx-i2c.1", NULL, &clk_i2c1),
+	CLKDEV_INIT("pnx-i2c.2", NULL, &clk_i2c2),
+	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
+	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
+	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
+	CLKDEV_INIT("lpc32xx-nand.0", "nand_ck", &clk_nand),
+	CLKDEV_INIT("lpc32xx-adc", NULL, &clk_adc),
+	CLKDEV_INIT(NULL, "i2s0_ck", &clk_i2s0),
+	CLKDEV_INIT(NULL, "i2s1_ck", &clk_i2s1),
+	CLKDEV_INIT("ts-lpc32xx", NULL, &clk_tsc),
+	CLKDEV_INIT("dev:mmc0", NULL, &clk_mmc),
+	CLKDEV_INIT("lpc-eth.0", NULL, &clk_net),
+	CLKDEV_INIT("dev:clcd", NULL, &clk_lcd),
+	CLKDEV_INIT("lpc32xx_udc", "ck_usbd", &clk_usbd),
+	CLKDEV_INIT("lpc32xx_rtc", NULL, &clk_rtc),
 };
 
 static int __init clk_init(void)
--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.c
+++ linux-2.6/arch/arm/mach-lpc32xx/common.c
@@ -32,198 +32,6 @@
 #include "common.h"
 
 /*
- * Watchdog timer
- */
-static struct resource watchdog_resources[] = {
-	[0] = {
-		.start = LPC32XX_WDTIM_BASE,
-		.end = LPC32XX_WDTIM_BASE + SZ_4K - 1,
-		.flags = IORESOURCE_MEM,
-	},
-};
-
-struct platform_device lpc32xx_watchdog_device = {
-	.name = "pnx4008-watchdog",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(watchdog_resources),
-	.resource = watchdog_resources,
-};
-
-/*
- * I2C busses
- */
-static struct resource i2c0_resources[] = {
-	[0] = {
-		.start = LPC32XX_I2C1_BASE,
-		.end = LPC32XX_I2C1_BASE + 0x100 - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_LPC32XX_I2C_1,
-		.end = IRQ_LPC32XX_I2C_1,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct resource i2c1_resources[] = {
-	[0] = {
-		.start = LPC32XX_I2C2_BASE,
-		.end = LPC32XX_I2C2_BASE + 0x100 - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_LPC32XX_I2C_2,
-		.end = IRQ_LPC32XX_I2C_2,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct resource i2c2_resources[] = {
-	[0] = {
-		.start = LPC32XX_OTG_I2C_BASE,
-		.end = LPC32XX_OTG_I2C_BASE + 0x100 - 1,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_LPC32XX_USB_I2C,
-		.end = IRQ_LPC32XX_USB_I2C,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device lpc32xx_i2c0_device = {
-	.name = "pnx-i2c",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(i2c0_resources),
-	.resource = i2c0_resources,
-};
-
-struct platform_device lpc32xx_i2c1_device = {
-	.name = "pnx-i2c",
-	.id = 1,
-	.num_resources = ARRAY_SIZE(i2c1_resources),
-	.resource = i2c1_resources,
-};
-
-struct platform_device lpc32xx_i2c2_device = {
-	.name = "pnx-i2c",
-	.id = 2,
-	.num_resources = ARRAY_SIZE(i2c2_resources),
-	.resource = i2c2_resources,
-};
-
-/* TSC (Touch Screen Controller) */
-
-static struct resource lpc32xx_tsc_resources[] = {
-	{
-		.start = LPC32XX_ADC_BASE,
-		.end = LPC32XX_ADC_BASE + SZ_4K - 1,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_LPC32XX_TS_IRQ,
-		.end = IRQ_LPC32XX_TS_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device lpc32xx_tsc_device = {
-	.name =  "ts-lpc32xx",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(lpc32xx_tsc_resources),
-	.resource = lpc32xx_tsc_resources,
-};
-
-/* RTC */
-
-static struct resource lpc32xx_rtc_resources[] = {
-	{
-		.start = LPC32XX_RTC_BASE,
-		.end = LPC32XX_RTC_BASE + SZ_4K - 1,
-		.flags = IORESOURCE_MEM,
-	},{
-		.start = IRQ_LPC32XX_RTC,
-		.end = IRQ_LPC32XX_RTC,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device lpc32xx_rtc_device = {
-	.name =  "rtc-lpc32xx",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(lpc32xx_rtc_resources),
-	.resource = lpc32xx_rtc_resources,
-};
-
-/*
- * ADC support
- */
-static struct resource adc_resources[] = {
-	{
-		.start = LPC32XX_ADC_BASE,
-		.end = LPC32XX_ADC_BASE + SZ_4K - 1,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_LPC32XX_TS_IRQ,
-		.end = IRQ_LPC32XX_TS_IRQ,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device lpc32xx_adc_device = {
-	.name =  "lpc32xx-adc",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(adc_resources),
-	.resource = adc_resources,
-};
-
-/*
- * USB support
- */
-/* The dmamask must be set for OHCI to work */
-static u64 ohci_dmamask = ~(u32) 0;
-static struct resource ohci_resources[] = {
-	{
-		.start = IO_ADDRESS(LPC32XX_USB_BASE),
-		.end = IO_ADDRESS(LPC32XX_USB_BASE + 0x100 - 1),
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_LPC32XX_USB_HOST,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-struct platform_device lpc32xx_ohci_device = {
-	.name = "usb-ohci",
-	.id = -1,
-	.dev = {
-		.dma_mask = &ohci_dmamask,
-		.coherent_dma_mask = 0xFFFFFFFF,
-	},
-	.num_resources = ARRAY_SIZE(ohci_resources),
-	.resource = ohci_resources,
-};
-
-/*
- * Network Support
- */
-static struct resource net_resources[] = {
-	[0] = DEFINE_RES_MEM(LPC32XX_ETHERNET_BASE, SZ_4K),
-	[1] = DEFINE_RES_MEM(LPC32XX_IRAM_BASE, SZ_128K),
-	[2] = DEFINE_RES_IRQ(IRQ_LPC32XX_ETHERNET),
-};
-
-static u64 lpc32xx_mac_dma_mask = 0xffffffffUL;
-struct platform_device lpc32xx_net_device = {
-	.name = "lpc-eth",
-	.id = 0,
-	.dev = {
-		.dma_mask = &lpc32xx_mac_dma_mask,
-		.coherent_dma_mask = 0xffffffffUL,
-	},
-	.num_resources = ARRAY_SIZE(net_resources),
-	.resource = net_resources,
-};
-
-/*
  * Returns the unique ID for the device
  */
 void lpc32xx_get_uid(u32 devid[4])
--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.h
+++ linux-2.6/arch/arm/mach-lpc32xx/common.h
@@ -23,26 +23,12 @@
 #include <linux/platform_device.h>
 
 /*
- * Arch specific platform device structures
- */
-extern struct platform_device lpc32xx_watchdog_device;
-extern struct platform_device lpc32xx_i2c0_device;
-extern struct platform_device lpc32xx_i2c1_device;
-extern struct platform_device lpc32xx_i2c2_device;
-extern struct platform_device lpc32xx_tsc_device;
-extern struct platform_device lpc32xx_adc_device;
-extern struct platform_device lpc32xx_rtc_device;
-extern struct platform_device lpc32xx_ohci_device;
-extern struct platform_device lpc32xx_net_device;
-
-/*
  * Other arch specific structures and functions
  */
 extern struct sys_timer lpc32xx_timer;
 extern void __init lpc32xx_init_irq(void);
 extern void __init lpc32xx_map_io(void);
 extern void __init lpc32xx_serial_init(void);
-extern void __init lpc32xx_gpio_init(void);
 extern void lpc23xx_restart(char, const char *);
 
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/irq.c
+++ linux-2.6/arch/arm/mach-lpc32xx/irq.c
@@ -22,6 +22,11 @@
 #include <linux/irq.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
 
 #include <mach/irqs.h>
 #include <mach/hardware.h>
@@ -44,6 +49,9 @@
 #define SIC1_ATR_DEFAULT	0x00026000
 #define SIC2_ATR_DEFAULT	0x00000000
 
+static struct irq_domain *lpc32xx_mic_domain;
+static struct device_node *lpc32xx_mic_np;
+
 struct lpc32xx_event_group_regs {
 	void __iomem *enab_reg;
 	void __iomem *edge_reg;
@@ -203,7 +211,7 @@ static void lpc32xx_mask_irq(struct irq_
 {
 	unsigned int reg, ctrl, mask;
 
-	get_controller(d->irq, &ctrl, &mask);
+	get_controller(d->hwirq, &ctrl, &mask);
 
 	reg = __raw_readl(LPC32XX_INTC_MASK(ctrl)) & ~mask;
 	__raw_writel(reg, LPC32XX_INTC_MASK(ctrl));
@@ -213,7 +221,7 @@ static void lpc32xx_unmask_irq(struct ir
 {
 	unsigned int reg, ctrl, mask;
 
-	get_controller(d->irq, &ctrl, &mask);
+	get_controller(d->hwirq, &ctrl, &mask);
 
 	reg = __raw_readl(LPC32XX_INTC_MASK(ctrl)) | mask;
 	__raw_writel(reg, LPC32XX_INTC_MASK(ctrl));
@@ -223,14 +231,14 @@ static void lpc32xx_ack_irq(struct irq_d
 {
 	unsigned int ctrl, mask;
 
-	get_controller(d->irq, &ctrl, &mask);
+	get_controller(d->hwirq, &ctrl, &mask);
 
 	__raw_writel(mask, LPC32XX_INTC_RAW_STAT(ctrl));
 
 	/* Also need to clear pending wake event */
-	if (lpc32xx_events[d->irq].mask != 0)
-		__raw_writel(lpc32xx_events[d->irq].mask,
-			lpc32xx_events[d->irq].event_group->rawstat_reg);
+	if (lpc32xx_events[d->hwirq].mask != 0)
+		__raw_writel(lpc32xx_events[d->hwirq].mask,
+			lpc32xx_events[d->hwirq].event_group->rawstat_reg);
 }
 
 static void __lpc32xx_set_irq_type(unsigned int irq, int use_high_level,
@@ -274,22 +282,22 @@ static int lpc32xx_set_irq_type(struct i
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
 		/* Rising edge sensitive */
-		__lpc32xx_set_irq_type(d->irq, 1, 1);
+		__lpc32xx_set_irq_type(d->hwirq, 1, 1);
 		break;
 
 	case IRQ_TYPE_EDGE_FALLING:
 		/* Falling edge sensitive */
-		__lpc32xx_set_irq_type(d->irq, 0, 1);
+		__lpc32xx_set_irq_type(d->hwirq, 0, 1);
 		break;
 
 	case IRQ_TYPE_LEVEL_LOW:
 		/* Low level sensitive */
-		__lpc32xx_set_irq_type(d->irq, 0, 0);
+		__lpc32xx_set_irq_type(d->hwirq, 0, 0);
 		break;
 
 	case IRQ_TYPE_LEVEL_HIGH:
 		/* High level sensitive */
-		__lpc32xx_set_irq_type(d->irq, 1, 0);
+		__lpc32xx_set_irq_type(d->hwirq, 1, 0);
 		break;
 
 	/* Other modes are not supported */
@@ -298,7 +306,7 @@ static int lpc32xx_set_irq_type(struct i
 	}
 
 	/* Ok to use the level handler for all types */
-	irq_set_handler(d->irq, handle_level_irq);
+	irq_set_handler(d->hwirq, handle_level_irq);
 
 	return 0;
 }
@@ -307,33 +315,33 @@ static int lpc32xx_irq_wake(struct irq_d
 {
 	unsigned long eventreg;
 
-	if (lpc32xx_events[d->irq].mask != 0) {
-		eventreg = __raw_readl(lpc32xx_events[d->irq].
+	if (lpc32xx_events[d->hwirq].mask != 0) {
+		eventreg = __raw_readl(lpc32xx_events[d->hwirq].
 			event_group->enab_reg);
 
 		if (state)
-			eventreg |= lpc32xx_events[d->irq].mask;
+			eventreg |= lpc32xx_events[d->hwirq].mask;
 		else {
-			eventreg &= ~lpc32xx_events[d->irq].mask;
+			eventreg &= ~lpc32xx_events[d->hwirq].mask;
 
 			/*
 			 * When disabling the wakeup, clear the latched
 			 * event
 			 */
-			__raw_writel(lpc32xx_events[d->irq].mask,
-				lpc32xx_events[d->irq].
+			__raw_writel(lpc32xx_events[d->hwirq].mask,
+				lpc32xx_events[d->hwirq].
 				event_group->rawstat_reg);
 		}
 
 		__raw_writel(eventreg,
-			lpc32xx_events[d->irq].event_group->enab_reg);
+			lpc32xx_events[d->hwirq].event_group->enab_reg);
 
 		return 0;
 	}
 
 	/* Clear event */
-	__raw_writel(lpc32xx_events[d->irq].mask,
-		lpc32xx_events[d->irq].event_group->rawstat_reg);
+	__raw_writel(lpc32xx_events[d->hwirq].mask,
+		lpc32xx_events[d->hwirq].event_group->rawstat_reg);
 
 	return -ENODEV;
 }
@@ -353,6 +361,7 @@ static void __init lpc32xx_set_default_m
 }
 
 static struct irq_chip lpc32xx_irq_chip = {
+	.name = "MIC",
 	.irq_ack = lpc32xx_ack_irq,
 	.irq_mask = lpc32xx_mask_irq,
 	.irq_unmask = lpc32xx_unmask_irq,
@@ -386,9 +395,23 @@ static void lpc32xx_sic2_handler(unsigne
 	}
 }
 
+static int __init __lpc32xx_mic_of_init(struct device_node *node,
+					struct device_node *parent)
+{
+	lpc32xx_mic_np = node;
+
+	return 0;
+}
+
+static const struct of_device_id mic_of_match[] __initconst = {
+	{ .compatible = "nxp,lpc32xx-mic", .data = __lpc32xx_mic_of_init },
+	{ }
+};
+
 void __init lpc32xx_init_irq(void)
 {
 	unsigned int i;
+	int irq_base;
 
 	/* Setup MIC */
 	__raw_writel(0, LPC32XX_INTC_MASK(LPC32XX_MIC_BASE));
@@ -448,4 +471,19 @@ void __init lpc32xx_init_irq(void)
 		LPC32XX_CLKPWR_PIN_RS);
 	__raw_writel(__raw_readl(LPC32XX_CLKPWR_INT_RS),
 		LPC32XX_CLKPWR_INT_RS);
+
+	of_irq_init(mic_of_match);
+
+	irq_base = irq_alloc_descs(-1, 0, NR_IRQS, 0);
+	if (irq_base < 0) {
+		pr_warn("Cannot allocate irq_descs, assuming pre-allocated\n");
+		irq_base = 0;
+	}
+
+	lpc32xx_mic_domain = irq_domain_add_legacy(lpc32xx_mic_np, NR_IRQS,
+						   irq_base, 0,
+						   &irq_domain_simple_ops,
+						   NULL);
+	if (!lpc32xx_mic_domain)
+		panic("Unable to add MIC irq domain\n");
 }
--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -1,8 +1,9 @@
 /*
- * arch/arm/mach-lpc32xx/phy3250.c
+ * Platform support for LPC32xx SoC
  *
  * Author: Kevin Wells <kevin.wells@nxp.com>
  *
+ * Copyright (C) 2012 Roland Stigge <stigge@antcom.de>
  * Copyright (C) 2010 NXP Semiconductors
  *
  * This program is free software; you can redistribute it and/or modify
@@ -25,11 +26,16 @@
 #include <linux/device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
-#include <linux/leds.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/clcd.h>
 #include <linux/amba/pl022.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/clk.h>
+#include <linux/amba/pl08x.h>
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
@@ -47,7 +53,6 @@
 #define SPI0_CS_GPIO	LPC32XX_GPIO(LPC32XX_GPIO_P3_GRP, 5)
 #define LCD_POWER_GPIO	LPC32XX_GPIO(LPC32XX_GPO_P3_GRP, 0)
 #define BKL_POWER_GPIO	LPC32XX_GPIO(LPC32XX_GPO_P3_GRP, 4)
-#define LED_GPIO	LPC32XX_GPIO(LPC32XX_GPO_P3_GRP, 1)
 
 /*
  * AMBA LCD controller
@@ -150,9 +155,6 @@ static struct clcd_board lpc32xx_clcd_da
 	.remove		= lpc32xx_clcd_remove,
 };
 
-static AMBA_AHB_DEVICE(lpc32xx_clcd, "dev:clcd", 0,
-	LPC32XX_LCD_BASE, { IRQ_LPC32XX_LCD }, &lpc32xx_clcd_data);
-
 /*
  * AMBA SSP (SPI)
  */
@@ -180,8 +182,11 @@ static struct pl022_ssp_controller lpc32
 	.enable_dma		= 0,
 };
 
-static AMBA_APB_DEVICE(lpc32xx_ssp0, "dev:ssp0", 0,
-	LPC32XX_SSP0_BASE, { IRQ_LPC32XX_SSP0 }, &lpc32xx_ssp0_data);
+static struct pl022_ssp_controller lpc32xx_ssp1_data = {
+	.bus_id			= 1,
+	.num_chipselect		= 1,
+	.enable_dma		= 0,
+};
 
 /* AT25 driver registration */
 static int __init phy3250_spi_board_register(void)
@@ -221,73 +226,33 @@ static int __init phy3250_spi_board_regi
 }
 arch_initcall(phy3250_spi_board_register);
 
-static struct i2c_board_info __initdata phy3250_i2c_board_info[] = {
-	{
-		I2C_BOARD_INFO("pcf8563", 0x51),
-	},
-};
-
-static struct gpio_led phy_leds[] = {
-	{
-		.name			= "led0",
-		.gpio			= LED_GPIO,
-		.active_low		= 1,
-		.default_trigger	= "heartbeat",
-	},
-};
-
-static struct gpio_led_platform_data led_data = {
-	.leds = phy_leds,
-	.num_leds = ARRAY_SIZE(phy_leds),
-};
-
-static struct platform_device lpc32xx_gpio_led_device = {
-	.name			= "leds-gpio",
-	.id			= -1,
-	.dev.platform_data	= &led_data,
-};
+static struct pl08x_platform_data pl08x_pd = {
 
-static struct platform_device *phy3250_devs[] __initdata = {
-	&lpc32xx_rtc_device,
-	&lpc32xx_tsc_device,
-	&lpc32xx_i2c0_device,
-	&lpc32xx_i2c1_device,
-	&lpc32xx_i2c2_device,
-	&lpc32xx_watchdog_device,
-	&lpc32xx_gpio_led_device,
-	&lpc32xx_adc_device,
-	&lpc32xx_ohci_device,
-	&lpc32xx_net_device,
 };
 
-static struct amba_device *amba_devs[] __initdata = {
-	&lpc32xx_clcd_device,
-	&lpc32xx_ssp0_device,
+static const struct of_dev_auxdata lpc32xx_auxdata_lookup[] __initconst = {
+	OF_DEV_AUXDATA("nxp,lpc32xx-adc", 0x40048000, "lpc32xx-adc", NULL),
+	OF_DEV_AUXDATA("nxp,lpc32xx-tsc", 0x40048000, "ts-lpc32xx", NULL),
+	OF_DEV_AUXDATA("nxp,pnx-i2c", 0x400A0000, "pnx-i2c.0", NULL),
+	OF_DEV_AUXDATA("nxp,pnx-i2c", 0x400A8000, "pnx-i2c.1", NULL),
+	OF_DEV_AUXDATA("nxp,pnx-i2c", 0x31020300, "pnx-i2c.2", NULL),
+	OF_DEV_AUXDATA("nxp,lpc32xx-rtc", 0x40024000, "lpc32xx_rtc", NULL),
+	OF_DEV_AUXDATA("nxp,lpc-eth", 0x31060000, "lpc-eth.0", NULL),
+	OF_DEV_AUXDATA("nxp,pnx4008-wdt", 0x4003C000, "pnx4008-watchdog", NULL),
+	OF_DEV_AUXDATA("nxp,lpc32xx-gpio", 0x40028000, "lpc32xx-gpio", NULL),
+	OF_DEV_AUXDATA("nxp,ohci-nxp", 0x31020000, "usb-ohci", NULL),
+	OF_DEV_AUXDATA("nxp,lpc32xx-udc", 0x31020000, "lpc32xx_udc", NULL),
+	OF_DEV_AUXDATA("arm,pl022", 0x20084000, "dev:ssp0", &lpc32xx_ssp0_data),
+	OF_DEV_AUXDATA("arm,pl022", 0x2008C000, "dev:ssp1", &lpc32xx_ssp1_data),
+	OF_DEV_AUXDATA("arm,pl110", 0x31040000, "dev:clcd", &lpc32xx_clcd_data),
+	OF_DEV_AUXDATA("arm,pl080", 0x31000000, "pl08xdmac", &pl08x_pd),
+	OF_DEV_AUXDATA("arm,pl180", 0x20098000, "dev:mmc0", NULL),
+	{ }
 };
 
-/*
- * Board specific functions
- */
-static void __init phy3250_board_init(void)
+static void __init lpc3250_machine_init(void)
 {
 	u32 tmp;
-	int i;
-
-	lpc32xx_gpio_init();
-
-	/* Register GPIOs used on this board */
-	if (gpio_request(SPI0_CS_GPIO, "spi0 cs"))
-		printk(KERN_ERR "Error requesting gpio %u",
-			SPI0_CS_GPIO);
-	else if (gpio_direction_output(SPI0_CS_GPIO, 1))
-		printk(KERN_ERR "Error setting gpio %u to output",
-			SPI0_CS_GPIO);
-
-	/* Setup network interface for RMII mode */
-	tmp = __raw_readl(LPC32XX_CLKPWR_MACCLK_CTRL);
-	tmp &= ~LPC32XX_CLKPWR_MACCTRL_PINS_MSK;
-	tmp |= LPC32XX_CLKPWR_MACCTRL_USE_RMII_PINS;
-	__raw_writel(tmp, LPC32XX_CLKPWR_MACCLK_CTRL);
 
 	/* Setup SLC NAND controller muxing */
 	__raw_writel(LPC32XX_CLKPWR_NANDCLK_SEL_SLC,
@@ -300,6 +265,12 @@ static void __init phy3250_board_init(vo
 	tmp |= LPC32XX_CLKPWR_LCDCTRL_LCDTYPE_TFT16;
 	__raw_writel(tmp, LPC32XX_CLKPWR_LCDCLK_CTRL);
 
+	/* Set up USB power */
+	tmp = __raw_readl(LPC32XX_CLKPWR_USB_CTRL);
+	tmp |= LPC32XX_CLKPWR_USBCTRL_HCLK_EN |
+		LPC32XX_CLKPWR_USBCTRL_USBI2C_EN;
+	__raw_writel(tmp, LPC32XX_CLKPWR_USB_CTRL);
+
 	/* Set up I2C pull levels */
 	tmp = __raw_readl(LPC32XX_CLKPWR_I2C_CLK_CTRL);
 	tmp |= LPC32XX_CLKPWR_I2CCLK_USBI2CHI_DRIVE |
@@ -321,33 +292,35 @@ static void __init phy3250_board_init(vo
 	/*
 	 * AMBA peripheral clocks need to be enabled prior to AMBA device
 	 * detection or a data fault will occur, so enable the clocks
-	 * here. However, we don't want to enable them if the peripheral
-	 * isn't included in the image
+	 * here.
 	 */
-#ifdef CONFIG_FB_ARMCLCD
 	tmp = __raw_readl(LPC32XX_CLKPWR_LCDCLK_CTRL);
 	__raw_writel((tmp | LPC32XX_CLKPWR_LCDCTRL_CLK_EN),
 		LPC32XX_CLKPWR_LCDCLK_CTRL);
-#endif
-#ifdef CONFIG_SPI_PL022
+
 	tmp = __raw_readl(LPC32XX_CLKPWR_SSP_CLK_CTRL);
 	__raw_writel((tmp | LPC32XX_CLKPWR_SSPCTRL_SSPCLK0_EN),
 		LPC32XX_CLKPWR_SSP_CLK_CTRL);
-#endif
 
-	platform_add_devices(phy3250_devs, ARRAY_SIZE(phy3250_devs));
-	for (i = 0; i < ARRAY_SIZE(amba_devs); i++) {
-		struct amba_device *d = amba_devs[i];
-		amba_device_register(d, &iomem_resource);
-	}
+	tmp = __raw_readl(LPC32XX_CLKPWR_DMA_CLK_CTRL);
+	__raw_writel((tmp | LPC32XX_CLKPWR_DMACLKCTRL_CLK_EN),
+		     LPC32XX_CLKPWR_DMA_CLK_CTRL);
 
 	/* Test clock needed for UDA1380 initial init */
 	__raw_writel(LPC32XX_CLKPWR_TESTCLK2_SEL_MOSC |
 		LPC32XX_CLKPWR_TESTCLK_TESTCLK2_EN,
 		LPC32XX_CLKPWR_TEST_CLK_SEL);
 
-	i2c_register_board_info(0, phy3250_i2c_board_info,
-		ARRAY_SIZE(phy3250_i2c_board_info));
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     lpc32xx_auxdata_lookup, NULL);
+
+	/* Register GPIOs used on this board */
+	if (gpio_request(SPI0_CS_GPIO, "spi0 cs"))
+		printk(KERN_ERR "Error requesting gpio %u",
+			SPI0_CS_GPIO);
+	else if (gpio_direction_output(SPI0_CS_GPIO, 1))
+		printk(KERN_ERR "Error setting gpio %u to output",
+			SPI0_CS_GPIO);
 }
 
 static int __init lpc32xx_display_uid(void)
@@ -363,12 +336,17 @@ static int __init lpc32xx_display_uid(vo
 }
 arch_initcall(lpc32xx_display_uid);
 
-MACHINE_START(PHY3250, "Phytec 3250 board with the LPC3250 Microcontroller")
-	/* Maintainer: Kevin Wells, NXP Semiconductors */
+static char const *lpc32xx_dt_compat[] __initdata = {
+	"nxp,lpc32xx",
+	NULL
+};
+
+DT_MACHINE_START(LPC32XX_DT, "LPC32XX SoC (Flattened Device Tree)")
 	.atag_offset	= 0x100,
 	.map_io		= lpc32xx_map_io,
 	.init_irq	= lpc32xx_init_irq,
 	.timer		= &lpc32xx_timer,
-	.init_machine	= phy3250_board_init,
+	.init_machine	= lpc3250_machine_init,
+	.dt_compat	= lpc32xx_dt_compat,
 	.restart	= lpc23xx_restart,
 MACHINE_END
