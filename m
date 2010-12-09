Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0LIP00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:26:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab0LIP0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:26:23 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
        adilger.kernel@dilger.ca, gregkh@suse.de, hch@infradead.org,
        axboe@kernel.dk, lczerner@redhat.com
Subject: [PATCH 2/2] Add BLKGETQUEUEINFO for reading block queue attributes
Date: Thu,  9 Dec 2010 16:25:37 +0100
Message-Id: <1291908337-18805-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a long time it has been pretty painful to retrieve informations from
/sys/block/*/queue for particular block device. Not only it is painful
to retrieve informations within C tool, parsing strings, etc, but one
have to run into problem even finding the proper path in sysfs.

This commit adds new block ioctl BLKGETQUEUEINFO, which is designed to
retrieve particular block queue attributes. I have tried to not to
create completely new interface, but since we already have those
information within block queue sysfs kobjects, rather retrieve it from
there.

So it binds enum blkq_info_type in include/linux/fs.h with
default_attrs[] definition within block/blk-sysfs.c for ordering
purposes, so the userspace has reliable way to address specific
block queue sysfs attribute.

In order to avoid string parsing (given that 99% of block queue sysfs
attributes are of unsigned long type) I have introduced new sysfs_ops
member *get which may be used to pass pointer to any type of data. Then
this get method is used to withdraw information through
kobject->ktype->sysfs_ops.

As an addition, macros for creating get and show methods are introduced
to simplify attribute definition.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 block/blk-sysfs.c     |  241 +++++++++++++++++++++++--------------------------
 block/ioctl.c         |   32 +++++++
 include/linux/fs.h    |   30 ++++++
 include/linux/sysfs.h |    1 +
 4 files changed, 178 insertions(+), 126 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8ba860e..e7f61b0 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -14,6 +14,7 @@ struct queue_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct request_queue *, char *);
 	ssize_t (*store)(struct request_queue *, const char *, size_t);
+	void (*get)(struct request_queue *, unsigned long *);
 };
 
 static ssize_t
@@ -31,11 +32,6 @@ queue_var_store(unsigned long *var, const char *page, size_t count)
 	return count;
 }
 
-static ssize_t queue_requests_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(q->nr_requests, (page));
-}
-
 static ssize_t
 queue_requests_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -81,14 +77,6 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
-static ssize_t queue_ra_show(struct request_queue *q, char *page)
-{
-	unsigned long ra_kb = q->backing_dev_info.ra_pages <<
-					(PAGE_CACHE_SHIFT - 10);
-
-	return queue_var_show(ra_kb, (page));
-}
-
 static ssize_t
 queue_ra_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -100,66 +88,6 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
-static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
-{
-	int max_sectors_kb = queue_max_sectors(q) >> 1;
-
-	return queue_var_show(max_sectors_kb, (page));
-}
-
-static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(queue_max_segments(q), (page));
-}
-
-static ssize_t queue_max_integrity_segments_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(q->limits.max_integrity_segments, (page));
-}
-
-static ssize_t queue_max_segment_size_show(struct request_queue *q, char *page)
-{
-	if (test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
-		return queue_var_show(queue_max_segment_size(q), (page));
-
-	return queue_var_show(PAGE_CACHE_SIZE, (page));
-}
-
-static ssize_t queue_logical_block_size_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(queue_logical_block_size(q), page);
-}
-
-static ssize_t queue_physical_block_size_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(queue_physical_block_size(q), page);
-}
-
-static ssize_t queue_io_min_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(queue_io_min(q), page);
-}
-
-static ssize_t queue_io_opt_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(queue_io_opt(q), page);
-}
-
-static ssize_t queue_discard_granularity_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(q->limits.discard_granularity, page);
-}
-
-static ssize_t queue_discard_max_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(q->limits.max_discard_sectors << 9, page);
-}
-
-static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *page)
-{
-	return queue_var_show(queue_discard_zeroes_data(q), page);
-}
-
 static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -178,20 +106,19 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
-static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
-{
-	int max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1;
-
-	return queue_var_show(max_hw_sectors_kb, (page));
-}
-
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
-static ssize_t								\
-queue_##name##_show(struct request_queue *q, char *page)		\
+static void								\
+queue_##name##_get(struct request_queue *q, unsigned long *data)	\
 {									\
 	int bit;							\
 	bit = test_bit(QUEUE_FLAG_##flag, &q->queue_flags);		\
-	return queue_var_show(neg ? !bit : bit, page);			\
+	*data = (neg ? !bit : bit);					\
+}									\
+static ssize_t								\
+queue_##name##_show(struct request_queue *q, char *page)		\
+{	unsigned long data;						\
+	queue_##name##_get(q, &data);					\
+	return queue_var_show(data, page);				\
 }									\
 static ssize_t								\
 queue_##name##_store(struct request_queue *q, const char *page, size_t count) \
@@ -216,12 +143,6 @@ QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
 
-static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
-{
-	return queue_var_show((blk_queue_nomerges(q) << 1) |
-			       blk_queue_noxmerges(q), page);
-}
-
 static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 				    size_t count)
 {
@@ -240,13 +161,6 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 	return ret;
 }
 
-static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
-{
-	bool set = test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags);
-
-	return queue_var_show(set, page);
-}
-
 static ssize_t
 queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -265,25 +179,74 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
-#define queue_iosched_store		elv_iosched_store
-#define queue_iosched_show		elv_iosched_show
-#define queue_hw_sector_size_show	queue_logical_block_size_show
+#define QUEUE_READ_DATA(name, expr)					\
+static void								\
+queue_##name##_get(struct request_queue *q, unsigned long *data)	\
+{									\
+	*data = expr;							\
+}									\
+static ssize_t								\
+queue_##name##_show(struct request_queue *q, char *page)		\
+{									\
+	unsigned long data;						\
+	queue_##name##_get(q, &data);					\
+	return queue_var_show(data, page);				\
+}
 
-#define QUEUE_ENTRY(_name,_mode,_show,_store)			\
+QUEUE_READ_DATA(requests, q->nr_requests);
+QUEUE_READ_DATA(ra, q->backing_dev_info.ra_pages << (PAGE_CACHE_SHIFT - 10));
+QUEUE_READ_DATA(max_sectors, queue_max_sectors(q) >> 1);
+QUEUE_READ_DATA(max_segments, queue_max_segments(q));
+QUEUE_READ_DATA(max_integrity_segments, q->limits.max_integrity_segments);
+QUEUE_READ_DATA(logical_block_size, queue_logical_block_size(q));
+QUEUE_READ_DATA(hw_sector_size, queue_logical_block_size(q));
+QUEUE_READ_DATA(physical_block_size, queue_physical_block_size(q));
+QUEUE_READ_DATA(io_min, queue_io_min(q));
+QUEUE_READ_DATA(io_opt, queue_io_opt(q));
+QUEUE_READ_DATA(discard_granularity, q->limits.discard_granularity);
+QUEUE_READ_DATA(discard_max, q->limits.max_discard_sectors << 9);
+QUEUE_READ_DATA(discard_zeroes_data, queue_discard_zeroes_data(q));
+QUEUE_READ_DATA(max_hw_sectors,queue_max_hw_sectors(q) >> 1);
+QUEUE_READ_DATA(nomerges,((blk_queue_nomerges(q) << 1) |
+			   blk_queue_noxmerges(q)));
+QUEUE_READ_DATA(rq_affinity, test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags));
+
+static void
+queue_max_segment_size_get(struct request_queue *q, unsigned long *data)
+{
+	if (test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags)) {
+		*data = queue_max_segment_size(q);
+		return;
+	}
+	*data = PAGE_CACHE_SIZE;
+}
+static ssize_t
+queue_max_segment_size_show(struct request_queue *q, char *page)
+{
+	unsigned long data;
+	queue_max_segment_size_get(q, &data);
+	return queue_var_show(data, page);
+}
+
+
+#define QUEUE_ENTRY(_name,_mode,_show,_store,_get)		\
 static struct queue_sysfs_entry queue_##_name##_entry = {	\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
+	.get = _get,						\
 }
 
 #define QUEUE_RO_ENTRY(name)					\
-	QUEUE_ENTRY(name, S_IRUGO, queue_##name##_show, NULL)
+	QUEUE_ENTRY(name, S_IRUGO, queue_##name##_show, NULL,	\
+		    queue_##name##_get)
 
 #define QUEUE_RW_ENTRY(name)					\
 	QUEUE_ENTRY(name, S_IRUGO | S_IWUSR,			\
-		    queue_##name##_show, queue_##name##_store)
+		    queue_##name##_show, queue_##name##_store,	\
+		    queue_##name##_get)
 
-#define ATTR_LIST(name) &queue_##name##_entry.attr
+#define ATTR_LIST(type, name) [type] = &queue_##name##_entry.attr
 
 QUEUE_RO_ENTRY(max_hw_sectors);
 QUEUE_RO_ENTRY(max_segments);
@@ -301,41 +264,66 @@ QUEUE_RO_ENTRY(discard_zeroes_data);
 QUEUE_RW_ENTRY(requests);
 QUEUE_RW_ENTRY(max_sectors);
 QUEUE_RW_ENTRY(ra);
-QUEUE_RW_ENTRY(iosched);
 QUEUE_RW_ENTRY(nonrot);
 QUEUE_RW_ENTRY(nomerges);
 QUEUE_RW_ENTRY(rq_affinity);
 QUEUE_RW_ENTRY(iostats);
 QUEUE_RW_ENTRY(random);
 
+/* elv_iosched_show does not return unsigned long, but char* */
+static struct queue_sysfs_entry queue_iosched_entry = {
+	.attr = {.name ="scheduler" , .mode = S_IRUGO | S_IWUSR },
+	.show	= elv_iosched_show,
+	.store	= elv_iosched_store,
+};
+
 static struct attribute *default_attrs[] = {
-	ATTR_LIST(requests),
-	ATTR_LIST(ra),
-	ATTR_LIST(max_hw_sectors),
-	ATTR_LIST(max_sectors),
-	ATTR_LIST(max_segments),
-	ATTR_LIST(max_integrity_segments),
-	ATTR_LIST(max_segment_size),
-	ATTR_LIST(iosched),
-	ATTR_LIST(hw_sector_size),
-	ATTR_LIST(logical_block_size),
-	ATTR_LIST(physical_block_size),
-	ATTR_LIST(io_min),
-	ATTR_LIST(io_opt),
-	ATTR_LIST(discard_granularity),
-	ATTR_LIST(discard_max),
-	ATTR_LIST(discard_zeroes_data),
-	ATTR_LIST(nonrot),
-	ATTR_LIST(nomerges),
-	ATTR_LIST(rq_affinity),
-	ATTR_LIST(iostats),
-	ATTR_LIST(random),
-	NULL,
+	ATTR_LIST(BLKQ_REQUESTS, requests),
+	ATTR_LIST(BLKQ_RA, ra),
+	ATTR_LIST(BLKQ_MAX_HW_SECTORS, max_hw_sectors),
+	ATTR_LIST(BLKQ_MAX_SECTORS, max_sectors),
+	ATTR_LIST(BLKQ_MAX_SEGMENTS, max_segments),
+	ATTR_LIST(BLKQ_MAX_INTEGRITY_SEGMENTS, max_integrity_segments),
+	ATTR_LIST(BLKQ_MAX_SEGMENT_SIZE, max_segment_size),
+	ATTR_LIST(BLKQ_HW_SECTOR_SIZE, hw_sector_size),
+	ATTR_LIST(BLKQ_LOGICAL_BLOCK_SIZE, logical_block_size),
+	ATTR_LIST(BLKQ_PHYSICAL_BLOCK_SIZE, physical_block_size),
+	ATTR_LIST(BLKQ_IO_MIN, io_min),
+	ATTR_LIST(BLKQ_IO_OPT, io_opt),
+	ATTR_LIST(BLKQ_DISCARD_GRANULARITY, discard_granularity),
+	ATTR_LIST(BLKQ_DISCARD_MAX, discard_max),
+	ATTR_LIST(BLKQ_DISCARD_ZEROES_DATA, discard_zeroes_data),
+	ATTR_LIST(BLKQ_NONROT, nonrot),
+	ATTR_LIST(BLKQ_NOMERGES, nomerges),
+	ATTR_LIST(BLKQ_RQ_AFFINITY, rq_affinity),
+	ATTR_LIST(BLKQ_IOSTATS, iostats),
+	ATTR_LIST(BLKQ_RANDOM, random),
+	ATTR_LIST(BLKQ_IOSCHED, iosched),
+	[BLKQ_END] = NULL,
 };
 
 #define to_queue(atr) container_of((atr), struct queue_sysfs_entry, attr)
 
 static ssize_t
+queue_attr_get(struct kobject *kobj, struct attribute *attr, void *data)
+{
+	struct queue_sysfs_entry *entry = to_queue(attr);
+	struct request_queue *q =
+		container_of(kobj, struct request_queue, kobj);
+
+	if (!entry->get)
+		return -EINVAL;
+	mutex_lock(&q->sysfs_lock);
+	if (test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)) {
+		mutex_unlock(&q->sysfs_lock);
+		return -ENOENT;
+	}
+	entry->get(q, (unsigned long *)data);
+	mutex_unlock(&q->sysfs_lock);
+	return 0;
+}
+
+static ssize_t
 queue_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
 {
 	struct queue_sysfs_entry *entry = to_queue(attr);
@@ -417,6 +405,7 @@ static void blk_release_queue(struct kobject *kobj)
 static const struct sysfs_ops queue_sysfs_ops = {
 	.show	= queue_attr_show,
 	.store	= queue_attr_store,
+	.get	= queue_attr_get,
 };
 
 struct kobj_type blk_queue_ktype = {
diff --git a/block/ioctl.c b/block/ioctl.c
index a9a302e..aadf2f25 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -229,6 +229,38 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 					 cmd == BLKSECDISCARD);
 	}
 
+	case BLKGETQUEUEINFO: {
+		struct kobject *kobj = &bdev_get_queue(bdev)->kobj;
+		const struct sysfs_ops *ops = kobj->ktype->sysfs_ops;
+		struct blk_queue_info bq_info;
+		struct attribute *attr;
+		int ret = 0;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+
+		if (copy_from_user(&bq_info, (void __user *)arg,
+				   sizeof(struct blk_queue_info)))
+			return -EFAULT;
+
+		if (bq_info.type > BLKQ_END || bq_info.type < 0)
+			return -EINVAL;
+
+		attr = kobj->ktype->default_attrs[bq_info.type];
+		if (!attr)
+			return -EINVAL;
+
+		ret = ops->get(kobj, attr, &bq_info.data);
+		if (ret)
+			return ret;
+
+		if (copy_to_user((struct blk_queue_info __user *)arg, &bq_info,
+					sizeof(struct blk_queue_info)))
+			ret = -EFAULT;
+
+		return ret;
+	}
+
 	case HDIO_GETGEO: {
 		struct hd_geometry geo;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c9e06cc..edd5440 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -52,6 +52,35 @@ struct inodes_stat_t {
 	int dummy[5];		/* padding for sysctl ABI compatibility */
 };
 
+enum blkq_info_type {
+	BLKQ_REQUESTS = 0,
+	BLKQ_RA,
+	BLKQ_MAX_HW_SECTORS,
+	BLKQ_MAX_SECTORS,
+	BLKQ_MAX_SEGMENTS,
+	BLKQ_MAX_INTEGRITY_SEGMENTS,
+	BLKQ_MAX_SEGMENT_SIZE,
+	BLKQ_IOSCHED,
+	BLKQ_HW_SECTOR_SIZE,
+	BLKQ_LOGICAL_BLOCK_SIZE,
+	BLKQ_PHYSICAL_BLOCK_SIZE,
+	BLKQ_IO_MIN,
+	BLKQ_IO_OPT,
+	BLKQ_DISCARD_GRANULARITY,
+	BLKQ_DISCARD_MAX,
+	BLKQ_DISCARD_ZEROES_DATA,
+	BLKQ_NONROT,
+	BLKQ_NOMERGES,
+	BLKQ_RQ_AFFINITY,
+	BLKQ_IOSTATS,
+	BLKQ_RANDOM,
+	BLKQ_END,		/* Last item = quantity of items */
+};
+
+struct blk_queue_info {
+	enum blkq_info_type type;
+	unsigned long data;
+};
 
 #define NR_FILE  8192	/* this can well be larger on a larger system */
 
@@ -318,6 +347,7 @@ struct inodes_stat_t {
 #define BLKPBSZGET _IO(0x12,123)
 #define BLKDISCARDZEROES _IO(0x12,124)
 #define BLKSECDISCARD _IO(0x12,125)
+#define BLKGETQUEUEINFO _IOWR(0x12,126,struct blk_queue_info)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 30b8815..71bd06c 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -112,6 +112,7 @@ struct bin_attribute {
 struct sysfs_ops {
 	ssize_t	(*show)(struct kobject *, struct attribute *,char *);
 	ssize_t	(*store)(struct kobject *,struct attribute *,const char *, size_t);
+	ssize_t	(*get)(struct kobject *, struct attribute *, void *);
 };
 
 struct sysfs_dirent;
-- 
1.7.2.3

