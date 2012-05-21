Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2EUPwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:52:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:50326 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab2EUPww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:52:52 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] leds: lm3533: use devres to manage driver data
Date: Mon, 21 May 2012 17:52:39 +0200
Message-Id: <1337615559-5868-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devres to manage driver data.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/leds/leds-lm3533.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-lm3533.c b/drivers/leds/leds-lm3533.c
index 4ef496c..e968470 100644
--- a/drivers/leds/leds-lm3533.c
+++ b/drivers/leds/leds-lm3533.c
@@ -632,7 +632,7 @@ static int __devinit lm3533_led_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	led = kzalloc(sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
 		return -ENOMEM;
 
@@ -661,7 +661,7 @@ static int __devinit lm3533_led_probe(struct platform_device *pdev)
 	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", pdev->id);
-		goto err_free;
+		return ret;
 	}
 
 	led->cb.dev = led->cdev.dev;
@@ -688,8 +688,6 @@ err_sysfs_remove:
 err_unregister:
 	led_classdev_unregister(&led->cdev);
 	flush_work_sync(&led->work);
-err_free:
-	kfree(led);
 
 	return ret;
 }
@@ -704,7 +702,6 @@ static int __devexit lm3533_led_remove(struct platform_device *pdev)
 	sysfs_remove_group(&led->cdev.dev->kobj, &lm3533_led_attribute_group);
 	led_classdev_unregister(&led->cdev);
 	flush_work_sync(&led->work);
-	kfree(led);
 
 	return 0;
 }
-- 
1.7.8.5

