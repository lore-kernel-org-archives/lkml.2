Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab2GQIQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:16:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54552 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2GQIQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:16:23 -0400
Message-ID: <50051F72.1000206@gmail.com>
Date: Tue, 17 Jul 2012 10:16:50 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: davej@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: sched, debug: INFO: possible irq lock inversion dependency detected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing using trinity inside a KVM tools guest using the latest linux-next, I've encountered a hang within the guest. When I've tried dumping tasks using sysrq-t I got the following:

[  138.777386] =========================================================
[  138.777386] [ INFO: possible irq lock inversion dependency detected ]
[  138.777386] 3.5.0-rc7-next-20120716-sasha-dirty #225 Tainted: G        W
[  138.777386] ---------------------------------------------------------
[  138.777386] swapper/0/0 just changed the state of lock:
[  138.777386]  (tasklist_lock){.?.+..}, at: [<ffffffff8113f833>] print_rq+0x53/0x190
[  138.777386] but this lock took another, HARDIRQ-unsafe lock in the past:
[  138.777386]  (&(&p->alloc_lock)->rlock){+.+...}

and interrupts could create inverse lock ordering between them.

[  138.777386]
[  138.777386] other info that might help us debug this:
[  138.777386]  Possible interrupt unsafe locking scenario:
[  138.777386]
[  138.777386]        CPU0                    CPU1
[  138.777386]        ----                    ----
[  138.777386]   lock(&(&p->alloc_lock)->rlock);
[  138.777386]                                local_irq_disable();
[  138.777386]                                lock(tasklist_lock);
[  138.777386]                                lock(&(&p->alloc_lock)->rlock);
[  138.777386]   <Interrupt>
[  138.777386]     lock(tasklist_lock);
[  138.777386]
[  138.777386]  *** DEADLOCK ***
[  138.777386]
[  138.777386] 6 locks held by swapper/0/0:
[  138.777386]  #0:  (&(&i->lock)->rlock){-.-...}, at: [<ffffffff81b5a09c>] serial8250_interrupt+0x2c/0xd0
[  138.777386]  #1:  (&port_lock_key){-.-...}, at: [<ffffffff81b5b1f3>] serial8250_handle_irq+0x23/0x80
[  138.777386]  #2:  (sysrq_key_table_lock){-.....}, at: [<ffffffff81b3eead>] __handle_sysrq+0x2d/0x180
[  138.777386]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff8112f2a0>] show_state_filter+0x0/0x220
[  138.777386]  #4:  (sched_debug_lock){-.....}, at: [<ffffffff8113ff6c>] print_cpu+0x5fc/0x710
[  138.777386]  #5:  (rcu_read_lock){.+.+..}, at: [<ffffffff8113ff60>] print_cpu+0x5f0/0x710
[  138.777386]
[  138.777386] the shortest dependencies between 2nd lock and 1st lock:
[  138.777386]  -> (&(&p->alloc_lock)->rlock){+.+...} ops: 83940 {
[  138.777386]     HARDIRQ-ON-W at:
[  138.777386]                       [<ffffffff8115cd10>] mark_irqflags+0x100/0x190
[  138.777386]                       [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]                       [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                       [<ffffffff8377fb1b>] _raw_spin_lock+0x3b/0x70
[  138.777386]                       [<ffffffff81258681>] set_task_comm+0x31/0x1c0
[  138.777386]                       [<ffffffff8111836c>] kthreadd+0x2c/0x170
[  138.777386]                       [<ffffffff83782c74>] kernel_thread_helper+0x4/0x10
[  138.777386]     SOFTIRQ-ON-W at:
[  138.777386]                       [<ffffffff8115cd33>] mark_irqflags+0x123/0x190
[  138.777386]                       [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]                       [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                       [<ffffffff8377fb1b>] _raw_spin_lock+0x3b/0x70
[  138.777386]                       [<ffffffff81258681>] set_task_comm+0x31/0x1c0
[  138.777386]                       [<ffffffff8111836c>] kthreadd+0x2c/0x170
[  138.777386]                       [<ffffffff83782c74>] kernel_thread_helper+0x4/0x10
[  138.777386]     INITIAL USE at:
[  138.777386]                      [<ffffffff8115ef24>] __lock_acquire+0x954/0xb50
[  138.777386]                      [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                      [<ffffffff8377fb1b>] _raw_spin_lock+0x3b/0x70
[  138.777386]                      [<ffffffff81258681>] set_task_comm+0x31/0x1c0
[  138.777386]                      [<ffffffff8111836c>] kthreadd+0x2c/0x170
[  138.777386]                      [<ffffffff83782c74>] kernel_thread_helper+0x4/0x10
[  138.777386]   }
[  138.777386]   ... key      at: [<ffffffff85352228>] __key.45660+0x0/0x8
[  138.777386]   ... acquired at:
[  138.777386]    [<ffffffff8115beba>] check_prevs_add+0xba/0x1a0
[  138.777386]    [<ffffffff8115c640>] validate_chain.isra.22+0x6a0/0x7b0
[  138.777386]    [<ffffffff8115f05d>] __lock_acquire+0xa8d/0xb50
[  138.777386]    [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]    [<ffffffff8377fb1b>] _raw_spin_lock+0x3b/0x70
[  138.777386]    [<ffffffff818bea25>] keyctl_session_to_parent+0x105/0x3f0
[  138.777386]    [<ffffffff818bee65>] sys_keyctl+0x155/0x1a0
[  138.777386]    [<ffffffff8378163d>] system_call_fastpath+0x1a/0x1f
[  138.777386]
[  138.777386] -> (tasklist_lock){.?.+..} ops: 31775 {
[  138.777386]    IN-HARDIRQ-R at:
[  138.777386]                     [<ffffffff8115cc51>] mark_irqflags+0x41/0x190
[  138.777386]                     [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]                     [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                     [<ffffffff8378006c>] _raw_read_lock_irqsave+0x7c/0xc0
[  138.777386]                     [<ffffffff8113f833>] print_rq+0x53/0x190
[  138.777386]                     [<ffffffff8113fffe>] print_cpu+0x68e/0x710
[  138.777386]                     [<ffffffff81140702>] sched_debug_show+0x682/0x720
[  138.777386]                     [<ffffffff8114129d>] sysrq_sched_debug_show+0xd/0x10
[  138.777386]                     [<ffffffff8112f43e>] show_state_filter+0x19e/0x220
[  138.777386]                     [<ffffffff81b3eb5b>] sysrq_handle_showstate+0xb/0x10
[  138.777386]                     [<ffffffff81b3ef37>] __handle_sysrq+0xb7/0x180
[  138.777386]                     [<ffffffff81b3f221>] handle_sysrq+0x21/0x30
[  138.777386]                     [<ffffffff81b5ab49>] serial8250_rx_chars+0x189/0x220
[  138.777386]                     [<ffffffff81b5b216>] serial8250_handle_irq+0x46/0x80
[  138.777386]                     [<ffffffff81b5b26e>] serial8250_default_handle_irq+0x1e/0x30
[  138.777386]                     [<ffffffff81b5a0be>] serial8250_interrupt+0x4e/0xd0
[  138.777386]                     [<ffffffff81196ad9>] handle_irq_event_percpu+0x139/0x420
[  138.777386]                     [<ffffffff81196e03>] handle_irq_event+0x43/0x70
[  138.777386]                     [<ffffffff81199b88>] handle_level_irq+0x98/0xe0
[  138.777386]                     [<ffffffff8106d374>] handle_irq+0x164/0x190
[  138.777386]                     [<ffffffff8106cec5>] do_IRQ+0x55/0xd0
[  138.777386]                     [<ffffffff83780caf>] ret_from_intr+0x0/0x1a
[  138.777386]                     [<ffffffff81074a65>] default_idle+0x235/0x5c0
[  138.777386]                     [<ffffffff81076648>] cpu_idle+0x118/0x160
[  138.777386]                     [<ffffffff835d3d6c>] rest_init+0x130/0x144
[  138.777386]                     [<ffffffff850efc3e>] start_kernel+0x392/0x39f
[  138.777386]                     [<ffffffff850ef397>] x86_64_start_reservations+0x101/0x105
[  138.777386]                     [<ffffffff850ef480>] x86_64_start_kernel+0xe5/0xf4
[  138.777386]    HARDIRQ-ON-R at:
[  138.777386]                     [<ffffffff8115ccdc>] mark_irqflags+0xcc/0x190
[  138.777386]                     [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]                     [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                     [<ffffffff8377ffae>] _raw_read_lock+0x3e/0x80
[  138.777386]                     [<ffffffff810ef898>] do_wait+0x178/0x3b0
[  138.777386]                     [<ffffffff810f10cb>] sys_wait4+0xbb/0xe0
[  138.777386]                     [<ffffffff81109c30>] wait_for_helper+0x80/0xa0
[  138.777386]                     [<ffffffff83782c74>] kernel_thread_helper+0x4/0x10
[  138.777386]    SOFTIRQ-ON-R at:
[  138.777386]                     [<ffffffff8115cd33>] mark_irqflags+0x123/0x190
[  138.777386]                     [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]                     [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                     [<ffffffff8377ffae>] _raw_read_lock+0x3e/0x80
[  138.777386]                     [<ffffffff810ef898>] do_wait+0x178/0x3b0
[  138.777386]                     [<ffffffff810f10cb>] sys_wait4+0xbb/0xe0
[  138.777386]                     [<ffffffff81109c30>] wait_for_helper+0x80/0xa0
[  138.777386]                     [<ffffffff83782c74>] kernel_thread_helper+0x4/0x10
[  138.777386]    INITIAL USE at:
[  138.777386]                    [<ffffffff8115ef24>] __lock_acquire+0x954/0xb50
[  138.777386]                    [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]                    [<ffffffff837805a9>] _raw_write_lock_irq+0x59/0x90
[  138.777386]                    [<ffffffff810e8015>] copy_process+0xb25/0x11c0
[  138.777386]                    [<ffffffff810e87f4>] do_fork+0x104/0x3d0
[  138.777386]                    [<ffffffff81076451>] kernel_thread+0x71/0x80
[  138.777386]                    [<ffffffff835d3c5d>] rest_init+0x21/0x144
[  138.777386]                    [<ffffffff850efc3e>] start_kernel+0x392/0x39f
[  138.777386]                    [<ffffffff850ef397>] x86_64_start_reservations+0x101/0x105
[  138.777386]                    [<ffffffff850ef480>] x86_64_start_kernel+0xe5/0xf4
[  138.777386]  }
[  138.777386]  ... key      at: [<ffffffff8481e018>] tasklist_lock+0x18/0x80
[  138.777386]  ... acquired at:
[  138.777386]    [<ffffffff8115b0e1>] check_usage_forwards+0xe1/0x100
[  138.777386]    [<ffffffff836c8351>] mark_lock_irq+0x91/0x137
[  138.777386]    [<ffffffff8115cb3b>] mark_lock+0x10b/0x1e0
[  138.777386]    [<ffffffff8115cc51>] mark_irqflags+0x41/0x190
[  138.777386]    [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]    [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]    [<ffffffff8378006c>] _raw_read_lock_irqsave+0x7c/0xc0
[  138.777386]    [<ffffffff8113f833>] print_rq+0x53/0x190
[  138.777386]    [<ffffffff8113fffe>] print_cpu+0x68e/0x710
[  138.777386]    [<ffffffff81140702>] sched_debug_show+0x682/0x720
[  138.777386]    [<ffffffff8114129d>] sysrq_sched_debug_show+0xd/0x10
[  138.777386]    [<ffffffff8112f43e>] show_state_filter+0x19e/0x220
[  138.777386]    [<ffffffff81b3eb5b>] sysrq_handle_showstate+0xb/0x10
[  138.777386]    [<ffffffff81b3ef37>] __handle_sysrq+0xb7/0x180
[  138.777386]    [<ffffffff81b3f221>] handle_sysrq+0x21/0x30
[  138.777386]    [<ffffffff81b5ab49>] serial8250_rx_chars+0x189/0x220
[  138.777386]    [<ffffffff81b5b216>] serial8250_handle_irq+0x46/0x80
[  138.777386]    [<ffffffff81b5b26e>] serial8250_default_handle_irq+0x1e/0x30
[  138.777386]    [<ffffffff81b5a0be>] serial8250_interrupt+0x4e/0xd0
[  138.777386]    [<ffffffff81196ad9>] handle_irq_event_percpu+0x139/0x420
[  138.777386]    [<ffffffff81196e03>] handle_irq_event+0x43/0x70
[  138.777386]    [<ffffffff81199b88>] handle_level_irq+0x98/0xe0
[  138.777386]    [<ffffffff8106d374>] handle_irq+0x164/0x190
[  138.777386]    [<ffffffff8106cec5>] do_IRQ+0x55/0xd0
[  138.777386]    [<ffffffff83780caf>] ret_from_intr+0x0/0x1a
[  138.777386]    [<ffffffff81074a65>] default_idle+0x235/0x5c0
[  138.777386]    [<ffffffff81076648>] cpu_idle+0x118/0x160
[  138.777386]    [<ffffffff835d3d6c>] rest_init+0x130/0x144
[  138.777386]    [<ffffffff850efc3e>] start_kernel+0x392/0x39f
[  138.777386]    [<ffffffff850ef397>] x86_64_start_reservations+0x101/0x105
[  138.777386]    [<ffffffff850ef480>] x86_64_start_kernel+0xe5/0xf4
[  138.777386]
[  138.777386]
[  138.777386] stack backtrace:
[  138.777386] Pid: 0, comm: swapper/0 Tainted: G        W    3.5.0-rc7-next-20120716-sasha-dirty #225
[  138.777386] Call Trace:
[  138.777386]  <IRQ>  [<ffffffff8115afdf>] print_irq_inversion_bug+0x1ff/0x220
[  138.777386]  [<ffffffff8115b0e1>] check_usage_forwards+0xe1/0x100
[  138.777386]  [<ffffffff8106d758>] ? dump_trace+0x1f8/0x230
[  138.777386]  [<ffffffff8115b000>] ? print_irq_inversion_bug+0x220/0x220
[  138.777386]  [<ffffffff836c8351>] mark_lock_irq+0x91/0x137
[  138.777386]  [<ffffffff8115cb3b>] mark_lock+0x10b/0x1e0
[  138.777386]  [<ffffffff8115cc51>] mark_irqflags+0x41/0x190
[  138.777386]  [<ffffffff8115eefb>] __lock_acquire+0x92b/0xb50
[  138.777386]  [<ffffffff81999038>] ? do_raw_spin_unlock+0xc8/0xe0
[  138.777386]  [<ffffffff8377fdfc>] ? _raw_spin_unlock_irqrestore+0x7c/0xa0
[  138.777386]  [<ffffffff810eb391>] ? console_unlock+0x3a1/0x3e0
[  138.777386]  [<ffffffff8116158a>] lock_acquire+0x1ca/0x270
[  138.777386]  [<ffffffff8113f833>] ? print_rq+0x53/0x190
[  138.777386]  [<ffffffff8378006c>] _raw_read_lock_irqsave+0x7c/0xc0
[  138.777386]  [<ffffffff8113f833>] ? print_rq+0x53/0x190
[  138.777386]  [<ffffffff8113f833>] print_rq+0x53/0x190
[  138.777386]  [<ffffffff8113fffe>] print_cpu+0x68e/0x710
[  138.777386]  [<ffffffff8113ff60>] ? print_cpu+0x5f0/0x710
[  138.777386]  [<ffffffff81140702>] sched_debug_show+0x682/0x720
[  138.777386]  [<ffffffff8114129d>] sysrq_sched_debug_show+0xd/0x10
[  138.777386]  [<ffffffff8112f43e>] show_state_filter+0x19e/0x220
[  138.777386]  [<ffffffff8112f2a0>] ? sched_show_task+0x1a0/0x1a0
[  138.777386]  [<ffffffff81b3eead>] ? __handle_sysrq+0x2d/0x180
[  138.777386]  [<ffffffff81b3eb5b>] sysrq_handle_showstate+0xb/0x10
[  138.777386]  [<ffffffff81b3ef37>] __handle_sysrq+0xb7/0x180
[  138.777386]  [<ffffffff81b3f221>] handle_sysrq+0x21/0x30
[  138.777386]  [<ffffffff81b5ab49>] serial8250_rx_chars+0x189/0x220
[  138.777386]  [<ffffffff8377fbf5>] ? _raw_spin_lock_irqsave+0xa5/0xc0
[  138.777386]  [<ffffffff81b5b1f3>] ? serial8250_handle_irq+0x23/0x80
[  138.777386]  [<ffffffff81b5b216>] serial8250_handle_irq+0x46/0x80
[  138.777386]  [<ffffffff81b5b26e>] serial8250_default_handle_irq+0x1e/0x30
[  138.777386]  [<ffffffff81b5a0be>] serial8250_interrupt+0x4e/0xd0
[  138.777386]  [<ffffffff81196df8>] ? handle_irq_event+0x38/0x70
[  138.777386]  [<ffffffff81196ad9>] handle_irq_event_percpu+0x139/0x420
[  138.777386]  [<ffffffff81196e03>] handle_irq_event+0x43/0x70
[  138.777386]  [<ffffffff81199b09>] ? handle_level_irq+0x19/0xe0
[  138.777386]  [<ffffffff81199b88>] handle_level_irq+0x98/0xe0
[  138.777386]  [<ffffffff8106d374>] handle_irq+0x164/0x190
[  138.777386]  [<ffffffff8106cec5>] do_IRQ+0x55/0xd0
[  138.777386]  [<ffffffff83780caf>] common_interrupt+0x6f/0x6f
[  138.777386]  <EOI>  [<ffffffff8109e036>] ? native_safe_halt+0x6/0x10
[  138.777386]  [<ffffffff8115d17d>] ? trace_hardirqs_on+0xd/0x10
[  138.777386]  [<ffffffff81074a65>] default_idle+0x235/0x5c0
[  138.777386]  [<ffffffff81076648>] cpu_idle+0x118/0x160
[  138.777386]  [<ffffffff835d3d6c>] rest_init+0x130/0x144
[  138.777386]  [<ffffffff835d3c3c>] ? csum_partial_copy_generic+0x16c/0x16c
[  138.777386]  [<ffffffff850efc3e>] start_kernel+0x392/0x39f
[  138.777386]  [<ffffffff850ef6b7>] ? obsolete_checksetup+0xaf/0xaf
[  138.777386]  [<ffffffff850ef397>] x86_64_start_reservations+0x101/0x105
[  138.777386]  [<ffffffff850ef120>] ? early_idt_handlers+0x120/0x120
[  138.777386]  [<ffffffff850ef480>] x86_64_start_kernel+0xe5/0xf4
