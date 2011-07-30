Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1G3TNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:13:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38652 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1G3TNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:13:20 -0400
Subject: [PATCH 1/3] loop: replace linked list of allocated devices with an
 idr index
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Date: Sat, 30 Jul 2011 21:13:16 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.4 (3.1.4-1.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312053197.1187.11.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: loop: replace linked list of allocated devices with an idr index

Replace the linked list, that keeps track of allocated devices, with an
idr index to allow a more efficient lookup of devices.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/block/loop.c |  152 ++++++++++++++++++++++++++-------------------------
 include/linux/loop.h |    1 
 2 files changed, 80 insertions(+), 73 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -78,8 +78,8 @@
 
 #include <asm/uaccess.h>
 
-static LIST_HEAD(loop_devices);
-static DEFINE_MUTEX(loop_devices_mutex);
+static DEFINE_IDR(loop_index_idr);
+static DEFINE_MUTEX(loop_index_mutex);
 
 static int max_part;
 static int part_shift;
@@ -722,17 +722,10 @@ static inline int is_loop_device(struct
 static ssize_t loop_attr_show(struct device *dev, char *page,
 			      ssize_t (*callback)(struct loop_device *, char *))
 {
-	struct loop_device *l, *lo = NULL;
-
-	mutex_lock(&loop_devices_mutex);
-	list_for_each_entry(l, &loop_devices, lo_list)
-		if (disk_to_dev(l->lo_disk) == dev) {
-			lo = l;
-			break;
-		}
-	mutex_unlock(&loop_devices_mutex);
+	struct gendisk *disk = dev_to_disk(dev);
+	struct loop_device *lo = disk->private_data;
 
-	return lo ? callback(lo, page) : -EIO;
+	return callback(lo, page);
 }
 
 #define LOOP_ATTR_RO(_name)						\
@@ -1557,40 +1550,64 @@ int loop_register_transfer(struct loop_f
 	return 0;
 }
 
+static int unregister_transfer_cb(int id, void *ptr, void *data)
+{
+	struct loop_device *lo = ptr;
+	struct loop_func_table *xfer = data;
+
+	mutex_lock(&lo->lo_ctl_mutex);
+	if (lo->lo_encryption == xfer)
+		loop_release_xfer(lo);
+	mutex_unlock(&lo->lo_ctl_mutex);
+	return 0;
+}
+
 int loop_unregister_transfer(int number)
 {
 	unsigned int n = number;
-	struct loop_device *lo;
 	struct loop_func_table *xfer;
 
 	if (n == 0 || n >= MAX_LO_CRYPT || (xfer = xfer_funcs[n]) == NULL)
 		return -EINVAL;
 
 	xfer_funcs[n] = NULL;
-
-	list_for_each_entry(lo, &loop_devices, lo_list) {
-		mutex_lock(&lo->lo_ctl_mutex);
-
-		if (lo->lo_encryption == xfer)
-			loop_release_xfer(lo);
-
-		mutex_unlock(&lo->lo_ctl_mutex);
-	}
-
+	idr_for_each(&loop_index_idr, &unregister_transfer_cb, xfer);
 	return 0;
 }
 
 EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
-static struct loop_device *loop_alloc(int i)
+static int loop_add(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
 	struct gendisk *disk;
+	int err;
 
 	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
-	if (!lo)
+	if (!lo) {
+		err = -ENOMEM;
 		goto out;
+	}
+
+	err = idr_pre_get(&loop_index_idr, GFP_KERNEL);
+	if (err < 0)
+		goto out_free_dev;
+
+	if (i >= 0) {
+		int m;
+
+		/* create specific i in the index */
+		err = idr_get_new_above(&loop_index_idr, lo, i, &m);
+		if (err >= 0 && i != m) {
+			idr_remove(&loop_index_idr, m);
+			err = -EEXIST;
+		}
+	} else {
+		err = -EINVAL;
+	}
+	if (err < 0)
+		goto out_free_dev;
 
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!lo->lo_queue)
@@ -1611,56 +1628,54 @@ static struct loop_device *loop_alloc(in
 	disk->private_data	= lo;
 	disk->queue		= lo->lo_queue;
 	sprintf(disk->disk_name, "loop%d", i);
-	return lo;
+	add_disk(disk);
+	*l = lo;
+	return lo->lo_number;
 
 out_free_queue:
 	blk_cleanup_queue(lo->lo_queue);
 out_free_dev:
 	kfree(lo);
 out:
-	return NULL;
+	return err;
 }
 
-static void loop_free(struct loop_device *lo)
+static void loop_remove(struct loop_device *lo)
 {
+	del_gendisk(lo->lo_disk);
 	blk_cleanup_queue(lo->lo_queue);
 	put_disk(lo->lo_disk);
-	list_del(&lo->lo_list);
 	kfree(lo);
 }
 
-static struct loop_device *loop_init_one(int i)
+static int loop_lookup(struct loop_device **l, int i)
 {
 	struct loop_device *lo;
+	int ret = -ENODEV;
 
-	list_for_each_entry(lo, &loop_devices, lo_list) {
-		if (lo->lo_number == i)
-			return lo;
-	}
-
-	lo = loop_alloc(i);
+	lo = idr_find(&loop_index_idr, i);
 	if (lo) {
-		add_disk(lo->lo_disk);
-		list_add_tail(&lo->lo_list, &loop_devices);
+		*l = lo;
+		ret = lo->lo_number;
 	}
-	return lo;
-}
-
-static void loop_del_one(struct loop_device *lo)
-{
-	del_gendisk(lo->lo_disk);
-	loop_free(lo);
+	return ret;
 }
 
 static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 {
 	struct loop_device *lo;
 	struct kobject *kobj;
+	int err;
 
-	mutex_lock(&loop_devices_mutex);
-	lo = loop_init_one(MINOR(dev) >> part_shift);
-	kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
-	mutex_unlock(&loop_devices_mutex);
+	mutex_lock(&loop_index_mutex);
+	err = loop_lookup(&lo, MINOR(dev) >> part_shift);
+	if (err < 0)
+		err = loop_add(&lo, MINOR(dev) >> part_shift);
+	if (err < 0)
+		kobj = ERR_PTR(err);
+	else
+		kobj = get_disk(lo->lo_disk);
+	mutex_unlock(&loop_index_mutex);
 
 	*part = 0;
 	return kobj;
@@ -1670,7 +1685,7 @@ static int __init loop_init(void)
 {
 	int i, nr;
 	unsigned long range;
-	struct loop_device *lo, *next;
+	struct loop_device *lo;
 
 	/*
 	 * loop module now has a feature to instantiate underlying device
@@ -1719,43 +1734,36 @@ static int __init loop_init(void)
 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
 
-	for (i = 0; i < nr; i++) {
-		lo = loop_alloc(i);
-		if (!lo)
-			goto Enomem;
-		list_add_tail(&lo->lo_list, &loop_devices);
-	}
-
-	/* point of no return */
-
-	list_for_each_entry(lo, &loop_devices, lo_list)
-		add_disk(lo->lo_disk);
-
 	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
 				  THIS_MODULE, loop_probe, NULL, NULL);
 
+	/* pre-create number devices of devices given by config or max_loop */
+	mutex_lock(&loop_index_mutex);
+	for (i = 0; i < nr; i++)
+		loop_add(&lo, i);
+	mutex_unlock(&loop_index_mutex);
+
 	printk(KERN_INFO "loop: module loaded\n");
 	return 0;
+}
 
-Enomem:
-	printk(KERN_INFO "loop: out of memory\n");
-
-	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
-		loop_free(lo);
+static int loop_exit_cb(int id, void *ptr, void *data)
+{
+	struct loop_device *lo = ptr;
 
-	unregister_blkdev(LOOP_MAJOR, "loop");
-	return -ENOMEM;
+	loop_remove(lo);
+	return 0;
 }
 
 static void __exit loop_exit(void)
 {
 	unsigned long range;
-	struct loop_device *lo, *next;
 
 	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
-	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
-		loop_del_one(lo);
+	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
+	idr_remove_all(&loop_index_idr);
+	idr_destroy(&loop_index_idr);
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	unregister_blkdev(LOOP_MAJOR, "loop");
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -64,7 +64,6 @@ struct loop_device {
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
-	struct list_head	lo_list;
 };
 
 #endif /* __KERNEL__ */


