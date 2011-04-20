Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750767Ab1DTEAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 00:00:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65435 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab1DTEAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 00:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:from:date:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=rQF3Hg5h6ocy/gNJDjkau8WdKrhzI6PJ7nptNVK5A9aw+hFfeXgPKesCpVSaV/Db2+
         3fAPiyV/buqeD/nuLmDWJt0dF2S9FN7JDY8zbxCopGwSyrivhNnQKvtHgNibO6YPyIkr
         ui8xRA+gbL2RQ+RIuMruskOK1TB2qCevBnZeU=
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] platform: fix samsung brightness min/max calculations
From: Jason Stubbs <jasonbstubbs@gmail.com>
Date: Wed, 20 Apr 2011 13:58:50 +1000
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104201358.50443.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

For one of the SABI configs, the valid brightness levels are 1 through 8 with
0 being reserved for the BIOS. To make the range 0-based, the driver is meant
to offset values to/from userspace by 1 giving valid levels of 0 through 7.

This patch fixes the reporting of the maximum level and the interpretation of
the value passed from userspace as per the above logic. It also fixes the
assumption that min_brightness will be either 0 or 1.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
---
diff --git a/drivers/platform/x86/samsung-laptop.c 
b/drivers/platform/x86/samsung-laptop.c
index d347116..ebf1b07 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -370,15 +370,17 @@ static u8 read_brightness(void)
 				  &sretval);
 	if (!retval) {
 		user_brightness = sretval.retval[0];
-		if (user_brightness != 0)
+		if (user_brightness > sabi_config->min_brightness)
 			user_brightness -= sabi_config->min_brightness;
+		else
+			user_brightness = 0;
 	}
 	return user_brightness;
 }
 
 static void set_brightness(u8 user_brightness)
 {
-	u8 user_level = user_brightness - sabi_config->min_brightness;
+	u8 user_level = user_brightness + sabi_config->min_brightness;
 
 	sabi_set_command(sabi_config->commands.set_brightness, user_level);
 }
@@ -782,7 +784,8 @@ static int __init samsung_init(void)
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = sabi_config->max_brightness;
+	props.max_brightness = sabi_config->max_brightness -
+				sabi_config->min_brightness;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
 						     &props);
