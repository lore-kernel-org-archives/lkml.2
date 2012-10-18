Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab2JRDKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:10:37 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43863 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JRDKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:10:34 -0400
Message-ID: <507F7313.8010707@oracle.com>
Date: Wed, 17 Oct 2012 23:10:11 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: james.l.morris@oracle.com, keescook@chromium.org,
        John Johansen <john.johansen@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: yama: lockdep warning on yama_ptracer_del
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was fuzzing with trinity within a KVM tools guest (lkvm) on a linux-next kernel, and got the
following dump which I believe to be noise due to how the timers work - but I'm not 100% sure.

If that's actually noise, the solution would be to get the timer code to assign meaningful
names for it's timer mutexes, right?

[  954.666095]
[  954.666471] ======================================================
[  954.668233] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[  954.670194] 3.7.0-rc1-next-20121017-sasha-00002-g2353878-dirty #54 Tainted: G        W
[  954.672344] ------------------------------------------------------
[  954.674123] trinity-child34/8145 [HC0[0]:SC0[2]:HE0:SE0] is trying to acquire:
[  954.674123]  (ptracer_relations_lock){+.....}, at: [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]
[  954.674123] and this task is already holding:
[  954.674123]  (&(&new_timer->it_lock)->rlock){-.-...}, at: [<ffffffff81138340>] exit_itimers+0x50/0x160
[  954.674123] which would create a new lock dependency:
[  954.674123]  (&(&new_timer->it_lock)->rlock){-.-...} -> (ptracer_relations_lock){+.....}
[  954.674123]
[  954.674123] but this new dependency connects a HARDIRQ-irq-safe lock:
[  954.674123]  (&(&new_timer->it_lock)->rlock){-.-...}
... which became HARDIRQ-irq-safe at:
[  954.674123]   [<ffffffff8117f814>] __lock_acquire+0x864/0x1ca0
[  954.674123]   [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]   [<ffffffff83a67e5c>] _raw_spin_lock_irqsave+0x7c/0xc0
[  954.674123]   [<ffffffff811377d2>] posix_timer_fn+0x32/0xd0
[  954.674123]   [<ffffffff8113df49>] __run_hrtimer+0x279/0x4d0
[  954.674123]   [<ffffffff8113eff9>] hrtimer_interrupt+0x109/0x210
[  954.674123]   [<ffffffff810981d5>] smp_apic_timer_interrupt+0x85/0xa0
[  954.674123]   [<ffffffff83a6a6b2>] apic_timer_interrupt+0x72/0x80
[  954.674123]   [<ffffffff81077e55>] default_idle+0x235/0x5b0
[  954.674123]   [<ffffffff81079a38>] cpu_idle+0x138/0x160
[  954.674123]   [<ffffffff839fe5fe>] start_secondary+0x26e/0x276
[  954.674123]
[  954.674123] to a HARDIRQ-irq-unsafe lock:
[  954.674123]  (ptracer_relations_lock){+.....}
... which became HARDIRQ-irq-unsafe at:
[  954.674123] ...  [<ffffffff8117f8df>] __lock_acquire+0x92f/0x1ca0
[  954.674123]   [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]   [<ffffffff83a67f70>] _raw_spin_lock_bh+0x40/0x80
[  954.674123]   [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]   [<ffffffff819644ec>] yama_task_free+0xc/0x10
[  954.674123]   [<ffffffff81923b41>] security_task_free+0x11/0x30
[  954.674123]   [<ffffffff81106ab8>] __put_task_struct+0x68/0x110
[  954.674123]   [<ffffffff8110e6b8>] delayed_put_task_struct+0x118/0x180
[  954.674123]   [<ffffffff811c9739>] rcu_do_batch.isra.14+0x5a9/0xab0
[  954.674123]   [<ffffffff811c9e5a>] rcu_cpu_kthread+0x21a/0x630
[  954.674123]   [<ffffffff81144440>] smpboot_thread_fn+0x2b0/0x2e0
[  954.674123]   [<ffffffff81138b63>] kthread+0xe3/0xf0
[  954.674123]   [<ffffffff83a698bc>] ret_from_fork+0x7c/0xb0
[  954.674123]
[  954.674123] other info that might help us debug this:
[  954.674123]
[  954.674123]  Possible interrupt unsafe locking scenario:
[  954.674123]
[  954.674123]        CPU0                    CPU1
[  954.674123]        ----                    ----
[  954.674123]   lock(ptracer_relations_lock);
[  954.674123]                                local_irq_disable();
[  954.674123]                                lock(&(&new_timer->it_lock)->rlock);
[  954.674123]                                lock(ptracer_relations_lock);
[  954.674123]   <Interrupt>
[  954.674123]     lock(&(&new_timer->it_lock)->rlock);
[  954.674123]
[  954.674123]  *** DEADLOCK ***
[  954.674123]
[  954.674123] 1 lock held by trinity-child34/8145:
[  954.674123]  #0:  (&(&new_timer->it_lock)->rlock){-.-...}, at: [<ffffffff81138340>] exit_itimers+0x50/0x160
[  954.674123]
the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[  954.674123] -> (&(&new_timer->it_lock)->rlock){-.-...} ops: 3138190 {
[  954.674123]    IN-HARDIRQ-W at:
[  954.674123]                     [<ffffffff8117f814>] __lock_acquire+0x864/0x1ca0
[  954.674123]                     [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]                     [<ffffffff83a67e5c>] _raw_spin_lock_irqsave+0x7c/0xc0
[  954.674123]                     [<ffffffff811377d2>] posix_timer_fn+0x32/0xd0
[  954.674123]                     [<ffffffff8113df49>] __run_hrtimer+0x279/0x4d0
[  954.674123]                     [<ffffffff8113eff9>] hrtimer_interrupt+0x109/0x210
[  954.674123]                     [<ffffffff810981d5>] smp_apic_timer_interrupt+0x85/0xa0
[  954.674123]                     [<ffffffff83a6a6b2>] apic_timer_interrupt+0x72/0x80
[  954.674123]                     [<ffffffff81077e55>] default_idle+0x235/0x5b0
[  954.674123]                     [<ffffffff81079a38>] cpu_idle+0x138/0x160
[  954.674123]                     [<ffffffff839fe5fe>] start_secondary+0x26e/0x276
[  954.674123]    IN-SOFTIRQ-W at:
[  954.674123]                     [<ffffffff8117f849>] __lock_acquire+0x899/0x1ca0
[  954.674123]                     [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]                     [<ffffffff83a67e5c>] _raw_spin_lock_irqsave+0x7c/0xc0
[  954.674123]                     [<ffffffff811377d2>] posix_timer_fn+0x32/0xd0
[  954.674123]                     [<ffffffff8113df49>] __run_hrtimer+0x279/0x4d0
[  954.674123]                     [<ffffffff8113eff9>] hrtimer_interrupt+0x109/0x210
[  954.674123]                     [<ffffffff8113f13a>] __hrtimer_peek_ahead_timers+0x3a/0x50
[  954.674123]                     [<ffffffff8113f191>] hrtimer_peek_ahead_timers+0x41/0xa0
[  954.674123]                     [<ffffffff8113f227>] run_hrtimer_softirq+0x37/0x40
[  954.674123]                     [<ffffffff81113897>] __do_softirq+0x1c7/0x440
[  954.674123]                     [<ffffffff81113b48>] run_ksoftirqd+0x38/0xa0
[  954.674123]                     [<ffffffff81144440>] smpboot_thread_fn+0x2b0/0x2e0
[  954.674123]                     [<ffffffff81138b63>] kthread+0xe3/0xf0
[  954.674123]                     [<ffffffff83a698bc>] ret_from_fork+0x7c/0xb0
[  954.674123]    INITIAL USE at:
[  954.674123]                    [<ffffffff8117f997>] __lock_acquire+0x9e7/0x1ca0
[  954.674123]                    [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]                    [<ffffffff83a67e5c>] _raw_spin_lock_irqsave+0x7c/0xc0
[  954.674123]                    [<ffffffff811374a6>] __lock_timer+0xa6/0x1a0
[  954.674123]                    [<ffffffff81137e37>] sys_timer_gettime+0x17/0x100
[  954.674123]                    [<ffffffff83a69b98>] tracesys+0xe1/0xe6
[  954.674123]  }
[  954.674123]  ... key      at: [<ffffffff85d6b940>] __key.30461+0x0/0x8
[  954.674123]  ... acquired at:
[  954.674123]    [<ffffffff8117d4ca>] check_irq_usage+0x6a/0xe0
[  954.674123]    [<ffffffff811804ba>] __lock_acquire+0x150a/0x1ca0
[  954.674123]    [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]    [<ffffffff83a67f70>] _raw_spin_lock_bh+0x40/0x80
[  954.674123]    [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]    [<ffffffff819644ec>] yama_task_free+0xc/0x10
[  954.674123]    [<ffffffff81923b41>] security_task_free+0x11/0x30
[  954.674123]    [<ffffffff81106ab8>] __put_task_struct+0x68/0x110
[  954.674123]    [<ffffffff8113b6b7>] posix_cpu_timer_del+0xa7/0xe0
[  954.674123]    [<ffffffff81138435>] exit_itimers+0x145/0x160
[  954.674123]    [<ffffffff8111055a>] do_exit+0x1aa/0xbd0
[  954.674123]    [<ffffffff81111044>] do_group_exit+0x84/0xd0
[  954.674123]    [<ffffffff811110a2>] sys_exit_group+0x12/0x20
[  954.674123]    [<ffffffff83a69b98>] tracesys+0xe1/0xe6
[  954.674123]
[  954.674123]
the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[  954.674123] -> (ptracer_relations_lock){+.....} ops: 8538 {
[  954.674123]    HARDIRQ-ON-W at:
[  954.674123]                     [<ffffffff8117f8df>] __lock_acquire+0x92f/0x1ca0
[  954.674123]                     [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]                     [<ffffffff83a67f70>] _raw_spin_lock_bh+0x40/0x80
[  954.674123]                     [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]                     [<ffffffff819644ec>] yama_task_free+0xc/0x10
[  954.674123]                     [<ffffffff81923b41>] security_task_free+0x11/0x30
[  954.674123]                     [<ffffffff81106ab8>] __put_task_struct+0x68/0x110
[  954.674123]                     [<ffffffff8110e6b8>] delayed_put_task_struct+0x118/0x180
[  954.674123]                     [<ffffffff811c9739>] rcu_do_batch.isra.14+0x5a9/0xab0
[  954.674123]                     [<ffffffff811c9e5a>] rcu_cpu_kthread+0x21a/0x630
[  954.674123]                     [<ffffffff81144440>] smpboot_thread_fn+0x2b0/0x2e0
[  954.674123]                     [<ffffffff81138b63>] kthread+0xe3/0xf0
[  954.674123]                     [<ffffffff83a698bc>] ret_from_fork+0x7c/0xb0
[  954.674123]    INITIAL USE at:
[  954.674123]                    [<ffffffff8117f997>] __lock_acquire+0x9e7/0x1ca0
[  954.674123]                    [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]                    [<ffffffff83a67f70>] _raw_spin_lock_bh+0x40/0x80
[  954.674123]                    [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]                    [<ffffffff819644ec>] yama_task_free+0xc/0x10
[  954.674123]                    [<ffffffff81923b41>] security_task_free+0x11/0x30
[  954.674123]                    [<ffffffff81106ab8>] __put_task_struct+0x68/0x110
[  954.674123]                    [<ffffffff8110e6b8>] delayed_put_task_struct+0x118/0x180
[  954.674123]                    [<ffffffff811c9739>] rcu_do_batch.isra.14+0x5a9/0xab0
[  954.674123]                    [<ffffffff811c9e5a>] rcu_cpu_kthread+0x21a/0x630
[  954.674123]                    [<ffffffff81144440>] smpboot_thread_fn+0x2b0/0x2e0
[  954.674123]                    [<ffffffff81138b63>] kthread+0xe3/0xf0
[  954.674123]                    [<ffffffff83a698bc>] ret_from_fork+0x7c/0xb0
[  954.674123]  }
[  954.674123]  ... key      at: [<ffffffff854ebcb8>] ptracer_relations_lock+0x18/0x50
[  954.674123]  ... acquired at:
[  954.674123]    [<ffffffff8117d4ca>] check_irq_usage+0x6a/0xe0
[  954.674123]    [<ffffffff811804ba>] __lock_acquire+0x150a/0x1ca0
[  954.674123]    [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]    [<ffffffff83a67f70>] _raw_spin_lock_bh+0x40/0x80
[  954.674123]    [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]    [<ffffffff819644ec>] yama_task_free+0xc/0x10
[  954.674123]    [<ffffffff81923b41>] security_task_free+0x11/0x30
[  954.674123]    [<ffffffff81106ab8>] __put_task_struct+0x68/0x110
[  954.674123]    [<ffffffff8113b6b7>] posix_cpu_timer_del+0xa7/0xe0
[  954.674123]    [<ffffffff81138435>] exit_itimers+0x145/0x160
[  954.674123]    [<ffffffff8111055a>] do_exit+0x1aa/0xbd0
[  954.674123]    [<ffffffff81111044>] do_group_exit+0x84/0xd0
[  954.674123]    [<ffffffff811110a2>] sys_exit_group+0x12/0x20
[  954.674123]    [<ffffffff83a69b98>] tracesys+0xe1/0xe6
[  954.674123]
[  954.674123]
[  954.674123] stack backtrace:
[  954.674123] Pid: 8145, comm: trinity-child34 Tainted: G        W    3.7.0-rc1-next-20121017-sasha-00002-g2353878-dirty #54
[  954.674123] Call Trace:
[  954.674123]  [<ffffffff8117d43c>] check_usage+0x49c/0x4c0
[  954.674123]  [<ffffffff8117d4ca>] check_irq_usage+0x6a/0xe0
[  954.674123]  [<ffffffff811804ba>] __lock_acquire+0x150a/0x1ca0
[  954.674123]  [<ffffffff810a4e39>] ? pvclock_clocksource_read+0x69/0x100
[  954.674123]  [<ffffffff81180b00>] ? __lock_acquire+0x1b50/0x1ca0
[  954.674123]  [<ffffffff8118324a>] lock_acquire+0x1aa/0x240
[  954.674123]  [<ffffffff8196409d>] ? yama_ptracer_del+0x1d/0xa0
[  954.674123]  [<ffffffff81076bf5>] ? sched_clock+0x15/0x20
[  954.674123]  [<ffffffff83a67f70>] _raw_spin_lock_bh+0x40/0x80
[  954.674123]  [<ffffffff8196409d>] ? yama_ptracer_del+0x1d/0xa0
[  954.674123]  [<ffffffff8117b2e2>] ? get_lock_stats+0x22/0x70
[  954.674123]  [<ffffffff8196409d>] yama_ptracer_del+0x1d/0xa0
[  954.674123]  [<ffffffff819644ec>] yama_task_free+0xc/0x10
[  954.674123]  [<ffffffff81923b41>] security_task_free+0x11/0x30
[  954.674123]  [<ffffffff81106ab8>] __put_task_struct+0x68/0x110
[  954.674123]  [<ffffffff8113b6b7>] posix_cpu_timer_del+0xa7/0xe0
[  954.674123]  [<ffffffff81138435>] exit_itimers+0x145/0x160
[  954.674123]  [<ffffffff8111055a>] do_exit+0x1aa/0xbd0
[  954.674123]  [<ffffffff811cae05>] ? rcu_user_exit+0xc5/0xf0
[  954.674123]  [<ffffffff8117de7d>] ? trace_hardirqs_on+0xd/0x10
[  954.674123]  [<ffffffff81111044>] do_group_exit+0x84/0xd0
[  954.674123]  [<ffffffff811110a2>] sys_exit_group+0x12/0x20
[  954.674123]  [<ffffffff83a69b98>] tracesys+0xe1/0xe6
