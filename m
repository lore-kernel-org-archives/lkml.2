Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab1FQQso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:48:44 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55920 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757808Ab1FQQsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:48:39 -0400
Date: Fri, 17 Jun 2011 09:48:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Miller <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <rmk@arm.linux.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@kernel.dk>,
        Namhyung Kim <namhyung@gmail.com>, shaohua.li@intel.com,
        alex.shi@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [GIT PULL] Re: REGRESSION: Performance regressions from
 switching anon_vma->lock to mutex
Message-ID: <20110617164811.GD2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <35c0ff16-bd58-4b9c-9d9f-d1a4df2ae7b9@email.android.com>
 <20110616070335.GA7661@elte.hu>
 <20110616171644.GK2582@linux.vnet.ibm.com>
 <20110616202550.GA16214@elte.hu>
 <1308262883.2516.71.camel@pasglop>
 <20110616223837.GA18431@elte.hu>
 <4DFA8802.6010300@linux.intel.com>
 <20110616225803.GA28557@elte.hu>
 <20110617004536.GP2582@linux.vnet.ibm.com>
 <20110617094333.GB19235@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617094333.GB19235@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 11:43:33AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Jun 17, 2011 at 12:58:03AM +0200, Ingo Molnar wrote:
> > > 
> > > * Andi Kleen <ak@linux.intel.com> wrote:
> > > 
> > > > > There's a crazy solution for that: the idle thread could process 
> > > > > RCU callbacks carefully, as if it was running user-space code.
> > > > 
> > > > In Ben's kernel NFS server case the system may not be idle.
> > > 
> > > An always-100%-busy NFS server is very unlikely, but even in the 
> > > hypothetical case a kernel NFS server is really performing system 
> > > calls from a kernel thread in essence. If it doesn't do it explicitly 
> > > then its main loop can easily include a "check RCU callbacks" call.
> > 
> > As long as they make sure to call it in a clean environment: no 
> > locks held and so on.  But I am a bit worried about the possibility 
> > of someone forgetting to put one of these where it is needed -- it 
> > would work just fine for most workloads, but could fail only for 
> > rare workloads.
> 
> Yeah, some sort of worst-case-tick mechanism would guarantee that we 
> wont remain without RCU GC.

Agreed!

> > That said, invoking RCU core/callback processing from the scheduler 
> > context certainly sounds like an interesting way to speed up grace 
> > periods.
> 
> It also moves whatever priority logic is needed closer to the 
> scheduler that has to touch those data structures anyway.
> 
> RCU, at least partially, is a scheduler driven garbage collector even 
> today: beyond context switch quiescent states the main practical role 
> of the per CPU timer tick itself is scheduling. So having it close to 
> when we do context-switches anyway looks pretty natural - worth 
> trying.
> 
> It might not work out in practice, but at first sight it would 
> simplify a few things i think.

OK, please see below for a patch that not only builds, but actually
passes minimal testing.  ;-)

Possible expectations and outcomes:

1.	Reduced grace-period latencies on !NO_HZ systems and
	on NO_HZ systems where each CPU goes non-idle frequently.
	(My unscientific testing shows little or no benefit, but
	then again, I was running rcutorture, which specializes
	in long read-side critical sections.  And I was running
	NO_HZ, which is less likely to show benefit.)

	I would not expect direct call to have any benefit over
	softirq invocation -- sub-microsecond softirq overhead
	won't matter to multi-millisecond

2.	Better cache locality.  I am a bit skeptical, but there is
	some chance that this might reduce cache misses on task_struct.
	Direct call might well do better than softirq here.

3.	Easier conversion to user-space operation.  I was figuring
	on using POSIX signals for scheduler_tick() and for softirq,
	so wasn't worried about it, but might well be simpler.

Anything else?

On eliminating softirq, I must admit that I am a bit worried about
invoking the RCU core code from scheduler_tick(), but there are some
changes that I could make that would reduce force_quiescent_state()
worst-case latency.  At the expense of lengthening grace periods,
unfortunately, but the reduction will be needed for RT on larger systems
anyway, so might as well try it.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Experimental change driving RCU core from scheduler

This change causes RCU's context-switch code to check to see if the RCU
core needs anything from the current CPU, and, if so, invoke the RCU
core code.  One possible improvement from this experiment is reduced
grace-period latency on systems that either have NO_HZ=n or that have
all CPUs frequently going non-idle.  The invocation of the RCU core code
is currently via softirq, though a plausible next step in the experiment
might be to instead use a direct function call.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 405a5fd..6b7a43a 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -87,6 +87,10 @@ static struct rcu_state *rcu_state;
 int rcu_scheduler_active __read_mostly;
 EXPORT_SYMBOL_GPL(rcu_scheduler_active);
 
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+static int rcu_pending(int cpu);
+static void rcu_process_callbacks(struct softirq_action *unused);
+
 #ifdef CONFIG_RCU_BOOST
 
 /*
@@ -159,8 +163,14 @@ void rcu_bh_qs(int cpu)
  */
 void rcu_note_context_switch(int cpu)
 {
+	unsigned long flags;
+
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
+	local_irq_save(flags);
+	if (rcu_pending(cpu))
+		invoke_rcu_core();
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
@@ -182,9 +192,6 @@ module_param(qlowmark, int, 0);
 int rcu_cpu_stall_suppress __read_mostly;
 module_param(rcu_cpu_stall_suppress, int, 0644);
 
-static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
-static int rcu_pending(int cpu);
-
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
  */
