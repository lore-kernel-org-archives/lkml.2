Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1FTXRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:17:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab1FTXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:17:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=uPrmTupYE73wiStVCecbjLK9EM3CuvTMr2/4sdpQ0PHtI+7A35C3v+g23NFdjSkL8
	Giq1K8wJ6HfpivSj6z9GQ==
From: Dan Ehrenberg <dehrenberg@google.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Ehrenberg <dehrenberg@google.com>
Subject: [PATCH] dio: Fast-path for page-aligned IOs
Date: Mon, 20 Jun 2011 16:17:35 -0700
Message-Id: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code introduces a fast-path variant of __blockdev_direct_IO
for the special case where the request size is a multiple of the page
size, the inode block size is a page, the user memory is page-aligned,
the underlying storage is contiguous on disk and the file location is
already initialized. The special case decreases the amount of
bookkeeping required, which saves a significant amount of CPU time on
a fast device such as a ramdisk or an SSD.  The patch is inspired by
earlier code by Ken Chen.

In my testing, this patch saves around a quarter of system time
compared to the old version when executed on a workload of 4k
random read operations on a high performance SSD. It does this
by nearly eliminating the CPU usage from fs/direct-io.c.  It only
works for this particular special case which we find to be common
in our workloads.

With hard drives, this optimization is less relevant because
(a) the long latency of a seek will mask most of this CPU time, and
(b) applications issue fewer, larger requests to minimize seeks,
thereby minimizing the CPU overhead from this code path. But on SSDs,
the drive makes requests as small as a page size fast. It is common
to use direct I/O here because the page cache overhead is easily
visible. And it is common to use operations which are multiples of
page size rather than smaller ones because most SSDs use 4k or bigger
blocks at the lowest level, even if the firmware may expose smaller
blocks.

The fast path does not apply for operations of the wrong size
or alignmnent, or for operations on raw drives with 512-byte sectors.
It might be possible to make this special case a little more general
while maintaining its performance benefits, but I do not believe that
the full performance benefits can be achieved without resorting to
special handling of simple cases, as is done in this patch.

Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
---
Changelog since v1:
  The original patch I sent was accidentally written for
  2.4.34. This version is forward-ported the patch to what's
  currently in upstream.

 fs/direct-io.c |  294 +++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 269 insertions(+), 25 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index ac5f164..aa2c369 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -38,6 +38,10 @@
 #include <asm/atomic.h>
 
 /*
+ * General case implementation of __blockdev_direct_IO
+ */
+
+/*
  * How many user pages to map in one call to get_user_pages().  This determines
  * the size of a structure on the stack.
  */
@@ -428,22 +432,22 @@ static struct bio *dio_await_one(struct dio *dio)
 /*
  * Process one completed BIO.  No locks are held.
  */
-static int dio_bio_complete(struct dio *dio, struct bio *bio)
+static int __dio_bio_complete(struct bio *bio, int is_async, int rw, int *error)
 {
 	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec = bio->bi_io_vec;
 	int page_no;
 
 	if (!uptodate)
-		dio->io_error = -EIO;
+		*error = -EIO;
 
-	if (dio->is_async && dio->rw == READ) {
+	if (is_async && rw == READ) {
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		for (page_no = 0; page_no < bio->bi_vcnt; page_no++) {
 			struct page *page = bvec[page_no].bv_page;
 
-			if (dio->rw == READ && !PageCompound(page))
+			if (rw == READ && !PageCompound(page))
 				set_page_dirty_lock(page);
 			page_cache_release(page);
 		}
@@ -452,6 +456,11 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	return uptodate ? 0 : -EIO;
 }
 
+static int dio_bio_complete(struct dio *dio, struct bio *bio)
+{
+	return __dio_bio_complete(bio, dio->is_async, dio->rw, &dio->io_error);
+}
+
 /*
  * Wait on and process all in-flight BIOs.  This must only be called once
  * all bios have been issued so that the refcount can only decrease.
@@ -1137,27 +1146,8 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	return ret;
 }
 
-/*
- * This is a library function for use by filesystem drivers.
- *
- * The locking rules are governed by the flags parameter:
- *  - if the flags value contains DIO_LOCKING we use a fancy locking
- *    scheme for dumb filesystems.
- *    For writes this function is called under i_mutex and returns with
- *    i_mutex held, for reads, i_mutex is not held on entry, but it is
- *    taken and dropped again before returning.
- *    For reads and writes i_alloc_sem is taken in shared mode and released
- *    on I/O completion (which may happen asynchronously after returning to
- *    the caller).
- *
- *  - if the flags value does NOT contain DIO_LOCKING we don't use any
- *    internal locking but rather rely on the filesystem to synchronize
- *    direct I/O reads/writes versus each other and truncate.
- *    For reads and writes both i_mutex and i_alloc_sem are not held on
- *    entry and are never taken.
- */
-ssize_t
-__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+static ssize_t
+dio_generic(int rw, struct kiocb *iocb, struct inode *inode,
 	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
@@ -1253,4 +1243,258 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 out:
 	return retval;
 }
+
+/*
+ * Special case for __blockdev_direct_IO:
+ * page-aligned page-sized IOs when the inode block size is page-sized.
+ *
+ * The following code does the exact same thing as the above
+ * general-case code, but the smaller amount of bookkeeping
+ * has a big impact on CPU usage, which is visible on fast
+ * devices like SSDs.
+ */
+
+/*
+ * struct mini_dio has a subset of the fields in struct dio.
+ * For comments on fields, see that struct definition.
+ */
+struct mini_dio {
+	/* The following struct items are needed in the completion. */
+	dio_iodone_t *end_io;
+	struct kiocb *iocb;
+	loff_t offset;
+	int rw;
+	int flags;
+	struct inode *inode;
+	size_t size;
+
+	/*
+	 * The following struct items are allocated just because
+	 * they're big, and they are only used during submission.
+	 */
+	struct buffer_head map_bh;
+	struct page *pages[DIO_PAGES];
+};
+
+/*
+ * In this function we treat everything as if it's AIO to simplify the logic.
+ * The AIO code paths also handle the synchronous case appropriately.
+ */
+static void dio_fast_end_aio(struct bio *bio, int error)
+{
+	struct mini_dio *mdio = bio->bi_private;
+	struct kiocb *iocb = mdio->iocb;
+	int res;
+
+	__dio_bio_complete(bio, 1, mdio->rw, &error);
+
+	/* Could it be some other value? */
+	res = (error < 0) ? error : mdio->size;
+
+	if (mdio->end_io)
+		mdio->end_io(iocb, mdio->offset, res,
+			     mdio->map_bh.b_private, 0, 1);
+	else
+		aio_complete(iocb, res, 0);
+
+	if (mdio->flags & DIO_LOCKING)
+		up_read_non_owner(&mdio->inode->i_alloc_sem);
+
+	kfree(mdio);
+}
+
+static ssize_t dio_fast(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
+{
+	struct bio *bio;
+	struct mini_dio *mdio;
+	int res, i;
+	size_t size = iov[0].iov_len;
+	int num_pages = size >> PAGE_SHIFT;
+
+	mdio = kmalloc(sizeof(*mdio), GFP_KERNEL);
+	if (mdio == NULL)
+		goto fallback;
+	mdio->end_io = end_io;
+	mdio->iocb = iocb;
+	mdio->offset = offset;
+	mdio->rw = rw;
+	mdio->flags = flags;
+	mdio->inode = inode;
+	mdio->size = size;
+	/* get_block expects a partially initialized bh */
+	mdio->map_bh.b_size = size;
+	mdio->map_bh.b_state = 0;
+
+	res = get_user_pages_fast(
+		(unsigned long)iov[0].iov_base,	/* Where from */
+		num_pages,			/* How many pages */
+		rw == READ,			/* Write to memory? */
+		mdio->pages);			/* Put results here */
+	if (res < 0)
+		goto fallback_free;
+	if (res != num_pages) {
+		num_pages = res;	/* Used for how many to free */
+		goto fallback_pages;
+	}
+
+	if (flags & DIO_LOCKING) {
+		if (rw == READ) {
+			struct address_space *mapping =
+					iocb->ki_filp->f_mapping;
+
+			mutex_lock(&inode->i_mutex);
+
+			res = filemap_write_and_wait_range(
+				mapping, offset,
+				offset + size - 1);
+			if (res != 0)
+				goto fallback_unlock;
+		}
+
+		/*
+		 * The i_alloc_sem will be released at I/O completion,
+		 * possibly in a different thread.
+		 */
+		down_read_non_owner(&inode->i_alloc_sem);
+	}
+
+
+	if ((*get_block)(inode, offset >> PAGE_SHIFT, &mdio->map_bh, 0) != 0)
+		goto fallback_sem_up;
+	if (!buffer_mapped(&mdio->map_bh) || mdio->map_bh.b_size != size)
+		/*
+		 * Bail out to the general case.
+		 *
+		 * If the first condition is false, we've either
+		 * encountered a file hole, or we are appending to
+		 * the end of the file.
+		 *
+		 * The second condition will only be false if the
+		 * file system returns a mapping shorter than the
+		 * total size. Here, we only handle physically
+		 * contiguous mappings, which can be implemented
+		 * with a single bio.
+		 */
+		goto fallback_sem_up;
+	bio = bio_alloc(GFP_KERNEL, num_pages);
+	bio->bi_bdev = mdio->map_bh.b_bdev;
+	bio->bi_end_io = dio_fast_end_aio;
+	bio->bi_private = mdio;
+	/*
+	 * On this fast path, inode->i_blkbits is guaranteed
+	 * to be equal to PAGE_SIZE
+	 */
+	bio->bi_sector = mdio->map_bh.b_blocknr << (PAGE_SHIFT - 9);
+
+	for (i = 0; i < num_pages; i++) {
+		if (bio_add_page(bio, mdio->pages[i], PAGE_SIZE, 0)
+				!= PAGE_SIZE) {
+			bio_put(bio);
+			goto fallback_sem_up;
+		}
+	}
+	/* bio is ready, submit it */
+	if (rw == READ)
+		bio_set_pages_dirty(bio);
+	if (submit_io == NULL)
+		submit_bio(rw, bio);
+	else
+		submit_io(rw, bio, inode, offset);
+	mutex_unlock(&inode->i_mutex);
+	return -EIOCBQUEUED;
+
+fallback_sem_up:
+	if (flags & DIO_LOCKING)
+		up_read_non_owner(&inode->i_alloc_sem);
+fallback_unlock:
+	if ((flags & DIO_LOCKING) && rw == READ)
+		mutex_unlock(&inode->i_mutex);
+fallback_pages:
+	for (i = 0; i < num_pages; i++)
+		page_cache_release(mdio->pages[i]);
+fallback_free:
+	kfree(mdio);
+
+fallback:	/* Bail out to the general case */
+	return dio_generic(rw, iocb, inode,
+			bdev, iov, offset, 1,
+			get_block, end_io, submit_io, flags);
+}
+
+/*
+ * __blockdev_direct_IO - issue a direct I/O request
+ *
+ * This is a library function for use by filesystem drivers in their
+ * direct I/O routine. It translates an I/O request into bios and
+ * sends those down to the block layer.
+ *
+ * @rw: either READ or WRITE
+ * @iocb: iocb of the request
+ * @inode: inode of the request
+ * @bdev: backing block device
+ * @iov: vector of ranges of user-space memory
+ * @offset: logical byte offset for the start of the IO
+ * @nr_segs: number of elements in iov
+ * @get_block: a callback to map blocks into a buffer_head
+ *    signature: int (*get_block)(struct inode *inode,
+ *		sector_t iblock, struct buffer_head *bh, int create)
+ *    On entry, bh will have its b_size field initialized with the
+ *    length of the request
+ *    On exit, get_block should have initialized bh. get_block returns
+ *    0 on success, or an error code if the block didn't exist. On success,
+ *    the bh will be mapped if possible, or marked as unmapped otherwise.
+ *    The boolean flag create indicates whether an allocation (or
+ *    initializiation) should be attempted if no block is already present for
+ *    the logical block offset iblock.
+ * @end_io: a callback on IO completion, or NULL (defaulting to aio_complete)
+ *    signature: void (*end_io)(struct kiocb *iocb, loff_t offset,
+ *			    ssize_t size, void *private, int ret,
+ *			    bool is_async)
+ *    The private argument is extracted from bh.b_private, allowing get_block to
+ *    pass information to the completion.
+ * @submit_io: a callback used to submit struct bios
+ * @flags: two flags allowed, DIO_LOCKING and DIO_SKIP_HOLES.
+ *    DIO_SKIP_HOLES indicates that this DIO request cannot fill
+ *    in a hole in the middle of a file.
+ *
+ * The locking rules are governed by the flags parameter:
+ *  - if the flags value contains DIO_LOCKING we use a fancy locking
+ *    scheme for dumb filesystems.
+ *    For writes this function is called under i_mutex and returns with
+ *    i_mutex held, for reads, i_mutex is not held on entry, but it is
+ *    taken and dropped again before returning.
+ *    For reads and writes i_alloc_sem is taken in shared mode and released
+ *    on I/O completion (which may happen asynchronously after returning to
+ *    the caller).
+ *
+ *  - if the flags value does NOT contain DIO_LOCKING we don't use any
+ *    internal locking but rather rely on the filesystem to synchronize
+ *    direct I/O reads/writes versus each other and truncate.
+ *    For reads and writes both i_mutex and i_alloc_sem are not held on
+ *    entry and are never taken.
+ */
+ssize_t
+__blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
+	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
+	dio_submit_t submit_io,	int flags)
+{
+	BUG_ON(rw != READ && rw != WRITE);
+	if (inode->i_blkbits == PAGE_SHIFT
+	    && nr_segs == 1
+	    && IS_ALIGNED(offset, PAGE_SIZE)
+	    && IS_ALIGNED((unsigned long)iov[0].iov_base, PAGE_SIZE)
+	    && IS_ALIGNED(iov[0].iov_len, PAGE_SIZE)
+	    && iov[0].iov_len >> PAGE_SHIFT <= DIO_PAGES)
+		return dio_fast(rw, iocb, inode,
+				bdev, iov, offset,
+				get_block, end_io, submit_io, flags);
+
+	return dio_generic(rw, iocb, inode,
+			bdev, iov, offset,
+			nr_segs, get_block, end_io, submit_io, flags);
+}
 EXPORT_SYMBOL(__blockdev_direct_IO);
-- 
1.7.3.1

