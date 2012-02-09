Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2BIMlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:41:50 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:64816 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab2BIMlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:41:45 -0500
Message-ID: <4F33BF05.208@gmail.com>
Date: Thu, 09 Feb 2012 07:41:41 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jens Axboe <axboe@kernel.dk>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] slab: introduce knalloc/kxnalloc
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org>
In-Reply-To: <20120208142513.4db2493a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces knalloc/kxnalloc wrappers that perform integer
overflow checks without zeroing the memory.

knalloc(n, size, flags) is the non-zeroing version of kcalloc(),
which allocates n * size bytes.

kxnalloc(xsize, n, size, flags) allocates xsize + n * size bytes.
It is useful to allocate a structure ending with a zero-length array,
which is a commonly used pattern.  For example, in posix_acl_alloc()
to allocate a posix_acl object one could call

    kxnalloc(sizeof(struct posix_acl),
             count, sizeof(struct posix_acl_entry), flags);

to avoid overflowing the allocation size.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
I coined the name knalloc() for Andrew's wtf_do_i_call_this() in the
previous email.  A better name is welcome.

I additionally added kxnalloc() since it's a common idiom.
---
 include/linux/slab.h |   31 +++++++++++++++++++++++++++----
 1 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 573c809..e3a1e81 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -190,7 +190,8 @@ size_t ksize(const void *);
 #endif
 
 /**
- * kcalloc - allocate memory for an array. The memory is set to zero.
+ * kxnalloc - allocate memory for an array with an extra header.
+ * @xsize: extra header size.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate.
@@ -240,11 +241,33 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *kxnalloc(size_t xsize, size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > ULONG_MAX / size)
+	if (size != 0 && n > (ULONG_MAX - xsize) / size)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+	return __kmalloc(xsize + n * size, flags);
+}
+
+/**
+ * knalloc - allocate memory for an array.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *knalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kxnalloc(0, n, size, flags);
+}
+
+/**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return knalloc(n, size, flags | __GFP_ZERO);
 }
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
-- 
1.7.5.4

