Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab2KDJz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 04:55:28 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34955 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2KDJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:55:21 -0500
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-leds@vger.kernel.org, Bryan Wu <cooloney@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: [PATCH v2 RESEND] leds: add led_trigger_rename function
Date: Sun,  4 Nov 2012 10:54:34 +0100
Message-Id: <1352022874-5100-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.12.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements a "led_trigger_rename" function to rename a trigger with
proper locking.

This assumes that led name was originally allocated in non-constant
storage.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: Bryan Wu <cooloney@gmail.com>
---

Hi Bryan,

I'm resending this one as it was probably lost it in the mail transition.

Fabio

 drivers/leds/led-triggers.c | 13 +++++++++++++
 include/linux/leds.h        | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 262eb41..a4fa4bf 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -166,6 +166,19 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL_GPL(led_trigger_set_default);
 
+void led_trigger_rename_static(const char *name, struct led_trigger *trig)
+{
+	/* new name must be on a temporary string to prevent races */
+	BUG_ON(name == trig->name);
+
+	down_write(&triggers_list_lock);
+	/* this assumes that trig->name was originaly allocated to
+	 * non constant storage */
+	strcpy((char *)trig->name, name);
+	up_write(&triggers_list_lock);
+}
+EXPORT_SYMBOL_GPL(led_trigger_rename_static);
+
 /* LED Trigger Interface */
 
 int led_trigger_register(struct led_trigger *trig)
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 6e53bb3..8107592 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -139,6 +139,24 @@ extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
 extern void led_set_brightness(struct led_classdev *led_cdev,
 			       enum led_brightness brightness);
 
+/**
+ * led_trigger_rename_static - rename a trigger
+ * @name: the new trigger name
+ * @trig: the LED trigger to rename
+ *
+ * Change a LED trigger name by copying the string passed in
+ * name into current trigger name, which MUST be large
+ * enough for the new string.
+ *
+ * Note that name must NOT point to the same string used
+ * during LED registration, as that could lead to races.
+ *
+ * This is meant to be used on triggers with statically
+ * allocated name.
+ */
+extern void led_trigger_rename_static(const char *name,
+				      struct led_trigger *trig);
+
 /*
  * LED Triggers
  */
-- 
1.7.12.1

