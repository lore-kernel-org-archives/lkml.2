Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1ETOtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:49:41 -0400
Received: from relay.pcl-ipout02.plus.net ([212.159.7.100]:35273 "EHLO
	relay.pcl-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174Ab1ETOtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:49:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoYgAIN+1k3Unw4T/2dsb2JhbACCNoJpkk6OL3eyXQKHIIkeDoYLBJRAhByGKg
Subject: [PATCH] mfd: Add ASIC3 PCMCIA/CF support
From: "Paul Parsons" <lost.distance@yahoo.com>
To: <linux-kernel@vger.kernel.org>
Cc: <sameo@linux.intel.com>, <philipp.zabel@gmail.com>, <mad_soft@inbox.ru>
Date: Fri, 20 May 2011 14:49:35 +0000
Content-Type: text/plain
Mime-Version: 1.0
X-Mailer: email v2.5.0 (Linux 2.6.39 x86_64 [http://email.cleancode.org])
Message-Id: <E1QNR1E-0003gV-IK@outmx04.plus.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PCMCIA/CF support for the HTC ASIC3. Underlying support is provided by the mfd/asic3 and pcmcia/pxa2xx-pcmcia drivers. An example configuration is provided by the pxa/hx4700 platform.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
---

Tested on an HP iPAQ hx4700 with (1) 1Gb CF memory card (CONFIG_PATA_PCMCIA), and (2) NE2000 Compatible CF Ethernet card (CONFIG_PCMCIA_PCNET).

diff -uprN clean-2.6.39/arch/arm/mach-pxa/hx4700.c linux-2.6.39/arch/arm/mach-pxa/hx4700.c
--- clean-2.6.39/arch/arm/mach-pxa/hx4700.c	2011-05-19 05:06:34.000000000 +0100
+++ linux-2.6.39/arch/arm/mach-pxa/hx4700.c	2011-05-20 15:22:52.333879329 +0100
@@ -261,7 +261,6 @@ static u16 asic3_gpio_config[] = {
 	ASIC3_GPIOC0_LED0,		/* red */
 	ASIC3_GPIOC1_LED1,		/* green */
 	ASIC3_GPIOC2_LED2,		/* blue */
-	ASIC3_GPIOC4_CF_nCD,
 	ASIC3_GPIOC5_nCIOW,
 	ASIC3_GPIOC6_nCIOR,
 	ASIC3_GPIOC7_nPCE_1,
@@ -275,6 +274,7 @@ static u16 asic3_gpio_config[] = {
 	ASIC3_GPIOC15_nPIOR,
 
 	/* GPIOD: input GPIOs, CF */
+	ASIC3_GPIOD4_CF_nCD,
 	ASIC3_GPIOD11_nCIOIS16,
 	ASIC3_GPIOD12_nCWAIT,
 	ASIC3_GPIOD15_nPIOW,
@@ -804,10 +804,15 @@ static struct i2c_board_info __initdata
  * PCMCIA
  */
 
+struct pcmcia_low_level;
+extern struct pcmcia_low_level asic3_pcmcia_low_level;
+
 static struct platform_device pcmcia = {
-	.name = "hx4700-pcmcia",
+	.name = "pxa2xx-pcmcia",
+	.id   = -1,
 	.dev  = {
 		.parent = &asic3.dev,
+		.platform_data = &asic3_pcmcia_low_level,
 	},
 };
 
diff -uprN clean-2.6.39/drivers/mfd/asic3.c linux-2.6.39/drivers/mfd/asic3.c
--- clean-2.6.39/drivers/mfd/asic3.c	2011-05-19 05:06:34.000000000 +0100
+++ linux-2.6.39/drivers/mfd/asic3.c	2011-05-20 15:22:52.333879329 +0100
@@ -102,7 +102,7 @@ static inline u32 asic3_read_register(st
 			(reg >> asic->bus_shift));
 }
 
-static void asic3_set_register(struct asic3 *asic, u32 reg, u32 bits, bool set)
+void asic3_set_register(struct asic3 *asic, u32 reg, u32 bits, bool set)
 {
 	unsigned long flags;
 	u32 val;
@@ -116,6 +116,7 @@ static void asic3_set_register(struct as
 	asic3_write_register(asic, reg, val);
 	spin_unlock_irqrestore(&asic->lock, flags);
 }
+EXPORT_SYMBOL_GPL(asic3_set_register);
 
 /* IRQs */
 #define MAX_ASIC_ISR_LOOPS    20
diff -uprN clean-2.6.39/drivers/pcmcia/Kconfig linux-2.6.39/drivers/pcmcia/Kconfig
--- clean-2.6.39/drivers/pcmcia/Kconfig	2011-05-19 05:06:34.000000000 +0100
+++ linux-2.6.39/drivers/pcmcia/Kconfig	2011-05-20 15:22:52.333879329 +0100
@@ -216,7 +216,7 @@ config PCMCIA_PXA2XX
 		    || MACH_ARMCORE || ARCH_PXA_PALM || TRIZEPS_PCMCIA \
 		    || ARCOM_PCMCIA || ARCH_PXA_ESERIES || MACH_STARGATE2 \
 		    || MACH_VPAC270 || MACH_BALLOON3 || MACH_COLIBRI \
-		    || MACH_COLIBRI320)
+		    || MACH_COLIBRI320 || MFD_ASIC3)
 	select PCMCIA_SOC_COMMON
 	help
 	  Say Y here to include support for the PXA2xx PCMCIA controller
diff -uprN clean-2.6.39/drivers/pcmcia/Makefile linux-2.6.39/drivers/pcmcia/Makefile
--- clean-2.6.39/drivers/pcmcia/Makefile	2011-05-19 05:06:34.000000000 +0100
+++ linux-2.6.39/drivers/pcmcia/Makefile	2011-05-20 15:22:52.333879329 +0100
@@ -73,6 +73,7 @@ pxa2xx-obj-$(CONFIG_MACH_VPAC270)		+= px
 pxa2xx-obj-$(CONFIG_MACH_BALLOON3)		+= pxa2xx_balloon3.o
 pxa2xx-obj-$(CONFIG_MACH_COLIBRI)		+= pxa2xx_colibri.o
 pxa2xx-obj-$(CONFIG_MACH_COLIBRI320)		+= pxa2xx_colibri.o
+pxa2xx-obj-$(CONFIG_MFD_ASIC3)			+= pxa2xx_asic3.o
 
 obj-$(CONFIG_PCMCIA_PXA2XX)			+= pxa2xx_base.o $(pxa2xx-obj-y)
 
diff -uprN clean-2.6.39/drivers/pcmcia/pxa2xx_asic3.c linux-2.6.39/drivers/pcmcia/pxa2xx_asic3.c
--- clean-2.6.39/drivers/pcmcia/pxa2xx_asic3.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.39/drivers/pcmcia/pxa2xx_asic3.c	2011-05-20 15:22:52.333879329 +0100
@@ -0,0 +1,121 @@
+/*
+ *  Copyright (C) 2011 Paul Parsons <lost.distance@yahoo.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/irq.h>
+
+#include <linux/mfd/asic3.h>
+#include <mach/hx4700.h>
+
+#include "soc_common.h"
+
+static struct gpio gpios[] = {
+	{ GPIO60_HX4700_CF_RNB,       GPIOF_DIR_IN,         "CF ready"        },
+	{ GPIO114_HX4700_CF_RESET,    GPIOF_OUT_INIT_LOW,   "CF reset"        },
+	{ GPIOD4_CF_nCD,              GPIOF_DIR_IN,         "CF card detect"  },
+	{ EGPIO4_CF_3V3_ON,           GPIOF_OUT_INIT_LOW,   "CF 3.3V enable"  },
+};
+
+static struct pcmcia_irqs irqs[] = {
+	{ 0,  IRQ_GPIO(GPIOD4_CF_nCD),              "CF card detect"  },
+};
+
+static int hw_init(struct soc_pcmcia_socket *skt)
+{
+	struct platform_device *pdev =
+		to_platform_device(skt->socket.dev.parent->parent);
+	struct asic3 *asic = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpio_request_array(gpios, ARRAY_SIZE(gpios));
+	if (ret)
+		goto out;
+
+	irq_set_irq_type(IRQ_GPIO(GPIOD4_CF_nCD), IRQ_TYPE_EDGE_BOTH);
+
+	ret = soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+	if (ret) {
+		gpio_free_array(gpios, ARRAY_SIZE(gpios));
+		goto out;
+	}
+
+	skt->socket.pci_irq = IRQ_GPIO(GPIO60_HX4700_CF_RNB);
+
+	asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
+		(ASIC3_EXTCF_CF0_BUF_EN|ASIC3_EXTCF_CF0_PWAIT_EN), 1);
+
+out:
+	return ret;
+}
+
+static void hw_shutdown(struct soc_pcmcia_socket *skt)
+{
+	struct platform_device *pdev =
+		to_platform_device(skt->socket.dev.parent->parent);
+	struct asic3 *asic = platform_get_drvdata(pdev);
+
+	asic3_set_register(asic, ASIC3_OFFSET(EXTCF, SELECT),
+		(ASIC3_EXTCF_CF0_BUF_EN|ASIC3_EXTCF_CF0_PWAIT_EN), 0);
+
+	soc_pcmcia_free_irqs(skt, irqs, ARRAY_SIZE(irqs));
+
+	gpio_free_array(gpios, ARRAY_SIZE(gpios));
+}
+
+static void socket_state(struct soc_pcmcia_socket *skt,
+	struct pcmcia_state *state)
+{
+	state->detect = (gpio_get_value(GPIOD4_CF_nCD) == 0);
+	state->ready = (gpio_get_value(GPIO60_HX4700_CF_RNB) != 0);
+	state->bvd1 = 1;
+	state->bvd2 = 1;
+	state->wrprot = 0;
+	state->vs_3v = 1;
+	state->vs_Xv = 0;
+}
+
+static int configure_socket(struct soc_pcmcia_socket *skt,
+	const socket_state_t *state)
+{
+	switch (state->Vcc)
+	{
+	case 0:
+		gpio_set_value(EGPIO4_CF_3V3_ON, 0);
+		break;
+	case 33:
+		gpio_set_value(EGPIO4_CF_3V3_ON, 1);
+		break;
+	default:
+		printk(KERN_ERR "pcmcia: Unsupported Vcc: %d\n", state->Vcc);
+		return -EINVAL;
+	}
+
+	gpio_set_value(GPIO114_HX4700_CF_RESET, (state->flags & SS_RESET) != 0);
+
+	return (0);
+}
+
+static void socket_init(struct soc_pcmcia_socket *skt)
+{
+}
+
+static void socket_suspend(struct soc_pcmcia_socket *skt)
+{
+}
+
+struct pcmcia_low_level asic3_pcmcia_low_level = {
+	.owner		= THIS_MODULE,
+	.nr		= 1,
+	.hw_init	= hw_init,
+	.hw_shutdown	= hw_shutdown,
+	.socket_state	= socket_state,
+	.configure_socket=configure_socket,
+	.socket_init	= socket_init,
+	.socket_suspend	= socket_suspend,
+};
diff -uprN clean-2.6.39/include/linux/mfd/asic3.h linux-2.6.39/include/linux/mfd/asic3.h
--- clean-2.6.39/include/linux/mfd/asic3.h	2011-05-19 05:06:34.000000000 +0100
+++ linux-2.6.39/include/linux/mfd/asic3.h	2011-05-20 15:22:52.333879329 +0100
@@ -129,6 +129,7 @@ struct asic3_platform_data {
 #define ASIC3_GPIOC13_nPWAIT		ASIC3_CONFIG_GPIO(45, 1, 1, 0)
 #define ASIC3_GPIOC14_nPIOIS16		ASIC3_CONFIG_GPIO(46, 1, 1, 0)
 #define ASIC3_GPIOC15_nPIOR		ASIC3_CONFIG_GPIO(47, 1, 0, 0)
+#define ASIC3_GPIOD4_CF_nCD		ASIC3_CONFIG_GPIO(52, 1, 0, 0)
 #define ASIC3_GPIOD11_nCIOIS16		ASIC3_CONFIG_GPIO(59, 1, 0, 0)
 #define ASIC3_GPIOD12_nCWAIT		ASIC3_CONFIG_GPIO(60, 1, 0, 0)
 #define ASIC3_GPIOD15_nPIOW		ASIC3_CONFIG_GPIO(63, 1, 0, 0)
@@ -293,4 +294,9 @@ struct asic3_platform_data {
 #define ASIC3_MAP_SIZE_32BIT	0x2000
 #define ASIC3_MAP_SIZE_16BIT	0x1000
 
+/* Functions needed by pxa2xx-pcmcia */
+
+struct asic3;
+extern void asic3_set_register(struct asic3 *asic, u32 reg, u32 bits, bool set);
+
 #endif /* __ASIC3_H__ */

