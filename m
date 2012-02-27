Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2B0VX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:23:29 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33622 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab2B0VUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:20:24 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH 07/22] iov_iter: let callers extract iovecs and bio_vecs
Date: Mon, 27 Feb 2012 15:19:21 -0600
Message-Id: <1330377576-3659-8-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4F4BF398.0075,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

direct IO treats memory from user iovecs and memory from arrays of
kernel pages very differently.  User memory is pinned and worked with in
batches while kernel pages are always pinned and don't require
additional processing.

Rather than try and provide an absctraction that includes these
different behaviours we let direct IO extract the memory structs and
hand them to the existing code.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 101afc1..4750933 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -604,6 +604,15 @@ static inline void iov_iter_init_bvec(struct iov_iter *i,
 
 	iov_iter_advance(i, written);
 }
+static inline int iov_iter_has_bvec(struct iov_iter *i)
+{
+	return i->ops == &ii_bvec_ops;
+}
+static inline struct bio_vec *iov_iter_bvec(struct iov_iter *i)
+{
+	BUG_ON(!iov_iter_has_bvec(i));
+	return (struct bio_vec *)i->data;
+}
 
 extern struct iov_iter_ops ii_iovec_ops;
 
@@ -619,6 +628,15 @@ static inline void iov_iter_init(struct iov_iter *i,
 
 	iov_iter_advance(i, written);
 }
+static inline int iov_iter_has_iovec(struct iov_iter *i)
+{
+	return i->ops == &ii_iovec_ops;
+}
+static inline struct iovec *iov_iter_iovec(struct iov_iter *i)
+{
+	BUG_ON(!iov_iter_has_iovec(i));
+	return (struct iovec *)i->data;
+}
 
 static inline size_t iov_iter_count(struct iov_iter *i)
 {
-- 
1.7.9.2

