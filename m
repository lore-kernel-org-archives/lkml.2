Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0LTBym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:54:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38347 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0LTByi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:54:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=oJJx/oocxUJJ/QPcizT1iGSLm8oUXBYTQ4s2oI6RrkaLQ0PAEyUgjnsuKYBiJl2Pjy
         ce2m3NQPOfObVK6PbT56wOWk0iswy61j/ZK5+9PBVRpz0sgk3Z0lzTA27IjgI+eJ4zmD
         EzI46i8jXH8rLM5OAaMlI9bF5cYC0aDpjQ5G8=
Subject: [PATCH v2] leds: leds-pca9532 cleanups
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Riku Voipio <riku.voipio@iki.fi>, Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dtor@mail.ru>
Content-Type: text/plain
Date: Mon, 20 Dec 2010 09:49:37 +0800
Message-Id: <1292809777.15685.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes:
1. Remove unneeded input_free_device() after input_unregister_device().
2. Add pca9532_destroy_devices() function for destroy devices.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Changes for v2:
Base on Dmitry's comments to add pca9532_destroy_devices() for destroy devices.

 drivers/leds/leds-pca9532.c |   66 ++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 43d0875..afac338 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -200,6 +200,32 @@ static void pca9532_led_work(struct work_struct *work)
 	pca9532_setled(led);
 }
 
+static void pca9532_destroy_devices(struct pca9532_data *data, int n_devs)
+{
+	int i = n_devs;
+
+	if (!data)
+		return;
+
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
+			}
+			break;
+		}
+	}
+}
+
 static int pca9532_configure(struct i2c_client *client,
 	struct pca9532_data *data, struct pca9532_platform_data *pdata)
 {
@@ -274,25 +300,7 @@ static int pca9532_configure(struct i2c_client *client,
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
-			}
-
+	pca9532_destroy_devices(data, i);
 	return err;
 }
 
@@ -329,25 +337,7 @@ static int pca9532_probe(struct i2c_client *client,
 static int pca9532_remove(struct i2c_client *client)
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
-	int i;
-	for (i = 0; i < 16; i++)
-		switch (data->leds[i].type) {
-		case PCA9532_TYPE_NONE:
-			break;
-		case PCA9532_TYPE_LED:
-			led_classdev_unregister(&data->leds[i].ldev);
-			cancel_work_sync(&data->leds[i].work);
-			break;
-		case PCA9532_TYPE_N2100_BEEP:
-			if (data->idev != NULL) {
-				input_unregister_device(data->idev);
-				input_free_device(data->idev);
-				cancel_work_sync(&data->work);
-				data->idev = NULL;
-			}
-			break;
-		}
-
+	pca9532_destroy_devices(data, 16);
 	kfree(data);
 	return 0;
 }
-- 
1.7.2



