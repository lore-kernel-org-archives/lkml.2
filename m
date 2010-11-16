Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab0KPOXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:23:49 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:2280 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755557Ab0KPOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:23:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiQJAKMh4kx5Ldur/2dsb2JhbACVYYx9cr5mhUsEiliFEA
Message-Id: <20101116142028.362270680@kernel.dk>
User-Agent: quilt/0.48-1
Date: Wed, 17 Nov 2010 01:09:02 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 02/28] kernel: kmem_ptr_validate considered harmful
References: <20101116140900.039761100@kernel.dk>
Content-Disposition: inline; filename=dcache-d_validate-broken.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a nasty ugly and error prone API. It's sole user, dcache, could not
get it right so there is roughly zero chance that anything else will.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

---
 include/linux/slab.h |    2 --
 mm/slab.c            |   32 +-------------------------------
 mm/slob.c            |    5 -----
 mm/slub.c            |   40 ----------------------------------------
 mm/util.c            |   21 ---------------------
 5 files changed, 1 insertion(+), 99 deletions(-)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2010-11-17 00:10:41.000000000 +1100
+++ linux-2.6/include/linux/slab.h	2010-11-17 00:11:49.000000000 +1100
@@ -106,8 +106,6 @@ int kmem_cache_shrink(struct kmem_cache
 void kmem_cache_free(struct kmem_cache *, void *);
 unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
-int kern_ptr_validate(const void *ptr, unsigned long size);
-int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
 /*
  * Please use this macro to create slab caches. Simply specify the
Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c	2010-11-17 00:10:41.000000000 +1100
+++ linux-2.6/mm/slab.c	2010-11-17 00:11:49.000000000 +1100
@@ -2781,7 +2781,7 @@ static void slab_put_obj(struct kmem_cac
 /*
  * Map pages beginning at addr to the given cache and slab. This is required
  * for the slab allocator to be able to lookup the cache and slab of a
- * virtual address for kfree, ksize, kmem_ptr_validate, and slab debugging.
+ * virtual address for kfree, ksize, and slab debugging.
  */
 static void slab_map_pages(struct kmem_cache *cache, struct slab *slab,
 			   void *addr)
@@ -3660,36 +3660,6 @@ void *kmem_cache_alloc_notrace(struct km
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
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-11-17 00:10:41.000000000 +1100
+++ linux-2.6/mm/slub.c	2010-11-17 00:24:15.000000000 +1100
@@ -1917,17 +1917,6 @@ void kmem_cache_free(struct kmem_cache *
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
@@ -2386,35 +2375,6 @@ static int kmem_cache_open(struct kmem_c
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
Index: linux-2.6/mm/util.c
===================================================================
--- linux-2.6.orig/mm/util.c	2010-11-17 00:10:41.000000000 +1100
+++ linux-2.6/mm/util.c	2010-11-17 00:11:49.000000000 +1100
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
Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c	2010-11-17 00:10:41.000000000 +1100
+++ linux-2.6/mm/slob.c	2010-11-17 00:11:49.000000000 +1100
@@ -678,11 +678,6 @@ int kmem_cache_shrink(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-int kmem_ptr_validate(struct kmem_cache *a, const void *b)
-{
-	return 0;
-}
-
 static unsigned int slob_ready __read_mostly;
 
 int slab_is_available(void)


