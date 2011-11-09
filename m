Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964966Ab1KJEe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:34:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935900Ab1KJDg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:36:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:46 2011
Message-Id: <20111109213146.741162097@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Ospite <ospite@studenti.unina.it>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [046/264] leds: save the delay values after a successful call to blink_set()
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Ospite <ospite@studenti.unina.it>

commit 6123b0e274503a0d3588e84fbe07c9aa01bfaf5d upstream.

When calling the hardware blinking function implemented by blink_set(),
the delay_on and delay_off values are not preserved across calls.

Fix that and make the "timer" trigger work as expected when hardware
blinking is available.

BEFORE the fix:
  $ cd /sys/class/leds/someled
  $ echo timer > trigger
  $ cat delay_on delay_off
  0
  0
  $ echo 100 > delay_on
  $ cat delay_on delay_off
  0
  0
  $ echo 100 > delay_off
  $ cat delay_on delay_off
  0
  0

AFTER the fix:
  $ cd /sys/class/leds/someled
  $ echo timer > trigger
  $ cat delay_on delay_off
  0
  0
  $ echo 100 > delay_on
  $ cat delay_on delay_off
  100
  0
  $ echo 100 > delay_off
  $ cat delay_on delay_off
  100
  100

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/leds/led-class.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -268,8 +268,11 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_off)
 {
 	if (led_cdev->blink_set &&
-	    !led_cdev->blink_set(led_cdev, delay_on, delay_off))
+	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
+		led_cdev->blink_delay_on = *delay_on;
+		led_cdev->blink_delay_off = *delay_off;
 		return;
+	}
 
 	/* blink with 1 Hz as default if nothing specified */
 	if (!*delay_on && !*delay_off)


