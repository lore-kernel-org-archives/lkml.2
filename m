Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958Ab2DML3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:29:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2DML3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:29:18 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: [PATCH 11/18] ARM: mach-footbridge: retire custom LED code
Date: Fri, 13 Apr 2012 19:26:10 +0800
Message-Id: <1334316377-23915-12-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-footbridge/Makefile         |    4 -
 arch/arm/mach-footbridge/ebsa285-leds.c   |  138 -----------------------------
 arch/arm/mach-footbridge/ebsa285.c        |   79 +++++++++++++++++
 arch/arm/mach-footbridge/netwinder-hw.c   |  110 ++++++++++++++++++++---
 arch/arm/mach-footbridge/netwinder-leds.c |  138 -----------------------------
 5 files changed, 175 insertions(+), 294 deletions(-)
 delete mode 100644 arch/arm/mach-footbridge/ebsa285-leds.c
 delete mode 100644 arch/arm/mach-footbridge/netwinder-leds.c

diff --git a/arch/arm/mach-footbridge/Makefile b/arch/arm/mach-footbridge/Makefile
index 3afb1b2..0b64dd4 100644
--- a/arch/arm/mach-footbridge/Makefile
+++ b/arch/arm/mach-footbridge/Makefile
@@ -14,15 +14,11 @@ pci-$(CONFIG_ARCH_EBSA285_HOST) += ebsa285-pci.o
 pci-$(CONFIG_ARCH_NETWINDER) += netwinder-pci.o
 pci-$(CONFIG_ARCH_PERSONAL_SERVER) += personal-pci.o
 
-leds-$(CONFIG_ARCH_EBSA285) += ebsa285-leds.o
-leds-$(CONFIG_ARCH_NETWINDER) += netwinder-leds.o
-
 obj-$(CONFIG_ARCH_CATS) += cats-hw.o isa-timer.o
 obj-$(CONFIG_ARCH_EBSA285) += ebsa285.o dc21285-timer.o
 obj-$(CONFIG_ARCH_NETWINDER) += netwinder-hw.o isa-timer.o
 obj-$(CONFIG_ARCH_PERSONAL_SERVER) += personal.o dc21285-timer.o
 
 obj-$(CONFIG_PCI)	+=$(pci-y)
-obj-$(CONFIG_LEDS)	+=$(leds-y)
 
 obj-$(CONFIG_ISA)	+= isa.o isa-rtc.o
diff --git a/arch/arm/mach-footbridge/ebsa285-leds.c b/arch/arm/mach-footbridge/ebsa285-leds.c
deleted file mode 100644
index 5bd2667..0000000
--- a/arch/arm/mach-footbridge/ebsa285-leds.c
+++ /dev/null
@@ -1,138 +0,0 @@
-/*
- *  linux/arch/arm/mach-footbridge/ebsa285-leds.c
- *
- *  Copyright (C) 1998-1999 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- * EBSA-285 control routines.
- *
- * The EBSA-285 uses the leds as follows:
- *  - Green - toggles state every 50 timer interrupts
- *  - Amber - On if system is not idle
- *  - Red   - currently unused
- *
- * Changelog:
- *   02-05-1999	RMK	Various cleanups
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <asm/mach-types.h>
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-static char led_state;
-static char hw_led_state;
-
-static DEFINE_SPINLOCK(leds_lock);
-
-static void ebsa285_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&leds_lock, flags);
-
-	switch (evt) {
-	case led_start:
-		hw_led_state = XBUS_LED_RED | XBUS_LED_GREEN;
-#ifndef CONFIG_LEDS_CPU
-		hw_led_state |= XBUS_LED_AMBER;
-#endif
-		led_state |= LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = XBUS_LED_RED | XBUS_LED_GREEN | XBUS_LED_AMBER;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = XBUS_LED_RED | XBUS_LED_GREEN | XBUS_LED_AMBER;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= XBUS_LED_GREEN;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= XBUS_LED_AMBER;
-		break;
-
-	case led_idle_end:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~XBUS_LED_AMBER;
-		break;
-#endif
-
-	case led_halted:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~XBUS_LED_RED;
-		break;
-
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~XBUS_LED_GREEN;
-		break;
-
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= XBUS_LED_GREEN;
-		break;
-
-	case led_amber_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~XBUS_LED_AMBER;
-		break;
-
-	case led_amber_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= XBUS_LED_AMBER;
-		break;
-
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~XBUS_LED_RED;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= XBUS_LED_RED;
-		break;
-
-	default:
-		break;
-	}
-
-	if  (led_state & LED_STATE_ENABLED)
-		*XBUS_LEDS = hw_led_state;
-
-	spin_unlock_irqrestore(&leds_lock, flags);
-}
-
-static int __init leds_init(void)
-{
-	if (machine_is_ebsa285())
-		leds_event = ebsa285_leds_event;
-
-	leds_event(led_start);
-
-	return 0;
-}
-
-__initcall(leds_init);
diff --git a/arch/arm/mach-footbridge/ebsa285.c b/arch/arm/mach-footbridge/ebsa285.c
index 27716a7..2ab83c3 100644
--- a/arch/arm/mach-footbridge/ebsa285.c
+++ b/arch/arm/mach-footbridge/ebsa285.c
@@ -5,6 +5,8 @@
  */
 #include <linux/init.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <asm/hardware/dec21285.h>
 #include <asm/mach-types.h>
@@ -13,6 +15,83 @@
 
 #include "common.h"
 
+/* LEDs */
+struct ebsa285_led {
+	struct led_classdev     cdev;
+	u8                      mask;
+};
+
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static const struct {
+	const char *name;
+	const char *trigger;
+} ebsa285_leds[] = {
+	{ "ebsa285:amber", "heartbeat", },
+	{ "ebsa285:green", "cpu0", },
+	{ "ebsa285:red",},
+};
+
+static void ebsa285_led_set(struct led_classdev *cdev,
+		enum led_brightness b)
+{
+	struct ebsa285_led *led = container_of(cdev,
+			struct ebsa285_led, cdev);
+
+	if (b != LED_OFF)
+		*XBUS_LEDS |= led->mask;
+	else
+		*XBUS_LEDS &= ~led->mask;
+}
+
+static enum led_brightness ebsa285_led_get(struct led_classdev *cdev)
+{
+	struct ebsa285_led *led = container_of(cdev,
+			struct ebsa285_led, cdev);
+
+	return (*XBUS_LEDS & led->mask) ? LED_FULL : LED_OFF;
+}
+
+static int __init ebsa285_leds_init(void)
+{
+	int i;
+
+	if (machine_is_ebsa285())
+		return -ENODEV;
+
+	/* 3 LEDS All ON */
+	*XBUS_LEDS |= XBUS_LED_AMBER | XBUS_LED_GREEN | XBUS_LED_RED;
+
+	for (i = 0; i < ARRAY_SIZE(ebsa285_leds); i++) {
+		struct ebsa285_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+		led->cdev.name = ebsa285_leds[i].name;
+		led->cdev.brightness_set = ebsa285_led_set;
+		led->cdev.brightness_get = ebsa285_led_get;
+		led->cdev.default_trigger = ebsa285_leds[i].trigger;
+		led->mask = BIT(i);
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
+fs_initcall(ebsa285_leds_init);
+
 MACHINE_START(EBSA285, "EBSA285")
 	/* Maintainer: Russell King */
 	.atag_offset	= 0x100,
diff --git a/arch/arm/mach-footbridge/netwinder-hw.c b/arch/arm/mach-footbridge/netwinder-hw.c
index cac9f67..a0a31bb 100644
--- a/arch/arm/mach-footbridge/netwinder-hw.c
+++ b/arch/arm/mach-footbridge/netwinder-hw.c
@@ -12,9 +12,10 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <asm/hardware/dec21285.h>
-#include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/setup.h>
 #include <asm/system_misc.h>
@@ -27,13 +28,6 @@
 #define GP1_IO_BASE		0x338
 #define GP2_IO_BASE		0x33a
 
-
-#ifdef CONFIG_LEDS
-#define DEFAULT_LEDS	0
-#else
-#define DEFAULT_LEDS	GPIO_GREEN_LED
-#endif
-
 /*
  * Winbond WB83977F accessibility stuff
  */
@@ -611,15 +605,9 @@ static void __init rwa010_init(void)
 static int __init nw_hw_init(void)
 {
 	if (machine_is_netwinder()) {
-		unsigned long flags;
-
 		wb977_init();
 		cpld_init();
 		rwa010_init();
-
-		raw_spin_lock_irqsave(&nw_gpio_lock, flags);
-		nw_gpio_modify_op(GPIO_RED_LED|GPIO_GREEN_LED, DEFAULT_LEDS);
-		raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
 	}
 	return 0;
 }
@@ -672,6 +660,100 @@ static void netwinder_restart(char mode, const char *cmd)
 	}
 }
 
+/* LEDs */
+struct netwinder_led {
+	struct led_classdev     cdev;
+	u8                      mask;
+};
+
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static const struct {
+	const char *name;
+	const char *trigger;
+} netwinder_leds[] = {
+	{ "netwinder:green", "heartbeat", },
+	{ "netwinder:red", "cpu0", },
+};
+
+/*
+ * The LED control in Netwinder is reversed:
+ *  - setting bit means turn off LED
+ *  - clearing bit means turn on LED
+ */
+static void netwinder_led_set(struct led_classdev *cdev,
+		enum led_brightness b)
+{
+	struct netwinder_led *led = container_of(cdev,
+			struct netwinder_led, cdev);
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&nw_gpio_lock, flags);
+	reg = nw_gpio_read();
+	if (b != LED_OFF)
+		reg &= ~led->mask;
+	else
+		reg |= led->mask;
+	nw_gpio_modify_op(led->mask, reg);
+	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+}
+
+static enum led_brightness netwinder_led_get(struct led_classdev *cdev)
+{
+	struct netwinder_led *led = container_of(cdev,
+			struct netwinder_led, cdev);
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&nw_gpio_lock, flags);
+	reg = nw_gpio_read();
+	spin_unlock_irqrestore(&nw_gpio_lock, flags);
+
+	return (reg & led->mask) ? LED_OFF : LED_FULL;
+}
+
+static int __init netwinder_leds_init(void)
+{
+	int i;
+
+	if (!machine_is_netwinder())
+		return -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(netwinder_leds); i++) {
+		struct netwinder_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+		led->cdev.name = netwinder_leds[i].name;
+		led->cdev.brightness_set = netwinder_led_set;
+		led->cdev.brightness_get = netwinder_led_get;
+		led->cdev.default_trigger = netwinder_leds[i].trigger;
+
+		if (i == 0)
+			led->mask = GPIO_GREEN_LED;
+		else
+			led->mask = GPIO_RED_LED;
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
+fs_initcall(netwinder_leds_init);
+
 MACHINE_START(NETWINDER, "Rebel-NetWinder")
 	/* Maintainer: Russell King/Rebel.com */
 	.atag_offset	= 0x100,
diff --git a/arch/arm/mach-footbridge/netwinder-leds.c b/arch/arm/mach-footbridge/netwinder-leds.c
deleted file mode 100644
index 5a2bd89..0000000
--- a/arch/arm/mach-footbridge/netwinder-leds.c
+++ /dev/null
@@ -1,138 +0,0 @@
-/*
- *  linux/arch/arm/mach-footbridge/netwinder-leds.c
- *
- *  Copyright (C) 1998-1999 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * NetWinder LED control routines.
- *
- * The Netwinder uses the leds as follows:
- *  - Green - toggles state every 50 timer interrupts
- *  - Red   - On if the system is not idle
- *
- * Changelog:
- *   02-05-1999	RMK	Various cleanups
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <asm/mach-types.h>
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-static char led_state;
-static char hw_led_state;
-
-static DEFINE_RAW_SPINLOCK(leds_lock);
-
-static void netwinder_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&leds_lock, flags);
-
-	switch (evt) {
-	case led_start:
-		led_state |= LED_STATE_ENABLED;
-		hw_led_state = GPIO_GREEN_LED;
-		break;
-
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = 0;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= GPIO_GREEN_LED;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~GPIO_RED_LED;
-		break;
-
-	case led_idle_end:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= GPIO_RED_LED;
-		break;
-#endif
-
-	case led_halted:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= GPIO_RED_LED;
-		break;
-
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= GPIO_GREEN_LED;
-		break;
-
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~GPIO_GREEN_LED;
-		break;
-
-	case led_amber_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= GPIO_GREEN_LED | GPIO_RED_LED;
-		break;
-
-	case led_amber_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~(GPIO_GREEN_LED | GPIO_RED_LED);
-		break;
-
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= GPIO_RED_LED;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~GPIO_RED_LED;
-		break;
-
-	default:
-		break;
-	}
-
-	raw_spin_unlock_irqrestore(&leds_lock, flags);
-
-	if  (led_state & LED_STATE_ENABLED) {
-		raw_spin_lock_irqsave(&nw_gpio_lock, flags);
-		nw_gpio_modify_op(GPIO_RED_LED | GPIO_GREEN_LED, hw_led_state);
-		raw_spin_unlock_irqrestore(&nw_gpio_lock, flags);
-	}
-}
-
-static int __init leds_init(void)
-{
-	if (machine_is_netwinder())
-		leds_event = netwinder_leds_event;
-
-	leds_event(led_start);
-
-	return 0;
-}
-
-__initcall(leds_init);
-- 
1.7.9.5

