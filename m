Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab2J0Crq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 22:47:46 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51733 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab2J0Cro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 22:47:44 -0400
Message-ID: <1351306051.12628.3.camel@phoenix>
Subject: [PATCH RFT] leds: blinkm: Avoid calling INIT_WORK in
 blinkm_led_common_set()
From: Axel Lin <axel.lin@ingics.com>
To: Jan-Simon Moeller <jansimon.moeller@gmx.de>, Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 27 Oct 2012 10:47:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling INIT_WORK in blinkm_led_common_set() means we init a workqueue every
time when brightness_set callback is called.
Move INIT_WORK to blinkm_probe() so we only need to init the workqueue once.

This patch also refactors the data structure of blinkm_data and blinkm_work.
Embedded struct blinkm_led in struct blinkm_work, and embedded struct
blinkm_work in blinkm_data. With this change, we don't need to allocate and free
memory for bl_work in blinkm_led_common_set() and led_work().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Jan-Simon,
  I don't have this hardware, can you help review and testing this patch.
Thank you,
Axel
 drivers/leds/leds-blinkm.c |   30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/leds/leds-blinkm.c b/drivers/leds/leds-blinkm.c
index f7c3d7f..5e4cd9b 100644
--- a/drivers/leds/leds-blinkm.c
+++ b/drivers/leds/leds-blinkm.c
@@ -44,7 +44,8 @@ struct blinkm_led {
 };
 
 struct blinkm_work {
-	struct blinkm_led *blinkm_led;
+	/* used for led class interface */
+	struct blinkm_led led;
 	struct work_struct work;
 };
 
@@ -54,8 +55,7 @@ struct blinkm_work {
 struct blinkm_data {
 	struct i2c_client *i2c_client;
 	struct mutex update_lock;
-	/* used for led class interface */
-	struct blinkm_led blinkm_leds[3];
+	struct blinkm_work bl_work[3];
 	/* used for "blinkm" sysfs interface */
 	u8 red;			/* color red */
 	u8 green;		/* color green */
@@ -446,12 +446,10 @@ static int blinkm_transfer_hw(struct i2c_client *client, int cmd)
 static void led_work(struct work_struct *work)
 {
 	int ret;
-	struct blinkm_led *led;
-	struct blinkm_data *data ;
 	struct blinkm_work *blm_work = work_to_blmwork(work);
+	struct blinkm_led *led = &blm_work->led;
+	struct blinkm_data *data = i2c_get_clientdata(led->i2c_client);
 
-	led = blm_work->blinkm_led;
-	data = i2c_get_clientdata(led->i2c_client);
 	ret = blinkm_transfer_hw(led->i2c_client, BLM_GO_RGB);
 	atomic_dec(&led->active);
 	dev_dbg(&led->i2c_client->dev,
@@ -459,7 +457,6 @@ static void led_work(struct work_struct *work)
 			" next_blue = %d, active = %d\n",
 			data->next_red, data->next_green,
 			data->next_blue, atomic_read(&led->active));
-	kfree(blm_work);
 }
 
 static int blinkm_led_common_set(struct led_classdev *led_cdev,
@@ -468,7 +465,7 @@ static int blinkm_led_common_set(struct led_classdev *led_cdev,
 	/* led_brightness is 0, 127 or 255 - we just use it here as-is */
 	struct blinkm_led *led = cdev_to_blmled(led_cdev);
 	struct blinkm_data *data = i2c_get_clientdata(led->i2c_client);
-	struct blinkm_work *bl_work;
+	struct blinkm_work *bl_work = &data->bl_work[color];
 
 	switch (color) {
 	case RED:
@@ -510,10 +507,6 @@ static int blinkm_led_common_set(struct led_classdev *led_cdev,
 		return -EINVAL;
 	}
 
-	bl_work = kzalloc(sizeof(*bl_work), GFP_ATOMIC);
-	if (!bl_work)
-		return -ENOMEM;
-
 	atomic_inc(&led->active);
 	dev_dbg(&led->i2c_client->dev,
 			"#TO_SCHED# next_red = %d, next_green = %d,"
@@ -521,9 +514,6 @@ static int blinkm_led_common_set(struct led_classdev *led_cdev,
 			data->next_red, data->next_green,
 			data->next_blue, atomic_read(&led->active));
 
-	/* a fresh work _item_ for each change */
-	bl_work->blinkm_led = led;
-	INIT_WORK(&bl_work->work, led_work);
 	/* queue work in own queue for easy sync on exit*/
 	schedule_work(&bl_work->work);
 
@@ -667,8 +657,9 @@ static int __devinit blinkm_probe(struct i2c_client *client,
 	}
 
 	for (i = 0; i < 3; i++) {
+		INIT_WORK(&data->bl_work[i].work, led_work);
 		/* RED = 0, GREEN = 1, BLUE = 2 */
-		led[i] = &data->blinkm_leds[i];
+		led[i] = &data->bl_work[i].led;
 		led[i]->i2c_client = client;
 		led[i]->id = i;
 		led[i]->led_cdev.max_brightness = 255;
@@ -746,13 +737,12 @@ exit:
 static int __devexit blinkm_remove(struct i2c_client *client)
 {
 	struct blinkm_data *data = i2c_get_clientdata(client);
-	int ret = 0;
-	int i;
+	int i, ret;
 
 	/* make sure no workqueue entries are pending */
 	for (i = 0; i < 3; i++) {
 		flush_scheduled_work();
-		led_classdev_unregister(&data->blinkm_leds[i].led_cdev);
+		led_classdev_unregister(&data->bl_work[i].led.led_cdev);
 	}
 
 	/* reset rgb */
-- 
1.7.9.5



