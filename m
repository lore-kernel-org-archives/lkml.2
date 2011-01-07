Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1AGQaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:30:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61760 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1AGQad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:30:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RnwQa1bERzpY48aSvrKfhrBamLU785vCrxO5Igh6SXODqu1AiLPoeViQdNR45njSnz
         ieHP8GjkM+klk3o3zs48r0xN4HRpwwbFjVyEvXty/14gwtUufOyWDInjbtPeA0WTUZRd
         +XlHfBA/RtgxX3vWaVzar4hOlBDTO73eS6lWA=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>, anarsoul@gmail.com
Subject: [RFC PATCH 1/2] LEDs: Add ability to blink via simple trigger
Date: Fri,  7 Jan 2011 18:28:16 +0200
Message-Id: <1294417697-4692-2-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294417697-4692-1-git-send-email-anarsoul@gmail.com>
References: <1294417697-4692-1-git-send-email-anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As blink API is now available, it's possible to add
ability to blink via simple trigger.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/leds/led-triggers.c |   20 ++++++++++++++++++++
 include/linux/leds.h        |    3 +++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index c41eb61..45f92ec 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -231,6 +231,26 @@ void led_trigger_event(struct led_trigger *trigger,
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
+void led_trigger_blink(struct led_trigger *trigger,
+			unsigned long *delay_on,
+			unsigned long *delay_off)
+{
+	struct list_head *entry;
+
+	if (!trigger)
+		return;
+
+	read_lock(&trigger->leddev_list_lock);
+	list_for_each(entry, &trigger->led_cdevs) {
+		struct led_classdev *led_cdev;
+
+		led_cdev = list_entry(entry, struct led_classdev, trig_list);
+		led_blink_set(led_cdev, delay_on, delay_off);
+	}
+	read_unlock(&trigger->leddev_list_lock);
+}
+EXPORT_SYMBOL_GPL(led_trigger_blink);
+
 void led_trigger_register_simple(const char *name, struct led_trigger **tp)
 {
 	struct led_trigger *trigger;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0f19df9..a1591e8 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -145,6 +145,9 @@ extern void led_trigger_register_simple(const char *name,
 extern void led_trigger_unregister_simple(struct led_trigger *trigger);
 extern void led_trigger_event(struct led_trigger *trigger,
 				enum led_brightness event);
+extern void led_trigger_blink(struct led_trigger *trigger,
+			unsigned long *delay_on,
+			unsigned long *delay_off);
 
 #else
 
-- 
1.7.3.2

