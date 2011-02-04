Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1BDVzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:55:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37389 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1BDVzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:55:54 -0500
Subject: Re: [PATCH] [resend] vt: Add virtual console keyboard mode OFF
From: Arthur Taylor <art@ified.ca>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20110203184852.GC20911@kroah.com>
References: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
	 <20110131174622.GA25097@suse.de> <1296612452.28176.52.camel@art-x200>
	 <20110203184852.GC20911@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 13:55:50 -0800
Message-ID: <1296856550.3555.11.camel@art-x200>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 10:48 -0800, Greg KH wrote:
> Are the xorg patches upstream and accepted or are they waiting for this
> change?  Will they work properly with the BSDs as well?

The Xorg patches requires this change to exist first to make sense,
hence is not upstream. The Xorg code which requires changing is in the
platform specific support code for linux
(xserver/hw/xfree86/os-support/linux/lnx_init.c) so I don't think the
BSDs even had the problem to begin with.

> Thanks for the information, but we also need the original changelog
> comment here for me to be able to apply it.
> 
> Care to resend with all of the text correct?

Hopefully this is correct. Thanks for the help, this is my first time
using the lkml.
---
commit ee6be802d3cfaba8e1693ec7ad266077bb89ccd6
Author: Arthur Taylor <art@ified.ca>
Date:   Sun Jan 30 00:13:03 2011 -0800

    virtual console: add keyboard mode OFF
    
    Add a new mode for the virtual console keyboard OFF in which all input
    other than shift keys is ignored. Prevents vt input buffers from
    overflowing when a program opens but doesn't read from a tty, like X11
    using evdev for input.
    
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
 

