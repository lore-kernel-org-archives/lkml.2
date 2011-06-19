Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1FSV0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 17:26:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45992 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab1FSV0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 17:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=IfMpl1w+c7Qz20e6Z6mpYNmy068YXnwJs8+pXLb17R8o/q7sNZfJ2SGT24/rkWnmEy
         PtN3AwRbnbpI3zTLHQPV/EZSimWHERRs6T3ucI0kYqkQO1TWjBTYI3neVmHkCM2y6ZAF
         Skb5838u5UFg4KBGOCuHE9vHqMQYGaFso0z7E=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] platform: samsung_laptop: fix samsung brightness min/max calculations
Date: Mon, 20 Jun 2011 07:23:19 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.39-ARCH; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <201105132044.25928.jasonbstubbs@gmail.com> <20110613235549.GA14762@kroah.com>
In-Reply-To: <20110613235549.GA14762@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106200723.20173.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

The min_brightness value of the sabi_config is incorrectly used in brightness
calculations. For the config where min_brightness = 1 and max_brightness = 8,
the user visible range should be 0 to 7 with hardware being set in the range
of 1 to 8. What is actually happening is that the user visible range is 0 to
8 with hardware being set in the range of -1 to 7.

This patch fixes the above issue as well as a miscalculation that would occur
in the case of min_brightness > 1.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
---
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 4c78dbc..aad14ab 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -371,15 +371,17 @@ static u8 read_brightness(void)
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
 
 	if (has_stepping_quirk && user_level != 0) {
 		/*
@@ -834,7 +836,8 @@ static int __init samsung_init(void)
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = sabi_config->max_brightness;
+	props.max_brightness = sabi_config->max_brightness -
+				sabi_config->min_brightness;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
 						     &props);
