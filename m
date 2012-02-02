Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2BBIOb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:14:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34131 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab2BBIOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:14:30 -0500
Message-ID: <1328170464.11502.3.camel@phoenix>
Subject: [PATCH 2/2] backlight: lp855x_bl: Small cleanups
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 02 Feb 2012 16:14:24 +0800
In-Reply-To: <1328170333.11502.1.camel@phoenix>
References: <1328170333.11502.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below cleanups:
- Make lp855x_bl_update_status() return 0 instead of bl->props.brightness.
  It looks pointless to return bl->props.brightness for lp855x_bl_update_status.
  Make it return 0 on success.
- Use devm_kzalloc to save a few error handling code.
- Use module_i2c_driver

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/lp855x_bl.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 5ab9ec8..c337b7a 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -131,7 +131,7 @@ static int lp855x_bl_update_status(struct backlight_device *bl)
 		lp855x_write_byte(lp, BRIGHTNESS_CTRL, val);
 	}
 
-	return bl->props.brightness;
+	return 0;
 }
 
 static int lp855x_bl_get_brightness(struct backlight_device *bl)
@@ -241,7 +241,7 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	lp = kzalloc(sizeof(struct lp855x), GFP_KERNEL);
+	lp = devm_kzalloc(&cl->dev, sizeof(struct lp855x), GFP_KERNEL);
 	if (!lp)
 		return -ENOMEM;
 
@@ -275,14 +275,11 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	}
 
 	backlight_update_status(lp->bl);
-	return ret;
+	return 0;
 
-err_dev:
-	kfree(lp);
-	return ret;
 err_sysfs:
 	lp855x_backlight_unregister(lp);
-	kfree(lp);
+err_dev:
 	return ret;
 }
 
@@ -294,7 +291,6 @@ static int __devexit lp855x_remove(struct i2c_client *cl)
 	backlight_update_status(lp->bl);
 	sysfs_remove_group(&lp->dev->kobj, &lp855x_attr_group);
 	lp855x_backlight_unregister(lp);
-	kfree(lp);
 
 	return 0;
 }
@@ -318,18 +314,7 @@ static struct i2c_driver lp855x_driver = {
 	.id_table = lp855x_ids,
 };
 
-static int __init lp855x_init(void)
-{
-	return i2c_add_driver(&lp855x_driver);
-}
-
-static void __exit lp855x_exit(void)
-{
-	i2c_del_driver(&lp855x_driver);
-}
-
-module_init(lp855x_init);
-module_exit(lp855x_exit);
+module_i2c_driver(lp855x_driver);
 
 MODULE_DESCRIPTION("Texas Instruments LP855x Backlight driver");
 MODULE_AUTHOR("Milo Kim <milo.kim@ti.com>");
-- 
1.7.5.4



