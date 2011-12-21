Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab1LULSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:18:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45350 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1LULSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:18:24 -0500
Message-Id: <20111221111143.401184003@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 11:57:41 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/7] lockdep: Provide early_printk() support
References: <20111221105739.798864333@chello.nl>
Content-Disposition: inline; filename=lockdep-early-printk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |  488 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 252 insertions(+), 236 deletions(-)
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -67,6 +67,22 @@ module_param(lock_stat, int, 0644);
 #define lock_stat 0
 #endif
 
+int use_early_printk = 0;
+module_param(use_early_printk, int, 0644);
+
+static int lprintk(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+	if (!use_early_printk || !(r = early_vprintk(fmt, args)))
+		r = vprintk(fmt, args);
+	va_end(args);
+
+	return r;
+}
+
 /*
  * lockdep_lock: protects the lockdep graph, the hashes and the
  *               class/list/hash allocators.
@@ -409,8 +425,8 @@ static int save_trace(struct stack_trace
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		lprintk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
+		lprintk("turning off the locking correctness validator.\n");
 		dump_stack();
 
 		return 0;
@@ -426,7 +442,7 @@ unsigned int max_lockdep_depth;
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 /*
- * We cannot printk in early bootup code. Not even early_printk()
+ * We cannot printk in early bootup code. Not even early_lprintk()
  * might work. So we mark any initialization errors and printk
  * about it later on, in lockdep_info().
  */
@@ -508,13 +524,13 @@ static void __print_lock_name(struct loc
 	name = class->name;
 	if (!name) {
 		name = __get_key_name(class->key, str);
-		printk("%s", name);
+		lprintk("%s", name);
 	} else {
-		printk("%s", name);
+		lprintk("%s", name);
 		if (class->name_version > 1)
-			printk("#%d", class->name_version);
+			lprintk("#%d", class->name_version);
 		if (class->subclass)
-			printk("/%d", class->subclass);
+			lprintk("/%d", class->subclass);
 	}
 }
 
@@ -524,9 +540,9 @@ static void print_lock_name(struct lock_
 
 	get_usage_chars(class, usage);
 
-	printk(" (");
+	lprintk(" (");
 	__print_lock_name(class);
-	printk("){%s}", usage);
+	lprintk("){%s}", usage);
 }
 
 static void print_lockdep_cache(struct lockdep_map *lock)
@@ -538,13 +554,13 @@ static void print_lockdep_cache(struct l
 	if (!name)
 		name = __get_key_name(lock->key->subkeys, str);
 
-	printk("%s", name);
+	lprintk("%s", name);
 }
 
 static void print_lock(struct held_lock *hlock)
 {
 	print_lock_name(hlock_class(hlock));
-	printk(", at: ");
+	lprintk(", at: ");
 	print_ip_sym(hlock->acquire_ip);
 }
 
@@ -553,21 +569,21 @@ static void lockdep_print_held_locks(str
 	int i, depth = curr->lockdep_depth;
 
 	if (!depth) {
-		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
+		lprintk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
 		return;
 	}
-	printk("%d lock%s held by %s/%d:\n",
+	lprintk("%d lock%s held by %s/%d:\n",
 		depth, depth > 1 ? "s" : "", curr->comm, task_pid_nr(curr));
 
 	for (i = 0; i < depth; i++) {
-		printk(" #%d: ", i);
+		lprintk(" #%d: ", i);
 		print_lock(curr->held_locks + i);
 	}
 }
 
 static void print_kernel_ident(void)
 {
-	printk("%s %.*s %s\n", init_utsname()->release,
+	lprintk("%s %.*s %s\n", init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version,
 		print_tainted());
@@ -661,9 +677,9 @@ look_up_lock_class(struct lockdep_map *l
 
 	if (unlikely(subclass >= MAX_LOCKDEP_SUBCLASSES)) {
 		debug_locks_off();
-		printk(KERN_ERR
+		lprintk(KERN_ERR
 			"BUG: looking up invalid subclass: %u\n", subclass);
-		printk(KERN_ERR
+		lprintk(KERN_ERR
 			"turning off the locking correctness validator.\n");
 		dump_stack();
 		return NULL;
@@ -729,9 +745,9 @@ register_lock_class(struct lockdep_map *
  	 */
 	if (!static_obj(lock->key)) {
 		debug_locks_off();
-		printk("INFO: trying to register non-static key.\n");
-		printk("the code is fine but needs lockdep annotation.\n");
-		printk("turning off the locking correctness validator.\n");
+		lprintk("INFO: trying to register non-static key.\n");
+		lprintk("the code is fine but needs lockdep annotation.\n");
+		lprintk("turning off the locking correctness validator.\n");
 		dump_stack();
 
 		return NULL;
@@ -763,8 +779,8 @@ register_lock_class(struct lockdep_map *
 		}
 		raw_local_irq_restore(flags);
 
-		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		lprintk("BUG: MAX_LOCKDEP_KEYS too low!\n");
+		lprintk("turning off the locking correctness validator.\n");
 		dump_stack();
 		return NULL;
 	}
@@ -791,10 +807,10 @@ register_lock_class(struct lockdep_map *
 		graph_unlock();
 		raw_local_irq_restore(flags);
 
-		printk("\nnew class %p: %s", class->key, class->name);
+		lprintk("\nnew class %p: %s", class->key, class->name);
 		if (class->name_version > 1)
-			printk("#%d", class->name_version);
-		printk("\n");
+			lprintk("#%d", class->name_version);
+		lprintk("\n");
 		dump_stack();
 
 		raw_local_irq_save(flags);
@@ -834,8 +850,8 @@ static struct lock_list *alloc_list_entr
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
-		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		lprintk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
+		lprintk("turning off the locking correctness validator.\n");
 		dump_stack();
 		return NULL;
 	}
@@ -1074,9 +1090,9 @@ print_circular_bug_entry(struct lock_lis
 {
 	if (debug_locks_silent)
 		return 0;
-	printk("\n-> #%u", depth);
+	lprintk("\n-> #%u", depth);
 	print_lock_name(target->class);
-	printk(":\n");
+	lprintk(":\n");
 	print_stack_trace(&target->trace, 6);
 
 	return 0;
@@ -1105,31 +1121,31 @@ print_circular_lock_scenario(struct held
 	 * from the safe_class lock to the unsafe_class lock.
 	 */
 	if (parent != source) {
-		printk("Chain exists of:\n  ");
+		lprintk("Chain exists of:\n  ");
 		__print_lock_name(source);
-		printk(" --> ");
+		lprintk(" --> ");
 		__print_lock_name(parent);
-		printk(" --> ");
+		lprintk(" --> ");
 		__print_lock_name(target);
-		printk("\n\n");
+		lprintk("\n\n");
 	}
 
-	printk(" Possible unsafe locking scenario:\n\n");
-	printk("       CPU0                    CPU1\n");
-	printk("       ----                    ----\n");
-	printk("  lock(");
+	lprintk(" Possible unsafe locking scenario:\n\n");
+	lprintk("       CPU0                    CPU1\n");
+	lprintk("       ----                    ----\n");
+	lprintk("  lock(");
 	__print_lock_name(target);
-	printk(");\n");
-	printk("                               lock(");
+	lprintk(");\n");
+	lprintk("                               lock(");
 	__print_lock_name(parent);
-	printk(");\n");
-	printk("                               lock(");
+	lprintk(");\n");
+	lprintk("                               lock(");
 	__print_lock_name(target);
-	printk(");\n");
-	printk("  lock(");
+	lprintk(");\n");
+	lprintk("  lock(");
 	__print_lock_name(source);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
+	lprintk(");\n");
+	lprintk("\n *** DEADLOCK ***\n\n");
 }
 
 /*
@@ -1146,18 +1162,18 @@ print_circular_bug_header(struct lock_li
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("======================================================\n");
-	printk("[ INFO: possible circular locking dependency detected ]\n");
+	lprintk("\n");
+	lprintk("======================================================\n");
+	lprintk("[ INFO: possible circular locking dependency detected ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------------------------\n");
-	printk("%s/%d is trying to acquire lock:\n",
+	lprintk("-------------------------------------------------------\n");
+	lprintk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(check_src);
-	printk("\nbut task is already holding lock:\n");
+	lprintk("\nbut task is already holding lock:\n");
 	print_lock(check_tgt);
-	printk("\nwhich lock already depends on the new lock.\n\n");
-	printk("\nthe existing dependency chain (in reverse order) is:\n");
+	lprintk("\nwhich lock already depends on the new lock.\n\n");
+	lprintk("\nthe existing dependency chain (in reverse order) is:\n");
 
 	print_circular_bug_entry(entry, depth);
 
@@ -1197,13 +1213,13 @@ static noinline int print_circular_bug(s
 		parent = get_lock_parent(parent);
 	}
 
-	printk("\nother info that might help us debug this:\n\n");
+	lprintk("\nother info that might help us debug this:\n\n");
 	print_circular_lock_scenario(check_src, check_tgt,
 				     first_parent);
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -1362,23 +1378,23 @@ static void print_lock_class_header(stru
 {
 	int bit;
 
-	printk("%*s->", depth, "");
+	lprintk("%*s->", depth, "");
 	print_lock_name(class);
-	printk(" ops: %lu", class->ops);
-	printk(" {\n");
+	lprintk(" ops: %lu", class->ops);
+	lprintk(" {\n");
 
 	for (bit = 0; bit < LOCK_USAGE_STATES; bit++) {
 		if (class->usage_mask & (1 << bit)) {
 			int len = depth;
 
-			len += printk("%*s   %s", depth, "", usage_str[bit]);
-			len += printk(" at:\n");
+			len += lprintk("%*s   %s", depth, "", usage_str[bit]);
+			len += lprintk(" at:\n");
 			print_stack_trace(class->usage_traces + bit, len);
 		}
 	}
-	printk("%*s }\n", depth, "");
+	lprintk("%*s }\n", depth, "");
 
-	printk("%*s ... key      at: ",depth,"");
+	lprintk("%*s ... key      at: ",depth,"");
 	print_ip_sym((unsigned long)class->key);
 }
 
@@ -1397,12 +1413,12 @@ print_shortest_lock_dependencies(struct 
 
 	do {
 		print_lock_class_header(entry->class, depth);
-		printk("%*s ... acquired at:\n", depth, "");
+		lprintk("%*s ... acquired at:\n", depth, "");
 		print_stack_trace(&entry->trace, 2);
-		printk("\n");
+		lprintk("\n");
 
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			lprintk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 
@@ -1440,33 +1456,33 @@ print_irq_lock_scenario(struct lock_list
 	 * from the safe_class lock to the unsafe_class lock.
 	 */
 	if (middle_class != unsafe_class) {
-		printk("Chain exists of:\n  ");
+		lprintk("Chain exists of:\n  ");
 		__print_lock_name(safe_class);
-		printk(" --> ");
+		lprintk(" --> ");
 		__print_lock_name(middle_class);
-		printk(" --> ");
+		lprintk(" --> ");
 		__print_lock_name(unsafe_class);
-		printk("\n\n");
+		lprintk("\n\n");
 	}
 
-	printk(" Possible interrupt unsafe locking scenario:\n\n");
-	printk("       CPU0                    CPU1\n");
-	printk("       ----                    ----\n");
-	printk("  lock(");
+	lprintk(" Possible interrupt unsafe locking scenario:\n\n");
+	lprintk("       CPU0                    CPU1\n");
+	lprintk("       ----                    ----\n");
+	lprintk("  lock(");
 	__print_lock_name(unsafe_class);
-	printk(");\n");
-	printk("                               local_irq_disable();\n");
-	printk("                               lock(");
+	lprintk(");\n");
+	lprintk("                               local_irq_disable();\n");
+	lprintk("                               lock(");
 	__print_lock_name(safe_class);
-	printk(");\n");
-	printk("                               lock(");
+	lprintk(");\n");
+	lprintk("                               lock(");
 	__print_lock_name(middle_class);
-	printk(");\n");
-	printk("  <Interrupt>\n");
-	printk("    lock(");
+	lprintk(");\n");
+	lprintk("  <Interrupt>\n");
+	lprintk("    lock(");
 	__print_lock_name(safe_class);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
+	lprintk(");\n");
+	lprintk("\n *** DEADLOCK ***\n\n");
 }
 
 static int
@@ -1484,13 +1500,13 @@ print_bad_irq_dependency(struct task_str
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("======================================================\n");
-	printk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
+	lprintk("\n");
+	lprintk("======================================================\n");
+	lprintk("[ INFO: %s-safe -> %s-unsafe lock order detected ]\n",
 		irqclass, irqclass);
 	print_kernel_ident();
-	printk("------------------------------------------------------\n");
-	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
+	lprintk("------------------------------------------------------\n");
+	lprintk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] is trying to acquire:\n",
 		curr->comm, task_pid_nr(curr),
 		curr->hardirq_context, hardirq_count() >> HARDIRQ_SHIFT,
 		curr->softirq_context, softirq_count() >> SOFTIRQ_SHIFT,
@@ -1498,47 +1514,47 @@ print_bad_irq_dependency(struct task_str
 		curr->softirqs_enabled);
 	print_lock(next);
 
-	printk("\nand this task is already holding:\n");
+	lprintk("\nand this task is already holding:\n");
 	print_lock(prev);
-	printk("which would create a new lock dependency:\n");
+	lprintk("which would create a new lock dependency:\n");
 	print_lock_name(hlock_class(prev));
-	printk(" ->");
+	lprintk(" ->");
 	print_lock_name(hlock_class(next));
-	printk("\n");
+	lprintk("\n");
 
-	printk("\nbut this new dependency connects a %s-irq-safe lock:\n",
+	lprintk("\nbut this new dependency connects a %s-irq-safe lock:\n",
 		irqclass);
 	print_lock_name(backwards_entry->class);
-	printk("\n... which became %s-irq-safe at:\n", irqclass);
+	lprintk("\n... which became %s-irq-safe at:\n", irqclass);
 
 	print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
 
-	printk("\nto a %s-irq-unsafe lock:\n", irqclass);
+	lprintk("\nto a %s-irq-unsafe lock:\n", irqclass);
 	print_lock_name(forwards_entry->class);
-	printk("\n... which became %s-irq-unsafe at:\n", irqclass);
-	printk("...");
+	lprintk("\n... which became %s-irq-unsafe at:\n", irqclass);
+	lprintk("...");
 
 	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
-	printk("\nother info that might help us debug this:\n\n");
+	lprintk("\nother info that might help us debug this:\n\n");
 	print_irq_lock_scenario(backwards_entry, forwards_entry,
 				hlock_class(prev), hlock_class(next));
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe dependencies between %s-irq-safe lock", irqclass);
-	printk(" and the holding lock:\n");
+	lprintk("\nthe dependencies between %s-irq-safe lock", irqclass);
+	lprintk(" and the holding lock:\n");
 	if (!save_trace(&prev_root->trace))
 		return 0;
 	print_shortest_lock_dependencies(backwards_entry, prev_root);
 
-	printk("\nthe dependencies between the lock to be acquired");
-	printk(" and %s-irq-unsafe lock:\n", irqclass);
+	lprintk("\nthe dependencies between the lock to be acquired");
+	lprintk(" and %s-irq-unsafe lock:\n", irqclass);
 	if (!save_trace(&next_root->trace))
 		return 0;
 	print_shortest_lock_dependencies(forwards_entry, next_root);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -1694,17 +1710,17 @@ print_deadlock_scenario(struct held_lock
 	struct lock_class *next = hlock_class(nxt);
 	struct lock_class *prev = hlock_class(prv);
 
-	printk(" Possible unsafe locking scenario:\n\n");
-	printk("       CPU0\n");
-	printk("       ----\n");
-	printk("  lock(");
+	lprintk(" Possible unsafe locking scenario:\n\n");
+	lprintk("       CPU0\n");
+	lprintk("       ----\n");
+	lprintk("  lock(");
 	__print_lock_name(prev);
-	printk(");\n");
-	printk("  lock(");
+	lprintk(");\n");
+	lprintk("  lock(");
 	__print_lock_name(next);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
-	printk(" May be due to missing lock nesting notation\n\n");
+	lprintk(");\n");
+	lprintk("\n *** DEADLOCK ***\n\n");
+	lprintk(" May be due to missing lock nesting notation\n\n");
 }
 
 static int
@@ -1714,22 +1730,22 @@ print_deadlock_bug(struct task_struct *c
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=============================================\n");
-	printk("[ INFO: possible recursive locking detected ]\n");
+	lprintk("\n");
+	lprintk("=============================================\n");
+	lprintk("[ INFO: possible recursive locking detected ]\n");
 	print_kernel_ident();
-	printk("---------------------------------------------\n");
-	printk("%s/%d is trying to acquire lock:\n",
+	lprintk("---------------------------------------------\n");
+	lprintk("%s/%d is trying to acquire lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(next);
-	printk("\nbut task is already holding lock:\n");
+	lprintk("\nbut task is already holding lock:\n");
 	print_lock(prev);
 
-	printk("\nother info that might help us debug this:\n");
+	lprintk("\nother info that might help us debug this:\n");
 	print_deadlock_scenario(next, prev);
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -1889,11 +1905,11 @@ check_prev_add(struct task_struct *curr,
 	 */
 	if (verbose(hlock_class(prev)) || verbose(hlock_class(next))) {
 		graph_unlock();
-		printk("\n new dependency: ");
+		lprintk("\n new dependency: ");
 		print_lock_name(hlock_class(prev));
-		printk(" => ");
+		lprintk(" => ");
 		print_lock_name(hlock_class(next));
-		printk("\n");
+		lprintk("\n");
 		dump_stack();
 		return graph_lock();
 	}
@@ -2019,7 +2035,7 @@ static inline int lookup_chain_cache(str
 cache_hit:
 			debug_atomic_inc(chain_lookup_hits);
 			if (very_verbose(class))
-				printk("\nhash chain already cached, key: "
+				lprintk("\nhash chain already cached, key: "
 					"%016Lx tail class: [%p] %s\n",
 					(unsigned long long)chain_key,
 					class->key, class->name);
@@ -2027,7 +2043,7 @@ static inline int lookup_chain_cache(str
 		}
 	}
 	if (very_verbose(class))
-		printk("\nnew hash chain, key: %016Lx tail class: [%p] %s\n",
+		lprintk("\nnew hash chain, key: %016Lx tail class: [%p] %s\n",
 			(unsigned long long)chain_key, class->key, class->name);
 	/*
 	 * Allocate a new chain entry from the static array, and add
@@ -2048,8 +2064,8 @@ static inline int lookup_chain_cache(str
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		lprintk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
+		lprintk("turning off the locking correctness validator.\n");
 		dump_stack();
 		return 0;
 	}
@@ -2201,17 +2217,17 @@ print_usage_bug_scenario(struct held_loc
 {
 	struct lock_class *class = hlock_class(lock);
 
-	printk(" Possible unsafe locking scenario:\n\n");
-	printk("       CPU0\n");
-	printk("       ----\n");
-	printk("  lock(");
+	lprintk(" Possible unsafe locking scenario:\n\n");
+	lprintk("       CPU0\n");
+	lprintk("       ----\n");
+	lprintk("  lock(");
 	__print_lock_name(class);
-	printk(");\n");
-	printk("  <Interrupt>\n");
-	printk("    lock(");
+	lprintk(");\n");
+	lprintk("  <Interrupt>\n");
+	lprintk("    lock(");
 	__print_lock_name(class);
-	printk(");\n");
-	printk("\n *** DEADLOCK ***\n\n");
+	lprintk(");\n");
+	lprintk("\n *** DEADLOCK ***\n\n");
 }
 
 static int
@@ -2221,16 +2237,16 @@ print_usage_bug(struct task_struct *curr
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=================================\n");
-	printk("[ INFO: inconsistent lock state ]\n");
+	lprintk("\n");
+	lprintk("=================================\n");
+	lprintk("[ INFO: inconsistent lock state ]\n");
 	print_kernel_ident();
-	printk("---------------------------------\n");
+	lprintk("---------------------------------\n");
 
-	printk("inconsistent {%s} -> {%s} usage.\n",
+	lprintk("inconsistent {%s} -> {%s} usage.\n",
 		usage_str[prev_bit], usage_str[new_bit]);
 
-	printk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
+	lprintk("%s/%d [HC%u[%lu]:SC%u[%lu]:HE%u:SE%u] takes:\n",
 		curr->comm, task_pid_nr(curr),
 		trace_hardirq_context(curr), hardirq_count() >> HARDIRQ_SHIFT,
 		trace_softirq_context(curr), softirq_count() >> SOFTIRQ_SHIFT,
@@ -2238,16 +2254,16 @@ print_usage_bug(struct task_struct *curr
 		trace_softirqs_enabled(curr));
 	print_lock(this);
 
-	printk("{%s} state was registered at:\n", usage_str[prev_bit]);
+	lprintk("{%s} state was registered at:\n", usage_str[prev_bit]);
 	print_stack_trace(hlock_class(this)->usage_traces + prev_bit, 1);
 
 	print_irqtrace_events(curr);
-	printk("\nother info that might help us debug this:\n");
+	lprintk("\nother info that might help us debug this:\n");
 	print_usage_bug_scenario(this);
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -2286,28 +2302,28 @@ print_irq_inversion_bug(struct task_stru
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=========================================================\n");
-	printk("[ INFO: possible irq lock inversion dependency detected ]\n");
+	lprintk("\n");
+	lprintk("=========================================================\n");
+	lprintk("[ INFO: possible irq lock inversion dependency detected ]\n");
 	print_kernel_ident();
-	printk("---------------------------------------------------------\n");
-	printk("%s/%d just changed the state of lock:\n",
+	lprintk("---------------------------------------------------------\n");
+	lprintk("%s/%d just changed the state of lock:\n",
 		curr->comm, task_pid_nr(curr));
 	print_lock(this);
 	if (forwards)
-		printk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
+		lprintk("but this lock took another, %s-unsafe lock in the past:\n", irqclass);
 	else
-		printk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
+		lprintk("but this lock was taken by another, %s-safe lock in the past:\n", irqclass);
 	print_lock_name(other->class);
-	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
+	lprintk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
-	printk("\nother info that might help us debug this:\n");
+	lprintk("\nother info that might help us debug this:\n");
 
 	/* Find a middle lock (if one exists) */
 	depth = get_lock_depth(other);
 	do {
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			lprintk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 		middle = entry;
@@ -2323,12 +2339,12 @@ print_irq_inversion_bug(struct task_stru
 
 	lockdep_print_held_locks(curr);
 
-	printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
+	lprintk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
 	if (!save_trace(&root->trace))
 		return 0;
 	print_shortest_lock_dependencies(other, root);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -2384,14 +2400,14 @@ check_usage_backwards(struct task_struct
 
 void print_irqtrace_events(struct task_struct *curr)
 {
-	printk("irq event stamp: %u\n", curr->irq_events);
-	printk("hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
+	lprintk("irq event stamp: %u\n", curr->irq_events);
+	lprintk("hardirqs last  enabled at (%u): ", curr->hardirq_enable_event);
 	print_ip_sym(curr->hardirq_enable_ip);
-	printk("hardirqs last disabled at (%u): ", curr->hardirq_disable_event);
+	lprintk("hardirqs last disabled at (%u): ", curr->hardirq_disable_event);
 	print_ip_sym(curr->hardirq_disable_ip);
-	printk("softirqs last  enabled at (%u): ", curr->softirq_enable_event);
+	lprintk("softirqs last  enabled at (%u): ", curr->softirq_enable_event);
 	print_ip_sym(curr->softirq_enable_ip);
-	printk("softirqs last disabled at (%u): ", curr->softirq_disable_event);
+	lprintk("softirqs last disabled at (%u): ", curr->softirq_disable_event);
 	print_ip_sym(curr->softirq_disable_ip);
 }
 
@@ -2934,7 +2950,7 @@ static int mark_lock(struct task_struct 
 	 * We must printk outside of the graph_lock:
 	 */
 	if (ret == 2) {
-		printk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
+		lprintk("\nmarked lock as {%s}:\n", usage_str[new_bit]);
 		print_lock(this);
 		print_irqtrace_events(curr);
 		dump_stack();
@@ -2979,7 +2995,7 @@ void lockdep_init_map(struct lockdep_map
 	 * Sanity check, the lock-class key must be persistent:
 	 */
 	if (!static_obj(key)) {
-		printk("BUG: key %p not in .data!\n", key);
+		lprintk("BUG: key %p not in .data!\n", key);
 		/*
 		 * What it says above ^^^^^, I suggest you read it.
 		 */
@@ -3044,10 +3060,10 @@ static int __lock_acquire(struct lockdep
 	}
 	atomic_inc((atomic_t *)&class->ops);
 	if (very_verbose(class)) {
-		printk("\nacquire class [%p] %s", class->key, class->name);
+		lprintk("\nacquire class [%p] %s", class->key, class->name);
 		if (class->name_version > 1)
-			printk("#%d", class->name_version);
-		printk("\n");
+			lprintk("#%d", class->name_version);
+		lprintk("\n");
 		dump_stack();
 	}
 
@@ -3151,8 +3167,8 @@ static int __lock_acquire(struct lockdep
 #endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
-		printk("BUG: MAX_LOCK_DEPTH too low!\n");
-		printk("turning off the locking correctness validator.\n");
+		lprintk("BUG: MAX_LOCK_DEPTH too low!\n");
+		lprintk("turning off the locking correctness validator.\n");
 		dump_stack();
 		return 0;
 	}
@@ -3172,21 +3188,21 @@ print_unlock_inbalance_bug(struct task_s
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: bad unlock balance detected! ]\n");
+	lprintk("\n");
+	lprintk("=====================================\n");
+	lprintk("[ BUG: bad unlock balance detected! ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------\n");
-	printk("%s/%d is trying to release lock (",
+	lprintk("-------------------------------------\n");
+	lprintk("%s/%d is trying to release lock (",
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
-	printk(") at:\n");
+	lprintk(") at:\n");
 	print_ip_sym(ip);
-	printk("but there are no more locks to release!\n");
-	printk("\nother info that might help us debug this:\n");
+	lprintk("but there are no more locks to release!\n");
+	lprintk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -3487,11 +3503,11 @@ static void check_flags(unsigned long fl
 
 	if (irqs_disabled_flags(flags)) {
 		if (DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)) {
-			printk("possible reason: unannotated irqs-off.\n");
+			lprintk("possible reason: unannotated irqs-off.\n");
 		}
 	} else {
 		if (DEBUG_LOCKS_WARN_ON(!current->hardirqs_enabled)) {
-			printk("possible reason: unannotated irqs-on.\n");
+			lprintk("possible reason: unannotated irqs-on.\n");
 		}
 	}
 
@@ -3617,21 +3633,21 @@ print_lock_contention_bug(struct task_st
 	if (debug_locks_silent)
 		return 0;
 
-	printk("\n");
-	printk("=================================\n");
-	printk("[ BUG: bad contention detected! ]\n");
+	lprintk("\n");
+	lprintk("=================================\n");
+	lprintk("[ BUG: bad contention detected! ]\n");
 	print_kernel_ident();
-	printk("---------------------------------\n");
-	printk("%s/%d is trying to contend lock (",
+	lprintk("---------------------------------\n");
+	lprintk("%s/%d is trying to contend lock (",
 		curr->comm, task_pid_nr(curr));
 	print_lockdep_cache(lock);
-	printk(") at:\n");
+	lprintk(") at:\n");
 	print_ip_sym(ip);
-	printk("but there are no locks held!\n");
-	printk("\nother info that might help us debug this:\n");
+	lprintk("but there are no locks held!\n");
+	lprintk("\nother info that might help us debug this:\n");
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 
 	return 0;
@@ -3949,17 +3965,17 @@ void lockdep_init(void)
 
 void __init lockdep_info(void)
 {
-	printk("Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar\n");
+	lprintk("Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar\n");
 
-	printk("... MAX_LOCKDEP_SUBCLASSES:  %lu\n", MAX_LOCKDEP_SUBCLASSES);
-	printk("... MAX_LOCK_DEPTH:          %lu\n", MAX_LOCK_DEPTH);
-	printk("... MAX_LOCKDEP_KEYS:        %lu\n", MAX_LOCKDEP_KEYS);
-	printk("... CLASSHASH_SIZE:          %lu\n", CLASSHASH_SIZE);
-	printk("... MAX_LOCKDEP_ENTRIES:     %lu\n", MAX_LOCKDEP_ENTRIES);
-	printk("... MAX_LOCKDEP_CHAINS:      %lu\n", MAX_LOCKDEP_CHAINS);
-	printk("... CHAINHASH_SIZE:          %lu\n", CHAINHASH_SIZE);
+	lprintk("... MAX_LOCKDEP_SUBCLASSES:  %lu\n", MAX_LOCKDEP_SUBCLASSES);
+	lprintk("... MAX_LOCK_DEPTH:          %lu\n", MAX_LOCK_DEPTH);
+	lprintk("... MAX_LOCKDEP_KEYS:        %lu\n", MAX_LOCKDEP_KEYS);
+	lprintk("... CLASSHASH_SIZE:          %lu\n", CLASSHASH_SIZE);
+	lprintk("... MAX_LOCKDEP_ENTRIES:     %lu\n", MAX_LOCKDEP_ENTRIES);
+	lprintk("... MAX_LOCKDEP_CHAINS:      %lu\n", MAX_LOCKDEP_CHAINS);
+	lprintk("... CHAINHASH_SIZE:          %lu\n", CHAINHASH_SIZE);
 
-	printk(" memory used by lock dependency info: %lu kB\n",
+	lprintk(" memory used by lock dependency info: %lu kB\n",
 		(sizeof(struct lock_class) * MAX_LOCKDEP_KEYS +
 		sizeof(struct list_head) * CLASSHASH_SIZE +
 		sizeof(struct lock_list) * MAX_LOCKDEP_ENTRIES +
@@ -3971,14 +3987,14 @@ void __init lockdep_info(void)
 		) / 1024
 		);
 
-	printk(" per task-struct memory footprint: %lu bytes\n",
+	lprintk(" per task-struct memory footprint: %lu bytes\n",
 		sizeof(struct held_lock) * MAX_LOCK_DEPTH);
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	if (lockdep_init_error) {
-		printk("WARNING: lockdep init error! lock-%s was acquired"
+		lprintk("WARNING: lockdep init error! lock-%s was acquired"
 			"before lockdep_init\n", lock_init_error);
-		printk("Call stack leading to lockdep invocation was:\n");
+		lprintk("Call stack leading to lockdep invocation was:\n");
 		print_stack_trace(&lockdep_init_trace, 0);
 	}
 #endif
@@ -3993,17 +4009,17 @@ print_freed_lock_bug(struct task_struct 
 	if (debug_locks_silent)
 		return;
 
-	printk("\n");
-	printk("=========================\n");
-	printk("[ BUG: held lock freed! ]\n");
+	lprintk("\n");
+	lprintk("=========================\n");
+	lprintk("[ BUG: held lock freed! ]\n");
 	print_kernel_ident();
-	printk("-------------------------\n");
-	printk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
+	lprintk("-------------------------\n");
+	lprintk("%s/%d is freeing memory %p-%p, with a lock still held there!\n",
 		curr->comm, task_pid_nr(curr), mem_from, mem_to-1);
 	print_lock(hlock);
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 }
 
@@ -4051,16 +4067,16 @@ static void print_held_locks_bug(struct 
 	if (debug_locks_silent)
 		return;
 
-	printk("\n");
-	printk("=====================================\n");
-	printk("[ BUG: lock held at task exit time! ]\n");
+	lprintk("\n");
+	lprintk("=====================================\n");
+	lprintk("[ BUG: lock held at task exit time! ]\n");
 	print_kernel_ident();
-	printk("-------------------------------------\n");
-	printk("%s/%d is exiting with locks still held!\n",
+	lprintk("-------------------------------------\n");
+	lprintk("%s/%d is exiting with locks still held!\n",
 		curr->comm, task_pid_nr(curr));
 	lockdep_print_held_locks(curr);
 
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 }
 
@@ -4077,10 +4093,10 @@ void debug_show_all_locks(void)
 	int unlock = 1;
 
 	if (unlikely(!debug_locks)) {
-		printk("INFO: lockdep is turned off.\n");
+		lprintk("INFO: lockdep is turned off.\n");
 		return;
 	}
-	printk("\nShowing all locks held in the system:\n");
+	lprintk("\nShowing all locks held in the system:\n");
 
 	/*
 	 * Here we try to get the tasklist_lock as hard as possible,
@@ -4091,18 +4107,18 @@ void debug_show_all_locks(void)
 retry:
 	if (!read_trylock(&tasklist_lock)) {
 		if (count == 10)
-			printk("hm, tasklist_lock locked, retrying... ");
+			lprintk("hm, tasklist_lock locked, retrying... ");
 		if (count) {
 			count--;
-			printk(" #%d", 10-count);
+			lprintk(" #%d", 10-count);
 			mdelay(200);
 			goto retry;
 		}
-		printk(" ignoring it.\n");
+		lprintk(" ignoring it.\n");
 		unlock = 0;
 	} else {
 		if (count != 10)
-			printk(KERN_CONT " locked it.\n");
+			lprintk(KERN_CONT " locked it.\n");
 	}
 
 	do_each_thread(g, p) {
@@ -4120,8 +4136,8 @@ void debug_show_all_locks(void)
 				unlock = 1;
 	} while_each_thread(g, p);
 
-	printk("\n");
-	printk("=============================================\n\n");
+	lprintk("\n");
+	lprintk("=============================================\n\n");
 
 	if (unlock)
 		read_unlock(&tasklist_lock);
@@ -4135,7 +4151,7 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
 void debug_show_held_locks(struct task_struct *task)
 {
 	if (unlikely(!debug_locks)) {
-		printk("INFO: lockdep is turned off.\n");
+		lprintk("INFO: lockdep is turned off.\n");
 		return;
 	}
 	lockdep_print_held_locks(task);
@@ -4149,12 +4165,12 @@ void lockdep_sys_exit(void)
 	if (unlikely(curr->lockdep_depth)) {
 		if (!debug_locks_off())
 			return;
-		printk("\n");
-		printk("================================================\n");
-		printk("[ BUG: lock held when returning to user space! ]\n");
+		lprintk("\n");
+		lprintk("================================================\n");
+		lprintk("[ BUG: lock held when returning to user space! ]\n");
 		print_kernel_ident();
-		printk("------------------------------------------------\n");
-		printk("%s/%d is leaving the kernel with locks still held!\n",
+		lprintk("------------------------------------------------\n");
+		lprintk("%s/%d is leaving the kernel with locks still held!\n",
 				curr->comm, curr->pid);
 		lockdep_print_held_locks(curr);
 	}
@@ -4169,14 +4185,14 @@ void lockdep_rcu_suspicious(const char *
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	/* Note: the following can be executed concurrently, so be careful. */
-	printk("\n");
-	printk("===============================\n");
-	printk("[ INFO: suspicious RCU usage. ]\n");
+	lprintk("\n");
+	lprintk("===============================\n");
+	lprintk("[ INFO: suspicious RCU usage. ]\n");
 	print_kernel_ident();
-	printk("-------------------------------\n");
-	printk("%s:%d %s!\n", file, line, s);
-	printk("\nother info that might help us debug this:\n\n");
-	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
+	lprintk("-------------------------------\n");
+	lprintk("%s:%d %s!\n", file, line, s);
+	lprintk("\nother info that might help us debug this:\n\n");
+	lprintk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
 
 	/*
 	 * If a CPU is in the RCU-free window in idle (ie: in the section
@@ -4197,10 +4213,10 @@ void lockdep_rcu_suspicious(const char *
 	 * rcu_read_lock_bh() and so on from extended quiescent states.
 	 */
 	if (rcu_is_cpu_idle())
-		printk("RCU used illegally from extended quiescent state!\n");
+		lprintk("RCU used illegally from extended quiescent state!\n");
 
 	lockdep_print_held_locks(curr);
-	printk("\nstack backtrace:\n");
+	lprintk("\nstack backtrace:\n");
 	dump_stack();
 }
 EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);


