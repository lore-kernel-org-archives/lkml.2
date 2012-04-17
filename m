Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2DQRLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:11:55 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:37361 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753946Ab2DQRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:09:23 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v2 8/8] ARM: LPC32xx: Device tree support
Date: Tue, 17 Apr 2012 19:08:27 +0200
Message-Id: <1334682507-15055-9-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1334682507-15055-1-git-send-email-stigge@antcom.de>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does the actual device tree switch for the LPC32xx SoC.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to v3.4-rc3

 Documentation/devicetree/bindings/arm/lpc32xx-mic.txt |   38 +++
 Documentation/devicetree/bindings/arm/lpc32xx.txt     |    8 
 arch/arm/Kconfig                                      |    1 
 arch/arm/mach-lpc32xx/Kconfig                         |   26 --
 arch/arm/mach-lpc32xx/clock.c                         |   77 +++----
 arch/arm/mach-lpc32xx/common.c                        |  192 ------------------
 arch/arm/mach-lpc32xx/common.h                        |   14 -
 arch/arm/mach-lpc32xx/irq.c                           |   78 +++++--
 arch/arm/mach-lpc32xx/phy3250.c                       |  146 +++++--------
 9 files changed, 202 insertions(+), 378 deletions(-)

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
