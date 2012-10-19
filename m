Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2JSEY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 00:24:57 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33621 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab2JSEY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 00:24:56 -0400
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 1/2 v4] block/throttle: remove redundant type transition
Date: Fri, 19 Oct 2012 12:24:45 +0800
Message-Id: <1350620686-12846-1-git-send-email-robin.k.dong@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <sanbai@taobao.com>

We don't need to convert tg to blkg and then convert it back in
throtl_update_dispatch_stats().

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 block/blk-throttle.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a9664fa..46ddeff 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -674,10 +674,9 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
 	return 0;
 }
 
-static void throtl_update_dispatch_stats(struct blkcg_gq *blkg, u64 bytes,
+static void throtl_update_dispatch_stats(struct throtl_grp *tg, u64 bytes,
 					 int rw)
 {
-	struct throtl_grp *tg = blkg_to_tg(blkg);
 	struct tg_stats_cpu *stats_cpu;
 	unsigned long flags;
 
@@ -708,7 +707,7 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 	tg->bytes_disp[rw] += bio->bi_size;
 	tg->io_disp[rw]++;
 
-	throtl_update_dispatch_stats(tg_to_blkg(tg), bio->bi_size, bio->bi_rw);
+	throtl_update_dispatch_stats(tg, bio->bi_size, bio->bi_rw);
 }
 
 static void throtl_add_bio_tg(struct throtl_data *td, struct throtl_grp *tg,
@@ -1127,7 +1126,7 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	tg = throtl_lookup_tg(td, blkcg);
 	if (tg) {
 		if (tg_no_rule_group(tg, rw)) {
-			throtl_update_dispatch_stats(tg_to_blkg(tg),
+			throtl_update_dispatch_stats(tg,
 						     bio->bi_size, bio->bi_rw);
 			goto out_unlock_rcu;
 		}
-- 
1.7.1

