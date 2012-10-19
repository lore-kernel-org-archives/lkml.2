Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2JSIMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:12:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58311 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab2JSIMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:12:12 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>, Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] lp855x_bl: remove unnecessary mutex code
Thread-Topic: [PATCH 2/2] lp855x_bl: remove unnecessary mutex code
Thread-Index: Ac2t0WsklGYQxw/yQJO27sQzEoDi7w==
Date: Fri, 19 Oct 2012 08:12:02 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F64179175@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 The mutex for accessing lp855x registers is used in case of
 the user-space interaction.
 When the brightness is changed via the sysfs, the mutex is required.
 But the backlight class device already provides it.
 Thus, the lp855x mutex is unnecessary.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index c4fd72f..ff86531 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -35,7 +35,6 @@ struct lp855x {
 	struct i2c_client *client;
 	struct backlight_device *bl;
 	struct device *dev;
-	struct mutex xfer_lock;
 	struct lp855x_platform_data *pdata;
 	struct pwm_device *pwm;
 };
@@ -44,14 +43,11 @@ static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
 {
 	int ret;
 
-	mutex_lock(&lp->xfer_lock);
 	ret = i2c_smbus_read_byte_data(lp->client, reg);
 	if (ret < 0) {
-		mutex_unlock(&lp->xfer_lock);
 		dev_err(lp->dev, "failed to read 0x%.2x\n", reg);
 		return ret;
 	}
-	mutex_unlock(&lp->xfer_lock);
 
 	*data = (u8)ret;
 	return 0;
@@ -59,13 +55,7 @@ static int lp855x_read_byte(struct lp855x *lp, u8 reg, u8 *data)
 
 static int lp855x_write_byte(struct lp855x *lp, u8 reg, u8 data)
 {
-	int ret;
-
-	mutex_lock(&lp->xfer_lock);
-	ret = i2c_smbus_write_byte_data(lp->client, reg, data);
-	mutex_unlock(&lp->xfer_lock);
-
-	return ret;
+	return i2c_smbus_write_byte_data(lp->client, reg, data);
 }
 
 static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
@@ -278,8 +268,6 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	lp->chip_id = id->driver_data;
 	i2c_set_clientdata(cl, lp);
 
-	mutex_init(&lp->xfer_lock);
-
 	ret = lp855x_init_registers(lp);
 	if (ret) {
 		dev_err(lp->dev, "i2c communication err: %d", ret);
-- 
1.7.9.5


Best Regards,
Milo


