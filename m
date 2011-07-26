Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1GZLum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:50:42 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36405 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1GZLug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:50:36 -0400
Subject: [PATCH] loop: add management interface for on-demand device
 allocation
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Jul 2011 13:50:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311681033.1325.4.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: loop: add management interface for on-demand device allocation

Loop devices today have a fixed pre-allocated number of usually 8.
The number can only be changed at init time. To find a free device
to use, /dev/loop%i needs to be scanned and all devices need to be
opened.

This adds a new /dev/loop-control device node allows to dynamically
request new, and to add and remove loop devices from the running
system:
  LOOP_CTL_ADD adds a specific device. Arg is the number
  of the device. It returns the device nr or a negative
  error code.

  LOOP_CTL_REMOVE removes a specific device, Arg is the
  number the device. It returns the device nr or a negative
  error code.

  LOOP_CTL_GET_FREE finds the next unbound device or allocates
  a new one. No arg is given. It returns the device nr or a
  negative error code.

The loop kernel module gets automatically loaded when
/dev/loop-control is accessed the first time. The alias
specified in the module, instructs udev to create this
device node, even when the module is not loaded.

A kernel config option BLK_DEV_LOOP_MIN_COUNT is introduced
to allow setups without any pre-created dead loop device,
if none is needed. The default is the historic value of 8.

The linked list to keep track of allocated loop devices is
replaced by a more efficient idr index.

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

 Documentation/kernel-parameters.txt |   13 -
 drivers/block/Kconfig               |   15 +
 drivers/block/loop.c                |  361 +++++++++++++++++++++++-------------
 include/linux/loop.h                |   10 
 include/linux/miscdevice.h          |    1 
 5 files changed, 266 insertions(+), 134 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 40cc653..504471b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1289,6 +1289,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			kernel log messages and is useful when debugging
 			kernel boot problems.
 
+	loop.max_loop=	[LOOP] The number of loop block devices that get
+	(max_loop)	unconditionally pre-created at init time. The default
+			number is configured by BLK_DEV_LOOP_MIN_COUNT. Loop
+			devices can be requested on-demand with the
+			/dev/loop-control interface.
+
+	loop.max_part=	[LOOP] Maximum possible number of partitions to create
+			per loop device.
+
 	lp=0		[LP]	Specify parallel ports to use, e.g,
 	lp=port[,port...]	lp=none,parport0 (lp0 not configured, lp1 uses
 	lp=reset		first parallel port). 'lp=0' disables the
@@ -1340,10 +1349,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			it is equivalent to "nosmp", which also disables
 			the IO APIC.
 
-	max_loop=	[LOOP] Maximum number of loopback devices that can
-			be mounted
-			Format: <1-256>
-
 	mcatest=	[IA-64]
 
 	mce		[X86-32] Machine Check Exception
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 717d6e4..a382ab5 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -254,7 +254,20 @@ config BLK_DEV_LOOP
 	  To compile this driver as a module, choose M here: the
 	  module will be called loop.
 
-	  Most users will answer N here.
+config BLK_DEV_LOOP_MIN_COUNT
+	int "Number of loop devices to pre-create at init time"
+	depends on BLK_DEV_LOOP
+	default 8
+	help
+	  Number of loop devices to be unconditionally pre-created at
+	  init time.
+
+	  This default value can be overwritten on the kernel command
+	  line or with module-parameter loop.max_loop.
+
+	  The historic default is 8, if a late 2011 version of losetup(8)
+	  is used, it can be set to 0, since needed loop devices can be
+	  dynamically allocated with the /dev/loop-control interface.
 
 config BLK_DEV_CRYPTOLOOP
 	tristate "Cryptoloop Support"
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 76c8da7..d9b71ca 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -75,15 +75,21 @@
 #include <linux/kthread.h>
 #include <linux/splice.h>
 #include <linux/sysfs.h>
+#include <linux/miscdevice.h>
 
 #include <asm/uaccess.h>
 
 static LIST_HEAD(loop_devices);
+static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_devices_mutex);
 
+static int max_loop;
 static int max_part;
 static int part_shift;
 
+static int loop_lookup(struct loop_device **lo, int nr);
+static int loop_add(struct loop_device **lo, int nr);
+
 /*
  * Transfer functions
  */
@@ -722,15 +728,8 @@ static inline int is_loop_device(struct file *file)
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
 
 	return lo ? callback(lo, page) : -EIO;
 }
@@ -995,7 +994,7 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
-	if (lo->lo_refcnt > 1)	/* we needed one fd for the ioctl */
+	if (atomic_read(&lo->lo_open_count) > 1)	/* we needed one fd for the ioctl */
 		return -EBUSY;
 
 	if (filp == NULL)
@@ -1485,13 +1484,19 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 
 static int lo_open(struct block_device *bdev, fmode_t mode)
 {
-	struct loop_device *lo = bdev->bd_disk->private_data;
-
-	mutex_lock(&lo->lo_ctl_mutex);
-	lo->lo_refcnt++;
-	mutex_unlock(&lo->lo_ctl_mutex);
+	struct loop_device *lo;
+	int err = 0;
 
-	return 0;
+	mutex_lock(&loop_devices_mutex);
+	lo = bdev->bd_disk->private_data;
+	if (!lo) {
+		err = -ENXIO;
+		goto out;
+	}
+	atomic_inc(&lo->lo_open_count);
+out:
+	mutex_unlock(&loop_devices_mutex);
+	return err;
 }
 
 static int lo_release(struct gendisk *disk, fmode_t mode)
@@ -1501,7 +1506,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 
 	mutex_lock(&lo->lo_ctl_mutex);
 
-	if (--lo->lo_refcnt)
+	if (!atomic_dec_and_test(&lo->lo_open_count))
 		goto out;
 
 	if (lo->lo_flags & LO_FLAGS_AUTOCLEAR) {
@@ -1536,10 +1541,6 @@ static const struct block_device_operations lo_fops = {
 #endif
 };
 
-/*
- * And now the modules code and kernel interface.
- */
-static int max_loop;
 module_param(max_loop, int, S_IRUGO);
 MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 module_param(max_part, int, S_IRUGO);
@@ -1556,136 +1557,244 @@ int loop_register_transfer(struct loop_func_table *funcs)
 	xfer_funcs[n] = funcs;
 	return 0;
 }
+EXPORT_SYMBOL(loop_register_transfer);
+
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
-
-EXPORT_SYMBOL(loop_register_transfer);
 EXPORT_SYMBOL(loop_unregister_transfer);
 
-static struct loop_device *loop_alloc(int i)
+static int loop_add(struct loop_device **lo, int nr)
 {
-	struct loop_device *lo;
+	struct loop_device *l;
 	struct gendisk *disk;
+	int err;
 
-	lo = kzalloc(sizeof(*lo), GFP_KERNEL);
-	if (!lo)
-		goto out;
+	l = kzalloc(sizeof(struct loop_device), GFP_KERNEL);
+	if (!l) {
+		err = -ENOMEM;
+		goto err;
+	}
 
-	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
-	if (!lo->lo_queue)
-		goto out_free_dev;
-
-	disk = lo->lo_disk = alloc_disk(1 << part_shift);
-	if (!disk)
-		goto out_free_queue;
-
-	mutex_init(&lo->lo_ctl_mutex);
-	lo->lo_number		= i;
-	lo->lo_thread		= NULL;
-	init_waitqueue_head(&lo->lo_event);
-	spin_lock_init(&lo->lo_lock);
-	disk->major		= LOOP_MAJOR;
-	disk->first_minor	= i << part_shift;
-	disk->fops		= &lo_fops;
-	disk->private_data	= lo;
-	disk->queue		= lo->lo_queue;
-	sprintf(disk->disk_name, "loop%d", i);
-	return lo;
-
-out_free_queue:
-	blk_cleanup_queue(lo->lo_queue);
-out_free_dev:
-	kfree(lo);
-out:
-	return NULL;
+	err = idr_pre_get(&loop_index_idr, GFP_KERNEL);
+	if (err < 0)
+		goto err_free_dev;
+
+	if (nr >= 0) {
+		int m;
+
+		/* create specific nr in the index */
+		err = idr_get_new_above(&loop_index_idr, l, nr, &m);
+		if (err >= 0 && nr != m) {
+			idr_remove(&loop_index_idr, m);
+			err = -EEXIST;
+		}
+	} else if (nr == -1) {
+		int m;
+
+		/* get next free nr */
+		err = idr_get_new(&loop_index_idr, l, &m);
+		if (err >= 0)
+			nr = m;
+	} else {
+		err = -EINVAL;
+	}
+	if (err < 0)
+		goto err_free_dev;
+
+	l->lo_queue = blk_alloc_queue(GFP_KERNEL);
+	if (!l->lo_queue) {
+		err = -ENOMEM;
+		goto err_free_dev;
+	}
+
+	disk = alloc_disk(1 << part_shift);
+	if (!disk) {
+		err = -ENOMEM;
+		goto err_free_queue;
+	}
+	disk->first_minor = nr << part_shift;
+	disk->major = LOOP_MAJOR;
+	disk->fops = &lo_fops;
+	disk->private_data = l;
+	disk->queue = l->lo_queue;
+	sprintf(disk->disk_name, "loop%d", nr);
+	add_disk(disk);
+	l->lo_disk = disk;
+
+	l->lo_number = nr;
+	mutex_init(&l->lo_ctl_mutex);
+	init_waitqueue_head(&l->lo_event);
+	spin_lock_init(&l->lo_lock);
+	*lo = l;
+
+	return l->lo_number;
+
+err_free_queue:
+	blk_cleanup_queue(l->lo_queue);
+err_free_dev:
+	kfree(l);
+err:
+	return err;
 }
 
-static void loop_free(struct loop_device *lo)
+static int find_free_cb(int id, void *ptr, void *data)
 {
-	blk_cleanup_queue(lo->lo_queue);
-	put_disk(lo->lo_disk);
-	list_del(&lo->lo_list);
-	kfree(lo);
+	struct loop_device *l = ptr;
+	struct loop_device **lo = data;
+
+	if (l->lo_state == Lo_unbound) {
+		*lo = l;
+		return 1;
+	}
+	return 0;
 }
 
-static struct loop_device *loop_init_one(int i)
+static int loop_lookup(struct loop_device **lo, int nr)
 {
-	struct loop_device *lo;
+	struct loop_device *l;
+	int ret = -ENODEV;
 
-	list_for_each_entry(lo, &loop_devices, lo_list) {
-		if (lo->lo_number == i)
-			return lo;
+	if (nr < 0) {
+		int err;
+
+		err = idr_for_each(&loop_index_idr, &find_free_cb, &l);
+		if (err == 1) {
+			*lo = l;
+			ret = l->lo_number;
+		}
+		goto out;
 	}
 
-	lo = loop_alloc(i);
-	if (lo) {
-		add_disk(lo->lo_disk);
-		list_add_tail(&lo->lo_list, &loop_devices);
+	/* lookup and return a specific nr */
+	l = idr_find(&loop_index_idr, nr);
+	if (l) {
+		*lo = l;
+		ret = l->lo_number;
 	}
-	return lo;
+out:
+	return ret;
 }
 
-static void loop_del_one(struct loop_device *lo)
+static void loop_remove(struct loop_device *lo)
 {
 	del_gendisk(lo->lo_disk);
-	loop_free(lo);
+	blk_cleanup_queue(lo->lo_queue);
+	put_disk(lo->lo_disk);
+	kfree(lo);
 }
 
 static struct kobject *loop_probe(dev_t dev, int *part, void *data)
 {
 	struct loop_device *lo;
 	struct kobject *kobj;
+	int err;
 
 	mutex_lock(&loop_devices_mutex);
-	lo = loop_init_one(MINOR(dev) >> part_shift);
-	kobj = lo ? get_disk(lo->lo_disk) : ERR_PTR(-ENOMEM);
+	err = loop_lookup(&lo, MINOR(dev) >> part_shift);
+	if (err < 0)
+		err = loop_add(&lo, MINOR(dev) >> part_shift);
+	if (err < 0)
+		kobj = ERR_PTR(err);
+	else
+		kobj = get_disk(lo->lo_disk);
 	mutex_unlock(&loop_devices_mutex);
 
 	*part = 0;
 	return kobj;
 }
 
+static long loop_control_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long parm)
+{
+	struct loop_device *lo;
+	int ret = -ENOSYS;
+
+	mutex_lock(&loop_devices_mutex);
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
+		if (lo->lo_state != Lo_unbound) {
+			ret = -EBUSY;
+			break;
+		}
+		if (atomic_read(&lo->lo_open_count) > 0) {
+			ret = -EBUSY;
+			break;
+		}
+		lo->lo_disk->private_data = NULL;
+		idr_remove(&loop_index_idr, lo->lo_number);
+		loop_remove(lo);
+		break;
+	case LOOP_CTL_GET_FREE:
+		ret = loop_lookup(&lo, -1);
+		if (ret >= 0)
+			break;
+		ret = loop_add(&lo, -1);
+	}
+	mutex_unlock(&loop_devices_mutex);
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
+	int err;
 	int i, nr;
 	unsigned long range;
-	struct loop_device *lo, *next;
+	struct loop_device *lo;
 
-	/*
-	 * loop module now has a feature to instantiate underlying device
-	 * structure on-demand, provided that there is an access dev node.
-	 * However, this will not work well with user space tool that doesn't
-	 * know about such "feature".  In order to not break any existing
-	 * tool, we do the following:
-	 *
-	 * (1) if max_loop is specified, create that many upfront, and this
-	 *     also becomes a hard limit.
-	 * (2) if max_loop is not specified, create 8 loop device on module
-	 *     load, user can further extend loop device by create dev node
-	 *     themselves and have kernel automatically instantiate actual
-	 *     device on-demand.
-	 */
+	err = misc_register(&loop_misc);
+	if (err < 0)
+		return err;
 
 	part_shift = 0;
 	if (max_part > 0) {
@@ -1704,61 +1813,62 @@ static int __init loop_init(void)
 
 	if ((1UL << part_shift) > DISK_MAX_PARTS)
 		return -EINVAL;
-
 	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
+	/*
+	 * If max_loop is specified, create that many upfront. This also
+	 * becomes a hard limit. If max_loop is not specified, create
+	 * CONFIG_BLK_DEV_LOOP_MIN_COUNT loop devices at init time.
+	 * Loop devices can be requested on-demand with the
+	 * /dev/loop-control interface, or be instantiated by accessing
+	 * a device node.
+	 */
 	if (max_loop) {
 		nr = max_loop;
 		range = max_loop << part_shift;
 	} else {
-		nr = 8;
+		nr = CONFIG_BLK_DEV_LOOP_MIN_COUNT;
 		range = 1UL << MINORBITS;
 	}
 
 	if (register_blkdev(LOOP_MAJOR, "loop"))
 		return -EIO;
-
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
+	mutex_lock(&loop_devices_mutex);
+	for (i = 0; i < nr; i++)
+		loop_add(&lo, i);
+	mutex_unlock(&loop_devices_mutex);
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
+
+	misc_deregister(&loop_misc);
 }
 
 module_init(loop_init);
@@ -1770,6 +1880,5 @@ static int __init max_loop_setup(char *str)
 	max_loop = simple_strtol(str, NULL, 0);
 	return 1;
 }
-
 __setup("max_loop=", max_loop_setup);
 #endif
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 66c194e..5c6d011 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -30,10 +30,10 @@ struct loop_func_table;
 
 struct loop_device {
 	int		lo_number;
-	int		lo_refcnt;
+	int		lo_flags;
 	loff_t		lo_offset;
 	loff_t		lo_sizelimit;
-	int		lo_flags;
+	atomic_t	lo_open_count;
 	int		(*transfer)(struct loop_device *, int cmd,
 				    struct page *raw_page, unsigned raw_off,
 				    struct page *loop_page, unsigned loop_off,
@@ -64,7 +64,6 @@ struct loop_device {
 
 	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
-	struct list_head	lo_list;
 };
 
 #endif /* __KERNEL__ */
@@ -161,4 +160,9 @@ int loop_unregister_transfer(int number);
 #define LOOP_CHANGE_FD		0x4C06
 #define LOOP_SET_CAPACITY	0x4C07
 
+/* /dev/loop-control interface */
+#define LOOP_CTL_ADD		0x4C80
+#define LOOP_CTL_REMOVE		0x4C81
+#define LOOP_CTL_GET_FREE	0x4C82
+
 #endif
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 18fd130..c309b1e 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -40,6 +40,7 @@
 #define BTRFS_MINOR		234
 #define AUTOFS_MINOR		235
 #define MAPPER_CTRL_MINOR	236
+#define LOOP_CTRL_MINOR		237
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;


