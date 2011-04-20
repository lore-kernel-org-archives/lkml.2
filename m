Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1DTFJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 01:09:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39588 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab1DTFJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 01:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=DiuMP14wkBK4O5SWzAcWjIbjrFwzXiqKg4qhRl9zpaXQ+CfNfJaC8KDpKML4uRcBEh
         2IeltHcwq2HZwgpF9Ju8Y56SOBx733M+QOqC3TLDzSvInOBKbab3R7gG4v6ZFrtEFqcY
         YcggDjGe6dhsZW9bfn2921+YtRNsPHQlx71pY=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] platform: add support for samsung nc210/nc110
Date: Wed, 20 Apr 2011 15:07:54 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104201507.54862.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

Note, I don't expect this patch to go in and would actually just like some
feedback on how to better handle the set_brightness problem. Note also that
this patch won't apply on top of my brightness min/max fixes patch and I'll
redo this one as necessary.

This patch adds support for the NC210/NC110 to the samsung-laptop driver.

All SABI commands except for set_brightness work as expected. The behaviour
of set_brightness is as follows:

- Setting a new brightness will only step one level toward the new brightness
  level. For example, setting a level of 5 when the current level is 2 will
  result in a brightness level of 3.
- A spurious KEY_BRIGHTNESS_UP or KEY_BRIGHTNESS_DOWN event is also generated
  along with the change in brightness.
- Neither of the above two issues occur when changing from/to brightness level 0.

The changes in set_brightness() work around the above while attempting to
minimize flicker due to jumping to and from brightness level 0.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
---
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index d347116..01d5278 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -380,6 +380,14 @@ static void set_brightness(u8 user_brightness)
 {
 	u8 user_level = user_brightness - sabi_config->min_brightness;
 
+	if (user_level == read_brightness()) {
+		return;
+	}
+
+	if (sabi_config->min_brightness == 0 && user_level != 0) {
+		sabi_set_command(sabi_config->commands.set_brightness, 0);
+	}
+
 	sabi_set_command(sabi_config->commands.set_brightness, user_level);
 }
 
@@ -666,6 +674,15 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "NC210/NC110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "NC210/NC110"),
+			DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
