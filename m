Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0DOFpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:45:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab0DOFpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:45:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=uPopkpUb93KfwlJBTDO1jd7hOugTcuqB+Lcwz0+98yIGWPg2LZDr/2K0s8ccrV++W
	b+rks5tq4kxBva57q3uwg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 3/4] block: Add seek histograms to the block histograms
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, rickyb@google.com
Date: Wed, 14 Apr 2010 22:45:40 -0700
Message-ID: <20100415054515.15836.48899.stgit@austin.mtv.corp.google.com>
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

Signed-off-by: Divyesh Shah <dpshah@google.com>
From: Edward Falk <efalk@google.com>
---

 block/Kconfig         |    9 ++++
 block/genhd.c         |  103 +++++++++++++++++++++++++++++++++++++++++++------
 fs/partitions/check.c |    4 ++
 include/linux/genhd.h |   14 ++++++-
 4 files changed, 117 insertions(+), 13 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index b62fe49..5dbc10b 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -126,6 +126,15 @@ config HISTO_TIME_BUCKETS
 	  This option controls how many buckets are used to collect
 	  transfer time statistics.
 
+config HISTO_SEEK_BUCKETS
+	int "Number of seek buckets in histogram"
+	depends on BLOCK_HISTOGRAM
+	default "20"
+	---help---
+	  This option controls how many buckets are used to collect
+	  disk seek statistics. The actual number of buckets is 1 greater
+	  than the number specified here as the last bucket is a catch-all one.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
diff --git a/block/genhd.c b/block/genhd.c
index 3666cf2..8920994 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -890,6 +890,8 @@ static DEVICE_ATTR(write_request_histo, S_IRUGO | S_IWUSR,
 		part_write_request_histo_show, part_write_histo_clear);
 static DEVICE_ATTR(write_dma_histo, S_IRUGO | S_IWUSR,
 		part_write_dma_histo_show, part_write_histo_clear);
+static DEVICE_ATTR(seek_histo, S_IRUGO | S_IWUSR,
+		part_seek_histo_show, part_seek_histo_clear);
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -917,6 +919,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_read_dma_histo.attr,
 	&dev_attr_write_request_histo.attr,
 	&dev_attr_write_dma_histo.attr,
+	&dev_attr_seek_histo.attr,
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
@@ -1304,6 +1307,8 @@ int invalidate_partition(struct gendisk *disk, int partno)
 EXPORT_SYMBOL(invalidate_partition);
 
 #ifdef	CONFIG_BLOCK_HISTOGRAM
+typedef void (part_histo_reset) (struct disk_stats *, int);
+
 /*
  * Clear one per-cpu instance of a particular I/O histogram. This should always
  * be called between part_stat_lock() and part_stat_unklock() calls.
@@ -1317,23 +1322,27 @@ static inline void __block_part_histogram_reset(struct disk_stats *stats,
 		memset(&stats->wr_histo, 0, sizeof(stats->wr_histo));
 }
 
+static inline void __block_part_seek_histogram_reset(struct disk_stats *stats,
+							int dummy)
+{
+	memset(&stats->seek_histo, 0, sizeof(stats->seek_histo));
+}
+
 /*
  * Clear the I/O histogram for a given partition.
  */
-static void block_part_histogram_reset(struct hd_struct *part, int direction)
+static void block_part_histogram_reset(struct hd_struct *part,
+				part_histo_reset *reset_fn, int direction)
 {
 #ifdef	CONFIG_SMP
 	int i;
 
 	part_stat_lock();
-	for_each_possible_cpu(i) {
-		if (cpu_possible(i))
-			__block_part_histogram_reset(per_cpu_ptr(part->dkstats,
-								i), direction);
-	}
+	for_each_possible_cpu(i)
+		reset_fn(per_cpu_ptr(part->dkstats, i), direction);
 #else
 	part_stat_lock();
-	__block_part_histogram_reset(&part.dkstats, direction);
+	reset_fn(&part.dkstats, direction);
 #endif
 	part_stat_unlock();
 }
@@ -1342,7 +1351,8 @@ static void block_part_histogram_reset(struct hd_struct *part, int direction)
  * Iterate though all partitions of the disk and clear the specified
  * (read/write) histogram.
  */
-static int block_disk_histogram_reset(struct hd_struct *part, int direction)
+static int block_disk_histogram_reset(struct hd_struct *part,
+				part_histo_reset *reset_fn, int direction)
 {
 	struct disk_part_iter piter;
 	struct gendisk *disk = part_to_disk(part);
@@ -1353,11 +1363,16 @@ static int block_disk_histogram_reset(struct hd_struct *part, int direction)
 
 	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY_PART0);
 	while ((temp = disk_part_iter_next(&piter)))
-		block_part_histogram_reset(temp, direction);
+		block_part_histogram_reset(temp, reset_fn, direction);
 	disk_part_iter_exit(&piter);
 	return 0;
 }
 
+void init_part_histo_defaults(struct hd_struct *part)
+{
+	part->last_end_sector = part->start_sect;
+}
+
 /*
  * Map transfer size to histogram bucket. Transfer sizes are exponentially
  * increasing. For example: 4,8,16,... sectors.
@@ -1397,6 +1412,15 @@ static inline int stats_time_bucket(int jiffies)
 }
 
 /*
+ * Map seek distance to histogram bucket. This also uses an exponential
+ * increment : 8, 16, 32, ... sectors.
+ */
+static inline int stats_seek_bucket(sector_t distance)
+{
+	return min(fls64(distance >> 3), CONFIG_HISTO_SEEK_BUCKETS);
+}
+
+/*
  * Log I/O completion, update histogram.
  *
  * @part:	disk device partition
@@ -1407,11 +1431,20 @@ static inline int stats_time_bucket(int jiffies)
 static inline void __block_histogram_completion(int cpu, struct hd_struct *part,
 		struct request *req, unsigned int req_ms, unsigned int dma_ms)
 {
-	sector_t sectors = blk_rq_size(req);
+	sector_t sectors = blk_rq_size(req), end_sector = blk_rq_pos(req);
+	sector_t distance, start_sector = end_sector - sectors;
 	int size_idx = stats_size_bucket(sectors);
 	int req_time_idx = stats_time_bucket(req_ms);
 	int dma_time_idx = stats_time_bucket(dma_ms);
 
+	if (start_sector >= part->last_end_sector)
+		distance = start_sector - part->last_end_sector;
+	else
+		distance = part->last_end_sector - start_sector;
+
+	part_stat_inc(cpu, part, seek_histo[stats_seek_bucket(distance)]);
+	part->last_end_sector = end_sector;
+
 	if (!rq_data_dir(req))
 		part_stat_inc(cpu, part,
 			rd_histo[HISTO_REQUEST][size_idx][req_time_idx]);
@@ -1455,6 +1488,11 @@ static uint64_t histo_stat_read(struct hd_struct *part, int direction,
 			part_stat_read(part, wr_histo[i][j][k]);
 }
 
+static uint64_t seek_histo_stat_read(struct hd_struct *part, int i)
+{
+	return part_stat_read(part, seek_histo[i]);
+}
+
 /*
  * Dumps the specified 'type' of histogram for part to out.
  * The result must be less than PAGE_SIZE.
@@ -1508,6 +1546,28 @@ static int dump_histo(struct hd_struct *part, int direction, int type,
 }
 
 /*
+ * Dumps the seek histogram for part. The result must be less than PAGE_SIZE.
+ */
+static int dump_seek_histo(struct hd_struct *part, char* page)
+{
+	ssize_t rem = PAGE_SIZE;
+	char *optr = page;
+	int i, len;
+
+	for (i = 0; i < CONFIG_HISTO_SEEK_BUCKETS + 1; i++) {
+		if (i < CONFIG_HISTO_SEEK_BUCKETS)
+			len = snprintf(page, rem, "%ld\t%llu\n",
+				1UL << (i + 3), seek_histo_stat_read(part, i));
+		else
+			len = snprintf(page, rem, "inf\t%llu\n",
+					seek_histo_stat_read(part, i));
+		page += len;
+		rem -= len;
+	}
+	return page - optr;
+}
+
+/*
  * sysfs show() methods for the four histogram channels.
  */
 ssize_t part_read_request_histo_show(struct device *dev,
@@ -1534,6 +1594,12 @@ ssize_t part_write_dma_histo_show(struct device *dev,
 	return dump_histo(dev_to_part(dev), WRITE, HISTO_DMA, page);
 }
 
+ssize_t part_seek_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	return dump_seek_histo(dev_to_part(dev), page);
+}
+
 /*
  * Reinitializes the read histograms to 0.
  */
@@ -1541,7 +1607,8 @@ ssize_t part_read_histo_clear(struct device *dev,
 		struct device_attribute *attr, const char *page, size_t count)
 {
 	/* Ignore the data, just clear the histogram */
-	int retval = block_disk_histogram_reset(dev_to_part(dev), READ);
+	int retval = block_disk_histogram_reset(dev_to_part(dev),
+					__block_part_histogram_reset, READ);
 	return (retval == 0 ? count : retval);
 }
 
@@ -1551,7 +1618,19 @@ ssize_t part_read_histo_clear(struct device *dev,
 ssize_t part_write_histo_clear(struct device *dev,
 		struct device_attribute *attr, const char *page, size_t count)
 {
-	int retval = block_disk_histogram_reset(dev_to_part(dev), WRITE);
+	int retval = block_disk_histogram_reset(dev_to_part(dev),
+					__block_part_histogram_reset, WRITE);
+	return (retval == 0 ? count : retval);
+}
+
+/*
+ * Reinitializes the seek histograms to 0.
+ */
+ssize_t part_seek_histo_clear(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count)
+{
+	int retval = block_disk_histogram_reset(dev_to_part(dev),
+				__block_part_seek_histogram_reset, 0);
 	return (retval == 0 ? count : retval);
 }
 
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e0044d4..47e2591 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -309,6 +309,8 @@ static DEVICE_ATTR(write_request_histo, S_IRUGO | S_IWUSR,
 		part_write_request_histo_show, part_write_histo_clear);
 static DEVICE_ATTR(write_dma_histo, S_IRUGO | S_IWUSR,
 		part_write_dma_histo_show, part_write_histo_clear);
+static DEVICE_ATTR(seek_histo, S_IRUGO | S_IWUSR,
+		part_seek_histo_show, part_seek_histo_clear);
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -328,6 +330,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_read_dma_histo.attr,
 	&dev_attr_write_request_histo.attr,
 	&dev_attr_write_dma_histo.attr,
+	&dev_attr_seek_histo.attr,
 #endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
@@ -436,6 +439,7 @@ struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	p->nr_sects = len;
 	p->partno = partno;
 	p->policy = get_disk_ro(disk);
+	init_part_histo_defaults(p);
 
 	dname = dev_name(ddev);
 	if (isdigit(dname[strlen(dname) - 1]))
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7406533..746b36b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -101,7 +101,8 @@ struct disk_stats {
 	 * /sys/block/DEV/PART/read_request_histo,
 	 * /sys/block/DEV/PART/write_request_histo,
 	 * /sys/block/DEV/PART/read_dma_histo,
-	 * /sys/block/DEV/PART/write_dma_histo and the
+	 * /sys/block/DEV/PART/write_dma_histo,
+	 * /sysfs/block/DEV/PART/seek_histo and the
 	 * /sys/block/DEV counterparts.
 	 *
 	 * The *request_histo files measure time from when the request is first
@@ -110,6 +111,7 @@ struct disk_stats {
 	 */
 	uint64_t rd_histo[2][CONFIG_HISTO_SIZE_BUCKETS][CONFIG_HISTO_TIME_BUCKETS];
 	uint64_t wr_histo[2][CONFIG_HISTO_SIZE_BUCKETS][CONFIG_HISTO_TIME_BUCKETS];
+	uint64_t seek_histo[CONFIG_HISTO_SEEK_BUCKETS + 1];
 #endif
 };
 	
@@ -131,6 +133,9 @@ struct hd_struct {
 #else
 	struct disk_stats dkstats;
 #endif
+#ifdef CONFIG_BLOCK_HISTOGRAM
+	sector_t last_end_sector;
+#endif
 	struct rcu_head rcu_head;
 };
 
@@ -399,13 +404,20 @@ extern ssize_t part_write_dma_histo_show(struct device *dev,
 			struct device_attribute *attr, char *page);
 extern ssize_t part_write_dma_histo_show(struct device *dev,
 			struct device_attribute *attr, char *page);
+extern ssize_t part_seek_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page);
 extern ssize_t part_read_histo_clear(struct device *dev,
 		struct device_attribute *attr, const char *page, size_t count);
 extern ssize_t part_write_histo_clear(struct device *dev,
 		struct device_attribute *attr, const char *page, size_t count);
+extern ssize_t part_seek_histo_clear(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count);
+
+extern void init_part_histo_defaults(struct hd_struct *part);
 #else
 static inline void block_histogram_completion(int cpu, struct hd_struct *part,
 						struct request *req) {}
+static inline void init_part_histo_defaults(struct hd_struct *part) {}
 #endif
 
 /* drivers/char/random.c */

