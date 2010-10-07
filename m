Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0JGUgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 16:36:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:57529 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab0JGUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 16:36:09 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: dmitry.torokhov@gmail.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] sysrq,keyboard: properly deal with alt-sysrq in sysrq input filter
Date: Thu,  7 Oct 2010 15:35:48 -0500
Message-Id: <1286483748-1171-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
References: <1286483748-1171-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 07 Oct 2010 20:35:53.0908 (UTC) FILETIME=[3CDAA740:01CB665F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses 2 problems:

1) You should still be able to use alt-PrintScreen to capture a grab
   of a single window when the sysrq filter is active.

2) The sysrq filter should reset the low level key mask so that future
   key presses will not show up as a repeated key.  The problem was
   that when you executed alt-sysrq g and then resumed the kernel, you
   would have to press 'g' twice to get it working again.

CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-input@vger.kernel.org
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/sysrq.c |   64 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index ef31bb8..b1fad74 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -566,6 +566,57 @@ static const unsigned char sysrq_xlate[KEY_MAX + 1] =
 static bool sysrq_down;
 static int sysrq_alt_use;
 static int sysrq_alt;
+static bool sysrq_kbd_triggered;
+
+/*
+ * This function was a copy of input_pass_event but modified to allow
+ * by-passing a specific filter, to allow for injected events without
+ * filter recursion.
+ */
+static void input_pass_event_ignore(struct input_dev *dev,
+			     unsigned int type, unsigned int code, int value,
+			     struct input_handle *ignore_handle)
+{
+	struct input_handler *handler;
+	struct input_handle *handle;
+
+	rcu_read_lock();
+
+	handle = rcu_dereference(dev->grab);
+	if (handle)
+		handle->handler->event(handle, type, code, value);
+	else {
+		bool filtered = false;
+
+		list_for_each_entry_rcu(handle, &dev->h_list, d_node) {
+			if (!handle->open || handle == ignore_handle)
+				continue;
+			handler = handle->handler;
+			if (!handler->filter) {
+				if (filtered)
+					break;
+
+				handler->event(handle, type, code, value);
+
+			} else if (handler->filter(handle, type, code, value))
+				filtered = true;
+		}
+	}
+
+	rcu_read_unlock();
+}
+
+/*
+ * Pass along alt-print_screen, if there was no sysrq processing by
+ * sending a key press down and then passing the key up event.
+ */
+static void simulate_alt_sysrq(struct input_handle *handle)
+{
+	input_pass_event_ignore(handle->dev, EV_KEY, KEY_SYSRQ, 1, handle);
+	input_pass_event_ignore(handle->dev, EV_SYN, SYN_REPORT, 0, handle);
+	input_pass_event_ignore(handle->dev, EV_KEY, KEY_SYSRQ, 0, handle);
+	input_pass_event_ignore(handle->dev, EV_SYN, SYN_REPORT, 0, handle);
+}
 
 static bool sysrq_filter(struct input_handle *handle, unsigned int type,
 		         unsigned int code, int value)
@@ -580,9 +631,11 @@ static bool sysrq_filter(struct input_handle *handle, unsigned int type,
 		if (value)
 			sysrq_alt = code;
 		else {
-			if (sysrq_down && code == sysrq_alt_use)
+			if (sysrq_down && code == sysrq_alt_use) {
 				sysrq_down = false;
-
+				if (!sysrq_kbd_triggered)
+					simulate_alt_sysrq(handle);
+			}
 			sysrq_alt = 0;
 		}
 		break;
@@ -590,13 +643,18 @@ static bool sysrq_filter(struct input_handle *handle, unsigned int type,
 	case KEY_SYSRQ:
 		if (value == 1 && sysrq_alt) {
 			sysrq_down = true;
+			sysrq_kbd_triggered = false;
 			sysrq_alt_use = sysrq_alt;
 		}
 		break;
 
 	default:
-		if (sysrq_down && value && value != 2)
+		if (sysrq_down && value && value != 2 && !sysrq_kbd_triggered) {
+			sysrq_kbd_triggered = true;
 			__handle_sysrq(sysrq_xlate[code], true);
+			/* Clear handled keys from being flagged as a repeated stroke */
+			__clear_bit(code, handle->dev->key);
+		}
 		break;
 	}
 
-- 
1.6.3.3

