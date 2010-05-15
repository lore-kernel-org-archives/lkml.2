Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0EOVAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:00:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62419 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0EOVAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 02/10] tty: never hold BTM while getting tty_mutex
Date: Sat, 15 May 2010 22:59:48 +0200
Message-Id: <1273957196-13768-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19lPMdqAb74iMyyjhfVzPd7r5TtGwL1MLqXogP
 ZUcyzg2NXEHZZZGMItNKbXv69dhHq9afEflqGxuDKpt3Ag4HKs
 55x8psvgQF/m3DVsOOd1g==
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
 drivers/char/pty.c    |   22 ++++++++--------------
 drivers/char/tty_io.c |   13 +++++++------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 384e79f..b441ebd 100644
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
 
@@ -657,24 +660,15 @@ static int __ptmx_open(struct inode *inode, struct file *filp)
 		goto out1;
 
 	retval = ptm_driver->ops->open(tty, filp);
-	if (!retval)
-		return 0;
+	if (retval)
+		tty_release(inode, filp);
 out1:
-	tty_release(inode, filp);
+	tty_unlock();
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
index 3bf2c75..d51993b 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1866,21 +1866,22 @@ got_driver:
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
+		tty_unlock();
 		goto retry_open;
 	}
 	tty_unlock();
-- 
1.7.0.4

