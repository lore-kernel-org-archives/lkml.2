Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3AIT7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:59:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33343 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab3AIT7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:59:35 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V5 07/30] iov_iter: add a shorten call
Date: Wed,  9 Jan 2013 13:58:22 -0600
Message-Id: <1357761525-22718-8-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
 fs/iov-iter.c      | 14 ++++++++++++++
 include/linux/fs.h |  5 +++++
 2 files changed, 19 insertions(+)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 22ef9ca..ac2d96e 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -202,6 +202,11 @@ static size_t ii_bvec_single_seg_count(struct iov_iter *i)
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
@@ -210,6 +215,7 @@ struct iov_iter_ops ii_bvec_ops = {
 	.ii_advance = ii_bvec_advance,
 	.ii_fault_in_readable = ii_bvec_fault_in_readable,
 	.ii_single_seg_count = ii_bvec_single_seg_count,
+	.ii_shorten = ii_bvec_shorten,
 };
 EXPORT_SYMBOL(ii_bvec_ops);
 #endif	/* CONFIG_BLOCK */
@@ -360,6 +366,13 @@ static size_t ii_iovec_single_seg_count(struct iov_iter *i)
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
@@ -368,5 +381,6 @@ struct iov_iter_ops ii_iovec_ops = {
 	.ii_advance = ii_iovec_advance,
 	.ii_fault_in_readable = ii_iovec_fault_in_readable,
 	.ii_single_seg_count = ii_iovec_single_seg_count,
+	.ii_shorten = ii_iovec_shorten,
 };
 EXPORT_SYMBOL(ii_iovec_ops);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 955d79e..cc4ed53 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -308,6 +308,7 @@ struct iov_iter_ops {
 	void (*ii_advance)(struct iov_iter *, size_t);
 	int (*ii_fault_in_readable)(struct iov_iter *, size_t);
 	size_t (*ii_single_seg_count)(struct iov_iter *);
+	int (*ii_shorten)(struct iov_iter *, size_t);
 };
 
 static inline size_t iov_iter_copy_to_user_atomic(struct page *page,
@@ -342,6 +343,10 @@ static inline size_t iov_iter_single_seg_count(struct iov_iter *i)
 {
 	return i->ops->ii_single_seg_count(i);
 }
+static inline int iov_iter_shorten(struct iov_iter *i, size_t count)
+{
+	return i->ops->ii_shorten(i, count);
+}
 
 #ifdef CONFIG_BLOCK
 extern struct iov_iter_ops ii_bvec_ops;
-- 
1.8.1

