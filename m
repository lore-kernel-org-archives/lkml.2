Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2KVTdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:33:01 -0500
Received: from aserp1050.oracle.com ([141.146.126.70]:40537 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab2KVTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:32:58 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 11/31] dio: add bio_vec support to __blockdev_direct_IO()
Date: Wed, 21 Nov 2012 16:40:51 -0600
Message-Id: <1353537671-26284-12-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: aserp1040.oracle.com [141.146.126.69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trick here is to initialize the dio state so that do_direct_IO()
consumes the pages we provide and never tries to map user pages.  This
is done by making sure that final_block_in_request covers the page that
we set in the dio.  do_direct_IO() will return before running out of
pages.

The caller is responsible for dirtying these pages, if needed.  We add
an option to the dio struct that makes sure we only dirty pages when
we're operating on iovecs of user addresses.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/direct-io.c | 185 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 133 insertions(+), 52 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e2733e4..8417a3f 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -126,6 +126,7 @@ struct dio {
 	spinlock_t bio_lock;		/* protects BIO fields below */
 	int page_errors;		/* errno from get_user_pages() */
 	int is_async;			/* is IO async ? */
+	int should_dirty;		/* should we mark read pages dirty? */
 	int io_error;			/* IO error in completion path */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
@@ -376,7 +377,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-	if (dio->is_async && dio->rw == READ)
+	if (dio->is_async && dio->rw == READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
@@ -447,13 +448,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	if (!uptodate)
 		dio->io_error = -EIO;
 
-	if (dio->is_async && dio->rw == READ) {
+	if (dio->is_async && dio->rw == READ && dio->should_dirty) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
 			struct page *page = bvec[page_no].bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (dio->rw == READ && !PageCompound(page) &&
+			    dio->should_dirty)
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
@@ -1052,6 +1054,101 @@ static int dio_aligned(unsigned long offset, unsigned *blkbits,
 	return 1;
 }
 
+static ssize_t direct_IO_iovec(const struct iovec *iov, unsigned long nr_segs,
+			       struct dio *dio, struct dio_submit *sdio,
+			       unsigned blkbits, struct buffer_head *map_bh)
+{
+	size_t bytes;
+	ssize_t retval = 0;
+	int seg;
+	unsigned long user_addr;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		user_addr = (unsigned long)iov[seg].iov_base;
+		sdio->pages_in_io +=
+			((user_addr + iov[seg].iov_len + PAGE_SIZE-1) /
+				PAGE_SIZE - user_addr / PAGE_SIZE);
+	}
+
+	dio->should_dirty = 1;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		user_addr = (unsigned long)iov[seg].iov_base;
+		sdio->size += bytes = iov[seg].iov_len;
+
+		/* Index into the first page of the first block */
+		sdio->first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
+		sdio->final_block_in_request = sdio->block_in_file +
+						(bytes >> blkbits);
+		/* Page fetching state */
+		sdio->head = 0;
+		sdio->tail = 0;
+		sdio->curr_page = 0;
+
+		sdio->total_pages = 0;
+		if (user_addr & (PAGE_SIZE-1)) {
+			sdio->total_pages++;
+			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
+		}
+		sdio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+		sdio->curr_user_address = user_addr;
+
+		retval = do_direct_IO(dio, sdio, map_bh);
+
+		dio->result += iov[seg].iov_len -
+			((sdio->final_block_in_request - sdio->block_in_file) <<
+					blkbits);
+
+		if (retval) {
+			dio_cleanup(dio, sdio);
+			break;
+		}
+	} /* end iovec loop */
+
+	return retval;
+}
+
+static ssize_t direct_IO_bvec(struct bio_vec *bvec, unsigned long nr_segs,
+			      struct dio *dio, struct dio_submit *sdio,
+			      unsigned blkbits, struct buffer_head *map_bh)
+{
+	ssize_t retval = 0;
+	int seg;
+
+	sdio->pages_in_io += nr_segs;
+
+	for (seg = 0; seg < nr_segs; seg++) {
+		sdio->size += bvec[seg].bv_len;
+
+		/* Index into the first page of the first block */
+		sdio->first_block_in_page = bvec[seg].bv_offset >> blkbits;
+		sdio->final_block_in_request = sdio->block_in_file +
+						(bvec[seg].bv_len  >> blkbits);
+		/* Page fetching state */
+		sdio->curr_page = 0;
+		page_cache_get(bvec[seg].bv_page);
+		dio->pages[0] = bvec[seg].bv_page;
+		sdio->head = 0;
+		sdio->tail = 1;
+
+		sdio->total_pages = 1;
+		sdio->curr_user_address = 0;
+
+		retval = do_direct_IO(dio, sdio, map_bh);
+
+		dio->result += bvec[seg].bv_len -
+			((sdio->final_block_in_request - sdio->block_in_file) <<
+					blkbits);
+
+		if (retval) {
+			dio_cleanup(dio, sdio);
+			break;
+		}
+	}
+
+	return retval;
+}
+
 /*
  * This is a library function for use by filesystem drivers.
  *
@@ -1091,11 +1188,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	loff_t end = offset;
 	struct dio *dio;
 	struct dio_submit sdio = { 0, };
-	unsigned long user_addr;
-	size_t bytes;
 	struct buffer_head map_bh = { 0, };
 	struct blk_plug plug;
-	const struct iovec *iov = iov_iter_iovec(iter);
 	unsigned long nr_segs = iter->nr_segs;
 
 	if (rw & WRITE)
@@ -1105,13 +1199,33 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		goto out;
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < nr_segs; seg++) {
-		addr = (unsigned long)iov[seg].iov_base;
-		size = iov[seg].iov_len;
-		end += size;
-		if (!dio_aligned(addr|size, &blkbits, bdev))
-			goto out;
-	}
+	if (iov_iter_has_iovec(iter)) {
+		const struct iovec *iov = iov_iter_iovec(iter);
+
+		for (seg = 0; seg < nr_segs; seg++) {
+			addr = (unsigned long)iov[seg].iov_base;
+			size = iov[seg].iov_len;
+			end += size;
+			if (!dio_aligned(addr|size, &blkbits, bdev))
+				goto out;
+		}
+	} else if (iov_iter_has_bvec(iter)) {
+		/*
+		 * Is this necessary, or can we trust the in-kernel
+		 * caller? Can we replace this with
+		 *	end += iov_iter_count(iter); ?
+		 */
+		struct bio_vec *bvec = iov_iter_bvec(iter);
+
+		for (seg = 0; seg < nr_segs; seg++) {
+			addr = bvec[seg].bv_offset;
+			size = bvec[seg].bv_len;
+			end += size;
+			if (!dio_aligned(addr|size, &blkbits, bdev))
+				goto out;
+		}
+	} else
+		BUG();
 
 	/* watch out for a 0 len io from a tricksy fs */
 	if (rw == READ && end == offset)
@@ -1188,47 +1302,14 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (unlikely(sdio.blkfactor))
 		sdio.pages_in_io = 2;
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		sdio.pages_in_io +=
-			((user_addr + iov[seg].iov_len + PAGE_SIZE-1) /
-				PAGE_SIZE - user_addr / PAGE_SIZE);
-	}
-
 	blk_start_plug(&plug);
 
-	for (seg = 0; seg < nr_segs; seg++) {
-		user_addr = (unsigned long)iov[seg].iov_base;
-		sdio.size += bytes = iov[seg].iov_len;
-
-		/* Index into the first page of the first block */
-		sdio.first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
-		sdio.final_block_in_request = sdio.block_in_file +
-						(bytes >> blkbits);
-		/* Page fetching state */
-		sdio.head = 0;
-		sdio.tail = 0;
-		sdio.curr_page = 0;
-
-		sdio.total_pages = 0;
-		if (user_addr & (PAGE_SIZE-1)) {
-			sdio.total_pages++;
-			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
-		}
-		sdio.total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
-		sdio.curr_user_address = user_addr;
-
-		retval = do_direct_IO(dio, &sdio, &map_bh);
-
-		dio->result += iov[seg].iov_len -
-			((sdio.final_block_in_request - sdio.block_in_file) <<
-					blkbits);
-
-		if (retval) {
-			dio_cleanup(dio, &sdio);
-			break;
-		}
-	} /* end iovec loop */
+	if (iov_iter_has_iovec(iter))
+		retval = direct_IO_iovec(iov_iter_iovec(iter), nr_segs, dio,
+					 &sdio, blkbits, &map_bh);
+	else
+		retval = direct_IO_bvec(iov_iter_bvec(iter), nr_segs, dio,
+					&sdio, blkbits, &map_bh);
 
 	if (retval == -ENOTBLK) {
 		/*
-- 
1.8.0

