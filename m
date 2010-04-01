Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0DAIKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 04:10:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:37981 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab0DAIJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:09:56 -0400
Date: Thu, 1 Apr 2010 19:09:40 +1100
From: Nick Piggin <npiggin@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <npiggin@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
Subject: Re: Is module refcounting racy?
Message-ID: <20100401080940.GA8356@laptop>
References: <20100318105533.GE25636@laptop>
 <201003291942.56706.rusty@rustcorp.com.au>
 <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
 <201003311414.49364.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003311414.49364.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:14:49PM +1030, Rusty Russell wrote:
> On Tue, 30 Mar 2010 03:28:49 am Nick Piggin wrote:
> > On Mon, Mar 29, 2010 at 8:12 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > On Thu, 18 Mar 2010 09:25:34 pm Nick Piggin wrote:
> > >> Hey,
> > >>
> > >> I've been looking at weird and wonderful ways to do scalable refcounting,
> > >> for the vfs...
> > >>
> > >> Sadly, module refcounting doesn't fit my bill. But as far as I could see,
> > >> it is racy.
> > >
> > > Other than for advisory purposes, the refcount is only checked against zero
> > > under stop_machine.  For exactly this reason.
> > 
> > There definitely looks to me like there is code that checks the refcount
> > *without* stop_machine. module_refcount is an exported function, and you
> > expect drivers to get this right (scsi_device_put for a trivial example)
> 
> No, but there's a lot of history of crap drivers which wanted to poke at it.
> And it's cute for debugging.
> 
> The scsi code is simply wrong.  But noone cares, since module removal is
> so rare.

Well maybe true (and I'm sure we have more important and frequently hit
bugs), but if we offer a feature it should be without bugs IMO.


> > , but
> > it even looks like it is used in a racy way in kernel/module.c code.
> 
> Yep, though I don't know if anyone uses waiting module removal AFAICT
> though; there's not even a modprobe option for it.
> 
> > Either we need to take my patch, or audit t, and put a WARN_ON
> > if it is called while not under stop_machine.
> 
> So can you send me a proper annotated signed-off patch to queue?

Sure.


> Note that years ago it was decided that module reference counting would be
> best effort, rather than perfect.  I disagreed, but we've lived with it
> surprisingly well.
> 
> I wonder if by caring even *less*, we can lose a lot of complexity without
> noticeably increasing the bug count.  Make modules run their own reference
> counts and just sleep for a while to see if the reference count changes.
> If not, assume it's good to be removed.  If reference count still hasn't
> moved after another minute or so, actually free the memory.

I think it can be done racelessly with my patch, which is not really too
much overhead. I think if this is considered too much, then we should
either fix code and preferably de-export and remove module_refcount from
drivers, or remove module removal completely.

--
Module refcounting is implemented with a per-cpu counter for speed. However
there is a race when tallying the counter where a reference may be taken
by one CPU and released by another. Reference count summation may then see
the decrement without having seen the previous increment, leading to lower
than expected count. A module which never has its actual reference drop below
1 may return a reference count of 0 due to this race.

Module removal generally runs under stop_machine, which prevents this race
causing bugs due to removal of in-use modules. However there are other real
bugs in module.c code and driver code (module_refcount is exported) where the
callers do not run under stop_machine.

Fix this by maintaining running per-cpu counters for the number of module
refcount increments and the number of refcount decrements. The increments
are tallied after the decrements, so any decrement seen will always have its
corresponding increment counted. The final refcount is the difference of the
total increments and decrements, preventing a low-refcount from being
returned.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
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
