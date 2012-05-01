Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2EAPpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 11:45:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48166 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab2EAPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 11:45:35 -0400
Date: Tue, 1 May 2012 08:45:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120501154513.GD2441@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
 <20120428034257.GA2495@linux.vnet.ibm.com>
 <20120501000245.GA4329@linux.vnet.ibm.com>
 <4F9FA50C.9070600@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F9FA50C.9070600@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050115-7182-0000-0000-000001661160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 10:55:40AM +0200, Pascal Chapperon wrote:
> Le 01/05/2012 02:02, Paul E. McKenney a écrit :
> >On Fri, Apr 27, 2012 at 08:42:58PM -0700, Paul E. McKenney wrote:
> >>On Fri, Apr 27, 2012 at 02:15:20PM +0200, Pascal Chapperon wrote:
> >>>Le 18/04/2012 17:23, Paul E. McKenney a écrit :
> >>>>On Wed, Apr 18, 2012 at 05:00:14PM +0200, Pascal Chapperon wrote:
> >>>>>Le 18/04/2012 16:01, Paul E. McKenney a écrit :
> >>>>>>On Wed, Apr 18, 2012 at 11:37:28AM +0200, Pascal Chapperon wrote:
> >>>>>>>Mount and umount operations are not slower with RCU_FAST_NO_HZ during
> >>>>>>>runtime; systemctl start and stop operations are also not slower. In
> >>>>>>>fact, i couldn't find a single operation slower during runtime with
> >>>>>>>RCU_FAST_NO_HZ.
> >>>>>>
> >>>>>>Your boot-time setup is such that all CPUs are online before the
> >>>>>>boot-time mount operations take place, right?
> >>>>>Yes :
> >>>>>[ 0.242697] Brought up 8 CPUs
> >>>>>[ 0.242699] Total of 8 processors activated (35118.33 BogoMIPS).
> >>>>>
> >>>>>>Struggling to understand
> >>>>>>how RCU can tell the difference between post-CPU-bringup boot time
> >>>>>>and run time...
> >>>>>>
> >>>>>systemd is controlling the whole boot process including mount
> >>>>>operation (apart root filesystem) and as I can see, uses heavily
> >>>>>sockets to do it (not to mention cpu-affinity). It controls also the
> >>>>>major part of umount operations. Is it possible that your patch hits
> >>>>>a systemd bug ?
> >>>>
> >>>>Is it possible that systemd is using network operations that include
> >>>>synchronize_rcu()? Then if you did the same operation from the
> >>>>command line at runtime, you might not see the slowdown.
> >>>>
> >>>>Is it possible for you to convince systemd to collect RCU event tracing
> >>>>during the slow operation? RCU event tracing is available under
> >>>>/sys/kernel/debug/tracing/rcu.
> >>>>
> >>>.
> >>>I have collected the RCU event tracing during a slow boot with
> >>>FAST_NO_HZ (and the same without FAST_NO_HZ, same kernel config).
> >>>The full logs and associated "systemd-analyze plot" can be found
> >>>(in comment 32) at :
> >>>
> >>>https://bugzilla.redhat.com/show_bug.cgi?id=806548
> >>>
> >>>With FAST_NO_HZ, almost each rcu_prep_idle is followed by ksoftirqd
> >>>(75000 ksoftirqd lines with FAST_NO_HZ, 4000 without).
> >>>
> >>>Sorry, the logs are very huge, but I can't figure where are the
> >>>plots of some interest.
> >>
> >>Thank you for collecting them!  I clearly will need to do some scripting.  ;-)
> >
> >And it appears that your system is migrating timers without waking up
> >the CPU on which the timer was posted.  This explains the slowdowns:
> >RCU assumes that the timer will either fire on the CPU that it was posted
> >on or that that CPU will be awakened when it goes offline.  If the timer
> >does not fire on that CPU and that CPU is not otherwise awakened, then
> >that CPU's RCU callbacks can be indefinitely postponed, which could account
> >for the slowdowns that you were seeing.
> >
> >Please see below for a lightly tested patch that should address this
> >problem, and thank you again for your patient testing efforts!
> >
> >							Thanx, Paul
> >
> >------------------------------------------------------------------------
> >
> >rcu: Make RCU_FAST_NO_HZ handle timer migration
> >
> >The current RCU_FAST_NO_HZ assumes that timers do not migrate unless a
> >CPU goes offline, in which case it assumes that the CPU will have to come
> >out of dyntick-idle mode (cancelling the timer) in order to go offline.
> >This is important because when RCU_FAST_NO_HZ permits a CPU to enter
> >dyntick-idle mode despite having RCU callbacks pending, it posts a timer
> >on that CPU to force a wakeup on that CPU.  This wakeup ensures that the
> >CPU will eventually handle the end of the grace period, including invoking
> >its RCU callbacks.
> >
> >However, Pascal Chapperon's test setup shows that the timer handler
> >rcu_idle_gp_timer_func() really does get invoked in some cases.  This is
> >problematic because this can cause the CPU that entered dyntick-idle
> >mode despite still having RCU callbacks pending to remain in
> >dyntick-idle mode indefinitely, which means that its RCU callbacks might
> >never be invoked.  This situation can result in grace-period delays or
> >even system hangs, which matches Pascal's observations of slow boot-up
> >and shutdown (https://lkml.org/lkml/2012/4/5/142).  See also the bugzilla:
> >
> >https://bugzilla.redhat.com/show_bug.cgi?id=806548
> >
> >This commit therefore causes the "should never be invoked" timer handler
> >rcu_idle_gp_timer_func() to use smp_call_function_single() to wake up
> >the CPU for which the timer was intended, allowing that CPU to invoke
> >its RCU callbacks in a timely manner.
> >
> >Reported-by: Pascal Chapperon<pascal.chapperon@wanadoo.fr>
> >Signed-off-by: Paul E. McKenney<paul.mckenney@linaro.org>
> >Signed-off-by: Paul E. McKenney<paulmck@linux.vnet.ibm.com>
> >---
> >
> >  include/trace/events/rcu.h |    1 +
> >  kernel/rcutree_plugin.h    |   23 ++++++++++++++++++++---
> >  2 files changed, 21 insertions(+), 3 deletions(-)
> >
> >diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
> >index aaa55e1..1480900 100644
> >--- a/include/trace/events/rcu.h
> >+++ b/include/trace/events/rcu.h
> >@@ -292,6 +292,7 @@ TRACE_EVENT(rcu_dyntick,
> >   *	"More callbacks": Still more callbacks, try again to clear them out.
> >   *	"Callbacks drained": All callbacks processed, off to dyntick idle!
> >   *	"Timer": Timer fired to cause CPU to continue processing callbacks.
> >+ *	"Demigrate": Timer fired on wrong CPU, woke up correct CPU.
> >   *	"Cleanup after idle": Idle exited, timer canceled.
> >   */
> >  TRACE_EVENT(rcu_prep_idle,
> >diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> >index dc12efc..bbd064a 100644
> >--- a/kernel/rcutree_plugin.h
> >+++ b/kernel/rcutree_plugin.h
> >@@ -1994,16 +1994,33 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
> >  }
> >
> >  /*
> >+ *
> >+ */
> >+void rcu_idle_demigrate(void *unused)
> >+{
> >+	trace_rcu_prep_idle("Demigrate");
> >+}
> >+
> >+/*
> >   * Timer handler used to force CPU to start pushing its remaining RCU
> >   * callbacks in the case where it entered dyntick-idle mode with callbacks
> >   * pending.  The hander doesn't really need to do anything because the
> >   * real work is done upon re-entry to idle, or by the next scheduling-clock
> >   * interrupt should idle not be re-entered.
> >+ *
> >+ * One special case: the timer gets migrated without awakening the CPU
> >+ * on which the timer was scheduled on.  In this case, we must wake up
> >+ * that CPU.  We do so with smp_call_function_single().
> >   */
> >-static void rcu_idle_gp_timer_func(unsigned long unused)
> >+static void rcu_idle_gp_timer_func(unsigned long cpu_in)
> >  {
> >-	WARN_ON_ONCE(1); /* Getting here can hang the system... */
> >+	int cpu = (int)cpu_in;
> >+
> >  	trace_rcu_prep_idle("Timer");
> >+	if (cpu != smp_processor_id())
> >+		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
> >+	else
> >+		WARN_ON_ONCE(1); /* Getting here can hang the system... */
> >  }
> >
> >  /*
> >@@ -2012,7 +2029,7 @@ static void rcu_idle_gp_timer_func(unsigned long unused)
> >  static void rcu_prepare_for_idle_init(int cpu)
> >  {
> >  	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
> >-		    rcu_idle_gp_timer_func, 0);
> >+		    rcu_idle_gp_timer_func, cpu);
> >  }
> >
> >  /*
> >
> >
> Paul, I can't apply your patch on top of master branch; perhaps I
> need to pull your own git repository ?
> Among other things, you have:
> static void rcu_idle_gp_timer_func(unsigned long unused)
> and I have:
> static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)

Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.

Or you can pull branch fnh.2012.05.01a from:

	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 3370997..1480900 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -292,6 +292,8 @@ TRACE_EVENT(rcu_dyntick,
  *	"More callbacks": Still more callbacks, try again to clear them out.
  *	"Callbacks drained": All callbacks processed, off to dyntick idle!
  *	"Timer": Timer fired to cause CPU to continue processing callbacks.
+ *	"Demigrate": Timer fired on wrong CPU, woke up correct CPU.
+ *	"Cleanup after idle": Idle exited, timer canceled.
  */
 TRACE_EVENT(rcu_prep_idle,
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1050d6d..403306b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1829,6 +1829,8 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 	rdp->qlen++;
 	if (lazy)
 		rdp->qlen_lazy++;
+	else
+		rcu_idle_count_callbacks_posted();
 
 	if (__is_kfree_rcu_offset((unsigned long)func))
 		trace_rcu_kfree_callback(rsp->name, head, (unsigned long)func,
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cdd1be0..36ca28e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -471,6 +471,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu);
 static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
+static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c023464..cadef05 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1938,6 +1938,14 @@ static void rcu_prepare_for_idle(int cpu)
 {
 }
 
+/*
+ * Don't bother keeping a running count of the number of RCU callbacks
+ * posted because CONFIG_RCU_FAST_NO_HZ=n.
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+}
+
 #else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 /*
@@ -1980,9 +1988,11 @@ static void rcu_prepare_for_idle(int cpu)
 
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
-static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
+static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
+static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
+static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -1995,6 +2005,8 @@ static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
  */
 int rcu_needs_cpu(int cpu)
 {
+	/* Flag a new idle sojourn to the idle-entry state machine. */
+	per_cpu(rcu_idle_first_pass, cpu) = 1;
 	/* If no callbacks, RCU doesn't need the CPU. */
 	if (!rcu_cpu_has_callbacks(cpu))
 		return 0;
@@ -2045,16 +2057,33 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 }
 
 /*
+ *
+ */
+void rcu_idle_demigrate(void *unused)
+{
+	trace_rcu_prep_idle("Demigrate");
+}
+
+/*
  * Timer handler used to force CPU to start pushing its remaining RCU
  * callbacks in the case where it entered dyntick-idle mode with callbacks
  * pending.  The hander doesn't really need to do anything because the
  * real work is done upon re-entry to idle, or by the next scheduling-clock
  * interrupt should idle not be re-entered.
+ *
+ * One special case: the timer gets migrated without awakening the CPU
+ * on which the timer was scheduled on.  In this case, we must wake up
+ * that CPU.  We do so with smp_call_function_single().
  */
-static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
+static void rcu_idle_gp_timer_func(unsigned long cpu_in)
 {
+	int cpu = (int)cpu_in;
+
 	trace_rcu_prep_idle("Timer");
-	return HRTIMER_NORESTART;
+	if (cpu != smp_processor_id())
+		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
+	else
+		WARN_ON_ONCE(1); /* Getting here can hang the system... */
 }
 
 /*
@@ -2062,19 +2091,8 @@ static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
  */
 static void rcu_prepare_for_idle_init(int cpu)
 {
-	static int firsttime = 1;
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
-
-	hrtimer_init(hrtp, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtp->function = rcu_idle_gp_timer_func;
-	if (firsttime) {
-		unsigned int upj = jiffies_to_usecs(RCU_IDLE_GP_DELAY);
-
-		rcu_idle_gp_wait = ns_to_ktime(upj * (u64)1000);
-		upj = jiffies_to_usecs(RCU_IDLE_LAZY_GP_DELAY);
-		rcu_idle_lazy_gp_wait = ns_to_ktime(upj * (u64)1000);
-		firsttime = 0;
-	}
+	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+		    rcu_idle_gp_timer_func, cpu);
 }
 
 /*
@@ -2084,7 +2102,8 @@ static void rcu_prepare_for_idle_init(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+	del_timer(&per_cpu(rcu_idle_gp_timer, cpu));
+	trace_rcu_prep_idle("Cleanup after idle");
 }
 
 /*
@@ -2108,6 +2127,29 @@ static void rcu_cleanup_after_idle(int cpu)
  */
 static void rcu_prepare_for_idle(int cpu)
 {
+	struct timer_list *tp;
+
+	/*
+	 * If this is an idle re-entry, for example, due to use of
+	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
+	 * loop, then don't take any state-machine actions, unless the
+	 * momentary exit from idle queued additional non-lazy callbacks.
+	 * Instead, repost the rcu_idle_gp_timer if this CPU has callbacks
+	 * pending.
+	 */
+	if (!per_cpu(rcu_idle_first_pass, cpu) &&
+	    (per_cpu(rcu_nonlazy_posted, cpu) ==
+	     per_cpu(rcu_nonlazy_posted_snap, cpu))) {
+		if (rcu_cpu_has_callbacks(cpu)) {
+			tp = &per_cpu(rcu_idle_gp_timer, cpu);
+			mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
+		}
+		return;
+	}
+	per_cpu(rcu_idle_first_pass, cpu) = 0;
+	per_cpu(rcu_nonlazy_posted_snap, cpu) =
+		per_cpu(rcu_nonlazy_posted, cpu) - 1;
+
 	/*
 	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
 	 * Also reset state to avoid prejudicing later attempts.
@@ -2140,11 +2182,15 @@ static void rcu_prepare_for_idle(int cpu)
 		per_cpu(rcu_dyntick_drain, cpu) = 0;
 		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
 		if (rcu_cpu_has_nonlazy_callbacks(cpu))
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_gp_wait, HRTIMER_MODE_REL);
+			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+					   jiffies + RCU_IDLE_GP_DELAY;
 		else
-			hrtimer_start(&per_cpu(rcu_idle_gp_timer, cpu),
-				      rcu_idle_lazy_gp_wait, HRTIMER_MODE_REL);
+			per_cpu(rcu_idle_gp_timer_expires, cpu) =
+					   jiffies + RCU_IDLE_LAZY_GP_DELAY;
+		tp = &per_cpu(rcu_idle_gp_timer, cpu);
+		mod_timer_pinned(tp, per_cpu(rcu_idle_gp_timer_expires, cpu));
+		per_cpu(rcu_nonlazy_posted_snap, cpu) =
+			per_cpu(rcu_nonlazy_posted, cpu);
 		return; /* Nothing more to do immediately. */
 	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
 		/* We have hit the limit, so time to give up. */
@@ -2184,6 +2230,17 @@ static void rcu_prepare_for_idle(int cpu)
 		trace_rcu_prep_idle("Callbacks drained");
 }
 
+/*
+ * Keep a running count of callbacks posted so that rcu_prepare_for_idle()
+ * can detect when something out of the idle loop posts a callback.
+ * Of course, it had better do so either from a trace event designed to
+ * be called from idle or from within RCU_NONIDLE().
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+	__this_cpu_add(rcu_nonlazy_posted, 1);
+}
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #ifdef CONFIG_RCU_CPU_STALL_INFO
@@ -2192,14 +2249,12 @@ static void rcu_prepare_for_idle(int cpu)
 
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
-	struct hrtimer *hrtp = &per_cpu(rcu_idle_gp_timer, cpu);
+	struct timer_list *tltp = &per_cpu(rcu_idle_gp_timer, cpu);
 
-	sprintf(cp, "drain=%d %c timer=%lld",
+	sprintf(cp, "drain=%d %c timer=%lu",
 		per_cpu(rcu_dyntick_drain, cpu),
 		per_cpu(rcu_dyntick_holdoff, cpu) == jiffies ? 'H' : '.',
-		hrtimer_active(hrtp)
-			? ktime_to_us(hrtimer_get_remaining(hrtp))
-			: -1);
+		timer_pending(tltp) ? tltp->expires - jiffies : -1);
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */

