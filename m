Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1HZJIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:08:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1HZJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:08:11 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] mach-ebsa110: retire custom LED code
Date: Fri, 26 Aug 2011 17:03:28 +0800
Message-Id: <1314349415-889-12-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-ebsa110/Makefile |    4 +-
 arch/arm/mach-ebsa110/leds.c   |   80 ++++++++++++++++++++++++---------------
 2 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-ebsa110/Makefile b/arch/arm/mach-ebsa110/Makefile
index 6520ac8..935e4af 100644
--- a/arch/arm/mach-ebsa110/Makefile
+++ b/arch/arm/mach-ebsa110/Makefile
@@ -4,9 +4,7 @@
 
 # Object file lists.
 
-obj-y			:= core.o io.o
+obj-y			:= core.o io.o leds.o
 obj-m			:=
 obj-n			:=
 obj-			:=
-
-obj-$(CONFIG_LEDS)	+= leds.o
diff --git a/arch/arm/mach-ebsa110/leds.c b/arch/arm/mach-ebsa110/leds.c
index 6a6ea57..94b35fb 100644
--- a/arch/arm/mach-ebsa110/leds.c
+++ b/arch/arm/mach-ebsa110/leds.c
@@ -1,51 +1,69 @@
 /*
- *  linux/arch/arm/mach-ebsa110/leds.c
+ * Driver for the LED found on the EBSA110 machine
+ * Based on Versatile and RealView machine LED code
  *
- *  Copyright (C) 1998 Russell King
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- *  EBSA-110 LED control routines.  We use the led as follows:
- *
- *   - Red - toggles state every 50 timer interrupts
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Bryan Wu <bryan.wu@canonical.com>
  */
-#include <linux/module.h>
-#include <linux/spinlock.h>
+#include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
-static spinlock_t leds_lock;
+#include <mach/hardware.h>
 
-static void ebsa110_leds_event(led_event_t ledevt)
+static void ebsa110_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
 {
-	unsigned long flags;
+	u8 reg = __raw_readb(SOFT_BASE);
 
-	spin_lock_irqsave(&leds_lock, flags);
+	if (b != LED_OFF)
+		reg |= 0x80;
+	else
+		reg &= ~0x80;
 
-	switch(ledevt) {
-	case led_timer:
-		*(volatile unsigned char *)SOFT_BASE ^= 128;
-		break;
+	__raw_writeb(reg, SOFT_BASE);
+}
 
-	default:
-		break;
-	}
+static enum led_brightness ebsa110_led_get(struct led_classdev *cdev)
+{
+	u8 reg = __raw_readb(SOFT_BASE);
 
-	spin_unlock_irqrestore(&leds_lock, flags);
+	return (reg & 0x80) ? LED_FULL : LED_OFF;
 }
 
-static int __init leds_init(void)
+static int __init ebsa110_leds_init(void)
 {
-	if (machine_is_ebsa110())
-		leds_event = ebsa110_leds_event;
+
+	struct led_classdev *cdev;
+	int ret;
+
+	if (!machine_is_ebsa110())
+		return -ENODEV;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return -ENOMEM;
+
+	cdev->name = "ebsa110:0";
+	cdev->brightness_set = ebsa110_led_set;
+	cdev->brightness_get = ebsa110_led_get;
+	cdev->default_trigger = "heartbeat";
+
+	ret = led_classdev_register(NULL, cdev);
+	if (ret	< 0) {
+		kfree(cdev);
+		return ret;
+	}
 
 	return 0;
 }
 
-__initcall(leds_init);
+/*
+ * Since we may have triggers on any subsystem, defer registration
+ * until after subsystem_init.
+ */
+fs_initcall(ebsa110_leds_init);
-- 
1.7.5

