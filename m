Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2JPJtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:49:41 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:43921 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JPJtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:49:39 -0400
Message-Id: <20121016094932.272408290@openvz.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Oct 2012 13:46:23 +0400
From: gorcunov@openvz.org
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/3] tty: pty - Move TIOCPKT handling into pty.c
References: <20121016094622.337128953@openvz.org>
Content-Disposition: inline; filename=tty-move-pktmode-set-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this ioctl is for pty devices only move it to pty.c.

v2:
 - drop PTY_TYPE_MASTER test since it's master peer
   ioctl anyway (by jslaby@)

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c       |   26 ++++++++++++++++++++++++++
 drivers/tty/tty_ioctl.c |   20 --------------------
 2 files changed, 26 insertions(+), 20 deletions(-)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -174,6 +174,28 @@ static int pty_set_lock(struct tty_struc
 	return 0;
 }
 
+/* Set the packet mode on a pty */
+static int pty_set_pktmode(struct tty_struct *tty, int __user *arg)
+{
+	unsigned long flags;
+	int pktmode;
+
+	if (get_user(pktmode, arg))
+		return -EFAULT;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	if (pktmode) {
+		if (!tty->packet) {
+			tty->packet = 1;
+			tty->link->ctrl_status = 0;
+		}
+	} else
+		tty->packet = 0;
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	return 0;
+}
+
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
@@ -393,6 +415,8 @@ static int pty_bsd_ioctl(struct tty_stru
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCPKT: /* Set PT packet mode */
+		return pty_set_pktmode(tty, (int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
 	}
@@ -507,6 +531,8 @@ static int pty_unix98_ioctl(struct tty_s
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *)arg);
+	case TIOCPKT: /* Set PT packet mode */
+		return pty_set_pktmode(tty, (int __user *)arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
Index: tty.git/drivers/tty/tty_ioctl.c
===================================================================
--- tty.git.orig/drivers/tty/tty_ioctl.c
+++ tty.git/drivers/tty/tty_ioctl.c
@@ -1153,26 +1153,6 @@ int n_tty_ioctl_helper(struct tty_struct
 		return 0;
 	case TCFLSH:
 		return tty_perform_flush(tty, arg);
-	case TIOCPKT:
-	{
-		int pktmode;
-
-		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
-		    tty->driver->subtype != PTY_TYPE_MASTER)
-			return -ENOTTY;
-		if (get_user(pktmode, (int __user *) arg))
-			return -EFAULT;
-		spin_lock_irqsave(&tty->ctrl_lock, flags);
-		if (pktmode) {
-			if (!tty->packet) {
-				tty->packet = 1;
-				tty->link->ctrl_status = 0;
-			}
-		} else
-			tty->packet = 0;
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-		return 0;
-	}
 	default:
 		/* Try the mode commands */
 		return tty_mode_ioctl(tty, file, cmd, arg);

