Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab2B0V0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:26:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30066 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2B0VUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:22 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 01/22] iov_iter: move into its own file
Date: Mon, 27 Feb 2012 15:19:15 -0600
Message-Id: <1330377576-3659-2-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F4BF395.0029,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This moves the iov_iter functions in to their own file.  We're going to
be working on them in upcoming patches.  They become sufficiently large,
and remain self-contained, to justify seperating them from the rest of
the huge mm/filemap.c.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 mm/Makefile   |    2 +-
 mm/filemap.c  |  144 ------------------------------------------------------
 mm/iov-iter.c |  151 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 152 insertions(+), 145 deletions(-)
 create mode 100644 mm/iov-iter.c

diff --git a/mm/Makefile b/mm/Makefile
index 50ec00e..652f053 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -13,7 +13,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o mmu_context.o percpu.o \
-			   $(mmu-y)
+			   iov-iter.o $(mmu-y)
 obj-y += init-mm.o
 
 ifdef CONFIG_NO_BOOTMEM
diff --git a/mm/filemap.c b/mm/filemap.c
index b662757..0533a71 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2011,150 +2011,6 @@ int file_remove_suid(struct file *file)
 }
 EXPORT_SYMBOL(file_remove_suid);
 
-static size_t __iovec_copy_from_user_inatomic(char *vaddr,
-			const struct iovec *iov, size_t base, size_t bytes)
-{
-	size_t copied = 0, left = 0;
-
-	while (bytes) {
-		char __user *buf = iov->iov_base + base;
-		int copy = min(bytes, iov->iov_len - base);
-
-		base = 0;
-		left = __copy_from_user_inatomic(vaddr, buf, copy);
-		copied += copy;
-		bytes -= copy;
-		vaddr += copy;
-		iov++;
-
-		if (unlikely(left))
-			break;
-	}
-	return copied - left;
-}
-
-/*
- * Copy as much as we can into the page and return the number of bytes which
- * were successfully copied.  If a fault is encountered then return the number of
- * bytes which were copied.
- */
-size_t iov_iter_copy_from_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	BUG_ON(!in_atomic());
-	kaddr = kmap_atomic(page, KM_USER0);
-	if (likely(i->nr_segs == 1)) {
-		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
-		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
-		copied = bytes - left;
-	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
-	}
-	kunmap_atomic(kaddr, KM_USER0);
-
-	return copied;
-}
-EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
-
-/*
- * This has the same sideeffects and return value as
- * iov_iter_copy_from_user_atomic().
- * The difference is that it attempts to resolve faults.
- * Page must not be locked.
- */
-size_t iov_iter_copy_from_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	kaddr = kmap(page);
-	if (likely(i->nr_segs == 1)) {
-		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
-		left = __copy_from_user(kaddr + offset, buf, bytes);
-		copied = bytes - left;
-	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
-	}
-	kunmap(page);
-	return copied;
-}
-EXPORT_SYMBOL(iov_iter_copy_from_user);
-
-void iov_iter_advance(struct iov_iter *i, size_t bytes)
-{
-	BUG_ON(i->count < bytes);
-
-	if (likely(i->nr_segs == 1)) {
-		i->iov_offset += bytes;
-		i->count -= bytes;
-	} else {
-		const struct iovec *iov = i->iov;
-		size_t base = i->iov_offset;
-		unsigned long nr_segs = i->nr_segs;
-
-		/*
-		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments (without overruning the iovec).
-		 */
-		while (bytes || unlikely(i->count && !iov->iov_len)) {
-			int copy;
-
-			copy = min(bytes, iov->iov_len - base);
-			BUG_ON(!i->count || i->count < copy);
-			i->count -= copy;
-			bytes -= copy;
-			base += copy;
-			if (iov->iov_len == base) {
-				iov++;
-				nr_segs--;
-				base = 0;
-			}
-		}
-		i->iov = iov;
-		i->iov_offset = base;
-		i->nr_segs = nr_segs;
-	}
-}
-EXPORT_SYMBOL(iov_iter_advance);
-
-/*
- * Fault in the first iovec of the given iov_iter, to a maximum length
- * of bytes. Returns 0 on success, or non-zero if the memory could not be
- * accessed (ie. because it is an invalid address).
- *
- * writev-intensive code may want this to prefault several iovecs -- that
- * would be possible (callers must not rely on the fact that _only_ the
- * first iovec will be faulted with the current implementation).
- */
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
-{
-	char __user *buf = i->iov->iov_base + i->iov_offset;
-	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
-	return fault_in_pages_readable(buf, bytes);
-}
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
-
-/*
- * Return the count of just the current iov_iter segment.
- */
-size_t iov_iter_single_seg_count(struct iov_iter *i)
-{
-	const struct iovec *iov = i->iov;
-	if (i->nr_segs == 1)
-		return i->count;
-	else
-		return min(i->count, iov->iov_len - i->iov_offset);
-}
-EXPORT_SYMBOL(iov_iter_single_seg_count);
-
 /*
  * Performs necessary checks before doing a write
  *
diff --git a/mm/iov-iter.c b/mm/iov-iter.c
new file mode 100644
index 0000000..596fcf0
--- /dev/null
+++ b/mm/iov-iter.c
@@ -0,0 +1,151 @@
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/uio.h>
+#include <linux/hardirq.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+
+static size_t __iovec_copy_from_user_inatomic(char *vaddr,
+			const struct iovec *iov, size_t base, size_t bytes)
+{
+	size_t copied = 0, left = 0;
+
+	while (bytes) {
+		char __user *buf = iov->iov_base + base;
+		int copy = min(bytes, iov->iov_len - base);
+
+		base = 0;
+		left = __copy_from_user_inatomic(vaddr, buf, copy);
+		copied += copy;
+		bytes -= copy;
+		vaddr += copy;
+		iov++;
+
+		if (unlikely(left))
+			break;
+	}
+	return copied - left;
+}
+
+/*
+ * Copy as much as we can into the page and return the number of bytes which
+ * were successfully copied.  If a fault is encountered then return the number
+ * of bytes which were copied.
+ */
+size_t iov_iter_copy_from_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	BUG_ON(!in_atomic());
+	kaddr = kmap_atomic(page, KM_USER0);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap_atomic(kaddr, KM_USER0);
+
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
+
+/*
+ * This has the same sideeffects and return value as
+ * iov_iter_copy_from_user_atomic().
+ * The difference is that it attempts to resolve faults.
+ * Page must not be locked.
+ */
+size_t iov_iter_copy_from_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	kaddr = kmap(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_from_user(kaddr + offset, buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap(page);
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_from_user);
+
+void iov_iter_advance(struct iov_iter *i, size_t bytes)
+{
+	BUG_ON(i->count < bytes);
+
+	if (likely(i->nr_segs == 1)) {
+		i->iov_offset += bytes;
+		i->count -= bytes;
+	} else {
+		const struct iovec *iov = i->iov;
+		size_t base = i->iov_offset;
+		unsigned long nr_segs = i->nr_segs;
+
+		/*
+		 * The !iov->iov_len check ensures we skip over unlikely
+		 * zero-length segments (without overruning the iovec).
+		 */
+		while (bytes || unlikely(i->count && !iov->iov_len)) {
+			int copy;
+
+			copy = min(bytes, iov->iov_len - base);
+			BUG_ON(!i->count || i->count < copy);
+			i->count -= copy;
+			bytes -= copy;
+			base += copy;
+			if (iov->iov_len == base) {
+				iov++;
+				nr_segs--;
+				base = 0;
+			}
+		}
+		i->iov = iov;
+		i->iov_offset = base;
+		i->nr_segs = nr_segs;
+	}
+}
+EXPORT_SYMBOL(iov_iter_advance);
+
+/*
+ * Fault in the first iovec of the given iov_iter, to a maximum length
+ * of bytes. Returns 0 on success, or non-zero if the memory could not be
+ * accessed (ie. because it is an invalid address).
+ *
+ * writev-intensive code may want this to prefault several iovecs -- that
+ * would be possible (callers must not rely on the fact that _only_ the
+ * first iovec will be faulted with the current implementation).
+ */
+int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
+{
+	char __user *buf = i->iov->iov_base + i->iov_offset;
+	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
+	return fault_in_pages_readable(buf, bytes);
+}
+EXPORT_SYMBOL(iov_iter_fault_in_readable);
+
+/*
+ * Return the count of just the current iov_iter segment.
+ */
+size_t iov_iter_single_seg_count(struct iov_iter *i)
+{
+	const struct iovec *iov = i->iov;
+	if (i->nr_segs == 1)
+		return i->count;
+	else
+		return min(i->count, iov->iov_len - i->iov_offset);
+}
+EXPORT_SYMBOL(iov_iter_single_seg_count);
-- 
1.7.9.2

