Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab2JVPSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:18:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34034 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab2JVPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:16:01 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 03/22] iov_iter: add copy_to_user support
Date: Mon, 22 Oct 2012 10:15:03 -0500
Message-Id: <1350918922-6096-4-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
index 001c7cf..36f9291 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -227,6 +227,10 @@ struct iov_iter {
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
1.7.12.3

