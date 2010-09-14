Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0INTzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0INTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] uml: kill big kernel lock
Date: Tue, 14 Sep 2010 21:55:16 +0200
Message-Id: <1284494124-7384-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:92gu7vZOPhDb56FOadivn1Nsk1w1HrF3ygvODXJLlX2
 8pi87/r2mqamSGhQKlqnlJ/UPgiZgbkmQNZr9wTcpqwIdCdk0j
 K8JUh6Osjk/L1LqJGr4HdYRsCYdILikgZIHvcMm8guyMn1BHtE
 Rpem7XBjO1OgnxL4xpULxL2dH74noWSakw7fUBf9zsP9Y5XzQm
 qN6jzO63cRuJ0BaNYdmxw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three uml device drivers still use the big kernel lock,
but all of them can be safely converted to using
a per-driver mutex instead. Most likely this is not
even necessary, so after further review these can
and should be removed as well.

The exec system call no longer requires the BKL either,
so remove it from there, too.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/drivers/harddog_kern.c   |   13 +++++++------
 arch/um/drivers/hostaudio_kern.c |    8 ++++----
 arch/um/drivers/ubd_kern.c       |    8 ++++----
 arch/um/kernel/exec.c            |    2 --
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/um/drivers/harddog_kern.c b/arch/um/drivers/harddog_kern.c
index cfcac1f..8603627 100644
--- a/arch/um/drivers/harddog_kern.c
+++ b/arch/um/drivers/harddog_kern.c
@@ -42,7 +42,7 @@
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <asm/uaccess.h>
@@ -50,6 +50,7 @@
 
 MODULE_LICENSE("GPL");
 
+static DEFINE_MUTEX(harddog_mutex);
 static DEFINE_SPINLOCK(lock);
 static int timer_alive;
 static int harddog_in_fd = -1;
@@ -66,7 +67,7 @@ static int harddog_open(struct inode *inode, struct file *file)
 	int err = -EBUSY;
 	char *sock = NULL;
 
-	lock_kernel();
+	mutex_lock(&harddog_mutex);
 	spin_lock(&lock);
 	if(timer_alive)
 		goto err;
@@ -83,11 +84,11 @@ static int harddog_open(struct inode *inode, struct file *file)
 
 	timer_alive = 1;
 	spin_unlock(&lock);
-	unlock_kernel();
+	mutex_unlock(&harddog_mutex);
 	return nonseekable_open(inode, file);
 err:
 	spin_unlock(&lock);
-	unlock_kernel();
+	mutex_unlock(&harddog_mutex);
 	return err;
 }
 
@@ -153,9 +154,9 @@ static long harddog_ioctl(struct file *file,
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&harddog_mutex);
 	ret = harddog_ioctl_unlocked(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&harddog_mutex);
 
 	return ret;
 }
diff --git a/arch/um/drivers/hostaudio_kern.c b/arch/um/drivers/hostaudio_kern.c
index 0c46e39..fde18dc 100644
--- a/arch/um/drivers/hostaudio_kern.c
+++ b/arch/um/drivers/hostaudio_kern.c
@@ -202,9 +202,9 @@ static int hostaudio_open(struct inode *inode, struct file *file)
 		w = 1;
 
 	kparam_block_sysfs_write(dsp);
-	lock_kernel();
+	mutex_lock(&hostaudio_mutex);
 	ret = os_open_file(dsp, of_set_rw(OPENFLAGS(), r, w), 0);
-	unlock_kernel();
+	mutex_unlock(&hostaudio_mutex);
 	kparam_unblock_sysfs_write(dsp);
 
 	if (ret < 0) {
@@ -263,9 +263,9 @@ static int hostmixer_open_mixdev(struct inode *inode, struct file *file)
 		w = 1;
 
 	kparam_block_sysfs_write(mixer);
-	lock_kernel();
+	mutex_lock(&hostaudio_mutex);
 	ret = os_open_file(mixer, of_set_rw(OPENFLAGS(), r, w), 0);
-	unlock_kernel();
+	mutex_unlock(&hostaudio_mutex);
 	kparam_unblock_sysfs_write(mixer);
 
 	if (ret < 0) {
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 1bcd208..dc73bc8 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1099,7 +1099,7 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	struct ubd *ubd_dev = disk->private_data;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&ubd_mutex);
 	if(ubd_dev->count == 0){
 		err = ubd_open_dev(ubd_dev);
 		if(err){
@@ -1118,7 +1118,7 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	        err = -EROFS;
 	}*/
 out:
-	unlock_kernel();
+	mutex_unlock(&ubd_mutex);
 	return err;
 }
 
@@ -1126,10 +1126,10 @@ static int ubd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct ubd *ubd_dev = disk->private_data;
 
-	lock_kernel();
+	mutex_lock(&ubd_mutex);
 	if(--ubd_dev->count == 0)
 		ubd_close_dev(ubd_dev);
-	unlock_kernel();
+	mutex_unlock(&ubd_mutex);
 	return 0;
 }
 
diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index cd145ed..460ce86 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -78,13 +78,11 @@ long sys_execve(const char __user *file, char __user *__user *argv,
 	long error;
 	char *filename;
 
-	lock_kernel();
 	filename = getname(file);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename)) goto out;
 	error = execve1(filename, argv, env);
 	putname(filename);
  out:
-	unlock_kernel();
 	return error;
 }
-- 
1.7.1

