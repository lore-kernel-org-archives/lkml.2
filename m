Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1AMNAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:00:41 -0500
Received: from lechat.rtp-net.org ([88.191.19.38]:58789 "EHLO
	lechat.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1AMNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:00:39 -0500
Message-Id: <20110113125921.818344418@rtp-net.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Jan 2011 13:59:13 +0100
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: rpurdie@rpsys.net
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: [patch 1/1] leds: add keyboard num/caps lock trigger
Content-Disposition: inline; filename=keyboards_leds_trigger.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a led trigger which enable/disable a led according
to keyboard leds events.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Index: linux-2.6-submit/drivers/leds/Kconfig
===================================================================
--- linux-2.6-submit.orig/drivers/leds/Kconfig	2010-12-29 11:29:38.000000000 +0100
+++ linux-2.6-submit/drivers/leds/Kconfig	2010-12-29 11:38:33.000000000 +0100
@@ -400,6 +400,13 @@
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_KEYBOARD
+	tristate "Keyboard LED Trigger"
+	depends on INPUT
+	help
+	  This allows LEDs to be controller by keyboard caps/num lock
+	  state.
+
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
Index: linux-2.6-submit/drivers/leds/ledtrig-keyleds.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-submit/drivers/leds/ledtrig-keyleds.c	2010-12-29 14:00:01.000000000 +0100
@@ -0,0 +1,173 @@
+/*
+ * ledtrig-keyleds.c - LED Trigger based on num/caps lock events
+ *
+ * Copyright 2010 Arnaud Patard <arnaud.patard@rtp-net.org>
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
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/input.h>
+#include "leds.h"
+
+struct keyboard_led_data {
+	struct led_classdev *caps_led;
+	struct led_classdev *num_led;
+};
+
+static struct keyboard_led_data led_datas;
+
+static void keyboard_led_event(struct input_handle *handle, unsigned int type,
+		unsigned int code, int value)
+{
+	switch (code) {
+	case LED_CAPSL:
+		if (led_datas.caps_led)
+			led_set_brightness(led_datas.caps_led,
+						value ? LED_FULL : LED_OFF);
+		break;
+	case LED_NUML:
+		if (led_datas.num_led)
+			led_set_brightness(led_datas.num_led,
+						value ? LED_FULL : LED_OFF);
+		break;
+	}
+}
+
+static int keyboard_led_connect(struct input_handler *handler,
+		struct input_dev *dev, const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int error;
+
+	handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "led-trigger";
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err_free_handle;
+
+	error = input_open_device(handle);
+	if (error)
+		goto err_unregister_handle;
+
+	return 0;
+
+ err_unregister_handle:
+	input_unregister_handle(handle);
+ err_free_handle:
+	kfree(handle);
+	return error;
+}
+
+static void keyboard_led_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+static const struct input_device_id keyboard_led_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT(EV_LED) },
+	},
+	{ }
+};
+
+static struct input_handler keyboard_led_handler = {
+	.name =	"led-trigger",
+	.event = keyboard_led_event,
+	.connect = keyboard_led_connect,
+	.disconnect = keyboard_led_disconnect,
+	.id_table = keyboard_led_ids,
+};
+
+
+static void caps_trig_activate(struct led_classdev *led)
+{
+	led_datas.caps_led = led;
+}
+
+static void caps_trig_deactivate(struct led_classdev *led)
+{
+	led_datas.caps_led = NULL;
+}
+
+static struct led_trigger caps_led_trigger = {
+	.name		= "caps",
+	.activate	= caps_trig_activate,
+	.deactivate	= caps_trig_deactivate,
+};
+
+static void num_trig_activate(struct led_classdev *led)
+{
+	led_datas.num_led = led;
+}
+
+static void num_trig_deactivate(struct led_classdev *led)
+{
+	led_datas.num_led = NULL;
+}
+
+static struct led_trigger num_led_trigger = {
+	.name		= "num",
+	.activate	= num_trig_activate,
+	.deactivate	= num_trig_deactivate,
+};
+
+static int __init keyboard_led_trig_init(void)
+{
+	int ret;
+
+	ret = led_trigger_register(&caps_led_trigger);
+	if (ret)
+		goto err;
+
+	ret = led_trigger_register(&num_led_trigger);
+	if (ret)
+		goto err_caps;
+
+	ret = input_register_handler(&keyboard_led_handler);
+	if (ret)
+		goto err_num;
+
+	printk(KERN_ERR "Led triggers registered\n");
+	return 0;
+
+err_num:
+	led_trigger_unregister(&num_led_trigger);
+err_caps:
+	led_trigger_unregister(&caps_led_trigger);
+err:
+	printk(KERN_ERR "Failed to register led triggers %d\n", ret);
+	return ret;
+}
+module_init(keyboard_led_trig_init);
+
+static void __exit keyboard_led_trig_exit(void)
+{
+	input_unregister_handler(&keyboard_led_handler);
+	led_trigger_unregister(&num_led_trigger);
+	led_trigger_unregister(&caps_led_trigger);
+}
+module_exit(keyboard_led_trig_exit);
+
+MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
+MODULE_DESCRIPTION("Keyboard LED trigger");
+MODULE_LICENSE("GPL");
Index: linux-2.6-submit/drivers/leds/Makefile
===================================================================
--- linux-2.6-submit.orig/drivers/leds/Makefile	2010-12-29 11:27:22.000000000 +0100
+++ linux-2.6-submit/drivers/leds/Makefile	2010-12-29 11:29:34.000000000 +0100
@@ -52,3 +52,4 @@
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_KEYBOARD)	+= ledtrig-keyleds.o


