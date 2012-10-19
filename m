Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab2JSMf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:35:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44270 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2JSMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:35:27 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH v2 3/3] mm/sl[aou]b: Move common kmem_cache_size() to slab.h
Date: Fri, 19 Oct 2012 09:33:12 -0300
Message-Id: <1350649992-25988-3-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1350649992-25988-1-git-send-email-elezegarcia@gmail.com>
References: <1350649992-25988-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is identically defined in all three allocators
and it's trivial to move it to slab.h

Since now it's static, inline, header-defined function
this patch also drops the EXPORT_SYMBOL tag.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Changes from v1:
 * Declare kmem_cache_size() static inline

 include/linux/slab.h |    9 ++++++++-
 mm/slab.c            |    6 ------
 mm/slob.c            |    6 ------
 mm/slub.c            |    9 ---------
 4 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 83d1a14..743a104 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -128,7 +128,6 @@ struct kmem_cache *kmem_cache_create(const char *, size_t, size_t,
 void kmem_cache_destroy(struct kmem_cache *);
 int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
-unsigned int kmem_cache_size(struct kmem_cache *);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
@@ -388,6 +387,14 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
+/*
+ * Determine the size of a slab object
+ */
+static inline unsigned int kmem_cache_size(struct kmem_cache *s)
+{
+	return s->object_size;
+}
+
 void __init kmem_cache_init_late(void);
 
 #endif	/* _LINUX_SLAB_H */
diff --git a/mm/slab.c b/mm/slab.c
index 87c55b0..92a3fec 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3969,12 +3969,6 @@ void kfree(const void *objp)
 }
 EXPORT_SYMBOL(kfree);
 
-unsigned int kmem_cache_size(struct kmem_cache *cachep)
-{
-	return cachep->object_size;
-}
-EXPORT_SYMBOL(kmem_cache_size);
-
 /*
  * This initializes kmem_list3 or resizes various caches for all nodes.
  */
diff --git a/mm/slob.c b/mm/slob.c
index 287a88a..fffbc82 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -604,12 +604,6 @@ void kmem_cache_free(struct kmem_cache *c, void *b)
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-unsigned int kmem_cache_size(struct kmem_cache *c)
-{
-	return c->object_size;
-}
-EXPORT_SYMBOL(kmem_cache_size);
-
 int __kmem_cache_shutdown(struct kmem_cache *c)
 {
 	/* No way to check for remaining objects */
diff --git a/mm/slub.c b/mm/slub.c
index a0d6984..1f826b0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3127,15 +3127,6 @@ error:
 	return -EINVAL;
 }
 
-/*
- * Determine the size of a slab object
- */
-unsigned int kmem_cache_size(struct kmem_cache *s)
-{
-	return s->object_size;
-}
-EXPORT_SYMBOL(kmem_cache_size);
-
 static void list_slab_objects(struct kmem_cache *s, struct page *page,
 							const char *text)
 {
-- 
1.7.8.6

