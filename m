Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2FLBp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:45:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56025 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153Ab2FLBp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:45:27 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] drm/i2c/ch7006: Convert to dev_pm_ops
Date: Tue, 12 Jun 2012 09:45:14 +0800
Message-Id: <1339465514-10766-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
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

This patch has been sitting around for quite a while now, it's going to
end up blocking improvements in the I2C subsystem at some point.

 drivers/gpu/drm/i2c/ch7006_drv.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i2c/ch7006_drv.c b/drivers/gpu/drm/i2c/ch7006_drv.c
index d3f2e87..74ad254 100644
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
+	struct i2c_client *client = to_i2c_device(dev);
 
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
1.7.10

