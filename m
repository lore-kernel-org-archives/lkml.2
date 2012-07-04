Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab2GDFLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab2GDFLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:11 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/25] leds: convert DA9030/DA9034 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:09:57 +0800
Message-Id: <1341378617-10386-6-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Eric Miao <eric.miao@canonical.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-da903x.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index d9cd73e..cc77c9d 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -108,7 +108,7 @@ static int __devinit da903x_led_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	led = kzalloc(sizeof(struct da903x_led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, sizeof(struct da903x_led), GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory for LED%d\n", id);
 		return -ENOMEM;
@@ -129,15 +129,11 @@ static int __devinit da903x_led_probe(struct platform_device *pdev)
 	ret = led_classdev_register(led->master, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", id);
-		goto err;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, led);
 	return 0;
-
-err:
-	kfree(led);
-	return ret;
 }
 
 static int __devexit da903x_led_remove(struct platform_device *pdev)
@@ -145,7 +141,6 @@ static int __devexit da903x_led_remove(struct platform_device *pdev)
 	struct da903x_led *led = platform_get_drvdata(pdev);
 
 	led_classdev_unregister(&led->cdev);
-	kfree(led);
 	return 0;
 }
 
-- 
1.7.10.4

