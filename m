Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823Ab2EQMwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761799Ab2EQMsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:41 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/24] GFS2: Clean up log write code path
Date: Thu, 17 May 2012 13:23:17 +0100
Message-Id: <1337257411-3173-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to this patch, we have two ways of sending i/o to the log.
One of those is used when we need to allocate both the data
to be written itself and also a buffer head to submit it. This
is done via sb_getblk and friends. This is used mostly for writing
log headers.

The other method is used when writing blocks which have some
in-place counterpart. This is the case for all the metadata
blocks which are journalled, and when journaled data is in use,
for unescaped journalled data blocks.

This patch replaces both of those two methods, and about half
a dozen separate i/o submission points with a single i/o
submission function. We also go direct to bio rather than
using buffer heads, since this allows us to build i/o
requests of the maximum size for the block device in
question. It also reduces the memory required for flushing
the log, which can be very useful in low memory situations.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 47d0bda..dd97f64 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -716,7 +716,9 @@ struct gfs2_sbd {
 
 	struct rw_semaphore sd_log_flush_lock;
 	atomic_t sd_log_in_flight;
+	struct bio *sd_log_bio;
 	wait_queue_head_t sd_log_flush_wait;
+	int sd_log_error;
 
 	unsigned int sd_log_flush_head;
 	u64 sd_log_flush_wrapped;
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index d886a17..f5eacb3 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -357,18 +357,6 @@ retry:
 	return 0;
 }
 
-u64 gfs2_log_bmap(struct gfs2_sbd *sdp, unsigned int lbn)
-{
-	struct gfs2_journal_extent *je;
-
-	list_for_each_entry(je, &sdp->sd_jdesc->extent_list, extent_list) {
-		if (lbn >= je->lblock && lbn < je->lblock + je->blocks)
-			return je->dblock + lbn - je->lblock;
-	}
-
-	return -1;
-}
-
 /**
  * log_distance - Compute distance between two journal blocks
  * @sdp: The GFS2 superblock
@@ -464,17 +452,6 @@ static unsigned int current_tail(struct gfs2_sbd *sdp)
 	return tail;
 }
 
-void gfs2_log_incr_head(struct gfs2_sbd *sdp)
-{
-	BUG_ON((sdp->sd_log_flush_head == sdp->sd_log_tail) &&
-	       (sdp->sd_log_flush_head != sdp->sd_log_head));
-
-	if (++sdp->sd_log_flush_head == sdp->sd_jdesc->jd_blocks) {
-		sdp->sd_log_flush_head = 0;
-		sdp->sd_log_flush_wrapped = 1;
-	}
-}
-
 static void log_pull_tail(struct gfs2_sbd *sdp, unsigned int new_tail)
 {
 	unsigned int dist = log_distance(sdp, new_tail, sdp->sd_log_tail);
@@ -580,23 +557,17 @@ static void gfs2_ordered_wait(struct gfs2_sbd *sdp)
 
 static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 {
-	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
-	struct buffer_head *bh;
 	struct gfs2_log_header *lh;
 	unsigned int tail;
 	u32 hash;
-
-	bh = sb_getblk(sdp->sd_vfs, blkno);
-	lock_buffer(bh);
-	memset(bh->b_data, 0, bh->b_size);
-	set_buffer_uptodate(bh);
-	clear_buffer_dirty(bh);
+	int rw = WRITE_FLUSH_FUA | REQ_META;
+	struct page *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
+	lh = page_address(page);
+	clear_page(lh);
 
 	gfs2_ail1_empty(sdp);
 	tail = current_tail(sdp);
 
-	lh = (struct gfs2_log_header *)bh->b_data;
-	memset(lh, 0, sizeof(struct gfs2_log_header));
 	lh->lh_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
 	lh->lh_header.mh_type = cpu_to_be32(GFS2_METATYPE_LH);
 	lh->lh_header.__pad0 = cpu_to_be64(0);
@@ -606,29 +577,22 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
 	lh->lh_flags = cpu_to_be32(flags);
 	lh->lh_tail = cpu_to_be32(tail);
 	lh->lh_blkno = cpu_to_be32(sdp->sd_log_flush_head);
-	hash = gfs2_disk_hash(bh->b_data, sizeof(struct gfs2_log_header));
+	hash = gfs2_disk_hash(page_address(page), sizeof(struct gfs2_log_header));
 	lh->lh_hash = cpu_to_be32(hash);
 
-	bh->b_end_io = end_buffer_write_sync;
-	get_bh(bh);
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags)) {
 		gfs2_ordered_wait(sdp);
 		log_flush_wait(sdp);
-		submit_bh(WRITE_SYNC | REQ_META | REQ_PRIO, bh);
-	} else {
-		submit_bh(WRITE_FLUSH_FUA | REQ_META, bh);
+		rw = WRITE_SYNC | REQ_META | REQ_PRIO;
 	}
-	wait_on_buffer(bh);
 
-	if (!buffer_uptodate(bh))
-		gfs2_io_error_bh(sdp, bh);
-	brelse(bh);
+	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
+	gfs2_log_write_page(sdp, page);
+	gfs2_log_flush_bio(sdp, rw);
+	log_flush_wait(sdp);
 
 	if (sdp->sd_log_tail != tail)
 		log_pull_tail(sdp, tail);
-
-	sdp->sd_log_idle = (tail == sdp->sd_log_flush_head);
-	gfs2_log_incr_head(sdp);
 }
 
 /**
@@ -674,6 +638,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 
 	gfs2_ordered_write(sdp);
 	lops_before_commit(sdp);
+	gfs2_log_flush_bio(sdp, WRITE);
 
 	if (sdp->sd_log_head != sdp->sd_log_flush_head) {
 		log_write_header(sdp, 0);
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index ff07454..3fd5215 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -52,8 +52,6 @@ extern unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 			    unsigned int ssize);
 
 extern int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
-extern void gfs2_log_incr_head(struct gfs2_sbd *sdp);
-extern u64 gfs2_log_bmap(struct gfs2_sbd *sdp, unsigned int lbn);
 extern void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
 extern void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
 extern void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a5937b3..872d3e6 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -127,118 +127,256 @@ static void gfs2_unpin(struct gfs2_sbd *sdp, struct buffer_head *bh,
 	atomic_dec(&sdp->sd_log_pinned);
 }
 
-
-static inline struct gfs2_log_descriptor *bh_log_desc(struct buffer_head *bh)
+static void gfs2_log_incr_head(struct gfs2_sbd *sdp)
 {
-	return (struct gfs2_log_descriptor *)bh->b_data;
+	BUG_ON((sdp->sd_log_flush_head == sdp->sd_log_tail) &&
+	       (sdp->sd_log_flush_head != sdp->sd_log_head));
+
+	if (++sdp->sd_log_flush_head == sdp->sd_jdesc->jd_blocks) {
+		sdp->sd_log_flush_head = 0;
+		sdp->sd_log_flush_wrapped = 1;
+	}
 }
 
-static inline __be64 *bh_log_ptr(struct buffer_head *bh)
+static u64 gfs2_log_bmap(struct gfs2_sbd *sdp)
 {
-	struct gfs2_log_descriptor *ld = bh_log_desc(bh);
-	return (__force __be64 *)(ld + 1);
+	unsigned int lbn = sdp->sd_log_flush_head;
+	struct gfs2_journal_extent *je;
+	u64 block;
+
+	list_for_each_entry(je, &sdp->sd_jdesc->extent_list, extent_list) {
+		if (lbn >= je->lblock && lbn < je->lblock + je->blocks) {
+			block = je->dblock + lbn - je->lblock;
+			gfs2_log_incr_head(sdp);
+			return block;
+		}
+	}
+
+	return -1;
 }
 
-static inline __be64 *bh_ptr_end(struct buffer_head *bh)
+/**
+ * gfs2_end_log_write_bh - end log write of pagecache data with buffers
+ * @sdp: The superblock
+ * @bvec: The bio_vec
+ * @error: The i/o status
+ *
+ * This finds the relavent buffers and unlocks then and sets the
+ * error flag according to the status of the i/o request. This is
+ * used when the log is writing data which has an in-place version
+ * that is pinned in the pagecache.
+ */
+
+static void gfs2_end_log_write_bh(struct gfs2_sbd *sdp, struct bio_vec *bvec,
+				  int error)
 {
-	return (__force __be64 *)(bh->b_data + bh->b_size);
+	struct buffer_head *bh, *next;
+	struct page *page = bvec->bv_page;
+	unsigned size;
+
+	bh = page_buffers(page);
+	size = bvec->bv_len;
+	while (bh_offset(bh) < bvec->bv_offset)
+		bh = bh->b_this_page;
+	do {
+		if (error)
+			set_buffer_write_io_error(bh);
+		unlock_buffer(bh);
+		next = bh->b_this_page;
+		size -= bh->b_size;
+		brelse(bh);
+		bh = next;
+	} while(bh && size);
 }
 
 /**
- * gfs2_log_write_endio - End of I/O for a log buffer
- * @bh: The buffer head
- * @uptodate: I/O Status
+ * gfs2_end_log_write - end of i/o to the log
+ * @bio: The bio
+ * @error: Status of i/o request
+ *
+ * Each bio_vec contains either data from the pagecache or data
+ * relating to the log itself. Here we iterate over the bio_vec
+ * array, processing both kinds of data.
  *
  */
 
-static void gfs2_log_write_endio(struct buffer_head *bh, int uptodate)
+static void gfs2_end_log_write(struct bio *bio, int error)
 {
-	struct gfs2_sbd *sdp = bh->b_private;
-	bh->b_private = NULL;
+	struct gfs2_sbd *sdp = bio->bi_private;
+	struct bio_vec *bvec;
+	struct page *page;
+	int i;
+
+	if (error) {
+		sdp->sd_log_error = error;
+		fs_err(sdp, "Error %d writing to log\n", error);
+	}
+
+	bio_for_each_segment(bvec, bio, i) {
+		page = bvec->bv_page;
+		if (page_has_buffers(page))
+			gfs2_end_log_write_bh(sdp, bvec, error);
+		else
+			mempool_free(page, gfs2_page_pool);
+	}
 
-	end_buffer_write_sync(bh, uptodate);
+	bio_put(bio);
 	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
 		wake_up(&sdp->sd_log_flush_wait);
 }
 
 /**
- * gfs2_log_get_buf - Get and initialize a buffer to use for log control data
- * @sdp: The GFS2 superblock
+ * gfs2_log_flush_bio - Submit any pending log bio
+ * @sdp: The superblock
+ * @rw: The rw flags
  *
- * tReturns: the buffer_head
+ * Submit any pending part-built or full bio to the block device. If
+ * there is no pending bio, then this is a no-op.
  */
 
-static struct buffer_head *gfs2_log_get_buf(struct gfs2_sbd *sdp)
+void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw)
 {
-	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
-	struct buffer_head *bh;
+	if (sdp->sd_log_bio) {
+		atomic_inc(&sdp->sd_log_in_flight);
+		submit_bio(rw, sdp->sd_log_bio);
+		sdp->sd_log_bio = NULL;
+	}
+}
 
-	bh = sb_getblk(sdp->sd_vfs, blkno);
-	lock_buffer(bh);
-	memset(bh->b_data, 0, bh->b_size);
-	set_buffer_uptodate(bh);
-	clear_buffer_dirty(bh);
-	gfs2_log_incr_head(sdp);
-	atomic_inc(&sdp->sd_log_in_flight);
-	bh->b_private = sdp;
-	bh->b_end_io = gfs2_log_write_endio;
+/**
+ * gfs2_log_alloc_bio - Allocate a new bio for log writing
+ * @sdp: The superblock
+ * @blkno: The next device block number we want to write to
+ *
+ * This should never be called when there is a cached bio in the
+ * super block. When it returns, there will be a cached bio in the
+ * super block which will have as many bio_vecs as the device is
+ * happy to handle.
+ *
+ * Returns: Newly allocated bio
+ */
 
-	return bh;
+static struct bio *gfs2_log_alloc_bio(struct gfs2_sbd *sdp, u64 blkno)
+{
+	struct super_block *sb = sdp->sd_vfs;
+	unsigned nrvecs = bio_get_nr_vecs(sb->s_bdev);
+	struct bio *bio;
+
+	BUG_ON(sdp->sd_log_bio);
+
+	while (1) {
+		bio = bio_alloc(GFP_NOIO, nrvecs);
+		if (likely(bio))
+			break;
+		nrvecs = max(nrvecs/2, 1U);
+	}
+
+	bio->bi_sector = blkno * (sb->s_blocksize >> 9);
+	bio->bi_bdev = sb->s_bdev;
+	bio->bi_end_io = gfs2_end_log_write;
+	bio->bi_private = sdp;
+
+	sdp->sd_log_bio = bio;
+
+	return bio;
 }
 
 /**
- * gfs2_fake_write_endio - 
- * @bh: The buffer head
- * @uptodate: The I/O Status
+ * gfs2_log_get_bio - Get cached log bio, or allocate a new one
+ * @sdp: The superblock
+ * @blkno: The device block number we want to write to
+ *
+ * If there is a cached bio, then if the next block number is sequential
+ * with the previous one, return it, otherwise flush the bio to the
+ * device. If there is not a cached bio, or we just flushed it, then
+ * allocate a new one.
  *
+ * Returns: The bio to use for log writes
  */
 
-static void gfs2_fake_write_endio(struct buffer_head *bh, int uptodate)
+static struct bio *gfs2_log_get_bio(struct gfs2_sbd *sdp, u64 blkno)
 {
-	struct buffer_head *real_bh = bh->b_private;
-	struct gfs2_bufdata *bd = real_bh->b_private;
-	struct gfs2_sbd *sdp = bd->bd_gl->gl_sbd;
+	struct bio *bio = sdp->sd_log_bio;
+	u64 nblk;
+
+	if (bio) {
+		nblk = bio->bi_sector + bio_sectors(bio);
+		nblk >>= sdp->sd_fsb2bb_shift;
+		if (blkno == nblk)
+			return bio;
+		gfs2_log_flush_bio(sdp, WRITE);
+	}
 
-	end_buffer_write_sync(bh, uptodate);
-	mempool_free(bh, gfs2_bh_pool);
-	unlock_buffer(real_bh);
-	brelse(real_bh);
-	if (atomic_dec_and_test(&sdp->sd_log_in_flight))
-		wake_up(&sdp->sd_log_flush_wait);
+	return gfs2_log_alloc_bio(sdp, blkno);
 }
 
+
 /**
- * gfs2_log_write_buf - write metadata buffer to log
+ * gfs2_log_write - write to log
  * @sdp: the filesystem
- * @real: the in-place buffer head
+ * @page: the page to write
+ * @size: the size of the data to write
+ * @offset: the offset within the page 
  *
+ * Try and add the page segment to the current bio. If that fails,
+ * submit the current bio to the device and create a new one, and
+ * then add the page segment to that.
  */
 
-static void gfs2_log_write_buf(struct gfs2_sbd *sdp, struct buffer_head *real)
+static void gfs2_log_write(struct gfs2_sbd *sdp, struct page *page,
+			   unsigned size, unsigned offset)
 {
-	u64 blkno = gfs2_log_bmap(sdp, sdp->sd_log_flush_head);
-	struct buffer_head *bh;
+	u64 blkno = gfs2_log_bmap(sdp);
+	struct bio *bio;
+	int ret;
+
+	bio = gfs2_log_get_bio(sdp, blkno);
+	ret = bio_add_page(bio, page, size, offset);
+	if (ret == 0) {
+		gfs2_log_flush_bio(sdp, WRITE);
+		bio = gfs2_log_alloc_bio(sdp, blkno);
+		ret = bio_add_page(bio, page, size, offset);
+		WARN_ON(ret == 0);
+	}
+}
 
-	bh = mempool_alloc(gfs2_bh_pool, GFP_NOFS);
-	atomic_set(&bh->b_count, 1);
-	bh->b_state = (1 << BH_Mapped) | (1 << BH_Uptodate) | (1 << BH_Lock);
-	set_bh_page(bh, real->b_page, bh_offset(real));
-	bh->b_blocknr = blkno;
-	bh->b_size = sdp->sd_sb.sb_bsize;
-	bh->b_bdev = sdp->sd_vfs->s_bdev;
-	bh->b_private = real;
-	bh->b_end_io = gfs2_fake_write_endio;
+/**
+ * gfs2_log_write_bh - write a buffer's content to the log
+ * @sdp: The super block
+ * @bh: The buffer pointing to the in-place location
+ * 
+ * This writes the content of the buffer to the next available location
+ * in the log. The buffer will be unlocked once the i/o to the log has
+ * completed.
+ */
+
+static void gfs2_log_write_bh(struct gfs2_sbd *sdp, struct buffer_head *bh)
+{
+	gfs2_log_write(sdp, bh->b_page, bh->b_size, bh_offset(bh));
+}
 
-	gfs2_log_incr_head(sdp);
-	atomic_inc(&sdp->sd_log_in_flight);
+/**
+ * gfs2_log_write_page - write one block stored in a page, into the log
+ * @sdp: The superblock
+ * @page: The struct page
+ *
+ * This writes the first block-sized part of the page into the log. Note
+ * that the page must have been allocated from the gfs2_page_pool mempool
+ * and that after this has been called, ownership has been transferred and
+ * the page may be freed at any time.
+ */
 
-	submit_bh(WRITE, bh);
+void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page)
+{
+	struct super_block *sb = sdp->sd_vfs;
+	gfs2_log_write(sdp, page, sb->s_blocksize, 0);
 }
 
-static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
+static struct page *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
 {
-	struct buffer_head *bh = gfs2_log_get_buf(sdp);
-	struct gfs2_log_descriptor *ld = bh_log_desc(bh);
+	void *page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
+	struct gfs2_log_descriptor *ld = page_address(page);
+	clear_page(ld);
 	ld->ld_header.mh_magic = cpu_to_be32(GFS2_MAGIC);
 	ld->ld_header.mh_type = cpu_to_be32(GFS2_METATYPE_LD);
 	ld->ld_header.mh_format = cpu_to_be32(GFS2_FORMAT_LD);
@@ -246,8 +384,7 @@ static struct buffer_head *gfs2_get_log_desc(struct gfs2_sbd *sdp, u32 ld_type)
 	ld->ld_length = 0;
 	ld->ld_data1 = 0;
 	ld->ld_data2 = 0;
-	memset(ld->ld_reserved, 0, sizeof(ld->ld_reserved));
-	return bh;
+	return page;
 }
 
 static void buf_lo_add(struct gfs2_sbd *sdp, struct gfs2_log_element *le)
@@ -283,9 +420,9 @@ out:
 
 static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 {
-	struct buffer_head *bh;
 	struct gfs2_log_descriptor *ld;
 	struct gfs2_bufdata *bd1 = NULL, *bd2;
+	struct page *page;
 	unsigned int total;
 	unsigned int limit;
 	unsigned int num;
@@ -303,10 +440,10 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		if (total > limit)
 			num = limit;
 		gfs2_log_unlock(sdp);
-		bh = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_METADATA);
+		page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_METADATA);
+		ld = page_address(page);
 		gfs2_log_lock(sdp);
-		ld = bh_log_desc(bh);
-		ptr = bh_log_ptr(bh);
+		ptr = (__be64 *)(ld + 1);
 		ld->ld_length = cpu_to_be32(num + 1);
 		ld->ld_data1 = cpu_to_be32(num);
 
@@ -319,7 +456,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 		}
 
 		gfs2_log_unlock(sdp);
-		submit_bh(WRITE, bh);
+		gfs2_log_write_page(sdp, page);
 		gfs2_log_lock(sdp);
 
 		n = 0;
@@ -328,7 +465,7 @@ static void buf_lo_before_commit(struct gfs2_sbd *sdp)
 			get_bh(bd2->bd_bh);
 			gfs2_log_unlock(sdp);
 			lock_buffer(bd2->bd_bh);
-			gfs2_log_write_buf(sdp, bd2->bd_bh);
+			gfs2_log_write_bh(sdp, bd2->bd_bh);
 			gfs2_log_lock(sdp);
 			if (++n >= num)
 				break;
@@ -453,16 +590,16 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 {
 	struct gfs2_log_descriptor *ld;
 	struct gfs2_meta_header *mh;
-	struct buffer_head *bh;
 	unsigned int offset;
 	struct list_head *head = &sdp->sd_log_le_revoke;
 	struct gfs2_bufdata *bd;
+	struct page *page;
 
 	if (!sdp->sd_log_num_revoke)
 		return;
 
-	bh = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_REVOKE);
-	ld = bh_log_desc(bh);
+	page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_REVOKE);
+	ld = page_address(page);
 	ld->ld_length = cpu_to_be32(gfs2_struct2blk(sdp, sdp->sd_log_num_revoke,
 						    sizeof(u64)));
 	ld->ld_data1 = cpu_to_be32(sdp->sd_log_num_revoke);
@@ -472,22 +609,23 @@ static void revoke_lo_before_commit(struct gfs2_sbd *sdp)
 		sdp->sd_log_num_revoke--;
 
 		if (offset + sizeof(u64) > sdp->sd_sb.sb_bsize) {
-			submit_bh(WRITE, bh);
 
-			bh = gfs2_log_get_buf(sdp);
-			mh = (struct gfs2_meta_header *)bh->b_data;
+			gfs2_log_write_page(sdp, page);
+			page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
+			mh = page_address(page);
+			clear_page(mh);
 			mh->mh_magic = cpu_to_be32(GFS2_MAGIC);
 			mh->mh_type = cpu_to_be32(GFS2_METATYPE_LB);
 			mh->mh_format = cpu_to_be32(GFS2_FORMAT_LB);
 			offset = sizeof(struct gfs2_meta_header);
 		}
 
-		*(__be64 *)(bh->b_data + offset) = cpu_to_be64(bd->bd_blkno);
+		*(__be64 *)(page_address(page) + offset) = cpu_to_be64(bd->bd_blkno);
 		offset += sizeof(u64);
 	}
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 
-	submit_bh(WRITE, bh);
+	gfs2_log_write_page(sdp, page);
 }
 
 static void revoke_lo_after_commit(struct gfs2_sbd *sdp, struct gfs2_ail *ai)
@@ -650,57 +788,51 @@ static void gfs2_check_magic(struct buffer_head *bh)
 	kunmap_atomic(kaddr);
 }
 
-static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
+static void gfs2_write_blocks(struct gfs2_sbd *sdp,
+			      struct gfs2_log_descriptor *ld,
+			      struct page *page,
 			      struct list_head *list, struct list_head *done,
 			      unsigned int n)
 {
-	struct buffer_head *bh1;
-	struct gfs2_log_descriptor *ld;
 	struct gfs2_bufdata *bd;
 	__be64 *ptr;
 
-	if (!bh)
+	if (!ld)
 		return;
 
-	ld = bh_log_desc(bh);
 	ld->ld_length = cpu_to_be32(n + 1);
 	ld->ld_data1 = cpu_to_be32(n);
-
-	ptr = bh_log_ptr(bh);
+	ptr = (__force __be64 *)(ld + 1);
 	
-	get_bh(bh);
-	submit_bh(WRITE, bh);
+	gfs2_log_write_page(sdp, page);
 	gfs2_log_lock(sdp);
-	while(!list_empty(list)) {
+	while (!list_empty(list)) {
 		bd = list_entry(list->next, struct gfs2_bufdata, bd_le.le_list);
 		list_move_tail(&bd->bd_le.le_list, done);
 		get_bh(bd->bd_bh);
-		while (be64_to_cpu(*ptr) != bd->bd_bh->b_blocknr) {
-			gfs2_log_incr_head(sdp);
-			ptr += 2;
-		}
 		gfs2_log_unlock(sdp);
 		lock_buffer(bd->bd_bh);
 		if (buffer_escaped(bd->bd_bh)) {
 			void *kaddr;
-			bh1 = gfs2_log_get_buf(sdp);
+			page = mempool_alloc(gfs2_page_pool, GFP_NOIO);
+			ptr = page_address(page);
 			kaddr = kmap_atomic(bd->bd_bh->b_page);
-			memcpy(bh1->b_data, kaddr + bh_offset(bd->bd_bh),
-			       bh1->b_size);
+			memcpy(ptr, kaddr + bh_offset(bd->bd_bh),
+			       bd->bd_bh->b_size);
 			kunmap_atomic(kaddr);
-			*(__be32 *)bh1->b_data = 0;
+			*(__be32 *)ptr = 0;
 			clear_buffer_escaped(bd->bd_bh);
 			unlock_buffer(bd->bd_bh);
 			brelse(bd->bd_bh);
-			submit_bh(WRITE, bh1);
+			gfs2_log_write_page(sdp, page);
 		} else {
-			gfs2_log_write_buf(sdp, bd->bd_bh);
+			gfs2_log_write_bh(sdp, bd->bd_bh);
 		}
+		n--;
 		gfs2_log_lock(sdp);
-		ptr += 2;
 	}
 	gfs2_log_unlock(sdp);
-	brelse(bh);
+	BUG_ON(n != 0);
 }
 
 /**
@@ -711,7 +843,8 @@ static void gfs2_write_blocks(struct gfs2_sbd *sdp, struct buffer_head *bh,
 static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 {
 	struct gfs2_bufdata *bd = NULL;
-	struct buffer_head *bh = NULL;
+	struct gfs2_log_descriptor *ld = NULL;
+	struct page *page = NULL;
 	unsigned int n = 0;
 	__be64 *ptr = NULL, *end = NULL;
 	LIST_HEAD(processed);
@@ -721,11 +854,13 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 	while (!list_empty(&sdp->sd_log_le_databuf)) {
 		if (ptr == end) {
 			gfs2_log_unlock(sdp);
-			gfs2_write_blocks(sdp, bh, &in_progress, &processed, n);
+			gfs2_write_blocks(sdp, ld, page, &in_progress, &processed, n);
 			n = 0;
-			bh = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_JDATA);
-			ptr = bh_log_ptr(bh);
-			end = bh_ptr_end(bh) - 1;
+			page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_JDATA);
+			ld = page_address(page);
+			ptr = (__force __be64 *)(ld + 1);
+			end = (__force __be64 *)(page_address(page) + sdp->sd_vfs->s_blocksize);
+			end--;
 			gfs2_log_lock(sdp);
 			continue;
 		}
@@ -733,11 +868,11 @@ static void databuf_lo_before_commit(struct gfs2_sbd *sdp)
 		list_move_tail(&bd->bd_le.le_list, &in_progress);
 		gfs2_check_magic(bd->bd_bh);
 		*ptr++ = cpu_to_be64(bd->bd_bh->b_blocknr);
-		*ptr++ = cpu_to_be64(buffer_escaped(bh) ? 1 : 0);
+		*ptr++ = cpu_to_be64(buffer_escaped(bd->bd_bh) ? 1 : 0);
 		n++;
 	}
 	gfs2_log_unlock(sdp);
-	gfs2_write_blocks(sdp, bh, &in_progress, &processed, n);
+	gfs2_write_blocks(sdp, ld, page, &in_progress, &processed, n);
 	gfs2_log_lock(sdp);
 	list_splice(&processed, &sdp->sd_log_le_databuf);
 	gfs2_log_unlock(sdp);
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 3c0b273..825356d 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -27,6 +27,8 @@ extern const struct gfs2_log_operations gfs2_rg_lops;
 extern const struct gfs2_log_operations gfs2_databuf_lops;
 
 extern const struct gfs2_log_operations *gfs2_log_ops[];
+extern void gfs2_log_write_page(struct gfs2_sbd *sdp, struct page *page);
+extern void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw);
 
 static inline unsigned int buf_limit(struct gfs2_sbd *sdp)
 {
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index ce17944..6cdb0f2 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -70,16 +70,6 @@ static void gfs2_init_gl_aspace_once(void *foo)
 	address_space_init_once(mapping);
 }
 
-static void *gfs2_bh_alloc(gfp_t mask, void *data)
-{
-	return alloc_buffer_head(mask);
-}
-
-static void gfs2_bh_free(void *ptr, void *data)
-{
-	return free_buffer_head(ptr);
-}
-
 /**
  * init_gfs2_fs - Register GFS2 as a filesystem
  *
@@ -170,8 +160,8 @@ static int __init init_gfs2_fs(void)
 	if (!gfs2_control_wq)
 		goto fail_recovery;
 
-	gfs2_bh_pool = mempool_create(1024, gfs2_bh_alloc, gfs2_bh_free, NULL);
-	if (!gfs2_bh_pool)
+	gfs2_page_pool = mempool_create_page_pool(64, 0);
+	if (!gfs2_page_pool)
 		goto fail_control;
 
 	gfs2_register_debugfs();
@@ -234,7 +224,7 @@ static void __exit exit_gfs2_fs(void)
 
 	rcu_barrier();
 
-	mempool_destroy(gfs2_bh_pool);
+	mempool_destroy(gfs2_page_pool);
 	kmem_cache_destroy(gfs2_rsrv_cachep);
 	kmem_cache_destroy(gfs2_quotad_cachep);
 	kmem_cache_destroy(gfs2_rgrpd_cachep);
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 3afc6ac..f00d7c5 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -26,7 +26,7 @@ struct kmem_cache *gfs2_bufdata_cachep __read_mostly;
 struct kmem_cache *gfs2_rgrpd_cachep __read_mostly;
 struct kmem_cache *gfs2_quotad_cachep __read_mostly;
 struct kmem_cache *gfs2_rsrv_cachep __read_mostly;
-mempool_t *gfs2_bh_pool __read_mostly;
+mempool_t *gfs2_page_pool __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 8fbe6cf..3586b0d 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -153,7 +153,7 @@ extern struct kmem_cache *gfs2_bufdata_cachep;
 extern struct kmem_cache *gfs2_rgrpd_cachep;
 extern struct kmem_cache *gfs2_quotad_cachep;
 extern struct kmem_cache *gfs2_rsrv_cachep;
-extern mempool_t *gfs2_bh_pool;
+extern mempool_t *gfs2_page_pool;
 
 static inline unsigned int gfs2_tune_get_i(struct gfs2_tune *gt,
 					   unsigned int *p)
-- 
1.7.4

