Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3AIUHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:07:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23475 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab3AIT7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:59:06 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V5 08/30] iov_iter: let callers extract iovecs and bio_vecs
Date: Wed,  9 Jan 2013 13:58:23 -0600
Message-Id: <1357761525-22718-9-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
index cc4ed53..eb564d1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -365,6 +365,17 @@ static inline void iov_iter_init_bvec(struct iov_iter *i,
 
 	iov_iter_advance(i, written);
 }
+
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
 #endif
 
 extern struct iov_iter_ops ii_iovec_ops;
@@ -382,8 +393,14 @@ static inline void iov_iter_init(struct iov_iter *i,
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
1.8.1

