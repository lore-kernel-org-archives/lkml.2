Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2A3UVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:21:09 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:39605 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2A3UVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:21:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, jirislaby@gmail.com
Subject: [PATCH 5/5] TTY: get rid of BTM around devpts_*
Date: Mon, 30 Jan 2012 21:14:32 +0100
Message-Id: <1327954472-26594-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devpts operations are protected by inode mutexes and dentry
refcounting. There is no need to hold BTM.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c    |    6 ++----
 drivers/tty/tty_io.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index ddec9f3..39afd04 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -54,8 +54,8 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	wake_up_interruptible(&tty->link->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
-		devpts_pty_kill(tty->link);
 		tty_unlock();
+		devpts_pty_kill(tty->link);
 		tty_vhangup(tty->link);
 		tty_lock();
 	}
@@ -613,9 +613,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 		return retval;
 
 	/* find a device that is not in use. */
-	tty_lock();
 	index = devpts_new_index(inode);
-	tty_unlock();
 	if (index < 0) {
 		retval = index;
 		goto err_file;
@@ -650,8 +648,8 @@ err_release:
 	tty_release(inode, filp);
 	return retval;
 out:
-	devpts_kill_index(inode, index);
 	tty_unlock();
+	devpts_kill_index(inode, index);
 err_file:
 	tty_free_file(filp);
 	return retval;
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 44736f9..ea7ebe2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1789,11 +1789,11 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * the slots and preserving the termios structure.
 	 */
 	release_tty(tty, idx);
+	tty_unlock();
 
 	/* Make this pty number available for reallocation */
 	if (devpts)
 		devpts_kill_index(inode, idx);
-	tty_unlock();
 	return 0;
 }
 
-- 
1.7.8.3


