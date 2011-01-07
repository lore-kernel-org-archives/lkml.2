Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab1AGQah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 11:30:37 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41419 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1AGQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 11:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CyuD0Y5+j6f8U9jOUBGBnaWSJnRMT/4EztcTabaJLsadEhv4VvuTWRITm26FpOibre
         AXRW4aldvJSyUtdiiYRjB2ZVISdzZU3RMNsp8DvRCElVk45xygJgXecqdrForYefFhro
         CpD2uaQtslLUJNKHgOZ4JlMyIaAj1mfo81p+s=
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>, anarsoul@gmail.com
Subject: [RFC PATCH 2/2] power_supply: Add new LED trigger charging-blink-solid-full
Date: Fri,  7 Jan 2011 18:28:17 +0200
Message-Id: <1294417697-4692-3-git-send-email-anarsoul@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1294417697-4692-1-git-send-email-anarsoul@gmail.com>
References: <1294417697-4692-1-git-send-email-anarsoul@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new trigger to power_supply LEDs. It will blink when
battery is charging, and stay solid when battery is charged.
It's usefull to indicate battery state when there's only one
LED available.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
---
 drivers/power/power_supply_leds.c |   18 ++++++++++++++++++
 include/linux/power_supply.h      |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 031a554..b640bbf 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -21,6 +21,7 @@
 static void power_supply_update_bat_leds(struct power_supply *psy)
 {
 	union power_supply_propval status;
+	unsigned long delay_on = 0, delay_off = 0;
 
 	if (psy->get_property(psy, POWER_SUPPLY_PROP_STATUS, &status))
 		return;
@@ -32,16 +33,22 @@ static void power_supply_update_bat_leds(struct power_supply *psy)
 		led_trigger_event(psy->charging_full_trig, LED_FULL);
 		led_trigger_event(psy->charging_trig, LED_OFF);
 		led_trigger_event(psy->full_trig, LED_FULL);
+		led_trigger_event(psy->charging_blink_full_solid_trig,
+			LED_FULL);
 		break;
 	case POWER_SUPPLY_STATUS_CHARGING:
 		led_trigger_event(psy->charging_full_trig, LED_FULL);
 		led_trigger_event(psy->charging_trig, LED_FULL);
 		led_trigger_event(psy->full_trig, LED_OFF);
+		led_trigger_blink(psy->charging_blink_full_solid_trig,
+			&delay_on, &delay_off);
 		break;
 	default:
 		led_trigger_event(psy->charging_full_trig, LED_OFF);
 		led_trigger_event(psy->charging_trig, LED_OFF);
 		led_trigger_event(psy->full_trig, LED_OFF);
+		led_trigger_event(psy->charging_blink_full_solid_trig,
+			LED_OFF);
 		break;
 	}
 }
@@ -64,15 +71,24 @@ static int power_supply_create_bat_triggers(struct power_supply *psy)
 	if (!psy->full_trig_name)
 		goto full_failed;
 
+	psy->charging_blink_full_solid_trig_name = kasprintf(GFP_KERNEL,
+		"%s-charging-blink-full-solid", psy->name);
+	if (!psy->charging_blink_full_solid_trig_name)
+		goto charging_blink_full_solid_failed;
+
 	led_trigger_register_simple(psy->charging_full_trig_name,
 				    &psy->charging_full_trig);
 	led_trigger_register_simple(psy->charging_trig_name,
 				    &psy->charging_trig);
 	led_trigger_register_simple(psy->full_trig_name,
 				    &psy->full_trig);
+	led_trigger_register_simple(psy->charging_blink_full_solid_trig_name,
+				    &psy->charging_blink_full_solid_trig);
 
 	goto success;
 
+charging_blink_full_solid_failed:
+	kfree(psy->full_trig_name);
 full_failed:
 	kfree(psy->charging_trig_name);
 charging_failed:
@@ -88,6 +104,8 @@ static void power_supply_remove_bat_triggers(struct power_supply *psy)
 	led_trigger_unregister_simple(psy->charging_full_trig);
 	led_trigger_unregister_simple(psy->charging_trig);
 	led_trigger_unregister_simple(psy->full_trig);
+	led_trigger_unregister_simple(psy->charging_blink_full_solid_trig);
+	kfree(psy->charging_blink_full_solid_trig_name);
 	kfree(psy->full_trig_name);
 	kfree(psy->charging_trig_name);
 	kfree(psy->charging_full_trig_name);
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 7d73256..32a1e50 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -173,6 +173,8 @@ struct power_supply {
 	char *full_trig_name;
 	struct led_trigger *online_trig;
 	char *online_trig_name;
+	struct led_trigger *charging_blink_full_solid_trig;
+	char *charging_blink_full_solid_trig_name;
 #endif
 };
 
-- 
1.7.3.2

