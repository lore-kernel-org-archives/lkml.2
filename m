Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1KNAMK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 19:12:10 -0500
Received: from toccata.ens-lyon.org ([140.77.166.68]:60273 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1KNAMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 19:12:07 -0500
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Nov 2011 19:12:06 EST
Date: Mon, 14 Nov 2011 01:03:23 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: rpurdie@rpsys.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] leds: add keyboard num/caps lock trigger
Message-ID: <20111114000323.GC8170@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Arnaud Patard <arnaud.patard@rtp-net.org>, rpurdie@rpsys.net,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20110113125921.818344418@rtp-net.org>
 <20110113131323.GJ5995@const.bordeaux.inria.fr>
 <87aaj01k2q.fsf@lechat.rtp-net.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87aaj01k2q.fsf@lechat.rtp-net.org>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Arnaud Patard, le Mon 17 Jan 2011 00:54:05 +0100, a écrit :
> I've download the patch at [1] and after a quick runtime test, got no
> success. When booting with the LEDS_INPUT set to y, the machine is
> hanging.

Could you try again with the attached patch?

Samuel

--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
index 79699c2..62261c0 100644
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.txt
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..1f31969 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -11,9 +11,6 @@ menuconfig NEW_LEDS
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
@@ -32,6 +29,14 @@ config LEDS_88PM860X
 	  This option enables support for on-chip LED drivers found on Marvell
 	  Semiconductor 88PM8606 PMIC.
 
+config LEDS_INPUT
+	tristate "LED Support using input keyboards"
+	depends on LEDS_CLASS && INPUT
+	select LEDS_TRIGGERS
+	help
+	  This option enables support for the LEDs on keyboard managed
+	  by the input layer.
+
 config LEDS_ATMEL_PWM
 	tristate "LED Support using Atmel PWM outputs"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e4f6bf5..90956c2 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 obj-$(CONFIG_LEDS_88PM860X)		+= leds-88pm860x.o
 obj-$(CONFIG_LEDS_ATMEL_PWM)		+= leds-atmel-pwm.o
 obj-$(CONFIG_LEDS_BD2802)		+= leds-bd2802.o
+obj-$(CONFIG_LEDS_INPUT)		+= leds-input.o
 obj-$(CONFIG_LEDS_LOCOMO)		+= leds-locomo.o
 obj-$(CONFIG_LEDS_LM3530)		+= leds-lm3530.o
 obj-$(CONFIG_LEDS_MIKROTIK_RB532)	+= leds-rb532.o
diff --git a/drivers/leds/leds-input.c b/drivers/leds/leds-input.c
new file mode 100644
index 0000000..55b2038
--- /dev/null
+++ b/drivers/leds/leds-input.c
@@ -0,0 +1,306 @@
+/*
+ * LED support for the input layer
+ *
+ * Copyright 2010-2011 Samuel Thibault <samuel.thibault@ens-lyon.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/leds.h>
+#include <linux/input.h>
+
+#include "leds.h"
+
+/*
+ * Keyboard LEDs are propagated by default like the following example:
+ *
+ * VT keyboard numlock trigger
+ * -> vt::numl VT LED
+ * -> vt-numl VT trigger
+ * -> per-device inputx::numl LED
+ *
+ * Userland can however choose the trigger for the vt::numl LED, or
+ * independently choose the trigger for any inputx::numl LED.
+ */
+
+/* VT LED classes and triggers are registered on-demand according to
+ * existing LED devices */
+
+/* Handler for VT LEDs, just triggers the corresponding VT trigger. */
+static void vt_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness);
+static struct led_classdev vt_leds[LED_CNT] = {
+#define DEFINE_INPUT_LED(vt_led, nam, deftrig) \
+	[vt_led] = { \
+		.name = "vt::"nam, \
+		.max_brightness = 1, \
+		.brightness_set = vt_led_set, \
+		.default_trigger = deftrig, \
+	}
+/* Default triggers for the VT LEDs just correspond to the legacy
+ * usage. */
+	DEFINE_INPUT_LED(LED_NUML, "numl", "numlock"),
+	DEFINE_INPUT_LED(LED_CAPSL, "capsl", "capslock"),
+	DEFINE_INPUT_LED(LED_SCROLLL, "scrolll", "scrollock"),
+	DEFINE_INPUT_LED(LED_COMPOSE, "compose", NULL),
+	DEFINE_INPUT_LED(LED_KANA, "kana", "kanalock"),
+	DEFINE_INPUT_LED(LED_SLEEP, "sleep", NULL),
+	DEFINE_INPUT_LED(LED_SUSPEND, "suspend", NULL),
+	DEFINE_INPUT_LED(LED_MUTE, "mute", NULL),
+	DEFINE_INPUT_LED(LED_MISC, "misc", NULL),
+	DEFINE_INPUT_LED(LED_MAIL, "mail", NULL),
+	DEFINE_INPUT_LED(LED_CHARGING, "charging", NULL),
+};
+static const char *const vt_led_names[LED_CNT] = {
+	[LED_NUML] = "numl",
+	[LED_CAPSL] = "capsl",
+	[LED_SCROLLL] = "scrolll",
+	[LED_COMPOSE] = "compose",
+	[LED_KANA] = "kana",
+	[LED_SLEEP] = "sleep",
+	[LED_SUSPEND] = "suspend",
+	[LED_MUTE] = "mute",
+	[LED_MISC] = "misc",
+	[LED_MAIL] = "mail",
+	[LED_CHARGING] = "charging",
+};
+/* Handler for hotplug initialization */
+static void vt_led_trigger_activate(struct led_classdev *cdev);
+/* VT triggers */
+static struct led_trigger vt_led_triggers[LED_CNT] = {
+#define DEFINE_INPUT_LED_TRIGGER(vt_led, nam) \
+	[vt_led] = { \
+		.name = "vt-"nam, \
+		.activate = vt_led_trigger_activate, \
+	}
+	DEFINE_INPUT_LED_TRIGGER(LED_NUML, "numl"),
+	DEFINE_INPUT_LED_TRIGGER(LED_CAPSL, "capsl"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SCROLLL, "scrolll"),
+	DEFINE_INPUT_LED_TRIGGER(LED_COMPOSE, "compose"),
+	DEFINE_INPUT_LED_TRIGGER(LED_KANA, "kana"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SLEEP, "sleep"),
+	DEFINE_INPUT_LED_TRIGGER(LED_SUSPEND, "suspend"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MUTE, "mute"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MISC, "misc"),
+	DEFINE_INPUT_LED_TRIGGER(LED_MAIL, "mail"),
+	DEFINE_INPUT_LED_TRIGGER(LED_CHARGING, "charging"),
+};
+/* Lock for registration coherency */
+static DEFINE_MUTEX(vt_led_registered_lock);
+/* Which VT LED classes and triggers are registered */
+static unsigned long vt_led_registered[BITS_TO_LONGS(LED_CNT)];
+
+/* Our input handler to catch connect/disconnect */
+static struct input_handler input_led_handler;
+
+/* VT LED state change, tell the VT trigger.  */
+static void vt_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	int led = cdev - vt_leds;
+
+	led_trigger_event(&vt_led_triggers[led], !!brightness);
+}
+
+/* LED state change for some keyboard, notify that keyboard.  */
+static void perdevice_input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	struct input_handle *handle;
+	struct led_classdev *leds;
+	int led;
+
+	handle = cdev->dev->platform_data;
+	if (!handle)
+		/* Still initializing */
+		return;
+	leds = handle->private;
+	led = cdev - leds;
+
+	input_inject_event(handle, EV_LED, led, !!brightness);
+	input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
+}
+
+/* Keyboard hotplug, initialize its LED status */
+static void vt_led_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - vt_led_triggers;
+
+	if (cdev->brightness_set)
+		cdev->brightness_set(cdev, vt_leds[led].brightness);
+}
+
+/* Free an input handle, used at abortion and disconnection.  */
+static void input_led_delete_handle(struct input_handle *handle)
+{
+	if (handle) {
+		struct led_classdev *leds = handle->private;
+		if (leds) {
+			int i;
+			for (i = 0; i < LED_CNT; i++)
+				kfree(leds[i].name);
+			kfree(leds);
+		}
+		kfree(handle);
+	}
+}
+
+/* A new input device with potential LEDs to connect.  */
+static int input_led_connect(struct input_handler *handler,
+			      struct input_dev *dev,
+			      const struct input_device_id *id)
+{
+	struct input_handle *handle;
+	int i, error = 0;
+	struct led_classdev *leds;
+
+	if (!test_bit(EV_LED, dev->keybit))
+		return -ENODEV;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	handle->private = leds = kzalloc(sizeof(*leds) * LED_CNT,
+						GFP_KERNEL);
+	if (!handle->private) {
+		error = -ENOMEM;
+		goto err;
+	}
+
+	handle->dev = dev;
+	handle->handler = handler;
+	handle->name = "input leds";
+
+	error = input_register_handle(handle);
+	if (error)
+		goto err;
+
+	/* lazily register missing VT LEDs */
+	mutex_lock(&vt_led_registered_lock);
+	for (i = 0; i < LED_CNT; i++)
+		if (vt_leds[i].name
+				&& !test_bit(i, vt_led_registered)
+				&& test_bit(i, dev->ledbit)) {
+			led_trigger_register(&vt_led_triggers[i]);
+			/* This keyboard has led i, try to register it */
+			if (!led_classdev_register(NULL, &vt_leds[i]))
+				set_bit(i, vt_led_registered);
+			else
+				led_trigger_unregister(&vt_led_triggers[i]);
+		}
+	mutex_unlock(&vt_led_registered_lock);
+
+	/* and register this device's LEDs */
+	for (i = 0; i < LED_CNT; i++)
+		if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
+			leds[i].name = kasprintf(GFP_KERNEL, "%s::%s",
+						dev_name(&dev->dev),
+						vt_led_names[i]);
+			if (!leds[i].name) {
+				error = -ENOMEM;
+				goto err_handler;
+			}
+			leds[i].max_brightness = 1;
+			leds[i].brightness_set = perdevice_input_led_set;
+			leds[i].default_trigger = vt_led_triggers[i].name;
+		}
+
+	/* No issue so far, we can register for real.  */
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name) {
+			led_classdev_register(&dev->dev, &leds[i]);
+			leds[i].dev->platform_data = handle;
+			perdevice_input_led_set(&leds[i],
+					vt_leds[i].brightness);
+		}
+
+	return 0;
+
+err_handler:
+	input_unregister_handler(&input_led_handler);
+err:
+	input_led_delete_handle(handle);
+	return error;
+}
+
+/* Disconnected input device. Clean it, and deregister now-useless VT LEDs
+ * and triggers.  */
+static void input_led_disconnect(struct input_handle *handle)
+{
+	int unregister, i;
+	struct led_classdev *leds = handle->private;
+
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name)
+			led_classdev_unregister(&leds[i]);
+
+	input_unregister_handle(handle);
+	input_led_delete_handle(handle);
+
+	mutex_lock(&vt_led_registered_lock);
+	for (i = 0; i < LED_CNT; i++) {
+		if (!test_bit(i, vt_led_registered))
+			continue;
+
+		unregister = 1;
+		list_for_each_entry(handle, &input_led_handler.h_list, h_node) {
+			if (test_bit(i, handle->dev->ledbit)) {
+				unregister = 0;
+				break;
+			}
+		}
+		if (!unregister)
+			continue;
+
+		led_classdev_unregister(&vt_leds[i]);
+		led_trigger_unregister(&vt_led_triggers[i]);
+		clear_bit(i, vt_led_registered);
+	}
+	mutex_unlock(&vt_led_registered_lock);
+}
+
+/* Only handle input devices which have LEDs */
+static const struct input_device_id input_led_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_LED) },
+	},
+
+	{ },	/* Terminating entry */
+};
+
+static struct input_handler input_led_handler = {
+	.connect	= input_led_connect,
+	.disconnect	= input_led_disconnect,
+	.name		= "input leds",
+	.id_table	= input_led_ids,
+};
+
+static int __init input_led_init(void)
+{
+	return input_register_handler(&input_led_handler);
+}
+
+static void __exit input_led_exit(void)
+{
+	/* This also disconnects all devices and thus unregisters LEDs and
+	 * triggers */
+	input_unregister_handler(&input_led_handler);
+}
+
+module_init(input_led_init);
+module_exit(input_led_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("User LED support for input layer");
+MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index b3d1741..622eecd 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -2,6 +2,7 @@ config VT
 	bool "Virtual terminal" if EXPERT
 	depends on !S390 && !UML
 	select INPUT
+	select LEDS_INPUT
 	default y
 	---help---
 	  If you say Y here, you will get support for terminal devices with
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index a605549..72a35c3 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -138,6 +139,7 @@ static unsigned int diacr;
 static char rep;					/* flag telling character repeat */
 
 static unsigned char ledstate = 0xff;			/* undefined */
+static unsigned char lockstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
 static struct ledptr {
@@ -977,6 +979,32 @@ static void k_brl(struct vc_data *vc, unsigned char value, char up_flag)
 	}
 }
 
+/* We route VT keyboard "leds" through triggers */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev);
+static struct led_trigger ledtrig_ledstate[] = {
+#define DEFINE_LEDSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { .name = nam, .activate = kbd_ledstate_trigger_activate, }
+	DEFINE_LEDSTATE_TRIGGER(VC_SCROLLOCK, "scrollock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_NUMLOCK,   "numlock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_CAPSLOCK,  "capslock"),
+	DEFINE_LEDSTATE_TRIGGER(VC_KANALOCK,  "kanalock"),
+#undef DEFINE_LEDSTATE_TRIGGER
+};
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev);
+static struct led_trigger ledtrig_lockstate[] = {
+#define DEFINE_LOCKSTATE_TRIGGER(kbd_led, nam) \
+	[kbd_led] = { .name = nam, .activate = kbd_lockstate_trigger_activate, }
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLOCK,  "shiftlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTGRLOCK,  "altgrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLOCK,   "ctrllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_ALTLOCK,    "altlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTLLOCK, "shiftllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_SHIFTRLOCK, "shiftrlock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLLLOCK,  "ctrlllock"),
+	DEFINE_LOCKSTATE_TRIGGER(VC_CTRLRLOCK,  "ctrlrlock"),
+#undef DEFINE_LOCKSTATE_TRIGGER
+};
+
 /*
  * The leds display either (i) the status of NumLock, CapsLock, ScrollLock,
  * or (ii) whatever pattern of lights people want to show using KDSETLED,
@@ -1009,6 +1037,7 @@ static inline unsigned char getleds(void)
 
 	leds = kbd->ledflagstate;
 
+	/* TODO: should be replaced by a LED trigger */
 	if (kbd->ledmode == LED_SHOW_MEM) {
 		for (i = 0; i < 3; i++)
 			if (ledptrs[i].valid) {
@@ -1021,18 +1050,24 @@ static inline unsigned char getleds(void)
 	return leds;
 }
 
-static int kbd_update_leds_helper(struct input_handle *handle, void *data)
+/* Called on trigger connection, to set initial state */
+static void kbd_ledstate_trigger_activate(struct led_classdev *cdev)
 {
-	unsigned char leds = *(unsigned char *)data;
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_ledstate;
 
-	if (test_bit(EV_LED, handle->dev->evbit)) {
-		input_inject_event(handle, EV_LED, LED_SCROLLL, !!(leds & 0x01));
-		input_inject_event(handle, EV_LED, LED_NUML,    !!(leds & 0x02));
-		input_inject_event(handle, EV_LED, LED_CAPSL,   !!(leds & 0x04));
-		input_inject_event(handle, EV_SYN, SYN_REPORT, 0);
-	}
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, ledstate & (1 << led) ? LED_FULL : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_lockstate;
 
-	return 0;
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, lockstate & (1 << led) ? LED_FULL : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
 }
 
 /*
@@ -1047,10 +1082,24 @@ static void kbd_bh(unsigned long dummy)
 	unsigned char leds = getleds();
 
 	if (leds != ledstate) {
-		input_handler_for_each_handle(&kbd_handler, &leds,
-					      kbd_update_leds_helper);
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			if ((leds ^ ledstate) & (1 << i))
+				led_trigger_event(&ledtrig_ledstate[i],
+						leds & (1 << i)
+						? LED_FULL : LED_OFF);
 		ledstate = leds;
 	}
+
+	if (kbd->lockstate != lockstate) {
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+			if ((kbd->lockstate ^ lockstate) & (1 << i))
+				led_trigger_event(&ledtrig_lockstate[i],
+						kbd->lockstate & (1 << i)
+						? LED_FULL : LED_OFF);
+		lockstate = kbd->lockstate;
+	}
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1388,20 +1437,6 @@ static void kbd_disconnect(struct input_handle *handle)
 	kfree(handle);
 }
 
-/*
- * Start keyboard handler on the new keyboard by refreshing LED state to
- * match the rest of the system.
- */
-static void kbd_start(struct input_handle *handle)
-{
-	tasklet_disable(&keyboard_tasklet);
-
-	if (ledstate != 0xff)
-		kbd_update_leds_helper(handle, &ledstate);
-
-	tasklet_enable(&keyboard_tasklet);
-}
-
 static const struct input_device_id kbd_ids[] = {
 	{
                 .flags = INPUT_DEVICE_ID_MATCH_EVBIT,
@@ -1423,7 +1458,6 @@ static struct input_handler kbd_handler = {
 	.match		= kbd_match,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
-	.start		= kbd_start,
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1447,6 +1481,11 @@ int __init kbd_init(void)
 	if (error)
 		return error;
 
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+		led_trigger_register(&ledtrig_ledstate[i]);
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+		led_trigger_register(&ledtrig_lockstate[i]);
+
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 

--0F1p//8PRICkK4MW--
