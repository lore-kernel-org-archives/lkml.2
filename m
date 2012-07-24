Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2GXG36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:29:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35416 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2GXG34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:29:56 -0400
Message-ID: <1343111387.10661.1.camel@phoenix>
Subject: [PATCH RFT] leds: max8997: Simplify max8997_led_set_mode
 implementation
From: Axel Lin <axel.lin@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Donggeun Kim <dg77.kim@samsung.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Jul 2012 14:29:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to call max8997_update_reg() twice just for updating
MAX8997_REG_LEN_CNTL register. With proper val and mask arguments to
max8997_update_reg() call, this can be done in one max8997_update_reg() call.
And then we can remove max8997_led_clear_mode() function.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-max8997.c |   60 ++++++++++---------------------------------
 1 file changed, 13 insertions(+), 47 deletions(-)

diff --git a/drivers/leds/leds-max8997.c b/drivers/leds/leds-max8997.c
index bf86d54..569e36d 100644
--- a/drivers/leds/leds-max8997.c
+++ b/drivers/leds/leds-max8997.c
@@ -49,71 +49,37 @@ struct max8997_led {
 	struct mutex mutex;
 };
 
-static void max8997_led_clear_mode(struct max8997_led *led,
-			enum max8997_led_mode mode)
-{
-	struct i2c_client *client = led->iodev->i2c;
-	u8 val = 0, mask = 0;
-	int ret;
-
-	switch (mode) {
-	case MAX8997_FLASH_MODE:
-		mask = led->id ?
-		      MAX8997_LED1_FLASH_MASK : MAX8997_LED0_FLASH_MASK;
-		break;
-	case MAX8997_MOVIE_MODE:
-		mask = led->id ?
-		      MAX8997_LED1_MOVIE_MASK : MAX8997_LED0_MOVIE_MASK;
-		break;
-	case MAX8997_FLASH_PIN_CONTROL_MODE:
-		mask = led->id ?
-		      MAX8997_LED1_FLASH_PIN_MASK : MAX8997_LED0_FLASH_PIN_MASK;
-		break;
-	case MAX8997_MOVIE_PIN_CONTROL_MODE:
-		mask = led->id ?
-		      MAX8997_LED1_MOVIE_PIN_MASK : MAX8997_LED0_MOVIE_PIN_MASK;
-		break;
-	default:
-		break;
-	}
-
-	if (mask) {
-		ret = max8997_update_reg(client,
-				MAX8997_REG_LEN_CNTL, val, mask);
-		if (ret)
-			dev_err(led->iodev->dev,
-				"failed to update register(%d)\n", ret);
-	}
-}
-
 static void max8997_led_set_mode(struct max8997_led *led,
 			enum max8997_led_mode mode)
 {
 	int ret;
 	struct i2c_client *client = led->iodev->i2c;
-	u8 mask = 0;
-
-	/* First, clear the previous mode */
-	max8997_led_clear_mode(led, led->led_mode);
+	u8 mask = 0, val;
 
 	switch (mode) {
 	case MAX8997_FLASH_MODE:
-		mask = led->id ?
+		mask = MAX8997_LED1_FLASH_MASK | MAX8997_LED0_FLASH_MASK;
+		val = led->id ?
 		      MAX8997_LED1_FLASH_MASK : MAX8997_LED0_FLASH_MASK;
 		led->cdev.max_brightness = MAX8997_LED_FLASH_MAX_BRIGHTNESS;
 		break;
 	case MAX8997_MOVIE_MODE:
-		mask = led->id ?
+		mask = MAX8997_LED1_MOVIE_MASK | MAX8997_LED0_MOVIE_MASK;
+		val = led->id ?
 		      MAX8997_LED1_MOVIE_MASK : MAX8997_LED0_MOVIE_MASK;
 		led->cdev.max_brightness = MAX8997_LED_MOVIE_MAX_BRIGHTNESS;
 		break;
 	case MAX8997_FLASH_PIN_CONTROL_MODE:
-		mask = led->id ?
+		mask = MAX8997_LED1_FLASH_PIN_MASK |
+		       MAX8997_LED0_FLASH_PIN_MASK;
+		val = led->id ?
 		      MAX8997_LED1_FLASH_PIN_MASK : MAX8997_LED0_FLASH_PIN_MASK;
 		led->cdev.max_brightness = MAX8997_LED_FLASH_MAX_BRIGHTNESS;
 		break;
 	case MAX8997_MOVIE_PIN_CONTROL_MODE:
-		mask = led->id ?
+		mask = MAX8997_LED1_MOVIE_PIN_MASK |
+		       MAX8997_LED0_MOVIE_PIN_MASK;
+		val = led->id ?
 		      MAX8997_LED1_MOVIE_PIN_MASK : MAX8997_LED0_MOVIE_PIN_MASK;
 		led->cdev.max_brightness = MAX8997_LED_MOVIE_MAX_BRIGHTNESS;
 		break;
@@ -123,8 +89,8 @@ static void max8997_led_set_mode(struct max8997_led *led,
 	}
 
 	if (mask) {
-		ret = max8997_update_reg(client,
-				MAX8997_REG_LEN_CNTL, mask, mask);
+		ret = max8997_update_reg(client, MAX8997_REG_LEN_CNTL, val,
+					 mask);
 		if (ret)
 			dev_err(led->iodev->dev,
 				"failed to update register(%d)\n", ret);
-- 
1.7.9.5



