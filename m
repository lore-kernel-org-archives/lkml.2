Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2JVPS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:18:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23151 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2JVPQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:16:01 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 02/22] iov_iter: iov_iter_copy_from_user() should use non-atomic copy
Date: Mon, 22 Oct 2012 10:15:02 -0500
Message-Id: <1350918922-6096-3-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
References: <1350918922-6096-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 mm/iov-iter.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/mm/iov-iter.c b/mm/iov-iter.c
index 83f7594..5c4f3a5 100644
--- a/mm/iov-iter.c
+++ b/mm/iov-iter.c
@@ -6,8 +6,8 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 
-static size_t __iovec_copy_from_user_inatomic(char *vaddr,
-			const struct iovec *iov, size_t base, size_t bytes)
+static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
+				     size_t base, size_t bytes, int atomic)
 {
 	size_t copied = 0, left = 0;
 
@@ -16,7 +16,10 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 		int copy = min(bytes, iov->iov_len - base);
 
 		base = 0;
-		left = __copy_from_user_inatomic(vaddr, buf, copy);
+		if (atomic)
+			left = __copy_from_user_inatomic(vaddr, buf, copy);
+		else
+			left = __copy_from_user(vaddr, buf, copy);
 		copied += copy;
 		bytes -= copy;
 		vaddr += copy;
@@ -47,8 +50,8 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+		copied = __iovec_copy_from_user(kaddr + offset, i->iov,
+						i->iov_offset, bytes, 1);
 	}
 	kunmap_atomic(kaddr);
 
@@ -75,8 +78,8 @@ size_t iov_iter_copy_from_user(struct page *page,
 		left = __copy_from_user(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+		copied = __iovec_copy_from_user(kaddr + offset, i->iov,
+						i->iov_offset, bytes, 0);
 	}
 	kunmap(page);
 	return copied;
-- 
1.7.12.3

