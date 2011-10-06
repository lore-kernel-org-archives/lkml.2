Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303Ab1JFWDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:03:53 -0400
Received: from smtp208.alice.it ([82.57.200.104]:36703 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929Ab1JFWDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:03:51 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Johannes Berg <johannes.berg@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] leds: save the delay values after a successful call to blink_set()
Date: Fri,  7 Oct 2011 00:03:30 +0200
Message-Id: <1317938611-4418-2-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
References: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/leds/led-class.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index d5a4ade..939f24a 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -267,8 +267,11 @@ void led_blink_set(struct led_classdev *led_cdev,
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
-- 
1.7.6.3

