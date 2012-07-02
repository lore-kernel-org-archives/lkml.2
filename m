Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab2GBNeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:34:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36936 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab2GBNeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:34:08 -0400
Date: Mon, 2 Jul 2012 06:33:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
Message-ID: <20120702133334.GA2508@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1340964584.2936.40.camel@lappy>
 <20120629172320.GA2416@linux.vnet.ibm.com>
 <1341006040.26928.4.camel@lappy>
 <1341225139.23484.4.camel@twins>
 <20120702113541.GI2907@linux.vnet.ibm.com>
 <1341230352.23484.7.camel@twins>
 <1341234773.2958.4.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341234773.2958.4.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12070213-7182-0000-0000-000001E556C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 03:12:53PM +0200, Sasha Levin wrote:
> On Mon, 2012-07-02 at 13:59 +0200, Peter Zijlstra wrote:
> > It only needs moving back before that spin_release() thing. But unless
> > there's a reason to do it later, something like the below might be the
> > right thing. 
> > 
> > ---
> >  kernel/sched/core.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 9bb7d28..7e20e6c 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -1914,6 +1914,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
> >  	sched_info_switch(prev, next);
> >  	perf_event_task_sched_out(prev, next);
> >  	fire_sched_out_preempt_notifiers(prev, next);
> > +	rcu_switch_from(prev);
> >  	prepare_lock_switch(rq, next);
> >  	prepare_arch_switch(next);
> >  	trace_sched_switch(prev, next);
> > @@ -2082,7 +2083,6 @@ context_switch(struct rq *rq, struct task_struct *prev,
> >  #endif
> >  
> >  	/* Here we just switch the register state and the stack. */
> > -	rcu_switch_from(prev);
> >  	switch_to(prev, next, prev);
> >  
> >  	barrier();
> > 
> 
> With this patch applied, I'm seeing the following:
> 
> [   37.047889] ======================================================
> [   37.048018] [ INFO: possible circular locking dependency detected ]
> [   37.048018] 3.5.0-rc5-next-20120702-sasha-00007-gefea299 #493 Tainted: G        W   
> [   37.048018] -------------------------------------------------------
> [   37.048018] rcu_torture_rea/2545 is trying to acquire lock:
> [   37.048018]  (&rsp->gp_wq){..-...}, at: [<ffffffff81128b5d>] __wake_up+0x2d/0x70
> [   37.048018] 
> [   37.048018] but task is already holding lock:
> [   37.048018]  (&rq->lock){-.-.-.}, at: [<ffffffff83738420>] __schedule+0x1a0/0x870
> [   37.048018] 
> [   37.048018] which lock already depends on the new lock.
> [   37.048018] 
> [   37.048018] 
> [   37.048018] the existing dependency chain (in reverse order) is:
> [   37.048018] 
> -> #2 (&rq->lock){-.-.-.}:
> [   37.048018]        [<ffffffff81163813>] validate_chain+0x6a3/0x790
> [   37.048018]        [<ffffffff81163d13>] __lock_acquire+0x413/0x4b0
> [   37.048018]        [<ffffffff81163f3a>] lock_acquire+0x18a/0x1e0
> [   37.048018]        [<ffffffff83739c1b>] _raw_spin_lock+0x3b/0x70
> [   37.048018]        [<ffffffff81133401>] wake_up_new_task+0x131/0x270
> [   37.048018]        [<ffffffff810eadea>] do_fork+0x27a/0x300
> [   37.048018]        [<ffffffff81071e71>] kernel_thread+0x71/0x80
> [   37.048018]        [<ffffffff83646701>] rest_init+0x21/0x140
> [   37.048018]        [<ffffffff850d8091>] start_kernel+0x3e1/0x3ee
> [   37.048018]        [<ffffffff850d7324>] x86_64_start_reservations+0xff/0x104
> [   37.048018]        [<ffffffff850d747e>] x86_64_start_kernel+0x155/0x164
> [   37.048018] 
> -> #1 (&p->pi_lock){-.-.-.}:
> [   37.048018]        [<ffffffff81163813>] validate_chain+0x6a3/0x790
> [   37.048018]        [<ffffffff81163d13>] __lock_acquire+0x413/0x4b0
> [   37.048018]        [<ffffffff81163f3a>] lock_acquire+0x18a/0x1e0
> [   37.048018]        [<ffffffff83739db1>] _raw_spin_lock_irqsave+0x81/0xc0
> [   37.048018]        [<ffffffff81133034>] try_to_wake_up+0x34/0x290
> [   37.048018]        [<ffffffff8113329d>] default_wake_function+0xd/0x10
> [   37.048018]        [<ffffffff8111ad48>] autoremove_wake_function+0x18/0x40
> [   37.048018]        [<ffffffff81125b92>] __wake_up_common+0x52/0x90
> [   37.048018]        [<ffffffff81128b73>] __wake_up+0x43/0x70
> [   37.048018]        [<ffffffff811a4715>] rcu_start_gp+0x85/0xb0
> [   37.048018]        [<ffffffff811ab1c2>] __rcu_process_callbacks+0x142/0x170
> [   37.048018]        [<ffffffff811ab270>] rcu_process_callbacks+0x80/0xb0
> [   37.048018]        [<ffffffff810f6061>] __do_softirq+0x221/0x460
> [   37.048018]        [<ffffffff810f639d>] run_ksoftirqd+0xfd/0x230
> [   37.048018]        [<ffffffff8111a502>] kthread+0xb2/0xc0
> [   37.048018]        [<ffffffff8373c8c4>] kernel_thread_helper+0x4/0x10
> [   37.048018] 
> -> #0 (&rsp->gp_wq){..-...}:
> [   37.048018]        [<ffffffff81162dbf>] check_prev_add+0x11f/0x4d0
> [   37.048018]        [<ffffffff81163813>] validate_chain+0x6a3/0x790
> [   37.048018]        [<ffffffff81163d13>] __lock_acquire+0x413/0x4b0
> [   37.048018]        [<ffffffff81163f3a>] lock_acquire+0x18a/0x1e0
> [   37.048018]        [<ffffffff83739db1>] _raw_spin_lock_irqsave+0x81/0xc0
> [   37.048018]        [<ffffffff81128b5d>] __wake_up+0x2d/0x70
> [   37.048018]        [<ffffffff811a47b3>] rcu_report_qs_rsp+0x73/0x80
> [   37.048018]        [<ffffffff811a7c9d>] rcu_report_qs_rnp+0x26d/0x2c0
> [   37.048018]        [<ffffffff811a8c2e>] rcu_report_unblock_qs_rnp+0x7e/0x90
> [   37.048018]        [<ffffffff811a9530>] rcu_read_unlock_special+0x330/0x400
> [   37.048018]        [<ffffffff811a982a>] rcu_preempt_note_context_switch+0x22a/0x300
> [   37.048018]        [<ffffffff8373870c>] __schedule+0x48c/0x870
> [   37.048018]        [<ffffffff83739074>] preempt_schedule_irq+0x94/0xd0
> [   37.048018]        [<ffffffff8373aee6>] retint_kernel+0x26/0x30
> [   37.048018]        [<ffffffff811a337d>] rcu_torture_read_unlock+0x5d/0x60
> [   37.048018]        [<ffffffff811a361d>] rcu_torture_reader+0x29d/0x380
> [   37.048018]        [<ffffffff8111a502>] kthread+0xb2/0xc0
> [   37.048018]        [<ffffffff8373c8c4>] kernel_thread_helper+0x4/0x10
> [   37.048018] 
> [   37.048018] other info that might help us debug this:
> [   37.048018] 
> [   37.048018] Chain exists of:
>   &rsp->gp_wq --> &p->pi_lock --> &rq->lock
> 
> [   37.048018]  Possible unsafe locking scenario:
> [   37.048018] 
> [   37.048018]        CPU0                    CPU1
> [   37.048018]        ----                    ----
> [   37.048018]   lock(&rq->lock);
> [   37.048018]                                lock(&p->pi_lock);
> [   37.048018]                                lock(&rq->lock);
> [   37.048018]   lock(&rsp->gp_wq);
> [   37.048018] 
> [   37.048018]  *** DEADLOCK ***

OK, so it looks like the context-switch-time call into preemptible RCU
needs to be outside of the runqueue-lock critical section.  One way
to do this is be reverting 616c310e (Move PREEMPT_RCU preemption to
switch_to() invocation).  Sasha, could you please try this out?

							Thanx, Paul

> [   37.048018] 
> [   37.048018] 1 lock held by rcu_torture_rea/2545:
> [   37.048018]  #0:  (&rq->lock){-.-.-.}, at: [<ffffffff83738420>] __schedule+0x1a0/0x870
> [   37.048018] 
> [   37.048018] stack backtrace:
> [   37.048018] Pid: 2545, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc5-next-20120702-sasha-00007-gefea299 #493
> [   37.048018] Call Trace:
> [   37.048018]  [<ffffffff81160da5>] print_circular_bug+0x105/0x120
> [   37.048018]  [<ffffffff81162dbf>] check_prev_add+0x11f/0x4d0
> [   37.048018]  [<ffffffff81163813>] validate_chain+0x6a3/0x790
> [   37.048018]  [<ffffffff81135488>] ? sched_clock_cpu+0x108/0x120
> [   37.048018]  [<ffffffff81163d13>] __lock_acquire+0x413/0x4b0
> [   37.048018]  [<ffffffff81163f3a>] lock_acquire+0x18a/0x1e0
> [   37.048018]  [<ffffffff81128b5d>] ? __wake_up+0x2d/0x70
> [   37.048018]  [<ffffffff83739db1>] _raw_spin_lock_irqsave+0x81/0xc0
> [   37.048018]  [<ffffffff81128b5d>] ? __wake_up+0x2d/0x70
> [   37.048018]  [<ffffffff81128b5d>] __wake_up+0x2d/0x70
> [   37.048018]  [<ffffffff811a47b3>] rcu_report_qs_rsp+0x73/0x80
> [   37.048018]  [<ffffffff811a7c9d>] rcu_report_qs_rnp+0x26d/0x2c0
> [   37.048018]  [<ffffffff811a8c2e>] rcu_report_unblock_qs_rnp+0x7e/0x90
> [   37.048018]  [<ffffffff811a9530>] rcu_read_unlock_special+0x330/0x400
> [   37.048018]  [<ffffffff811604a4>] ? __lock_acquired+0x2a4/0x2e0
> [   37.048018]  [<ffffffff811a982a>] rcu_preempt_note_context_switch+0x22a/0x300
> [   37.048018]  [<ffffffff8373870c>] __schedule+0x48c/0x870
> [   37.048018]  [<ffffffff83738abd>] ? __schedule+0x83d/0x870
> [   37.048018]  [<ffffffff83739074>] preempt_schedule_irq+0x94/0xd0
> [   37.048018]  [<ffffffff8373aee6>] retint_kernel+0x26/0x30
> [   37.048018]  [<ffffffff811a9200>] ? rcu_preempt_qs+0x120/0x120
> [   37.048018]  [<ffffffff811161dd>] ? __rcu_read_unlock+0x4d/0xa0
> [   37.048018]  [<ffffffff811a337d>] rcu_torture_read_unlock+0x5d/0x60
> [   37.048018]  [<ffffffff811a361d>] rcu_torture_reader+0x29d/0x380
> [   37.048018]  [<ffffffff811a2160>] ? T.861+0x50/0x50
> [   37.048018]  [<ffffffff811a3380>] ? rcu_torture_read_unlock+0x60/0x60
> [   37.048018]  [<ffffffff8111a502>] kthread+0xb2/0xc0
> [   37.048018]  [<ffffffff8373c8c4>] kernel_thread_helper+0x4/0x10
> [   37.048018]  [<ffffffff8373adb4>] ? retint_restore_args+0x13/0x13
> [   37.048018]  [<ffffffff8111a450>] ? __init_kthread_worker+0x70/0x70
> [   37.048018]  [<ffffffff8373c8c0>] ? gs_change+0x13/0x13
> 

