Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab2EOG6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab2EOG57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:57:59 -0400
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org
Subject: [PATCH 1/2] mm: move readahead syscall to mm/readahead.c
Date: Tue, 15 May 2012 14:57:32 +0800
Message-Id: <1337065058-310-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

It is better to define readahead(2) in mm/readahead.c
than in mm/filemap.c.

Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 mm/filemap.c   |   39 ---------------------------------------
 mm/readahead.c |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 79c4b2b..64b48f9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -29,7 +29,6 @@
 #include <linux/pagevec.h>
 #include <linux/blkdev.h>
 #include <linux/security.h>
-#include <linux/syscalls.h>
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
@@ -1478,44 +1477,6 @@ out:
 }
 EXPORT_SYMBOL(generic_file_aio_read);
 
-static ssize_t
-do_readahead(struct address_space *mapping, struct file *filp,
-	     pgoff_t index, unsigned long nr)
-{
-	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
-		return -EINVAL;
-
-	force_page_cache_readahead(mapping, filp, index, nr);
-	return 0;
-}
-
-SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
-{
-	ssize_t ret;
-	struct file *file;
-
-	ret = -EBADF;
-	file = fget(fd);
-	if (file) {
-		if (file->f_mode & FMODE_READ) {
-			struct address_space *mapping = file->f_mapping;
-			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
-			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
-			unsigned long len = end - start + 1;
-			ret = do_readahead(mapping, file, start, len);
-		}
-		fput(file);
-	}
-	return ret;
-}
-#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
-asmlinkage long SyS_readahead(long fd, loff_t offset, long count)
-{
-	return SYSC_readahead((int) fd, offset, (size_t) count);
-}
-SYSCALL_ALIAS(sys_readahead, SyS_readahead);
-#endif
-
 #ifdef CONFIG_MMU
 /**
  * page_cache_read - adds requested page to the page cache if not already there
diff --git a/mm/readahead.c b/mm/readahead.c
index cbcbb02..ea8f8fa 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -17,6 +17,8 @@
 #include <linux/task_io_accounting_ops.h>
 #include <linux/pagevec.h>
 #include <linux/pagemap.h>
+#include <linux/syscalls.h>
+#include <linux/file.h>
 
 /*
  * Initialise a struct file's readahead state.  Assumes that the caller has
@@ -562,3 +564,41 @@ page_cache_async_readahead(struct address_space *mapping,
 	ondemand_readahead(mapping, ra, filp, true, offset, req_size);
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
+
+static ssize_t
+do_readahead(struct address_space *mapping, struct file *filp,
+	     pgoff_t index, unsigned long nr)
+{
+	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
+		return -EINVAL;
+
+	force_page_cache_readahead(mapping, filp, index, nr);
+	return 0;
+}
+
+SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
+{
+	ssize_t ret;
+	struct file *file;
+
+	ret = -EBADF;
+	file = fget(fd);
+	if (file) {
+		if (file->f_mode & FMODE_READ) {
+			struct address_space *mapping = file->f_mapping;
+			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
+			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			unsigned long len = end - start + 1;
+			ret = do_readahead(mapping, file, start, len);
+		}
+		fput(file);
+	}
+	return ret;
+}
+#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
+asmlinkage long SyS_readahead(long fd, loff_t offset, long count)
+{
+	return SYSC_readahead((int) fd, offset, (size_t) count);
+}
+SYSCALL_ALIAS(sys_readahead, SyS_readahead);
+#endif
-- 
1.7.7.6

