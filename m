Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab1DNRqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:37999 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988Ab1DNRqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Graham Gower <graham.gower@gmail.com>,
        Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 047/209] drivers/char/vt_ioctl.c: fix VT_OPENQRY error value
Date: Thu, 14 Apr 2011 13:41:17 -0400
Message-Id: <1302803039-9400-48-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graham Gower <graham.gower@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 1e0ad2881d50becaeea70ec696a80afeadf944d2 upstream.

When all VT's are in use, VT_OPENQRY casts -1 to unsigned char before
returning it to userspace as an int.  VT255 is not the next available
console.

Signed-off-by: Graham Gower <graham.gower@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/vt_ioctl.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..6351a26 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -503,6 +503,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	struct kbd_struct * kbd;
 	unsigned int console;
 	unsigned char ucval;
+	unsigned int uival;
 	void __user *up = (void __user *)arg;
 	int i, perm;
 	int ret = 0;
@@ -657,7 +658,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGETMODE:
-		ucval = vc->vc_mode;
+		uival = vc->vc_mode;
 		goto setint;
 
 	case KDMAPDISP:
@@ -695,7 +696,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGKBMODE:
-		ucval = ((kbd->kbdmode == VC_RAW) ? K_RAW :
+		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
 				 K_XLATE);
@@ -717,9 +718,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGKBMETA:
-		ucval = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
+		uival = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
 	setint:
-		ret = put_user(ucval, (int __user *)arg);
+		ret = put_user(uival, (int __user *)arg);
 		break;
 
 	case KDGETKEYCODE:
@@ -949,7 +950,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (! VT_IS_IN_USE(i))
 				break;
-		ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
+		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 
 
 	/*
-- 
1.7.4.4

