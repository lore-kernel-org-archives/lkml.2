Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab1GFTEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:04:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab1GFTEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:04:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=lrs6CH0ho8ddlnVWxJBrcKdyv9PoU2eVQIYhGgOWnWWvctmsRl2jH5ggiv69kFsLx
	vnNmfxcJ6XxwPpVLXuFJA==
From: Slava Pestov <slavapestov@google.com>
To: linux-kernel@vger.kernel.org
Cc: mrubin@google.com, Slava Pestov <slavapestov@google.com>
Subject: [RFC] Change /proc/diskstats to use sched_clock()
Date: Wed,  6 Jul 2011 12:04:27 -0700
Message-Id: <1309979067-31572-1-git-send-email-slavapestov@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves the accuracy of I/O utilization stats
and cleans up some duplication by introducing the following
changes:
- Removing start_time field from struct request
- Moving start_time_ns outside of the CONFIG_BLK_CGROUP #ifdef
- Changing blk_account_io_done() to use sched_clock() and
  start_time_ns
- Changing a few usages of start_time to start_time_ns in
  the CFQ I/O scheduler, MD subsystem, and request merging

Signed-off-by: Slava Pestov <slavapestov@google.com>
---
 block/blk-core.c       |   28 ++++++++++++++++------------
 block/blk-merge.c      |    4 ++--
 block/cfq-iosched.c    |   11 ++++++++++-
 block/genhd.c          |   19 +++++++++++--------
 drivers/md/dm.c        |    3 ++-
 fs/partitions/check.c  |   22 +++++++++++-----------
 include/linux/blkdev.h |   21 ++++++++-------------
 include/linux/genhd.h  |    8 ++++----
 8 files changed, 64 insertions(+), 52 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d2f8f40..bea7009 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -141,7 +141,6 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->cmd_len = BLK_MAX_CDB;
 	rq->tag = -1;
 	rq->ref_count = 1;
-	rq->start_time = jiffies;
 	set_start_time_ns(rq);
 	rq->part = NULL;
 }
@@ -991,12 +990,9 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 EXPORT_SYMBOL(blk_insert_request);
 
 static void part_round_stats_single(int cpu, struct hd_struct *part,
-				    unsigned long now)
+				    unsigned long long now)
 {
-	if (now == part->stamp)
-		return;
-
-	if (part_in_flight(part)) {
+	if (part_in_flight(part) && time_after64(now, part->stamp)) {
 		__part_stat_add(cpu, part, time_in_queue,
 				part_in_flight(part) * (now - part->stamp));
 		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
@@ -1018,11 +1014,11 @@ static void part_round_stats_single(int cpu, struct hd_struct *part,
  * second, leading to >100% utilisation.  To deal with that, we call this
  * function to do a round-off before returning the results when reading
  * /proc/diskstats.  This accounts immediately for all queue usage up to
- * the current jiffies and restarts the counters again.
+ * the current nanosecond and restarts the counters again.
  */
 void part_round_stats(int cpu, struct hd_struct *part)
 {
-	unsigned long now = jiffies;
+	unsigned long long now = sched_clock();
 
 	if (part->partno)
 		part_round_stats_single(cpu, &part_to_disk(part)->part0, now);
@@ -1787,17 +1783,25 @@ static void blk_account_io_done(struct request *req)
 	 * containing request is enough.
 	 */
 	if (blk_do_io_stat(req) && !(req->cmd_flags & REQ_FLUSH_SEQ)) {
-		unsigned long duration = jiffies - req->start_time;
+		unsigned long long now;
 		const int rw = rq_data_dir(req);
-		struct hd_struct *part;
+		struct hd_struct *part, *hd;
 		int cpu;
 
 		cpu = part_stat_lock();
+		now = sched_clock();
 		part = req->part;
 
 		part_stat_inc(cpu, part, ios[rw]);
-		part_stat_add(cpu, part, ticks[rw], duration);
-		part_round_stats(cpu, part);
+		if (time_after64(now, rq_start_time_ns(req)))
+			part_stat_add(cpu, part, ticks[rw],
+					now - rq_start_time_ns(req));
+		if (part->partno) {
+			hd = &part_to_disk(part)->part0;	
+			part_round_stats_single(cpu, hd, now);
+		}
+		part_round_stats_single(cpu, part, now);
+
 		part_dec_in_flight(part, rw);
 
 		hd_struct_put(part);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index cfcc37c..dbc51ab 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -421,8 +421,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	 * the merged requests to be the current request
 	 * for accounting purposes.
 	 */
-	if (time_after(req->start_time, next->start_time))
-		req->start_time = next->start_time;
+	if (time_after64(req->start_time_ns, next->start_time_ns))
+		req->start_time_ns = next->start_time_ns;
 
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f379943..029214f 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3543,8 +3543,14 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 	struct cfq_data *cfqd = cfqq->cfqd;
 	const int sync = rq_is_sync(rq);
 	unsigned long now;
+	unsigned long long sched_now;
+	unsigned long long cfq_fifo_expire;
 
 	now = jiffies;
+	preempt_disable();
+	sched_now = sched_clock();
+	preempt_enable();
+
 	cfq_log_cfqq(cfqd, cfqq, "complete rqnoidle %d",
 		     !!(rq->cmd_flags & REQ_NOIDLE));
 
@@ -3563,7 +3569,10 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 
 	if (sync) {
 		RQ_CIC(rq)->last_end_request = now;
-		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
+		cfq_fifo_expire = rq_start_time_ns(rq)
+		    + (unsigned long long)cfqd->cfq_fifo_expire[1]
+		    * NSEC_PER_MSEC;
+		if (!time_after64(cfq_fifo_expire, sched_now))
 			cfqd->last_delayed_sync = now;
 	}
 
diff --git a/block/genhd.c b/block/genhd.c
index 3608289..1e8eed3 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1154,21 +1154,24 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
 		part_stat_unlock();
-		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
-			   "%u %lu %lu %llu %u %u %u %u\n",
+		seq_printf(seqf,
+			   "%4d %7d %s "
+			   "%lu %lu %lu %llu "
+			   "%lu %lu %lu %llu "
+			   "%u %llu %llu\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[READ]),
 			   part_stat_read(hd, merges[READ]),
-			   (unsigned long long)part_stat_read(hd, sectors[READ]),
-			   jiffies_to_msecs(part_stat_read(hd, ticks[READ])),
+			   part_stat_read(hd, sectors[READ]),
+			   part_stat_read(hd, ticks[READ]) / NSEC_PER_MSEC,
 			   part_stat_read(hd, ios[WRITE]),
 			   part_stat_read(hd, merges[WRITE]),
-			   (unsigned long long)part_stat_read(hd, sectors[WRITE]),
-			   jiffies_to_msecs(part_stat_read(hd, ticks[WRITE])),
+			   part_stat_read(hd, sectors[WRITE]),
+			   part_stat_read(hd, ticks[WRITE]) / NSEC_PER_MSEC,
 			   part_in_flight(hd),
-			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
-			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
+			   part_stat_read(hd, io_ticks) / NSEC_PER_MSEC,
+			   part_stat_read(hd, time_in_queue) / NSEC_PER_MSEC
 			);
 	}
 	disk_part_iter_exit(&piter);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0cf68b4..bdbd520 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/moduleparam.h>
+#include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
@@ -1439,7 +1440,7 @@ void dm_dispatch_request(struct request *rq)
 	if (blk_queue_io_stat(rq->q))
 		rq->cmd_flags |= REQ_IO_STAT;
 
-	rq->start_time = jiffies;
+	set_start_time_ns(rq);
 	r = blk_insert_cloned_request(rq->q, rq);
 	if (r)
 		dm_complete_request(rq, r);
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d545e97..9f0d1d6 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -268,21 +268,21 @@ ssize_t part_stat_show(struct device *dev,
 	part_round_stats(cpu, p);
 	part_stat_unlock();
 	return sprintf(buf,
-		"%8lu %8lu %8llu %8u "
-		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
+		"%8lu %8lu %8lu %8llu "
+		"%8lu %8lu %8lu %8llu "
+		"%8u %8llu %8llu"
 		"\n",
 		part_stat_read(p, ios[READ]),
 		part_stat_read(p, merges[READ]),
-		(unsigned long long)part_stat_read(p, sectors[READ]),
-		jiffies_to_msecs(part_stat_read(p, ticks[READ])),
+		part_stat_read(p, sectors[READ]),
+		part_stat_read(p, ticks[READ]) / NSEC_PER_MSEC,
 		part_stat_read(p, ios[WRITE]),
 		part_stat_read(p, merges[WRITE]),
-		(unsigned long long)part_stat_read(p, sectors[WRITE]),
-		jiffies_to_msecs(part_stat_read(p, ticks[WRITE])),
+		part_stat_read(p, sectors[WRITE]),
+		part_stat_read(p, ticks[WRITE]) / NSEC_PER_MSEC,
 		part_in_flight(p),
-		jiffies_to_msecs(part_stat_read(p, io_ticks)),
-		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
+		part_stat_read(p, io_ticks) / NSEC_PER_MSEC,
+		part_stat_read(p, time_in_queue) / NSEC_PER_MSEC);
 }
 
 ssize_t part_inflight_show(struct device *dev,
@@ -290,8 +290,8 @@ ssize_t part_inflight_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[0]),
-		atomic_read(&p->in_flight[1]));
+	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[READ]),
+		atomic_read(&p->in_flight[WRITE]));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1a23722..6b384c5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -122,9 +122,9 @@ struct request {
 
 	struct gendisk *rq_disk;
 	struct hd_struct *part;
-	unsigned long start_time;
-#ifdef CONFIG_BLK_CGROUP
+	/* These use sched_clock() as a clock */
 	unsigned long long start_time_ns;
+#ifdef CONFIG_BLK_CGROUP
 	unsigned long long io_start_time_ns;    /* when passed to hardware */
 #endif
 	/* Number of scatter-gather DMA addr+len pairs after
@@ -1134,7 +1134,6 @@ static inline void put_dev_sector(Sector p)
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
 
-#ifdef CONFIG_BLK_CGROUP
 /*
  * This should not be using sched_clock(). A real patch is in progress
  * to fix this up, until that is in place we need to disable preemption
@@ -1147,6 +1146,12 @@ static inline void set_start_time_ns(struct request *req)
 	preempt_enable();
 }
 
+static inline uint64_t rq_start_time_ns(struct request *req)
+{
+        return req->start_time_ns;
+}
+
+#ifdef CONFIG_BLK_CGROUP
 static inline void set_io_start_time_ns(struct request *req)
 {
 	preempt_disable();
@@ -1154,22 +1159,12 @@ static inline void set_io_start_time_ns(struct request *req)
 	preempt_enable();
 }
 
-static inline uint64_t rq_start_time_ns(struct request *req)
-{
-        return req->start_time_ns;
-}
-
 static inline uint64_t rq_io_start_time_ns(struct request *req)
 {
         return req->io_start_time_ns;
 }
 #else
-static inline void set_start_time_ns(struct request *req) {}
 static inline void set_io_start_time_ns(struct request *req) {}
-static inline uint64_t rq_start_time_ns(struct request *req)
-{
-	return 0;
-}
 static inline uint64_t rq_io_start_time_ns(struct request *req)
 {
 	return 0;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 300d758..2f76da2 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -83,9 +83,9 @@ struct disk_stats {
 	unsigned long sectors[2];	/* READs and WRITEs */
 	unsigned long ios[2];
 	unsigned long merges[2];
-	unsigned long ticks[2];
-	unsigned long io_ticks;
-	unsigned long time_in_queue;
+	unsigned long long ticks[2];
+	unsigned long long io_ticks;
+	unsigned long long time_in_queue;
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -108,7 +108,7 @@ struct hd_struct {
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;
 #endif
-	unsigned long stamp;
+	unsigned long long stamp;
 	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
-- 
1.7.3.1

