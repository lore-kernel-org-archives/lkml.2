Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965733Ab2KBJbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:31:49 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57070 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759214Ab2KBJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:31:47 -0400
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 1/2 v5] block/throttle: remove redundant type transition
Date: Fri,  2 Nov 2012 17:31:36 +0800
Message-Id: <1351848697-26087-1-git-send-email-robin.k.dong@gmail.com>
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

