Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0KGSqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 13:46:13 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41750 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab0KGSqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 13:46:12 -0500
Date: Sun, 7 Nov 2010 10:46:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-08-11 - RCU whinge during very early boot
Message-ID: <20101107184608.GA15561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org>
 <10167.1281629887@localhost>
 <AANLkTim2Z=f0-=-+FEWPAdGrMdQXFWcQbKi0JCs_1KGK@mail.gmail.com>
 <20101006230400.GR2433@linux.vnet.ibm.com>
 <AANLkTikRa8vq0GBv29LaYcudta-3LWV0tcHdcCwskvB3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikRa8vq0GBv29LaYcudta-3LWV0tcHdcCwskvB3@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 02:26:02PM +0200, Zdenek Kabelac wrote:
> 2010/10/7 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > On Tue, Oct 05, 2010 at 12:05:13PM +0200, Zdenek Kabelac wrote:
> >> 2010/8/12  <Valdis.Kletnieks@vt.edu>:
> >> > On Wed, 11 Aug 2010 16:10:49 PDT, akpm@linux-foundation.org said:
> >> >> The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to
> >> >>
> >> >>    http://userweb.kernel.org/~akpm/mmotm/
> >> >
> >> > Throws a RCU complaint.  Hopefully somebody on the cc: list knows what it is about...
> >> >
> >> > [    0.026136] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz stepping 0a
> >> > [    0.028399] NMI watchdog enabled, takes one hw-pmu counter.
> >> > [    0.030019] lockdep: fixing up alternatives.
> >> > [    0.031178]
> >> > [    0.031179] ===================================================
> >> > [    0.031182] [ INFO: suspicious rcu_dereference_check() usage. ]
> >> > [    0.031184] ---------------------------------------------------
> >> > [    0.031187] kernel/sched.c:618 invoked rcu_dereference_check() without protection!
> >> > [    0.031189]
> >> > [    0.031189] other info that might help us debug this:
> >> > [    0.031190]
> >> > [    0.031192]
> >> > [    0.031193] rcu_scheduler_active = 1, debug_locks = 1
> >> > [    0.031195] 3 locks held by kworker/0:0/4:
> >> > [    0.031197]  #0:  (events){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
> >> > [    0.031210]  #1:  ((&c_idle.work)){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
> >> > [    0.031217]  #2:  (&rq->lock){-.-...}, at: [<ffffffff81b5f9b8>] init_idle+0x2b/0x114
> >> > [    0.031225]
> >> > [    0.031226] stack backtrace:
> >> > [    0.031229] Pid: 4, comm: kworker/0:0 Not tainted 2.6.35-mmotm0811 #1
> >> > [    0.031232] Call Trace:
> >> > [    0.031237]  [<ffffffff810661eb>] lockdep_rcu_dereference+0x9d/0xa5
> >> > [    0.031242]  [<ffffffff8102b751>] task_group+0x7b/0x8a
> >> > [    0.031246]  [<ffffffff81b5f9b8>] ? init_idle+0x2b/0x114
> >> > [    0.031250]  [<ffffffff8102b775>] set_task_rq+0x15/0x6e
> >> > [    0.031253]  [<ffffffff81b5fa5e>] init_idle+0xd1/0x114
> >> > [    0.031257]  [<ffffffff81b5fb44>] fork_idle+0x8e/0x9d
> >> > [    0.031261]  [<ffffffff81b5de6f>] do_fork_idle+0x17/0x28
> >> > [    0.031265]  [<ffffffff8105052b>] process_one_work+0x217/0x37d
> >> > [    0.031269]  [<ffffffff810504ca>] ? process_one_work+0x1b6/0x37d
> >> > [    0.031273]  [<ffffffff81b5de58>] ? do_fork_idle+0x0/0x28
> >> > [    0.031277]  [<ffffffff81051775>] worker_thread+0x17e/0x251
> >> > [    0.031281]  [<ffffffff810515f7>] ? worker_thread+0x0/0x251
> >> > [    0.031285]  [<ffffffff8105544a>] kthread+0x7d/0x85
> >> > [    0.031290]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
> >> > [    0.031295]  [<ffffffff81558d80>] ? restore_args+0x0/0x30
> >> > [    0.031299]  [<ffffffff810553cd>] ? kthread+0x0/0x85
> >> > [    0.031303]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
> >> > [    0.031333] Booting Node   0, Processors  #1 Ok.
> >> > [    0.103111] NMI watchdog enabled, takes one hw-pmu counter.
> >> > [    0.104013] Brought up 2 CPUs
> >> >
> >>
> >> I'm still seeing this INFO message on my vanilla 2.6.36-rc kernel.
> >>
> >> ----------------------
> >>
> >> ftrace: converting mcount calls to 0f 1f 44 00 00
> >> ftrace: allocating 16045 entries in 63 pages
> >> Setting APIC routing to flat
> >> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >> CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
> >> NMI watchdog enabled, takes one hw-pmu counter.
> >> lockdep: fixing up alternatives.
> >>
> 
> 
> > Hello, Zdenek,
> >
> > I believe that the following patch from Peter Z. should address this.
> >
> >                                                        Thanx, Paul
> >
> 
> 
> > ------------------------------------------------------------------------
> >
> > commit e3dd67d97b3c2aad366b845c797745a78efaf90d
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Thu Sep 16 17:50:31 2010 +0200
> >
> >    sched: fix RCU lockdep splat from task_group()
> >
> >    This addresses the following RCU lockdep splat:
> ...
> >    So insert an RCU read-side critical section to avoid the complaint.
> >
> >    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 09b574e..40e065e 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5331,7 +5331,19 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
> >        idle->se.exec_start = sched_clock();
> >
> >        cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
> > +       /*
> > +        * We're having a chicken and egg problem, even though we are
> > +        * holding rq->lock, the cpu isn't yet set to this cpu so the
> > +        * lockdep check in task_group() will fail.
> > +        *
> > +        * Similar case to sched_fork(). / Alternatively we could
> > +        * use task_rq_lock() here and obtain the other rq->lock.
> > +        *
> > +        * Silence PROVE_RCU
> > +        */
> > +       rcu_read_lock();
> >        __set_task_cpu(idle, cpu);
> > +       rcu_read_unlock();
> >
> >        rq->curr = rq->idle = idle;
> >  #if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
> >
> 
> 
> 
> I'm using kernel patched with this patch - but I still get this error
> - though at different place:
> (not really sure how it is related - but of course the RCU complain
> disappeared during  boot).
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> kernel/sched.c:618 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 1 lock held by make/6137:
>  #0:  (&rq->lock){......}, at: [<ffffffff810487d7>] task_fork_fair+0x67/0x180
> 
> stack backtrace:
> Pid: 6137, comm: make Not tainted 2.6.36-rc8-00024-ga7ac73b #6
> Call Trace:
>  [<ffffffff81089b7b>] lockdep_rcu_dereference+0xbb/0xc0
>  [<ffffffff8103e605>] set_task_rq+0x2f5/0x300
>  [<ffffffff810488db>] task_fork_fair+0x16b/0x180
>  [<ffffffff8104b634>] sched_fork+0xe4/0x280
>  [<ffffffff8104fa55>] copy_process+0x6e5/0x13d0
>  [<ffffffff81119809>] ? __do_fault+0x3b9/0x4b0
>  [<ffffffff810507fb>] do_fork+0x8b/0x490
>  [<ffffffff8111d6b6>] ? handle_mm_fault+0x196/0xa90
>  [<ffffffff8147dc2d>] ? retint_swapgs+0xe/0x13
>  [<ffffffff8147dc2d>] ? retint_swapgs+0xe/0x13
>  [<ffffffff8100c395>] sys_vfork+0x25/0x30
>  [<ffffffff81003583>] stub_vfork+0x13/0x20
>  [<ffffffff810031db>] ? system_call_fastpath+0x16/0x1b
> loop: module loaded

OK, so this one requires that we either be in an rcu_read_lock()
critical section, that we hold the task's alloc_lock(), that the
cgroup_mutex is held, or that the runqueue lock for the CPU that
the task last ran on is held.  Unfortunately, we are creating the
task, so there is no last CPU that it ran on, thus confusing the
check.

But this looks -really- familiar...

Could you please apply commit b0a0f667, which hit mainline after 2.6.36?

							Thanx, Paul
