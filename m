Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934516Ab2C3Pt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:49:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:46933 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004Ab2C3Po3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:44:29 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 06/21] iov_iter: add a shorten call
Date: Fri, 30 Mar 2012 10:43:33 -0500
Message-Id: <1333122228-13633-7-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090207.4F75D4DD.0005,ss=1,re=0.000,fgs=0
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
 include/linux/fs.h |    5 +++++
 mm/iov-iter.c      |   14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 48de8ab..9895876 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -548,6 +548,7 @@ struct iov_iter_ops {
 	void (*ii_advance)(struct iov_iter *, size_t);
 	int (*ii_fault_in_readable)(struct iov_iter *, size_t);
 	size_t (*ii_single_seg_count)(struct iov_iter *);
+	int (*ii_shorten)(struct iov_iter *, size_t);
 };
 
 static inline size_t iov_iter_copy_to_user_atomic(struct page *page,
@@ -582,6 +583,10 @@ static inline size_t iov_iter_single_seg_count(struct iov_iter *i)
 {
 	return i->ops->ii_single_seg_count(i);
 }
+static inline int iov_iter_shorten(struct iov_iter *i, size_t count)
+{
+	return i->ops->ii_shorten(i, count);
+}
 
 extern struct iov_iter_ops ii_bvec_ops;
 
diff --git a/mm/iov-iter.c b/mm/iov-iter.c
index 5b35f23..361e00f 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -197,6 +197,11 @@ size_t ii_bvec_single_seg_count(struct iov_iter *i)
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
@@ -205,6 +210,7 @@ struct iov_iter_ops ii_bvec_ops = {
 	.ii_advance = ii_bvec_advance,
 	.ii_fault_in_readable = ii_bvec_fault_in_readable,
 	.ii_single_seg_count = ii_bvec_single_seg_count,
+	.ii_shorten = ii_bvec_shorten,
 };
 EXPORT_SYMBOL(ii_bvec_ops);
 
@@ -351,6 +357,13 @@ size_t ii_iovec_single_seg_count(struct iov_iter *i)
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
@@ -359,5 +372,6 @@ struct iov_iter_ops ii_iovec_ops = {
 	.ii_advance = ii_iovec_advance,
 	.ii_fault_in_readable = ii_iovec_fault_in_readable,
 	.ii_single_seg_count = ii_iovec_single_seg_count,
+	.ii_shorten = ii_iovec_shorten,
 };
 EXPORT_SYMBOL(ii_iovec_ops);
-- 
1.7.9.5

