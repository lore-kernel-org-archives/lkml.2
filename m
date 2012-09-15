Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2IOQVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 12:21:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56935 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2IOQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 12:21:11 -0400
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Kurt Van Dijck <kurt.van.dijck@eia.be>,
        Bryan Wu <bryan.wu@canonical.com>
Subject: [PATCH v2] leds: add led_trigger_rename function
Date: Sat, 15 Sep 2012 18:18:44 +0200
Message-Id: <1347725924-1760-1-git-send-email-fabio.baltieri@gmail.com>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <20120915161518.GA1687@gmail.com>
References: <20120915161518.GA1687@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implements a "led_trigger_rename" function to rename a trigger with
proper locking.

This assumes that led name was originally allocated in non-constant
storage.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/led-triggers.c | 13 +++++++++++++
 include/linux/leds.h        | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index b53bf54..c0f5d7c 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -153,6 +153,19 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
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
index 5676197..21644c7 100644
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
1.7.11.rc1.9.gf623ca1.dirty

