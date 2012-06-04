Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab2FDKuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:50:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54663 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab2FDKuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:50:00 -0400
Message-ID: <1338806988.28282.17.camel@twins>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, mingo@kernel.org
Date: Mon, 04 Jun 2012 12:49:48 +0200
In-Reply-To: <1338802157.28282.7.camel@twins>
References: <20120603223617.GB7707@redhat.com>
	 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
	 <20120604000059.GA14144@redhat.com>
	 <CA+55aFwJO40594yLH0gS_7YurDGAojVYfgBQXLNawraV_jdNsQ@mail.gmail.com>
	 <1338802157.28282.7.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 11:29 +0200, Peter Zijlstra wrote:
> On Sun, 2012-06-03 at 17:16 -0700, Linus Torvalds wrote:
> > On Sun, Jun 3, 2012 at 5:00 PM, Dave Jones <davej@redhat.com> wrote:
> > >
> > > sysrq-d: http://fpaste.org/ow9O/
> > 
> > Ugh. I'm adding PeterZ to the cc, just to see if he can make more sense of it.
> > 
> > Peter, is there no way to make the lock thing print not just the lock
> > class name, but also the pointer to the actual *instance* of the lock
> > held?
> 
> Sorta, we have a pointer to the struct lockdep_map inside whatever lock
> type. But we don't have the lock type so we cannot actually provide the
> pointer to the spinlock_t struct mutex etc..
> 
> > Also, it's a bit unclear to me, but I *think* that most of those users
> > don't actually "hold" the lock - they are waiting for it. Yes/no?
> 
> Yes, this is waiting to acquire, lockdep started out with 2 hooks, one
> before the actual acquire and one on release. Its done before the actual
> acquire so we can warn before we lock up in case of an actual deadlock.
> 
> >  Does
> > the lockdep information have the capability to distinguish between
> > "waiting for" vs "actually successfully owns the lock"?
> 
> Sometimes.. when build with lockstat we have enough hooks to do this. I
> suppose I could make all those hooks available for all of lockdep and
> track the per lock state more accurate in order to improve this
> printout.


Something like the compile tested only patch below should do both
things. It will however make that already long output line longer still.


[19247.688328] 1 lock held by agetty/509:
[19247.689732]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff813c12f0>] n_tty_read+0x5d0/0x8a0

Will become something like:

19247.688328] 1 lock on stack by agetty/509:
[19247.689732]  #0: blocked: (&tty->atomic_read_lock){+.+.+.}, instance: ffffffffffffffff, at: [<ffffffff813c12f0>] n_tty_read+0x5d0/0x8a0

where instance is clearly a saner number :-)

---
 include/linux/lockdep.h     |   44 ++++++++-------
 include/trace/events/lock.h |    3 -
 kernel/lockdep.c            |  127 ++++++++++++++++++++++++++++---------------
 3 files changed, 106 insertions(+), 68 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 00e4637..7a989a8 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -211,6 +211,13 @@ struct lock_chain {
  */
 #define MAX_LOCKDEP_KEYS		((1UL << MAX_LOCKDEP_KEYS_BITS) - 1)
 
+enum held_lock_state {
+	hls_unheld = 0,
+	hls_acquiring,
+	hls_contended,
+	hls_acquired,
+};
+
 struct held_lock {
 	/*
 	 * One-way hash of the dependency chain up to this point. We
@@ -254,7 +261,10 @@ struct held_lock {
 	unsigned int read:2;        /* see lock_acquire() comment */
 	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
-	unsigned int references:11;					/* 32 bits */
+	unsigned int state:2;	    /* see held_lock_state */
+									/* 9 bit hole */
+	unsigned int references:16;
+									/* 16 bit hole */
 };
 
 /*
@@ -363,6 +373,18 @@ extern void lockdep_trace_alloc(gfp_t mask);
 
 #define lockdep_recursing(tsk)	((tsk)->lockdep_recursion)
 
+extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
+extern void lock_acquired(struct lockdep_map *lock, unsigned long ip);
+
+#define LOCK_CONTENDED(_lock, try, lock)			\
+do {								\
+	if (!try(_lock)) {					\
+		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
+		lock(_lock);					\
+	}							\
+	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
+} while (0)
+
 #else /* !LOCKDEP */
 
 static inline void lockdep_off(void)
@@ -414,31 +436,13 @@ struct lock_class_key { };
 
 #define lockdep_recursing(tsk)			(0)
 
-#endif /* !LOCKDEP */
-
-#ifdef CONFIG_LOCK_STAT
-
-extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
-extern void lock_acquired(struct lockdep_map *lock, unsigned long ip);
-
-#define LOCK_CONTENDED(_lock, try, lock)			\
-do {								\
-	if (!try(_lock)) {					\
-		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
-		lock(_lock);					\
-	}							\
-	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
-} while (0)
-
-#else /* CONFIG_LOCK_STAT */
-
 #define lock_contended(lockdep_map, ip) do {} while (0)
 #define lock_acquired(lockdep_map, ip) do {} while (0)
 
 #define LOCK_CONTENDED(_lock, try, lock) \
 	lock(_lock)
 
-#endif /* CONFIG_LOCK_STAT */
+#endif /* !LOCKDEP */
 
 #ifdef CONFIG_LOCKDEP
 
diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 2821b86..dbcb2f5 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -61,8 +61,6 @@ DEFINE_EVENT(lock, lock_release,
 	TP_ARGS(lock, ip)
 );
 
-#ifdef CONFIG_LOCK_STAT
-
 DEFINE_EVENT(lock, lock_contended,
 
 	TP_PROTO(struct lockdep_map *lock, unsigned long ip),
@@ -78,7 +76,6 @@ DEFINE_EVENT(lock, lock_acquired,
 );
 
 #endif
-#endif
 
 #endif /* _TRACE_LOCK_H */
 
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index ea9ee45..81ae879 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -541,10 +541,23 @@ static void print_lockdep_cache(struct lockdep_map *lock)
 	printk("%s", name);
 }
 
+static void print_lock_state(struct held_lock *hlock)
+{
+	switch (hlock->state) {
+	/* holding an unheld lock is fail!  */
+	case hls_unheld:	printk("FAIL:    "); break;
+
+	case hls_acquiring:	/* fall-through */
+	case hls_contended:	printk("blocked: "); break;
+	case hls_acquired:	printk("held:    "); break;
+	};
+}
+
 static void print_lock(struct held_lock *hlock)
 {
+	print_lock_state(hlock);
 	print_lock_name(hlock_class(hlock));
-	printk(", at: ");
+	printk(", instance: %p, at: ", hlock->instance);
 	print_ip_sym(hlock->acquire_ip);
 }
 
@@ -556,7 +569,7 @@ static void lockdep_print_held_locks(struct task_struct *curr)
 		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
 		return;
 	}
-	printk("%d lock%s held by %s/%d:\n",
+	printk("%d lock%s on stack by %s/%d:\n",
 		depth, depth > 1 ? "s" : "", curr->comm, task_pid_nr(curr));
 
 	for (i = 0; i < depth; i++) {
@@ -3093,6 +3106,7 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
 	hlock->references = references;
+	hlock->state = hls_acquiring;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = lockstat_clock();
@@ -3607,7 +3621,6 @@ void lockdep_clear_current_reclaim_state(void)
 	current->lockdep_reclaim_gfp = 0;
 }
 
-#ifdef CONFIG_LOCK_STAT
 static int
 print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
@@ -3637,14 +3650,72 @@ print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 	return 0;
 }
 
+#ifdef CONFIG_LOCK_STAT
+
+static void lockstat_contended(struct held_lock *hlock)
+{
+	int contention_point, contending_point;
+	struct lock_class_stats *stats;
+
+	hlock->waittime_stamp = lockstat_clock();
+
+	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
+	contending_point = lock_point(hlock_class(hlock)->contending_point,
+				      lock->ip);
+
+	stats = get_lock_stats(hlock_class(hlock));
+	if (contention_point < LOCKSTAT_POINTS)
+		stats->contention_point[contention_point]++;
+	if (contending_point < LOCKSTAT_POINTS)
+		stats->contending_point[contending_point]++;
+	if (lock->cpu != smp_processor_id())
+		stats->bounces[bounce_contended + !!hlock->read]++;
+	put_lock_stats(stats);
+}
+
+static void lockstat_acquired(struct held_lock *hlock)
+{
+	struct lockdep_map *lock = hlock->instance;
+	struct lock_class_stats *stats;
+	u64 now, waittime = 0;
+	int cpu;
+
+	cpu = smp_processor_id();
+	if (hlock->waittime_stamp) {
+		now = lockstat_clock();
+		waittime = now - hlock->waittime_stamp;
+		hlock->holdtime_stamp = now;
+	}
+
+	stats = get_lock_stats(hlock_class(hlock));
+	if (waittime) {
+		if (hlock->read)
+			lock_time_inc(&stats->read_waittime, waittime);
+		else
+			lock_time_inc(&stats->write_waittime, waittime);
+	}
+	if (lock->cpu != cpu)
+		stats->bounces[bounce_acquired + !!hlock->read]++;
+	put_lock_stats(stats);
+
+	lock->cpu = cpu;
+	lock->ip = ip;
+}
+
+#else /* CONFIG_LOCK_STAT */
+
+static inline void lockstat_contended(struct held_lock *hlock) { }
+static inline void lockstat_acquired(struct held_lock *hlock) { }
+
+#endif /* CONFIG_LOCK_STAT */
+
 static void
 __lock_contended(struct lockdep_map *lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
-	struct lock_class_stats *stats;
 	unsigned int depth;
-	int i, contention_point, contending_point;
+	int i;
 
 	depth = curr->lockdep_depth;
 	/*
@@ -3673,20 +3744,8 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 	if (hlock->instance != lock)
 		return;
 
-	hlock->waittime_stamp = lockstat_clock();
-
-	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
-	contending_point = lock_point(hlock_class(hlock)->contending_point,
-				      lock->ip);
-
-	stats = get_lock_stats(hlock_class(hlock));
-	if (contention_point < LOCKSTAT_POINTS)
-		stats->contention_point[contention_point]++;
-	if (contending_point < LOCKSTAT_POINTS)
-		stats->contending_point[contending_point]++;
-	if (lock->cpu != smp_processor_id())
-		stats->bounces[bounce_contended + !!hlock->read]++;
-	put_lock_stats(stats);
+	hlock->state = hls_contended;
+	lockstat_contended(hlock);
 }
 
 static void
@@ -3694,10 +3753,8 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
-	struct lock_class_stats *stats;
 	unsigned int depth;
-	u64 now, waittime = 0;
-	int i, cpu;
+	int i;
 
 	depth = curr->lockdep_depth;
 	/*
@@ -3726,28 +3783,8 @@ __lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	if (hlock->instance != lock)
 		return;
 
-	cpu = smp_processor_id();
-	if (hlock->waittime_stamp) {
-		now = lockstat_clock();
-		waittime = now - hlock->waittime_stamp;
-		hlock->holdtime_stamp = now;
-	}
-
-	trace_lock_acquired(lock, ip);
-
-	stats = get_lock_stats(hlock_class(hlock));
-	if (waittime) {
-		if (hlock->read)
-			lock_time_inc(&stats->read_waittime, waittime);
-		else
-			lock_time_inc(&stats->write_waittime, waittime);
-	}
-	if (lock->cpu != cpu)
-		stats->bounces[bounce_acquired + !!hlock->read]++;
-	put_lock_stats(stats);
-
-	lock->cpu = cpu;
-	lock->ip = ip;
+	hlock->state = hls_acquired;
+	lockstat_acquired(hlock);
 }
 
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
@@ -3783,12 +3820,12 @@ void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
+	trace_lock_acquired(lock, ip);
 	__lock_acquired(lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(lock_acquired);
-#endif
 
 /*
  * Used by the testsuite, sanitize the validator state

