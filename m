Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab2AXTly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:41:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:49168 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab2AXTlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:41:52 -0500
Date: Tue, 24 Jan 2012 11:41:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] RCU changes for v3.3
Message-ID: <20120124194140.GB2381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120105135432.GA31450@elte.hu>
 <1327422312.7231.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20120124165312.GG2531@linux.vnet.ibm.com>
 <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327425208.7231.26.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012419-7282-0000-0000-000005E45923
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 06:13:28PM +0100, Eric Dumazet wrote:
> Le mardi 24 janvier 2012 à 08:53 -0800, Paul E. McKenney a écrit :
> > On Tue, Jan 24, 2012 at 05:25:12PM +0100, Eric Dumazet wrote:
> > > Le jeudi 05 janvier 2012 à 14:54 +0100, Ingo Molnar a écrit :
> > > > Linus,
> > > > 
> > > > Please pull the latest core-rcu-for-linus git tree from:
> > > > 
> > > >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus
> > > > 
> > > >  Thanks,
> > > 
> > > Hi guys
> > > 
> > > New lockdep warning here :
> > 
> > Hmmm...  Looks like tracing from within the inner idle loop.
> > 
> > Because RCU ignores CPUs in the inner idle loop (after the call to
> > rcu_idle_enter()), RCU read-side critical sections are not legal there.
> > 
> > One approach would be to delay the call to rcu_idle_enter() until after
> > the tracing is done, and to ensure that the call to rcu_idle_exit() happens
> > before any tracing.  I am not seeing perf_trace_power(), so need to
> > update and look again.  Or are you looking at -next rather than mainline?
> > 
> 
> I am using mainline, not -next
> 
> It seems "powertop" triggers the warnings.
> 
> Check include/trace/events/power.h line 75 :
> 
> DECLARE_EVENT_CLASS(power,
> 
> This declares perf_trace_power()...
> 
> include/trace/ftrace.h line 718
> 
> #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)  \
> static notrace void							\
> perf_trace_##call(void *__data, proto) ...

Thank you for the info!

Now I just need to find the call point.

Ah, I see...  I need to find one of trace_power_start(),
trace_power_frequency(), or trace_power_end().  I would have to guess
that this is either the trace_power_start() or the trace_power_end()
called from drivers/cpuidle/cpuidle.c lines 97 and 102.  Those are
within cpuidle_idle_call(), which are called from cpu_idle() in
arch/x86/kernel/process_32.c and arch/x86/kernel/process_64.c, so this
sounds plausible.

And they are indeed busted -- RCU believes the CPU is idle at the point
that cpuidle_idle_call() is invoked.

A hacky patch is below.  Here are some of my concerns with it:

1.	Is there a configuration in which the scheduler clock gets
	turned off, but in which cpuidle_idle_call() always returns
	zero?  If so, we either really need RCU to consider the entire
	inner loop to be idle (thus needing to snapshot the value of
	cpuidle_idle_call() in the outer loop) or we need explicit calls
	to rcu_sched_qs() and friends.

	Yes, we could momentarily exit RCU idleness mode, but I would
	need to think that one through...

2.	I am not totally confident that I have the order of operations
	surrounding the call to pm_idle() correct.

3.	This only addresses x86, and it looks like a few other architectures
	have this same problem.

4.	Probably other things that I haven't thought of.

That said, the patch does seem to compile, at least on my 32-bit
laptop...

							Thanx, Paul

------------------------------------------------------------------------

idle: Avoid using RCU when RCU thinks the CPU is idle

The x86 idle loops invoke cpuidle_idle_call() which uses tracing
which uses RCU.  Unfortunately, these idle loops have already
told RCU to ignore this CPU when they call it.  This patch hacks
the idle loops to avoid this problem, but probably causing several
other problems in the process.

Not-yet-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 485204f..cc0f2e2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -84,6 +84,8 @@ static inline void play_dead(void)
  */
 void cpu_idle(void)
 {
+	bool pm_idle_ok;
+
 	int cpu = smp_processor_id();
 
 	/*
@@ -100,7 +102,6 @@ void cpu_idle(void)
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_idle_enter();
-		rcu_idle_enter();
 		while (!need_resched()) {
 
 			check_pgt_cache();
@@ -113,11 +114,13 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			if (cpuidle_idle_call())
+			pm_idle_ok = cpuidle_idle_call();
+			rcu_idle_enter();
+			if (pm_idle_ok)
 				pm_idle();
+			rcu_idle_exit();
 			start_critical_timings();
 		}
-		rcu_idle_exit();
 		tick_nohz_idle_exit();
 		preempt_enable_no_resched();
 		schedule();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9b9fe4a..f75de25 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -109,6 +109,8 @@ static inline void play_dead(void)
  */
 void cpu_idle(void)
 {
+	bool pm_idle_ok;
+
 	current_thread_info()->status |= TS_POLLING;
 
 	/*
@@ -140,10 +142,15 @@ void cpu_idle(void)
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
 
-			/* enter_idle() needs rcu for notifiers */
+			pm_idle_ok = cpuidle_idle_call();
+
+			/*
+			 * Both enter_idle() and cpuidle_idle_call() need
+			 * RCU for notifiers
+			 */
 			rcu_idle_enter();
 
-			if (cpuidle_idle_call())
+			if (pm_idle_ok)
 				pm_idle();
 
 			rcu_idle_exit();

