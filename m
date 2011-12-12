Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1LLRnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:43:35 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:21425 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1LLRnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:43:33 -0500
X-Authority-Analysis: v=2.0 cv=KapQQHkD c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=xe8BsctaAAAA:8 a=ucpdzKScsDtkka9Rqp4A:9 a=HfWwDtX00zqu_a88NxUA:7 a=wPNLvfGTeEIA:10 a=4xiMoyYyJz-rYouK:21 a=XkZGqeEr2yZc1uvt:21 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EE63D43.50706@cfl.rr.com>
Date: Mon, 12 Dec 2011 12:43:31 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <cover.1322709471.git.psusi@cfl.rr.com> <4ED6F320.5060709@cfl.rr.com> <20111208123038.GA16493@nb.redhat.com> <4EE0C814.2000807@cfl.rr.com> <20111208151650.GB16934@nb.redhat.com> <4EE0D6E6.9000807@cfl.rr.com> <20111208155844.GA9281@redhat.com> <4EE0E085.8000907@cfl.rr.com> <20111208162847.GB9281@redhat.com> <4EE17815.6050806@cfl.rr.com> <20111212145330.GB29180@redhat.com>
In-Reply-To: <20111212145330.GB29180@redhat.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/12/2011 09:53 AM, Vivek Goyal wrote:
> Can you please inline the patch so that reviewing becomes easier. Right
> now it is an attachment.

Hrm... it shows up inline for me.  I guess I'll copy/paste this time.


> - I think during copy/paste tabs have been replaced by spaces at places.
> - You have retained function extend_partition() from my patch. I think you
>   are not using it.

Woops, fixed.

> - Can we rename BLKPG_RES_PARTITION to BLKPG_RESIZE_PARTITION. It is
>   easier to read.

BLKPG_DELETE_PARTITION is also easier to read, but the existing code went with DEL.  I prefer to stay consistent with the existing code and also use a 3 letter name.

- From de3a303233515b89c4d18869daca1bd5e6775895 Mon Sep 17 00:00:00 2001
From: Phillip Susi <psusi@cfl.rr.com>
Date: Mon, 12 Dec 2011 12:33:36 -0500
Subject: [PATCH] Add partition resize function to BLKPG ioctl

Add a new operation code ( BLKPG_RES_PARTITION ) to the
BLKPG ioctl that allows altering the size of an existing
partition, even if it is currently in use.

Thanks to Vivek Goyal for the seq counter idea.
- ---
 block/genhd.c         |   10 ++++----
 block/ioctl.c         |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/partitions/check.c |   39 ++++++++++++++++++++++++++++++++++++-
 include/linux/blkpg.h |    1 +
 include/linux/genhd.h |    7 ++++++
 5 files changed, 100 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 02e9fca..b34fb90 100644
- --- a/block/genhd.c
+++ b/block/genhd.c
@@ -154,7 +154,7 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
- -		if (!part->nr_sects &&
+		if (!part_nr_sects_read(part) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY) &&
 		    !(piter->flags & DISK_PITER_INCL_EMPTY_PART0 &&
 		      piter->idx == 0))
@@ -191,7 +191,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_exit);
 static inline int sector_in_part(struct hd_struct *part, sector_t sector)
 {
 	return part->start_sect <= sector &&
- -		sector < part->start_sect + part->nr_sects;
+		sector < part->start_sect + part_nr_sects_read(part);
 }
 
 /**
@@ -766,8 +766,8 @@ void __init printk_all_partitions(void)
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
- -			       (unsigned long long)part->nr_sects >> 1,
- -			       disk_name(disk, part->partno, name_buf), uuid);
+			       (unsigned long long)part_nr_sects_read(part) >> 1
+			       , disk_name(disk, part->partno, name_buf), uuid);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
@@ -858,7 +858,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
- -			   (unsigned long long)part->nr_sects >> 1,
+			   (unsigned long long)part_nr_sects_read(part) >> 1,
 			   disk_name(sgp, part->partno, buf));
 	disk_part_iter_exit(&piter);
 
diff --git a/block/ioctl.c b/block/ioctl.c
index ca939fc..f97e6a4 100644
- --- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -36,8 +36,8 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 		case BLKPG_ADD_PARTITION:
 			start = p.start >> 9;
 			length = p.length >> 9;
- -			/* check for fit in a hd_struct */ 
- -			if (sizeof(sector_t) == sizeof(long) && 
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) == sizeof(long) &&
 			    sizeof(long long) > sizeof(long)) {
 				long pstart = start, plength = length;
 				if (pstart != start || plength != length
@@ -92,6 +92,53 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			bdput(bdevp);
 
 			return 0;
+		case BLKPG_RES_PARTITION:
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
+
+			mutex_lock(&bdev->bd_mutex);
+
+			/* overlap? */
+			disk_part_iter_init(&piter, disk,
+					    DISK_PITER_INCL_EMPTY);
+			while ((part = disk_part_iter_next(&piter))) {
+				if (part->partno != partno && !(start + length <= part->start_sect ||
+				      start >= part->start_sect + part->nr_sects)) {
+					disk_part_iter_exit(&piter);
+					mutex_unlock(&bdev->bd_mutex);
+					return -EBUSY;
+				}
+			}
+			disk_part_iter_exit(&piter);
+			part = disk_get_part(disk, partno);
+			if (!part)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				return -ENXIO;
+			}
+			if (start != part->start_sect)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				disk_put_part(part);
+				return -EINVAL;
+			}
+			part->nr_sects = length;
+			bdevp = bdget(part_devt(part));
+			mutex_lock(&bdevp->bd_mutex);
+			i_size_write(bdevp->bd_inode, p.length);
+			mutex_unlock(&bdevp->bd_mutex);
+			bdput(bdevp);
+			disk_put_part(part);
+			mutex_unlock(&bdev->bd_mutex);
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e3c63d1..089e4bc 100644
- --- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -234,7 +234,7 @@ ssize_t part_size_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
- -	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
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
index faf8a45..103da38 100644
- --- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
 /* The subfunctions (for the op field) */
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
+#define BLKPG_RES_PARTITION	3
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6d18f35..a55ce2c 100644
- --- a/include/linux/genhd.h
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
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7mPT4ACgkQJ4UciIs+XuJs4QCfS4zI3KeVsI1trJ/135mZMz6F
6J8AnRy1hH++V32jUgait02EYeHfuI+c
=6guc
-----END PGP SIGNATURE-----
