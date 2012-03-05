Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab2CEQGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:06:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab2CEQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:38 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 09/19] fs: Protect write paths by sb_start_write - sb_end_write
Date: Mon,  5 Mar 2012 17:01:07 +0100
Message-Id: <1330963277-26336-10-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several entry points which dirty pages in a filesystem.  mmap
(handled by block_page_mkwrite()), buffered write (handled by
__generic_file_aio_write()), splice write (generic_file_splice_write),
truncate, and fallocate (these can dirty last partial page - handled inside
each filesystem separately). Protect these places with sb_start_write() and
sb_end_write().

->page_mkwrite() calls are particularly complex since they are called with
mmap_sem held and thus we cannot use standard sb_start_write() due to lock
ordering constraints. We solve the problem by using a special freeze protection
sb_start_pagefault() which ranks below mmap_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c      |   22 ++++------------------
 fs/open.c        |    7 ++++++-
 fs/splice.c      |    3 +++
 mm/filemap.c     |   12 ++++++++++--
 mm/filemap_xip.c |    5 +++--
 5 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 5294a33..89ed4af 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2288,8 +2288,8 @@ EXPORT_SYMBOL(block_commit_write);
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
  *
- * Direct callers of this function should call vfs_check_frozen() so that page
- * fault does not busyloop until the fs is thawed.
+ * Direct callers of this function should protect against filesystem freezing
+ * using sb_start_write() - sb_end_write() functions.
  */
 int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 get_block_t get_block)
@@ -2327,18 +2327,7 @@ int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 
 	if (unlikely(ret < 0))
 		goto out_unlock;
-	/*
-	 * Freezing in progress? We check after the page is marked dirty and
-	 * with page lock held so if the test here fails, we are sure freezing
-	 * code will wait during syncing until the page fault is done - at that
-	 * point page will be dirty and unlocked so freezing code will write it
-	 * and writeprotect it again.
-	 */
 	set_page_dirty(page);
-	if (inode->i_sb->s_frozen != SB_UNFROZEN) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
 	wait_on_page_writeback(page);
 	return 0;
 out_unlock:
@@ -2353,12 +2342,9 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	int ret;
 	struct super_block *sb = vma->vm_file->f_path.dentry->d_inode->i_sb;
 
-	/*
-	 * This check is racy but catches the common case. The check in
-	 * __block_page_mkwrite() is reliable.
-	 */
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	sb_start_pagefault(sb);
 	ret = __block_page_mkwrite(vma, vmf, get_block);
+	sb_end_pagefault(sb);
 	return block_page_mkwrite_return(ret);
 }
 EXPORT_SYMBOL(block_page_mkwrite);
diff --git a/fs/open.c b/fs/open.c
index 456e415..444ffbb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -164,11 +164,13 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (IS_APPEND(inode))
 		goto out_putf;
 
+	sb_start_write(inode->i_sb);
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
 		error = security_path_truncate(&file->f_path);
 	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+	sb_end_write(inode->i_sb);
 out_putf:
 	fput(file);
 out:
@@ -266,7 +268,10 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
-	return file->f_op->fallocate(file, mode, offset, len);
+	sb_start_write(inode->i_sb);
+	ret = file->f_op->fallocate(file, mode, offset, len);
+	sb_end_write(inode->i_sb);
+	return ret;
 }
 
 SYSCALL_DEFINE(fallocate)(int fd, int mode, loff_t offset, loff_t len)
diff --git a/fs/splice.c b/fs/splice.c
index 1ec0493..401297d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -992,6 +992,8 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 	};
 	ssize_t ret;
 
+	sb_start_write(inode->i_sb);
+
 	pipe_lock(pipe);
 
 	splice_from_pipe_begin(&sd);
@@ -1028,6 +1030,7 @@ generic_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 			*ppos += ret;
 		balance_dirty_pages_ratelimited_nr(mapping, nr_pages);
 	}
+	sb_end_write(inode->i_sb);
 
 	return ret;
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index b865c0b..8ff3111 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1765,6 +1765,7 @@ int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
 	int ret = VM_FAULT_LOCKED;
 
+	sb_start_pagefault(inode->i_sb);
 	file_update_time(vma->vm_file);
 	lock_page(page);
 	if ((page->mapping != inode->i_mapping) ||
@@ -1773,7 +1774,14 @@ int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		ret = VM_FAULT_NOPAGE;
 		goto out;
 	}
+	/*
+	 * We mark the page dirty already here so that when freeze is in
+	 * progress, we are guaranteed that writeback during freezing will
+	 * see the dirty page and writeprotect it again.
+	 */
+	set_page_dirty(page);
 out:
+	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 EXPORT_SYMBOL(filemap_page_mkwrite);
@@ -2537,8 +2545,6 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	count = ocount;
 	pos = *ppos;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
-
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 	written = 0;
@@ -2635,6 +2641,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
+	sb_start_write(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
 	blk_start_plug(&plug);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
@@ -2648,6 +2655,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			ret = err;
 	}
 	blk_finish_plug(&plug);
+	sb_end_write(inode->i_sb);
 	return ret;
 }
 EXPORT_SYMBOL(generic_file_aio_write);
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 591dba6..b051f0d 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -402,6 +402,8 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	loff_t pos;
 	ssize_t ret;
 
+	sb_start_write(inode->i_sb);
+
 	mutex_lock(&inode->i_mutex);
 
 	if (!access_ok(VERIFY_READ, buf, len)) {
@@ -412,8 +414,6 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	pos = *ppos;
 	count = len;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
-
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
@@ -435,6 +435,7 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	current->backing_dev_info = NULL;
  out_up:
 	mutex_unlock(&inode->i_mutex);
+	sb_end_write(inode->i_sb);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(xip_file_write);
-- 
1.7.1

