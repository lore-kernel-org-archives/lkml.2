Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2LLOBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:01:03 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47786 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab2LLOA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:00:59 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 06/33] leds-lp55xx: do chip specific configuration on device
 init
Thread-Topic: [PATCH 06/33] leds-lp55xx: do chip specific configuration on
 device init
Thread-Index: Ac3YcRnP2bX7GGYESB6ffbCxR+Bc+g==
Date: Wed, 12 Dec 2012 14:00:55 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAD8@DQHE02.ent.ti.com>
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

 Chip specific function is configured during the device initialization.
 So _configure() is moved to each device init function.

 If chip configuration gets failed, the device is de-initialized in
 each _init_device(), not probe().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   25 +++++++++++++++++--------
 drivers/leds/leds-lp5523.c |   26 +++++++++++++++++++-------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 37075fd..56ea946 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -694,6 +694,7 @@ static void lp5521_reset_device(struct lp5521_chip *chip)
 	lp5521_write(client, LP5521_REG_RESET, 0xff);
 }
 
+static void lp5521_deinit_device(struct lp5521_chip *chip);
 static int lp5521_init_device(struct lp5521_chip *chip)
 {
 	struct lp5521_platform_data *pdata = chip->pdata;
@@ -742,9 +743,22 @@ static int lp5521_init_device(struct lp5521_chip *chip)
 	usleep_range(10000, 20000);
 
 	ret = lp5521_detect(client);
-	if (ret)
+	if (ret) {
 		dev_err(&client->dev, "Chip not found\n");
+		goto err;
+	}
+
+	ret = lp5521_configure(client);
+	if (ret < 0) {
+		dev_err(&client->dev, "error configuring chip\n");
+		goto err_config;
+	}
 
+	return 0;
+
+err_config:
+	lp5521_deinit_device(chip);
+err:
 	return ret;
 }
 
@@ -882,16 +896,10 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	ret = lp5521_init_device(chip);
 	if (ret)
-		goto fail1;
+		goto err_init;
 
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
-	ret = lp5521_configure(client);
-	if (ret < 0) {
-		dev_err(&client->dev, "error configuring chip\n");
-		goto fail1;
-	}
-
 	ret = lp5521_register_leds(chip);
 	if (ret)
 		goto fail2;
@@ -906,6 +914,7 @@ fail2:
 	lp5521_unregister_leds(chip);
 fail1:
 	lp5521_deinit_device(chip);
+err_init:
 	return ret;
 }
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index ec21642..a6521ea 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -953,6 +953,7 @@ static void lp5523_reset_device(struct lp5523_chip *chip)
 	lp5523_write(client, LP5523_REG_RESET, 0xff);
 }
 
+static void lp5523_deinit_device(struct lp5523_chip *chip);
 static int lp5523_init_device(struct lp5523_chip *chip)
 {
 	struct lp5523_platform_data *pdata = chip->pdata;
@@ -978,7 +979,22 @@ static int lp5523_init_device(struct lp5523_chip *chip)
 				     * Exact value is not available. 10 - 20ms
 				     * appears to be enough for reset.
 				     */
-	return lp5523_detect(client);
+	ret = lp5523_detect(client);
+	if (ret)
+		goto err;
+
+	ret = lp5523_configure(client);
+	if (ret < 0) {
+		dev_err(&client->dev, "error configuring chip\n");
+		goto err_config;
+	}
+
+	return 0;
+
+err_config:
+	lp5523_deinit_device(chip);
+err:
+	return ret;
 }
 
 static void lp5523_deinit_device(struct lp5523_chip *chip)
@@ -1018,7 +1034,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	ret = lp5523_init_device(chip);
 	if (ret)
-		goto fail1;
+		goto err_init;
 
 	dev_info(&client->dev, "%s Programmable led chip found\n", id->name);
 
@@ -1030,11 +1046,6 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 			goto fail1;
 		}
 	}
-	ret = lp5523_configure(client);
-	if (ret < 0) {
-		dev_err(&client->dev, "error configuring chip\n");
-		goto fail1;
-	}
 
 	ret = lp5523_register_leds(chip, id->name);
 	if (ret)
@@ -1050,6 +1061,7 @@ fail2:
 	lp5523_unregister_leds(chip);
 fail1:
 	lp5523_deinit_device(chip);
+err_init:
 	return ret;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


