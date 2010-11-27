Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0K0K0D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:26:03 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab0K0KZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:25:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAO1p8Ex5Lcx2/2dsb2JhbACjC3K9doVHBIphhRQ
Message-Id: <4e69b1fc6fab023f2c8194e3cd033ecf03aa7a7a.1290852958.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:33 +1100
Subject: [PATCH 03/46] kernel: kmem_ptr_validate considered harmful
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a nasty and error prone API. It is no longer used, remove it.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 include/linux/slab.h |    2 --
 mm/slab.c            |   32 +-------------------------------
 mm/slob.c            |    5 -----
 mm/slub.c            |   40 ----------------------------------------
 mm/util.c            |   21 ---------------------
 5 files changed, 1 insertions(+), 99 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 59260e2..fa90866 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -106,8 +106,6 @@ int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
 unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
-int kern_ptr_validate(const void *ptr, unsigned long size);
-int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
diff --git a/mm/slab.c b/mm/slab.c
index b1e40da..6107f23 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2781,7 +2781,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct slab *slabp,
 /*
  * Map pages beginning at addr to the given cache and slab. This is required
  * for the slab allocator to be able to lookup the cache and slab of a
- * virtual address for kfree, ksize, kmem_ptr_validate, and slab debugging.
+ * virtual address for kfree, ksize, and slab debugging.
  */
 static void slab_map_pages(struct kmem_cache *cache, struct slab *slab,
 			   void *addr)
@@ -3660,36 +3660,6 @@ void *kmem_cache_alloc_notrace(struct kmem_cache *cachep, gfp_t flags)
 EXPORT_SYMBOL(kmem_cache_alloc_notrace);
 #endif
 
-/**
- * kmem_ptr_validate - check if an untrusted pointer might be a slab entry.
- * @cachep: the cache we're checking against
- * @ptr: pointer to validate
- *
- * This verifies that the untrusted pointer looks sane;
- * it is _not_ a guarantee that the pointer is actually
- * part of the slab cache in question, but it at least
- * validates that the pointer can be dereferenced and
- * looks half-way sane.
- *
- * Currently only used for dentry validation.
- */
-int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr)
-{
-	unsigned long size = cachep->buffer_size;
-	struct page *page;
-
-	if (unlikely(!kern_ptr_validate(ptr, size)))
-		goto out;
-	page = virt_to_page(ptr);
-	if (unlikely(!PageSlab(page)))
-		goto out;
-	if (unlikely(page_get_cache(page) != cachep))
-		goto out;
-	return 1;
-out:
-	return 0;
-}
-
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid)
 {
diff --git a/mm/slob.c b/mm/slob.c
index 617b6d6..3588eaa 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -678,11 +678,6 @@ int kmem_cache_shrink(struct kmem_cache *d)
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-int kmem_ptr_validate(struct kmem_cache *a, const void *b)
-{
-	return 0;
-}
-
 static unsigned int slob_ready __read_mostly;
 
 int slab_is_available(void)
diff --git a/mm/slub.c b/mm/slub.c
index 981fb73..5ed0941 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1917,17 +1917,6 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
-/* Figure out on which slab page the object resides */
-static struct page *get_object_page(const void *x)
-{
-	struct page *page = virt_to_head_page(x);
-
-	if (!PageSlab(page))
-		return NULL;
-
-	return page;
-}
-
 /*
  * Object placement in a slab is made very easy because we always start at
  * offset 0. If we tune the size of the object to the alignment then we can
@@ -2386,35 +2375,6 @@ error:
 }
 
 /*
- * Check if a given pointer is valid
- */
-int kmem_ptr_validate(struct kmem_cache *s, const void *object)
-{
-	struct page *page;
-
-	if (!kern_ptr_validate(object, s->size))
-		return 0;
-
-	page = get_object_page(object);
-
-	if (!page || s != page->slab)
-		/* No slab or wrong slab */
-		return 0;
-
-	if (!check_valid_pointer(s, page, object))
-		return 0;
-
-	/*
-	 * We could also check if the object is on the slabs freelist.
-	 * But this would be too expensive and it seems that the main
-	 * purpose of kmem_ptr_valid() is to check if the object belongs
-	 * to a certain slab.
-	 */
-	return 1;
-}
-EXPORT_SYMBOL(kmem_ptr_validate);
-
-/*
  * Determine the size of a slab object
  */
 unsigned int kmem_cache_size(struct kmem_cache *s)
diff --git a/mm/util.c b/mm/util.c
index 73dac81..f126975 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -186,27 +186,6 @@ void kzfree(const void *p)
 }
 EXPORT_SYMBOL(kzfree);
 
-int kern_ptr_validate(const void *ptr, unsigned long size)
-{
-	unsigned long addr = (unsigned long)ptr;
-	unsigned long min_addr = PAGE_OFFSET;
-	unsigned long align_mask = sizeof(void *) - 1;
-
-	if (unlikely(addr < min_addr))
-		goto out;
-	if (unlikely(addr > (unsigned long)high_memory - size))
-		goto out;
-	if (unlikely(addr & align_mask))
-		goto out;
-	if (unlikely(!kern_addr_valid(addr)))
-		goto out;
-	if (unlikely(!kern_addr_valid(addr + size - 1)))
-		goto out;
-	return 1;
-out:
-	return 0;
-}
-
 /*
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate
-- 
1.7.1

