Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab1IAVzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 17:55:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758059Ab1IAVzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 17:55:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, dm-devel@redhat.com
Cc: kzak@redhat.com, vgoyal@redhat.com
Subject: [PATCH 1/1] block: Add ioctl for extending partition size online
Date: Thu,  1 Sep 2011 17:55:27 -0400
Message-Id: <1314914128-3171-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1314914128-3171-1-git-send-email-vgoyal@redhat.com>
References: <1314914128-3171-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently one can change the partition table but new partition table does
not take effect if there are any users/openers of the partition.

It will be nice if partition can be extended while in use. The use case
is that a device size can grow and the one should be able to extend
the last partition to use size increase.

This patch provides an ioctl BLKPG_EXTEND_PARTITION, to extend the
partition online. It does not support partition shrinking. It also does
not modify any of the on disk data structures. User must make sure
that table is first updated on disk and then do relevant changes
in kernel's view of table. That will make sure things are fine over
a reboot.

Apart from updating partition size, it also updates the associated
bdev's inode size so that tools like pvresize can come to know of
new size of partition device.

I have added one patch for util-linux package to add a command line tool
, extendpart (on the lines of addpart, delpart).

I did following test.

- Create a partition of 10MB on a disk using fdisk.
- Add this partition to a volume group
- Use fdisk to increase the partition size to 20MB. (First delete the
  partition and then create a new one of 20MB size).
- Use extendpart to extend partition size in kernel.
	extendpart /dev/sda 1 20480
- Do pvresize on partition so that physical volume can be incrased in
  size online.
	pvresize /dev/sda1

pvresize does recognize the new size. Also lsblk and /proc/partitions
report the new size of partition.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/genhd.c         |   10 +++---
 block/ioctl.c         |   74 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/partitions/check.c |   66 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkpg.h |    1 +
 include/linux/genhd.h |    8 +++++
 5 files changed, 151 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e2f6790..90327a4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -154,7 +154,7 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
-		if (!part->nr_sects &&
+		if (!part_nr_sects_read(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
 		      piter->idx == 0))
@@ -191,7 +191,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 static inline int sector_in_part(struct hd_struct *part, sector_t sector)
 {
 	return part->start_sect <= sector &&
-		sector < part->start_sect + part->nr_sects;
+		sector < part->start_sect + part_nr_sects_read(part);
 }
 
 /**
@@ -760,8 +760,8 @@ void __init printk_all_partitions(void)
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
-			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       (unsigned long long)part_nr_sects_read(part) >> 1
+			       , disk_name(disk, part->partno, name_buf), uuid);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
@@ -852,7 +852,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
-			   (unsigned long long)part->nr_sects >> 1,
+			   (unsigned long long)part_nr_sects_read(part) >> 1,
 			   disk_name(sgp, part->partno, buf));
 	disk_part_iter_exit(&piter);
 
diff --git a/block/ioctl.c b/block/ioctl.c
index 1124cd2..d5de971 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -12,12 +12,13 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 {
 	struct block_device *bdevp;
 	struct gendisk *disk;
-	struct hd_struct *part;
+	struct hd_struct *part, *lpart;
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
 	struct disk_part_iter piter;
-	long long start, length;
+	long long start, length, size, orig_length, new_length;
 	int partno;
+	loff_t bdev_size;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -91,6 +92,75 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			bdput(bdevp);
 
 			return 0;
+		case BLKPG_EXTEND_PARTITION:
+			/* length here represents increase in partition size */
+			size = p.length >> 9;
+
+			part = disk_get_part(disk, partno);
+			if (!part)
+				return -ENXIO;
+			bdevp = bdget(part_devt(part));
+			disk_put_part(part);
+			if (!bdevp)
+				return -ENOMEM;
+
+			mutex_lock(&bdevp->bd_mutex);
+			mutex_lock_nested(&bdev->bd_mutex, 1);
+
+			start = part->start_sect;
+			orig_length = part->nr_sects;
+			new_length = orig_length + size;
+
+			if (new_length < orig_length || new_length < 0) {
+				mutex_unlock(&bdev->bd_mutex);
+				mutex_unlock(&bdevp->bd_mutex);
+				bdput(bdevp);
+				return -EINVAL;
+			}
+
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) == sizeof(long) &&
+			    sizeof(long long) > sizeof(long)) {
+				long plength = new_length;
+				if (plength != length || plength < 0) {
+					mutex_unlock(&bdev->bd_mutex);
+					mutex_unlock(&bdevp->bd_mutex);
+					bdput(bdevp);
+					return -EINVAL;
+				}
+			}
+
+			/* overlap? */
+			disk_part_iter_init(&piter, disk,
+					    DISK_PITER_INCL_EMPTY);
+			while ((lpart = disk_part_iter_next(&piter))) {
+
+				/* This is partition being extended */
+				if (lpart->start_sect == part->start_sect)
+					continue;
+
+				if (!(start + new_length <= lpart->start_sect ||
+				    start >= lpart->start_sect + lpart->nr_sects
+					)) {
+					disk_part_iter_exit(&piter);
+					mutex_unlock(&bdev->bd_mutex);
+					mutex_unlock(&bdevp->bd_mutex);
+					bdput(bdevp);
+					return -EBUSY;
+				}
+			}
+			disk_part_iter_exit(&piter);
+			if (!extend_partition(disk, partno, size)) {
+				/* Update bdev->bd_inode size */
+				bdev_size = i_size_read(bdevp->bd_inode);
+				i_size_write(bdevp->bd_inode,
+						bdev_size + (size << 9));
+			}
+			mutex_unlock(&bdev->bd_mutex);
+			mutex_unlock(&bdevp->bd_mutex);
+			bdput(bdevp);
+
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e3c63d1..5d462d6 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -21,6 +21,7 @@
 #include <linux/ctype.h>
 #include <linux/genhd.h>
 #include <linux/blktrace_api.h>
+#include <linux/seqlock.h>
 
 #include "check.h"
 
@@ -234,7 +235,7 @@ ssize_t part_size_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+	return sprintf(buf, "%llu\n",(unsigned long long)part_nr_sects_read(p));
 }
 
 static ssize_t part_ro_show(struct device *dev,
@@ -408,6 +409,69 @@ void delete_partition(struct gendisk *disk, int partno)
 	hd_struct_put(part);
 }
 
+#if BITS_PER_LONG == 32 && defined(CONFIG_LBDAF)
+static inline void part_nr_sects_write_begin(struct seqcount_t *seq)
+{
+	write_seqcount_begin(&seq);
+}
+
+static inline void part_nr_sects_write_end(struct seqcount_t *seq)
+{
+	write_seqcount_end(&seq);
+}
+
+/*
+ * Any access of part->nr_sects which is not protected by partition
+ * bd_mutex or gendisk bdev bd_mutex, hould be done using this accessor
+ * function.
+ */
+sector_t part_nr_sects_read(struct hd_struct *part)
+{
+	sector_t nr_sects;
+        unsigned seq;
+
+        do {
+                seq = read_seqcount_begin(&part->seq);
+                nr_sects = part->nr_sects;
+        } while (read_seqcount_retry(&part->seq, seq));
+
+        return nr_sects;
+}
+#else
+static inline void part_nr_sects_write_begin(seqcount_t *seq) {}
+static inline void part_nr_sects_write_end(seqcount_t *seq) {}
+sector_t part_nr_sects_read(struct hd_struct *part)
+{
+	return part->nr_sects;
+}
+#endif
+
+int extend_partition(struct gendisk *disk, int partno, sector_t size)
+{
+	struct disk_part_tbl *ptbl = disk->part_tbl;
+	struct hd_struct *part;
+	unsigned long flags;
+
+	if (partno >= ptbl->len)
+		return 1;
+
+	part = ptbl->part[partno];
+	if (!part)
+		return 1;
+
+	/*
+	 * It is called with mutex held for writer mutual exclusion. Disabling
+	 * interrupts to protect against a reader in interrupt/softirq
+	 * context. Is it not needed?
+	 */
+	local_irq_save(flags);
+	part_nr_sects_write_begin(&part->seq);
+	part->nr_sects += size;
+	part_nr_sects_write_end(&part->seq);
+	local_irq_restore(flags);
+	return 0;
+}
+
 static ssize_t whole_disk_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
index faf8a45..2a7bce9 100644
--- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
 /* The subfunctions (for the op field) */
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
+#define BLKPG_EXTEND_PARTITION	3
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 02fa469..81c12d2 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -98,7 +98,13 @@ struct partition_meta_info {
 
 struct hd_struct {
 	sector_t start_sect;
+	/*
+	 * nr_sects is protected by sequence counter. One might extend a
+	 * partition while IO is happening to it and update of nr_sects
+	 * can be non-atomic on 32bit machines with 64bit sector_t.
+	 */
 	sector_t nr_sects;
+	seqcount_t seq;
 	sector_t alignment_offset;
 	unsigned int discard_alignment;
 	struct device __dev;
@@ -600,8 +606,10 @@ extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     struct partition_meta_info
 						       *info);
 extern void __delete_partition(struct hd_struct *);
+extern int extend_partition(struct gendisk *disk, int partno, sector_t size);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
+extern sector_t part_nr_sects_read(struct hd_struct *part);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
-- 
1.7.6

