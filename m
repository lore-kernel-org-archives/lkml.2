Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1BYRmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:42:44 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:23145 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753389Ab1BYRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:41:57 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: JSgD1W8VM1nSHqrhezv7WdoQ7ds1MPLua5KURwmsqOWgesC
 AVkwgxwc.tilO0yAN2QrBQ9Sb4EV_NhqEhuzpf9MPXTUOcA_mJRtZX5RyW5O
 p1vF2dtQ4gVp3CpevhLrO2VeCkPHmM6oOEi9cuxCKruqcEjCUdgLEuuVQFlw
 1wTojji5PcIBYaLuw.7mGXPiNiR0k5WnXxjpeaYGH6XRVXd1yr3_9tCusbNU
 Q3TyVInEhzBGw9HKQdbUgi9Oelsvz0Gh2A4waIbcjkJxMBDIWKET5_sn73yx
 Pp9E0KUOBq7tczM_s4hdwaMNXnaTsugNz9nWISQywfvNPwgA-
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110225174155.212499723@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 25 Feb 2011 11:38:52 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [cpuops cmpxchg double V3 2/5] slub: Get rid of slab_free_hook_irq()
References: <20110225173850.486326452@linux.com>
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
--- linux-2.6.orig/mm/slub.c	2011-01-10 12:06:58.000000000 -0600
+++ linux-2.6/mm/slub.c	2011-01-10 12:07:11.000000000 -0600
@@ -807,14 +807,24 @@ static inline void slab_post_alloc_hook(
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
@@ -1101,9 +1111,6 @@ static inline void slab_post_alloc_hook(
 
 static inline void slab_free_hook(struct kmem_cache *s, void *x) {}
 
-static inline void slab_free_hook_irq(struct kmem_cache *s,
-		void *object) {}
-
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -1909,8 +1916,6 @@ static __always_inline void slab_free(st
 	local_irq_save(flags);
 	c = __this_cpu_ptr(s->cpu_slab);
 
-	slab_free_hook_irq(s, x);
-
 	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
 		c->freelist = object;

