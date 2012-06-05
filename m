Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2FEVh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:37:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49887 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab2FEVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:37:27 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Shuah Khan <shuahkhan@gmail.com>
Subject: [PATCH v2 1/2] led: add oneshot trigger
Date: Tue,  5 Jun 2012 23:38:58 +0200
Message-Id: <1338932339-1660-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add oneshot trigger to blink a led with configurable parameters via
sysfs.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
Hi all,

that's my v2 of the ledtrig-oneshot trigger, with the correction suggested from
Shuah in the original thread.  These include some unnecessary initialization
and use of the new "activated" flag.

I've kept the name to "oneshot" as I think it suits the role of the trigger as
example/test for the led_blink_set_oneshot function but I have expanded a bit
the Kconfig description to better identify the trigger's usage.

About the namespace question, I think that naming the parameters delay_on and
delay_off is ok as they have the same meaning as timer's ones (they also
uses the same internal fields after all...).

Also, I added a default set of delay_{on,off} to 100ms on activation, so that
the trigger starts with a valid configuration, like ledtrig-timer does.

Anything else that should be changed?

Fabio

 drivers/leds/Kconfig           |  14 +++
 drivers/leds/Makefile          |   1 +
 drivers/leds/ledtrig-oneshot.c | 198 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 213 insertions(+)
 create mode 100644 drivers/leds/ledtrig-oneshot.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 04cb8c8..1f151fb 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -443,6 +443,20 @@ config LEDS_TRIGGER_TIMER
 
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_ONESHOT
+	tristate "LED One-shot Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows LEDs to blink in one-shot pulses with parameters
+	  controlled via sysfs.  It's useful to notify the user on
+	  sporadic events, when there are no clear begin and end trap points,
+	  or on dense events, where this blinks the LED at constant rate if
+	  rearmed continuously.
+
+	  It also shows how to use the led_blink_set_oneshot() function.
+
+	  If unsure, say Y.
+
 config LEDS_TRIGGER_IDE_DISK
 	bool "LED IDE Disk Trigger"
 	depends on IDE_GD_ATA
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index f8958cd..9112d51 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_LEDS_DAC124S085)		+= leds-dac124s085.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
+obj-$(CONFIG_LEDS_TRIGGER_ONESHOT)	+= ledtrig-oneshot.o
 obj-$(CONFIG_LEDS_TRIGGER_IDE_DISK)	+= ledtrig-ide-disk.o
 obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
new file mode 100644
index 0000000..1aacdfe
--- /dev/null
+++ b/drivers/leds/ledtrig-oneshot.c
@@ -0,0 +1,198 @@
+/*
+ * One-shot LED Trigger
+ *
+ * Copyright 2012, Fabio Baltieri <fabio.baltieri@gmail.com>
+ *
+ * Based on ledtrig-timer.c by Richard Purdie <rpurdie@openedhand.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+
+#define DEFAULT_DELAY 100
+
+struct oneshot_trig_data {
+	unsigned int invert;
+};
+
+static ssize_t led_shot(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+
+	led_blink_set_oneshot(led_cdev,
+			&led_cdev->blink_delay_on, &led_cdev->blink_delay_off,
+			oneshot_data->invert);
+
+	/* content is ignored */
+	return size;
+}
+static ssize_t led_invert_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%u\n", oneshot_data->invert);
+}
+
+static ssize_t led_invert_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	oneshot_data->invert = !!state;
+
+	return size;
+}
+
+static ssize_t led_delay_on_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_on);
+}
+
+static ssize_t led_delay_on_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	led_cdev->blink_delay_on = state;
+
+	return size;
+}
+static ssize_t led_delay_off_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%lu\n", led_cdev->blink_delay_off);
+}
+
+static ssize_t led_delay_off_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	unsigned long state;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	led_cdev->blink_delay_off = state;
+
+	return size;
+}
+
+static DEVICE_ATTR(delay_on, 0644, led_delay_on_show, led_delay_on_store);
+static DEVICE_ATTR(delay_off, 0644, led_delay_off_show, led_delay_off_store);
+static DEVICE_ATTR(invert, 0644, led_invert_show, led_invert_store);
+static DEVICE_ATTR(shot, 0200, NULL, led_shot);
+
+static void oneshot_trig_activate(struct led_classdev *led_cdev)
+{
+	struct oneshot_trig_data *oneshot_data;
+	int rc;
+
+	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
+	if (!oneshot_data)
+		return;
+
+	led_cdev->trigger_data = oneshot_data;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
+	if (rc)
+		goto err_out_trig_data;
+	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
+	if (rc)
+		goto err_out_delayon;
+	rc = device_create_file(led_cdev->dev, &dev_attr_invert);
+	if (rc)
+		goto err_out_delayoff;
+	rc = device_create_file(led_cdev->dev, &dev_attr_shot);
+	if (rc)
+		goto err_out_invert;
+
+	led_cdev->blink_delay_on = DEFAULT_DELAY;
+	led_cdev->blink_delay_off = DEFAULT_DELAY;
+
+	led_cdev->activated = true;
+
+	return;
+
+err_out_invert:
+	device_remove_file(led_cdev->dev, &dev_attr_invert);
+err_out_delayoff:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+err_out_delayon:
+	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+err_out_trig_data:
+	kfree(led_cdev->trigger_data);
+}
+
+static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct oneshot_trig_data *oneshot_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		device_remove_file(led_cdev->dev, &dev_attr_delay_on);
+		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
+		device_remove_file(led_cdev->dev, &dev_attr_invert);
+		device_remove_file(led_cdev->dev, &dev_attr_shot);
+		kfree(oneshot_data);
+		led_cdev->activated = false;
+	}
+
+	/* Stop blinking */
+	led_brightness_set(led_cdev, LED_OFF);
+}
+
+static struct led_trigger oneshot_led_trigger = {
+	.name     = "oneshot",
+	.activate = oneshot_trig_activate,
+	.deactivate = oneshot_trig_deactivate,
+};
+
+static int __init oneshot_trig_init(void)
+{
+	return led_trigger_register(&oneshot_led_trigger);
+}
+
+static void __exit oneshot_trig_exit(void)
+{
+	led_trigger_unregister(&oneshot_led_trigger);
+}
+
+module_init(oneshot_trig_init);
+module_exit(oneshot_trig_exit);
+
+MODULE_AUTHOR("Fabio Baltieri <fabio.baltieri@gmail.com>");
+MODULE_DESCRIPTION("One-shot LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.7.10.2.520.g6a4a482.dirty

