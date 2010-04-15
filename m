Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0DOFq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:46:58 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab0DOFq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:46:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LEdKJ5hEFhlkfV9i/Jdda6i4OwczF2ayuxv2NQsSPElyOhdMUDkhhAaTnLDi8J6wr
	KeR58MKk798HSfVG6tQ6g==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 4/4] block: Make base bucket for the histograms configurable
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, rickyb@google.com
Date: Wed, 14 Apr 2010 22:46:47 -0700
Message-ID: <20100415054545.15836.44360.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
References: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 block/genhd.c         |   87 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/partitions/check.c |    9 +++++
 include/linux/genhd.h |   19 +++++++++--
 3 files changed, 99 insertions(+), 16 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8920994..c2ba04b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -892,6 +892,12 @@ static DEVICE_ATTR(write_dma_histo, S_IRUGO | S_IWUSR,
 		part_write_dma_histo_show, part_write_histo_clear);
 static DEVICE_ATTR(seek_histo, S_IRUGO | S_IWUSR,
 		part_seek_histo_show, part_seek_histo_clear);
+static DEVICE_ATTR(base_histo_size, S_IRUGO | S_IWUSR,
+		part_base_histo_size_show, part_base_histo_size_write);
+static DEVICE_ATTR(base_histo_time, S_IRUGO | S_IWUSR,
+		part_base_histo_time_show, part_base_histo_time_write);
+static DEVICE_ATTR(base_histo_seek, S_IRUGO | S_IWUSR,
+		part_base_histo_seek_show, part_base_histo_seek_write);
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -920,6 +926,9 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_write_request_histo.attr,
 	&dev_attr_write_dma_histo.attr,
 	&dev_attr_seek_histo.attr,
+	&dev_attr_base_histo_size.attr,
+	&dev_attr_base_histo_time.attr,
+	&dev_attr_base_histo_seek.attr,
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
@@ -1206,6 +1215,7 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 			return NULL;
 		}
 		disk->part_tbl->part[0] = &disk->part0;
+		init_part_histo_defaults(&disk->part0);
 
 		disk->minors = minors;
 		rand_initialize_disk(disk);
@@ -1307,6 +1317,13 @@ int invalidate_partition(struct gendisk *disk, int partno)
 EXPORT_SYMBOL(invalidate_partition);
 
 #ifdef	CONFIG_BLOCK_HISTOGRAM
+/* Smallest transfer size identifiable (in sectors) by histograms. */
+static const int base_histo_size = 4;
+/* Smallest transfer time identifiable (in ms) by histograms. */
+static const int base_histo_time = 10;
+/* Smallest seek distance identifiable (in log base 2 sectors). */
+static const int base_histo_seek = 3;
+
 typedef void (part_histo_reset) (struct disk_stats *, int);
 
 /*
@@ -1371,18 +1388,22 @@ static int block_disk_histogram_reset(struct hd_struct *part,
 void init_part_histo_defaults(struct hd_struct *part)
 {
 	part->last_end_sector = part->start_sect;
+	part->base_histo_size = base_histo_size;
+	part->base_histo_time = base_histo_time;
+	part->base_histo_seek = base_histo_seek;
 }
 
 /*
  * Map transfer size to histogram bucket. Transfer sizes are exponentially
  * increasing. For example: 4,8,16,... sectors.
  */
-static inline int stats_size_bucket(sector_t sectors)
+static inline int stats_size_bucket(sector_t sectors, int base_histo_size)
 {
 	int i;
 	/* To make sure bucket for x bytes captures all IOs <= x bytes. */
 	--sectors;
-	do_div(sectors, BASE_HISTO_SIZE);
+	BUG_ON(!base_histo_size);
+	do_div(sectors, base_histo_size);
 	if (sectors >= (1 << (CONFIG_HISTO_SIZE_BUCKETS - 2)))
 		return CONFIG_HISTO_SIZE_BUCKETS - 1;
 
@@ -1395,11 +1416,11 @@ static inline int stats_size_bucket(sector_t sectors)
  * Map transfer time to histogram bucket. This also uses an exponential
  * increment, but we like the 1,2,5,10,20,50 progression.
  */
-static inline int stats_time_bucket(int jiffies)
+static inline int stats_time_bucket(int jiffies, int base_histo_time)
 {
 	int i;
 	int ms = msecs_to_jiffies(jiffies);
-	int t = BASE_HISTO_TIME;
+	int t = base_histo_time;
 
 	for (i = 0;; t *= 10) {
 		if (++i >= CONFIG_HISTO_TIME_BUCKETS || ms <= t)
@@ -1415,9 +1436,10 @@ static inline int stats_time_bucket(int jiffies)
  * Map seek distance to histogram bucket. This also uses an exponential
  * increment : 8, 16, 32, ... sectors.
  */
-static inline int stats_seek_bucket(sector_t distance)
+static inline int stats_seek_bucket(sector_t distance, int base_histo_seek)
 {
-	return min(fls64(distance >> 3), CONFIG_HISTO_SEEK_BUCKETS);
+	return min(fls64(distance >> base_histo_seek),
+			CONFIG_HISTO_SEEK_BUCKETS);
 }
 
 /*
@@ -1433,16 +1455,17 @@ static inline void __block_histogram_completion(int cpu, struct hd_struct *part,
 {
 	sector_t sectors = blk_rq_size(req), end_sector = blk_rq_pos(req);
 	sector_t distance, start_sector = end_sector - sectors;
-	int size_idx = stats_size_bucket(sectors);
-	int req_time_idx = stats_time_bucket(req_ms);
-	int dma_time_idx = stats_time_bucket(dma_ms);
+	int size_idx = stats_size_bucket(sectors, part->base_histo_size);
+	int req_time_idx = stats_time_bucket(req_ms, part->base_histo_time);
+	int dma_time_idx = stats_time_bucket(dma_ms, part->base_histo_time);
 
 	if (start_sector >= part->last_end_sector)
 		distance = start_sector - part->last_end_sector;
 	else
 		distance = part->last_end_sector - start_sector;
 
-	part_stat_inc(cpu, part, seek_histo[stats_seek_bucket(distance)]);
+	part_stat_inc(cpu, part, seek_histo[stats_seek_bucket(distance,
+						      part->base_histo_seek)]);
 	part->last_end_sector = end_sector;
 
 	if (!rq_data_dir(req))
@@ -1502,7 +1525,7 @@ static int dump_histo(struct hd_struct *part, int direction, int type,
 {
 	ssize_t	rem = PAGE_SIZE;
 	char *optr = page;
-	int i, j, len, ms, size = BASE_HISTO_SIZE * 512;
+	int i, j, len, ms, size = part->base_histo_size * 512;
 	static const int mults[3] = {1, 2, 5};
 
 	/*
@@ -1515,7 +1538,7 @@ static int dump_histo(struct hd_struct *part, int direction, int type,
 	len = snprintf(page, rem, "       ");
 	page += len;
 	rem -= len;
-	for (i = 0, ms = BASE_HISTO_TIME; i < CONFIG_HISTO_TIME_BUCKETS;
+	for (i = 0, ms = part->base_histo_time; i < CONFIG_HISTO_TIME_BUCKETS;
 		ms *= 10) {
 		for (j = 0; j < 3 && i < CONFIG_HISTO_TIME_BUCKETS; ++j, ++i) {
 			len = snprintf(page, rem, "\t%d", ms * mults[j]);
@@ -1557,7 +1580,8 @@ static int dump_seek_histo(struct hd_struct *part, char* page)
 	for (i = 0; i < CONFIG_HISTO_SEEK_BUCKETS + 1; i++) {
 		if (i < CONFIG_HISTO_SEEK_BUCKETS)
 			len = snprintf(page, rem, "%ld\t%llu\n",
-				1UL << (i + 3), seek_histo_stat_read(part, i));
+				1UL << (i + part->base_histo_seek),
+				seek_histo_stat_read(part, i));
 		else
 			len = snprintf(page, rem, "inf\t%llu\n",
 					seek_histo_stat_read(part, i));
@@ -1634,4 +1658,41 @@ ssize_t part_seek_histo_clear(struct device *dev,
 	return (retval == 0 ? count : retval);
 }
 
+#define SHOW_BASE_FUNCTION(__VAR)					\
+ssize_t part_##__VAR##_show(struct device *dev,				\
+			struct device_attribute *attr, char *page)	\
+{									\
+	struct hd_struct *part = dev_to_part(dev);			\
+									\
+	return sprintf(page, "%d\n", part->__VAR);			\
+}
+
+SHOW_BASE_FUNCTION(base_histo_size);
+SHOW_BASE_FUNCTION(base_histo_time);
+SHOW_BASE_FUNCTION(base_histo_seek);
+#undef SHOW_BASE_FUNCTION
+
+#define WRITE_BASE_FUNCTION(__VAR, MIN, reset_fn)			\
+ssize_t part_##__VAR##_write(struct device *dev,			\
+	struct device_attribute *attr, const char *page, size_t count)	\
+{									\
+	struct hd_struct *part = dev_to_part(dev);			\
+	char *p = (char *)page;						\
+	unsigned long __data;						\
+	int data, retval = strict_strtoul(p, 10, &__data);		\
+									\
+	if (retval)							\
+		return retval;						\
+	data = __data;							\
+	part->__VAR = max(data, MIN);					\
+	block_disk_histogram_reset(part, reset_fn, READ);		\
+	block_disk_histogram_reset(part, reset_fn, WRITE);		\
+	return count;							\
+}
+
+WRITE_BASE_FUNCTION(base_histo_size, 1, __block_part_histogram_reset);
+WRITE_BASE_FUNCTION(base_histo_time, 1, __block_part_histogram_reset);
+WRITE_BASE_FUNCTION(base_histo_seek, 1, __block_part_seek_histogram_reset);
+#undef WRITE_BASE_FUNCTION
+
 #endif
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 47e2591..ddc0262 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -311,6 +311,12 @@ static DEVICE_ATTR(write_dma_histo, S_IRUGO | S_IWUSR,
 		part_write_dma_histo_show, part_write_histo_clear);
 static DEVICE_ATTR(seek_histo, S_IRUGO | S_IWUSR,
 		part_seek_histo_show, part_seek_histo_clear);
+static DEVICE_ATTR(base_histo_size, S_IRUGO | S_IWUSR,
+		part_base_histo_size_show, part_base_histo_size_write);
+static DEVICE_ATTR(base_histo_time, S_IRUGO | S_IWUSR,
+		part_base_histo_time_show, part_base_histo_time_write);
+static DEVICE_ATTR(base_histo_seek, S_IRUGO | S_IWUSR,
+		part_base_histo_seek_show, part_base_histo_seek_write);
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -331,6 +337,9 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_write_request_histo.attr,
 	&dev_attr_write_dma_histo.attr,
 	&dev_attr_seek_histo.attr,
+	&dev_attr_base_histo_size.attr,
+	&dev_attr_base_histo_time.attr,
+	&dev_attr_base_histo_seek.attr,
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 746b36b..b64d983 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -80,9 +80,6 @@ struct partition {
 	__le32 nr_sects;		/* nr of sectors in partition */
 } __attribute__((packed));
 
-#define	BASE_HISTO_SIZE		4	/* smallest transfer size, sectors */
-#define	BASE_HISTO_TIME		10	/* shortest transfer time, ms */
-
 /* Index into the histo arrays */
 #define HISTO_REQUEST   0
 #define HISTO_DMA       1
@@ -135,6 +132,9 @@ struct hd_struct {
 #endif
 #ifdef CONFIG_BLOCK_HISTOGRAM
 	sector_t last_end_sector;
+	int base_histo_size;
+	int base_histo_time;
+	int base_histo_seek;
 #endif
 	struct rcu_head rcu_head;
 };
@@ -414,6 +414,19 @@ extern ssize_t part_seek_histo_clear(struct device *dev,
 		struct device_attribute *attr, const char *page, size_t count);
 
 extern void init_part_histo_defaults(struct hd_struct *part);
+
+extern ssize_t part_base_histo_size_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_base_histo_time_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_base_histo_seek_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_base_histo_size_write(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count);
+extern ssize_t part_base_histo_time_write(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count);
+extern ssize_t part_base_histo_seek_write(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count);
 #else
 static inline void block_histogram_completion(int cpu, struct hd_struct *part,
 						struct request *req) {}

