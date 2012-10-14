Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab2JNCxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 22:53:44 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:49583 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2JNCxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 22:53:43 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2012 22:53:43 EDT
Date: Sun, 14 Oct 2012 04:48:36 +0200
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC] brd: Add miscdevice to control creation and deletion of ramdisks
Message-ID: <20121014024836.GB27966@order.stressinduktion.org>
Mail-Followup-To: npiggin@kernel.dk, linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While toying around with a library which needs small block devices for
quorum management, I came up with this small patch to dynamically create
and destroy ram disks (I wanted to have non-swappable backed devices).

I am not really comfortable with the the double-use of the ioctl parameter
of BRD_CTL_ADD passing the size and returning the minor id. But it seemed
the easiest way to go.  I even don't know if going the ioctl-route is
the right way.

Currently new minor ids are allocated strictly sequential. Deleted ones
won't get reused. If the ioctl way is the way to go, I may change the
bookkeeping to idrs. Feedback appreciated!

This patch is against 3.6.

This patch adds the miscdevice /dev/brd-control with two ioctls:

  1) BRD_CTL_ADD: Instantiates a new ram disk with a given size as
     parameter. This parameter is filled in with the new minor id
     on return.

  2) BRD_CTL_DEL: Deletes a ram disk. Takes the minor id as parameter.

Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 Documentation/ioctl/ioctl-number.txt |   1 +
 drivers/block/brd.c                  | 115 ++++++++++++++++++++++++++++++++---
 include/linux/Kbuild                 |   1 +
 include/linux/brd.h                  |  11 ++++
 include/linux/miscdevice.h           |   1 +
 5 files changed, 122 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/brd.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 849b771..b8827eb 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -326,4 +326,5 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:raph@8d.com>
 0xF6	all	LTTng			Linux Trace Toolkit Next Generation
 					<mailto:mathieu.desnoyers@efficios.com>
+0xF7	00-01	drivers/block/brd.c	block ram device control driver
 0xFD	all	linux/dm-ioctl.h
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 531ceb3..7401de7 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -19,6 +19,9 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/brd.h>
 
 #include <asm/uaccess.h>
 
@@ -460,7 +463,7 @@ __setup("ramdisk_size=", ramdisk_size);
 static LIST_HEAD(brd_devices);
 static DEFINE_MUTEX(brd_devices_mutex);
 
-static struct brd_device *brd_alloc(int i)
+static struct brd_device *brd_alloc(int i, int size_kb)
 {
 	struct brd_device *brd;
 	struct gendisk *disk;
@@ -494,7 +497,7 @@ static struct brd_device *brd_alloc(int i)
 	disk->queue		= brd->brd_queue;
 	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
-	set_capacity(disk, rd_size * 2);
+	set_capacity(disk, size_kb * 2);
 
 	return brd;
 
@@ -523,7 +526,7 @@ static struct brd_device *brd_init_one(int i)
 			goto out;
 	}
 
-	brd = brd_alloc(i);
+	brd = brd_alloc(i, rd_size);
 	if (brd) {
 		add_disk(brd->brd_disk);
 		list_add_tail(&brd->brd_list, &brd_devices);
@@ -553,9 +556,97 @@ static struct kobject *brd_probe(dev_t dev, int *part, void *data)
 	return kobj;
 }
 
+static long brd_control_ioctl(struct file *file, unsigned int cmd,
+			unsigned long param)
+{
+	int error = -ENOSYS;
+	int size_kb, val;
+	struct brd_device *brd, *brd2;
+
+	if (rd_nr)
+		return -EINVAL;
+
+	mutex_lock(&brd_devices_mutex);
+	switch (cmd) {
+	case BRD_CTL_ADD:
+		error = get_user(size_kb, (int __user *)param);
+		if (error < 0)
+			break;
+		if (size_kb < 0) {
+			error = -EINVAL;
+			break;
+		}
+		val = 0;
+		list_for_each_entry(brd, &brd_devices, brd_list) {
+			val = max(val, 1 + brd->brd_number);
+		}
+		if (val >= (MINORMASK >> part_shift)) {
+			error = -EINVAL;
+			break;
+		}
+		brd = brd_alloc(val, size_kb);
+		if (brd == NULL) {
+			error = -ENOMEM;
+			break;
+		}
+		list_add_tail(&brd->brd_list, &brd_devices);
+		add_disk(brd->brd_disk);
+		val <<= part_shift;
+		error = put_user(val, (int __user *)param);
+		if (error < 0)
+			break;
+		error = 0;
+		break;
+	case BRD_CTL_DEL:
+		error = get_user(val, (int __user *)param);
+		if (error < 0)
+			break;
+		if ((val & max_part) != 0) {
+			error = -EINVAL;
+			break;
+		}
+		val >>= part_shift;
+		brd2 = NULL;
+		list_for_each_entry(brd, &brd_devices, brd_list) {
+			if (brd->brd_number == val) {
+				brd2 = brd;
+				break;
+			}
+		}
+		if (brd2 == NULL) {
+			error = -ENODEV;
+			break;
+		}
+		brd_del_one(brd2);
+		break;
+	}
+	mutex_unlock(&brd_devices_mutex);
+	return error;
+}
+
+static const struct file_operations brd_ctl_fops = {
+	.open		= nonseekable_open,
+	.unlocked_ioctl	= brd_control_ioctl,
+	.owner		= THIS_MODULE,
+	.llseek		= noop_llseek,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= brd_control_ioctl,
+#endif
+};
+
+static struct miscdevice brd_misc = {
+	.minor	= BRD_CTRL_MINOR,
+	.name	= "brd-control",
+	.fops	= &brd_ctl_fops,
+};
+
+MODULE_ALIAS_MISCDEV(BRD_CTRL_MINOR);
+MODULE_ALIAS("devname:brd-control");
+
 static int __init brd_init(void)
 {
 	int i, nr;
+	int err = -ENOMEM;
 	unsigned long range;
 	struct brd_device *brd, *next;
 
@@ -603,11 +694,18 @@ static int __init brd_init(void)
 		range = 1UL << MINORBITS;
 	}
 
-	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
-		return -EIO;
+	err = misc_register(&brd_misc);
+	if (err < 0)
+		return err;
+
+	err = register_blkdev(RAMDISK_MAJOR, "ramdisk");
+	if (err < 0) {
+		err = -EIO;
+		goto out;
+	}
 
 	for (i = 0; i < nr; i++) {
-		brd = brd_alloc(i);
+		brd = brd_alloc(i, rd_size);
 		if (!brd)
 			goto out_free;
 		list_add_tail(&brd->brd_list, &brd_devices);
@@ -630,8 +728,10 @@ out_free:
 		brd_free(brd);
 	}
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
+out:
+	misc_deregister(&brd_misc);
 
-	return -ENOMEM;
+	return err;
 }
 
 static void __exit brd_exit(void)
@@ -646,6 +746,7 @@ static void __exit brd_exit(void)
 
 	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), range);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
+	misc_deregister(&brd_misc);
 }
 
 module_init(brd_init);
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index fa21760..05b0d3f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -78,6 +78,7 @@ header-y += blk_types.h
 header-y += blkpg.h
 header-y += blktrace_api.h
 header-y += bpqether.h
+header-y += brd.h
 header-y += bsg.h
 header-y += can.h
 header-y += capability.h
diff --git a/include/linux/brd.h b/include/linux/brd.h
new file mode 100644
index 0000000..1774b2e
--- /dev/null
+++ b/include/linux/brd.h
@@ -0,0 +1,11 @@
+#ifndef _LINUX_BRD_H__
+#define _LINUX_BRD_H__
+
+#include <linux/ioctl.h>
+
+#define BRD_CTL_MAGIC 0xF7
+
+/* /dev/brd-control ioctl commands */
+#define BRD_CTL_ADD _IOWR(BRD_CTL_MAGIC, 0, int)
+#define BRD_CTL_DEL _IOR(BRD_CTL_MAGIC, 1, int)
+#endif /* __LINUX_BRD_H__ */
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index e0deeb2..45df076 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -44,6 +44,7 @@
 #define MAPPER_CTRL_MINOR	236
 #define LOOP_CTRL_MINOR		237
 #define VHOST_NET_MINOR		238
+#define BRD_CTRL_MINOR		239
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
