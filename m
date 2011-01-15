Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1AOWW7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 17:22:59 -0500
Received: from solo.fdn.fr ([80.67.169.19]:45561 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab1AOWW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 17:22:58 -0500
Date: Sat, 15 Jan 2011 20:09:43 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, jslaby@suse.cz,
        rpurdie@rpsys.net, arnaud.patard@rtp-net.org
Subject: Re: [patch 20/35] leds: route kbd LEDs through the generic LEDs layer
Message-ID: <20110115190943.GC6678@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
	jslaby@suse.cz, rpurdie@rpsys.net, arnaud.patard@rtp-net.org
References: <201011112205.oABM5KVJ005298@imap1.linux-foundation.org> <201011111440.07882.dmitry.torokhov@gmail.com> <20110102090935.GV32469@atrey.karlin.mff.cuni.cz> <20110102103210.GA25662@core.coreip.homeip.net> <20110102225741.GX5480@const.famille.thibault.fr> <20110112182702.GA9168@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110112182702.GA9168@core.coreip.homeip.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov, le Wed 12 Jan 2011 10:27:02 -0800, a écrit :
> > index 43d3395..0e2c9ba 100644
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

Sure, I didn't expect it to be building fine as it was completely
untested, it was rather just to show some code :)

> Anyway, I was looking at the patch this way and that and I convinced
> myself that while input should be integrated with LED subsystem doing it
> via an input handler is not the right way. Input handler is, by it's
> nature, an optional operation or an interface that exists to transform
> the input core data stream into some other form. Here OTOH we have a
> piece of hardware that we want to manage. I think the proper conversion
> would involve attaching led_classdev structures directly to input_dev
> objects and controlling them at the core level.

Mmm, you mean, something like the patch below, which embeds the led
devices inside the input structure? (don't even try to build with the
patch below, again it's just to show code which is usually clearer than
phrases :) ; it can probably be made #if CONFIG_LEDS BTW)

Where would you prefer the vt-global virtual leds to go to? In
keyboard.c or in a new file in drivers/leds/ for instances? Same
question for the keyboard state triggers, which I had put into
keyboard.c but Arnaud had put in a new file, but thus needing to pass
through an input handler again.

Samuel

diff -urp linux-2.6.37-orig/drivers/input/input.c linux-2.6.37-perso/drivers/input/input.c
--- linux-2.6.37-orig/drivers/input/input.c	2011-01-05 03:16:31.000000000 +0100
+++ linux-2.6.37-perso/drivers/input/input.c	2011-01-15 20:01:36.000000000 +0100
@@ -404,6 +404,19 @@ void input_inject_event(struct input_han
 }
 EXPORT_SYMBOL(input_inject_event);
 
+static void input_led_set(struct led_classdev *cdev,
+			  enum led_brightness brightness)
+{
+	dev = cdev->dev;
+	input_dev = struct_up(dev);
+
+	lock_stuff();
+	input_handle_event(input_dev, NULL, EV_LED, led, !!brightness);
+	input_handle_event(input_dev, NULL, EV_SYN, SYN_REPORT, 0);
+	unlock_stuff();
+}
+
+
 /**
  * input_alloc_absinfo - allocates array of input_absinfo structs
  * @dev: the input device emitting absolute events
@@ -1907,6 +1920,18 @@ int input_register_device(struct input_d
 		dev->name ? dev->name : "Unspecified device", path ? path : "N/A");
 	kfree(path);
 
+	if (evbit[EV_LED]) {
+		for (i = 0; i < LED_CNT; i++) {
+			if (test_bit(i, dev->ledbits)) {
+				initialize_stuff(&dev->leds[i]);
+				dev->leds[i].brightness_set = input_led_set;
+				dev->leds[i].default_trigger = vt_led_triggers[i].name;
+				led_classdev_register(&dev->dev, &dev->leds[i]);
+				lazily_register_vt_led(i);
+			}
+		}
+	}
+
 	error = mutex_lock_interruptible(&input_mutex);
 	if (error) {
 		device_del(&dev->dev);
@@ -1952,6 +1977,15 @@ void input_unregister_device(struct inpu
 
 	mutex_unlock(&input_mutex);
 
+	if (evbit[EV_LED]) {
+		for (i = 0; i < LED_CNT; i++) {
+			if (test_bit(i, dev->ledbits)) {
+				led_classdev_unregister(&dev->leds[i]);
+				lazily_unregister_vt_led(i);
+			}
+		}
+	}
+
 	device_unregister(&dev->dev);
 }
 EXPORT_SYMBOL(input_unregister_device);
diff -urp linux-2.6.37-orig/drivers/tty/vt/keyboard.c linux-2.6.37-perso/drivers/tty/vt/keyboard.c
--- linux-2.6.37-orig/drivers/tty/vt/keyboard.c	2011-01-05 03:17:37.000000000 +0100
+++ linux-2.6.37-perso/drivers/tty/vt/keyboard.c	2011-01-15 19:37:47.000000000 +0100
@@ -36,6 +36,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/leds.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
@@ -139,6 +140,7 @@ static unsigned int diacr;
 static char rep;					/* flag telling character repeat */
 
 static unsigned char ledstate = 0xff;			/* undefined */
+static unsigned char lockstate = 0xff;			/* undefined */
 static unsigned char ledioctl;
 
 static struct ledptr {
@@ -977,6 +979,33 @@ static void k_brl(struct vc_data *vc, un
 	}
 }
 
+/* VT keyboard lock states are exposed through triggers used by default by the
+ * central VT leds */
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
@@ -1009,6 +1038,7 @@ static inline unsigned char getleds(void
 
 	leds = kbd->ledflagstate;
 
+	/* TODO: reimplement in input LED layer */
 	if (kbd->ledmode == LED_SHOW_MEM) {
 		for (i = 0; i < 3; i++)
 			if (ledptrs[i].valid) {
@@ -1021,18 +1051,24 @@ static inline unsigned char getleds(void
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
+	led_trigger_event(trigger, ledstate & (1 << led) ? INT_MAX : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
+}
+static void kbd_lockstate_trigger_activate(struct led_classdev *cdev)
+{
+	struct led_trigger *trigger = cdev->trigger;
+	int led = trigger - ledtrig_lockstate;
 
-	return 0;
+	tasklet_disable(&keyboard_tasklet);
+	led_trigger_event(trigger, lockstate & (1 << led) ? INT_MAX : LED_OFF);
+	tasklet_enable(&keyboard_tasklet);
 }
 
 /*
@@ -1047,10 +1083,24 @@ static void kbd_bh(unsigned long dummy)
 	unsigned char leds = getleds();
 
 	if (leds != ledstate) {
-		input_handler_for_each_handle(&kbd_handler, &leds,
-					      kbd_update_leds_helper);
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+			if ((leds ^ ledstate) & (1 << i))
+				led_trigger_event(&ledtrig_ledstate[i],
+						leds & (1 << i)
+						? INT_MAX : LED_OFF);
 		ledstate = leds;
 	}
+
+	if (kbd->lockstate != lockstate) {
+		int i;
+		for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+			if ((kbd->lockstate ^ lockstate) & (1 << i))
+				led_trigger_event(&ledtrig_lockstate[i],
+						kbd->lockstate & (1 << i)
+						? INT_MAX : LED_OFF);
+		lockstate = kbd->lockstate;
+	}
 }
 
 DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
@@ -1388,20 +1438,6 @@ static void kbd_disconnect(struct input_
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
@@ -1423,7 +1459,6 @@ static struct input_handler kbd_handler
 	.match		= kbd_match,
 	.connect	= kbd_connect,
 	.disconnect	= kbd_disconnect,
-	.start		= kbd_start,
 	.name		= "kbd",
 	.id_table	= kbd_ids,
 };
@@ -1450,5 +1485,10 @@ int __init kbd_init(void)
 	tasklet_enable(&keyboard_tasklet);
 	tasklet_schedule(&keyboard_tasklet);
 
+	for (i = 0; i < ARRAY_SIZE(ledtrig_ledstate); i++)
+		led_trigger_register(&ledtrig_ledstate[i]);
+	for (i = 0; i < ARRAY_SIZE(ledtrig_lockstate); i++)
+		led_trigger_register(&ledtrig_lockstate[i]);
+
 	return 0;
 }
