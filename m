Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2J0TbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 15:31:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:38476 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596Ab2J0TbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 15:31:11 -0400
Date: Sat, 27 Oct 2012 21:31:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.6.3-rt8
Message-ID: <alpine.LFD.2.02.1210272125200.2756@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.6.3-rt8 release.

Changes since 3.6.3-rt7:

   * Fix the SLUB fallout on NUMA machines

     I missed to fixup the smp function calls which can result in a
     deadlock on RT.

   * Fix a mainline issue with cpufreq/powernow-k8 (Same patch is
     queued upstream, but one of Carstens test systems stumbled over
     it so I carry that until it hits 3.6.stable)

The delta patch against 3.6.3-rt7 is appended below and can be found
here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/incr/patch-3.6.3-rt7-rt8.patch.xz

The RT patch against 3.6.3 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patch-3.6.3-rt8.patch.xz

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.6/patches-3.6.3-rt8.tar.xz

Enjoy,

	tglx

---------->
Index: linux-stable/localversion-rt
===================================================================
--- linux-stable.orig/localversion-rt
+++ linux-stable/localversion-rt
@@ -1 +1 @@
--rt7
+-rt8
Index: linux-stable/mm/slub.c
===================================================================
--- linux-stable.orig/mm/slub.c
+++ linux-stable/mm/slub.c
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
@@ -1963,7 +1963,7 @@ int put_cpu_partial(struct kmem_cache *s
 				 * set to the per node partial list.
 				 */
 				local_lock_irqsave(slub_lock, flags);
-				unfreeze_partials(s);
+				unfreeze_partials(s, smp_processor_id());
 				local_unlock_irqrestore(slub_lock, flags);
 				pobjects = 0;
 				pages = 0;
@@ -2005,17 +2005,10 @@ static inline void __flush_cpu_slab(stru
 		if (c->page)
 			flush_slab(s, c);
 
-		unfreeze_partials(s);
+		unfreeze_partials(s, cpu);
 	}
 }
 
-static void flush_cpu_slab(void *d)
-{
-	struct kmem_cache *s = d;
-
-	__flush_cpu_slab(s, smp_processor_id());
-}
-
 static bool has_cpu_slab(int cpu, void *info)
 {
 	struct kmem_cache *s = info;
@@ -2024,10 +2017,29 @@ static bool has_cpu_slab(int cpu, void *
 	return c->page || c->partial;
 }
 
+#ifndef CONFIG_PREEMPT_RT_FULL
+static void flush_cpu_slab(void *d)
+{
+	struct kmem_cache *s = d;
+
+	__flush_cpu_slab(s, smp_processor_id());
+}
+
 static void flush_all(struct kmem_cache *s)
 {
 	on_each_cpu_cond(has_cpu_slab, flush_cpu_slab, s, 1, GFP_ATOMIC);
 }
+#else
+static void flush_all(struct kmem_cache *s)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (has_cpu_slab(cpu, s))
+			__flush_cpu_slab(s, cpu);
+	}
+}
+#endif
 
 /*
  * Check if the objects in a per cpu structure fit numa
Index: linux-stable/drivers/cpufreq/powernow-k8.c
===================================================================
--- linux-stable.orig/drivers/cpufreq/powernow-k8.c
+++ linux-stable/drivers/cpufreq/powernow-k8.c
@@ -1224,13 +1224,12 @@ static int powernowk8_target(struct cpuf
 					     .relation = relation };
 
 	/*
-	 * Must run on @pol->cpu.  cpufreq core is responsible for ensuring
-	 * that we're bound to the current CPU and pol->cpu stays online.
+	 * Must run on @pol->cpu. We queue it on the target cpu even
+	 * if we are currently on the target cpu. This is preemptible
+	 * non cpu bound context, so we can't call the target function
+	 * directly.
 	 */
-	if (smp_processor_id() == pol->cpu)
-		return powernowk8_target_fn(&pta);
-	else
-		return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
+	return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
 }
 
 /* Driver entry point to verify the policy and range of frequencies */
