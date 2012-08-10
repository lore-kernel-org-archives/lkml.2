Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab2HJT6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:58:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab2HJT5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:57:36 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/2] radio-shark: Only compile led support when CONFIG_LED_CLASS is set
Date: Fri, 10 Aug 2012 21:58:05 +0200
Message-Id: <1344628686-10482-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Dadiv Rientjes <rientjes@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index c2ead23..f746ed0 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -27,7 +27,6 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
@@ -35,6 +34,12 @@
 #include <media/v4l2-device.h>
 #include <sound/tea575x-tuner.h>
 
+#if defined(CONFIG_LEDS_CLASS) || \
+    (defined(CONFIG_LEDS_CLASS_MODULE) && defined(CONFIG_RADIO_SHARK_MODULE))
+#include <linux/leds.h>
+#define SHARK_USE_LEDS 1
+#endif
+
 /*
  * Version Information
  */
@@ -54,6 +59,7 @@ MODULE_LICENSE("GPL");
 
 #define v4l2_dev_to_shark(d) container_of(d, struct shark_device, v4l2_dev)
 
+#ifdef SHARK_USE_LEDS
 enum { BLUE_LED, BLUE_PULSE_LED, RED_LED, NO_LEDS };
 
 static void shark_led_set_blue(struct led_classdev *led_cdev,
@@ -83,17 +89,20 @@ static const struct led_classdev shark_led_templates[NO_LEDS] = {
 		.brightness_set = shark_led_set_red,
 	},
 };
+#endif
 
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
@@ -175,6 +184,7 @@ static struct snd_tea575x_ops shark_tea_ops = {
 	.read_val  = shark_read_val,
 };
 
+#ifdef SHARK_USE_LEDS
 static void shark_led_work(struct work_struct *work)
 {
 	struct shark_device *shark =
@@ -244,20 +254,25 @@ static void shark_led_set_red(struct led_classdev *led_cdev,
 	set_bit(RED_LED, &shark->brightness_new);
 	schedule_work(&shark->led_work);
 }
+#endif
 
 static void usb_shark_disconnect(struct usb_interface *intf)
 {
 	struct v4l2_device *v4l2_dev = usb_get_intfdata(intf);
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
+#ifdef SHARK_USE_LEDS
 	int i;
+#endif
 
 	mutex_lock(&shark->tea.mutex);
 	v4l2_device_disconnect(&shark->v4l2_dev);
 	snd_tea575x_exit(&shark->tea);
 	mutex_unlock(&shark->tea.mutex);
 
+#ifdef SHARK_USE_LEDS
 	for (i = 0; i < NO_LEDS; i++)
 		led_classdev_unregister(&shark->leds[i]);
+#endif
 
 	v4l2_device_put(&shark->v4l2_dev);
 }
@@ -266,7 +281,9 @@ static void usb_shark_release(struct v4l2_device *v4l2_dev)
 {
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
 
+#ifdef SHARK_USE_LEDS
 	cancel_work_sync(&shark->led_work);
+#endif
 	v4l2_device_unregister(&shark->v4l2_dev);
 	kfree(shark->transfer_buffer);
 	kfree(shark);
@@ -276,7 +293,10 @@ static int usb_shark_probe(struct usb_interface *intf,
 			   const struct usb_device_id *id)
 {
 	struct shark_device *shark;
-	int i, retval = -ENOMEM;
+	int retval = -ENOMEM;
+#ifdef SHARK_USE_LEDS
+	int i;
+#endif
 
 	shark = kzalloc(sizeof(struct shark_device), GFP_KERNEL);
 	if (!shark)
@@ -321,6 +341,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 		goto err_init_tea;
 	}
 
+#ifdef SHARK_USE_LEDS
 	INIT_WORK(&shark->led_work, shark_led_work);
 	for (i = 0; i < NO_LEDS; i++) {
 		shark->leds[i] = shark_led_templates[i];
@@ -341,6 +362,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 				 "couldn't register led: %s\n",
 				 shark->led_names[i]);
 	}
+#endif
 
 	return 0;
 
-- 
1.7.11.4

