Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761116Ab2FHPLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:11:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:46034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760491Ab2FHPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:11:37 -0400
Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>
In-Reply-To: <20120608150153.GE1711@redhat.com>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk>
	 <20120606194233.GA1537@redhat.com>
	 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
	 <20120606230040.GA18089@redhat.com>
	 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
	 <1339064814.23343.14.camel@twins>
	 <CA+55aFycTypSSvjOB-KXzpK86ALifGbrO2s4HRc69CqyoX=qJA@mail.gmail.com>
	 <1339140698.23343.26.camel@twins> <20120608143829.GD1711@redhat.com>
	 <1339167065.2507.38.camel@laptop>  <20120608150153.GE1711@redhat.com>
Content-Type: multipart/mixed; boundary="=-qAgdyCjDnqZqSLqlo9cA"
Date: Fri, 08 Jun 2012 17:11:23 +0200
Message-ID: <1339168283.2507.47.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qAgdyCjDnqZqSLqlo9cA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2012-06-08 at 11:01 -0400, Dave Jones wrote:
> gaah, it's quoted-printable damaged. When I save that in mutt, I get a
> file that contains crap like

ok, evolution is no longer able to send plain text..  git can deal with
quoted printable, and I have an awk script to decipher it. Still bloody
annoying though.

Attached now :/



--=-qAgdyCjDnqZqSLqlo9cA
Content-Disposition: attachment; filename*0=peter_zijlstra-re-processes_hung_after_sys_renameat_and__miss; filename*1=ing__processes.patch
Content-Type: text/x-patch; name*0=peter_zijlstra-re-processes_hung_after_sys_renameat_and__missing_; name*1=_processes.patch; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Subject: Re: processes hung after sys_renameat, and 'missing' processes
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 08 Jun 2012 09:31:38 +0200

On Thu, 2012-06-07 at 08:30 -0700, Linus Torvalds wrote:
> On Thu, Jun 7, 2012 at 3:26 AM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > On Wed, 2012-06-06 at 16:31 -0700, Linus Torvalds wrote:
> >> PeterZ - the fact that we use mutex_lock_nested with
> >> I_MUTEX_PARENT/I_MUTEX_CHILD/nothing hopefully doesn't screw us up in
> >> case we get it wrong, right?
> >
> > Sadly, if you get that annotation wrong you can annotate an actual
> > deadlock away. This the reason you have to be very careful when
> > annotating stuff.
>=20
> Is that true even if you can see an actual deadlock on the lock *instance=
s*?

Yep.. :/

> The point of the locking classes (to me) was always that you could see
> the deadlock even if it didn't *actually* happen, just *potentially*
> happened. If the lock classes then mean that that hides an actual
> deadlock information, that's a big downside.

Right, so in order to report a deadlock on instances we'd have to do a
full lock graph walk on every contended lock acquisition. This is quite
expensive.

Although I can look into doing that from say the NMI watchdog and/or
some sysrq key.

> And yeah, that really means that we absolutely *have* to get the
> instance data in the lock debug printout, since we can't see deadlocks
> any other way.=20

Well, typically deadlocks aren't that hard to find once you trigger
them. The current case of course being the exception to that rule..=20

> Can you check the compile error that Dave reported for
> your patch, because right now Dave is running without it, afaik, due
> to your lock-instance patch not really working in practice.

Oh, missed that in the thread.. yeah here goes.


Now also compile tested with CONFIG_LOCK_STAT...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1339140698.23343.26.camel@twins
---
 include/linux/lockdep.h     |   44 ++++++++-------
 include/trace/events/lock.h |    3 -
 kernel/lockdep.c            |  128 ++++++++++++++++++++++++++++----------------
 3 files changed, 107 insertions(+), 68 deletions(-)

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
@@ -363,6 +373,18 @@ extern void lockdep_trace_alloc(gfp_t ma
 
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
 
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -541,10 +541,23 @@ static void print_lockdep_cache(struct l
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
 
@@ -556,7 +569,7 @@ static void lockdep_print_held_locks(str
 		printk("no locks held by %s/%d.\n", curr->comm, task_pid_nr(curr));
 		return;
 	}
-	printk("%d lock%s held by %s/%d:\n",
+	printk("%d lock%s on stack by %s/%d:\n",
 		depth, depth > 1 ? "s" : "", curr->comm, task_pid_nr(curr));
 
 	for (i = 0; i < depth; i++) {
@@ -3093,6 +3106,7 @@ static int __lock_acquire(struct lockdep
 	hlock->check = check;
 	hlock->hardirqs_off = !!hardirqs_off;
 	hlock->references = references;
+	hlock->state = hls_acquiring;
 #ifdef CONFIG_LOCK_STAT
 	hlock->waittime_stamp = 0;
 	hlock->holdtime_stamp = lockstat_clock();
@@ -3607,7 +3621,6 @@ void lockdep_clear_current_reclaim_state
 	current->lockdep_reclaim_gfp = 0;
 }
 
-#ifdef CONFIG_LOCK_STAT
 static int
 print_lock_contention_bug(struct task_struct *curr, struct lockdep_map *lock,
 			   unsigned long ip)
@@ -3637,14 +3650,73 @@ print_lock_contention_bug(struct task_st
 	return 0;
 }
 
+#ifdef CONFIG_LOCK_STAT
+
+static void lockstat_contended(struct held_lock *hlock, unsigned long ip)
+{
+	struct lockdep_map *lock = hlock->instance;
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
+static void lockstat_acquired(struct held_lock *hlock, unsigned long ip)
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
+static inline void lockstat_contended(struct held_lock *hlock, unsigned long ip) { }
+static inline void lockstat_acquired(struct held_lock *hlock, unsigned long ip) { }
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
@@ -3673,20 +3745,8 @@ __lock_contended(struct lockdep_map *loc
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
+	lockstat_contended(hlock, ip);
 }
 
 static void
@@ -3694,10 +3754,8 @@ __lock_acquired(struct lockdep_map *lock
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
@@ -3726,28 +3784,8 @@ __lock_acquired(struct lockdep_map *lock
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
+	lockstat_acquired(hlock, ip);
 }
 
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
@@ -3783,12 +3821,12 @@ void lock_acquired(struct lockdep_map *l
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


--=-qAgdyCjDnqZqSLqlo9cA--

