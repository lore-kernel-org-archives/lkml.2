Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab2LLOCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:02:37 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47930 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab2LLOCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:02:35 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 22/33] leds-lp55xx: use common driver function for adding
 attributes
Thread-Topic: [PATCH 22/33] leds-lp55xx: use common driver function for
 adding attributes
Thread-Index: Ac3YcVNDixMZ74mcQdCLaDVTVH/qnA==
Date: Wed, 12 Dec 2012 14:02:31 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0ABC7@DQHE02.ent.ti.com>
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

 Use lp55xx_register_sysfs() rather than lp5521_register_sysfs()
 and lp5523_register_sysfs().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |   17 +++++++----------
 drivers/leds/leds-lp5523.c |   23 +++++++----------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 16bbba3..c683bf5 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -501,12 +501,6 @@ static const struct attribute_group lp5521_group = {
 	.attrs = lp5521_attributes,
 };
 
-static int lp5521_register_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-	return sysfs_create_group(&dev->kobj, &lp5521_group);
-}
-
 static void lp5521_unregister_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -530,6 +524,7 @@ static struct lp55xx_device_config lp5521_cfg = {
 	.set_led_current    = lp5521_set_led_current,
 	.firmware_cb        = lp5521_firmware_loaded,
 	.run_engine         = lp5521_run_engine,
+	.dev_attr_group     = &lp5521_group,
 };
 
 static int __devinit lp5521_probe(struct i2c_client *client,
@@ -572,13 +567,15 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	if (ret)
 		goto err_register_leds;
 
-	ret = lp5521_register_sysfs(client);
+	ret = lp55xx_register_sysfs(chip);
 	if (ret) {
 		dev_err(&client->dev, "registering sysfs failed\n");
-		goto fail2;
+		goto err_register_sysfs;
 	}
-	return ret;
-fail2:
+
+	return 0;
+
+err_register_sysfs:
 	lp55xx_unregister_leds(led, chip);
 err_register_leds:
 	lp55xx_deinit_device(chip);
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 92e68e7..d58b06c 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -484,18 +484,6 @@ static const struct attribute_group lp5523_group = {
 	.attrs = lp5523_attributes,
 };
 
-static int lp5523_register_sysfs(struct i2c_client *client)
-{
-	struct device *dev = &client->dev;
-	int ret;
-
-	ret = sysfs_create_group(&dev->kobj, &lp5523_group);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static void lp5523_unregister_sysfs(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -519,6 +507,7 @@ static struct lp55xx_device_config lp5523_cfg = {
 	.set_led_current    = lp5523_set_led_current,
 	.firmware_cb        = lp5523_firmware_loaded,
 	.run_engine         = lp5523_run_engine,
+	.dev_attr_group     = &lp5523_group,
 };
 
 static int __devinit lp5523_probe(struct i2c_client *client,
@@ -561,13 +550,15 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 	if (ret)
 		goto err_register_leds;
 
-	ret = lp5523_register_sysfs(client);
+	ret = lp55xx_register_sysfs(chip);
 	if (ret) {
 		dev_err(&client->dev, "registering sysfs failed\n");
-		goto fail2;
+		goto err_register_sysfs;
 	}
-	return ret;
-fail2:
+
+	return 0;
+
+err_register_sysfs:
 	lp55xx_unregister_leds(led, chip);
 err_register_leds:
 	lp55xx_deinit_device(chip);
-- 
1.7.9.5


Best Regards,
Milo


