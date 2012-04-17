Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab2DQLCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:02:09 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:43876 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab2DQLCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:02:05 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org,
        tim.gardner@canonical.com
Subject: [PATCH 17/18] ARM: mach-sa1100: retire custom LED code
Date: Tue, 17 Apr 2012 18:53:44 +0800
Message-Id: <1334660025-20442-18-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
References: <1334660025-20442-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-sa1100/Makefile       |    9 ---
 arch/arm/mach-sa1100/assabet.c      |   83 +++++++++++++++++++++++++
 arch/arm/mach-sa1100/badge4.c       |   30 ++++++++++
 arch/arm/mach-sa1100/cerf.c         |   42 +++++++++++++
 arch/arm/mach-sa1100/hackkit.c      |   32 ++++++++++
 arch/arm/mach-sa1100/lart.c         |   26 ++++++++
 arch/arm/mach-sa1100/leds-assabet.c |  113 -----------------------------------
 arch/arm/mach-sa1100/leds-badge4.c  |  110 ----------------------------------
 arch/arm/mach-sa1100/leds-cerf.c    |  109 ---------------------------------
 arch/arm/mach-sa1100/leds-hackkit.c |  111 ----------------------------------
 arch/arm/mach-sa1100/leds-lart.c    |  100 -------------------------------
 arch/arm/mach-sa1100/leds.c         |   50 ----------------
 arch/arm/mach-sa1100/leds.h         |   13 ----
 13 files changed, 213 insertions(+), 615 deletions(-)
 delete mode 100644 arch/arm/mach-sa1100/leds-assabet.c
 delete mode 100644 arch/arm/mach-sa1100/leds-badge4.c
 delete mode 100644 arch/arm/mach-sa1100/leds-cerf.c
 delete mode 100644 arch/arm/mach-sa1100/leds-hackkit.c
 delete mode 100644 arch/arm/mach-sa1100/leds-lart.c
 delete mode 100644 arch/arm/mach-sa1100/leds.c
 delete mode 100644 arch/arm/mach-sa1100/leds.h

diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 60b97ec..1aed9e7 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -7,21 +7,17 @@ obj-y := clock.o generic.o irq.o time.o #nmi-oopser.o
 obj-m :=
 obj-n :=
 obj-  :=
-led-y := leds.o
 
 obj-$(CONFIG_CPU_FREQ_SA1100)		+= cpu-sa1100.o
 obj-$(CONFIG_CPU_FREQ_SA1110)		+= cpu-sa1110.o
 
 # Specific board support
 obj-$(CONFIG_SA1100_ASSABET)		+= assabet.o
-led-$(CONFIG_SA1100_ASSABET)		+= leds-assabet.o
 obj-$(CONFIG_ASSABET_NEPONSET)		+= neponset.o
 
 obj-$(CONFIG_SA1100_BADGE4)		+= badge4.o
-led-$(CONFIG_SA1100_BADGE4)		+= leds-badge4.o
 
 obj-$(CONFIG_SA1100_CERF)		+= cerf.o
-led-$(CONFIG_SA1100_CERF)		+= leds-cerf.o
 
 obj-$(CONFIG_SA1100_COLLIE)		+= collie.o
 
@@ -29,13 +25,11 @@ obj-$(CONFIG_SA1100_H3100)		+= h3100.o h3xxx.o
 obj-$(CONFIG_SA1100_H3600)		+= h3600.o h3xxx.o
 
 obj-$(CONFIG_SA1100_HACKKIT)		+= hackkit.o
-led-$(CONFIG_SA1100_HACKKIT)		+= leds-hackkit.o
 
 obj-$(CONFIG_SA1100_JORNADA720)		+= jornada720.o
 obj-$(CONFIG_SA1100_JORNADA720_SSP)	+= jornada720_ssp.o
 
 obj-$(CONFIG_SA1100_LART)		+= lart.o
-led-$(CONFIG_SA1100_LART)		+= leds-lart.o
 
 obj-$(CONFIG_SA1100_NANOENGINE)		+= nanoengine.o
 obj-$(CONFIG_PCI_NANOENGINE)		+= pci-nanoengine.o
@@ -46,9 +40,6 @@ obj-$(CONFIG_SA1100_SHANNON)		+= shannon.o
 
 obj-$(CONFIG_SA1100_SIMPAD)		+= simpad.o
 
-# LEDs support
-obj-$(CONFIG_LEDS) += $(led-y)
-
 # Miscellaneous functions
 obj-$(CONFIG_PM)			+= pm.o sleep.o
 obj-$(CONFIG_SA1100_SSP)		+= ssp.o
diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
index 375d3f7..0e29ec2 100644
--- a/arch/arm/mach-sa1100/assabet.c
+++ b/arch/arm/mach-sa1100/assabet.c
@@ -20,6 +20,8 @@
 #include <linux/mtd/partitions.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
 
 #include <video/sa1100fb.h>
 
@@ -529,6 +531,87 @@ static void __init assabet_map_io(void)
 	sa1100_register_uart(2, 3);
 }
 
+/* LEDs */
+struct assabet_led {
+	struct led_classdev cdev;
+	u32 mask;
+};
+
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static const struct {
+	const char *name;
+	const char *trigger;
+} assabet_leds[] = {
+	{ "assabet:red", "cpu0",},
+	{ "assabet:green", "heartbeat", },
+};
+
+/*
+ * The LED control in Assabet is reversed:
+ *  - setting bit means turn off LED
+ *  - clearing bit means turn on LED
+ */
+static void assabet_led_set(struct led_classdev *cdev,
+		enum led_brightness b)
+{
+	struct assabet_led *led = container_of(cdev,
+			struct assabet_led, cdev);
+
+	if (b != LED_OFF)
+		ASSABET_BCR_clear(led->mask);
+	else
+		ASSABET_BCR_set(led->mask);
+}
+
+static enum led_brightness assabet_led_get(struct led_classdev *cdev)
+{
+	struct assabet_led *led = container_of(cdev,
+			struct assabet_led, cdev);
+
+	return (ASSABET_BCR & led->mask) ? LED_OFF : LED_FULL;
+}
+
+static int __init assabet_leds_init(void)
+{
+	int i;
+
+	if (!machine_is_assabet())
+		return -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(assabet_leds); i++) {
+		struct assabet_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+		led->cdev.name = assabet_leds[i].name;
+		led->cdev.brightness_set = assabet_led_set;
+		led->cdev.brightness_get = assabet_led_get;
+		led->cdev.default_trigger = assabet_leds[i].trigger;
+
+		if (!i)
+			led->mask = ASSABET_BCR_LED_RED;
+		else
+			led->mask = ASSABET_BCR_LED_GREEN;
+
+		if (led_classdev_register(NULL, &led->cdev) < 0) {
+			kfree(led);
+			break;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Since we may have triggers on any subsystem, defer registration
+ * until after subsystem_init.
+ */
+fs_initcall(assabet_leds_init);
 
 MACHINE_START(ASSABET, "Intel-Assabet")
 	.atag_offset	= 0x100,
diff --git a/arch/arm/mach-sa1100/badge4.c b/arch/arm/mach-sa1100/badge4.c
index e0f0c03..58b2d95 100644
--- a/arch/arm/mach-sa1100/badge4.c
+++ b/arch/arm/mach-sa1100/badge4.c
@@ -22,6 +22,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/errno.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -76,8 +78,36 @@ static struct platform_device sa1111_device = {
 	.resource	= sa1111_resources,
 };
 
+/* LEDs */
+struct gpio_led badge4_gpio_leds[] = {
+	{
+		.name			= "badge4:red",
+		.default_trigger	= "heartbeat",
+		.gpio			= 7,
+	},
+	{
+		.name			= "badge4:green",
+		.default_trigger	= "cpu0",
+		.gpio			= 9,
+	},
+};
+
+static struct gpio_led_platform_data badge4_gpio_led_info = {
+	.leds		= badge4_gpio_leds,
+	.num_leds	= ARRAY_SIZE(badge4_gpio_leds),
+};
+
+static struct platform_device badge4_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &badge4_gpio_led_info,
+	}
+};
+
 static struct platform_device *devices[] __initdata = {
 	&sa1111_device,
+	&badge4_leds,
 };
 
 static int __init badge4_sa1111_init(void)
diff --git a/arch/arm/mach-sa1100/cerf.c b/arch/arm/mach-sa1100/cerf.c
index 4a61f60..c4edf2e 100644
--- a/arch/arm/mach-sa1100/cerf.c
+++ b/arch/arm/mach-sa1100/cerf.c
@@ -17,6 +17,8 @@
 #include <linux/irq.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
 
 #include <mach/hardware.h>
 #include <asm/setup.h>
@@ -43,8 +45,48 @@ static struct platform_device cerfuart2_device = {
 	.resource	= cerfuart2_resources,
 };
 
+/* LEDs */
+struct gpio_led cerf_gpio_leds[] = {
+	{
+		.name			= "cerf:d0",
+		.default_trigger	= "heartbeat",
+		.gpio			= 0,
+	},
+	{
+		.name			= "cerf:d1",
+		.default_trigger	= "cpu0",
+		.gpio			= 1,
+	},
+	{
+		.name			= "cerf:d2",
+		.default_trigger	= "default-on",
+		.gpio			= 2,
+	},
+	{
+		.name			= "cerf:d3",
+		.default_trigger	= "default-on",
+		.gpio			= 3,
+	},
+
+};
+
+static struct gpio_led_platform_data cerf_gpio_led_info = {
+	.leds		= cerf_gpio_leds,
+	.num_leds	= ARRAY_SIZE(cerf_gpio_leds),
+};
+
+static struct platform_device cerf_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &cerf_gpio_led_info,
+	}
+};
+
+
 static struct platform_device *cerf_devices[] __initdata = {
 	&cerfuart2_device,
+	&cerf_leds,
 };
 
 #ifdef CONFIG_SA1100_CERF_FLASH_32MB
diff --git a/arch/arm/mach-sa1100/hackkit.c b/arch/arm/mach-sa1100/hackkit.c
index 5535475..85e82ab 100644
--- a/arch/arm/mach-sa1100/hackkit.c
+++ b/arch/arm/mach-sa1100/hackkit.c
@@ -21,6 +21,10 @@
 #include <linux/serial_core.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/tty.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
 
 #include <asm/mach-types.h>
 #include <asm/setup.h>
@@ -183,9 +187,37 @@ static struct flash_platform_data hackkit_flash_data = {
 static struct resource hackkit_flash_resource =
 	DEFINE_RES_MEM(SA1100_CS0_PHYS, SZ_32M);
 
+/* LEDs */
+struct gpio_led hackkit_gpio_leds[] = {
+	{
+		.name			= "hackkit:red",
+		.default_trigger	= "cpu0",
+		.gpio			= 22,
+	},
+	{
+		.name			= "hackkit:green",
+		.default_trigger	= "heartbeat",
+		.gpio			= 23,
+	},
+};
+
+static struct gpio_led_platform_data hackkit_gpio_led_info = {
+	.leds		= hackkit_gpio_leds,
+	.num_leds	= ARRAY_SIZE(hackkit_gpio_leds),
+};
+
+static struct platform_device hackkit_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &hackkit_gpio_led_info,
+	}
+};
+
 static void __init hackkit_init(void)
 {
 	sa11x0_register_mtd(&hackkit_flash_data, &hackkit_flash_resource, 1);
+	platform_device_register(&hackkit_leds);
 }
 
 /**********************************************************************
diff --git a/arch/arm/mach-sa1100/lart.c b/arch/arm/mach-sa1100/lart.c
index eb6534e..9a4b4ab 100644
--- a/arch/arm/mach-sa1100/lart.c
+++ b/arch/arm/mach-sa1100/lart.c
@@ -5,6 +5,9 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/tty.h>
+#include <linux/gpio.h>
+#include <linux/leds.h>
+#include <linux/platform_device.h>
 
 #include <video/sa1100fb.h>
 
@@ -126,6 +129,27 @@ static struct map_desc lart_io_desc[] __initdata = {
 	}
 };
 
+/* LEDs */
+struct gpio_led lart_gpio_leds[] = {
+	{
+		.name			= "lart:red",
+		.default_trigger	= "cpu0",
+		.gpio			= 23,
+	},
+};
+
+static struct gpio_led_platform_data lart_gpio_led_info = {
+	.leds		= lart_gpio_leds,
+	.num_leds	= ARRAY_SIZE(lart_gpio_leds),
+};
+
+static struct platform_device lart_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &lart_gpio_led_info,
+	}
+};
 static void __init lart_map_io(void)
 {
 	sa1100_map_io();
@@ -139,6 +163,8 @@ static void __init lart_map_io(void)
 	GPDR |= GPIO_UART_TXD;
 	GPDR &= ~GPIO_UART_RXD;
 	PPAR |= PPAR_UPR;
+
+	platform_device_register(&lart_leds);
 }
 
 MACHINE_START(LART, "LART")
diff --git a/arch/arm/mach-sa1100/leds-assabet.c b/arch/arm/mach-sa1100/leds-assabet.c
deleted file mode 100644
index 3699176..0000000
--- a/arch/arm/mach-sa1100/leds-assabet.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/leds-assabet.c
- *
- * Copyright (C) 2000 John Dorsey <john+@cs.cmu.edu>
- *
- * Original (leds-footbridge.c) by Russell King
- *
- * Assabet uses the LEDs as follows:
- *   - Green - toggles state every 50 timer interrupts
- *   - Red   - on if system is not idle
- */
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <mach/assabet.h>
-
-#include "leds.h"
-
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-#define ASSABET_BCR_LED_MASK	(ASSABET_BCR_LED_GREEN | ASSABET_BCR_LED_RED)
-
-void assabet_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch (evt) {
-	case led_start:
-		hw_led_state = ASSABET_BCR_LED_RED | ASSABET_BCR_LED_GREEN;
-		led_state = LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		hw_led_state = ASSABET_BCR_LED_RED | ASSABET_BCR_LED_GREEN;
-		ASSABET_BCR_frob(ASSABET_BCR_LED_MASK, hw_led_state);
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = ASSABET_BCR_LED_RED | ASSABET_BCR_LED_GREEN;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = ASSABET_BCR_LED_RED | ASSABET_BCR_LED_GREEN;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= ASSABET_BCR_LED_GREEN;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= ASSABET_BCR_LED_RED;
-		break;
-
-	case led_idle_end:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~ASSABET_BCR_LED_RED;
-		break;
-#endif
-
-	case led_halted:
-		break;
-
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~ASSABET_BCR_LED_GREEN;
-		break;
-
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= ASSABET_BCR_LED_GREEN;
-		break;
-
-	case led_amber_on:
-		break;
-
-	case led_amber_off:
-		break;
-
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~ASSABET_BCR_LED_RED;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= ASSABET_BCR_LED_RED;
-		break;
-
-	default:
-		break;
-	}
-
-	if  (led_state & LED_STATE_ENABLED)
-		ASSABET_BCR_frob(ASSABET_BCR_LED_MASK, hw_led_state);
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-sa1100/leds-badge4.c b/arch/arm/mach-sa1100/leds-badge4.c
deleted file mode 100644
index f99fac3..0000000
--- a/arch/arm/mach-sa1100/leds-badge4.c
+++ /dev/null
@@ -1,110 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/leds-badge4.c
- *
- * Author: Christopher Hoover <ch@hpl.hp.com>
- * Copyright (C) 2002 Hewlett-Packard Company
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include "leds.h"
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-#define LED_RED		GPIO_GPIO(7)
-#define LED_GREEN       GPIO_GPIO(9)
-#define LED_MASK	(LED_RED|LED_GREEN)
-
-#define LED_IDLE	LED_GREEN
-#define LED_TIMER	LED_RED
-
-void badge4_leds_event(led_event_t evt)
-{
-        unsigned long flags;
-
-	local_irq_save(flags);
-
-        switch (evt) {
-        case led_start:
-		GPDR |= LED_MASK;
-                hw_led_state = LED_MASK;
-                led_state = LED_STATE_ENABLED;
-                break;
-
-        case led_stop:
-                led_state &= ~LED_STATE_ENABLED;
-                break;
-
-        case led_claim:
-                led_state |= LED_STATE_CLAIMED;
-                hw_led_state = LED_MASK;
-                break;
-
-        case led_release:
-                led_state &= ~LED_STATE_CLAIMED;
-                hw_led_state = LED_MASK;
-                break;
-
-#ifdef CONFIG_LEDS_TIMER
-        case led_timer:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state ^= LED_TIMER;
-                break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-        case led_idle_start:
-		/* LED off when system is idle */
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_IDLE;
-                break;
-
-        case led_idle_end:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_IDLE;
-                break;
-#endif
-
-        case led_red_on:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_RED;
-                break;
-
-        case led_red_off:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_RED;
-                break;
-
-        case led_green_on:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_GREEN;
-                break;
-
-        case led_green_off:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_GREEN;
-                break;
-
-	default:
-		break;
-        }
-
-        if  (led_state & LED_STATE_ENABLED) {
-                GPSR = hw_led_state;
-                GPCR = hw_led_state ^ LED_MASK;
-        }
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-sa1100/leds-cerf.c b/arch/arm/mach-sa1100/leds-cerf.c
deleted file mode 100644
index 040540f..0000000
--- a/arch/arm/mach-sa1100/leds-cerf.c
+++ /dev/null
@@ -1,109 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/leds-cerf.c
- *
- * Author: ???
- */
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include "leds.h"
-
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-#define LED_D0          GPIO_GPIO(0)
-#define LED_D1          GPIO_GPIO(1)
-#define LED_D2          GPIO_GPIO(2)
-#define LED_D3          GPIO_GPIO(3)
-#define LED_MASK        (LED_D0|LED_D1|LED_D2|LED_D3)
-
-void cerf_leds_event(led_event_t evt)
-{
-        unsigned long flags;
-
-	local_irq_save(flags);
-
-        switch (evt) {
-        case led_start:
-                hw_led_state = LED_MASK;
-                led_state = LED_STATE_ENABLED;
-                break;
-
-        case led_stop:
-                led_state &= ~LED_STATE_ENABLED;
-                break;
-
-        case led_claim:
-                led_state |= LED_STATE_CLAIMED;
-                hw_led_state = LED_MASK;
-                break;
-        case led_release:
-                led_state &= ~LED_STATE_CLAIMED;
-                hw_led_state = LED_MASK;
-                break;
-
-#ifdef CONFIG_LEDS_TIMER
-        case led_timer:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state ^= LED_D0;
-                break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-        case led_idle_start:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_D1;
-                break;
-
-        case led_idle_end:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_D1;
-                break;
-#endif
-        case led_green_on:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_D2;
-                break;
-
-        case led_green_off:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_D2;
-                break;
-
-        case led_amber_on:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_D3;
-                break;
-
-        case led_amber_off:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_D3;
-                break;
-
-        case led_red_on:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state &= ~LED_D1;
-                break;
-
-        case led_red_off:
-                if (!(led_state & LED_STATE_CLAIMED))
-                        hw_led_state |= LED_D1;
-                break;
-
-        default:
-                break;
-        }
-
-        if  (led_state & LED_STATE_ENABLED) {
-                GPSR = hw_led_state;
-                GPCR = hw_led_state ^ LED_MASK;
-        }
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-sa1100/leds-hackkit.c b/arch/arm/mach-sa1100/leds-hackkit.c
deleted file mode 100644
index 6a23524..0000000
--- a/arch/arm/mach-sa1100/leds-hackkit.c
+++ /dev/null
@@ -1,111 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/leds-hackkit.c
- *
- * based on leds-lart.c
- *
- * (C) Erik Mouw (J.A.K.Mouw@its.tudelft.nl), April 21, 2000
- * (C) Stefan Eletzhofer <stefan.eletzhofer@eletztrick.de>, 2002
- *
- * The HackKit has two leds (GPIO 22/23). The red led (gpio 22) is used
- * as cpu led, the green one is used as timer led.
- */
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include "leds.h"
-
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-#define LED_GREEN    GPIO_GPIO23
-#define LED_RED    GPIO_GPIO22
-#define LED_MASK  (LED_RED | LED_GREEN)
-
-void hackkit_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch(evt) {
-		case led_start:
-			/* pin 22/23 are outputs */
-			GPDR |= LED_MASK;
-			hw_led_state = LED_MASK;
-			led_state = LED_STATE_ENABLED;
-			break;
-
-		case led_stop:
-			led_state &= ~LED_STATE_ENABLED;
-			break;
-
-		case led_claim:
-			led_state |= LED_STATE_CLAIMED;
-			hw_led_state = LED_MASK;
-			break;
-
-		case led_release:
-			led_state &= ~LED_STATE_CLAIMED;
-			hw_led_state = LED_MASK;
-			break;
-
-#ifdef CONFIG_LEDS_TIMER
-		case led_timer:
-			if (!(led_state & LED_STATE_CLAIMED))
-				hw_led_state ^= LED_GREEN;
-			break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-		case led_idle_start:
-			/* The LART people like the LED to be off when the
-			   system is idle... */
-			if (!(led_state & LED_STATE_CLAIMED))
-				hw_led_state &= ~LED_RED;
-			break;
-
-		case led_idle_end:
-			/* ... and on if the system is not idle */
-			if (!(led_state & LED_STATE_CLAIMED))
-				hw_led_state |= LED_RED;
-			break;
-#endif
-
-		case led_red_on:
-			if (led_state & LED_STATE_CLAIMED)
-				hw_led_state &= ~LED_RED;
-			break;
-
-		case led_red_off:
-			if (led_state & LED_STATE_CLAIMED)
-				hw_led_state |= LED_RED;
-			break;
-
-		case led_green_on:
-			if (led_state & LED_STATE_CLAIMED)
-				hw_led_state &= ~LED_GREEN;
-			break;
-
-		case led_green_off:
-			if (led_state & LED_STATE_CLAIMED)
-				hw_led_state |= LED_GREEN;
-			break;
-
-		default:
-			break;
-	}
-
-	/* Now set the GPIO state, or nothing will happen at all */
-	if (led_state & LED_STATE_ENABLED) {
-		GPSR = hw_led_state;
-		GPCR = hw_led_state ^ LED_MASK;
-	}
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-sa1100/leds-lart.c b/arch/arm/mach-sa1100/leds-lart.c
deleted file mode 100644
index a51830c..0000000
--- a/arch/arm/mach-sa1100/leds-lart.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/leds-lart.c
- *
- * (C) Erik Mouw (J.A.K.Mouw@its.tudelft.nl), April 21, 2000
- *
- * LART uses the LED as follows:
- *   - GPIO23 is the LED, on if system is not idle
- *  You can use both CONFIG_LEDS_CPU and CONFIG_LEDS_TIMER at the same
- *  time, but in that case the timer events will still dictate the
- *  pace of the LED.
- */
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include "leds.h"
-
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-#define LED_23    GPIO_GPIO23
-#define LED_MASK  (LED_23)
-
-void lart_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch(evt) {
-	case led_start:
-		/* pin 23 is output pin */
-		GPDR |= LED_23;
-		hw_led_state = LED_MASK;
-		led_state = LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = LED_MASK;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = LED_MASK;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= LED_23;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		/* The LART people like the LED to be off when the
-                   system is idle... */
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~LED_23;
-		break;
-
-	case led_idle_end:
-		/* ... and on if the system is not idle */
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= LED_23;
-		break;
-#endif
-
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~LED_23;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= LED_23;
-		break;
-
-	default:
-		break;
-	}
-
-	/* Now set the GPIO state, or nothing will happen at all */
-	if (led_state & LED_STATE_ENABLED) {
-		GPSR = hw_led_state;
-		GPCR = hw_led_state ^ LED_MASK;
-	}
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-sa1100/leds.c b/arch/arm/mach-sa1100/leds.c
deleted file mode 100644
index 5fe71a0..0000000
--- a/arch/arm/mach-sa1100/leds.c
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * linux/arch/arm/mach-sa1100/leds.c
- *
- * SA1100 LEDs dispatcher
- *
- * Copyright (C) 2001 Nicolas Pitre
- */
-#include <linux/compiler.h>
-#include <linux/init.h>
-
-#include <asm/leds.h>
-#include <asm/mach-types.h>
-
-#include "leds.h"
-
-static int __init
-sa1100_leds_init(void)
-{
-	if (machine_is_assabet())
-		leds_event = assabet_leds_event;
-	if (machine_is_consus())
-		leds_event = consus_leds_event;
-	if (machine_is_badge4())
-		leds_event = badge4_leds_event;
-	if (machine_is_brutus())
-		leds_event = brutus_leds_event;
-	if (machine_is_cerf())
-		leds_event = cerf_leds_event;
-	if (machine_is_flexanet())
-		leds_event = flexanet_leds_event;
-	if (machine_is_graphicsclient())
-		leds_event = graphicsclient_leds_event;
-	if (machine_is_hackkit())
-		leds_event = hackkit_leds_event;
-	if (machine_is_lart())
-		leds_event = lart_leds_event;
-	if (machine_is_pfs168())
-		leds_event = pfs168_leds_event;
-	if (machine_is_graphicsmaster())
-		leds_event = graphicsmaster_leds_event;
-	if (machine_is_adsbitsy())
-		leds_event = adsbitsy_leds_event;
-	if (machine_is_pt_system3())
-		leds_event = system3_leds_event;
-
-	leds_event(led_start);
-	return 0;
-}
-
-core_initcall(sa1100_leds_init);
diff --git a/arch/arm/mach-sa1100/leds.h b/arch/arm/mach-sa1100/leds.h
deleted file mode 100644
index 776b602..0000000
--- a/arch/arm/mach-sa1100/leds.h
+++ /dev/null
@@ -1,13 +0,0 @@
-extern void assabet_leds_event(led_event_t evt);
-extern void badge4_leds_event(led_event_t evt);
-extern void consus_leds_event(led_event_t evt);
-extern void brutus_leds_event(led_event_t evt);
-extern void cerf_leds_event(led_event_t evt);
-extern void flexanet_leds_event(led_event_t evt);
-extern void graphicsclient_leds_event(led_event_t evt);
-extern void hackkit_leds_event(led_event_t evt);
-extern void lart_leds_event(led_event_t evt);
-extern void pfs168_leds_event(led_event_t evt);
-extern void graphicsmaster_leds_event(led_event_t evt);
-extern void adsbitsy_leds_event(led_event_t evt);
-extern void system3_leds_event(led_event_t evt);
-- 
1.7.9.5

