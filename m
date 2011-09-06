Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1IFHMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 03:12:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40762 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753073Ab1IFHMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 03:12:39 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
        Ilkka Koskinen <ilkka.koskinen@nokia.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] lis3lv02d: Make regulator API usage unconditional
Date: Tue,  6 Sep 2011 00:12:29 -0700
Message-Id: <1315293149-3881-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315293149-3881-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1315293149-3881-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator API contains a range of features for stubbing itself out
when not in use and for transparently restricting the actual effect of
regulator API calls where they can't be supported on a particular system
so that drivers don't need to individually implement this. Simplify the
driver slightly by making use of this idiom.

The only in tree user is ecovec24 which does not use the regulator API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   34 +++++++++++--------------------
 include/linux/lis3lv02d.h              |    1 -
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index 6cdc38f..c02fea0 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -79,8 +79,7 @@ static int lis3_i2c_init(struct lis3lv02d *lis3)
 	u8 reg;
 	int ret;
 
-	if (lis3->reg_ctrl)
-		lis3_reg_ctrl(lis3, LIS3_REG_ON);
+	lis3_reg_ctrl(lis3, LIS3_REG_ON);
 
 	lis3->read(lis3, WHO_AM_I, &reg);
 	if (reg != lis3->whoami)
@@ -106,10 +105,6 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 	struct lis3lv02d_platform_data *pdata = client->dev.platform_data;
 
 	if (pdata) {
-		/* Regulator control is optional */
-		if (pdata->driver_features & LIS3_USE_REGULATOR_CTRL)
-			lis3_dev.reg_ctrl = lis3_reg_ctrl;
-
 		if ((pdata->driver_features & LIS3_USE_BLOCK_READ) &&
 			(i2c_check_functionality(client->adapter,
 						I2C_FUNC_SMBUS_I2C_BLOCK)))
@@ -131,15 +126,13 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 			goto fail;
 	}
 
-	if (lis3_dev.reg_ctrl) {
-		lis3_dev.regulators[0].supply = reg_vdd;
-		lis3_dev.regulators[1].supply = reg_vdd_io;
-		ret = regulator_bulk_get(&client->dev,
-					ARRAY_SIZE(lis3_dev.regulators),
-					lis3_dev.regulators);
-		if (ret < 0)
-			goto fail;
-	}
+	lis3_dev.regulators[0].supply = reg_vdd;
+	lis3_dev.regulators[1].supply = reg_vdd_io;
+	ret = regulator_bulk_get(&client->dev,
+				 ARRAY_SIZE(lis3_dev.regulators),
+				 lis3_dev.regulators);
+	if (ret < 0)
+		goto fail;
 
 	lis3_dev.pdata	  = pdata;
 	lis3_dev.bus_priv = client;
@@ -153,13 +146,11 @@ static int __devinit lis3lv02d_i2c_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, &lis3_dev);
 
 	/* Provide power over the init call */
-	if (lis3_dev.reg_ctrl)
-		lis3_reg_ctrl(&lis3_dev, LIS3_REG_ON);
+	lis3_reg_ctrl(&lis3_dev, LIS3_REG_ON);
 
 	ret = lis3lv02d_init_device(&lis3_dev);
 
-	if (lis3_dev.reg_ctrl)
-		lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
+	lis3_reg_ctrl(&lis3_dev, LIS3_REG_OFF);
 
 	if (ret)
 		goto fail2;
@@ -185,9 +176,8 @@ static int __devexit lis3lv02d_i2c_remove(struct i2c_client *client)
 	lis3lv02d_joystick_disable(lis3);
 	lis3lv02d_remove_fs(&lis3_dev);
 
-	if (lis3_dev.reg_ctrl)
-		regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
-				lis3_dev.regulators);
+	regulator_bulk_free(ARRAY_SIZE(lis3->regulators),
+			    lis3_dev.regulators);
 	return 0;
 }
 
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
index d4292c8..f1664c6 100644
--- a/include/linux/lis3lv02d.h
+++ b/include/linux/lis3lv02d.h
@@ -113,7 +113,6 @@ struct lis3lv02d_platform_data {
 	s8 axis_x;
 	s8 axis_y;
 	s8 axis_z;
-#define LIS3_USE_REGULATOR_CTRL 0x01
 #define LIS3_USE_BLOCK_READ	0x02
 	u16 driver_features;
 	int default_rate;
-- 
1.7.5.4

