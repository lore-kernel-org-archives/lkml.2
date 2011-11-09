Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1KJFUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:20:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934240Ab1KJDXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.757168270@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Stubbs <jasonbstubbs@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [073/262] platform: samsung_laptop: fix samsung brightness min/max calculations
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Stubbs <jasonbstubbs@gmail.com>

commit bee460be8c691c544e84ed678280ace6153104c6 upstream.

The min_brightness value of the sabi_config is incorrectly used in brightness
calculations. For the config where min_brightness = 1 and max_brightness = 8,
the user visible range should be 0 to 7 with hardware being set in the range
of 1 to 8. What is actually happening is that the user visible range is 0 to
8 with hardware being set in the range of -1 to 7.

This patch fixes the above issue as well as a miscalculation that would occur
in the case of min_brightness > 1.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>

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
@@ -819,7 +821,8 @@ static int __init samsung_init(void)
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = sabi_config->max_brightness;
+	props.max_brightness = sabi_config->max_brightness -
+				sabi_config->min_brightness;
 	backlight_device = backlight_device_register("samsung", &sdev->dev,
 						     NULL, &backlight_ops,
 						     &props);


