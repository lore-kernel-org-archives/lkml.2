Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab2EDXPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 19:15:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42120 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab2EDXPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 19:15:50 -0400
Date: Fri, 4 May 2012 16:14:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
Cc: Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: Re: RCU related performance regression in 3.3
Message-ID: <20120504231442.GT2411@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20177034.34764.1335528920975.JavaMail.www@wwinf1f04>
 <20120428034257.GA2495@linux.vnet.ibm.com>
 <20120501000245.GA4329@linux.vnet.ibm.com>
 <4F9FA50C.9070600@wanadoo.fr>
 <20120501154513.GD2441@linux.vnet.ibm.com>
 <4FA3EAEE.9030601@wanadoo.fr>
 <20120504150411.GC2411@linux.vnet.ibm.com>
 <4FA44CF9.7050604@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA44CF9.7050604@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050423-1780-0000-0000-00000550D573
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000274; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00136371; UDB=6.00031824; UTC=2012-05-04
 23:15:47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:41:13PM +0200, Pascal Chapperon wrote:
> Le 04/05/2012 17:04, Paul E. McKenney a écrit :
> >On Fri, May 04, 2012 at 04:42:54PM +0200, Pascal Chapperon wrote:
> >>Le 01/05/2012 17:45, Paul E. McKenney a écrit :
> >>
> >>>Here is my RCU_FAST_NO_HZ patch stack on top of v3.4-rc4.
> >>>
> >>>Or you can pull branch fnh.2012.05.01a from:
> >>>
> >>>	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> >>>
> >>>							Thanx, Paul
> >>>
> >>I applied your global patch on top of v3.4-rc4. But the slowdown is
> >>worse than before : boot sequence took 80s instead 20-30s (12s for
> >>initramfs instead of 2s).
> >>
> >>I'll send you rcu tracing log in a second mail.
> >
> >Hmmm...  Well, I guess I am glad that I finally did something that
> >had an effect, but I sure wish that the effect had been in the other
> >direction!
> >
> >Just to make sure I understand: the difference between the 20-30s and
> >the 80s is exactly the patch I sent you?
> >
> >							Thanx, Paul
> >
> >
> Yes. Exactly same kernel config as in previous results, I applied
> your patch against v3.4-rc4, and sorry, the result is exactly what I
> said;
> I saw that your global patch was quite huge, and addresses things which
> are not directly related with the initial patch (commit
> 7cb92499000e3c86dae653077b1465458a039ef6); maybe a side effect?
> 
> However, I'm ready to try this patch on my smaller laptop which
> supports well CONFIG_FAST_NO_HZ=y and systemd, if you think it can
> help ?
> 
> Another thought: this issue as nothing to do with i7 Hyper-threading
> capacities ? (as I test core2duo, Pentium ulv in same conditions and I
> don't encountered any slowdown ?)

Well, one possibility is that your setup starts the jiffies counter
at some interesting value.  The attached patch (also against v3.4-rc4)
applies a bit more paranoia to the initialization to handle this
and other possibilities.

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
index c023464..ccbdc72 100644
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
@@ -1978,11 +1986,20 @@ static void rcu_prepare_for_idle(int cpu)
 #define RCU_IDLE_GP_DELAY 6		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
+/* Loop counter for rcu_prepare_for_idle(). */
 static DEFINE_PER_CPU(int, rcu_dyntick_drain);
+/* If rcu_dyntick_holdoff==jiffies, don't try to enter dyntick-idle mode. */
 static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
-static DEFINE_PER_CPU(struct hrtimer, rcu_idle_gp_timer);
-static ktime_t rcu_idle_gp_wait;	/* If some non-lazy callbacks. */
-static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
+/* Timer to awaken the CPU if it enters dyntick-idle mode with callbacks. */
+static DEFINE_PER_CPU(struct timer_list, rcu_idle_gp_timer);
+/* Scheduled expiry time for rcu_idle_gp_timer to allow reposting. */
+static DEFINE_PER_CPU(unsigned long, rcu_idle_gp_timer_expires);
+/* Enable special processing on first attempt to enter dyntick-idle mode. */
+static DEFINE_PER_CPU(bool, rcu_idle_first_pass);
+/* Running count of non-lazy callbacks posted, never decremented. */
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted);
+/* Snapshot of rcu_nonlazy_posted to detect meaningful exits from idle. */
+static DEFINE_PER_CPU(unsigned long, rcu_nonlazy_posted_snap);
 
 /*
  * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
@@ -1995,6 +2012,8 @@ static ktime_t rcu_idle_lazy_gp_wait;	/* If only lazy callbacks. */
  */
 int rcu_needs_cpu(int cpu)
 {
+	/* Flag a new idle sojourn to the idle-entry state machine. */
+	per_cpu(rcu_idle_first_pass, cpu) = 1;
 	/* If no callbacks, RCU doesn't need the CPU. */
 	if (!rcu_cpu_has_callbacks(cpu))
 		return 0;
@@ -2045,16 +2064,39 @@ static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
 }
 
 /*
+ * Handler for smp_call_function_single().  The only point of this
+ * handler is to wake the CPU up, so the handler does only tracing.
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
+	if (cpu == smp_processor_id()) {
+		WARN_ON_ONCE(1); /* Getting here can hang the system... */
+	} else {
+		preempt_disable();
+		if (cpu_online(cpu))
+			smp_call_function_single(cpu, rcu_idle_demigrate,
+						 NULL, 0);
+		preempt_enable();
+	}
 }
 
 /*
@@ -2062,19 +2104,11 @@ static enum hrtimer_restart rcu_idle_gp_timer_func(struct hrtimer *hrtp)
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
+	per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+	setup_timer(&per_cpu(rcu_idle_gp_timer, cpu),
+		    rcu_idle_gp_timer_func, cpu);
+	per_cpu(rcu_idle_gp_timer_expires, cpu) = jiffies - 1;
+	per_cpu(rcu_idle_first_pass, cpu) = 1;
 }
 
 /*
@@ -2084,7 +2118,8 @@ static void rcu_prepare_for_idle_init(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	hrtimer_cancel(&per_cpu(rcu_idle_gp_timer, cpu));
+	del_timer(&per_cpu(rcu_idle_gp_timer, cpu));
+	trace_rcu_prep_idle("Cleanup after idle");
 }
 
 /*
@@ -2108,6 +2143,29 @@ static void rcu_cleanup_after_idle(int cpu)
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
@@ -2140,11 +2198,15 @@ static void rcu_prepare_for_idle(int cpu)
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
@@ -2184,6 +2246,19 @@ static void rcu_prepare_for_idle(int cpu)
 		trace_rcu_prep_idle("Callbacks drained");
 }
 
+/*
+ * Keep a running count of the number of non-lazy callbacks posted
+ * on this CPU.  This running counter (which is never decremented) allows
+ * rcu_prepare_for_idle() to detect when something out of the idle loop
+ * posts a callback, even if an equal number of callbacks are invoked.
+ * Of course, callbacks should only be posted from within a trace event
+ * designed to be called from idle or from within RCU_NONIDLE().
+ */
+static void rcu_idle_count_callbacks_posted(void)
+{
+	__this_cpu_add(rcu_nonlazy_posted, 1);
+}
+
 #endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
 
 #ifdef CONFIG_RCU_CPU_STALL_INFO
@@ -2192,14 +2267,12 @@ static void rcu_prepare_for_idle(int cpu)
 
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

