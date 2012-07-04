Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241Ab2GDFOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:14:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54689 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030229Ab2GDFOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:14:07 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/25] leds: convert One-shot LED trigger driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:17 +0800
Message-Id: <1341378617-10386-26-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-oneshot.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
index 2c029aa..6395a38 100644
--- a/drivers/leds/ledtrig-oneshot.c
+++ b/drivers/leds/ledtrig-oneshot.c
@@ -127,7 +127,8 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
 	struct oneshot_trig_data *oneshot_data;
 	int rc;
 
-	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
+	oneshot_data = devm_kzalloc(led_cdev->dev, sizeof(*oneshot_data),
+				GFP_KERNEL);
 	if (!oneshot_data)
 		return;
 
@@ -135,7 +136,7 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
 
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
 	if (rc)
-		goto err_out_trig_data;
+		return;
 	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
 	if (rc)
 		goto err_out_delayon;
@@ -159,8 +160,6 @@ err_out_delayoff:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
 err_out_delayon:
 	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
-err_out_trig_data:
-	kfree(led_cdev->trigger_data);
 }
 
 static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
@@ -172,7 +171,6 @@ static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
 		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
 		device_remove_file(led_cdev->dev, &dev_attr_invert);
 		device_remove_file(led_cdev->dev, &dev_attr_shot);
-		kfree(oneshot_data);
 		led_cdev->activated = false;
 	}
 
-- 
1.7.10.4

