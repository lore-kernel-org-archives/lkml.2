Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab0IHNEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:04:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741Ab0IHNEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:04:30 -0400
Date: Wed, 8 Sep 2010 15:04:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] core kernel fixes
Message-ID: <20100908130404.GA6165@elte.hu>
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

Please pull the latest core-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      gcc-4.6: kernel/*: Fix unused but set warnings

Paul E. McKenney (2):
      MAINTAINERS: Add RCU's public git tree
      pid: make setpgid() system call use RCU read-side critical section

Randy Dunlap (1):
      mutex: Fix annotations to include it in kernel-locking docbook


 Documentation/DocBook/kernel-locking.tmpl |    6 ++++++
 Documentation/mutex-design.txt            |    3 ++-
 MAINTAINERS                               |    2 ++
 include/linux/mutex.h                     |    8 ++++++++
 kernel/debug/kdb/kdb_bp.c                 |    2 --
 kernel/hrtimer.c                          |    3 +--
 kernel/mutex.c                            |   23 +++++++----------------
 kernel/sched_fair.c                       |    3 +--
 kernel/sys.c                              |    2 ++
 kernel/sysctl.c                           |    5 +----
 kernel/trace/ring_buffer.c                |    2 --
 11 files changed, 30 insertions(+), 29 deletions(-)

diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 0b1a3f9..a0d479d 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1961,6 +1961,12 @@ machines due to caching.
    </sect1>
   </chapter>
 
+  <chapter id="apiref">
+   <title>Mutex API reference</title>
+!Iinclude/linux/mutex.h
+!Ekernel/mutex.c
+  </chapter>
+
   <chapter id="references">
    <title>Further reading</title>
 
diff --git a/Documentation/mutex-design.txt b/Documentation/mutex-design.txt
index c91ccc0..38c10fd 100644
--- a/Documentation/mutex-design.txt
+++ b/Documentation/mutex-design.txt
@@ -9,7 +9,7 @@ firstly, there's nothing wrong with semaphores. But if the simpler
 mutex semantics are sufficient for your code, then there are a couple
 of advantages of mutexes:
 
- - 'struct mutex' is smaller on most architectures: .e.g on x86,
+ - 'struct mutex' is smaller on most architectures: E.g. on x86,
    'struct semaphore' is 20 bytes, 'struct mutex' is 16 bytes.
    A smaller structure size means less RAM footprint, and better
    CPU-cache utilization.
@@ -136,3 +136,4 @@ the APIs of 'struct mutex' have been streamlined:
  void mutex_lock_nested(struct mutex *lock, unsigned int subclass);
  int  mutex_lock_interruptible_nested(struct mutex *lock,
                                       unsigned int subclass);
+ int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
diff --git a/MAINTAINERS b/MAINTAINERS
index 5fa8451..614861a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4799,6 +4799,7 @@ RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 S:	Supported
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4823,6 +4824,7 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
 F:	Documentation/RCU/
 F:	include/linux/rcu*
 F:	include/linux/srcu*
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 878cab4..f363bc8 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -78,6 +78,14 @@ struct mutex_waiter {
 # include <linux/mutex-debug.h>
 #else
 # define __DEBUG_MUTEX_INITIALIZER(lockname)
+/**
+ * mutex_init - initialize the mutex
+ * @mutex: the mutex to be initialized
+ *
+ * Initialize the mutex to unlocked state.
+ *
+ * It is not allowed to initialize an already locked mutex.
+ */
 # define mutex_init(mutex) \
 do {							\
 	static struct lock_class_key __key;		\
diff --git a/kernel/debug/kdb/kdb_bp.c b/kernel/debug/kdb/kdb_bp.c
index 75bd9b3..20059ef 100644
--- a/kernel/debug/kdb/kdb_bp.c
+++ b/kernel/debug/kdb/kdb_bp.c
@@ -274,7 +274,6 @@ static int kdb_bp(int argc, const char **argv)
 	int i, bpno;
 	kdb_bp_t *bp, *bp_check;
 	int diag;
-	int free;
 	char *symname = NULL;
 	long offset = 0ul;
 	int nextarg;
@@ -305,7 +304,6 @@ static int kdb_bp(int argc, const char **argv)
 	/*
 	 * Find an empty bp structure to allocate
 	 */
-	free = KDB_MAXBPT;
 	for (bpno = 0, bp = kdb_breakpoints; bpno < KDB_MAXBPT; bpno++, bp++) {
 		if (bp->bp_free)
 			break;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ce66917..1decafb 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1091,11 +1091,10 @@ EXPORT_SYMBOL_GPL(hrtimer_cancel);
  */
 ktime_t hrtimer_get_remaining(const struct hrtimer *timer)
 {
-	struct hrtimer_clock_base *base;
 	unsigned long flags;
 	ktime_t rem;
 
-	base = lock_hrtimer_base(timer, &flags);
+	lock_hrtimer_base(timer, &flags);
 	rem = hrtimer_expires_remaining(timer);
 	unlock_hrtimer_base(timer, &flags);
 
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 4c0b7b3..200407c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -36,15 +36,6 @@
 # include <asm/mutex.h>
 #endif
 
-/***
- * mutex_init - initialize the mutex
- * @lock: the mutex to be initialized
- * @key: the lock_class_key for the class; used by mutex lock debugging
- *
- * Initialize the mutex to unlocked state.
- *
- * It is not allowed to initialize an already locked mutex.
- */
 void
 __mutex_init(struct mutex *lock, const char *name, struct lock_class_key *key)
 {
@@ -68,7 +59,7 @@ EXPORT_SYMBOL(__mutex_init);
 static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
-/***
+/**
  * mutex_lock - acquire the mutex
  * @lock: the mutex to be acquired
  *
@@ -105,7 +96,7 @@ EXPORT_SYMBOL(mutex_lock);
 
 static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
-/***
+/**
  * mutex_unlock - release the mutex
  * @lock: the mutex to be released
  *
@@ -364,8 +355,8 @@ __mutex_lock_killable_slowpath(atomic_t *lock_count);
 static noinline int __sched
 __mutex_lock_interruptible_slowpath(atomic_t *lock_count);
 
-/***
- * mutex_lock_interruptible - acquire the mutex, interruptable
+/**
+ * mutex_lock_interruptible - acquire the mutex, interruptible
  * @lock: the mutex to be acquired
  *
  * Lock the mutex like mutex_lock(), and return 0 if the mutex has
@@ -456,15 +447,15 @@ static inline int __mutex_trylock_slowpath(atomic_t *lock_count)
 	return prev == 1;
 }
 
-/***
- * mutex_trylock - try acquire the mutex, without waiting
+/**
+ * mutex_trylock - try to acquire the mutex, without waiting
  * @lock: the mutex to be acquired
  *
  * Try to acquire the mutex atomically. Returns 1 if the mutex
  * has been acquired successfully, and 0 on contention.
  *
  * NOTE: this function follows the spin_trylock() convention, so
- * it is negated to the down_trylock() return values! Be careful
+ * it is negated from the down_trylock() return values! Be careful
  * about this when converting semaphore users to mutexes.
  *
  * This function must not be used in interrupt context. The
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ab661eb..134f7ed 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1313,7 +1313,7 @@ static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 		  int this_cpu, int load_idx)
 {
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *idlest = NULL, *group = sd->groups;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
 
@@ -1348,7 +1348,6 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
 
 		if (local_group) {
 			this_load = avg_load;
-			this = group;
 		} else if (avg_load < min_load) {
 			min_load = avg_load;
 			idlest = group;
diff --git a/kernel/sys.c b/kernel/sys.c
index e9ad444..7f5a0cd 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -931,6 +931,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 		pgid = pid;
 	if (pgid < 0)
 		return -EINVAL;
+	rcu_read_lock();
 
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
@@ -984,6 +985,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
 	write_unlock_irq(&tasklist_lock);
+	rcu_read_unlock();
 	return err;
 }
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ca38e8e..f88552c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1713,10 +1713,7 @@ static __init int sysctl_init(void)
 {
 	sysctl_set_parent(NULL, root_table);
 #ifdef CONFIG_SYSCTL_SYSCALL_CHECK
-	{
-		int err;
-		err = sysctl_check_table(current->nsproxy, root_table);
-	}
+	sysctl_check_table(current->nsproxy, root_table);
 #endif
 	return 0;
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 19cccc3..492197e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2985,13 +2985,11 @@ static void rb_advance_reader(struct ring_buffer_per_cpu *cpu_buffer)
 
 static void rb_advance_iter(struct ring_buffer_iter *iter)
 {
-	struct ring_buffer *buffer;
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct ring_buffer_event *event;
 	unsigned length;
 
 	cpu_buffer = iter->cpu_buffer;
-	buffer = cpu_buffer->buffer;
 
 	/*
 	 * Check if we are at the end of the buffer.
