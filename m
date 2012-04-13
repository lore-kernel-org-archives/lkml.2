Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973Ab2DML3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:29:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab2DML3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:29:46 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        arnd.bergmann@linaro.org, nicolas.pitre@linaro.org
Subject: [PATCH 13/18] ARM: mach-pxa: retire custom LED code
Date: Fri, 13 Apr 2012 19:26:12 +0800
Message-Id: <1334316377-23915-14-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
References: <1334316377-23915-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-pxa/Makefile         |    8 ---
 arch/arm/mach-pxa/idp.c            |   79 +++++++++++++++++++++++
 arch/arm/mach-pxa/leds-idp.c       |  115 ---------------------------------
 arch/arm/mach-pxa/leds-lubbock.c   |  124 ------------------------------------
 arch/arm/mach-pxa/leds-mainstone.c |  119 ----------------------------------
 arch/arm/mach-pxa/leds.c           |   32 ----------
 arch/arm/mach-pxa/leds.h           |   13 ----
 arch/arm/mach-pxa/lubbock.c        |   93 +++++++++++++++++++++++++++
 arch/arm/mach-pxa/mainstone.c      |   92 ++++++++++++++++++++++++++
 9 files changed, 264 insertions(+), 411 deletions(-)
 delete mode 100644 arch/arm/mach-pxa/leds-idp.c
 delete mode 100644 arch/arm/mach-pxa/leds-lubbock.c
 delete mode 100644 arch/arm/mach-pxa/leds-mainstone.c
 delete mode 100644 arch/arm/mach-pxa/leds.c
 delete mode 100644 arch/arm/mach-pxa/leds.h

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index be0f7df..d4337e3 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -95,12 +95,4 @@ obj-$(CONFIG_MACH_RAUMFELD_CONNECTOR)	+= raumfeld.o
 obj-$(CONFIG_MACH_RAUMFELD_SPEAKER)	+= raumfeld.o
 obj-$(CONFIG_MACH_ZIPIT2)	+= z2.o
 
-# Support for blinky lights
-led-y := leds.o
-led-$(CONFIG_ARCH_LUBBOCK)	+= leds-lubbock.o
-led-$(CONFIG_MACH_MAINSTONE)	+= leds-mainstone.o
-led-$(CONFIG_ARCH_PXA_IDP)	+= leds-idp.o
-
-obj-$(CONFIG_LEDS)		+= $(led-y)
-
 obj-$(CONFIG_TOSA_BT)		+= tosa-bt.o
diff --git a/arch/arm/mach-pxa/idp.c b/arch/arm/mach-pxa/idp.c
index 6ff466b..3c58d95 100644
--- a/arch/arm/mach-pxa/idp.c
+++ b/arch/arm/mach-pxa/idp.c
@@ -191,6 +191,85 @@ static void __init idp_map_io(void)
 	iotable_init(idp_io_desc, ARRAY_SIZE(idp_io_desc));
 }
 
+/* LEDs */
+struct idp_led {
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
+} idp_leds[] = {
+	{ "idp:green", "heartbeat", },
+	{ "idp:red", "cpu0", },
+};
+
+static void idp_led_set(struct led_classdev *cdev,
+		enum led_brightness b)
+{
+	struct idp_led *led = container_of(cdev,
+			struct idp_led, cdev);
+	u32 reg = IDP_CPLD_LED_CONTROL;
+
+	if (b != LED_OFF)
+		reg &= ~led->mask;
+	else
+		reg |= led->mask;
+
+	IDP_CPLD_LED_CONTROL = reg;
+}
+
+static enum led_brightness idp_led_get(struct led_classdev *cdev)
+{
+	struct idp_led *led = container_of(cdev,
+			struct idp_led, cdev);
+
+	return (IDP_CPLD_LED_CONTROL & led->mask) ? LED_OFF : LED_FULL;
+}
+
+static int __init idp_leds_init(void)
+{
+	int i;
+
+	if (!machine_is_pxa_idp())
+		return -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(idp_leds); i++) {
+		struct idp_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+		led->cdev.name = idp_leds[i].name;
+		led->cdev.brightness_set = idp_led_set;
+		led->cdev.brightness_get = idp_led_get;
+		led->cdev.default_trigger = idp_leds[i].trigger;
+
+		if (i == 0)
+			led->mask = IDP_HB_LED;
+		else
+			led->mask = IDP_BUSY_LED;
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
+fs_initcall(idp_leds_init);
 
 MACHINE_START(PXA_IDP, "Vibren PXA255 IDP")
 	/* Maintainer: Vibren Technologies */
diff --git a/arch/arm/mach-pxa/leds-idp.c b/arch/arm/mach-pxa/leds-idp.c
deleted file mode 100644
index 06b0600..0000000
--- a/arch/arm/mach-pxa/leds-idp.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * linux/arch/arm/mach-pxa/leds-idp.c
- *
- * Copyright (C) 2000 John Dorsey <john+@cs.cmu.edu>
- *
- * Copyright (c) 2001 Jeff Sutherland <jeffs@accelent.com>
- *
- * Original (leds-footbridge.c) by Russell King
- *
- * Macros for actual LED manipulation should be in machine specific
- * files in this 'mach' directory.
- */
-
-
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include <mach/pxa25x.h>
-#include <mach/idp.h>
-
-#include "leds.h"
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-void idp_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch (evt) {
-	case led_start:
-		hw_led_state = IDP_HB_LED | IDP_BUSY_LED;
-		led_state = LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-		led_state &= ~LED_STATE_ENABLED;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		hw_led_state = IDP_HB_LED | IDP_BUSY_LED;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = IDP_HB_LED | IDP_BUSY_LED;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= IDP_HB_LED;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~IDP_BUSY_LED;
-		break;
-
-	case led_idle_end:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= IDP_BUSY_LED;
-		break;
-#endif
-
-	case led_halted:
-		break;
-
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= IDP_HB_LED;
-		break;
-
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~IDP_HB_LED;
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
-			hw_led_state |= IDP_BUSY_LED;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~IDP_BUSY_LED;
-		break;
-
-	default:
-		break;
-	}
-
-	if  (led_state & LED_STATE_ENABLED)
-		IDP_CPLD_LED_CONTROL = ( (IDP_CPLD_LED_CONTROL | IDP_LEDS_MASK) & ~hw_led_state);
-	else
-		IDP_CPLD_LED_CONTROL |= IDP_LEDS_MASK;
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-pxa/leds-lubbock.c b/arch/arm/mach-pxa/leds-lubbock.c
deleted file mode 100644
index 0bd85c8..0000000
--- a/arch/arm/mach-pxa/leds-lubbock.c
+++ /dev/null
@@ -1,124 +0,0 @@
-/*
- * linux/arch/arm/mach-pxa/leds-lubbock.c
- *
- * Copyright (C) 2000 John Dorsey <john+@cs.cmu.edu>
- *
- * Copyright (c) 2001 Jeff Sutherland <jeffs@accelent.com>
- *
- * Original (leds-footbridge.c) by Russell King
- *
- * Major surgery on April 2004 by Nicolas Pitre for less global
- * namespace collision.  Mostly adapted the Mainstone version.
- */
-
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <mach/pxa25x.h>
-#include <mach/lubbock.h>
-
-#include "leds.h"
-
-/*
- * 8 discrete leds available for general use:
- *
- * Note: bits [15-8] are used to enable/blank the 8 7 segment hex displays
- * so be sure to not monkey with them here.
- */
-
-#define D28			(1 << 0)
-#define D27			(1 << 1)
-#define D26			(1 << 2)
-#define D25			(1 << 3)
-#define D24			(1 << 4)
-#define D23			(1 << 5)
-#define D22			(1 << 6)
-#define D21			(1 << 7)
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-void lubbock_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch (evt) {
-	case led_start:
-		hw_led_state = 0;
-		led_state = LED_STATE_ENABLED;
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
-		hw_led_state ^= D26;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		hw_led_state &= ~D27;
-		break;
-
-	case led_idle_end:
-		hw_led_state |= D27;
-		break;
-#endif
-
-	case led_halted:
-		break;
-
-	case led_green_on:
-		hw_led_state |= D21;
-		break;
-
-	case led_green_off:
-		hw_led_state &= ~D21;
-		break;
-
-	case led_amber_on:
-		hw_led_state |= D22;
-		break;
-
-	case led_amber_off:
-		hw_led_state &= ~D22;
-		break;
-
-	case led_red_on:
-		hw_led_state |= D23;
-		break;
-
-	case led_red_off:
-		hw_led_state &= ~D23;
-		break;
-
-	default:
-		break;
-	}
-
-	if  (led_state & LED_STATE_ENABLED)
-		LUB_DISC_BLNK_LED = (LUB_DISC_BLNK_LED | 0xff) & ~hw_led_state;
-	else
-		LUB_DISC_BLNK_LED |= 0xff;
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-pxa/leds-mainstone.c b/arch/arm/mach-pxa/leds-mainstone.c
deleted file mode 100644
index 4058ab3..0000000
--- a/arch/arm/mach-pxa/leds-mainstone.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * linux/arch/arm/mach-pxa/leds-mainstone.c
- *
- * Author:     Nicolas Pitre
- * Created:    Nov 05, 2002
- * Copyright:  MontaVista Software Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/init.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-
-#include <mach/pxa27x.h>
-#include <mach/mainstone.h>
-
-#include "leds.h"
-
-
-/* 8 discrete leds available for general use: */
-#define D28			(1 << 0)
-#define D27			(1 << 1)
-#define D26			(1 << 2)
-#define D25			(1 << 3)
-#define D24			(1 << 4)
-#define D23			(1 << 5)
-#define D22			(1 << 6)
-#define D21			(1 << 7)
-
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
-
-static unsigned int led_state;
-static unsigned int hw_led_state;
-
-void mainstone_leds_event(led_event_t evt)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	switch (evt) {
-	case led_start:
-		hw_led_state = 0;
-		led_state = LED_STATE_ENABLED;
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
-		hw_led_state ^= D26;
-		break;
-#endif
-
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		hw_led_state &= ~D27;
-		break;
-
-	case led_idle_end:
-		hw_led_state |= D27;
-		break;
-#endif
-
-	case led_halted:
-		break;
-
-	case led_green_on:
-		hw_led_state |= D21;
-		break;
-
-	case led_green_off:
-		hw_led_state &= ~D21;
-		break;
-
-	case led_amber_on:
-		hw_led_state |= D22;
-		break;
-
-	case led_amber_off:
-		hw_led_state &= ~D22;
-		break;
-
-	case led_red_on:
-		hw_led_state |= D23;
-		break;
-
-	case led_red_off:
-		hw_led_state &= ~D23;
-		break;
-
-	default:
-		break;
-	}
-
-	if  (led_state & LED_STATE_ENABLED)
-		MST_LEDCTRL = (MST_LEDCTRL | 0xff) & ~hw_led_state;
-	else
-		MST_LEDCTRL |= 0xff;
-
-	local_irq_restore(flags);
-}
diff --git a/arch/arm/mach-pxa/leds.c b/arch/arm/mach-pxa/leds.c
deleted file mode 100644
index bbe4d5f..0000000
--- a/arch/arm/mach-pxa/leds.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * linux/arch/arm/mach-pxa/leds.c
- *
- * xscale LEDs dispatcher
- *
- * Copyright (C) 2001 Nicolas Pitre
- *
- * Copyright (c) 2001 Jeff Sutherland, Accelent Systems Inc.
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
-pxa_leds_init(void)
-{
-	if (machine_is_lubbock())
-		leds_event = lubbock_leds_event;
-	if (machine_is_mainstone())
-		leds_event = mainstone_leds_event;
-	if (machine_is_pxa_idp())
-		leds_event = idp_leds_event;
-
-	leds_event(led_start);
-	return 0;
-}
-
-core_initcall(pxa_leds_init);
diff --git a/arch/arm/mach-pxa/leds.h b/arch/arm/mach-pxa/leds.h
deleted file mode 100644
index 7f0dfe0..0000000
--- a/arch/arm/mach-pxa/leds.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * arch/arm/mach-pxa/leds.h
- *
- * Copyright (c) 2001 Jeff Sutherland, Accelent Systems Inc.
- *
- * blinky lights for various PXA-based systems:
- *
- */
-
-extern void idp_leds_event(led_event_t evt);
-extern void lubbock_leds_event(led_event_t evt);
-extern void mainstone_leds_event(led_event_t evt);
-extern void trizeps4_leds_event(led_event_t evt);
diff --git a/arch/arm/mach-pxa/lubbock.c b/arch/arm/mach-pxa/lubbock.c
index 6bb3f47..f3a300f 100644
--- a/arch/arm/mach-pxa/lubbock.c
+++ b/arch/arm/mach-pxa/lubbock.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/syscore_ops.h>
 #include <linux/major.h>
@@ -23,6 +24,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/smc91x.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <linux/spi/spi.h>
 #include <linux/spi/ads7846.h>
@@ -549,6 +552,96 @@ static void __init lubbock_map_io(void)
 	PCFR |= PCFR_OPDE;
 }
 
+/*
+ * Driver for the 8 discrete LEDs available for general use:
+ * Note: bits [15-8] are used to enable/blank the 8 7 segment hex displays
+ * so be sure to not monkey with them here.
+ */
+
+struct lubbock_led {
+	struct led_classdev	cdev;
+	u8			mask;
+};
+
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static const struct {
+	const char *name;
+	const char *trigger;
+} lubbock_leds[] = {
+	{ "lubbock:D28", "default-on", },
+	{ "lubbock:D27", "cpu0", },
+	{ "lubbock:D26", "heartbeat" },
+	{ "lubbock:D25", },
+	{ "lubbock:D24", },
+	{ "lubbock:D23", },
+	{ "lubbock:D22", },
+	{ "lubbock:D21", },
+};
+
+static void lubbock_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
+{
+	struct lubbock_led *led = container_of(cdev,
+					 struct lubbock_led, cdev);
+	u32 reg = LUB_DISC_BLNK_LED;
+
+	if (b != LED_OFF)
+		reg |= led->mask;
+	else
+		reg &= ~led->mask;
+
+	LUB_DISC_BLNK_LED = reg;
+}
+
+static enum led_brightness lubbock_led_get(struct led_classdev *cdev)
+{
+	struct lubbock_led *led = container_of(cdev,
+					 struct lubbock_led, cdev);
+	u32 reg = LUB_DISC_BLNK_LED;
+
+	return (reg & led->mask) ? LED_FULL : LED_OFF;
+}
+
+static int __init lubbock_leds_init(void)
+{
+	int i;
+
+	if (!machine_is_lubbock())
+		return -ENODEV;
+
+	/* All ON */
+	LUB_DISC_BLNK_LED |= 0xff;
+	for (i = 0; i < ARRAY_SIZE(lubbock_leds); i++) {
+		struct lubbock_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+		led->cdev.name = lubbock_leds[i].name;
+		led->cdev.brightness_set = lubbock_led_set;
+		led->cdev.brightness_get = lubbock_led_get;
+		led->cdev.default_trigger = lubbock_leds[i].trigger;
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
+fs_initcall(lubbock_leds_init);
+
 MACHINE_START(LUBBOCK, "Intel DBPXA250 Development Platform (aka Lubbock)")
 	/* Maintainer: MontaVista Software Inc. */
 	.map_io		= lubbock_map_io,
diff --git a/arch/arm/mach-pxa/mainstone.c b/arch/arm/mach-pxa/mainstone.c
index 1aebaf7..2ef1570 100644
--- a/arch/arm/mach-pxa/mainstone.c
+++ b/arch/arm/mach-pxa/mainstone.c
@@ -28,6 +28,8 @@
 #include <linux/pwm_backlight.h>
 #include <linux/smc91x.h>
 #include <linux/i2c/pxa-i2c.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <asm/types.h>
 #include <asm/setup.h>
@@ -613,6 +615,96 @@ static void __init mainstone_map_io(void)
  	PCFR = 0x66;
 }
 
+/*
+ * Driver for the 8 discrete LEDs available for general use:
+ * Note: bits [15-8] are used to enable/blank the 8 7 segment hex displays
+ * so be sure to not monkey with them here.
+ */
+
+struct mainstone_led {
+	struct led_classdev	cdev;
+	u8			mask;
+};
+
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static const struct {
+	const char *name;
+	const char *trigger;
+} mainstone_leds[] = {
+	{ "mainstone:D28", "default-on", },
+	{ "mainstone:D27", "cpu0", },
+	{ "mainstone:D26", "heartbeat" },
+	{ "mainstone:D25", },
+	{ "mainstone:D24", },
+	{ "mainstone:D23", },
+	{ "mainstone:D22", },
+	{ "mainstone:D21", },
+};
+
+static void mainstone_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
+{
+	struct mainstone_led *led = container_of(cdev,
+					 struct mainstone_led, cdev);
+	u32 reg = MST_LEDCTRL;
+
+	if (b != LED_OFF)
+		reg |= led->mask;
+	else
+		reg &= ~led->mask;
+
+	MST_LEDCTRL = reg;
+}
+
+static enum led_brightness mainstone_led_get(struct led_classdev *cdev)
+{
+	struct mainstone_led *led = container_of(cdev,
+					 struct mainstone_led, cdev);
+	u32 reg = MST_LEDCTRL;
+
+	return (reg & led->mask) ? LED_FULL : LED_OFF;
+}
+
+static int __init mainstone_leds_init(void)
+{
+	int i;
+
+	if (!machine_is_mainstone())
+		return -ENODEV;
+
+	/* All ON */
+	MST_LEDCTRL |= 0xff;
+	for (i = 0; i < ARRAY_SIZE(mainstone_leds); i++) {
+		struct mainstone_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+		led->cdev.name = mainstone_leds[i].name;
+		led->cdev.brightness_set = mainstone_led_set;
+		led->cdev.brightness_get = mainstone_led_get;
+		led->cdev.default_trigger = mainstone_leds[i].trigger;
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
+fs_initcall(mainstone_leds_init);
+
 MACHINE_START(MAINSTONE, "Intel HCDDBBVA0 Development Platform (aka Mainstone)")
 	/* Maintainer: MontaVista Software Inc. */
 	.atag_offset	= 0x100,	/* BLOB boot parameter setting */
-- 
1.7.9.5

