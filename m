Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0LNRtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:49:08 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:38808 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759789Ab0LNRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:49:03 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: a8qMnMQVM1lqopRw.LpBkKXIicXywiGTHy1f0rw9f3W0AEf
 FbNq.4Uq_aDyUzhuUK_mfV5i.lbIJE63WXZdxYTJpYcOGzgxR8Zn0MBf4acs
 Afuo3qq8HdRlFOQySE.4rzCIi0d_5w.BoSoF0aQgyCuRwic8HXll1p6pM0yK
 l0iWIIhnRa3nawkjtr9Ly658RqOqBMYyFMIA2GQb8jYkZ.u025nid_zWmHLO
 u1rsPjDpaxI9u0aX_X.IsIomJq8IO64fsQebw9pZvxuTgRnnSd9QPJv1rnT6
 z2XqoHGd2_tmUh5A2PVVk8.OE5djEH6yEKvAWiibBtam8hJQ-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20101214174901.240711925@linux.com>
User-Agent: quilt/0.48-1
Date: Tue, 14 Dec 2010 11:48:50 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V1 3/4] slub: Get rid of slab_free_hook_irq()
References: <20101214174847.887713690@linux.com>
Content-Disposition: inline; filename=slub_remove_irq_freehook
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch will make the fastpaths lockless and will no longer
require interrupts to be disabled. Calling the free hook with irq disabled
will no longer be possible.

Move the slab_free_hook_irq() logic into slab_free_hook. Only disable
interrupts if the features are selected that require callbacks with
interrupts off and reenable after calls have been made.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-12-14 10:45:11.000000000 -0600
+++ linux-2.6/mm/slub.c	2010-12-14 10:46:40.000000000 -0600
@@ -805,14 +805,24 @@ static inline void slab_post_alloc_hook(
 static inline void slab_free_hook(struct kmem_cache *s, void *x)
 {
 	kmemleak_free_recursive(x, s->flags);
-}
 
-static inline void slab_free_hook_irq(struct kmem_cache *s, void *object)
-{
-	kmemcheck_slab_free(s, object, s->objsize);
-	debug_check_no_locks_freed(object, s->objsize);
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(object, s->objsize);
+	/*
+	 * Trouble is that we may no longer disable interupts in the fast path
+	 * So in order to make the debug calls that expect irqs to be
+	 * disabled we need to disable interrupts temporarily.
+	 */
+#if defined(CONFIG_KMEMCHECK) || defined(CONFIG_LOCKDEP)
+	{
+		unsigned long flags;
+
+		local_irq_save(flags);
+		kmemcheck_slab_free(s, x, s->objsize);
+		debug_check_no_locks_freed(x, s->objsize);
+		if (!(s->flags & SLAB_DEBUG_OBJECTS))
+			debug_check_no_obj_freed(x, s->objsize);
+		local_irq_restore(flags);
+	}
+#endif
 }
 
 /*
@@ -1099,9 +1109,6 @@ static inline void slab_post_alloc_hook(
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
 
-static inline void slab_free_hook_irq(struct kmem_cache *s,
-		void *object) {}
-
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -1893,8 +1900,6 @@ static __always_inline void slab_free(st
 	local_irq_save(flags);
 	c = __this_cpu_ptr(s->cpu_slab);
 
-	slab_free_hook_irq(s, x);
-
 	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
 		c->freelist = object;

