Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab1BMGl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:41:29 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:60794 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1BMGlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:41:23 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCHv2 10/11] unicore32 core architecture: interrupts ang gpio handling
Date: Sun, 13 Feb 2011 14:41:12 +0800
Message-ID: <02f501cbcb49$015b8fa0$0412aee0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLSPs9k4ZQ1320QpisT5z+wiAfZQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements interrupts and gpio handling.
UniCore32 has 9 gpio interrupt sources.
And gpio device operations are also here.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/gpio.h     |  103 ++++++++
 arch/unicore32/include/asm/irq.h      |  107 ++++++++
 arch/unicore32/include/asm/irqflags.h |   53 ++++
 arch/unicore32/kernel/gpio.c          |  122 ++++++++++
 arch/unicore32/kernel/irq.c           |  426 +++++++++++++++++++++++++++++++++
 5 files changed, 811 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/asm/gpio.h
 create mode 100644 arch/unicore32/include/asm/irq.h
 create mode 100644 arch/unicore32/include/asm/irqflags.h
 create mode 100644 arch/unicore32/kernel/gpio.c
 create mode 100644 arch/unicore32/kernel/irq.c

diff --git a/arch/unicore32/include/asm/gpio.h b/arch/unicore32/include/asm/gpio.h
new file mode 100644
index 0000000..3aaa41e
--- /dev/null
+++ b/arch/unicore32/include/asm/gpio.h
@@ -0,0 +1,103 @@
+/*
+ * linux/arch/unicore32/include/asm/gpio.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __UNICORE_GPIO_H__
+#define __UNICORE_GPIO_H__
+
+#include <asm/irq.h>
+#include <mach/hardware.h>
+#include <asm-generic/gpio.h>
+
+#define GPI_OTP_INT             0
+#define GPI_PCI_INTA            1
+#define GPI_PCI_INTB            2
+#define GPI_PCI_INTC            3
+#define GPI_PCI_INTD            4
+#define GPI_BAT_DET             5
+#define GPI_SD_CD               6
+#define GPI_SOFF_REQ            7
+#define GPI_SD_WP               8
+#define GPI_LCD_CASE_OFF        9
+#define GPO_WIFI_EN             10
+#define GPO_HDD_LED             11
+#define GPO_VGA_EN              12
+#define GPO_LCD_EN              13
+#define GPO_LED_DATA            14
+#define GPO_LED_CLK             15
+#define GPO_CAM_PWR_EN          16
+#define GPO_LCD_VCC_EN          17
+#define GPO_SOFT_OFF            18
+#define GPO_BT_EN               19
+#define GPO_FAN_ON              20
+#define GPO_SPKR                21
+#define GPO_SET_V1              23
+#define GPO_SET_V2              24
+#define GPO_CPU_HEALTH          25
+#define GPO_LAN_SEL             26
+
+#ifdef CONFIG_PUV3_NB0916
+#define GPI_BTN_TOUCH		14
+#define GPIO_IN			0x000043ff /* 1 for input */
+#define GPIO_OUT		0x0fffbc00 /* 1 for output */
+#endif	/* CONFIG_PUV3_NB0916 */
+
+#ifdef CONFIG_PUV3_SMW0919
+#define GPIO_IN			0x000003ff /* 1 for input */
+#define GPIO_OUT		0x0ffffc00 /* 1 for output */
+#endif  /* CONFIG_PUV3_SMW0919 */
+
+#ifdef CONFIG_PUV3_DB0913
+#define GPIO_IN			0x000001df /* 1 for input */
+#define GPIO_OUT		0x03fee800 /* 1 for output */
+#endif  /* CONFIG_PUV3_DB0913 */
+
+#define GPIO_DIR                (~((GPIO_IN) | 0xf0000000))
+				/* 0 input, 1 output */
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	if (__builtin_constant_p(gpio) && (gpio <= GPIO_MAX))
+		return GPIO_GPLR & GPIO_GPIO(gpio);
+	else
+		return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	if (__builtin_constant_p(gpio) && (gpio <= GPIO_MAX))
+		if (value)
+			GPIO_GPSR = GPIO_GPIO(gpio);
+		else
+			GPIO_GPCR = GPIO_GPIO(gpio);
+	else
+		__gpio_set_value(gpio, value);
+}
+
+#define gpio_cansleep	__gpio_cansleep
+
+static inline unsigned gpio_to_irq(unsigned gpio)
+{
+	if ((gpio < IRQ_GPIOHIGH) && (FIELD(1, 1, gpio) & GPIO_GPIR))
+		return IRQ_GPIOLOW0 + gpio;
+	else
+		return IRQ_GPIO0 + gpio;
+}
+
+static inline unsigned irq_to_gpio(unsigned irq)
+{
+	if (irq < IRQ_GPIOHIGH)
+		return irq - IRQ_GPIOLOW0;
+	else
+		return irq - IRQ_GPIO0;
+}
+
+#endif /* __UNICORE_GPIO_H__ */
diff --git a/arch/unicore32/include/asm/irq.h b/arch/unicore32/include/asm/irq.h
new file mode 100644
index 0000000..ade8bb8
--- /dev/null
+++ b/arch/unicore32/include/asm/irq.h
@@ -0,0 +1,107 @@
+/*
+ * linux/arch/unicore32/include/asm/irq.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_IRQ_H__
+#define __UNICORE_IRQ_H__
+
+#include <asm-generic/irq.h>
+
+#define	IRQ_GPIOLOW0		0x00
+#define	IRQ_GPIOLOW1		0x01
+#define	IRQ_GPIOLOW2		0x02
+#define	IRQ_GPIOLOW3		0x03
+#define	IRQ_GPIOLOW4		0x04
+#define	IRQ_GPIOLOW5		0x05
+#define	IRQ_GPIOLOW6		0x06
+#define	IRQ_GPIOLOW7		0x07
+#define IRQ_GPIOHIGH		0x08
+#define IRQ_USB			0x09
+#define IRQ_SDC			0x0a
+#define IRQ_AC97		0x0b
+#define IRQ_SATA		0x0c
+#define IRQ_MME			0x0d
+#define IRQ_PCI_BRIDGE		0x0e
+#define	IRQ_DDR			0x0f
+#define	IRQ_SPI			0x10
+#define	IRQ_UNIGFX		0x11
+#define	IRQ_I2C			0x11
+#define	IRQ_UART1		0x12
+#define	IRQ_UART0		0x13
+#define IRQ_UMAL		0x14
+#define IRQ_NAND		0x15
+#define IRQ_PS2_KBD		0x16
+#define IRQ_PS2_AUX		0x17
+#define IRQ_DMA			0x18
+#define IRQ_DMAERR		0x19
+#define	IRQ_TIMER0		0x1a
+#define	IRQ_TIMER1		0x1b
+#define	IRQ_TIMER2		0x1c
+#define	IRQ_TIMER3		0x1d
+#define	IRQ_RTC			0x1e
+#define	IRQ_RTCAlarm		0x1f
+
+#define	IRQ_GPIO0		0x20
+#define	IRQ_GPIO1		0x21
+#define	IRQ_GPIO2		0x22
+#define	IRQ_GPIO3		0x23
+#define	IRQ_GPIO4		0x24
+#define	IRQ_GPIO5		0x25
+#define	IRQ_GPIO6		0x26
+#define	IRQ_GPIO7		0x27
+#define IRQ_GPIO8		0x28
+#define IRQ_GPIO9		0x29
+#define IRQ_GPIO10		0x2a
+#define IRQ_GPIO11		0x2b
+#define IRQ_GPIO12		0x2c
+#define IRQ_GPIO13		0x2d
+#define IRQ_GPIO14		0x2e
+#define IRQ_GPIO15		0x2f
+#define IRQ_GPIO16		0x30
+#define IRQ_GPIO17		0x31
+#define IRQ_GPIO18		0x32
+#define IRQ_GPIO19		0x33
+#define IRQ_GPIO20		0x34
+#define IRQ_GPIO21		0x35
+#define IRQ_GPIO22		0x36
+#define IRQ_GPIO23		0x37
+#define IRQ_GPIO24		0x38
+#define IRQ_GPIO25		0x39
+#define IRQ_GPIO26		0x3a
+#define IRQ_GPIO27		0x3b
+
+#ifdef CONFIG_ARCH_FPGA
+#define IRQ_PCIINTA             IRQ_GPIOLOW2
+#define IRQ_PCIINTB             IRQ_GPIOLOW1
+#define IRQ_PCIINTC             IRQ_GPIOLOW0
+#define IRQ_PCIINTD             IRQ_GPIOLOW6
+#endif
+
+#if defined(CONFIG_PUV3_DB0913) || defined(CONFIG_PUV3_NB0916)	\
+	|| defined(CONFIG_PUV3_SMW0919)
+#define IRQ_PCIINTA             IRQ_GPIOLOW1
+#define IRQ_PCIINTB             IRQ_GPIOLOW2
+#define IRQ_PCIINTC             IRQ_GPIOLOW3
+#define IRQ_PCIINTD             IRQ_GPIOLOW4
+#endif
+
+#define IRQ_SD_CD               IRQ_GPIO6 /* falling or rising trigger */
+
+#ifndef __ASSEMBLY__
+struct irqaction;
+struct pt_regs;
+extern void migrate_irqs(void);
+
+extern void asm_do_IRQ(unsigned int, struct pt_regs *);
+
+#endif
+
+#endif
+
diff --git a/arch/unicore32/include/asm/irqflags.h b/arch/unicore32/include/asm/irqflags.h
new file mode 100644
index 0000000..6d8a28d
--- /dev/null
+++ b/arch/unicore32/include/asm/irqflags.h
@@ -0,0 +1,53 @@
+/*
+ * linux/arch/unicore32/include/asm/irqflags.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_IRQFLAGS_H__
+#define __UNICORE_IRQFLAGS_H__
+
+#ifdef __KERNEL__
+
+#include <asm/ptrace.h>
+
+#define ARCH_IRQ_DISABLED	(PRIV_MODE | PSR_I_BIT)
+#define ARCH_IRQ_ENABLED	(PRIV_MODE)
+
+/*
+ * Save the current interrupt enable state.
+ */
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long temp;
+
+	asm volatile("mov %0, asr" : "=r" (temp) : : "memory", "cc");
+
+	return temp & PSR_c;
+}
+
+/*
+ * restore saved IRQ state
+ */
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	unsigned long temp;
+
+	asm volatile(
+		"mov	%0, asr\n"
+		"mov.a	asr, %1\n"
+		"mov.f	asr, %0"
+		: "=&r" (temp)
+		: "r" (flags)
+		: "memory", "cc");
+}
+
+#include <asm-generic/irqflags.h>
+
+#endif
+#endif
diff --git a/arch/unicore32/kernel/gpio.c b/arch/unicore32/kernel/gpio.c
new file mode 100644
index 0000000..4cb2830
--- /dev/null
+++ b/arch/unicore32/kernel/gpio.c
@@ -0,0 +1,122 @@
+/*
+ * linux/arch/unicore32/kernel/gpio.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ *	Maintained by GUAN Xue-tao <gxt@mprc.pku.edu.cn>
+ *	Copyright (C) 2001-2010 Guan Xuetao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/* in FPGA, no GPIO support */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <mach/hardware.h>
+
+#ifdef CONFIG_LEDS
+#include <linux/leds.h>
+#include <linux/platform_device.h>
+
+static const struct gpio_led puv3_gpio_leds[] = {
+	{ .name = "cpuhealth", .gpio = GPO_CPU_HEALTH, .active_low = 0,
+		.default_trigger = "heartbeat",	},
+	{ .name = "hdd_led", .gpio = GPO_HDD_LED, .active_low = 1,
+		.default_trigger = "ide-disk", },
+};
+
+static const struct gpio_led_platform_data puv3_gpio_led_data = {
+	.num_leds =	ARRAY_SIZE(puv3_gpio_leds),
+	.leds =		(void *) puv3_gpio_leds,
+};
+
+static struct platform_device puv3_gpio_gpio_leds = {
+	.name =		"leds-gpio",
+	.id =		-1,
+	.dev = {
+		.platform_data = (void *) &puv3_gpio_led_data,
+	}
+};
+
+static int __init puv3_gpio_leds_init(void)
+{
+	platform_device_register(&puv3_gpio_gpio_leds);
+	return 0;
+}
+
+device_initcall(puv3_gpio_leds_init);
+#endif
+
+static int puv3_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return GPIO_GPLR & GPIO_GPIO(offset);
+}
+
+static void puv3_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (value)
+		GPIO_GPSR = GPIO_GPIO(offset);
+	else
+		GPIO_GPCR = GPIO_GPIO(offset);
+}
+
+static int puv3_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	GPIO_GPDR &= ~GPIO_GPIO(offset);
+	local_irq_restore(flags);
+	return 0;
+}
+
+static int puv3_direction_output(struct gpio_chip *chip, unsigned offset,
+		int value)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	puv3_gpio_set(chip, offset, value);
+	GPIO_GPDR |= GPIO_GPIO(offset);
+	local_irq_restore(flags);
+	return 0;
+}
+
+static struct gpio_chip puv3_gpio_chip = {
+	.label			= "gpio",
+	.direction_input	= puv3_direction_input,
+	.direction_output	= puv3_direction_output,
+	.set			= puv3_gpio_set,
+	.get			= puv3_gpio_get,
+	.base			= 0,
+	.ngpio			= GPIO_MAX + 1,
+};
+
+void __init puv3_init_gpio(void)
+{
+	GPIO_GPDR = GPIO_DIR;
+#if	defined(CONFIG_PUV3_NB0916) || defined(CONFIG_PUV3_SMW0919)	\
+	|| defined(CONFIG_PUV3_DB0913)
+	gpio_set_value(GPO_WIFI_EN, 1);
+	gpio_set_value(GPO_HDD_LED, 1);
+	gpio_set_value(GPO_VGA_EN, 1);
+	gpio_set_value(GPO_LCD_EN, 1);
+	gpio_set_value(GPO_CAM_PWR_EN, 0);
+	gpio_set_value(GPO_LCD_VCC_EN, 1);
+	gpio_set_value(GPO_SOFT_OFF, 1);
+	gpio_set_value(GPO_BT_EN, 1);
+	gpio_set_value(GPO_FAN_ON, 0);
+	gpio_set_value(GPO_SPKR, 0);
+	gpio_set_value(GPO_CPU_HEALTH, 1);
+	gpio_set_value(GPO_LAN_SEL, 1);
+/*
+ * DO NOT modify the GPO_SET_V1 and GPO_SET_V2 in kernel
+ *	gpio_set_value(GPO_SET_V1, 1);
+ *	gpio_set_value(GPO_SET_V2, 1);
+ */
+#endif
+	gpiochip_add(&puv3_gpio_chip);
+}
diff --git a/arch/unicore32/kernel/irq.c b/arch/unicore32/kernel/irq.c
new file mode 100644
index 0000000..7c211f5
--- /dev/null
+++ b/arch/unicore32/kernel/irq.c
@@ -0,0 +1,426 @@
+/*
+ * linux/arch/unicore32/kernel/irq.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
+#include <linux/signal.h>
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/random.h>
+#include <linux/smp.h>
+#include <linux/init.h>
+#include <linux/seq_file.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/kallsyms.h>
+#include <linux/proc_fs.h>
+#include <linux/sysdev.h>
+#include <linux/gpio.h>
+
+#include <asm/system.h>
+#include <mach/hardware.h>
+
+#include "setup.h"
+
+/*
+ * PKUnity GPIO edge detection for IRQs:
+ * IRQs are generated on Falling-Edge, Rising-Edge, or both.
+ * Use this instead of directly setting GRER/GFER.
+ */
+static int GPIO_IRQ_rising_edge;
+static int GPIO_IRQ_falling_edge;
+static int GPIO_IRQ_mask = 0;
+
+#define GPIO_MASK(irq)		(1 << (irq - IRQ_GPIO0))
+
+static int puv3_gpio_type(unsigned int irq, unsigned int type)
+{
+	unsigned int mask;
+
+	if (irq < IRQ_GPIOHIGH)
+		mask = 1 << irq;
+	else
+		mask = GPIO_MASK(irq);
+
+	if (type == IRQ_TYPE_PROBE) {
+		if ((GPIO_IRQ_rising_edge | GPIO_IRQ_falling_edge) & mask)
+			return 0;
+		type = IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING;
+	}
+
+	if (type & IRQ_TYPE_EDGE_RISING)
+		GPIO_IRQ_rising_edge |= mask;
+	else
+		GPIO_IRQ_rising_edge &= ~mask;
+	if (type & IRQ_TYPE_EDGE_FALLING)
+		GPIO_IRQ_falling_edge |= mask;
+	else
+		GPIO_IRQ_falling_edge &= ~mask;
+
+	GPIO_GRER = GPIO_IRQ_rising_edge & GPIO_IRQ_mask;
+	GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
+
+	return 0;
+}
+
+/*
+ * GPIO IRQs must be acknowledged.  This is for IRQs from 0 to 7.
+ */
+static void puv3_low_gpio_ack(unsigned int irq)
+{
+	GPIO_GEDR = (1 << irq);
+}
+
+static void puv3_low_gpio_mask(unsigned int irq)
+{
+	INTC_ICMR &= ~(1 << irq);
+}
+
+static void puv3_low_gpio_unmask(unsigned int irq)
+{
+	INTC_ICMR |= 1 << irq;
+}
+
+static int puv3_low_gpio_wake(unsigned int irq, unsigned int on)
+{
+	if (on)
+		PM_PWER |= 1 << irq;
+	else
+		PM_PWER &= ~(1 << irq);
+	return 0;
+}
+
+static struct irq_chip puv3_low_gpio_chip = {
+	.name		= "GPIO-low",
+	.ack		= puv3_low_gpio_ack,
+	.mask		= puv3_low_gpio_mask,
+	.unmask		= puv3_low_gpio_unmask,
+	.set_type	= puv3_gpio_type,
+	.set_wake	= puv3_low_gpio_wake,
+};
+
+/*
+ * IRQ8 (GPIO0 through 27) handler.  We enter here with the
+ * irq_controller_lock held, and IRQs disabled.  Decode the IRQ
+ * and call the handler.
+ */
+static void
+puv3_gpio_handler(unsigned int irq, struct irq_desc *desc)
+{
+	unsigned int mask;
+
+	mask = GPIO_GEDR;
+	do {
+		/*
+		 * clear down all currently active IRQ sources.
+		 * We will be processing them all.
+		 */
+		GPIO_GEDR = mask;
+
+		irq = IRQ_GPIO0;
+		do {
+			if (mask & 1)
+				generic_handle_irq(irq);
+			mask >>= 1;
+			irq++;
+		} while (mask);
+		mask = GPIO_GEDR;
+	} while (mask);
+}
+
+/*
+ * GPIO0-27 edge IRQs need to be handled specially.
+ * In addition, the IRQs are all collected up into one bit in the
+ * interrupt controller registers.
+ */
+static void puv3_high_gpio_ack(unsigned int irq)
+{
+	unsigned int mask = GPIO_MASK(irq);
+
+	GPIO_GEDR = mask;
+}
+
+static void puv3_high_gpio_mask(unsigned int irq)
+{
+	unsigned int mask = GPIO_MASK(irq);
+
+	GPIO_IRQ_mask &= ~mask;
+
+	GPIO_GRER &= ~mask;
+	GPIO_GFER &= ~mask;
+}
+
+static void puv3_high_gpio_unmask(unsigned int irq)
+{
+	unsigned int mask = GPIO_MASK(irq);
+
+	GPIO_IRQ_mask |= mask;
+
+	GPIO_GRER = GPIO_IRQ_rising_edge & GPIO_IRQ_mask;
+	GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
+}
+
+static int puv3_high_gpio_wake(unsigned int irq, unsigned int on)
+{
+	if (on)
+		PM_PWER |= PM_PWER_GPIOHIGH;
+	else
+		PM_PWER &= ~PM_PWER_GPIOHIGH;
+	return 0;
+}
+
+static struct irq_chip puv3_high_gpio_chip = {
+	.name		= "GPIO-high",
+	.ack		= puv3_high_gpio_ack,
+	.mask		= puv3_high_gpio_mask,
+	.unmask		= puv3_high_gpio_unmask,
+	.set_type	= puv3_gpio_type,
+	.set_wake	= puv3_high_gpio_wake,
+};
+
+/*
+ * We don't need to ACK IRQs on the PKUnity unless they're GPIOs
+ * this is for internal IRQs i.e. from 8 to 31.
+ */
+static void puv3_mask_irq(unsigned int irq)
+{
+	INTC_ICMR &= ~(1 << irq);
+}
+
+static void puv3_unmask_irq(unsigned int irq)
+{
+	INTC_ICMR |= (1 << irq);
+}
+
+/*
+ * Apart form GPIOs, only the RTC alarm can be a wakeup event.
+ */
+static int puv3_set_wake(unsigned int irq, unsigned int on)
+{
+	if (irq == IRQ_RTCAlarm) {
+		if (on)
+			PM_PWER |= PM_PWER_RTC;
+		else
+			PM_PWER &= ~PM_PWER_RTC;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static struct irq_chip puv3_normal_chip = {
+	.name		= "PKUnity-v3",
+	.ack		= puv3_mask_irq,
+	.mask		= puv3_mask_irq,
+	.unmask		= puv3_unmask_irq,
+	.set_wake	= puv3_set_wake,
+};
+
+static struct resource irq_resource = {
+	.name	= "irqs",
+	.start	= PKUNITY_INTC_BASE,
+	.end	= PKUNITY_INTC_BASE + 0xFFFFF,
+};
+
+static struct puv3_irq_state {
+	unsigned int	saved;
+	unsigned int	icmr;
+	unsigned int	iclr;
+	unsigned int	iccr;
+} puv3_irq_state;
+
+static int puv3_irq_suspend(struct sys_device *dev, pm_message_t state)
+{
+	struct puv3_irq_state *st = &puv3_irq_state;
+
+	st->saved = 1;
+	st->icmr = INTC_ICMR;
+	st->iclr = INTC_ICLR;
+	st->iccr = INTC_ICCR;
+
+	/*
+	 * Disable all GPIO-based interrupts.
+	 */
+	INTC_ICMR &= ~(0x1ff);
+
+	/*
+	 * Set the appropriate edges for wakeup.
+	 */
+	GPIO_GRER = PM_PWER & GPIO_IRQ_rising_edge;
+	GPIO_GFER = PM_PWER & GPIO_IRQ_falling_edge;
+
+	/*
+	 * Clear any pending GPIO interrupts.
+	 */
+	GPIO_GEDR = GPIO_GEDR;
+
+	return 0;
+}
+
+static int puv3_irq_resume(struct sys_device *dev)
+{
+	struct puv3_irq_state *st = &puv3_irq_state;
+
+	if (st->saved) {
+		INTC_ICCR = st->iccr;
+		INTC_ICLR = st->iclr;
+
+		GPIO_GRER = GPIO_IRQ_rising_edge & GPIO_IRQ_mask;
+		GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
+
+		INTC_ICMR = st->icmr;
+	}
+	return 0;
+}
+
+static struct sysdev_class puv3_irq_sysclass = {
+	.name		= "pkunity-irq",
+	.suspend	= puv3_irq_suspend,
+	.resume		= puv3_irq_resume,
+};
+
+static struct sys_device puv3_irq_device = {
+	.id		= 0,
+	.cls		= &puv3_irq_sysclass,
+};
+
+static int __init puv3_irq_init_devicefs(void)
+{
+	sysdev_class_register(&puv3_irq_sysclass);
+	return sysdev_register(&puv3_irq_device);
+}
+
+device_initcall(puv3_irq_init_devicefs);
+
+void __init init_IRQ(void)
+{
+	unsigned int irq;
+
+	request_resource(&iomem_resource, &irq_resource);
+
+	/* disable all IRQs */
+	INTC_ICMR = 0;
+
+	/* all IRQs are IRQ, not REAL */
+	INTC_ICLR = 0;
+
+	/* clear all GPIO edge detects */
+	GPIO_GPIR = FMASK(8, 0) & ~FIELD(1, 1, GPI_SOFF_REQ);
+	GPIO_GFER = 0;
+	GPIO_GRER = 0;
+	GPIO_GEDR = 0x0FFFFFFF;
+
+	INTC_ICCR = 1;
+
+	for (irq = 0; irq < IRQ_GPIOHIGH; irq++) {
+		set_irq_chip(irq, &puv3_low_gpio_chip);
+		set_irq_handler(irq, handle_edge_irq);
+		irq_modify_status(irq,
+			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN,
+			0);
+	}
+
+	for (irq = IRQ_GPIOHIGH + 1; irq < IRQ_GPIO0; irq++) {
+		set_irq_chip(irq, &puv3_normal_chip);
+		set_irq_handler(irq, handle_level_irq);
+		irq_modify_status(irq,
+			IRQ_NOREQUEST | IRQ_NOAUTOEN,
+			IRQ_NOPROBE);
+	}
+
+	for (irq = IRQ_GPIO0; irq <= IRQ_GPIO27; irq++) {
+		set_irq_chip(irq, &puv3_high_gpio_chip);
+		set_irq_handler(irq, handle_edge_irq);
+		irq_modify_status(irq,
+			IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN,
+			0);
+	}
+
+	/*
+	 * Install handler for GPIO 0-27 edge detect interrupts
+	 */
+	set_irq_chip(IRQ_GPIOHIGH, &puv3_normal_chip);
+	set_irq_chained_handler(IRQ_GPIOHIGH, puv3_gpio_handler);
+
+#ifdef CONFIG_PUV3_GPIO
+	puv3_init_gpio();
+#endif
+}
+
+int show_interrupts(struct seq_file *p, void *v)
+{
+	int i = *(loff_t *) v, cpu;
+	struct irq_desc *desc;
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (i == 0) {
+		char cpuname[12];
+
+		seq_printf(p, "    ");
+		for_each_present_cpu(cpu) {
+			sprintf(cpuname, "CPU%d", cpu);
+			seq_printf(p, " %10s", cpuname);
+		}
+		seq_putc(p, '\n');
+	}
+
+	if (i < nr_irqs) {
+		desc = irq_to_desc(i);
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		action = desc->action;
+		if (!action)
+			goto unlock;
+
+		seq_printf(p, "%3d: ", i);
+		for_each_present_cpu(cpu)
+			seq_printf(p, "%10u ", kstat_irqs_cpu(i, cpu));
+		seq_printf(p, " %10s", desc->chip->name ? : "-");
+		seq_printf(p, "  %s", action->name);
+		for (action = action->next; action; action = action->next)
+			seq_printf(p, ", %s", action->name);
+
+		seq_putc(p, '\n');
+unlock:
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	} else if (i == nr_irqs) {
+		seq_printf(p, "Error in interrupt!\n");
+	}
+	return 0;
+}
+
+/*
+ * do_IRQ handles all hardware IRQ's.  Decoded IRQs should not
+ * come via this function.  Instead, they should provide their
+ * own 'handler'
+ */
+asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+
+	/*
+	 * Some hardware gives randomly wrong interrupts.  Rather
+	 * than crashing, do something sensible.
+	 */
+	if (unlikely(irq >= nr_irqs)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING "Bad IRQ%u\n", irq);
+		ack_bad_irq(irq);
+	} else {
+		generic_handle_irq(irq);
+	}
+
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
-- 
1.7.0.4


