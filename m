Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2B0VUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:20:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33639 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2B0VU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 14/22] fs: pull iov_iter use higher up the stack
Date: Mon, 27 Feb 2012 15:19:28 -0600
Message-Id: <1330377576-3659-15-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F4BF399.00AE,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

Right now only callers of generic_perform_write() pack their iovec
arguments into an iov_iter structure.  All the callers higher up in the
stack work on raw iovec arguments.

This patch introduces the use of the iov_iter abstraction higher up the
stack.  Private generic path functions are changed to operation on
iov_iter instead of on raw iovecs.  Exported interfaces that take iovecs
immediately pack their arguments into an iov_iter and call into the
shared functions.

File operation struct functions are added with iov_iter as an argument
so that callers to the generic file system functions can specify
abstract memory rather than iovec arrays only.

Almost all of this patch only transforms arguments and shouldn't change
functionality.  The buffered read path is the exception.  We add a
read_actor function which uses the iov_iter helper functions instead of
operating on each individual iovec element.  This may improve
performance as the iov_iter helper can copy multiple iovec elements from
one mapped page cache page.

As always, the direct IO path is special.  Sadly, it may still be
cleanest to have it work on the underlying memory structures directly
instead of working through the iov_iter abstraction.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h |   12 +++
 mm/filemap.c       |  261 +++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 190 insertions(+), 83 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 94f2d0a..92727a9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1686,7 +1686,9 @@ struct file_operations {
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
+	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *, loff_t);
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
+	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *, loff_t);
 	int (*readdir) (struct file *, void *, filldir_t);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
@@ -2448,13 +2450,23 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern int file_read_actor(read_descriptor_t * desc, struct page *page, unsigned long offset, unsigned long size);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
 extern ssize_t generic_file_aio_read(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *,
+		loff_t);
 extern ssize_t __generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long,
 		loff_t *);
+extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *,
+		loff_t *);
 extern ssize_t generic_file_aio_write(struct kiocb *, const struct iovec *, unsigned long, loff_t);
+extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *,
+		loff_t);
 extern ssize_t generic_file_direct_write(struct kiocb *, const struct iovec *,
 		unsigned long *, loff_t, loff_t *, size_t, size_t);
+extern ssize_t generic_file_direct_write_iter(struct kiocb *, struct iov_iter *,
+		loff_t, loff_t *, size_t);
 extern ssize_t generic_file_buffered_write(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t, loff_t *, size_t, ssize_t);
+extern ssize_t generic_file_buffered_write_iter(struct kiocb *,
+		struct iov_iter *, loff_t, loff_t *, ssize_t);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
 extern ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 extern int generic_segment_checks(const struct iovec *iov,
diff --git a/mm/filemap.c b/mm/filemap.c
index 0533a71..7ce5bff 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1381,31 +1381,56 @@ int generic_segment_checks(const struct iovec *iov,
 }
 EXPORT_SYMBOL(generic_segment_checks);
 
+static ssize_t mapping_direct_IO(struct address_space *mapping, int rw,
+				 struct kiocb *iocb, struct iov_iter *iter,
+				 loff_t pos)
+{
+	if (iov_iter_has_iovec(iter))
+		return mapping->a_ops->direct_IO(rw, iocb, iov_iter_iovec(iter),
+						 pos, iter->nr_segs);
+	else if (iov_iter_has_bvec(iter))
+		return mapping->a_ops->direct_IO_bvec(rw, iocb,
+						      iov_iter_bvec(iter), pos,
+						      iter->nr_segs);
+	else
+		BUG();
+}
+
+static int file_read_iter_actor(read_descriptor_t *desc, struct page *page,
+				unsigned long offset, unsigned long size)
+{
+	struct iov_iter *iter = desc->arg.data;
+	unsigned long copied = 0;
+
+	if (size > desc->count)
+		size = desc->count;
+
+	copied = iov_iter_copy_to_user(page, iter, offset, size);
+	if (copied < size)
+		desc->error = -EFAULT;
+
+	iov_iter_advance(iter, copied);
+	desc->count -= copied;
+	desc->written += copied;
+
+	return copied;
+}
+
 /**
- * generic_file_aio_read - generic filesystem read routine
+ * generic_file_read_iter - generic filesystem read routine
  * @iocb:	kernel I/O control block
- * @iov:	io vector request
- * @nr_segs:	number of segments in the iovec
+ * @iov_iter:	memory vector
  * @pos:	current file position
- *
- * This is the "read()" routine for all filesystems
- * that can use the page cache directly.
  */
 ssize_t
-generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos)
+generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct file *filp = iocb->ki_filp;
-	ssize_t retval;
-	unsigned long seg = 0;
-	size_t count;
+	read_descriptor_t desc;
+	ssize_t retval = 0;
+	size_t count = iov_iter_count(iter);
 	loff_t *ppos = &iocb->ki_pos;
 
-	count = 0;
-	retval = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
-	if (retval)
-		return retval;
-
 	/* coalesce the iovecs and go direct-to-BIO for O_DIRECT */
 	if (filp->f_flags & O_DIRECT) {
 		loff_t size;
@@ -1419,13 +1444,13 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		size = i_size_read(inode);
 		if (pos < size) {
 			retval = filemap_write_and_wait_range(mapping, pos,
-					pos + iov_length(iov, nr_segs) - 1);
+					pos + count - 1);
 			if (!retval) {
 				struct blk_plug plug;
 
 				blk_start_plug(&plug);
-				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
+				retval = mapping_direct_IO(mapping, READ,
+							   iocb, iter, pos);
 				blk_finish_plug(&plug);
 			}
 			if (retval > 0) {
@@ -1448,42 +1473,47 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	count = retval;
-	for (seg = 0; seg < nr_segs; seg++) {
-		read_descriptor_t desc;
-		loff_t offset = 0;
-
-		/*
-		 * If we did a short DIO read we need to skip the section of the
-		 * iov that we've already read data into.
-		 */
-		if (count) {
-			if (count > iov[seg].iov_len) {
-				count -= iov[seg].iov_len;
-				continue;
-			}
-			offset = count;
-			count = 0;
-		}
-
-		desc.written = 0;
-		desc.arg.buf = iov[seg].iov_base + offset;
-		desc.count = iov[seg].iov_len - offset;
-		if (desc.count == 0)
-			continue;
-		desc.error = 0;
-		do_generic_file_read(filp, ppos, &desc, file_read_actor);
-		retval += desc.written;
-		if (desc.error) {
-			retval = retval ?: desc.error;
-			break;
-		}
-		if (desc.count > 0)
-			break;
-	}
+	desc.written = 0;
+	desc.arg.data = iter;
+	desc.count = count;
+	desc.error = 0;
+	do_generic_file_read(filp, ppos, &desc, file_read_iter_actor);
+	if (desc.written)
+		retval = desc.written;
+	else
+		retval = desc.error;
 out:
 	return retval;
 }
+EXPORT_SYMBOL(generic_file_read_iter);
+
+/**
+ * generic_file_aio_read - generic filesystem read routine
+ * @iocb:	kernel I/O control block
+ * @iov:	io vector request
+ * @nr_segs:	number of segments in the iovec
+ * @pos:	current file position
+ *
+ * This is the "read()" routine for all filesystems
+ * that can use the page cache directly.
+ */
+ssize_t
+generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos)
+{
+	struct iov_iter iter;
+	int ret;
+	size_t count;
+
+	count = 0;
+	ret = generic_segment_checks(iov, &nr_segs, &count, VERIFY_WRITE);
+	if (ret)
+		return ret;
+
+	iov_iter_init(&iter, iov, nr_segs, count, 0);
+
+	return generic_file_read_iter(iocb, &iter, pos);
+}
 EXPORT_SYMBOL(generic_file_aio_read);
 
 static ssize_t
@@ -2116,9 +2146,8 @@ int pagecache_write_end(struct file *file, struct address_space *mapping,
 EXPORT_SYMBOL(pagecache_write_end);
 
 ssize_t
-generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long *nr_segs, loff_t pos, loff_t *ppos,
-		size_t count, size_t ocount)
+generic_file_direct_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+		loff_t pos, loff_t *ppos, size_t count)
 {
 	struct file	*file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -2127,10 +2156,13 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	size_t		write_len;
 	pgoff_t		end;
 
-	if (count != ocount)
-		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
+	if (count != iov_iter_count(iter)) {
+		written = iov_iter_shorten(iter, count);
+		if (written)
+			goto out;
+	}
 
-	write_len = iov_length(iov, *nr_segs);
+	write_len = count;
 	end = (pos + write_len - 1) >> PAGE_CACHE_SHIFT;
 
 	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
@@ -2157,7 +2189,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	written = mapping_direct_IO(mapping, WRITE, iocb, iter, pos);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
@@ -2183,6 +2215,23 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 out:
 	return written;
 }
+EXPORT_SYMBOL(generic_file_direct_write_iter);
+
+ssize_t
+generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long *nr_segs, loff_t pos, loff_t *ppos,
+		size_t count, size_t ocount)
+{
+	struct iov_iter iter;
+	ssize_t ret;
+
+	iov_iter_init(&iter, iov, *nr_segs, ocount, 0);
+	ret = generic_file_direct_write_iter(iocb, &iter, pos, ppos, count);
+	/* generic_file_direct_write_iter() might have shortened the vec */
+	if (*nr_segs != iter.nr_segs)
+		*nr_segs = iter.nr_segs;
+	return ret;
+}
 EXPORT_SYMBOL(generic_file_direct_write);
 
 /*
@@ -2314,16 +2363,13 @@ again:
 }
 
 ssize_t
-generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos, loff_t *ppos,
-		size_t count, ssize_t written)
+generic_file_buffered_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+		loff_t pos, loff_t *ppos, ssize_t written)
 {
 	struct file *file = iocb->ki_filp;
 	ssize_t status;
-	struct iov_iter i;
 
-	iov_iter_init(&i, iov, nr_segs, count, written);
-	status = generic_perform_write(file, &i, pos);
+	status = generic_perform_write(file, iter, pos);
 
 	if (likely(status >= 0)) {
 		written += status;
@@ -2332,13 +2378,24 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	
 	return written ? written : status;
 }
+EXPORT_SYMBOL(generic_file_buffered_write_iter);
+
+ssize_t
+generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos, loff_t *ppos,
+		size_t count, ssize_t written)
+{
+	struct iov_iter iter;
+	iov_iter_init(&iter, iov, nr_segs, count, written);
+	return generic_file_buffered_write_iter(iocb, &iter, pos, ppos,
+						written);
+}
 EXPORT_SYMBOL(generic_file_buffered_write);
 
 /**
  * __generic_file_aio_write - write data to a file
  * @iocb:	IO state structure (file, offset, etc.)
- * @iov:	vector with data to write
- * @nr_segs:	number of segments in the vector
+ * @iter:	iov_iter specifying memory to write
  * @ppos:	position where to write
  *
  * This function does all the work needed for actually writing data to a
@@ -2353,24 +2410,18 @@ EXPORT_SYMBOL(generic_file_buffered_write);
  * A caller has to handle it. This is mainly due to the fact that we want to
  * avoid syncing under i_mutex.
  */
-ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				 unsigned long nr_segs, loff_t *ppos)
+ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				  loff_t *ppos)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space * mapping = file->f_mapping;
-	size_t ocount;		/* original count */
 	size_t count;		/* after file limit checks */
 	struct inode 	*inode = mapping->host;
 	loff_t		pos;
 	ssize_t		written;
 	ssize_t		err;
 
-	ocount = 0;
-	err = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
-	if (err)
-		return err;
-
-	count = ocount;
+	count = iov_iter_count(iter);
 	pos = *ppos;
 
 	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
@@ -2397,8 +2448,8 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		loff_t endbyte;
 		ssize_t written_buffered;
 
-		written = generic_file_direct_write(iocb, iov, &nr_segs, pos,
-							ppos, count, ocount);
+		written = generic_file_direct_write_iter(iocb, iter, pos,
+							 ppos, count);
 		if (written < 0 || written == count)
 			goto out;
 		/*
@@ -2407,9 +2458,9 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		 */
 		pos += written;
 		count -= written;
-		written_buffered = generic_file_buffered_write(iocb, iov,
-						nr_segs, pos, ppos, count,
-						written);
+		iov_iter_advance(iter, written);
+		written_buffered = generic_file_buffered_write_iter(iocb, iter,
+						pos, ppos, written);
 		/*
 		 * If generic_file_buffered_write() retuned a synchronous error
 		 * then we want to return the number of bytes which were
@@ -2441,13 +2492,57 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			 */
 		}
 	} else {
-		written = generic_file_buffered_write(iocb, iov, nr_segs,
-				pos, ppos, count, written);
+		iter->count = count;
+		written = generic_file_buffered_write_iter(iocb, iter,
+				pos, ppos, written);
 	}
 out:
 	current->backing_dev_info = NULL;
 	return written ? written : err;
 }
+EXPORT_SYMBOL(__generic_file_write_iter);
+
+ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	ssize_t ret;
+
+	mutex_lock(&inode->i_mutex);
+	ret = __generic_file_write_iter(iocb, iter, &iocb->ki_pos);
+	mutex_unlock(&inode->i_mutex);
+
+	if (ret > 0 || ret == -EIOCBQUEUED) {
+		ssize_t err;
+
+		err = generic_write_sync(file, pos, ret);
+		if (err < 0 && ret > 0)
+			ret = err;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(generic_file_write_iter);
+
+ssize_t
+__generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
+			 unsigned long nr_segs, loff_t *ppos)
+{
+	struct iov_iter iter;
+	size_t count;
+	int ret;
+
+	count = 0;
+	ret = generic_segment_checks(iov, &nr_segs, &count, VERIFY_READ);
+	if (ret)
+		goto out;
+
+	iov_iter_init(&iter, iov, nr_segs, count, 0);
+
+	ret = __generic_file_write_iter(iocb, &iter, ppos);
+out:
+	return ret;
+}
 EXPORT_SYMBOL(__generic_file_aio_write);
 
 /**
-- 
1.7.9.2

