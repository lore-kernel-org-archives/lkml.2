Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab2GJO7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:59:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab2GJO7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:59:44 -0400
Date: Tue, 10 Jul 2012 10:59:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
Message-ID: <20120710145930.GG14884@redhat.com>
References: <20120709213418.799759100@redhat.com>
 <4FFB5DC3.30803@ubuntu.com>
 <20120710135759.GE14884@redhat.com>
 <4FFC387F.3070308@ubuntu.com>
 <20120710142001.GF14884@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710142001.GF14884@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:20:01AM -0400, Vivek Goyal wrote:

[..]
> > 
> > Shouldn't this be BITS_PER_LONG==32 && defined(CONFIG_LBDAF) &&
> > defined(CONFIG_PREEMPT)?  No sense disabling preemption when the
> > sector size is also 32 bits.
> 
> Yes. Good catch. We don't want to disable/enable preemption for 32bit UP 
> kernels with sector size 32bit. I will modify the patch and repost soon.
> 
> BTW, what happened to all the new lines in the code above. Looks like you
> mailer chewed these up.

Here is the V2 of the patch with CONFIG_LBDAF test added to UP, PREEMPT
case.

Thanks
Vivek


block: add partition resize function to blkpg ioctl

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

v2: Add CONFIG_LBDAF test to UP preempt case as suggested by Phillip. 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 block/genhd.c             |   20 +++++++++++----
 block/ioctl.c             |   59 +++++++++++++++++++++++++++++++++++++++++++---
 block/partition-generic.c |    4 ++-
 include/linux/blkpg.h     |    1 
 include/linux/genhd.h     |   57 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 132 insertions(+), 9 deletions(-)

Index: linux-2.6/block/genhd.c
===================================================================
--- linux-2.6.orig/block/genhd.c	2012-07-10 21:03:52.458190498 -0400
+++ linux-2.6/block/genhd.c	2012-07-10 21:03:57.065190639 -0400
@@ -154,7 +154,7 @@ struct hd_struct *disk_part_iter_next(st
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
@@ -862,7 +862,7 @@ static int show_partition(struct seq_fil
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
-			   (unsigned long long)part->nr_sects >> 1,
+			   (unsigned long long)part_nr_sects_read(part) >> 1,
 			   disk_name(sgp, part->partno, buf));
 	disk_part_iter_exit(&piter);
 
@@ -1268,6 +1268,16 @@ struct gendisk *alloc_disk_node(int mino
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
Index: linux-2.6/block/ioctl.c
===================================================================
--- linux-2.6.orig/block/ioctl.c	2012-07-10 21:03:52.459190498 -0400
+++ linux-2.6/block/ioctl.c	2012-07-10 21:03:57.067190639 -0400
@@ -13,7 +13,7 @@ static int blkpg_ioctl(struct block_devi
 {
 	struct block_device *bdevp;
 	struct gendisk *disk;
-	struct hd_struct *part;
+	struct hd_struct *part, *lpart;
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
 	struct disk_part_iter piter;
@@ -36,8 +36,8 @@ static int blkpg_ioctl(struct block_devi
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
@@ -92,6 +92,59 @@ static int blkpg_ioctl(struct block_devi
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
Index: linux-2.6/block/partition-generic.c
===================================================================
--- linux-2.6.orig/block/partition-generic.c	2012-07-10 21:03:52.460190498 -0400
+++ linux-2.6/block/partition-generic.c	2012-07-10 21:03:57.069190639 -0400
@@ -84,7 +84,7 @@ ssize_t part_size_show(struct device *de
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
-	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
+	return sprintf(buf, "%llu\n",(unsigned long long)part_nr_sects_read(p));
 }
 
 static ssize_t part_ro_show(struct device *dev,
@@ -294,6 +294,8 @@ struct hd_struct *add_partition(struct g
 		err = -ENOMEM;
 		goto out_free;
 	}
+
+	seqcount_init(&p->nr_sects_seq);
 	pdev = part_to_dev(p);
 
 	p->start_sect = start;
Index: linux-2.6/include/linux/blkpg.h
===================================================================
--- linux-2.6.orig/include/linux/blkpg.h	2012-07-10 21:03:52.462190498 -0400
+++ linux-2.6/include/linux/blkpg.h	2012-07-10 21:03:57.072190639 -0400
@@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
 /* The subfunctions (for the op field) */
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
+#define BLKPG_RESIZE_PARTITION	3
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
Index: linux-2.6/include/linux/genhd.h
===================================================================
--- linux-2.6.orig/include/linux/genhd.h	2012-07-10 21:03:52.463190498 -0400
+++ linux-2.6/include/linux/genhd.h	2012-07-10 21:05:47.178194202 -0400
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
@@ -648,6 +654,57 @@ static inline void hd_struct_put(struct 
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
+#elif BITS_PER_LONG==32 && defined(CONFIG_LBDAF) && defined(CONFIG_PREEMPT)
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
