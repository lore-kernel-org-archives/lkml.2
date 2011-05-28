Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab1E1PCb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:02:31 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:43229 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab1E1PC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:02:27 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, arnd@arndb.de, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 2/2] ARM: mxs: use gpio-mxs driver by adding platform device
Date: Sat, 28 May 2011 23:09:34 +0800
Message-Id: <1306595374-25178-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
References: <1306595374-25178-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It replaces mach-mxs/gpio with gpio-mxs driver by adding platform
device for drivers/gpio/gpio-mxs, and then remove the mach-mxs/gpio
driver.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 arch/arm/mach-mxs/Makefile                      |    2 +-
 arch/arm/mach-mxs/devices.c                     |   11 +
 arch/arm/mach-mxs/devices/Makefile              |    1 +
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c   |   53 ++++
 arch/arm/mach-mxs/gpio.c                        |  331 -----------------------
 arch/arm/mach-mxs/gpio.h                        |   34 ---
 arch/arm/mach-mxs/include/mach/devices-common.h |    2 +
 arch/arm/mach-mxs/mach-mx28evk.c                |    1 -
 arch/arm/mach-mxs/mm-mx23.c                     |    1 -
 arch/arm/mach-mxs/mm-mx28.c                     |    1 -
 10 files changed, 68 insertions(+), 369 deletions(-)
 create mode 100644 arch/arm/mach-mxs/devices/platform-gpio-mxs.c
 delete mode 100644 arch/arm/mach-mxs/gpio.c
 delete mode 100644 arch/arm/mach-mxs/gpio.h

diff --git a/arch/arm/mach-mxs/Makefile b/arch/arm/mach-mxs/Makefile
index 58e8923..6c38262 100644
--- a/arch/arm/mach-mxs/Makefile
+++ b/arch/arm/mach-mxs/Makefile
@@ -1,5 +1,5 @@
 # Common support
-obj-y := clock.o devices.o gpio.o icoll.o iomux.o system.o timer.o
+obj-y := clock.o devices.o icoll.o iomux.o system.o timer.o
 
 obj-$(CONFIG_MXS_OCOTP) += ocotp.o
 obj-$(CONFIG_PM) += pm.o
diff --git a/arch/arm/mach-mxs/devices.c b/arch/arm/mach-mxs/devices.c
index cfdb6b2..fe3e847 100644
--- a/arch/arm/mach-mxs/devices.c
+++ b/arch/arm/mach-mxs/devices.c
@@ -88,3 +88,14 @@ int __init mxs_add_amba_device(const struct amba_device *dev)
 
 	return amba_device_register(adev, &iomem_resource);
 }
+
+struct device mxs_apbh_bus = {
+	.init_name	= "mxs_apbh",
+	.parent         = &platform_bus,
+};
+
+static int __init mxs_device_init(void)
+{
+	return device_register(&mxs_apbh_bus);
+}
+core_initcall(mxs_device_init);
diff --git a/arch/arm/mach-mxs/devices/Makefile b/arch/arm/mach-mxs/devices/Makefile
index 324f282..351915c 100644
--- a/arch/arm/mach-mxs/devices/Makefile
+++ b/arch/arm/mach-mxs/devices/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_MXS_HAVE_PLATFORM_FLEXCAN) += platform-flexcan.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_I2C) += platform-mxs-i2c.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_MMC) += platform-mxs-mmc.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXS_PWM) += platform-mxs-pwm.o
+obj-y += platform-gpio-mxs.o
 obj-$(CONFIG_MXS_HAVE_PLATFORM_MXSFB) += platform-mxsfb.o
diff --git a/arch/arm/mach-mxs/devices/platform-gpio-mxs.c b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
new file mode 100644
index 0000000..ed0885e
--- /dev/null
+++ b/arch/arm/mach-mxs/devices/platform-gpio-mxs.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/init.h>
+
+#include <mach/mx23.h>
+#include <mach/mx28.h>
+#include <mach/devices-common.h>
+
+struct platform_device *__init mxs_add_gpio(
+	int id, resource_size_t iobase, int irq)
+{
+	struct resource res[] = {
+		{
+			.start = iobase,
+			.end = iobase + SZ_8K - 1,
+			.flags = IORESOURCE_MEM,
+		}, {
+			.start = irq,
+			.end = irq,
+			.flags = IORESOURCE_IRQ,
+		},
+	};
+
+	return platform_device_register_resndata(&mxs_apbh_bus,
+			"gpio-mxs", id, res, ARRAY_SIZE(res), NULL, 0);
+}
+
+static int __init mxs_add_mxs_gpio(void)
+{
+	if (cpu_is_mx23()) {
+		mxs_add_gpio(0, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO0);
+		mxs_add_gpio(1, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO1);
+		mxs_add_gpio(2, MX23_PINCTRL_BASE_ADDR, MX23_INT_GPIO2);
+	}
+
+	if (cpu_is_mx28()) {
+		mxs_add_gpio(0, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO0);
+		mxs_add_gpio(1, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO1);
+		mxs_add_gpio(2, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO2);
+		mxs_add_gpio(3, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO3);
+		mxs_add_gpio(4, MX28_PINCTRL_BASE_ADDR, MX28_INT_GPIO4);
+	}
+
+	return 0;
+}
+postcore_initcall(mxs_add_mxs_gpio);
diff --git a/arch/arm/mach-mxs/gpio.c b/arch/arm/mach-mxs/gpio.c
deleted file mode 100644
index 2c950fe..0000000
--- a/arch/arm/mach-mxs/gpio.c
+++ /dev/null
@@ -1,331 +0,0 @@
-/*
- * MXC GPIO support. (c) 2008 Daniel Mack <daniel@caiaq.de>
- * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
- *
- * Based on code from Freescale,
- * Copyright (C) 2004-2010 Freescale Semiconductor, Inc. All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA  02110-1301, USA.
- */
-
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/gpio.h>
-#include <mach/mx23.h>
-#include <mach/mx28.h>
-#include <asm-generic/bug.h>
-
-#include "gpio.h"
-
-static struct mxs_gpio_port *mxs_gpio_ports;
-static int gpio_table_size;
-
-#define PINCTRL_DOUT(n)		((cpu_is_mx23() ? 0x0500 : 0x0700) + (n) * 0x10)
-#define PINCTRL_DIN(n)		((cpu_is_mx23() ? 0x0600 : 0x0900) + (n) * 0x10)
-#define PINCTRL_DOE(n)		((cpu_is_mx23() ? 0x0700 : 0x0b00) + (n) * 0x10)
-#define PINCTRL_PIN2IRQ(n)	((cpu_is_mx23() ? 0x0800 : 0x1000) + (n) * 0x10)
-#define PINCTRL_IRQEN(n)	((cpu_is_mx23() ? 0x0900 : 0x1100) + (n) * 0x10)
-#define PINCTRL_IRQLEV(n)	((cpu_is_mx23() ? 0x0a00 : 0x1200) + (n) * 0x10)
-#define PINCTRL_IRQPOL(n)	((cpu_is_mx23() ? 0x0b00 : 0x1300) + (n) * 0x10)
-#define PINCTRL_IRQSTAT(n)	((cpu_is_mx23() ? 0x0c00 : 0x1400) + (n) * 0x10)
-
-#define GPIO_INT_FALL_EDGE	0x0
-#define GPIO_INT_LOW_LEV	0x1
-#define GPIO_INT_RISE_EDGE	0x2
-#define GPIO_INT_HIGH_LEV	0x3
-#define GPIO_INT_LEV_MASK	(1 << 0)
-#define GPIO_INT_POL_MASK	(1 << 1)
-
-/* Note: This driver assumes 32 GPIOs are handled in one register */
-
-static void clear_gpio_irqstatus(struct mxs_gpio_port *port, u32 index)
-{
-	__mxs_clrl(1 << index, port->base + PINCTRL_IRQSTAT(port->id));
-}
-
-static void set_gpio_irqenable(struct mxs_gpio_port *port, u32 index,
-				int enable)
-{
-	if (enable) {
-		__mxs_setl(1 << index, port->base + PINCTRL_IRQEN(port->id));
-		__mxs_setl(1 << index, port->base + PINCTRL_PIN2IRQ(port->id));
-	} else {
-		__mxs_clrl(1 << index, port->base + PINCTRL_IRQEN(port->id));
-	}
-}
-
-static void mxs_gpio_ack_irq(struct irq_data *d)
-{
-	u32 gpio = irq_to_gpio(d->irq);
-	clear_gpio_irqstatus(&mxs_gpio_ports[gpio / 32], gpio & 0x1f);
-}
-
-static void mxs_gpio_mask_irq(struct irq_data *d)
-{
-	u32 gpio = irq_to_gpio(d->irq);
-	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 0);
-}
-
-static void mxs_gpio_unmask_irq(struct irq_data *d)
-{
-	u32 gpio = irq_to_gpio(d->irq);
-	set_gpio_irqenable(&mxs_gpio_ports[gpio / 32], gpio & 0x1f, 1);
-}
-
-static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset);
-
-static int mxs_gpio_set_irq_type(struct irq_data *d, unsigned int type)
-{
-	u32 gpio = irq_to_gpio(d->irq);
-	u32 pin_mask = 1 << (gpio & 31);
-	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
-	void __iomem *pin_addr;
-	int edge;
-
-	switch (type) {
-	case IRQ_TYPE_EDGE_RISING:
-		edge = GPIO_INT_RISE_EDGE;
-		break;
-	case IRQ_TYPE_EDGE_FALLING:
-		edge = GPIO_INT_FALL_EDGE;
-		break;
-	case IRQ_TYPE_LEVEL_LOW:
-		edge = GPIO_INT_LOW_LEV;
-		break;
-	case IRQ_TYPE_LEVEL_HIGH:
-		edge = GPIO_INT_HIGH_LEV;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	/* set level or edge */
-	pin_addr = port->base + PINCTRL_IRQLEV(port->id);
-	if (edge & GPIO_INT_LEV_MASK)
-		__mxs_setl(pin_mask, pin_addr);
-	else
-		__mxs_clrl(pin_mask, pin_addr);
-
-	/* set polarity */
-	pin_addr = port->base + PINCTRL_IRQPOL(port->id);
-	if (edge & GPIO_INT_POL_MASK)
-		__mxs_setl(pin_mask, pin_addr);
-	else
-		__mxs_clrl(pin_mask, pin_addr);
-
-	clear_gpio_irqstatus(port, gpio & 0x1f);
-
-	return 0;
-}
-
-/* MXS has one interrupt *per* gpio port */
-static void mxs_gpio_irq_handler(u32 irq, struct irq_desc *desc)
-{
-	u32 irq_stat;
-	struct mxs_gpio_port *port = (struct mxs_gpio_port *)irq_get_handler_data(irq);
-	u32 gpio_irq_no_base = port->virtual_irq_start;
-
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
-
-	irq_stat = __raw_readl(port->base + PINCTRL_IRQSTAT(port->id)) &
-			__raw_readl(port->base + PINCTRL_IRQEN(port->id));
-
-	while (irq_stat != 0) {
-		int irqoffset = fls(irq_stat) - 1;
-		generic_handle_irq(gpio_irq_no_base + irqoffset);
-		irq_stat &= ~(1 << irqoffset);
-	}
-}
-
-/*
- * Set interrupt number "irq" in the GPIO as a wake-up source.
- * While system is running, all registered GPIO interrupts need to have
- * wake-up enabled. When system is suspended, only selected GPIO interrupts
- * need to have wake-up enabled.
- * @param  irq          interrupt source number
- * @param  enable       enable as wake-up if equal to non-zero
- * @return       This function returns 0 on success.
- */
-static int mxs_gpio_set_wake_irq(struct irq_data *d, unsigned int enable)
-{
-	u32 gpio = irq_to_gpio(d->irq);
-	u32 gpio_idx = gpio & 0x1f;
-	struct mxs_gpio_port *port = &mxs_gpio_ports[gpio / 32];
-
-	if (enable) {
-		if (port->irq_high && (gpio_idx >= 16))
-			enable_irq_wake(port->irq_high);
-		else
-			enable_irq_wake(port->irq);
-	} else {
-		if (port->irq_high && (gpio_idx >= 16))
-			disable_irq_wake(port->irq_high);
-		else
-			disable_irq_wake(port->irq);
-	}
-
-	return 0;
-}
-
-static struct irq_chip gpio_irq_chip = {
-	.name = "mxs gpio",
-	.irq_ack = mxs_gpio_ack_irq,
-	.irq_mask = mxs_gpio_mask_irq,
-	.irq_unmask = mxs_gpio_unmask_irq,
-	.irq_set_type = mxs_gpio_set_irq_type,
-	.irq_set_wake = mxs_gpio_set_wake_irq,
-};
-
-static void mxs_set_gpio_direction(struct gpio_chip *chip, unsigned offset,
-				int dir)
-{
-	struct mxs_gpio_port *port =
-		container_of(chip, struct mxs_gpio_port, chip);
-	void __iomem *pin_addr = port->base + PINCTRL_DOE(port->id);
-
-	if (dir)
-		__mxs_setl(1 << offset, pin_addr);
-	else
-		__mxs_clrl(1 << offset, pin_addr);
-}
-
-static int mxs_gpio_get(struct gpio_chip *chip, unsigned offset)
-{
-	struct mxs_gpio_port *port =
-		container_of(chip, struct mxs_gpio_port, chip);
-
-	return (__raw_readl(port->base + PINCTRL_DIN(port->id)) >> offset) & 1;
-}
-
-static void mxs_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
-{
-	struct mxs_gpio_port *port =
-		container_of(chip, struct mxs_gpio_port, chip);
-	void __iomem *pin_addr = port->base + PINCTRL_DOUT(port->id);
-
-	if (value)
-		__mxs_setl(1 << offset, pin_addr);
-	else
-		__mxs_clrl(1 << offset, pin_addr);
-}
-
-static int mxs_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct mxs_gpio_port *port =
-		container_of(chip, struct mxs_gpio_port, chip);
-
-	return port->virtual_irq_start + offset;
-}
-
-static int mxs_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	mxs_set_gpio_direction(chip, offset, 0);
-	return 0;
-}
-
-static int mxs_gpio_direction_output(struct gpio_chip *chip,
-				     unsigned offset, int value)
-{
-	mxs_gpio_set(chip, offset, value);
-	mxs_set_gpio_direction(chip, offset, 1);
-	return 0;
-}
-
-int __init mxs_gpio_init(struct mxs_gpio_port *port, int cnt)
-{
-	int i, j;
-
-	/* save for local usage */
-	mxs_gpio_ports = port;
-	gpio_table_size = cnt;
-
-	pr_info("MXS GPIO hardware\n");
-
-	for (i = 0; i < cnt; i++) {
-		/* disable the interrupt and clear the status */
-		__raw_writel(0, port[i].base + PINCTRL_PIN2IRQ(i));
-		__raw_writel(0, port[i].base + PINCTRL_IRQEN(i));
-
-		/* clear address has to be used to clear IRQSTAT bits */
-		__mxs_clrl(~0U, port[i].base + PINCTRL_IRQSTAT(i));
-
-		for (j = port[i].virtual_irq_start;
-			j < port[i].virtual_irq_start + 32; j++) {
-			irq_set_chip_and_handler(j, &gpio_irq_chip,
-						 handle_level_irq);
-			set_irq_flags(j, IRQF_VALID);
-		}
-
-		/* setup one handler for each entry */
-		irq_set_chained_handler(port[i].irq, mxs_gpio_irq_handler);
-		irq_set_handler_data(port[i].irq, &port[i]);
-
-		/* register gpio chip */
-		port[i].chip.direction_input = mxs_gpio_direction_input;
-		port[i].chip.direction_output = mxs_gpio_direction_output;
-		port[i].chip.get = mxs_gpio_get;
-		port[i].chip.set = mxs_gpio_set;
-		port[i].chip.to_irq = mxs_gpio_to_irq;
-		port[i].chip.base = i * 32;
-		port[i].chip.ngpio = 32;
-
-		/* its a serious configuration bug when it fails */
-		BUG_ON(gpiochip_add(&port[i].chip) < 0);
-	}
-
-	return 0;
-}
-
-#define MX23_GPIO_BASE	MX23_IO_ADDRESS(MX23_PINCTRL_BASE_ADDR)
-#define MX28_GPIO_BASE	MX28_IO_ADDRESS(MX28_PINCTRL_BASE_ADDR)
-
-#define DEFINE_MXS_GPIO_PORT(_base, _irq, _id)				\
-	{								\
-		.chip.label = "gpio-" #_id,				\
-		.id = _id,						\
-		.irq = _irq,						\
-		.base = _base,						\
-		.virtual_irq_start = MXS_GPIO_IRQ_START + (_id) * 32,	\
-	}
-
-#ifdef CONFIG_SOC_IMX23
-static struct mxs_gpio_port mx23_gpio_ports[] = {
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO0, 0),
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO1, 1),
-	DEFINE_MXS_GPIO_PORT(MX23_GPIO_BASE, MX23_INT_GPIO2, 2),
-};
-
-int __init mx23_register_gpios(void)
-{
-	return mxs_gpio_init(mx23_gpio_ports, ARRAY_SIZE(mx23_gpio_ports));
-}
-#endif
-
-#ifdef CONFIG_SOC_IMX28
-static struct mxs_gpio_port mx28_gpio_ports[] = {
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO0, 0),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO1, 1),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO2, 2),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO3, 3),
-	DEFINE_MXS_GPIO_PORT(MX28_GPIO_BASE, MX28_INT_GPIO4, 4),
-};
-
-int __init mx28_register_gpios(void)
-{
-	return mxs_gpio_init(mx28_gpio_ports, ARRAY_SIZE(mx28_gpio_ports));
-}
-#endif
diff --git a/arch/arm/mach-mxs/gpio.h b/arch/arm/mach-mxs/gpio.h
deleted file mode 100644
index 005bb06..0000000
--- a/arch/arm/mach-mxs/gpio.h
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Copyright 2007 Freescale Semiconductor, Inc. All Rights Reserved.
- * Copyright 2008 Juergen Beisert, kernel@pengutronix.de
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
- * MA  02110-1301, USA.
- */
-
-#ifndef __MXS_GPIO_H__
-#define __MXS_GPIO_H__
-
-struct mxs_gpio_port {
-	void __iomem *base;
-	int id;
-	int irq;
-	int irq_high;
-	int virtual_irq_start;
-	struct gpio_chip chip;
-};
-
-int mxs_gpio_init(struct mxs_gpio_port*, int);
-
-#endif /* __MXS_GPIO_H__ */
diff --git a/arch/arm/mach-mxs/include/mach/devices-common.h b/arch/arm/mach-mxs/include/mach/devices-common.h
index 7a37469..812d7a8 100644
--- a/arch/arm/mach-mxs/include/mach/devices-common.h
+++ b/arch/arm/mach-mxs/include/mach/devices-common.h
@@ -11,6 +11,8 @@
 #include <linux/init.h>
 #include <linux/amba/bus.h>
 
+extern struct device mxs_apbh_bus;
+
 struct platform_device *mxs_add_platform_device_dmamask(
 		const char *name, int id,
 		const struct resource *res, unsigned int num_resources,
diff --git a/arch/arm/mach-mxs/mach-mx28evk.c b/arch/arm/mach-mxs/mach-mx28evk.c
index eacdc6b..56767a5 100644
--- a/arch/arm/mach-mxs/mach-mx28evk.c
+++ b/arch/arm/mach-mxs/mach-mx28evk.c
@@ -26,7 +26,6 @@
 #include <mach/iomux-mx28.h>
 
 #include "devices-mx28.h"
-#include "gpio.h"
 
 #define MX28EVK_FLEXCAN_SWITCH	MXS_GPIO_NR(2, 13)
 #define MX28EVK_FEC_PHY_POWER	MXS_GPIO_NR(2, 15)
diff --git a/arch/arm/mach-mxs/mm-mx23.c b/arch/arm/mach-mxs/mm-mx23.c
index 5148cd6..1b2345a 100644
--- a/arch/arm/mach-mxs/mm-mx23.c
+++ b/arch/arm/mach-mxs/mm-mx23.c
@@ -41,5 +41,4 @@ void __init mx23_map_io(void)
 void __init mx23_init_irq(void)
 {
 	icoll_init_irq();
-	mx23_register_gpios();
 }
diff --git a/arch/arm/mach-mxs/mm-mx28.c b/arch/arm/mach-mxs/mm-mx28.c
index 7e4cea3..b6e18dd 100644
--- a/arch/arm/mach-mxs/mm-mx28.c
+++ b/arch/arm/mach-mxs/mm-mx28.c
@@ -41,5 +41,4 @@ void __init mx28_map_io(void)
 void __init mx28_init_irq(void)
 {
 	icoll_init_irq();
-	mx28_register_gpios();
 }
-- 
1.7.4.1

