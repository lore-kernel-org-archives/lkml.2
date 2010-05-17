Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0EQJqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:46:51 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:53025 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0EQJqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hh4PFqxad3YCCxuAbgRjdBZz4MCVg+csSuZ6N+q+X71YOkDHmymMPr8caGrx+GZbjj
         xoIg6jJ5rdrfk5W/76m61nJRGuYINHcgPrVcAcPBQlg9/YxV3sFU16LCzJIAU3IMIDho
         mRjX1HY+0bPlOXVyuQQOW3jlG40ZewLqfLXbE=
Subject: [PATCH v2] leds-lp3944: properly handle lp3944_configure fail in
	lp3944_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain
Date: Mon, 17 May 2010 17:47:48 +0800
Message-Id: <1274089668.28623.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, lp3944_probe return 0 even if lp3944_configure fail.
Therefore, led_classdev_unregister will be executed twice
( in error handling of lp3944_configure and lp3944_remove ).
This patch properly handles lp3944_configure fail in lp3944_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lp3944.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index 8d5ecce..932a58d 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -379,6 +379,7 @@ static int __devinit lp3944_probe(struct i2c_client *client,
 {
 	struct lp3944_platform_data *lp3944_pdata = client->dev.platform_data;
 	struct lp3944_data *data;
+	int err;
 
 	if (lp3944_pdata == NULL) {
 		dev_err(&client->dev, "no platform data\n");
@@ -401,9 +402,13 @@ static int __devinit lp3944_probe(struct i2c_client *client,
 
 	mutex_init(&data->lock);
 
-	dev_info(&client->dev, "lp3944 enabled\n");
+	err = lp3944_configure(client, data, lp3944_pdata);
+	if (err < 0) {
+		kfree(data);
+		return err;
+	}
 
-	lp3944_configure(client, data, lp3944_pdata);
+	dev_info(&client->dev, "lp3944 enabled\n");
 	return 0;
 }
 
-- 
1.5.4.3



