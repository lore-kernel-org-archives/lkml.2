Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2HKKe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2HKKeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:34:04 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3/4] radio-shark: Only compile led support when CONFIG_LED_CLASS is set
Date: Sat, 11 Aug 2012 12:34:54 +0200
Message-Id: <1344681295-2485-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
References: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark.c | 135 ++++++++++++++++++++++----------------
 1 file changed, 79 insertions(+), 56 deletions(-)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 05e12bf..e1970bf 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -35,6 +35,11 @@
 #include <media/v4l2-device.h>
 #include <sound/tea575x-tuner.h>
 
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
+#define SHARK_USE_LEDS 1
+#endif
+
 /*
  * Version Information
  */
@@ -56,44 +61,18 @@ MODULE_LICENSE("GPL");
 
 enum { BLUE_LED, BLUE_PULSE_LED, RED_LED, NO_LEDS };
 
-static void shark_led_set_blue(struct led_classdev *led_cdev,
-			       enum led_brightness value);
-static void shark_led_set_blue_pulse(struct led_classdev *led_cdev,
-				     enum led_brightness value);
-static void shark_led_set_red(struct led_classdev *led_cdev,
-			      enum led_brightness value);
-
-static const struct led_classdev shark_led_templates[NO_LEDS] = {
-	[BLUE_LED] = {
-		.name		= "%s:blue:",
-		.brightness	= LED_OFF,
-		.max_brightness = 127,
-		.brightness_set = shark_led_set_blue,
-	},
-	[BLUE_PULSE_LED] = {
-		.name		= "%s:blue-pulse:",
-		.brightness	= LED_OFF,
-		.max_brightness = 255,
-		.brightness_set = shark_led_set_blue_pulse,
-	},
-	[RED_LED] = {
-		.name		= "%s:red:",
-		.brightness	= LED_OFF,
-		.max_brightness = 1,
-		.brightness_set = shark_led_set_red,
-	},
-};
-
 struct shark_device {
 	struct usb_device *usbdev;
 	struct v4l2_device v4l2_dev;
 	struct snd_tea575x tea;
 
+#ifdef SHARK_USE_LEDS
 	struct work_struct led_work;
 	struct led_classdev leds[NO_LEDS];
 	char led_names[NO_LEDS][32];
 	atomic_t brightness[NO_LEDS];
 	unsigned long brightness_new;
+#endif
 
 	u8 *transfer_buffer;
 	u32 last_val;
@@ -175,6 +154,7 @@ static struct snd_tea575x_ops shark_tea_ops = {
 	.read_val  = shark_read_val,
 };
 
+#ifdef SHARK_USE_LEDS
 static void shark_led_work(struct work_struct *work)
 {
 	struct shark_device *shark =
@@ -235,21 +215,78 @@ static void shark_led_set_red(struct led_classdev *led_cdev,
 	schedule_work(&shark->led_work);
 }
 
+static const struct led_classdev shark_led_templates[NO_LEDS] = {
+	[BLUE_LED] = {
+		.name		= "%s:blue:",
+		.brightness	= LED_OFF,
+		.max_brightness = 127,
+		.brightness_set = shark_led_set_blue,
+	},
+	[BLUE_PULSE_LED] = {
+		.name		= "%s:blue-pulse:",
+		.brightness	= LED_OFF,
+		.max_brightness = 255,
+		.brightness_set = shark_led_set_blue_pulse,
+	},
+	[RED_LED] = {
+		.name		= "%s:red:",
+		.brightness	= LED_OFF,
+		.max_brightness = 1,
+		.brightness_set = shark_led_set_red,
+	},
+};
+
+static int shark_register_leds(struct shark_device *shark, struct device *dev)
+{
+	int i, retval;
+
+	INIT_WORK(&shark->led_work, shark_led_work);
+	for (i = 0; i < NO_LEDS; i++) {
+		shark->leds[i] = shark_led_templates[i];
+		snprintf(shark->led_names[i], sizeof(shark->led_names[0]),
+			 shark->leds[i].name, shark->v4l2_dev.name);
+		shark->leds[i].name = shark->led_names[i];
+		retval = led_classdev_register(dev, &shark->leds[i]);
+		if (retval) {
+			v4l2_err(&shark->v4l2_dev,
+				 "couldn't register led: %s\n",
+				 shark->led_names[i]);
+			return retval;
+		}
+	}
+	return 0;
+}
+
+static void shark_unregister_leds(struct shark_device *shark)
+{
+	int i;
+
+	for (i = 0; i < NO_LEDS; i++)
+		led_classdev_unregister(&shark->leds[i]);
+
+	cancel_work_sync(&shark->led_work);
+}
+#else
+static int shark_register_leds(struct shark_device *shark, struct device *dev)
+{
+	v4l2_warn(&shark->v4l2_dev,
+		  "CONFIG_LED_CLASS not enabled, LED support disabled\n");
+	return 0;
+}
+static inline void shark_unregister_leds(struct shark_device *shark) { }
+#endif
+
 static void usb_shark_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v4l2_dev = usb_get_intfdata(intf);
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
-	int i;
 
 	mutex_lock(&shark->tea.mutex);
 	v4l2_device_disconnect(&shark->v4l2_dev);
 	snd_tea575x_exit(&shark->tea);
 	mutex_unlock(&shark->tea.mutex);
 
-	for (i = 0; i < NO_LEDS; i++)
-		led_classdev_unregister(&shark->leds[i]);
-
-	cancel_work_sync(&shark->led_work);
+	shark_unregister_leds(shark);
 
 	v4l2_device_put(&shark->v4l2_dev);
 }
@@ -267,7 +304,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 			   const struct usb_device_id *id)
 {
 	struct shark_device *shark;
-	int i, retval = -ENOMEM;
+	int retval = -ENOMEM;
 
 	shark = kzalloc(sizeof(struct shark_device), GFP_KERNEL);
 	if (!shark)
@@ -277,8 +314,13 @@ static int usb_shark_probe(struct usb_interface *intf,
 	if (!shark->transfer_buffer)
 		goto err_alloc_buffer;
 
-	shark->v4l2_dev.release = usb_shark_release;
 	v4l2_device_set_name(&shark->v4l2_dev, DRV_NAME, &shark_instance);
+
+	retval = shark_register_leds(shark, &intf->dev);
+	if (retval)
+		goto err_reg_leds;
+
+	shark->v4l2_dev.release = usb_shark_release;
 	retval = v4l2_device_register(&intf->dev, &shark->v4l2_dev);
 	if (retval) {
 		v4l2_err(&shark->v4l2_dev, "couldn't register v4l2_device\n");
@@ -303,32 +345,13 @@ static int usb_shark_probe(struct usb_interface *intf,
 		goto err_init_tea;
 	}
 
-	INIT_WORK(&shark->led_work, shark_led_work);
-	for (i = 0; i < NO_LEDS; i++) {
-		shark->leds[i] = shark_led_templates[i];
-		snprintf(shark->led_names[i], sizeof(shark->led_names[0]),
-			 shark->leds[i].name, shark->v4l2_dev.name);
-		shark->leds[i].name = shark->led_names[i];
-		/*
-		 * We don't fail the probe if we fail to register the leds,
-		 * because once we've called snd_tea575x_init, the /dev/radio0
-		 * node may be opened from userspace holding a reference to us!
-		 *
-		 * Note we cannot register the leds first instead as
-		 * shark_led_work depends on the v4l2 mutex and registered bit.
-		 */
-		retval = led_classdev_register(&intf->dev, &shark->leds[i]);
-		if (retval)
-			v4l2_err(&shark->v4l2_dev,
-				 "couldn't register led: %s\n",
-				 shark->led_names[i]);
-	}
-
 	return 0;
 
 err_init_tea:
 	v4l2_device_unregister(&shark->v4l2_dev);
 err_reg_dev:
+	shark_unregister_leds(shark);
+err_reg_leds:
 	kfree(shark->transfer_buffer);
 err_alloc_buffer:
 	kfree(shark);
-- 
1.7.11.4

