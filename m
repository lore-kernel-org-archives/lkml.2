Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161380Ab2GLRFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:05:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45656 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934146Ab2GLRF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:05:29 -0400
Date: Thu, 12 Jul 2012 10:01:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120712170152.GA31396@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
 <20120711123616.GA27086@localhost>
 <20120711125559.GA27383@localhost>
 <20120712141130.GA20195@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712141130.GA20195@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071217-5112-0000-0000-000009FFAE41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:11:30PM +0800, Fengguang Wu wrote:
> On Wed, Jul 11, 2012 at 08:55:59PM +0800, Fengguang Wu wrote:
> > On Wed, Jul 11, 2012 at 08:36:16PM +0800, Fengguang Wu wrote:
> > > On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> > > > On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > Fortunately this bug is bisectable and the first bad commit is:
> > > > > 
> > > > >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> > > > >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > > > > 
> > > > >             rcu: Track idleness independent of idle tasks
> > > > 
> > > > OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> > > > traces while in idle.  The confusion on my part was that in TREE_RCU,
> > > > the nesting and dyntick-idle indication are different, while in
> > > > TINY_RCU they are one and the same.
> > > > 
> > > > Does the following patch help?
> > > 
> > > Not exactly, but the error message is now changed to:
> > 
> > Then I think it may help to test the linux-next tree that contains
> > latest RCU fixes. And it somehow helped. There are no warnings in
> > the linux-next tree 1 or 2 days ago; there is a maybe unrelated warning
> > in today's linux-next tree.
> > 
> > [    0.013241] Performance Events: 
> > [    0.014222] ------------[ cut here ]------------
> > [    0.014975] WARNING: at /c/wfg/linux/kernel/workqueue.c:1217 worker_enter_idle+0x2fa/0x37c()
> 
> That's bisected to one of Tejun's workqueue commit..
> 
> > Both trees freeze after this point:
> > 
> > modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6-next-20120710+/modules.dep: No such file or directory
> > ^M
> > modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6-next-20120710+/modules.dep: No such file or directory
> > ^M
> 
> And that's bisected to Al's vfs work..
> 
> > So I'd better to base the test on one of your RCU branches..
> > Which branch would your recommend?
> 
> And finally I tried the patch on top of rcu/next, and get the attached
> dmesg and warnings:
> 
> [    1.776415] Testing tracer preemptirqsoff: PASSED
> [    1.779383] Testing tracer wakeup: [    2.091320] ftrace-test (15) used greatest stack depth: 7284 bytes left
> PASSED
> [    2.094844] Testing tracer wakeup_rt: [    2.179052] ------------[ cut here ]------------
> [    2.181087] WARNING: at /c/wfg/linux/kernel/rcutiny.c:92 rcu_idle_enter+0xf0/0x244()     
> [    2.183023] Hardware name: Bochs
> 
> [    2.183023] Modules linked in:
> [    2.183023]
> [    2.183023] Pid: 0, comm: swapper Not tainted 3.5.0-rc5+ #59
> [    2.183023] Call Trace:
> [    2.183023]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
> [    2.183023]  [<c1105d31>] ? rcu_idle_enter+0xf0/0x244    
> [    2.183023]  [<c1105d31>] ? rcu_idle_enter+0xf0/0x244
> [    2.183023]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
> [    2.183023]  [<c1105d31>] rcu_idle_enter+0xf0/0x244   
> [    2.183023]  [<c100fbdb>] cpu_idle+0x159/0x220     
> [    2.183023]  [<c14165a3>] rest_init+0x2db/0x2ef
> [    2.183023]  [<c14162c8>] ? reciprocal_value+0x64/0x64
> [    2.183023]  [<c171d456>] start_kernel+0x8eb/0x8ff    
> [    2.183023]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
> [    2.183023]  [<c171c342>] i386_start_kernel+0xf8/0x10b 
> [    2.183023] ---[ end trace 44593438a59a9533 ]---      
> [    2.195679] ------------[ cut here ]------------
> [    2.196428] WARNING: at /c/wfg/linux/kernel/rcutiny.c:113 rcu_irq_exit+0x100/0x217()
> [    2.197633] Hardware name: Bochs
> [    2.198183] Modules linked in:
> [    2.198695] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc5+ #59
> [    2.199671] Call Trace:
> [    2.199671]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
> [    2.199671]  [<c1105b2a>] ? rcu_irq_exit+0x100/0x217     
> [    2.199671]  [<c1105b2a>] ? rcu_irq_exit+0x100/0x217
> [    2.199671]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
> [    2.199671]  [<c1105b2a>] rcu_irq_exit+0x100/0x217
> [    2.199671]  [<c10469ae>] irq_exit+0x117/0x14d
> [    2.199671]  [<c1005d31>] do_IRQ+0xe5/0x106
> [    2.199671]  [<c10ba77e>] ? trace_hardirqs_off_caller+0x97/0x167
> [    2.199671]  [<c1437975>] common_interrupt+0x35/0x3c            
> [    2.199671]  [<c10c00e0>] ? trace_hardirqs_on_caller+0x1b8/0x38c
> [    2.199671]  [<c1025c7b>] ? native_safe_halt+0x13/0x23                          
> 
> The same rcu/next HEAD w/o patch, the warning is:
> 
> [    4.456093] Testing event rcu_dyntick: [    4.458251] 
> [    4.458941] ===============================
> [    4.459352] [ INFO: suspicious RCU usage. ]
> [    4.459352] 3.5.0-rc5+ #60 Not tainted
> [    4.459352] -------------------------------
> [    4.459352] /c/wfg/linux/include/trace/events/rcu.h:275 suspicious rcu_dereference_check() usage!
> [    4.459352] 
> [    4.459352] other info that might help us debug this:
> [    4.459352] 
> [    4.459352] 
> [    4.459352] RCU used illegally from idle CPU!
> [    4.459352] rcu_scheduler_active = 1, debug_locks = 0
> [    4.459352] RCU used illegally from extended quiescent state!
> [    4.459352] no locks held by swapper/0.
> [    4.459352] 
> [    4.459352] stack backtrace:
> [    4.459352] Pid: 0, comm: swapper Not tainted 3.5.0-rc5+ #60
> [    4.459352] Call Trace:
> 
> [    4.459352] 
> [    4.459352]  [<c10bbb36>] lockdep_rcu_suspicious+0x1de/0x1f4
> [    4.459352]  [<c1103171>] trace_rcu_dyntick+0xd9/0x167
> [    4.459352]  [<c1105865>] rcu_idle_enter_common+0x84/0x22d
> [    4.459352]  [<c10ba77e>] ? trace_hardirqs_off_caller+0x97/0x167
> [    4.459352]  [<c1105d98>] rcu_idle_enter+0x16d/0x274
> [    4.459352]  [<c100fbdb>] cpu_idle+0x159/0x220
> [    4.459352]  [<c14165c3>] rest_init+0x2db/0x2ef
> [    4.459352]  [<c14162e8>] ? reciprocal_value+0x64/0x64
> [    4.459352]  [<c171d456>] start_kernel+0x8eb/0x8ff
> [    4.459352]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
> [    4.459352]  [<c171c342>] i386_start_kernel+0xf8/0x10b
> [    4.481163] OK 
> [    4.481437] Testing event rcu_prep_idle: OK
> 
> That's a great kconfig (from the testing respective)! :-P

Could you please try replacing my earlier patch with this one?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Pull TINY_RCU dyntick-idle tracing into non-idle region

Because TINY_RCU's idle detection keys directly off of the nesting
level, rather than from a separate variable as in TREE_RCU, the
TINY_RCU dyntick-idle tracing on transition to idle must happen
before the change to the nesting level.  This commit therefore makes
this change by passing the desired new value (rather than the old value)
of the nesting level in to rcu_idle_enter_common().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 547b1fe..31a10f9 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -56,24 +56,27 @@ static void __call_rcu(struct rcu_head *head,
 static long long rcu_dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 
 /* Common code for rcu_idle_enter() and rcu_irq_exit(), see kernel/rcutree.c. */
-static void rcu_idle_enter_common(long long oldval)
+static void rcu_idle_enter_common(long long newval)
 {
 	if (rcu_dynticks_nesting) {
 		RCU_TRACE(trace_rcu_dyntick("--=",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
+		rcu_dynticks_nesting = newval;
 		return;
 	}
-	RCU_TRACE(trace_rcu_dyntick("Start", oldval, rcu_dynticks_nesting));
+	RCU_TRACE(trace_rcu_dyntick("Start", rcu_dynticks_nesting, newval));
 	if (!is_idle_task(current)) {
 		struct task_struct *idle = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick("Error on entry: not idle task",
-					    oldval, rcu_dynticks_nesting));
+					    rcu_dynticks_nesting, newval));
 		ftrace_dump(DUMP_ALL);
 		WARN_ONCE(1, "Current pid: %d comm: %s / Idle pid: %d comm: %s",
 			  current->pid, current->comm,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
+	barrier();
+	rcu_dynticks_nesting = newval;
 	rcu_sched_qs(0); /* implies rcu_bh_qsctr_inc(0) */
 }
 
@@ -84,17 +87,16 @@ static void rcu_idle_enter_common(long long oldval)
 void rcu_idle_enter(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
 	WARN_ON_ONCE((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((rcu_dynticks_nesting & DYNTICK_TASK_NEST_MASK) ==
 	    DYNTICK_TASK_NEST_VALUE)
-		rcu_dynticks_nesting = 0;
+		newval = 0;
 	else
-		rcu_dynticks_nesting  -= DYNTICK_TASK_NEST_VALUE;
-	rcu_idle_enter_common(oldval);
+		newval = rcu_dynticks_nesting - DYNTICK_TASK_NEST_VALUE;
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -105,13 +107,12 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
 void rcu_irq_exit(void)
 {
 	unsigned long flags;
-	long long oldval;
+	long long newval;
 
 	local_irq_save(flags);
-	oldval = rcu_dynticks_nesting;
-	rcu_dynticks_nesting--;
-	WARN_ON_ONCE(rcu_dynticks_nesting < 0);
-	rcu_idle_enter_common(oldval);
+	newval = rcu_dynticks_nesting - 1;
+	WARN_ON_ONCE(newval < 0);
+	rcu_idle_enter_common(newval);
 	local_irq_restore(flags);
 }
 

