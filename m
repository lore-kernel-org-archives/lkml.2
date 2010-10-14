Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab0JNTba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:31:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63824 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0JNTb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:31:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=V/f+I3lJL9EC06wkWVGd0MyYt3DjE66xcuoZbNQ7zzGgGTxS1T4k1JVT2JM0FCyaW9
         W9Gwzwr2QnAG+7SIAoDcCChDra54VFnQ6nZTXD7Uzv9yJq+ACyuQhTb0xkUvlY2y81g6
         /vz4Je19Fysap/atp7E3t+X3FCOZNJ86GzfxQ=
From: Peter Korsgaard <peter.korsgaard@genesi-usa.com>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Peter Korsgaard <peter.korsgaard@genesi-usa.com>
Subject: [PATCH] leds: add led trigger for input subsystem led events
Date: Thu, 14 Oct 2010 21:31:14 +0200
Message-Id: <1287084674-6104-1-git-send-email-peter.korsgaard@genesi-usa.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a LED trigger for the numlock/capslock/scrolllock states of the
input subsystem. This is handy for devices like the Efika smartbook [1],
which uses a standard USB HID keyboard, but keyboard LEDs are connected
directly to GPIOs, or for any other situation where you want to show
num/caps/scrolllock state on LED subsystem LEDs.

[1] http://www.genesi-usa.com/products/smartbook

Signed-off-by: Peter Korsgaard <peter.korsgaard@genesi-usa.com>
---
 drivers/leds/Kconfig         |    7 ++
 drivers/leds/Makefile        |    1 +
 drivers/leds/ledtrig-input.c |  165 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 173 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/ledtrig-input.c

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index e411262..92b4af1 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -373,6 +373,13 @@ config LEDS_TRIGGER_DEFAULT_ON
 	  This allows LEDs to be initialised in the ON state.
 	  If unsure, say Y.
 
+config LEDS_TRIGGER_INPUT
+	tristate "Input subsystem LEDs Trigger"
+	depends on INPUT
+	help
+	  This allows LEDs to be controlled according to the state of
+	  the input subsystem LEDs (capslock/numlock/scrolllock/..)
+
 comment "iptables trigger is under Netfilter config (LED target)"
 	depends on LEDS_TRIGGERS
 
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 7d6b958..f6b7645 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -49,3 +49,4 @@ obj-$(CONFIG_LEDS_TRIGGER_HEARTBEAT)	+= ledtrig-heartbeat.o
 obj-$(CONFIG_LEDS_TRIGGER_BACKLIGHT)	+= ledtrig-backlight.o
 obj-$(CONFIG_LEDS_TRIGGER_GPIO)		+= ledtrig-gpio.o
 obj-$(CONFIG_LEDS_TRIGGER_DEFAULT_ON)	+= ledtrig-default-on.o
+obj-$(CONFIG_LEDS_TRIGGER_INPUT)	+= ledtrig-input.o
diff --git a/drivers/leds/ledtrig-input.c b/drivers/leds/ledtrig-input.c
new file mode 100644
index 0000000..e4eae2b
--- /dev/null
+++ b/drivers/leds/ledtrig-input.c
@@ -0,0 +1,165 @@
+/*
+ * led trigger for input subsystem led states
+ *
+ * Peter Korsgaard <peter.korsgaard@genesi-usa.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/input.h>
+#include <linux/leds.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include "leds.h"
+
+struct input_trig {
+	int value; /* current value of input LED */
+	struct work_struct work;
+	struct led_trigger trig;
+};
+
+static int trig_connect(struct input_handler *handler, struct input_dev *dev,
+			 const struct input_device_id *id)
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
+	handle->name = "ledtrig-input";
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
+static void trig_disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	input_unregister_handle(handle);
+	kfree(handle);
+}
+
+static void trig_activate(struct led_classdev *led_cdev)
+{
+	struct input_trig *input = container_of(led_cdev->trigger,
+						struct input_trig, trig);
+
+	led_set_brightness(led_cdev, input->value ? LED_FULL : LED_OFF);
+}
+
+static struct input_trig trig[] = {
+	[LED_NUML] = {
+		.trig = {
+			.name = "numlock",
+			.activate = trig_activate,
+		},
+	},
+	[LED_CAPSL] = {
+		.trig = {
+			.name = "capslock",
+			.activate = trig_activate,
+		}
+	},
+	[LED_SCROLLL] = {
+		.trig = {
+			.name = "scrolllock",
+			.activate = trig_activate,
+		},
+	},
+};
+
+static void trig_event(struct input_handle *handle, unsigned int type,
+		      unsigned int code, int value)
+{
+	if (type == EV_LED && code < ARRAY_SIZE(trig)) {
+		if (value != trig[code].value) {
+			trig[code].value = value;
+			schedule_work(&trig[code].work);
+		}
+	}
+}
+
+static const struct input_device_id trig_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_LED) },
+	},
+	{ },			/* Terminating zero entry */
+};
+MODULE_DEVICE_TABLE(input, trig_ids);
+
+static struct input_handler trig_handler = {
+	.event		= trig_event,
+	.connect	= trig_connect,
+	.disconnect	= trig_disconnect,
+	.name		= "ledtrig-input",
+	.id_table	= trig_ids,
+};
+
+static void trig_work(struct work_struct *work)
+{
+	struct input_trig *input = container_of(work, struct input_trig, work);
+
+	led_trigger_event(&input->trig, input->value ? LED_FULL : LED_OFF);
+}
+
+static int __init trig_init(void)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(trig); i++) {
+		INIT_WORK(&trig[i].work, trig_work);
+		ret = led_trigger_register(&trig[i].trig);
+		if (ret)
+			goto trig_reg_fail;
+	}
+
+	ret = input_register_handler(&trig_handler);
+	if (!ret)
+		return 0;
+
+ trig_reg_fail:
+	for (; i > 0; i--)
+		led_trigger_unregister(&trig[i-1].trig);
+
+	return ret;
+}
+module_init(trig_init);
+
+static void __exit trig_exit(void)
+{
+	int i;
+
+	input_unregister_handler(&trig_handler);
+
+	for (i = 0; i < ARRAY_SIZE(trig); i++) {
+		cancel_work_sync(&trig[i].work);
+		led_trigger_unregister(&trig[i].trig);
+	}
+}
+module_exit(trig_exit);
+
+MODULE_AUTHOR("Peter Korsgaard <peter.korsgaard@genesi-usa.com>");
+MODULE_DESCRIPTION("LED trigger for input subsystem LEDs");
+MODULE_LICENSE("GPL");
-- 
1.7.1

