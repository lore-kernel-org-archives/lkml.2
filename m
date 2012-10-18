Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2JRU1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:27:03 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56788 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 05/21] TTY: move devpts kill to pty
Date: Thu, 18 Oct 2012 22:26:31 +0200
Message-Id: <1350592007-9216-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have control over tty->driver_data in pty, we can just
kill the /dev/pts/ in pty code too. Namely, in ->shutdown hook of
tty. For pty, this is called only once, for whichever end is closed
last. But we don't care, both driver_data are the inode as it used to
be till now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c    | 9 +++++++++
 drivers/tty/tty_io.c | 5 -----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 559e5b2..2728afe 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -363,6 +363,12 @@ err:
 	return retval;
 }
 
+/* this is called once with whichever end is closed last */
+static void pty_unix98_shutdown(struct tty_struct *tty)
+{
+	devpts_kill_index(tty->driver_data, tty->index);
+}
+
 static void pty_cleanup(struct tty_struct *tty)
 {
 	kfree(tty->port);
@@ -578,6 +584,7 @@ static const struct tty_operations ptm_unix98_ops = {
 	.set_termios = pty_set_termios,
 	.ioctl = pty_unix98_ioctl,
 	.resize = pty_resize,
+	.shutdown = pty_unix98_shutdown,
 	.cleanup = pty_cleanup
 };
 
@@ -593,6 +600,7 @@ static const struct tty_operations pty_unix98_ops = {
 	.chars_in_buffer = pty_chars_in_buffer,
 	.unthrottle = pty_unthrottle,
 	.set_termios = pty_set_termios,
+	.shutdown = pty_unix98_shutdown,
 	.cleanup = pty_cleanup,
 };
 
@@ -661,6 +669,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 		goto err_release;
 
 	tty_unlock(tty);
+	tty->driver_data = inode;
 	tty->link->driver_data = slave_inode;
 	return 0;
 err_release:
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 2ea176b..e835a5b8 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1625,7 +1625,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	struct tty_struct *tty = file_tty(filp);
 	struct tty_struct *o_tty;
 	int	pty_master, tty_closing, o_tty_closing, do_sleep;
-	int	devpts;
 	int	idx;
 	char	buf[64];
 
@@ -1640,7 +1639,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	idx = tty->index;
 	pty_master = (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 		      tty->driver->subtype == PTY_TYPE_MASTER);
-	devpts = (tty->driver->flags & TTY_DRIVER_DEVPTS_MEM) != 0;
 	/* Review: parallel close */
 	o_tty = tty->link;
 
@@ -1799,9 +1797,6 @@ int tty_release(struct inode *inode, struct file *filp)
 	release_tty(tty, idx);
 	mutex_unlock(&tty_mutex);
 
-	/* Make this pty number available for reallocation */
-	if (devpts)
-		devpts_kill_index(inode, idx);
 	return 0;
 }
 
-- 
1.7.12.3


