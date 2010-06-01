Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0FAUzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:55:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56281 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab0FAUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 22/31] tty: never hold BTM while getting tty_mutex
Date: Tue,  1 Jun 2010 22:53:02 +0200
Message-Id: <1275425591-8803-23-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/UPYxPd+8V3+0uHzfzvFRCsNBZCo79pAib/rz
 3mhhuV0npOYVQ46GahX8SHtqTuJOJrZ9Dd36ISQk/CSlkupgqZ
 zBDdF9v4c3h5EjMCZK9IQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_mutex is never taken with the BTM held, except for
two corner cases that are worked around here.
We give up the BTM before calling tty_release() in the
error path of tty_open().
Similarly, we reorder the locking in ptmx_open()
to get tty_mutex before the BTM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/pty.c    |   24 +++++++++++-------------
 drivers/char/tty_io.c |   12 ++++++------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 384e79f..d9c1407 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -626,7 +626,7 @@ static const struct tty_operations pty_unix98_ops = {
  *		allocated_ptys_lock handles the list of free pty numbers
  */
 
-static int __ptmx_open(struct inode *inode, struct file *filp)
+static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
 	int retval;
@@ -635,11 +635,14 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 	nonseekable_open(inode, filp);
 
 	/* find a device that is not in use. */
+	tty_lock();
 	index = devpts_new_index(inode);
+	tty_unlock();
 	if (index < 0)
 		return index;
 
 	mutex_lock(&tty_mutex);
+	tty_lock();
 	tty = tty_init_dev(ptm_driver, index, 1);
 	mutex_unlock(&tty_mutex);
 
@@ -657,24 +660,19 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 		goto out1;
 
 	retval = ptm_driver->ops->open(tty, filp);
-	if (!retval)
-		return 0;
+	if (retval)
+		goto out2;
 out1:
+	tty_unlock();
+	return retval;
+out2:
+	tty_unlock();
 	tty_release(inode, filp);
 	return retval;
 out:
 	devpts_kill_index(inode, index);
-	return retval;
-}
-
-static int ptmx_open(struct inode *inode, struct file *filp)
-{
-	int ret;
-
-	tty_lock();
-	ret = __ptmx_open(inode, filp);
 	tty_unlock();
-	return ret;
+	return retval;
 }
 
 static struct file_operations ptmx_fops;
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 4c2cc6b..d51993b 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1866,19 +1866,19 @@ got_driver:
 		printk(KERN_DEBUG "error %d in opening %s...", retval,
 		       tty->name);
 #endif
+		tty_unlock(); /* need to call tty_release without BTM */
 		tty_release(inode, filp);
-		if (retval != -ERESTARTSYS) {
-			tty_unlock();
+		if (retval != -ERESTARTSYS)
 			return retval;
-		}
-		if (signal_pending(current)) {
-			tty_unlock();
+
+		if (signal_pending(current))
 			return retval;
-		}
+
 		schedule();
 		/*
 		 * Need to reset f_op in case a hangup happened.
 		 */
+		tty_lock();
 		if (filp->f_op == &hung_up_tty_fops)
 			filp->f_op = &tty_fops;
 		tty_unlock();
-- 
1.7.0.4

