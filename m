Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333Ab1JFWEC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:04:02 -0400
Received: from smtp207.alice.it ([82.57.200.103]:38528 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965307Ab1JFWEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:04:00 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Johannes Berg <johannes.berg@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] leds: turn the blink_timer off before starting to blink
Date: Fri,  7 Oct 2011 00:03:31 +0200
Message-Id: <1317938611-4418-3-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
References: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/leds/led-class.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index 939f24a..a7f0b29 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -266,6 +266,8 @@ void led_blink_set(struct led_classdev *led_cdev,
 		   unsigned long *delay_on,
 		   unsigned long *delay_off)
 {
+	del_timer_sync(&led_cdev->blink_timer);
+
 	if (led_cdev->blink_set &&
 	    !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
 		led_cdev->blink_delay_on = *delay_on;
-- 
1.7.6.3

