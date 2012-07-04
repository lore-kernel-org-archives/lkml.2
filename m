Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576Ab2GDFM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:12:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54668 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab2GDFMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:12:52 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/25] leds: convert Freescale MC13783 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:08 +0800
Message-Id: <1341378617-10386-17-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Philippe Retornaz <philippe.retornaz@epfl.ch>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-mc13783.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-mc13783.c b/drivers/leds/leds-mc13783.c
index 6515c11..2a5d434 100644
--- a/drivers/leds/leds-mc13783.c
+++ b/drivers/leds/leds-mc13783.c
@@ -280,7 +280,8 @@ static int __devinit mc13783_led_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	led = kcalloc(pdata->num_leds, sizeof(*led), GFP_KERNEL);
+	led = devm_kzalloc(&pdev->dev, pdata->num_leds * sizeof(*led),
+				GFP_KERNEL);
 	if (led == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -289,7 +290,7 @@ static int __devinit mc13783_led_probe(struct platform_device *pdev)
 	ret = mc13783_leds_prepare(pdev);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to init led driver\n");
-		goto err_free;
+		return ret;
 	}
 
 	for (i = 0; i < pdata->num_leds; i++) {
@@ -344,8 +345,6 @@ err_register:
 		cancel_work_sync(&led[i].work);
 	}
 
-err_free:
-	kfree(led);
 	return ret;
 }
 
@@ -373,7 +372,6 @@ static int __devexit mc13783_led_remove(struct platform_device *pdev)
 	mc13xxx_unlock(dev);
 
 	platform_set_drvdata(pdev, NULL);
-	kfree(led);
 	return 0;
 }
 
-- 
1.7.10.4

