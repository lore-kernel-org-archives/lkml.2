Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895Ab1AMLBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 06:01:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61955 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab1AMLBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 06:01:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Am+KkqsprxsImR+yC2LSMRUiZIwWAaVXM00+ET5x54rGu0h+7m/g7MZgvF7OX/65K6
         VaWCBWl70mqaKnTpa7RbBZzcgOls/5UD9q/rqNhLxuubg9I5Tp4Ub53z/EN3XVbtzS67
         21y5kI0ENI62TkfIVtRnd0+EwbR1/zf0RrQ70=
MIME-Version: 1.0
In-Reply-To: <20110111143417.GD22390@atrey.karlin.mff.cuni.cz>
References: <AANLkTimqzWuGUvMo+8znuVbYocsnsJe7Heo+xY5jRrXv@mail.gmail.com>
	<20110111143417.GD22390@atrey.karlin.mff.cuni.cz>
Date: Thu, 13 Jan 2011 03:01:48 -0800
X-Google-Sender-Auth: eY6lD0NtpFCw99kSgiw3Jxm3kBc
Message-ID: <AANLkTi=CqG+3aJ2yYgsMEdzQp=1Fsph-MPS5StXAVgm0@mail.gmail.com>
Subject: Re: [RFC] New console keyboard mode OFF
From: Arthur Taylor <art@ified.ca>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Seems very sane. Of course it all depends what a patch looks like...
>                                                                        Pavel

Well the simple method is only 9 lines.

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
index 6b68a0f..b498b2e 100644
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
