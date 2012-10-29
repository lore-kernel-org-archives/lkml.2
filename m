Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab2J2FLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:11:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59652 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2J2FLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:11:41 -0400
Message-ID: <1351487489.18143.3.camel@phoenix>
Subject: [PATCH RFT] leds: blinkm: Don't init a workqueue per brightness_set
 call
From: Axel Lin <axel.lin@ingics.com>
To: Jan-Simon Moeller <jansimon.moeller@gmx.de>, Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Oct 2012 13:11:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling INIT_WORK in blinkm_led_common_set() means we init a workqueue every time
when brightness_set callback is called.
Move INIT_WORK to blinkm_probe() so we only need to init the workqueue once.

So we only need to init a workqueue per blinkm led rather than init a workqueue
per brightness_set call.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
This patch is v2 of "[PATCH RFT] leds: blinkm: Avoid calling INIT_WORK in blinkm_led_common_set()"
I think the new subject line is better for the reason I sent the patch.

v2:
Now we have a workqueue per blinkm led.
I think the code can be simpler and has better readability if we embeded
struct work_struct in struct blinkm_led.

Note I don't have this hardware, so I added Request-For-Test (RFT) in the subject line.
Axel

 drivers/leds/leds-blinkm.c |   30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/leds/leds-blinkm.c b/drivers/leds/leds-blinkm.c
index f7c3d7f..b62d214 100644
--- a/drivers/leds/leds-blinkm.c
+++ b/drivers/leds/leds-blinkm.c
@@ -37,19 +37,15 @@ static int blinkm_transfer_hw(struct i2c_client *client, int cmd);
 static int blinkm_test_run(struct i2c_client *client);
 
 struct blinkm_led {
+	struct work_struct work;
 	struct i2c_client *i2c_client;
 	struct led_classdev led_cdev;
 	int id;
 	atomic_t active;
 };
 
-struct blinkm_work {
-	struct blinkm_led *blinkm_led;
-	struct work_struct work;
-};
-
 #define cdev_to_blmled(c)          container_of(c, struct blinkm_led, led_cdev)
-#define work_to_blmwork(c)         container_of(c, struct blinkm_work, work)
+#define work_to_blmled(c)         container_of(c, struct blinkm_led, work)
 
 struct blinkm_data {
 	struct i2c_client *i2c_client;
@@ -446,12 +442,9 @@ static int blinkm_transfer_hw(struct i2c_client *client, int cmd)
 static void led_work(struct work_struct *work)
 {
 	int ret;
-	struct blinkm_led *led;
-	struct blinkm_data *data ;
-	struct blinkm_work *blm_work = work_to_blmwork(work);
+	struct blinkm_led *led = work_to_blmled(work);
+	struct blinkm_data *data = i2c_get_clientdata(led->i2c_client);
 
-	led = blm_work->blinkm_led;
-	data = i2c_get_clientdata(led->i2c_client);
 	ret = blinkm_transfer_hw(led->i2c_client, BLM_GO_RGB);
 	atomic_dec(&led->active);
 	dev_dbg(&led->i2c_client->dev,
@@ -459,7 +452,6 @@ static void led_work(struct work_struct *work)
 			" next_blue = %d, active = %d\n",
 			data->next_red, data->next_green,
 			data->next_blue, atomic_read(&led->active));
-	kfree(blm_work);
 }
 
 static int blinkm_led_common_set(struct led_classdev *led_cdev,
@@ -468,7 +460,6 @@ static int blinkm_led_common_set(struct led_classdev *led_cdev,
 	/* led_brightness is 0, 127 or 255 - we just use it here as-is */
 	struct blinkm_led *led = cdev_to_blmled(led_cdev);
 	struct blinkm_data *data = i2c_get_clientdata(led->i2c_client);
-	struct blinkm_work *bl_work;
 
 	switch (color) {
 	case RED:
@@ -510,10 +501,6 @@ static int blinkm_led_common_set(struct led_classdev *led_cdev,
 		return -EINVAL;
 	}
 
-	bl_work = kzalloc(sizeof(*bl_work), GFP_ATOMIC);
-	if (!bl_work)
-		return -ENOMEM;
-
 	atomic_inc(&led->active);
 	dev_dbg(&led->i2c_client->dev,
 			"#TO_SCHED# next_red = %d, next_green = %d,"
@@ -521,11 +508,8 @@ static int blinkm_led_common_set(struct led_classdev *led_cdev,
 			data->next_red, data->next_green,
 			data->next_blue, atomic_read(&led->active));
 
-	/* a fresh work _item_ for each change */
-	bl_work->blinkm_led = led;
-	INIT_WORK(&bl_work->work, led_work);
 	/* queue work in own queue for easy sync on exit*/
-	schedule_work(&bl_work->work);
+	schedule_work(&led->work);
 
 	return 0;
 }
@@ -667,6 +651,7 @@ static int __devinit blinkm_probe(struct i2c_client *client,
 	}
 
 	for (i = 0; i < 3; i++) {
+		INIT_WORK(&data->blinkm_leds[i].work, led_work);
 		/* RED = 0, GREEN = 1, BLUE = 2 */
 		led[i] = &data->blinkm_leds[i];
 		led[i]->i2c_client = client;
@@ -746,8 +731,7 @@ exit:
 static int __devexit blinkm_remove(struct i2c_client *client)
 {
 	struct blinkm_data *data = i2c_get_clientdata(client);
-	int ret = 0;
-	int i;
+	int i, ret;
 
 	/* make sure no workqueue entries are pending */
 	for (i = 0; i < 3; i++) {
-- 
1.7.9.5



