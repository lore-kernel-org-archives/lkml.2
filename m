Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1ISI0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:26:09 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:33639 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752630Ab1ISI0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:26:07 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fs/direct-io.c: Calcuate fs_count correctly in get_more_blocks.
Date: Mon, 19 Sep 2011 16:25:39 +0800
Message-Id: <1316420739-4734-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In get_more_blocks, we use dio_count to calcuate fs_count and do some
tricky things to increase fs_count if dio_count isn't aligned. But
actually it still has some cornor case that can't be coverd. See the
following example:
./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).
The same goes if the offset isn't aligned to fs_blocksize.

In this case, the old calculation counts fs_count to be 1, but actually
we will write into 2 different blocks(if fs_blocksize=4096). The old code
just works, since it will call get_block twice(and may have to allocate
and create extent twice for file systems like ext4). So we'd better call
get_block just once with the proper fs_count.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/direct-io.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 44a360c..b05f24e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -569,9 +569,8 @@ static int get_more_blocks(struct dio *dio)
 	int ret;
 	struct buffer_head *map_bh = &dio->map_bh;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
+	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
-	unsigned long dio_count;/* Number of dio_block-sized blocks */
-	unsigned long blkmask;
 	int create;
 
 	/*
@@ -582,11 +581,8 @@ static int get_more_blocks(struct dio *dio)
 	if (ret == 0) {
 		BUG_ON(dio->block_in_file >= dio->final_block_in_request);
 		fs_startblk = dio->block_in_file >> dio->blkfactor;
-		dio_count = dio->final_block_in_request - dio->block_in_file;
-		fs_count = dio_count >> dio->blkfactor;
-		blkmask = (1 << dio->blkfactor) - 1;
-		if (dio_count & blkmask)	
-			fs_count++;
+		fs_endblk = (dio->final_block_in_request - 1) >> dio->blkfactor;
+		fs_count = fs_endblk - fs_startblk + 1;
 
 		map_bh->b_state = 0;
 		map_bh->b_size = fs_count << dio->inode->i_blkbits;
-- 
1.7.0.4

