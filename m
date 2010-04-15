Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136Ab0DOFpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:45:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:4078 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0DOFpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:45:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=QsMVzHwrTk+LtKDtJZuUYHSMLUOisHqqIl+AB2p1e9PW16RGjx4YkBYk6dBXZmzgv
	tN8nItIx3o2+jpUVY+KMg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 2/4] block: Add disk performance histograms which can be read
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, rickyb@google.com
Date: Wed, 14 Apr 2010 22:45:10 -0700
Message-ID: <20100415054436.15836.84971.stgit@austin.mtv.corp.google.com>
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

from sysfs and cleared upon writing.

Signed-off-by: Divyesh Shah <dpshah@google.com>
From: Edward Falk <efalk@google.com>
---

 block/Kconfig          |   26 +++++
 block/blk-core.c       |    1 
 block/genhd.c          |  270 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/partitions/check.c  |   16 +++
 include/linux/blkdev.h |    4 -
 include/linux/genhd.h  |   48 +++++++++
 include/linux/time.h   |    5 +
 7 files changed, 368 insertions(+), 2 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index f9e89f4..b62fe49 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -100,6 +100,32 @@ config DEBUG_BLK_CGROUP
 	in the blk group which can be used by cfq for tracing various
 	group related activity.
 
+config BLOCK_HISTOGRAM
+	bool "Performance histogram data"
+	default n
+	---help---
+	  This option causes block devices to collect statistics on transfer
+	  sizes and times. Useful for performance-tuning a system. Creates
+	  entries in /sysfs/block/.
+
+	  If you are unsure, say N here.
+
+config HISTO_SIZE_BUCKETS
+	int "Number of size buckets in histogram"
+	depends on BLOCK_HISTOGRAM
+	default "10"
+	---help---
+	  This option controls how many buckets are used to collect
+	  transfer size statistics.
+
+config HISTO_TIME_BUCKETS
+	int "Number of time buckets in histogram"
+	depends on BLOCK_HISTOGRAM
+	default "11"
+	---help---
+	  This option controls how many buckets are used to collect
+	  transfer time statistics.
+
 endif # BLOCK
 
 config BLOCK_COMPAT
diff --git a/block/blk-core.c b/block/blk-core.c
index f18e7b7..6432b14 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1744,6 +1744,7 @@ static void blk_account_io_done(struct request *req)
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
 		part_round_stats(cpu, part);
+		block_histogram_completion(cpu, part, req);
 		part_dec_in_flight(part, rw);
 
 		part_stat_unlock();
diff --git a/block/genhd.c b/block/genhd.c
index d13ba76..3666cf2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -881,6 +881,16 @@ static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+#ifdef	CONFIG_BLOCK_HISTOGRAM
+static DEVICE_ATTR(read_request_histo, S_IRUGO | S_IWUSR,
+		part_read_request_histo_show, part_read_histo_clear);
+static DEVICE_ATTR(read_dma_histo, S_IRUGO | S_IWUSR, part_read_dma_histo_show,
+		part_read_histo_clear);
+static DEVICE_ATTR(write_request_histo, S_IRUGO | S_IWUSR,
+		part_write_request_histo_show, part_write_histo_clear);
+static DEVICE_ATTR(write_dma_histo, S_IRUGO | S_IWUSR,
+		part_write_dma_histo_show, part_write_histo_clear);
+#endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -902,6 +912,12 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+#ifdef CONFIG_BLOCK_HISTOGRAM
+	&dev_attr_read_request_histo.attr,
+	&dev_attr_read_dma_histo.attr,
+	&dev_attr_write_request_histo.attr,
+	&dev_attr_write_dma_histo.attr,
+#endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
@@ -1286,3 +1302,257 @@ int invalidate_partition(struct gendisk *disk, int partno)
 }
 
 EXPORT_SYMBOL(invalidate_partition);
+
+#ifdef	CONFIG_BLOCK_HISTOGRAM
+/*
+ * Clear one per-cpu instance of a particular I/O histogram. This should always
+ * be called between part_stat_lock() and part_stat_unklock() calls.
+ */
+static inline void __block_part_histogram_reset(struct disk_stats *stats,
+						int direction)
+{
+	if (direction == READ)
+		memset(&stats->rd_histo, 0, sizeof(stats->rd_histo));
+	else
+		memset(&stats->wr_histo, 0, sizeof(stats->wr_histo));
+}
+
+/*
+ * Clear the I/O histogram for a given partition.
+ */
+static void block_part_histogram_reset(struct hd_struct *part, int direction)
+{
+#ifdef	CONFIG_SMP
+	int i;
+
+	part_stat_lock();
+	for_each_possible_cpu(i) {
+		if (cpu_possible(i))
+			__block_part_histogram_reset(per_cpu_ptr(part->dkstats,
+								i), direction);
+	}
+#else
+	part_stat_lock();
+	__block_part_histogram_reset(&part.dkstats, direction);
+#endif
+	part_stat_unlock();
+}
+
+/*
+ * Iterate though all partitions of the disk and clear the specified
+ * (read/write) histogram.
+ */
+static int block_disk_histogram_reset(struct hd_struct *part, int direction)
+{
+	struct disk_part_iter piter;
+	struct gendisk *disk = part_to_disk(part);
+	struct hd_struct *temp;
+
+	if (!disk)
+		return -ENODEV;
+
+	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY_PART0);
+	while ((temp = disk_part_iter_next(&piter)))
+		block_part_histogram_reset(temp, direction);
+	disk_part_iter_exit(&piter);
+	return 0;
+}
+
+/*
+ * Map transfer size to histogram bucket. Transfer sizes are exponentially
+ * increasing. For example: 4,8,16,... sectors.
+ */
+static inline int stats_size_bucket(sector_t sectors)
+{
+	int i;
+	/* To make sure bucket for x bytes captures all IOs <= x bytes. */
+	--sectors;
+	do_div(sectors, BASE_HISTO_SIZE);
+	if (sectors >= (1 << (CONFIG_HISTO_SIZE_BUCKETS - 2)))
+		return CONFIG_HISTO_SIZE_BUCKETS - 1;
+
+	for (i = 0; sectors > 0; ++i, sectors /= 2)
+		;
+	return i;
+}
+
+/*
+ * Map transfer time to histogram bucket. This also uses an exponential
+ * increment, but we like the 1,2,5,10,20,50 progression.
+ */
+static inline int stats_time_bucket(int jiffies)
+{
+	int i;
+	int ms = msecs_to_jiffies(jiffies);
+	int t = BASE_HISTO_TIME;
+
+	for (i = 0;; t *= 10) {
+		if (++i >= CONFIG_HISTO_TIME_BUCKETS || ms <= t)
+			return i - 1;
+		if (++i >= CONFIG_HISTO_TIME_BUCKETS || ms <= t*2)
+			return i - 1;
+		if (++i >= CONFIG_HISTO_TIME_BUCKETS || ms <= t*5)
+			return i - 1;
+	}
+}
+
+/*
+ * Log I/O completion, update histogram.
+ *
+ * @part:	disk device partition
+ * @req:	pointer to request
+ * @req_ms:	time transfer required
+ * @dma_ms:	time dma required
+ */
+static inline void __block_histogram_completion(int cpu, struct hd_struct *part,
+		struct request *req, unsigned int req_ms, unsigned int dma_ms)
+{
+	sector_t sectors = blk_rq_size(req);
+	int size_idx = stats_size_bucket(sectors);
+	int req_time_idx = stats_time_bucket(req_ms);
+	int dma_time_idx = stats_time_bucket(dma_ms);
+
+	if (!rq_data_dir(req))
+		part_stat_inc(cpu, part,
+			rd_histo[HISTO_REQUEST][size_idx][req_time_idx]);
+	else
+		part_stat_inc(cpu, part,
+			wr_histo[HISTO_REQUEST][size_idx][req_time_idx]);
+
+	if (!rq_data_dir(req))
+		part_stat_inc(cpu, part,
+			rd_histo[HISTO_DMA][size_idx][dma_time_idx]);
+	else
+		part_stat_inc(cpu, part,
+			wr_histo[HISTO_DMA][size_idx][dma_time_idx]);
+}
+
+/*
+ * Called after a dma interrupt. Should be called between part_stat_lock()
+ * and part_stat_unlock() calls.
+ * Note that for block devices with queue_depth > 1, the io_elapsed will not be
+ * accurate as it may include time spent in the disk queue due to re-ordering of
+ * requests by the disk.
+ */
+void block_histogram_completion(int cpu, struct hd_struct *part,
+		struct request *req)
+{
+	unsigned long long now = sched_clock();
+	uint64_t rq_elapsed = 0, io_elapsed = 0;
+
+	if (time_after64(now, rq_start_time_ns(req)))
+		rq_elapsed = now - rq_start_time_ns(req);
+	if (time_after64(now, rq_io_start_time_ns(req)))
+		io_elapsed = now - rq_io_start_time_ns(req);
+	__block_histogram_completion(cpu, part, req, nsecs_to_msecs(rq_elapsed),
+					nsecs_to_msecs(io_elapsed));
+}
+
+static uint64_t histo_stat_read(struct hd_struct *part, int direction,
+				int i, int j, int k)
+{
+	return (direction == READ) ? part_stat_read(part, rd_histo[i][j][k]) :
+			part_stat_read(part, wr_histo[i][j][k]);
+}
+
+/*
+ * Dumps the specified 'type' of histogram for part to out.
+ * The result must be less than PAGE_SIZE.
+ */
+static int dump_histo(struct hd_struct *part, int direction, int type,
+			char *page)
+{
+	ssize_t	rem = PAGE_SIZE;
+	char *optr = page;
+	int i, j, len, ms, size = BASE_HISTO_SIZE * 512;
+	static const int mults[3] = {1, 2, 5};
+
+	/*
+	 * Documentation/filesystems/sysfs.txt strongly discourages the use of
+	 * any kind of fancy formatting here. We *are* emitting an array, so
+	 * there needs to be some amount of formatting.
+	 */
+
+	/* Row header */
+	len = snprintf(page, rem, "       ");
+	page += len;
+	rem -= len;
+	for (i = 0, ms = BASE_HISTO_TIME; i < CONFIG_HISTO_TIME_BUCKETS;
+		ms *= 10) {
+		for (j = 0; j < 3 && i < CONFIG_HISTO_TIME_BUCKETS; ++j, ++i) {
+			len = snprintf(page, rem, "\t%d", ms * mults[j]);
+			page += len;
+			rem -= len;
+		}
+	}
+	len = snprintf(page, rem, "\n");
+	page += len;
+	rem -= len;
+
+	/* Payload */
+	for (i = 0; i < CONFIG_HISTO_SIZE_BUCKETS; i++, size *= 2) {
+		len = snprintf(page, rem, "%7d", size);
+		page += len;
+		rem -= len;
+		for (j = 0; j < CONFIG_HISTO_TIME_BUCKETS; j++) {
+			len = snprintf(page, rem, "\t%llu",
+				histo_stat_read(part, direction, type, i, j));
+			page += len;
+			rem -= len;
+		}
+		len = snprintf(page, rem, "\n");
+		page += len;
+		rem -= len;
+	}
+	return page - optr;
+}
+
+/*
+ * sysfs show() methods for the four histogram channels.
+ */
+ssize_t part_read_request_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	return dump_histo(dev_to_part(dev), READ, HISTO_REQUEST, page);
+}
+
+ssize_t part_read_dma_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	return dump_histo(dev_to_part(dev), READ, HISTO_DMA, page);
+}
+
+ssize_t part_write_request_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	return dump_histo(dev_to_part(dev), WRITE, HISTO_REQUEST, page);
+}
+
+ssize_t part_write_dma_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page)
+{
+	return dump_histo(dev_to_part(dev), WRITE, HISTO_DMA, page);
+}
+
+/*
+ * Reinitializes the read histograms to 0.
+ */
+ssize_t part_read_histo_clear(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count)
+{
+	/* Ignore the data, just clear the histogram */
+	int retval = block_disk_histogram_reset(dev_to_part(dev), READ);
+	return (retval == 0 ? count : retval);
+}
+
+/*
+ * Reinitializes the write histograms to 0.
+ */
+ssize_t part_write_histo_clear(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count)
+{
+	int retval = block_disk_histogram_reset(dev_to_part(dev), WRITE);
+	return (retval == 0 ? count : retval);
+}
+
+#endif
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..e0044d4 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -300,6 +300,16 @@ static DEVICE_ATTR(discard_alignment, S_IRUGO, part_discard_alignment_show,
 		   NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
+#ifdef CONFIG_BLOCK_HISTOGRAM
+static DEVICE_ATTR(read_request_histo, S_IRUGO | S_IWUSR,
+		part_read_request_histo_show, part_read_histo_clear);
+static DEVICE_ATTR(read_dma_histo, S_IRUGO | S_IWUSR, part_read_dma_histo_show,
+		part_read_histo_clear);
+static DEVICE_ATTR(write_request_histo, S_IRUGO | S_IWUSR,
+		part_write_request_histo_show, part_write_histo_clear);
+static DEVICE_ATTR(write_dma_histo, S_IRUGO | S_IWUSR,
+		part_write_dma_histo_show, part_write_histo_clear);
+#endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -313,6 +323,12 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_stat.attr,
 	&dev_attr_inflight.attr,
+#ifdef CONFIG_BLOCK_HISTOGRAM
+	&dev_attr_read_request_histo.attr,
+	&dev_attr_read_dma_histo.attr,
+	&dev_attr_write_request_histo.attr,
+	&dev_attr_write_dma_histo.attr,
+#endif
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4cc2cdf..2e5e083 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -195,7 +195,7 @@ struct request {
 
 	struct gendisk *rq_disk;
 	unsigned long start_time;
-#ifdef CONFIG_BLK_CGROUP
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLOCK_HISTOGRAM)
 	unsigned long long start_time_ns;
 	unsigned long long io_start_time_ns;    /* when passed to hardware */
 #endif
@@ -1206,7 +1206,7 @@ static inline void put_dev_sector(Sector p)
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
 
-#ifdef CONFIG_BLK_CGROUP
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLOCK_HISTOGRAM)
 static inline void set_start_time_ns(struct request *req)
 {
 	req->start_time_ns = sched_clock();
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5f2f4c4..7406533 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -65,6 +65,8 @@ enum {
 #include <linux/fs.h>
 #include <linux/workqueue.h>
 
+struct request;
+
 struct partition {
 	unsigned char boot_ind;		/* 0x80 - active */
 	unsigned char head;		/* starting head */
@@ -78,6 +80,13 @@ struct partition {
 	__le32 nr_sects;		/* nr of sectors in partition */
 } __attribute__((packed));
 
+#define	BASE_HISTO_SIZE		4	/* smallest transfer size, sectors */
+#define	BASE_HISTO_TIME		10	/* shortest transfer time, ms */
+
+/* Index into the histo arrays */
+#define HISTO_REQUEST   0
+#define HISTO_DMA       1
+
 struct disk_stats {
 	unsigned long sectors[2];	/* READs and WRITEs */
 	unsigned long ios[2];
@@ -85,6 +94,23 @@ struct disk_stats {
 	unsigned long ticks[2];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+#ifdef CONFIG_BLOCK_HISTOGRAM
+	/*
+	 * Implement 2-variable histograms, with transfers tracked by transfer
+	 * size and completion time. The sysfs files are
+	 * /sys/block/DEV/PART/read_request_histo,
+	 * /sys/block/DEV/PART/write_request_histo,
+	 * /sys/block/DEV/PART/read_dma_histo,
+	 * /sys/block/DEV/PART/write_dma_histo and the
+	 * /sys/block/DEV counterparts.
+	 *
+	 * The *request_histo files measure time from when the request is first
+	 * submitted into the reuqest queue.  The *dma_histo files measure time
+	 * from when the request is dispatched from the queue to the device.
+	 */
+	uint64_t rd_histo[2][CONFIG_HISTO_SIZE_BUCKETS][CONFIG_HISTO_TIME_BUCKETS];
+	uint64_t wr_histo[2][CONFIG_HISTO_SIZE_BUCKETS][CONFIG_HISTO_TIME_BUCKETS];
+#endif
 };
 	
 struct hd_struct {
@@ -360,6 +386,28 @@ static inline int get_disk_ro(struct gendisk *disk)
 	return disk->part0.policy;
 }
 
+#ifdef	CONFIG_BLOCK_HISTOGRAM
+extern void block_histogram_completion(int cpu, struct hd_struct *part,
+					struct request *req);
+extern ssize_t part_read_request_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_read_dma_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_write_request_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_write_dma_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_write_dma_histo_show(struct device *dev,
+			struct device_attribute *attr, char *page);
+extern ssize_t part_read_histo_clear(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count);
+extern ssize_t part_write_histo_clear(struct device *dev,
+		struct device_attribute *attr, const char *page, size_t count);
+#else
+static inline void block_histogram_completion(int cpu, struct hd_struct *part,
+						struct request *req) {}
+#endif
+
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk);
 extern void rand_initialize_disk(struct gendisk *disk);
diff --git a/include/linux/time.h b/include/linux/time.h
index 6e026e4..fa1b9de 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -42,6 +42,11 @@ extern struct timezone sys_tz;
 
 #define TIME_T_MAX	(time_t)((1UL << ((sizeof(time_t) << 3) - 1)) - 1)
 
+static inline unsigned int nsecs_to_msecs(uint64_t ns)
+{
+	return ns / NSEC_PER_MSEC;
+}
+
 static inline int timespec_equal(const struct timespec *a,
                                  const struct timespec *b)
 {

