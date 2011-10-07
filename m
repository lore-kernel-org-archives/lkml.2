Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1JGHIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:08:47 -0400
Received: from peace.netnation.com ([204.174.223.2]:48283 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1JGHIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:08:45 -0400
Date: Fri, 7 Oct 2011 00:08:42 -0700
From: Simon Kirby <sim@hostway.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111007070842.GA27555@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 06:40:14PM -0700, Linus Torvalds wrote:

> Peter Zijlstra (1):
>       posix-cpu-timers: Cure SMP wobbles

Hello!

I upgraded a few boxes from 3.1-rc6+fixes to 3.1-rc9 (actually 538d2882),
and now they're hard locking every 15 minutes. Below is a serial console
capture of the lockup. I suspect this is from d670ec13. I'll confirm that
they stop crashing with that commit reverted...

[ 1717.560007] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[ 1717.560007] Pid: 18034, comm: php Not tainted 3.1.0-rc9-hw+ #45
[ 1717.560007] Call Trace:
[ 1717.560007]  <NMI>  [<ffffffff816b3544>] panic+0xba/0x1fb
[ 1717.560007]  [<ffffffff81018d70>] ? native_sched_clock+0x20/0x80
[ 1717.560007]  [<ffffffff81018dd9>] ? sched_clock+0x9/0x10
[ 1717.560007]  [<ffffffff810a4751>] watchdog_overflow_callback+0xb1/0xc0
[ 1717.560007]  [<ffffffff810d0a12>] __perf_event_overflow+0xa2/0x1f0
[ 1717.560007]  [<ffffffff810c9f11>] ? perf_event_update_userpage+0x11/0xc0
[ 1717.560007]  [<ffffffff810d0f64>] perf_event_overflow+0x14/0x20
[ 1717.560007]  [<ffffffff81025a11>] intel_pmu_handle_irq+0x351/0x5f0
[ 1717.560007]  [<ffffffff816b7ff6>] perf_event_nmi_handler+0x36/0xb0
[ 1717.560007]  [<ffffffff816ba21f>] notifier_call_chain+0x3f/0x80
[ 1717.560007]  [<ffffffff816ba285>] atomic_notifier_call_chain+0x15/0x20
[ 1717.560007]  [<ffffffff816ba2be>] notify_die+0x2e/0x30
[ 1717.560007]  [<ffffffff816b76e2>] do_nmi+0xa2/0x250
[ 1717.560007]  [<ffffffff816b7080>] nmi+0x20/0x30
[ 1717.560007]  [<ffffffff8137e20d>] ? __write_lock_failed+0xd/0x20
[ 1717.560007]  <<EOE>>  [<ffffffff816b6819>] _raw_write_lock_irq+0x19/0x20
[ 1717.560007]  [<ffffffff810587c3>] copy_process+0xb23/0x1270
[ 1717.560007]  [<ffffffff81058fc2>] do_fork+0xb2/0x2f0
[ 1717.560007]  [<ffffffff8101a7e3>] sys_clone+0x23/0x30
[ 1717.560007]  [<ffffffff816be533>] stub_clone+0x13/0x20
[ 1717.560007]  [<ffffffff816be292>] ? system_call_fastpath+0x16/0x1b
[ 1717.560005] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3
[ 1717.560005] Pid: 18038, comm: httpd Not tainted 3.1.0-rc9-hw+ #45
[ 1717.560005] Call Trace:
[ 1717.560005]  <NMI>  [<ffffffff816b3544>] panic+0xba/0x1fb
[ 1717.560005]  [<ffffffff81018d70>] ? native_sched_clock+0x20/0x80
[ 1717.560005]  [<ffffffff81018dd9>] ? sched_clock+0x9/0x10
[ 1717.560005]  [<ffffffff810a4751>] watchdog_overflow_callback+0xb1/0xc0
[ 1717.560005]  [<ffffffff810d0a12>] __perf_event_overflow+0xa2/0x1f0
[ 1717.560005]  [<ffffffff810c9f11>] ? perf_event_update_userpage+0x11/0xc0
[ 1717.560005]  [<ffffffff810d0f64>] perf_event_overflow+0x14/0x20
[ 1717.560005]  [<ffffffff81025a11>] intel_pmu_handle_irq+0x351/0x5f0
[ 1717.560005]  [<ffffffff816b7ff6>] perf_event_nmi_handler+0x36/0xb0
[ 1717.560005]  [<ffffffff816ba21f>] notifier_call_chain+0x3f/0x80
[ 1717.560005]  [<ffffffff816ba285>] atomic_notifier_call_chain+0x15/0x20
[ 1717.560005]  [<ffffffff816ba2be>] notify_die+0x2e/0x30
[ 1717.560005]  [<ffffffff816b76e2>] do_nmi+0xa2/0x250
[ 1717.560005]  [<ffffffff816b7080>] nmi+0x20/0x30
[ 1717.560005]  [<ffffffff816b6644>] ? _raw_spin_lock+0x14/0x20
[ 1717.560005]  <<EOE>>  [<ffffffff8104b4e5>] task_rq_lock+0x55/0xa0
[ 1717.560005]  [<ffffffff8104b8d4>] task_sched_runtime+0x24/0x90
[ 1717.560005]  [<ffffffff8107c924>] thread_group_cputime+0x74/0xb0
[ 1717.560005]  [<ffffffff8107d126>] thread_group_cputimer+0xa6/0xf0
[ 1717.560005]  [<ffffffff8107d198>] cpu_timer_sample_group+0x28/0x90
[ 1717.560005]  [<ffffffff8107d3c3>] set_process_cpu_timer+0x33/0x110
[ 1717.560005]  [<ffffffff8107d4da>] update_rlimit_cpu+0x3a/0x60
[ 1717.560005]  [<ffffffff8106fe9e>] do_prlimit+0xfe/0x1f0
[ 1717.560005]  [<ffffffff8106ffd6>] sys_setrlimit+0x46/0x60
[ 1717.560005]  [<ffffffff816be292>] system_call_fastpath+0x16/0x1b
[ 1717.564005] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 1
[ 1717.564005] Pid: 8, comm: migration/1 Not tainted 3.1.0-rc9-hw+ #45
[ 1717.564005] Call Trace:
[ 1717.564005]  <NMI>  [<ffffffff816b3544>] panic+0xba/0x1fb
[ 1717.564005]  [<ffffffff81018d70>] ? native_sched_clock+0x20/0x80
[ 1717.564005]  [<ffffffff81018dd9>] ? sched_clock+0x9/0x10
[ 1717.564005]  [<ffffffff810a4751>] watchdog_overflow_callback+0xb1/0xc0
[ 1717.564005]  [<ffffffff810d0a12>] __perf_event_overflow+0xa2/0x1f0
[ 1717.564005]  [<ffffffff810c9f11>] ? perf_event_update_userpage+0x11/0xc0
[ 1717.564005]  [<ffffffff810d0f64>] perf_event_overflow+0x14/0x20
[ 1717.564005]  [<ffffffff81025a11>] intel_pmu_handle_irq+0x351/0x5f0
[ 1717.564005]  [<ffffffff816b7ff6>] perf_event_nmi_handler+0x36/0xb0
[ 1717.564005]  [<ffffffff816ba21f>] notifier_call_chain+0x3f/0x80
[ 1717.564005]  [<ffffffff816ba285>] atomic_notifier_call_chain+0x15/0x20
[ 1717.564005]  [<ffffffff816ba2be>] notify_die+0x2e/0x30
[ 1717.564005]  [<ffffffff816b76e2>] do_nmi+0xa2/0x250
[ 1717.564005]  [<ffffffff816b7080>] nmi+0x20/0x30
[ 1717.564005]  [<ffffffff816b6640>] ? _raw_spin_lock+0x10/0x20
[ 1717.564005]  <<EOE>>  [<ffffffff81048cfd>] double_rq_lock+0x4d/0x60
[ 1717.564005]  [<ffffffff8104fee8>] __migrate_task+0x78/0x120
[ 1717.564005]  [<ffffffff8104ff90>] ? __migrate_task+0x120/0x120
[ 1717.564005]  [<ffffffff8104ffae>] migration_cpu_stop+0x1e/0x30
[ 1717.564005]  [<ffffffff810a370c>] cpu_stopper_thread+0xcc/0x190
[ 1717.564005]  [<ffffffff8105049d>] ? default_wake_function+0xd/0x10
[ 1717.564005]  [<ffffffff81043e0a>] ? __wake_up_common+0x5a/0x90
[ 1717.564005]  [<ffffffff810a3640>] ? cgroup_release_agent+0x1d0/0x1d0
[ 1717.564005]  [<ffffffff810a3640>] ? cgroup_release_agent+0x1d0/0x1d0
[ 1717.564005]  [<ffffffff8107adb6>] kthread+0x96/0xb0
[ 1717.564005]  [<ffffffff816c0374>] kernel_thread_helper+0x4/0x10
[ 1717.564005]  [<ffffffff8107ad20>] ? kthread_worker_fn+0x190/0x190
[ 1717.564005]  [<ffffffff816c0370>] ? gs_change+0x13/0x13
[ 1717.560007] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
[ 1717.560007] Pid: 15190, comm: httpd Not tainted 3.1.0-rc9-hw+ #45
[ 1717.560007] Call Trace:
[ 1717.560007]  <NMI>  [<ffffffff816b3544>] panic+0xba/0x1fb
[ 1717.560007]  [<ffffffff81018d70>] ? native_sched_clock+0x20/0x80
[ 1717.560007]  [<ffffffff81018dd9>] ? sched_clock+0x9/0x10
[ 1717.560007]  [<ffffffff810a4751>] watchdog_overflow_callback+0xb1/0xc0
[ 1717.560007]  [<ffffffff810d0a12>] __perf_event_overflow+0xa2/0x1f0
[ 1717.560007]  [<ffffffff810c9f11>] ? perf_event_update_userpage+0x11/0xc0
[ 1717.560007]  [<ffffffff810d0f64>] perf_event_overflow+0x14/0x20
[ 1717.560007]  [<ffffffff81025a11>] intel_pmu_handle_irq+0x351/0x5f0
[ 1717.560007]  [<ffffffff816b7ff6>] perf_event_nmi_handler+0x36/0xb0
[ 1717.560007]  [<ffffffff816ba21f>] notifier_call_chain+0x3f/0x80
[ 1717.560007]  [<ffffffff816ba285>] atomic_notifier_call_chain+0x15/0x20
[ 1717.560007]  [<ffffffff816ba2be>] notify_die+0x2e/0x30
[ 1717.560007]  [<ffffffff816b76e2>] do_nmi+0xa2/0x250
[ 1717.560007]  [<ffffffff816b7080>] nmi+0x20/0x30
[ 1717.560007]  [<ffffffff816b6644>] ? _raw_spin_lock+0x14/0x20
[ 1717.560007]  <<EOE>>  [<ffffffff81048064>] update_curr+0x174/0x1a0
[ 1717.560007]  [<ffffffff8104c75c>] enqueue_task_fair+0x5c/0x520
[ 1717.560007]  [<ffffffff81048ea1>] enqueue_task+0x61/0x70
[ 1717.560007]  [<ffffffff81048ed9>] activate_task+0x29/0x40
[ 1717.560007]  [<ffffffff81050589>] wake_up_new_task+0xb9/0x160
[ 1717.560007]  [<ffffffff81059056>] do_fork+0x146/0x2f0
[ 1717.560007]  [<ffffffff81114d80>] ? fd_install+0x30/0x60
[ 1717.560007]  [<ffffffff8101a7e3>] sys_clone+0x23/0x30
[ 1717.560007]  [<ffffffff816be533>] stub_clone+0x13/0x20
[ 1717.560007]  [<ffffffff816be292>] ? system_call_fastpath+0x16/0x1b

Config: http://0x.ca/sim/ref/3.1-rc9/config

Simon-
