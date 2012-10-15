Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2JOUKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42248 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2JOUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:02 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v4 12/24] raid5: use bio_reset()
Date: Mon, 15 Oct 2012 13:08:46 -0700
Message-Id: <1350331769-14856-13-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had to shuffle the code around a bit (where bi_rw and bi_end_io were
set), but shouldn't really be anything tricky here

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cbfc424..5e327ae 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -561,14 +561,6 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		bi = &sh->dev[i].req;
 		rbi = &sh->dev[i].rreq; /* For writing to replacement */
 
-		bi->bi_rw = rw;
-		rbi->bi_rw = rw;
-		if (rw & WRITE) {
-			bi->bi_end_io = raid5_end_write_request;
-			rbi->bi_end_io = raid5_end_write_request;
-		} else
-			bi->bi_end_io = raid5_end_read_request;
-
 		rcu_read_lock();
 		rrdev = rcu_dereference(conf->disks[i].replacement);
 		smp_mb(); /* Ensure that if rrdev is NULL, rdev won't be */
@@ -643,7 +635,14 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
+			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
+			bi->bi_rw = rw;
+			bi->bi_end_io = (rw & WRITE)
+				? raid5_end_write_request
+				: raid5_end_read_request;
+			bi->bi_private = sh;
+
 			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
@@ -657,12 +656,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 				bi->bi_rw |= REQ_FLUSH;
 
-			bi->bi_flags = 1 << BIO_UPTODATE;
-			bi->bi_idx = 0;
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
-			bi->bi_next = NULL;
 			if (rrdev)
 				set_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags);
 			generic_make_request(bi);
@@ -674,7 +670,13 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 
 			set_bit(STRIPE_IO_STARTED, &sh->state);
 
+			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
+			rbi->bi_rw = rw;
+			BUG_ON(!(rw & WRITE));
+			rbi->bi_end_io = raid5_end_write_request;
+			rbi->bi_private = sh;
+
 			pr_debug("%s: for %llu schedule op %ld on "
 				 "replacement disc %d\n",
 				__func__, (unsigned long long)sh->sector,
@@ -686,12 +688,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			else
 				rbi->bi_sector = (sh->sector
 						  + rrdev->data_offset);
-			rbi->bi_flags = 1 << BIO_UPTODATE;
-			rbi->bi_idx = 0;
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_size = STRIPE_SIZE;
-			rbi->bi_next = NULL;
 			generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
-- 
1.7.12

