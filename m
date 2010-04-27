Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0D0JTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:19:08 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:52542 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0D0JSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=r3o7cAyKxS6pxeQ1f9npSKM96vBlkkGkOWDmIRbKLwsHp2jatHx2zWTkji1rFcQGUC
         +BskuagR4jCPR1G/0UcqukB83wh2RM0Lp5vhH0G+bHoP8Vi74s92xIS4Efwel8R8N2iG
         ZuF3NCdmGjIBArWArMInFu2BVRC3WWdVDwWmI=
From: John Kacur <jkacur@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 07/10] staging: push down BKL into ioctl functions
Date: Tue, 27 Apr 2010 11:18:15 +0200
Message-Id: <1272359898-32020-8-git-send-email-jkacur@redhat.com>
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
 drivers/staging/crystalhd/crystalhd_lnx.c |   13 +++++++++----
 drivers/staging/dt3155/dt3155_drv.c       |   24 ++++++++++++++++++------
 drivers/staging/poch/poch.c               |   17 +++++++++++++++--
 drivers/staging/vme/devices/vme_user.c    |   18 +++++++++++++++---
 4 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index 3d6b773..3291e14 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -16,6 +16,7 @@
 ***************************************************************************/
 
 #include <linux/version.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 
 #include "crystalhd_lnx.h"
@@ -261,12 +262,12 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 }
 
 /* API interfaces */
-static int chd_dec_ioctl(struct inode *in, struct file *fd,
-			 unsigned int cmd, unsigned long ua)
+static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 {
 	struct crystalhd_adp *adp = chd_get_adp();
 	crystalhd_cmd_proc cproc;
 	struct crystalhd_user *uc;
+	int ret;
 
 	if (!adp || !fd) {
 		BCMLOG_ERR("Invalid adp\n");
@@ -279,13 +280,17 @@ static int chd_dec_ioctl(struct inode *in, struct file *fd,
 		return -ENODATA;
 	}
 
+	lock_kernel();
 	cproc = crystalhd_get_cmd_proc(&adp->cmds, cmd, uc);
 	if (!cproc) {
 		BCMLOG_ERR("Unhandled command: %d\n", cmd);
+		unlock_kernel();
 		return -EINVAL;
 	}
 
-	return chd_dec_api_cmd(adp, ua, uc->uid, cmd, cproc);
+	ret = chd_dec_api_cmd(adp, ua, uc->uid, cmd, cproc);
+	unlock_kernel();
+	return ret;
 }
 
 static int chd_dec_open(struct inode *in, struct file *fd)
@@ -345,7 +350,7 @@ static int chd_dec_close(struct inode *in, struct file *fd)
 
 static const struct file_operations chd_dec_fops = {
 	.owner   = THIS_MODULE,
-	.bkl_ioctl   = chd_dec_ioctl,
+	.unlocked_ioctl = chd_dec_ioctl,
 	.open    = chd_dec_open,
 	.release = chd_dec_close,
 };
diff --git a/drivers/staging/dt3155/dt3155_drv.c b/drivers/staging/dt3155/dt3155_drv.c
index 09fb197..7e6095f 100644
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@ -63,6 +63,7 @@ extern void printques(int);
 #include <linux/types.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
+#include <linux/smp_lock.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -835,6 +836,17 @@ static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
   return 0;
 }
 
+static long
+dt3155_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = dt3155_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
 
 /*****************************************************
  * file operations supported by DT3155 driver
@@ -842,12 +854,12 @@ static unsigned int dt3155_poll (struct file * filp, poll_table *wait)
  *  register_chrdev
  *****************************************************/
 static struct file_operations dt3155_fops = {
-  read:		dt3155_read,
-  bkl_ioctl:	dt3155_ioctl,
-  mmap:		dt3155_mmap,
-  poll:         dt3155_poll,
-  open:		dt3155_open,
-  release:	dt3155_close
+	.read		= dt3155_read,
+	.unlocked_ioctl	= dt3155_unlocked_ioctl,
+	.mmap		= dt3155_mmap,
+	.poll		= dt3155_poll,
+	.open		= dt3155_open,
+	.release	= dt3155_close
 };
 
 
diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index edc8c58..bf46e29 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -16,6 +16,7 @@
 #include <linux/sysfs.h>
 #include <linux/poll.h>
 #include <linux/idr.h>
+#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/ioctl.h>
@@ -911,7 +912,7 @@ static unsigned int poch_poll(struct file *filp, poll_table *pt)
 	return ret;
 }
 
-static int poch_ioctl(struct inode *inode, struct file *filp,
+static int poch_ioctl(struct file *filp,
 		      unsigned int cmd, unsigned long arg)
 {
 	struct channel_info *channel = filp->private_data;
@@ -1033,11 +1034,23 @@ static int poch_ioctl(struct inode *inode, struct file *filp,
 	return 0;
 }
 
+static long
+poch_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = poch_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static struct file_operations poch_fops = {
 	.owner = THIS_MODULE,
 	.open = poch_open,
 	.release = poch_release,
-	.bkl_ioctl = poch_ioctl,
+	.poch_ioctl = poch_unlocked_ioctl,
 	.poll = poch_poll,
 	.mmap = poch_mmap
 };
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 7ba7149..bc16fc0 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
+#include <linux/smp_lock.h>
 #include <linux/types.h>
 
 #include <asm/io.h>
@@ -130,8 +131,7 @@ static int vme_user_release(struct inode *, struct file *);
 static ssize_t vme_user_read(struct file *, char *, size_t, loff_t *);
 static ssize_t vme_user_write(struct file *, const char *, size_t, loff_t *);
 static loff_t vme_user_llseek(struct file *, loff_t, int);
-static int vme_user_ioctl(struct inode *, struct file *, unsigned int,
-	unsigned long);
+static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
 static int __init vme_user_probe(struct device *, int, int);
 static int __exit vme_user_remove(struct device *, int, int);
@@ -142,7 +142,7 @@ static struct file_operations vme_user_fops = {
         .read = vme_user_read,
         .write = vme_user_write,
         .llseek = vme_user_llseek,
-        .bkl_ioctl = vme_user_ioctl,
+        .unlocked_ioctl = vme_user_unlocked_ioctl,
 };
 
 
@@ -555,6 +555,18 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 	return -EINVAL;
 }
 
+static long
+vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = vme_user_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 
 /*
  * Unallocate a previously allocated buffer
-- 
1.6.6.1

