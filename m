Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2I0RB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:01:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49103 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2I0RBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:01:43 -0400
Message-Id: <20120927170137.805935065@openvz.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Sep 2012 21:00:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, hpa@zytor.com, gregkh@linuxfoundation.org,
        xemul@parallels.com, jslaby@suse.cz,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/2] tty: Add get- ioctls to fetch tty status v2
References: <20120927165958.287690622@openvz.org>
Content-Disposition: inline; filename=tty-fetch-flags-5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For checkpoint/restore we need to know if tty has
exclusive or packet mode set, as well as if pty
is currently locked. Just to be able to restore
this characteristics.

For this sake the following ioctl codes are introduced

 - TIOCGPKT to get packet mode state
 - TIOCGPTLCK to get Pty locked state
 - TIOCGEXCL to get Exclusive mode state

Note this ioctls are a bit unsafe in terms of data
obtained consistency. The tty characteristics might
be changed right after ioctl complete. Keep it in
mind and use this ioctl carefully.

v2:
 - Use TIOC prefix for ioctl codes (by jslaby@)

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c            |   35 +++++++++++++++++++++++++++++++++++
 drivers/tty/tty_io.c         |    7 +++++++
 fs/compat_ioctl.c            |    3 +++
 include/asm-generic/ioctls.h |    3 +++
 4 files changed, 48 insertions(+)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -174,6 +174,14 @@ static int pty_set_lock(struct tty_struc
 	return 0;
 }
 
+static int pty_get_lock(struct tty_struct *tty, int __user *arg)
+{
+	int locked = test_bit(TTY_PTY_LOCK, &tty->flags);
+	if (put_user(locked, arg))
+		return -EFAULT;
+	return 0;
+}
+
 /* Set the packet mode on a pty */
 static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 {
@@ -199,6 +207,25 @@ static int pty_set_pktmode(struct tty_st
 	return 0;
 }
 
+/* Get the packet mode of a pty */
+static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
+{
+	unsigned long flags;
+	int pktmode;
+
+	if (tty->driver->subtype != PTY_TYPE_MASTER)
+		return -ENOTTY;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	pktmode = tty->packet;
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	if (put_user(pktmode, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
@@ -418,8 +445,12 @@ static int pty_bsd_ioctl(struct tty_stru
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCGPTLCK: /* Get PT Lock status */
+		return pty_get_lock(tty, (int __user *)arg);
 	case TIOCPKT: /* Set PT packet mode */
 		return pty_set_pktmode(tty, (int __user *)arg);
+	case TIOCGPKT: /* Get PT packet mode */
+		return pty_get_pktmode(tty, (int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
 	}
@@ -534,8 +565,12 @@ static int pty_unix98_ioctl(struct tty_s
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *)arg);
+	case TIOCGPTLCK: /* Get PT Lock status */
+		return pty_get_lock(tty, (int __user *)arg);
 	case TIOCPKT: /* Set PT packet mode */
 		return pty_set_pktmode(tty, (int __user *)arg);
+	case TIOCGPKT: /* Get PT packet mode */
+		return pty_get_pktmode(tty, (int __user *)arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
Index: tty.git/drivers/tty/tty_io.c
===================================================================
--- tty.git.orig/drivers/tty/tty_io.c
+++ tty.git/drivers/tty/tty_io.c
@@ -2693,6 +2693,13 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCNXCL:
 		clear_bit(TTY_EXCLUSIVE, &tty->flags);
 		return 0;
+	case TIOCGEXCL:
+	{
+		int excl = test_bit(TTY_EXCLUSIVE, &tty->flags);
+		if (put_user(excl, (int __user *)p))
+			return -EFAULT;
+		return 0;
+	}
 	case TIOCNOTTY:
 		if (current->signal->tty != tty)
 			return -ENOTTY;
Index: tty.git/fs/compat_ioctl.c
===================================================================
--- tty.git.orig/fs/compat_ioctl.c
+++ tty.git/fs/compat_ioctl.c
@@ -842,6 +842,9 @@ COMPATIBLE_IOCTL(TIOCGDEV)
 COMPATIBLE_IOCTL(TIOCCBRK)
 COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
+COMPATIBLE_IOCTL(TIOCGPKT)
+COMPATIBLE_IOCTL(TIOCGPTLCK)
+COMPATIBLE_IOCTL(TIOCGEXCL)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
 COMPATIBLE_IOCTL(TIOCSETD)
Index: tty.git/include/asm-generic/ioctls.h
===================================================================
--- tty.git.orig/include/asm-generic/ioctls.h
+++ tty.git/include/asm-generic/ioctls.h
@@ -74,6 +74,9 @@
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451

