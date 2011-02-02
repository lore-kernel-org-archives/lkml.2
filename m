Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1BBCPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:15:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54194 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1BBCPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:15:30 -0500
Subject: [PATCH] [resend] vt: Add virtual console keyboard mode OFF
From: Arthur Taylor <art@ified.ca>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20110131174622.GA25097@suse.de>
References: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
	 <20110131174622.GA25097@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 18:07:32 -0800
Message-ID: <1296612452.28176.52.camel@art-x200>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 09:46 -0800, Greg KH wrote:
> Care to document this somewhere (i.e. Documentation/ABI?)
Sure. Can it wait for a future patch though as currently all VT IOCTLs
aren't documented in the source tree. I'm willing to write said
documentation.

> Your patch is line-wrapped and can not be applied :(
Fixed in this mail (hopefully).

> Are you sure you can change the size of this structure and no one is
> going to have problems?
>From what I can tell, no. kbd_struct and it's members are defined in the
non-exported kbd_kern.h, and it is never packed into weird places. Is
that sufficient? What else should be checked?

> Also, what userspace code is going to use this new feature?  Has it been
> tested to work properly?
Xorg is the intended user. In short, reasons for the feature are:
      * Removes having to flush unnecessary duplicate data.
      * Fixes an Xorg corner case.
      * Less code run in both kernel and userspace per key event (I know
        kinda meh, but hey, it's a plus.)

Since the switch to evdev and automatic input device detection, Xorg
sets the console to RAW to disable kernel special key handling and
flushes the console input buffer per key event.

If Xorg is configured with static input device definitions, it can't
flush the input in case the older kbd driver is in use, leading to the
buffer filling. If the console input buffer fills, bad things happen
(which I'm currently looking into as well.)

I modified my xserver to use this feature. I tested Xorg with the
input-evdev and input-kbd drivers for keyboard events. Since input-kbd
sets the keyboard back to RAW when needed, everything is fine. If
input-kbd isn't in use, the keyboard stays in OFF and he input buffer is
always kept empty, things always work. Shift key states are maintained,
and SysRq's unRaw function is still works as expected.

To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>
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
@@ -654,7 +654,8 @@ static void k_spec(struct vc_data *vc, unsigned char value, char up_flag)
 	if (value >= ARRAY_SIZE(fn_handler))
 		return;
 	if ((kbd->kbdmode == VC_RAW ||
-	     kbd->kbdmode == VC_MEDIUMRAW) &&
+	     kbd->kbdmode == VC_MEDIUMRAW ||
+	     kbd->kbdmode == VC_OFF) &&
 	     value != KVAL(K_SAK))
 		return;		/* SAK is allowed even in raw mode */
 	fn_handler[value](vc);
@@ -1295,7 +1296,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 	if (rc == NOTIFY_STOP)
 		return;
 
-	if (raw_mode && type != KT_SPEC && type != KT_SHIFT)
+	if ((raw_mode || kbd->kbdmode == VC_OFF) && type != KT_SPEC && type != KT_SHIFT)
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
 

