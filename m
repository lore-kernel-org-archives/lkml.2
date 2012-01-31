Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2AaHel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 02:34:41 -0500
Received: from mail2.nsc.com ([12.238.8.132]:55864 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752865Ab2AaHei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 02:34:38 -0500
X-WSS-ID: 0LYNJPL-0A-MN2-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 30 Jan 2012 23:34:23 -0800
Subject: [PATCH v3 6/6] leds-lm3530: set the max_brightness to 127
Thread-Topic: [PATCH v3 6/6] leds-lm3530: set the max_brightness to 127
Thread-Index: Aczf6sByRKl/KUlpTiOMQSQpu02Hhg==
Message-ID: <B567DBAB974C0544994013492B949F8E3812DEC936@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6339460B1LS10038298-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only 7 bits are used for the brightness. (register address : A0h)
So the max_brightness property of lm3530 should be set to 127.

On initializing registers, maximum initial brightness is limited to 'max_brightness'.

Division-by-two is removed on updating the value of brightness.
This arithmetic is not necessary because the range of brightness is 0 ~ 127.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lm3530.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 3bb3c09..c669ebc 100644
--- a/drivers/leds/leds-lm3530.c
+++ b/drivers/leds/leds-lm3530.c
@@ -80,6 +80,9 @@
 #define LM3530_DEF_ZT_3			(0x66)
 #define LM3530_DEF_ZT_4			(0x7F)
 
+/* 7 bits are used for the brightness : LM3530_BRT_CTRL_REG */
+#define MAX_BRIGHTNESS			(127)
+
 struct lm3530_mode_map {
 	const char *mode;
 	enum lm3530_mode mode_val;
@@ -184,6 +187,9 @@ static int lm3530_init_registers(struct lm3530_data *drvdata)
 	else
 		brightness = drvdata->brightness = pdata->brt_val;
 
+	if (brightness > drvdata->led_dev.max_brightness)
+		brightness = drvdata->led_dev.max_brightness;
+
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
 	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
@@ -249,12 +255,12 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 
 		/* set the brightness in brightness control register*/
 		err = i2c_smbus_write_byte_data(drvdata->client,
-				LM3530_BRT_CTRL_REG, brt_val / 2);
+				LM3530_BRT_CTRL_REG, brt_val);
 		if (err)
 			dev_err(&drvdata->client->dev,
 				"Unable to set brightness: %d\n", err);
 		else
-			drvdata->brightness = brt_val / 2;
+			drvdata->brightness = brt_val;
 
 		if (brt_val == 0) {
 			err = regulator_disable(drvdata->regulator);
@@ -353,6 +359,7 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->enable = false;
 	drvdata->led_dev.name = pdata->name ? pdata->name : LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
+	drvdata->led_dev.max_brightness = MAX_BRIGHTNESS;
 
 	i2c_set_clientdata(client, drvdata);
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated




