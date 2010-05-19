Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0ESBqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:46:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:41121 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0ESBkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:06 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 14/25] kgdboc,keyboard: Keyboard driver for kdb with kgdb
Date: Tue, 18 May 2010 20:39:24 -0500
Message-Id: <1274233175-3675-15-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:53.0204 (UTC) FILETIME=[2DA9DB40:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds in the kdb PS/2 keyboard driver.  This was mostly a
direct port from the original kdb where I cleaned up the code against
checkpatch.pl and added the glue to stitch it into kgdb.

This patch also enables early kdb debug via kgdbwait and the keyboard.

All the access to configure kdb using either a serial console or the
keyboard is done via kgdboc.

If you want to use only the keyboard and want to break in early you
would add to your kernel command arguments:

    kgdboc=kbd kgdbwait

If you wanted serial and or the keyboard access you could use:

    kgdboc=kbd,ttyS0

You can also configure kgdboc as a kernel module or at run time with
the sysfs where you can activate and deactivate kgdb.

Turn it on:
    echo kbd,ttyS0 > /sys/module/kgdboc/parameters/kgdboc

Turn it off:
    echo "" > /sys/module/kgdboc/parameters/kgdboc

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 Documentation/kernel-parameters.txt |    8 +-
 drivers/serial/kgdboc.c             |   61 +++++++++-
 kernel/debug/kdb/Makefile           |    1 +
 kernel/debug/kdb/kdb_keyboard.c     |  212 +++++++++++++++++++++++++++++++++++
 lib/Kconfig.kgdb                    |    7 +
 5 files changed, 279 insertions(+), 10 deletions(-)
 create mode 100644 kernel/debug/kdb/kdb_keyboard.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..293b0e0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1113,9 +1113,11 @@ and is between 256 and 4096 characters. It is defined in the file
 			zone if it does not.
 
 	kgdboc=		[HW] kgdb over consoles.
-			Requires a tty driver that supports console polling.
-			(only serial supported for now)
-			Format: <serial_device>[,baud]
+			Requires a tty driver that supports console polling,
+			or a supported polling keyboard driver (non-usb).
+			Serial only format: <serial_device>[,baud]
+			keyboard only format: kbd
+			keyboard and serial format: kbd,<serial_device>[,baud]
 
 	kmac=		[MIPS] korina ethernet MAC address.
 			Configure the RouterBoard 532 series on-chip
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index eadc1ab..ecef6e1 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include <linux/tty.h>
 
 #define MAX_CONFIG_LEN		40
@@ -32,6 +33,40 @@ static struct kparam_string kps = {
 static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
 
+#ifdef CONFIG_KDB_KEYBOARD
+static int kgdboc_register_kbd(char **cptr)
+{
+	if (strncmp(*cptr, "kbd", 3) == 0) {
+		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
+			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
+			kdb_poll_idx++;
+			if (cptr[0][3] == ',')
+				*cptr += 4;
+			else
+				return 1;
+		}
+	}
+	return 0;
+}
+
+static void kgdboc_unregister_kbd(void)
+{
+	int i;
+
+	for (i = 0; i < kdb_poll_idx; i++) {
+		if (kdb_poll_funcs[i] == kdb_get_kbd_char) {
+			kdb_poll_idx--;
+			kdb_poll_funcs[i] = kdb_poll_funcs[kdb_poll_idx];
+			kdb_poll_funcs[kdb_poll_idx] = NULL;
+			i--;
+		}
+	}
+}
+#else /* ! CONFIG_KDB_KEYBOARD */
+#define kgdboc_register_kbd(x) 0
+#define kgdboc_unregister_kbd()
+#endif /* ! CONFIG_KDB_KEYBOARD */
+
 static int kgdboc_option_setup(char *opt)
 {
 	if (strlen(opt) > MAX_CONFIG_LEN) {
@@ -45,25 +80,38 @@ static int kgdboc_option_setup(char *opt)
 
 __setup("kgdboc=", kgdboc_option_setup);
 
+static void cleanup_kgdboc(void)
+{
+	kgdboc_unregister_kbd();
+	if (configured == 1)
+		kgdb_unregister_io_module(&kgdboc_io_ops);
+}
+
 static int configure_kgdboc(void)
 {
 	struct tty_driver *p;
 	int tty_line = 0;
 	int err;
+	char *cptr = config;
 
 	err = kgdboc_option_setup(config);
 	if (err || !strlen(config) || isspace(config[0]))
 		goto noconfig;
 
 	err = -ENODEV;
+	kgdb_tty_driver = NULL;
+
+	if (kgdboc_register_kbd(&cptr))
+		goto do_register;
 
-	p = tty_find_polling_driver(config, &tty_line);
+	p = tty_find_polling_driver(cptr, &tty_line);
 	if (!p)
 		goto noconfig;
 
 	kgdb_tty_driver = p;
 	kgdb_tty_line = tty_line;
 
+do_register:
 	err = kgdb_register_io_module(&kgdboc_io_ops);
 	if (err)
 		goto noconfig;
@@ -75,6 +123,7 @@ static int configure_kgdboc(void)
 noconfig:
 	config[0] = 0;
 	configured = 0;
+	cleanup_kgdboc();
 
 	return err;
 }
@@ -88,20 +137,18 @@ static int __init init_kgdboc(void)
 	return configure_kgdboc();
 }
 
-static void cleanup_kgdboc(void)
-{
-	if (configured == 1)
-		kgdb_unregister_io_module(&kgdboc_io_ops);
-}
-
 static int kgdboc_get_char(void)
 {
+	if (!kgdb_tty_driver)
+		return -1;
 	return kgdb_tty_driver->ops->poll_get_char(kgdb_tty_driver,
 						kgdb_tty_line);
 }
 
 static void kgdboc_put_char(u8 chr)
 {
+	if (!kgdb_tty_driver)
+		return;
 	kgdb_tty_driver->ops->poll_put_char(kgdb_tty_driver,
 					kgdb_tty_line, chr);
 }
diff --git a/kernel/debug/kdb/Makefile b/kernel/debug/kdb/Makefile
index d1e925e..d4fc58f 100644
--- a/kernel/debug/kdb/Makefile
+++ b/kernel/debug/kdb/Makefile
@@ -8,6 +8,7 @@
 
 CCVERSION	:= $(shell $(CC) -v 2>&1 | sed -ne '$$p')
 obj-y := kdb_io.o kdb_main.o kdb_support.o kdb_bt.o gen-kdb_cmds.o kdb_bp.o kdb_debugger.o
+obj-$(CONFIG_KDB_KEYBOARD)    += kdb_keyboard.o
 
 clean-files := gen-kdb_cmds.c
 
diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
new file mode 100644
index 0000000..4bca634
--- /dev/null
+++ b/kernel/debug/kdb/kdb_keyboard.c
@@ -0,0 +1,212 @@
+/*
+ * Kernel Debugger Architecture Dependent Console I/O handler
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.
+ *
+ * Copyright (c) 1999-2006 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2009 Wind River Systems, Inc.  All Rights Reserved.
+ */
+
+#include <linux/kdb.h>
+#include <linux/keyboard.h>
+#include <linux/ctype.h>
+#include <linux/module.h>
+#include <linux/io.h>
+
+/* Keyboard Controller Registers on normal PCs. */
+
+#define KBD_STATUS_REG		0x64	/* Status register (R) */
+#define KBD_DATA_REG		0x60	/* Keyboard data register (R/W) */
+
+/* Status Register Bits */
+
+#define KBD_STAT_OBF 		0x01	/* Keyboard output buffer full */
+#define KBD_STAT_MOUSE_OBF	0x20	/* Mouse output buffer full */
+
+static int kbd_exists;
+
+/*
+ * Check if the keyboard controller has a keypress for us.
+ * Some parts (Enter Release, LED change) are still blocking polled here,
+ * but hopefully they are all short.
+ */
+int kdb_get_kbd_char(void)
+{
+	int scancode, scanstatus;
+	static int shift_lock;	/* CAPS LOCK state (0-off, 1-on) */
+	static int shift_key;	/* Shift next keypress */
+	static int ctrl_key;
+	u_short keychar;
+
+	if (KDB_FLAG(NO_I8042) || KDB_FLAG(NO_VT_CONSOLE) ||
+	    (inb(KBD_STATUS_REG) == 0xff && inb(KBD_DATA_REG) == 0xff)) {
+		kbd_exists = 0;
+		return -1;
+	}
+	kbd_exists = 1;
+
+	if ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
+		return -1;
+
+	/*
+	 * Fetch the scancode
+	 */
+	scancode = inb(KBD_DATA_REG);
+	scanstatus = inb(KBD_STATUS_REG);
+
+	/*
+	 * Ignore mouse events.
+	 */
+	if (scanstatus & KBD_STAT_MOUSE_OBF)
+		return -1;
+
+	/*
+	 * Ignore release, trigger on make
+	 * (except for shift keys, where we want to
+	 *  keep the shift state so long as the key is
+	 *  held down).
+	 */
+
+	if (((scancode&0x7f) == 0x2a) || ((scancode&0x7f) == 0x36)) {
+		/*
+		 * Next key may use shift table
+		 */
+		if ((scancode & 0x80) == 0)
+			shift_key = 1;
+		else
+			shift_key = 0;
+		return -1;
+	}
+
+	if ((scancode&0x7f) == 0x1d) {
+		/*
+		 * Left ctrl key
+		 */
+		if ((scancode & 0x80) == 0)
+			ctrl_key = 1;
+		else
+			ctrl_key = 0;
+		return -1;
+	}
+
+	if ((scancode & 0x80) != 0)
+		return -1;
+
+	scancode &= 0x7f;
+
+	/*
+	 * Translate scancode
+	 */
+
+	if (scancode == 0x3a) {
+		/*
+		 * Toggle caps lock
+		 */
+		shift_lock ^= 1;
+
+#ifdef	KDB_BLINK_LED
+		kdb_toggleled(0x4);
+#endif
+		return -1;
+	}
+
+	if (scancode == 0x0e) {
+		/*
+		 * Backspace
+		 */
+		return 8;
+	}
+
+	/* Special Key */
+	switch (scancode) {
+	case 0xF: /* Tab */
+		return 9;
+	case 0x53: /* Del */
+		return 4;
+	case 0x47: /* Home */
+		return 1;
+	case 0x4F: /* End */
+		return 5;
+	case 0x4B: /* Left */
+		return 2;
+	case 0x48: /* Up */
+		return 16;
+	case 0x50: /* Down */
+		return 14;
+	case 0x4D: /* Right */
+		return 6;
+	}
+
+	if (scancode == 0xe0)
+		return -1;
+
+	/*
+	 * For Japanese 86/106 keyboards
+	 * 	See comment in drivers/char/pc_keyb.c.
+	 * 	- Masahiro Adegawa
+	 */
+	if (scancode == 0x73)
+		scancode = 0x59;
+	else if (scancode == 0x7d)
+		scancode = 0x7c;
+
+	if (!shift_lock && !shift_key && !ctrl_key) {
+		keychar = plain_map[scancode];
+	} else if ((shift_lock || shift_key) && key_maps[1]) {
+		keychar = key_maps[1][scancode];
+	} else if (ctrl_key && key_maps[4]) {
+		keychar = key_maps[4][scancode];
+	} else {
+		keychar = 0x0020;
+		kdb_printf("Unknown state/scancode (%d)\n", scancode);
+	}
+	keychar &= 0x0fff;
+	if (keychar == '\t')
+		keychar = ' ';
+	switch (KTYP(keychar)) {
+	case KT_LETTER:
+	case KT_LATIN:
+		if (isprint(keychar))
+			break;		/* printable characters */
+		/* drop through */
+	case KT_SPEC:
+		if (keychar == K_ENTER)
+			break;
+		/* drop through */
+	default:
+		return -1;	/* ignore unprintables */
+	}
+
+	if ((scancode & 0x7f) == 0x1c) {
+		/*
+		 * enter key.  All done.  Absorb the release scancode.
+		 */
+		while ((inb(KBD_STATUS_REG) & KBD_STAT_OBF) == 0)
+			;
+
+		/*
+		 * Fetch the scancode
+		 */
+		scancode = inb(KBD_DATA_REG);
+		scanstatus = inb(KBD_STATUS_REG);
+
+		while (scanstatus & KBD_STAT_MOUSE_OBF) {
+			scancode = inb(KBD_DATA_REG);
+			scanstatus = inb(KBD_STATUS_REG);
+		}
+
+		if (scancode != 0x9c) {
+			/*
+			 * Wasn't an enter-release,  why not?
+			 */
+			kdb_printf("kdb: expected enter got 0x%x status 0x%x\n",
+			       scancode, scanstatus);
+		}
+
+		return 13;
+	}
+
+	return keychar & 0xff;
+}
+EXPORT_SYMBOL_GPL(kdb_get_kbd_char);
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 78de43a..ee8ae71 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -63,4 +63,11 @@ config KGDB_KDB
 	help
 	  KDB frontend for kernel
 
+config KDB_KEYBOARD
+	bool "KGDB_KDB: keyboard as input device"
+	depends on VT && KGDB_KDB
+	default n
+	help
+	  KDB can use a PS/2 type keyboard for an input device
+
 endif # KGDB
-- 
1.6.3.3

