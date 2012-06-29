Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2F2KJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:09:27 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41893 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab2F2KJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:09:25 -0400
Message-ID: <1340964584.2936.40.camel@lappy>
Subject: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
From: Sasha Levin <levinsasha928@gmail.com>
To: paulmck <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 29 Jun 2012 12:09:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I think I've stumbled on another bug that will increase your paranoia levels even further.

I got the following lockup when fuzzing with trinity inside a KVM tools guest, using latest linux-next.

It appears that it was caused by a03d6178 ("rcu: Move RCU grace-period cleanup into kthread"). This issue doesn't reproduce easily though, it took some fuzzing before hitting it.

[   81.457842] irq event stamp: 54856
[   81.457846] BUG: spinlock recursion on CPU#3, trinity-child19/5970
[   81.457852]  lock: 0xffff880035bd6300, .magic: dead4ead, .owner: trinity-child19/5970, .owner_cpu: 3
[   81.457855] Pid: 5970, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479
[   81.457856] Call Trace:
[   81.457865]  [<ffffffff8199b9d8>] spin_dump+0x78/0xc0
[   81.457868]  [<ffffffff8199ba4b>] spin_bug+0x2b/0x40
[   81.457872]  [<ffffffff8199bb8e>] do_raw_spin_lock+0x4e/0x140
[   81.457878]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   81.457883]  [<ffffffff81130603>] ? ttwu_queue+0xd3/0x100
[   81.457886]  [<ffffffff81130603>] ttwu_queue+0xd3/0x100
[   81.457889]  [<ffffffff81132864>] ? try_to_wake_up+0x34/0x290
[   81.457891]  [<ffffffff81132a7c>] try_to_wake_up+0x24c/0x290
[   81.457895]  [<ffffffff8115fcc4>] ? __lock_acquired+0x2a4/0x2e0
[   81.457898]  [<ffffffff81132acd>] default_wake_function+0xd/0x10
[   81.457902]  [<ffffffff8111a6c8>] autoremove_wake_function+0x18/0x40
[   81.457906]  [<ffffffff811253c2>] __wake_up_common+0x52/0x90
[   81.457909]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.457912]  [<ffffffff811283a3>] __wake_up+0x43/0x70
[   81.457917]  [<ffffffff811a4173>] rcu_report_qs_rsp+0x73/0x80
[   81.457921]  [<ffffffff811a81cd>] rcu_report_qs_rnp+0x26d/0x2c0
[   81.457923]  [<ffffffff811a829e>] rcu_report_unblock_qs_rnp+0x7e/0x90
[   81.457926]  [<ffffffff811a8d70>] rcu_read_unlock_special+0x330/0x400
[   81.457928]  [<ffffffff8115d1fa>] ? get_lock_stats+0x2a/0x60
[   81.457931]  [<ffffffff811a906a>] rcu_preempt_note_context_switch+0x22a/0x300
[   81.457934]  [<ffffffff8372789a>] __schedule+0x76a/0x880
[   81.457937]  [<ffffffff81161bc6>] ? mark_held_locks+0xf6/0x120
[   81.457940]  [<ffffffff83727f34>] preempt_schedule_irq+0x94/0xd0
[   81.457943]  [<ffffffff83729da6>] retint_kernel+0x26/0x30
[   81.457946]  [<ffffffff811a8aa2>] ? rcu_read_unlock_special+0x62/0x400
[   81.457949]  [<ffffffff8115d23e>] ? put_lock_stats+0xe/0x40
[   81.457953]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.457956]  [<ffffffff81163c6a>] ? __lock_release+0x1ba/0x1d0
[   81.457958]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.457963]  [<ffffffff81115b5d>] __rcu_read_unlock+0x4d/0xa0
[   81.457965]  [<ffffffff811e0985>] find_get_page+0x235/0x260
[   81.457967]  [<ffffffff811e0750>] ? find_get_pages+0x2e0/0x2e0
[   81.457970]  [<ffffffff811e0eee>] filemap_fault+0x6e/0x4c0
[   81.457973]  [<ffffffff8120e33e>] __do_fault+0xae/0x560
[   81.457976]  [<ffffffff81134cb8>] ? sched_clock_cpu+0x108/0x120
[   81.457979]  [<ffffffff8120ee51>] handle_pte_fault+0x81/0x1f0
[   81.457982]  [<ffffffff8120f2e9>] handle_mm_fault+0x329/0x350
[   81.457985]  [<ffffffff8120b5f0>] ? follow_page+0x550/0x5a0
[   81.457988]  [<ffffffff8120f808>] __get_user_pages+0x438/0x5d0
[   81.457991]  [<ffffffff812108f6>] __mlock_vma_pages_range+0xc6/0xd0
[   81.457993]  [<ffffffff81210a01>] do_mlock_pages+0x101/0x180
[   81.457997]  [<ffffffff81211148>] sys_mlockall+0x128/0x1a0
[   81.457999]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.458678] hardirqs last  enabled at (54855): [<ffffffff8372a565>] sysret_check+0x22/0x5d
[   81.458678] hardirqs last disabled at (54856): [<ffffffff83728ce4>] _raw_spin_lock_irq+0x34/0xa0
[   81.458678] softirqs last  enabled at (54816): [<ffffffff810f5c3b>] __do_softirq+0x3db/0x460
[   81.458678] softirqs last disabled at (54797): [<ffffffff8372baec>] call_softirq+0x1c/0x30
[   81.559841] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
[   81.559841]  lock: rcu_preempt_state, .magic: dead4ead, .owner: trinity-child19/5970, .owner_cpu: 3
[   81.559841] Pid: 0, comm: swapper/1 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479
[   81.559841] Call Trace:
[   81.559841]  [<ffffffff8199b9d8>] spin_dump+0x78/0xc0
[   81.559841]  [<ffffffff8199bc3e>] do_raw_spin_lock+0xfe/0x140
[   81.559841]  [<ffffffff83728c91>] _raw_spin_lock_irqsave+0xa1/0xc0
[   81.559841]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff8112838d>] __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff811a4952>] force_quiescent_state+0x102/0x120
[   81.559841]  [<ffffffff811a95cb>] rcu_prepare_for_idle+0x32b/0x490
[   81.559841]  [<ffffffff811a994c>] rcu_idle_enter_common+0x21c/0x340
[   81.559841]  [<ffffffff81122110>] ? srcu_notifier_call_chain+0x20/0x20
[   81.559841]  [<ffffffff811a9d4b>] rcu_idle_enter+0xdb/0x150
[   81.559841]  [<ffffffff8107243e>] cpu_idle+0x10e/0x180
[   81.559841]  [<ffffffff8371ce3c>] ? setup_APIC_timer+0x88/0x8d
[   81.559841]  [<ffffffff8371c477>] start_secondary+0xd7/0xde
[   81.559841] sending NMI to all CPUs:
[   81.559841] NMI backtrace for cpu 1
[   81.559841] CPU 1 
[   81.559841] Pid: 0, comm: swapper/1 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.559841] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[   81.559841] RSP: 0018:ffff88000d5d1cb8  EFLAGS: 00000086
[   81.559841] RAX: 0000000000000400 RBX: 0000000000000001 RCX: 0000000000000830
[   81.559841] RDX: 0000000000000001 RSI: 0000000000000400 RDI: 0000000000000830
[   81.559841] RBP: ffff88000d5d1cb8 R08: ffffffff84ee09c0 R09: 0000000000000000
[   81.559841] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000001
[   81.559841] R13: ffffffff84ee09c0 R14: 0000000000000001 R15: 000000000000b024
[   81.559841] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[   81.559841] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.559841] CR2: 0000000000f73ffc CR3: 000000000bb08000 CR4: 00000000000406e0
[   81.559841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.559841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.559841] Process swapper/1 (pid: 0, threadinfo ffff88000d5d0000, task ffff88000d5c8000)
[   81.559841] Stack:
[   81.559841]  ffff88000d5d1d28 ffffffff8109602d 0000000000000000 0000000000000000
[   81.559841]  ffff88000d5d1d38 0000000000000086 0000000000000002 0000000200080000
[   81.559841]  ffff88000d5d1d08 0000000000000000 000000009486a4e0 000000009486a4e0
[   81.559841] Call Trace:
[   81.559841]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[   81.559841]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[   81.559841]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[   81.559841]  [<ffffffff8199bc43>] do_raw_spin_lock+0x103/0x140
[   81.559841]  [<ffffffff83728c91>] _raw_spin_lock_irqsave+0xa1/0xc0
[   81.559841]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff8112838d>] __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff811a4952>] force_quiescent_state+0x102/0x120
[   81.559841]  [<ffffffff811a95cb>] rcu_prepare_for_idle+0x32b/0x490
[   81.559841]  [<ffffffff811a994c>] rcu_idle_enter_common+0x21c/0x340
[   81.559841]  [<ffffffff81122110>] ? srcu_notifier_call_chain+0x20/0x20
[   81.559841]  [<ffffffff811a9d4b>] rcu_idle_enter+0xdb/0x150
[   81.559841]  [<ffffffff8107243e>] cpu_idle+0x10e/0x180
[   81.559841]  [<ffffffff8371ce3c>] ? setup_APIC_timer+0x88/0x8d
[   81.559841]  [<ffffffff8371c477>] start_secondary+0xd7/0xde
[   81.559841] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[   82.001011] NMI backtrace for cpu 0
[   82.001011] CPU 0 
[   82.001011] Pid: 0, comm: swapper/0 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   82.001011] RIP: 0010:[<ffffffff8109e497>]  [<ffffffff8109e497>] __ticket_spin_trylock+0x27/0x30
[   82.001011] RSP: 0018:ffff88000d803dc0  EFLAGS: 00000097
[   82.001011] RAX: 0000000000000000 RBX: ffff8800299d6300 RCX: 0000000000002277
[   82.001011] RDX: 0000000022772276 RSI: 0000000000010002 RDI: ffff8800299d6300
[   82.001011] RBP: ffff88000d803df8 R08: 0000000000000000 R09: 0000000000000001
[   82.001011] R10: 0000000000000000 R11: 0000000000000001 R12: 000000009205d80a
[   82.001011] R13: 000000009486a4e0 R14: 0000000000000001 R15: 0000000000000001
[   82.001011] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[   82.001011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.001011] CR2: 0000000000db6594 CR3: 000000000bffa000 CR4: 00000000000406f0
[   82.001011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.001011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   82.001011] Process swapper/0 (pid: 0, threadinfo ffffffff84800000, task ffffffff8482d400)
[   82.001011] Stack:
[   82.001011]  ffffffff8199bc0a ffff88000d803df8 0000000000000086 ffff8800299d6300
[   82.001011]  ffff8800299d6318 0000000000000001 0000000000000000 ffff88000d803e28
[   82.001011]  ffffffff83728afb ffffffff8113ff5e ffffffff83729500 ffff88000d5a16f8
[   82.001011] Call Trace:
[   82.001011]  <IRQ> 
[   82.001011]  [<ffffffff8199bc0a>] ? do_raw_spin_lock+0xca/0x140
[   82.001011]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   82.001011]  [<ffffffff8113ff5e>] ? do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff83729500>] ? _raw_spin_unlock+0x30/0x60
[   82.001011]  [<ffffffff8113ff5e>] do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff81140245>] sched_rt_period_timer+0x45/0x70
[   82.001011]  [<ffffffff8111f4f6>] __run_hrtimer+0x206/0x330
[   82.001011]  [<ffffffff81140200>] ? do_sched_rt_period_timer+0x320/0x320
[   82.001011]  [<ffffffff8111f8e8>] hrtimer_interrupt+0x118/0x230
[   82.001011]  [<ffffffff81090f55>] smp_apic_timer_interrupt+0x85/0xa0
[   82.001011]  [<ffffffff8372b0ef>] apic_timer_interrupt+0x6f/0x80
[   82.001011]  <EOI> 
[   82.001011]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[   82.001011]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[   82.001011]  [<ffffffff8116211d>] ? trace_hardirqs_on+0xd/0x10
[   82.001011]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[   82.001011]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[   82.001011]  [<ffffffff83636281>] rest_init+0x131/0x140
[   82.001011]  [<ffffffff83636150>] ? csum_partial_copy_generic+0x170/0x170
[   82.001011]  [<ffffffff850d108c>] start_kernel+0x3dc/0x3e9
[   82.001011]  [<ffffffff850d0ade>] ? kernel_init+0x28a/0x28a
[   82.001011]  [<ffffffff850d0324>] x86_64_start_reservations+0xff/0x104
[   82.001011]  [<ffffffff850d047e>] x86_64_start_kernel+0x155/0x164
[   82.001011] Code: 0f 1f 40 00 8b 17 55 89 d1 31 c0 c1 e9 10 48 89 e5 66 39 ca 75 14 8d 8a 00 00 01 00 89 d0 f0 0f b1 0f 39 c2 0f 94 c0 0f b6 c0 c9 <c3> 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 83 07 01 c9 c3 66 0f 
[   81.570014] NMI backtrace for cpu 2
[   81.570014] CPU 2 
[   81.570014] Pid: 5961, comm: trinity-child6 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.570014] RIP: 0010:[<ffffffff81984c6b>]  [<ffffffff81984c6b>] __delay+0xb/0x10
[   81.570014] RSP: 0018:ffff88001a2bb850  EFLAGS: 00000092
[   81.570014] RAX: 0000000000000000 RBX: ffff880035bd6300 RCX: 0000000069fcd06b
[   81.570014] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000001
[   81.570014] RBP: ffff88001a2bb888 R08: 0000000000000000 R09: 0000000000000001
[   81.570014] R10: 0000000000000000 R11: 0000000000000001 R12: 00000000933ba7db
[   81.570014] R13: 000000009486a4e0 R14: 0000000000000001 R15: ffff88001a2bb928
[   81.570014] FS:  00007f9767634700(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[   81.570014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   81.570014] CR2: 0000000000000ff9 CR3: 000000000b8b0000 CR4: 00000000000406e0
[   81.570014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.570014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.570014] Process trinity-child6 (pid: 5961, threadinfo ffff88001a2ba000, task ffff88001a7f3000)
[   81.570014] Stack:
[   81.570014]  ffffffff8199bc1d ffff88001a2bb888 0000000000000086 ffff880035bd6300
[   81.570014]  ffff880035bd6318 0000000000000001 0000000000000000 ffff88001a2bb8c8
[   81.570014]  ffffffff83728a78 ffffffff81139fe2 ffffffff83728b07 ffffffff81139fd5
[   81.570014] Call Trace:
[   81.570014]  [<ffffffff8199bc1d>] ? do_raw_spin_lock+0xdd/0x140
[   81.570014]  [<ffffffff83728a78>] _raw_spin_lock_nested+0x68/0x90
[   81.570014]  [<ffffffff81139fe2>] ? load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff83728b07>] ? _raw_spin_lock+0x67/0x70
[   81.570014]  [<ffffffff81139fd5>] ? load_balance+0x295/0x6e0
[   81.570014]  [<ffffffff81139fe2>] load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff81137dc0>] ? find_busiest_group+0x2a0/0x2a0
[   81.570014]  [<ffffffff8113c6df>] idle_balance+0x15f/0x240
[   81.570014]  [<ffffffff8113c5bf>] ? idle_balance+0x3f/0x240
[   81.570014]  [<ffffffff8372739d>] __schedule+0x26d/0x880
[   81.570014]  [<ffffffff83727b15>] schedule+0x55/0x60
[   81.570014]  [<ffffffff83725568>] schedule_timeout+0x38/0x2c0
[   81.570014]  [<ffffffff8115fa5d>] ? __lock_acquired+0x3d/0x2e0
[   81.570014]  [<ffffffff83726f54>] ? wait_for_common+0x44/0x170
[   81.570014]  [<ffffffff83727007>] ? wait_for_common+0xf7/0x170
[   81.570014]  [<ffffffff8372700f>] wait_for_common+0xff/0x170
[   81.570014]  [<ffffffff81132ac0>] ? try_to_wake_up+0x290/0x290
[   81.570014]  [<ffffffff811efd60>] ? lru_add_drain+0x50/0x50
[   81.570014]  [<ffffffff83727128>] wait_for_completion+0x18/0x20
[   81.570014]  [<ffffffff8110d7c0>] flush_work+0x80/0xc0
[   81.570014]  [<ffffffff8110d740>] ? start_flush_work+0x1a0/0x1a0
[   81.570014]  [<ffffffff8110cab0>] ? do_work_for_cpu+0x30/0x30
[   81.570014]  [<ffffffff8110e33b>] schedule_on_each_cpu+0x13b/0x1c0
[   81.570014]  [<ffffffff811eed90>] lru_add_drain_all+0x10/0x20
[   81.570014]  [<ffffffff812403c9>] do_pages_move+0x49/0x1e0
[   81.570014]  [<ffffffff8199bb30>] ? do_raw_spin_unlock+0xd0/0xe0
[   81.570014]  [<ffffffff812409a7>] sys_move_pages+0x2f7/0x380
[   81.570014]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.570014] Code: 55 48 c7 05 34 8e 25 03 a0 4c 98 81 48 89 e5 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 ff 15 16 8e 25 03 c9 <c3> 0f 1f 40 00 55 48 8d 04 bd 00 00 00 00 48 89 e5 65 48 8b 14 
[   81.458024] NMI backtrace for cpu 3
[   81.458024] CPU 3 
[   81.458024] Pid: 5970, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.458024] RIP: 0010:[<ffffffff81071646>]  [<ffffffff81071646>] native_read_tsc+0x6/0x20
[   81.458024] RSP: 0000:ffff88000bab15e8  EFLAGS: 00000082
[   81.458024] RAX: 0000000069fce97a RBX: ffff880035bd6300 RCX: 0000000000000000
[   81.458024] RDX: 0000000000000090 RSI: 0000000010000005 RDI: 0000000000000001
[   81.458024] RBP: ffff88000bab15e8 R08: 0000000000000000 R09: 0000000000000000
[   81.458024] R10: 0000000000000000 R11: 00000000000155d4 R12: 00000000941579c2
[   81.458024] R13: 0000000000000001 R14: 0000000000000003 R15: ffff880035a00000
[   81.458024] FS:  00007f9767634700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[   81.458024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.458024] CR2: 0000000000000008 CR3: 000000000b962000 CR4: 00000000000406e0
[   81.458024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.458024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.458024] Process trinity-child19 (pid: 5970, threadinfo ffff88000bab0000, task ffff88000b9e8000)
[   81.458024] Stack:
[   81.458024]  ffff88000bab1628 ffffffff81984ce2 ffff88000bab1618 ffff880035bd6300
[   81.458024]  00000000941579c2 000000009486a4e0 0000000000000001 ffff880035a00000
[   81.458024]  ffff88000bab1638 ffffffff81984c6a ffff88000bab1678 ffffffff8199bc1d
[   81.458024] Call Trace:
[   81.458024]  [<ffffffff81984ce2>] delay_tsc+0x42/0x140
[   81.458024]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.458024]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.458024]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   81.458024]  [<ffffffff81130603>] ? ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81130603>] ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81132864>] ? try_to_wake_up+0x34/0x290
[   81.458024]  [<ffffffff81132a7c>] try_to_wake_up+0x24c/0x290
[   81.458024]  [<ffffffff8115fcc4>] ? __lock_acquired+0x2a4/0x2e0
[   81.458024]  [<ffffffff81132acd>] default_wake_function+0xd/0x10
[   81.458024]  [<ffffffff8111a6c8>] autoremove_wake_function+0x18/0x40
[   81.458024]  [<ffffffff811253c2>] __wake_up_common+0x52/0x90
[   81.458024]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.458024]  [<ffffffff811283a3>] __wake_up+0x43/0x70
[   81.458024]  [<ffffffff811a4173>] rcu_report_qs_rsp+0x73/0x80
[   81.458024]  [<ffffffff811a81cd>] rcu_report_qs_rnp+0x26d/0x2c0
[   81.458024]  [<ffffffff811a829e>] rcu_report_unblock_qs_rnp+0x7e/0x90
[   81.458024]  [<ffffffff811a8d70>] rcu_read_unlock_special+0x330/0x400
[   81.458024]  [<ffffffff8115d1fa>] ? get_lock_stats+0x2a/0x60
[   81.458024]  [<ffffffff811a906a>] rcu_preempt_note_context_switch+0x22a/0x300
[   81.458024]  [<ffffffff8372789a>] __schedule+0x76a/0x880
[   81.458024]  [<ffffffff81161bc6>] ? mark_held_locks+0xf6/0x120
[   81.458024]  [<ffffffff83727f34>] preempt_schedule_irq+0x94/0xd0
[   81.458024]  [<ffffffff83729da6>] retint_kernel+0x26/0x30
[   81.458024]  [<ffffffff811a8aa2>] ? rcu_read_unlock_special+0x62/0x400
[   81.458024]  [<ffffffff8115d23e>] ? put_lock_stats+0xe/0x40
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81163c6a>] ? __lock_release+0x1ba/0x1d0
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81115b5d>] __rcu_read_unlock+0x4d/0xa0
[   81.458024]  [<ffffffff811e0985>] find_get_page+0x235/0x260
[   81.458024]  [<ffffffff811e0750>] ? find_get_pages+0x2e0/0x2e0
[   81.458024]  [<ffffffff811e0eee>] filemap_fault+0x6e/0x4c0
[   81.458024]  [<ffffffff8120e33e>] __do_fault+0xae/0x560
[   81.458024]  [<ffffffff81134cb8>] ? sched_clock_cpu+0x108/0x120
[   81.458024]  [<ffffffff8120ee51>] handle_pte_fault+0x81/0x1f0
[   81.458024]  [<ffffffff8120f2e9>] handle_mm_fault+0x329/0x350
[   81.458024]  [<ffffffff8120b5f0>] ? follow_page+0x550/0x5a0
[   81.458024]  [<ffffffff8120f808>] __get_user_pages+0x438/0x5d0
[   81.458024]  [<ffffffff812108f6>] __mlock_vma_pages_range+0xc6/0xd0
[   81.458024]  [<ffffffff81210a01>] do_mlock_pages+0x101/0x180
[   81.458024]  [<ffffffff81211148>] sys_mlockall+0x128/0x1a0
[   81.458024]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.458024] Code: 08 ff 15 e6 ae 7c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[   81.458024] BUG: spinlock lockup suspected on CPU#3, trinity-child19/5970
[   81.458024]  lock: 0xffff880035bd6300, .magic: dead4ead, .owner: trinity-child19/5970, .owner_cpu: 3
[   81.458024] Pid: 5970, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479
[   81.458024] Call Trace:
[   81.458024]  [<ffffffff8199b9d8>] spin_dump+0x78/0xc0
[   81.458024]  [<ffffffff8199bc3e>] do_raw_spin_lock+0xfe/0x140
[   81.458024]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   81.458024]  [<ffffffff81130603>] ? ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81130603>] ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81132864>] ? try_to_wake_up+0x34/0x290
[   81.458024]  [<ffffffff81132a7c>] try_to_wake_up+0x24c/0x290
[   81.458024]  [<ffffffff8115fcc4>] ? __lock_acquired+0x2a4/0x2e0
[   81.458024]  [<ffffffff81132acd>] default_wake_function+0xd/0x10
[   81.458024]  [<ffffffff8111a6c8>] autoremove_wake_function+0x18/0x40
[   81.458024]  [<ffffffff811253c2>] __wake_up_common+0x52/0x90
[   81.458024]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.458024]  [<ffffffff811283a3>] __wake_up+0x43/0x70
[   81.458024]  [<ffffffff811a4173>] rcu_report_qs_rsp+0x73/0x80
[   81.458024]  [<ffffffff811a81cd>] rcu_report_qs_rnp+0x26d/0x2c0
[   81.458024]  [<ffffffff811a829e>] rcu_report_unblock_qs_rnp+0x7e/0x90
[   81.458024]  [<ffffffff811a8d70>] rcu_read_unlock_special+0x330/0x400
[   81.458024]  [<ffffffff8115d1fa>] ? get_lock_stats+0x2a/0x60
[   81.458024]  [<ffffffff811a906a>] rcu_preempt_note_context_switch+0x22a/0x300
[   81.458024]  [<ffffffff8372789a>] __schedule+0x76a/0x880
[   81.458024]  [<ffffffff81161bc6>] ? mark_held_locks+0xf6/0x120
[   81.458024]  [<ffffffff83727f34>] preempt_schedule_irq+0x94/0xd0
[   81.458024]  [<ffffffff83729da6>] retint_kernel+0x26/0x30
[   81.458024]  [<ffffffff811a8aa2>] ? rcu_read_unlock_special+0x62/0x400
[   81.458024]  [<ffffffff8115d23e>] ? put_lock_stats+0xe/0x40
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81163c6a>] ? __lock_release+0x1ba/0x1d0
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81115b5d>] __rcu_read_unlock+0x4d/0xa0
[   81.458024]  [<ffffffff811e0985>] find_get_page+0x235/0x260
[   81.458024]  [<ffffffff811e0750>] ? find_get_pages+0x2e0/0x2e0
[   81.458024]  [<ffffffff811e0eee>] filemap_fault+0x6e/0x4c0
[   81.458024]  [<ffffffff8120e33e>] __do_fault+0xae/0x560
[   81.458024]  [<ffffffff81134cb8>] ? sched_clock_cpu+0x108/0x120
[   81.458024]  [<ffffffff8120ee51>] handle_pte_fault+0x81/0x1f0
[   81.458024]  [<ffffffff8120f2e9>] handle_mm_fault+0x329/0x350
[   81.458024]  [<ffffffff8120b5f0>] ? follow_page+0x550/0x5a0
[   81.458024]  [<ffffffff8120f808>] __get_user_pages+0x438/0x5d0
[   81.458024]  [<ffffffff812108f6>] __mlock_vma_pages_range+0xc6/0xd0
[   81.458024]  [<ffffffff81210a01>] do_mlock_pages+0x101/0x180
[   81.458024]  [<ffffffff81211148>] sys_mlockall+0x128/0x1a0
[   81.458024]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.458024] sending NMI to all CPUs:
[   82.001011] NMI backtrace for cpu 0
[   82.001011] CPU 0 
[   82.001011] Pid: 0, comm: swapper/0 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   82.001011] RIP: 0010:[<ffffffff81071646>]  [<ffffffff81071646>] native_read_tsc+0x6/0x20
[   82.001011] RSP: 0018:ffff88000d803d68  EFLAGS: 00000082
[   82.001011] RAX: 000000000dd5a0d4 RBX: ffff8800299d6300 RCX: 0000000000000000
[   82.001011] RDX: 0000000000000091 RSI: 0000000000010002 RDI: 0000000000000001
[   82.001011] RBP: ffff88000d803d68 R08: 0000000000000000 R09: 0000000000000001
[   82.001011] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000092dffe2d
[   82.001011] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
[   82.001011] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[   82.001011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.001011] CR2: 0000000000db6594 CR3: 000000000bffa000 CR4: 00000000000406f0
[   82.001011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.001011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   82.001011] Process swapper/0 (pid: 0, threadinfo ffffffff84800000, task ffffffff8482d400)
[   82.001011] Stack:
[   82.001011]  ffff88000d803da8 ffffffff81984ce2 ffff88000d803df8 ffff8800299d6300
[   82.001011]  0000000092dffe2d 000000009486a4e0 0000000000000001 0000000000000001
[   82.001011]  ffff88000d803db8 ffffffff81984c6a ffff88000d803df8 ffffffff8199bc1d
[   82.001011] Call Trace:
[   82.001011]  <IRQ> 
[   82.001011]  [<ffffffff81984ce2>] delay_tsc+0x42/0x140
[   82.001011]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   82.001011]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   82.001011]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   82.001011]  [<ffffffff8113ff5e>] ? do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff83729500>] ? _raw_spin_unlock+0x30/0x60
[   82.001011]  [<ffffffff8113ff5e>] do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff81140245>] sched_rt_period_timer+0x45/0x70
[   82.001011]  [<ffffffff8111f4f6>] __run_hrtimer+0x206/0x330
[   82.001011]  [<ffffffff81140200>] ? do_sched_rt_period_timer+0x320/0x320
[   82.001011]  [<ffffffff8111f8e8>] hrtimer_interrupt+0x118/0x230
[   82.001011]  [<ffffffff81090f55>] smp_apic_timer_interrupt+0x85/0xa0
[   82.001011]  [<ffffffff8372b0ef>] apic_timer_interrupt+0x6f/0x80
[   82.001011]  <EOI> 
[   82.001011]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[   82.001011]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[   82.001011]  [<ffffffff8116211d>] ? trace_hardirqs_on+0xd/0x10
[   82.001011]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[   82.001011]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[   82.001011]  [<ffffffff83636281>] rest_init+0x131/0x140
[   82.001011]  [<ffffffff83636150>] ? csum_partial_copy_generic+0x170/0x170
[   82.001011]  [<ffffffff850d108c>] start_kernel+0x3dc/0x3e9
[   82.001011]  [<ffffffff850d0ade>] ? kernel_init+0x28a/0x28a
[   82.001011]  [<ffffffff850d0324>] x86_64_start_reservations+0xff/0x104
[   82.001011]  [<ffffffff850d047e>] x86_64_start_kernel+0x155/0x164
[   82.001011] Code: 08 ff 15 e6 ae 7c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[   81.570014] NMI backtrace for cpu 2
[   81.570014] CPU 2 
[   81.570014] Pid: 5961, comm: trinity-child6 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.570014] RIP: 0010:[<ffffffff81071646>]  [<ffffffff81071646>] native_read_tsc+0x6/0x20
[   81.570014] RSP: 0018:ffff88001a2bb7f8  EFLAGS: 00000082
[   81.570014] RAX: 000000000dd5ced6 RBX: ffff880035bd6300 RCX: 0000000000000000
[   81.570014] RDX: 0000000000000091 RSI: 0000000000000003 RDI: 0000000000000001
[   81.570014] RBP: ffff88001a2bb7f8 R08: 0000000000000000 R09: 0000000000000001
[   81.570014] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000093e2c894
[   81.570014] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88001a2bb928
[   81.570014] FS:  00007f9767634700(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[   81.570014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   81.570014] CR2: 0000000000000ff9 CR3: 000000000b8b0000 CR4: 00000000000406e0
[   81.570014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.570014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.570014] Process trinity-child6 (pid: 5961, threadinfo ffff88001a2ba000, task ffff88001a7f3000)
[   81.570014] Stack:
[   81.570014]  ffff88001a2bb838 ffffffff81984ce2 ffff88001a2bb888 ffff880035bd6300
[   81.570014]  0000000093e2c894 000000009486a4e0 0000000000000001 ffff88001a2bb928
[   81.570014]  ffff88001a2bb848 ffffffff81984c6a ffff88001a2bb888 ffffffff8199bc1d
[   81.570014] Call Trace:
[   81.570014]  [<ffffffff81984ce2>] delay_tsc+0x42/0x140
[   81.570014]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.570014]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.570014]  [<ffffffff83728a78>] _raw_spin_lock_nested+0x68/0x90
[   81.570014]  [<ffffffff81139fe2>] ? load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff83728b07>] ? _raw_spin_lock+0x67/0x70
[   81.570014]  [<ffffffff81139fd5>] ? load_balance+0x295/0x6e0
[   81.570014]  [<ffffffff81139fe2>] load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff81137dc0>] ? find_busiest_group+0x2a0/0x2a0
[   81.570014]  [<ffffffff8113c6df>] idle_balance+0x15f/0x240
[   81.570014]  [<ffffffff8113c5bf>] ? idle_balance+0x3f/0x240
[   81.570014]  [<ffffffff8372739d>] __schedule+0x26d/0x880
[   81.570014]  [<ffffffff83727b15>] schedule+0x55/0x60
[   81.570014]  [<ffffffff83725568>] schedule_timeout+0x38/0x2c0
[   81.570014]  [<ffffffff8115fa5d>] ? __lock_acquired+0x3d/0x2e0
[   81.570014]  [<ffffffff83726f54>] ? wait_for_common+0x44/0x170
[   81.570014]  [<ffffffff83727007>] ? wait_for_common+0xf7/0x170
[   81.570014]  [<ffffffff8372700f>] wait_for_common+0xff/0x170
[   81.570014]  [<ffffffff81132ac0>] ? try_to_wake_up+0x290/0x290
[   81.570014]  [<ffffffff811efd60>] ? lru_add_drain+0x50/0x50
[   81.570014]  [<ffffffff83727128>] wait_for_completion+0x18/0x20
[   81.570014]  [<ffffffff8110d7c0>] flush_work+0x80/0xc0
[   81.570014]  [<ffffffff8110d740>] ? start_flush_work+0x1a0/0x1a0
[   81.570014]  [<ffffffff8110cab0>] ? do_work_for_cpu+0x30/0x30
[   81.570014]  [<ffffffff8110e33b>] schedule_on_each_cpu+0x13b/0x1c0
[   81.570014]  [<ffffffff811eed90>] lru_add_drain_all+0x10/0x20
[   81.570014]  [<ffffffff812403c9>] do_pages_move+0x49/0x1e0
[   81.570014]  [<ffffffff8199bb30>] ? do_raw_spin_unlock+0xd0/0xe0
[   81.570014]  [<ffffffff812409a7>] sys_move_pages+0x2f7/0x380
[   81.570014]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.570014] Code: 08 ff 15 e6 ae 7c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[   81.458024] NMI backtrace for cpu 3
[   81.458024] CPU 3 
[   81.458024] Pid: 5970, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.458024] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[   81.458024] RSP: 0000:ffff88000bab1598  EFLAGS: 00000086
[   81.458024] RAX: 0000000000000400 RBX: 0000000000000003 RCX: 0000000000000830
[   81.458024] RDX: 0000000000000003 RSI: 0000000000000400 RDI: 0000000000000830
[   81.458024] RBP: ffff88000bab1598 R08: ffffffff84ee09c0 R09: 0000000000000000
[   81.458024] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000003
[   81.458024] R13: ffffffff84ee09c0 R14: 0000000000000003 R15: 000000000000b024
[   81.458024] FS:  00007f9767634700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[   81.458024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.458024] CR2: 0000000000000008 CR3: 000000000b962000 CR4: 00000000000406e0
[   81.458024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.458024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.458024] Process trinity-child19 (pid: 5970, threadinfo ffff88000bab0000, task ffff88000b9e8000)
[   81.458024] Stack:
[   81.458024]  ffff88000bab1608 ffffffff8109602d 0000000000000000 ffff880035a00000
[   81.458024]  ffff88000bab1618 0000000000000086 0000000000000002 0000000200080000
[   81.458024]  ffff88000bab15e8 0000000000000000 000000009486a4e0 000000009486a4e0
[   81.458024] Call Trace:
[   81.458024]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[   81.458024]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[   81.458024]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[   81.458024]  [<ffffffff8199bc43>] do_raw_spin_lock+0x103/0x140
[   81.458024]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   81.458024]  [<ffffffff81130603>] ? ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81130603>] ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81132864>] ? try_to_wake_up+0x34/0x290
[   81.458024]  [<ffffffff81132a7c>] try_to_wake_up+0x24c/0x290
[   81.458024]  [<ffffffff8115fcc4>] ? __lock_acquired+0x2a4/0x2e0
[   81.458024]  [<ffffffff81132acd>] default_wake_function+0xd/0x10
[   81.458024]  [<ffffffff8111a6c8>] autoremove_wake_function+0x18/0x40
[   81.458024]  [<ffffffff811253c2>] __wake_up_common+0x52/0x90
[   81.458024]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.458024]  [<ffffffff811283a3>] __wake_up+0x43/0x70
[   81.458024]  [<ffffffff811a4173>] rcu_report_qs_rsp+0x73/0x80
[   81.458024]  [<ffffffff811a81cd>] rcu_report_qs_rnp+0x26d/0x2c0
[   81.458024]  [<ffffffff811a829e>] rcu_report_unblock_qs_rnp+0x7e/0x90
[   81.458024]  [<ffffffff811a8d70>] rcu_read_unlock_special+0x330/0x400
[   81.458024]  [<ffffffff8115d1fa>] ? get_lock_stats+0x2a/0x60
[   81.458024]  [<ffffffff811a906a>] rcu_preempt_note_context_switch+0x22a/0x300
[   81.458024]  [<ffffffff8372789a>] __schedule+0x76a/0x880
[   81.458024]  [<ffffffff81161bc6>] ? mark_held_locks+0xf6/0x120
[   81.458024]  [<ffffffff83727f34>] preempt_schedule_irq+0x94/0xd0
[   81.458024]  [<ffffffff83729da6>] retint_kernel+0x26/0x30
[   81.458024]  [<ffffffff811a8aa2>] ? rcu_read_unlock_special+0x62/0x400
[   81.458024]  [<ffffffff8115d23e>] ? put_lock_stats+0xe/0x40
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81163c6a>] ? __lock_release+0x1ba/0x1d0
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81115b5d>] __rcu_read_unlock+0x4d/0xa0
[   81.458024]  [<ffffffff811e0985>] find_get_page+0x235/0x260
[   81.458024]  [<ffffffff811e0750>] ? find_get_pages+0x2e0/0x2e0
[   81.458024]  [<ffffffff811e0eee>] filemap_fault+0x6e/0x4c0
[   81.458024]  [<ffffffff8120e33e>] __do_fault+0xae/0x560
[   81.458024]  [<ffffffff81134cb8>] ? sched_clock_cpu+0x108/0x120
[   81.458024]  [<ffffffff8120ee51>] handle_pte_fault+0x81/0x1f0
[   81.458024]  [<ffffffff8120f2e9>] handle_mm_fault+0x329/0x350
[   81.458024]  [<ffffffff8120b5f0>] ? follow_page+0x550/0x5a0
[   81.458024]  [<ffffffff8120f808>] __get_user_pages+0x438/0x5d0
[   81.458024]  [<ffffffff812108f6>] __mlock_vma_pages_range+0xc6/0xd0
[   81.458024]  [<ffffffff81210a01>] do_mlock_pages+0x101/0x180
[   81.458024]  [<ffffffff81211148>] sys_mlockall+0x128/0x1a0
[   81.458024]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.458024] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[   81.559841] NMI backtrace for cpu 1
[   81.559841] CPU 1 
[   81.559841] Pid: 0, comm: swapper/1 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.559841] RIP: 0010:[<ffffffff8199bbf8>]  [<ffffffff8199bbf8>] do_raw_spin_lock+0xb8/0x140
[   81.559841] RSP: 0018:ffff88000d5d1d68  EFLAGS: 00000082
[   81.559841] RAX: 0000000400000000 RBX: ffffffff84b73020 RCX: 000000000db8c30f
[   81.559841] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000001
[   81.559841] RBP: ffff88000d5d1d98 R08: 0000000000000000 R09: 0000000000000000
[   81.559841] R10: 0000000000000000 R11: 0000000000000002 R12: 000000000078280c
[   81.559841] R13: 000000009486a4e0 R14: 0000000000000000 R15: 0000000000000000
[   81.559841] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[   81.559841] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.559841] CR2: 0000000000f73ffc CR3: 000000000bb08000 CR4: 00000000000406e0
[   81.559841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.559841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.559841] Process swapper/1 (pid: 0, threadinfo ffff88000d5d0000, task ffff88000d5c8000)
[   81.559841] Stack:
[   81.559841]  ffff88000d5d1d98 0000000000000086 ffffffff84b73020 ffffffff84b73038
[   81.559841]  0000000000000086 0000000000000001 ffff88000d5d1dd8 ffffffff83728c91
[   81.559841]  ffffffff8112838d 0000000000000086 ffff88000d5d1df8 ffffffff84b73020
[   81.559841] Call Trace:
[   81.559841]  [<ffffffff83728c91>] _raw_spin_lock_irqsave+0xa1/0xc0
[   81.559841]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff8112838d>] __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff811a4952>] force_quiescent_state+0x102/0x120
[   81.559841]  [<ffffffff811a95cb>] rcu_prepare_for_idle+0x32b/0x490
[   81.559841]  [<ffffffff811a994c>] rcu_idle_enter_common+0x21c/0x340
[   81.559841]  [<ffffffff81122110>] ? srcu_notifier_call_chain+0x20/0x20
[   81.559841]  [<ffffffff811a9d4b>] rcu_idle_enter+0xdb/0x150
[   81.559841]  [<ffffffff8107243e>] cpu_idle+0x10e/0x180
[   81.559841]  [<ffffffff8371ce3c>] ? setup_APIC_timer+0x88/0x8d
[   81.559841]  [<ffffffff8371c477>] start_secondary+0xd7/0xde
[   81.559841] Code: 28 70 ff 66 90 85 c0 75 72 4c 69 2d 4f 15 e9 02 e8 03 00 00 41 be 01 00 00 00 eb 3e 0f 1f 80 00 00 00 00 48 83 3d 68 a8 ea 02 00 <75> 08 0f 0b 0f 1f 40 00 eb fe 48 89 df e8 66 28 70 ff 66 90 85 
[   81.570014] BUG: spinlock lockup suspected on CPU#2, trinity-child6/5961
[   81.570014]  lock: 0xffff880035bd6300, .magic: dead4ead, .owner: trinity-child19/5970, .owner_cpu: 3
[   81.570014] Pid: 5961, comm: trinity-child6 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479
[   81.570014] Call Trace:
[   81.570014]  [<ffffffff8199b9d8>] spin_dump+0x78/0xc0
[   81.570014]  [<ffffffff8199bc3e>] do_raw_spin_lock+0xfe/0x140
[   81.570014]  [<ffffffff83728a78>] _raw_spin_lock_nested+0x68/0x90
[   81.570014]  [<ffffffff81139fe2>] ? load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff83728b07>] ? _raw_spin_lock+0x67/0x70
[   81.570014]  [<ffffffff81139fd5>] ? load_balance+0x295/0x6e0
[   81.570014]  [<ffffffff81139fe2>] load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff81137dc0>] ? find_busiest_group+0x2a0/0x2a0
[   81.570014]  [<ffffffff8113c6df>] idle_balance+0x15f/0x240
[   81.570014]  [<ffffffff8113c5bf>] ? idle_balance+0x3f/0x240
[   81.570014]  [<ffffffff8372739d>] __schedule+0x26d/0x880
[   81.570014]  [<ffffffff83727b15>] schedule+0x55/0x60
[   81.570014]  [<ffffffff83725568>] schedule_timeout+0x38/0x2c0
[   81.570014]  [<ffffffff8115fa5d>] ? __lock_acquired+0x3d/0x2e0
[   81.570014]  [<ffffffff83726f54>] ? wait_for_common+0x44/0x170
[   81.570014]  [<ffffffff83727007>] ? wait_for_common+0xf7/0x170
[   81.570014]  [<ffffffff8372700f>] wait_for_common+0xff/0x170
[   81.570014]  [<ffffffff81132ac0>] ? try_to_wake_up+0x290/0x290
[   81.570014]  [<ffffffff811efd60>] ? lru_add_drain+0x50/0x50
[   81.570014]  [<ffffffff83727128>] wait_for_completion+0x18/0x20
[   81.570014]  [<ffffffff8110d7c0>] flush_work+0x80/0xc0
[   81.570014]  [<ffffffff8110d740>] ? start_flush_work+0x1a0/0x1a0
[   81.570014]  [<ffffffff8110cab0>] ? do_work_for_cpu+0x30/0x30
[   81.570014]  [<ffffffff8110e33b>] schedule_on_each_cpu+0x13b/0x1c0
[   81.570014]  [<ffffffff811eed90>] lru_add_drain_all+0x10/0x20
[   81.570014]  [<ffffffff812403c9>] do_pages_move+0x49/0x1e0
[   81.570014]  [<ffffffff8199bb30>] ? do_raw_spin_unlock+0xd0/0xe0
[   81.570014]  [<ffffffff812409a7>] sys_move_pages+0x2f7/0x380
[   81.570014]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.570014] sending NMI to all CPUs:
[   82.001011] NMI backtrace for cpu 0
[   82.001011] CPU 0 
[   82.001011] Pid: 0, comm: swapper/0 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   82.001011] RIP: 0010:[<ffffffff8107164c>]  [<ffffffff8107164c>] native_read_tsc+0xc/0x20
[   82.001011] RSP: 0018:ffff88000d803d70  EFLAGS: 00000082
[   82.001011] RAX: 0000000000000091 RBX: 00000000a3e8fee8 RCX: 00000000a3e8ff0f
[   82.001011] RDX: 0000000000000091 RSI: 0000000000010002 RDI: 0000000000000001
[   82.001011] RBP: ffff88000d803da8 R08: 0000000000000000 R09: 0000000000000001
[   82.001011] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff84800010
[   82.001011] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
[   82.001011] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[   82.001011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.001011] CR2: 0000000000db6594 CR3: 000000000bffa000 CR4: 00000000000406f0
[   82.001011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.001011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   82.001011] Process swapper/0 (pid: 0, threadinfo ffffffff84800000, task ffffffff8482d400)
[   82.001011] Stack:
[   82.001011]  ffffffff81984d25 ffff88000d803df8 ffff8800299d6300 000000009398743f
[   82.001011]  000000009486a4e0 0000000000000001 0000000000000001 ffff88000d803db8
[   82.001011]  ffffffff81984c6a ffff88000d803df8 ffffffff8199bc1d ffff88000d803df8
[   82.001011] Call Trace:
[   82.001011]  <IRQ> 
[   82.001011]  [<ffffffff81984d25>] ? delay_tsc+0x85/0x140
[   82.001011]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   82.001011]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   82.001011]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   82.001011]  [<ffffffff8113ff5e>] ? do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff83729500>] ? _raw_spin_unlock+0x30/0x60
[   82.001011]  [<ffffffff8113ff5e>] do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff81140245>] sched_rt_period_timer+0x45/0x70
[   82.001011]  [<ffffffff8111f4f6>] __run_hrtimer+0x206/0x330
[   82.001011]  [<ffffffff81140200>] ? do_sched_rt_period_timer+0x320/0x320
[   82.001011]  [<ffffffff8111f8e8>] hrtimer_interrupt+0x118/0x230
[   82.001011]  [<ffffffff81090f55>] smp_apic_timer_interrupt+0x85/0xa0
[   82.001011]  [<ffffffff8372b0ef>] apic_timer_interrupt+0x6f/0x80
[   82.001011]  <EOI> 
[   82.001011]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[   82.001011]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[   82.001011]  [<ffffffff8116211d>] ? trace_hardirqs_on+0xd/0x10
[   82.001011]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[   82.001011]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[   82.001011]  [<ffffffff83636281>] rest_init+0x131/0x140
[   82.001011]  [<ffffffff83636150>] ? csum_partial_copy_generic+0x170/0x170
[   82.001011]  [<ffffffff850d108c>] start_kernel+0x3dc/0x3e9
[   82.001011]  [<ffffffff850d0ade>] ? kernel_init+0x28a/0x28a
[   82.001011]  [<ffffffff850d0324>] x86_64_start_reservations+0xff/0x104
[   82.001011]  [<ffffffff850d047e>] x86_64_start_kernel+0x155/0x164
[   82.001011] Code: 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 89 c1 c9 48 89 d0 <89> c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 00 00 00 00 00 55 
[   81.570014] NMI backtrace for cpu 2
[   81.570014] CPU 2 
[   81.570014] Pid: 5961, comm: trinity-child6 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.570014] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[   81.570014] RSP: 0018:ffff88001a2bb7a8  EFLAGS: 00000086
[   81.570014] RAX: 0000000000000400 RBX: 0000000000000002 RCX: 0000000000000830
[   81.570014] RDX: 0000000000000002 RSI: 0000000000000400 RDI: 0000000000000830
[   81.570014] RBP: ffff88001a2bb7a8 R08: ffffffff84ee09c0 R09: 0000000000000000
[   81.570014] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000002
[   81.570014] R13: ffffffff84ee09c0 R14: 0000000000000002 R15: 000000000000b024
[   81.570014] FS:  00007f9767634700(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[   81.570014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   81.570014] CR2: 0000000000000ff9 CR3: 000000000b8b0000 CR4: 00000000000406e0
[   81.570014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.570014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.570014] Process trinity-child6 (pid: 5961, threadinfo ffff88001a2ba000, task ffff88001a7f3000)
[   81.570014] Stack:
[   81.570014]  ffff88001a2bb818 ffffffff8109602d 0000000000000000 ffff88001a2bb928
[   81.570014]  ffff88001a2bb828 0000000000000086 0000000000000002 0000000200080000
[   81.570014]  ffff88001a2bb7f8 0000000000000000 000000009486a4e0 000000009486a4e0
[   81.570014] Call Trace:
[   81.570014]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[   81.570014]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[   81.570014]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[   81.570014]  [<ffffffff8199bc43>] do_raw_spin_lock+0x103/0x140
[   81.570014]  [<ffffffff83728a78>] _raw_spin_lock_nested+0x68/0x90
[   81.570014]  [<ffffffff81139fe2>] ? load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff83728b07>] ? _raw_spin_lock+0x67/0x70
[   81.570014]  [<ffffffff81139fd5>] ? load_balance+0x295/0x6e0
[   81.570014]  [<ffffffff81139fe2>] load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff81137dc0>] ? find_busiest_group+0x2a0/0x2a0
[   81.570014]  [<ffffffff8113c6df>] idle_balance+0x15f/0x240
[   81.570014]  [<ffffffff8113c5bf>] ? idle_balance+0x3f/0x240
[   81.570014]  [<ffffffff8372739d>] __schedule+0x26d/0x880
[   81.570014]  [<ffffffff83727b15>] schedule+0x55/0x60
[   81.570014]  [<ffffffff83725568>] schedule_timeout+0x38/0x2c0
[   81.570014]  [<ffffffff8115fa5d>] ? __lock_acquired+0x3d/0x2e0
[   81.570014]  [<ffffffff83726f54>] ? wait_for_common+0x44/0x170
[   81.570014]  [<ffffffff83727007>] ? wait_for_common+0xf7/0x170
[   81.570014]  [<ffffffff8372700f>] wait_for_common+0xff/0x170
[   81.570014]  [<ffffffff81132ac0>] ? try_to_wake_up+0x290/0x290
[   81.570014]  [<ffffffff811efd60>] ? lru_add_drain+0x50/0x50
[   81.570014]  [<ffffffff83727128>] wait_for_completion+0x18/0x20
[   81.570014]  [<ffffffff8110d7c0>] flush_work+0x80/0xc0
[   81.570014]  [<ffffffff8110d740>] ? start_flush_work+0x1a0/0x1a0
[   81.570014]  [<ffffffff8110cab0>] ? do_work_for_cpu+0x30/0x30
[   81.570014]  [<ffffffff8110e33b>] schedule_on_each_cpu+0x13b/0x1c0
[   81.570014]  [<ffffffff811eed90>] lru_add_drain_all+0x10/0x20
[   81.570014]  [<ffffffff812403c9>] do_pages_move+0x49/0x1e0
[   81.570014]  [<ffffffff8199bb30>] ? do_raw_spin_unlock+0xd0/0xe0
[   81.570014]  [<ffffffff812409a7>] sys_move_pages+0x2f7/0x380
[   81.570014]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.570014] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[   81.559841] NMI backtrace for cpu 1
[   81.559841] CPU 1 
[   81.559841] Pid: 0, comm: swapper/1 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.559841] RIP: 0010:[<ffffffff8112956f>]  [<ffffffff8112956f>] add_preempt_count+0x5f/0xa0
[   81.559841] RSP: 0018:ffff88000d5d1d08  EFLAGS: 00000006
[   81.559841] RAX: ffff88000d5d1fd8 RBX: ffffffff84b73020 RCX: 0000000000007159
[   81.559841] RDX: 0000000071597158 RSI: 0000000000000002 RDI: 0000000000000001
[   81.559841] RBP: ffff88000d5d1d08 R08: 0000000000000000 R09: 0000000000000000
[   81.559841] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000ccecab
[   81.559841] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[   81.559841] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[   81.559841] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.559841] CR2: 0000000000f73ffc CR3: 000000000bb08000 CR4: 00000000000406e0
[   81.559841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.559841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.559841] Process swapper/1 (pid: 0, threadinfo ffff88000d5d0000, task ffff88000d5c8000)
[   81.559841] Stack:
[   81.559841]  ffff88000d5d1d48 ffffffff81984cbe 0000000000000000 ffffffff84b73020
[   81.559841]  0000000000ccecab 000000009486a4e0 0000000000000000 0000000000000000
[   81.559841]  ffff88000d5d1d58 ffffffff81984c6a ffff88000d5d1d98 ffffffff8199bc1d
[   81.559841] Call Trace:
[   81.559841]  [<ffffffff81984cbe>] delay_tsc+0x1e/0x140
[   81.559841]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.559841]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.559841]  [<ffffffff83728c91>] _raw_spin_lock_irqsave+0xa1/0xc0
[   81.559841]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff8112838d>] __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff811a4952>] force_quiescent_state+0x102/0x120
[   81.559841]  [<ffffffff811a95cb>] rcu_prepare_for_idle+0x32b/0x490
[   81.559841]  [<ffffffff811a994c>] rcu_idle_enter_common+0x21c/0x340
[   81.559841]  [<ffffffff81122110>] ? srcu_notifier_call_chain+0x20/0x20
[   81.559841]  [<ffffffff811a9d4b>] rcu_idle_enter+0xdb/0x150
[   81.559841]  [<ffffffff8107243e>] cpu_idle+0x10e/0x180
[   81.559841]  [<ffffffff8371ce3c>] ? setup_APIC_timer+0x88/0x8d
[   81.559841]  [<ffffffff8371c477>] start_secondary+0xd7/0xde
[   81.559841] Code: 63 be 32 0c 00 00 48 c7 c7 25 f1 27 84 e8 3a 1b fc ff eb 50 0f 1f 84 00 00 00 00 00 65 48 8b 04 25 88 d9 00 00 01 b8 44 e0 ff ff <8b> 0d 2f b1 20 04 85 c9 75 2f 80 b8 44 e0 ff ff f4 76 26 e8 49 
[   81.458024] NMI backtrace for cpu 3
[   81.458024] CPU 3 
[   81.458024] Pid: 5970, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.458024] RIP: 0010:[<ffffffff81984cc6>]  [<ffffffff81984cc6>] delay_tsc+0x26/0x140
[   81.458024] RSP: 0000:ffff88000bab15f8  EFLAGS: 00000006
[   81.458024] RAX: 0000000000000003 RBX: ffff880035bd6300 RCX: 0000000000000000
[   81.458024] RDX: 00000000ffe9ffe8 RSI: 0000000010000005 RDI: 0000000000000001
[   81.458024] RBP: ffff88000bab1628 R08: 0000000000000000 R09: 0000000000000000
[   81.458024] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000899af7
[   81.458024] R13: 0000000000000001 R14: 0000000000000000 R15: ffff880035a00000
[   81.458024] FS:  00007f9767634700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[   81.458024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.458024] CR2: 0000000000000008 CR3: 000000000b962000 CR4: 00000000000406e0
[   81.458024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.458024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.458024] Process trinity-child19 (pid: 5970, threadinfo ffff88000bab0000, task ffff88000b9e8000)
[   81.458024] Stack:
[   81.458024]  0000000000000000 ffff880035bd6300 0000000000899af7 000000009486a4e0
[   81.458024]  0000000000000000 ffff880035a00000 ffff88000bab1638 ffffffff81984c6a
[   81.458024]  ffff88000bab1678 ffffffff8199bc1d ffff88000bab1678 0000000000000086
[   81.458024] Call Trace:
[   81.458024]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.458024]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.458024]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   81.458024]  [<ffffffff81130603>] ? ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81130603>] ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81132864>] ? try_to_wake_up+0x34/0x290
[   81.458024]  [<ffffffff81132a7c>] try_to_wake_up+0x24c/0x290
[   81.458024]  [<ffffffff8115fcc4>] ? __lock_acquired+0x2a4/0x2e0
[   81.458024]  [<ffffffff81132acd>] default_wake_function+0xd/0x10
[   81.458024]  [<ffffffff8111a6c8>] autoremove_wake_function+0x18/0x40
[   81.458024]  [<ffffffff811253c2>] __wake_up_common+0x52/0x90
[   81.458024]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.458024]  [<ffffffff811283a3>] __wake_up+0x43/0x70
[   81.458024]  [<ffffffff811a4173>] rcu_report_qs_rsp+0x73/0x80
[   81.458024]  [<ffffffff811a81cd>] rcu_report_qs_rnp+0x26d/0x2c0
[   81.458024]  [<ffffffff811a829e>] rcu_report_unblock_qs_rnp+0x7e/0x90
[   81.458024]  [<ffffffff811a8d70>] rcu_read_unlock_special+0x330/0x400
[   81.458024]  [<ffffffff8115d1fa>] ? get_lock_stats+0x2a/0x60
[   81.458024]  [<ffffffff811a906a>] rcu_preempt_note_context_switch+0x22a/0x300
[   81.458024]  [<ffffffff8372789a>] __schedule+0x76a/0x880
[   81.458024]  [<ffffffff81161bc6>] ? mark_held_locks+0xf6/0x120
[   81.458024]  [<ffffffff83727f34>] preempt_schedule_irq+0x94/0xd0
[   81.458024]  [<ffffffff83729da6>] retint_kernel+0x26/0x30
[   81.458024]  [<ffffffff811a8aa2>] ? rcu_read_unlock_special+0x62/0x400
[   81.458024]  [<ffffffff8115d23e>] ? put_lock_stats+0xe/0x40
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81163c6a>] ? __lock_release+0x1ba/0x1d0
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81115b5d>] __rcu_read_unlock+0x4d/0xa0
[   81.458024]  [<ffffffff811e0985>] find_get_page+0x235/0x260
[   81.458024]  [<ffffffff811e0750>] ? find_get_pages+0x2e0/0x2e0
[   81.458024]  [<ffffffff811e0eee>] filemap_fault+0x6e/0x4c0
[   81.458024]  [<ffffffff8120e33e>] __do_fault+0xae/0x560
[   81.458024]  [<ffffffff81134cb8>] ? sched_clock_cpu+0x108/0x120
[   81.458024]  [<ffffffff8120ee51>] handle_pte_fault+0x81/0x1f0
[   81.458024]  [<ffffffff8120f2e9>] handle_mm_fault+0x329/0x350
[   81.458024]  [<ffffffff8120b5f0>] ? follow_page+0x550/0x5a0
[   81.458024]  [<ffffffff8120f808>] __get_user_pages+0x438/0x5d0
[   81.458024]  [<ffffffff812108f6>] __mlock_vma_pages_range+0xc6/0xd0
[   81.458024]  [<ffffffff81210a01>] do_mlock_pages+0x101/0x180
[   81.458024]  [<ffffffff81211148>] sys_mlockall+0x128/0x1a0
[   81.458024]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.458024] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 52 48 7a ff e8 2d 87 01 00 0f 1f 00 <0f> ae e8 48 83 3d 67 15 ec 02 00 75 07 0f 0b 0f 1f 00 eb fe 41 
[   82.001011] BUG: spinlock lockup suspected on CPU#0, swapper/0/0
[   82.001011]  lock: 0xffff8800299d6300, .magic: dead4ead, .owner: trinity-child6/5961, .owner_cpu: 2
[   82.001011] Pid: 0, comm: swapper/0 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479
[   82.001011] Call Trace:
[   82.001011]  <IRQ>  [<ffffffff8199b9d8>] spin_dump+0x78/0xc0
[   82.001011]  [<ffffffff8199bc3e>] do_raw_spin_lock+0xfe/0x140
[   82.001011]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   82.001011]  [<ffffffff8113ff5e>] ? do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff83729500>] ? _raw_spin_unlock+0x30/0x60
[   82.001011]  [<ffffffff8113ff5e>] do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff81140245>] sched_rt_period_timer+0x45/0x70
[   82.001011]  [<ffffffff8111f4f6>] __run_hrtimer+0x206/0x330
[   82.001011]  [<ffffffff81140200>] ? do_sched_rt_period_timer+0x320/0x320
[   82.001011]  [<ffffffff8111f8e8>] hrtimer_interrupt+0x118/0x230
[   82.001011]  [<ffffffff81090f55>] smp_apic_timer_interrupt+0x85/0xa0
[   82.001011]  [<ffffffff8372b0ef>] apic_timer_interrupt+0x6f/0x80
[   82.001011]  <EOI>  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[   82.001011]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[   82.001011]  [<ffffffff8116211d>] ? trace_hardirqs_on+0xd/0x10
[   82.001011]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[   82.001011]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[   82.001011]  [<ffffffff83636281>] rest_init+0x131/0x140
[   82.001011]  [<ffffffff83636150>] ? csum_partial_copy_generic+0x170/0x170
[   82.001011]  [<ffffffff850d108c>] start_kernel+0x3dc/0x3e9
[   82.001011]  [<ffffffff850d0ade>] ? kernel_init+0x28a/0x28a
[   82.001011]  [<ffffffff850d0324>] x86_64_start_reservations+0xff/0x104
[   82.001011]  [<ffffffff850d047e>] x86_64_start_kernel+0x155/0x164
[   82.001011] sending NMI to all CPUs:
[   82.001011] NMI backtrace for cpu 0
[   82.001011] CPU 0 
[   82.001011] Pid: 0, comm: swapper/0 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   82.001011] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[   82.001011] RSP: 0018:ffff88000d803d18  EFLAGS: 00000086
[   82.001011] RAX: 0000000000000400 RBX: 0000000000000000 RCX: 0000000000000830
[   82.001011] RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000830
[   82.001011] RBP: ffff88000d803d18 R08: ffffffff84ee09c0 R09: 0000000000000000
[   82.001011] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
[   82.001011] R13: ffffffff84ee09c0 R14: 0000000000000000 R15: 000000000000b024
[   82.001011] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[   82.001011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   82.001011] CR2: 0000000000db6594 CR3: 000000000bffa000 CR4: 00000000000406f0
[   82.001011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   82.001011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   82.001011] Process swapper/0 (pid: 0, threadinfo ffffffff84800000, task ffffffff8482d400)
[   82.001011] Stack:
[   82.001011]  ffff88000d803d88 ffffffff8109602d 0000000000000000 0000000000000001
[   82.001011]  ffff88000d803d98 0000000000000086 0000000000000002 0000000200080000
[   82.001011]  ffff88000d803d68 0000000000000000 000000009486a4e0 000000009486a4e0
[   82.001011] Call Trace:
[   82.001011]  <IRQ> 
[   82.001011]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[   82.001011]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[   82.001011]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[   82.001011]  [<ffffffff8199bc43>] do_raw_spin_lock+0x103/0x140
[   82.001011]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   82.001011]  [<ffffffff8113ff5e>] ? do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff83729500>] ? _raw_spin_unlock+0x30/0x60
[   82.001011]  [<ffffffff8113ff5e>] do_sched_rt_period_timer+0x7e/0x320
[   82.001011]  [<ffffffff81140245>] sched_rt_period_timer+0x45/0x70
[   82.001011]  [<ffffffff8111f4f6>] __run_hrtimer+0x206/0x330
[   82.001011]  [<ffffffff81140200>] ? do_sched_rt_period_timer+0x320/0x320
[   82.001011]  [<ffffffff8111f8e8>] hrtimer_interrupt+0x118/0x230
[   82.001011]  [<ffffffff81090f55>] smp_apic_timer_interrupt+0x85/0xa0
[   82.001011]  [<ffffffff8372b0ef>] apic_timer_interrupt+0x6f/0x80
[   82.001011]  <EOI> 
[   82.001011]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[   82.001011]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[   82.001011]  [<ffffffff8116211d>] ? trace_hardirqs_on+0xd/0x10
[   82.001011]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[   82.001011]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[   82.001011]  [<ffffffff83636281>] rest_init+0x131/0x140
[   82.001011]  [<ffffffff83636150>] ? csum_partial_copy_generic+0x170/0x170
[   82.001011]  [<ffffffff850d108c>] start_kernel+0x3dc/0x3e9
[   82.001011]  [<ffffffff850d0ade>] ? kernel_init+0x28a/0x28a
[   82.001011]  [<ffffffff850d0324>] x86_64_start_reservations+0xff/0x104
[   82.001011]  [<ffffffff850d047e>] x86_64_start_kernel+0x155/0x164
[   82.001011] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[   81.559841] NMI backtrace for cpu 1
[   81.559841] CPU 1 
[   81.559841] Pid: 0, comm: swapper/1 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.559841] RIP: 0010:[<ffffffff81071646>]  [<ffffffff81071646>] native_read_tsc+0x6/0x20
[   81.559841] RSP: 0018:ffff88000d5d1d08  EFLAGS: 00000082
[   81.559841] RAX: 000000007a9c9786 RBX: 000000007a9c9749 RCX: 000000007a9c9749
[   81.559841] RDX: 0000000000000092 RSI: 0000000000000002 RDI: 0000000000000001
[   81.559841] RBP: ffff88000d5d1d08 R08: 0000000000000000 R09: 0000000000000000
[   81.559841] R10: 0000000000000000 R11: 0000000000000002 R12: ffff88000d5d0010
[   81.559841] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
[   81.559841] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[   81.559841] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.559841] CR2: 0000000000f73ffc CR3: 000000000bb08000 CR4: 00000000000406e0
[   81.559841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.559841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.559841] Process swapper/1 (pid: 0, threadinfo ffff88000d5d0000, task ffff88000d5c8000)
[   81.559841] Stack:
[   81.559841]  ffff88000d5d1d48 ffffffff81984d25 0000000000000000 ffffffff84b73020
[   81.559841]  000000000192362a 000000009486a4e0 0000000000000000 0000000000000000
[   81.559841]  ffff88000d5d1d58 ffffffff81984c6a ffff88000d5d1d98 ffffffff8199bc1d
[   81.559841] Call Trace:
[   81.559841]  [<ffffffff81984d25>] delay_tsc+0x85/0x140
[   81.559841]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.559841]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.559841]  [<ffffffff83728c91>] _raw_spin_lock_irqsave+0xa1/0xc0
[   81.559841]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff8112838d>] __wake_up+0x2d/0x70
[   81.559841]  [<ffffffff811a4952>] force_quiescent_state+0x102/0x120
[   81.559841]  [<ffffffff811a95cb>] rcu_prepare_for_idle+0x32b/0x490
[   81.559841]  [<ffffffff811a994c>] rcu_idle_enter_common+0x21c/0x340
[   81.559841]  [<ffffffff81122110>] ? srcu_notifier_call_chain+0x20/0x20
[   81.559841]  [<ffffffff811a9d4b>] rcu_idle_enter+0xdb/0x150
[   81.559841]  [<ffffffff8107243e>] cpu_idle+0x10e/0x180
[   81.559841]  [<ffffffff8371ce3c>] ? setup_APIC_timer+0x88/0x8d
[   81.559841]  [<ffffffff8371c477>] start_secondary+0xd7/0xde
[   81.559841] Code: 08 ff 15 e6 ae 7c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[   81.570014] NMI backtrace for cpu 2
[   81.570014] CPU 2 
[   81.570014] Pid: 5961, comm: trinity-child6 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.570014] RIP: 0010:[<ffffffff81071646>]  [<ffffffff81071646>] native_read_tsc+0x6/0x20
[   81.570014] RSP: 0018:ffff88001a2bb7f8  EFLAGS: 00000082
[   81.570014] RAX: 000000007a9cb129 RBX: ffff880035bd6300 RCX: 0000000000000000
[   81.570014] RDX: 0000000000000092 RSI: 0000000000000003 RDI: 0000000000000001
[   81.570014] RBP: ffff88001a2bb7f8 R08: 0000000000000000 R09: 0000000000000000
[   81.570014] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000988054
[   81.570014] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88001a2bb928
[   81.570014] FS:  00007f9767634700(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[   81.570014] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   81.570014] CR2: 0000000000000ff9 CR3: 000000000b8b0000 CR4: 00000000000406e0
[   81.570014] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.570014] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.570014] Process trinity-child6 (pid: 5961, threadinfo ffff88001a2ba000, task ffff88001a7f3000)
[   81.570014] Stack:
[   81.570014]  ffff88001a2bb838 ffffffff81984ce2 0000000000000000 ffff880035bd6300
[   81.570014]  0000000000988054 000000009486a4e0 0000000000000000 ffff88001a2bb928
[   81.570014]  ffff88001a2bb848 ffffffff81984c6a ffff88001a2bb888 ffffffff8199bc1d
[   81.570014] Call Trace:
[   81.570014]  [<ffffffff81984ce2>] delay_tsc+0x42/0x140
[   81.570014]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.570014]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.570014]  [<ffffffff83728a78>] _raw_spin_lock_nested+0x68/0x90
[   81.570014]  [<ffffffff81139fe2>] ? load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff83728b07>] ? _raw_spin_lock+0x67/0x70
[   81.570014]  [<ffffffff81139fd5>] ? load_balance+0x295/0x6e0
[   81.570014]  [<ffffffff81139fe2>] load_balance+0x2a2/0x6e0
[   81.570014]  [<ffffffff81137dc0>] ? find_busiest_group+0x2a0/0x2a0
[   81.570014]  [<ffffffff8113c6df>] idle_balance+0x15f/0x240
[   81.570014]  [<ffffffff8113c5bf>] ? idle_balance+0x3f/0x240
[   81.570014]  [<ffffffff8372739d>] __schedule+0x26d/0x880
[   81.570014]  [<ffffffff83727b15>] schedule+0x55/0x60
[   81.570014]  [<ffffffff83725568>] schedule_timeout+0x38/0x2c0
[   81.570014]  [<ffffffff8115fa5d>] ? __lock_acquired+0x3d/0x2e0
[   81.570014]  [<ffffffff83726f54>] ? wait_for_common+0x44/0x170
[   81.570014]  [<ffffffff83727007>] ? wait_for_common+0xf7/0x170
[   81.570014]  [<ffffffff8372700f>] wait_for_common+0xff/0x170
[   81.570014]  [<ffffffff81132ac0>] ? try_to_wake_up+0x290/0x290
[   81.570014]  [<ffffffff811efd60>] ? lru_add_drain+0x50/0x50
[   81.570014]  [<ffffffff83727128>] wait_for_completion+0x18/0x20
[   81.570014]  [<ffffffff8110d7c0>] flush_work+0x80/0xc0
[   81.570014]  [<ffffffff8110d740>] ? start_flush_work+0x1a0/0x1a0
[   81.570014]  [<ffffffff8110cab0>] ? do_work_for_cpu+0x30/0x30
[   81.570014]  [<ffffffff8110e33b>] schedule_on_each_cpu+0x13b/0x1c0
[   81.570014]  [<ffffffff811eed90>] lru_add_drain_all+0x10/0x20
[   81.570014]  [<ffffffff812403c9>] do_pages_move+0x49/0x1e0
[   81.570014]  [<ffffffff8199bb30>] ? do_raw_spin_unlock+0xd0/0xe0
[   81.570014]  [<ffffffff812409a7>] sys_move_pages+0x2f7/0x380
[   81.570014]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.570014] Code: 08 ff 15 e6 ae 7c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[   81.458024] NMI backtrace for cpu 3
[   81.458024] CPU 3 
[   81.458024] Pid: 5970, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120628-sasha-00005-g9f23eb7 #479  
[   81.458024] RIP: 0010:[<ffffffff81984d20>]  [<ffffffff81984d20>] delay_tsc+0x80/0x140
[   81.458024] RSP: 0000:ffff88000bab15f8  EFLAGS: 00000082
[   81.458024] RAX: 000000927a9cc311 RBX: 000000007a9cc311 RCX: 000000007a9cc311
[   81.458024] RDX: 0000000000000092 RSI: 0000000010000005 RDI: 0000000000000001
[   81.458024] RBP: ffff88000bab1628 R08: 0000000000000000 R09: 0000000000000000
[   81.458024] R10: 0000000000000000 R11: 0000000000000002 R12: ffff88000bab0010
[   81.458024] R13: 0000000000000001 R14: 0000000000000003 R15: ffff880035a00000
[   81.458024] FS:  00007f9767634700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[   81.458024] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   81.458024] CR2: 0000000000000008 CR3: 000000000b962000 CR4: 00000000000406e0
[   81.458024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   81.458024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   81.458024] Process trinity-child19 (pid: 5970, threadinfo ffff88000bab0000, task ffff88000b9e8000)
[   81.458024] Stack:
[   81.458024]  0000000000000000 ffff880035bd6300 00000000011ecec4 000000009486a4e0
[   81.458024]  0000000000000000 ffff880035a00000 ffff88000bab1638 ffffffff81984c6a
[   81.458024]  ffff88000bab1678 ffffffff8199bc1d ffff88000bab1678 0000000000000086
[   81.458024] Call Trace:
[   81.458024]  [<ffffffff81984c6a>] __delay+0xa/0x10
[   81.458024]  [<ffffffff8199bc1d>] do_raw_spin_lock+0xdd/0x140
[   81.458024]  [<ffffffff83728afb>] _raw_spin_lock+0x5b/0x70
[   81.458024]  [<ffffffff81130603>] ? ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81130603>] ttwu_queue+0xd3/0x100
[   81.458024]  [<ffffffff81132864>] ? try_to_wake_up+0x34/0x290
[   81.458024]  [<ffffffff81132a7c>] try_to_wake_up+0x24c/0x290
[   81.458024]  [<ffffffff8115fcc4>] ? __lock_acquired+0x2a4/0x2e0
[   81.458024]  [<ffffffff81132acd>] default_wake_function+0xd/0x10
[   81.458024]  [<ffffffff8111a6c8>] autoremove_wake_function+0x18/0x40
[   81.458024]  [<ffffffff811253c2>] __wake_up_common+0x52/0x90
[   81.458024]  [<ffffffff8112838d>] ? __wake_up+0x2d/0x70
[   81.458024]  [<ffffffff811283a3>] __wake_up+0x43/0x70
[   81.458024]  [<ffffffff811a4173>] rcu_report_qs_rsp+0x73/0x80
[   81.458024]  [<ffffffff811a81cd>] rcu_report_qs_rnp+0x26d/0x2c0
[   81.458024]  [<ffffffff811a829e>] rcu_report_unblock_qs_rnp+0x7e/0x90
[   81.458024]  [<ffffffff811a8d70>] rcu_read_unlock_special+0x330/0x400
[   81.458024]  [<ffffffff8115d1fa>] ? get_lock_stats+0x2a/0x60
[   81.458024]  [<ffffffff811a906a>] rcu_preempt_note_context_switch+0x22a/0x300
[   81.458024]  [<ffffffff8372789a>] __schedule+0x76a/0x880
[   81.458024]  [<ffffffff81161bc6>] ? mark_held_locks+0xf6/0x120
[   81.458024]  [<ffffffff83727f34>] preempt_schedule_irq+0x94/0xd0
[   81.458024]  [<ffffffff83729da6>] retint_kernel+0x26/0x30
[   81.458024]  [<ffffffff811a8aa2>] ? rcu_read_unlock_special+0x62/0x400
[   81.458024]  [<ffffffff8115d23e>] ? put_lock_stats+0xe/0x40
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81163c6a>] ? __lock_release+0x1ba/0x1d0
[   81.458024]  [<ffffffff811e0968>] ? find_get_page+0x218/0x260
[   81.458024]  [<ffffffff81115b5d>] __rcu_read_unlock+0x4d/0xa0
[   81.458024]  [<ffffffff811e0985>] find_get_page+0x235/0x260
[   81.458024]  [<ffffffff811e0750>] ? find_get_pages+0x2e0/0x2e0
[   81.458024]  [<ffffffff811e0eee>] filemap_fault+0x6e/0x4c0
[   81.458024]  [<ffffffff8120e33e>] __do_fault+0xae/0x560
[   81.458024]  [<ffffffff81134cb8>] ? sched_clock_cpu+0x108/0x120
[   81.458024]  [<ffffffff8120ee51>] handle_pte_fault+0x81/0x1f0
[   81.458024]  [<ffffffff8120f2e9>] handle_mm_fault+0x329/0x350
[   81.458024]  [<ffffffff8120b5f0>] ? follow_page+0x550/0x5a0
[   81.458024]  [<ffffffff8120f808>] __get_user_pages+0x438/0x5d0
[   81.458024]  [<ffffffff812108f6>] __mlock_vma_pages_range+0xc6/0xd0
[   81.458024]  [<ffffffff81210a01>] do_mlock_pages+0x101/0x180
[   81.458024]  [<ffffffff81211148>] sys_mlockall+0x128/0x1a0
[   81.458024]  [<ffffffff8372a539>] system_call_fastpath+0x16/0x1b
[   81.458024] Code: 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f ae e8 48 83 3d 2a 15 ec 02 00 75 10 0f 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 <e8> 1b c9 6e ff 66 90 41 89 c7 29 d8 44 39 e8 73 6f bf 01 00 00

