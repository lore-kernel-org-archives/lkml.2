Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2B0VUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:20:22 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33568 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2B0VUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:20 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 02/22] iov_iter: add copy_to_user support
Date: Mon, 27 Feb 2012 15:19:16 -0600
Message-Id: <1330377576-3659-3-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4F4BF393.0132,ss=1,re=0.000,fgs=0
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
 include/linux/fs.h |    4 +++
 mm/iov-iter.c      |   78 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 386da09..c66aa4b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -535,6 +535,10 @@ struct iov_iter {
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
index 596fcf0..eea21ea 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -6,6 +6,84 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 
+static size_t __iovec_copy_to_user_inatomic(char *vaddr,
+			const struct iovec *iov, size_t base, size_t bytes)
+{
+	size_t copied = 0, left = 0;
+
+	while (bytes) {
+		char __user *buf = iov->iov_base + base;
+		int copy = min(bytes, iov->iov_len - base);
+
+		base = 0;
+		left = __copy_to_user_inatomic(buf, vaddr, copy);
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
+	kaddr = kmap_atomic(page, KM_USER0);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_to_user_inatomic(buf, kaddr + offset, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_to_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap_atomic(kaddr, KM_USER0);
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
+		copied = __iovec_copy_to_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap(page);
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_to_user);
+
+
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
 {
-- 
1.7.9.2

