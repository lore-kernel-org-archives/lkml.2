Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0KETFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:05:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:46556 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab0KETFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:05:36 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: stern@rowland.harvard.edu
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Dmitry Torokhov <dtor@mail.ru>
Subject: [RFC PATCH 5/5] usb,keyboard,kdb: Implement HID keyboard polling
Date: Fri,  5 Nov 2010 14:05:06 -0500
Message-Id: <1288983906-31129-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288983906-31129-5-git-send-email-jason.wessel@windriver.com>
References: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-2-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-3-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-4-git-send-email-jason.wessel@windriver.com>
 <1288983906-31129-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Nov 2010 19:05:19.0479 (UTC) FILETIME=[63A95870:01CB7D1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to kdb for usb keyboards using the in kernel
API for polling a specific device on a usb hcd.

The usb hid-core requires two types of modifications:

  1) The hid-core must call back to kdb anytime a keyboard is attached
     or removed in order to allow kdb to know what keyboard devices
     should be polled.

  2) If the debugger_core is active the urb packet data needs to get
     sent directly to kdb.

The modifications to kgdboc were simply to add the additional keyboard
poll hook type as well as to call the function to flush usb queue when
nearing the time to restart normal kernel execution.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/hid/usbhid/hid-core.c   |   18 +++-
 drivers/serial/kgdboc.c         |   15 +++
 include/linux/kdb.h             |   13 +++
 kernel/debug/kdb/kdb_keyboard.c |  195 ++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.kgdb                |    7 ++
 5 files changed, 244 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 5489eab..db4f3b7 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -35,6 +35,8 @@
 #include <linux/hiddev.h>
 #include <linux/hid-debug.h>
 #include <linux/hidraw.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include "usbhid.h"
 
 /*
@@ -245,9 +247,17 @@ static void hid_irq_in(struct urb *urb)
 	case 0:			/* success */
 		usbhid_mark_busy(usbhid);
 		usbhid->retry_delay = 0;
-		hid_input_report(urb->context, HID_INPUT_REPORT,
-				 urb->transfer_buffer,
-				 urb->actual_length, 1);
+		if (unlikely(in_dbg_master() && hid && hid->driver &&
+			     urb->actual_length)) {
+			kdb_put_usb_char(usbhid->inbuf,
+					 interface_to_usbdev(usbhid->intf));
+			break;
+		} else {
+			hid_input_report(urb->context, HID_INPUT_REPORT,
+					 urb->transfer_buffer,
+					 urb->actual_length, 1);
+		}
+
 		/*
 		 * autosuspend refused while keys are pressed
 		 * because most keyboards don't wake up when
@@ -1055,6 +1065,7 @@ static int usbhid_start(struct hid_device *hid)
 				USB_INTERFACE_PROTOCOL_KEYBOARD) {
 		usbhid_set_leds(hid);
 		device_set_wakeup_enable(&dev->dev, 1);
+		kdb_keyboard_attach(dev);
 	}
 	return 0;
 
@@ -1076,6 +1087,7 @@ static void usbhid_stop(struct hid_device *hid)
 	if (WARN_ON(!usbhid))
 		return;
 
+	kdb_keyboard_detach(hid_to_usb_dev(hid));
 	clear_bit(HID_STARTED, &usbhid->iofl);
 	spin_lock_irq(&usbhid->lock);	/* Sync with error handler */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 3374618..99014d9 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -19,6 +19,7 @@
 #include <linux/console.h>
 #include <linux/vt_kern.h>
 #include <linux/input.h>
+#include <linux/usb.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -91,6 +92,9 @@ static DECLARE_WORK(kgdboc_restore_input_work, kgdboc_restore_input_helper);
 static void kgdboc_restore_input(void)
 {
 	schedule_work(&kgdboc_restore_input_work);
+#ifdef CONFIG_KDB_USB
+	usb_poll_irq_schedule_flush();
+#endif /* CONFIG_KDB_USB */
 }
 
 static int kgdboc_register_kbd(char **cptr)
@@ -99,6 +103,12 @@ static int kgdboc_register_kbd(char **cptr)
 		if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
 			kdb_poll_funcs[kdb_poll_idx] = kdb_get_kbd_char;
 			kdb_poll_idx++;
+#ifdef CONFIG_KDB_USB
+			if (kdb_poll_idx < KDB_POLL_FUNC_MAX) {
+				kdb_poll_funcs[kdb_poll_idx] = kdb_get_usb_char;
+				kdb_poll_idx++;
+			}
+#endif /* CONFIG_KDB_USB */
 			if (cptr[0][3] == ',')
 				*cptr += 4;
 			else
@@ -113,7 +123,12 @@ static void kgdboc_unregister_kbd(void)
 	int i;
 
 	for (i = 0; i < kdb_poll_idx; i++) {
+#ifdef CONFIG_KDB_USB
+		if (kdb_poll_funcs[i] == kdb_get_kbd_char ||
+			kdb_poll_funcs[i] == kdb_get_usb_char) {
+#else /* ! CONFIG_KDB_USB */
 		if (kdb_poll_funcs[i] == kdb_get_kbd_char) {
+#endif /* CONFIG_KDB_USB */
 			kdb_poll_idx--;
 			kdb_poll_funcs[i] = kdb_poll_funcs[kdb_poll_idx];
 			kdb_poll_funcs[kdb_poll_idx] = NULL;
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index aadff7c..62546f1 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -128,6 +128,19 @@ typedef int (*get_char_func)(void);
 extern get_char_func kdb_poll_funcs[];
 extern int kdb_get_kbd_char(void);
 
+#ifdef CONFIG_KDB_USB
+extern int kdb_no_usb;
+extern int kdb_get_usb_char(void);
+struct usb_device;
+void kdb_keyboard_attach(struct usb_device *dev);
+void kdb_keyboard_detach(struct usb_device *dev);
+extern void kdb_put_usb_char(char *buffer, struct usb_device *dev);
+#else /* ! CONFIG_KDB_USB */
+#define kdb_put_usb_char(x)
+#define kdb_keyboard_attach(x)
+#define kdb_keyboard_detach(x)
+#endif /* ! CONFIG_KDB_USB */
+
 static inline
 int kdb_process_cpu(const struct task_struct *p)
 {
diff --git a/kernel/debug/kdb/kdb_keyboard.c b/kernel/debug/kdb/kdb_keyboard.c
index 4bca634..1d41dc6 100644
--- a/kernel/debug/kdb/kdb_keyboard.c
+++ b/kernel/debug/kdb/kdb_keyboard.c
@@ -5,7 +5,7 @@
  * License.
  *
  * Copyright (c) 1999-2006 Silicon Graphics, Inc.  All Rights Reserved.
- * Copyright (c) 2009 Wind River Systems, Inc.  All Rights Reserved.
+ * Copyright (c) 2009-2010 Wind River Systems, Inc.  All Rights Reserved.
  */
 
 #include <linux/kdb.h>
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/usb.h>
 
 /* Keyboard Controller Registers on normal PCs. */
 
@@ -210,3 +211,195 @@ int kdb_get_kbd_char(void)
 	return keychar & 0xff;
 }
 EXPORT_SYMBOL_GPL(kdb_get_kbd_char);
+
+#ifdef CONFIG_KDB_USB
+static unsigned char kdb_usb_keycode[256] = {
+	  0,   0,   0,   0,  30,  48,  46,  32,  18,  33,  34,  35,  23,
+	 36,  37,  38,  50,  49,  24,  25,  16,  19,  31,  20,  22,  47,
+	 17,  45,  21,  44,   2,   3,   4,   5,   6,   7,   8,   9,  10,
+	 11,  28,   1,  14,  15,  57,  12,  13,  26,  27,  43,  84,  39,
+	 40,  41,  51,  52,  53,  58,  59,  60,  61,  62,  63,  64,  65,
+	 66,  67,  68,  87,  88,  99,  70, 119, 110, 102, 104, 111, 107,
+	109, 106, 105, 108, 103,  69,  98,  55,  74,  78,  96,  79,  80,
+	 81,  75,  76,  77,  71,  72,  73,  82,  83,  86, 127, 116, 117,
+	 85,  89,  90,  91,  92,  93,  94,  95, 120, 121, 122, 123, 134,
+	138, 130, 132, 128, 129, 131, 137, 133, 135, 136, 113, 115, 114,
+	  0,   0,   0, 124,   0, 181, 182, 183, 184, 185, 186, 187, 188,
+	189, 190, 191, 192, 193, 194, 195, 196, 197, 198,   0,   0,   0,
+	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
+	  0,   0,   0,  29,  42,  56, 125,  97,  54, 100, 126, 164, 166,
+	165, 163, 161, 115, 114, 113, 150, 158, 159, 128, 136, 177, 178,
+	176, 142, 152, 173, 140,
+};
+
+#define MAX_KEYBOARDS	8
+static struct usb_device *kdb_keyboard_dev[8];
+
+#define KDB_USB_RING_MAX 4
+static int kdb_usbkbd_head;
+static int kdb_usbkbd_tail;
+static int kdb_usbkbd_ring[KDB_USB_RING_MAX];
+static bool kdb_usbkbd_caps_lock;
+
+static void push_usbkbd_key(int keycode)
+{
+	int next = kdb_usbkbd_head + 1;
+
+	if (next >= KDB_USB_RING_MAX)
+		next = 0;
+	if (next == kdb_usbkbd_tail)
+		return;
+
+	kdb_usbkbd_ring[kdb_usbkbd_head] = keycode;
+	kdb_usbkbd_head = next;
+}
+
+static int kdb_pop_usbkbd_key(void)
+{
+	int next = kdb_usbkbd_tail + 1;
+	int ret = kdb_usbkbd_ring[kdb_usbkbd_tail];
+
+	if (kdb_usbkbd_tail == kdb_usbkbd_head)
+		return -1;
+	if (next >= KDB_USB_RING_MAX)
+		next = 0;
+	kdb_usbkbd_tail = next;
+	return ret;
+}
+
+#define MAX_KEYS_DOWN 4
+static int kbdusb_keys_down[MAX_KEYS_DOWN];
+static int kbdusb_idx;
+
+/*
+ * This function receive input from usb keyboard devices
+ */
+void kdb_put_usb_char(char *buffer, struct usb_device *dev)
+{
+	unsigned char keycode, spec;
+	int i, j, found;
+
+	/* Mark keys up if they are no longer down */
+	for (i = 0; i < kbdusb_idx; i++) {
+		for (j = 0; j < MAX_KEYS_DOWN; j++) {
+			if (kbdusb_keys_down[i] == buffer[2+j])
+				break;
+		}
+		if (j == MAX_KEYS_DOWN) {
+			kbdusb_idx--;
+			kbdusb_keys_down[i] = kbdusb_keys_down[kbdusb_idx];
+			i--;
+			if (kbdusb_idx == 0)
+				break;
+		}
+	}
+
+	for (i = 0; i < MAX_KEYS_DOWN; i++) {
+		if (!buffer[2+i])
+			break;
+
+		keycode = buffer[2+i];
+		buffer[2+i] = 0;
+		spec = buffer[0];
+		buffer[0] = 0;
+
+		/* if the key was previously down, skip it */
+		found = 0;
+		for (j = 0; j < kbdusb_idx; j++)
+			if (keycode == kbdusb_keys_down[j]) {
+				found = 1;
+				break;
+			}
+		if (found)
+			continue;
+
+		if (kbdusb_idx < MAX_KEYS_DOWN) {
+			kbdusb_keys_down[kbdusb_idx] = keycode;
+			kbdusb_idx++;
+		}
+		/* A normal key is pressed, decode it */
+		if (keycode)
+			keycode = kdb_usb_keycode[keycode];
+
+		/* 2 Keys pressed at one time ? */
+		if (spec && keycode) {
+			switch (spec) {
+			case 0x2:
+			case 0x20: /* Shift */
+				push_usbkbd_key(key_maps[1][keycode]);
+				break;
+			case 0x1:
+			case 0x10: /* Ctrl */
+				push_usbkbd_key(key_maps[4][keycode]);
+				break;
+			case 0x4:
+			case 0x40: /* Alt */
+				break;
+			}
+		} else if (keycode) { /* If only one key pressed */
+			switch (keycode) {
+			case 0x1C: /* Enter */
+				push_usbkbd_key(13);
+				break;
+			case 0x3A: /* Capslock */
+				kdb_usbkbd_caps_lock = !kdb_usbkbd_caps_lock;
+				break;
+			case 0x0E: /* Backspace */
+				push_usbkbd_key(8);
+				break;
+			case 0x0F: /* TAB */
+				push_usbkbd_key(9);
+				break;
+			case 0x77: /* Pause */
+				break;
+			default:
+				if (!kdb_usbkbd_caps_lock)
+					push_usbkbd_key(plain_map[keycode]);
+				else
+					push_usbkbd_key(key_maps[1][keycode]);
+				break;
+			}
+		}
+	}
+}
+
+void kdb_keyboard_attach(struct usb_device *dev)
+{
+	int i;
+
+	for (i = 0; i < MAX_KEYBOARDS; i++)
+		if (kdb_keyboard_dev[i] == NULL) {
+			kdb_keyboard_dev[i] = dev;
+			break;
+		}
+}
+
+void kdb_keyboard_detach(struct usb_device *dev)
+{
+	int i;
+
+	for (i = 0; i < MAX_KEYBOARDS; i++)
+		if (kdb_keyboard_dev[i] == dev) {
+			kdb_keyboard_dev[i] = NULL;
+			break;
+		}
+}
+
+int kdb_get_usb_char(void)
+{
+	int ret = kdb_pop_usbkbd_key();
+	int i;
+
+	if (ret >= 0)
+		return ret;
+	for (i = 0; i < MAX_KEYBOARDS; i++)
+		if (kdb_keyboard_dev[i])
+			usb_poll_irq(kdb_keyboard_dev[i]);
+	return kdb_pop_usbkbd_key();
+}
+
+#endif /* CONFIG_KDB_USB */
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 43cb93f..a13e113 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -79,4 +79,11 @@ config KDB_KEYBOARD
 	help
 	  KDB can use a PS/2 type keyboard for an input device
 
+config KDB_USB
+	bool "KGDB_KDB: Allow usb input device devices"
+	depends on VT && KGDB_KDB && KDB_KEYBOARD
+	default y
+	help
+	  KDB can use a USB keyboard for an input device
+
 endif # KGDB
-- 
1.6.3.3

