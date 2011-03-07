Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1CGO1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:27:38 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58224 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751011Ab1CGO1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:27:36 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18BrKAz+PYBsABtRy4XMX9x1w4stVxke/Yri2imdi
	d/A7Bu0Buy2wbs
Subject: Re: [patchlet] sched: fix rt throttle runtime borrowing
From: Mike Galbraith <efault@gmx.de>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1299490414.14465.74.camel@marge.simson.net>
References: <1299486101.14465.25.camel@marge.simson.net>
	 <AANLkTikOY2-_EAjYTBZG4Wb9HNHRxJ4Qcd+zbvbxzPbt@mail.gmail.com>
	 <1299490414.14465.74.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 15:27:32 +0100
Message-ID: <1299508052.8093.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 10:33 +0100, Mike Galbraith wrote:
> On Mon, 2011-03-07 at 17:11 +0800, Yong Zhang wrote:
> > On Mon, Mar 7, 2011 at 4:21 PM, Mike Galbraith <efault@gmx.de> wrote:
> > > Greetings,
> > >
> > > The RT throttle leaves a bit to be desired as a protection mechanism.
> > > With default settings, the thing won't save your bacon if you start a
> > > single hog as RT on SMP box, or if your normally sane app goes nuts.
> > >
> > > With the below, my box will limp along so I can kill the RT hog.  May
> > > not be the best solution, but works for me.. modulo bustage I haven't
> > > noticed yet of course.
> > >
> > > sched: fix rt throttle runtime borrowing
> > >
> > > If allowed to borrow up to rt_period, the throttle has no effect on an out
> > > of control RT task, allowing it to consume 100% CPU indefinitely, blocking
> > > system critical SCHED_NORMAL threads indefinitely.
> > 
> > Yep.
> > I think it's helpful.
> 
> Well, it does prevent complete death, but you have to be pretty darn
> attentive to notice that the patient is still technically alive ;-)
> 
> As such, turning borrowing off by default, and making borrowing up to
> within a micron of 100% CPU an opt-in feature likely makes more sense.

sched: fix rt throttle runtime borrowing

If allowed to borrow up to rt_period, the throttle has no effect on an out
of control RT task, allowing it to consume 100% CPU indefinitely, blocking
system critical SCHED_NORMAL threads indefinitely.

To make the throttle a more effective safety mechanism, disable borrowing
by default. while providing an opt-in switch for those who know the risks.
Also fix the throttle such that it never silently bumps rt_runtime to the
point that it disables itself (rt_runtime >= rt_period).

Convert balance_runtime() and do_balance_runtime() to void since their
return values are never used.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 Documentation/scheduler/sched-rt-group.txt |   10 ++++++++
 include/linux/sched.h                      |    1 
 kernel/sched.c                             |    6 +++++
 kernel/sched_rt.c                          |   34 +++++++++++++++--------------
 kernel/sysctl.c                            |    9 +++++++
 5 files changed, 44 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -344,7 +344,7 @@ static inline struct rt_bandwidth *sched
 /*
  * We ran out of runtime, see if we can borrow some from our neighbours.
  */
-static int do_balance_runtime(struct rt_rq *rt_rq)
+static void do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 	struct root_domain *rd = cpu_rq(smp_processor_id())->rd;
@@ -354,7 +354,7 @@ static int do_balance_runtime(struct rt_
 	weight = cpumask_weight(rd->span);
 
 	raw_spin_lock(&rt_b->rt_runtime_lock);
-	rt_period = ktime_to_ns(rt_b->rt_period);
+	rt_period = ktime_to_ns(rt_b->rt_period) - 1;
 	for_each_cpu(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
@@ -366,14 +366,19 @@ static int do_balance_runtime(struct rt_
 		/*
 		 * Either all rqs have inf runtime and there's nothing to steal
 		 * or __disable_runtime() below sets a specific rq to inf to
-		 * indicate its been disabled and disalow stealing.
+		 * indicate its been disabled and disallow stealing.
 		 */
 		if (iter->rt_runtime == RUNTIME_INF)
 			goto next;
 
 		/*
 		 * From runqueues with spare time, take 1/n part of their
-		 * spare time, but no more than our period.
+		 * spare time, but no more than our period - 1 ns.
+		 *
+		 * NOTE: we don't allow borrowing to _full_ period because
+		 * sched_rt_runtime_exceeded() interprets rt_runtime >= rt_period
+		 * to mean unlimited.  The user can set that manually, but we
+		 * don't want to silently disable ourselves.
 		 */
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
@@ -392,8 +397,6 @@ next:
 		raw_spin_unlock(&iter->rt_runtime_lock);
 	}
 	raw_spin_unlock(&rt_b->rt_runtime_lock);
-
-	return more;
 }
 
 /*
@@ -517,22 +520,21 @@ static void enable_runtime(struct rq *rq
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
-static int balance_runtime(struct rt_rq *rt_rq)
+static void balance_runtime(struct rt_rq *rt_rq)
 {
-	int more = 0;
+	if (!sysctl_sched_rt_borrow_runtime)
+		return;
 
-	if (rt_rq->rt_time > rt_rq->rt_runtime) {
-		raw_spin_unlock(&rt_rq->rt_runtime_lock);
-		more = do_balance_runtime(rt_rq);
-		raw_spin_lock(&rt_rq->rt_runtime_lock);
-	}
+	if (rt_rq->rt_time <= rt_rq->rt_runtime)
+		return;
 
-	return more;
+	raw_spin_unlock(&rt_rq->rt_runtime_lock);
+	do_balance_runtime(rt_rq);
+	raw_spin_lock(&rt_rq->rt_runtime_lock);
 }
 #else /* !CONFIG_SMP */
-static inline int balance_runtime(struct rt_rq *rt_rq)
+static inline void balance_runtime(struct rt_rq *rt_rq)
 {
-	return 0;
 }
 #endif /* CONFIG_SMP */
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1941,6 +1941,7 @@ static inline unsigned int get_sysctl_ti
 #endif
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
+extern int sysctl_sched_rt_borrow_runtime;
 
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -822,6 +822,12 @@ static __read_mostly int scheduler_runni
  */
 int sysctl_sched_rt_runtime = 950000;
 
+/*
+ * do we allow borrowing of runtime from neighboring CPUs.
+ * default: 0 - no borrowing allowed.
+ */
+int sysctl_sched_rt_borrow_runtime;
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -361,6 +361,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
+	{
+		.procname	= "sched_rt_borrow_runtime",
+		.data		= &sysctl_sched_rt_borrow_runtime,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
Index: linux-2.6/Documentation/scheduler/sched-rt-group.txt
===================================================================
--- linux-2.6.orig/Documentation/scheduler/sched-rt-group.txt
+++ linux-2.6/Documentation/scheduler/sched-rt-group.txt
@@ -101,6 +101,16 @@ The system wide settings are configured
   * sched_rt_runtime_us takes values from -1 to (INT_MAX - 1).
   * A run time of -1 specifies runtime == period, ie. no limit.
 
+/proc/sys/kernel/sched_rt_borrow_runtime:
+  Enable borrowing of rt_runtime from neighbouring CPUs which have excess.
+  Caution should be exercised when enabling this option, as when enabled,
+  rt_runtime is allowed to grow to within 1 ns of rt_period, meaning that
+  the default 95% CPU reserved for realtime becomes very nearly 100% for
+  the borrowing CPU if ALL other CPUs are not fully utilizing their available
+  bandwidth, which can starve critical system threads badly should an RT
+  task spin out of control.
+
+  * sched_rt_borrow_runtime takes values 0 (disabled) and 1 (enabled).
 
 2.2 Default behaviour
 ---------------------


