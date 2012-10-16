Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2JPJuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:50:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47414 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2JPJtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:49:40 -0400
Message-Id: <20121016094932.434394225@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Oct 2012 13:46:25 +0400
From: gorcunov@openvz.org
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 3/3] tty: Add get- ioctls to fetch tty status v3
References: <20121016094622.337128953@openvz.org>
Content-Disposition: inline; filename=tty-fetch-flags-8
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
 drivers/tty/pty.c    |   21 +++++++++++++++++++++
 drivers/tty/tty_io.c |    5 +++++
 2 files changed, 26 insertions(+)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -174,6 +174,12 @@ static int pty_set_lock(struct tty_struc
 	return 0;
 }
 
+static int pty_get_lock(struct tty_struct *tty, int __user *arg)
+{
+	int locked = test_bit(TTY_PTY_LOCK, &tty->flags);
+	return put_user(locked, arg);
+}
+
 /* Set the packet mode on a pty */
 static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
 {
@@ -196,6 +202,13 @@ static int pty_set_pktmode(struct tty_st
 	return 0;
 }
 
+/* Get the packet mode of a pty */
+static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
+{
+	int pktmode = tty->packet;
+	return put_user(pktmode, arg);
+}
+
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
@@ -415,8 +428,12 @@ static int pty_bsd_ioctl(struct tty_stru
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
@@ -531,8 +548,12 @@ static int pty_unix98_ioctl(struct tty_s
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
@@ -2690,6 +2690,11 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCNXCL:
 		clear_bit(TTY_EXCLUSIVE, &tty->flags);
 		return 0;
+	case TIOCGEXCL:
+	{
+		int excl = test_bit(TTY_EXCLUSIVE, &tty->flags);
+		return put_user(excl, (int __user *)p);
+	}
 	case TIOCNOTTY:
 		if (current->signal->tty != tty)
 			return -ENOTTY;

