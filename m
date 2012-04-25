Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab2DYRmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:42:43 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:36178 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2DYRmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:42:42 -0400
Message-ID: <1335375758.5313.22.camel@lorien2>
Subject: [PATCH  v2] leds: add new transient trigger for one shot timer
 activation
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: akpm@linux-foundation.org
Cc: shuahkhan@gmail.com, Jonas Bonn <jonas@southpole.se>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        NeilBrown <neilb@suse.de>
Date: Wed, 25 Apr 2012 11:42:38 -0600
In-Reply-To: <1335219745.2850.7.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2> <1334064283.10826.6.camel@ted>
	 <1334507752.2723.3.camel@lorien2> <1334894674.3051.18.camel@lorien2>
	 <1334983269.2435.90.camel@jerome.southpole.se>
	 <1335138687.2882.20.camel@lorien2> <20120423115610.2da4d4d7@notabene.brown>
	 <1335158999.5139.47.camel@jerome.southpole.se>
	 <20120423154546.415bd6c0@notabene.brown> <1335219745.2850.7.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version of the patch to add new transient trigger to support
one shot timer activation. This trigger has two properties, activate
and duration. duration allows setting timer value in msecs. activate
allows activating and deactivating the timer specified by duration as
needed.

There was a suggestion to change units to seconds similar to "safe_delay_show" 
and "safe_delay_store" in drivers/md/md.c. safe_delay_show shows time in
seconds, however safe_delay_store still takes the value in msecs. This
sounded like an asymmetric interface.

I decided to leave duration units as msecs to be consistent with the
rest of the triggers in the leds sub-system for now.

I also found couple of bugs in activate store causing it to cancel the 
timer when it shouldn't and extending the timer when a second activate
comes in while timer is running.

Hope I addressed all of the review comments and didn't miss anything.
Thanks again for a good discussion and ideas.

>From 188e7791c91eb17b1a857dfa7e64a0b8c66247e7 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Wed, 25 Apr 2012 11:27:20 -0600
Subject: [PATCH] leds: add new transient trigger for one shot timer
 activation


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 drivers/leds/Kconfig             |    8 ++
 drivers/leds/Makefile            |    1 +
 drivers/leds/ledtrig-transient.c |  252 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 261 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-transient.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 5f12659..638219b 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -488,4 +488,12 @@ config LEDS_TRIGGER_DEFAULT_ON
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
+config LEDS_TRIGGER_TRANSIENT
+	tristate "LED Transient Trigger"
+	depends on LEDS_TRIGGERS
+	help
+	  This allows one time activation of a transient state on
+	  GPIO/PWM based hadrware.
+	  If unsure, say Y.
+
 endif # NEW_LEDS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9475bbb..202b187 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_TRANSIENT)	+= ledtrig-transient.o
diff --git a/drivers/leds/ledtrig-transient.c b/drivers/leds/ledtrig-transient.c
new file mode 100644
index 0000000..3a846d7
--- /dev/null
+++ b/drivers/leds/ledtrig-transient.c
@@ -0,0 +1,252 @@
+/*
+ * LED Kernel Transient Trigger
+ *
+ * Copyright (C) 2012 Shuah Khan <shuahkhan@gmail.com>
+ *
+ * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
+ * ledtrig-heartbeat.c
+ * Design and use-case input from Jonas Bonn <jonas@southpole.se> and
+ * Neil Brown <neilb@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+/*
+* This trigger exports two properties, activate and duration.
+* duration allows setting timer value in msecs.
+* activate allows activating and deactivating the timer specified by
+* duration as needed.
+*	activate - one shot timer activate mechanism.
+*		   1 when activated, 0 when deactivated.
+*
+*		   activate state indicates a timer
+*		   with a value of specified duration running.
+*		   deactivated state indicates no active timer is running.
+*	duration - one shot timer value. When activate is set, duration value
+*		   is used to start a timer that runs once.
+*	When timer expires activate goes back to deactivated state,
+*	duration is left at the set value to be used when activate
+*	is set at a future time. This will allow user app to set the
+*	time once and activate it to run it once for the specified value as
+*	needed.
+*
+*	echo 1 > activate -	starts timer = duration when duration is not 0.
+*	echo 0 > activate -	cancels currently running timer.
+*	echo n > duration -	stores timer value to be used upon next
+*				activate. Currently active timer if
+*				any, continues to run for the specified time.
+*	echo 0 > duration -	stores timer value to be used upon next
+*				activate. Currently active timer if any,
+*				continues to run for the specified time.
+*
+*	Future enhancements:
+*	1. extending and shortening the timer could be supported either by
+*	   simply modifying the running timer duration is set when
+*	   activate is in activated state. For example:
+*	   echo n > duration will extend/shorten timer, however
+*	   this could lead race conditions with timer expiry.
+*	2. The same could be done using a third attribute to control
+*	   extending and shortening the timer.
+*
+*	Example use-case 1:
+*	echo transient > trigger
+*	echo n > duration
+*	repeat the following step as needed:
+*	echo 1 > activate - start timer = duration to run once
+*	echo 1 > activate - start timer = duration to run once
+*	echo none > trigger
+*
+*	Example use-case 2:
+*	echo transient > trigger
+*	echo n > duration
+*	repeat the following step as needed:
+*	echo 1 > activate - start timer = duration to run once
+*	echo 1 > activate - start timer = duration to run once
+*	echo none > trigger
+*
+* This trigger is intended to be used for for the following example use cases:
+* - Control of vibrate (phones, tablets etc.) hardware by user space app.
+* - Use of LED by user space app as activity indicator.
+* - Use of LED by user space app as a kind of watchdog indicator -- as
+*	long as the app is alive, it can keep the LED illuminated, if it dies
+*	the LED will be extinguished automatically.
+* - Use by any user space app that needs a transient GPIO output.
+*/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/timer.h>
+#include <linux/leds.h>
+#include "leds.h"
+
+struct transient_trig_data {
+	int activate;
+	unsigned long duration;
+	struct timer_list timer;
+};
+
+static void transient_timer_function(unsigned long data)
+{
+	struct led_classdev *led_cdev = (struct led_classdev *) data;
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	transient_data->activate = 0;
+	led_cdev->brightness_set(led_cdev, LED_OFF);
+}
+
+static ssize_t transient_activate_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%d\n", transient_data->activate);
+}
+
+static ssize_t transient_activate_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	if (state != 1 && state != 0)
+		return -EINVAL;
+
+	/* cancel the running timer */
+	if (state == 0 && transient_data->activate == 1) {
+		del_timer(&transient_data->timer);
+		transient_data->activate = state;
+		led_cdev->brightness_set(led_cdev, LED_OFF);
+		return size;
+	}
+
+	/* start timer if there is no active timer */
+	if (state == 1 && transient_data->activate == 0 &&
+	    transient_data->duration != 0) {
+		transient_data->activate = state;
+		led_cdev->brightness_set(led_cdev, LED_FULL);
+		mod_timer(&transient_data->timer,
+			  jiffies + transient_data->duration);
+	}
+
+	/* state == 0 && transient_data->activate == 0
+		timer is not active - just return */
+	/* state == 1 && transient_data->activate == 1
+		timer is already active - just return */
+
+	return size;
+}
+
+static ssize_t transient_duration_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	return sprintf(buf, "%lu\n", transient_data->duration);
+}
+
+static ssize_t transient_duration_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+	unsigned long state;
+	ssize_t ret;
+
+	ret = kstrtoul(buf, 10, &state);
+	if (ret)
+		return ret;
+
+	transient_data->duration = state;
+
+	return size;
+}
+
+static DEVICE_ATTR(activate, 0644, transient_activate_show,
+		   transient_activate_store);
+static DEVICE_ATTR(duration, 0644, transient_duration_show,
+		   transient_duration_store);
+
+static void transient_trig_activate(struct led_classdev *led_cdev)
+{
+	int rc;
+	struct transient_trig_data *tdata;
+
+	tdata = kzalloc(sizeof(struct transient_trig_data), GFP_KERNEL);
+	if (!tdata) {
+		dev_err(led_cdev->dev,
+			"unable to allocate transient trigger\n");
+		return;
+	}
+	led_cdev->trigger_data = tdata;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_activate);
+	if (rc)
+		goto err_out;
+
+	rc = device_create_file(led_cdev->dev, &dev_attr_duration);
+	if (rc)
+		goto err_out_time;
+
+	setup_timer(&tdata->timer, transient_timer_function,
+		    (unsigned long) led_cdev);
+	led_cdev->activated = true;
+
+	return;
+
+err_out_time:
+	device_remove_file(led_cdev->dev, &dev_attr_activate);
+err_out:
+	dev_err(led_cdev->dev, "unable to register transient trigger\n");
+	led_cdev->trigger_data = NULL;
+	kfree(tdata);
+}
+
+static void transient_trig_deactivate(struct led_classdev *led_cdev)
+{
+	struct transient_trig_data *transient_data = led_cdev->trigger_data;
+
+	if (led_cdev->activated) {
+		del_timer_sync(&transient_data->timer);
+		device_remove_file(led_cdev->dev, &dev_attr_activate);
+		device_remove_file(led_cdev->dev, &dev_attr_duration);
+		led_cdev->trigger_data = NULL;
+		led_cdev->activated = false;
+		kfree(transient_data);
+	}
+}
+
+static struct led_trigger transient_trigger = {
+	.name     = "transient",
+	.activate = transient_trig_activate,
+	.deactivate = transient_trig_deactivate,
+};
+
+static int __init transient_trig_init(void)
+{
+	return led_trigger_register(&transient_trigger);
+}
+
+static void __exit transient_trig_exit(void)
+{
+	led_trigger_unregister(&transient_trigger);
+}
+
+module_init(transient_trig_init);
+module_exit(transient_trig_exit);
+
+MODULE_AUTHOR("Shuah Khan <shuahkhan@gmail.com>");
+MODULE_DESCRIPTION("Transient LED trigger");
+MODULE_LICENSE("GPL");
-- 
1.7.5.4



