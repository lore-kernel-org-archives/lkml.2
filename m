Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2IHUva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:51:30 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49904 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2IHUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:50:07 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 04/10] mm, slob: Add support for kmalloc_track_caller()
Date: Sat,  8 Sep 2012 17:47:53 -0300
Message-Id: <1347137279-17568-4-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently slob falls back to regular kmalloc for this case.
With this patch kmalloc_track_caller() is correctly implemented,
thus tracing the specified caller.

This is important to trace accurately allocations performed by
krealloc, kstrdup, kmemdup, etc.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 include/linux/slab.h |    6 ++++--
 mm/slob.c            |   27 ++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 0dd2dfa..83d1a14 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -321,7 +321,8 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
  * request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || \
-	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING))
+	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING)) || \
+	(defined(CONFIG_SLOB) && defined(CONFIG_TRACING))
 extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
@@ -340,7 +341,8 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
  * allocation request comes from.
  */
 #if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || \
-	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING))
+	(defined(CONFIG_SLAB) && defined(CONFIG_TRACING)) || \
+	(defined(CONFIG_SLOB) && defined(CONFIG_TRACING))
 extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
diff --git a/mm/slob.c b/mm/slob.c
index c0c1a93..984c42a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -424,7 +424,8 @@ out:
  * End of slob allocator proper. Begin kmem_cache_alloc and kmalloc frontend.
  */
 
-void *__kmalloc_node(size_t size, gfp_t gfp, int node)
+static __always_inline void *
+__do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 {
 	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
@@ -445,7 +446,7 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 		*m = size;
 		ret = (void *)m + align;
 
-		trace_kmalloc_node(_RET_IP_, ret,
+		trace_kmalloc_node(caller, ret,
 				   size, size + align, gfp, node);
 	} else {
 		unsigned int order = get_order(size);
@@ -454,15 +455,35 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			gfp |= __GFP_COMP;
 		ret = slob_new_pages(gfp, order, node);
 
-		trace_kmalloc_node(_RET_IP_, ret,
+		trace_kmalloc_node(caller, ret,
 				   size, PAGE_SIZE << order, gfp, node);
 	}
 
 	kmemleak_alloc(ret, size, 1, gfp);
 	return ret;
 }
+
+void *__kmalloc_node(size_t size, gfp_t gfp, int node)
+{
+	return __do_kmalloc_node(size, gfp, node, _RET_IP_);
+}
 EXPORT_SYMBOL(__kmalloc_node);
 
+#ifdef CONFIG_TRACING
+void *__kmalloc_track_caller(size_t size, gfp_t gfp, unsigned long caller)
+{
+	return __do_kmalloc_node(size, gfp, NUMA_NO_NODE, caller);
+}
+
+#ifdef CONFIG_NUMA
+void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
+					int node, unsigned long caller)
+{
+	return __do_kmalloc_node(size, gfp, node, caller);
+}
+#endif
+#endif
+
 void kfree(const void *block)
 {
 	struct page *sp;
-- 
1.7.8.6

