Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2B0RqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:46:16 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:57917 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753685Ab2B0RqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:46:15 -0500
From: Roland Stigge <stigge@antcom.de>
To: linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        w.sang@pengutronix.de, linux-kernel@vger.kernel.org, arnd@arndb.de
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH v3] ARM: LPC32xx: Ethernet support
Date: Mon, 27 Feb 2012 18:46:02 +0100
Message-Id: <1330364762-23203-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds ethernet support to the LPC32xx ARM architecture. The actual
driver in drivers/net is contained in a separate patch.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 arch/arm/mach-lpc32xx/Kconfig              |   26 ++++++++++++++++++++++
 arch/arm/mach-lpc32xx/clock.c              |    2 -
 arch/arm/mach-lpc32xx/common.c             |   34 +++++++++++++++++++++++++++++
 arch/arm/mach-lpc32xx/common.h             |    4 +--
 arch/arm/mach-lpc32xx/include/mach/board.h |   32 +++++++++++++++++++++++++++
 arch/arm/mach-lpc32xx/irq.c                |    4 +++
 arch/arm/mach-lpc32xx/phy3250.c            |    2 +
 7 files changed, 101 insertions(+), 3 deletions(-)

--- linux-2.6.orig/arch/arm/mach-lpc32xx/Kconfig
+++ linux-2.6/arch/arm/mach-lpc32xx/Kconfig
@@ -29,5 +29,31 @@ config ARCH_LPC32XX_UART6_SELECT
 
 endmenu
 
+menu "LPC32XX chip components"
+
+config ARCH_LPC32XX_IRAM_FOR_NET
+	bool "Use IRAM for network buffers"
+	default n
+	help
+	  Say Y here to use the LPC internal fast IRAM (i.e. 256KB SRAM) as
+	  network buffer.  If the total combined required buffer sizes is
+	  larger than the size of IRAM, then SDRAM will be used instead.
+
+	  This can be enabled safely if the IRAM is not intended for other
+	  uses.
+
+config ARCH_LPC32XX_MII_SUPPORT
+	bool "Check to enable MII support or leave disabled for RMII support"
+	default n
+	help
+	  Say Y here to enable MII support, or N for RMII support. Regardless of
+	  which support is selected, the ethernet interface driver needs to be
+	  selected in the device driver networking section.
+
+	  The PHY3250 reference board uses RMII, so users of this board should
+	  say N.
+
+endmenu
+
 endif
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1134,7 +1134,7 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK(NULL, "i2s1_ck", clk_i2s1)
 	_REGISTER_CLOCK("ts-lpc32xx", NULL, clk_tsc)
 	_REGISTER_CLOCK("dev:mmc0", NULL, clk_mmc)
-	_REGISTER_CLOCK("lpc-net.0", NULL, clk_net)
+	_REGISTER_CLOCK("lpc-eth.0", NULL, clk_net)
 	_REGISTER_CLOCK("dev:clcd", NULL, clk_lcd)
 	_REGISTER_CLOCK("lpc32xx_udc", "ck_usbd", clk_usbd)
 	_REGISTER_CLOCK("lpc32xx_rtc", NULL, clk_rtc)
--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.c
+++ linux-2.6/arch/arm/mach-lpc32xx/common.c
@@ -186,6 +186,40 @@ struct platform_device lpc32xx_ohci_devi
 };
 
 /*
+ * Network Support
+ */
+static struct lpc_net_cfg lpc32xx_netdata = {
+	.phy_irq = -1,
+	.phy_mask = 0xFFFFFFF0,
+};
+
+static struct resource net_resources[] = {
+	[0] = {
+		.start = LPC32XX_ETHERNET_BASE,
+		.end = LPC32XX_ETHERNET_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_LPC32XX_ETHERNET,
+		.end = IRQ_LPC32XX_ETHERNET,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static u64 lpc32xx_mac_dma_mask = 0xffffffffUL;
+struct platform_device lpc32xx_net_device = {
+	.name = "lpc-eth",
+	.id = 0,
+	.dev = {
+		.dma_mask = &lpc32xx_mac_dma_mask,
+		.coherent_dma_mask = 0xffffffffUL,
+		.platform_data = &lpc32xx_netdata,
+	},
+	.num_resources = ARRAY_SIZE(net_resources),
+	.resource = net_resources,
+};
+
+/*
  * Returns the unique ID for the device
  */
 void lpc32xx_get_uid(u32 devid[4])
--- linux-2.6.orig/arch/arm/mach-lpc32xx/common.h
+++ linux-2.6/arch/arm/mach-lpc32xx/common.h
@@ -19,6 +19,7 @@
 #ifndef __LPC32XX_COMMON_H
 #define __LPC32XX_COMMON_H
 
+#include <mach/board.h>
 #include <linux/platform_device.h>
 
 /*
@@ -32,6 +33,7 @@ extern struct platform_device lpc32xx_ts
 extern struct platform_device lpc32xx_adc_device;
 extern struct platform_device lpc32xx_rtc_device;
 extern struct platform_device lpc32xx_ohci_device;
+extern struct platform_device lpc32xx_net_device;
 
 /*
  * Other arch specific structures and functions
@@ -67,8 +69,6 @@ extern u32 clk_get_pclk_div(void);
  */
 extern void lpc32xx_get_uid(u32 devid[4]);
 
-extern u32 lpc32xx_return_iram_size(void);
-
 /*
  * Pointers used for sizing and copying suspend function data
  */
--- /dev/null
+++ linux-2.6/arch/arm/mach-lpc32xx/include/mach/board.h
@@ -0,0 +1,32 @@
+/*
+ * arm/arch/mach-lpc32xx/include/mach/board.h
+ *
+ * Author: Kevin Wells <kevin.wells@nxp.com>
+ *
+ * Copyright (C) 2010 NXP Semiconductors
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ASM_ARCH_BOARD_H
+#define __ASM_ARCH_BOARD_H
+
+/*
+ * Network configuration structure
+ */
+struct lpc_net_cfg {
+	int	phy_irq;        /* PHY IRQ number, or -1 for polling */
+	u32	phy_mask;       /* PHY mask value */
+};
+
+extern u32 lpc32xx_return_iram_size(void);
+
+#endif  /* __ASM_ARCH_BOARD_H */
--- linux-2.6.orig/arch/arm/mach-lpc32xx/irq.c
+++ linux-2.6/arch/arm/mach-lpc32xx/irq.c
@@ -150,6 +150,10 @@ static const struct lpc32xx_event_info l
 		.event_group = &lpc32xx_event_int_regs,
 		.mask = LPC32XX_CLKPWR_INTSRC_KEY_BIT,
 	},
+	[IRQ_LPC32XX_ETHERNET] = {
+		.event_group = &lpc32xx_event_int_regs,
+		.mask = LPC32XX_CLKPWR_INTSRC_MAC_BIT,
+	},
 	[IRQ_LPC32XX_USB_OTG_ATX] = {
 		.event_group = &lpc32xx_event_int_regs,
 		.mask = LPC32XX_CLKPWR_INTSRC_USBATXINT_BIT,
--- linux-2.6.orig/arch/arm/mach-lpc32xx/phy3250.c
+++ linux-2.6/arch/arm/mach-lpc32xx/phy3250.c
@@ -37,6 +37,7 @@
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
+#include <mach/board.h>
 #include <mach/gpio-lpc32xx.h>
 #include "common.h"
 
@@ -278,6 +279,7 @@ static struct platform_device *phy3250_d
 	&lpc32xx_gpio_led_device,
 	&lpc32xx_adc_device,
 	&lpc32xx_ohci_device,
+	&lpc32xx_net_device,
 };
 
 static struct amba_device *amba_devs[] __initdata = {
