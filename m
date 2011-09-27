Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1I0Ius (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 04:50:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1I0Iuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 04:50:46 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: tony@atomide.com, linux@arm.linux.org.uk, rpurdie@rpsys.net,
        manuel.lauss@gmail.com, cjb@laptop.org, cbou@mail.ru,
        dwmw2@infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linus.walleij@linaro.org, akpm@google.com
Subject: [PATCH] leds-class: change back LEDS_CLASS to tristate instead of bool
Date: Tue, 27 Sep 2011 16:50:32 +0800
Message-Id: <1317113432-7299-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LEDS_CLASS is required by leds and trigger drivers, but we can build it as
module.  So change this option back as tristate and treak the help message
as well.

LEDS_TRIGGERS depends on LEDS_CLASSS, which should be tristate.  So set it
as tristate too and update header files as well.

Change those ifdefs to take care of module configuration.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 arch/arm/mach-omap1/board-ams-delta.c |    4 ++--
 drivers/leds/Kconfig                  |    9 ++++++---
 drivers/leds/led-class.c              |    8 ++++----
 drivers/leds/leds.h                   |    2 +-
 drivers/mmc/host/au1xmmc.c            |    6 +++---
 drivers/power/power_supply.h          |    2 +-
 include/linux/leds.h                  |    7 ++++---
 include/linux/mmc/host.h              |    2 +-
 include/linux/power_supply.h          |    2 +-
 9 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index b2572f7..fd28696 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -241,7 +241,7 @@ static struct i2c_board_info ams_delta_camera_board_info[] = {
 	},
 };
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 DEFINE_LED_TRIGGER(ams_delta_camera_led_trigger);
 
 static int ams_delta_camera_power(struct device *dev, int power)
@@ -320,7 +320,7 @@ static void __init ams_delta_init(void)
 
 	omap1_usb_init(&ams_delta_usb_config);
 	omap1_set_camera_info(&ams_delta_camera_platform_data);
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	led_trigger_register_simple("ams_delta_camera",
 			&ams_delta_camera_led_trigger);
 #endif
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..c30233e 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -17,10 +17,13 @@ menuconfig NEW_LEDS
 if NEW_LEDS
 
 config LEDS_CLASS
-	bool "LED Class Support"
+	tristate "LED Class Support"
 	help
 	  This option enables the led sysfs class in /sys/class/leds.  You'll
-	  need this to do anything useful with LEDs.  If unsure, say N.
+	  need this to do anything useful with LEDs.  If unsure, say M.
+
+	  Note: don't disable it as N, because plenty of led and trigger drivers
+	  are using this option.
 
 comment "LED drivers"
 
@@ -388,7 +391,7 @@ config LEDS_RENESAS_TPU
 	  Brightness control is supported but hardware blinking is not.
 
 config LEDS_TRIGGERS
-	bool "LED Trigger support"
+	tristate "LED Trigger support"
 	depends on LEDS_CLASS
 	help
 	  This option enables trigger support for the leds class.
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index dc3d3d8..1f54cb0 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -75,7 +75,7 @@ static ssize_t led_max_brightness_show(struct device *dev,
 static struct device_attribute led_class_attrs[] = {
 	__ATTR(brightness, 0644, led_brightness_show, led_brightness_store),
 	__ATTR(max_brightness, 0444, led_max_brightness_show, NULL),
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	__ATTR(trigger, 0644, led_trigger_show, led_trigger_store),
 #endif
 	__ATTR_NULL,
@@ -209,7 +209,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	init_rwsem(&led_cdev->trigger_lock);
 #endif
 	/* add to the list of leds */
@@ -226,7 +226,7 @@ int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 	led_cdev->blink_timer.function = led_timer_function;
 	led_cdev->blink_timer.data = (unsigned long)led_cdev;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	led_trigger_set_default(led_cdev);
 #endif
 
@@ -245,7 +245,7 @@ EXPORT_SYMBOL_GPL(led_classdev_register);
  */
 void led_classdev_unregister(struct led_classdev *led_cdev)
 {
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	down_write(&led_cdev->trigger_lock);
 	if (led_cdev->trigger)
 		led_trigger_set(led_cdev, NULL);
diff --git a/drivers/leds/leds.h b/drivers/leds/leds.h
index e77c7f8..53b59b7 100644
--- a/drivers/leds/leds.h
+++ b/drivers/leds/leds.h
@@ -35,7 +35,7 @@ static inline int led_get_brightness(struct led_classdev *led_cdev)
 extern struct rw_semaphore leds_list_lock;
 extern struct list_head leds_list;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 void led_trigger_set_default(struct led_classdev *led_cdev);
 void led_trigger_set(struct led_classdev *led_cdev,
 			struct led_trigger *trigger);
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 56e7834..83f4913 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -1043,7 +1043,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 						     "using PIO\n");
 	}
 
-#ifdef CONFIG_LEDS_CLASS
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 	if (host->platdata && host->platdata->led) {
 		struct led_classdev *led = host->platdata->led;
 		led->name = mmc_hostname(mmc);
@@ -1072,7 +1072,7 @@ static int __devinit au1xmmc_probe(struct platform_device *pdev)
 	return 0;	/* all ok */
 
 out6:
-#ifdef CONFIG_LEDS_CLASS
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 	if (host->platdata && host->platdata->led)
 		led_classdev_unregister(host->platdata->led);
 out5:
@@ -1111,7 +1111,7 @@ static int __devexit au1xmmc_remove(struct platform_device *pdev)
 	if (host) {
 		mmc_remove_host(host->mmc);
 
-#ifdef CONFIG_LEDS_CLASS
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
 		if (host->platdata && host->platdata->led)
 			led_classdev_unregister(host->platdata->led);
 #endif
diff --git a/drivers/power/power_supply.h b/drivers/power/power_supply.h
index 018de2b..efa9544 100644
--- a/drivers/power/power_supply.h
+++ b/drivers/power/power_supply.h
@@ -22,7 +22,7 @@ static inline void power_supply_init_attrs(struct device_type *dev_type) {}
 
 #endif /* CONFIG_SYSFS */
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 
 extern void power_supply_update_leds(struct power_supply *psy);
 extern int power_supply_create_triggers(struct power_supply *psy);
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5884def..051bc7e 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -66,7 +66,7 @@ struct led_classdev {
 	struct timer_list	 blink_timer;
 	int			 blink_brightness;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	/* Protects the trigger data below */
 	struct rw_semaphore	 trigger_lock;
 
@@ -115,7 +115,7 @@ extern void led_brightness_set(struct led_classdev *led_cdev,
 /*
  * LED Triggers
  */
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 
 #define TRIG_NAME_MAX 50
 
@@ -161,7 +161,8 @@ extern void led_trigger_blink(struct led_trigger *trigger,
 #endif
 
 /* Trigger specific functions */
-#ifdef CONFIG_LEDS_TRIGGER_IDE_DISK
+#if defined(CONFIG_LEDS_TRIGGER_IDE_DISK) || \
+	defined(CONFIG_LEDS_TRIGGER_IDE_DISK_MODULE)
 extern void ledtrig_ide_activity(void);
 #else
 #define ledtrig_ide_activity() do {} while(0)
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index aed5bc7..adac344 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -300,7 +300,7 @@ struct mmc_host {
 
 	mmc_pm_flag_t		pm_flags;	/* requested pm features */
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	struct led_trigger	*led;		/* activity led */
 #endif
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 204c18d..cb09fa0 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -164,7 +164,7 @@ struct power_supply {
 	struct device *dev;
 	struct work_struct changed_work;
 
-#ifdef CONFIG_LEDS_TRIGGERS
+#if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
 	struct led_trigger *charging_full_trig;
 	char *charging_full_trig_name;
 	struct led_trigger *charging_trig;
-- 
1.7.5

