Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2JVPUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:20:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23009 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2JVPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:15:46 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 08/22] iov_iter: let callers extract iovecs and bio_vecs
Date: Mon, 22 Oct 2012 10:15:08 -0500
Message-Id: <1350918922-6096-9-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
index 1a986ed..6ece092 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -297,6 +297,17 @@ static inline void iov_iter_init_bvec(struct iov_iter *i,
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
@@ -312,8 +323,14 @@ static inline void iov_iter_init(struct iov_iter *i,
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
1.7.12.3

