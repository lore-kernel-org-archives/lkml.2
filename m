Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1FBHSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:18:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:9407 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab1FBHS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:18:29 -0400
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: penberg@kernel.org
Cc: suleiman@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cl@linux-foundation.org, mpm@selenic.com,
        Suleiman Souhlal <ssouhlal@FreeBSD.org>
Subject: [PATCH] SLAB: Record actual last user of freed objects.
Date: Thu,  2 Jun 2011 00:16:42 -0700
Message-Id: <1306999002-29738-1-git-send-email-ssouhlal@FreeBSD.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when using CONFIG_DEBUG_SLAB, we put in kfree() or
kmem_cache_free() as the last user of free objects, which is not
very useful, so change it to the caller of those functions instead.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 mm/slab.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 98f114d..615e76c 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3603,13 +3603,14 @@ free_done:
  * Release an obj back to its cache. If the obj has a constructed state, it must
  * be in this state _before_ it is released.  Called with disabled ints.
  */
-static inline void __cache_free(struct kmem_cache *cachep, void *objp)
+static inline void __cache_free(struct kmem_cache *cachep, void *objp,
+    void *caller)
 {
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
 	kmemleak_free_recursive(objp, cachep->flags);
-	objp = cache_free_debugcheck(cachep, objp, __builtin_return_address(0));
+	objp = cache_free_debugcheck(cachep, objp, caller);
 
 	kmemcheck_slab_free(cachep, objp, obj_size(cachep));
 
@@ -3800,7 +3801,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 	debug_check_no_locks_freed(objp, obj_size(cachep));
 	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(objp, obj_size(cachep));
-	__cache_free(cachep, objp);
+	__cache_free(cachep, objp, __builtin_return_address(0));
 	local_irq_restore(flags);
 
 	trace_kmem_cache_free(_RET_IP_, objp);
@@ -3830,7 +3831,7 @@ void kfree(const void *objp)
 	c = virt_to_cache(objp);
 	debug_check_no_locks_freed(objp, obj_size(c));
 	debug_check_no_obj_freed(objp, obj_size(c));
-	__cache_free(c, (void *)objp);
+	__cache_free(c, (void *)objp, __builtin_return_address(0));
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(kfree);
-- 
1.7.3.1

