Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1JLUNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 16:13:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49632 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab1JLUNv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 16:13:51 -0400
MIME-Version: 1.0
Date: Wed, 12 Oct 2011 23:13:50 +0300
Message-ID: <CAEbykaX=HWMJmTB0VCFkfW2v2G9=FcnFZBFwrYk8bFTT_FrD-Q@mail.gmail.com>
Subject: sig->cputimer.lock/rq->lock lockdep report
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got the same problem that Dave reported earlier. I bisected it to
commit d670ec13178d "posix-cpu-timers: Cure SMP wobbles".

[   23.032034] =======================================================
[   23.032039] [ INFO: possible circular locking dependency detected ]
[   23.032042] 3.1.0-rc9+ #6
[   23.032043] -------------------------------------------------------
[   23.032045] xmonad/3052 is trying to acquire lock:
[   23.032047]  (&(&sig->cputimer.lock)->rlock){-.....}, at:
[<ffffffff810855bc>] update_curr+0x12c/0x260
[   23.032057]
[   23.032057] but task is already holding lock:
[   23.032059]  (&rq->lock){-.-.-.}, at: [<ffffffff81089043>]
scheduler_tick+0x53/0x3e0
[   23.032064]
[   23.032065] which lock already depends on the new lock.
[   23.032065]
[   23.032067]
[   23.032067] the existing dependency chain (in reverse order) is:
[   23.032069]
[   23.032070] -> #2 (&rq->lock){-.-.-.}:
[   23.032073]        [<ffffffff810d2ff9>] lock_acquire+0x99/0x200
[   23.032078]        [<ffffffff816f4426>] _raw_spin_lock+0x46/0x80
[   23.032083]        [<ffffffff810881ac>] wake_up_new_task+0x9c/0x2a0
[   23.032086]        [<ffffffff8108f887>] do_fork+0x167/0x3e0
[   23.032089]        [<ffffffff8104d4d1>] kernel_thread+0x71/0x80
[   23.032093]        [<ffffffff816cac02>] rest_init+0x26/0xe4
[   23.032098]        [<ffffffff81ea6b72>] start_kernel+0x365/0x370
[   23.032103]        [<ffffffff81ea6322>] x86_64_start_reservations+0x132/0x136
[   23.032106]        [<ffffffff81ea6416>] x86_64_start_kernel+0xf0/0xf7
[   23.032109]
[   23.032110] -> #1 (&p->pi_lock){-.-.-.}:
[   23.032113]        [<ffffffff810d2ff9>] lock_acquire+0x99/0x200
[   23.032116]        [<ffffffff816f45f8>] _raw_spin_lock_irqsave+0x58/0xa0
[   23.032119]        [<ffffffff810ba0ed>] thread_group_cputimer+0x3d/0x100
[   23.032123]        [<ffffffff810ba1e2>] cpu_timer_sample_group+0x32/0xb0
[   23.032126]        [<ffffffff810baaf3>] posix_cpu_timer_set+0xf3/0x350
[   23.032129]        [<ffffffff810b6b18>] sys_timer_settime+0xa8/0x180
[   23.032134]        [<ffffffff816fc2ab>] system_call_fastpath+0x16/0x1b
[   23.032138]
[   23.032139] -> #0 (&(&sig->cputimer.lock)->rlock){-.....}:
[   23.032142]        [<ffffffff810d22b5>] __lock_acquire+0x1755/0x1d70
[   23.032145]        [<ffffffff810d2ff9>] lock_acquire+0x99/0x200
[   23.032147]        [<ffffffff816f4426>] _raw_spin_lock+0x46/0x80
[   23.032150]        [<ffffffff810855bc>] update_curr+0x12c/0x260
[   23.032153]        [<ffffffff81085c17>] task_tick_fair+0x37/0x180
[   23.032156]        [<ffffffff810890c4>] scheduler_tick+0xd4/0x3e0
[   23.032160]        [<ffffffff810a3f7e>] update_process_times+0x6e/0x90
[   23.032164]        [<ffffffff810ca314>] tick_sched_timer+0x64/0xc0
[   23.032169]        [<ffffffff810bc38f>] __run_hrtimer+0x6f/0x360
[   23.032172]        [<ffffffff810bcdf3>] hrtimer_interrupt+0xf3/0x220
[   23.032175]        [<ffffffff816fe119>] smp_apic_timer_interrupt+0x69/0x99
[   23.032179]        [<ffffffff816fcdb0>] apic_timer_interrupt+0x70/0x80
[   23.032182]        [<ffffffff8119bfac>] kmem_cache_alloc+0x1fc/0x210
[   23.032186]        [<ffffffff81151c65>] mempool_alloc_slab+0x15/0x20
[   23.032191]        [<ffffffff81151fa9>] mempool_alloc+0x59/0x150
[   23.032194]        [<ffffffff811dd73e>] bio_alloc_bioset+0x3e/0xf0
[   23.032199]        [<ffffffff81510330>] __split_and_process_bio+0x580/0x6b0
[   23.032203]        [<ffffffff815105cf>] dm_request+0x16f/0x230
[   23.032206]        [<ffffffff8133f294>] generic_make_request+0x274/0x700
[   23.032211]        [<ffffffff8133f798>] submit_bio+0x78/0xf0
[   23.032214]        [<ffffffff811e2f60>] mpage_readpages+0x120/0x140
[   23.032218]        [<ffffffff8121b90d>] ext4_readpages+0x1d/0x20
[   23.032222]        [<ffffffff8115b09a>] __do_page_cache_readahead+0x21a/0x2d0
[   23.032226]        [<ffffffff8115b2e1>] ra_submit+0x21/0x30
[   23.032229]        [<ffffffff811516f2>] filemap_fault+0x282/0x4b0
[   23.032232]        [<ffffffff81171ec1>] __do_fault+0x71/0x4b0
[   23.032237]        [<ffffffff81174824>] handle_pte_fault+0x84/0x8e0
[   23.032240]        [<ffffffff8117537f>] handle_mm_fault+0x1bf/0x2d0
[   23.032243]        [<ffffffff816f8041>] do_page_fault+0x141/0x530
[   23.032247]        [<ffffffff816f56bf>] page_fault+0x1f/0x30
[   23.032250]
[   23.032251] other info that might help us debug this:
[   23.032252]
[   23.032253] Chain exists of:
[   23.032253]   &(&sig->cputimer.lock)->rlock --> &p->pi_lock --> &rq->lock
[   23.032258]
[   23.032259]  Possible unsafe locking scenario:
[   23.032260]
[   23.032262]        CPU0                    CPU1
[   23.032263]        ----                    ----
[   23.032265]   lock(&rq->lock);
[   23.032267]                                lock(&p->pi_lock);
[   23.032270]                                lock(&rq->lock);
[   23.032272]   lock(&(&sig->cputimer.lock)->rlock);
[   23.032275]
[   23.032275]  *** DEADLOCK ***
[   23.032276]
[   23.032277] 3 locks held by xmonad/3052:
[   23.032279]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff816f7fcf>]
do_page_fault+0xcf/0x530
[   23.032284]  #1:  (&md->io_lock){++++..}, at: [<ffffffff8151049f>]
dm_request+0x3f/0x230
[   23.032289]  #2:  (&rq->lock){-.-.-.}, at: [<ffffffff81089043>]
scheduler_tick+0x53/0x3e0
[   23.032294]
[   23.032294] stack backtrace:
[   23.032297] Pid: 3052, comm: xmonad Not tainted 3.1.0-rc9+ #6
[   23.032299] Call Trace:
[   23.032301]  <IRQ>  [<ffffffff816e6d9a>] print_circular_bug+0x23d/0x24e
[   23.032308]  [<ffffffff810d22b5>] __lock_acquire+0x1755/0x1d70
[   23.032312]  [<ffffffff810bf335>] ? sched_clock_local+0x25/0x90
[   23.032316]  [<ffffffff810bf4c8>] ? sched_clock_cpu+0xa8/0x120
[   23.032318]  [<ffffffff810d2ff9>] lock_acquire+0x99/0x200
[   23.032321]  [<ffffffff810855bc>] ? update_curr+0x12c/0x260
[   23.032324]  [<ffffffff816f4426>] _raw_spin_lock+0x46/0x80
[   23.032327]  [<ffffffff810855bc>] ? update_curr+0x12c/0x260
[   23.032330]  [<ffffffff810855bc>] update_curr+0x12c/0x260
[   23.032333]  [<ffffffff81085c17>] task_tick_fair+0x37/0x180
[   23.032336]  [<ffffffff810890c4>] scheduler_tick+0xd4/0x3e0
[   23.032339]  [<ffffffff810a3f7e>] update_process_times+0x6e/0x90
[   23.032342]  [<ffffffff810ca314>] tick_sched_timer+0x64/0xc0
[   23.032345]  [<ffffffff810bc38f>] __run_hrtimer+0x6f/0x360
[   23.032348]  [<ffffffff810ca2b0>] ? tick_nohz_handler+0xf0/0xf0
[   23.032351]  [<ffffffff810bcdf3>] hrtimer_interrupt+0xf3/0x220
[   23.032354]  [<ffffffff816fe119>] smp_apic_timer_interrupt+0x69/0x99
[   23.032357]  [<ffffffff816fcdb0>] apic_timer_interrupt+0x70/0x80
[   23.032359]  <EOI>  [<ffffffff810ceeb8>] ? mark_held_locks+0x88/0x150
[   23.032365]  [<ffffffff816ea30f>] ? __slab_alloc.isra.58+0x44c/0x461
[   23.032368]  [<ffffffff81151c65>] ? mempool_alloc_slab+0x15/0x20
[   23.032371]  [<ffffffff81151c65>] ? mempool_alloc_slab+0x15/0x20
[   23.032374]  [<ffffffff810d107f>] ? __lock_acquire+0x51f/0x1d70
[   23.032377]  [<ffffffff81151c65>] ? mempool_alloc_slab+0x15/0x20
[   23.032380]  [<ffffffff8119bfac>] kmem_cache_alloc+0x1fc/0x210
[   23.032383]  [<ffffffff81151c65>] ? mempool_alloc_slab+0x15/0x20
[   23.032386]  [<ffffffff81151c65>] mempool_alloc_slab+0x15/0x20
[   23.032389]  [<ffffffff81151fa9>] mempool_alloc+0x59/0x150
[   23.032392]  [<ffffffff81151c65>] ? mempool_alloc_slab+0x15/0x20
[   23.032395]  [<ffffffff81151fa9>] ? mempool_alloc+0x59/0x150
[   23.032398]  [<ffffffff811dd73e>] bio_alloc_bioset+0x3e/0xf0
[   23.032401]  [<ffffffff81510330>] __split_and_process_bio+0x580/0x6b0
[   23.032404]  [<ffffffff8150fde1>] ? __split_and_process_bio+0x31/0x6b0
[   23.032408]  [<ffffffff810cc80d>] ? trace_hardirqs_off+0xd/0x10
[   23.032411]  [<ffffffff815105cf>] dm_request+0x16f/0x230
[   23.032414]  [<ffffffff81510493>] ? dm_request+0x33/0x230
[   23.032417]  [<ffffffff811dcfc1>] ? __bio_add_page.part.15+0x101/0x210
[   23.032421]  [<ffffffff8133f294>] generic_make_request+0x274/0x700
[   23.032424]  [<ffffffff811dd123>] ? bio_add_page+0x53/0x60
[   23.032427]  [<ffffffff811e2bd4>] ? do_mpage_readpage+0x434/0x630
[   23.032430]  [<ffffffff8133f798>] submit_bio+0x78/0xf0
[   23.032433]  [<ffffffff811e2f60>] mpage_readpages+0x120/0x140
[   23.032436]  [<ffffffff81220110>] ? noalloc_get_block_write+0x30/0x30
[   23.032439]  [<ffffffff81220110>] ? noalloc_get_block_write+0x30/0x30
[   23.032443]  [<ffffffff810cc80d>] ? trace_hardirqs_off+0xd/0x10
[   23.032446]  [<ffffffff810bf58f>] ? local_clock+0x4f/0x60
[   23.032449]  [<ffffffff8121b90d>] ext4_readpages+0x1d/0x20
[   23.032452]  [<ffffffff8115b09a>] __do_page_cache_readahead+0x21a/0x2d0
[   23.032455]  [<ffffffff8115af3e>] ? __do_page_cache_readahead+0xbe/0x2d0
[   23.032458]  [<ffffffff8115b2e1>] ra_submit+0x21/0x30
[   23.032461]  [<ffffffff811516f2>] filemap_fault+0x282/0x4b0
[   23.032464]  [<ffffffff810d107f>] ? __lock_acquire+0x51f/0x1d70
[   23.032468]  [<ffffffff81171ec1>] __do_fault+0x71/0x4b0
[   23.032471]  [<ffffffff81174824>] handle_pte_fault+0x84/0x8e0
[   23.032474]  [<ffffffff816f7fcf>] ? do_page_fault+0xcf/0x530
[   23.032478]  [<ffffffff810ccf8c>] ? lock_release_holdtime.part.23+0x11c/0x1a0
[   23.032481]  [<ffffffff816f80ec>] ? do_page_fault+0x1ec/0x530
[   23.032484]  [<ffffffff8117537f>] handle_mm_fault+0x1bf/0x2d0
[   23.032487]  [<ffffffff816f8041>] do_page_fault+0x141/0x530
[   23.032490]  [<ffffffff81171df3>] ? might_fault+0x53/0xb0
[   23.032494]  [<ffffffff8136241d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   23.032497]  [<ffffffff816f56bf>] page_fault+0x1f/0x30

Ari
