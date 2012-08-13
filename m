Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2HMFwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:52:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2HMFwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:52:30 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, olof@lixom.net
Subject: [PATCH 05/18] ARM: mach-shark: retire custom LED code
Date: Mon, 13 Aug 2012 13:51:29 +0800
Message-Id: <1344837102-11850-6-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
References: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPU activity LED is now handled by the trigger in the leds
subsystem, retire this old CONFIG_LEDS-based code.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-shark/Makefile |   4 +-
 arch/arm/mach-shark/core.c   |   1 -
 arch/arm/mach-shark/leds.c   | 220 +++++++++++++++++--------------------------
 3 files changed, 87 insertions(+), 138 deletions(-)

diff --git a/arch/arm/mach-shark/Makefile b/arch/arm/mach-shark/Makefile
index 45be9b0..2965718 100644
--- a/arch/arm/mach-shark/Makefile
+++ b/arch/arm/mach-shark/Makefile
@@ -4,9 +4,7 @@
 
 # Object file lists.
 
-obj-y			:= core.o dma.o irq.o pci.o
+obj-y			:= core.o dma.o irq.o pci.o leds.o
 obj-m			:=
 obj-n			:=
 obj-			:=
-
-obj-$(CONFIG_LEDS)	+= leds.o
diff --git a/arch/arm/mach-shark/core.c b/arch/arm/mach-shark/core.c
index 2704bcd..c709979 100644
--- a/arch/arm/mach-shark/core.c
+++ b/arch/arm/mach-shark/core.c
@@ -13,7 +13,6 @@
 
 #include <asm/setup.h>
 #include <asm/mach-types.h>
-#include <asm/leds.h>
 #include <asm/param.h>
 #include <asm/system_misc.h>
 
diff --git a/arch/arm/mach-shark/leds.c b/arch/arm/mach-shark/leds.c
index 2560907..081c778 100644
--- a/arch/arm/mach-shark/leds.c
+++ b/arch/arm/mach-shark/leds.c
@@ -1,165 +1,117 @@
 /*
- * arch/arm/mach-shark/leds.c
- * by Alexander Schulz
- *
- * derived from:
- * arch/arm/kernel/leds-footbridge.c
- * Copyright (C) 1998-1999 Russell King
- *
  * DIGITAL Shark LED control routines.
  *
- * The leds use is as follows:
- *  - Green front - toggles state every 50 timer interrupts
- *  - Amber front - Unused, this is a dual color led (Amber/Green)
- *  - Amber back  - On if system is not idle
+ * Driver for the 3 user LEDs found on the Shark
+ * Based on Versatile and RealView machine LED code
  *
- * Changelog:
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Bryan Wu <bryan.wu@canonical.com>
  */
 #include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/ioport.h>
 #include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
-#include <asm/leds.h>
+#include <asm/mach-types.h>
 
-#define LED_STATE_ENABLED	1
-#define LED_STATE_CLAIMED	2
+#if defined(CONFIG_NEW_LEDS) && defined(CONFIG_LEDS_CLASS)
+struct shark_led {
+	struct led_classdev cdev;
+	u8 mask;
+};
 
-#define SEQUOIA_LED_GREEN       (1<<6)
-#define SEQUOIA_LED_AMBER       (1<<5)
-#define SEQUOIA_LED_BACK        (1<<7)
+/*
+ * The triggers lines up below will only be used if the
+ * LED triggers are compiled in.
+ */
+static const struct {
+	const char *name;
+	const char *trigger;
+} shark_leds[] = {
+	{ "shark:amber0", "default-on", },	/* Bit 5 */
+	{ "shark:green", "heartbeat", },	/* Bit 6 */
+	{ "shark:amber1", "cpu0" },		/* Bit 7 */
+};
+
+static u16 led_reg_read(void)
+{
+	outw(0x09, 0x24);
+	return inw(0x26);
+}
 
-static char led_state;
-static short hw_led_state;
-static short saved_state;
+static void led_reg_write(u16 value)
+{
+	outw(0x09, 0x24);
+	outw(value, 0x26);
+}
 
-static DEFINE_RAW_SPINLOCK(leds_lock);
+static void shark_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
+{
+	struct shark_led *led = container_of(cdev,
+						 struct shark_led, cdev);
+	u16 reg = led_reg_read();
 
-short sequoia_read(int addr) {
-  outw(addr,0x24);
-  return inw(0x26);
-}
+	if (b != LED_OFF)
+		reg |= led->mask;
+	else
+		reg &= ~led->mask;
 
-void sequoia_write(short value,short addr) {
-  outw(addr,0x24);
-  outw(value,0x26);
+	led_reg_write(reg);
 }
 
-static void sequoia_leds_event(led_event_t evt)
+static enum led_brightness shark_led_get(struct led_classdev *cdev)
 {
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&leds_lock, flags);
+	struct shark_led *led = container_of(cdev,
+						 struct shark_led, cdev);
+	u16 reg = led_reg_read();
 
-	hw_led_state = sequoia_read(0x09);
+	return (reg & led->mask) ? LED_FULL : LED_OFF;
+}
 
-	switch (evt) {
-	case led_start:
-		hw_led_state |= SEQUOIA_LED_GREEN;
-		hw_led_state |= SEQUOIA_LED_AMBER;
-#ifdef CONFIG_LEDS_CPU
-		hw_led_state |= SEQUOIA_LED_BACK;
-#else
-		hw_led_state &= ~SEQUOIA_LED_BACK;
-#endif
-		led_state |= LED_STATE_ENABLED;
-		break;
-
-	case led_stop:
-		hw_led_state &= ~SEQUOIA_LED_BACK;
-		hw_led_state |= SEQUOIA_LED_GREEN;
-		hw_led_state |= SEQUOIA_LED_AMBER;
-		led_state &= ~LED_STATE_ENABLED;
-		break;
-
-	case led_claim:
-		led_state |= LED_STATE_CLAIMED;
-		saved_state = hw_led_state;
-		hw_led_state &= ~SEQUOIA_LED_BACK;
-		hw_led_state |= SEQUOIA_LED_GREEN;
-		hw_led_state |= SEQUOIA_LED_AMBER;
-		break;
-
-	case led_release:
-		led_state &= ~LED_STATE_CLAIMED;
-		hw_led_state = saved_state;
-		break;
-
-#ifdef CONFIG_LEDS_TIMER
-	case led_timer:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state ^= SEQUOIA_LED_GREEN;
-		break;
-#endif
+static int __init shark_leds_init(void)
+{
+	int i;
+	u16 reg;
 
-#ifdef CONFIG_LEDS_CPU
-	case led_idle_start:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state &= ~SEQUOIA_LED_BACK;
-		break;
+	if (!machine_is_shark())
+		return -ENODEV;
 
-	case led_idle_end:
-		if (!(led_state & LED_STATE_CLAIMED))
-			hw_led_state |= SEQUOIA_LED_BACK;
-		break;
-#endif
+	for (i = 0; i < ARRAY_SIZE(shark_leds); i++) {
+		struct shark_led *led;
 
-	case led_green_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~SEQUOIA_LED_GREEN;
-		break;
-
-	case led_green_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= SEQUOIA_LED_GREEN;
-		break;
-
-	case led_amber_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~SEQUOIA_LED_AMBER;
-		break;
-
-	case led_amber_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= SEQUOIA_LED_AMBER;
-		break;
-
-	case led_red_on:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state |= SEQUOIA_LED_BACK;
-		break;
-
-	case led_red_off:
-		if (led_state & LED_STATE_CLAIMED)
-			hw_led_state &= ~SEQUOIA_LED_BACK;
-		break;
-
-	default:
-		break;
-	}
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
 
-	if  (led_state & LED_STATE_ENABLED)
-		sequoia_write(hw_led_state,0x09);
+		led->cdev.name = shark_leds[i].name;
+		led->cdev.brightness_set = shark_led_set;
+		led->cdev.brightness_get = shark_led_get;
+		led->cdev.default_trigger = shark_leds[i].trigger;
 
-	raw_spin_unlock_irqrestore(&leds_lock, flags);
-}
+		/* Count in 5 bits offset */
+		led->mask = BIT(i + 5);
 
-static int __init leds_init(void)
-{
-	extern void (*leds_event)(led_event_t);
-	short temp;
-	
-	leds_event = sequoia_leds_event;
+		if (led_classdev_register(NULL, &led->cdev) < 0) {
+			kfree(led);
+			break;
+		}
+	}
 
 	/* Make LEDs independent of power-state */
-	request_region(0x24,4,"sequoia");
-	temp = sequoia_read(0x09);
-	temp |= 1<<10;
-	sequoia_write(temp,0x09);
-	leds_event(led_start);
+	request_region(0x24, 4, "led_reg");
+	reg = led_reg_read();
+	reg |= 1 << 10;
+	led_reg_write(reg);
+
 	return 0;
 }
 
-__initcall(leds_init);
+/*
+ * Since we may have triggers on any subsystem, defer registration
+ * until after subsystem_init.
+ */
+fs_initcall(shark_leds_init);
+#endif
-- 
1.7.11.4

