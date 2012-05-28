Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2E1PoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:44:08 -0400
Received: from metasoft.pl ([195.149.224.191]:56360 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab2E1PoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:44:07 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2012 11:44:07 EDT
X-clamdmail: clamdmail 0.18a
Message-ID: <4FC39B5A.9010007@metasoft.pl>
Date: Mon, 28 May 2012 17:35:54 +0200
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        =?ISO-8859-2?Q?Rafa=B3_Pry=B3owski?= <prylowski@metasoft.pl>
Subject: [PATCH] leds: don't disable blinking when writing the same value
 to delay_on or delay_off
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function led_set_software_blink() assumes that blink timer is still running,
but commit 488bc35bf40df89d37486c1826b178a2fba36ce7 introduced disabling
of blink timer before each call to led_set_software_blink().

Correct led_software_blink():
1) remove protection against reprogramming blink timer to the same values,
   because it only disables blinking now,
2) remove unnecessary call to led_stop_software_blink().

Signed-off-by: Rafal Prylowski <prylowski@metasoft.pl>
Cc: Bryan Wu <bryan.wu@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---

Patch applies to current mainline.

 drivers/leds/led-core.c |    7 -------
 1 file changed, 7 deletions(-)

Index: mainline/drivers/leds/led-core.c
===================================================================
--- mainline.orig/drivers/leds/led-core.c
+++ mainline/drivers/leds/led-core.c
@@ -44,13 +44,6 @@ static void led_set_software_blink(struc
 	if (!led_cdev->blink_brightness)
 		led_cdev->blink_brightness = led_cdev->max_brightness;
 
-	if (led_get_trigger_data(led_cdev) &&
-	    delay_on == led_cdev->blink_delay_on &&
-	    delay_off == led_cdev->blink_delay_off)
-		return;
-
-	led_stop_software_blink(led_cdev);
-
 	led_cdev->blink_delay_on = delay_on;
 	led_cdev->blink_delay_off = delay_off;
 
