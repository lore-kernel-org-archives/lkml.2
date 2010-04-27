Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0D0JSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:18:55 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab0D0JSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=e7I1ahuGaFfXVbZhP8hvYhQWURlI8C6fq7f7glpwqZ/ZfQDHdTO/6GIr8VCvFY05Wo
         UJ5lmh9O3qOOU82XHqSL4UQBAMNknqSHar2V8lGk/L1UwgH1IcF9N1PjO/0J/2MbrhwJ
         MGnX5+JaGp/k+gqSr5nnanJlLGSxEOzJW9tz0=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 06/10] isdn: push down BKL into ioctl functions
Date: Tue, 27 Apr 2010 11:18:14 +0200
Message-Id: <1272359898-32020-7-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Fixed merge conflicts that result from having applied
Linus's Preparation for BKL'ed ioctl removal patch first.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/isdn/capi/capi.c            |   17 ++++++++++++++---
 drivers/isdn/divert/divert_procfs.c |   19 ++++++++++++++++---
 drivers/isdn/i4l/isdn_common.c      |   18 +++++++++++++++---
 drivers/isdn/mISDN/timerdev.c       |   10 ++++++----
 4 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 6bc9766..0cabe31 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -787,8 +787,7 @@ capi_poll(struct file *file, poll_table * wait)
 }
 
 static int
-capi_ioctl(struct inode *inode, struct file *file,
-	   unsigned int cmd, unsigned long arg)
+capi_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct capidev *cdev = file->private_data;
 	capi_ioctl_struct data;
@@ -981,6 +980,18 @@ register_out:
 	}
 }
 
+static long
+capi_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = capi_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int capi_open(struct inode *inode, struct file *file)
 {
 	struct capidev *cdev;
@@ -1026,7 +1037,7 @@ static const struct file_operations capi_fops =
 	.read		= capi_read,
 	.write		= capi_write,
 	.poll		= capi_poll,
-	.bkl_ioctl	= capi_ioctl,
+	.unlocked_ioctl	= capi_unlocked_ioctl,
 	.open		= capi_open,
 	.release	= capi_release,
 };
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index ae0244f..8084557 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -11,6 +11,7 @@
 
 #include <linux/module.h>
 #include <linux/poll.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
@@ -178,8 +179,7 @@ isdn_divert_close(struct inode *ino, struct file *filep)
 /* IOCTL */
 /*********/
 static int
-isdn_divert_ioctl(struct inode *inode, struct file *file,
-		  uint cmd, ulong arg)
+isdn_divert_ioctl(struct file *file, uint cmd, ulong arg)
 {
 	divert_ioctl dioctl;
 	int i;
@@ -258,6 +258,19 @@ isdn_divert_ioctl(struct inode *inode, struct file *file,
 	return copy_to_user((void __user *)arg, &dioctl, sizeof(dioctl)) ? -EFAULT : 0;
 }				/* isdn_divert_ioctl */
 
+static long
+isdn_divert_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = isdn_divert_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 static const struct file_operations isdn_fops =
 {
 	.owner          = THIS_MODULE,
@@ -265,7 +278,7 @@ static const struct file_operations isdn_fops =
 	.read           = isdn_divert_read,
 	.write          = isdn_divert_write,
 	.poll           = isdn_divert_poll,
-	.bkl_ioctl      = isdn_divert_ioctl,
+	.unlocked_ioctl = isdn_divert_unlocked_ioctl,
 	.open           = isdn_divert_open,
 	.release        = isdn_divert_close,                                      
 };
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 08ba72d..a44cdb4 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1272,9 +1272,9 @@ isdn_poll(struct file *file, poll_table * wait)
 
 
 static int
-isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
+isdn_ioctl(struct file *file, uint cmd, ulong arg)
 {
-	uint minor = iminor(inode);
+	uint minor = iminor(file->f_path.dentry->d_inode);
 	isdn_ctrl c;
 	int drvidx;
 	int chidx;
@@ -1722,6 +1722,18 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 #undef cfg
 }
 
+static long
+isdn_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = isdn_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  * Open the device code.
  */
@@ -1838,7 +1850,7 @@ static const struct file_operations isdn_fops =
 	.read		= isdn_read,
 	.write		= isdn_write,
 	.poll		= isdn_poll,
-	.bkl_ioctl	= isdn_ioctl,
+	.unlocked_ioctl	= isdn_unlocked_ioctl,
 	.open		= isdn_open,
 	.release	= isdn_close,
 };
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index fc7d777..c3243c9 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -24,6 +24,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/mISDNif.h>
+#include <linux/smp_lock.h>
 #include "core.h"
 
 static u_int	*debug;
@@ -215,9 +216,8 @@ unlock:
 	return ret;
 }
 
-static int
-mISDN_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
-    unsigned long arg)
+static long
+mISDN_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct mISDNtimerdev	*dev = filep->private_data;
 	int			id, tout, ret = 0;
@@ -226,6 +226,7 @@ mISDN_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
 	if (*debug & DEBUG_TIMER)
 		printk(KERN_DEBUG "%s(%p, %x, %lx)\n", __func__,
 		    filep, cmd, arg);
+	lock_kernel();
 	switch (cmd) {
 	case IMADDTIMER:
 		if (get_user(tout, (int __user *)arg)) {
@@ -257,13 +258,14 @@ mISDN_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
 	default:
 		ret = -EINVAL;
 	}
+	unlock_kernel();
 	return ret;
 }
 
 static const struct file_operations mISDN_fops = {
 	.read		= mISDN_read,
 	.poll		= mISDN_poll,
-	.bkl_ioctl	= mISDN_ioctl,
+	.unlocked_ioctl	= mISDN_ioctl,
 	.open		= mISDN_open,
 	.release	= mISDN_close,
 };
-- 
1.6.6.1

