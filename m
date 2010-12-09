Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab0LIP0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:26:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab0LIP0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:26:39 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
        adilger.kernel@dilger.ca, gregkh@suse.de, hch@infradead.org,
        axboe@kernel.dk, lczerner@redhat.com
Subject: [PATCH 1/2] blk-sysfs: Clean-up attribute definitions
Date: Thu,  9 Dec 2010 16:25:36 +0100
Message-Id: <1291908337-18805-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit simplifies block queue attribute definitions for sysfs
/sys/block/*/queue by introducing macros instead of defining each
structure of its own.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 block/blk-sysfs.c |  197 +++++++++++++++++------------------------------------
 1 files changed, 63 insertions(+), 134 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 013457f..8ba860e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -187,14 +187,14 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 
 #define QUEUE_SYSFS_BIT_FNS(name, flag, neg)				\
 static ssize_t								\
-queue_show_##name(struct request_queue *q, char *page)			\
+queue_##name##_show(struct request_queue *q, char *page)		\
 {									\
 	int bit;							\
 	bit = test_bit(QUEUE_FLAG_##flag, &q->queue_flags);		\
 	return queue_var_show(neg ? !bit : bit, page);			\
 }									\
 static ssize_t								\
-queue_store_##name(struct request_queue *q, const char *page, size_t count) \
+queue_##name##_store(struct request_queue *q, const char *page, size_t count) \
 {									\
 	unsigned long val;						\
 	ssize_t ret;							\
@@ -265,142 +265,71 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
-static struct queue_sysfs_entry queue_requests_entry = {
-	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_requests_show,
-	.store = queue_requests_store,
-};
-
-static struct queue_sysfs_entry queue_ra_entry = {
-	.attr = {.name = "read_ahead_kb", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_ra_show,
-	.store = queue_ra_store,
-};
-
-static struct queue_sysfs_entry queue_max_sectors_entry = {
-	.attr = {.name = "max_sectors_kb", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_max_sectors_show,
-	.store = queue_max_sectors_store,
-};
-
-static struct queue_sysfs_entry queue_max_hw_sectors_entry = {
-	.attr = {.name = "max_hw_sectors_kb", .mode = S_IRUGO },
-	.show = queue_max_hw_sectors_show,
-};
-
-static struct queue_sysfs_entry queue_max_segments_entry = {
-	.attr = {.name = "max_segments", .mode = S_IRUGO },
-	.show = queue_max_segments_show,
-};
-
-static struct queue_sysfs_entry queue_max_integrity_segments_entry = {
-	.attr = {.name = "max_integrity_segments", .mode = S_IRUGO },
-	.show = queue_max_integrity_segments_show,
-};
-
-static struct queue_sysfs_entry queue_max_segment_size_entry = {
-	.attr = {.name = "max_segment_size", .mode = S_IRUGO },
-	.show = queue_max_segment_size_show,
-};
-
-static struct queue_sysfs_entry queue_iosched_entry = {
-	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
-	.show = elv_iosched_show,
-	.store = elv_iosched_store,
-};
-
-static struct queue_sysfs_entry queue_hw_sector_size_entry = {
-	.attr = {.name = "hw_sector_size", .mode = S_IRUGO },
-	.show = queue_logical_block_size_show,
-};
-
-static struct queue_sysfs_entry queue_logical_block_size_entry = {
-	.attr = {.name = "logical_block_size", .mode = S_IRUGO },
-	.show = queue_logical_block_size_show,
-};
-
-static struct queue_sysfs_entry queue_physical_block_size_entry = {
-	.attr = {.name = "physical_block_size", .mode = S_IRUGO },
-	.show = queue_physical_block_size_show,
-};
-
-static struct queue_sysfs_entry queue_io_min_entry = {
-	.attr = {.name = "minimum_io_size", .mode = S_IRUGO },
-	.show = queue_io_min_show,
-};
-
-static struct queue_sysfs_entry queue_io_opt_entry = {
-	.attr = {.name = "optimal_io_size", .mode = S_IRUGO },
-	.show = queue_io_opt_show,
-};
-
-static struct queue_sysfs_entry queue_discard_granularity_entry = {
-	.attr = {.name = "discard_granularity", .mode = S_IRUGO },
-	.show = queue_discard_granularity_show,
-};
-
-static struct queue_sysfs_entry queue_discard_max_entry = {
-	.attr = {.name = "discard_max_bytes", .mode = S_IRUGO },
-	.show = queue_discard_max_show,
-};
-
-static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
-	.attr = {.name = "discard_zeroes_data", .mode = S_IRUGO },
-	.show = queue_discard_zeroes_data_show,
-};
-
-static struct queue_sysfs_entry queue_nonrot_entry = {
-	.attr = {.name = "rotational", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_show_nonrot,
-	.store = queue_store_nonrot,
-};
-
-static struct queue_sysfs_entry queue_nomerges_entry = {
-	.attr = {.name = "nomerges", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_nomerges_show,
-	.store = queue_nomerges_store,
-};
+#define queue_iosched_store		elv_iosched_store
+#define queue_iosched_show		elv_iosched_show
+#define queue_hw_sector_size_show	queue_logical_block_size_show
 
-static struct queue_sysfs_entry queue_rq_affinity_entry = {
-	.attr = {.name = "rq_affinity", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_rq_affinity_show,
-	.store = queue_rq_affinity_store,
-};
-
-static struct queue_sysfs_entry queue_iostats_entry = {
-	.attr = {.name = "iostats", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_show_iostats,
-	.store = queue_store_iostats,
-};
+#define QUEUE_ENTRY(_name,_mode,_show,_store)			\
+static struct queue_sysfs_entry queue_##_name##_entry = {	\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,					\
+	.store	= _store,					\
+}
 
-static struct queue_sysfs_entry queue_random_entry = {
-	.attr = {.name = "add_random", .mode = S_IRUGO | S_IWUSR },
-	.show = queue_show_random,
-	.store = queue_store_random,
-};
+#define QUEUE_RO_ENTRY(name)					\
+	QUEUE_ENTRY(name, S_IRUGO, queue_##name##_show, NULL)
+
+#define QUEUE_RW_ENTRY(name)					\
+	QUEUE_ENTRY(name, S_IRUGO | S_IWUSR,			\
+		    queue_##name##_show, queue_##name##_store)
+
+#define ATTR_LIST(name) &queue_##name##_entry.attr
+
+QUEUE_RO_ENTRY(max_hw_sectors);
+QUEUE_RO_ENTRY(max_segments);
+QUEUE_RO_ENTRY(max_integrity_segments);
+QUEUE_RO_ENTRY(max_segment_size);
+QUEUE_RO_ENTRY(hw_sector_size);
+QUEUE_RO_ENTRY(logical_block_size);
+QUEUE_RO_ENTRY(physical_block_size);
+QUEUE_RO_ENTRY(io_min);
+QUEUE_RO_ENTRY(io_opt);
+QUEUE_RO_ENTRY(discard_granularity);
+QUEUE_RO_ENTRY(discard_max);
+QUEUE_RO_ENTRY(discard_zeroes_data);
+
+QUEUE_RW_ENTRY(requests);
+QUEUE_RW_ENTRY(max_sectors);
+QUEUE_RW_ENTRY(ra);
+QUEUE_RW_ENTRY(iosched);
+QUEUE_RW_ENTRY(nonrot);
+QUEUE_RW_ENTRY(nomerges);
+QUEUE_RW_ENTRY(rq_affinity);
+QUEUE_RW_ENTRY(iostats);
+QUEUE_RW_ENTRY(random);
 
 static struct attribute *default_attrs[] = {
-	&queue_requests_entry.attr,
-	&queue_ra_entry.attr,
-	&queue_max_hw_sectors_entry.attr,
-	&queue_max_sectors_entry.attr,
-	&queue_max_segments_entry.attr,
-	&queue_max_integrity_segments_entry.attr,
-	&queue_max_segment_size_entry.attr,
-	&queue_iosched_entry.attr,
-	&queue_hw_sector_size_entry.attr,
-	&queue_logical_block_size_entry.attr,
-	&queue_physical_block_size_entry.attr,
-	&queue_io_min_entry.attr,
-	&queue_io_opt_entry.attr,
-	&queue_discard_granularity_entry.attr,
-	&queue_discard_max_entry.attr,
-	&queue_discard_zeroes_data_entry.attr,
-	&queue_nonrot_entry.attr,
-	&queue_nomerges_entry.attr,
-	&queue_rq_affinity_entry.attr,
-	&queue_iostats_entry.attr,
-	&queue_random_entry.attr,
+	ATTR_LIST(requests),
+	ATTR_LIST(ra),
+	ATTR_LIST(max_hw_sectors),
+	ATTR_LIST(max_sectors),
+	ATTR_LIST(max_segments),
+	ATTR_LIST(max_integrity_segments),
+	ATTR_LIST(max_segment_size),
+	ATTR_LIST(iosched),
+	ATTR_LIST(hw_sector_size),
+	ATTR_LIST(logical_block_size),
+	ATTR_LIST(physical_block_size),
+	ATTR_LIST(io_min),
+	ATTR_LIST(io_opt),
+	ATTR_LIST(discard_granularity),
+	ATTR_LIST(discard_max),
+	ATTR_LIST(discard_zeroes_data),
+	ATTR_LIST(nonrot),
+	ATTR_LIST(nomerges),
+	ATTR_LIST(rq_affinity),
+	ATTR_LIST(iostats),
+	ATTR_LIST(random),
 	NULL,
 };
 
-- 
1.7.2.3

