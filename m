Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab2BSHId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:08:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57080 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab2BSHIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:08:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.219.130 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329635302.4818.1.camel@phoenix>
Subject: [PATCH] drivers/video/backlight/lp855x_bl.c: fix setting initial
 value for max_brightness and brightness
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 19 Feb 2012 15:08:22 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code does not always ensure
pdata->initial_brightness <= pdata->max_brightness <= MAX_BRIGHTNESS.
Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/lp855x_bl.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index d32c097..29a3af2 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -24,6 +24,7 @@
 
 #define BUF_SIZE		(20)
 #define DEFAULT_BL_NAME		"lcd-backlight"
+#define MAX_BRIGHTNESS		255
 
 struct lp855x {
 	const char *chipid;
@@ -171,10 +172,14 @@ static int lp855x_backlight_register(struct lp855x *lp)
 	char *name = pdata->name ? : DEFAULT_BL_NAME;
 
 	props.type = BACKLIGHT_PLATFORM;
+
+	if (pdata->max_brightness > MAX_BRIGHTNESS)
+		pdata->max_brightness = MAX_BRIGHTNESS;
+	props.max_brightness = pdata->max_brightness;
+
+	if (pdata->initial_brightness > pdata->max_brightness)
+		pdata->initial_brightness = pdata->max_brightness;
 	props.brightness = pdata->initial_brightness;
-	props.max_brightness =
-		(pdata->max_brightness < pdata->initial_brightness) ?
-		255 : pdata->max_brightness;
 
 	bl = backlight_device_register(name, lp->dev, lp,
 				       &lp855x_bl_ops, &props);
-- 
1.7.5.4



