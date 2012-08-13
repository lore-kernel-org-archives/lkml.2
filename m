Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2HMFxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:53:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab2HMFxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:53:01 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, olof@lixom.net
Subject: [PATCH 09/18] ARM: mach-clps711x: retire custom LED code of P720T machine
Date: Mon, 13 Aug 2012 13:51:33 +0800
Message-Id: <1344837102-11850-10-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
References: <1344837102-11850-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add tigger based LED driver into board file of P720T.
Remove old LED driver file.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-clps711x/Makefile     |  2 --
 arch/arm/mach-clps711x/common.c     |  1 -
 arch/arm/mach-clps711x/p720t-leds.c | 63 -------------------------------------
 arch/arm/mach-clps711x/p720t.c      | 61 +++++++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+), 66 deletions(-)
 delete mode 100644 arch/arm/mach-clps711x/p720t-leds.c

diff --git a/arch/arm/mach-clps711x/Makefile b/arch/arm/mach-clps711x/Makefile
index f2f0256..5872b49 100644
--- a/arch/arm/mach-clps711x/Makefile
+++ b/arch/arm/mach-clps711x/Makefile
@@ -16,5 +16,3 @@ obj-$(CONFIG_ARCH_CLEP7312) += clep7312.o
 obj-$(CONFIG_ARCH_EDB7211)  += edb7211-arch.o edb7211-mm.o
 obj-$(CONFIG_ARCH_FORTUNET) += fortunet.o
 obj-$(CONFIG_ARCH_P720T)    += p720t.o
-leds-$(CONFIG_ARCH_P720T)   += p720t-leds.o
-obj-$(CONFIG_LEDS)          += $(leds-y)
diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index c965fd8..1e1ae48 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -31,7 +31,6 @@
 #include <asm/sizes.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/leds.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-clps711x/p720t-leds.c b/arch/arm/mach-clps711x/p720t-leds.c
deleted file mode 100644
index bbc449f..0000000
--- a/arch/arm/mach-clps711x/p720t-leds.c
+++ /dev/null
@@ -1,63 +0,0 @@
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
-#include <asm/mach-types.h>
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
index 42ee8f3..09113a9 100644
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
@@ -121,3 +125,60 @@ static int p720t_hw_init(void)
 
 __initcall(p720t_hw_init);
 
+/*
+ * LED controled by CPLD
+ */
+#if defined(CONFIG_NEW_LEDS) && defined(CONFIG_LEDS_CLASS)
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
+#endif
-- 
1.7.11.4

