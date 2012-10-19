Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2JSEZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:25:03 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:55352 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab2JSEY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:24:59 -0400
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <boyu.mt@taobao.com>
Subject: [PATCH 2/2 v4] block/throttle: Add IO queued information in blkio.throttle
Date: Fri, 19 Oct 2012 12:24:46 +0800
Message-Id: <1350620686-12846-2-git-send-email-robin.k.dong@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1350620686-12846-1-git-send-email-robin.k.dong@gmail.com>
References: <1350620686-12846-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <sanbai@taobao.com>

Currently, if the IO is throttled by io-throttle, the system admin has no idea
of the situation and can't report it to the real application user about that
he/she has to do something.

So this patch adds a new interface named blkio.throttle.io_queued which
exposes the number of bios that have been sent to blk-throttle therefore the
user could calculate the difference from throttle.io_serviced to see how many
IOs are currently throttled.

Cc: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Robin Dong <sanbai@taobao.com>
---
v3 <-- v2:
 - Use nr-queued[] of struct throtl_grp for stats instaed of adding new blkg_rwstat.

v4 <-- v3:
 - Add two new blkg_rwstat arguments to count total bios be sent in blk_throttle.

 block/blk-throttle.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 46ddeff..b122b0c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -70,6 +70,10 @@ struct throtl_grp {
 	/* Number of queued bios on READ and WRITE lists */
 	unsigned int nr_queued[2];
 
+	/* The stats of total number queued in blk-throtlle */
+	struct blkg_rwstat io_queue_bytes;
+	struct blkg_rwstat io_queued;
+
 	/* bytes per second rate limits */
 	uint64_t bps[2];
 
@@ -267,6 +271,8 @@ static void throtl_pd_reset_stats(struct blkcg_gq *blkg)
 		blkg_rwstat_reset(&sc->service_bytes);
 		blkg_rwstat_reset(&sc->serviced);
 	}
+	blkg_rwstat_reset(&tg->io_queued);
+	blkg_rwstat_reset(&tg->io_queue_bytes);
 }
 
 static struct throtl_grp *throtl_lookup_tg(struct throtl_data *td,
@@ -699,6 +705,12 @@ static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
 	local_irq_restore(flags);
 }
 
+static void throtl_update_queued_stats(struct throtl_grp *tg, u64 bytes, int rw)
+{
+	blkg_rwstat_add(&tg->io_queued, rw, 1);
+	blkg_rwstat_add(&tg->io_queue_bytes, rw, bytes);
+}
+
 static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
@@ -952,6 +964,15 @@ static u64 tg_prfill_cpu_rwstat(struct seq_file *sf,
 	return __blkg_prfill_rwstat(sf, pd, &rwstat);
 }
 
+static u64 tg_prfill_io_queued(struct seq_file *sf,
+				struct blkg_policy_data *pd, int off)
+{
+	struct throtl_grp *tg = pd_to_tg(pd);
+	struct blkg_rwstat *rwstat = (void *)tg + off;
+
+	return __blkg_prfill_rwstat(sf, pd, rwstat);
+}
+
 static int tg_print_cpu_rwstat(struct cgroup *cgrp, struct cftype *cft,
 			       struct seq_file *sf)
 {
@@ -962,6 +983,16 @@ static int tg_print_cpu_rwstat(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static int tg_print_io_queued(struct cgroup *cgrp, struct cftype *cft,
+			       struct seq_file *sf)
+{
+	struct blkcg *blkcg = cgroup_to_blkcg(cgrp);
+
+	blkcg_print_blkgs(sf, blkcg, tg_prfill_io_queued, &blkcg_policy_throtl,
+			  cft->private, true);
+	return 0;
+}
+
 static u64 tg_prfill_conf_u64(struct seq_file *sf, struct blkg_policy_data *pd,
 			      int off)
 {
@@ -1084,6 +1115,16 @@ static struct cftype throtl_files[] = {
 		.private = offsetof(struct tg_stats_cpu, serviced),
 		.read_seq_string = tg_print_cpu_rwstat,
 	},
+	{
+		.name = "throttle.io_queue_bytes",
+		.private = offsetof(struct throtl_grp, io_queue_bytes),
+		.read_seq_string = tg_print_io_queued,
+	},
+	{
+		.name = "throttle.io_queued",
+		.private = offsetof(struct throtl_grp, io_queued),
+		.read_seq_string = tg_print_io_queued,
+	},
 	{ }	/* terminate */
 };
 
@@ -1128,6 +1169,8 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		if (tg_no_rule_group(tg, rw)) {
 			throtl_update_dispatch_stats(tg,
 						     bio->bi_size, bio->bi_rw);
+			throtl_update_queued_stats(tg,
+					bio->bi_size, bio->bi_rw);
 			goto out_unlock_rcu;
 		}
 	}
@@ -1141,6 +1184,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	if (unlikely(!tg))
 		goto out_unlock;
 
+	throtl_update_queued_stats(tg, bio->bi_size, bio->bi_rw);
 	if (tg->nr_queued[rw]) {
 		/*
 		 * There is already another bio queued in same dir. No
-- 
1.7.1

