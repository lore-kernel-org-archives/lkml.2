Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1A3IgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 03:36:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46583 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab1A3IgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 03:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=eG86K4tV2loNB4HzQeYGguKBREHk87PasPO81dwmD/8T3nxD3YkZ2MaqXy9Ed4s1rN
         /ZEagaABEK3HUMwWb9nLFuGNJOLHb2MV4njtfT351usXV4DFTgD0iC9Y6MYfMoyeyQ8A
         BcchFIUp1YDiDZTIYl6TYP3qhJpHxEEv61BNk=
MIME-Version: 1.0
Date: Sun, 30 Jan 2011 00:36:22 -0800
X-Google-Sender-Auth: rRNMgRgI4wZDkKRlnU7illmCQqc
Message-ID: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
Subject: [PATCH] vt: Add virtual console keyboard mode OFF
From: Arthur Taylor <art@ified.ca>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, akpm@linux-foundation.org, alan@redhat.com,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new mode for the virtual console keyboard OFF to compliment RAW
in which all key events are ignored. New mode prevents vt input
buffers from overflowing when a program opens but doesn't read from a
tty, like Xorg using only evdev for input.

The new mode is available by the ioctl KDSKBMODE with argument K_OFF
from linux/kd.h. Does not effect sysrq behaviour.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Arthur Taylor <art@ified.ca>
---
 drivers/tty/vt/keyboard.c |    5 +++--
 drivers/tty/vt/vt_ioctl.c |    3 +++
 include/linux/kbd_kern.h  |    3 ++-
 include/linux/kd.h        |    1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index e95d787..6dd3c68 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -654,7 +654,8 @@ static void k_spec(struct vc_data *vc, unsigned
char value, char up_flag)
 	if (value >= ARRAY_SIZE(fn_handler))
 		return;
 	if ((kbd->kbdmode == VC_RAW ||
-	     kbd->kbdmode == VC_MEDIUMRAW) &&
+	     kbd->kbdmode == VC_MEDIUMRAW ||
+	     kbd->kbdmode == VC_OFF) &&
 	     value != KVAL(K_SAK))
 		return;		/* SAK is allowed even in raw mode */
 	fn_handler[value](vc);
@@ -1295,7 +1296,7 @@ static void kbd_keycode(unsigned int keycode,
int down, int hw_raw)
 	if (rc == NOTIFY_STOP)
 		return;

-	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
+	if ((raw_mode || kbd->kbdmode == VC_OFF) && type != KT_SPEC && type
!= KT_SHIFT)
 		return;

 	(*k_handler[type])(vc, keysym & 0xff, !down);
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 1235ebd..6bcf05b 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -688,6 +688,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 			kbd->kbdmode = VC_UNICODE;
 			compute_shiftstate();
 			break;
+		  case K_OFF:
+			kbd->kbdmode = VC_OFF;
+			break;
 		  default:
 			ret = -EINVAL;
 			goto out;
diff --git a/include/linux/kbd_kern.h b/include/linux/kbd_kern.h
index 506ad20..4b0761c 100644
--- a/include/linux/kbd_kern.h
+++ b/include/linux/kbd_kern.h
@@ -50,11 +50,12 @@ struct kbd_struct {
 #define VC_CAPSLOCK	2	/* capslock mode */
 #define VC_KANALOCK	3	/* kanalock mode */

-	unsigned char kbdmode:2;	/* one 2-bit value */
+	unsigned char kbdmode:3;	/* one 3-bit value */
 #define VC_XLATE	0	/* translate keycodes using keymap */
 #define VC_MEDIUMRAW	1	/* medium raw (keycode) mode */
 #define VC_RAW		2	/* raw (scancode) mode */
 #define VC_UNICODE	3	/* Unicode mode */
+#define VC_OFF		4	/* disabled mode */

 	unsigned char modeflags:5;
 #define VC_APPLIC	0	/* application key mode */
diff --git a/include/linux/kd.h b/include/linux/kd.h
index 15f2853..c36d847 100644
--- a/include/linux/kd.h
+++ b/include/linux/kd.h
@@ -81,6 +81,7 @@ struct unimapinit {
 #define		K_XLATE		0x01
 #define		K_MEDIUMRAW	0x02
 #define		K_UNICODE	0x03
+#define		K_OFF		0x04
 #define KDGKBMODE	0x4B44	/* gets current keyboard mode */
 #define KDSKBMODE	0x4B45	/* sets current keyboard mode */
