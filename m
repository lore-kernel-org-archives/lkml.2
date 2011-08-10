Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1HJHyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 03:54:51 -0400
Received: from ms14.sony.co.jp ([211.125.136.233]:33891 "EHLO ms14.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1HJHyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 03:54:50 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Aug 2011 03:54:50 EDT
Message-Id: <201108100731.p7A7VdcA000020@imail.sm.sony.co.jp>
Date: Wed, 10 Aug 2011 16:31:36 +0900
From: Masakazu Mokuno <Masakazu.Mokuno@jp.sony.com>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] led: fix memory leak
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.57.01 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

led: fix memory leak

The memory for struct led_trigger should be properly kfreed in the case of
error of led_trigger_register(). Also this function should return NULL if
error.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

---
 drivers/leds/led-triggers.c |    5 	4 +	1 -	0 !
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -261,9 +261,12 @@ void led_trigger_register_simple(const c
 	if (trigger) {
 		trigger->name = name;
 		err = led_trigger_register(trigger);
-		if (err < 0)
+		if (err < 0) {
+			kfree(trigger);
+			trigger = NULL;
 			printk(KERN_WARNING "LED trigger %s failed to register"
 				" (%d)\n", name, err);
+		}
 	} else
 		printk(KERN_WARNING "LED trigger %s failed to register"
 			" (no memory)\n", name);

