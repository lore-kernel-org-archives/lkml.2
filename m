Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab2BINsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 08:48:40 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:49517 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab2BINsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 08:48:39 -0500
Message-ID: <4F33CEAE.60400@gmail.com>
Date: Thu, 09 Feb 2012 08:48:30 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH RFC v2] slab: introduce kmalloc_array
References: <20120207141155.GA16184@elgon.mountain> <4F323388.7040902@kernel.dk> <20120208142513.4db2493a.akpm@linux-foundation.org> <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
In-Reply-To: <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a kmalloc_array() wrapper that performs integer
overflow checking without zeroing the memory.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
Let's take "kxnalloc" off for now and keep the patch simple.
---
 include/linux/slab.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 573c809..a595dce 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -190,7 +190,7 @@ size_t ksize(const void *);
 #endif
 
 /**
- * kcalloc - allocate memory for an array. The memory is set to zero.
+ * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate.
@@ -240,11 +240,22 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	if (size != 0 && n > ULONG_MAX / size)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+	return __kmalloc(n * size, flags);
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
+	return kmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
-- 
1.7.5.4

