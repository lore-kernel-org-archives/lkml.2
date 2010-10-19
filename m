Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab0JSJRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:17:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab0JSJRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:17:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Weinberger <richard@nod.at>
Subject: Re: linux-next: user mode linux build failure (2)
Date: Tue, 19 Oct 2010 11:18:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>
References: <201010190200.01496.richard@nod.at>
In-Reply-To: <201010190200.01496.richard@nod.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010191118.06960.arnd@arndb.de>
X-Provags-ID: V02:K0:xU6q+uNO6amfyPDkbNYBwzU4/WhN14wyJFYdQ0Rqka/
 IvLa2CZjROvWzqZc56Iv1XplGMNZPCuXXlTkT8DpsYAHGQqGMk
 eSUR8CcISn3myyf+xkAoGnW3O36Igh9knmqJDNPLXOlAO09N9c
 8RNC61XeI62UM4LfHS076UKRx+tVTmWskRcjr1Rz73WJN9nNj+
 iF0xbVMfsBM0jYG8gdabg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010, Richard Weinberger wrote:
> Hi!
> 
> 1e3d8715 (uml: kill big kernel lock) breaks um build.
> 
> arch/um/drivers/ubd_kern.c: In function 'ubd_open':
> arch/um/drivers/ubd_kern.c:1104: error: 'ubd_mutex' undeclared (first use in 
> this function)
> arch/um/drivers/ubd_kern.c:1104: error: (Each undeclared identifier is 
> reported only once
> arch/um/drivers/ubd_kern.c:1104: error: for each function it appears in.)
> arch/um/drivers/ubd_kern.c: In function 'ubd_release':
> arch/um/drivers/ubd_kern.c:1131: error: 'ubd_mutex' undeclared (first use in 
> this function)
> make[1]: *** [arch/um/drivers/ubd_kern.o] Error 1
> make: *** [arch/um/drivers] Error 2
> 
> It seems you forgot to define ubd_mutex in ubd_kern.c.

Thanks for the report, I updated the patch now to the version below.

	Arnd

---
Subject: [PATCH] uml: kill big kernel lock

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
index 0c46e39..d92ff6d 100644
--- a/arch/um/drivers/hostaudio_kern.c
+++ b/arch/um/drivers/hostaudio_kern.c
@@ -8,7 +8,7 @@
 #include "linux/slab.h"
 #include "linux/sound.h"
 #include "linux/soundcard.h"
-#include "linux/smp_lock.h"
+#include "linux/mutex.h"
 #include "asm/uaccess.h"
 #include "init.h"
 #include "os.h"
@@ -67,6 +67,8 @@ MODULE_PARM_DESC(mixer, MIXER_HELP);
 
 #endif
 
+static DEFINE_MUTEX(hostaudio_mutex);
+
 /* /dev/dsp file operations */
 
 static ssize_t hostaudio_read(struct file *file, char __user *buffer,
@@ -202,9 +204,9 @@ static int hostaudio_open(struct inode *inode, struct file *file)
 		w = 1;
 
 	kparam_block_sysfs_write(dsp);
-	lock_kernel();
+	mutex_lock(&hostaudio_mutex);
 	ret = os_open_file(dsp, of_set_rw(OPENFLAGS(), r, w), 0);
-	unlock_kernel();
+	mutex_unlock(&hostaudio_mutex);
 	kparam_unblock_sysfs_write(dsp);
 
 	if (ret < 0) {
@@ -263,9 +265,9 @@ static int hostmixer_open_mixdev(struct inode *inode, struct file *file)
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
index 1bcd208..0c05360 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -33,7 +33,7 @@
 #include "linux/mm.h"
 #include "linux/slab.h"
 #include "linux/vmalloc.h"
-#include "linux/smp_lock.h"
+#include "linux/mutex.h"
 #include "linux/blkpg.h"
 #include "linux/genhd.h"
 #include "linux/spinlock.h"
@@ -100,6 +100,7 @@ static inline void ubd_set_bit(__u64 bit, unsigned char *data)
 #define DRIVER_NAME "uml-blkdev"
 
 static DEFINE_MUTEX(ubd_lock);
+static DEFINE_MUTEX(ubd_mutex); /* replaces BKL, might not be needed */
 
 static int ubd_open(struct block_device *bdev, fmode_t mode);
 static int ubd_release(struct gendisk *disk, fmode_t mode);
@@ -1099,7 +1100,7 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	struct ubd *ubd_dev = disk->private_data;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&ubd_mutex);
 	if(ubd_dev->count == 0){
 		err = ubd_open_dev(ubd_dev);
 		if(err){
@@ -1118,7 +1119,7 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	        err = -EROFS;
 	}*/
 out:
-	unlock_kernel();
+	mutex_unlock(&ubd_mutex);
 	return err;
 }
 
@@ -1126,10 +1127,10 @@ static int ubd_release(struct gendisk *disk, fmode_t mode)
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
