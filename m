Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab2GDFNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204Ab2GDFN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:27 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/25] leds: convert Network Space v2 LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:12 +0800
Message-Id: <1341378617-10386-21-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-ns2.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/leds-ns2.c b/drivers/leds/leds-ns2.c
index 01cf89e..10528da 100644
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@ -273,29 +273,23 @@ static int __devinit ns2_led_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
-	leds_data = kzalloc(sizeof(struct ns2_led_data) *
+	leds_data = devm_kzalloc(&pdev->dev, sizeof(struct ns2_led_data) *
 			    pdata->num_leds, GFP_KERNEL);
 	if (!leds_data)
 		return -ENOMEM;
 
 	for (i = 0; i < pdata->num_leds; i++) {
 		ret = create_ns2_led(pdev, &leds_data[i], &pdata->leds[i]);
-		if (ret < 0)
-			goto err;
-
+		if (ret < 0) {
+			for (i = i - 1; i >= 0; i--)
+				delete_ns2_led(&leds_data[i]);
+			return ret;
+		}
 	}
 
 	platform_set_drvdata(pdev, leds_data);
 
 	return 0;
-
-err:
-	for (i = i - 1; i >= 0; i--)
-		delete_ns2_led(&leds_data[i]);
-
-	kfree(leds_data);
-
-	return ret;
 }
 
 static int __devexit ns2_led_remove(struct platform_device *pdev)
@@ -309,7 +303,6 @@ static int __devexit ns2_led_remove(struct platform_device *pdev)
 	for (i = 0; i < pdata->num_leds; i++)
 		delete_ns2_led(&leds_data[i]);
 
-	kfree(leds_data);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.10.4

