Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2JNOnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:43:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46446 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932092Ab2JNOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:13 -0400
Message-Id: <20121014143545.681657294@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peng Tao <bergwolf@gmail.com>, Peng Tao <tao.peng@emc.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 088/147] pnfsblock: fix partial page buffer wirte
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Tao <bergwolf@gmail.com>

commit fe6e1e8d9fad86873eb74a26e80a8f91f9e870b5 upstream.

If applications use flock to protect its write range, generic NFS
will not do read-modify-write cycle at page cache level. Therefore
LD should know how to handle non-sector aligned writes. Otherwise
there will be data corruption.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to Linux 3.2:
 - Adjust context
 - s/wdata->pages\.npages/wdata->npages/
 - s/header->pnfs_error/wdata->pnfs_error/
 - Drop change in missing out_mds exit path]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/blocklayout/blocklayout.c |  177 +++++++++++++++++++++++++++++++++++---
 fs/nfs/blocklayout/blocklayout.h |    1 +
 2 files changed, 166 insertions(+), 12 deletions(-)

--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -164,25 +164,39 @@ static struct bio *bl_alloc_init_bio(int
 	return bio;
 }
 
-static struct bio *bl_add_page_to_bio(struct bio *bio, int npg, int rw,
+static struct bio *do_add_page_to_bio(struct bio *bio, int npg, int rw,
 				      sector_t isect, struct page *page,
 				      struct pnfs_block_extent *be,
 				      void (*end_io)(struct bio *, int err),
-				      struct parallel_io *par)
+				      struct parallel_io *par,
+				      unsigned int offset, int len)
 {
+	isect = isect + (offset >> SECTOR_SHIFT);
+	dprintk("%s: npg %d rw %d isect %llu offset %u len %d\n", __func__,
+		npg, rw, (unsigned long long)isect, offset, len);
 retry:
 	if (!bio) {
 		bio = bl_alloc_init_bio(npg, isect, be, end_io, par);
 		if (!bio)
 			return ERR_PTR(-ENOMEM);
 	}
-	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
+	if (bio_add_page(bio, page, len, offset) < len) {
 		bio = bl_submit_bio(rw, bio);
 		goto retry;
 	}
 	return bio;
 }
 
+static struct bio *bl_add_page_to_bio(struct bio *bio, int npg, int rw,
+				      sector_t isect, struct page *page,
+				      struct pnfs_block_extent *be,
+				      void (*end_io)(struct bio *, int err),
+				      struct parallel_io *par)
+{
+	return do_add_page_to_bio(bio, npg, rw, isect, page, be,
+				  end_io, par, 0, PAGE_CACHE_SIZE);
+}
+
 /* This is basically copied from mpage_end_io_read */
 static void bl_end_io_read(struct bio *bio, int err)
 {
@@ -446,6 +460,106 @@ map_block(struct buffer_head *bh, sector
 	return;
 }
 
+static void
+bl_read_single_end_io(struct bio *bio, int error)
+{
+	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct page *page = bvec->bv_page;
+
+	/* Only one page in bvec */
+	unlock_page(page);
+}
+
+static int
+bl_do_readpage_sync(struct page *page, struct pnfs_block_extent *be,
+		    unsigned int offset, unsigned int len)
+{
+	struct bio *bio;
+	struct page *shadow_page;
+	sector_t isect;
+	char *kaddr, *kshadow_addr;
+	int ret = 0;
+
+	dprintk("%s: offset %u len %u\n", __func__, offset, len);
+
+	shadow_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
+	if (shadow_page == NULL)
+		return -ENOMEM;
+
+	bio = bio_alloc(GFP_NOIO, 1);
+	if (bio == NULL)
+		return -ENOMEM;
+
+	isect = (page->index << PAGE_CACHE_SECTOR_SHIFT) +
+		(offset / SECTOR_SIZE);
+
+	bio->bi_sector = isect - be->be_f_offset + be->be_v_offset;
+	bio->bi_bdev = be->be_mdev;
+	bio->bi_end_io = bl_read_single_end_io;
+
+	lock_page(shadow_page);
+	if (bio_add_page(bio, shadow_page,
+			 SECTOR_SIZE, round_down(offset, SECTOR_SIZE)) == 0) {
+		unlock_page(shadow_page);
+		bio_put(bio);
+		return -EIO;
+	}
+
+	submit_bio(READ, bio);
+	wait_on_page_locked(shadow_page);
+	if (unlikely(!test_bit(BIO_UPTODATE, &bio->bi_flags))) {
+		ret = -EIO;
+	} else {
+		kaddr = kmap_atomic(page);
+		kshadow_addr = kmap_atomic(shadow_page);
+		memcpy(kaddr + offset, kshadow_addr + offset, len);
+		kunmap_atomic(kshadow_addr);
+		kunmap_atomic(kaddr);
+	}
+	__free_page(shadow_page);
+	bio_put(bio);
+
+	return ret;
+}
+
+static int
+bl_read_partial_page_sync(struct page *page, struct pnfs_block_extent *be,
+			  unsigned int dirty_offset, unsigned int dirty_len,
+			  bool full_page)
+{
+	int ret = 0;
+	unsigned int start, end;
+
+	if (full_page) {
+		start = 0;
+		end = PAGE_CACHE_SIZE;
+	} else {
+		start = round_down(dirty_offset, SECTOR_SIZE);
+		end = round_up(dirty_offset + dirty_len, SECTOR_SIZE);
+	}
+
+	dprintk("%s: offset %u len %d\n", __func__, dirty_offset, dirty_len);
+	if (!be) {
+		zero_user_segments(page, start, dirty_offset,
+				   dirty_offset + dirty_len, end);
+		if (start == 0 && end == PAGE_CACHE_SIZE &&
+		    trylock_page(page)) {
+			SetPageUptodate(page);
+			unlock_page(page);
+		}
+		return ret;
+	}
+
+	if (start != dirty_offset)
+		ret = bl_do_readpage_sync(page, be, start, dirty_offset - start);
+
+	if (!ret && (dirty_offset + dirty_len < end))
+		ret = bl_do_readpage_sync(page, be, dirty_offset + dirty_len,
+					  end - dirty_offset - dirty_len);
+
+	return ret;
+}
+
 /* Given an unmapped page, zero it or read in page for COW, page is locked
  * by caller.
  */
@@ -479,7 +593,6 @@ init_page_for_write(struct page *page, s
 	SetPageUptodate(page);
 
 cleanup:
-	bl_put_extent(cow_read);
 	if (bh)
 		free_buffer_head(bh);
 	if (ret) {
@@ -501,6 +614,7 @@ bl_write_pagelist(struct nfs_write_data
 	struct parallel_io *par;
 	loff_t offset = wdata->args.offset;
 	size_t count = wdata->args.count;
+	unsigned int pg_offset, pg_len, saved_len;
 	struct page **pages = wdata->args.pages;
 	struct page *page;
 	pgoff_t index;
@@ -615,10 +729,11 @@ next_page:
 		if (!extent_length) {
 			/* We've used up the previous extent */
 			bl_put_extent(be);
+			bl_put_extent(cow_read);
 			bio = bl_submit_bio(WRITE, bio);
 			/* Get the next one */
 			be = bl_find_get_extent(BLK_LSEG2EXT(wdata->lseg),
-					     isect, NULL);
+					     isect, &cow_read);
 			if (!be || !is_writable(be, isect)) {
 				wdata->pnfs_error = -EINVAL;
 				goto out;
@@ -626,7 +741,26 @@ next_page:
 			extent_length = be->be_length -
 			    (isect - be->be_f_offset);
 		}
-		if (be->be_state == PNFS_BLOCK_INVALID_DATA) {
+
+		dprintk("%s offset %lld count %Zu\n", __func__, offset, count);
+		pg_offset = offset & ~PAGE_CACHE_MASK;
+		if (pg_offset + count > PAGE_CACHE_SIZE)
+			pg_len = PAGE_CACHE_SIZE - pg_offset;
+		else
+			pg_len = count;
+
+		saved_len = pg_len;
+		if (be->be_state == PNFS_BLOCK_INVALID_DATA &&
+		    !bl_is_sector_init(be->be_inval, isect)) {
+			ret = bl_read_partial_page_sync(pages[i], cow_read,
+							pg_offset, pg_len, true);
+			if (ret) {
+				dprintk("%s bl_read_partial_page_sync fail %d\n",
+					__func__, ret);
+				wdata->pnfs_error = ret;
+				goto out;
+			}
+
 			ret = bl_mark_sectors_init(be->be_inval, isect,
 						       PAGE_CACHE_SECTORS,
 						       NULL);
@@ -636,15 +770,35 @@ next_page:
 				wdata->pnfs_error = ret;
 				goto out;
 			}
+
+			/* Expand to full page write */
+			pg_offset = 0;
+			pg_len = PAGE_CACHE_SIZE;
+		} else if  ((pg_offset & (SECTOR_SIZE - 1)) ||
+			    (pg_len & (SECTOR_SIZE - 1))){
+			/* ahh, nasty case. We have to do sync full sector
+			 * read-modify-write cycles.
+			 */
+			unsigned int saved_offset = pg_offset;
+			ret = bl_read_partial_page_sync(pages[i], be, pg_offset,
+							pg_len, false);
+			pg_offset = round_down(pg_offset, SECTOR_SIZE);
+			pg_len = round_up(saved_offset + pg_len, SECTOR_SIZE)
+				 - pg_offset;
 		}
-		bio = bl_add_page_to_bio(bio, wdata->npages - i, WRITE,
+
+
+		bio = do_add_page_to_bio(bio, wdata->npages - i, WRITE,
 					 isect, pages[i], be,
-					 bl_end_io_write, par);
+					 bl_end_io_write, par,
+					 pg_offset, pg_len);
 		if (IS_ERR(bio)) {
 			wdata->pnfs_error = PTR_ERR(bio);
 			bio = NULL;
 			goto out;
 		}
+		offset += saved_len;
+		count -= saved_len;
 		isect += PAGE_CACHE_SECTORS;
 		last_isect = isect;
 		extent_length -= PAGE_CACHE_SECTORS;
@@ -662,12 +816,10 @@ next_page:
 	}
 
 write_done:
-	wdata->res.count = (last_isect << SECTOR_SHIFT) - (offset);
-	if (count < wdata->res.count) {
-		wdata->res.count = count;
-	}
+	wdata->res.count = wdata->args.count;
 out:
 	bl_put_extent(be);
+	bl_put_extent(cow_read);
 	bl_submit_bio(WRITE, bio);
 	put_parallel(par);
 	return PNFS_ATTEMPTED;
--- a/fs/nfs/blocklayout/blocklayout.h
+++ b/fs/nfs/blocklayout/blocklayout.h
@@ -40,6 +40,7 @@
 
 #define PAGE_CACHE_SECTORS (PAGE_CACHE_SIZE >> SECTOR_SHIFT)
 #define PAGE_CACHE_SECTOR_SHIFT (PAGE_CACHE_SHIFT - SECTOR_SHIFT)
+#define SECTOR_SIZE (1 << SECTOR_SHIFT)
 
 struct block_mount_id {
 	spinlock_t			bm_lock;    /* protects list */


