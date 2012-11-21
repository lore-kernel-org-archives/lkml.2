Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab2KVSsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:48:32 -0500
Received: from userp1050.oracle.com ([156.151.31.82]:18897 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2KVSs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:48:29 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH v4 08/31] iov_iter: let callers extract iovecs and bio_vecs
Date: Wed, 21 Nov 2012 16:40:48 -0600
Message-Id: <1353537671-26284-9-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
References: <1353537671-26284-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

direct IO treats memory from user iovecs and memory from arrays of
kernel pages very differently.  User memory is pinned and worked with in
batches while kernel pages are always pinned and don't require
additional processing.

Rather than try and provide an abstraction that includes these
different behaviours we let direct IO extract the memory structs and
hand them to the existing code.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 include/linux/fs.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b2f558..6f26f11 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -364,6 +364,17 @@ static inline void iov_iter_init_bvec(struct iov_iter *i,
 	iov_iter_advance(i, written);
 }
 
+static inline int iov_iter_has_bvec(struct iov_iter *i)
+{
+	return i->ops == &ii_bvec_ops;
+}
+
+static inline struct bio_vec *iov_iter_bvec(struct iov_iter *i)
+{
+	BUG_ON(!iov_iter_has_bvec(i));
+	return (struct bio_vec *)i->data;
+}
+
 extern struct iov_iter_ops ii_iovec_ops;
 
 static inline void iov_iter_init(struct iov_iter *i,
@@ -379,8 +390,14 @@ static inline void iov_iter_init(struct iov_iter *i,
 	iov_iter_advance(i, written);
 }
 
+static inline int iov_iter_has_iovec(struct iov_iter *i)
+{
+	return i->ops == &ii_iovec_ops;
+}
+
 static inline struct iovec *iov_iter_iovec(struct iov_iter *i)
 {
+	BUG_ON(!iov_iter_has_iovec(i));
 	return (struct iovec *)i->data;
 }
 
-- 
1.8.0

