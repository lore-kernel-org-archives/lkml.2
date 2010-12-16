Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0LPJGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:06:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42368 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0LPJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=KuVNKeUbxaam8Ur/xy/6iTnHRESufvhq7IzXnE3xj1HCWJnX2iluawce4YkY/Inu4M
         euveadWRY2stazpDqXYfdsbkDyQlkRZ/NY8EORUIYNG0bzbeAcvBkcukw/NQ2AeAeglv
         oLfPrTZ871duYMHp7gJ4fu9uOBR5aqpy+ETLM=
Subject: [PATCH] leds: leds-pca9532 cleanups
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dtor@mail.ru>
Content-Type: text/plain
Date: Thu, 16 Dec 2010 17:05:53 +0800
Message-Id: <1292490353.9368.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6244111ba78a6768ded3fedf8967b6bc891fa757 Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 16 Dec 2010 15:41:55 +0800
Subject: [PATCH] leds: leds-pca9532 cleanups

This patch includes below fixes:
1. Remove unneeded input_free_device() after input_unregister_device().
2. Use "while (--i >= 0)" instead of "if (i > 0) for (i = i - 1; i >= 0; i--)"
   for reclaim resources in pca9532_configure() error path.
   I think this change improves readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-pca9532.c |   34 ++++++++++++++++------------------
 1 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 43d0875..c298c65 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -274,24 +274,23 @@ static int pca9532_configure(struct i2c_client *client,
 	return 0;
 
 exit:
-	if (i > 0)
-		for (i = i - 1; i >= 0; i--)
-			switch (data->leds[i].type) {
-			case PCA9532_TYPE_NONE:
-				break;
-			case PCA9532_TYPE_LED:
-				led_classdev_unregister(&data->leds[i].ldev);
-				cancel_work_sync(&data->leds[i].work);
-				break;
-			case PCA9532_TYPE_N2100_BEEP:
-				if (data->idev != NULL) {
-					input_unregister_device(data->idev);
-					input_free_device(data->idev);
-					cancel_work_sync(&data->work);
-					data->idev = NULL;
-				}
-				break;
+	while (--i >= 0) {
+		switch (data->leds[i].type) {
+		case PCA9532_TYPE_NONE:
+			break;
+		case PCA9532_TYPE_LED:
+			led_classdev_unregister(&data->leds[i].ldev);
+			cancel_work_sync(&data->leds[i].work);
+			break;
+		case PCA9532_TYPE_N2100_BEEP:
+			if (data->idev != NULL) {
+				input_unregister_device(data->idev);
+				cancel_work_sync(&data->work);
+				data->idev = NULL;
 			}
+			break;
+		}
+	}
 
 	return err;
 }
@@ -341,7 +340,6 @@ static int pca9532_remove(struct i2c_client *client)
 		case PCA9532_TYPE_N2100_BEEP:
 			if (data->idev != NULL) {
 				input_unregister_device(data->idev);
-				input_free_device(data->idev);
 				cancel_work_sync(&data->work);
 				data->idev = NULL;
 			}
-- 
1.7.2



