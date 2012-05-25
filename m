Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040Ab2EYCRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:17:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2EYCRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:17:45 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-f0-4fbeebc6c44f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 02/13] backlight: adp8870: use devm_ functions
Date: Fri, 25 May 2012 11:17:42 +0900
Message-id: <000d01cd3a1c$90d16630$b2743290$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HJC1o7Q0abF9Qz21HCErQX1lxw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jQd1jr/f5G0x8Y2ZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyZvxeyFKwWqxiw7UVrA2MrUJdjJwcEgImEo+/NzFC2GISF+6t
	Z+ti5OIQEpjOKLFu4z8oZzaTxNY3F1hBqtgE1CS+fDnMDmKLCERINM+YxQxSxCzQwiix4VAz
	M0hCWMBO4se8XWANLAKqEkeaj4A18ArYSjz6+Z0ZwhaU+DH5HguIzSygJbF5WxMrhC0vsXnN
	W6AaDqCT1CUe/dWF2KUnMfvrJnaIEhGJfS/eMU5gFJiFZNIsJJNmIZk0C0nLAkaWVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBoflMagfjygaLQ4wCHIxKPLwrI/b5C7EmlhVX5h5ilOBg
	VhLhFYwECvGmJFZWpRblxxeV5qQWH2KU5mBREue1W7zDX0ggPbEkNTs1tSC1CCbLxMEp1cAY
	KmJdoXXsfbT0wgAt9b3ZFgU1fC2753j6eOX46fCFmv57+Ipvu9yRKVUTGnVrpV5yZby7bPdO
	seh/65RHKnuvbY190nrzWobw4k35b832fZ5d0F/S2ll7JGtByrXIg9zrrM6cO8h8Vv+s6M7E
	pzqhczSyl1fd8z0XsfpCgk+h4JT8xrvOqsVKLMUZiYZazEXFiQB70zrcSQIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_ functions allocate memory that is released when a driver
detaches. This patch uses devm_kzalloc of these functions.

Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8870_bl.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 9be58c6..32c025f 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -244,8 +244,8 @@ static int __devinit adp8870_led_probe(struct i2c_client *client)
 	struct led_info *cur_led;
 	int ret, i;
 
-
-	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&client->dev, pdata->num_leds * sizeof(*led),
+				GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&client->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -253,17 +253,17 @@ static int __devinit adp8870_led_probe(struct i2c_client *client)
 
 	ret = adp8870_write(client, ADP8870_ISCLAW, pdata->led_fade_law);
 	if (ret)
-		goto err_free;
+		return ret;
 
 	ret = adp8870_write(client, ADP8870_ISCT1,
 			(pdata->led_on_time & 0x3) << 6);
 	if (ret)
-		goto err_free;
+		return ret;
 
 	ret = adp8870_write(client, ADP8870_ISCF,
 			FADE_VAL(pdata->led_fade_in, pdata->led_fade_out));
 	if (ret)
-		goto err_free;
+		return ret;
 
 	for (i = 0; i < pdata->num_leds; ++i) {
 		cur_led = &pdata->leds[i];
@@ -317,9 +317,6 @@ static int __devinit adp8870_led_probe(struct i2c_client *client)
 		cancel_work_sync(&led[i].work);
 	}
 
- err_free:
-	kfree(led);
-
 	return ret;
 }
 
@@ -335,7 +332,6 @@ static int __devexit adp8870_led_remove(struct i2c_client *client)
 		cancel_work_sync(&data->led[i].work);
 	}
 
-	kfree(data->led);
 	return 0;
 }
 #else
@@ -874,7 +870,7 @@ static int __devinit adp8870_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -894,8 +890,7 @@ static int __devinit adp8870_probe(struct i2c_client *client,
 			&client->dev, data, &adp8870_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out2;
+		return PTR_ERR(bl);
 	}
 
 	data->bl = bl;
@@ -930,8 +925,6 @@ out:
 			&adp8870_bl_attr_group);
 out1:
 	backlight_device_unregister(bl);
-out2:
-	kfree(data);
 
 	return ret;
 }
@@ -950,7 +943,6 @@ static int __devexit adp8870_remove(struct i2c_client *client)
 			&adp8870_bl_attr_group);
 
 	backlight_device_unregister(data->bl);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.1


