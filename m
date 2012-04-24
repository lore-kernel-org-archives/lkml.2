Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab2DXPHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:07:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55718 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab2DXPHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:07:17 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH v2] leds: heartbeat: stop on shutdown
Date: Tue, 24 Apr 2012 17:07:02 +0200
Message-Id: <1335280022-16308-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1335275034-22135-1-git-send-email-holler@ahsoftware.de>
References: <1335275034-22135-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A halted kernel should not show a heartbeat.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/leds/ledtrig-heartbeat.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 759c0bb..1c05bd9 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/leds.h>
+#include <linux/reboot.h>
 #include "leds.h"
 
 struct heartbeat_trig_data {
@@ -101,13 +102,28 @@ static struct led_trigger heartbeat_led_trigger = {
 	.deactivate = heartbeat_trig_deactivate,
 };
 
+static int heartbeat_reboot_notifier(struct notifier_block *nb,
+				     unsigned long code, void *unused)
+{
+	led_trigger_unregister(&heartbeat_led_trigger);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block heartbeat_reboot_nb = {
+	.notifier_call = heartbeat_reboot_notifier,
+};
+
 static int __init heartbeat_trig_init(void)
 {
-	return led_trigger_register(&heartbeat_led_trigger);
+	int rc = led_trigger_register(&heartbeat_led_trigger);
+	if( ! rc )
+		register_reboot_notifier(&heartbeat_reboot_nb);
+	return rc;
 }
 
 static void __exit heartbeat_trig_exit(void)
 {
+	unregister_reboot_notifier(&heartbeat_reboot_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
 
-- 
1.7.6.5

