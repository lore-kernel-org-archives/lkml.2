Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404Ab2JXTnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:43:37 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55795 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934491Ab2JXTnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:43:33 -0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 3/3] tty: Add get- ioctls to fetch tty status v3
Date: Wed, 24 Oct 2012 23:43:22 +0400
Message-Id: <1351107802-14795-4-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351107802-14795-1-git-send-email-gorcunov@gmail.com>
References: <1351107802-14795-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

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
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index df3c642..0ce0b3e 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -171,6 +171,12 @@ static int pty_set_lock(struct tty_struct *tty, int __user *arg)
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
@@ -193,6 +199,13 @@ static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
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
@@ -420,8 +433,12 @@ static int pty_bsd_ioctl(struct tty_struct *tty,
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
@@ -536,8 +553,12 @@ static int pty_unix98_ioctl(struct tty_struct *tty,
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
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index a3eba7f..739ea86 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2687,6 +2687,11 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
-- 
1.7.7.6

