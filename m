Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1G3TNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:13:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38652 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab1G3TN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:13:29 -0400
Subject: [PATCH 2/3] loop: add management interface for on-demand device
 allocation
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Karel Zak <kzak@redhat.com>
Date: Sat, 30 Jul 2011 21:13:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312053208.1187.12.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: loop: add management interface for on-demand device allocation

Loop devices today have a fixed pre-allocated number of usually 8.
The number can only be changed at module init time. To find a free
device to use, /dev/loop%i needs to be scanned, and all devices need
to be opened until a free one is possibly found.

This adds a new /dev/loop-control device node, that allows to
dynamically find or allocate a free device, and to add and remove loop
devices from the running system:
 LOOP_CTL_ADD adds a specific device. Arg is the number
 of the device. It returns the device i or a negative
 error code.

 LOOP_CTL_REMOVE removes a specific device, Arg is the
 number the device. It returns the device i or a negative
 error code.

 LOOP_CTL_GET_FREE finds the next unbound device or allocates
 a new one. No arg is given. It returns the device i or a
 negative error code.

The loop kernel module gets automatically loaded when
/dev/loop-control is accessed the first time. The alias
specified in the module, instructs udev to create this
'dead' device node, even when the module is not loaded.

Example:
 cfd = open("/dev/loop-control", O_RDWR);

 # add a new specific loop device
 err = ioctl(cfd, LOOP_CTL_ADD, devnr);

 # remove a specific loop device
 err = ioctl(cfd, LOOP_CTL_REMOVE, devnr);

 # find or allocate a free loop device to use
 devnr = ioctl(cfd, LOOP_CTL_GET_FREE);

 sprintf(loopname, "/dev/loop%i", devnr);
 ffd = open("backing-file", O_RDWR);
 lfd = open(loopname, O_RDWR);
 err = ioctl(lfd, LOOP_SET_FD, ffd);

Cc: Tejun Heo <tj@kernel.org>
Cc: Karel Zak  <kzak@redhat.com>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/loop.c       |  120 +++++++++++++++++++++++++++++++++++++++++++--
 include/linux/loop.h       |    4 +
 include/linux/miscdevice.h |    1 
 3 files changed, 121 insertions(+), 4 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,7 +75,7 @@
 #include <linux/kthread.h>
 #include <linux/splice.h>
 #include <linux/sysfs.h>
-
+#include <linux/miscdevice.h>
 #include <asm/uaccess.h>
 
 static DEFINE_IDR(loop_index_idr);
@@ -1478,13 +1478,22 @@ static int lo_compat_ioctl(struct block_
 
 static int lo_open(struct block_device *bdev, fmode_t mode)
 {
-	struct loop_device *lo = bdev->bd_disk->private_data;
+	struct loop_device *lo;
+	int err = 0;
+
+	mutex_lock(&loop_index_mutex);
+	lo = bdev->bd_disk->private_data;
+	if (!lo) {
+		err = -ENXIO;
+		goto out;
+	}
 
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
-
-	return 0;
+out:
+	mutex_unlock(&loop_index_mutex);
+	return err;
 }
 
 static int lo_release(struct gendisk *disk, fmode_t mode)
@@ -1603,6 +1612,13 @@ static int loop_add(struct loop_device *
 			idr_remove(&loop_index_idr, m);
 			err = -EEXIST;
 		}
+	} else if (i == -1) {
+		int m;
+
+		/* get next free nr */
+		err = idr_get_new(&loop_index_idr, lo, &m);
+		if (err >= 0)
+			i = m;
 	} else {
 		err = -EINVAL;
 	}
@@ -1648,16 +1664,41 @@ static void loop_remove(struct loop_devi
 	kfree(lo);
 }
 
+static int find_free_cb(int id, void *ptr, void *data)
+{
+	struct loop_device *lo = ptr;
+	struct loop_device **l = data;
+
+	if (lo->lo_state == Lo_unbound) {
+		*l = lo;
+		return 1;
+	}
+	return 0;
+}
+
 static int loop_lookup(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
 	int ret = -ENODEV;
 
+	if (i < 0) {
+		int err;
+
+		err = idr_for_each(&loop_index_idr, &find_free_cb, &lo);
+		if (err == 1) {
+			*l = lo;
+			ret = lo->lo_number;
+		}
+		goto out;
+	}
+
+	/* lookup and return a specific i */
 	lo = idr_find(&loop_index_idr, i);
 	if (lo) {
 		*l = lo;
 		ret = lo->lo_number;
 	}
+out:
 	return ret;
 }
 
@@ -1681,11 +1722,76 @@ static struct kobject *loop_probe(dev_t
 	return kobj;
 }
 
+static long loop_control_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long parm)
+{
+	struct loop_device *lo;
+	int ret = -ENOSYS;
+
+	mutex_lock(&loop_index_mutex);
+	switch (cmd) {
+	case LOOP_CTL_ADD:
+		ret = loop_lookup(&lo, parm);
+		if (ret >= 0) {
+			ret = -EEXIST;
+			break;
+		}
+		ret = loop_add(&lo, parm);
+		break;
+	case LOOP_CTL_REMOVE:
+		ret = loop_lookup(&lo, parm);
+		if (ret < 0)
+			break;
+		mutex_lock(&lo->lo_ctl_mutex);
+		if (lo->lo_state != Lo_unbound) {
+			ret = -EBUSY;
+			mutex_unlock(&lo->lo_ctl_mutex);
+			break;
+		}
+		if (lo->lo_refcnt > 0) {
+			ret = -EBUSY;
+			mutex_unlock(&lo->lo_ctl_mutex);
+			break;
+		}
+		lo->lo_disk->private_data = NULL;
+		mutex_unlock(&lo->lo_ctl_mutex);
+		idr_remove(&loop_index_idr, lo->lo_number);
+		loop_remove(lo);
+		break;
+	case LOOP_CTL_GET_FREE:
+		ret = loop_lookup(&lo, -1);
+		if (ret >= 0)
+			break;
+		ret = loop_add(&lo, -1);
+	}
+	mutex_unlock(&loop_index_mutex);
+
+	return ret;
+}
+
+static const struct file_operations loop_ctl_fops = {
+	.open		= nonseekable_open,
+	.unlocked_ioctl	= loop_control_ioctl,
+	.compat_ioctl	= loop_control_ioctl,
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+};
+
+static struct miscdevice loop_misc = {
+	.minor		= LOOP_CTRL_MINOR,
+	.name		= "loop-control",
+	.fops		= &loop_ctl_fops,
+};
+
+MODULE_ALIAS_MISCDEV(LOOP_CTRL_MINOR);
+MODULE_ALIAS("devname:loop-control");
+
 static int __init loop_init(void)
 {
 	int i, nr;
 	unsigned long range;
 	struct loop_device *lo;
+	int err;
 
 	/*
 	 * loop module now has a feature to instantiate underlying device
@@ -1702,6 +1808,10 @@ static int __init loop_init(void)
 	 *     device on-demand.
 	 */
 
+	err = misc_register(&loop_misc);
+	if (err < 0)
+		return err;
+
 	part_shift = 0;
 	if (max_part > 0) {
 		part_shift = fls(max_part);
@@ -1767,6 +1877,8 @@ static void __exit loop_exit(void)
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	unregister_blkdev(LOOP_MAJOR, "loop");
+
+	misc_deregister(&loop_misc);
 }
 
 module_init(loop_init);
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -160,4 +160,8 @@ int loop_unregister_transfer(int number)
 #define LOOP_CHANGE_FD		0x4C06
 #define LOOP_SET_CAPACITY	0x4C07
 
+/* /dev/loop-control interface */
+#define LOOP_CTL_ADD		0x4C80
+#define LOOP_CTL_REMOVE		0x4C81
+#define LOOP_CTL_GET_FREE	0x4C82
 #endif
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -40,6 +40,7 @@
 #define BTRFS_MINOR		234
 #define AUTOFS_MINOR		235
 #define MAPPER_CTRL_MINOR	236
+#define LOOP_CTRL_MINOR		237
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;


