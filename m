Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877Ab2DXWjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:39:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56299 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964864Ab2DXWjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:39:15 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH v4] leds: heartbeat: stop on shutdown, reboot or panic
Date: Wed, 25 Apr 2012 00:38:57 +0200
Message-Id: <1335307137-5732-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1335306610-5549-1-git-send-email-holler@ahsoftware.de>
References: <1335306610-5549-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A halted kernel should not show a heartbeat.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/leds/ledtrig-heartbeat.c |   27 ++++++++++++++++++++++++++-
 1 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index 759c0bb..31c234c 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -18,6 +18,7 @@
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/leds.h>
+#include <linux/reboot.h>
 #include "leds.h"
 
 struct heartbeat_trig_data {
@@ -101,13 +102,37 @@ static struct led_trigger heartbeat_led_trigger = {
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
+static struct notifier_block heartbeat_panic_nb = {
+	.notifier_call = heartbeat_reboot_notifier,
+};
+
 static int __init heartbeat_trig_init(void)
 {
-	return led_trigger_register(&heartbeat_led_trigger);
+	int rc = led_trigger_register(&heartbeat_led_trigger);
+	if (!rc) {
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &heartbeat_panic_nb);
+		register_reboot_notifier(&heartbeat_reboot_nb);
+	}
+	return rc;
 }
 
 static void __exit heartbeat_trig_exit(void)
 {
+	unregister_reboot_notifier(&heartbeat_reboot_nb);
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &heartbeat_panic_nb);
 	led_trigger_unregister(&heartbeat_led_trigger);
 }
 
-- 
1.7.6.5

