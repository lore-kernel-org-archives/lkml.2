Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2LLOAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:00:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44323 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab2LLOA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:00:28 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/33] leds-lp55xx: cleanup deinit_device() in lp5521/5523
Thread-Topic: [PATCH 02/33] leds-lp55xx: cleanup deinit_device() in
 lp5521/5523
Thread-Index: Ac3YcQeprsk/s1BYSMax5kzqJGbc7w==
Date: Wed, 12 Dec 2012 14:00:24 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAB8@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Device de-initialization code is moved to _deinit_device() at each driver.
 This patch is a preceding step for lp55xx common driver architecture.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   20 ++++++++++++--------
 drivers/leds/leds-lp5523.c |   20 ++++++++++++--------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 6951d5d..d2b79b5 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -740,6 +740,16 @@ static int lp5521_init_device(struct lp5521_chip *chip)
 	return ret;
 }
 
+static void lp5521_deinit_device(struct lp5521_chip *chip)
+{
+	struct lp5521_platform_data *pdata = chip->pdata;
+
+	if (pdata->enable)
+		pdata->enable(0);
+	if (pdata->release_resources)
+		pdata->release_resources();
+}
+
 static int __devinit lp5521_init_led(struct lp5521_led *led,
 				struct i2c_client *client,
 				int chan, struct lp5521_platform_data *pdata)
@@ -865,10 +875,7 @@ fail2:
 		cancel_work_sync(&chip->leds[i].brightness_work);
 	}
 fail1:
-	if (pdata->enable)
-		pdata->enable(0);
-	if (pdata->release_resources)
-		pdata->release_resources();
+	lp5521_deinit_device(chip);
 	return ret;
 }
 
@@ -885,10 +892,7 @@ static int __devexit lp5521_remove(struct i2c_client *client)
 		cancel_work_sync(&chip->leds[i].brightness_work);
 	}
 
-	if (chip->pdata->enable)
-		chip->pdata->enable(0);
-	if (chip->pdata->release_resources)
-		chip->pdata->release_resources();
+	lp5521_deinit_device(chip);
 	return 0;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 918f09d..b88251d 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -923,6 +923,16 @@ static int lp5523_init_device(struct lp5523_chip *chip)
 	return lp5523_detect(client);
 }
 
+static void lp5523_deinit_device(struct lp5523_chip *chip)
+{
+	struct lp5523_platform_data *pdata = chip->pdata;
+
+	if (pdata->enable)
+		pdata->enable(0);
+	if (pdata->release_resources)
+		pdata->release_resources();
+}
+
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -1009,10 +1019,7 @@ fail2:
 		flush_work(&chip->leds[i].brightness_work);
 	}
 fail1:
-	if (pdata->enable)
-		pdata->enable(0);
-	if (pdata->release_resources)
-		pdata->release_resources();
+	lp5523_deinit_device(chip);
 	return ret;
 }
 
@@ -1031,10 +1038,7 @@ static int lp5523_remove(struct i2c_client *client)
 		flush_work(&chip->leds[i].brightness_work);
 	}
 
-	if (chip->pdata->enable)
-		chip->pdata->enable(0);
-	if (chip->pdata->release_resources)
-		chip->pdata->release_resources();
+	lp5523_deinit_device(chip);
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


