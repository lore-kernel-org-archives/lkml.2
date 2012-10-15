Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2JOUKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:10:51 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab2JOUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:39 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 08/26] block: Remove bi_idx references
Date: Mon, 15 Oct 2012 13:09:11 -0700
Message-Id: <1350331769-14856-38-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These were harmless but uneccessary,andt getting rid of them makes the
code easier to audit since most of them need to be removed.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/floppy.c | 1 -
 drivers/md/dm-verity.c | 2 +-
 drivers/md/raid10.c    | 1 -
 fs/buffer.c            | 1 -
 fs/jfs/jfs_logmgr.c    | 2 --
 fs/logfs/dev_bdev.c    | 5 -----
 mm/page_io.c           | 1 -
 7 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 95e52879..24e5cef 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3778,7 +3778,6 @@ static int __floppy_read_block_0(struct block_device *bdev)
 	bio_vec.bv_len = size;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
-	bio.bi_idx = 0;
 	bio.bi_size = size;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = 0;
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 18ef6c5..6956626 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -496,7 +496,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio,
 
 	bio->bi_end_io = verity_end_io;
 	bio->bi_private = io;
-	io->io_vec_size = bio->bi_vcnt - bio->bi_idx;
+	io->io_vec_size = bio_segments(bio);
 	if (io->io_vec_size < DM_VERITY_IO_VEC_INLINE)
 		io->io_vec = io->io_vec_inline;
 	else
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index bbd08f5..6d06d83 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4249,7 +4249,6 @@ read_more:
 	read_bio->bi_flags &= ~(BIO_POOL_MASK - 1);
 	read_bio->bi_flags |= 1 << BIO_UPTODATE;
 	read_bio->bi_vcnt = 0;
-	read_bio->bi_idx = 0;
 	read_bio->bi_size = 0;
 	r10_bio->master_bio = read_bio;
 	r10_bio->read_slot = r10_bio->devs[r10_bio->read_slot].devnum;
diff --git a/fs/buffer.c b/fs/buffer.c
index 58e2e7b..38d8793 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2893,7 +2893,6 @@ int submit_bh(int rw, struct buffer_head * bh)
 	bio->bi_io_vec[0].bv_offset = bh_offset(bh);
 
 	bio->bi_vcnt = 1;
-	bio->bi_idx = 0;
 	bio->bi_size = bh->b_size;
 
 	bio->bi_end_io = end_bio_bh_io_sync;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 2eb952c..8ae5e35 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2004,7 +2004,6 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
 	bio->bi_vcnt = 1;
-	bio->bi_idx = 0;
 	bio->bi_size = LOGPSIZE;
 
 	bio->bi_end_io = lbmIODone;
@@ -2145,7 +2144,6 @@ static void lbmStartIO(struct lbuf * bp)
 	bio->bi_io_vec[0].bv_offset = bp->l_offset;
 
 	bio->bi_vcnt = 1;
-	bio->bi_idx = 0;
 	bio->bi_size = LOGPSIZE;
 
 	bio->bi_end_io = lbmIODone;
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index e784a21..550475c 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -32,7 +32,6 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio_vec.bv_len = PAGE_SIZE;
 	bio_vec.bv_offset = 0;
 	bio.bi_vcnt = 1;
-	bio.bi_idx = 0;
 	bio.bi_size = PAGE_SIZE;
 	bio.bi_bdev = bdev;
 	bio.bi_sector = page->index * (PAGE_SIZE >> 9);
@@ -108,7 +107,6 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 		if (i >= max_pages) {
 			/* Block layer cannot split bios :( */
 			bio->bi_vcnt = i;
-			bio->bi_idx = 0;
 			bio->bi_size = i * PAGE_SIZE;
 			bio->bi_bdev = super->s_bdev;
 			bio->bi_sector = ofs >> 9;
@@ -136,7 +134,6 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 		unlock_page(page);
 	}
 	bio->bi_vcnt = nr_pages;
-	bio->bi_idx = 0;
 	bio->bi_size = nr_pages * PAGE_SIZE;
 	bio->bi_bdev = super->s_bdev;
 	bio->bi_sector = ofs >> 9;
@@ -202,7 +199,6 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 		if (i >= max_pages) {
 			/* Block layer cannot split bios :( */
 			bio->bi_vcnt = i;
-			bio->bi_idx = 0;
 			bio->bi_size = i * PAGE_SIZE;
 			bio->bi_bdev = super->s_bdev;
 			bio->bi_sector = ofs >> 9;
@@ -224,7 +220,6 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 		bio->bi_io_vec[i].bv_offset = 0;
 	}
 	bio->bi_vcnt = nr_pages;
-	bio->bi_idx = 0;
 	bio->bi_size = nr_pages * PAGE_SIZE;
 	bio->bi_bdev = super->s_bdev;
 	bio->bi_sector = ofs >> 9;
diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..8d3c0c0 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -35,7 +35,6 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[0].bv_offset = 0;
 		bio->bi_vcnt = 1;
-		bio->bi_idx = 0;
 		bio->bi_size = PAGE_SIZE;
 		bio->bi_end_io = end_io;
 	}
-- 
1.7.12

