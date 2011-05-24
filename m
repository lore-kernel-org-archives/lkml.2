Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1EXPnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:43:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41415 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1EXPnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:43:00 -0400
Date: Tue, 24 May 2011 08:42:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110524154238.GB2266@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306189249.15900.10.camel@t41.thuisdomein>
 <4DDB7D36.60905@fusionio.com>
 <20110524143527.GA2266@linux.vnet.ibm.com>
 <4DDBC600.1000200@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDBC600.1000200@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 04:51:44PM +0200, Jens Axboe wrote:
> On 2011-05-24 16:35, Paul E. McKenney wrote:
> > On Tue, May 24, 2011 at 11:41:10AM +0200, Jens Axboe wrote:
> >> On 2011-05-24 00:20, Paul Bolle wrote:
> >>> On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
> >>>> Running under CONFIG_PREEMPT=y (along with CONFIG_TREE_PREEMPT_RCU=y)
> >>>> could be very helpful in and of itself.  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> >>>> can also be helpful.  In post-2.6.39 mainline, it should be possible
> >>>> to set CONFIG_DEBUG_OBJECTS_RCU_HEAD=y without CONFIG_PREEMPT=y, but
> >>>> again, CONFIG_PREEMPT=y can help find problems.
> >>>
> >>> 0) The first thing I tried (from your suggestions) was
> >>> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y. Given its dependencies (and, well, the
> >>> build system I used) I ended up with:
> >>>
> >>>     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local3.fc16.i686 |
> >>>     grep -v "^#"
> >>>     CONFIG_TREE_PREEMPT_RCU=y
> >>>     CONFIG_PREEMPT_RCU=y
> >>>     CONFIG_RCU_FANOUT=32
> >>>     CONFIG_PREEMPT_NOTIFIERS=y
> >>>     CONFIG_PREEMPT=y
> >>>     CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> >>>     CONFIG_DEBUG_PREEMPT=y
> >>>     CONFIG_PROVE_RCU=y
> >>>     CONFIG_SPARSE_RCU_POINTER=y
> >>>
> >>> It looks like I am unable to trigger the issue we're talking about here
> >>> when using that config.
> >>>
> >>> 1) For reference, the config of a kernel that does trigger it had:
> >>>
> >>>     $ grep -e PREEMPT -e RCU /boot/config-2.6.39-0.local2.fc16.i686 |
> >>>     grep -v "^#"
> >>>     CONFIG_TREE_RCU=y
> >>>     CONFIG_RCU_FANOUT=32
> >>>     CONFIG_RCU_FAST_NO_HZ=y
> >>>     CONFIG_PREEMPT_NOTIFIERS=y
> >>>     CONFIG_PREEMPT_VOLUNTARY=y
> >>>     CONFIG_PROVE_RCU=y
> >>>     CONFIG_SPARSE_RCU_POINTER=y
> >>>
> >>>>> Again CONFIG_TREE_PREEMPT_RCU is available only if PREEMPT=y. So should
> >>>>> we enable preemtion and CONFIG_TREE_PREEMPT_RCU=y and try to reproduce
> >>>>> the issue?
> >>>>
> >>>> Please!
> >>>
> >>> 2) It appears I can't reproduce with those options enabled (see above).
> >>>
> >>>> Polling is fine.  Please see attached for a script to poll at 15-second
> >>>> intervals.  Please also feel free to adjust, just tell me what you
> >>>> adjusted.
> >>>
> >>> And should I now try to run that script on a config that triggers this
> >>> issue (such as the config under 1) above)?
> >>
> >> Paul, can we see a dmesg from your running system? Perhaps there's some
> >> dependency on a particular driver or device that makes this easier to
> >> reproduce.
> > 
> > Here you go, please see attached.
> > 
> > I should have some additional diagnostics later today Pacific time.
> 
> Heh sorry, _other_ Paul :-)

;-)

> You are not seeing this issue, are you?

No, I am not.

> As per your earlier comment on sleeping under rcu_read_lock(), I checked
> everything again and it seems sane. Would that not trigger an
> immediately schedule-while-atomic in any case, regardless of RCU config?

This used to be the case, but not anymore.  Hence my additional
diagnostics.

The way that this used to happen is that CONFIG_PREEMPT=y and
CONFIG_TREE_RCU=y would disable preemption across RCU read-side sections.
Then you would see schedule-while-atomic.

However, I recently changed the config setup so that CONFIG_PREEMPT=y
and CONFIG_SMP=y forces CONFIG_TREE_PREEMPT_RCU=y, which avoids that
diagnostic.  So does CONFIG_SMP=n and CONFIG_TREE_RCU=y, in which case
preemption is always disabled, so there is no way for the scheduler to
see that there was anything atomic going on.

So I am adding a similar diagnostic under CONFIG_PROVE_RCU.

Rather embarrassing -- I totally missed the fact that this diagnostic
would be lost.  :-/

Please see below for a sneak preview of the diagnostic patch.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Restore checks for blocking in RCU read-side critical sections

Long ago, using TREE_RCU with PREEMPT would result in "scheduling
while atomic" diagnostics if you blocked in an RCU read-side critical
section.  However, PREEMPT now implies TREE_PREEMPT_RCU, which defeats
this diagnostic.  This commit therefore adds a replacement diagnostic
based on PROVE_RCU.

Because rcu_lockdep_assert() and lockdep_rcu_dereference() are now being
used for things that have nothing to do with rcu_dereference(), rename
lockdep_rcu_dereference() to lockdep_rcu_suspicious() and add a third
argument that is a string indicating what is suspicious.  This third
argument is passed in from a new third argument to rcu_lockdep_assert().
Update all calls to rcu_lockdep_assert() to add an informative third
argument.

Finally, add a pair of rcu_lockdep_assert() calls from within
rcu_note_context_switch(), one complaining if a context switch occurs
in an RCU-bh read-side critical section and another complaining if a
context switch occurs in an RCU-sched read-side critical section.
These are present only if the PROVE_RCU kernel parameter is enabled.

Again, you must enable PROVE_RCU to see these new diagnostics.  But you
are enabling PROVE_RCU to check out new RCU uses in any case, aren't you?

Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 4aef1dd..bfa66e7 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -545,7 +545,7 @@ do {									\
 #endif
 
 #ifdef CONFIG_PROVE_RCU
-extern void lockdep_rcu_dereference(const char *file, const int line);
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s);
 #endif
 
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 58b13f1..fb2933d 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -297,19 +297,20 @@ extern int rcu_my_thread_group_empty(void);
 /**
  * rcu_lockdep_assert - emit lockdep splat if specified condition not met
  * @c: condition to check
+ * @s: informative message
  */
-#define rcu_lockdep_assert(c)						\
+#define rcu_lockdep_assert(c, s)					\
 	do {								\
 		static bool __warned;					\
 		if (debug_lockdep_rcu_enabled() && !__warned && !(c)) {	\
 			__warned = true;				\
-			lockdep_rcu_dereference(__FILE__, __LINE__);	\
+			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
 	} while (0)
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define rcu_lockdep_assert(c) do { } while (0)
+#define rcu_lockdep_assert(c, s) do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
 
@@ -338,14 +339,16 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_check(p, c, space) \
 	({ \
 		typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_check()" \
+				      " usage"); \
 		rcu_dereference_sparse(p, space); \
 		smp_read_barrier_depends(); \
 		((typeof(*p) __force __kernel *)(_________p1)); \
 	})
 #define __rcu_dereference_protected(p, c, space) \
 	({ \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, "suspicious rcu_dereference_protected()" \
+				      " usage"); \
 		rcu_dereference_sparse(p, space); \
 		((typeof(*p) __force __kernel *)(p)); \
 	})
@@ -359,7 +362,9 @@ extern int rcu_my_thread_group_empty(void);
 #define __rcu_dereference_index_check(p, c) \
 	({ \
 		typeof(p) _________p1 = ACCESS_ONCE(p); \
-		rcu_lockdep_assert(c); \
+		rcu_lockdep_assert(c, \
+				   "suspicious rcu_dereference_index_check()" \
+				   " usage"); \
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 53a6895..f3e05c1 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3798,7 +3798,7 @@ void lockdep_sys_exit(void)
 	}
 }
 
-void lockdep_rcu_dereference(const char *file, const int line)
+void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
 {
 	struct task_struct *curr = current;
 
@@ -3807,9 +3807,10 @@ void lockdep_rcu_dereference(const char *file, const int line)
 		return;
 #endif /* #ifdef CONFIG_PROVE_RCU_REPEATEDLY */
 	/* Note: the following can be executed concurrently, so be careful. */
-	printk("\n===================================================\n");
-	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
-	printk(  "---------------------------------------------------\n");
+	printk("\n===============================\n");
+	printk(  "[ INFO: suspicious RCU usage. ]\n");
+	printk(  "-------------------------------\n");
+	printk(  "%s\n", s);
 	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
 			file, line);
 	printk("\nother info that might help us debug this:\n\n");
diff --git a/kernel/pid.c b/kernel/pid.c
index 57a8346..a7577b3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -419,7 +419,9 @@ EXPORT_SYMBOL(pid_task);
  */
 struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
 {
-	rcu_lockdep_assert(rcu_read_lock_held());
+	rcu_lockdep_assert(rcu_read_lock_held(),
+			   "find_task_by_pid_ns() needs rcu_read_lock()"
+			   " protection");
 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
 }
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b2868ea..ec851db 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -153,6 +153,12 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_note_context_switch(int cpu)
 {
+	rcu_lockdep_assert(!rcu_read_lock_bh_held(),
+			   "Illegal context switch in RCU-bh"
+			   " read-side critical section");
+	rcu_lockdep_assert(!rcu_read_lock_sched_held(),
+			   "Illegal context switch in RCU-sched"
+			   " read-side critical section");
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
@@ -1675,11 +1681,15 @@ static int rcu_node_kthread(void *arg)
 
 	for (;;) {
 		rnp->node_kthread_status = RCU_KTHREAD_WAITING;
+		printk(KERN_INFO "rcun %p starting wait for work.\n", rnp);
 		rcu_wait(atomic_read(&rnp->wakemask) != 0);
+		printk(KERN_INFO "rcun %p completed wait for work.\n", rnp);
 		rnp->node_kthread_status = RCU_KTHREAD_RUNNING;
 		raw_spin_lock_irqsave(&rnp->lock, flags);
 		mask = atomic_xchg(&rnp->wakemask, 0);
+		printk(KERN_INFO "rcun %p initiating boost.\n", rnp);
 		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
+		printk(KERN_INFO "rcun %p completed boost.\n", rnp);
 		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask >>= 1) {
 			if ((mask & 0x1) == 0)
 				continue;
@@ -1689,10 +1699,12 @@ static int rcu_node_kthread(void *arg)
 				preempt_enable();
 				continue;
 			}
+			printk(KERN_INFO "rcun %p awaking rcuc%d.\n", rnp, cpu);
 			per_cpu(rcu_cpu_has_work, cpu) = 1;
 			sp.sched_priority = RCU_KTHREAD_PRIO;
 			sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 			preempt_enable();
+			printk(KERN_INFO "rcun %p awakened rcuc%d.\n", rnp, cpu);
 		}
 	}
 	/* NOTREACHED */
