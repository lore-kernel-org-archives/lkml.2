Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2GDFKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:10:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2GDFKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:10:45 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/25] leds: convert HTC ASIC3 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:09:54 +0800
Message-Id: <1341378617-10386-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Paul Parsons <lost.distance@yahoo.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-asic3.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-asic3.c b/drivers/leds/leds-asic3.c
index 525a924..5de74ff 100644
--- a/drivers/leds/leds-asic3.c
+++ b/drivers/leds/leds-asic3.c
@@ -99,12 +99,13 @@ static int __devinit asic3_led_probe(struct platform_device *pdev)
 
 	ret = mfd_cell_enable(pdev);
 	if (ret < 0)
-		goto ret0;
+		return ret;
 
-	led->cdev = kzalloc(sizeof(struct led_classdev), GFP_KERNEL);
+	led->cdev = devm_kzalloc(&pdev->dev, sizeof(struct led_classdev),
+				GFP_KERNEL);
 	if (!led->cdev) {
 		ret = -ENOMEM;
-		goto ret1;
+		goto out;
 	}
 
 	led->cdev->name = led->name;
@@ -115,15 +116,12 @@ static int __devinit asic3_led_probe(struct platform_device *pdev)
 
 	ret = led_classdev_register(&pdev->dev, led->cdev);
 	if (ret < 0)
-		goto ret2;
+		goto out;
 
 	return 0;
 
-ret2:
-	kfree(led->cdev);
-ret1:
+out:
 	(void) mfd_cell_disable(pdev);
-ret0:
 	return ret;
 }
 
@@ -133,8 +131,6 @@ static int __devexit asic3_led_remove(struct platform_device *pdev)
 
 	led_classdev_unregister(led->cdev);
 
-	kfree(led->cdev);
-
 	return mfd_cell_disable(pdev);
 }
 
-- 
1.7.10.4

