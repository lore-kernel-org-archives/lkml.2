Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab2IZOb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:31:58 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42402 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab2IZOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:31:56 -0400
Message-ID: <506311CE.30406@hp.com>
Date: Wed, 26 Sep 2012 07:31:42 -0700
From: Don Morris <don.morris@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 16/19] sched, numa: NUMA home-node selection code
References: <506310A8.5040402@hp.com>
In-Reply-To: <506310A8.5040402@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-sending to LKML due to mailer picking up an incorrect
address. (Sorry for the dupe).

On 09/26/2012 07:26 AM, Don Morris wrote:
> Peter --
> 
> You may have / probably have already seen this, and if so I
> apologize in advance (can't find any sign of a fix via any
> searches...).
> 
> I picked up your August sched/numa patch set and have been
> working on it with a 2-node and a 8-node configuration. Got
> a very intermittent crash on the 2-node which of course
> hasn't reproduced since I got the crash/kdump configured.
> (I suspect it is related, however).
> 
> On the 8-node, however, I very reliably got a hard lockup
> NMI after several minutes. This occurs when running Andrea's
> autonuma-benchmark
> (git://gitorious.org/autonuma-benchmark/autonuma-benchmark.git) reliably
> with the first test (two processes, one
> thread per core/vcore, each loops over a single malloc space).
> I'll attach the full stack set from that crash.
> 
> Since the NMI output seemed really consistent that the hard
> lockup stemmed from waiting for a spinlock that never seemed
> to be picked up, I turned on Lock debugging in the .config and
> got a very clear, very consistent circular dependency warning (just
> below).
> 
> As far as I can tell, the warning is correct and is consistent
> with the actual NMI crash output (variant in that the "pidof"
> process on cpu 52 is going through task_sched_runtime() to do
> the task_rq_lock() operation on the numa01 process which
> results in it getting the pi_lock and waiting for
> the rq->lock when numa01 (back on CPU 0) had the rq->lock
> from scheduler_tick() and is going for the pi_lock via
> task_work_add()... ).
> 
> I'm nowhere near confident enough in my knowledge of the
> nuances of run queue locking during the tick update to try
> to hack a workaround - so sorry no proposed patch fix here,
> just a bug report.
> 
> On another minor note, while looking over this and of course
> noticing that most other cpus were tied up waiting for the
> page lock on one of the huge pages (THP was of course on)
> while one of them busied itself invalidating across the other
> CPUs -- the question comes to mind if that's really needed.
> Yes, it certainly is needed in the true PROT_NONE case you're
> building off of as you certainly can't allow access to a
> translation which is now supposed to be locked out, but you
> could allow transitory minor faults when going from PROT_NONE
> back to access as the fault would clear the TLB anyway (at
> least on x86, any architecture which doesn't do that would have
> to have an explicit TLB invalidation for cases where the translation
> is detected as updated anyway, so that should be okay). In your
> case, I would think the transitory faults on what's really a
> hint to the system would probably be much better than tying up
> N-1 other CPUs to do the other flush on a process that spans
> the system -- especially if the other processors are in a scenario
> where they're running that process but working on a different page
> (and hence may never even touch the page changing access anyway).
> Even in the case where you're adding the hint (access to NONE)
> you could be willing to miss an access in favor of letting the
> next context switch invalidate the TLB for you (again, there
> may be architectures where you'll never invalidate unless it is
> explicitly, I think IPF was that way but it has been a while)
> given you really need a non-trivial run time to merit doing this
> work and have a good chance of settling out to a good access
> pattern.
> 
> Just a thought.
> 
> Thanks for your work,
> Don Morris
> 
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.6.0-rc4 #28 Not tainted
> -------------------------------------------------------
> numa01/35386 is trying to acquire lock:
>  (&p->pi_lock){-.-.-.}, at: [<ffffffff81073e68>] task_work_add+0x38/0xa0
> 
> but task is already holding lock:
>  (&rq->lock){-.-.-.}, at: [<ffffffff81085d83>] scheduler_tick+0x53/0x150
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&rq->lock){-.-.-.}:
>        [<ffffffff810b52e3>] validate_chain+0x633/0x730
>        [<ffffffff810b57d2>] __lock_acquire+0x3f2/0x490
>        [<ffffffff810b5959>] lock_acquire+0xe9/0x120
>        [<ffffffff8152e306>] _raw_spin_lock+0x36/0x70
>        [<ffffffff8108c1f1>] wake_up_new_task+0xd1/0x190
>        [<ffffffff810513f2>] do_fork+0x1f2/0x280
>        [<ffffffff8101bcd6>] kernel_thread+0x76/0x80
>        [<ffffffff81513976>] rest_init+0x26/0xc0
>        [<ffffffff81cdfeff>] start_kernel+0x3c6/0x3d3
>        [<ffffffff81cdf356>] x86_64_start_reservations+0x131/0x136
>        [<ffffffff81cdf45c>] x86_64_start_kernel+0x101/0x110
> 
> -> #0 (&p->pi_lock){-.-.-.}:
>        [<ffffffff810b48ef>] check_prev_add+0x11f/0x4e0
>        [<ffffffff810b52e3>] validate_chain+0x633/0x730
>        [<ffffffff810b57d2>] __lock_acquire+0x3f2/0x490
>        [<ffffffff810b5959>] lock_acquire+0xe9/0x120
>        [<ffffffff8152e4b5>] _raw_spin_lock_irqsave+0x55/0xa0
>        [<ffffffff81073e68>] task_work_add+0x38/0xa0
>        [<ffffffff810905d7>] task_tick_numa+0xb7/0xd0
>        [<ffffffff8109237a>] task_tick_fair+0x5a/0x70
>        [<ffffffff81085e0e>] scheduler_tick+0xde/0x150
>        [<ffffffff8106267e>] update_process_times+0x6e/0x90
>        [<ffffffff810ad803>] tick_sched_timer+0xa3/0xe0
>        [<ffffffff8107c266>] __run_hrtimer+0x106/0x1c0
>        [<ffffffff8107c5f0>] hrtimer_interrupt+0x120/0x260
>        [<ffffffff81538fdd>] smp_apic_timer_interrupt+0x8d/0xa3
>        [<ffffffff81537eaf>] apic_timer_interrupt+0x6f/0x80
>        [<ffffffff8152e326>] _raw_spin_lock+0x56/0x70
>        [<ffffffff811488e8>] do_anonymous_page+0x1e8/0x270
>        [<ffffffff8114d1fc>] handle_pte_fault+0x9c/0x2a0
>        [<ffffffff8114d5a0>] handle_mm_fault+0x1a0/0x1c0
>        [<ffffffff81532de1>] do_page_fault+0x421/0x450
>        [<ffffffff8152f2d5>] page_fault+0x25/0x30
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&rq->lock);
>                                lock(&p->pi_lock);
>                                lock(&rq->lock);
>   lock(&p->pi_lock);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by numa01/35386:
>  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81532bbc>]
> do_page_fault+0x1fc/0x450
>  #1:  (&(&mm->page_table_lock)->rlock){+.+...}, at: [<ffffffff811488e8>]
> do_anonymous_page+0x1e8/0x270
>  #2:  (&rq->lock){-.-.-.}, at: [<ffffffff81085d83>]
> scheduler_tick+0x53/0x150
> 
> stack backtrace:
> Pid: 35386, comm: numa01 Not tainted 3.6.0-rc4 #28
> Call Trace:
>  <IRQ>  [<ffffffff810b36a7>] print_circular_bug+0xf7/0x120
>  [<ffffffff8108f5d7>] ? update_sd_lb_stats+0x347/0x700
>  [<ffffffff810b48ef>] check_prev_add+0x11f/0x4e0
>  [<ffffffff8101afe5>] ? native_sched_clock+0x35/0x80
>  [<ffffffff8101a5d9>] ? sched_clock+0x9/0x10
>  [<ffffffff8108d82f>] ? sched_clock_cpu+0x4f/0x110
>  [<ffffffff810b52e3>] validate_chain+0x633/0x730
>  [<ffffffff8101a5d9>] ? sched_clock+0x9/0x10
>  [<ffffffff810b57d2>] __lock_acquire+0x3f2/0x490
>  [<ffffffff810afc5d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff810b5959>] lock_acquire+0xe9/0x120
>  [<ffffffff81073e68>] ? task_work_add+0x38/0xa0
>  [<ffffffff8152e4b5>] _raw_spin_lock_irqsave+0x55/0xa0
>  [<ffffffff81073e68>] ? task_work_add+0x38/0xa0
>  [<ffffffff81073e68>] task_work_add+0x38/0xa0
>  [<ffffffff810905d7>] task_tick_numa+0xb7/0xd0
>  [<ffffffff8109237a>] task_tick_fair+0x5a/0x70
>  [<ffffffff81085e0e>] scheduler_tick+0xde/0x150
>  [<ffffffff8106267e>] update_process_times+0x6e/0x90
>  [<ffffffff810ad803>] tick_sched_timer+0xa3/0xe0
>  [<ffffffff8107c266>] __run_hrtimer+0x106/0x1c0
>  [<ffffffff810ad760>] ? tick_nohz_restart+0xa0/0xa0
>  [<ffffffff8107c5f0>] hrtimer_interrupt+0x120/0x260
>  [<ffffffff81538fdd>] smp_apic_timer_interrupt+0x8d/0xa3
>  [<ffffffff81537eaf>] apic_timer_interrupt+0x6f/0x80
>  <EOI>  [<ffffffff8108d93b>] ? local_clock+0x4b/0x70
>  [<ffffffff812754e2>] ? do_raw_spin_lock+0xb2/0x140
>  [<ffffffff81275509>] ? do_raw_spin_lock+0xd9/0x140
>  [<ffffffff8152e326>] _raw_spin_lock+0x56/0x70
>  [<ffffffff811488e8>] ? do_anonymous_page+0x1e8/0x270
>  [<ffffffff811488e8>] do_anonymous_page+0x1e8/0x270
>  [<ffffffff8114d1fc>] handle_pte_fault+0x9c/0x2a0
>  [<ffffffff81532bbc>] ? do_page_fault+0x1fc/0x450
>  [<ffffffff810b5ddf>] ? __lock_release+0x14f/0x180
>  [<ffffffff8114d5a0>] handle_mm_fault+0x1a0/0x1c0
>  [<ffffffff8107d1c5>] ? down_read_trylock+0x55/0x70
>  [<ffffffff81532de1>] do_page_fault+0x421/0x450
>  [<ffffffff810b5ddf>] ? __lock_release+0x14f/0x180
>  [<ffffffff810b4522>] ? trace_hardirqs_on_caller+0x152/0x1c0
>  [<ffffffff810b459d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff8152ed60>] ? _raw_spin_unlock_irq+0x30/0x40
>  [<ffffffff8152d670>] ? __schedule+0x610/0x690
>  [<ffffffff8126f03d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
>  [<ffffffff8152f2d5>] page_fault+0x25/0x30
> 

