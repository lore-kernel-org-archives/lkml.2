Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1HAHkC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 03:40:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:61614 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab1HAHj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 03:39:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,299,1309762800"; 
   d="scan'208";a="36557330"
Subject: [PATCH]blk-throttle: correctly determine sync bio
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Aug 2011 15:39:57 +0800
Message-ID: <1312184397.15392.430.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

read request is always sync. Using rw_is_sync() to determine
if a bio is sync.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index f6a7941..a19f58c 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -746,7 +746,7 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
 static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
 {
 	bool rw = bio_data_dir(bio);
-	bool sync = bio->bi_rw & REQ_SYNC;
+	bool sync = rw_is_sync(bio->bi_rw);
 
 	/* Charge the bio to the group */
 	tg->bytes_disp[rw] += bio->bi_size;
@@ -1150,7 +1150,7 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 
 		if (tg_no_rule_group(tg, rw)) {
 			blkiocg_update_dispatch_stats(&tg->blkg, bio->bi_size,
-					rw, bio->bi_rw & REQ_SYNC);
+					rw, rw_is_sync(bio->bi_rw));
 			rcu_read_unlock();
 			return 0;
 		}


