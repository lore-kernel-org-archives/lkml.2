Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1HZJHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:07:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33856 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1HZJHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:07:49 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] mach-clps711x: retire custom LED code of P720T machine
Date: Fri, 26 Aug 2011 17:03:27 +0800
Message-Id: <1314349415-889-11-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tigger based LED driver into board file of P720T.
Remove old LED driver file.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-clps711x/Makefile            |    2 -
 arch/arm/mach-clps711x/include/mach/time.h |    2 -
 arch/arm/mach-clps711x/p720t-leds.c        |   67 ----------------------------
 arch/arm/mach-clps711x/p720t.c             |   60 +++++++++++++++++++++++++
 arch/arm/mach-clps711x/time.c              |    1 -
 5 files changed, 60 insertions(+), 72 deletions(-)
 delete mode 100644 arch/arm/mach-clps711x/p720t-leds.c

diff --git a/arch/arm/mach-clps711x/Makefile b/arch/arm/mach-clps711x/Makefile
index 4a19731..af9dcce 100644
--- a/arch/arm/mach-clps711x/Makefile
+++ b/arch/arm/mach-clps711x/Makefile
@@ -16,5 +16,3 @@ obj-$(CONFIG_ARCH_CLEP7312) += clep7312.o
 obj-$(CONFIG_ARCH_EDB7211)  += edb7211-arch.o edb7211-mm.o
 obj-$(CONFIG_ARCH_FORTUNET) += fortunet.o
 obj-$(CONFIG_ARCH_P720T)    += p720t.o
-leds-$(CONFIG_ARCH_P720T)   += p720t-leds.o
-obj-$(CONFIG_LEDS)          += $(leds-y)
diff --git a/arch/arm/mach-clps711x/include/mach/time.h b/arch/arm/mach-clps711x/include/mach/time.h
index 61fef91..bafc325 100644
--- a/arch/arm/mach-clps711x/include/mach/time.h
+++ b/arch/arm/mach-clps711x/include/mach/time.h
@@ -17,7 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
-#include <asm/leds.h>
 #include <asm/hardware/clps7111.h>
 
 extern void clps711x_setup_timer(void);
@@ -29,7 +28,6 @@ static irqreturn_t
 p720t_timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
-	do_leds();
 	xtime_update(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
diff --git a/arch/arm/mach-clps711x/p720t-leds.c b/arch/arm/mach-clps711x/p720t-leds.c
deleted file mode 100644
index 1512144..0000000
--- a/arch/arm/mach-clps711x/p720t-leds.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- *  linux/arch/arm/mach-clps711x/leds.c
- *
- *  Integrator LED control routines
- *
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
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/io.h>
-
-#include <mach/hardware.h>
-#include <asm/leds.h>
-#include <asm/system.h>
-#include <asm/mach-types.h>
-
-#include <asm/hardware/clps7111.h>
-#include <asm/hardware/ep7212.h>
-
-static void p720t_leds_event(led_event_t ledevt)
-{
-	unsigned long flags;
-	u32 pddr;
-
-	local_irq_save(flags);
-	switch(ledevt) {
-	case led_idle_start:
-		break;
-
-	case led_idle_end:
-		break;
-
-	case led_timer:
-		pddr = clps_readb(PDDR);
-		clps_writeb(pddr ^ 1, PDDR);
-		break;
-
-	default:
-		break;
-	}
-
-	local_irq_restore(flags);
-}
-
-static int __init leds_init(void)
-{
-	if (machine_is_p720t())
-		leds_event = p720t_leds_event;
-
-	return 0;
-}
-
-arch_initcall(leds_init);
diff --git a/arch/arm/mach-clps711x/p720t.c b/arch/arm/mach-clps711x/p720t.c
index cefbce0..13fd262 100644
--- a/arch/arm/mach-clps711x/p720t.c
+++ b/arch/arm/mach-clps711x/p720t.c
@@ -23,6 +23,8 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <mach/hardware.h>
 #include <asm/pgtable.h>
@@ -34,6 +36,8 @@
 #include <asm/mach/map.h>
 #include <mach/syspld.h>
 
+#include <asm/hardware/clps7111.h>
+
 #include "common.h"
 
 /*
@@ -121,3 +125,59 @@ static int p720t_hw_init(void)
 
 __initcall(p720t_hw_init);
 
+/*
+ * LED controled by CPLD
+ */
+static void p720t_led_set(struct led_classdev *cdev,
+			      enum led_brightness b)
+{
+	u8 reg = clps_readb(PDDR);
+
+	if (b != LED_OFF)
+		reg |= 0x1;
+	else
+		reg &= ~0x1;
+
+	clps_writeb(reg, PDDR);
+}
+
+static enum led_brightness p720t_led_get(struct led_classdev *cdev)
+{
+	u8 reg = clps_readb(PDDR);
+
+	return (reg & 0x1) ? LED_FULL : LED_OFF;
+}
+
+static int __init p720t_leds_init(void)
+{
+
+	struct led_classdev *cdev;
+	int ret;
+
+	if (!machine_is_p720t())
+		return -ENODEV;
+
+	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
+	if (!cdev)
+		return -ENOMEM;
+
+	cdev->name = "p720t:0";
+	cdev->brightness_set = p720t_led_set;
+	cdev->brightness_get = p720t_led_get;
+	cdev->default_trigger = "heartbeat";
+
+	ret = led_classdev_register(NULL, cdev);
+	if (ret	< 0) {
+		kfree(cdev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Since we may have triggers on any subsystem, defer registration
+ * until after subsystem_init.
+ */
+fs_initcall(p720t_leds_init);
+
diff --git a/arch/arm/mach-clps711x/time.c b/arch/arm/mach-clps711x/time.c
index d581ef0..d79fe79 100644
--- a/arch/arm/mach-clps711x/time.c
+++ b/arch/arm/mach-clps711x/time.c
@@ -25,7 +25,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/hardware/clps7111.h>
 
 #include <asm/mach/time.h>
-- 
1.7.5

