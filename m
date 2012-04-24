Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2DXNxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:53:20 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41163 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2DXNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:53:19 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] leds: heartbeat: stop on shutdown
Date: Tue, 24 Apr 2012 15:43:54 +0200
Message-Id: <1335275034-22135-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A halted kernel should not show a heartbeat.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/leds/ledtrig-heartbeat.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 759c0bb..76189b0 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/leds.h>
+#include <linux/reboot.h>
 #include "leds.h"
 
 struct heartbeat_trig_data {
@@ -101,13 +102,26 @@ static struct led_trigger heartbeat_led_trigger = {
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
+	register_reboot_notifier(&heartbeat_reboot_nb);
 	return led_trigger_register(&heartbeat_led_trigger);
 }
 
 static void __exit heartbeat_trig_exit(void)
 {
+	unregister_reboot_notifier(&heartbeat_reboot_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
 
-- 
1.7.6.5

