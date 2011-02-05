Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1BERrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:11 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52674 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1BERrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:08 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 07/17] fs/9p: Add buffered write support for v9fs.
Date: Sat,  5 Feb 2011 23:16:35 +0530
Message-Id: <1296928005-9529-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can now support writeable mmaps.
Based on the original patch from Badari Pulavarty <pbadari@us.ibm.com>

TODO: O_DIRECT

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_addr.c |  181 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/9p/vfs_file.c |   54 +++++++++++++++-
 2 files changed, 216 insertions(+), 19 deletions(-)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 637bd70..792c68a 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -39,16 +39,16 @@
 #include "v9fs.h"
 #include "v9fs_vfs.h"
 #include "cache.h"
+#include "fid.h"
 
 /**
- * v9fs_vfs_readpage - read an entire page in from 9P
+ * v9fs_fid_readpage - read an entire page in from 9P
  *
- * @filp: file being read
+ * @fid: fid being read
  * @page: structure to page
  *
  */
-
-static int v9fs_vfs_readpage(struct file *filp, struct page *page)
+static int v9fs_fid_readpage(struct p9_fid *fid, struct page *page)
 {
 	int retval;
 	loff_t offset;
@@ -67,7 +67,7 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 	buffer = kmap(page);
 	offset = page_offset(page);
 
-	retval = v9fs_file_readn(filp, buffer, NULL, PAGE_CACHE_SIZE, offset);
+	retval = v9fs_fid_readn(fid, buffer, NULL, PAGE_CACHE_SIZE, offset);
 	if (retval < 0) {
 		v9fs_uncache_page(inode, page);
 		goto done;
@@ -87,6 +87,19 @@ done:
 }
 
 /**
+ * v9fs_vfs_readpage - read an entire page in from 9P
+ *
+ * @filp: file being read
+ * @page: structure to page
+ *
+ */
+
+static int v9fs_vfs_readpage(struct file *filp, struct page *page)
+{
+	return v9fs_fid_readpage(filp->private_data, page);
+}
+
+/**
  * v9fs_vfs_readpages - read a set of pages from 9P
  *
  * @filp: file being read
@@ -124,7 +137,6 @@ static int v9fs_release_page(struct page *page, gfp_t gfp)
 {
 	if (PagePrivate(page))
 		return 0;
-
 	return v9fs_fscache_release_page(page, gfp);
 }
 
@@ -137,22 +149,86 @@ static int v9fs_release_page(struct page *page, gfp_t gfp)
 
 static void v9fs_invalidate_page(struct page *page, unsigned long offset)
 {
+	/*
+	 * If called with zero offset, we should release
+	 * the private state assocated with the page
+	 */
 	if (offset == 0)
 		v9fs_fscache_invalidate_page(page);
 }
 
+static int v9fs_vfs_writepage_locked(struct page *page)
+{
+	char *buffer;
+	int retval, len;
+	loff_t offset, size;
+	mm_segment_t old_fs;
+	struct inode *inode = page->mapping->host;
+
+	size = i_size_read(inode);
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+
+	set_page_writeback(page);
+
+	buffer = kmap(page);
+	offset = page_offset(page);
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+	/* We should have i_private always set */
+	BUG_ON(!inode->i_private);
+
+	retval = v9fs_file_write_internal(inode,
+					  (struct p9_fid *)inode->i_private,
+					  buffer, len, &offset, 0);
+	if (retval > 0)
+		retval = 0;
+
+	set_fs(old_fs);
+	kunmap(page);
+	end_page_writeback(page);
+	return retval;
+}
+
+static int v9fs_vfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	int retval;
+
+	retval = v9fs_vfs_writepage_locked(page);
+	if (retval < 0) {
+		if (retval == -EAGAIN) {
+			redirty_page_for_writepage(wbc, page);
+			retval = 0;
+		} else {
+			SetPageError(page);
+			mapping_set_error(page->mapping, retval);
+		}
+	} else
+		retval = 0;
+
+	unlock_page(page);
+	return retval;
+}
+
 /**
  * v9fs_launder_page - Writeback a dirty page
- * Since the writes go directly to the server, we simply return a 0
- * here to indicate success.
- *
  * Returns 0 on success.
  */
 
 static int v9fs_launder_page(struct page *page)
 {
+	int retval;
 	struct inode *inode = page->mapping->host;
+
 	v9fs_fscache_wait_on_page_write(inode, page);
+	if (clear_page_dirty_for_io(page)) {
+		retval = v9fs_vfs_writepage_locked(page);
+		if (retval)
+			return retval;
+	}
 	return 0;
 }
 
@@ -178,6 +254,11 @@ static int v9fs_launder_page(struct page *page)
 ssize_t v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		loff_t pos, unsigned long nr_segs)
 {
+	/*
+	 * FIXME
+	 * Now that we do caching with cache mode enabled, We need
+	 * to support direct IO
+	 */
 	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_direct_IO: v9fs_direct_IO (%s) "
 			"off/no(%lld/%lu) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
@@ -185,11 +266,81 @@ ssize_t v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 
 	return -EINVAL;
 }
+
+static int v9fs_write_begin(struct file *filp, struct address_space *mapping,
+			    loff_t pos, unsigned len, unsigned flags,
+			    struct page **pagep, void **fsdata)
+{
+	int retval = 0;
+	struct page *page;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	struct inode *inode = mapping->host;
+
+start:
+	page = grab_cache_page_write_begin(mapping, index, flags);
+	if (!page) {
+		retval = -ENOMEM;
+		goto out;
+	}
+	BUG_ON(!inode->i_private);
+	if (PageUptodate(page))
+		goto out;
+
+	if (len == PAGE_CACHE_SIZE)
+		goto out;
+
+	retval = v9fs_fid_readpage(inode->i_private, page);
+	page_cache_release(page);
+	if (!retval)
+		goto start;
+out:
+	*pagep = page;
+	return retval;
+}
+
+static int v9fs_write_end(struct file *filp, struct address_space *mapping,
+			  loff_t pos, unsigned len, unsigned copied,
+			  struct page *page, void *fsdata)
+{
+	loff_t last_pos = pos + copied;
+	struct inode *inode = page->mapping->host;
+
+	if (unlikely(copied < len)) {
+		/*
+		 * zero out the rest of the area
+		 */
+		unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+
+		zero_user(page, from + copied, len - copied);
+		flush_dcache_page(page);
+	}
+
+	if (!PageUptodate(page))
+		SetPageUptodate(page);
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold the i_mutex.
+	 */
+	if (last_pos > inode->i_size)
+		i_size_write(inode, last_pos);
+
+	set_page_dirty(page);
+	unlock_page(page);
+	page_cache_release(page);
+
+	return copied;
+}
+
+
 const struct address_space_operations v9fs_addr_operations = {
-      .readpage = v9fs_vfs_readpage,
-      .readpages = v9fs_vfs_readpages,
-      .releasepage = v9fs_release_page,
-      .invalidatepage = v9fs_invalidate_page,
-      .launder_page = v9fs_launder_page,
-      .direct_IO = v9fs_direct_IO,
+	.readpage = v9fs_vfs_readpage,
+	.readpages = v9fs_vfs_readpages,
+	.set_page_dirty = __set_page_dirty_nobuffers,
+	.writepage = v9fs_vfs_writepage,
+	.write_begin = v9fs_write_begin,
+	.write_end = v9fs_write_end,
+	.releasepage = v9fs_release_page,
+	.invalidatepage = v9fs_invalidate_page,
+	.launder_page = v9fs_launder_page,
+	.direct_IO = v9fs_direct_IO,
 };
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 0f62b26..6e38947 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -44,6 +44,8 @@
 #include "fid.h"
 #include "cache.h"
 
+static const struct vm_operations_struct v9fs_file_vm_ops;
+
 /**
  * v9fs_file_open - open a file (or directory)
  * @inode: inode to be opened
@@ -515,6 +517,7 @@ out:
 	return retval;
 }
 
+
 static int v9fs_file_fsync(struct file *filp, int datasync)
 {
 	struct p9_fid *fid;
@@ -544,28 +547,71 @@ int v9fs_file_fsync_dotl(struct file *filp, int datasync)
 	return retval;
 }
 
+static int
+v9fs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int retval;
+
+	retval = generic_file_mmap(file, vma);
+	if (!retval)
+		vma->vm_ops = &v9fs_file_vm_ops;
+
+	return retval;
+}
+
+static int
+v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct page *page = vmf->page;
+	struct file *filp = vma->vm_file;
+	struct inode *inode = filp->f_path.dentry->d_inode;
+
+
+	P9_DPRINTK(P9_DEBUG_VFS, "page %p fid %lx\n",
+		   page, (unsigned long)filp->private_data);
+
+	/* make sure the cache has finished storing the page */
+	v9fs_fscache_wait_on_page_write(inode, page);
+	BUG_ON(!inode->i_private);
+	lock_page(page);
+	if (page->mapping != inode->i_mapping)
+		goto out_unlock;
+
+	return VM_FAULT_LOCKED;
+out_unlock:
+	unlock_page(page);
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct v9fs_file_vm_ops = {
+	.fault = filemap_fault,
+	.page_mkwrite = v9fs_vm_page_mkwrite,
+};
+
 const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
+	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
-	.write = v9fs_file_write,
+	.aio_write = generic_file_aio_write,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock,
-	.mmap = generic_file_readonly_mmap,
+	.mmap = v9fs_file_mmap,
 	.fsync = v9fs_file_fsync,
 };
 
 const struct file_operations v9fs_cached_file_operations_dotl = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
+	.write = do_sync_write,
 	.aio_read = generic_file_aio_read,
-	.write = v9fs_file_write,
+	.aio_write = generic_file_aio_write,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock_dotl,
 	.flock = v9fs_file_flock_dotl,
-	.mmap = generic_file_readonly_mmap,
+	.mmap = v9fs_file_mmap,
 	.fsync = v9fs_file_fsync_dotl,
 };
 
-- 
1.7.1

