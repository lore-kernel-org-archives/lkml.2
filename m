Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab0DFDi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:38:26 -0400
Received: from smtp-out.google.com ([74.125.121.35]:32778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0DFDiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:38:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=W28cUeb1VWjtkfUI6XOBDxHIA0jzj2KsGiCGpdVXZj86l9jmj3ZF1j0qVEoKeFp0l
	+nNJM0vxrTq7dGudlkpPg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 3/3][v3] blkio: Increment the blkio cgroup stats for real now.
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Mon, 05 Apr 2010 20:37:38 -0700
Message-ID: <20100406033706.23464.76477.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100406032630.23464.24685.stgit@austin.mtv.corp.google.com>
References: <20100406032630.23464.24685.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We also add start_time_ns and io_start_time_ns fields to struct request
here to record the time when a request is created and when it is
dispatched to device. We use ns uints here as ms and jiffies are
not very useful for non-rotational media.

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 block/blk-cgroup.c     |   58 ++++++++++++++++++++++++++++++++++++++++++++++--
 block/blk-cgroup.h     |   15 ++++++++++--
 block/blk-core.c       |    6 +++--
 block/cfq-iosched.c    |    7 +++++-
 include/linux/blkdev.h |   38 +++++++++++++++++++++++++++++++
 5 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d585a05..8bd607c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -15,6 +15,7 @@
 #include <linux/kdev_t.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/blkdev.h>
 #include "blk-cgroup.h"
 
 #define MAX_KEY_LEN 100
@@ -63,6 +64,23 @@ void blkio_group_init(struct blkio_group *blkg)
 }
 EXPORT_SYMBOL_GPL(blkio_group_init);
 
+/*
+ * Add to the appropriate stat variable depending on the request type.
+ * This should be called with the blkg->stats_lock held.
+ */
+static void blkio_add_stat(uint64_t *stat, uint64_t add, bool direction,
+				bool sync)
+{
+	if (direction)
+		stat[BLKIO_STAT_WRITE] += add;
+	else
+		stat[BLKIO_STAT_READ] += add;
+	if (sync)
+		stat[BLKIO_STAT_SYNC] += add;
+	else
+		stat[BLKIO_STAT_ASYNC] += add;
+}
+
 void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
 {
 	unsigned long flags;
@@ -73,6 +91,42 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg, unsigned long time)
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
 
+void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+				uint64_t bytes, bool direction, bool sync)
+{
+	struct blkio_group_stats *stats;
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &blkg->stats;
+	stats->sectors += bytes >> 9;
+	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICED], 1, direction,
+			sync);
+	blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_BYTES], bytes,
+			direction, sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_dispatch_stats);
+
+void blkiocg_update_completion_stats(struct blkio_group *blkg,
+	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
+{
+	struct blkio_group_stats *stats;
+	unsigned long flags;
+	unsigned long long now = sched_clock();
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	stats = &blkg->stats;
+	if (time_after64(now, io_start_time))
+		blkio_add_stat(stats->stat_arr[BLKIO_STAT_SERVICE_TIME],
+				now - io_start_time, direction, sync);
+	if (time_after64(io_start_time, start_time))
+		blkio_add_stat(stats->stat_arr[BLKIO_STAT_WAIT_TIME],
+				io_start_time - start_time, direction, sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
+
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 			struct blkio_group *blkg, void *key, dev_t dev)
 {
@@ -315,12 +369,12 @@ SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
 #undef SHOW_FUNCTION_PER_GROUP
 
 #ifdef CONFIG_DEBUG_BLK_CGROUP
-void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
+void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 			unsigned long dequeue)
 {
 	blkg->stats.dequeue += dequeue;
 }
-EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
+EXPORT_SYMBOL_GPL(blkiocg_update_dequeue_stats);
 #endif
 
 struct cftype blkio_files[] = {
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index a4bc4bb..b22e553 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -125,12 +125,12 @@ static inline char *blkg_path(struct blkio_group *blkg)
 {
 	return blkg->path;
 }
-void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
+void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
 				unsigned long dequeue);
 #else
 static inline char *blkg_path(struct blkio_group *blkg) { return NULL; }
-static inline void blkiocg_update_blkio_group_dequeue_stats(
-			struct blkio_group *blkg, unsigned long dequeue) {}
+static inline void blkiocg_update_dequeue_stats(struct blkio_group *blkg,
+						unsigned long dequeue) {}
 #endif
 
 #if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
@@ -144,6 +144,10 @@ extern struct blkio_group *blkiocg_lookup_group(struct blkio_cgroup *blkcg,
 void blkio_group_init(struct blkio_group *blkg);
 void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 					unsigned long time);
+void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
+						bool direction, bool sync);
+void blkiocg_update_completion_stats(struct blkio_group *blkg,
+	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
 #else
 struct cgroup;
 static inline struct blkio_cgroup *
@@ -160,5 +164,10 @@ static inline struct blkio_group *
 blkiocg_lookup_group(struct blkio_cgroup *blkcg, void *key) { return NULL; }
 static inline void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 						unsigned long time) {}
+static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
+				uint64_t bytes, bool direction, bool sync) {}
+static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
+		uint64_t start_time, uint64_t io_start_time, bool direction,
+		bool sync) {}
 #endif
 #endif /* _BLK_CGROUP_H */
diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..1d94f15 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,6 +127,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->tag = -1;
 	rq->ref_count = 1;
 	rq->start_time = jiffies;
+	set_start_time_ns(rq);
 }
 EXPORT_SYMBOL(blk_rq_init);
 
@@ -1855,8 +1856,10 @@ void blk_dequeue_request(struct request *rq)
 	 * and to it is freed is accounted as io that is in progress at
 	 * the driver side.
 	 */
-	if (blk_account_rq(rq))
+	if (blk_account_rq(rq)) {
 		q->in_flight[rq_is_sync(rq)]++;
+		set_io_start_time_ns(rq);
+	}
 }
 
 /**
@@ -2517,4 +2520,3 @@ int __init blk_dev_init(void)
 
 	return 0;
 }
-
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index cf11548..9102ffc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -854,7 +854,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 	cfqg->saved_workload_slice = 0;
-	blkiocg_update_blkio_group_dequeue_stats(&cfqg->blkg, 1);
+	blkiocg_update_dequeue_stats(&cfqg->blkg, 1);
 }
 
 static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
@@ -1865,6 +1865,8 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
+	blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
+					rq_data_dir(rq), rq_is_sync(rq));
 }
 
 /*
@@ -3285,6 +3287,9 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
+	blkiocg_update_completion_stats(&cfqq->cfqg->blkg, rq_start_time_ns(rq),
+			rq_io_start_time_ns(rq), rq_data_dir(rq),
+			rq_is_sync(rq));
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebd22db..ac1f30d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -193,7 +193,10 @@ struct request {
 
 	struct gendisk *rq_disk;
 	unsigned long start_time;
-
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
+	unsigned long long start_time_ns;
+	unsigned long long io_start_time_ns;    /* when passed to hardware */
+#endif
 	/* Number of scatter-gather DMA addr+len pairs after
 	 * physical address coalescing is performed.
 	 */
@@ -1219,6 +1222,39 @@ static inline void put_dev_sector(Sector p)
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
 
+#if defined(CONFIG_BLK_CGROUP) || defined(CONFIG_BLK_CGROUP_MODULE)
+static inline void set_start_time_ns(struct request *req)
+{
+	req->start_time_ns = sched_clock();
+}
+
+static inline void set_io_start_time_ns(struct request *req)
+{
+	req->io_start_time_ns = sched_clock();
+}
+
+static inline uint64_t rq_start_time_ns(struct request *req)
+{
+	return req->start_time_ns;
+}
+
+static inline uint64_t rq_io_start_time_ns(struct request *req)
+{
+	return req->io_start_time_ns;
+}
+#else
+static inline void set_start_time_ns(struct request *req) {}
+static inline void set_io_start_time_ns(struct request *req) {}
+static inline uint64_t rq_start_time_ns(struct request *req)
+{
+	return 0;
+}
+static inline uint64_t rq_io_start_time_ns(struct request *req)
+{
+	return 0;
+}
+#endif
+
 #define MODULE_ALIAS_BLOCKDEV(major,minor) \
 	MODULE_ALIAS("block-major-" __stringify(major) "-" __stringify(minor))
 #define MODULE_ALIAS_BLOCKDEV_MAJOR(major) \

