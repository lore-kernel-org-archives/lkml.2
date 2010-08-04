Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab0HDC4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:56:17 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:29081 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758195Ab0HDCwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:52:13 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5hRaqJwVM1nRxx9HPPdEgQxEEBYCdtkhKvSbcskd_wp7Xta
 vzH.d.XtOJ4._3d9IAGzLzvBu.PQC9iP1uod9b6DddHuoigy3W.fseFZM9.v
 nmVi_m075u7O0SHY2r6IOR.NV8PfUp3FYNUm4r.bpJzD6kgROzhALOnRf1AV
 FA6bNPwUUqD3Dp8Zv29hGv5_GqUmLGU2gIHfo9q89jX6CvEP21sJFU4NgtBr
 qmDMV2Q5LZH167JYdZdaDhJgj.nYHxMVYENUPOJtdjQOPfVQanYAGGYlIeWT
 W3c7eT7QavEfq_fVA
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20100804024530.755052163@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 03 Aug 2010 21:45:26 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q3 12/23] slub: Extract hooks for memory checkers from hotpaths
References: <20100804024514.139976032@linux.com>
Content-Disposition: inline; filename=slub_extract
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the code that memory checkers and other verification tools use from
the hotpaths. Makes it easier to add new ones and reduces the disturbances
of the hotpaths.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   49 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 11 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-26 14:26:24.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-26 14:26:33.000000000 -0500
@@ -793,6 +793,37 @@ static void trace(struct kmem_cache *s, 
 }
 
 /*
+ * Hooks for other subsystems that check memory allocations. In a typical
+ * production configuration these hooks all should produce no code at all.
+ */
+static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
+{
+	lockdep_trace_alloc(flags);
+	might_sleep_if(flags & __GFP_WAIT);
+
+	return should_failslab(s->objsize, flags, s->flags);
+}
+
+static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, void *object)
+{
+	kmemcheck_slab_alloc(s, flags, object, s->objsize);
+	kmemleak_alloc_recursive(object, s->objsize, 1, s->flags, flags);
+}
+
+static inline void slab_free_hook(struct kmem_cache *s, void *x)
+{
+	kmemleak_free_recursive(x, s->flags);
+}
+
+static inline void slab_free_hook_irq(struct kmem_cache *s, void *object)
+{
+	kmemcheck_slab_free(s, object, s->objsize);
+	debug_check_no_locks_freed(object, s->objsize);
+	if (!(s->flags & SLAB_DEBUG_OBJECTS))
+		debug_check_no_obj_freed(object, s->objsize);
+}
+
+/*
  * Tracking of fully allocated slabs for debugging purposes.
  */
 static void add_full(struct kmem_cache_node *n, struct page *page)
@@ -1698,10 +1729,7 @@ static __always_inline void *slab_alloc(
 
 	gfpflags &= gfp_allowed_mask;
 
-	lockdep_trace_alloc(gfpflags);
-	might_sleep_if(gfpflags & __GFP_WAIT);
-
-	if (should_failslab(s->objsize, gfpflags, s->flags))
+	if (!slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
 	local_irq_save(flags);
@@ -1720,8 +1748,7 @@ static __always_inline void *slab_alloc(
 	if (unlikely(gfpflags & __GFP_ZERO) && object)
 		memset(object, 0, s->objsize);
 
-	kmemcheck_slab_alloc(s, gfpflags, object, s->objsize);
-	kmemleak_alloc_recursive(object, s->objsize, 1, s->flags, gfpflags);
+	slab_post_alloc_hook(s, gfpflags, object);
 
 	return object;
 }
@@ -1851,13 +1878,13 @@ static __always_inline void slab_free(st
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
-	kmemleak_free_recursive(x, s->flags);
+	slab_free_hook(s, x);
+
 	local_irq_save(flags);
 	c = __this_cpu_ptr(s->cpu_slab);
-	kmemcheck_slab_free(s, object, s->objsize);
-	debug_check_no_locks_freed(object, s->objsize);
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(object, s->objsize);
+
+	slab_free_hook_irq(s, x);
+
 	if (likely(page == c->page && c->node >= 0)) {
 		set_freepointer(s, object, c->freelist);
 		c->freelist = object;

