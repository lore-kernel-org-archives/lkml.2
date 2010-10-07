Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0JGUgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:36:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:57526 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0JGUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:36:06 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: dmitry.torokhov@gmail.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] keyboard,kgdboc: Allow key release on kernel resume
Date: Thu,  7 Oct 2010 15:35:46 -0500
Message-Id: <1286483748-1171-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
References: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Oct 2010 20:35:52.0111 (UTC) FILETIME=[3BC873F0:01CB665F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a keyboard with kdb, a hook point to free all the
keystrokes is required for resuming kernel operations.

This is mainly because there is no way to force the end user to hold
down the original keys that were pressed prior to entering kdb when
resuming the kernel.

The kgdboc driver will call kbd_dbg_clear_keys() just prior to
resuming the kernel execution which will schedule a callback to clear
any keys which were depressed prior to the entering the kernel
debugger.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-input@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/keyboard.c  |   37 +++++++++++++++++++++++++++++++++++++
 drivers/serial/kgdboc.c  |   13 +++++++++++++
 include/linux/kbd_kern.h |    1 +
 3 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index a7ca752..0c6c641 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -363,6 +363,43 @@ static void to_utf8(struct vc_data *vc, uint c)
 	}
 }
 
+#ifdef CONFIG_KDB_KEYBOARD
+static int kbd_clear_keys_helper(struct input_handle *handle, void *data)
+{
+	unsigned int *keycode = data;
+	input_inject_event(handle, EV_KEY, *keycode, 0);
+	return 0;
+}
+
+static void kbd_clear_keys_callback(struct work_struct *dummy)
+{
+	unsigned int i, j, k;
+
+	for (i = 0; i < ARRAY_SIZE(key_down); i++) {
+		if (!key_down[i])
+			continue;
+
+		k = i * BITS_PER_LONG;
+
+		for (j = 0; j < BITS_PER_LONG; j++, k++) {
+			if (!test_bit(k, key_down))
+				continue;
+			input_handler_for_each_handle(&kbd_handler, &k,
+				      kbd_clear_keys_helper);
+		}
+	}
+}
+
+static DECLARE_WORK(kbd_clear_keys_work, kbd_clear_keys_callback);
+
+/* Called to clear any key presses after resuming the kernel. */
+void kbd_dbg_clear_keys(void)
+{
+	schedule_work(&kbd_clear_keys_work);
+}
+EXPORT_SYMBOL_GPL(kbd_dbg_clear_keys);
+#endif /* CONFIG_KDB_KEYBOARD */
+
 /*
  * Called after returning from RAW mode or when changing consoles - recompute
  * shift_down[] and shift_state from key_down[] maybe called when keymap is
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 39f9a1a..62b6edc 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -18,6 +18,7 @@
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/vt_kern.h>
+#include <linux/kbd_kern.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -37,12 +38,16 @@ static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
 
 #ifdef CONFIG_KDB_KEYBOARD
+static bool			kgdboc_use_kbd;
+
 static int kgdboc_register_kbd(char **cptr)
 {
+	kgdboc_use_kbd = false;
 	if (strncmp(*cptr, "kbd", 3) == 0) {
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
+			kgdboc_use_kbd = true;
 			if (cptr[0][3] == ',')
 				*cptr += 4;
 			else
@@ -65,9 +70,16 @@ static void kgdboc_unregister_kbd(void)
 		}
 	}
 }
+
+static inline void kgdboc_clear_kbd(void)
+{
+	if (kgdboc_use_kbd)
+		kbd_dbg_clear_keys(); /* Release all pressed keys */
+}
 #else /* ! CONFIG_KDB_KEYBOARD */
 #define kgdboc_register_kbd(x) 0
 #define kgdboc_unregister_kbd()
+#define kgdboc_clear_kbd()
 #endif /* ! CONFIG_KDB_KEYBOARD */
 
 static int kgdboc_option_setup(char *opt)
@@ -231,6 +243,7 @@ static void kgdboc_post_exp_handler(void)
 		dbg_restore_graphics = 0;
 		con_debug_leave();
 	}
+	kgdboc_clear_kbd();
 }
 
 static struct kgdb_io kgdboc_io_ops = {
diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
index 506ad20..ae87c0a 100644
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -144,6 +144,7 @@ struct console;
 int getkeycode(unsigned int scancode);
 int setkeycode(unsigned int scancode, unsigned int keycode);
 void compute_shiftstate(void);
+void kbd_dbg_clear_keys(void);
 
 /* defkeymap.c */
 
-- 
1.6.3.3

