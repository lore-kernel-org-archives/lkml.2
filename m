Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2B0V0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:26:42 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30068 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2B0VUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:21 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 05/22] iov_iter: add bvec support
Date: Mon, 27 Feb 2012 15:19:19 -0600
Message-Id: <1330377576-3659-6-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F4BF395.0052,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds a set of iov_iter_ops calls which work with memory which is
specified by an array of bio_vec structs instead of an array of iovec
structs.

The big difference is that the pages referenced by the bio_vec elements
are pinned.  They don't need to be faulted in and we can always use
kmap_atomic() to map them one at a time.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h |   17 +++++++
 mm/iov-iter.c      |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1a64eda..3689d58 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -583,6 +583,23 @@ static inline size_t iov_iter_single_seg_count(struct iov_iter *i)
 	return i->ops->ii_single_seg_count(i);
 }
 
+extern struct iov_iter_ops ii_bvec_ops;
+
+struct bio_vec;
+static inline void iov_iter_init_bvec(struct iov_iter *i,
+				      struct bio_vec *bvec,
+				      unsigned long nr_segs,
+				      size_t count, size_t written)
+{
+	i->ops = &ii_bvec_ops;
+	i->data = (unsigned long)bvec;
+	i->nr_segs = nr_segs;
+	i->iov_offset = 0;
+	i->count = count + written;
+
+	iov_iter_advance(i, written);
+}
+
 extern struct iov_iter_ops ii_iovec_ops;
 
 static inline void iov_iter_init(struct iov_iter *i,
diff --git a/mm/iov-iter.c b/mm/iov-iter.c
index 83f0db7..5b35f23 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -5,6 +5,7 @@
 #include <linux/hardirq.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/bio.h>
 
 static size_t __iovec_copy_to_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
@@ -83,6 +84,129 @@ size_t ii_iovec_copy_to_user(struct page *page,
 	return copied;
 }
 
+/*
+ * As an easily verifiable first pass, we implement all the methods that
+ * copy data to and from bvec pages with one function.  We implement it
+ * all with kmap_atomic().
+ */
+static size_t bvec_copy_tofrom_page(struct iov_iter *iter, struct page *page,
+				    unsigned long page_offset, size_t bytes,
+				    int topage)
+{
+	struct bio_vec *bvec = (struct bio_vec *)iter->data;
+	size_t bvec_offset = iter->iov_offset;
+	size_t remaining = bytes;
+	void *bvec_map;
+	void *page_map;
+	size_t copy;
+
+	page_map = kmap_atomic(page, KM_USER0);
+
+	BUG_ON(bytes > iter->count);
+	while (remaining) {
+		BUG_ON(bvec->bv_len == 0);
+		BUG_ON(bvec_offset >= bvec->bv_len);
+		copy = min(remaining, bvec->bv_len - bvec_offset);
+		bvec_map = kmap_atomic(bvec->bv_page, KM_USER1);
+		if (topage)
+			memcpy(page_map + page_offset,
+			       bvec_map + bvec->bv_offset + bvec_offset,
+			       copy);
+		else
+			memcpy(bvec_map + bvec->bv_offset + bvec_offset,
+			       page_map + page_offset,
+			       copy);
+		kunmap_atomic(bvec_map, KM_USER1);
+		remaining -= copy;
+		bvec_offset += copy;
+		page_offset += copy;
+		if (bvec_offset == bvec->bv_len) {
+			bvec_offset = 0;
+			bvec++;
+		}
+	}
+
+	kunmap_atomic(page_map, KM_USER0);
+
+	return bytes;
+}
+
+size_t ii_bvec_copy_to_user_atomic(struct page *page, struct iov_iter *i,
+				   unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 0);
+}
+size_t ii_bvec_copy_to_user(struct page *page, struct iov_iter *i,
+				   unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 0);
+}
+size_t ii_bvec_copy_from_user_atomic(struct page *page, struct iov_iter *i,
+				     unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 1);
+}
+size_t ii_bvec_copy_from_user(struct page *page, struct iov_iter *i,
+			      unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 1);
+}
+
+/*
+ * bio_vecs have a stricter structure than iovecs that might have
+ * come from userspace.  There are no zero length bio_vec elements.
+ */
+void ii_bvec_advance(struct iov_iter *i, size_t bytes)
+{
+	struct bio_vec *bvec = (struct bio_vec *)i->data;
+	size_t offset = i->iov_offset;
+	size_t delta;
+
+	BUG_ON(i->count < bytes);
+	while (bytes) {
+		BUG_ON(bvec->bv_len == 0);
+		BUG_ON(bvec->bv_len <= offset);
+		delta = min(bytes, bvec->bv_len - offset);
+		offset += delta;
+		i->count -= delta;
+		bytes -= delta;
+		if (offset == bvec->bv_len) {
+			bvec++;
+			offset = 0;
+		}
+	}
+
+	i->data = (unsigned long)bvec;
+	i->iov_offset = offset;
+}
+
+/*
+ * pages pointed to by bio_vecs are always pinned.
+ */
+int ii_bvec_fault_in_readable(struct iov_iter *i, size_t bytes)
+{
+	return 0;
+}
+
+size_t ii_bvec_single_seg_count(struct iov_iter *i)
+{
+	const struct bio_vec *bvec = (struct bio_vec *)i->data;
+	if (i->nr_segs == 1)
+		return i->count;
+	else
+		return min(i->count, bvec->bv_len - i->iov_offset);
+}
+
+struct iov_iter_ops ii_bvec_ops = {
+	.ii_copy_to_user_atomic = ii_bvec_copy_to_user_atomic,
+	.ii_copy_to_user = ii_bvec_copy_to_user,
+	.ii_copy_from_user_atomic = ii_bvec_copy_from_user_atomic,
+	.ii_copy_from_user = ii_bvec_copy_from_user,
+	.ii_advance = ii_bvec_advance,
+	.ii_fault_in_readable = ii_bvec_fault_in_readable,
+	.ii_single_seg_count = ii_bvec_single_seg_count,
+};
+EXPORT_SYMBOL(ii_bvec_ops);
 
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
-- 
1.7.9.2

