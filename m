Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab2J0TSg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:18:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:38425 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab2J0TSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:18:35 -0400
Date: Sat, 27 Oct 2012 21:18:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux-foundation.org>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] slub: Use the correct per cpu slab on CPU_DEAD
Message-ID: <alpine.LFD.2.02.1210272117060.2756@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While making slub available for RT I noticed, that during CPU offline
for each kmem_cache __flush_cpu_slab() is called on a live CPU. This
correctly flushs the cpu_slab of the dead CPU via flush_slab. Though
unfreeze_partials which is called from __flush_cpu_slab() after that
looks at the cpu_slab of the cpu on which this is called. So we fail
to look at the partials of the dead cpu.

Correct this by extending the arguments of unfreeze_partials with the
target cpu number and use per_cpu_ptr instead of this_cpu_ptr.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 mm/slub.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -1874,10 +1874,10 @@ redo:
  *
  * This function must be called with interrupt disabled.
  */
-static void unfreeze_partials(struct kmem_cache *s)
+static void unfreeze_partials(struct kmem_cache *s, unsigned int cpu)
 {
 	struct kmem_cache_node *n = NULL, *n2 = NULL;
-	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
+	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 	struct page *page, *discard_page = NULL;
 
 	while ((page = c->partial)) {
@@ -1963,7 +1963,7 @@ static int put_cpu_partial(struct kmem_c
 				 * set to the per node partial list.
 				 */
 				local_irq_save(flags);
-				unfreeze_partials(s);
+				unfreeze_partials(s, smp_processor_id());
 				local_irq_restore(flags);
 				oldpage = NULL;
 				pobjects = 0;
@@ -2006,7 +2006,7 @@ static inline void __flush_cpu_slab(stru
 		if (c->page)
 			flush_slab(s, c);
 
-		unfreeze_partials(s);
+		unfreeze_partials(s, cpu);
 	}
 }
 
