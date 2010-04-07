Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab0DGQ3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:29:55 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:51682 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695Ab0DGQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:29:54 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 12:29:54 EDT
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH 1/2] slab: Generify kernel pointer validation
Date: Wed,  7 Apr 2010 19:23:40 +0300
Message-Id: <1270657421-1937-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Linus, introduce a kern_ptr_validate() helper that does some
sanity checks to make sure a pointer is a valid kernel pointer.  This is a
preparational step for fixing SLUB kmem_ptr_validate().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/slab.h |    1 +
 mm/slab.c            |   13 +------------
 mm/util.c            |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 4884462..49d1247 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -106,6 +106,7 @@ int kmem_cache_shrink(struct kmem_cache *);
 void kmem_cache_free(struct kmem_cache *, void *);
 unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
+int kern_ptr_validate(const void *ptr, unsigned long size);
 int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
 /*
diff --git a/mm/slab.c b/mm/slab.c
index a9f325b..bac0f4f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3602,21 +3602,10 @@ EXPORT_SYMBOL(kmem_cache_alloc_notrace);
  */
 int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr)
 {
-	unsigned long addr = (unsigned long)ptr;
-	unsigned long min_addr = PAGE_OFFSET;
-	unsigned long align_mask = BYTES_PER_WORD - 1;
 	unsigned long size = cachep->buffer_size;
 	struct page *page;
 
-	if (unlikely(addr < min_addr))
-		goto out;
-	if (unlikely(addr > (unsigned long)high_memory - size))
-		goto out;
-	if (unlikely(addr & align_mask))
-		goto out;
-	if (unlikely(!kern_addr_valid(addr)))
-		goto out;
-	if (unlikely(!kern_addr_valid(addr + size - 1)))
+	if (unlikely(!kern_ptr_validate(ptr, size)))
 		goto out;
 	page = virt_to_page(ptr);
 	if (unlikely(!PageSlab(page)))
diff --git a/mm/util.c b/mm/util.c
index 834db7b..f5712e8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -186,6 +186,27 @@ void kzfree(const void *p)
 }
 EXPORT_SYMBOL(kzfree);
 
+int kern_ptr_validate(const void *ptr, unsigned long size)
+{
+	unsigned long addr = (unsigned long)ptr;
+	unsigned long min_addr = PAGE_OFFSET;
+	unsigned long align_mask = sizeof(void *) - 1;
+
+	if (unlikely(addr < min_addr))
+		goto out;
+	if (unlikely(addr > (unsigned long)high_memory - size))
+		goto out;
+	if (unlikely(addr & align_mask))
+		goto out;
+	if (unlikely(!kern_addr_valid(addr)))
+		goto out;
+	if (unlikely(!kern_addr_valid(addr + size - 1)))
+		goto out;
+	return 1;
+out:
+	return 0;
+}
+
 /*
  * strndup_user - duplicate an existing string from user space
  * @s: The string to duplicate
-- 
1.6.3.3

