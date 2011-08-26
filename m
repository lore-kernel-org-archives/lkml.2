Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1HZJHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:07:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1HZJHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:07:30 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] mach-integrator: retire custom LED code
Date: Fri, 26 Aug 2011 17:03:26 +0800
Message-Id: <1314349415-889-10-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the LED in core module for CPU activity and also enable 4
debugging LEDs in baseboard.

The CPU activity LED is now handled by the trigger in the leds
subsystem, retire this old CONFIG_LEDS-based code.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-integrator/Makefile |    3 +-
 arch/arm/mach-integrator/core.c   |    1 -
 arch/arm/mach-integrator/leds.c   |  159 ++++++++++++++++++++++---------------
 3 files changed, 96 insertions(+), 67 deletions(-)

diff --git a/arch/arm/mach-integrator/Makefile b/arch/arm/mach-integrator/Makefile
index ebeef96..5521d18 100644
--- a/arch/arm/mach-integrator/Makefile
+++ b/arch/arm/mach-integrator/Makefile
@@ -4,11 +4,10 @@
 
 # Object file lists.
 
-obj-y					:= core.o lm.o
+obj-y					:= core.o lm.o leds.o
 obj-$(CONFIG_ARCH_INTEGRATOR_AP)	+= integrator_ap.o
 obj-$(CONFIG_ARCH_INTEGRATOR_CP)	+= integrator_cp.o
 
-obj-$(CONFIG_LEDS)			+= leds.o
 obj-$(CONFIG_PCI)			+= pci_v3.o pci.o
 obj-$(CONFIG_CPU_FREQ_INTEGRATOR)	+= cpu.o
 obj-$(CONFIG_INTEGRATOR_IMPD1)		+= impd1.o
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 3267cdd..f9c638d 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -28,7 +28,6 @@
 #include <asm/irq.h>
 #include <mach/cm.h>
 #include <asm/system.h>
-#include <asm/leds.h>
 #include <asm/mach/time.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-integrator/leds.c b/arch/arm/mach-integrator/leds.c
index 28be186..dab912b 100644
--- a/arch/arm/mach-integrator/leds.c
+++ b/arch/arm/mach-integrator/leds.c
@@ -1,91 +1,122 @@
 /*
- *  linux/arch/arm/mach-integrator/leds.c
+ * Driver for the 4 user LEDs found on the Integrator AP/CP baseboard
+ * Based on Versatile and RealView machine LED code
  *
- *  Integrator/AP and Integrator/CP LED control routines
- *
- *  Copyright (C) 1999 ARM Limited
- *  Copyright (C) 2000 Deep Blue Solutions Ltd
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Bryan Wu <bryan.wu@canonical.com>
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/smp.h>
-#include <linux/spinlock.h>
 #include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
+#include <mach/cm.h>
 #include <mach/hardware.h>
 #include <mach/platform.h>
-#include <asm/leds.h>
-#include <asm/system.h>
-#include <asm/mach-types.h>
-#include <mach/cm.h>
 
-static int saved_leds;
+#define ALPHA_REG __io_address(INTEGRATOR_DBG_BASE)
+#define LEDREG	(__io_address(INTEGRATOR_DBG_BASE) + INTEGRATOR_DBG_LEDS_OFFSET)
+
+struct integrator_led {
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
+} integrator_leds[] = {
+	{ "integrator:green0", "heartbeat", },
+	{ "integrator:yellow", },
+	{ "integrator:red", },
+	{ "integrator:green1", },
+	{ "integrator:core_module", "cpu0", },
+};
 
-static void integrator_leds_event(led_event_t ledevt)
+static void integrator_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
 {
-	unsigned long flags;
-	const unsigned int dbg_base = IO_ADDRESS(INTEGRATOR_DBG_BASE);
-	unsigned int update_alpha_leds;
+	struct integrator_led *led = container_of(cdev,
+						 struct integrator_led, cdev);
+	u32 reg = __raw_readl(LEDREG);
 
-	// yup, change the LEDs
-	local_irq_save(flags);
-	update_alpha_leds = 0;
+	if (b != LED_OFF)
+		reg |= led->mask;
+	else
+		reg &= ~led->mask;
 
-	switch(ledevt) {
-	case led_idle_start:
-		cm_control(CM_CTRL_LED, 0);
-		break;
+	while (__raw_readl(ALPHA_REG) & 1)
+		cpu_relax();
 
-	case led_idle_end:
-		cm_control(CM_CTRL_LED, CM_CTRL_LED);
-		break;
+	__raw_writel(reg, LEDREG);
+}
 
-	case led_timer:
-		saved_leds ^= GREEN_LED;
-		update_alpha_leds = 1;
-		break;
+static enum led_brightness integrator_led_get(struct led_classdev *cdev)
+{
+	struct integrator_led *led = container_of(cdev,
+						 struct integrator_led, cdev);
+	u32 reg = __raw_readl(LEDREG);
 
-	case led_red_on:
-		saved_leds |= RED_LED;
-		update_alpha_leds = 1;
-		break;
+	return (reg & led->mask) ? LED_FULL : LED_OFF;
+}
 
-	case led_red_off:
-		saved_leds &= ~RED_LED;
-		update_alpha_leds = 1;
-		break;
+static void cm_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
+{
+	if (b != LED_OFF)
+		cm_control(CM_CTRL_LED, CM_CTRL_LED);
+	else
+		cm_control(CM_CTRL_LED, 0);
+}
 
-	default:
-		break;
-	}
+static enum led_brightness cm_led_get(struct led_classdev *cdev)
+{
+	u32 reg = readl(CM_CTRL);
 
-	if (update_alpha_leds) {
-		while (__raw_readl(dbg_base + INTEGRATOR_DBG_ALPHA_OFFSET) & 1);
-		__raw_writel(saved_leds, dbg_base + INTEGRATOR_DBG_LEDS_OFFSET);
-	}
-	local_irq_restore(flags);
+	return (reg & CM_CTRL_LED) ? LED_FULL : LED_OFF;
 }
 
-static int __init leds_init(void)
+static int __init integrator_leds_init(void)
 {
-	if (machine_is_integrator() || machine_is_cintegrator())
-		leds_event = integrator_leds_event;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(integrator_leds); i++) {
+		struct integrator_led *led;
+
+		led = kzalloc(sizeof(*led), GFP_KERNEL);
+		if (!led)
+			break;
+
+
+		led->cdev.name = integrator_leds[i].name;
+
+		if (i == 4) { /* Setting for LED in core module */
+			led->cdev.brightness_set = cm_led_set;
+			led->cdev.brightness_get = cm_led_get;
+		} else {
+			led->cdev.brightness_set = integrator_led_set;
+			led->cdev.brightness_get = integrator_led_get;
+		}
+
+		led->cdev.default_trigger = integrator_leds[i].trigger;
+		led->mask = BIT(i);
+
+		if (led_classdev_register(NULL, &led->cdev) < 0) {
+			kfree(led);
+			break;
+		}
+	}
 
 	return 0;
 }
 
-core_initcall(leds_init);
+/*
+ * Since we may have triggers on any subsystem, defer registration
+ * until after subsystem_init.
+ */
+fs_initcall(integrator_leds_init);
-- 
1.7.5

