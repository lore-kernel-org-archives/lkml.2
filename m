Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157Ab2KVTSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:18:03 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:44974 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965142Ab2KVTR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:17:58 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 07/31] iov_iter: add a shorten call
Date: Wed, 21 Nov 2012 16:40:47 -0600
Message-Id: <1353537671-26284-8-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

The generic direct write path wants to shorten its memory vector.  It
does this when it finds that it has to perform a partial write due to
LIMIT_FSIZE.  .direct_IO() always performs IO on all of the referenced
memory because it doesn't have an argument to specify the length of the
IO.

We add an iov_iter operation for this so that the generic path can ask
to shorten the memory vector without having to know what kind it is.
We're happy to shorten the kernel copy of the iovec array, but we refuse
to shorten the bio_vec array and return an error in this case.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h |  5 +++++
 mm/iov-iter.c      | 14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0d7f42f..8b2f558 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -307,6 +307,7 @@ struct iov_iter_ops {
 	void (*ii_advance)(struct iov_iter *, size_t);
 	int (*ii_fault_in_readable)(struct iov_iter *, size_t);
 	size_t (*ii_single_seg_count)(struct iov_iter *);
+	int (*ii_shorten)(struct iov_iter *, size_t);
 };
 
 static inline size_t iov_iter_copy_to_user_atomic(struct page *page,
@@ -341,6 +342,10 @@ static inline size_t iov_iter_single_seg_count(struct iov_iter *i)
 {
 	return i->ops->ii_single_seg_count(i);
 }
+static inline int iov_iter_shorten(struct iov_iter *i, size_t count)
+{
+	return i->ops->ii_shorten(i, count);
+}
 
 extern struct iov_iter_ops ii_bvec_ops;
 
diff --git a/mm/iov-iter.c b/mm/iov-iter.c
index c5d0a9e..fcced89 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -201,6 +201,11 @@ static size_t ii_bvec_single_seg_count(struct iov_iter *i)
 		return min(i->count, bvec->bv_len - i->iov_offset);
 }
 
+static int ii_bvec_shorten(struct iov_iter *i, size_t count)
+{
+	return -EINVAL;
+}
+
 struct iov_iter_ops ii_bvec_ops = {
 	.ii_copy_to_user_atomic = ii_bvec_copy_to_user_atomic,
 	.ii_copy_to_user = ii_bvec_copy_to_user,
@@ -209,6 +214,7 @@ struct iov_iter_ops ii_bvec_ops = {
 	.ii_advance = ii_bvec_advance,
 	.ii_fault_in_readable = ii_bvec_fault_in_readable,
 	.ii_single_seg_count = ii_bvec_single_seg_count,
+	.ii_shorten = ii_bvec_shorten,
 };
 EXPORT_SYMBOL(ii_bvec_ops);
 
@@ -358,6 +364,13 @@ static size_t ii_iovec_single_seg_count(struct iov_iter *i)
 		return min(i->count, iov->iov_len - i->iov_offset);
 }
 
+static int ii_iovec_shorten(struct iov_iter *i, size_t count)
+{
+	struct iovec *iov = (struct iovec *)i->data;
+	i->nr_segs = iov_shorten(iov, i->nr_segs, count);
+	return 0;
+}
+
 struct iov_iter_ops ii_iovec_ops = {
 	.ii_copy_to_user_atomic = ii_iovec_copy_to_user_atomic,
 	.ii_copy_to_user = ii_iovec_copy_to_user,
@@ -366,5 +379,6 @@ struct iov_iter_ops ii_iovec_ops = {
 	.ii_advance = ii_iovec_advance,
 	.ii_fault_in_readable = ii_iovec_fault_in_readable,
 	.ii_single_seg_count = ii_iovec_single_seg_count,
+	.ii_shorten = ii_iovec_shorten,
 };
 EXPORT_SYMBOL(ii_iovec_ops);
-- 
1.8.0

