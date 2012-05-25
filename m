Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab2EYCQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 22:16:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27704 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2EYCQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 22:16:57 -0400
X-AuditID: cbfee61a-b7fe76d0000023f5-fa-4fbeeb974945
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/13] backlight: adp8860: use devm_ functions
Date: Fri, 25 May 2012 11:16:55 +0900
Message-id: <000c01cd3a1c$74c84670$5e58d350$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac06HHSGCvqWbJPvSoC0+D50JpToPA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd3pr/f5G7x/Z2xxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyrux6xViwX7yiefpz9gbGb0JdjJwcEgImErPPz2CFsMUkLtxb
	z9bFyMUhJLCIUWLmiVnMEM5sJon5H5+wgFSxCahJfPlymB3EFhGIkGieAVHELNDCKLHhUDMz
	SEJYwE6iZdEBsAYWAVWJhjcnwGxeAVuJedNfMELYghI/Jt8DizMLaEls3tbECmHLS2xe8xZo
	DgfQSeoSj/7qQuzSk7i+YTM7RImIxL4X7xgnMArMQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILi
	pPRcQ73ixNzi0rx0veT83E2M4NB8JrWDcWWDxSFGAQ5GJR7elRH7/IVYE8uKK3MPMUpwMCuJ
	8ApGAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInz2i3e4S8kkJ5YkpqdmlqQWgSTZeLglGpg7Nex
	PGMadvNA9XO2hc8e32I/LHqrqj3BSIQvfutej7+uoScNJjpbce8POmcQfjt2Vd+e/euLtMVP
	Kny56Drn2r0l5kZbQuayyygf2jaRQXH1q+zFG91XMHbI/CvyLw4zu/Wx5ZSb9dGKL0z+fXs0
	FKQP7y7iynM5HVgur7xmAqf6tPUFH/mclFiKMxINtZiLihMBeL1liUkCAAA=
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
 drivers/video/backlight/adp8860_bl.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 550dbf0..48af78f 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -222,7 +222,8 @@ static int __devinit adp8860_led_probe(struct i2c_client *client)
 	struct led_info *cur_led;
 	int ret, i;
 
-	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
+	led = devm_kzalloc(&client->dev, sizeof(*led) * pdata->num_leds,
+				GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&client->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -236,7 +237,7 @@ static int __devinit adp8860_led_probe(struct i2c_client *client)
 
 	if (ret) {
 		dev_err(&client->dev, "failed to write\n");
-		goto err_free;
+		return ret;
 	}
 
 	for (i = 0; i < pdata->num_leds; ++i) {
@@ -291,9 +292,6 @@ static int __devinit adp8860_led_probe(struct i2c_client *client)
 		cancel_work_sync(&led[i].work);
 	}
 
- err_free:
-	kfree(led);
-
 	return ret;
 }
 
@@ -309,7 +307,6 @@ static int __devexit adp8860_led_remove(struct i2c_client *client)
 		cancel_work_sync(&data->led[i].work);
 	}
 
-	kfree(data->led);
 	return 0;
 }
 #else
@@ -675,13 +672,13 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
 	ret = adp8860_read(client, ADP8860_MFDVID, &reg_val);
 	if (ret < 0)
-		goto out2;
+		return ret;
 
 	switch (ADP8860_MANID(reg_val)) {
 	case ADP8863_MANUFID:
@@ -694,8 +691,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 		break;
 	default:
 		dev_err(&client->dev, "failed to probe\n");
-		ret = -ENODEV;
-		goto out2;
+		return -ENODEV;
 	}
 
 	/* It's confirmed that the DEVID field is actually a REVID */
@@ -717,8 +713,7 @@ static int __devinit adp8860_probe(struct i2c_client *client,
 			&client->dev, data, &adp8860_bl_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&client->dev, "failed to register backlight\n");
-		ret = PTR_ERR(bl);
-		goto out2;
+		return PTR_ERR(bl);
 	}
 
 	bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
@@ -756,8 +751,6 @@ out:
 			&adp8860_bl_attr_group);
 out1:
 	backlight_device_unregister(bl);
-out2:
-	kfree(data);
 
 	return ret;
 }
@@ -776,7 +769,6 @@ static int __devexit adp8860_remove(struct i2c_client *client)
 			&adp8860_bl_attr_group);
 
 	backlight_device_unregister(data->bl);
-	kfree(data);
 
 	return 0;
 }
-- 
1.7.1


