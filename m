Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab0CRKz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:55:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:51384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0CRKz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:55:57 -0400
Date: Thu, 18 Mar 2010 21:55:34 +1100
From: Nick Piggin <npiggin@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Is module refcounting racy?
Message-ID: <20100318105533.GE25636@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I've been looking at weird and wonderful ways to do scalable refcounting,
for the vfs...

Sadly, module refcounting doesn't fit my bill. But as far as I could see,
it is racy. Can someone confirm that we do or do not have a race (and
if so, whether this patch would solve it?)

Race described in the comment below.

Thanks,
Nick

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h
+++ linux-2.6/include/linux/module.h
@@ -365,7 +365,8 @@ struct module
 	void (*exit)(void);
 
 	struct module_ref {
-		int count;
+		unsigned int incs;
+		unsigned int decs;
 	} __percpu *refptr;
 #endif
 
@@ -459,9 +460,9 @@ static inline void __module_get(struct m
 {
 	if (module) {
 		preempt_disable();
-		__this_cpu_inc(module->refptr->count);
+		__this_cpu_inc(module->refptr->incs);
 		trace_module_get(module, _THIS_IP_,
-				 __this_cpu_read(module->refptr->count));
+				 __this_cpu_read(module->refptr->incs));
 		preempt_enable();
 	}
 }
@@ -474,11 +475,10 @@ static inline int try_module_get(struct
 		preempt_disable();
 
 		if (likely(module_is_live(module))) {
-			__this_cpu_inc(module->refptr->count);
+			__this_cpu_inc(module->refptr->incs);
 			trace_module_get(module, _THIS_IP_,
-				__this_cpu_read(module->refptr->count));
-		}
-		else
+				__this_cpu_read(module->refptr->incs));
+		} else
 			ret = 0;
 
 		preempt_enable();
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -473,11 +473,13 @@ static void module_unload_init(struct mo
 	int cpu;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for_each_possible_cpu(cpu)
-		per_cpu_ptr(mod->refptr, cpu)->count = 0;
+	for_each_possible_cpu(cpu) {
+		per_cpu_ptr(mod->refptr, cpu)->incs = 0;
+		per_cpu_ptr(mod->refptr, cpu)->decs = 0;
+	}
 
 	/* Hold reference count during initialization. */
-	__this_cpu_write(mod->refptr->count, 1);
+	__this_cpu_write(mod->refptr->incs, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 }
@@ -616,12 +618,28 @@ static int try_stop_module(struct module
 
 unsigned int module_refcount(struct module *mod)
 {
-	unsigned int total = 0;
+	unsigned int incs = 0, decs = 0;
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		total += per_cpu_ptr(mod->refptr, cpu)->count;
-	return total;
+		decs += per_cpu_ptr(mod->refptr, cpu)->decs;
+	/*
+	 * ensure the incs are added up after the decs.
+	 * module_put ensures incs are visible before decs with smp_wmb.
+	 *
+	 * This 2-count scheme avoids the situation where the refcount
+	 * for CPU0 is read, then CPU0 increments the module refcount,
+	 * then CPU1 drops that refcount, then the refcount for CPU1 is
+	 * read. We would record a decrement but not its corresponding
+	 * increment so we would see a low count (disaster).
+	 *
+	 * Rare situation? But module_refcount can be preempted, and we
+	 * might be tallying up 4096+ CPUs. So it is not impossible.
+	 */
+	smp_rmb();
+	for_each_possible_cpu(cpu)
+		incs += per_cpu_ptr(mod->refptr, cpu)->incs;
+	return incs - decs;
 }
 EXPORT_SYMBOL(module_refcount);
 
@@ -798,10 +816,11 @@ void module_put(struct module *module)
 {
 	if (module) {
 		preempt_disable();
-		__this_cpu_dec(module->refptr->count);
+		smp_wmb(); /* see comment in module_refcount */
+		__this_cpu_inc(module->refptr->decs);
 
 		trace_module_put(module, _RET_IP_,
-				 __this_cpu_read(module->refptr->count));
+				 __this_cpu_read(module->refptr->decs));
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
