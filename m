Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2IHUuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:50:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37179 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab2IHUuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:50:05 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 03/10] mm, slab: Remove silly function slab_buffer_size()
Date: Sat,  8 Sep 2012 17:47:52 -0300
Message-Id: <1347137279-17568-3-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is seldom used, and can be simply replaced with cachep->size.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 include/linux/slab_def.h |    5 -----
 mm/slab.c                |   12 ++----------
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 36d7031..604ebc8 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -113,17 +113,12 @@ void *__kmalloc(size_t size, gfp_t flags);
 #ifdef CONFIG_TRACING
 extern void *kmem_cache_alloc_trace(size_t size,
 				    struct kmem_cache *cachep, gfp_t flags);
-extern size_t slab_buffer_size(struct kmem_cache *cachep);
 #else
 static __always_inline void *
 kmem_cache_alloc_trace(size_t size, struct kmem_cache *cachep, gfp_t flags)
 {
 	return kmem_cache_alloc(cachep, flags);
 }
-static inline size_t slab_buffer_size(struct kmem_cache *cachep)
-{
-	return 0;
-}
 #endif
 
 static __always_inline void *kmalloc(size_t size, gfp_t flags)
diff --git a/mm/slab.c b/mm/slab.c
index 3b4587b..53e41de 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -498,14 +498,6 @@ static void **dbg_userword(struct kmem_cache *cachep, void *objp)
 
 #endif
 
-#ifdef CONFIG_TRACING
-size_t slab_buffer_size(struct kmem_cache *cachep)
-{
-	return cachep->size;
-}
-EXPORT_SYMBOL(slab_buffer_size);
-#endif
-
 /*
  * Do not go above this order unless 0 objects fit into the slab or
  * overridden on the command line.
@@ -3849,7 +3841,7 @@ kmem_cache_alloc_trace(size_t size, struct kmem_cache *cachep, gfp_t flags)
 	ret = __cache_alloc(cachep, flags, __builtin_return_address(0));
 
 	trace_kmalloc(_RET_IP_, ret,
-		      size, slab_buffer_size(cachep), flags);
+		      size, cachep->size, flags);
 	return ret;
 }
 EXPORT_SYMBOL(kmem_cache_alloc_trace);
@@ -3880,7 +3872,7 @@ void *kmem_cache_alloc_node_trace(size_t size,
 	ret = __cache_alloc_node(cachep, flags, nodeid,
 				  __builtin_return_address(0));
 	trace_kmalloc_node(_RET_IP_, ret,
-			   size, slab_buffer_size(cachep),
+			   size, cachep->size,
 			   flags, nodeid);
 	return ret;
 }
-- 
1.7.8.6

