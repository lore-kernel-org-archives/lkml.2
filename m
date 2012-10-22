Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2JVPQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:16:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23113 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2JVPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:15:58 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH 04/22] fuse: convert fuse to use iov_iter_copy_[to|from]_user
Date: Mon, 22 Oct 2012 10:15:04 -0500
Message-Id: <1350918922-6096-5-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future patch hides the internals of struct iov_iter, so fuse should
be using the supported interface.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: fuse-devel@lists.sourceforge.net
---
 fs/fuse/file.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 78d2837..4e42e95 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1631,30 +1631,17 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 	while (iov_iter_count(&ii)) {
 		struct page *page = pages[page_idx++];
 		size_t todo = min_t(size_t, PAGE_SIZE, iov_iter_count(&ii));
-		void *kaddr;
+		size_t left;
 
-		kaddr = kmap(page);
-
-		while (todo) {
-			char __user *uaddr = ii.iov->iov_base + ii.iov_offset;
-			size_t iov_len = ii.iov->iov_len - ii.iov_offset;
-			size_t copy = min(todo, iov_len);
-			size_t left;
-
-			if (!to_user)
-				left = copy_from_user(kaddr, uaddr, copy);
-			else
-				left = copy_to_user(uaddr, kaddr, copy);
-
-			if (unlikely(left))
-				return -EFAULT;
+		if (!to_user)
+			left = iov_iter_copy_from_user(page, &ii, 0, todo);
+		else
+			left = iov_iter_copy_to_user(page, &ii, 0, todo);
 
-			iov_iter_advance(&ii, copy);
-			todo -= copy;
-			kaddr += copy;
-		}
+		if (unlikely(left))
+			return -EFAULT;
 
-		kunmap(page);
+		iov_iter_advance(&ii, todo);
 	}
 
 	return 0;
-- 
1.7.12.3

