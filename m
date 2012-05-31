Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2EaUoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:44:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40321 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2EaUoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:44:12 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 2/2] msync: start async writeout when MS_ASYNC
Date: Thu, 31 May 2012 22:43:55 +0200
Message-Id: <1338497035-13014-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msync.c says that applications had better use fsync() or fadvise(FADV_DONTNEED)
instead of MS_ASYNC.  Both advices are really bad:

* fsync() can be a replacement for MS_SYNC, not for MS_ASYNC;

* fadvise(FADV_DONTNEED) invalidates the pages completely, which will make
  later accesses expensive.

Having the possibility to schedule a writeback immediately is an advantage
for the applications.  They can do the same thing that fadvise does,
but without the invalidation part.  The implementation is also similar
to fadvise, but with tag-and-write enabled.

One example is if you are implementing a persistent dirty bitmap.
Whenever you set bits to 1 you need to synchronize it with MS_SYNC, so
that dirtiness is reported properly after a host crash.  If you have set
any bits to 0, getting them to disk is not needed for correctness, but
it is still desirable to save some work after a host crash.  You could
simply use MS_SYNC in a separate thread, but MS_ASYNC provides exactly
the desired semantics and is easily done in the kernel.

If the application does not want to start I/O, it can simply call msync
with flags equal to MS_INVALIDATE.  This one remains a no-op, as it should
be on a reasonable implementation.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/fs.h |    3 +-
 mm/fadvise.c       |    2 +-
 mm/filemap.c       |   11 ++++++---
 mm/msync.c         |   60 ++++++++++++++++++++++++++++++---------------------
 4 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..0aeedb9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2196,7 +2196,8 @@ extern int filemap_write_and_wait(struct address_space *mapping);
 extern int filemap_write_and_wait_range(struct address_space *mapping,
 				        loff_t lstart, loff_t lend);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
-				loff_t start, loff_t end, int sync_mode);
+				loff_t start, loff_t end, int sync_mode,
+				bool tagged_writepages);
 extern int filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end);
 
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 469491e..a3579f1 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -118,7 +118,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 	case POSIX_FADV_DONTNEED:
 		if (!bdi_write_congested(mapping->backing_dev_info))
 			__filemap_fdatawrite_range(mapping, offset, endbyte,
-						   WB_SYNC_NONE);
+						   WB_SYNC_NONE, 0);
 
 		/* First and last FULL page! */
 		start_index = (offset+(PAGE_CACHE_SIZE-1)) >> PAGE_CACHE_SHIFT;
diff --git a/mm/filemap.c b/mm/filemap.c
index 79c4b2b..641e2a8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -191,6 +191,7 @@ static int sleep_on_page_killable(void *word)
  * @start:	offset in bytes where the range starts
  * @end:	offset in bytes where the range ends (inclusive)
  * @sync_mode:	enable synchronous operation
+ * @tagged_writepages: tag-and-write to avoid livelock (implicit if WB_SYNC_ALL)
  *
  * Start writeback against all of a mapping's dirty pages that lie
  * within the byte offsets <start, end> inclusive.
@@ -201,7 +202,8 @@ static int sleep_on_page_killable(void *word)
  * be waited upon, and not just skipped over.
  */
 int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
-				loff_t end, int sync_mode)
+				loff_t end, int sync_mode,
+				bool tagged_writepages)
 {
 	int ret;
 	struct writeback_control wbc = {
@@ -209,6 +211,7 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 		.nr_to_write = LONG_MAX,
 		.range_start = start,
 		.range_end = end,
+		.tagged_writepages = tagged_writepages,
 	};
 
 	if (!mapping_cap_writeback_dirty(mapping))
@@ -221,7 +224,7 @@ int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 static inline int __filemap_fdatawrite(struct address_space *mapping,
 	int sync_mode)
 {
-	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode);
+	return __filemap_fdatawrite_range(mapping, 0, LLONG_MAX, sync_mode, 0);
 }
 
 int filemap_fdatawrite(struct address_space *mapping)
@@ -233,7 +236,7 @@ EXPORT_SYMBOL(filemap_fdatawrite);
 int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 				loff_t end)
 {
-	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
+	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL, 1);
 }
 EXPORT_SYMBOL(filemap_fdatawrite_range);
 
@@ -361,7 +364,7 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 
 	if (mapping->nrpages) {
 		err = __filemap_fdatawrite_range(mapping, lstart, lend,
-						 WB_SYNC_ALL);
+						 WB_SYNC_ALL, 1);
 		/* See comment of filemap_write_and_wait() */
 		if (err != -EIO) {
 			int err2 = filemap_fdatawait_range(mapping,
diff --git a/mm/msync.c b/mm/msync.c
index 505fe99..4d1f813 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -13,20 +13,16 @@
 #include <linux/file.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
+#include <linux/backing-dev.h>
+#include <linux/writeback.h>
 
 /*
  * MS_SYNC syncs the specified range - including mappings.
  *
- * MS_ASYNC does not start I/O (it used to, up to 2.5.67).
- * Nor does it marks the relevant pages dirty (it used to up to 2.6.17).
- * Now it doesn't do anything, since dirty pages are properly tracked.
- *
- * The application may now run fsync() to
- * write out the dirty pages and wait on the writeout and check the result.
- * Or the application may run fadvise(FADV_DONTNEED) against the fd to start
- * async writeout immediately.
- * So by _not_ starting I/O in MS_ASYNC we provide complete flexibility to
- * applications.
+ * MS_ASYNC only starts I/O, as it did up to 2.5.67, but only dirty pages
+ * will now be written.   While the application may run fadvise(FADV_DONTNEED)
+ * against the fd to start async writeout immediately, invalidating the
+ * pages will make later accesses expensive.
  */
 SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 {
@@ -78,30 +74,44 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 			error = -EBUSY;
 			goto out_unlock;
 		}
+
+		error = 0;
 		file = vma->vm_file;
 		next = min(end, vma->vm_end);
-		if ((flags & MS_SYNC) && file &&
-				(vma->vm_flags & VM_SHARED)) {
-			file_offset = vma->vm_pgoff * PAGE_SIZE;
-			get_file(file);
-			up_read(&mm->mmap_sem);
-			error = vfs_fsync_range(file,
-					start - vma->vm_start + file_offset,
-					next - vma->vm_start + file_offset, 1);
-			fput(file);
-			start = next;
-			if (error || start >= end)
-				goto out;
-			down_read(&mm->mmap_sem);
-			vma = find_vma(mm, start);
-		} else {
+		if (!file || !(vma->vm_flags & VM_SHARED) ||
+		    !(flags & ~MS_INVALIDATE)) {
 			start = next;
 			if (start >= end) {
 				error = 0;
 				goto out_unlock;
 			}
 			vma = vma->vm_next;
+			continue;
+		}
+
+		file_offset = vma->vm_pgoff * PAGE_SIZE;
+		get_file(file);
+		up_read(&mm->mmap_sem);
+		if (flags & MS_SYNC) {
+			error = vfs_fsync_range(file,
+					start - vma->vm_start + file_offset,
+					next - vma->vm_start + file_offset, 1);
+		} else {
+			struct address_space *mapping = file->f_mapping;
+			/* end offset is inclusive! */
+			if (mapping &&
+			    !bdi_write_congested(mapping->backing_dev_info))
+				__filemap_fdatawrite_range(mapping,
+					start - vma->vm_start + file_offset,
+					next - 1 - vma->vm_start + file_offset,
+					WB_SYNC_NONE, 1);
 		}
+		fput(file);
+		start = next;
+		if (error || start >= end)
+			goto out;
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, start);
 	}
 out_unlock:
 	up_read(&mm->mmap_sem);
-- 
1.7.1

