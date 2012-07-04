Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab2GDFMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:12:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2GDFMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:12:20 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/25] leds: convert Sun Fire LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:05 +0800
Message-Id: <1341378617-10386-14-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-sunfire.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/leds/leds-sunfire.c b/drivers/leds/leds-sunfire.c
index 1757396..134d9a4 100644
--- a/drivers/leds/leds-sunfire.c
+++ b/drivers/leds/leds-sunfire.c
@@ -132,15 +132,13 @@ static int __devinit sunfire_led_generic_probe(struct platform_device *pdev,
 	if (pdev->num_resources != 1) {
 		printk(KERN_ERR PFX "Wrong number of resources %d, should be 1\n",
 		       pdev->num_resources);
-		err = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		printk(KERN_ERR PFX "Could not allocate struct sunfire_drvdata\n");
-		err = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < NUM_LEDS_PER_BOARD; i++) {
@@ -156,20 +154,15 @@ static int __devinit sunfire_led_generic_probe(struct platform_device *pdev,
 		if (err) {
 			printk(KERN_ERR PFX "Could not register %s LED\n",
 			       lp->name);
-			goto out_unregister_led_cdevs;
+			for (i--; i >= 0; i--)
+				led_classdev_unregister(&p->leds[i].led_cdev);
+			return err;
 		}
 	}
 
 	dev_set_drvdata(&pdev->dev, p);
 
 	return 0;
-
-out_unregister_led_cdevs:
-	for (i--; i >= 0; i--)
-		led_classdev_unregister(&p->leds[i].led_cdev);
-	kfree(p);
-out:
-	return err;
 }
 
 static int __devexit sunfire_led_generic_remove(struct platform_device *pdev)
@@ -180,8 +173,6 @@ static int __devexit sunfire_led_generic_remove(struct platform_device *pdev)
 	for (i = 0; i < NUM_LEDS_PER_BOARD; i++)
 		led_classdev_unregister(&p->leds[i].led_cdev);
 
-	kfree(p);
-
 	return 0;
 }
 
-- 
1.7.10.4

