Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab1KJDhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:37:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935590Ab1KJDhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:37:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:46 2011
Message-Id: <20111109213146.857143604@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:31:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Ospite <ospite@studenti.unina.it>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: [047/264] leds: turn the blink_timer off before starting to blink
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Ospite <ospite@studenti.unina.it>

commit 488bc35bf40df89d37486c1826b178a2fba36ce7 upstream.

Depending on the implementation of the hardware blinking function in
blink_set(), the led can support hardware blinking for some values of
delay_on and delay_off and fall-back to software blinking for some other
values.

Turning off the blink_timer unconditionally before starting to blink
make sure that a sequence like:

  OFF
  hardware blinking
  software blinking
  hardware blinking

does not leave the software blinking timer active.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/leds/led-class.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -267,6 +267,8 @@ void led_blink_set(struct led_classdev *
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
+	del_timer_sync(&led_cdev->blink_timer);
+
 	if (led_cdev->blink_set &&
 	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
 		led_cdev->blink_delay_on = *delay_on;


