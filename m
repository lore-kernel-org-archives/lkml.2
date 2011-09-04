Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1IDNQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 09:16:39 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56529 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1IDNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 09:16:23 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] block: move trace_block_bio_remap() before blk_partition_remap
Date: Sun,  4 Sep 2011 22:15:10 +0900
Message-Id: <1315142112-2430-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315142112-2430-1-git-send-email-namhyung@gmail.com>
References: <1315142112-2430-1-git-send-email-namhyung@gmail.com>
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
index 90e1ffdeb415..a60b46cc9da5 100644
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

