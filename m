Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab0GOPNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:13:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60007 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521Ab0GOPNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:13:00 -0400
Subject: [PATCH 3/3] kmemleak: Add DocBook style comments to kmemleak.c
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Thu, 15 Jul 2010 16:09:13 +0100
Message-ID: <20100715150913.21793.78106.stgit@e102109-lin.cambridge.arm.com>
In-Reply-To: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
References: <20100715150703.21793.94815.stgit@e102109-lin.cambridge.arm.com>
User-Agent: StGit/0.15-83-g972d5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2010 15:09:13.0377 (UTC) FILETIME=[AF53F910:01CB242F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The description and parameters of the kmemleak API weren't obvious. This
patch adds comments clarifying the API usage.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/kmemleak.c |   80 ++++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 59 insertions(+), 21 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index d33e990..5f2eb5b 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -843,10 +843,19 @@ out:
 	rcu_read_unlock();
 }
 
-/*
- * Memory allocation function callback. This function is called from the
- * kernel allocators when a new block is allocated (kmem_cache_alloc, kmalloc,
- * vmalloc etc.).
+/**
+ * kmemleak_alloc - register a newly allocated object
+ * @ptr:	pointer to beginning of the object
+ * @size:	size of the object
+ * @min_count:	minimum number of references to this object. If during memory
+ *		scanning a number of references less than @min_count is found,
+ *		the object is reported as a memory leak. If @min_count is 0,
+ *		the object is never reported as a leak. If @min_count is -1,
+ *		the object is ignored (not scanned and not reported as a leak)
+ * @gfp:	kmalloc() flags used for kmemleak internal memory allocations
+ *
+ * This function is called from the kernel allocators when a new object
+ * (memory block) is allocated (kmem_cache_alloc, kmalloc, vmalloc etc.).
  */
 void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 			  gfp_t gfp)
@@ -860,9 +869,12 @@ void __ref kmemleak_alloc(const void *ptr, size_t size, int min_count,
 }
 EXPORT_SYMBOL_GPL(kmemleak_alloc);
 
-/*
- * Memory freeing function callback. This function is called from the kernel
- * allocators when a block is freed (kmem_cache_free, kfree, vfree etc.).
+/**
+ * kmemleak_free - unregister a previously registered object
+ * @ptr:	pointer to beginning of the object
+ *
+ * This function is called from the kernel allocators when an object (memory
+ * block) is freed (kmem_cache_free, kfree, vfree etc.).
  */
 void __ref kmemleak_free(const void *ptr)
 {
@@ -875,9 +887,14 @@ void __ref kmemleak_free(const void *ptr)
 }
 EXPORT_SYMBOL_GPL(kmemleak_free);
 
-/*
- * Partial memory freeing function callback. This function is usually called
- * from bootmem allocator when (part of) a memory block is freed.
+/**
+ * kmemleak_free_part - partially unregister a previously registered object
+ * @ptr:	pointer to the beginning or inside the object. This also
+ *		represents the start of the range to be freed
+ * @size:	size to be unregistered
+ *
+ * This function is called when only a part of a memory block is freed
+ * (usually from the bootmem allocator).
  */
 void __ref kmemleak_free_part(const void *ptr, size_t size)
 {
@@ -890,9 +907,12 @@ void __ref kmemleak_free_part(const void *ptr, size_t size)
 }
 EXPORT_SYMBOL_GPL(kmemleak_free_part);
 
-/*
- * Mark an already allocated memory block as a false positive. This will cause
- * the block to no longer be reported as leak and always be scanned.
+/**
+ * kmemleak_not_leak - mark an allocated object as false positive
+ * @ptr:	pointer to beginning of the object
+ *
+ * Calling this function on an object will cause the memory block to no longer
+ * be reported as leak and always be scanned.
  */
 void __ref kmemleak_not_leak(const void *ptr)
 {
@@ -905,10 +925,14 @@ void __ref kmemleak_not_leak(const void *ptr)
 }
 EXPORT_SYMBOL(kmemleak_not_leak);
 
-/*
- * Ignore a memory block. This is usually done when it is known that the
- * corresponding block is not a leak and does not contain any references to
- * other allocated memory blocks.
+/**
+ * kmemleak_ignore - ignore an allocated object
+ * @ptr:	pointer to beginning of the object
+ *
+ * Calling this function on an object will cause the memory block to be
+ * ignored (not scanned and not reported as a leak). This is usually done when
+ * it is known that the corresponding block is not a leak and does not contain
+ * any references to other allocated memory blocks.
  */
 void __ref kmemleak_ignore(const void *ptr)
 {
@@ -921,8 +945,16 @@ void __ref kmemleak_ignore(const void *ptr)
 }
 EXPORT_SYMBOL(kmemleak_ignore);
 
-/*
- * Limit the range to be scanned in an allocated memory block.
+/**
+ * kmemleak_scan_area - limit the range to be scanned in an allocated object
+ * @ptr:	pointer to beginning or inside the object. This also
+ *		represents the start of the scan area
+ * @size:	size of the scan area
+ * @gfp:	kmalloc() flags used for kmemleak internal memory allocations
+ *
+ * This function is used when it is known that only certain parts of an object
+ * contain references to other objects. Kmemleak will only scan these areas
+ * reducing the number false negatives.
  */
 void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 {
@@ -935,8 +967,14 @@ void __ref kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp)
 }
 EXPORT_SYMBOL(kmemleak_scan_area);
 
-/*
- * Inform kmemleak not to scan the given memory block.
+/**
+ * kmemleak_no_scan - do not scan an allocated object
+ * @ptr:	pointer to beginning of the object
+ *
+ * This function notifies kmemleak not to scan the given memory block. Useful
+ * in situations where it is known that the given object does not contain any
+ * references to other objects. Kmemleak will not scan such objects reducing
+ * the number of false negatives.
  */
 void __ref kmemleak_no_scan(const void *ptr)
 {

