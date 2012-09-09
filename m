Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2IIP2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 11:28:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57139 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2IIP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 11:28:35 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH] leds: add led_trigger_rename function
Date: Sun,  9 Sep 2012 17:27:54 +0200
Message-Id: <1347204474-1694-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements a led_trigger_rename() function to rename a trigger with
proper locking.

This also implies that "name" in "struct led_trigger" is not const
anymore.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
Hi all,

this adds a led_trigger_rename_static() function to change a trigger name
without races with other functions reading trigger names.  That would be
useful, for example, for network devices related triggers, where device name
can be changed by the user.

The implementation is actually just a locked strcpy from a temporary string
into the real one, so it probabily makes sense only for statically allocated
strings (i.e. fixed size), hence the "_static" suffix.

Any comments?

Fabio

 drivers/leds/led-triggers.c | 13 ++++++++++++-
 include/linux/leds.h        | 22 ++++++++++++++++++++--
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index b53bf54..995ae5c 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -153,6 +153,17 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
 }
 EXPORT_SYMBOL_GPL(led_trigger_set_default);
 
+void led_trigger_rename_static(const char *name, struct led_trigger *trig)
+{
+	/* new name must be on a temporary string to prevent races */
+	BUG_ON(name == trig->name);
+
+	down_write(&triggers_list_lock);
+	strcpy(trig->name, name);
+	up_write(&triggers_list_lock);
+}
+EXPORT_SYMBOL_GPL(led_trigger_rename_static);
+
 /* LED Trigger Interface */
 
 int led_trigger_register(struct led_trigger *trig)
@@ -274,7 +285,7 @@ void led_trigger_blink_oneshot(struct led_trigger *trig,
 }
 EXPORT_SYMBOL_GPL(led_trigger_blink_oneshot);
 
-void led_trigger_register_simple(const char *name, struct led_trigger **tp)
+void led_trigger_register_simple(char *name, struct led_trigger **tp)
 {
 	struct led_trigger *trig;
 	int err;
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 5676197..a8546ba 100644
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
@@ -148,7 +166,7 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
 
 struct led_trigger {
 	/* Trigger Properties */
-	const char	 *name;
+	char		*name;
 	void		(*activate)(struct led_classdev *led_cdev);
 	void		(*deactivate)(struct led_classdev *led_cdev);
 
@@ -167,7 +185,7 @@ extern void led_trigger_unregister(struct led_trigger *trigger);
 /* Registration functions for simple triggers */
 #define DEFINE_LED_TRIGGER(x)		static struct led_trigger *x;
 #define DEFINE_LED_TRIGGER_GLOBAL(x)	struct led_trigger *x;
-extern void led_trigger_register_simple(const char *name,
+extern void led_trigger_register_simple(char *name,
 				struct led_trigger **trigger);
 extern void led_trigger_unregister_simple(struct led_trigger *trigger);
 extern void led_trigger_event(struct led_trigger *trigger,
-- 
1.7.11.rc1.9.gf623ca1.dirty

