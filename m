Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2JTScb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:32:31 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:60885 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2JTSc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:32:28 -0400
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: linux-kernel@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Nick Piggin <npiggin@kernel.dk>
Subject: [PATCH 4/4] brd: add miscdevice to control creation and deletion of ram disks
Date: Sat, 20 Oct 2012 20:32:23 +0200
Message-Id: <1350757943-24981-5-git-send-email-hannes@stressinduktion.org>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
References: <1350757943-24981-1-git-send-email-hannes@stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the miscdevice /dev/brd-control with two ioctls:

  1) BRD_CTL_ADD: Instantiates a new ram disk with a given size as
     parameter. This parameter is filled in with the new minor id
     on return.

  2) BRD_CTL_DEL: Deletes a ram disk. Takes the minor id as parameter.

Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
---
 Documentation/ioctl/ioctl-number.txt |   1 +
 drivers/block/brd.c                  | 170 ++++++++++++++++++++++++++++++++---
 include/linux/Kbuild                 |   1 +
 include/linux/brd.h                  |  12 +++
 include/linux/miscdevice.h           |   1 +
 5 files changed, 173 insertions(+), 12 deletions(-)
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
index 1d0016b..5ad25af 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -20,6 +20,9 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/brd.h>
 
 #include <asm/uaccess.h>
 
@@ -478,7 +481,7 @@ __setup("ramdisk_size=", ramdisk_size);
  */
 static DEFINE_MUTEX(brd_devices_mutex);
 
-static struct brd_device *brd_alloc(int i)
+static struct brd_device *brd_alloc(int i, unsigned int size_kb)
 {
 	struct brd_device *brd;
 	struct gendisk *disk;
@@ -511,7 +514,7 @@ static struct brd_device *brd_alloc(int i)
 	disk->queue		= brd->brd_queue;
 	disk->flags |= GENHD_FL_SUPPRESS_PARTITION_INFO;
 	sprintf(disk->disk_name, "ram%d", i);
-	set_capacity(disk, rd_size * 2);
+	set_capacity(disk, size_kb * 2);
 
 	return brd;
 
@@ -584,7 +587,7 @@ static struct brd_device *brd_new(int id)
 	err = brd_new_specific_id(id);
 	if (err < 0)
 		return ERR_PTR(err);
-	brd = brd_alloc(id);
+	brd = brd_alloc(id, rd_size);
 	if (!brd) {
 		p = ERR_PTR(-ENOMEM);
 		goto out;
@@ -605,6 +608,139 @@ out:
 	return p;
 }
 
+static int brd_control_add(unsigned int size_kb)
+{
+	int val, err;
+	struct brd_device *brd, *p;
+
+	lockdep_assert_held(&brd_devices_mutex);
+
+	val = brd_new_id(0);
+	if (val < 0)
+		return val;
+	if (val >= (MINORMASK >> part_shift)) {
+		err = -EINVAL;
+		goto out;
+	}
+	brd = brd_alloc(val, size_kb);
+	if (!brd) {
+		err = -ENOMEM;
+		goto out;
+	}
+	p = idr_replace(&brd_idr, brd, val);
+	if (IS_ERR(p)) {
+		err = PTR_ERR(p);
+		goto out2;
+	}
+	if (p != DUMMY) {
+		WARN_ON(1);
+		err = -EBUSY;
+		goto out2;
+	}
+	add_disk(brd->brd_disk);
+	return val;
+out2:
+	brd_free(brd);
+out:
+	idr_remove(&brd_idr, val);
+	return err;
+}
+
+static int brd_control_del(unsigned int val)
+{
+	int err = 0;
+	struct brd_device *brd;
+	struct block_device *bdev;
+
+	lockdep_assert_held(&brd_devices_mutex);
+
+	brd = idr_find(&brd_idr, val);
+	if (!brd)
+		return -ENODEV;
+
+	mutex_lock(&brd_mutex);
+	bdev = bdget_disk(brd->brd_disk, 0);
+	if (!bdev) {
+		err = -ENODEV;
+		goto out;
+	}
+	mutex_lock(&bdev->bd_mutex);
+	err = brd_blkdev_in_use(bdev);
+	if (err) {
+		err = -EBUSY;
+	} else {
+		idr_remove(&brd_idr, val);
+		brd_del_one(brd);
+		err = 0;
+	}
+	mutex_unlock(&bdev->bd_mutex);
+out:
+	mutex_unlock(&brd_mutex);
+	return err;
+}
+
+static long brd_control_ioctl(struct file *file, unsigned int cmd,
+			unsigned long param)
+{
+	int err = -ENOSYS;
+	int val;
+	unsigned int size_kb;
+
+	if (rd_nr)
+		return -EINVAL;
+
+	mutex_lock(&brd_devices_mutex);
+	switch (cmd) {
+	case BRD_CTL_ADD:
+		err = get_user(size_kb, (unsigned int __user *)param);
+		if (err < 0)
+			break;
+		val = brd_control_add(size_kb);
+		if (val < 0) {
+			err = val;
+			break;
+		}
+		err = put_user(val << part_shift, (unsigned int __user *)param);
+		if (err < 0) {
+			brd_control_del(val);
+			break;
+		}
+		err = 0;
+		break;
+	case BRD_CTL_DEL:
+		err = get_user(val, (unsigned int __user *)param);
+		if (err < 0)
+			break;
+		if ((val & max_part) != 0) {
+			err = -EINVAL;
+			break;
+		}
+		val >>= part_shift;
+		err = brd_control_del(val);
+		break;
+	}
+	mutex_unlock(&brd_devices_mutex);
+	return err;
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
+MODULE_ALIAS_MISCDEV(BRD_CTRL_MINOR);
+MODULE_ALIAS("devname:brd-control");
+
 static int brd_add_disk_idr(int id, void *p, void *data)
 {
 	struct brd_device *brd = (struct brd_device *)p;
@@ -691,14 +827,21 @@ static int __init brd_init(void)
 		range = 1UL << MINORBITS;
 	}
 
-	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
-		return -EIO;
+	err = misc_register(&brd_misc);
+	if (err)
+		return err;
+
+	err = register_blkdev(RAMDISK_MAJOR, "ramdisk");
+	if (err) {
+		err = -EIO;
+		goto out;
+	}
 
 	for (i = 0; i < nr; i++) {
 		brd = brd_new(i);
 		if (IS_ERR(brd)) {
 			err = PTR_RET(brd);
-			goto out_free;
+			goto out2;
 		}
 	}
 
@@ -712,13 +855,15 @@ static int __init brd_init(void)
 	printk(KERN_INFO "brd: module loaded\n");
 	return 0;
 
-out_free:
+out2:
+	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
+out:
+	misc_deregister(&brd_misc);
+
 	idr_for_each(&brd_idr, brd_free_idr, NULL);
 	idr_remove_all(&brd_idr);
 	idr_destroy(&brd_idr);
 
-	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
-
 	return err;
 }
 
@@ -728,12 +873,13 @@ static void __exit brd_exit(void)
 
 	range = rd_nr ? rd_nr << part_shift : 1UL << MINORBITS;
 
+	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), range);
+	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
+	misc_deregister(&brd_misc);
+
 	idr_for_each(&brd_idr, brd_del_one_idr, NULL);
 	idr_remove_all(&brd_idr);
 	idr_destroy(&brd_idr);
-
-	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), range);
-	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
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
index 0000000..8a789136
--- /dev/null
+++ b/include/linux/brd.h
@@ -0,0 +1,12 @@
+#ifndef __LINUX_BRD_H__
+#define __LINUX_BRD_H__
+
+#include <linux/ioctl.h>
+
+#define BRD_CTL_IOCTL_MAGIC 0xF7
+
+/* /dev/brd-control ioctl commands */
+#define BRD_CTL_ADD _IOWR(BRD_CTL_IOCTL_MAGIC, 0, unsigned int)
+#define BRD_CTL_DEL _IOR(BRD_CTL_IOCTL_MAGIC, 1, unsigned int)
+
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
-- 
1.7.12.4

