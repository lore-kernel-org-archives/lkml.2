Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935531Ab2JXTnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:43:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43638 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935317Ab2JXTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:43:34 -0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 1/3] tty: pty - Move TIOCPKT handling into pty.c
Date: Wed, 24 Oct 2012 23:43:20 +0400
Message-Id: <1351107802-14795-2-git-send-email-gorcunov@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351107802-14795-1-git-send-email-gorcunov@gmail.com>
References: <1351107802-14795-1-git-send-email-gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@openvz.org>

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
 drivers/tty/tty_ioctl.c |   21 ---------------------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 4219f04..df3c642 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -171,6 +171,28 @@ static int pty_set_lock(struct tty_struct *tty, int __user *arg)
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
@@ -398,6 +420,8 @@ static int pty_bsd_ioctl(struct tty_struct *tty,
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCPKT: /* Set PT packet mode */
+		return pty_set_pktmode(tty, (int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
 	}
@@ -512,6 +536,8 @@ static int pty_unix98_ioctl(struct tty_struct *tty,
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *)arg);
+	case TIOCPKT: /* Set PT packet mode */
+		return pty_set_pktmode(tty, (int __user *)arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 12b1fa0..8481b29 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1118,7 +1118,6 @@ EXPORT_SYMBOL_GPL(tty_perform_flush);
 int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
-	unsigned long flags;
 	int retval;
 
 	switch (cmd) {
@@ -1153,26 +1152,6 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
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
-- 
1.7.7.6

