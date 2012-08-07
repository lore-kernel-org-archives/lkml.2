Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab2HGLOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:14:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40678 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab2HGLOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:14:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, Francisco Jerez <currojerez@riseup.net>,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] drm/i2c/ch7006: Convert to dev_pm_ops
Date: Tue,  7 Aug 2012 12:14:14 +0100
Message-Id: <1344338054-7837-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C specific suspend and resume functions have been deprecated and
printing a warning on boot for over a year, dev_pm_ops should be used
instead so convert to that.

Also remove the suspend function since all it does is log.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Francisco Jerez <currojerez@riseup.net>
---
 drivers/gpu/drm/i2c/ch7006_drv.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i2c/ch7006_drv.c b/drivers/gpu/drm/i2c/ch7006_drv.c
index 36d9522..599099f 100644
--- a/drivers/gpu/drm/i2c/ch7006_drv.c
+++ b/drivers/gpu/drm/i2c/ch7006_drv.c
@@ -427,15 +427,10 @@ static int ch7006_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int ch7006_suspend(struct i2c_client *client, pm_message_t mesg)
+static int ch7006_resume(struct device *dev)
 {
-	ch7006_dbg(client, "\n");
-
-	return 0;
-}
+	struct i2c_client *client = to_i2c_client(dev);
 
-static int ch7006_resume(struct i2c_client *client)
-{
 	ch7006_dbg(client, "\n");
 
 	ch7006_write(client, 0x3d, 0x0);
@@ -499,15 +494,18 @@ static struct i2c_device_id ch7006_ids[] = {
 };
 MODULE_DEVICE_TABLE(i2c, ch7006_ids);
 
+static const struct dev_pm_ops ch7006_pm_ops = {
+	.resume = ch7006_resume,
+};
+
 static struct drm_i2c_encoder_driver ch7006_driver = {
 	.i2c_driver = {
 		.probe = ch7006_probe,
 		.remove = ch7006_remove,
-		.suspend = ch7006_suspend,
-		.resume = ch7006_resume,
 
 		.driver = {
 			.name = "ch7006",
+			.pm = &ch7006_pm_ops,
 		},
 
 		.id_table = ch7006_ids,
-- 
1.7.10.4

