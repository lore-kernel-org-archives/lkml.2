Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab2GDFLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2GDFL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:27 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/25] leds: convert BD2802 RGB LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:09:59 +0800
Message-Id: <1341378617-10386-8-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Kim Kyuwon <q1.kim@samsung.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-bd2802.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 591cbdf..89ca6a2 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -677,7 +677,7 @@ static int __devinit bd2802_probe(struct i2c_client *client,
 	struct bd2802_led_platform_data *pdata;
 	int ret, i;
 
-	led = kzalloc(sizeof(struct bd2802_led), GFP_KERNEL);
+	led = devm_kzalloc(&client->dev, sizeof(struct bd2802_led), GFP_KERNEL);
 	if (!led) {
 		dev_err(&client->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
@@ -697,7 +697,7 @@ static int __devinit bd2802_probe(struct i2c_client *client,
 	ret = bd2802_write_byte(client, BD2802_REG_CLKSETUP, 0x00);
 	if (ret < 0) {
 		dev_err(&client->dev, "failed to detect device\n");
-		goto failed_free;
+		return ret;
 	} else
 		dev_info(&client->dev, "return 0x%02x\n", ret);
 
@@ -729,9 +729,6 @@ static int __devinit bd2802_probe(struct i2c_client *client,
 failed_unregister_dev_file:
 	for (i--; i >= 0; i--)
 		device_remove_file(&led->client->dev, bd2802_attributes[i]);
-failed_free:
-	kfree(led);
-
 	return ret;
 }
 
@@ -746,7 +743,6 @@ static int __exit bd2802_remove(struct i2c_client *client)
 		bd2802_disable_adv_conf(led);
 	for (i = 0; i < ARRAY_SIZE(bd2802_attributes); i++)
 		device_remove_file(&led->client->dev, bd2802_attributes[i]);
-	kfree(led);
 
 	return 0;
 }
-- 
1.7.10.4

