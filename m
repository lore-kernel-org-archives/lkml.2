Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2AYJkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:40:55 -0500
Received: from mail2.nsc.com ([12.238.8.132]:40518 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036Ab2AYJkx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:40:53 -0500
X-WSS-ID: 0LYCLK0-0A-7FD-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Lars-Peter Clausen" <lars@metafoo.de>
cc: "Linus Walleij" <linus.walleij@linaro.org>,
        "shreshthakumar.sahu@stericsson.com" 
	<shreshthakumar.sahu@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Wed, 25 Jan 2012 01:40:37 -0800
Subject: RE: [PATCH v2 1/2] leds-lm3530: set the value of max_brightness
 to 127
Thread-Topic: [PATCH v2 1/2] leds-lm3530: set the value of
 max_brightness to 127
Thread-Index: AczbNnTVO2wEgzm4RnmOqSLosn4EjQADPykA
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD3F53@EXMAIL03.scwf.nsc.com>
References: <B567DBAB974C0544994013492B949F8E3812CD3E37@EXMAIL03.scwf.nsc.com>
 <4F1FB4DA.2050104@metafoo.de>
In-Reply-To: <4F1FB4DA.2050104@metafoo.de>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 6301118C1LS9914370-08-01
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
---
 drivers/leds/leds-lm3530.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lm3530.c b/drivers/leds/leds-lm3530.c
index 4d7ce76..7005a5f 100644
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
 		brightness = drvdata->brightness = pltfm->brt_val;
 
+	if (brightness > drvdata->led_dev.max_brightness)
+		brightness = drvdata->led_dev.max_brightness;
+
 	reg_val[0] = gen_config;	/* LM3530_GEN_CONFIG */
 	reg_val[1] = als_config;	/* LM3530_ALS_CONFIG */
 	reg_val[2] = brt_ramp;		/* LM3530_BRT_RAMP_RATE */
@@ -241,12 +247,12 @@ static void lm3530_brightness_set(struct led_classdev *led_cdev,
 
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
@@ -340,6 +346,7 @@ static int __devinit lm3530_probe(struct i2c_client *client,
 	drvdata->enable = false;
 	drvdata->led_dev.name = LM3530_LED_DEV;
 	drvdata->led_dev.brightness_set = lm3530_brightness_set;
+	drvdata->led_dev.max_brightness = MAX_BRIGHTNESS;
 
 	i2c_set_clientdata(client, drvdata);
 
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim


-----Original Message-----
From: Lars-Peter Clausen [mailto:lars@metafoo.de] 
Sent: Wednesday, January 25, 2012 4:53 PM
To: Kim, Milo
Cc: Linus Walleij; shreshthakumar.sahu@stericsson.com; linux-kernel@vger.kernel.org; rpurdie@rpsys.net
Subject: Re: [PATCH v2 1/2] leds-lm3530: set the value of max_brightness to 127

On 01/25/2012 02:51 AM, Kim, Milo wrote:
>> Only 7 bits are used for the brightness. (register address : A0h)
>> So the max_brightness property of lm3530 should be set to 127.
>> 
>> On initializing registers, maximum initial brightness is limited to 'max_brightness'.
>> 
>> Division-by-two is removed on updating the value of brightness.
>> This arithmetic is not necessary because the range of brightness is 0 ~ 127.
>> 
>> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
>> ---
>>  drivers/leds/leds-lm3530.c |   22 +++++++++++-----------
>>  1 files changed, 11 insertions(+), 11 deletions(-)
>> 

> Looks like something went wrong, this is the same patch as 2/2

Sorry for confusing you. Wrong patch was sent.

Best Regards,
Milo -


