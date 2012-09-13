Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2IMJ4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:56:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38319 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2IMJ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:56:28 -0400
Date: Thu, 13 Sep 2012 13:56:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120913095623.GB28508@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For checkpoint/restore we need to know if tty has
exclusive or packet mode set, as well as if pty
is currently locked. Just to be able to restore
this characteristics.

For this sake the following ioctl codes are introduced

 - TIOGPKT to get packet mode state
 - TIOGPTLCK to get Pty locked state
 - TIOGEXCL to get Exclusive mode state

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
Guys, what do you think?

 drivers/tty/pty.c            |   12 ++++++++++++
 drivers/tty/tty_io.c         |    7 +++++++
 drivers/tty/tty_ioctl.c      |   16 ++++++++++++++++
 fs/compat_ioctl.c            |    3 +++
 include/asm-generic/ioctls.h |    3 +++
 5 files changed, 41 insertions(+)

Index: linux-2.6.git/drivers/tty/pty.c
===================================================================
--- linux-2.6.git.orig/drivers/tty/pty.c
+++ linux-2.6.git/drivers/tty/pty.c
@@ -173,6 +173,14 @@ static int pty_set_lock(struct tty_struc
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
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
@@ -342,6 +350,8 @@ static int pty_bsd_ioctl(struct tty_stru
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOGPTLCK:
+		return pty_get_lock(tty, (int __user *) arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
 	}
@@ -449,6 +459,8 @@ static int pty_unix98_ioctl(struct tty_s
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *)arg);
+	case TIOGPTLCK:
+		return pty_get_lock(tty, (int __user *) arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
Index: linux-2.6.git/drivers/tty/tty_io.c
===================================================================
--- linux-2.6.git.orig/drivers/tty/tty_io.c
+++ linux-2.6.git/drivers/tty/tty_io.c
@@ -2675,6 +2675,13 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCNXCL:
 		clear_bit(TTY_EXCLUSIVE, &tty->flags);
 		return 0;
+	case TIOGEXCL:
+	{
+		int excl = test_bit(TTY_EXCLUSIVE, &tty->flags);
+		if (put_user(excl, (int __user *)p))
+			return -EFAULT;
+		return 0;
+	}
 	case TIOCNOTTY:
 		if (current->signal->tty != tty)
 			return -ENOTTY;
Index: linux-2.6.git/drivers/tty/tty_ioctl.c
===================================================================
--- linux-2.6.git.orig/drivers/tty/tty_ioctl.c
+++ linux-2.6.git/drivers/tty/tty_ioctl.c
@@ -1173,6 +1173,22 @@ int n_tty_ioctl_helper(struct tty_struct
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return 0;
 	}
+	case TIOGPKT:
+	{
+		int pktmode;
+
+		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
+		    tty->driver->subtype != PTY_TYPE_MASTER)
+			return -ENOTTY;
+
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		pktmode = tty->packet;
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+		if (put_user(pktmode, (int __user *) arg))
+			return -EFAULT;
+		return 0;
+	}
 	default:
 		/* Try the mode commands */
 		return tty_mode_ioctl(tty, file, cmd, arg);
Index: linux-2.6.git/fs/compat_ioctl.c
===================================================================
--- linux-2.6.git.orig/fs/compat_ioctl.c
+++ linux-2.6.git/fs/compat_ioctl.c
@@ -842,6 +842,9 @@ COMPATIBLE_IOCTL(TIOCGDEV)
 COMPATIBLE_IOCTL(TIOCCBRK)
 COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
+COMPATIBLE_IOCTL(TIOGPKT)
+COMPATIBLE_IOCTL(TIOGPTLCK)
+COMPATIBLE_IOCTL(TIOGEXCL)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
 COMPATIBLE_IOCTL(TIOCSETD)
Index: linux-2.6.git/include/asm-generic/ioctls.h
===================================================================
--- linux-2.6.git.orig/include/asm-generic/ioctls.h
+++ linux-2.6.git/include/asm-generic/ioctls.h
@@ -74,6 +74,9 @@
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 #define TIOCVHANGUP	0x5437
+#define TIOGPKT		_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
