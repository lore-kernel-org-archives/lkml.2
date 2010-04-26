Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab0DZWYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:24:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63406 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab0DZWYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:24:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] isdn: push down BKL into ioctl functions
Date: Tue, 27 Apr 2010 00:24:02 +0200
Message-Id: <1272320645-8671-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201004262112.39906.arnd@arndb.de>
References: <201004262112.39906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/e1u6nPf4/nNjlXbK6H0qzZ0AAnUit8bFiVsL
 peeiDCK8vWnEh0DdUCRCyUNiq1qEhsEZfnLCvnRcvBHR+Fjq5o
 3LkhtWjIR32B6uiTK6wTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/capi/capi.c            |   17 ++++++++++++++---
 drivers/isdn/divert/divert_procfs.c |   19 ++++++++++++++++---
 drivers/isdn/i4l/isdn_common.c      |   18 +++++++++++++++---
 drivers/isdn/mISDN/timerdev.c       |   10 ++++++----
 4 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index ee58375..0cabe31 100644
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
-	.ioctl		= capi_ioctl,
+	.unlocked_ioctl	= capi_unlocked_ioctl,
 	.open		= capi_open,
 	.release	= capi_release,
 };
diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index 9f49d90..8084557 100644
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
-	.ioctl          = isdn_divert_ioctl,
+	.unlocked_ioctl = isdn_divert_unlocked_ioctl,
 	.open           = isdn_divert_open,
 	.release        = isdn_divert_close,                                      
 };
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 70044ee..a44cdb4 100644
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
-	.ioctl		= isdn_ioctl,
+	.unlocked_ioctl	= isdn_unlocked_ioctl,
 	.open		= isdn_open,
 	.release	= isdn_close,
 };
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index 8785004..c3243c9 100644
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
-	.ioctl		= mISDN_ioctl,
+	.unlocked_ioctl	= mISDN_ioctl,
 	.open		= mISDN_open,
 	.release	= mISDN_close,
 };
-- 
1.7.0.4

