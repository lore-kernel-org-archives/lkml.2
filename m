Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0HPRXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:23:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34043 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0HPRXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:23:50 -0400
Date: Mon, 16 Aug 2010 10:23:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-08-11 - RCU whinge during very early boot
Message-ID: <20100816172347.GE2388@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org>
 <10167.1281629887@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10167.1281629887@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 12:18:07PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 11 Aug 2010 16:10:49 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Throws a RCU complaint.  Hopefully somebody on the cc: list knows what it is about...

Hello, Valdis!

Thank you for finding this!

> [    0.026136] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz stepping 0a
> [    0.028399] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.030019] lockdep: fixing up alternatives.
> [    0.031178] 
> [    0.031179] ===================================================
> [    0.031182] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.031184] ---------------------------------------------------
> [    0.031187] kernel/sched.c:618 invoked rcu_dereference_check() without protection!
> [    0.031189] 
> [    0.031189] other info that might help us debug this:
> [    0.031190] 
> [    0.031192] 
> [    0.031193] rcu_scheduler_active = 1, debug_locks = 1
> [    0.031195] 3 locks held by kworker/0:0/4:
> [    0.031197]  #0:  (events){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
> [    0.031210]  #1:  ((&c_idle.work)){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
> [    0.031217]  #2:  (&rq->lock){-.-...}, at: [<ffffffff81b5f9b8>] init_idle+0x2b/0x114

Interesting!  My first thought was that this is a false positive, given
that lockdep_is_held(&task_rq(p)->lock) is one of the arguments to
task_subsys_state_check() and thus to rcu_dereference_check().  However...

Given the "lockdep: fixing up alternatives" above, we know that cpu==1,
and that the code is running on CPU 0.

So init_idle() acquires the specified CPU's runqueue lock:

	struct rq *rq = cpu_rq(cpu);
	...
	raw_spin_lock_irqsave(&rq->lock, flags);

Then init_idle() goes on to initialize a number of fields in the
new idle task's task structure, then calls __set_task_cpu() to set
up the new idle task on the specified CPU.

Now, __set_task_cpu() invokes set_task_rq(), which invokes task_group(),
which as mentioned before specifies lockdep_is_held(&task_rq(p)->lock)
as one of the splat-avoiding conditions.  But the new idle task does
not yet have its current CPU set to CPU 1 -- that doesn't happen until
the end of __set_task_cpu().  Therefore, task_rq(p) will return 0.

So, if I am reading the code correctly, task_group() will be checking
for CPU 0's runqueue, when we are instead holding CPU 1's runqueue lock.
The patch below fixes this by acquiring both locks, as is done during
task migration.  Untested, probably does not even compile.

Thoughts?

> [    0.031226] stack backtrace:
> [    0.031229] Pid: 4, comm: kworker/0:0 Not tainted 2.6.35-mmotm0811 #1
> [    0.031232] Call Trace:
> [    0.031237]  [<ffffffff810661eb>] lockdep_rcu_dereference+0x9d/0xa5
> [    0.031242]  [<ffffffff8102b751>] task_group+0x7b/0x8a
> [    0.031246]  [<ffffffff81b5f9b8>] ? init_idle+0x2b/0x114
> [    0.031250]  [<ffffffff8102b775>] set_task_rq+0x15/0x6e
> [    0.031253]  [<ffffffff81b5fa5e>] init_idle+0xd1/0x114
> [    0.031257]  [<ffffffff81b5fb44>] fork_idle+0x8e/0x9d
> [    0.031261]  [<ffffffff81b5de6f>] do_fork_idle+0x17/0x28
> [    0.031265]  [<ffffffff8105052b>] process_one_work+0x217/0x37d
> [    0.031269]  [<ffffffff810504ca>] ? process_one_work+0x1b6/0x37d
> [    0.031273]  [<ffffffff81b5de58>] ? do_fork_idle+0x0/0x28
> [    0.031277]  [<ffffffff81051775>] worker_thread+0x17e/0x251
> [    0.031281]  [<ffffffff810515f7>] ? worker_thread+0x0/0x251
> [    0.031285]  [<ffffffff8105544a>] kthread+0x7d/0x85
> [    0.031290]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
> [    0.031295]  [<ffffffff81558d80>] ? restore_args+0x0/0x30
> [    0.031299]  [<ffffffff810553cd>] ? kthread+0x0/0x85
> [    0.031303]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
> [    0.031333] Booting Node   0, Processors  #1 Ok.
> [    0.103111] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.104013] Brought up 2 CPUs

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 sched.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 70fa78d..81a6a0a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5314,9 +5314,11 @@ void __cpuinit init_idle_bootup_task(struct task_struct *idle)
 void __cpuinit init_idle(struct task_struct *idle, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
+	struct rq *oldrq = task_rq(idle);
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	local_irq_save(flags);
+	double_rq_lock(oldrq, rq);
 
 	__sched_fork(idle);
 	idle->state = TASK_RUNNING;
@@ -5329,7 +5331,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
 	idle->oncpu = 1;
 #endif
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	double_rq_unlock(oldrq, rq);
+	local_irq_restore(flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
 #if defined(CONFIG_PREEMPT)
