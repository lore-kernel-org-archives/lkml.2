Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0DNOdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:33:43 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:60105 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab0DNOdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:33:42 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch, daniel@caiaq.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       r58066@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH 2.6.34-rc4 1/1] mx5: Add registration of GPIOs for MX51 Babbage board.
Date: Wed, 14 Apr 2010 09:33:12 -0500
Message-Id: <1271255592-25446-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Update /plat-mxc/gpio.c to support Freescale's MX51 Babbage HW.
This patch applies to 2.6.34-rc4.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/devices.c |   33 +++++++++++++++++++++++++++++++--
 arch/arm/plat-mxc/gpio.c    |   25 +++++++++++++++++++------
 arch/arm/plat-mxc/tzic.c    |    4 +++-
 3 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
index d6fd396..5070ae1 100644
--- a/arch/arm/mach-mx5/devices.c
+++ b/arch/arm/mach-mx5/devices.c
@@ -1,5 +1,6 @@
 /*
  * Copyright 2009 Amit Kucheria <amit.kucheria@canonical.com>
+ * Copyright (C) 2010 Freescale Semiconductor, Inc.
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
@@ -10,8 +11,10 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/gpio.h>
 #include <mach/hardware.h>
 #include <mach/imx-uart.h>
+#include <mach/irqs.h>
 
 static struct resource uart0[] = {
 	{
@@ -89,8 +92,34 @@ struct platform_device mxc_fec_device = {
 	.resource = mxc_fec_resources,
 };
 
-/* Dummy definition to allow compiling in AVIC and TZIC simultaneously */
+static struct mxc_gpio_port mxc_gpio_ports[] = {
+	{
+		.chip.label = "gpio-0",
+		.base = MX51_IO_ADDRESS(MX51_GPIO1_BASE_ADDR),
+		.irq = MX51_MXC_INT_GPIO1_LOW,
+		.virtual_irq_start = MXC_GPIO_IRQ_START
+	},
+	{
+		.chip.label = "gpio-1",
+		.base = MX51_IO_ADDRESS(MX51_GPIO2_BASE_ADDR),
+		.irq = MX51_MXC_INT_GPIO2_LOW,
+		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 1
+	},
+	{
+		.chip.label = "gpio-2",
+		.base = MX51_IO_ADDRESS(MX51_GPIO3_BASE_ADDR),
+		.irq = MX51_MXC_INT_GPIO3_LOW,
+		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 2
+	},
+	{
+		.chip.label = "gpio-3",
+		.base = MX51_IO_ADDRESS(MX51_GPIO4_BASE_ADDR),
+		.irq = MX51_MXC_INT_GPIO4_LOW,
+		.virtual_irq_start = MXC_GPIO_IRQ_START + 32 * 3
+	},
+};
+
 int __init mxc_register_gpios(void)
 {
-	return 0;
+	return mxc_gpio_init(mxc_gpio_ports, ARRAY_SIZE(mxc_gpio_ports));
 }
diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
index 70b2389..dfdf961 100644
--- a/arch/arm/plat-mxc/gpio.c
+++ b/arch/arm/plat-mxc/gpio.c
@@ -3,7 +3,7 @@
  * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
  *
  * Based on code from Freescale,
- * Copyright 2004-2006 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -38,7 +38,6 @@ static int gpio_table_size;
 #define GPIO_ICR2	(cpu_is_mx1_mx2() ? 0x2C : 0x10)
 #define GPIO_IMR	(cpu_is_mx1_mx2() ? 0x30 : 0x14)
 #define GPIO_ISR	(cpu_is_mx1_mx2() ? 0x34 : 0x18)
-#define GPIO_ISR	(cpu_is_mx1_mx2() ? 0x34 : 0x18)
 
 #define GPIO_INT_LOW_LEV	(cpu_is_mx1_mx2() ? 0x3 : 0x0)
 #define GPIO_INT_HIGH_LEV	(cpu_is_mx1_mx2() ? 0x2 : 0x1)
@@ -171,6 +170,18 @@ static void mxc_gpio_irq_handler(struct mxc_gpio_port *port, u32 irq_stat)
 	}
 }
 
+/* one interrupt *per* gpio port */
+static void mx5_gpio_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	u32 irq_stat;
+	u32 mask = 0xFFFFFFFF;
+	struct mxc_gpio_port *port = (struct mxc_gpio_port *)get_irq_data(irq);
+
+	irq_stat = __raw_readl(port->base + GPIO_ISR) &
+			(__raw_readl(port->base + GPIO_IMR) & mask);
+	mxc_gpio_irq_handler(port, irq_stat);
+}
+
 /* MX1 and MX3 has one interrupt *per* gpio port */
 static void mx3_gpio_irq_handler(u32 irq, struct irq_desc *desc)
 {
@@ -289,11 +300,13 @@ int __init mxc_gpio_init(struct mxc_gpio_port *port, int cnt)
 		/* its a serious configuration bug when it fails */
 		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
 
-		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25()) {
-			/* setup one handler for each entry */
+		/* setup one handler for each entry */
+		if (cpu_is_mx1() || cpu_is_mx3() || cpu_is_mx25())
 			set_irq_chained_handler(port[i].irq, mx3_gpio_irq_handler);
-			set_irq_data(port[i].irq, &port[i]);
-		}
+		else if (cpu_is_mx51())
+			set_irq_chained_handler(port[i].irq, mx5_gpio_irq_handler);
+
+		set_irq_data(port[i].irq, &port[i]);
 	}
 
 	if (cpu_is_mx2()) {
diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
index afa6709..9b86d2a 100644
--- a/arch/arm/plat-mxc/tzic.c
+++ b/arch/arm/plat-mxc/tzic.c
@@ -1,5 +1,5 @@
 /*
- * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright (C)2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
@@ -19,6 +19,7 @@
 #include <asm/mach/irq.h>
 
 #include <mach/hardware.h>
+#include <mach/common.h>
 
 /*
  *****************************************
@@ -144,6 +145,7 @@ void __init tzic_init_irq(void __iomem *irqbase)
 		set_irq_handler(i, handle_level_irq);
 		set_irq_flags(i, IRQF_VALID);
 	}
+	mxc_register_gpios();
 
 	pr_info("TrustZone Interrupt Controller (TZIC) initialized\n");
 }
-- 
1.6.0.4

