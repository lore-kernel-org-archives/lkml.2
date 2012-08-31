Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab2HaFLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 01:11:03 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34747 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750898Ab2HaFLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 01:11:01 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block/throttle: Call throtl_update_dispatch_stats with throtl_grp directly.
Date: Fri, 31 Aug 2012 13:08:23 +0800
Message-Id: <1346389703-2927-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.219.226.154 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

All callers of throtl_update_dispatch_stats uses tg_to_blkg and then
in this function we use blkg_to_tg again to change it back. So remove
all these useless conversion and use throtl_grp directly to call
throtl_update_dispatch_stats.

Cc: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-throttle.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e287c19..1588c2d 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -675,10 +675,9 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
 	return 0;
 }
 
-static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
+static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
 					 int rw)
 {
-	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct tg_stats_cpu *stats_cpu;
 	unsigned long flags;
 
@@ -709,7 +708,7 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	tg->bytes_disp[rw] += bio->bi_size;
 	tg->io_disp[rw]++;
 
-	throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, bio->bi_rw);
+	throtl_update_dispatch_stats(tg, bio->bi_size, bio->bi_rw);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -1133,7 +1132,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	tg = throtl_lookup_tg(td, blkcg);
 	if (tg) {
 		if (tg_no_rule_group(tg, rw)) {
-			throtl_update_dispatch_stats(tg_to_blkg(tg),
+			throtl_update_dispatch_stats(tg,
 						     bio->bi_size, bio->bi_rw);
 			goto out_unlock_rcu;
 		}
-- 
1.7.0.4

