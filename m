Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab1F1Ph0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:37:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540Ab1F1PfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 4/8] blk-throttle: specify number of ios during dispatch update
Date: Tue, 28 Jun 2011 11:35:05 -0400
Message-Id: <1309275309-12889-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently we assume the number of IOs to be 1 while dispatch stats
are being updated. It could happen that we are clubbing multiple
dispatches and updating in one shot. Throttling logic currently will
count one page as one IO for dirty page throttling. Hence modify the
logic to be able to specify number of IOs to associate with the
update.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c   |    6 +++---
 block/blk-cgroup.h   |    2 +-
 block/blk-throttle.c |    2 +-
 block/cfq-iosched.c  |    2 +-
 block/cfq.h          |    6 +++---
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bcaf16e..c0815c5 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -394,8 +394,8 @@ EXPORT_SYMBOL_GPL(blkiocg_update_timeslice_used);
  * should be called under rcu read lock or queue lock to make sure blkg pointer
  * is valid.
  */
-void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync)
+void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
+			unsigned int nr_ios, bool direction, bool sync)
 {
 	struct blkio_group_stats_cpu *stats_cpu;
 	unsigned long flags;
@@ -412,7 +412,7 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 	u64_stats_update_begin(&stats_cpu->syncp);
 	stats_cpu->sectors += bytes >> 9;
 	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_SERVICED],
-			1, direction, sync);
+			nr_ios, direction, sync);
 	blkio_add_stat(stats_cpu->stat_arr_cpu[BLKIO_STAT_CPU_SERVICE_BYTES],
 			bytes, direction, sync);
 	u64_stats_update_end(&stats_cpu->syncp);
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index a71d290..7202dcc 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -318,7 +318,7 @@ void blkiocg_update_timeslice_used(struct blkio_group *blkg,
 					unsigned long time,
 					unsigned long unaccounted_time);
 void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
-						bool direction, bool sync);
+				unsigned int nr_ios, bool direction, bool sync);
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
 	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
 void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 885ee4a..506f4ec 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -727,7 +727,7 @@ static void throtl_charge_io(struct throtl_grp *tg, bool rw, unsigned int sz,
 	tg->bytes_disp[rw] += sz;
 	tg->io_disp[rw] += nr_ios;
 
-	blkiocg_update_dispatch_stats(&tg->blkg, sz, rw, sync);
+	blkiocg_update_dispatch_stats(&tg->blkg, sz, nr_ios, rw, sync);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3d403a1..3b88563 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2060,7 +2060,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
 	cfqq->nr_sectors += blk_rq_sectors(rq);
 	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
-					rq_data_dir(rq), rq_is_sync(rq));
+					1, rq_data_dir(rq), rq_is_sync(rq));
 }
 
 /*
diff --git a/block/cfq.h b/block/cfq.h
index 2a15592..1795b3d 100644
--- a/block/cfq.h
+++ b/block/cfq.h
@@ -56,9 +56,9 @@ cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg)
 }
 
 static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync)
+		uint64_t bytes, unsigned int nr_ios, bool direction, bool sync)
 {
-	blkiocg_update_dispatch_stats(blkg, bytes, direction, sync);
+	blkiocg_update_dispatch_stats(blkg, bytes, nr_ios, direction, sync);
 }
 
 static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync)
@@ -101,7 +101,7 @@ static inline void
 cfq_blkiocg_update_set_idle_time_stats(struct blkio_group *blkg) {}
 
 static inline void cfq_blkiocg_update_dispatch_stats(struct blkio_group *blkg,
-				uint64_t bytes, bool direction, bool sync) {}
+	uint64_t bytes, unsigned int nr_ios, bool direction, bool sync) {}
 static inline void cfq_blkiocg_update_completion_stats(struct blkio_group *blkg, uint64_t start_time, uint64_t io_start_time, bool direction, bool sync) {}
 
 static inline void cfq_blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
-- 
1.7.4.4

