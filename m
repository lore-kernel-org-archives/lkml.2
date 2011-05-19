Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531Ab1ESUJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:09:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41231 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933926Ab1ESUJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:09:34 -0400
Date: Thu, 19 May 2011 22:09:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v2.6.40
Message-ID: <20110519200924.GA6105@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-locking-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-locking-for-linus

 Thanks,

	Ingo

------------------>
Jeff Mahoney (1):
      watchdog, hung_task_timeout: Add Kconfig configurable default

Milton Miller (1):
      seqlock: Don't smp_rmb in seqlock reader spin loop

Steven Rostedt (7):
      lockdep: Print a nicer description for irq lock inversions
      lockdep: Print a nicer description for normal deadlocks
      lockdep: Print a nicer description for simple deadlocks
      lockdep: Print a nicer description for irq inversion bugs
      lockdep: Replace "Bad BFS generated tree" message with something less cryptic
      lockdep: Print a nicer description for simple irq lock inversions
      lockdep: Remove cmpxchg to update nr_chain_hlocks


 include/linux/seqlock.h |    4 +-
 kernel/hung_task.c      |    2 +-
 kernel/lockdep.c        |  206 ++++++++++++++++++++++++++++++++++++++++++++---
 lib/Kconfig.debug       |   15 ++++
 4 files changed, 213 insertions(+), 14 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e98cd2e..06d6964 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -88,12 +88,12 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 	unsigned ret;
 
 repeat:
-	ret = sl->sequence;
-	smp_rmb();
+	ret = ACCESS_ONCE(sl->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
 	}
+	smp_rmb();
 
 	return ret;
 }
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 53ead17..ea64012 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -33,7 +33,7 @@ unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
 /*
  * Zero means infinite timeout - no checking done:
  */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 53a6895..63437d0 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -490,6 +490,18 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
 	usage[i] = '\0';
 }
 
+static int __print_lock_name(struct lock_class *class)
+{
+	char str[KSYM_NAME_LEN];
+	const char *name;
+
+	name = class->name;
+	if (!name)
+		name = __get_key_name(class->key, str);
+
+	return printk("%s", name);
+}
+
 static void print_lock_name(struct lock_class *class)
 {
 	char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
@@ -1053,6 +1065,56 @@ print_circular_bug_entry(struct lock_list *target, int depth)
 	return 0;
 }
 
+static void
+print_circular_lock_scenario(struct held_lock *src,
+			     struct held_lock *tgt,
+			     struct lock_list *prt)
+{
+	struct lock_class *source = hlock_class(src);
+	struct lock_class *target = hlock_class(tgt);
+	struct lock_class *parent = prt->class;
+
+	/*
+	 * A direct locking problem where unsafe_class lock is taken
+	 * directly by safe_class lock, then all we need to show
+	 * is the deadlock scenario, as it is obvious that the
+	 * unsafe lock is taken under the safe lock.
+	 *
+	 * But if there is a chain instead, where the safe lock takes
+	 * an intermediate lock (middle_class) where this lock is
+	 * not the same as the safe lock, then the lock chain is
+	 * used to describe the problem. Otherwise we would need
+	 * to show a different CPU case for each link in the chain
+	 * from the safe_class lock to the unsafe_class lock.
+	 */
+	if (parent != source) {
+		printk("Chain exists of:\n  ");
+		__print_lock_name(source);
+		printk(" --> ");
+		__print_lock_name(parent);
+		printk(" --> ");
+		__print_lock_name(target);
+		printk("\n\n");
+	}
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0                    CPU1\n");
+	printk("       ----                    ----\n");
+	printk("  lock(");
+	__print_lock_name(target);
+	printk(");\n");
+	printk("                               lock(");
+	__print_lock_name(parent);
+	printk(");\n");
+	printk("                               lock(");
+	__print_lock_name(target);
+	printk(");\n");
+	printk("  lock(");
+	__print_lock_name(source);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 /*
  * When a circular dependency is detected, print the
  * header first:
@@ -1096,6 +1158,7 @@ static noinline int print_circular_bug(struct lock_list *this,
 {
 	struct task_struct *curr = current;
 	struct lock_list *parent;
+	struct lock_list *first_parent;
 	int depth;
 
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
@@ -1109,6 +1172,7 @@ static noinline int print_circular_bug(struct lock_list *this,
 	print_circular_bug_header(target, depth, check_src, check_tgt);
 
 	parent = get_lock_parent(target);
+	first_parent = parent;
 
 	while (parent) {
 		print_circular_bug_entry(parent, --depth);
@@ -1116,6 +1180,9 @@ static noinline int print_circular_bug(struct lock_list *this,
 	}
 
 	printk("\nother info that might help us debug this:\n\n");
+	print_circular_lock_scenario(check_src, check_tgt,
+				     first_parent);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
@@ -1314,7 +1381,7 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 		printk("\n");
 
 		if (depth == 0 && (entry != root)) {
-			printk("lockdep:%s bad BFS generated tree\n", __func__);
+			printk("lockdep:%s bad path found in chain graph\n", __func__);
 			break;
 		}
 
@@ -1325,6 +1392,62 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
 	return;
 }
 
+static void
+print_irq_lock_scenario(struct lock_list *safe_entry,
+			struct lock_list *unsafe_entry,
+			struct lock_class *prev_class,
+			struct lock_class *next_class)
+{
+	struct lock_class *safe_class = safe_entry->class;
+	struct lock_class *unsafe_class = unsafe_entry->class;
+	struct lock_class *middle_class = prev_class;
+
+	if (middle_class == safe_class)
+		middle_class = next_class;
+
+	/*
+	 * A direct locking problem where unsafe_class lock is taken
+	 * directly by safe_class lock, then all we need to show
+	 * is the deadlock scenario, as it is obvious that the
+	 * unsafe lock is taken under the safe lock.
+	 *
+	 * But if there is a chain instead, where the safe lock takes
+	 * an intermediate lock (middle_class) where this lock is
+	 * not the same as the safe lock, then the lock chain is
+	 * used to describe the problem. Otherwise we would need
+	 * to show a different CPU case for each link in the chain
+	 * from the safe_class lock to the unsafe_class lock.
+	 */
+	if (middle_class != unsafe_class) {
+		printk("Chain exists of:\n  ");
+		__print_lock_name(safe_class);
+		printk(" --> ");
+		__print_lock_name(middle_class);
+		printk(" --> ");
+		__print_lock_name(unsafe_class);
+		printk("\n\n");
+	}
+
+	printk(" Possible interrupt unsafe locking scenario:\n\n");
+	printk("       CPU0                    CPU1\n");
+	printk("       ----                    ----\n");
+	printk("  lock(");
+	__print_lock_name(unsafe_class);
+	printk(");\n");
+	printk("                               local_irq_disable();\n");
+	printk("                               lock(");
+	__print_lock_name(safe_class);
+	printk(");\n");
+	printk("                               lock(");
+	__print_lock_name(middle_class);
+	printk(");\n");
+	printk("  <Interrupt>\n");
+	printk("    lock(");
+	__print_lock_name(safe_class);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 static int
 print_bad_irq_dependency(struct task_struct *curr,
 			 struct lock_list *prev_root,
@@ -1376,6 +1499,9 @@ print_bad_irq_dependency(struct task_struct *curr,
 	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	printk("\nother info that might help us debug this:\n\n");
+	print_irq_lock_scenario(backwards_entry, forwards_entry,
+				hlock_class(prev), hlock_class(next));
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe dependencies between %s-irq-safe lock", irqclass);
@@ -1539,6 +1665,26 @@ static inline void inc_chains(void)
 
 #endif
 
+static void
+print_deadlock_scenario(struct held_lock *nxt,
+			     struct held_lock *prv)
+{
+	struct lock_class *next = hlock_class(nxt);
+	struct lock_class *prev = hlock_class(prv);
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0\n");
+	printk("       ----\n");
+	printk("  lock(");
+	__print_lock_name(prev);
+	printk(");\n");
+	printk("  lock(");
+	__print_lock_name(next);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+	printk(" May be due to missing lock nesting notation\n\n");
+}
+
 static int
 print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 		   struct held_lock *next)
@@ -1557,6 +1703,7 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
 	print_lock(prev);
 
 	printk("\nother info that might help us debug this:\n");
+	print_deadlock_scenario(next, prev);
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
@@ -1826,7 +1973,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	struct list_head *hash_head = chainhashentry(chain_key);
 	struct lock_chain *chain;
 	struct held_lock *hlock_curr, *hlock_next;
-	int i, j, n, cn;
+	int i, j;
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
@@ -1886,15 +2033,9 @@ cache_hit:
 	}
 	i++;
 	chain->depth = curr->lockdep_depth + 1 - i;
-	cn = nr_chain_hlocks;
-	while (cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS) {
-		n = cmpxchg(&nr_chain_hlocks, cn, cn + chain->depth);
-		if (n == cn)
-			break;
-		cn = n;
-	}
-	if (likely(cn + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
-		chain->base = cn;
+	if (likely(nr_chain_hlocks + chain->depth <= MAX_LOCKDEP_CHAIN_HLOCKS)) {
+		chain->base = nr_chain_hlocks;
+		nr_chain_hlocks += chain->depth;
 		for (j = 0; j < chain->depth - 1; j++, i++) {
 			int lock_id = curr->held_locks[i].class_idx - 1;
 			chain_hlocks[chain->base + j] = lock_id;
@@ -2011,6 +2152,24 @@ static void check_chain_key(struct task_struct *curr)
 #endif
 }
 
+static void
+print_usage_bug_scenario(struct held_lock *lock)
+{
+	struct lock_class *class = hlock_class(lock);
+
+	printk(" Possible unsafe locking scenario:\n\n");
+	printk("       CPU0\n");
+	printk("       ----\n");
+	printk("  lock(");
+	__print_lock_name(class);
+	printk(");\n");
+	printk("  <Interrupt>\n");
+	printk("    lock(");
+	__print_lock_name(class);
+	printk(");\n");
+	printk("\n *** DEADLOCK ***\n\n");
+}
+
 static int
 print_usage_bug(struct task_struct *curr, struct held_lock *this,
 		enum lock_usage_bit prev_bit, enum lock_usage_bit new_bit)
@@ -2039,6 +2198,8 @@ print_usage_bug(struct task_struct *curr, struct held_lock *this,
 
 	print_irqtrace_events(curr);
 	printk("\nother info that might help us debug this:\n");
+	print_usage_bug_scenario(this);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nstack backtrace:\n");
@@ -2073,6 +2234,10 @@ print_irq_inversion_bug(struct task_struct *curr,
 			struct held_lock *this, int forwards,
 			const char *irqclass)
 {
+	struct lock_list *entry = other;
+	struct lock_list *middle = NULL;
+	int depth;
+
 	if (!debug_locks_off_graph_unlock() || debug_locks_silent)
 		return 0;
 
@@ -2091,6 +2256,25 @@ print_irq_inversion_bug(struct task_struct *curr,
 	printk("\n\nand interrupts could create inverse lock ordering between them.\n\n");
 
 	printk("\nother info that might help us debug this:\n");
+
+	/* Find a middle lock (if one exists) */
+	depth = get_lock_depth(other);
+	do {
+		if (depth == 0 && (entry != root)) {
+			printk("lockdep:%s bad path found in chain graph\n", __func__);
+			break;
+		}
+		middle = entry;
+		entry = get_lock_parent(entry);
+		depth--;
+	} while (entry && entry != root && (depth >= 0));
+	if (forwards)
+		print_irq_lock_scenario(root, other,
+			middle ? middle->class : root->class, other->class);
+	else
+		print_irq_lock_scenario(other, root,
+			middle ? middle->class : other->class, root->class);
+
 	lockdep_print_held_locks(curr);
 
 	printk("\nthe shortest dependencies between 2nd lock and 1st lock:\n");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..debbb05 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -238,6 +238,21 @@ config DETECT_HUNG_TASK
 	  enabled then all held locks will also be reported. This
 	  feature has negligible overhead.
 
+config DEFAULT_HUNG_TASK_TIMEOUT
+	int "Default timeout for hung task detection (in seconds)"
+	depends on DETECT_HUNG_TASK
+	default 120
+	help
+	  This option controls the default timeout (in seconds) used
+	  to determine when a task has become non-responsive and should
+	  be considered hung.
+
+	  It can be adjusted at runtime via the kernel.hung_task_timeout
+	  sysctl or by writing a value to /proc/sys/kernel/hung_task_timeout.
+
+	  A timeout of 0 disables the check.  The default is two minutes.
+	  Keeping the default should be fine in most cases.
+
 config BOOTPARAM_HUNG_TASK_PANIC
 	bool "Panic (Reboot) On Hung Tasks"
 	depends on DETECT_HUNG_TASK
