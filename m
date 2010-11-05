Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab0KETFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:05:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:46557 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab0KETFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:05:37 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: stern@rowland.harvard.edu
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, Dmitry Torokhov <dtor@mail.ru>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC PATCH 4/5] kgdboc: reset input devices (keyboards) when exiting debugger
Date: Fri,  5 Nov 2010 14:05:05 -0500
Message-Id: <1288983906-31129-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288983906-31129-4-git-send-email-jason.wessel@windriver.com>
References: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-3-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Nov 2010 19:05:18.0573 (UTC) FILETIME=[631F19D0:01CB7D1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@mail.ru>

Allow all keys to be released when resuming kernel execution to avoid
problems with auto repeated keystrokes and the need to press a key an
extra time to reset its state.

[jason.wessel@windriver.com: fix compile without keyboard input driver]
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/serial/kgdboc.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 59 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index d4b711c..3374618 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -18,6 +18,7 @@
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/vt_kern.h>
+#include <linux/input.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -37,6 +38,61 @@ static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
 
 #ifdef CONFIG_KDB_KEYBOARD
+static int kgdboc_reset_connect(struct input_handler *handler,
+				struct input_dev *dev,
+				const struct input_device_id *id)
+{
+	input_reset_device(dev);
+
+	/* Retrun an error - we do not want to bind, just to reset */
+	return -ENODEV;
+}
+
+static void kgdboc_reset_disconnect(struct input_handle *handle)
+{
+	/* We do not expect anyone to actually bind to us */
+	BUG();
+}
+
+static const struct input_device_id kgdboc_reset_ids[] = {
+	{
+		.flags = INPUT_DEVICE_ID_MATCH_EVBIT,
+		.evbit = { BIT_MASK(EV_KEY) },
+	},
+	{ }
+};
+
+static struct input_handler kgdboc_reset_handler = {
+	.connect	= kgdboc_reset_connect,
+	.disconnect	= kgdboc_reset_disconnect,
+	.name		= "kgdboc_reset",
+	.id_table	= kgdboc_reset_ids,
+};
+
+static DEFINE_MUTEX(kgdboc_reset_mutex);
+
+static void kgdboc_restore_input_helper(struct work_struct *dummy)
+{
+	/*
+	 * We need to take a mutex to prevent several instances of
+	 * this work running on different CPUs so they don't try
+	 * to register again already registered handler.
+	 */
+	mutex_lock(&kgdboc_reset_mutex);
+
+	if (input_register_handler(&kgdboc_reset_handler) == 0)
+		input_unregister_handler(&kgdboc_reset_handler);
+
+	mutex_unlock(&kgdboc_reset_mutex);
+}
+
+static DECLARE_WORK(kgdboc_restore_input_work, kgdboc_restore_input_helper);
+
+static void kgdboc_restore_input(void)
+{
+	schedule_work(&kgdboc_restore_input_work);
+}
+
 static int kgdboc_register_kbd(char **cptr)
 {
 	if (strncmp(*cptr, "kbd", 3) == 0) {
@@ -64,10 +120,12 @@ static void kgdboc_unregister_kbd(void)
 			i--;
 		}
 	}
+	flush_work_sync(&kgdboc_restore_input_work);
 }
 #else /* ! CONFIG_KDB_KEYBOARD */
 #define kgdboc_register_kbd(x) 0
 #define kgdboc_unregister_kbd()
+#define kgdboc_restore_input()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
 static int kgdboc_option_setup(char *opt)
@@ -231,6 +289,7 @@ static void kgdboc_post_exp_handler(void)
 		dbg_restore_graphics = 0;
 		con_debug_leave();
 	}
+	kgdboc_restore_input();
 }
 
 static struct kgdb_io kgdboc_io_ops = {
-- 
1.6.3.3

