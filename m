Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1HVQIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:08:04 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33173 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1HVQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:08:01 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] block: move trace_block_bio_remap() before blk_partition_remap
Date: Tue, 23 Aug 2011 01:05:54 +0900
Message-Id: <1314029154-5177-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block_bio_remap tracepoint keep tracks of remapping information of
the @bio. IOW, if underlying disk remaps @bio to other disk, it
could be tracked using the tracepoint in __generic_make_request()
loop. However, blk_partition_remap() also modifies the information
before the tracepoint so that the remapping chain could be diverged
and this could make some potential userspace tools confused.

Moving the tracepoint before blk_partition_remap() can help it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 block/blk-core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b627558c461f..13559c2584b4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1494,6 +1494,9 @@ static inline void __generic_make_request(struct bio *bio)
 					bio->bi_size))
 			goto end_io;
 
+		if (old_sector != -1)
+			trace_block_bio_remap(q, bio, old_dev, old_sector);
+
 		/*
 		 * If this device has partitions, remap block n
 		 * of partition p to block n+start(p) of the disk.
@@ -1503,9 +1506,6 @@ static inline void __generic_make_request(struct bio *bio)
 		if (bio_integrity_enabled(bio) && bio_integrity_prep(bio))
 			goto end_io;
 
-		if (old_sector != -1)
-			trace_block_bio_remap(q, bio, old_dev, old_sector);
-
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
 
-- 
1.7.6

