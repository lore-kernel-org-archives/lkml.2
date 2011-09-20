Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1ITQJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 12:09:25 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38747
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752317Ab1ITQJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 12:09:23 -0400
Date: Tue, 20 Sep 2011 12:09:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] loop: remove the incorrect write_begin/write_end shortcut
Message-ID: <20110920160922.GA2491@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the loop device tries to call directly into write_begin/write_end
instead of going through ->write if it can.  This is a fairly nasty shortcut
as write_begin and write_end are only callbacks for the generic write code
and expect to be called with filesystem specific locks held.  

This code currently causes various issues for clustered filesystems as it
doesn't take the required cluster locks, and it also causes issues for XFS
as it doesn't properly lock against the swapext ioctl as called by the
defragmentation tools.  This in case causes data corruption if
defragmentation hits a busy loop device in the wrong time window, as
reported by RH QA.

The reason why we have this shortcut is that it saves a data copy when
doing a transformation on the loop device, which is the technical term
for using cryptoloop (or an XOR transformation).  Given that cryptoloop
has been deprecated in favour of dm-crypt my opinion is that we should
simply drop this shortcut instead of finding complicated ways to to
introduce a formal interface for this shortcut.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/block/loop.c
===================================================================
--- linux-2.6.orig/drivers/block/loop.c	2011-09-19 12:21:06.725231729 -0400
+++ linux-2.6/drivers/block/loop.c	2011-09-19 12:28:01.671730150 -0400
@@ -203,74 +203,6 @@ lo_do_transfer(struct loop_device *lo, i
 }
 
 /**
- * do_lo_send_aops - helper for writing data to a loop device
- *
- * This is the fast version for backing filesystems which implement the address
- * space operations write_begin and write_end.
- */
-static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
-		loff_t pos, struct page *unused)
-{
-	struct file *file = lo->lo_backing_file; /* kudos to NFsckingS */
-	struct address_space *mapping = file->f_mapping;
-	pgoff_t index;
-	unsigned offset, bv_offs;
-	int len, ret;
-
-	mutex_lock(&mapping->host->i_mutex);
-	index = pos >> PAGE_CACHE_SHIFT;
-	offset = pos & ((pgoff_t)PAGE_CACHE_SIZE - 1);
-	bv_offs = bvec->bv_offset;
-	len = bvec->bv_len;
-	while (len > 0) {
-		sector_t IV;
-		unsigned size, copied;
-		int transfer_result;
-		struct page *page;
-		void *fsdata;
-
-		IV = ((sector_t)index << (PAGE_CACHE_SHIFT - 9))+(offset >> 9);
-		size = PAGE_CACHE_SIZE - offset;
-		if (size > len)
-			size = len;
-
-		ret = pagecache_write_begin(file, mapping, pos, size, 0,
-							&page, &fsdata);
-		if (ret)
-			goto fail;
-
-		file_update_time(file);
-
-		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
-				bvec->bv_page, bv_offs, size, IV);
-		copied = size;
-		if (unlikely(transfer_result))
-			copied = 0;
-
-		ret = pagecache_write_end(file, mapping, pos, size, copied,
-							page, fsdata);
-		if (ret < 0 || ret != copied)
-			goto fail;
-
-		if (unlikely(transfer_result))
-			goto fail;
-
-		bv_offs += copied;
-		len -= copied;
-		offset = 0;
-		index++;
-		pos += copied;
-	}
-	ret = 0;
-out:
-	mutex_unlock(&mapping->host->i_mutex);
-	return ret;
-fail:
-	ret = -1;
-	goto out;
-}
-
-/**
  * __do_lo_send_write - helper for writing data to a loop device
  *
  * This helper just factors out common code between do_lo_send_direct_write()
@@ -297,10 +229,8 @@ static int __do_lo_send_write(struct fil
 /**
  * do_lo_send_direct_write - helper for writing data to a loop device
  *
- * This is the fast, non-transforming version for backing filesystems which do
- * not implement the address space operations write_begin and write_end.
- * It uses the write file operation which should be present on all writeable
- * filesystems.
+ * This is the fast, non-transforming version that does not need double
+ * buffering.
  */
 static int do_lo_send_direct_write(struct loop_device *lo,
 		struct bio_vec *bvec, loff_t pos, struct page *page)
@@ -316,15 +246,9 @@ static int do_lo_send_direct_write(struc
 /**
  * do_lo_send_write - helper for writing data to a loop device
  *
- * This is the slow, transforming version for filesystems which do not
- * implement the address space operations write_begin and write_end.  It
- * uses the write file operation which should be present on all writeable
- * filesystems.
- *
- * Using fops->write is slower than using aops->{prepare,commit}_write in the
- * transforming case because we need to double buffer the data as we cannot do
- * the transformations in place as we do not have direct access to the
- * destination pages of the backing file.
+ * This is the slow, transforming version that needs to double buffer the
+ * data as it cannot do the transformations in place without having direct
+ * access to the destination pages of the backing file.
  */
 static int do_lo_send_write(struct loop_device *lo, struct bio_vec *bvec,
 		loff_t pos, struct page *page)
@@ -350,17 +274,16 @@ static int lo_send(struct loop_device *l
 	struct page *page = NULL;
 	int i, ret = 0;
 
-	do_lo_send = do_lo_send_aops;
-	if (!(lo->lo_flags & LO_FLAGS_USE_AOPS)) {
+	if (lo->transfer != transfer_none) {
+		page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
+		if (unlikely(!page))
+			goto fail;
+		kmap(page);
+		do_lo_send = do_lo_send_write;
+	} else {
 		do_lo_send = do_lo_send_direct_write;
-		if (lo->transfer != transfer_none) {
-			page = alloc_page(GFP_NOIO | __GFP_HIGHMEM);
-			if (unlikely(!page))
-				goto fail;
-			kmap(page);
-			do_lo_send = do_lo_send_write;
-		}
 	}
+
 	bio_for_each_segment(bvec, bio, i) {
 		ret = do_lo_send(lo, bvec, pos, page);
 		if (ret < 0)
@@ -849,35 +772,23 @@ static int loop_set_fd(struct loop_devic
 	mapping = file->f_mapping;
 	inode = mapping->host;
 
-	if (!(file->f_mode & FMODE_WRITE))
-		lo_flags |= LO_FLAGS_READ_ONLY;
-
 	error = -EINVAL;
-	if (S_ISREG(inode->i_mode) || S_ISBLK(inode->i_mode)) {
-		const struct address_space_operations *aops = mapping->a_ops;
-
-		if (aops->write_begin)
-			lo_flags |= LO_FLAGS_USE_AOPS;
-		if (!(lo_flags & LO_FLAGS_USE_AOPS) && !file->f_op->write)
-			lo_flags |= LO_FLAGS_READ_ONLY;
+	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
+		goto out_putf;
 
-		lo_blocksize = S_ISBLK(inode->i_mode) ?
-			inode->i_bdev->bd_block_size : PAGE_SIZE;
+	if (!(file->f_mode & FMODE_WRITE) || !(mode & FMODE_WRITE) ||
+	    !file->f_op->write)
+		lo_flags |= LO_FLAGS_READ_ONLY;
 
-		error = 0;
-	} else {
-		goto out_putf;
-	}
+	lo_blocksize = S_ISBLK(inode->i_mode) ?
+		inode->i_bdev->bd_block_size : PAGE_SIZE;
 
+	error = -EFBIG;
 	size = get_loop_size(lo, file);
-
-	if ((loff_t)(sector_t)size != size) {
-		error = -EFBIG;
+	if ((loff_t)(sector_t)size != size)
 		goto out_putf;
-	}
 
-	if (!(mode & FMODE_WRITE))
-		lo_flags |= LO_FLAGS_READ_ONLY;
+	error = 0;
 
 	set_device_ro(bdev, (lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
Index: linux-2.6/include/linux/loop.h
===================================================================
--- linux-2.6.orig/include/linux/loop.h	2011-09-19 12:21:32.241231706 -0400
+++ linux-2.6/include/linux/loop.h	2011-09-19 12:21:40.768232536 -0400
@@ -73,7 +73,6 @@ struct loop_device {
  */
 enum {
 	LO_FLAGS_READ_ONLY	= 1,
-	LO_FLAGS_USE_AOPS	= 2,
 	LO_FLAGS_AUTOCLEAR	= 4,
 };
 
