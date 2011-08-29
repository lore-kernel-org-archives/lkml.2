Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1H2XXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:31423 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411Ab1H2XX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="43701318"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/11] DIO: Separate map_bh from dio v2
Date: Mon, 29 Aug 2011 16:23:16 -0700
Message-Id: <1314660202-661-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Only a single b_private field in the map_bh buffer head is needed after
the submission path. Move map_bh separately to avoid storing
this information in the long term slab.

This avoids the weird 104 byte hole in struct dio_submit which also needed
to be memseted early.

v2: b_private->private (hch)
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   65 +++++++++++++++++++++++++++++++-------------------------
 1 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e91ac83..172ec77 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -119,6 +119,7 @@ struct dio {
 	loff_t i_size;			/* i_size when submitted */
 	dio_iodone_t *end_io;		/* IO completion function */
 
+	void *private;			/* copy from map_bh.b_private */
 
 	/* BIO completion state */
 	spinlock_t bio_lock;		/* protects BIO fields below */
@@ -133,7 +134,6 @@ struct dio {
 	struct kiocb *iocb;		/* kiocb */
 	ssize_t result;                 /* IO result */
 
-	struct buffer_head map_bh;	/* last get_block() result */
 	/*
 	 * pages[] (and any fields placed after it) are not zeroed out at
 	 * allocation time.  Don't add new fields after pages[] unless you
@@ -301,7 +301,7 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is
 
 	if (dio->end_io && dio->result) {
 		dio->end_io(dio->iocb, offset, transferred,
-			    dio->map_bh.b_private, ret, is_async);
+			    dio->private, ret, is_async);
 	} else {
 		if (is_async)
 			aio_complete(dio->iocb, ret, 0);
@@ -574,10 +574,10 @@ static int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
  * buffer_mapped().  However the direct-io code will only process holes one
  * block at a time - it will repeatedly call get_block() as it walks the hole.
  */
-static int get_more_blocks(struct dio *dio, struct dio_submit *sdio)
+static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
+			   struct buffer_head *map_bh)
 {
 	int ret;
-	struct buffer_head *map_bh = &dio->map_bh;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
 	unsigned long dio_count;/* Number of dio_block-sized blocks */
@@ -621,6 +621,9 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio)
 
 		ret = (*sdio->get_block)(dio->inode, fs_startblk,
 						map_bh, create);
+
+		/* Store for completion */
+		dio->private = map_bh->b_private;
 	}
 	return ret;
 }
@@ -629,7 +632,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio)
  * There is no bio.  Make one now.
  */
 static int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
-		       sector_t start_sector)
+		       sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
 	int ret, nr_pages;
@@ -638,10 +641,10 @@ static int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
 	if (ret)
 		goto out;
 	sector = start_sector << (sdio->blkbits - 9);
-	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	nr_pages = min(sdio->pages_in_io, bio_get_nr_vecs(map_bh->b_bdev));
 	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
-	dio_bio_alloc(dio, sdio, dio->map_bh.b_bdev, sector, nr_pages);
+	dio_bio_alloc(dio, sdio, map_bh->b_bdev, sector, nr_pages);
 	sdio->boundary = 0;
 out:
 	return ret;
@@ -686,7 +689,8 @@ static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
  * The caller of this function is responsible for removing cur_page from the
  * dio, and for dropping the refcount which came from that presence.
  */
-static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio)
+static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
+			     struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -721,14 +725,14 @@ static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio)
 	}
 
 	if (sdio->bio == NULL) {
-		ret = dio_new_bio(dio, sdio, sdio->cur_page_block);
+		ret = dio_new_bio(dio, sdio, sdio->cur_page_block, map_bh);
 		if (ret)
 			goto out;
 	}
 
 	if (dio_bio_add_page(dio, sdio) != 0) {
 		dio_bio_submit(dio, sdio);
-		ret = dio_new_bio(dio, sdio, sdio->cur_page_block);
+		ret = dio_new_bio(dio, sdio, sdio->cur_page_block, map_bh);
 		if (ret == 0) {
 			ret = dio_bio_add_page(dio, sdio);
 			BUG_ON(ret != 0);
@@ -757,7 +761,8 @@ out:
  */
 static int
 submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
-		unsigned offset, unsigned len, sector_t blocknr)
+		    unsigned offset, unsigned len, sector_t blocknr,
+		    struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -782,7 +787,7 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 		 * avoid metadata seeks.
 		 */
 		if (sdio->boundary) {
-			ret = dio_send_cur_page(dio, sdio);
+			ret = dio_send_cur_page(dio, sdio, map_bh);
 			page_cache_release(sdio->cur_page);
 			sdio->cur_page = NULL;
 		}
@@ -793,7 +798,7 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 	 * If there's a deferred page already there then send it.
 	 */
 	if (sdio->cur_page) {
-		ret = dio_send_cur_page(dio, sdio);
+		ret = dio_send_cur_page(dio, sdio, map_bh);
 		page_cache_release(sdio->cur_page);
 		sdio->cur_page = NULL;
 		if (ret)
@@ -815,16 +820,16 @@ out:
  * file blocks.  Only called for S_ISREG files - blockdevs do not set
  * buffer_new
  */
-static void clean_blockdev_aliases(struct dio *dio)
+static void clean_blockdev_aliases(struct dio *dio, struct buffer_head *map_bh)
 {
 	unsigned i;
 	unsigned nblocks;
 
-	nblocks = dio->map_bh.b_size >> dio->inode->i_blkbits;
+	nblocks = map_bh->b_size >> dio->inode->i_blkbits;
 
 	for (i = 0; i < nblocks; i++) {
-		unmap_underlying_metadata(dio->map_bh.b_bdev,
-					dio->map_bh.b_blocknr + i);
+		unmap_underlying_metadata(map_bh->b_bdev,
+					  map_bh->b_blocknr + i);
 	}
 }
 
@@ -837,7 +842,8 @@ static void clean_blockdev_aliases(struct dio *dio)
  * `end' is zero if we're doing the start of the IO, 1 at the end of the
  * IO.
  */
-static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end)
+static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
+			   struct buffer_head *map_bh)
 {
 	unsigned dio_blocks_per_fs_block;
 	unsigned this_chunk_blocks;	/* In dio_blocks */
@@ -845,7 +851,7 @@ static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end)
 	struct page *page;
 
 	sdio->start_zero_done = 1;
-	if (!sdio->blkfactor || !buffer_new(&dio->map_bh))
+	if (!sdio->blkfactor || !buffer_new(map_bh))
 		return;
 
 	dio_blocks_per_fs_block = 1 << sdio->blkfactor;
@@ -865,7 +871,7 @@ static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end)
 
 	page = ZERO_PAGE(0);
 	if (submit_page_section(dio, sdio, page, 0, this_chunk_bytes, 
-				sdio->next_block_for_io))
+				sdio->next_block_for_io, map_bh))
 		return;
 
 	sdio->next_block_for_io += this_chunk_blocks;
@@ -887,13 +893,13 @@ static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end)
  * it should set b_size to PAGE_SIZE or more inside get_block().  This gives
  * fine alignment but still allows this function to work in PAGE_SIZE units.
  */
-static int do_direct_IO(struct dio *dio, struct dio_submit *sdio)
+static int do_direct_IO(struct dio *dio, struct dio_submit *sdio,
+			struct buffer_head *map_bh)
 {
 	const unsigned blkbits = sdio->blkbits;
 	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
 	struct page *page;
 	unsigned block_in_page;
-	struct buffer_head *map_bh = &dio->map_bh;
 	int ret = 0;
 
 	/* The I/O can start at any block offset within the first page */
@@ -919,7 +925,7 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio)
 				unsigned long blkmask;
 				unsigned long dio_remainder;
 
-				ret = get_more_blocks(dio, sdio);
+				ret = get_more_blocks(dio, sdio, map_bh);
 				if (ret) {
 					page_cache_release(page);
 					goto out;
@@ -932,7 +938,7 @@ static int do_direct_IO(struct dio *dio, struct dio_submit *sdio)
 				sdio->next_block_for_io =
 					map_bh->b_blocknr << sdio->blkfactor;
 				if (buffer_new(map_bh))
-					clean_blockdev_aliases(dio);
+					clean_blockdev_aliases(dio, map_bh);
 
 				if (!sdio->blkfactor)
 					goto do_holes;
@@ -991,7 +997,7 @@ do_holes:
 			 * we must zero out the start of this block.
 			 */
 			if (unlikely(sdio->blkfactor && !sdio->start_zero_done))
-				dio_zero_block(dio, sdio, 0);
+				dio_zero_block(dio, sdio, 0, map_bh);
 
 			/*
 			 * Work out, in this_chunk_blocks, how much disk we
@@ -1009,7 +1015,7 @@ do_holes:
 
 			sdio->boundary = buffer_boundary(map_bh);
 			ret = submit_page_section(dio, sdio, page, offset_in_page,
-				this_chunk_bytes, sdio->next_block_for_io);
+				  this_chunk_bytes, sdio->next_block_for_io, map_bh);
 			if (ret) {
 				page_cache_release(page);
 				goto out;
@@ -1045,6 +1051,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	ssize_t ret = 0;
 	ssize_t ret2;
 	size_t bytes;
+	struct buffer_head map_bh = { 0, };
 
 	dio->inode = inode;
 	dio->rw = rw;
@@ -1099,7 +1106,7 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 		sdio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 		sdio->curr_user_address = user_addr;
 	
-		ret = do_direct_IO(dio, sdio);
+		ret = do_direct_IO(dio, sdio, &map_bh);
 
 		dio->result += iov[seg].iov_len -
 			((sdio->final_block_in_request - sdio->block_in_file) <<
@@ -1122,10 +1129,10 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	 * There may be some unwritten disk at the end of a part-written
 	 * fs-block-sized block.  Go zero that now.
 	 */
-	dio_zero_block(dio, sdio, 1);
+	dio_zero_block(dio, sdio, 1, &map_bh);
 
 	if (sdio->cur_page) {
-		ret2 = dio_send_cur_page(dio, sdio);
+		ret2 = dio_send_cur_page(dio, sdio, &map_bh);
 		if (ret == 0)
 			ret = ret2;
 		page_cache_release(sdio->cur_page);
-- 
1.7.4.4

