Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab1LXWVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 17:21:23 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:13959 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1LXWVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 17:21:22 -0500
X-Authority-Analysis: v=2.0 cv=T8IOvo2Q c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=yzaWUNkOEcUA:10 a=ayC55rCoAAAA:8 a=phXHQVTUczh05-AN30MA:9 a=I9JqqNzyeE77t8AzY3QA:7 a=IKKWOzAjkM8BEgTr:21 a=A75bYY1vAGMvK4eY:21 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
From: Phillip Susi <psusi@cfl.rr.com>
To: vgoyal@redhat.com
Cc: joe@perches.com, kzak@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, Phillip Susi <psusi@cfl.rr.com>
Subject: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Date: Sat, 24 Dec 2011 17:21:14 -0500
Message-Id: <1324765275-2091-1-git-send-email-psusi@cfl.rr.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4EF645DC.3000202@cfl.rr.com>
References: <4EF645DC.3000202@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new operation code ( BLKPG_RESIZE_PARTITION ) to the
BLKPG ioctl that allows altering the size of an existing
partition, even if it is currently in use.

Thanks to Vivek Goyal for the seq counter idea.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 block/genhd.c         |   10 ++++----
 block/ioctl.c         |   53 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/partitions/check.c |   39 +++++++++++++++++++++++++++++++++++-
 include/linux/blkpg.h |    1 +
 include/linux/genhd.h |    7 ++++++
 5 files changed, 102 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 02e9fca..b34fb90 100644
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
@@ -766,8 +766,8 @@ void __init printk_all_partitions(void)
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
-			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       (unsigned long long)part_nr_sects_read(part) >> 1
+			       , disk_name(disk, part->partno, name_buf), uuid);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
@@ -858,7 +858,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
-			   (unsigned long long)part->nr_sects >> 1,
+			   (unsigned long long)part_nr_sects_read(part) >> 1,
 			   disk_name(sgp, part->partno, buf));
 	disk_part_iter_exit(&piter);
 
diff --git a/block/ioctl.c b/block/ioctl.c
index ca939fc..08b2bd6 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -36,8 +36,8 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 		case BLKPG_ADD_PARTITION:
 			start = p.start >> 9;
 			length = p.length >> 9;
-			/* check for fit in a hd_struct */ 
-			if (sizeof(sector_t) == sizeof(long) && 
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) == sizeof(long) &&
 			    sizeof(long long) > sizeof(long)) {
 				long pstart = start, plength = length;
 				if (pstart != start || plength != length
@@ -92,6 +92,55 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			bdput(bdevp);
 
 			return 0;
+		case BLKPG_RESIZE_PARTITION:
+			start = p.start >> 9;
+			length = p.length >> 9;
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) == sizeof(long) &&
+			    sizeof(long long) > sizeof(long)) {
+				long pstart = start, plength = length;
+				if (pstart != start || plength != length
+				    || pstart < 0 || plength < 0)
+					return -EINVAL;
+			}
+			part = disk_get_part(disk, partno);
+			if (!part)
+				return -ENXIO;
+			bdevp = bdget(part_devt(part));
+			if (!bdevp) {
+				disk_put_part(part);
+				return -ENOMEM;
+			}
+			mutex_lock(&bdevp->bd_mutex);
+			mutex_lock_nested(&bdev->bd_mutex, 1);
+			if (start != part->start_sect) {
+				mutex_unlock(&bdevp->bd_mutex);
+				mutex_unlock(&bdev->bd_mutex);
+				disk_put_part(part);
+				return -EINVAL;
+			}
+			/* overlap? */
+			disk_part_iter_init(&piter, disk,
+					    DISK_PITER_INCL_EMPTY);
+			struct hd_struct *lpart;
+			while ((lpart = disk_part_iter_next(&piter))) {
+				if (lpart->partno != partno && !(start + length <= lpart->start_sect ||
+				      start >= lpart->start_sect + lpart->nr_sects)) {
+					disk_part_iter_exit(&piter);
+					mutex_unlock(&bdevp->bd_mutex);
+					mutex_unlock(&bdev->bd_mutex);
+					disk_put_part(part);
+					return -EBUSY;
+				}
+			}
+			disk_part_iter_exit(&piter);
+			part->nr_sects = length;
+			i_size_write(bdevp->bd_inode, p.length);
+			mutex_unlock(&bdevp->bd_mutex);
+			mutex_unlock(&bdev->bd_mutex);
+			bdput(bdevp);
+			disk_put_part(part);
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e3c63d1..089e4bc 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -234,7 +234,7 @@ ssize_t part_size_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+	return sprintf(buf, "%llu\n",(unsigned long long)part_nr_sects_read(p));
 }
 
 static ssize_t part_ro_show(struct device *dev,
@@ -408,6 +408,43 @@ void delete_partition(struct gendisk *disk, int partno)
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
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&part->seq);
+		nr_sects = part->nr_sects;
+	} while (read_seqcount_retry(&part->seq, seq));
+
+	return nr_sects;
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
 static ssize_t whole_disk_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
index faf8a45..a851944 100644
--- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
 /* The subfunctions (for the op field) */
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
+#define BLKPG_RESIZE_PARTITION	3
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6d18f35..a55ce2c 100644
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
@@ -604,6 +610,7 @@ extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 extern void __delete_partition(struct hd_struct *);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
+extern sector_t part_nr_sects_read(struct hd_struct *part);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
-- 
1.7.5.4

