Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2AYOaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:30:17 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38183 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2AYOaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:30:15 -0500
Date: Wed, 25 Jan 2012 06:00:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, Steffen Persvold <sp@numascale.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
Message-ID: <20120125140029.GA2534@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F1FCF02.9060209@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1FCF02.9060209@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012514-8974-0000-0000-0000058B915F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 05:44:34PM +0800, Daniel J Blueman wrote:
> During validation of an interconnect which extends the AMD Opteron
> HyperTransport to many servers (Numascale NumaConnect), we observe
> RCU warnings [1] when larger systems are under specific workloads,
> and subsequent hanging.
> 
> This is reproducable via RCU-intensive activities, eg the rcutorture
> module (let me know if interested in another reproducer 'bigmap'
> that hits the spot) on eg stock 3.1.8 and 3.2.1. Reproducing on a
> subset of cores for clarity and with further debug [2], we observe
> struct rcu_node's qsmask bitfield not being cleared on typically
> three tree nodes when expected to be [3] and we see the RCU grace
> periods stop incrementing.

I do test three-level trees regularly, but on relatively small systems
by limiting CONFIG_RCU_FANOUT.  If you are running 64-bit systems
with default values of CONFIG_RCU_FANOUT, a 1024-CPU system fits into a
two-level tree, so I would guess that you either have more than 1024 CPUs
(at least as far as NR_CPUS is concerned) or gaps in your CPU-numbering
scheme.

> Has this been encountered previously?

I haven't seen that warning since I was originally developing
TREE_PREEMPT_RCU some years back.

Numascale NumaConnect is cache-coherent, right?

> Many thanks,
>   Daniel
> 
> --- [1]
> 
> WARNING: at kernel/rcutree_plugin.h:990

OK, if I have the right version, RCU-sched is trying to do a new grace
period, but finds that one of the rcu_node structure's ->qsmask fields
indicates that a CPU (or group of CPUs) failed to check into the previous
grace period.

> rcu_preempt_check_blocked_tasks+0x27/0x30()
> Hardware name: ProLiant DL165 G6
> Modules linked in:
> Pid: 21880, comm: bigmap Not tainted 3.1.8-numaconnect10+ #5
> Call Trace:
> <IRQ>  [<ffffffff810b9027>] ? rcu_preempt_check_blocked_tasks+0x27/0x30
>  [<ffffffff8106e03b>] warn_slowpath_common+0x8b/0xc0
>  [<ffffffff810c5901>] ? perf_event_task_tick+0x71/0xa0
>  [<ffffffff8106e085>] warn_slowpath_null+0x15/0x20
>  [<ffffffff810b9027>] rcu_preempt_check_blocked_tasks+0x27/0x30
>  [<ffffffff810b9193>] rcu_start_gp+0x163/0x200
>  [<ffffffff810ba0eb>] __rcu_process_callbacks+0x8b/0xd0
>  [<ffffffff810ba150>] rcu_process_callbacks+0x20/0x50
>  [<ffffffff8107422d>] __do_softirq+0x9d/0x140
>  [<ffffffff815be92c>] call_softirq+0x1c/0x30
>  [<ffffffff8103478a>] do_softirq+0x4a/0x80
>  [<ffffffff81074605>] irq_exit+0xa5/0xb0
>  [<ffffffff8104a005>] smp_apic_timer_interrupt+0x45/0x60
>  [<ffffffff815bd44b>] apic_timer_interrupt+0x6b/0x70
> <EOI>  [<ffffffff810b97e0>] ? call_rcu_sched+0x10/0x20
>  [<ffffffff8113ce60>] ? fsnotify+0x70/0x2d0
>  [<ffffffff81121b43>] ? iput_final+0xe3/0x150
>  [<ffffffff81102b45>] ? kmem_cache_free+0x15/0xa0
>  [<ffffffff81125d2a>] ? vfsmount_lock_global_lock_online+0x4a/0xc0
>  [<ffffffff8110b9ed>] __fput+0x17d/0x1f0
>  [<ffffffff8110bc07>] fput+0x17/0x20
>  [<ffffffff810ed856>] remove_vma+0x36/0x70
>  [<ffffffff810ed97e>] exit_mmap+0xee/0x120
>  [<ffffffff8106c414>] mmput+0x44/0xf0
>  [<ffffffff81070df9>] exit_mm+0x109/0x140
>  [<ffffffff810724d6>] do_exit+0x1b6/0x3d0
>  [<ffffffff8107bc8b>] ? __dequeue_signal+0x5b/0xa0
>  [<ffffffff8107272c>] do_group_exit+0x3c/0xa0
>  [<ffffffff8107e970>] get_signal_to_deliver+0x1a0/0x320
>  [<ffffffff8103273c>] do_signal+0x4c/0x120
>  [<ffffffff8107d05d>] ? kill_something_info+0x3d/0x130
>  [<ffffffff8107dc1b>] ? sys_kill+0x7b/0x90
>  [<ffffffff8103287d>] do_notify_resume+0x6d/0x80
>  [<ffffffff815bcc5b>] int_signal+0x12/0x17
> ---[ end trace 826a49848cffd17f ]---
> 
> --- [2]
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 6b76d81..7875427 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -828,6 +828,39 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp,
> struct rcu_node *rnp, struct rcu_dat
>         __note_new_gpnum(rsp, rnp, rdp);
>  }
> 
> +static void
> +_debug_print(struct rcu_data *rdp)
> +{
> +       printk(KERN_ERR "%3d %p c=%lu g=%lu pq=%d pgp=%lu qp=%d
> of=%lu ri=%lu ql=%ld qs=%c%c%c%c b=%ld ci=%lu co=%lu ca=%lu\n",
> +              rdp->cpu, rdp,
> +              rdp->completed, rdp->gpnum,
> +              rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
> +              rdp->qs_pending,
> +              rdp->offline_fqs, rdp->resched_ipi,
> +              rdp->qlen,
> +              ".N"[rdp->nxttail[RCU_NEXT_READY_TAIL] !=
> +                   rdp->nxttail[RCU_NEXT_TAIL]],
> +              ".R"[rdp->nxttail[RCU_WAIT_TAIL] !=
> +                   rdp->nxttail[RCU_NEXT_READY_TAIL]],
> +              ".W"[rdp->nxttail[RCU_DONE_TAIL] !=
> +                   rdp->nxttail[RCU_WAIT_TAIL]],
> +              ".D"[&rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL]],
> +              rdp->blimit, rdp->n_cbs_invoked, rdp->n_cbs_orphaned,
> rdp->n_cbs_adopted);
> +}
> +
> +static void
> +rcu_debug_print(struct rcu_state *rsp, struct rcu_node *rnp)
> +{
> +       int cpu;
> +
> +       if (rnp->qsmask) {
> +               printk(KERN_ERR "CPU %d, treason uncloaked, rsp @ %p
> (%s), rsp->gpnum is %lu, rnp @ %p, qsmask is 0x%lx\n",
> +                      smp_processor_id(), rsp, rsp->name,
> rsp->gpnum, rnp, rnp->qsmask);
> +               for_each_online_cpu(cpu)
> +                       _debug_print(per_cpu_ptr(rsp->rda, cpu));
> +       }
> +}
> +
>  /*
>   * Start a new RCU grace period if warranted, re-initializing the
> hierarchy
>   * in preparation for detecting the next grace period.  The caller
> must hold
> @@ -873,6 +906,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
> 
>         /* Special-case the common single-level case. */
>         if (NUM_RCU_NODES == 1) {
> +               rcu_debug_print(rsp, rnp);
>                 rcu_preempt_check_blocked_tasks(rnp);
>                 rnp->qsmask = rnp->qsmaskinit;
>                 rnp->gpnum = rsp->gpnum;
> @@ -912,6 +946,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
>          */
>         rcu_for_each_node_breadth_first(rsp, rnp) {
>                 raw_spin_lock(&rnp->lock);      /* irqs already
> disabled. */
> +               rcu_debug_print(rsp, rnp);
>                 rcu_preempt_check_blocked_tasks(rnp);
>                 rnp->qsmask = rnp->qsmaskinit;
>                 rnp->gpnum = rsp->gpnum;
> 
> --- [3]
> 
> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d000,
> qsmask is 0x1
>   0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=279
> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
>  12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=10
> ql=2 qs=.R.. b=10 ci=561 co=0 ca=0
>  24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=14
> ql=0 qs=.... b=10 ci=406 co=0 ca=0
>  36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=22
> ql=0 qs=.... b=10 ci=215 co=0 ca=0
>  48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=14
> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0

And it looks like CPU 48 is the one that did not check in.  What is
CONFIG_NO_HZ set to?  If CONFIG_NO_HZ=y, this can legitimately
happen, and printing the values of rdp->dynticks->dynticks,
rdp->dynticks->dynticks_nesting, rdp->dynticks->dynticks_nmi_nesting,
and rdp->dynticks_fqs will determine whether or not the situation is
legitimate or not.

If CONFIG_NO_HZ=n, than this should not happen.  In this case, I should
be able to provide you with a more focused debug print.

>  60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
> ql=0 qs=.... b=10 ci=50 co=0 ca=0
>  72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
> ql=0 qs=.... b=10 ci=22 co=0 ca=0
> ------------[ cut here ]------------
> WARNING: at kernel/rcutree_plugin.h:1011
> rcu_preempt_check_blocked_tasks+0x27/0x30()
> Hardware name: H8QI6
> Modules linked in: rcutorture
> Pid: 4562, comm: rcu_torture_rea Not tainted 3.2.1-numaconnect10+ #59
> Call Trace:
> <IRQ>  [<ffffffff810bb8e7>] ? rcu_preempt_check_blocked_tasks+0x27/0x30
>  [<ffffffff8106f74b>] warn_slowpath_common+0x8b/0xc0
>  [<ffffffff8106f795>] warn_slowpath_null+0x15/0x20
>  [<ffffffff810bb8e7>] rcu_preempt_check_blocked_tasks+0x27/0x30
>  [<ffffffff810bb9f2>] rcu_start_gp+0x102/0x1b0
>  [<ffffffff810bc60b>] __rcu_process_callbacks+0x8b/0xd0
>  [<ffffffff810bce70>] rcu_process_callbacks+0x20/0x40
>  [<ffffffff81075b3d>] __do_softirq+0x9d/0x140
>  [<ffffffffa0001530>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
>  [<ffffffff815da36c>] call_softirq+0x1c/0x30
>  [<ffffffff8103451a>] do_softirq+0x4a/0x80
>  [<ffffffff81075eb3>] irq_exit+0x43/0x60
>  [<ffffffff8104af95>] smp_apic_timer_interrupt+0x45/0x60
>  [<ffffffff815d8e8b>] apic_timer_interrupt+0x6b/0x70
> <EOI>  [<ffffffff815d58bf>] ? __schedule+0x34f/0x710
>  [<ffffffff810618a5>] ? update_curr+0x85/0xd0
>  [<ffffffff81090735>] ? sched_clock_local+0x15/0x80
>  [<ffffffff81090865>] ? sched_clock_cpu+0x65/0x90
>  [<ffffffffa0001530>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
>  [<ffffffff815d5f5a>] schedule+0x3a/0x60
>  [<ffffffffa0001660>] rcu_torture_reader+0x130/0x230 [rcutorture]
>  [<ffffffffa0001de0>] ? rcu_torture_writer+0x160/0x160 [rcutorture]
>  [<ffffffffa0001530>] ? rcu_torture_shuffle+0x80/0x80 [rcutorture]
>  [<ffffffff8108aa26>] kthread+0x96/0xa0
>  [<ffffffff815da274>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8108a990>] ? kthread_stop+0x70/0x70
>  [<ffffffff815da270>] ? gs_change+0xb/0xb
> ---[ end trace 19f7bd7f233f1506 ]---
> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d100,
> qsmask is 0x8
>   0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=279
> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
>  12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=10
> ql=3 qs=NR.. b=10 ci=561 co=0 ca=0
>  24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=14
> ql=0 qs=.... b=10 ci=406 co=0 ca=0
>  36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=22
> ql=0 qs=.... b=10 ci=215 co=0 ca=0
>  48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=19
> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0

Hmmmm...  Same CPU and grace-period number.  This is a repeat of the
above printout, correct?

>  60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
> ql=0 qs=.... b=10 ci=50 co=0 ca=0
>  72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
> ql=0 qs=.... b=10 ci=22 co=0 ca=0
> CPU 48, treason uncloaked, rsp @ ffffffff81a1d000 (rcu_sched),
> rsp->gpnum is 4058, rsp->completed is 4057, rnp @ ffffffff81a1d800,
> qsmask is 0x1
>   0 ffff8803f840d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=0 ri=280
> ql=1 qs=..W. b=10 ci=145949 co=0 ca=0
>  12 ffff880bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=7 ri=11
> ql=3 qs=NR.. b=10 ci=561 co=0 ca=0
>  24 ffff8813d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=15
> ql=0 qs=.... b=10 ci=406 co=0 ca=0
>  36 ffff881bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=5 ri=23
> ql=0 qs=.... b=10 ci=215 co=0 ca=0
>  48 ffff8823d040d4e0 c=4057 g=4057 pq=1 pgp=4057 qp=0 of=6 ri=21
> ql=26 qs=.RWD b=10 ci=7345 co=0 ca=0

Same here, but most of the ql= values are larger.  Later printout?

							Thanx, Paul

>  60 ffff882bd040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=16
> ql=0 qs=.... b=10 ci=50 co=0 ca=0
>  72 ffff8833d040d4e0 c=4057 g=4058 pq=1 pgp=4058 qp=0 of=6 ri=26
> ql=0 qs=.... b=10 ci=22 co=0 ca=0
> 
> -- 
> Daniel J Blueman
> Principal Software Engineer, Numascale Asia
> 

