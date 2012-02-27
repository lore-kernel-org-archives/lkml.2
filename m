Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab2B0VXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:23:23 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30106 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2B0VU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 13/22] dio: add __blockdev_direct_IO_bdev()
Date: Mon, 27 Feb 2012 15:19:27 -0600
Message-Id: <1330377576-3659-14-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F4BF399.00D4,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

Previous patches refactored __blockdev_direct_IO() to call helper
functions while iterating over the user's iovec.  This adds a
__blockdev_direct_IO() which is the same except that it iterates over
the pages in a bio_vec instead of user addresses in an iovec.

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
 fs/direct-io.c     |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |   26 ++++++++++++++++
 2 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 20bb84c..2fef85f 100644
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
@@ -420,7 +421,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-	if (dio->is_async && dio->rw == READ)
+	if (dio->is_async && dio->rw == READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
 	if (sdio->submit_io)
@@ -491,13 +492,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
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
@@ -1336,6 +1338,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 				PAGE_SIZE - user_addr / PAGE_SIZE);
 	}
 
+	dio->should_dirty = 1;
+
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		sdio.size += bytes = iov[seg].iov_len;
@@ -1400,6 +1404,84 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 
 EXPORT_SYMBOL(__blockdev_direct_IO);
 
+ssize_t
+__blockdev_direct_IO_bvec(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, struct bio_vec *bvec, loff_t offset,
+	unsigned long bvec_len, get_block_t get_block,
+	dio_iodone_t end_io, dio_submit_t submit_io, int flags)
+{
+	unsigned blkbits = inode->i_blkbits;
+	ssize_t retval = -EINVAL;
+	loff_t end = offset;
+	struct dio *dio;
+	struct dio_submit sdio = { 0, };
+	unsigned long i;
+	struct buffer_head map_bh = { 0, };
+
+	if (rw & WRITE)
+		rw = WRITE_ODIRECT;
+
+	if (!dio_aligned(offset, &blkbits, bdev))
+		goto out;
+
+	/* Check the memory alignment.  Blocks cannot straddle pages */
+	for (i = 0; i < bvec_len; i++) {
+		end += bvec[i].bv_len;
+		if (!dio_aligned(bvec[i].bv_len | bvec[i].bv_offset,
+				 &blkbits, bdev))
+			goto out;
+	}
+
+	dio = dio_alloc_init(flags, rw, iocb, inode, end_io, end);
+	retval = -ENOMEM;
+	if (!dio)
+		goto out;
+
+	retval = dio_lock_and_flush(dio, offset, end);
+	if (retval) {
+		kmem_cache_free(dio_cache, dio);
+		goto out;
+	}
+
+	sdio_init(&sdio, inode, offset, blkbits, get_block, submit_io);
+
+	sdio.pages_in_io = bvec_len;
+
+	for (i = 0; i < bvec_len; i++) {
+		sdio.size += bvec[i].bv_len;
+
+		/* Index into the first page of the first block */
+		sdio.first_block_in_page = bvec[i].bv_offset >> blkbits;
+		sdio.final_block_in_request = sdio.block_in_file +
+						(bvec[i].bv_len  >> blkbits);
+		/* Page fetching state */
+		sdio.curr_page = 0;
+		page_cache_get(bvec[i].bv_page);
+		dio->pages[0] = bvec[i].bv_page;
+		sdio.head = 0;
+		sdio.tail = 1;
+
+		sdio.total_pages = 1;
+		sdio.curr_user_address = 0;
+
+		retval = do_direct_IO(dio, &sdio, &map_bh);
+
+		dio->result += bvec[i].bv_len -
+			((sdio.final_block_in_request - sdio.block_in_file) <<
+					blkbits);
+
+		if (retval) {
+			dio_cleanup(dio, &sdio);
+			break;
+		}
+	}
+
+	retval = dio_post_submission(rw, offset, dio, &sdio, &map_bh, retval);
+out:
+	return retval;
+}
+EXPORT_SYMBOL(__blockdev_direct_IO_bvec);
+
 static __init int dio_init(void)
 {
 	dio_cache = KMEM_CACHE(dio, SLAB_PANIC);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4750933..94f2d0a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -692,6 +692,8 @@ struct address_space_operations {
 	void (*freepage)(struct page *);
 	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO_bvec)(int, struct kiocb *, struct bio_vec *bvec,
+			loff_t offset, unsigned long bvec_len);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
@@ -2530,6 +2532,30 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 				    offset, nr_segs, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
+
+ssize_t __blockdev_direct_IO_bvec(int rw, struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, struct bio_vec *bvec,
+	loff_t offset, unsigned long bvec_len, get_block_t get_block,
+	dio_iodone_t end_io, dio_submit_t submit_io, int flags);
+
+static inline ssize_t blockdev_direct_IO_bvec(int rw, struct kiocb *iocb,
+	struct inode *inode, struct block_device *bdev, struct bio_vec *bvec,
+	loff_t offset, unsigned long bvec_len, get_block_t get_block,
+	dio_iodone_t end_io)
+{
+	return __blockdev_direct_IO_bvec(rw, iocb, inode, bdev, bvec, offset,
+				bvec_len, get_block, end_io, NULL,
+				DIO_LOCKING | DIO_SKIP_HOLES);
+}
+
+static inline ssize_t blockdev_direct_IO_bvec_no_locking(int rw,
+	struct kiocb *iocb, struct inode *inode, struct block_device *bdev,
+	struct bio_vec *bvec, loff_t offset, unsigned long bvec_len,
+	get_block_t get_block, dio_iodone_t end_io)
+{
+	return __blockdev_direct_IO_bvec(rw, iocb, inode, bdev, bvec, offset,
+				bvec_len, get_block, end_io, NULL, 0);
+}
 #else
 static inline void inode_dio_wait(struct inode *inode)
 {
-- 
1.7.9.2

