Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1IFIeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:34:14 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:53544 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753288Ab1IFIeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:34:08 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Ben Hutchings <ben@decadent.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: [PATCH] gpio: rewrite U300 GPIO to use gpiolib
Date: Tue, 6 Sep 2011 10:32:30 +0200
Message-ID: <1315297950-12720-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This rewrites the U300 GPIO so as to use gpiolib and
struct gpio_chip instead of just generic GPIO, hiding
all the platform specifics and passing in GPIO chip
variant as platform data at runtime instead of the
compiletime kludges.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Debian kernel maintainers <debian-kernel@lists.debian.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-nu: Linus Walleij <linus.walleij@linaro.org>
---
First I though that I had to have runtime pin configuration
to solve this, but it turns out that all users of the config
functionality were inside the U300 GPIO driver itself, so
I just made that functionality private to the driver.

This solves the problem observed by Ben Hutchings that some
touchscreen input devices wouldn't work with certain ARM
machines still using just generic GPIO.

This is based on top of the pending GPIO cleanups in Russells
tree, if I can get some ACK on this I presume Russell can
apply it to his branch.
---
 arch/arm/Kconfig                            |    1 +
 arch/arm/mach-u300/Kconfig                  |    1 +
 arch/arm/mach-u300/core.c                   |   31 +-
 arch/arm/mach-u300/include/mach/gpio-u300.h |  149 +---
 arch/arm/mach-u300/include/mach/gpio.h      |   40 +-
 arch/arm/mach-u300/include/mach/irqs.h      |   25 +-
 drivers/gpio/Kconfig                        |    9 +
 drivers/gpio/gpio-u300.c                    | 1191 ++++++++++++++++-----------
 8 files changed, 795 insertions(+), 652 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f23712d..3f38a7f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -831,6 +831,7 @@ config ARCH_U300
 	select CLKDEV_LOOKUP
 	select HAVE_MACH_CLKDEV
 	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
 	help
 	  Support for ST-Ericsson U300 series mobile platforms.
 
diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
index 966a5a0..39e077e 100644
--- a/arch/arm/mach-u300/Kconfig
+++ b/arch/arm/mach-u300/Kconfig
@@ -6,6 +6,7 @@ comment "ST-Ericsson Mobile Platform Products"
 
 config MACH_U300
 	bool "U300"
+	select GPIO_U300
 
 comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
 
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 724037e..2f1d758 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -38,6 +38,7 @@
 #include <mach/hardware.h>
 #include <mach/syscon.h>
 #include <mach/dma_channels.h>
+#include <mach/gpio-u300.h>
 
 #include "clock.h"
 #include "mmc.h"
@@ -223,7 +224,7 @@ static struct resource gpio_resources[] = {
 		.end   = IRQ_U300_GPIO_PORT2,
 		.flags = IORESOURCE_IRQ,
 	},
-#ifdef U300_COH901571_3
+#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
 	{
 		.name  = "gpio3",
 		.start = IRQ_U300_GPIO_PORT3,
@@ -236,6 +237,7 @@ static struct resource gpio_resources[] = {
 		.end   = IRQ_U300_GPIO_PORT4,
 		.flags = IORESOURCE_IRQ,
 	},
+#endif
 #ifdef CONFIG_MACH_U300_BS335
 	{
 		.name  = "gpio5",
@@ -250,7 +252,6 @@ static struct resource gpio_resources[] = {
 		.flags = IORESOURCE_IRQ,
 	},
 #endif /* CONFIG_MACH_U300_BS335 */
-#endif /* U300_COH901571_3 */
 };
 
 static struct resource keypad_resources[] = {
@@ -1495,11 +1496,35 @@ static struct platform_device i2c1_device = {
 	.resource = i2c1_resources,
 };
 
+/*
+ * The different variants have a few different versions of the
+ * GPIO block, with different number of ports.
+ */
+static struct u300_gpio_platform u300_gpio_plat = {
+#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
+	.variant = U300_GPIO_COH901335,
+	.ports = 3,
+#endif
+#ifdef CONFIG_MACH_U300_BS335
+	.variant = U300_GPIO_COH901571_3_BS335,
+	.ports = 7,
+#endif
+#ifdef CONFIG_MACH_U300_BS365
+	.variant = U300_GPIO_COH901571_3_BS365,
+	.ports = 5,
+#endif
+	.gpio_base = 0,
+	.gpio_irq_base = IRQ_U300_GPIO_BASE,
+};
+
 static struct platform_device gpio_device = {
 	.name = "u300-gpio",
 	.id = -1,
 	.num_resources = ARRAY_SIZE(gpio_resources),
 	.resource = gpio_resources,
+	.dev = {
+		.platform_data = &u300_gpio_plat,
+	},
 };
 
 static struct platform_device keypad_device = {
@@ -1596,7 +1621,7 @@ void __init u300_init_irq(void)
 	BUG_ON(IS_ERR(clk));
 	clk_enable(clk);
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < U300_VIC_IRQS_END; i++)
 		set_bit(i, (unsigned long *) &mask[0]);
 	vic_init((void __iomem *) U300_INTCON0_VBASE, 0, mask[0], mask[0]);
 	vic_init((void __iomem *) U300_INTCON1_VBASE, 32, mask[1], mask[1]);
diff --git a/arch/arm/mach-u300/include/mach/gpio-u300.h b/arch/arm/mach-u300/include/mach/gpio-u300.h
index a611906..0c2b202 100644
--- a/arch/arm/mach-u300/include/mach/gpio-u300.h
+++ b/arch/arm/mach-u300/include/mach/gpio-u300.h
@@ -9,132 +9,6 @@
 #ifndef __MACH_U300_GPIO_U300_H
 #define __MACH_U300_GPIO_U300_H
 
-#include <linux/kernel.h>
-#include <linux/io.h>
-#include <mach/hardware.h>
-#include <asm/irq.h>
-
-/* Switch type depending on platform/chip variant */
-#if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
-#define U300_COH901335
-#endif
-#if defined(CONFIG_MACH_U300_BS365) || defined(CONFIG_MACH_U300_BS335)
-#define U300_COH901571_3
-#endif
-
-/* Get base address for regs here */
-#include "u300-regs.h"
-/* IRQ numbers */
-#include "irqs.h"
-
-/*
- * This is the GPIO block definitions. GPIO (General Purpose I/O) can be
- * used for anything, and often is. The event/enable etc figures are for
- * the lowermost pin (pin 0 on each port), shift this left to match your
- * pin if you're gonna use these values.
- */
-#ifdef U300_COH901335
-#define U300_GPIO_PORTX_SPACING				(0x1C)
-/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
-#define U300_GPIO_PXPDIR				(0x00)
-#define U300_GPIO_PXPDOR				(0x00)
-/* Port X Pin Config Register 32bit (R/W) */
-#define U300_GPIO_PXPCR					(0x04)
-#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
-#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
-#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
-/* Port X Interrupt Event Register 32bit (R/W) */
-#define U300_GPIO_PXIEV					(0x08)
-#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
-/* Port X Interrupt Enable Register 32bit (R/W) */
-#define U300_GPIO_PXIEN					(0x0C)
-#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
-/* Port X Interrupt Force Register 32bit (R/W) */
-#define U300_GPIO_PXIFR					(0x10)
-#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
-/* Port X Interrupt Config Register 32bit (R/W) */
-#define U300_GPIO_PXICR					(0x14)
-#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
-/* Port X Pull-up Enable Register 32bit (R/W) */
-#define U300_GPIO_PXPER					(0x18)
-#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
-#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
-/* Control Register 32bit (R/W) */
-#define U300_GPIO_CR					(0x54)
-#define U300_GPIO_CR_BLOCK_CLOCK_ENABLE			(0x00000001UL)
-/* three ports of 8 bits each = GPIO pins 0..23 */
-#define U300_GPIO_NUM_PORTS 3
-#define U300_GPIO_PINS_PER_PORT 8
-#define U300_GPIO_MAX	(U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
-#endif
-
-#ifdef U300_COH901571_3
-/*
- * Control Register 32bit (R/W)
- * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
- * gives the number of GPIO pins.
- * bit 8-2  (mask 0x000001FC) contains the core version ID.
- */
-#define U300_GPIO_CR					(0x00)
-#define U300_GPIO_CR_SYNC_SEL_ENABLE			(0x00000002UL)
-#define U300_GPIO_CR_BLOCK_CLKRQ_ENABLE			(0x00000001UL)
-#define U300_GPIO_PORTX_SPACING				(0x30)
-/* Port X Pin Data INPUT Register 32bit (R/W) */
-#define U300_GPIO_PXPDIR				(0x04)
-/* Port X Pin Data OUTPUT Register 32bit (R/W) */
-#define U300_GPIO_PXPDOR				(0x08)
-/* Port X Pin Config Register 32bit (R/W) */
-#define U300_GPIO_PXPCR					(0x0C)
-#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
-#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
-#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
-#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
-/* Port X Pull-up Enable Register 32bit (R/W) */
-#define U300_GPIO_PXPER					(0x10)
-#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
-#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
-/* Port X Interrupt Event Register 32bit (R/W) */
-#define U300_GPIO_PXIEV					(0x14)
-#define U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEV_IRQ_EVENT			(0x00000001UL)
-/* Port X Interrupt Enable Register 32bit (R/W) */
-#define U300_GPIO_PXIEN					(0x18)
-#define U300_GPIO_PXIEN_ALL_IRQ_ENABLE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIEN_IRQ_ENABLE			(0x00000001UL)
-/* Port X Interrupt Force Register 32bit (R/W) */
-#define U300_GPIO_PXIFR					(0x1C)
-#define U300_GPIO_PXIFR_ALL_IRQ_FORCE_MASK		(0x000000FFUL)
-#define U300_GPIO_PXIFR_IRQ_FORCE			(0x00000001UL)
-/* Port X Interrupt Config Register 32bit (R/W) */
-#define U300_GPIO_PXICR					(0x20)
-#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
-#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
-#ifdef CONFIG_MACH_U300_BS335
-/* seven ports of 8 bits each = GPIO pins 0..55 */
-#define U300_GPIO_NUM_PORTS 7
-#else
-/* five ports of 8 bits each = GPIO pins 0..39 */
-#define U300_GPIO_NUM_PORTS 5
-#endif
-#define U300_GPIO_PINS_PER_PORT 8
-#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS - 1)
-#endif
-
 /*
  * Individual pin assignments for the B26/S26. Notice that the
  * actual usage of these pins depends on the PAD MUX settings, that
@@ -250,4 +124,27 @@
 
 #endif
 
+/**
+ * enum u300_gpio_variant - the type of U300 GPIO employed
+ */
+enum u300_gpio_variant {
+	U300_GPIO_COH901335,
+	U300_GPIO_COH901571_3_BS335,
+	U300_GPIO_COH901571_3_BS365,
+};
+
+/**
+ * struct u300_gpio_platform - U300 GPIO platform data
+ * @variant: IP block variant
+ * @ports: number of GPIO block ports
+ * @gpio_base: first GPIO number for this block (use a free range)
+ * @gpio_irq_base: first GPIO IRQ number for this block (use a free range)
+ */
+struct u300_gpio_platform {
+	enum u300_gpio_variant variant;
+	u8 ports;
+	int gpio_base;
+	int gpio_irq_base;
+};
+
 #endif /* __MACH_U300_GPIO_U300_H */
diff --git a/arch/arm/mach-u300/include/mach/gpio.h b/arch/arm/mach-u300/include/mach/gpio.h
index 430a054..ba224b5 100644
--- a/arch/arm/mach-u300/include/mach/gpio.h
+++ b/arch/arm/mach-u300/include/mach/gpio.h
@@ -13,35 +13,15 @@
 #ifndef __MACH_U300_GPIO_H
 #define __MACH_U300_GPIO_H
 
-#define __ARM_GPIOLIB_COMPLEX
+#include <linux/io.h>
+#include <mach/hardware.h>
+#include <asm/irq.h>
+#include <asm-generic/gpio.h>
 
-/* These can be found in arch/arm/mach-u300/gpio.c */
-extern int gpio_is_valid(int number);
-extern int gpio_request(unsigned gpio, const char *label);
-extern void gpio_free(unsigned gpio);
-extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio, int value);
-extern int gpio_register_callback(unsigned gpio,
-				  int (*func)(void *arg),
-				  void *);
-extern int gpio_unregister_callback(unsigned gpio);
-extern void enable_irq_on_gpio_pin(unsigned gpio, int edge);
-extern void disable_irq_on_gpio_pin(unsigned gpio);
-extern void gpio_pullup(unsigned gpio, int value);
-extern int gpio_get_value(unsigned gpio);
-extern void gpio_set_value(unsigned gpio, int value);
+/* Map these overrides to gpiolib functions, simply */
+#define gpio_get_value  __gpio_get_value
+#define gpio_set_value  __gpio_set_value
+#define gpio_cansleep   __gpio_cansleep
+#define gpio_to_irq     __gpio_to_irq
 
-#define gpio_get_value_cansleep gpio_get_value
-#define gpio_set_value_cansleep gpio_set_value
-
-/* translates a pin number to a port number */
-#define PIN_TO_PORT(val) (val >> 3)
-
-/* wrappers to sleep-enable the previous two functions */
-static inline unsigned gpio_to_irq(unsigned gpio)
-{
-	return PIN_TO_PORT(gpio) + IRQ_U300_GPIO_PORT0;
-}
-#define gpio_to_irq gpio_to_irq
-
-#endif /* __MACH_U300_GPIO_H */
+#endif
diff --git a/arch/arm/mach-u300/include/mach/irqs.h b/arch/arm/mach-u300/include/mach/irqs.h
index 09b1b28..d270fea 100644
--- a/arch/arm/mach-u300/include/mach/irqs.h
+++ b/arch/arm/mach-u300/include/mach/irqs.h
@@ -72,7 +72,7 @@
 
 /* DB3150 and DB3200 have only 45 IRQs */
 #if defined(CONFIG_MACH_U300_BS2X) || defined(CONFIG_MACH_U300_BS330)
-#define U300_NR_IRQS			45
+#define U300_VIC_IRQS_END		45
 #endif
 
 /* The DB3350-specific interrupt lines */
@@ -88,7 +88,7 @@
 #define IRQ_U300_GPIO_PORT4		53
 #define IRQ_U300_GPIO_PORT5		54
 #define IRQ_U300_GPIO_PORT6		55
-#define U300_NR_IRQS			56
+#define U300_VIC_IRQS_END		56
 #endif
 
 /* The DB3210-specific interrupt lines */
@@ -106,16 +106,25 @@
 #define IRQ_U300_NFIF			45
 #define IRQ_U300_NFIF2			46
 #define IRQ_U300_SYSCON_PLL_LOCK	47
-#define U300_NR_IRQS			48
+#define U300_VIC_IRQS_END		48
 #endif
 
-#ifdef CONFIG_AB3550_CORE
-#define IRQ_AB3550_BASE			(U300_NR_IRQS)
-#define IRQ_AB3550_END			(IRQ_AB3550_BASE + 37)
+/* Maximum 8*7 GPIO lines */
+#ifdef CONFIG_GPIO_U300
+#define IRQ_U300_GPIO_BASE		(U300_VIC_IRQS_END)
+#define IRQ_U300_GPIO_END		(IRQ_U300_GPIO_BASE + 56)
+#else
+#define IRQ_U300_GPIO_END		(U300_VIC_IRQS_END)
+#endif
 
-#define NR_IRQS				(IRQ_AB3550_END + 1)
+/* Optional AB3550 mixsig chip */
+#ifdef CONFIG_AB3550_CORE
+#define IRQ_AB3550_BASE			(IRQ_U300_GPIO_END)
+#define IRQ_AB3550_END			(IRQ_AB3550_BASE + 38)
 #else
-#define NR_IRQS U300_NR_IRQS
+#define IRQ_AB3550_END			(IRQ_U300_GPIO_END)
 #endif
 
+#define NR_IRQS				(IRQ_AB3550_END)
+
 #endif
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index d539efd..4caa3d3 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -178,6 +178,15 @@ config GPIO_SCH
 	  The Intel Tunnel Creek processor has 5 GPIOs powered by the
 	  core power rail and 9 from suspend power supply.
 
+config GPIO_U300
+	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
+	depends on GPIOLIB && ARCH_U300
+	help
+	  Say yes here to support GPIO interface on ST-Ericsson U300.
+	  The names of the two IP block variants supported are
+	  COH 901 335 and COH 901 571/3. They contain 3, 5 or 7
+	  ports of 8 GPIO pins each.
+
 config GPIO_VX855
 	tristate "VIA VX855/VX875 GPIO"
 	depends on MFD_SUPPORT && PCI
diff --git a/drivers/gpio/gpio-u300.c b/drivers/gpio/gpio-u300.c
index 92f2b8c..8e011d5 100644
--- a/drivers/gpio/gpio-u300.c
+++ b/drivers/gpio/gpio-u300.c
@@ -1,18 +1,17 @@
 /*
  * U300 GPIO module.
  *
- * Copyright (C) 2007-2009 ST-Ericsson AB
+ * Copyright (C) 2007-2011 ST-Ericsson AB
  * License terms: GNU General Public License (GPL) version 2
  * This can driver either of the two basic GPIO cores
  * available in the U300 platforms:
  * COH 901 335   - Used in DB3150 (U300 1.0) and DB3200 (U330 1.0)
  * COH 901 571/3 - Used in DB3210 (U365 2.0) and DB3350 (U335 1.0)
- * Notice that you also have inline macros in <asm-arch/gpio.h>
- * Author: Linus Walleij <linus.walleij@stericsson.com>
+ * Author: Linus Walleij <linus.walleij@linaro.org>
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
- *
  */
 #include <linux/module.h>
+#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
@@ -21,678 +20,900 @@
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/list.h>
+#include <linux/slab.h>
 #include <mach/gpio-u300.h>
 
-/* Reference to GPIO block clock */
-static struct clk *clk;
+/*
+ * Bias modes for U300 GPIOs
+ *
+ * GPIO_U300_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
+ * GPIO_U300_CONFIG_BIAS_FLOAT: no specific bias, the GPIO will float or state
+ *	is not controlled by software
+ * GPIO_U300_CONFIG_BIAS_PULL_UP: the GPIO will be pulled up (usually with high
+ *	impedance to VDD)
+ */
+#define GPIO_U300_CONFIG_BIAS_UNKNOWN	0x1000
+#define GPIO_U300_CONFIG_BIAS_FLOAT	0x1001
+#define GPIO_U300_CONFIG_BIAS_PULL_UP	0x1002
+
+/*
+ * Drive modes for U300 GPIOs (output)
+ *
+ * GPIO_U300_CONFIG_DRIVE_PUSH_PULL: the GPIO will be driven actively high and
+ *	low, this is the most typical case and is typically achieved with two
+ *	active transistors on the output
+ * GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN: the GPIO will be driven with open drain
+ *	(open collector) which means it is usually wired with other output
+ *	ports which are then pulled up with an external resistor
+ * GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE: the GPIO will be driven with open drain
+ *	(open emitter) which is the same as open drain mutatis mutandis but
+ *	pulled to ground
+ */
+#define GPIO_U300_CONFIG_DRIVE_PUSH_PULL	0x2000
+#define GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN	0x2001
+#define GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE	0x2002
+
+/*
+ * Register definitions for COH 901 335 variant
+ */
+#define U300_335_PORT_STRIDE				(0x1C)
+/* Port X Pin Data Register 32bit, this is both input and output (R/W) */
+#define U300_335_PXPDIR					(0x00)
+#define U300_335_PXPDOR					(0x00)
+/* Port X Pin Config Register 32bit (R/W) */
+#define U300_335_PXPCR					(0x04)
+/* This register layout is the same in both blocks */
+#define U300_GPIO_PXPCR_ALL_PINS_MODE_MASK		(0x0000FFFFUL)
+#define U300_GPIO_PXPCR_PIN_MODE_MASK			(0x00000003UL)
+#define U300_GPIO_PXPCR_PIN_MODE_SHIFT			(0x00000002UL)
+#define U300_GPIO_PXPCR_PIN_MODE_INPUT			(0x00000000UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL	(0x00000001UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN	(0x00000002UL)
+#define U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE	(0x00000003UL)
+/* Port X Interrupt Event Register 32bit (R/W) */
+#define U300_335_PXIEV					(0x08)
+/* Port X Interrupt Enable Register 32bit (R/W) */
+#define U300_335_PXIEN					(0x0C)
+/* Port X Interrupt Force Register 32bit (R/W) */
+#define U300_335_PXIFR					(0x10)
+/* Port X Interrupt Config Register 32bit (R/W) */
+#define U300_335_PXICR					(0x14)
+/* This register layout is the same in both blocks */
+#define U300_GPIO_PXICR_ALL_IRQ_CONFIG_MASK		(0x000000FFUL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_MASK			(0x00000001UL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_FALLING_EDGE		(0x00000000UL)
+#define U300_GPIO_PXICR_IRQ_CONFIG_RISING_EDGE		(0x00000001UL)
+/* Port X Pull-up Enable Register 32bit (R/W) */
+#define U300_335_PXPER					(0x18)
+/* This register layout is the same in both blocks */
+#define U300_GPIO_PXPER_ALL_PULL_UP_DISABLE_MASK	(0x000000FFUL)
+#define U300_GPIO_PXPER_PULL_UP_DISABLE			(0x00000001UL)
+/* Control Register 32bit (R/W) */
+#define U300_335_CR					(0x54)
+#define U300_335_CR_BLOCK_CLOCK_ENABLE			(0x00000001UL)
 
-/* Memory resource */
-static struct resource *memres;
-static void __iomem *virtbase;
-static struct device *gpiodev;
+/*
+ * Register definitions for COH 901 571 / 3 variant
+ */
+#define U300_571_PORT_STRIDE				(0x30)
+/*
+ * Control Register 32bit (R/W)
+ * bit 15-9 (mask 0x0000FE00) contains the number of cores. 8*cores
+ * gives the number of GPIO pins.
+ * bit 8-2  (mask 0x000001FC) contains the core version ID.
+ */
+#define U300_571_CR					(0x00)
+#define U300_571_CR_SYNC_SEL_ENABLE			(0x00000002UL)
+#define U300_571_CR_BLOCK_CLKRQ_ENABLE			(0x00000001UL)
+/*
+ * These registers have the same layout and function as the corresponding
+ * COH 901 335 registers, just at different offset.
+ */
+#define U300_571_PXPDIR					(0x04)
+#define U300_571_PXPDOR					(0x08)
+#define U300_571_PXPCR					(0x0C)
+#define U300_571_PXPER					(0x10)
+#define U300_571_PXIEV					(0x14)
+#define U300_571_PXIEN					(0x18)
+#define U300_571_PXIFR					(0x1C)
+#define U300_571_PXICR					(0x20)
+
+/* 8 bits per port, no version has more than 7 ports */
+#define U300_GPIO_PINS_PER_PORT 8
+#define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * 7)
+
+struct u300_gpio {
+	struct gpio_chip chip;
+	struct list_head port_list;
+	struct clk *clk;
+	struct resource *memres;
+	void __iomem *base;
+	struct device *dev;
+	int irq_base;
+	int users;
+	u32 stride;
+	/* Register offsets */
+	u32 pcr;
+	u32 dor;
+	u32 dir;
+	u32 per;
+	u32 icr;
+	u32 ien;
+	u32 iev;
+};
 
 struct u300_gpio_port {
-	const char *name;
+	struct list_head node;
+	struct u300_gpio *gpio;
+	char name[8];
 	int irq;
 	int number;
+	u8 toggle_edge_mode;
 };
 
+/*
+ * Macro to expand to read a specific register found in the "gpio"
+ * struct. It requires the struct u300_gpio *gpio variable to exist in
+ * its context. It calculates the port offset from the given pin
+ * offset, muliplies by the port stride and adds the register offset
+ * so it provides a pointer to the desired register.
+ */
+#define U300_PIN_REG(pin, reg) \
+	(gpio->base + (pin >> 3) * gpio->stride + gpio->reg)
 
-static struct u300_gpio_port gpio_ports[] = {
-	{
-		.name = "gpio0",
-		.number = 0,
-	},
-	{
-		.name = "gpio1",
-		.number = 1,
-	},
-	{
-		.name = "gpio2",
-		.number = 2,
-	},
-#ifdef U300_COH901571_3
-	{
-		.name = "gpio3",
-		.number = 3,
-	},
-	{
-		.name = "gpio4",
-		.number = 4,
-	},
-#ifdef CONFIG_MACH_U300_BS335
-	{
-		.name = "gpio5",
-		.number = 5,
-	},
-	{
-		.name = "gpio6",
-		.number = 6,
-	},
-#endif
-#endif
+/*
+ * Provides a bitmask for a specific gpio pin inside an 8-bit GPIO
+ * register.
+ */
+#define U300_PIN_BIT(pin) \
+	(1 << (pin & 0x07))
 
+struct u300_gpio_confdata {
+	u16 bias_mode;
+	bool output;
+	int outval;
 };
 
+/* BS335 has seven ports of 8 bits each = GPIO pins 0..55 */
+#define BS335_GPIO_NUM_PORTS 7
+/* BS365 has five ports of 8 bits each = GPIO pins 0..39 */
+#define BS365_GPIO_NUM_PORTS 5
 
-#ifdef U300_COH901571_3
+#define U300_FLOATING_INPUT { \
+	.bias_mode = GPIO_U300_CONFIG_BIAS_FLOAT, \
+	.output = false, \
+}
 
-/* Default input value */
-#define DEFAULT_OUTPUT_LOW   0
-#define DEFAULT_OUTPUT_HIGH  1
+#define U300_PULL_UP_INPUT { \
+	.bias_mode = GPIO_U300_CONFIG_BIAS_PULL_UP, \
+	.output = false, \
+}
 
-/* GPIO Pull-Up status */
-#define DISABLE_PULL_UP  0
-#define ENABLE_PULL_UP  1
+#define U300_OUTPUT_LOW { \
+	.output = true, \
+	.outval = 0, \
+}
 
-#define GPIO_NOT_USED 0
-#define GPIO_IN       1
-#define GPIO_OUT      2
+#define U300_OUTPUT_HIGH { \
+	.output = true, \
+	.outval = 1, \
+}
 
-struct u300_gpio_configuration_data {
-	unsigned char pin_usage;
-	unsigned char default_output_value;
-	unsigned char pull_up;
-};
 
 /* Initial configuration */
-const struct u300_gpio_configuration_data
-u300_gpio_config[U300_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
-#ifdef CONFIG_MACH_U300_BS335
+static struct __initdata u300_gpio_confdata
+bs335_gpio_config[BS335_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
 	/* Port 0, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_HIGH,  DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_HIGH,
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
 	},
 	/* Port 1, pins 0-7 */
 	{
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_HIGH,  DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_PULL_UP_INPUT,
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_HIGH,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
 	},
 	/* Port 2, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_LOW,
+		U300_PULL_UP_INPUT,
+		U300_OUTPUT_LOW,
+		U300_PULL_UP_INPUT,
 	},
 	/* Port 3, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_PULL_UP_INPUT,
+		U300_OUTPUT_LOW,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
 	},
 	/* Port 4, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
 	},
 	/* Port 5, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
 	},
 	/* Port 6, pind 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
 	}
-#endif
+};
 
-#ifdef CONFIG_MACH_U300_BS365
+static struct __initdata u300_gpio_confdata
+bs365_gpio_config[BS365_GPIO_NUM_PORTS][U300_GPIO_PINS_PER_PORT] = {
 	/* Port 0, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_LOW,
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_PULL_UP_INPUT,
+		U300_FLOATING_INPUT,
 	},
 	/* Port 1, pins 0-7 */
 	{
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_HIGH,  DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP}
+		U300_OUTPUT_LOW,
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_LOW,
+		U300_FLOATING_INPUT,
+		U300_FLOATING_INPUT,
+		U300_OUTPUT_HIGH,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
 	},
 	/* Port 2, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,   DISABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
+		U300_FLOATING_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
 	},
 	/* Port 3, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
 	},
 	/* Port 4, pins 0-7 */
 	{
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_IN,  DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
+		U300_PULL_UP_INPUT,
 		/* These 4 pins doesn't exist on DB3210 */
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP},
-		{GPIO_OUT, DEFAULT_OUTPUT_LOW,    ENABLE_PULL_UP}
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
+		U300_OUTPUT_LOW,
 	}
-#endif
 };
-#endif
 
-
-/* No users == we can power down GPIO */
-static int gpio_users;
-
-struct gpio_struct {
-	int (*callback)(void *);
-	void *data;
-	int users;
-};
-
-static struct gpio_struct gpio_pin[U300_GPIO_MAX];
-
-/*
- * Let drivers register callback in order to get notified when there is
- * an interrupt on the gpio pin
+/**
+ * to_u300_gpio() - get the pointer to u300_gpio
+ * @chip: the gpio chip member of the structure u300_gpio
  */
-int gpio_register_callback(unsigned gpio, int (*func)(void *arg), void *data)
+static inline struct u300_gpio *to_u300_gpio(struct gpio_chip *chip)
 {
-	if (gpio_pin[gpio].callback)
-		dev_warn(gpiodev, "%s: WARNING: callback already "
-			 "registered for gpio pin#%d\n", __func__, gpio);
-	gpio_pin[gpio].callback = func;
-	gpio_pin[gpio].data = data;
-
-	return 0;
+	return container_of(chip, struct u300_gpio, chip);
 }
-EXPORT_SYMBOL(gpio_register_callback);
 
-int gpio_unregister_callback(unsigned gpio)
+static int u300_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	if (!gpio_pin[gpio].callback)
-		dev_warn(gpiodev, "%s: WARNING: callback already "
-			 "unregistered for gpio pin#%d\n", __func__, gpio);
-	gpio_pin[gpio].callback = NULL;
-	gpio_pin[gpio].data = NULL;
+	struct u300_gpio *gpio = to_u300_gpio(chip);
 
-	return 0;
+	return readl(U300_PIN_REG(offset, dir)) & U300_PIN_BIT(offset);
 }
-EXPORT_SYMBOL(gpio_unregister_callback);
 
-/* Non-zero means valid */
-int gpio_is_valid(int number)
+static void u300_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	if (number >= 0 &&
-	    number < (U300_GPIO_NUM_PORTS * U300_GPIO_PINS_PER_PORT))
-		return 1;
-	return 0;
-}
-EXPORT_SYMBOL(gpio_is_valid);
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	unsigned long flags;
+	u32 val;
 
-int gpio_request(unsigned gpio, const char *label)
-{
-	if (gpio_pin[gpio].users)
-		return -EINVAL;
-	else
-		gpio_pin[gpio].users++;
+	local_irq_save(flags);
 
-	gpio_users++;
+	val = readl(U300_PIN_REG(offset, dor));
+	if (value)
+		writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, dor));
+	else
+		writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, dor));
 
-	return 0;
+	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(gpio_request);
 
-void gpio_free(unsigned gpio)
+static int u300_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	gpio_users--;
-	gpio_pin[gpio].users--;
-	if (unlikely(gpio_pin[gpio].users < 0)) {
-		dev_warn(gpiodev, "warning: gpio#%d release mismatch\n",
-			 gpio);
-		gpio_pin[gpio].users = 0;
-	}
-
-	return;
-}
-EXPORT_SYMBOL(gpio_free);
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	unsigned long flags;
+	u32 val;
 
-/* This returns zero or nonzero */
-int gpio_get_value(unsigned gpio)
-{
-	return readl(virtbase + U300_GPIO_PXPDIR +
-	  PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING) & (1 << (gpio & 0x07));
+	local_irq_save(flags);
+	val = readl(U300_PIN_REG(offset, pcr));
+	/* Mask out this pin, note 2 bits per setting */
+	val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << ((offset & 0x07) << 1));
+	writel(val, U300_PIN_REG(offset, pcr));
+	local_irq_restore(flags);
+	return 0;
 }
-EXPORT_SYMBOL(gpio_get_value);
 
-/*
- * We hope that the compiler will optimize away the unused branch
- * in case "value" is a constant
- */
-void gpio_set_value(unsigned gpio, int value)
+static int u300_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+				      int value)
 {
-	u32 val;
+	struct u300_gpio *gpio = to_u300_gpio(chip);
 	unsigned long flags;
+	u32 oldmode;
+	u32 val;
 
 	local_irq_save(flags);
-	if (value) {
-		/* set */
-		val = readl(virtbase + U300_GPIO_PXPDOR +
-		  PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING)
-		  & (1 << (gpio & 0x07));
-		writel(val | (1 << (gpio & 0x07)), virtbase +
-		  U300_GPIO_PXPDOR +
-		  PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
-	} else {
-		/* clear */
-		val = readl(virtbase + U300_GPIO_PXPDOR +
-		  PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING)
-		  & (1 << (gpio & 0x07));
-		writel(val & ~(1 << (gpio & 0x07)), virtbase +
-		  U300_GPIO_PXPDOR +
-		  PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
+	val = readl(U300_PIN_REG(offset, pcr));
+	/*
+	 * Drive mode must be set by the special mode set function, set
+	 * push/pull mode by default if no mode has been selected.
+	 */
+	oldmode = val & (U300_GPIO_PXPCR_PIN_MODE_MASK <<
+			 ((offset & 0x07) << 1));
+	/* mode = 0 means input, else some mode is already set */
+	if (oldmode == 0) {
+		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK <<
+			 ((offset & 0x07) << 1));
+		val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL
+			<< ((offset & 0x07) << 1));
+		writel(val, U300_PIN_REG(offset, pcr));
 	}
+	u300_gpio_set(chip, offset, value);
 	local_irq_restore(flags);
+	return 0;
+}
+
+static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	int retirq = gpio->irq_base + offset;
+
+	dev_dbg(gpio->dev, "request IRQ for GPIO %d, return %d\n", offset,
+		retirq);
+	return retirq;
 }
-EXPORT_SYMBOL(gpio_set_value);
 
-int gpio_direction_input(unsigned gpio)
+static int u300_gpio_config(struct gpio_chip *chip, unsigned offset,
+		     u16 param, unsigned long *data)
 {
+	struct u300_gpio *gpio = to_u300_gpio(chip);
 	unsigned long flags;
 	u32 val;
 
-	if (gpio > U300_GPIO_MAX)
-		return -EINVAL;
-
 	local_irq_save(flags);
-	val = readl(virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	/* Mask out this pin*/
-	val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << ((gpio & 0x07) << 1));
-	/* This is not needed since it sets the bits to zero.*/
-	/* val |= (U300_GPIO_PXPCR_PIN_MODE_INPUT << (gpio*2)); */
-	writel(val, virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
+	switch (param) {
+	case GPIO_U300_CONFIG_BIAS_UNKNOWN:
+	case GPIO_U300_CONFIG_BIAS_FLOAT:
+		val = readl(U300_PIN_REG(offset, per));
+		writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, per));
+		break;
+	case GPIO_U300_CONFIG_BIAS_PULL_UP:
+		val = readl(U300_PIN_REG(offset, per));
+		writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, per));
+		break;
+	case GPIO_U300_CONFIG_DRIVE_PUSH_PULL:
+		val = readl(U300_PIN_REG(offset, pcr));
+		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
+			 << ((offset & 0x07) << 1));
+		val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL
+			<< ((offset & 0x07) << 1));
+		writel(val, U300_PIN_REG(offset, pcr));
+		break;
+	case GPIO_U300_CONFIG_DRIVE_OPEN_DRAIN:
+		val = readl(U300_PIN_REG(offset, pcr));
+		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
+			 << ((offset & 0x07) << 1));
+		val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_DRAIN
+			<< ((offset & 0x07) << 1));
+		writel(val, U300_PIN_REG(offset, pcr));
+		break;
+	case GPIO_U300_CONFIG_DRIVE_OPEN_SOURCE:
+		val = readl(U300_PIN_REG(offset, pcr));
+		val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK
+			 << ((offset & 0x07) << 1));
+		val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_OPEN_SOURCE
+			<< ((offset & 0x07) << 1));
+		writel(val, U300_PIN_REG(offset, pcr));
+		break;
+	default:
+		local_irq_restore(flags);
+		dev_err(gpio->dev, "illegal configuration requested\n");
+		return -EINVAL;
+	}
 	local_irq_restore(flags);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_direction_input);
+EXPORT_SYMBOL_GPL(u300_gpio_config);
+
+static struct gpio_chip u300_gpio_chip = {
+	.label			= "u300-gpio-chip",
+	.owner			= THIS_MODULE,
+	.get			= u300_gpio_get,
+	.set			= u300_gpio_set,
+	.direction_input	= u300_gpio_direction_input,
+	.direction_output	= u300_gpio_direction_output,
+	.to_irq			= u300_gpio_to_irq,
+};
 
-int gpio_direction_output(unsigned gpio, int value)
+static void u300_toggle_trigger(struct u300_gpio *gpio, unsigned offset)
 {
-	unsigned long flags;
 	u32 val;
 
-	if (gpio > U300_GPIO_MAX)
-		return -EINVAL;
-
-	local_irq_save(flags);
-	val = readl(virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	/* Mask out this pin */
-	val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << ((gpio & 0x07) << 1));
-	/*
-	 * FIXME: configure for push/pull, open drain or open source per pin
-	 * in setup. The current driver will only support push/pull.
-	 */
-	val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL
-			<< ((gpio & 0x07) << 1));
-	writel(val, virtbase + U300_GPIO_PXPCR + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	gpio_set_value(gpio, value);
-	local_irq_restore(flags);
-	return 0;
+	val = readl(U300_PIN_REG(offset, icr));
+	/* Set mode depending on state */
+	if (u300_gpio_get(&gpio->chip, offset)) {
+		/* High now, let's trigger on falling edge next then */
+		writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, icr));
+		dev_dbg(gpio->dev, "next IRQ on falling edge on pin %d\n",
+			offset);
+	} else {
+		/* Low now, let's trigger on rising edge next then */
+		writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, icr));
+		dev_dbg(gpio->dev, "next IRQ on rising edge on pin %d\n",
+			offset);
+	}
 }
-EXPORT_SYMBOL(gpio_direction_output);
 
-/*
- * Enable an IRQ, edge is rising edge (!= 0) or falling edge (==0).
- */
-void enable_irq_on_gpio_pin(unsigned gpio, int edge)
+static int u300_gpio_irq_type(struct irq_data *d, unsigned trigger)
 {
+	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct u300_gpio *gpio = port->gpio;
+	int offset = d->irq - gpio->irq_base;
 	u32 val;
-	unsigned long flags;
-	local_irq_save(flags);
 
-	val = readl(virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	val |= (1 << (gpio & 0x07));
-	writel(val, virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	val = readl(virtbase + U300_GPIO_PXICR + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	if (edge)
-		val |= (1 << (gpio & 0x07));
-	else
-		val &= ~(1 << (gpio & 0x07));
-	writel(val, virtbase + U300_GPIO_PXICR + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	local_irq_restore(flags);
+	if ((trigger & IRQF_TRIGGER_RISING) &&
+	    (trigger & IRQF_TRIGGER_FALLING)) {
+		/*
+		 * The GPIO block can only trigger on falling OR rising edges,
+		 * not both. So we need to toggle the mode whenever the pin
+		 * goes from one state to the other with a special state flag
+		 */
+		dev_dbg(gpio->dev,
+			"trigger on both rising and falling edge on pin %d\n",
+			offset);
+		port->toggle_edge_mode |= U300_PIN_BIT(offset);
+		u300_toggle_trigger(gpio, offset);
+	} else if (trigger & IRQF_TRIGGER_RISING) {
+		dev_dbg(gpio->dev, "trigger on rising edge on pin %d\n",
+			offset);
+		val = readl(U300_PIN_REG(offset, icr));
+		writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, icr));
+		port->toggle_edge_mode &= ~U300_PIN_BIT(offset);
+	} else if (trigger & IRQF_TRIGGER_FALLING) {
+		dev_dbg(gpio->dev, "trigger on falling edge on pin %d\n",
+			offset);
+		val = readl(U300_PIN_REG(offset, icr));
+		writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, icr));
+		port->toggle_edge_mode &= ~U300_PIN_BIT(offset);
+	}
+
+	return 0;
 }
-EXPORT_SYMBOL(enable_irq_on_gpio_pin);
 
-void disable_irq_on_gpio_pin(unsigned gpio)
+static void u300_gpio_irq_enable(struct irq_data *d)
 {
+	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct u300_gpio *gpio = port->gpio;
+	int offset = d->irq - gpio->irq_base;
 	u32 val;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	val = readl(virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
-	val &= ~(1 << (gpio & 0x07));
-	writel(val, virtbase + U300_GPIO_PXIEN + PIN_TO_PORT(gpio) *
-				U300_GPIO_PORTX_SPACING);
+	val = readl(U300_PIN_REG(offset, ien));
+	writel(val | U300_PIN_BIT(offset), U300_PIN_REG(offset, ien));
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(disable_irq_on_gpio_pin);
 
-/* Enable (value == 0) or disable (value == 1) internal pullup */
-void gpio_pullup(unsigned gpio, int value)
+static void u300_gpio_irq_disable(struct irq_data *d)
 {
+	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
+	struct u300_gpio *gpio = port->gpio;
+	int offset = d->irq - gpio->irq_base;
 	u32 val;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	if (value) {
-		val = readl(virtbase + U300_GPIO_PXPER + PIN_TO_PORT(gpio) *
-					U300_GPIO_PORTX_SPACING);
-		writel(val | (1 << (gpio & 0x07)), virtbase + U300_GPIO_PXPER +
-				PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
-	} else {
-		val = readl(virtbase + U300_GPIO_PXPER + PIN_TO_PORT(gpio) *
-					U300_GPIO_PORTX_SPACING);
-		writel(val & ~(1 << (gpio & 0x07)), virtbase + U300_GPIO_PXPER +
-				PIN_TO_PORT(gpio) * U300_GPIO_PORTX_SPACING);
-	}
+	val = readl(U300_PIN_REG(offset, ien));
+	writel(val & ~U300_PIN_BIT(offset), U300_PIN_REG(offset, ien));
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(gpio_pullup);
 
-static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
+static struct irq_chip u300_gpio_irqchip = {
+	.name			= "u300-gpio-irqchip",
+	.irq_enable		= u300_gpio_irq_enable,
+	.irq_disable		= u300_gpio_irq_disable,
+	.irq_set_type		= u300_gpio_irq_type,
+
+};
+
+static void u300_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct u300_gpio_port *port = dev_id;
-	u32 val;
-	int pin;
+	struct u300_gpio_port *port = irq_get_handler_data(irq);
+	struct u300_gpio *gpio = port->gpio;
+	int pinoffset = port->number << 3; /* get the right stride */
+	unsigned long val;
 
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 	/* Read event register */
-	val = readl(virtbase + U300_GPIO_PXIEV + port->number *
-				U300_GPIO_PORTX_SPACING);
-	/* Mask with enable register */
-	val &= readl(virtbase + U300_GPIO_PXIEV + port->number *
-				U300_GPIO_PORTX_SPACING);
+	val = readl(U300_PIN_REG(pinoffset, iev));
 	/* Mask relevant bits */
-	val &= U300_GPIO_PXIEV_ALL_IRQ_EVENT_MASK;
+	val &= 0xFFU; /* 8 bits per port */
 	/* ACK IRQ (clear event) */
-	writel(val, virtbase + U300_GPIO_PXIEV + port->number *
-				U300_GPIO_PORTX_SPACING);
-	/* Print message */
-	while (val != 0) {
-		unsigned gpio;
-
-		pin = __ffs(val);
-		/* mask off this pin */
-		val &= ~(1 << pin);
-		gpio = (port->number << 3) + pin;
-
-		if (gpio_pin[gpio].callback)
-			(void)gpio_pin[gpio].callback(gpio_pin[gpio].data);
-		else
-			dev_dbg(gpiodev, "stray GPIO IRQ on line %d\n",
-			       gpio);
+	writel(val, U300_PIN_REG(pinoffset, iev));
+
+	/* Call IRQ handler */
+	if (val != 0) {
+		int irqoffset;
+
+		for_each_set_bit(irqoffset, &val, U300_GPIO_PINS_PER_PORT) {
+			int pin_irq = gpio->irq_base + (port->number << 3)
+				+ irqoffset;
+			int offset = pinoffset + irqoffset;
+
+			dev_dbg(gpio->dev, "GPIO IRQ %d on pin %d\n",
+				pin_irq, offset);
+			generic_handle_irq(pin_irq);
+			/*
+			 * Triggering IRQ on both rising and falling edge
+			 * needs mockery
+			 */
+			if (port->toggle_edge_mode & U300_PIN_BIT(offset))
+				u300_toggle_trigger(gpio, offset);
+		}
 	}
-	return IRQ_HANDLED;
+
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
 }
 
-static void gpio_set_initial_values(void)
+static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
+				      int offset,
+				      struct u300_gpio_confdata *conf)
 {
-#ifdef U300_COH901571_3
-	int i, j;
-	unsigned long flags;
-	u32 val;
+	/* Set mode: input or output */
+	if (conf->output) {
+		u300_gpio_direction_output(&gpio->chip, offset, conf->outval);
 
-	/* Write default values to all pins */
-	for (i = 0; i < U300_GPIO_NUM_PORTS; i++) {
-		val = 0;
-		for (j = 0; j < 8; j++)
-			val |= (u32) (u300_gpio_config[i][j].default_output_value != DEFAULT_OUTPUT_LOW) << j;
-		local_irq_save(flags);
-		writel(val, virtbase + U300_GPIO_PXPDOR + i * U300_GPIO_PORTX_SPACING);
-		local_irq_restore(flags);
+		/* Deactivate bias mode for output */
+		u300_gpio_config(&gpio->chip, offset,
+				 GPIO_U300_CONFIG_BIAS_FLOAT,
+				 NULL);
+
+		/* Set drive mode for output */
+		u300_gpio_config(&gpio->chip, offset,
+				 GPIO_U300_CONFIG_DRIVE_PUSH_PULL, NULL);
+
+		dev_dbg(gpio->dev, "set up pin %d as output, value: %d\n",
+			offset, conf->outval);
+	} else {
+		u300_gpio_direction_input(&gpio->chip, offset);
+
+		/* Always set output low on input pins */
+		u300_gpio_set(&gpio->chip, offset, 0);
+
+		/* Set bias mode for input */
+		u300_gpio_config(&gpio->chip, offset, conf->bias_mode, NULL);
+
+		dev_dbg(gpio->dev, "set up pin %d as input, bias: %04x\n",
+			offset, conf->bias_mode);
 	}
+}
 
-	/*
-	 * Put all pins that are set to either 'GPIO_OUT' or 'GPIO_NOT_USED'
-	 * to output and 'GPIO_IN' to input for each port. And initialize
-	 * default value on outputs.
-	 */
-	for (i = 0; i < U300_GPIO_NUM_PORTS; i++) {
-		for (j = 0; j < U300_GPIO_PINS_PER_PORT; j++) {
-			local_irq_save(flags);
-			val = readl(virtbase + U300_GPIO_PXPCR +
-					 i * U300_GPIO_PORTX_SPACING);
-			/* Mask out this pin */
-			val &= ~(U300_GPIO_PXPCR_PIN_MODE_MASK << (j << 1));
-
-			if (u300_gpio_config[i][j].pin_usage != GPIO_IN)
-				val |= (U300_GPIO_PXPCR_PIN_MODE_OUTPUT_PUSH_PULL << (j << 1));
-			writel(val, virtbase + U300_GPIO_PXPCR +
-					 i * U300_GPIO_PORTX_SPACING);
-			local_irq_restore(flags);
+static void __init u300_gpio_init_coh901571(struct u300_gpio *gpio,
+				     struct u300_gpio_platform *plat)
+{
+	int i, j;
+
+	/* Write default config and values to all pins */
+	for (i = 0; i < plat->ports; i++) {
+		for (j = 0; j < 8; j++) {
+			struct u300_gpio_confdata *conf;
+			int offset = (i*8) + j;
+
+			if (plat->variant == U300_GPIO_COH901571_3_BS335)
+				conf = &bs335_gpio_config[i][j];
+			else if (plat->variant == U300_GPIO_COH901571_3_BS365)
+				conf = &bs365_gpio_config[i][j];
+			else
+				break;
+
+			u300_gpio_init_pin(gpio, offset, conf);
 		}
 	}
+}
 
-	/* Enable or disable the internal pull-ups in the GPIO ASIC block */
-	for (i = 0; i < U300_GPIO_MAX; i++) {
-		val = 0;
-		for (j = 0; j < 8; j++)
-			val |= (u32)((u300_gpio_config[i][j].pull_up == DISABLE_PULL_UP) << j);
-		local_irq_save(flags);
-		writel(val, virtbase + U300_GPIO_PXPER + i * U300_GPIO_PORTX_SPACING);
-		local_irq_restore(flags);
+static inline void u300_gpio_free_ports(struct u300_gpio *gpio)
+{
+	struct u300_gpio_port *port;
+	struct list_head *p, *n;
+
+	list_for_each_safe(p, n, &gpio->port_list) {
+		port = list_entry(p, struct u300_gpio_port, node);
+		list_del(&port->node);
+		free_irq(port->irq, port);
+		kfree(port);
 	}
-#endif
 }
 
-static int __init gpio_probe(struct platform_device *pdev)
+static int __init u300_gpio_probe(struct platform_device *pdev)
 {
-	u32 val;
+	struct u300_gpio_platform *plat = dev_get_platdata(&pdev->dev);
+	struct u300_gpio *gpio;
 	int err = 0;
+	int portno;
+	u32 val;
+	u32 ifr;
 	int i;
-	int num_irqs;
 
-	gpiodev = &pdev->dev;
-	memset(gpio_pin, 0, sizeof(gpio_pin));
+	gpio = kzalloc(sizeof(struct u300_gpio), GFP_KERNEL);
+	if (gpio == NULL) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	gpio->chip = u300_gpio_chip;
+	gpio->chip.ngpio = plat->ports * U300_GPIO_PINS_PER_PORT;
+	gpio->irq_base = plat->gpio_irq_base;
+	gpio->chip.dev = &pdev->dev;
+	gpio->chip.base = plat->gpio_base;
+	gpio->dev = &pdev->dev;
 
 	/* Get GPIO clock */
-	clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
-		err = PTR_ERR(clk);
-		dev_err(gpiodev, "could not get GPIO clock\n");
+	gpio->clk = clk_get(gpio->dev, NULL);
+	if (IS_ERR(gpio->clk)) {
+		err = PTR_ERR(gpio->clk);
+		dev_err(gpio->dev, "could not get GPIO clock\n");
 		goto err_no_clk;
 	}
-	err = clk_enable(clk);
+	err = clk_enable(gpio->clk);
 	if (err) {
-		dev_err(gpiodev, "could not enable GPIO clock\n");
+		dev_err(gpio->dev, "could not enable GPIO clock\n");
 		goto err_no_clk_enable;
 	}
 
-	memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!memres)
+	gpio->memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!gpio->memres) {
+		dev_err(gpio->dev, "could not get GPIO memory resource\n");
+		err = -ENODEV;
 		goto err_no_resource;
+	}
 
-	if (!request_mem_region(memres->start, resource_size(memres),
+	if (!request_mem_region(gpio->memres->start,
+				resource_size(gpio->memres),
 				"GPIO Controller")) {
 		err = -ENODEV;
 		goto err_no_ioregion;
 	}
 
-	virtbase = ioremap(memres->start, resource_size(memres));
-	if (!virtbase) {
+	gpio->base = ioremap(gpio->memres->start, resource_size(gpio->memres));
+	if (!gpio->base) {
 		err = -ENOMEM;
 		goto err_no_ioremap;
 	}
-	dev_info(gpiodev, "remapped 0x%08x to %p\n",
-		 memres->start, virtbase);
-
-#ifdef U300_COH901335
-	dev_info(gpiodev, "initializing GPIO Controller COH 901 335\n");
-	/* Turn on the GPIO block */
-	writel(U300_GPIO_CR_BLOCK_CLOCK_ENABLE, virtbase + U300_GPIO_CR);
-#endif
-
-#ifdef U300_COH901571_3
-	dev_info(gpiodev, "initializing GPIO Controller COH 901 571/3\n");
-	val = readl(virtbase + U300_GPIO_CR);
-	dev_info(gpiodev, "COH901571/3 block version: %d, " \
-	       "number of cores: %d\n",
-	       ((val & 0x0000FE00) >> 9),
-	       ((val & 0x000001FC) >> 2));
-	writel(U300_GPIO_CR_BLOCK_CLKRQ_ENABLE, virtbase + U300_GPIO_CR);
-#endif
-
-	gpio_set_initial_values();
-
-	for (num_irqs = 0 ; num_irqs < U300_GPIO_NUM_PORTS; num_irqs++) {
-
-		gpio_ports[num_irqs].irq =
-			platform_get_irq_byname(pdev,
-						gpio_ports[num_irqs].name);
-
-		err = request_irq(gpio_ports[num_irqs].irq,
-				  gpio_irq_handler, IRQF_DISABLED,
-				  gpio_ports[num_irqs].name,
-				  &gpio_ports[num_irqs]);
-		if (err) {
-			dev_err(gpiodev, "cannot allocate IRQ for %s!\n",
-				gpio_ports[num_irqs].name);
-			goto err_no_irq;
+
+	if (plat->variant == U300_GPIO_COH901335) {
+		dev_info(gpio->dev,
+			 "initializing GPIO Controller COH 901 335\n");
+		gpio->stride = U300_335_PORT_STRIDE;
+		gpio->pcr = U300_335_PXPCR;
+		gpio->dor = U300_335_PXPDOR;
+		gpio->dir = U300_335_PXPDIR;
+		gpio->per = U300_335_PXPER;
+		gpio->icr = U300_335_PXICR;
+		gpio->ien = U300_335_PXIEN;
+		gpio->iev = U300_335_PXIEV;
+		ifr = U300_335_PXIFR;
+
+		/* Turn on the GPIO block */
+		writel(U300_335_CR_BLOCK_CLOCK_ENABLE,
+		       gpio->base + U300_335_CR);
+	} else if (plat->variant == U300_GPIO_COH901571_3_BS335 ||
+		   plat->variant == U300_GPIO_COH901571_3_BS365) {
+		dev_info(gpio->dev,
+			 "initializing GPIO Controller COH 901 571/3\n");
+		gpio->stride = U300_571_PORT_STRIDE;
+		gpio->pcr = U300_571_PXPCR;
+		gpio->dor = U300_571_PXPDOR;
+		gpio->dir = U300_571_PXPDIR;
+		gpio->per = U300_571_PXPER;
+		gpio->icr = U300_571_PXICR;
+		gpio->ien = U300_571_PXIEN;
+		gpio->iev = U300_571_PXIEV;
+		ifr = U300_571_PXIFR;
+
+		val = readl(gpio->base + U300_571_CR);
+		dev_info(gpio->dev, "COH901571/3 block version: %d, " \
+			 "number of cores: %d totalling %d pins\n",
+			 ((val & 0x000001FC) >> 2),
+			 ((val & 0x0000FE00) >> 9),
+			 ((val & 0x0000FE00) >> 9) * 8);
+		writel(U300_571_CR_BLOCK_CLKRQ_ENABLE,
+		       gpio->base + U300_571_CR);
+		u300_gpio_init_coh901571(gpio, plat);
+	} else {
+		dev_err(gpio->dev, "unknown block variant\n");
+		err = -ENODEV;
+		goto err_unknown_variant;
+	}
+
+	/* Add each port with its IRQ separately */
+	INIT_LIST_HEAD(&gpio->port_list);
+	for (portno = 0 ; portno < plat->ports; portno++) {
+		struct u300_gpio_port *port =
+			kmalloc(sizeof(struct u300_gpio_port), GFP_KERNEL);
+
+		if (!port) {
+			dev_err(gpio->dev, "out of memory\n");
+			err = -ENOMEM;
+			goto err_no_port;
 		}
-		/* Turns off PortX_irq_force */
-		writel(0x0, virtbase + U300_GPIO_PXIFR +
-				 num_irqs * U300_GPIO_PORTX_SPACING);
+
+		snprintf(port->name, 8, "gpio%d", portno);
+		port->number = portno;
+		port->gpio = gpio;
+
+		port->irq = platform_get_irq_byname(pdev,
+						    port->name);
+
+		dev_dbg(gpio->dev, "register IRQ %d for %s\n", port->irq,
+			port->name);
+
+		irq_set_chained_handler(port->irq, u300_gpio_irq_handler);
+		irq_set_handler_data(port->irq, port);
+
+		/* For each GPIO pin set the unique IRQ handler */
+		for (i = 0; i < U300_GPIO_PINS_PER_PORT; i++) {
+			int irqno = gpio->irq_base + (portno << 3) + i;
+
+			dev_dbg(gpio->dev, "handler for IRQ %d on %s\n",
+				irqno, port->name);
+			irq_set_chip_and_handler(irqno, &u300_gpio_irqchip,
+						 handle_simple_irq);
+			set_irq_flags(irqno, IRQF_VALID);
+			irq_set_chip_data(irqno, port);
+		}
+
+		/* Turns off irq force (test register) for this port */
+		writel(0x0, gpio->base + portno * gpio->stride + ifr);
+
+		list_add_tail(&port->node, &gpio->port_list);
 	}
+	dev_dbg(gpio->dev, "initialized %d GPIO ports\n", portno);
+
+	err = gpiochip_add(&gpio->chip);
+	if (err) {
+		dev_err(gpio->dev, "unable to add gpiochip: %d\n", err);
+		goto err_no_chip;
+	}
+
+	platform_set_drvdata(pdev, gpio);
 
 	return 0;
 
- err_no_irq:
-	for (i = 0; i < num_irqs; i++)
-		free_irq(gpio_ports[i].irq, &gpio_ports[i]);
-	iounmap(virtbase);
- err_no_ioremap:
-	release_mem_region(memres->start, resource_size(memres));
- err_no_ioregion:
- err_no_resource:
-	clk_disable(clk);
- err_no_clk_enable:
-	clk_put(clk);
- err_no_clk:
-	dev_info(gpiodev, "module ERROR:%d\n", err);
+err_no_chip:
+err_no_port:
+	u300_gpio_free_ports(gpio);
+err_unknown_variant:
+	iounmap(gpio->base);
+err_no_ioremap:
+	release_mem_region(gpio->memres->start, resource_size(gpio->memres));
+err_no_ioregion:
+err_no_resource:
+	clk_disable(gpio->clk);
+err_no_clk_enable:
+	clk_put(gpio->clk);
+err_no_clk:
+	kfree(gpio);
+	dev_info(&pdev->dev, "module ERROR:%d\n", err);
 	return err;
 }
 
-static int __exit gpio_remove(struct platform_device *pdev)
+static int __exit u300_gpio_remove(struct platform_device *pdev)
 {
-	int i;
+	struct u300_gpio_platform *plat = dev_get_platdata(&pdev->dev);
+	struct u300_gpio *gpio = platform_get_drvdata(pdev);
+	int err;
 
 	/* Turn off the GPIO block */
-	writel(0x00000000U, virtbase + U300_GPIO_CR);
-	for (i = 0 ; i < U300_GPIO_NUM_PORTS; i++)
-		free_irq(gpio_ports[i].irq, &gpio_ports[i]);
-	iounmap(virtbase);
-	release_mem_region(memres->start, resource_size(memres));
-	clk_disable(clk);
-	clk_put(clk);
+	if (plat->variant == U300_GPIO_COH901335)
+		writel(0x00000000U, gpio->base + U300_335_CR);
+	if (plat->variant == U300_GPIO_COH901571_3_BS335 ||
+	    plat->variant == U300_GPIO_COH901571_3_BS365)
+		writel(0x00000000U, gpio->base + U300_571_CR);
+
+	err = gpiochip_remove(&gpio->chip);
+	if (err < 0) {
+		dev_err(gpio->dev, "unable to remove gpiochip: %d\n", err);
+		return err;
+	}
+	u300_gpio_free_ports(gpio);
+	iounmap(gpio->base);
+	release_mem_region(gpio->memres->start,
+			   resource_size(gpio->memres));
+	clk_disable(gpio->clk);
+	clk_put(gpio->clk);
+	platform_set_drvdata(pdev, NULL);
+	kfree(gpio);
 	return 0;
 }
 
-static struct platform_driver gpio_driver = {
+static struct platform_driver u300_gpio_driver = {
 	.driver		= {
 		.name	= "u300-gpio",
 	},
-	.remove		= __exit_p(gpio_remove),
+	.remove		= __exit_p(u300_gpio_remove),
 };
 
 
 static int __init u300_gpio_init(void)
 {
-	return platform_driver_probe(&gpio_driver, gpio_probe);
+	return platform_driver_probe(&u300_gpio_driver, u300_gpio_probe);
 }
 
 static void __exit u300_gpio_exit(void)
 {
-	platform_driver_unregister(&gpio_driver);
+	platform_driver_unregister(&u300_gpio_driver);
 }
 
 arch_initcall(u300_gpio_init);
 module_exit(u300_gpio_exit);
 
 MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
-
-#ifdef U300_COH901571_3
-MODULE_DESCRIPTION("ST-Ericsson AB COH 901 571/3 GPIO driver");
-#endif
-
-#ifdef U300_COH901335
-MODULE_DESCRIPTION("ST-Ericsson AB COH 901 335 GPIO driver");
-#endif
-
+MODULE_DESCRIPTION("ST-Ericsson AB COH 901 335/COH 901 571/3 GPIO driver");
 MODULE_LICENSE("GPL");
-- 
1.7.3.2

