Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2GJN6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:58:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2GJN6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:58:11 -0400
Date: Tue, 10 Jul 2012 09:57:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Message-ID: <20120710135759.GE14884@redhat.com>
References: <20120709213418.799759100@redhat.com>
 <4FFB5DC3.30803@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFB5DC3.30803@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 06:40:03PM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 07/09/2012 05:34 PM, vgoyal@redhat.com wrote:
> > Phillip, do let me know if I should put your signed-off-by also in the
> > patch.
> 
> Sure, kernel side looks good.  My original util-linux patches also added a -u update mode to kpartx, which I think is the more useful interface than the lower level resizepart command, but I suppose I can rebase it to apply on top of this patch.

I wrote user space part only to do testing. We definitely need better user
space support. Especially a utility which changes partition details both
in kernel as well as on disk. Asking user to call two different utilities
is error prone and irritating.

Resending this patch again with your Signed-off-by.

Add a new operation code (BLKPG_RESIZE_PARTITION) to the BLKPG ioctl that
allows altering the size of an existing partition, even if it is currently
in use.

This patch converts hd_struct->nr_sects into sequence counter because
One might extend a partition while IO is happening to it and update of
nr_sects can be non-atomic on 32bit machines with 64bit sector_t. This
can lead to issues like reading inconsistent size of a partition. Sequence
counter have been used so that readers don't have to take bdev mutex lock
as we call sector_in_part() very frequently.

Now all the access to hd_struct->nr_sects should happen using sequence
counter read/update helper functions part_nr_sects_read/part_nr_sects_write.
There is one exception though, set_capacity()/get_capacity(). I think
theoritically race should exist there too but this patch does not
modify set_capacity()/get_capacity() due to sheer number of call sites
and I am afraid that change might break something. I have left that as a
TODO item. We can handle it later if need be. This patch does not introduce
any new races as such w.r.t set_capacity()/get_capacity().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 block/genhd.c             |   20 +++++++++++----
 block/ioctl.c             |   59 ++++++++++++++++++++++++++++++++++++++++++--
 block/partition-generic.c |    4 ++-
 include/linux/blkpg.h     |    1 +
 include/linux/genhd.h     |   57 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9cf5583..cac7366 100644
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
@@ -769,8 +769,8 @@ void __init printk_all_partitions(void)
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
-			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf),
+			       (unsigned long long)part_nr_sects_read(part) >> 1
+			       , disk_name(disk, part->partno, name_buf),
 			       uuid_buf);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
@@ -862,7 +862,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
-			   (unsigned long long)part->nr_sects >> 1,
+			   (unsigned long long)part_nr_sects_read(part) >> 1,
 			   disk_name(sgp, part->partno, buf));
 	disk_part_iter_exit(&piter);
 
@@ -1268,6 +1268,16 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		}
 		disk->part_tbl->part[0] = &disk->part0;
 
+		/*
+		 * set_capacity() and get_capacity() currently don't use
+		 * seqcounter to read/update the part0->nr_sects. Still init
+		 * the counter as we can read the sectors in IO submission
+		 * patch using seqence counters.
+		 *
+		 * TODO: Ideally set_capacity() and get_capacity() should be
+		 * converted to make use of bd_mutex and sequence counters.
+		 */
+		seqcount_init(&disk->part0.nr_sects_seq);
 		hd_ref_init(&disk->part0);
 
 		disk->minors = minors;
diff --git a/block/ioctl.c b/block/ioctl.c
index ba15b2d..4476e0e8 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -13,7 +13,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 {
 	struct block_device *bdevp;
 	struct gendisk *disk;
-	struct hd_struct *part;
+	struct hd_struct *part, *lpart;
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
 	struct disk_part_iter piter;
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
@@ -92,6 +92,59 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			bdput(bdevp);
 
 			return 0;
+		case BLKPG_RESIZE_PARTITION:
+			start = p.start >> 9;
+			/* new length of partition in bytes */
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
+				bdput(bdevp);
+				disk_put_part(part);
+				return -EINVAL;
+			}
+			/* overlap? */
+			disk_part_iter_init(&piter, disk,
+					    DISK_PITER_INCL_EMPTY);
+			while ((lpart = disk_part_iter_next(&piter))) {
+				if (lpart->partno != partno &&
+				   !(start + length <= lpart->start_sect ||
+				   start >= lpart->start_sect + lpart->nr_sects)
+				   ) {
+					disk_part_iter_exit(&piter);
+					mutex_unlock(&bdevp->bd_mutex);
+					mutex_unlock(&bdev->bd_mutex);
+					bdput(bdevp);
+					disk_put_part(part);
+					return -EBUSY;
+				}
+			}
+			disk_part_iter_exit(&piter);
+			part_nr_sects_write(part, (sector_t)length);
+			i_size_write(bdevp->bd_inode, p.length);
+			mutex_unlock(&bdevp->bd_mutex);
+			mutex_unlock(&bdev->bd_mutex);
+			bdput(bdevp);
+			disk_put_part(part);
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 6df5d69..f1d1451 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -84,7 +84,7 @@ ssize_t part_size_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+	return sprintf(buf, "%llu\n",(unsigned long long)part_nr_sects_read(p));
 }
 
 static ssize_t part_ro_show(struct device *dev,
@@ -294,6 +294,8 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 		err = -ENOMEM;
 		goto out_free;
 	}
+
+	seqcount_init(&p->nr_sects_seq);
 	pdev = part_to_dev(p);
 
 	p->start_sect = start;
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
index 017a7fb..ee8e688 100644
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
+	seqcount_t nr_sects_seq;
 	sector_t alignment_offset;
 	unsigned int discard_alignment;
 	struct device __dev;
@@ -648,6 +654,57 @@ static inline void hd_struct_put(struct hd_struct *part)
 		__delete_partition(part);
 }
 
+/*
+ * Any access of part->nr_sects which is not protected by partition
+ * bd_mutex or gendisk bdev bd_mutex, should be done using this
+ * accessor function.
+ *
+ * Code written along the lines of i_size_read() and i_size_write().
+ * CONFIG_PREEMPT case optimizes the case of UP kernel with preemption
+ * on.
+ */
+static inline sector_t part_nr_sects_read(struct hd_struct *part)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_LBDAF) && defined(CONFIG_SMP)
+	sector_t nr_sects;
+	unsigned seq;
+	do {
+		seq = read_seqcount_begin(&part->nr_sects_seq);
+		nr_sects = part->nr_sects;
+	} while (read_seqcount_retry(&part->nr_sects_seq, seq));
+	return nr_sects;
+#elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
+	sector_t nr_sects;
+
+	preempt_disable();
+	nr_sects = part->nr_sects;
+	preempt_enable();
+	return nr_sects;
+#else
+	return part->nr_sects;
+#endif
+}
+
+/*
+ * Should be called with mutex lock held (typically bd_mutex) of partition
+ * to provide mutual exlusion among writers otherwise seqcount might be
+ * left in wrong state leaving the readers spinning infinitely.
+ */
+static inline void part_nr_sects_write(struct hd_struct *part, sector_t size)
+{
+#if BITS_PER_LONG==32 && defined(CONFIG_LBDAF) && defined(CONFIG_SMP)
+	write_seqcount_begin(&part->nr_sects_seq);
+	part->nr_sects = size;
+	write_seqcount_end(&part->nr_sects_seq);
+#elif BITS_PER_LONG==32 && defined(CONFIG_LBDAF) && defined(CONFIG_PREEMPT)
+	preempt_disable();
+	part->nr_sects = size;
+	preempt_enable();
+#else
+	part->nr_sects = size;
+#endif
+}
+
 #else /* CONFIG_BLOCK */
 
 static inline void printk_all_partitions(void) { }
-- 
1.7.7.6

