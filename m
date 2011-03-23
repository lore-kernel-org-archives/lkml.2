Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab1CWVBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:01:01 -0400
Received: from smtp205.alice.it ([82.57.200.101]:45202 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933325Ab1CWVBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:01:00 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Daniel Ribeiro <drwyrm@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openezx-devel@lists.openezx.org
Subject: [PATCH] leds: leds-regulator.c, fix handling already enabled regulators
Date: Wed, 23 Mar 2011 22:00:02 +0100
Message-Id: <1300914002-17760-1-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the driver aware of the initial status of the regulator.

The leds-regulator driver was ignoring the initial status of the
regulator; this resulted in rdev->use_count incremented up to 2 after
calling regulator_led_set_value() in the .probe method when a regulator
was already enabled at insmod time, and this made impossible to ever
disable the regulator.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---

This problem was anticipated by Mark Brown on the very first submission 
of the driver but my knowledge about regulators at the time made me 
overlook what he was asking for, now that I have actually experienced 
the problem I've finally figured out what Mark was really referring to.

NOTE: initially I thought about CC-ing stable@kernel.org as well on 
this, as it is an actual fix, but then I checked that there are 
currently no users of the driver in mainline linux and I dropped it, is 
that how it should be?

Thanks,
   Antonio Ospite
   http://ao2.it

 drivers/leds/leds-regulator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-regulator.c b/drivers/leds/leds-regulator.c
index 3790816..8497f56 100644
--- a/drivers/leds/leds-regulator.c
+++ b/drivers/leds/leds-regulator.c
@@ -178,6 +178,10 @@ static int __devinit regulator_led_probe(struct platform_device *pdev)
 	led->cdev.flags |= LED_CORE_SUSPENDRESUME;
 	led->vcc = vcc;
 
+	/* to handle correctly an already enabled regulator */
+	if (regulator_is_enabled(led->vcc))
+		led->enabled = 1;
+
 	mutex_init(&led->mutex);
 	INIT_WORK(&led->work, led_work);
 
-- 
1.7.4.1

