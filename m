Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1KNEGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 23:06:21 -0500
Received: from solo.fdn.fr ([80.67.169.19]:45674 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1KNEGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 23:06:20 -0500
Date: Mon, 14 Nov 2011 05:06:13 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org, jslaby@suse.cz,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [patch 20/35] leds: route kbd LEDs through the generic LEDs layer
Message-ID: <20111114040613.GA4992@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
	jslaby@suse.cz, rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
	Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>
References: <201011112205.oABM5KVJ005298@imap1.linux-foundation.org>
 <201011111440.07882.dmitry.torokhov@gmail.com>
 <20110102090935.GV32469@atrey.karlin.mff.cuni.cz>
 <20110102103210.GA25662@core.coreip.homeip.net>
 <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110112182702.GA9168@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, le Wed 12 Jan 2011 10:27:02 -0800, a écrit :
> > --- a/drivers/char/Kconfig
> > +++ b/drivers/char/Kconfig
> > @@ -8,6 +8,7 @@ config VT
> >  	bool "Virtual terminal" if EMBEDDED
> >  	depends on !S390
> >  	select INPUT
> > +	select LEDS_INPUT
> 
> This will not work as LEDS_INPUT is itself depends and selects other
> symbols and "select" statement does not propagate dependencies.
> 
> Anyway, I was looking at the patch this way and that and I convinced
> myself that while input should be integrated with LED subsystem doing it
> via an input handler is not the right way. Input handler is, by it's
> nature, an optional operation or an interface that exists to transform
> the input core data stream into some other form. Here OTOH we have a
> piece of hardware that we want to manage. I think the proper conversion
> would involve attaching led_classdev structures directly to input_dev
> objects and controlling them at the core level.

Here is (at last!) an updated & tested patch. It actually makes things
simpler, which is a good sign :)

I however don't know how to fix the issue about VT selecting INPUT_LEDS.

Samuel

From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: [PATCH] Route keyboard LEDs through the generic LEDs layer.

This permits to reassign keyboard LEDs to something else than keyboard "leds"
state, by adding keyboard led and modifier triggers connected to a series
of VT input LEDs, themselves connected to VT input triggers, which
per-input device LEDs use by default.  Userland can thus easily change the LED
behavior of (a priori) all input devices, or of particular input devices.

This also permits to fix #7063 from userland by using a modifier to implement
proper CapsLock behavior and have the keyboard caps lock led show that modifier
state.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
[ebroder@mokafive.com: Rebased to 3.2-rc1 or so, cleaned up some includes, and fixed some constants]
Signed-off-by: Evan Broder <evan@ebroder.net>

diff -ur linux-3.1-orig/Documentation/leds/leds-class.txt linux-3.1-morris/Documentation/leds/leds-class.txt
--- linux-3.1-orig/Documentation/leds/leds-class.txt	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/Documentation/leds/leds-class.txt	2011-11-13 22:01:22.107128241 +0100
@@ -2,9 +2,6 @@
 LED handling under Linux
 ========================
 
-If you're reading this and thinking about keyboard leds, these are
-handled by the input subsystem and the led class is *not* needed.
-
 In its simplest form, the LED class just allows control of LEDs from
 userspace. LEDs appear in /sys/class/leds/. The maximum brightness of the
 LED is defined in max_brightness file. The brightness file will set the brightness
diff -ur linux-3.1-orig/drivers/input/input.c linux-3.1-morris/drivers/input/input.c
--- linux-3.1-orig/drivers/input/input.c	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/drivers/input/input.c	2011-11-14 02:07:52.236943816 +0100
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/rcupdate.h>
 #include "input-compat.h"
+#include "leds.h"
 
 MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
 MODULE_DESCRIPTION("Input core");
@@ -632,6 +633,11 @@
 		handle->open = 0;
 
 	spin_unlock_irq(&dev->event_lock);
+
+#ifdef CONFIG_INPUT_LEDS
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_disconnect(dev);
+#endif
 }
 
 /**
@@ -1871,6 +1877,11 @@
 
 	list_add_tail(&dev->node, &input_dev_list);
 
+#ifdef CONFIG_INPUT_LEDS
+	if (is_event_supported(EV_LED, dev->evbit, EV_MAX))
+		input_led_connect(dev);
+#endif
+
 	list_for_each_entry(handler, &input_handler_list, node)
 		input_attach_handler(dev, handler);
 
diff -ur linux-3.1-orig/drivers/input/Kconfig linux-3.1-morris/drivers/input/Kconfig
--- linux-3.1-orig/drivers/input/Kconfig	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/drivers/input/Kconfig	2011-11-14 02:36:44.253817605 +0100
@@ -165,6 +165,15 @@
 
 source "drivers/input/keyboard/Kconfig"
 
+config INPUT_LEDS
+	tristate "LED Support"
+	depends on LEDS_CLASS
+	select LEDS_TRIGGERS
+	default y
+	help
+	  This option enables support for the LEDs on keyboard managed
+	  by the input layer.
+
 source "drivers/input/mouse/Kconfig"
 
 source "drivers/input/joystick/Kconfig"
diff -ur linux-3.1-orig/drivers/input/Makefile linux-3.1-morris/drivers/input/Makefile
--- linux-3.1-orig/drivers/input/Makefile	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/drivers/input/Makefile	2011-11-14 01:24:58.714209193 +0100
@@ -17,6 +17,7 @@
 obj-$(CONFIG_INPUT_EVBUG)	+= evbug.o
 
 obj-$(CONFIG_INPUT_KEYBOARD)	+= keyboard/
+obj-$(CONFIG_INPUT_LEDS)	+= leds.o
 obj-$(CONFIG_INPUT_MOUSE)	+= mouse/
 obj-$(CONFIG_INPUT_JOYSTICK)	+= joystick/
 obj-$(CONFIG_INPUT_TABLET)	+= tablet/
diff -ur linux-3.1-orig/drivers/leds/Kconfig linux-3.1-morris/drivers/leds/Kconfig
--- linux-3.1-orig/drivers/leds/Kconfig	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/drivers/leds/Kconfig	2011-11-14 01:21:11.743396542 +0100
@@ -11,9 +11,6 @@
 	  Say Y to enable Linux LED support.  This allows control of supported
 	  LEDs from both userspace and optionally, by kernel events (triggers).
 
-	  This is not related to standard keyboard LEDs which are controlled
-	  via the input system.
-
 if NEW_LEDS
 
 config LEDS_CLASS
diff -ur linux-3.1-orig/drivers/tty/Kconfig linux-3.1-morris/drivers/tty/Kconfig
--- linux-3.1-orig/drivers/tty/Kconfig	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/drivers/tty/Kconfig	2011-11-14 02:36:34.838014234 +0100
@@ -2,6 +2,7 @@
 	bool "Virtual terminal" if EXPERT
 	depends on !S390
 	select INPUT
+	select INPUT_LEDS
 	default y
 	---help---
 	  If you say Y here, you will get support for terminal devices with
diff -ur linux-3.1-orig/drivers/tty/vt/keyboard.c linux-3.1-morris/drivers/tty/vt/keyboard.c
--- linux-3.1-orig/drivers/tty/vt/keyboard.c	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/drivers/tty/vt/keyboard.c	2011-11-14 00:16:40.321709258 +0100
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -137,6 +138,7 @@
 static char rep;					/* flag telling character repeat */
 
 static unsigned char ledstate = 0xff;			/* undefined */
+static unsigned char lockstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
 static struct ledptr {
@@ -976,6 +978,32 @@
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
@@ -1008,6 +1036,7 @@
 
 	leds = kbd->ledflagstate;
 
+	/* TODO: should be replaced by a LED trigger */
 	if (kbd->ledmode == LED_SHOW_MEM) {
 		for (i = 0; i < 3; i++)
 			if (ledptrs[i].valid) {
@@ -1020,18 +1049,24 @@
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
@@ -1046,10 +1081,24 @@
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
@@ -1387,20 +1436,6 @@
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
@@ -1422,7 +1457,6 @@
 	.match		= kbd_match,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
-	.start		= kbd_start,
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1446,6 +1480,11 @@
 	if (error)
 		return error;
 
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+		led_trigger_register(&ledtrig_ledstate[i]);
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+		led_trigger_register(&ledtrig_lockstate[i]);
+
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
diff -ur linux-3.1-orig/include/linux/input.h linux-3.1-morris/include/linux/input.h
--- linux-3.1-orig/include/linux/input.h	2011-10-24 09:10:05.000000000 +0200
+++ linux-3.1-morris/include/linux/input.h	2011-11-14 01:42:50.930272764 +0100
@@ -1267,6 +1267,8 @@
 	unsigned long snd[BITS_TO_LONGS(SND_CNT)];
 	unsigned long sw[BITS_TO_LONGS(SW_CNT)];
 
+	struct led_classdev *leds;
+
 	int (*open)(struct input_dev *dev);
 	void (*close)(struct input_dev *dev);
 	int (*flush)(struct input_dev *dev, struct file *file);
--- linux-3.1-orig/drivers/input/leds.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.1-morris/drivers/input/leds.h	2011-11-14 02:24:26.738456456 +0100
@@ -0,0 +1,14 @@
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
+#include <linux/input.h>
+
+extern int input_led_connect(struct input_dev *dev);
+extern void input_led_disconnect(struct input_dev *dev);
--- linux-3.1-orig/drivers/input/leds.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.1-morris/drivers/input/leds.c	2011-11-14 03:23:07.578469395 +0100
@@ -0,0 +1,243 @@
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
+/* Number of input devices having each LED */
+static int vt_led_references[LED_CNT];
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
+	struct input_dev *dev;
+	struct led_classdev *leds;
+	int led;
+
+	dev = cdev->dev->platform_data;
+	if (!dev)
+		/* Still initializing */
+		return;
+	leds = dev->leds;
+	led = cdev - leds;
+
+	input_event(dev, EV_LED, led, !!brightness);
+	input_event(dev, EV_SYN, SYN_REPORT, 0);
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
+/* Free led stuff from input device, used at abortion and disconnection.  */
+static void input_led_delete(struct input_dev *dev)
+{
+	if (dev) {
+		struct led_classdev *leds = dev->leds;
+		if (leds) {
+			int i;
+			for (i = 0; i < LED_CNT; i++)
+				kfree(leds[i].name);
+			kfree(leds);
+			dev->leds = NULL;
+		}
+	}
+}
+
+/* A new input device with potential LEDs to connect.  */
+int input_led_connect(struct input_dev *dev)
+{
+	int i, error = 0;
+	struct led_classdev *leds;
+
+	dev->leds = leds = kzalloc(sizeof(*leds) * LED_CNT, GFP_KERNEL);
+	if (!dev->leds)
+		return -ENOMEM;
+
+	/* lazily register missing VT LEDs */
+	mutex_lock(&vt_led_registered_lock);
+	for (i = 0; i < LED_CNT; i++)
+		if (vt_leds[i].name && test_bit(i, dev->ledbit)) {
+			if (!vt_led_references[i]) {
+				led_trigger_register(&vt_led_triggers[i]);
+				/* This keyboard is first to have led i,
+				 * try to register it */
+				if (!led_classdev_register(NULL, &vt_leds[i]))
+					vt_led_references[i] = 1;
+				else
+					led_trigger_unregister(&vt_led_triggers[i]);
+			} else
+				vt_led_references[i]++;
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
+				goto err;
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
+			leds[i].dev->platform_data = dev;
+			perdevice_input_led_set(&leds[i],
+					vt_leds[i].brightness);
+		}
+
+	return 0;
+
+err:
+	input_led_delete(dev);
+	return error;
+}
+
+/* Disconnected input device. Clean it, and deregister now-useless VT LEDs
+ * and triggers.  */
+extern void input_led_disconnect(struct input_dev *dev)
+{
+	int i;
+	struct led_classdev *leds = dev->leds;
+
+	for (i = 0; i < LED_CNT; i++)
+		if (leds[i].name)
+			led_classdev_unregister(&leds[i]);
+
+	input_led_delete(dev);
+
+	mutex_lock(&vt_led_registered_lock);
+	for (i = 0; i < LED_CNT; i++) {
+		if (!vt_leds[i].name || !test_bit(i, dev->ledbit))
+			continue;
+
+		vt_led_references[i]--;
+		if (vt_led_references[i]) {
+			/* Still some devices needing it */
+			continue;
+		}
+
+		led_classdev_unregister(&vt_leds[i]);
+		led_trigger_unregister(&vt_led_triggers[i]);
+		clear_bit(i, vt_led_registered);
+	}
+	mutex_unlock(&vt_led_registered_lock);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("User LED support for input layer");
+MODULE_AUTHOR("Samuel Thibault <samuel.thibault@ens-lyon.org>");
