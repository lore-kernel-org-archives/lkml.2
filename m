Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0GITPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:15:10 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34333 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0GITMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:21 -0400
Message-Id: <20100709190857.912752982@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:20 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 14/19] slub: Move gfpflag masking out of the hotpath
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=slub_move_gfpflags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the gfpflags masking into the hooks for checkers and into the slowpaths.
gfpflag masking requires access to a global variable and thus adds an
additional cacheline reference to the hotpaths.

If no hooks are active then the gfpflag masking will result in
code that the compiler can toss out.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-07 10:38:17.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-07 10:38:22.000000000 -0500
@@ -798,6 +798,7 @@ static void trace(struct kmem_cache *s, 
  */
 static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 {
+	flags &= gfp_allowed_mask;
 	lockdep_trace_alloc(flags);
 	might_sleep_if(flags & __GFP_WAIT);
 
@@ -806,6 +807,7 @@ static inline int slab_pre_alloc_hook(st
 
 static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, void *object)
 {
+	flags &= gfp_allowed_mask;
 	kmemcheck_slab_alloc(s, flags, object, s->objsize);
 	kmemleak_alloc_recursive(object, s->objsize, 1, s->flags, flags);
 }
@@ -1648,6 +1650,7 @@ static void *__slab_alloc(struct kmem_ca
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
+	gfpflags &= gfp_allowed_mask;
 
 	if (!c->page)
 		goto new_slab;
@@ -1733,8 +1736,6 @@ static __always_inline void *slab_alloc(
 	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
-	gfpflags &= gfp_allowed_mask;
-
 	if (!slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 

