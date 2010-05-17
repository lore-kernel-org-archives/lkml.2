Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0EQBdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 21:33:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57772 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0EQBdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 21:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=elF8YMErrrpRitc/XMX/iPFmF7tKZbdvPHAN2TIGBB2mvQiMnUoPE4m+qkGPoQm5vF
         2M7w55ctQn1EddULm8B3U0XDk+HyyA9u7O/0PfrqRcjvOhLGoQGDOywc0nVfpaciqJ+J
         wB4ci4bBk0Z+8EhAn6SiccTPmw7CVRQHei7dM=
Subject: [PATCH] leds-lp3944: properly handle lp3944_configure fail in
	lp3944_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain
Date: Mon, 17 May 2010 09:34:02 +0800
Message-Id: <1274060042.17226.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, lp3944_probe return 0 even if lp3944_configure fail.
Therefore, led_classdev_unregister will be executed twice ( in error handling of lp3944_configure and lp3944_remove ).
This patch properly handles lp3944_configure fail in lp3944_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lp3944.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index 8d5ecce..03a24d0 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -379,6 +379,7 @@ static int __devinit lp3944_probe(struct i2c_client *client,
 {
 	struct lp3944_platform_data *lp3944_pdata = client->dev.platform_data;
 	struct lp3944_data *data;
+	int err;
 
 	if (lp3944_pdata == NULL) {
 		dev_err(&client->dev, "no platform data\n");
@@ -403,8 +404,15 @@ static int __devinit lp3944_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "lp3944 enabled\n");
 
-	lp3944_configure(client, data, lp3944_pdata);
+	err = lp3944_configure(client, data, lp3944_pdata);
+	if (err < 0)
+		goto err_configure;
+
 	return 0;
+
+err_configure:
+	kfree(data);
+	return err;
 }
 
 static int __devexit lp3944_remove(struct i2c_client *client)
-- 
1.5.4.3



