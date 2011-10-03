Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab1JCRjv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:39:51 -0400
Received: from uucp.gnuu.de ([83.246.114.63]:4182 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739Ab1JCRjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:39:43 -0400
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Oct 2011 13:39:42 EDT
From: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Garzik <jgarzik@pobox.com>, Paul Mackerras <paulus@samba.org>
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
Subject: [PATCH] libata: Convert LED disk trigger from IDE to libata
Date: Mon,  3 Oct 2011 18:07:45 +0200
Message-Id: <38bd3a0590c6b069e2e6ff63d2bc4d039a703f02.1317657893.git.joerg@alea.gnuu.de>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the trigger for the LED at the front of Apple's
iBooks to libata. It's merely a replacement of the string ide by disk.

The patch is taken from http://dev.gentoo.org/~josejx/ata.patch. I've
asked Joseph Jezak if he intends to send this patch upstream, but as he
did not reply I'll do so.
---
 arch/powerpc/configs/pmac32_defconfig |    2 +-
 arch/powerpc/configs/ppc6xx_defconfig |    2 +-
 drivers/ata/libata-core.c             |    4 ++
 drivers/ide/ide-disk.c                |    2 +-
 drivers/leds/Kconfig                  |   10 +++---
 drivers/leds/Makefile                 |    2 +-
 drivers/leds/ledtrig-disk.c           |   64 +++++++++++++++++++++++++++++++++
 drivers/leds/ledtrig-ide-disk.c       |   64 ---------------------------------
 drivers/macintosh/Kconfig             |   11 +++---
 drivers/macintosh/via-pmu-led.c       |    4 +-
 include/linux/leds.h                  |    6 ++--
 11 files changed, 87 insertions(+), 84 deletions(-)
 create mode 100644 drivers/leds/ledtrig-disk.c
 delete mode 100644 drivers/leds/ledtrig-ide-disk.c

diff --git a/arch/powerpc/configs/pmac32_defconfig b/arch/powerpc/configs/pmac32_defconfig
index f8b394a..cff5d4e 100644
--- a/arch/powerpc/configs/pmac32_defconfig
+++ b/arch/powerpc/configs/pmac32_defconfig
@@ -180,7 +180,7 @@ CONFIG_ADB=y
 CONFIG_ADB_CUDA=y
 CONFIG_ADB_PMU=y
 CONFIG_ADB_PMU_LED=y
-CONFIG_ADB_PMU_LED_IDE=y
+CONFIG_ADB_PMU_LED_DISK=y
 CONFIG_PMAC_APM_EMU=m
 CONFIG_PMAC_MEDIABAY=y
 CONFIG_PMAC_BACKLIGHT=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 04360f9..c56464d 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -471,7 +471,7 @@ CONFIG_ADB=y
 CONFIG_ADB_CUDA=y
 CONFIG_ADB_PMU=y
 CONFIG_ADB_PMU_LED=y
-CONFIG_ADB_PMU_LED_IDE=y
+CONFIG_ADB_PMU_LED_DISK=y
 CONFIG_PMAC_APM_EMU=y
 CONFIG_PMAC_MEDIABAY=y
 CONFIG_PMAC_BACKLIGHT=y
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4a3a5ae..d37e3a2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -66,6 +66,7 @@
 #include <asm/byteorder.h>
 #include <linux/cdrom.h>
 #include <linux/ratelimit.h>
+#include <linux/leds.h>
 
 #include "libata.h"
 #include "libata-transport.h"
@@ -4823,6 +4824,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 
+	/* Trigger the LED (if available) */
+	ledtrig_disk_activity();
+
 	/* XXX: New EH and old EH use different mechanisms to
 	 * synchronize EH with regular execution path.
 	 *
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 2747980..cb25bd6 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -186,7 +186,7 @@ static ide_startstop_t ide_do_rw_disk(ide_drive_t *drive, struct request *rq,
 	BUG_ON(drive->dev_flags & IDE_DFLAG_BLOCKED);
 	BUG_ON(rq->cmd_type != REQ_TYPE_FS);
 
-	ledtrig_ide_activity();
+	ledtrig_disk_activity();
 
 	pr_debug("%s: %sing: block=%llu, sectors=%u, buffer=0x%08lx\n",
 		 drive->name, rq_data_dir(rq) == READ ? "read" : "writ",
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index b591e72..1934d8a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -404,12 +404,12 @@ config LEDS_TRIGGER_TIMER
 
 	  If unsure, say Y.
 
-config LEDS_TRIGGER_IDE_DISK
-	bool "LED IDE Disk Trigger"
-	depends on IDE_GD_ATA
-	depends on LEDS_TRIGGERS
+config LEDS_TRIGGER_DISK
+	bool "LED Disk Trigger"
+	depends on IDE_GD_ATA || ATA
+        depends on LEDS_TRIGGERS
 	help
-	  This allows LEDs to be controlled by IDE disk activity.
+	  This allows LEDs to be controlled by disk activity.
 	  If unsure, say Y.
 
 config LEDS_TRIGGER_HEARTBEAT
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index bbfd2e3..350cc89 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -49,7 +49,7 @@ obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
-obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
+obj-$(CONFIG_LEDS_TRIGGER_DISK)		+= ledtrig-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
diff --git a/drivers/leds/ledtrig-disk.c b/drivers/leds/ledtrig-disk.c
new file mode 100644
index 0000000..0ebb2eb
--- /dev/null
+++ b/drivers/leds/ledtrig-disk.c
@@ -0,0 +1,64 @@
+/*
+ * LED Disk Activity Trigger
+ *
+ * Copyright 2006 Openedhand Ltd.
+ *
+ * Author: Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+#include <linux/leds.h>
+
+static void ledtrig_disk_timerfunc(unsigned long data);
+
+DEFINE_LED_TRIGGER(ledtrig_disk);
+static DEFINE_TIMER(ledtrig_disk_timer, ledtrig_disk_timerfunc, 0, 0);
+static int disk_activity;
+static int disk_lastactivity;
+
+void ledtrig_disk_activity(void)
+{
+	disk_activity++;
+	if (!timer_pending(&ledtrig_disk_timer))
+		mod_timer(&ledtrig_disk_timer, jiffies + msecs_to_jiffies(10));
+}
+EXPORT_SYMBOL(ledtrig_disk_activity);
+
+static void ledtrig_disk_timerfunc(unsigned long data)
+{
+	if (disk_lastactivity != disk_activity) {
+		disk_lastactivity = disk_activity;
+		/* INT_MAX will set each LED to its maximum brightness */
+		led_trigger_event(ledtrig_disk, INT_MAX);
+		mod_timer(&ledtrig_disk_timer, jiffies + msecs_to_jiffies(10));
+	} else {
+		led_trigger_event(ledtrig_disk, LED_OFF);
+	}
+}
+
+static int __init ledtrig_disk_init(void)
+{
+	led_trigger_register_simple("disk-activity", &ledtrig_disk);
+	return 0;
+}
+
+static void __exit ledtrig_disk_exit(void)
+{
+	led_trigger_unregister_simple(ledtrig_disk);
+}
+
+module_init(ledtrig_disk_init);
+module_exit(ledtrig_disk_exit);
+
+MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
+MODULE_DESCRIPTION("LED Disk Activity Trigger");
+MODULE_LICENSE("GPL");
diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
deleted file mode 100644
index ec099fc..0000000
--- a/drivers/leds/ledtrig-ide-disk.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * LED IDE-Disk Activity Trigger
- *
- * Copyright 2006 Openedhand Ltd.
- *
- * Author: Richard Purdie <rpurdie@openedhand.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/jiffies.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/timer.h>
-#include <linux/leds.h>
-
-static void ledtrig_ide_timerfunc(unsigned long data);
-
-DEFINE_LED_TRIGGER(ledtrig_ide);
-static DEFINE_TIMER(ledtrig_ide_timer, ledtrig_ide_timerfunc, 0, 0);
-static int ide_activity;
-static int ide_lastactivity;
-
-void ledtrig_ide_activity(void)
-{
-	ide_activity++;
-	if (!timer_pending(&ledtrig_ide_timer))
-		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
-}
-EXPORT_SYMBOL(ledtrig_ide_activity);
-
-static void ledtrig_ide_timerfunc(unsigned long data)
-{
-	if (ide_lastactivity != ide_activity) {
-		ide_lastactivity = ide_activity;
-		/* INT_MAX will set each LED to its maximum brightness */
-		led_trigger_event(ledtrig_ide, INT_MAX);
-		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
-	} else {
-		led_trigger_event(ledtrig_ide, LED_OFF);
-	}
-}
-
-static int __init ledtrig_ide_init(void)
-{
-	led_trigger_register_simple("ide-disk", &ledtrig_ide);
-	return 0;
-}
-
-static void __exit ledtrig_ide_exit(void)
-{
-	led_trigger_unregister_simple(ledtrig_ide);
-}
-
-module_init(ledtrig_ide_init);
-module_exit(ledtrig_ide_exit);
-
-MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
-MODULE_DESCRIPTION("LED IDE Disk Activity Trigger");
-MODULE_LICENSE("GPL");
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index fa51af1..aeb7b2a 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -96,17 +96,16 @@ config ADB_PMU_LED
 	  Support the front LED on Power/iBooks as a generic LED that can
 	  be triggered by any of the supported triggers. To get the
 	  behaviour of the old CONFIG_BLK_DEV_IDE_PMAC_BLINK, select this
-	  and the ide-disk LED trigger and configure appropriately through
-	  sysfs.
+	  and the disk LED trigger and configure appropriately through sysfs.
 
-config ADB_PMU_LED_IDE
-	bool "Use front LED as IDE LED by default"
+config ADB_PMU_LED_DISK
+	bool "Use front LED as a disk LED by default"
 	depends on ADB_PMU_LED
 	depends on LEDS_CLASS
 	select LEDS_TRIGGERS
-	select LEDS_TRIGGER_IDE_DISK
+	select LEDS_TRIGGER_DISK
 	help
-	  This option makes the front LED default to the IDE trigger
+	  This option makes the front LED default to the disk trigger
 	  so that it blinks on IDE activity.
 
 config PMAC_SMU
diff --git a/drivers/macintosh/via-pmu-led.c b/drivers/macintosh/via-pmu-led.c
index 19c3718..ae067ab 100644
--- a/drivers/macintosh/via-pmu-led.c
+++ b/drivers/macintosh/via-pmu-led.c
@@ -73,8 +73,8 @@ static void pmu_led_set(struct led_classdev *led_cdev,
 
 static struct led_classdev pmu_led = {
 	.name = "pmu-led::front",
-#ifdef CONFIG_ADB_PMU_LED_IDE
-	.default_trigger = "ide-disk",
+#ifdef CONFIG_ADB_PMU_LED_DISK
+	.default_trigger = "disk-activity",
 #endif
 	.brightness_set = pmu_led_set,
 };
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..3413358 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -161,10 +161,10 @@ extern void led_trigger_blink(struct led_trigger *trigger,
 #endif
 
 /* Trigger specific functions */
-#ifdef CONFIG_LEDS_TRIGGER_IDE_DISK
-extern void ledtrig_ide_activity(void);
+#ifdef CONFIG_LEDS_TRIGGER_DISK
+extern void ledtrig_disk_activity(void);
 #else
-#define ledtrig_ide_activity() do {} while(0)
+#define ledtrig_disk_activity() do {} while(0)
 #endif
 
 /*
-- 
1.7.6.3

