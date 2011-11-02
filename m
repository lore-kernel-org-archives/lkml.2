Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1KBC0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:26:50 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:39498 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753347Ab1KBC0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:26:47 -0400
From: Tao Ma <tm@tao.ma>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH V2 for 3.2] fs/direct-io.c: Calculate fs_count correctly in get_more_blocks.
Date: Wed,  2 Nov 2011 10:26:34 +0800
Message-Id: <1320200794-2881-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <x49wrblav46.fsf@segfault.boston.devel.redhat.com>
References: <x49wrblav46.fsf@segfault.boston.devel.redhat.com>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In get_more_blocks, we use dio_count to calculate fs_count to let the
file system map(maybe also create) blocks. And some tricky things are
done to increase fs_count if dio_count isn't aligned.

But actually it still has some cornor case that can't be coverd. See the
following example:
./dio_write foo -s 1024 -w 4096(direct write 4096 bytes at offset 1024).

In this case, the old calculation counts fs_count to be 1, but actually
we will write into 2 different blocks(if fs_blocksize=4096). So the
underlying file system is called twice and leads to some performance
overhead. So fix it by calculating fs_count correctly and let the file
system knows what we really want to write.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/direct-io.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index d740ab6..5582183 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -580,9 +580,8 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 {
 	int ret;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
+	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
-	unsigned long dio_count;/* Number of dio_block-sized blocks */
-	unsigned long blkmask;
 	int create;
 
 	/*
@@ -593,11 +592,9 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 	if (ret == 0) {
 		BUG_ON(sdio->block_in_file >= sdio->final_block_in_request);
 		fs_startblk = sdio->block_in_file >> sdio->blkfactor;
-		dio_count = sdio->final_block_in_request - sdio->block_in_file;
-		fs_count = dio_count >> sdio->blkfactor;
-		blkmask = (1 << sdio->blkfactor) - 1;
-		if (dio_count & blkmask)	
-			fs_count++;
+		fs_endblk = (sdio->final_block_in_request - 1) >>
+				sdio->blkfactor;
+		fs_count = fs_endblk - fs_startblk + 1;
 
 		map_bh->b_state = 0;
 		map_bh->b_size = fs_count << dio->inode->i_blkbits;
-- 
1.7.1

