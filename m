Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab1IAW4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:56:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632Ab1IAW4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:56:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Sep  1 15:53:31 2011
Message-Id: <20110901225331.004899394@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 01 Sep 2011 15:50:06 -0700
From: gregkh@suse.de
To: Matthew Garrett <mjg@redhat.com>, Greg KH <greg@kroah.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Stubbs <jasonbstubbs@gmail.com>, stable <stable@kernel.org>
Subject: [patch 4/8] platform: samsung_laptop: fix samsung brightness min/max calculations
In-Reply-To: <20110901225401.GA26870@kroah.com>
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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/samsung-laptop.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

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
@@ -829,7 +831,8 @@ static int __init samsung_init(void)
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = sabi_config->max_brightness;
+	props.max_brightness = sabi_config->max_brightness -
+				sabi_config->min_brightness;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
 						     &props);


