Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab2B0V0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:26:04 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33595 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab2B0VUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:22 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 04/22] iov_iter: hide iovec details behind ops function pointers
Date: Mon, 27 Feb 2012 15:19:18 -0600
Message-Id: <1330377576-3659-5-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F4BF395.0092,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This moves the current iov_iter functions behind an ops struct of
function pointers.  The current iov_iter functions all work with memory
which is specified by iovec arrays of user space pointers.

This patch is part of a series that lets us specify memory with bio_vec
arrays of page pointers.  By moving to an iov_iter operation struct we
can add that support in later patches in this series by adding another
set of function pointers.

I only came to this after having initialy tried to teach the current
iov_iter functions about bio_vecs by introducing conditional branches
that dealt with bio_vecs in all the functions.  It wasn't pretty.  This
approach seems to be the lesser evil.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h |   65 ++++++++++++++++++++++++++++++++++++++++-----------
 mm/iov-iter.c      |   66 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 90 insertions(+), 41 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c66aa4b..1a64eda 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -529,29 +529,68 @@ struct address_space;
 struct writeback_control;
 
 struct iov_iter {
-	const struct iovec *iov;
+	struct iov_iter_ops *ops;
+	unsigned long data;
 	unsigned long nr_segs;
 	size_t iov_offset;
 	size_t count;
 };
 
-size_t iov_iter_copy_to_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_to_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_from_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_from_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-void iov_iter_advance(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
-size_t iov_iter_single_seg_count(struct iov_iter *i);
+struct iov_iter_ops {
+	size_t (*ii_copy_to_user_atomic)(struct page *, struct iov_iter *,
+					 unsigned long, size_t);
+	size_t (*ii_copy_to_user)(struct page *, struct iov_iter *,
+				  unsigned long, size_t);
+	size_t (*ii_copy_from_user_atomic)(struct page *, struct iov_iter *,
+					   unsigned long, size_t);
+	size_t (*ii_copy_from_user)(struct page *, struct iov_iter *,
+					  unsigned long, size_t);
+	void (*ii_advance)(struct iov_iter *, size_t);
+	int (*ii_fault_in_readable)(struct iov_iter *, size_t);
+	size_t (*ii_single_seg_count)(struct iov_iter *);
+};
+
+static inline size_t iov_iter_copy_to_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_to_user_atomic(page, i, offset, bytes);
+}
+static inline size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_to_user(page, i, offset, bytes);
+}
+static inline size_t iov_iter_copy_from_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_from_user_atomic(page, i, offset, bytes);
+}
+static inline size_t iov_iter_copy_from_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_from_user(page, i, offset, bytes);
+}
+static inline void iov_iter_advance(struct iov_iter *i, size_t bytes)
+{
+	return i->ops->ii_advance(i, bytes);
+}
+static inline int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
+{
+	return i->ops->ii_fault_in_readable(i, bytes);
+}
+static inline size_t iov_iter_single_seg_count(struct iov_iter *i)
+{
+	return i->ops->ii_single_seg_count(i);
+}
+
+extern struct iov_iter_ops ii_iovec_ops;
 
 static inline void iov_iter_init(struct iov_iter *i,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count, size_t written)
 {
-	i->iov = iov;
+	i->ops = &ii_iovec_ops;
+	i->data = (unsigned long)iov;
 	i->nr_segs = nr_segs;
 	i->iov_offset = 0;
 	i->count = count + written;
diff --git a/mm/iov-iter.c b/mm/iov-iter.c
index eea21ea..83f0db7 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -33,9 +33,10 @@ static size_t __iovec_copy_to_user_inatomic(char *vaddr,
  * were sucessfully copied.  If a fault is encountered then return the number of
  * bytes which were copied.
  */
-size_t iov_iter_copy_to_user_atomic(struct page *page,
+size_t ii_iovec_copy_to_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
@@ -43,45 +44,44 @@ size_t iov_iter_copy_to_user_atomic(struct page *page,
 	kaddr = kmap_atomic(page, KM_USER0);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = __copy_to_user_inatomic(buf, kaddr + offset, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_to_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+						iov, i->iov_offset, bytes);
 	}
 	kunmap_atomic(kaddr, KM_USER0);
 
 	return copied;
 }
-EXPORT_SYMBOL(iov_iter_copy_to_user_atomic);
 
 /*
  * This has the same sideeffects and return value as
- * iov_iter_copy_to_user_atomic().
+ * ii_iovec_copy_to_user_atomic().
  * The difference is that it attempts to resolve faults.
  * Page must not be locked.
  */
-size_t iov_iter_copy_to_user(struct page *page,
+size_t ii_iovec_copy_to_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
 	kaddr = kmap(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = copy_to_user(buf, kaddr + offset, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_to_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+						iov, i->iov_offset, bytes);
 	}
 	kunmap(page);
 	return copied;
 }
-EXPORT_SYMBOL(iov_iter_copy_to_user);
 
 
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
@@ -111,9 +111,10 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,
  * were successfully copied.  If a fault is encountered then return the number
  * of bytes which were copied.
  */
-size_t iov_iter_copy_from_user_atomic(struct page *page,
+size_t ii_iovec_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
@@ -121,12 +122,12 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	kaddr = kmap_atomic(page, KM_USER0);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+						iov, i->iov_offset, bytes);
 	}
 	kunmap_atomic(kaddr, KM_USER0);
 
@@ -136,32 +137,32 @@ EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
 
 /*
  * This has the same sideeffects and return value as
- * iov_iter_copy_from_user_atomic().
+ * ii_iovec_copy_from_user_atomic().
  * The difference is that it attempts to resolve faults.
  * Page must not be locked.
  */
-size_t iov_iter_copy_from_user(struct page *page,
+size_t ii_iovec_copy_from_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
 	kaddr = kmap(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = __copy_from_user(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
 		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+						iov, i->iov_offset, bytes);
 	}
 	kunmap(page);
 	return copied;
 }
-EXPORT_SYMBOL(iov_iter_copy_from_user);
 
-void iov_iter_advance(struct iov_iter *i, size_t bytes)
+void ii_iovec_advance(struct iov_iter *i, size_t bytes)
 {
 	BUG_ON(i->count < bytes);
 
@@ -169,7 +170,7 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 		i->iov_offset += bytes;
 		i->count -= bytes;
 	} else {
-		const struct iovec *iov = i->iov;
+		struct iovec *iov = (struct iovec *)i->data;
 		size_t base = i->iov_offset;
 		unsigned long nr_segs = i->nr_segs;
 
@@ -191,12 +192,11 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 				base = 0;
 			}
 		}
-		i->iov = iov;
+		i->data = (unsigned long)iov;
 		i->iov_offset = base;
 		i->nr_segs = nr_segs;
 	}
 }
-EXPORT_SYMBOL(iov_iter_advance);
 
 /*
  * Fault in the first iovec of the given iov_iter, to a maximum length
@@ -207,23 +207,33 @@ EXPORT_SYMBOL(iov_iter_advance);
  * would be possible (callers must not rely on the fact that _only_ the
  * first iovec will be faulted with the current implementation).
  */
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
+int ii_iovec_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
-	char __user *buf = i->iov->iov_base + i->iov_offset;
-	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
+	struct iovec *iov = (struct iovec *)i->data;
+	char __user *buf = iov->iov_base + i->iov_offset;
+	bytes = min(bytes, iov->iov_len - i->iov_offset);
 	return fault_in_pages_readable(buf, bytes);
 }
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
 /*
  * Return the count of just the current iov_iter segment.
  */
-size_t iov_iter_single_seg_count(struct iov_iter *i)
+size_t ii_iovec_single_seg_count(struct iov_iter *i)
 {
-	const struct iovec *iov = i->iov;
+	struct iovec *iov = (struct iovec *)i->data;
 	if (i->nr_segs == 1)
 		return i->count;
 	else
 		return min(i->count, iov->iov_len - i->iov_offset);
 }
-EXPORT_SYMBOL(iov_iter_single_seg_count);
+
+struct iov_iter_ops ii_iovec_ops = {
+	.ii_copy_to_user_atomic = ii_iovec_copy_to_user_atomic,
+	.ii_copy_to_user = ii_iovec_copy_to_user,
+	.ii_copy_from_user_atomic = ii_iovec_copy_from_user_atomic,
+	.ii_copy_from_user = ii_iovec_copy_from_user,
+	.ii_advance = ii_iovec_advance,
+	.ii_fault_in_readable = ii_iovec_fault_in_readable,
+	.ii_single_seg_count = ii_iovec_single_seg_count,
+};
+EXPORT_SYMBOL(ii_iovec_ops);
-- 
1.7.9.2

