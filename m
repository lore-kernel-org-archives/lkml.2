Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab0INTzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0INTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] fix rawctl compat ioctls breakage on amd64 and itanic
Date: Tue, 14 Sep 2010 21:55:17 +0200
Message-Id: <1284494124-7384-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:oF4ret6gc4Hqlv1Bwx9/Bp5VS5se9DDOo5Dd13wdwnL
 3bZ5x3fMsUHRXf88yOt5EoqEiDVzWRB3ooN2ZoEGzOISyzQbem
 IW4LYBNR3gZnD5s3FQoCnsil03CiZFOv85Srw3ojrXuYJna6JZ
 Bsw4zn0iUffkW6Lgtx8RaBq5gjwjhXds9v7e4B6mtJ1LefdI6G
 3A4rmbPer2nHwSqns9ztg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>

RAW_SETBIND and RAW_GETBIND 32bit versions are fscked in interesting ways.

1) fs/compat_ioctl.c has COMPATIBLE_IOCTL(RAW_SETBIND) followed by
HANDLE_IOCTL(RAW_SETBIND, raw_ioctl).  The latter is ignored.

2) on amd64 (and itanic) the damn thing is broken - we have int + u64 + u64
and layouts on i386 and amd64 are _not_ the same.  raw_ioctl() would
work there, but it's never called due to (1).  As it is, i386 /sbin/raw
definitely doesn't work on amd64 boxen.

3) switching to raw_ioctl() as is would *not* work on e.g. sparc64 and ppc64,
which would be rather sad, seeing that normal userland there is 32bit.
The thing is, slapping __packed on the struct in question does not DTRT -
it eliminates *all* padding.  The real solution is to use compat_u64.

4) of course, all that stuff has no business being outside of raw.c in the
first place - there should be ->compat_ioctl() for /dev/rawctl instead of
messing with compat_ioctl.c.

[akpm@linux-foundation.org: coding-style fixes]
[arnd@arndb.de: port to 2.6.36]
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/raw.c |  243 ++++++++++++++++++++++++++++++----------------------
 fs/compat_ioctl.c  |   70 ---------------
 2 files changed, 140 insertions(+), 173 deletions(-)

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b38942f..24b2b91 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -19,8 +19,8 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/gfp.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 
@@ -55,7 +55,6 @@ static int raw_open(struct inode *inode, struct file *filp)
 		return 0;
 	}
 
-	lock_kernel();
 	mutex_lock(&raw_mutex);
 
 	/*
@@ -82,7 +81,6 @@ static int raw_open(struct inode *inode, struct file *filp)
 			bdev->bd_inode->i_mapping;
 	filp->private_data = bdev;
 	mutex_unlock(&raw_mutex);
-	unlock_kernel();
 	return 0;
 
 out2:
@@ -91,7 +89,6 @@ out1:
 	blkdev_put(bdev, filp->f_mode);
 out:
 	mutex_unlock(&raw_mutex);
-	unlock_kernel();
 	return err;
 }
 
@@ -125,20 +122,84 @@ static long
 raw_ioctl(struct file *filp, unsigned int command, unsigned long arg)
 {
 	struct block_device *bdev = filp->private_data;
-	int ret;
+	return blkdev_ioctl(bdev, 0, command, arg);
+}
+
+static int bind_set(int number, u64 major, u64 minor)
+{
+	dev_t dev = MKDEV(major, minor);
+	struct raw_device_data *rawdev;
+	int err = 0;
 
-	lock_kernel();
-	ret = blkdev_ioctl(bdev, 0, command, arg);
-	unlock_kernel();
+	if (number <= 0 || number >= MAX_RAW_MINORS)
+		return -EINVAL;
 
-	return ret;
+	if (MAJOR(dev) != major || MINOR(dev) != minor)
+		return -EINVAL;
+
+	rawdev = &raw_devices[number];
+
+	/*
+	 * This is like making block devices, so demand the
+	 * same capability
+	 */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/*
+	 * For now, we don't need to check that the underlying
+	 * block device is present or not: we can do that when
+	 * the raw device is opened.  Just check that the
+	 * major/minor numbers make sense.
+	 */
+
+	if (MAJOR(dev) == 0 && dev != 0)
+		return -EINVAL;
+
+	mutex_lock(&raw_mutex);
+	if (rawdev->inuse) {
+		mutex_unlock(&raw_mutex);
+		return -EBUSY;
+	}
+	if (rawdev->binding) {
+		bdput(rawdev->binding);
+		module_put(THIS_MODULE);
+	}
+	if (!dev) {
+		/* unbind */
+		rawdev->binding = NULL;
+		device_destroy(raw_class, MKDEV(RAW_MAJOR, number));
+	} else {
+		rawdev->binding = bdget(dev);
+		if (rawdev->binding == NULL) {
+			err = -ENOMEM;
+		} else {
+			dev_t raw = MKDEV(RAW_MAJOR, number);
+			__module_get(THIS_MODULE);
+			device_destroy(raw_class, raw);
+			device_create(raw_class, NULL, raw, NULL,
+				      "raw%d", number);
+		}
+	}
+	mutex_unlock(&raw_mutex);
+	return err;
 }
 
-static void bind_device(struct raw_config_request *rq)
+static int bind_get(int number, dev_t *dev)
 {
-	device_destroy(raw_class, MKDEV(RAW_MAJOR, rq->raw_minor));
-	device_create(raw_class, NULL, MKDEV(RAW_MAJOR, rq->raw_minor), NULL,
-		      "raw%d", rq->raw_minor);
+	struct raw_device_data *rawdev;
+	struct block_device *bdev;
+
+	if (number <= 0 || number >= MAX_RAW_MINORS)
+		return -EINVAL;
+
+	rawdev = &raw_devices[number];
+
+	mutex_lock(&raw_mutex);
+	bdev = rawdev->binding;
+	*dev = bdev ? bdev->bd_dev : 0;
+	mutex_unlock(&raw_mutex);
+	return 0;
 }
 
 /*
@@ -149,105 +210,78 @@ static long raw_ctl_ioctl(struct file *filp, unsigned int command,
 			  unsigned long arg)
 {
 	struct raw_config_request rq;
-	struct raw_device_data *rawdev;
-	int err = 0;
+	dev_t dev;
+	int err;
 
-	lock_kernel();
 	switch (command) {
 	case RAW_SETBIND:
+		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq)))
+			return -EFAULT;
+
+		return bind_set(rq.raw_minor, rq.block_major, rq.block_minor);
+
 	case RAW_GETBIND:
+		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq)))
+			return -EFAULT;
 
-		/* First, find out which raw minor we want */
+		err = bind_get(rq.raw_minor, &dev);
+		if (err)
+			return err;
 
-		if (copy_from_user(&rq, (void __user *) arg, sizeof(rq))) {
-			err = -EFAULT;
-			goto out;
-		}
+		rq.block_major = MAJOR(dev);
+		rq.block_minor = MINOR(dev);
 
-		if (rq.raw_minor <= 0 || rq.raw_minor >= MAX_RAW_MINORS) {
-			err = -EINVAL;
-			goto out;
-		}
-		rawdev = &raw_devices[rq.raw_minor];
-
-		if (command == RAW_SETBIND) {
-			dev_t dev;
-
-			/*
-			 * This is like making block devices, so demand the
-			 * same capability
-			 */
-			if (!capable(CAP_SYS_ADMIN)) {
-				err = -EPERM;
-				goto out;
-			}
-
-			/*
-			 * For now, we don't need to check that the underlying
-			 * block device is present or not: we can do that when
-			 * the raw device is opened.  Just check that the
-			 * major/minor numbers make sense.
-			 */
-
-			dev = MKDEV(rq.block_major, rq.block_minor);
-			if ((rq.block_major == 0 && rq.block_minor != 0) ||
-					MAJOR(dev) != rq.block_major ||
-					MINOR(dev) != rq.block_minor) {
-				err = -EINVAL;
-				goto out;
-			}
-
-			mutex_lock(&raw_mutex);
-			if (rawdev->inuse) {
-				mutex_unlock(&raw_mutex);
-				err = -EBUSY;
-				goto out;
-			}
-			if (rawdev->binding) {
-				bdput(rawdev->binding);
-				module_put(THIS_MODULE);
-			}
-			if (rq.block_major == 0 && rq.block_minor == 0) {
-				/* unbind */
-				rawdev->binding = NULL;
-				device_destroy(raw_class,
-						MKDEV(RAW_MAJOR, rq.raw_minor));
-			} else {
-				rawdev->binding = bdget(dev);
-				if (rawdev->binding == NULL)
-					err = -ENOMEM;
-				else {
-					__module_get(THIS_MODULE);
-					bind_device(&rq);
-				}
-			}
-			mutex_unlock(&raw_mutex);
-		} else {
-			struct block_device *bdev;
-
-			mutex_lock(&raw_mutex);
-			bdev = rawdev->binding;
-			if (bdev) {
-				rq.block_major = MAJOR(bdev->bd_dev);
-				rq.block_minor = MINOR(bdev->bd_dev);
-			} else {
-				rq.block_major = rq.block_minor = 0;
-			}
-			mutex_unlock(&raw_mutex);
-			if (copy_to_user((void __user *)arg, &rq, sizeof(rq))) {
-				err = -EFAULT;
-				goto out;
-			}
-		}
-		break;
-	default:
-		err = -EINVAL;
-		break;
+		if (copy_to_user((void __user *)arg, &rq, sizeof(rq)))
+			return -EFAULT;
+
+		return 0;
 	}
-out:
-	unlock_kernel();
-	return err;
+
+	return -EINVAL;
+}
+
+#ifdef CONFIG_COMPAT
+struct raw32_config_request {
+	compat_int_t	raw_minor;
+	compat_u64	block_major;
+	compat_u64	block_minor;
+};
+
+static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
+				unsigned long arg)
+{
+	struct raw32_config_request __user *user_req = compat_ptr(arg);
+	struct raw32_config_request rq;
+	dev_t dev;
+	int err = 0;
+
+	switch (cmd) {
+	case RAW_SETBIND:
+		if (copy_from_user(&rq, user_req, sizeof(rq)))
+			return -EFAULT;
+
+		return bind_set(rq.raw_minor, rq.block_major, rq.block_minor);
+
+	case RAW_GETBIND:
+		if (copy_from_user(&rq, user_req, sizeof(rq)))
+			return -EFAULT;
+
+		err = bind_get(rq.raw_minor, &dev);
+		if (err)
+			return err;
+
+		rq.block_major = MAJOR(dev);
+		rq.block_minor = MINOR(dev);
+
+		if (copy_to_user(user_req, &rq, sizeof(rq)))
+			return -EFAULT;
+
+		return 0;
+	}
+
+	return -EINVAL;
 }
+#endif
 
 static const struct file_operations raw_fops = {
 	.read		= do_sync_read,
@@ -263,6 +297,9 @@ static const struct file_operations raw_fops = {
 
 static const struct file_operations raw_ctl_fops = {
 	.unlocked_ioctl = raw_ctl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= raw_ctl_compat_ioctl,
+#endif
 	.open		= raw_open,
 	.owner		= THIS_MODULE,
 };
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 03e59aa..d0ad09d 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -599,69 +599,6 @@ static int do_smb_getmountuid(unsigned int fd, unsigned int cmd,
 #define HIDPGETCONNLIST	_IOR('H', 210, int)
 #define HIDPGETCONNINFO	_IOR('H', 211, int)
 
-#ifdef CONFIG_BLOCK
-struct raw32_config_request
-{
-        compat_int_t    raw_minor;
-        __u64   block_major;
-        __u64   block_minor;
-} __attribute__((packed));
-
-static int get_raw32_request(struct raw_config_request *req, struct raw32_config_request __user *user_req)
-{
-        int ret;
-
-        if (!access_ok(VERIFY_READ, user_req, sizeof(struct raw32_config_request)))
-                return -EFAULT;
-
-        ret = __get_user(req->raw_minor, &user_req->raw_minor);
-        ret |= __get_user(req->block_major, &user_req->block_major);
-        ret |= __get_user(req->block_minor, &user_req->block_minor);
-
-        return ret ? -EFAULT : 0;
-}
-
-static int set_raw32_request(struct raw_config_request *req, struct raw32_config_request __user *user_req)
-{
-	int ret;
-
-        if (!access_ok(VERIFY_WRITE, user_req, sizeof(struct raw32_config_request)))
-                return -EFAULT;
-
-        ret = __put_user(req->raw_minor, &user_req->raw_minor);
-        ret |= __put_user(req->block_major, &user_req->block_major);
-        ret |= __put_user(req->block_minor, &user_req->block_minor);
-
-        return ret ? -EFAULT : 0;
-}
-
-static int raw_ioctl(unsigned fd, unsigned cmd,
-		struct raw32_config_request __user *user_req)
-{
-        int ret;
-
-        switch (cmd) {
-        case RAW_SETBIND:
-	default: {	/* RAW_GETBIND */
-                struct raw_config_request req;
-                mm_segment_t oldfs = get_fs();
-
-                if ((ret = get_raw32_request(&req, user_req)))
-                        return ret;
-
-                set_fs(KERNEL_DS);
-                ret = sys_ioctl(fd,cmd,(unsigned long)&req);
-                set_fs(oldfs);
-
-                if ((!ret) && (cmd == RAW_GETBIND)) {
-                        ret = set_raw32_request(&req, user_req);
-                }
-                break;
-        }
-        }
-        return ret;
-}
-#endif /* CONFIG_BLOCK */
 
 struct serial_struct32 {
         compat_int_t    type;
@@ -1262,9 +1199,6 @@ COMPATIBLE_IOCTL(SOUND_MIXER_PRIVATE5)
 COMPATIBLE_IOCTL(SOUND_MIXER_GETLEVELS)
 COMPATIBLE_IOCTL(SOUND_MIXER_SETLEVELS)
 COMPATIBLE_IOCTL(OSS_GETVERSION)
-/* Raw devices */
-COMPATIBLE_IOCTL(RAW_SETBIND)
-COMPATIBLE_IOCTL(RAW_GETBIND)
 /* SMB ioctls which do not need any translations */
 COMPATIBLE_IOCTL(SMB_IOC_NEWCONN)
 /* Watchdog */
@@ -1523,10 +1457,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case MTIOCGET32:
 	case MTIOCPOS32:
 		return mt_ioctl_trans(fd, cmd, argp);
-	/* Raw devices */
-	case RAW_SETBIND:
-	case RAW_GETBIND:
-		return raw_ioctl(fd, cmd, argp);
 #endif
 	/* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
-- 
1.7.1

