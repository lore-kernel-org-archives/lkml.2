Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab0EQV3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:29:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448Ab0EQV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:28:58 -0400
Date: Mon, 17 May 2010 23:28:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/locking changes for v2.6.35
Message-ID: <20100517212848.GA28536@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
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
Frederic Weisbecker (6):
      lockstat: Make lockstat counting per cpu
      lockdep: Fix redundant_hardirqs_on incremented with irqs enabled
      lockdep: Simplify debug atomic ops
      lockdep: Provide off case for redundant_hardirqs_on increment
      lockdep: Actually _dec_ in debug_atomic_dec
      lockdep: No need to disable preemption in debug atomic ops

Thomas Gleixner (1):
      i8253: Convert i8253_lock to raw_spinlock

Tony Breeds (1):
      mutex: Fix optimistic spinning vs. BKL

Yong Zhang (1):
      lockdep: Reduce stack_trace usage


 arch/mips/include/asm/i8253.h     |    2 +-
 arch/mips/kernel/i8253.c          |   14 +++---
 arch/x86/include/asm/i8253.h      |    2 +-
 arch/x86/kernel/apm_32.c          |    4 +-
 arch/x86/kernel/i8253.c           |   14 +++---
 drivers/block/hd.c                |    4 +-
 drivers/input/gameport/gameport.c |    4 +-
 drivers/input/joystick/analog.c   |    4 +-
 drivers/input/misc/pcspkr.c       |    6 +-
 include/linux/sched.h             |    3 +-
 kernel/lockdep.c                  |   81 +++++++++++++++++++-----------------
 kernel/lockdep_internals.h        |   72 +++++++++++++++++++++++----------
 kernel/lockdep_proc.c             |   58 +++++++++++++-------------
 kernel/mutex.c                    |   12 +++++-
 kernel/sched.c                    |    5 +-
 sound/drivers/pcsp/pcsp.h         |    2 +-
 sound/drivers/pcsp/pcsp_input.c   |    4 +-
 sound/drivers/pcsp/pcsp_lib.c     |   12 +++---
 18 files changed, 174 insertions(+), 129 deletions(-)

diff --git a/arch/mips/include/asm/i8253.h b/arch/mips/include/asm/i8253.h
index 032ca73..48bb823 100644
--- a/arch/mips/include/asm/i8253.h
+++ b/arch/mips/include/asm/i8253.h
@@ -12,7 +12,7 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-extern spinlock_t i8253_lock;
+extern raw_spinlock_t i8253_lock;
 
 extern void setup_pit_timer(void);
 
diff --git a/arch/mips/kernel/i8253.c b/arch/mips/kernel/i8253.c
index ed5c441..9479406 100644
--- a/arch/mips/kernel/i8253.c
+++ b/arch/mips/kernel/i8253.c
@@ -15,7 +15,7 @@
 #include <asm/io.h>
 #include <asm/time.h>
 
-DEFINE_SPINLOCK(i8253_lock);
+DEFINE_RAW_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
 /*
@@ -26,7 +26,7 @@ EXPORT_SYMBOL(i8253_lock);
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 
 	switch(mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -55,7 +55,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
@@ -65,10 +65,10 @@ static void init_pit_timer(enum clock_event_mode mode,
  */
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	outb_p(delta & 0xff , PIT_CH0);	/* LSB */
 	outb(delta >> 8 , PIT_CH0);	/* MSB */
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 
 	return 0;
 }
@@ -137,7 +137,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	static int old_count;
 	static u32 old_jifs;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
@@ -183,7 +183,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	old_count = count;
 	old_jifs = jifs;
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	count = (LATCH - 1) - count;
 
diff --git a/arch/x86/include/asm/i8253.h b/arch/x86/include/asm/i8253.h
index 1edbf89..fc1f579 100644
--- a/arch/x86/include/asm/i8253.h
+++ b/arch/x86/include/asm/i8253.h
@@ -6,7 +6,7 @@
 #define PIT_CH0			0x40
 #define PIT_CH2			0x42
 
-extern spinlock_t i8253_lock;
+extern raw_spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 031aa88..c4f9182 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -1224,7 +1224,7 @@ static void reinit_timer(void)
 #ifdef INIT_TIMER_AFTER_SUSPEND
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/* set the clock to HZ */
 	outb_pit(0x34, PIT_MODE);		/* binary, mode 2, LSB/MSB, ch 0 */
 	udelay(10);
@@ -1232,7 +1232,7 @@ static void reinit_timer(void)
 	udelay(10);
 	outb_pit(LATCH >> 8, PIT_CH0);	/* MSB */
 	udelay(10);
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 #endif
 }
 
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index 23c1679..2dfd315 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -16,7 +16,7 @@
 #include <asm/hpet.h>
 #include <asm/smp.h>
 
-DEFINE_SPINLOCK(i8253_lock);
+DEFINE_RAW_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
 /*
@@ -33,7 +33,7 @@ struct clock_event_device *global_clock_event;
 static void init_pit_timer(enum clock_event_mode mode,
 			   struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
@@ -62,7 +62,7 @@ static void init_pit_timer(enum clock_event_mode mode,
 		/* Nothing to do here */
 		break;
 	}
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
@@ -72,10 +72,10 @@ static void init_pit_timer(enum clock_event_mode mode,
  */
 static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
 {
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	outb_pit(delta & 0xff , PIT_CH0);	/* LSB */
 	outb_pit(delta >> 8 , PIT_CH0);		/* MSB */
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 
 	return 0;
 }
@@ -130,7 +130,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	int count;
 	u32 jifs;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	/*
 	 * Although our caller may have the read side of xtime_lock,
 	 * this is now a seqlock, and we are cheating in this routine
@@ -176,7 +176,7 @@ static cycle_t pit_read(struct clocksource *cs)
 	old_count = count;
 	old_jifs = jifs;
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	count = (LATCH - 1) - count;
 
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 034e6df..81c78b3 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -164,12 +164,12 @@ unsigned long read_timer(void)
 	unsigned long t, flags;
 	int i;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	t = jiffies * 11932;
 	outb_p(0, 0x43);
 	i = inb_p(0x40);
 	i |= inb(0x40) << 8;
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 	return(t - i);
 }
 #endif
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 7e18bcf..46239e4 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -59,11 +59,11 @@ static unsigned int get_time_pit(void)
 	unsigned long flags;
 	unsigned int count;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 	outb_p(0x00, 0x43);
 	count = inb_p(0x40);
 	count |= inb_p(0x40) << 8;
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return count;
 }
diff --git a/drivers/input/joystick/analog.c b/drivers/input/joystick/analog.c
index 1c0b529..4afe0a3 100644
--- a/drivers/input/joystick/analog.c
+++ b/drivers/input/joystick/analog.c
@@ -146,11 +146,11 @@ static unsigned int get_time_pit(void)
         unsigned long flags;
         unsigned int count;
 
-        spin_lock_irqsave(&i8253_lock, flags);
+        raw_spin_lock_irqsave(&i8253_lock, flags);
         outb_p(0x00, 0x43);
         count = inb_p(0x40);
         count |= inb_p(0x40) << 8;
-        spin_unlock_irqrestore(&i8253_lock, flags);
+        raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
         return count;
 }
diff --git a/drivers/input/misc/pcspkr.c b/drivers/input/misc/pcspkr.c
index ea4e1fd..f080dd3 100644
--- a/drivers/input/misc/pcspkr.c
+++ b/drivers/input/misc/pcspkr.c
@@ -30,7 +30,7 @@ MODULE_ALIAS("platform:pcspkr");
 #include <asm/i8253.h>
 #else
 #include <asm/8253pit.h>
-static DEFINE_SPINLOCK(i8253_lock);
+static DEFINE_RAW_SPINLOCK(i8253_lock);
 #endif
 
 static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int code, int value)
@@ -50,7 +50,7 @@ static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int c
 	if (value > 20 && value < 32767)
 		count = PIT_TICK_RATE / value;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* set command for counter 2, 2 byte write */
@@ -65,7 +65,7 @@ static int pcspkr_event(struct input_dev *dev, unsigned int type, unsigned int c
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 
 	return 0;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..bc6bd9a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -361,7 +361,8 @@ extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
+			       unsigned long timeout);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 2594e1c..5108080 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -431,20 +431,7 @@ static struct stack_trace lockdep_init_trace = {
 /*
  * Various lockdep statistics:
  */
-atomic_t chain_lookup_hits;
-atomic_t chain_lookup_misses;
-atomic_t hardirqs_on_events;
-atomic_t hardirqs_off_events;
-atomic_t redundant_hardirqs_on;
-atomic_t redundant_hardirqs_off;
-atomic_t softirqs_on_events;
-atomic_t softirqs_off_events;
-atomic_t redundant_softirqs_on;
-atomic_t redundant_softirqs_off;
-atomic_t nr_unused_locks;
-atomic_t nr_cyclic_checks;
-atomic_t nr_find_usage_forwards_checks;
-atomic_t nr_find_usage_backwards_checks;
+DEFINE_PER_CPU(struct lockdep_stats, lockdep_stats);
 #endif
 
 /*
@@ -748,7 +735,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		return NULL;
 	}
 	class = lock_classes + nr_lock_classes++;
-	debug_atomic_inc(&nr_unused_locks);
+	debug_atomic_inc(nr_unused_locks);
 	class->key = key;
 	class->name = lock->name;
 	class->subclass = subclass;
@@ -818,7 +805,8 @@ static struct lock_list *alloc_list_entry(void)
  * Add a new dependency to the head of the list:
  */
 static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
-			    struct list_head *head, unsigned long ip, int distance)
+			    struct list_head *head, unsigned long ip,
+			    int distance, struct stack_trace *trace)
 {
 	struct lock_list *entry;
 	/*
@@ -829,11 +817,9 @@ static int add_lock_to_list(struct lock_class *class, struct lock_class *this,
 	if (!entry)
 		return 0;
 
-	if (!save_trace(&entry->trace))
-		return 0;
-
 	entry->class = this;
 	entry->distance = distance;
+	entry->trace = *trace;
 	/*
 	 * Since we never remove from the dependency list, the list can
 	 * be walked lockless by other CPUs, it's only allocation
@@ -1205,7 +1191,7 @@ check_noncircular(struct lock_list *root, struct lock_class *target,
 {
 	int result;
 
-	debug_atomic_inc(&nr_cyclic_checks);
+	debug_atomic_inc(nr_cyclic_checks);
 
 	result = __bfs_forwards(root, target, class_equal, target_entry);
 
@@ -1242,7 +1228,7 @@ find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
 {
 	int result;
 
-	debug_atomic_inc(&nr_find_usage_forwards_checks);
+	debug_atomic_inc(nr_find_usage_forwards_checks);
 
 	result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
 
@@ -1265,7 +1251,7 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 {
 	int result;
 
-	debug_atomic_inc(&nr_find_usage_backwards_checks);
+	debug_atomic_inc(nr_find_usage_backwards_checks);
 
 	result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
 
@@ -1635,12 +1621,20 @@ check_deadlock(struct task_struct *curr, struct held_lock *next,
  */
 static int
 check_prev_add(struct task_struct *curr, struct held_lock *prev,
-	       struct held_lock *next, int distance)
+	       struct held_lock *next, int distance, int trylock_loop)
 {
 	struct lock_list *entry;
 	int ret;
 	struct lock_list this;
 	struct lock_list *uninitialized_var(target_entry);
+	/*
+	 * Static variable, serialized by the graph_lock().
+	 *
+	 * We use this static variable to save the stack trace in case
+	 * we call into this function multiple times due to encountering
+	 * trylocks in the held lock stack.
+	 */
+	static struct stack_trace trace;
 
 	/*
 	 * Prove that the new <prev> -> <next> dependency would not
@@ -1688,20 +1682,23 @@ check_prev_add(struct task_struct *curr, struct held_lock *prev,
 		}
 	}
 
+	if (!trylock_loop && !save_trace(&trace))
+		return 0;
+
 	/*
 	 * Ok, all validations passed, add the new lock
 	 * to the previous lock's dependency list:
 	 */
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
 			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, &trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
 			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance);
+			       next->acquire_ip, distance, &trace);
 	if (!ret)
 		return 0;
 
@@ -1731,6 +1728,7 @@ static int
 check_prevs_add(struct task_struct *curr, struct held_lock *next)
 {
 	int depth = curr->lockdep_depth;
+	int trylock_loop = 0;
 	struct held_lock *hlock;
 
 	/*
@@ -1756,7 +1754,8 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		 * added:
 		 */
 		if (hlock->read != 2) {
-			if (!check_prev_add(curr, hlock, next, distance))
+			if (!check_prev_add(curr, hlock, next,
+						distance, trylock_loop))
 				return 0;
 			/*
 			 * Stop after the first non-trylock entry,
@@ -1779,6 +1778,7 @@ check_prevs_add(struct task_struct *curr, struct held_lock *next)
 		if (curr->held_locks[depth].irq_context !=
 				curr->held_locks[depth-1].irq_context)
 			break;
+		trylock_loop = 1;
 	}
 	return 1;
 out_bug:
@@ -1825,7 +1825,7 @@ static inline int lookup_chain_cache(struct task_struct *curr,
 	list_for_each_entry(chain, hash_head, entry) {
 		if (chain->chain_key == chain_key) {
 cache_hit:
-			debug_atomic_inc(&chain_lookup_hits);
+			debug_atomic_inc(chain_lookup_hits);
 			if (very_verbose(class))
 				printk("\nhash chain already cached, key: "
 					"%016Lx tail class: [%p] %s\n",
@@ -1890,7 +1890,7 @@ cache_hit:
 		chain_hlocks[chain->base + j] = class - lock_classes;
 	}
 	list_add_tail_rcu(&chain->entry, hash_head);
-	debug_atomic_inc(&chain_lookup_misses);
+	debug_atomic_inc(chain_lookup_misses);
 	inc_chains();
 
 	return 1;
@@ -2311,7 +2311,12 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
-		debug_atomic_inc(&redundant_hardirqs_on);
+		/*
+		 * Neither irq nor preemption are disabled here
+		 * so this is racy by nature but loosing one hit
+		 * in a stat is not a big deal.
+		 */
+		__debug_atomic_inc(redundant_hardirqs_on);
 		return;
 	}
 	/* we'll do an OFF -> ON transition: */
@@ -2338,7 +2343,7 @@ void trace_hardirqs_on_caller(unsigned long ip)
 
 	curr->hardirq_enable_ip = ip;
 	curr->hardirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(&hardirqs_on_events);
+	debug_atomic_inc(hardirqs_on_events);
 }
 EXPORT_SYMBOL(trace_hardirqs_on_caller);
 
@@ -2370,9 +2375,9 @@ void trace_hardirqs_off_caller(unsigned long ip)
 		curr->hardirqs_enabled = 0;
 		curr->hardirq_disable_ip = ip;
 		curr->hardirq_disable_event = ++curr->irq_events;
-		debug_atomic_inc(&hardirqs_off_events);
+		debug_atomic_inc(hardirqs_off_events);
 	} else
-		debug_atomic_inc(&redundant_hardirqs_off);
+		debug_atomic_inc(redundant_hardirqs_off);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 
@@ -2396,7 +2401,7 @@ void trace_softirqs_on(unsigned long ip)
 		return;
 
 	if (curr->softirqs_enabled) {
-		debug_atomic_inc(&redundant_softirqs_on);
+		debug_atomic_inc(redundant_softirqs_on);
 		return;
 	}
 
@@ -2406,7 +2411,7 @@ void trace_softirqs_on(unsigned long ip)
 	curr->softirqs_enabled = 1;
 	curr->softirq_enable_ip = ip;
 	curr->softirq_enable_event = ++curr->irq_events;
-	debug_atomic_inc(&softirqs_on_events);
+	debug_atomic_inc(softirqs_on_events);
 	/*
 	 * We are going to turn softirqs on, so set the
 	 * usage bit for all held locks, if hardirqs are
@@ -2436,10 +2441,10 @@ void trace_softirqs_off(unsigned long ip)
 		curr->softirqs_enabled = 0;
 		curr->softirq_disable_ip = ip;
 		curr->softirq_disable_event = ++curr->irq_events;
-		debug_atomic_inc(&softirqs_off_events);
+		debug_atomic_inc(softirqs_off_events);
 		DEBUG_LOCKS_WARN_ON(!softirq_count());
 	} else
-		debug_atomic_inc(&redundant_softirqs_off);
+		debug_atomic_inc(redundant_softirqs_off);
 }
 
 static void __lockdep_trace_alloc(gfp_t gfp_mask, unsigned long flags)
@@ -2644,7 +2649,7 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 			return 0;
 		break;
 	case LOCK_USED:
-		debug_atomic_dec(&nr_unused_locks);
+		debug_atomic_dec(nr_unused_locks);
 		break;
 	default:
 		if (!debug_locks_off_graph_unlock())
@@ -2750,7 +2755,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 		if (!class)
 			return 0;
 	}
-	debug_atomic_inc((atomic_t *)&class->ops);
+	atomic_inc((atomic_t *)&class->ops);
 	if (very_verbose(class)) {
 		printk("\nacquire class [%p] %s", class->key, class->name);
 		if (class->name_version > 1)
diff --git a/kernel/lockdep_internals.h b/kernel/lockdep_internals.h
index a2ee95a..4f560cf 100644
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -110,30 +110,60 @@ lockdep_count_backward_deps(struct lock_class *class)
 #endif
 
 #ifdef CONFIG_DEBUG_LOCKDEP
+
+#include <asm/local.h>
 /*
- * Various lockdep statistics:
+ * Various lockdep statistics.
+ * We want them per cpu as they are often accessed in fast path
+ * and we want to avoid too much cache bouncing.
  */
-extern atomic_t chain_lookup_hits;
-extern atomic_t chain_lookup_misses;
-extern atomic_t hardirqs_on_events;
-extern atomic_t hardirqs_off_events;
-extern atomic_t redundant_hardirqs_on;
-extern atomic_t redundant_hardirqs_off;
-extern atomic_t softirqs_on_events;
-extern atomic_t softirqs_off_events;
-extern atomic_t redundant_softirqs_on;
-extern atomic_t redundant_softirqs_off;
-extern atomic_t nr_unused_locks;
-extern atomic_t nr_cyclic_checks;
-extern atomic_t nr_cyclic_check_recursions;
-extern atomic_t nr_find_usage_forwards_checks;
-extern atomic_t nr_find_usage_forwards_recursions;
-extern atomic_t nr_find_usage_backwards_checks;
-extern atomic_t nr_find_usage_backwards_recursions;
-# define debug_atomic_inc(ptr)		atomic_inc(ptr)
-# define debug_atomic_dec(ptr)		atomic_dec(ptr)
-# define debug_atomic_read(ptr)		atomic_read(ptr)
+struct lockdep_stats {
+	int	chain_lookup_hits;
+	int	chain_lookup_misses;
+	int	hardirqs_on_events;
+	int	hardirqs_off_events;
+	int	redundant_hardirqs_on;
+	int	redundant_hardirqs_off;
+	int	softirqs_on_events;
+	int	softirqs_off_events;
+	int	redundant_softirqs_on;
+	int	redundant_softirqs_off;
+	int	nr_unused_locks;
+	int	nr_cyclic_checks;
+	int	nr_cyclic_check_recursions;
+	int	nr_find_usage_forwards_checks;
+	int	nr_find_usage_forwards_recursions;
+	int	nr_find_usage_backwards_checks;
+	int	nr_find_usage_backwards_recursions;
+};
+
+DECLARE_PER_CPU(struct lockdep_stats, lockdep_stats);
+
+#define __debug_atomic_inc(ptr)					\
+	this_cpu_inc(lockdep_stats.ptr);
+
+#define debug_atomic_inc(ptr)			{		\
+	WARN_ON_ONCE(!irqs_disabled());				\
+	__this_cpu_inc(lockdep_stats.ptr);			\
+}
+
+#define debug_atomic_dec(ptr)			{		\
+	WARN_ON_ONCE(!irqs_disabled());				\
+	__this_cpu_dec(lockdep_stats.ptr);			\
+}
+
+#define debug_atomic_read(ptr)		({				\
+	struct lockdep_stats *__cpu_lockdep_stats;			\
+	unsigned long long __total = 0;					\
+	int __cpu;							\
+	for_each_possible_cpu(__cpu) {					\
+		__cpu_lockdep_stats = &per_cpu(lockdep_stats, __cpu);	\
+		__total += __cpu_lockdep_stats->ptr;			\
+	}								\
+	__total;							\
+})
 #else
+# define __debug_atomic_inc(ptr)	do { } while (0)
 # define debug_atomic_inc(ptr)		do { } while (0)
 # define debug_atomic_dec(ptr)		do { } while (0)
 # define debug_atomic_read(ptr)		0
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index d4aba4f..59b76c8 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -184,34 +184,34 @@ static const struct file_operations proc_lockdep_chains_operations = {
 static void lockdep_stats_debug_show(struct seq_file *m)
 {
 #ifdef CONFIG_DEBUG_LOCKDEP
-	unsigned int hi1 = debug_atomic_read(&hardirqs_on_events),
-		     hi2 = debug_atomic_read(&hardirqs_off_events),
-		     hr1 = debug_atomic_read(&redundant_hardirqs_on),
-		     hr2 = debug_atomic_read(&redundant_hardirqs_off),
-		     si1 = debug_atomic_read(&softirqs_on_events),
-		     si2 = debug_atomic_read(&softirqs_off_events),
-		     sr1 = debug_atomic_read(&redundant_softirqs_on),
-		     sr2 = debug_atomic_read(&redundant_softirqs_off);
-
-	seq_printf(m, " chain lookup misses:           %11u\n",
-		debug_atomic_read(&chain_lookup_misses));
-	seq_printf(m, " chain lookup hits:             %11u\n",
-		debug_atomic_read(&chain_lookup_hits));
-	seq_printf(m, " cyclic checks:                 %11u\n",
-		debug_atomic_read(&nr_cyclic_checks));
-	seq_printf(m, " find-mask forwards checks:     %11u\n",
-		debug_atomic_read(&nr_find_usage_forwards_checks));
-	seq_printf(m, " find-mask backwards checks:    %11u\n",
-		debug_atomic_read(&nr_find_usage_backwards_checks));
-
-	seq_printf(m, " hardirq on events:             %11u\n", hi1);
-	seq_printf(m, " hardirq off events:            %11u\n", hi2);
-	seq_printf(m, " redundant hardirq ons:         %11u\n", hr1);
-	seq_printf(m, " redundant hardirq offs:        %11u\n", hr2);
-	seq_printf(m, " softirq on events:             %11u\n", si1);
-	seq_printf(m, " softirq off events:            %11u\n", si2);
-	seq_printf(m, " redundant softirq ons:         %11u\n", sr1);
-	seq_printf(m, " redundant softirq offs:        %11u\n", sr2);
+	unsigned long long hi1 = debug_atomic_read(hardirqs_on_events),
+			   hi2 = debug_atomic_read(hardirqs_off_events),
+			   hr1 = debug_atomic_read(redundant_hardirqs_on),
+			   hr2 = debug_atomic_read(redundant_hardirqs_off),
+			   si1 = debug_atomic_read(softirqs_on_events),
+			   si2 = debug_atomic_read(softirqs_off_events),
+			   sr1 = debug_atomic_read(redundant_softirqs_on),
+			   sr2 = debug_atomic_read(redundant_softirqs_off);
+
+	seq_printf(m, " chain lookup misses:           %11llu\n",
+		debug_atomic_read(chain_lookup_misses));
+	seq_printf(m, " chain lookup hits:             %11llu\n",
+		debug_atomic_read(chain_lookup_hits));
+	seq_printf(m, " cyclic checks:                 %11llu\n",
+		debug_atomic_read(nr_cyclic_checks));
+	seq_printf(m, " find-mask forwards checks:     %11llu\n",
+		debug_atomic_read(nr_find_usage_forwards_checks));
+	seq_printf(m, " find-mask backwards checks:    %11llu\n",
+		debug_atomic_read(nr_find_usage_backwards_checks));
+
+	seq_printf(m, " hardirq on events:             %11llu\n", hi1);
+	seq_printf(m, " hardirq off events:            %11llu\n", hi2);
+	seq_printf(m, " redundant hardirq ons:         %11llu\n", hr1);
+	seq_printf(m, " redundant hardirq offs:        %11llu\n", hr2);
+	seq_printf(m, " softirq on events:             %11llu\n", si1);
+	seq_printf(m, " softirq off events:            %11llu\n", si2);
+	seq_printf(m, " redundant softirq ons:         %11llu\n", sr1);
+	seq_printf(m, " redundant softirq offs:        %11llu\n", sr2);
 #endif
 }
 
@@ -263,7 +263,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 #endif
 	}
 #ifdef CONFIG_DEBUG_LOCKDEP
-	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
+	DEBUG_LOCKS_WARN_ON(debug_atomic_read(nr_unused_locks) != nr_unused);
 #endif
 	seq_printf(m, " lock-classes:                  %11lu [max: %lu]\n",
 			nr_lock_classes, MAX_LOCKDEP_KEYS);
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 632f04c..7d4626b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -145,6 +145,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	struct task_struct *task = current;
 	struct mutex_waiter waiter;
 	unsigned long flags;
+	unsigned long timeout;
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
@@ -168,15 +169,22 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 * to serialize everything.
 	 */
 
-	for (;;) {
+	for (timeout = jiffies + 2; time_before(jiffies, timeout);) {
 		struct thread_info *owner;
 
 		/*
+		 * If we own the BKL, then don't spin. The owner of the mutex
+		 * might be waiting on us to release the BKL.
+		 */
+		if (current->lock_depth >= 0)
+			break;
+
+		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
 		owner = ACCESS_ONCE(lock->owner);
-		if (owner && !mutex_spin_on_owner(lock, owner))
+		if (owner && !mutex_spin_on_owner(lock, owner, timeout))
 			break;
 
 		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c2a54f..e613160 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3775,7 +3775,8 @@ EXPORT_SYMBOL(schedule);
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
  */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner,
+			unsigned long timeout)
 {
 	unsigned int cpu;
 	struct rq *rq;
@@ -3811,7 +3812,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 
 	rq = cpu_rq(cpu);
 
-	for (;;) {
+	while (time_before(jiffies, timeout)) {
 		/*
 		 * Owner changed, break to re-assess state.
 		 */
diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
index 1e12307..4ff6c8c 100644
--- a/sound/drivers/pcsp/pcsp.h
+++ b/sound/drivers/pcsp/pcsp.h
@@ -16,7 +16,7 @@
 #include <asm/i8253.h>
 #else
 #include <asm/8253pit.h>
-static DEFINE_SPINLOCK(i8253_lock);
+static DEFINE_RAW_SPINLOCK(i8253_lock);
 #endif
 
 #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */
diff --git a/sound/drivers/pcsp/pcsp_input.c b/sound/drivers/pcsp/pcsp_input.c
index 0444cde..b5e2b54 100644
--- a/sound/drivers/pcsp/pcsp_input.c
+++ b/sound/drivers/pcsp/pcsp_input.c
@@ -21,7 +21,7 @@ static void pcspkr_do_sound(unsigned int count)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&i8253_lock, flags);
+	raw_spin_lock_irqsave(&i8253_lock, flags);
 
 	if (count) {
 		/* set command for counter 2, 2 byte write */
@@ -36,7 +36,7 @@ static void pcspkr_do_sound(unsigned int count)
 		outb(inb_p(0x61) & 0xFC, 0x61);
 	}
 
-	spin_unlock_irqrestore(&i8253_lock, flags);
+	raw_spin_unlock_irqrestore(&i8253_lock, flags);
 }
 
 void pcspkr_stop_sound(void)
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index d77ffa9..ce9e7d1 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -66,7 +66,7 @@ static u64 pcsp_timer_update(struct snd_pcsp *chip)
 	timer_cnt = val * CUR_DIV() / 256;
 
 	if (timer_cnt && chip->enable) {
-		spin_lock_irqsave(&i8253_lock, flags);
+		raw_spin_lock_irqsave(&i8253_lock, flags);
 		if (!nforce_wa) {
 			outb_p(chip->val61, 0x61);
 			outb_p(timer_cnt, 0x42);
@@ -75,7 +75,7 @@ static u64 pcsp_timer_update(struct snd_pcsp *chip)
 			outb(chip->val61 ^ 2, 0x61);
 			chip->thalf = 1;
 		}
-		spin_unlock_irqrestore(&i8253_lock, flags);
+		raw_spin_unlock_irqrestore(&i8253_lock, flags);
 	}
 
 	chip->ns_rem = PCSP_PERIOD_NS();
@@ -159,10 +159,10 @@ static int pcsp_start_playing(struct snd_pcsp *chip)
 		return -EIO;
 	}
 
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	chip->val61 = inb(0x61) | 0x03;
 	outb_p(0x92, 0x43);	/* binary, mode 1, LSB only, ch 2 */
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 	atomic_set(&chip->timer_active, 1);
 	chip->thalf = 0;
 
@@ -179,11 +179,11 @@ static void pcsp_stop_playing(struct snd_pcsp *chip)
 		return;
 
 	atomic_set(&chip->timer_active, 0);
-	spin_lock(&i8253_lock);
+	raw_spin_lock(&i8253_lock);
 	/* restore the timer */
 	outb_p(0xb6, 0x43);	/* binary, mode 3, LSB/MSB, ch 2 */
 	outb(chip->val61 & 0xFC, 0x61);
-	spin_unlock(&i8253_lock);
+	raw_spin_unlock(&i8253_lock);
 }
 
 /*
