Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2HKKe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:34:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2HKKeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:34:01 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/4] radio-shark*: Call cancel_work_sync from disconnect rather then release
Date: Sat, 11 Aug 2012 12:34:53 +0200
Message-Id: <1344681295-2485-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
References: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the need for shark_led_work to take the v4l2 lock.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-shark.c  | 13 ++-----------
 drivers/media/radio/radio-shark2.c | 12 ++----------
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 6117132..05e12bf 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -181,14 +181,6 @@ static void shark_led_work(struct work_struct *work)
 		container_of(work, struct shark_device, led_work);
 	int i, res, brightness, actual_len;
 
-	/*
-	 * We use the v4l2_dev lock and registered bit to ensure the device
-	 * does not get unplugged and unreffed while we're running.
-	 */
-	mutex_lock(&shark->tea.mutex);
-	if (!video_is_registered(&shark->tea.vd))
-		goto leave;
-
 	for (i = 0; i < 3; i++) {
 		if (!test_and_clear_bit(i, &shark->brightness_new))
 			continue;
@@ -208,8 +200,6 @@ static void shark_led_work(struct work_struct *work)
 			v4l2_err(&shark->v4l2_dev, "set LED %s error: %d\n",
 				 shark->led_names[i], res);
 	}
-leave:
-	mutex_unlock(&shark->tea.mutex);
 }
 
 static void shark_led_set_blue(struct led_classdev *led_cdev,
@@ -259,6 +249,8 @@ static void usb_shark_disconnect(struct usb_interface *intf)
 	for (i = 0; i < NO_LEDS; i++)
 		led_classdev_unregister(&shark->leds[i]);
 
+	cancel_work_sync(&shark->led_work);
+
 	v4l2_device_put(&shark->v4l2_dev);
 }
 
@@ -266,7 +258,6 @@ static void usb_shark_release(struct v4l2_device *v4l2_dev)
 {
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
 
-	cancel_work_sync(&shark->led_work);
 	v4l2_device_unregister(&shark->v4l2_dev);
 	kfree(shark->transfer_buffer);
 	kfree(shark);
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index fc0289d..217483c 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -166,13 +166,6 @@ static void shark_led_work(struct work_struct *work)
 	struct shark_device *shark =
 		container_of(work, struct shark_device, led_work);
 	int i, res, brightness, actual_len;
-	/*
-	 * We use the v4l2_dev lock and registered bit to ensure the device
-	 * does not get unplugged and unreffed while we're running.
-	 */
-	mutex_lock(&shark->tea.mutex);
-	if (!video_is_registered(&shark->tea.vd))
-		goto leave;
 
 	for (i = 0; i < 2; i++) {
 		if (!test_and_clear_bit(i, &shark->brightness_new))
@@ -191,8 +184,6 @@ static void shark_led_work(struct work_struct *work)
 			v4l2_err(&shark->v4l2_dev, "set LED %s error: %d\n",
 				 shark->led_names[i], res);
 	}
-leave:
-	mutex_unlock(&shark->tea.mutex);
 }
 
 static void shark_led_set_blue(struct led_classdev *led_cdev,
@@ -231,6 +222,8 @@ static void usb_shark_disconnect(struct usb_interface *intf)
 	for (i = 0; i < NO_LEDS; i++)
 		led_classdev_unregister(&shark->leds[i]);
 
+	cancel_work_sync(&shark->led_work);
+
 	v4l2_device_put(&shark->v4l2_dev);
 }
 
@@ -238,7 +231,6 @@ static void usb_shark_release(struct v4l2_device *v4l2_dev)
 {
 	struct shark_device *shark = v4l2_dev_to_shark(v4l2_dev);
 
-	cancel_work_sync(&shark->led_work);
 	v4l2_device_unregister(&shark->v4l2_dev);
 	kfree(shark->transfer_buffer);
 	kfree(shark);
-- 
1.7.11.4

