Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2LLOAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:00:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47742 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343Ab2LLOAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:00:17 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/33] leds-lp55xx: cleanup init_device() in lp5521/5523
Thread-Topic: [PATCH 01/33] leds-lp55xx: cleanup init_device() in lp5521/5523
Thread-Index: Ac3YcQEfoFy+Ql9vSIC9Y5KizTjwuw==
Date: Wed, 12 Dec 2012 14:00:13 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAB0@DQHE02.ent.ti.com>
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

 To make _probe() simple, device initialization code is moved to
 _init_device() at each driver.
 This patch is a preceding step for lp55xx common driver architecture.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/leds/leds-lp5521.c |  102 ++++++++++++++++++++++++--------------------
 drivers/leds/leds-lp5523.c |   47 +++++++++++---------
 2 files changed, 84 insertions(+), 65 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index ddc4315..6951d5d 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -687,6 +687,59 @@ static void lp5521_unregister_sysfs(struct i2c_client *client)
 				&lp5521_led_attribute_group);
 }
 
+static int lp5521_init_device(struct lp5521_chip *chip)
+{
+	struct lp5521_platform_data *pdata = chip->pdata;
+	struct i2c_client *client = chip->client;
+	int ret;
+	u8 buf;
+
+	if (pdata->setup_resources) {
+		ret = pdata->setup_resources();
+		if (ret < 0)
+			return ret;
+	}
+
+	if (pdata->enable) {
+		pdata->enable(0);
+		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
+		pdata->enable(1);
+		usleep_range(1000, 2000); /* 500us abs min. */
+	}
+
+	lp5521_write(client, LP5521_REG_RESET, 0xff);
+	usleep_range(10000, 20000); /*
+				     * Exact value is not available. 10 - 20ms
+				     * appears to be enough for reset.
+				     */
+
+	/*
+	 * Make sure that the chip is reset by reading back the r channel
+	 * current reg. This is dummy read is required on some platforms -
+	 * otherwise further access to the R G B channels in the
+	 * LP5521_REG_ENABLE register will not have any effect - strange!
+	 */
+	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	if (ret) {
+		dev_err(&client->dev, "error in resetting chip\n");
+		return ret;
+	}
+	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&client->dev,
+			"unexpected data in register (expected 0x%x got 0x%x)\n",
+			LP5521_REG_R_CURR_DEFAULT, buf);
+		ret = -EINVAL;
+		return ret;
+	}
+	usleep_range(10000, 20000);
+
+	ret = lp5521_detect(client);
+	if (ret)
+		dev_err(&client->dev, "Chip not found\n");
+
+	return ret;
+}
+
 static int __devinit lp5521_init_led(struct lp5521_led *led,
 				struct i2c_client *client,
 				int chan, struct lp5521_platform_data *pdata)
@@ -742,7 +795,6 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
 	int ret, i, led;
-	u8 buf;
 
 	chip = devm_kzalloc(&client->dev, sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -762,51 +814,9 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 
 	chip->pdata   = pdata;
 
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
-		if (ret < 0)
-			return ret;
-	}
-
-	if (pdata->enable) {
-		pdata->enable(0);
-		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
-		usleep_range(1000, 2000); /* 500us abs min. */
-	}
-
-	lp5521_write(client, LP5521_REG_RESET, 0xff);
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-
-	/*
-	 * Make sure that the chip is reset by reading back the r channel
-	 * current reg. This is dummy read is required on some platforms -
-	 * otherwise further access to the R G B channels in the
-	 * LP5521_REG_ENABLE register will not have any effect - strange!
-	 */
-	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
-	if (ret) {
-		dev_err(&client->dev, "error in resetting chip\n");
-		goto fail2;
-	}
-	if (buf != LP5521_REG_R_CURR_DEFAULT) {
-		dev_err(&client->dev,
-			"unexpected data in register (expected 0x%x got 0x%x)\n",
-			LP5521_REG_R_CURR_DEFAULT, buf);
-		ret = -EINVAL;
-		goto fail2;
-	}
-	usleep_range(10000, 20000);
-
-	ret = lp5521_detect(client);
-
-	if (ret) {
-		dev_err(&client->dev, "Chip not found\n");
-		goto fail2;
-	}
+	ret = lp5521_init_device(chip);
+	if (ret)
+		goto fail1;
 
 	dev_info(&client->dev, "%s programmable led chip found\n", id->name);
 
diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index eb89cbd..918f09d 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -896,6 +896,33 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
 	return 0;
 }
 
+static int lp5523_init_device(struct lp5523_chip *chip)
+{
+	struct lp5523_platform_data *pdata = chip->pdata;
+	struct i2c_client *client = chip->client;
+	int ret;
+
+	if (pdata->setup_resources) {
+		ret = pdata->setup_resources();
+		if (ret < 0)
+			return ret;
+	}
+
+	if (pdata->enable) {
+		pdata->enable(0);
+		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
+		pdata->enable(1);
+		usleep_range(1000, 2000); /* 500us abs min. */
+	}
+
+	lp5523_write(client, LP5523_REG_RESET, 0xff);
+	usleep_range(10000, 20000); /*
+				     * Exact value is not available. 10 - 20ms
+				     * appears to be enough for reset.
+				     */
+	return lp5523_detect(client);
+}
+
 static int __devinit lp5523_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
@@ -921,25 +948,7 @@ static int __devinit lp5523_probe(struct i2c_client *client,
 
 	chip->pdata   = pdata;
 
-	if (pdata->setup_resources) {
-		ret = pdata->setup_resources();
-		if (ret < 0)
-			return ret;
-	}
-
-	if (pdata->enable) {
-		pdata->enable(0);
-		usleep_range(1000, 2000); /* Keep enable down at least 1ms */
-		pdata->enable(1);
-		usleep_range(1000, 2000); /* 500us abs min. */
-	}
-
-	lp5523_write(client, LP5523_REG_RESET, 0xff);
-	usleep_range(10000, 20000); /*
-				     * Exact value is not available. 10 - 20ms
-				     * appears to be enough for reset.
-				     */
-	ret = lp5523_detect(client);
+	ret = lp5523_init_device(chip);
 	if (ret)
 		goto fail1;
 
-- 
1.7.9.5


Best Regards,
Milo


