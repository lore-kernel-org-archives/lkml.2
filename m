Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab2HaFRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 01:17:33 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:49303 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750929Ab2HaFRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 01:17:32 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH V2] block/throttle: Add IO throttled information in blkio.throttle.
Date: Fri, 31 Aug 2012 13:15:09 +0800
Message-Id: <1346390109-3169-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.219.226.154 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently, if the IO is throttled by io-throttle, the SA has no idea of
the situation and can't report it to the real application user about
that he/she has to do something. So this patch adds a new interface
named blkio.throttle.io_queued which indicates how many IOs are
currently throttled.

Also another function blkg_rwstat_dec is added since the number of throttled
IOs can be either added or decreased.

Cc: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-cgroup.h   |   26 ++++++++++++++++++++++++++
 block/blk-throttle.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2459730..b1f6f5c 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -413,6 +413,32 @@ static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
 }
 
 /**
+ * blkg_rwstat_dec - dec a value to a blkg_rwstat
+ * @rwstat: target blkg_rwstat
+ * @rw: mask of REQ_{WRITE|SYNC}
+ * @val: value to dec
+ *
+ * Dec @val to @rwstat.  The counters are chosen according to @rw.  The
+ * caller is responsible for synchronizing calls to this function.
+ */
+static inline void blkg_rwstat_dec(struct blkg_rwstat *rwstat,
+				   int rw, uint64_t val)
+{
+	u64_stats_update_begin(&rwstat->syncp);
+
+	if (rw & REQ_WRITE)
+		rwstat->cnt[BLKG_RWSTAT_WRITE] -= val;
+	else
+		rwstat->cnt[BLKG_RWSTAT_READ] -= val;
+	if (rw & REQ_SYNC)
+		rwstat->cnt[BLKG_RWSTAT_SYNC] -= val;
+	else
+		rwstat->cnt[BLKG_RWSTAT_ASYNC] -= val;
+
+	u64_stats_update_end(&rwstat->syncp);
+}
+
+/**
  * blkg_rwstat_read - read the current values of a blkg_rwstat
  * @rwstat: blkg_rwstat to read
  *
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 1588c2d..9317d71 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -46,6 +46,8 @@ struct tg_stats_cpu {
 	struct blkg_rwstat		service_bytes;
 	/* total IOs serviced, post merge */
 	struct blkg_rwstat		serviced;
+	/* total IOs queued, not submitted to the underlying device. */
+	struct blkg_rwstat		io_queued;
 };
 
 struct throtl_grp {
@@ -267,6 +269,7 @@ static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
 
 		blkg_rwstat_reset(&sc->service_bytes);
 		blkg_rwstat_reset(&sc->serviced);
+		blkg_rwstat_reset(&sc->io_queued);
 	}
 }
 
@@ -700,6 +703,31 @@ static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
 	local_irq_restore(flags);
 }
 
+static void throtl_update_queued_stats(struct throtl_grp *tg, int rw, int add)
+{
+	struct tg_stats_cpu *stats_cpu;
+	unsigned long flags;
+
+	/* If per cpu stats are not allocated yet, don't do any accounting. */
+	if (tg->stats_cpu == NULL)
+		return;
+
+	/*
+	 * Disabling interrupts to provide mutual exclusion between two
+	 * writes on same cpu. It probably is not needed for 64bit. Not
+	 * optimizing that case yet.
+	 */
+	local_irq_save(flags);
+
+	stats_cpu = this_cpu_ptr(tg->stats_cpu);
+	if (add)
+		blkg_rwstat_add(&stats_cpu->io_queued, rw, 1);
+	else
+		blkg_rwstat_dec(&stats_cpu->io_queued, rw, 1);
+
+	local_irq_restore(flags);
+}
+
 static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
@@ -715,6 +743,8 @@ static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
 			struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
+	struct tg_stats_cpu *stats_cpu;
+	unsigned long flags;
 
 	bio_list_add(&tg->bio_lists[rw], bio);
 	/* Take a bio reference on tg */
@@ -722,6 +752,7 @@ static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
 	tg->nr_queued[rw]++;
 	td->nr_queued[rw]++;
 	throtl_enqueue_tg(td, tg);
+	throtl_update_queued_stats(tg, bio->bi_rw, 1);
 }
 
 static void tg_update_disptime(struct throtl_data *td, struct throtl_grp *tg)
@@ -762,6 +793,7 @@ static void tg_dispatch_one_bio(struct throtl_data *td, struct throtl_grp *tg,
 	bio->bi_rw |= REQ_THROTTLED;
 
 	throtl_trim_slice(td, tg, rw);
+	throtl_update_queued_stats(tg, bio->bi_rw, 0);
 }
 
 static int throtl_dispatch_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -1090,6 +1122,11 @@ static struct cftype throtl_files[] = {
 		.private = offsetof(struct tg_stats_cpu, serviced),
 		.read_seq_string = tg_print_cpu_rwstat,
 	},
+	{
+		.name = "throttle.io_queued",
+		.private = offsetof(struct tg_stats_cpu, io_queued),
+		.read_seq_string = tg_print_cpu_rwstat,
+	},
 	{ }	/* terminate */
 };
 
-- 
1.7.0.4

