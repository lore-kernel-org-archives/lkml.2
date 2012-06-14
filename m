Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2FNQ4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:56:01 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:39399 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932129Ab2FNQvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:51:45 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 12/23] ARM: LPC32xx: DT conversion of Standard UARTs
Date: Thu, 14 Jun 2012 18:51:02 +0200
Message-Id: <1339692673-7848-13-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1339692673-7848-1-git-send-email-stigge@antcom.de>
References: <1339692673-7848-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches from static serial driver initialization to devicetree
configuration. This way, the Standard UARTs of the LPC32xx SoC can be enabled
individually via DT.

E.g., instead of Kconfig configuration, the phy3250.dts activates
UARTs 3 and 5.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Tested-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
 
---
 arch/arm/Kconfig               |    2 
 arch/arm/boot/dts/lpc32xx.dtsi |   34 ++++++++++++----
 arch/arm/boot/dts/phy3250.dts  |    8 +++
 arch/arm/mach-lpc32xx/Kconfig  |   32 ---------------
 arch/arm/mach-lpc32xx/serial.c |   85 -----------------------------------------
 5 files changed, 35 insertions(+), 126 deletions(-)

--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -1019,8 +1019,6 @@ source "arch/arm/mach-kirkwood/Kconfig"
 
 source "arch/arm/mach-ks8695/Kconfig"
 
-source "arch/arm/mach-lpc32xx/Kconfig"
-
 source "arch/arm/mach-msm/Kconfig"
 
 source "arch/arm/mach-mv78xx0/Kconfig"
--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -126,24 +126,42 @@
 				reg = <0x2009C000 0x1000>;
 			};
 
+			/* UART5 first since it is the default console, ttyS0 */
+			uart5: serial@40090000 {
+				/* actually, ns16550a w/ 64 byte fifos! */
+				compatible = "nxp,lpc3220-uart";
+				reg = <0x40090000 0x1000>;
+				interrupts = <9 0>;
+				clock-frequency = <13000000>;
+				reg-shift = <2>;
+				status = "disabled";
+			};
+
 			uart3: serial@40080000 {
-				compatible = "nxp,serial";
+				compatible = "nxp,lpc3220-uart";
 				reg = <0x40080000 0x1000>;
+				interrupts = <7 0>;
+				clock-frequency = <13000000>;
+				reg-shift = <2>;
+				status = "disabled";
 			};
 
 			uart4: serial@40088000 {
-				compatible = "nxp,serial";
+				compatible = "nxp,lpc3220-uart";
 				reg = <0x40088000 0x1000>;
-			};
-
-			uart5: serial@40090000 {
-				compatible = "nxp,serial";
-				reg = <0x40090000 0x1000>;
+				interrupts = <8 0>;
+				clock-frequency = <13000000>;
+				reg-shift = <2>;
+				status = "disabled";
 			};
 
 			uart6: serial@40098000 {
-				compatible = "nxp,serial";
+				compatible = "nxp,lpc3220-uart";
 				reg = <0x40098000 0x1000>;
+				interrupts = <10 0>;
+				clock-frequency = <13000000>;
+				reg-shift = <2>;
+				status = "disabled";
 			};
 
 			i2c1: i2c@400A0000 {
--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -94,6 +94,14 @@
 		};
 
 		apb {
+			uart5: serial@40090000 {
+				status = "okay";
+			};
+
+			uart3: serial@40080000 {
+				status = "okay";
+			};
+
 			i2c1: i2c@400A0000 {
 				clock-frequency = <100000>;
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/Kconfig
+++ /dev/null
@@ -1,32 +0,0 @@
-if ARCH_LPC32XX
-
-menu "Individual UART enable selections"
-
-config ARCH_LPC32XX_UART3_SELECT
-	bool "Add support for standard UART3"
-	help
-	 Adds support for standard UART 3 when the 8250 serial support
-	 is enabled.
-
-config ARCH_LPC32XX_UART4_SELECT
-	bool "Add support for standard UART4"
-	help
-	 Adds support for standard UART 4 when the 8250 serial support
-	 is enabled.
-
-config ARCH_LPC32XX_UART5_SELECT
-	bool "Add support for standard UART5"
-	default y
-	help
-	 Adds support for standard UART 5 when the 8250 serial support
-	 is enabled.
-
-config ARCH_LPC32XX_UART6_SELECT
-	bool "Add support for standard UART6"
-	help
-	 Adds support for standard UART 6 when the 8250 serial support
-	 is enabled.
-
-endmenu
-
-endif
--- linux-2.6.orig/arch/arm/mach-lpc32xx/serial.c
+++ linux-2.6/arch/arm/mach-lpc32xx/serial.c
@@ -31,59 +31,6 @@
 
 #define LPC32XX_SUART_FIFO_SIZE	64
 
-/* Standard 8250/16550 compatible serial ports */
-static struct plat_serial8250_port serial_std_platform_data[] = {
-#ifdef CONFIG_ARCH_LPC32XX_UART5_SELECT
-	{
-		.membase        = io_p2v(LPC32XX_UART5_BASE),
-		.mapbase        = LPC32XX_UART5_BASE,
-		.irq		= IRQ_LPC32XX_UART_IIR5,
-		.uartclk	= LPC32XX_MAIN_OSC_FREQ,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM32,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_BUGGY_UART |
-					UPF_SKIP_TEST,
-	},
-#endif
-#ifdef CONFIG_ARCH_LPC32XX_UART3_SELECT
-	{
-		.membase	= io_p2v(LPC32XX_UART3_BASE),
-		.mapbase        = LPC32XX_UART3_BASE,
-		.irq		= IRQ_LPC32XX_UART_IIR3,
-		.uartclk	= LPC32XX_MAIN_OSC_FREQ,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM32,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_BUGGY_UART |
-					UPF_SKIP_TEST,
-	},
-#endif
-#ifdef CONFIG_ARCH_LPC32XX_UART4_SELECT
-	{
-		.membase	= io_p2v(LPC32XX_UART4_BASE),
-		.mapbase        = LPC32XX_UART4_BASE,
-		.irq		= IRQ_LPC32XX_UART_IIR4,
-		.uartclk	= LPC32XX_MAIN_OSC_FREQ,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM32,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_BUGGY_UART |
-					UPF_SKIP_TEST,
-	},
-#endif
-#ifdef CONFIG_ARCH_LPC32XX_UART6_SELECT
-	{
-		.membase	= io_p2v(LPC32XX_UART6_BASE),
-		.mapbase        = LPC32XX_UART6_BASE,
-		.irq		= IRQ_LPC32XX_UART_IIR6,
-		.uartclk	= LPC32XX_MAIN_OSC_FREQ,
-		.regshift	= 2,
-		.iotype		= UPIO_MEM32,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_BUGGY_UART |
-					UPF_SKIP_TEST,
-	},
-#endif
-	{ },
-};
-
 struct uartinit {
 	char *uart_ck_name;
 	u32 ck_mode_mask;
@@ -92,7 +39,6 @@ struct uartinit {
 };
 
 static struct uartinit uartinit_data[] __initdata = {
-#ifdef CONFIG_ARCH_LPC32XX_UART5_SELECT
 	{
 		.uart_ck_name = "uart5_ck",
 		.ck_mode_mask =
@@ -100,8 +46,6 @@ static struct uartinit uartinit_data[] _
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART5_CLK_CTRL,
 		.mapbase = LPC32XX_UART5_BASE,
 	},
-#endif
-#ifdef CONFIG_ARCH_LPC32XX_UART3_SELECT
 	{
 		.uart_ck_name = "uart3_ck",
 		.ck_mode_mask =
@@ -109,8 +53,6 @@ static struct uartinit uartinit_data[] _
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART3_CLK_CTRL,
 		.mapbase = LPC32XX_UART3_BASE,
 	},
-#endif
-#ifdef CONFIG_ARCH_LPC32XX_UART4_SELECT
 	{
 		.uart_ck_name = "uart4_ck",
 		.ck_mode_mask =
@@ -118,8 +60,6 @@ static struct uartinit uartinit_data[] _
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART4_CLK_CTRL,
 		.mapbase = LPC32XX_UART4_BASE,
 	},
-#endif
-#ifdef CONFIG_ARCH_LPC32XX_UART6_SELECT
 	{
 		.uart_ck_name = "uart6_ck",
 		.ck_mode_mask =
@@ -127,19 +67,6 @@ static struct uartinit uartinit_data[] _
 		.pdiv_clk_reg = LPC32XX_CLKPWR_UART6_CLK_CTRL,
 		.mapbase = LPC32XX_UART6_BASE,
 	},
-#endif
-};
-
-static struct platform_device serial_std_platform_device = {
-	.name			= "serial8250",
-	.id			= 0,
-	.dev			= {
-		.platform_data	= serial_std_platform_data,
-	},
-};
-
-static struct platform_device *lpc32xx_serial_devs[] __initdata = {
-	&serial_std_platform_device,
 };
 
 void __init lpc32xx_serial_init(void)
@@ -156,15 +83,8 @@ void __init lpc32xx_serial_init(void)
 		clk = clk_get(NULL, uartinit_data[i].uart_ck_name);
 		if (!IS_ERR(clk)) {
 			clk_enable(clk);
-			serial_std_platform_data[i].uartclk =
-				clk_get_rate(clk);
 		}
 
-		/* Fall back on main osc rate if clock rate return fails */
-		if (serial_std_platform_data[i].uartclk == 0)
-			serial_std_platform_data[i].uartclk =
-				LPC32XX_MAIN_OSC_FREQ;
-
 		/* Setup UART clock modes for all UARTs, disable autoclock */
 		clkmodes |= uartinit_data[i].ck_mode_mask;
 
@@ -189,7 +109,7 @@ void __init lpc32xx_serial_init(void)
 	__raw_writel(clkmodes, LPC32XX_UARTCTL_CLKMODE);
 	for (i = 0; i < ARRAY_SIZE(uartinit_data); i++) {
 		/* Force a flush of the RX FIFOs to work around a HW bug */
-		puart = serial_std_platform_data[i].mapbase;
+		puart = uartinit_data[i].mapbase;
 		__raw_writel(0xC1, LPC32XX_UART_IIR_FCR(puart));
 		__raw_writel(0x00, LPC32XX_UART_DLL_FIFO(puart));
 		j = LPC32XX_SUART_FIFO_SIZE;
@@ -202,7 +122,4 @@ void __init lpc32xx_serial_init(void)
 	tmp = __raw_readl(LPC32XX_UARTCTL_CTRL);
 	tmp &= ~LPC32XX_UART_U5_ROUTE_TO_USB;
 	__raw_writel(tmp, LPC32XX_UARTCTL_CTRL);
-
-	platform_add_devices(lpc32xx_serial_devs,
-		ARRAY_SIZE(lpc32xx_serial_devs));
 }
