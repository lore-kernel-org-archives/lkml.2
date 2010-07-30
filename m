Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0G3J4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 05:56:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60185 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab0G3J4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 05:56:04 -0400
Subject: block: move all core partition code from fs/partitions/check.c to
 block/
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 11:56:10 +0200
Message-ID: <1280483770.1851.5.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: block: move all core partition code from fs/partitions/check.c to block/

Only the actual partition parsing code should be left in fs/partitions now,
and the driver core/sysfs code for partitions has moved to block/partition.c.

Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---
 block/Makefile        |    3 
 block/genhd.c         |   42 ++++++
 block/partition.c     |  290 +++++++++++++++++++++++++++++++++++++++++++
 fs/partitions/check.c |  332 --------------------------------------------------
 4 files changed, 334 insertions(+), 333 deletions(-)

--- a/block/Makefile
+++ b/block/Makefile
@@ -5,7 +5,8 @@
 obj-$(CONFIG_BLOCK) := elevator.o blk-core.o blk-tag.o blk-sysfs.o \
 			blk-barrier.o blk-settings.o blk-ioc.o blk-map.o \
 			blk-exec.o blk-merge.o blk-softirq.o blk-timeout.o \
-			blk-iopoll.o blk-lib.o ioctl.o genhd.o scsi_ioctl.o
+			blk-iopoll.o blk-lib.o ioctl.o genhd.o partition.o \
+			scsi_ioctl.o
 
 obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_BLK_CGROUP)	+= blk-cgroup.o
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -2,6 +2,7 @@
  *  gendisk handling
  */
 
+#include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
@@ -21,6 +22,47 @@
 
 #include "blk.h"
 
+#ifdef CONFIG_BLK_DEV_MD
+extern void md_autodetect_dev(dev_t dev);
+#endif
+
+/*
+ * disk_name() is used by partition check code and the genhd driver.
+ * It formats the devicename of the indicated disk into
+ * the supplied buffer (of size at least 32), and returns
+ * a pointer to that same buffer (for convenience).
+ */
+char *disk_name(struct gendisk *hd, int partno, char *buf)
+{
+	if (!partno)
+		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
+	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
+		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
+	else
+		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
+
+	return buf;
+}
+
+const char *bdevname(struct block_device *bdev, char *buf)
+{
+	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
+}
+EXPORT_SYMBOL(bdevname);
+
+/*
+ * There's very little reason to use this, you should really
+ * have a struct block_device just about everywhere and use
+ * bdevname() instead.
+ */
+const char *__bdevname(dev_t dev, char *buffer)
+{
+	scnprintf(buffer, BDEVNAME_SIZE, "unknown-block(%u,%u)",
+				MAJOR(dev), MINOR(dev));
+	return buffer;
+}
+EXPORT_SYMBOL(__bdevname);
+
 static DEFINE_MUTEX(block_class_lock);
 #ifndef CONFIG_SYSFS_DEPRECATED
 struct kobject *block_depr;
--- /dev/null
+++ b/block/partition.c
@@ -0,0 +1,290 @@
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/kmod.h>
+#include <linux/ctype.h>
+#include <linux/genhd.h>
+#include <linux/blktrace_api.h>
+
+static ssize_t part_partition_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%d\n", p->partno);
+}
+
+static ssize_t part_start_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%llu\n",(unsigned long long)p->start_sect);
+}
+
+ssize_t part_size_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+}
+
+ssize_t part_alignment_offset_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment_offset);
+}
+
+ssize_t part_discard_alignment_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	return sprintf(buf, "%u\n", p->discard_alignment);
+}
+
+ssize_t part_stat_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	int cpu;
+
+	cpu = part_stat_lock();
+	part_round_stats(cpu, p);
+	part_stat_unlock();
+	return sprintf(buf,
+		"%8lu %8lu %8llu %8u "
+		"%8lu %8lu %8llu %8u "
+		"%8u %8u %8u"
+		"\n",
+		part_stat_read(p, ios[READ]),
+		part_stat_read(p, merges[READ]),
+		(unsigned long long)part_stat_read(p, sectors[READ]),
+		jiffies_to_msecs(part_stat_read(p, ticks[READ])),
+		part_stat_read(p, ios[WRITE]),
+		part_stat_read(p, merges[WRITE]),
+		(unsigned long long)part_stat_read(p, sectors[WRITE]),
+		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
+		part_in_flight(p),
+		jiffies_to_msecs(part_stat_read(p, io_ticks)),
+		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
+}
+
+ssize_t part_inflight_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%8u %8u\n", p->in_flight[0], p->in_flight[1]);
+}
+
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+ssize_t part_fail_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%d\n", p->make_it_fail);
+}
+
+ssize_t part_fail_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0)
+		p->make_it_fail = (i == 0) ? 0 : 1;
+
+	return count;
+}
+#endif
+
+static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
+static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
+static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
+static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
+static DEVICE_ATTR(discard_alignment, S_IRUGO, part_discard_alignment_show,
+		   NULL);
+static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+static struct device_attribute dev_attr_fail =
+	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
+#endif
+
+static struct attribute *part_attrs[] = {
+	&dev_attr_partition.attr,
+	&dev_attr_start.attr,
+	&dev_attr_size.attr,
+	&dev_attr_alignment_offset.attr,
+	&dev_attr_discard_alignment.attr,
+	&dev_attr_stat.attr,
+	&dev_attr_inflight.attr,
+#ifdef CONFIG_FAIL_MAKE_REQUEST
+	&dev_attr_fail.attr,
+#endif
+	NULL
+};
+
+static struct attribute_group part_attr_group = {
+	.attrs = part_attrs,
+};
+
+static const struct attribute_group *part_attr_groups[] = {
+	&part_attr_group,
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	&blk_trace_attr_group,
+#endif
+	NULL
+};
+
+static void part_release(struct device *dev)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	free_part_stats(p);
+	kfree(p);
+}
+
+struct device_type part_type = {
+	.name		= "partition",
+	.groups		= part_attr_groups,
+	.release	= part_release,
+};
+
+static void delete_partition_rcu_cb(struct rcu_head *head)
+{
+	struct hd_struct *part = container_of(head, struct hd_struct, rcu_head);
+
+	part->start_sect = 0;
+	part->nr_sects = 0;
+	part_stat_set_all(part, 0);
+	put_device(part_to_dev(part));
+}
+
+void delete_partition(struct gendisk *disk, int partno)
+{
+	struct disk_part_tbl *ptbl = disk->part_tbl;
+	struct hd_struct *part;
+
+	if (partno >= ptbl->len)
+		return;
+
+	part = ptbl->part[partno];
+	if (!part)
+		return;
+
+	blk_free_devt(part_devt(part));
+	rcu_assign_pointer(ptbl->part[partno], NULL);
+	rcu_assign_pointer(ptbl->last_lookup, NULL);
+	kobject_put(part->holder_dir);
+	device_del(part_to_dev(part));
+
+	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
+}
+
+static ssize_t whole_disk_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	return 0;
+}
+static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
+		   whole_disk_show, NULL);
+
+struct hd_struct *add_partition(struct gendisk *disk, int partno,
+				sector_t start, sector_t len, int flags)
+{
+	struct hd_struct *p;
+	dev_t devt = MKDEV(0, 0);
+	struct device *ddev = disk_to_dev(disk);
+	struct device *pdev;
+	struct disk_part_tbl *ptbl;
+	const char *dname;
+	int err;
+
+	err = disk_expand_part_tbl(disk, partno);
+	if (err)
+		return ERR_PTR(err);
+	ptbl = disk->part_tbl;
+
+	if (ptbl->part[partno])
+		return ERR_PTR(-EBUSY);
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-EBUSY);
+
+	if (!init_part_stats(p)) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+	pdev = part_to_dev(p);
+
+	p->start_sect = start;
+	p->alignment_offset =
+		queue_limit_alignment_offset(&disk->queue->limits, start);
+	p->discard_alignment =
+		queue_limit_discard_alignment(&disk->queue->limits, start);
+	p->nr_sects = len;
+	p->partno = partno;
+	p->policy = get_disk_ro(disk);
+
+	dname = dev_name(ddev);
+	if (isdigit(dname[strlen(dname) - 1]))
+		dev_set_name(pdev, "%sp%d", dname, partno);
+	else
+		dev_set_name(pdev, "%s%d", dname, partno);
+
+	device_initialize(pdev);
+	pdev->class = &block_class;
+	pdev->type = &part_type;
+	pdev->parent = ddev;
+
+	err = blk_alloc_devt(p, &devt);
+	if (err)
+		goto out_free_stats;
+	pdev->devt = devt;
+
+	/* delay uevent until 'holders' subdir is created */
+	dev_set_uevent_suppress(pdev, 1);
+	err = device_add(pdev);
+	if (err)
+		goto out_put;
+
+	err = -ENOMEM;
+	p->holder_dir = kobject_create_and_add("holders", &pdev->kobj);
+	if (!p->holder_dir)
+		goto out_del;
+
+	dev_set_uevent_suppress(pdev, 0);
+	if (flags & ADDPART_FLAG_WHOLEDISK) {
+		err = device_create_file(pdev, &dev_attr_whole_disk);
+		if (err)
+			goto out_del;
+	}
+
+	/* everything is up and running, commence */
+	INIT_RCU_HEAD(&p->rcu_head);
+	rcu_assign_pointer(ptbl->part[partno], p);
+
+	/* suppress uevent if the disk supresses it */
+	if (!dev_get_uevent_suppress(ddev))
+		kobject_uevent(&pdev->kobj, KOBJ_ADD);
+
+	return p;
+
+out_free_stats:
+	free_part_stats(p);
+out_free:
+	kfree(p);
+	return ERR_PTR(err);
+out_del:
+	kobject_put(p->holder_dir);
+	device_del(pdev);
+out_put:
+	put_device(pdev);
+	blk_free_devt(devt);
+	return ERR_PTR(err);
+}
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -1,7 +1,4 @@
 /*
- *  fs/partitions/check.c
- *
- *  Code extracted from drivers/block/genhd.c
  *  Copyright (C) 1991-1998  Linus Torvalds
  *  Re-organised Feb 1998 Russell King
  *
@@ -9,8 +6,6 @@
  *  block drivers, which allows all the partition code to
  *  be grouped in one location, and it to be mostly self
  *  contained.
- *
- *  Added needed MAJORS for new pairs, {hdi,hdj}, {hdk,hdl}
  */
 
 #include <linux/init.h>
@@ -39,10 +34,6 @@
 #include "karma.h"
 #include "sysv68.h"
 
-#ifdef CONFIG_BLK_DEV_MD
-extern void md_autodetect_dev(dev_t dev);
-#endif
-
 int warn_no_part = 1; /*This is ugly: should make genhd removable media aware*/
 
 static int (*check_part[])(struct parsed_partitions *) = {
@@ -114,46 +105,6 @@ static int (*check_part[])(struct parsed
 #endif
 	NULL
 };
- 
-/*
- * disk_name() is used by partition check code and the genhd driver.
- * It formats the devicename of the indicated disk into
- * the supplied buffer (of size at least 32), and returns
- * a pointer to that same buffer (for convenience).
- */
-
-char *disk_name(struct gendisk *hd, int partno, char *buf)
-{
-	if (!partno)
-		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
-	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
-		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
-	else
-		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
-
-	return buf;
-}
-
-const char *bdevname(struct block_device *bdev, char *buf)
-{
-	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
-}
-
-EXPORT_SYMBOL(bdevname);
-
-/*
- * There's very little reason to use this, you should really
- * have a struct block_device just about everywhere and use
- * bdevname() instead.
- */
-const char *__bdevname(dev_t dev, char *buffer)
-{
-	scnprintf(buffer, BDEVNAME_SIZE, "unknown-block(%u,%u)",
-				MAJOR(dev), MINOR(dev));
-	return buffer;
-}
-
-EXPORT_SYMBOL(__bdevname);
 
 static struct parsed_partitions *
 check_partition(struct gendisk *hd, struct block_device *bdev)
@@ -200,288 +151,6 @@ check_partition(struct gendisk *hd, stru
 	return ERR_PTR(res);
 }
 
-static ssize_t part_partition_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-
-	return sprintf(buf, "%d\n", p->partno);
-}
-
-static ssize_t part_start_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-
-	return sprintf(buf, "%llu\n",(unsigned long long)p->start_sect);
-}
-
-ssize_t part_size_show(struct device *dev,
-		       struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
-}
-
-ssize_t part_alignment_offset_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n", (unsigned long long)p->alignment_offset);
-}
-
-ssize_t part_discard_alignment_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%u\n", p->discard_alignment);
-}
-
-ssize_t part_stat_show(struct device *dev,
-		       struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	int cpu;
-
-	cpu = part_stat_lock();
-	part_round_stats(cpu, p);
-	part_stat_unlock();
-	return sprintf(buf,
-		"%8lu %8lu %8llu %8u "
-		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
-		"\n",
-		part_stat_read(p, ios[READ]),
-		part_stat_read(p, merges[READ]),
-		(unsigned long long)part_stat_read(p, sectors[READ]),
-		jiffies_to_msecs(part_stat_read(p, ticks[READ])),
-		part_stat_read(p, ios[WRITE]),
-		part_stat_read(p, merges[WRITE]),
-		(unsigned long long)part_stat_read(p, sectors[WRITE]),
-		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
-		part_in_flight(p),
-		jiffies_to_msecs(part_stat_read(p, io_ticks)),
-		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
-}
-
-ssize_t part_inflight_show(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-
-	return sprintf(buf, "%8u %8u\n", p->in_flight[0], p->in_flight[1]);
-}
-
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-ssize_t part_fail_show(struct device *dev,
-		       struct device_attribute *attr, char *buf)
-{
-	struct hd_struct *p = dev_to_part(dev);
-
-	return sprintf(buf, "%d\n", p->make_it_fail);
-}
-
-ssize_t part_fail_store(struct device *dev,
-			struct device_attribute *attr,
-			const char *buf, size_t count)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	int i;
-
-	if (count > 0 && sscanf(buf, "%d", &i) > 0)
-		p->make_it_fail = (i == 0) ? 0 : 1;
-
-	return count;
-}
-#endif
-
-static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
-static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
-static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
-static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
-static DEVICE_ATTR(discard_alignment, S_IRUGO, part_discard_alignment_show,
-		   NULL);
-static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
-static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-static struct device_attribute dev_attr_fail =
-	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
-#endif
-
-static struct attribute *part_attrs[] = {
-	&dev_attr_partition.attr,
-	&dev_attr_start.attr,
-	&dev_attr_size.attr,
-	&dev_attr_alignment_offset.attr,
-	&dev_attr_discard_alignment.attr,
-	&dev_attr_stat.attr,
-	&dev_attr_inflight.attr,
-#ifdef CONFIG_FAIL_MAKE_REQUEST
-	&dev_attr_fail.attr,
-#endif
-	NULL
-};
-
-static struct attribute_group part_attr_group = {
-	.attrs = part_attrs,
-};
-
-static const struct attribute_group *part_attr_groups[] = {
-	&part_attr_group,
-#ifdef CONFIG_BLK_DEV_IO_TRACE
-	&blk_trace_attr_group,
-#endif
-	NULL
-};
-
-static void part_release(struct device *dev)
-{
-	struct hd_struct *p = dev_to_part(dev);
-	free_part_stats(p);
-	kfree(p);
-}
-
-struct device_type part_type = {
-	.name		= "partition",
-	.groups		= part_attr_groups,
-	.release	= part_release,
-};
-
-static void delete_partition_rcu_cb(struct rcu_head *head)
-{
-	struct hd_struct *part = container_of(head, struct hd_struct, rcu_head);
-
-	part->start_sect = 0;
-	part->nr_sects = 0;
-	part_stat_set_all(part, 0);
-	put_device(part_to_dev(part));
-}
-
-void delete_partition(struct gendisk *disk, int partno)
-{
-	struct disk_part_tbl *ptbl = disk->part_tbl;
-	struct hd_struct *part;
-
-	if (partno >= ptbl->len)
-		return;
-
-	part = ptbl->part[partno];
-	if (!part)
-		return;
-
-	blk_free_devt(part_devt(part));
-	rcu_assign_pointer(ptbl->part[partno], NULL);
-	rcu_assign_pointer(ptbl->last_lookup, NULL);
-	kobject_put(part->holder_dir);
-	device_del(part_to_dev(part));
-
-	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
-}
-
-static ssize_t whole_disk_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	return 0;
-}
-static DEVICE_ATTR(whole_disk, S_IRUSR | S_IRGRP | S_IROTH,
-		   whole_disk_show, NULL);
-
-struct hd_struct *add_partition(struct gendisk *disk, int partno,
-				sector_t start, sector_t len, int flags)
-{
-	struct hd_struct *p;
-	dev_t devt = MKDEV(0, 0);
-	struct device *ddev = disk_to_dev(disk);
-	struct device *pdev;
-	struct disk_part_tbl *ptbl;
-	const char *dname;
-	int err;
-
-	err = disk_expand_part_tbl(disk, partno);
-	if (err)
-		return ERR_PTR(err);
-	ptbl = disk->part_tbl;
-
-	if (ptbl->part[partno])
-		return ERR_PTR(-EBUSY);
-
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p)
-		return ERR_PTR(-EBUSY);
-
-	if (!init_part_stats(p)) {
-		err = -ENOMEM;
-		goto out_free;
-	}
-	pdev = part_to_dev(p);
-
-	p->start_sect = start;
-	p->alignment_offset =
-		queue_limit_alignment_offset(&disk->queue->limits, start);
-	p->discard_alignment =
-		queue_limit_discard_alignment(&disk->queue->limits, start);
-	p->nr_sects = len;
-	p->partno = partno;
-	p->policy = get_disk_ro(disk);
-
-	dname = dev_name(ddev);
-	if (isdigit(dname[strlen(dname) - 1]))
-		dev_set_name(pdev, "%sp%d", dname, partno);
-	else
-		dev_set_name(pdev, "%s%d", dname, partno);
-
-	device_initialize(pdev);
-	pdev->class = &block_class;
-	pdev->type = &part_type;
-	pdev->parent = ddev;
-
-	err = blk_alloc_devt(p, &devt);
-	if (err)
-		goto out_free_stats;
-	pdev->devt = devt;
-
-	/* delay uevent until 'holders' subdir is created */
-	dev_set_uevent_suppress(pdev, 1);
-	err = device_add(pdev);
-	if (err)
-		goto out_put;
-
-	err = -ENOMEM;
-	p->holder_dir = kobject_create_and_add("holders", &pdev->kobj);
-	if (!p->holder_dir)
-		goto out_del;
-
-	dev_set_uevent_suppress(pdev, 0);
-	if (flags & ADDPART_FLAG_WHOLEDISK) {
-		err = device_create_file(pdev, &dev_attr_whole_disk);
-		if (err)
-			goto out_del;
-	}
-
-	/* everything is up and running, commence */
-	INIT_RCU_HEAD(&p->rcu_head);
-	rcu_assign_pointer(ptbl->part[partno], p);
-
-	/* suppress uevent if the disk supresses it */
-	if (!dev_get_uevent_suppress(ddev))
-		kobject_uevent(&pdev->kobj, KOBJ_ADD);
-
-	return p;
-
-out_free_stats:
-	free_part_stats(p);
-out_free:
-	kfree(p);
-	return ERR_PTR(err);
-out_del:
-	kobject_put(p->holder_dir);
-	device_del(pdev);
-out_put:
-	put_device(pdev);
-	blk_free_devt(devt);
-	return ERR_PTR(err);
-}
-
 static bool disk_unlock_native_capacity(struct gendisk *disk)
 {
 	const struct block_device_operations *bdops = disk->fops;
@@ -618,4 +287,3 @@ rescan:
 	kfree(state);
 	return 0;
 }
-


