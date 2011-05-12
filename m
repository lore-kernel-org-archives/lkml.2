Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1ELCes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:34:48 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:59940 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1ELCer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=CM9XosbBsmqga+NlfUIY549Gj6lfuvAvcf1lRAoU6MpfZG1GsGfy6ZdEV2i1dwDLaW
         Na8zfAI4i7wcjYjSzoIrnrk9UU8K7ybgPxCbIDRQicLZmyu/BkIrjydNqeRkDpThN0p7
         XfK/2y0v/z9EI1IdiCo1tGTx9+QcBZfuwK7c8=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Date: Thu, 12 May 2011 12:32:38 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r3; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <201105111447.49816.jasonbstubbs@gmail.com> <20110511135114.GD12717@kroah.com>
In-Reply-To: <20110511135114.GD12717@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105121232.39157.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

For one of the SABI configs, the valid brightness levels are 1 through 8 with
0 being reserved for the BIOS. To make the range 0-based, the driver is meant
to offset values to/from userspace by 1 giving valid levels of 0 through 7.

Currently, the driver is reporting a max brightness of 8 and doing the offset
the wrong way such that setting a brightness of 8 will set as 7 in hardware
while setting a brightness of 0 will attempt (and fail) to set as -1 in
hardware.

This patch fixes these calculations as well as a potential miscalculation due
to an assumption of min_brightness being either 0 or 1.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
---
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 01d5278..995b041 100644
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
 
 	if (user_level == read_brightness()) {
 		return;
@@ -799,7 +801,8 @@ static int __init samsung_init(void)
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = sabi_config->max_brightness;
+	props.max_brightness = sabi_config->max_brightness -
+				sabi_config->min_brightness;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
 						     &props);
