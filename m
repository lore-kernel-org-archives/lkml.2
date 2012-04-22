Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2DVO5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:57:25 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:51332 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2DVO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:57:24 -0400
Message-ID: <1335106633.6261.1.camel@phoenix>
Subject: [PATCH] leds: lm3556: Don't call kfree for the memory allocated by
 devm_kzalloc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Geon Si Jeong <gshark.jeong@gmail.com>, Woogyom Kim <milo.kim@ti.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 22 Apr 2012 22:57:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_* functions eliminate the need for manual resource releasing
and simplify error handling. Resources allocated by devm_* are freed
automatically on driver detach.

Thus adding kfree calls here will introduce double free bug.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-lm3556.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lm3556.c b/drivers/leds/leds-lm3556.c
index cc0abbc..15a5acd 100644
--- a/drivers/leds/leds-lm3556.c
+++ b/drivers/leds/leds-lm3556.c
@@ -360,9 +360,8 @@ static int lm3556_probe(struct i2c_client *client,
 		return -ENODATA;
 	}
 
-	chip =
-	    devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
-			 GFP_KERNEL);
+	chip = devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
+			    GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
@@ -416,7 +415,6 @@ err_create_torch_file:
 err_create_flash_file:
 err_chip_init:
 	i2c_set_clientdata(client, NULL);
-	kfree(chip);
 	return err;
 }
 
@@ -430,7 +428,6 @@ static int lm3556_remove(struct i2c_client *client)
 	led_classdev_unregister(&chip->cdev_flash);
 	lm3556_write_reg(client, REG_ENABLE, 0);
 
-	kfree(chip);
 	return 0;
 }
 
-- 
1.7.5.4



