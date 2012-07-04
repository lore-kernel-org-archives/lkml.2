Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571Ab2GDFN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2GDFNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:52 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/25] leds: convert Backlight emulation LED trigger driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:15 +0800
Message-Id: <1341378617-10386-24-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-backlight.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
index b941685..3fa20a9 100644
--- a/drivers/leds/ledtrig-backlight.c
+++ b/drivers/leds/ledtrig-backlight.c
@@ -101,7 +101,8 @@ static void bl_trig_activate(struct led_classdev *led)
 
 	struct bl_trig_notifier *n;
 
-	n = kzalloc(sizeof(struct bl_trig_notifier), GFP_KERNEL);
+	n = devm_kzalloc(led->dev, sizeof(struct bl_trig_notifier),
+			GFP_KERNEL);
 	led->trigger_data = n;
 	if (!n) {
 		dev_err(led->dev, "unable to allocate backlight trigger\n");
@@ -110,7 +111,7 @@ static void bl_trig_activate(struct led_classdev *led)
 
 	ret = device_create_file(led->dev, &dev_attr_inverted);
 	if (ret)
-		goto err_invert;
+		led->trigger_data = NULL;
 
 	n->led = led;
 	n->brightness = led->brightness;
@@ -123,10 +124,6 @@ static void bl_trig_activate(struct led_classdev *led)
 	led->activated = true;
 
 	return;
-
-err_invert:
-	led->trigger_data = NULL;
-	kfree(n);
 }
 
 static void bl_trig_deactivate(struct led_classdev *led)
@@ -137,7 +134,6 @@ static void bl_trig_deactivate(struct led_classdev *led)
 	if (led->activated) {
 		device_remove_file(led->dev, &dev_attr_inverted);
 		fb_unregister_client(&n->notifier);
-		kfree(n);
 		led->activated = false;
 	}
 }
-- 
1.7.10.4

