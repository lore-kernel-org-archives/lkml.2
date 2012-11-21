Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab2KVTsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:48:36 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:40309 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab2KVTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:48:34 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 03/31] iov_iter: add copy_to_user support
Date: Wed, 21 Nov 2012 16:40:43 -0600
Message-Id: <1353537671-26284-4-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds iov_iter wrappers around copy_to_user() to match the existing
wrappers around copy_from_user().

This will be used by the generic file system buffered read path.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h |  4 +++
 mm/iov-iter.c      | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..26c1bda 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -294,6 +294,10 @@ struct iov_iter {
 	size_t count;
 };
 
+size_t iov_iter_copy_to_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
+size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 size_t iov_iter_copy_from_user(struct page *page,
diff --git a/mm/iov-iter.c b/mm/iov-iter.c
index 5c4f3a5..d68b67f 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -6,6 +6,86 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 
+static size_t __iovec_copy_to_user(char *vaddr, const struct iovec *iov,
+				   size_t base, size_t bytes, int atomic)
+{
+	size_t copied = 0, left = 0;
+
+	while (bytes) {
+		char __user *buf = iov->iov_base + base;
+		int copy = min(bytes, iov->iov_len - base);
+
+		base = 0;
+		if (atomic)
+			left = __copy_to_user_inatomic(buf, vaddr, copy);
+		else
+			left = copy_to_user(buf, vaddr, copy);
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
+ * were sucessfully copied.  If a fault is encountered then return the number of
+ * bytes which were copied.
+ */
+size_t iov_iter_copy_to_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	BUG_ON(!in_atomic());
+	kaddr = kmap_atomic(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_to_user_inatomic(buf, kaddr + offset, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_to_user(kaddr + offset, i->iov,
+					      i->iov_offset, bytes, 1);
+	}
+	kunmap_atomic(kaddr);
+
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_to_user_atomic);
+
+/*
+ * This has the same sideeffects and return value as
+ * iov_iter_copy_to_user_atomic().
+ * The difference is that it attempts to resolve faults.
+ * Page must not be locked.
+ */
+size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	kaddr = kmap(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = copy_to_user(buf, kaddr + offset, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_to_user(kaddr + offset, i->iov,
+					      i->iov_offset, bytes, 0);
+	}
+	kunmap(page);
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_to_user);
+
 static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
 				     size_t base, size_t bytes, int atomic)
 {
-- 
1.8.0

