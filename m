Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030733Ab2CUKLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:11:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965188Ab2CUKLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:11:36 -0400
Message-ID: <1332324687.12310.2.camel@phoenix>
Subject: [PATCH] backlight: Use id->driver_data to differentiate lp855x chips
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 21 Mar 2012 18:11:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code has corresponding driver_data settings for different chip types.
Use the driver_data to differentiate lp855x chips.

Also make lp855x_is_valid_rom_area() return bool instead of int.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/lp855x_bl.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index ce0c53a..c2c420e 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -25,7 +25,8 @@
 #define MAX_BRIGHTNESS		255
 
 struct lp855x {
-	const char *chipid;
+	const char *chipname;
+	enum lp855x_chip_id chip_id;
 	struct i2c_client *client;
 	struct backlight_device *bl;
 	struct device *dev;
@@ -61,23 +62,27 @@ static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
 	return ret;
 }
 
-static int lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
+static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 {
-	const char *id = lp->chipid;
 	u8 start, end;
 
-	if (strstr(id, "lp8550") || strstr(id, "lp8551")
-	    || strstr(id, "lp8552") || strstr(id, "lp8553")) {
+	switch (lp->chip_id) {
+	case LP8550:
+	case LP8551:
+	case LP8552:
+	case LP8553:
 		start = EEPROM_START;
 		end = EEPROM_END;
-	} else if (strstr(id, "lp8556")) {
+		break;
+	case LP8556:
 		start = EPROM_START;
 		end = EPROM_END;
-	} else {
-		return 0;
+		break;
+	default:
+		return false;
 	}
 
-	return (addr >= start && addr <= end) ? 1 : 0;
+	return (addr >= start && addr <= end) ? true : false;
 }
 
 static int lp855x_init_registers(struct lp855x *lp)
@@ -199,7 +204,7 @@ static ssize_t lp855x_get_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
-	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipid);
+	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipname);
 }
 
 static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
@@ -253,7 +258,8 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
-	lp->chipid = id->name;
+	lp->chipname = id->name;
+	lp->chip_id = id->driver_data;
 	i2c_set_clientdata(cl, lp);
 
 	mutex_init(&lp->xfer_lock);
-- 
1.7.5.4



