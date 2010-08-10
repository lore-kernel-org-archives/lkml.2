Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354Ab0HJWII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:08:08 -0400
Received: from kroah.org ([198.145.64.141]:44917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933405Ab0HJWAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:00:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/68] tty: never hold BTM while getting tty_mutex
Date: Tue, 10 Aug 2010 14:58:58 -0700
Message-Id: <1281477570-18944-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100810214425.GB17385@kroah.com>
References: <20100810214425.GB17385@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

tty_mutex is never taken with the BTM held, except for
two corner cases that are worked around here.
We give up the BTM before calling tty_release() in the
error path of tty_open().
Similarly, we reorder the locking in ptmx_open()
to get tty_mutex before the BTM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/pty.c    |   24 +++++++++++-------------
 drivers/char/tty_io.c |   12 ++++++------
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 622e21c..de22ea9 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -647,7 +647,7 @@ static const struct tty_operations pty_unix98_ops = {
  *		allocated_ptys_lock handles the list of free pty numbers
  */
 
-static int __ptmx_open(struct inode *inode, struct file *filp)
+static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty;
 	int retval;
@@ -656,11 +656,14 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
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
 
@@ -678,24 +681,19 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
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
index 5ee9081..bb22cf4 100644
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
1.7.2

