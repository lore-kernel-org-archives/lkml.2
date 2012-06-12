Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab2FLLeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:34:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56840 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2FLLeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:34:00 -0400
Message-ID: <1339500907.4999.99.camel@lappy>
Subject: rcu,sched: spinlock recursion on 3.5-rc2
From: Sasha Levin <levinsasha928@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Tue, 12 Jun 2012 13:35:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

I've got the following splat while fuzzing with trinity in a KVM tools guest on 3.5-rc2:

[ 8110.274070] BUG: spinlock recursion on CPU#0, rcu_torture_rea/2658
[ 8110.275014]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
[ 8110.275014] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
[ 8110.275014] Call Trace:
[ 8110.275014]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 8110.275014]  [<ffffffff8197deab>] spin_bug+0x2b/0x40
[ 8110.275014]  [<ffffffff8197dfee>] do_raw_spin_lock+0x4e/0x140
[ 8110.275014]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.275014]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8110.275014]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8110.275014]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8110.275014]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8110.275014]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8110.275014]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8110.275014]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8110.275014]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8110.275014]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8110.275014]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.275014]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8110.275014]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8110.275014]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8110.275014]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8110.275014]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8110.275014]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8110.275014]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8110.275014]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.275014]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.275014]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.275014]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.275014]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.275014]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.275014]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] BUG: spinlock lockup on CPU#1, rcu_torture_rea/2653
[ 8110.306059]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
[ 8110.306059] Pid: 2653, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
[ 8110.306059] Call Trace:
[ 8110.306059]  <IRQ>  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 8110.306059]  [<ffffffff8197e09e>] do_raw_spin_lock+0xfe/0x140
[ 8110.306059]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.306059]  [<ffffffff81126620>] ? load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126620>] load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126d38>] ? update_shares+0x158/0x240
[ 8110.306059]  [<ffffffff81126fdd>] rebalance_domains+0x1bd/0x290
[ 8110.306059]  [<ffffffff81126e20>] ? update_shares+0x240/0x240
[ 8110.306059]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 8110.306059]  [<ffffffff811272c3>] run_rebalance_domains+0x43/0x60
[ 8110.306059]  [<ffffffff810e2c01>] __do_softirq+0x221/0x460
[ 8110.306059]  [<ffffffff8109a516>] ? kvm_clock_read+0x46/0x80
[ 8110.306059]  [<ffffffff837c3aec>] call_softirq+0x1c/0x30
[ 8110.306059]  [<ffffffff81069215>] do_softirq+0x75/0x120
[ 8110.306059]  [<ffffffff810e1c0b>] irq_exit+0x5b/0xf0
[ 8110.306059]  [<ffffffff8108e99a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 8110.306059]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8110.306059]  <EOI>  [<ffffffff837c164b>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8110.306059]  [<ffffffff837c166c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8110.306059]  [<ffffffff811171bd>] finish_task_switch+0x8d/0x110
[ 8110.306059]  [<ffffffff81117180>] ? finish_task_switch+0x50/0x110
[ 8110.306059]  [<ffffffff837bf943>] __schedule+0x7e3/0x880
[ 8110.306059]  [<ffffffff8118dfc0>] ? rcu_torture_reader+0x380/0x380
[ 8110.306059]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8110.306059]  [<ffffffff8118dee2>] rcu_torture_reader+0x2a2/0x380
[ 8110.306059]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.306059]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.306059]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.306059]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.306059]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.306059]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.306059]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] sending NMI to all CPUs:
[ 8110.306059] NMI backtrace for cpu 1
[ 8110.306059] CPU 1 
[ 8110.306059] Pid: 2653, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8110.306059] RIP: 0010:[<ffffffff8109a5aa>]  [<ffffffff8109a5aa>] native_write_msr_safe+0xa/0x10
[ 8110.306059] RSP: 0018:ffff88001b803bd0  EFLAGS: 00000086
[ 8110.306059] RAX: 0000000000000400 RBX: 0000000000000001 RCX: 0000000000000830
[ 8110.306059] RDX: 0000000000000001 RSI: 0000000000000400 RDI: 0000000000000830
[ 8110.306059] RBP: ffff88001b803bd0 R08: ffffffff851259c0 R09: 0000000000000000
[ 8110.306059] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[ 8110.306059] R13: ffffffff851259c0 R14: 0000000000000001 R15: 000000000000ef40
[ 8110.306059] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 8110.306059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8110.306059] CR2: 0000000000000ffc CR3: 000000005f1ee000 CR4: 00000000000406e0
[ 8110.306059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8110.306059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8110.306059] Process rcu_torture_rea (pid: 2653, threadinfo ffff88000cf72000, task ffff88000cf6b000)
[ 8110.306059] Stack:
[ 8110.306059]  ffff88001b803c40 ffffffff81093d2d 0000000000000000 ffff88001b803d70
[ 8110.306059]  ffff88001b803c50 0000000000000086 0000000000000002 0000000200080000
[ 8110.306059]  ffff88001b803c20 0000000000000000 00000000948a9c80 00000000948a9c80
[ 8110.306059] Call Trace:
[ 8110.306059]  <IRQ> 
[ 8110.306059]  [<ffffffff81093d2d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 8110.306059]  [<ffffffff81093e17>] x2apic_send_IPI_all+0x17/0x20
[ 8110.306059]  [<ffffffff8108f184>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 8110.306059]  [<ffffffff8197e0a3>] do_raw_spin_lock+0x103/0x140
[ 8110.306059]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.306059]  [<ffffffff81126620>] ? load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126620>] load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126d38>] ? update_shares+0x158/0x240
[ 8110.306059]  [<ffffffff81126fdd>] rebalance_domains+0x1bd/0x290
[ 8110.306059]  [<ffffffff81126e20>] ? update_shares+0x240/0x240
[ 8110.306059]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 8110.306059]  [<ffffffff811272c3>] run_rebalance_domains+0x43/0x60
[ 8110.306059]  [<ffffffff810e2c01>] __do_softirq+0x221/0x460
[ 8110.306059]  [<ffffffff8109a516>] ? kvm_clock_read+0x46/0x80
[ 8110.306059]  [<ffffffff837c3aec>] call_softirq+0x1c/0x30
[ 8110.306059]  [<ffffffff81069215>] do_softirq+0x75/0x120
[ 8110.306059]  [<ffffffff810e1c0b>] irq_exit+0x5b/0xf0
[ 8110.306059]  [<ffffffff8108e99a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 8110.306059]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8110.306059]  <EOI> 
[ 8110.306059]  [<ffffffff837c164b>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8110.306059]  [<ffffffff837c166c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8110.306059]  [<ffffffff811171bd>] finish_task_switch+0x8d/0x110
[ 8110.306059]  [<ffffffff81117180>] ? finish_task_switch+0x50/0x110
[ 8110.306059]  [<ffffffff837bf943>] __schedule+0x7e3/0x880
[ 8110.306059]  [<ffffffff8118dfc0>] ? rcu_torture_reader+0x380/0x380
[ 8110.306059]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8110.306059]  [<ffffffff8118dee2>] rcu_torture_reader+0x2a2/0x380
[ 8110.306059]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.306059]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.306059]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.306059]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.306059]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.306059]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.306059]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 8111.347769] NMI backtrace for cpu 0
[ 8111.347769] CPU 0 
[ 8111.347769] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.347769] RIP: 0010:[<ffffffff81116887>]  [<ffffffff81116887>] sub_preempt_count+0x87/0xb0
[ 8111.347769] RSP: 0018:ffff88000cf959e8  EFLAGS: 00000002
[ 8111.347769] RAX: ffff88000cf95fd8 RBX: 000000004eacf13e RCX: 0000000000000000
[ 8111.347769] RDX: 00000000000012db RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.347769] RBP: ffff88000cf959e8 R08: 0000000010000004 R09: 0000000000000000
[ 8111.347769] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000cf94010
[ 8111.347769] R13: 0000000000000001 R14: 0000000000000000 R15: 000000004eacf17b
[ 8111.347769] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 8111.347769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.347769] CR2: 0000000000000ff8 CR3: 000000005eb81000 CR4: 00000000000406f0
[ 8111.347769] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.347769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.347769] Process rcu_torture_rea (pid: 2658, threadinfo ffff88000cf94000, task ffff88000cfa0000)
[ 8111.347769] Stack:
[ 8111.347769]  ffff88000cf95a28 ffffffff819674aa ffff88000cf95a18 ffff88000d9d6140
[ 8111.347769]  000000008abefb96 00000000948a9c80 0000000000000001 0000000000000086
[ 8111.347769]  ffff88000cf95a38 ffffffff8196736a ffff88000cf95a78 ffffffff8197e07d
[ 8111.347769] Call Trace:
[ 8111.347769]  [<ffffffff819674aa>] delay_tsc+0x10a/0x140
[ 8111.347769]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.347769]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.347769]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.347769]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8111.347769]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8111.347769]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8111.347769]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8111.347769]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8111.347769]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8111.347769]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.347769]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8111.347769]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8111.347769]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8111.347769]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8111.347769]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8111.347769]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.347769]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.347769]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.347769]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.347769]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.347769]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.347769] Code: 01 f0 04 00 75 3e be 4b 0c 00 00 48 c7 c7 6f a7 40 84 e8 2d 21 fc ff eb 2b 0f 1f 00 65 48 8b 04 25 88 d9 00 00 29 b8 44 e0 ff ff <eb> 17 0f 1f 80 00 00 00 00 81 ff fe 00 00 00 77 e0 eb aa 66 0f 
[ 8111.351463] NMI backtrace for cpu 2
[ 8111.351463] CPU 2 
[ 8111.351463] Pid: 11, comm: rcub/5 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.351463] RIP: 0010:[<ffffffff819674a0>]  [<ffffffff819674a0>] delay_tsc+0x100/0x140
[ 8111.351463] RSP: 0018:ffff88000d575c90  EFLAGS: 00000006
[ 8111.351463] RAX: 0000000000000029 RBX: 000000006bcb86d7 RCX: 000000006bcb8700
[ 8111.351463] RDX: 00000000000012db RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.351463] RBP: ffff88000d575cc0 R08: 0000000000000002 R09: 0000000000000000
[ 8111.351463] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000d574010
[ 8111.351463] R13: 0000000000000001 R14: 0000000000000002 R15: 000000006bcb8700
[ 8111.351463] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 8111.351463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.351463] CR2: 00007f155b06eff9 CR3: 00000000389c4000 CR4: 00000000000406e0
[ 8111.351463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.351463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.351463] Process rcub/5 (pid: 11, threadinfo ffff88000d574000, task ffff88000d578000)
[ 8111.351463] Stack:
[ 8111.351463]  ffff88000d575d10 ffff88000d9d6140 0000000092cd334a 00000000948a9c80
[ 8111.351463]  0000000000000001 ffff88000d9d6140 ffff88000d575cd0 ffffffff8196736a
[ 8111.351463]  ffff88000d575d10 ffffffff8197e07d ffff88000d575d10 0000000000000086
[ 8111.351463] Call Trace:
[ 8111.351463]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.351463]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.351463]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.351463]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8111.351463]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8111.351463]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8111.351463]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8111.351463]  [<ffffffff81190e50>] rcu_boost_kthread+0x90/0x120
[ 8111.351463]  [<ffffffff81190dc0>] ? trace_rcu_utilization+0xd0/0xd0
[ 8111.351463]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.351463]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.351463]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.351463]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.351463]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.351463] Code: cf 0d 03 00 75 04 0f 0b eb fe 44 29 fb 41 89 c6 41 01 dd e8 f3 91 70 ff 66 90 89 c3 e9 6a ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <bf> 01 00 00 00 e8 56 f3 7a ff 65 48 8b 04 25 88 d9 00 00 48 8b 
[ 8111.011063] NMI backtrace for cpu 4
[ 8111.011063] CPU 4 
[ 8111.011063] Pid: 2654, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.011063] RIP: 0010:[<ffffffff819673c9>]  [<ffffffff819673c9>] delay_tsc+0x29/0x140
[ 8111.011063] RSP: 0018:ffff880041803d78  EFLAGS: 00000002
[ 8111.011063] RAX: 0000000000000004 RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.011063] RDX: 00000000b6d3b6d2 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.011063] RBP: ffff880041803da8 R08: 0000000000010001 R09: 0000000000000000
[ 8111.011063] R10: 0000000000000000 R11: 0000000000000001 R12: 000000008c9addbe
[ 8111.011063] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000001
[ 8111.011063] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 8111.011063] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.011063] CR2: 00007f93d6ff5021 CR3: 000000000809d000 CR4: 00000000000406e0
[ 8111.011063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.011063] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.011063] Process rcu_torture_rea (pid: 2654, threadinfo ffff88000cf74000, task ffff88000cf78000)
[ 8111.011063] Stack:
[ 8111.011063]  ffff880041803df8 ffff88000d9d6140 000000008c9addbe 00000000948a9c80
[ 8111.011063]  0000000000000001 0000000000000001 ffff880041803db8 ffffffff8196736a
[ 8111.011063]  ffff880041803df8 ffffffff8197e07d ffff880041803df8 0000000000000086
[ 8111.011063] Call Trace:
[ 8111.011063]  <IRQ> 
[ 8111.011063]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.011063]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.011063]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.011063]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 8111.011063]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 8111.011063]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 8111.011063]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 8111.011063]  [<ffffffff8111641f>] ? account_system_vtime+0xff/0x140
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 8111.011063]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8111.011063]  <EOI> 
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8114f01d>] ? lock_release+0x17d/0x1a0
[ 8111.011063]  [<ffffffff8118dc38>] rcu_torture_read_unlock+0x58/0x60
[ 8111.011063]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.011063]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.011063]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.011063]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.011063]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.011063]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.011063]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.011063]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.011063] Code: 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 f2 f4 7a ff e8 8d 84 01 00 0f 1f 00 0f ae e8 <48> 83 3d 37 d0 0d 03 00 75 07 0f 0b 0f 1f 00 eb fe 41 89 c6 e8 
[ 8112.229101] NMI backtrace for cpu 3
[ 8112.229101] CPU 3 
[ 8112.229101] Pid: 27, comm: watchdog/3 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8112.229101] RIP: 0010:[<ffffffff819673c9>]  [<ffffffff819673c9>] delay_tsc+0x29/0x140
[ 8112.229101] RSP: 0018:ffff8800354d7ca0  EFLAGS: 00000006
[ 8112.229101] RAX: 0000000000000003 RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8112.229101] RDX: 00000000b6d3b6d2 RSI: 0000000000000000 RDI: 0000000000000001
[ 8112.229101] RBP: ffff8800354d7cd0 R08: 0000000000000002 R09: 0000000000000000
[ 8112.229101] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000090092bc0
[ 8112.229101] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88000d9d6140
[ 8112.229101] FS:  0000000000000000(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 8112.229101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8112.229101] CR2: 00007fe1aee26600 CR3: 000000000b42d000 CR4: 00000000000406e0
[ 8112.229101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8112.229101] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8112.229101] Process watchdog/3 (pid: 27, threadinfo ffff8800354d6000, task ffff8800354d8000)
[ 8112.229101] Stack:
[ 8112.229101]  ffff8800354d7d20 ffff88000d9d6140 0000000090092bc0 00000000948a9c80
[ 8112.229101]  0000000000000001 ffff88000d9d6140 ffff8800354d7ce0 ffffffff8196736a
[ 8112.229101]  ffff8800354d7d20 ffffffff8197e07d ffff8800354d7d20 0000000000000086
[ 8112.229101] Call Trace:
[ 8112.229101]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8112.229101]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8112.229101]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8112.229101]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8112.229101]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8112.229101]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8112.229101]  [<ffffffff81121785>] ? sched_clock_local+0x25/0x90
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8112.229101]  [<ffffffff8118369a>] watchdog+0x7a/0xd0
[ 8112.229101]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8112.229101]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8112.229101]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8112.229101]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8112.229101]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8112.229101] Code: 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 f2 f4 7a ff e8 8d 84 01 00 0f 1f 00 0f ae e8 <48> 83 3d 37 d0 0d 03 00 75 07 0f 0b 0f 1f 00 eb fe 41 89 c6 e8 
[ 8111.351463] BUG: spinlock lockup on CPU#2, rcub/5/11
[ 8111.351463]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
[ 8111.351463] Pid: 11, comm: rcub/5 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
[ 8111.351463] Call Trace:
[ 8111.351463]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 8111.351463]  [<ffffffff8197e09e>] do_raw_spin_lock+0xfe/0x140
[ 8111.351463]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.351463]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8111.351463]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8111.351463]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8111.351463]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8111.351463]  [<ffffffff81190e50>] rcu_boost_kthread+0x90/0x120
[ 8111.351463]  [<ffffffff81190dc0>] ? trace_rcu_utilization+0xd0/0xd0
[ 8111.351463]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.351463]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.351463]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.351463]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.351463]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.351463] sending NMI to all CPUs:
[ 8111.351463] NMI backtrace for cpu 2
[ 8111.351463] CPU 2 
[ 8111.351463] Pid: 11, comm: rcub/5 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.351463] RIP: 0010:[<ffffffff8109a5aa>]  [<ffffffff8109a5aa>] native_write_msr_safe+0xa/0x10
[ 8111.351463] RSP: 0018:ffff88000d575c30  EFLAGS: 00000086
[ 8111.351463] RAX: 0000000000000400 RBX: 0000000000000002 RCX: 0000000000000830
[ 8111.351463] RDX: 0000000000000002 RSI: 0000000000000400 RDI: 0000000000000830
[ 8111.351463] RBP: ffff88000d575c30 R08: ffffffff851259c0 R09: 0000000000000000
[ 8111.351463] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[ 8111.351463] R13: ffffffff851259c0 R14: 0000000000000002 R15: 000000000000ef40
[ 8111.351463] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 8111.351463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.351463] CR2: 00007f155b06eff9 CR3: 00000000389c4000 CR4: 00000000000406e0
[ 8111.351463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.351463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.351463] Process rcub/5 (pid: 11, threadinfo ffff88000d574000, task ffff88000d578000)
[ 8111.351463] Stack:
[ 8111.351463]  ffff88000d575ca0 ffffffff81093d2d 0000000000000000 ffff88000d9d6140
[ 8111.351463]  ffff88000d575cb0 0000000000000086 0000000000000002 0000000200080000
[ 8111.351463]  ffff88000d575c80 0000000000000000 00000000948a9c80 00000000948a9c80
[ 8111.351463] Call Trace:
[ 8111.351463]  [<ffffffff81093d2d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 8111.351463]  [<ffffffff81093e17>] x2apic_send_IPI_all+0x17/0x20
[ 8111.351463]  [<ffffffff8108f184>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 8111.351463]  [<ffffffff8197e0a3>] do_raw_spin_lock+0x103/0x140
[ 8111.351463]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.351463]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8111.351463]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8111.351463]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8111.351463]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8111.351463]  [<ffffffff81190e50>] rcu_boost_kthread+0x90/0x120
[ 8111.351463]  [<ffffffff81190dc0>] ? trace_rcu_utilization+0xd0/0xd0
[ 8111.351463]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.351463]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.351463]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.351463]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.351463]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.351463] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 8110.306059] NMI backtrace for cpu 1
[ 8110.306059] CPU 1 
[ 8110.306059] Pid: 2653, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8110.306059] RIP: 0010:[<ffffffff81116890>]  [<ffffffff81116890>] sub_preempt_count+0x90/0xb0
[ 8110.306059] RSP: 0018:ffff88001b803c20  EFLAGS: 00000006
[ 8110.306059] RAX: ffff88000cf73fd8 RBX: 00000000c3c0e658 RCX: 0000000000000000
[ 8110.306059] RDX: 00000000000012dc RSI: 0000000000000000 RDI: 0000000000000001
[ 8110.306059] RBP: ffff88001b803c20 R08: 0000000000000105 R09: 0000000000000000
[ 8110.306059] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000cf72010
[ 8110.306059] R13: 0000000000000001 R14: 0000000000000001 R15: 00000000c3c0e67c
[ 8110.306059] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 8110.306059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8110.306059] CR2: 0000000000000ffc CR3: 000000005f1ee000 CR4: 00000000000406e0
[ 8110.306059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8110.306059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8110.306059] Process rcu_torture_rea (pid: 2653, threadinfo ffff88000cf72000, task ffff88000cf6b000)
[ 8110.306059] Stack:
[ 8110.306059]  ffff88001b803c60 ffffffff819674aa 0000000000000000 ffff88000d9d6140
[ 8110.306059]  0000000001978cb7 00000000948a9c80 0000000000000000 ffff88001b803d70
[ 8110.306059]  ffff88001b803c70 ffffffff8196736a ffff88001b803cb0 ffffffff8197e07d
[ 8110.306059] Call Trace:
[ 8110.306059]  <IRQ> 
[ 8110.306059]  [<ffffffff819674aa>] delay_tsc+0x10a/0x140
[ 8110.306059]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8110.306059]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8110.306059]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.306059]  [<ffffffff81126620>] ? load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126620>] load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126d38>] ? update_shares+0x158/0x240
[ 8110.306059]  [<ffffffff81126fdd>] rebalance_domains+0x1bd/0x290
[ 8110.306059]  [<ffffffff81126e20>] ? update_shares+0x240/0x240
[ 8110.306059]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 8110.306059]  [<ffffffff811272c3>] run_rebalance_domains+0x43/0x60
[ 8110.306059]  [<ffffffff810e2c01>] __do_softirq+0x221/0x460
[ 8110.306059]  [<ffffffff8109a516>] ? kvm_clock_read+0x46/0x80
[ 8110.306059]  [<ffffffff837c3aec>] call_softirq+0x1c/0x30
[ 8110.306059]  [<ffffffff81069215>] do_softirq+0x75/0x120
[ 8110.306059]  [<ffffffff810e1c0b>] irq_exit+0x5b/0xf0
[ 8110.306059]  [<ffffffff8108e99a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 8110.306059]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8110.306059]  <EOI> 
[ 8110.306059]  [<ffffffff837c164b>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8110.306059]  [<ffffffff837c166c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8110.306059]  [<ffffffff811171bd>] finish_task_switch+0x8d/0x110
[ 8110.306059]  [<ffffffff81117180>] ? finish_task_switch+0x50/0x110
[ 8110.306059]  [<ffffffff837bf943>] __schedule+0x7e3/0x880
[ 8110.306059]  [<ffffffff8118dfc0>] ? rcu_torture_reader+0x380/0x380
[ 8110.306059]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8110.306059]  [<ffffffff8118dee2>] rcu_torture_reader+0x2a2/0x380
[ 8110.306059]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.306059]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.306059]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.306059]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.306059]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.306059]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.306059]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] Code: 00 00 48 c7 c7 6f a7 40 84 e8 2d 21 fc ff eb 2b 0f 1f 00 65 48 8b 04 25 88 d9 00 00 29 b8 44 e0 ff ff eb 17 0f 1f 80 00 00 00 00 <81> ff fe 00 00 00 77 e0 eb aa 66 0f 1f 44 00 00 c9 0f 1f 80 00 
[ 8111.347769] NMI backtrace for cpu 0
[ 8111.347769] CPU 0 
[ 8111.347769] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.347769] RIP: 0010:[<ffffffff819673d1>]  [<ffffffff819673d1>] delay_tsc+0x31/0x140
[ 8111.347769] RSP: 0018:ffff88000cf959f8  EFLAGS: 00000082
[ 8111.347769] RAX: 0000000000000000 RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.347769] RDX: 00000000b6d3b6d2 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.347769] RBP: ffff88000cf95a28 R08: 0000000010000004 R09: 0000000000000000
[ 8111.347769] R10: 0000000000000000 R11: 0000000000000000 R12: 000000008bfc4879
[ 8111.347769] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000086
[ 8111.347769] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 8111.347769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.347769] CR2: 0000000000000ff8 CR3: 000000005eb81000 CR4: 00000000000406f0
[ 8111.347769] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.347769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.347769] Process rcu_torture_rea (pid: 2658, threadinfo ffff88000cf94000, task ffff88000cfa0000)
[ 8111.347769] Stack:
[ 8111.347769]  ffff88000cf95a18 ffff88000d9d6140 000000008bfc4879 00000000948a9c80
[ 8111.347769]  0000000000000001 0000000000000086 ffff88000cf95a38 ffffffff8196736a
[ 8111.347769]  ffff88000cf95a78 ffffffff8197e07d ffff88000cf95a78 0000000000000086
[ 8111.347769] Call Trace:
[ 8111.347769]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.347769]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.347769]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.347769]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8111.347769]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8111.347769]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8111.347769]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8111.347769]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8111.347769]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8111.347769]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.347769]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8111.347769]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8111.347769]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8111.347769]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8111.347769]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8111.347769]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.347769]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.347769]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.347769]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.347769]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.347769]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.347769] Code: 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 f2 f4 7a ff e8 8d 84 01 00 0f 1f 00 0f ae e8 48 83 3d 37 d0 0d 03 00 <75> 07 0f 0b 0f 1f 00 eb fe 41 89 c6 e8 9e 92 70 ff 66 90 65 4c 
[ 8112.229101] NMI backtrace for cpu 3
[ 8112.229101] CPU 3 
[ 8112.229101] Pid: 27, comm: watchdog/3 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8112.229101] RIP: 0010:[<ffffffff81070686>]  [<ffffffff81070686>] native_read_tsc+0x6/0x20
[ 8112.229101] RSP: 0018:ffff8800354d7c90  EFLAGS: 00000082
[ 8112.229101] RAX: 00000000cfcf63b2 RBX: 00000000cfcf6383 RCX: 00000000cfcf6383
[ 8112.229101] RDX: 00000000000012dc RSI: 0000000000000000 RDI: 0000000000000001
[ 8112.229101] RBP: ffff8800354d7c90 R08: 0000000000000002 R09: 0000000000000000
[ 8112.229101] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800354d6010
[ 8112.229101] R13: 0000000000000001 R14: 0000000000000003 R15: ffff88000d9d6140
[ 8112.229101] FS:  0000000000000000(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 8112.229101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8112.229101] CR2: 00007fe1aee26600 CR3: 000000000b42d000 CR4: 00000000000406e0
[ 8112.229101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8112.229101] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8112.229101] Process watchdog/3 (pid: 27, threadinfo ffff8800354d6000, task ffff8800354d8000)
[ 8112.229101] Stack:
[ 8112.229101]  ffff8800354d7cd0 ffffffff81967425 ffff8800354d7d20 ffff88000d9d6140
[ 8112.229101]  00000000913d633e 00000000948a9c80 0000000000000001 ffff88000d9d6140
[ 8112.229101]  ffff8800354d7ce0 ffffffff8196736a ffff8800354d7d20 ffffffff8197e07d
[ 8112.229101] Call Trace:
[ 8112.229101]  [<ffffffff81967425>] delay_tsc+0x85/0x140
[ 8112.229101]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8112.229101]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8112.229101]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8112.229101]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8112.229101]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8112.229101]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8112.229101]  [<ffffffff81121785>] ? sched_clock_local+0x25/0x90
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8112.229101]  [<ffffffff8118369a>] watchdog+0x7a/0xd0
[ 8112.229101]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8112.229101]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8112.229101]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8112.229101]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8112.229101]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8112.229101] Code: 08 ff 15 ae be 9c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[ 8111.011063] NMI backtrace for cpu 4
[ 8111.011063] CPU 4 
[ 8111.011063] Pid: 2654, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.011063] RIP: 0010:[<ffffffff8196740e>]  [<ffffffff8196740e>] delay_tsc+0x6e/0x140
[ 8111.011063] RSP: 0018:ffff880041803d78  EFLAGS: 00000082
[ 8111.011063] RAX: 000012dccfa8fa68 RBX: 00000000cfa8fa68 RCX: 00000000cfa8fa68
[ 8111.011063] RDX: 00000000000012dc RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.011063] RBP: ffff880041803da8 R08: 0000000000010001 R09: 0000000000000000
[ 8111.011063] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000cf74010
[ 8111.011063] R13: 0000000000000001 R14: 0000000000000004 R15: 0000000000000001
[ 8111.011063] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 8111.011063] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.011063] CR2: 00007f93d6ff5021 CR3: 000000000809d000 CR4: 00000000000406e0
[ 8111.011063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.011063] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.011063] Process rcu_torture_rea (pid: 2654, threadinfo ffff88000cf74000, task ffff88000cf78000)
[ 8111.011063] Stack:
[ 8111.011063]  ffff880041803df8 ffff88000d9d6140 000000008daabef7 00000000948a9c80
[ 8111.011063]  0000000000000001 0000000000000001 ffff880041803db8 ffffffff8196736a
[ 8111.011063]  ffff880041803df8 ffffffff8197e07d ffff880041803df8 0000000000000086
[ 8111.011063] Call Trace:
[ 8111.011063]  <IRQ> 
[ 8111.011063]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.011063]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.011063]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.011063]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 8111.011063]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 8111.011063]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 8111.011063]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 8111.011063]  [<ffffffff8111641f>] ? account_system_vtime+0xff/0x140
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 8111.011063]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8111.011063]  <EOI> 
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8114f01d>] ? lock_release+0x17d/0x1a0
[ 8111.011063]  [<ffffffff8118dc38>] rcu_torture_read_unlock+0x58/0x60
[ 8111.011063]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.011063]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.011063]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.011063]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.011063]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.011063]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.011063]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.011063]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.011063] Code: 90 65 4c 8b 24 25 88 d9 00 00 89 c3 49 81 ec c8 1f 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f ae e8 48 83 3d fa cf 0d 03 00 <75> 10 0f 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 e8 5b 92 
[ 8112.229101] BUG: spinlock lockup on CPU#3, watchdog/3/27
[ 8112.229101]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
[ 8112.229101] Pid: 27, comm: watchdog/3 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
[ 8112.229101] Call Trace:
[ 8112.229101]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 8112.229101]  [<ffffffff8197e09e>] do_raw_spin_lock+0xfe/0x140
[ 8112.229101]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8112.229101]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8112.229101]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8112.229101]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8112.229101]  [<ffffffff81121785>] ? sched_clock_local+0x25/0x90
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8112.229101]  [<ffffffff8118369a>] watchdog+0x7a/0xd0
[ 8112.229101]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8112.229101]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8112.229101]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8112.229101]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8112.229101]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8112.229101] sending NMI to all CPUs:
[ 8111.347769] NMI backtrace for cpu 0
[ 8111.347769] CPU 0 
[ 8111.347769] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.347769] RIP: 0010:[<ffffffff819673a1>]  [<ffffffff819673a1>] delay_tsc+0x1/0x140
[ 8111.347769] RSP: 0018:ffff88000cf95a28  EFLAGS: 00000002
[ 8111.347769] RAX: 0000000000000000 RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.347769] RDX: 00000000b6d3b6d2 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.347769] RBP: ffff88000cf95a38 R08: 0000000010000004 R09: 0000000000000000
[ 8111.347769] R10: 0000000000000000 R11: 0000000000000000 R12: 000000008f1a16ab
[ 8111.347769] R13: 00000000948a9c80 R14: 0000000000000001 R15: 0000000000000086
[ 8111.347769] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 8111.347769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.347769] CR2: 0000000000000ff8 CR3: 000000005eb81000 CR4: 00000000000406f0
[ 8111.347769] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.347769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.347769] Process rcu_torture_rea (pid: 2658, threadinfo ffff88000cf94000, task ffff88000cfa0000)
[ 8111.347769] Stack:
[ 8111.347769]  ffff88000cf95a38 ffffffff8196736a ffff88000cf95a78 ffffffff8197e07d
[ 8111.347769]  ffff88000cf95a78 0000000000000086 ffff88000d9d6140 ffff88000d9d6158
[ 8111.347769]  00000000001d6140 000000000000008b ffff88000cf95aa8 ffffffff837c0b2b
[ 8111.347769] Call Trace:
[ 8111.347769]  [<ffffffff8196736a>] ? __delay+0xa/0x10
[ 8111.347769]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.347769]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.347769]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8111.347769]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8111.347769]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8111.347769]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8111.347769]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8111.347769]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8111.347769]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.347769]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8111.347769]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8111.347769]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8111.347769]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8111.347769]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8111.347769]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.347769]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.347769]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.347769]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.347769]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.347769]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.347769] Code: 00 00 00 48 89 e5 65 48 8b 14 25 58 60 1d 00 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 08 0c 47 03 c9 c3 66 0f 1f 44 00 00 55 <48> 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 
[ 8112.229101] NMI backtrace for cpu 3
[ 8112.229101] CPU 3 
[ 8112.229101] Pid: 27, comm: watchdog/3 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8112.229101] RIP: 0010:[<ffffffff8109a5aa>]  [<ffffffff8109a5aa>] native_write_msr_safe+0xa/0x10
[ 8112.229101] RSP: 0018:ffff8800354d7c40  EFLAGS: 00000086
[ 8112.229101] RAX: 0000000000000400 RBX: 0000000000000003 RCX: 0000000000000830
[ 8112.229101] RDX: 0000000000000003 RSI: 0000000000000400 RDI: 0000000000000830
[ 8112.229101] RBP: ffff8800354d7c40 R08: ffffffff851259c0 R09: 0000000000000000
[ 8112.229101] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[ 8112.229101] R13: ffffffff851259c0 R14: 0000000000000003 R15: 000000000000ef40
[ 8112.229101] FS:  0000000000000000(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 8112.229101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8112.229101] CR2: 00007fe1aee26600 CR3: 000000000b42d000 CR4: 00000000000406e0
[ 8112.229101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8112.229101] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8112.229101] Process watchdog/3 (pid: 27, threadinfo ffff8800354d6000, task ffff8800354d8000)
[ 8112.229101] Stack:
[ 8112.229101]  ffff8800354d7cb0 ffffffff81093d2d 0000000000000000 ffff88000d9d6140
[ 8112.229101]  ffff8800354d7cc0 0000000000000086 0000000000000002 0000000200080000
[ 8112.229101]  ffff8800354d7c90 0000000000000000 00000000948a9c80 00000000948a9c80
[ 8112.229101] Call Trace:
[ 8112.229101]  [<ffffffff81093d2d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 8112.229101]  [<ffffffff81093e17>] x2apic_send_IPI_all+0x17/0x20
[ 8112.229101]  [<ffffffff8108f184>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 8112.229101]  [<ffffffff8197e0a3>] do_raw_spin_lock+0x103/0x140
[ 8112.229101]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8112.229101]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8112.229101]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8112.229101]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8112.229101]  [<ffffffff81121785>] ? sched_clock_local+0x25/0x90
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8112.229101]  [<ffffffff8118369a>] watchdog+0x7a/0xd0
[ 8112.229101]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8112.229101]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8112.229101]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8112.229101]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8112.229101]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8112.229101] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 8111.351463] NMI backtrace for cpu 2
[ 8111.351463] CPU 2 
[ 8111.351463] Pid: 11, comm: rcub/5 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.351463] RIP: 0010:[<ffffffff81070686>]  [<ffffffff81070686>] native_read_tsc+0x6/0x20
[ 8111.351463] RSP: 0018:ffff88000d575c80  EFLAGS: 00000082
[ 8111.351463] RAX: 00000000e96c109c RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.351463] RDX: 00000000000012df RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.351463] RBP: ffff88000d575c80 R08: 0000000000000002 R09: 0000000000000000
[ 8111.351463] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000033fccab
[ 8111.351463] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88000d9d6140
[ 8111.351463] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 8111.351463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.351463] CR2: 00007f155b06eff9 CR3: 00000000389c4000 CR4: 00000000000406e0
[ 8111.351463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.351463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.351463] Process rcub/5 (pid: 11, threadinfo ffff88000d574000, task ffff88000d578000)
[ 8111.351463] Stack:
[ 8111.351463]  ffff88000d575cc0 ffffffff819673e2 0000000000000000 ffff88000d9d6140
[ 8111.351463]  00000000033fccab 00000000948a9c80 0000000000000000 ffff88000d9d6140
[ 8111.351463]  ffff88000d575cd0 ffffffff8196736a ffff88000d575d10 ffffffff8197e07d
[ 8111.351463] Call Trace:
[ 8111.351463]  [<ffffffff819673e2>] delay_tsc+0x42/0x140
[ 8111.351463]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.351463]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.351463]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.351463]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8111.351463]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8111.351463]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8111.351463]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8111.351463]  [<ffffffff81190e50>] rcu_boost_kthread+0x90/0x120
[ 8111.351463]  [<ffffffff81190dc0>] ? trace_rcu_utilization+0xd0/0xd0
[ 8111.351463]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.351463]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.351463]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.351463]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.351463]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.351463] Code: 08 ff 15 ae be 9c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[ 8110.306059] NMI backtrace for cpu 1
[ 8110.306059] CPU 1 
[ 8110.306059] Pid: 2653, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8110.306059] RIP: 0010:[<ffffffff8196736a>]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8110.306059] RSP: 0018:ffff88001b803c70  EFLAGS: 00000082
[ 8110.306059] RAX: 0000000000000000 RBX: ffff88000d9d6140 RCX: 0000000000000000
[ 8110.306059] RDX: 00000000000012df RSI: 0000000000000000 RDI: 0000000000000001
[ 8110.306059] RBP: ffff88001b803c70 R08: 0000000000000105 R09: 0000000000000000
[ 8110.306059] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000058864be
[ 8110.306059] R13: 00000000948a9c80 R14: 0000000000000000 R15: ffff88001b803d70
[ 8110.306059] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 8110.306059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8110.306059] CR2: 0000000000000ffc CR3: 000000005f1ee000 CR4: 00000000000406e0
[ 8110.306059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8110.306059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8110.306059] Process rcu_torture_rea (pid: 2653, threadinfo ffff88000cf72000, task ffff88000cf6b000)
[ 8110.306059] Stack:
[ 8110.306059]  ffff88001b803cb0 ffffffff8197e07d ffff88001b803cb0 0000000000000086
[ 8110.306059]  ffff88000d9d6140 ffff88000d9d6158 0000000000000287 0000000000000000
[ 8110.306059]  ffff88001b803ce0 ffffffff837c0b2b ffffffff81126620 000000000000fff8
[ 8110.306059] Call Trace:
[ 8110.306059]  <IRQ> 
[ 8110.306059]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8110.306059]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.306059]  [<ffffffff81126620>] ? load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126620>] load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126d38>] ? update_shares+0x158/0x240
[ 8110.306059]  [<ffffffff81126fdd>] rebalance_domains+0x1bd/0x290
[ 8110.306059]  [<ffffffff81126e20>] ? update_shares+0x240/0x240
[ 8110.306059]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 8110.306059]  [<ffffffff811272c3>] run_rebalance_domains+0x43/0x60
[ 8110.306059]  [<ffffffff810e2c01>] __do_softirq+0x221/0x460
[ 8110.306059]  [<ffffffff8109a516>] ? kvm_clock_read+0x46/0x80
[ 8110.306059]  [<ffffffff837c3aec>] call_softirq+0x1c/0x30
[ 8110.306059]  [<ffffffff81069215>] do_softirq+0x75/0x120
[ 8110.306059]  [<ffffffff810e1c0b>] irq_exit+0x5b/0xf0
[ 8110.306059]  [<ffffffff8108e99a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 8110.306059]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8110.306059]  <EOI> 
[ 8110.306059]  [<ffffffff837c164b>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8110.306059]  [<ffffffff837c166c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8110.306059]  [<ffffffff811171bd>] finish_task_switch+0x8d/0x110
[ 8110.306059]  [<ffffffff81117180>] ? finish_task_switch+0x50/0x110
[ 8110.306059]  [<ffffffff837bf943>] __schedule+0x7e3/0x880
[ 8110.306059]  [<ffffffff8118dfc0>] ? rcu_torture_reader+0x380/0x380
[ 8110.306059]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8110.306059]  [<ffffffff8118dee2>] rcu_torture_reader+0x2a2/0x380
[ 8110.306059]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.306059]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.306059]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.306059]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.306059]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.306059]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.306059]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] Code: 00 55 48 c7 05 54 0c 47 03 a0 73 96 81 48 89 e5 c9 c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 ff 15 36 0c 47 03 <c9> c3 0f 1f 40 00 55 48 8d 04 bd 00 00 00 00 48 89 e5 65 48 8b 
[ 8111.011063] NMI backtrace for cpu 4
[ 8111.011063] CPU 4 
[ 8111.011063] Pid: 2654, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.011063] RIP: 0010:[<ffffffff81070688>]  [<ffffffff81070688>] native_read_tsc+0x8/0x20
[ 8111.011063] RSP: 0018:ffff880041803d68  EFLAGS: 00000082
[ 8111.011063] RAX: 0000000007eddbe7 RBX: ffff88000d9d6140 RCX: 0000000007eddbe7
[ 8111.011063] RDX: 00000000000012e0 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.011063] RBP: ffff880041803d68 R08: 0000000000010001 R09: 0000000000000000
[ 8111.011063] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000091460d14
[ 8111.011063] R13: 0000000000000001 R14: 0000000000000004 R15: 0000000000000001
[ 8111.011063] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 8111.011063] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.011063] CR2: 00007f93d6ff5021 CR3: 000000000809d000 CR4: 00000000000406e0
[ 8111.011063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.011063] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.011063] Process rcu_torture_rea (pid: 2654, threadinfo ffff88000cf74000, task ffff88000cf78000)
[ 8111.011063] Stack:
[ 8111.011063]  ffff880041803da8 ffffffff819673e2 ffff880041803df8 ffff88000d9d6140
[ 8111.011063]  0000000091460d14 00000000948a9c80 0000000000000001 0000000000000001
[ 8111.011063]  ffff880041803db8 ffffffff8196736a ffff880041803df8 ffffffff8197e07d
[ 8111.011063] Call Trace:
[ 8111.011063]  <IRQ> 
[ 8111.011063]  [<ffffffff819673e2>] delay_tsc+0x42/0x140
[ 8111.011063]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.011063]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.011063]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.011063]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 8111.011063]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 8111.011063]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 8111.011063]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 8111.011063]  [<ffffffff8111641f>] ? account_system_vtime+0xff/0x140
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 8111.011063]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8111.011063]  <EOI> 
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8114f01d>] ? lock_release+0x17d/0x1a0
[ 8111.011063]  [<ffffffff8118dc38>] rcu_torture_read_unlock+0x58/0x60
[ 8111.011063]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.011063]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.011063]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.011063]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.011063]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.011063]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.011063]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.011063]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.011063] Code: 15 ae be 9c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 89 c1 <c9> 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 00 00 
[ 8111.011063] BUG: spinlock lockup on CPU#4, rcu_torture_rea/2654
[ 8111.011063]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
[ 8111.011063] Pid: 2654, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
[ 8111.011063] Call Trace:
[ 8111.011063]  <IRQ>  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 8111.011063]  [<ffffffff8197e09e>] do_raw_spin_lock+0xfe/0x140
[ 8111.011063]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.011063]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 8111.011063]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 8111.011063]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 8111.011063]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 8111.011063]  [<ffffffff8111641f>] ? account_system_vtime+0xff/0x140
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 8111.011063]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8111.011063]  <EOI>  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8114f01d>] ? lock_release+0x17d/0x1a0
[ 8111.011063]  [<ffffffff8118dc38>] rcu_torture_read_unlock+0x58/0x60
[ 8111.011063]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.011063]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.011063]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.011063]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.011063]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.011063]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.011063]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.011063]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.011063] sending NMI to all CPUs:
[ 8111.011063] NMI backtrace for cpu 4
[ 8111.011063] CPU 4 
[ 8111.011063] Pid: 2654, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.011063] RIP: 0010:[<ffffffff8109a5aa>]  [<ffffffff8109a5aa>] native_write_msr_safe+0xa/0x10
[ 8111.011063] RSP: 0018:ffff880041803d18  EFLAGS: 00000086
[ 8111.011063] RAX: 0000000000000400 RBX: 0000000000000004 RCX: 0000000000000830
[ 8111.011063] RDX: 0000000000000004 RSI: 0000000000000400 RDI: 0000000000000830
[ 8111.011063] RBP: ffff880041803d18 R08: ffffffff851259c0 R09: 0000000000000000
[ 8111.011063] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000004
[ 8111.011063] R13: ffffffff851259c0 R14: 0000000000000004 R15: 000000000000ef40
[ 8111.011063] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 8111.011063] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.011063] CR2: 00007f93d6ff5021 CR3: 000000000809d000 CR4: 00000000000406e0
[ 8111.011063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.011063] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.011063] Process rcu_torture_rea (pid: 2654, threadinfo ffff88000cf74000, task ffff88000cf78000)
[ 8111.011063] Stack:
[ 8111.011063]  ffff880041803d88 ffffffff81093d2d 0000000000000000 0000000000000001
[ 8111.011063]  ffff880041803d98 0000000000000086 0000000000000002 0000000200080000
[ 8111.011063]  ffff880041803d68 0000000000000000 00000000948a9c80 00000000948a9c80
[ 8111.011063] Call Trace:
[ 8111.011063]  <IRQ> 
[ 8111.011063]  [<ffffffff81093d2d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 8111.011063]  [<ffffffff81093e17>] x2apic_send_IPI_all+0x17/0x20
[ 8111.011063]  [<ffffffff8108f184>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 8111.011063]  [<ffffffff8197e0a3>] do_raw_spin_lock+0x103/0x140
[ 8111.011063]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.011063]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 8111.011063]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 8111.011063]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 8111.011063]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 8111.011063]  [<ffffffff8111641f>] ? account_system_vtime+0xff/0x140
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 8111.011063]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8111.011063]  <EOI> 
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8114f01d>] ? lock_release+0x17d/0x1a0
[ 8111.011063]  [<ffffffff8118dc38>] rcu_torture_read_unlock+0x58/0x60
[ 8111.011063]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.011063]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.011063]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.011063]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.011063]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.011063]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.011063]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.011063]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.011063] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 8111.347769] NMI backtrace for cpu 0
[ 8111.347769] CPU 0 
[ 8111.347769] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.347769] RIP: 0010:[<ffffffff81070686>]  [<ffffffff81070686>] native_read_tsc+0x6/0x20
[ 8111.347769] RSP: 0018:ffff88000cf959e8  EFLAGS: 00000082
[ 8111.347769] RAX: 0000000069137f7d RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.347769] RDX: 00000000000012e3 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.347769] RBP: ffff88000cf959e8 R08: 0000000010000004 R09: 0000000000000000
[ 8111.347769] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000932d7753
[ 8111.347769] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000086
[ 8111.347769] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 8111.347769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.347769] CR2: 0000000000000ff8 CR3: 000000005eb81000 CR4: 00000000000406f0
[ 8111.347769] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.347769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.347769] Process rcu_torture_rea (pid: 2658, threadinfo ffff88000cf94000, task ffff88000cfa0000)
[ 8111.347769] Stack:
[ 8111.347769]  ffff88000cf95a28 ffffffff819673e2 ffff88000cf95a18 ffff88000d9d6140
[ 8111.347769]  00000000932d7753 00000000948a9c80 0000000000000001 0000000000000086
[ 8111.347769]  ffff88000cf95a38 ffffffff8196736a ffff88000cf95a78 ffffffff8197e07d
[ 8111.347769] Call Trace:
[ 8111.347769]  [<ffffffff819673e2>] delay_tsc+0x42/0x140
[ 8111.347769]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.347769]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.347769]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.347769]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8111.347769]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8111.347769]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8111.347769]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8111.347769]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8111.347769]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8111.347769]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.347769]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8111.347769]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8111.347769]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8111.347769]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8111.347769]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8111.347769]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.347769]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.347769]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.347769]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.347769]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.347769]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.347769] Code: 08 ff 15 ae be 9c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[ 8110.306059] NMI backtrace for cpu 1
[ 8110.306059] CPU 1 
[ 8110.306059] Pid: 2653, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8110.306059] RIP: 0010:[<ffffffff8196740e>]  [<ffffffff8196740e>] delay_tsc+0x6e/0x140
[ 8110.306059] RSP: 0018:ffff88001b803c30  EFLAGS: 00000082
[ 8110.306059] RAX: 000012e369144e60 RBX: 0000000069144e60 RCX: 0000000069144e60
[ 8110.306059] RDX: 00000000000012e3 RSI: 0000000000000000 RDI: 0000000000000001
[ 8110.306059] RBP: ffff88001b803c60 R08: 0000000000000105 R09: 0000000000000000
[ 8110.306059] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000cf72010
[ 8110.306059] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88001b803d70
[ 8110.306059] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 8110.306059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8110.306059] CR2: 0000000000000ffc CR3: 000000005f1ee000 CR4: 00000000000406e0
[ 8110.306059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8110.306059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8110.306059] Process rcu_torture_rea (pid: 2653, threadinfo ffff88000cf72000, task ffff88000cf6b000)
[ 8110.306059] Stack:
[ 8110.306059]  0000000000000000 ffff88000d9d6140 000000000a12546a 00000000948a9c80
[ 8110.306059]  0000000000000000 ffff88001b803d70 ffff88001b803c70 ffffffff8196736a
[ 8110.306059]  ffff88001b803cb0 ffffffff8197e07d ffff88001b803cb0 0000000000000086
[ 8110.306059] Call Trace:
[ 8110.306059]  <IRQ> 
[ 8110.306059]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8110.306059]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8110.306059]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.306059]  [<ffffffff81126620>] ? load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126620>] load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126d38>] ? update_shares+0x158/0x240
[ 8110.306059]  [<ffffffff81126fdd>] rebalance_domains+0x1bd/0x290
[ 8110.306059]  [<ffffffff81126e20>] ? update_shares+0x240/0x240
[ 8110.306059]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 8110.306059]  [<ffffffff811272c3>] run_rebalance_domains+0x43/0x60
[ 8110.306059]  [<ffffffff810e2c01>] __do_softirq+0x221/0x460
[ 8110.306059]  [<ffffffff8109a516>] ? kvm_clock_read+0x46/0x80
[ 8110.306059]  [<ffffffff837c3aec>] call_softirq+0x1c/0x30
[ 8110.306059]  [<ffffffff81069215>] do_softirq+0x75/0x120
[ 8110.306059]  [<ffffffff810e1c0b>] irq_exit+0x5b/0xf0
[ 8110.306059]  [<ffffffff8108e99a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 8110.306059]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8110.306059]  <EOI> 
[ 8110.306059]  [<ffffffff837c164b>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8110.306059]  [<ffffffff837c166c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8110.306059]  [<ffffffff811171bd>] finish_task_switch+0x8d/0x110
[ 8110.306059]  [<ffffffff81117180>] ? finish_task_switch+0x50/0x110
[ 8110.306059]  [<ffffffff837bf943>] __schedule+0x7e3/0x880
[ 8110.306059]  [<ffffffff8118dfc0>] ? rcu_torture_reader+0x380/0x380
[ 8110.306059]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8110.306059]  [<ffffffff8118dee2>] rcu_torture_reader+0x2a2/0x380
[ 8110.306059]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.306059]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.306059]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.306059]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.306059]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.306059]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.306059]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] Code: 90 65 4c 8b 24 25 88 d9 00 00 89 c3 49 81 ec c8 1f 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f ae e8 48 83 3d fa cf 0d 03 00 <75> 10 0f 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 e8 5b 92 
[ 8112.229101] NMI backtrace for cpu 3
[ 8112.229101] CPU 3 
[ 8112.229101] Pid: 27, comm: watchdog/3 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8112.229101] RIP: 0010:[<ffffffff81070688>]  [<ffffffff81070688>] native_read_tsc+0x8/0x20
[ 8112.229101] RSP: 0018:ffff8800354d7c90  EFLAGS: 00000082
[ 8112.229101] RAX: 0000000069147143 RBX: ffff88000d9d6140 RCX: 0000000069147143
[ 8112.229101] RDX: 00000000000012e3 RSI: 0000000000000000 RDI: 0000000000000001
[ 8112.229101] RBP: ffff8800354d7c90 R08: 0000000000000002 R09: 0000000000000000
[ 8112.229101] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000003e7b190
[ 8112.229101] R13: 0000000000000001 R14: 0000000000000003 R15: ffff88000d9d6140
[ 8112.229101] FS:  0000000000000000(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 8112.229101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8112.229101] CR2: 00007fe1aee26600 CR3: 000000000b42d000 CR4: 00000000000406e0
[ 8112.229101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8112.229101] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8112.229101] Process watchdog/3 (pid: 27, threadinfo ffff8800354d6000, task ffff8800354d8000)
[ 8112.229101] Stack:
[ 8112.229101]  ffff8800354d7cd0 ffffffff819673e2 0000000000000000 ffff88000d9d6140
[ 8112.229101]  0000000003e7b190 00000000948a9c80 0000000000000000 ffff88000d9d6140
[ 8112.229101]  ffff8800354d7ce0 ffffffff8196736a ffff8800354d7d20 ffffffff8197e07d
[ 8112.229101] Call Trace:
[ 8112.229101]  [<ffffffff819673e2>] delay_tsc+0x42/0x140
[ 8112.229101]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8112.229101]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8112.229101]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8112.229101]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8112.229101]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8112.229101]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8112.229101]  [<ffffffff81121785>] ? sched_clock_local+0x25/0x90
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8112.229101]  [<ffffffff8118369a>] watchdog+0x7a/0xd0
[ 8112.229101]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8112.229101]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8112.229101]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8112.229101]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8112.229101]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8112.229101] Code: 15 ae be 9c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 89 c1 <c9> 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 00 00 
[ 8111.351463] NMI backtrace for cpu 2
[ 8111.351463] CPU 2 
[ 8111.351463] Pid: 11, comm: rcub/5 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.351463] RIP: 0010:[<ffffffff81070686>]  [<ffffffff81070686>] native_read_tsc+0x6/0x20
[ 8111.351463] RSP: 0018:ffff88000d575c80  EFLAGS: 00000082
[ 8111.351463] RAX: 00000000686f9b15 RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.351463] RDX: 00000000000012e3 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.351463] RBP: ffff88000d575c80 R08: 0000000000000002 R09: 0000000000000000
[ 8111.351463] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000006a0401f
[ 8111.351463] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88000d9d6140
[ 8111.351463] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 8111.351463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.351463] CR2: 00007f155b06eff9 CR3: 00000000389c4000 CR4: 00000000000406e0
[ 8111.351463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.351463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.351463] Process rcub/5 (pid: 11, threadinfo ffff88000d574000, task ffff88000d578000)
[ 8111.351463] Stack:
[ 8111.351463]  ffff88000d575cc0 ffffffff819673e2 0000000000000000 ffff88000d9d6140
[ 8111.351463]  0000000006a0401f 00000000948a9c80 0000000000000000 ffff88000d9d6140
[ 8111.351463]  ffff88000d575cd0 ffffffff8196736a ffff88000d575d10 ffffffff8197e07d
[ 8111.351463] Call Trace:
[ 8111.351463]  [<ffffffff819673e2>] delay_tsc+0x42/0x140
[ 8111.351463]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.351463]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.351463]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.351463]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8111.351463]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8111.351463]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8111.351463]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8111.351463]  [<ffffffff81190e50>] rcu_boost_kthread+0x90/0x120
[ 8111.351463]  [<ffffffff81190dc0>] ? trace_rcu_utilization+0xd0/0xd0
[ 8111.351463]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.351463]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.351463]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.351463]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.351463]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.351463] Code: 08 ff 15 ae be 9c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[ 8111.347769] BUG: spinlock lockup on CPU#0, rcu_torture_rea/2658
[ 8111.347769]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
[ 8111.347769] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
[ 8111.347769] Call Trace:
[ 8111.347769]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 8111.347769]  [<ffffffff8197e09e>] do_raw_spin_lock+0xfe/0x140
[ 8111.347769]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.347769]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8111.347769]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8111.347769]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8111.347769]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8111.347769]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8111.347769]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8111.347769]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.347769]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8111.347769]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8111.347769]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8111.347769]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8111.347769]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8111.347769]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.347769]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.347769]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.347769]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.347769]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.347769]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.347769] sending NMI to all CPUs:
[ 8111.347769] NMI backtrace for cpu 0
[ 8111.347769] CPU 0 
[ 8111.347769] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.347769] RIP: 0010:[<ffffffff8109a5aa>]  [<ffffffff8109a5aa>] native_write_msr_safe+0xa/0x10
[ 8111.347769] RSP: 0018:ffff88000cf95998  EFLAGS: 00000086
[ 8111.347769] RAX: 0000000000000400 RBX: 0000000000000000 RCX: 0000000000000830
[ 8111.347769] RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000830
[ 8111.347769] RBP: ffff88000cf95998 R08: ffffffff851259c0 R09: 0000000000000000
[ 8111.347769] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 8111.347769] R13: ffffffff851259c0 R14: 0000000000000000 R15: 000000000000ef40
[ 8111.347769] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 8111.347769] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.347769] CR2: 0000000000000ff8 CR3: 000000005eb81000 CR4: 00000000000406f0
[ 8111.347769] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.347769] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.347769] Process rcu_torture_rea (pid: 2658, threadinfo ffff88000cf94000, task ffff88000cfa0000)
[ 8111.347769] Stack:
[ 8111.347769]  ffff88000cf95a08 ffffffff81093d2d 0000000000000000 0000000000000086
[ 8111.347769]  ffff88000cf95a18 0000000000000086 0000000000000002 0000000200080000
[ 8111.347769]  ffff88000cf959e8 0000000000000000 00000000948a9c80 00000000948a9c80
[ 8111.347769] Call Trace:
[ 8111.347769]  [<ffffffff81093d2d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 8111.347769]  [<ffffffff81093e17>] x2apic_send_IPI_all+0x17/0x20
[ 8111.347769]  [<ffffffff8108f184>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 8111.347769]  [<ffffffff8197e0a3>] do_raw_spin_lock+0x103/0x140
[ 8111.347769]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.347769]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
[ 8111.347769]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
[ 8111.347769]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
[ 8111.347769]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
[ 8111.347769]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
[ 8111.347769]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 8111.347769]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
[ 8111.347769]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.347769]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
[ 8111.347769]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
[ 8111.347769]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
[ 8111.347769]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
[ 8111.347769]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
[ 8111.347769]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.347769]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.347769]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.347769]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.347769]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.347769]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.347769]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.347769]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.347769] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 8110.306059] NMI backtrace for cpu 1
[ 8110.306059] CPU 1 
[ 8110.306059] Pid: 2653, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8110.306059] RIP: 0010:[<ffffffff81116890>]  [<ffffffff81116890>] sub_preempt_count+0x90/0xb0
[ 8110.306059] RSP: 0018:ffff88001b803c20  EFLAGS: 00000006
[ 8110.306059] RAX: ffff88000cf73fd8 RBX: 0000000046560e3e RCX: 0000000000000000
[ 8110.306059] RDX: 00000000000012e5 RSI: 0000000000000000 RDI: 0000000000000001
[ 8110.306059] RBP: ffff88001b803c20 R08: 0000000000000105 R09: 0000000000000000
[ 8110.306059] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000cf72010
[ 8110.306059] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000046560e6d
[ 8110.306059] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 8110.306059] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8110.306059] CR2: 0000000000000ffc CR3: 000000005f1ee000 CR4: 00000000000406e0
[ 8110.306059] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8110.306059] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8110.306059] Process rcu_torture_rea (pid: 2653, threadinfo ffff88000cf72000, task ffff88000cf6b000)
[ 8110.306059] Stack:
[ 8110.306059]  ffff88001b803c60 ffffffff819674aa 0000000000000000 ffff88000d9d6140
[ 8110.306059]  000000000c21d807 00000000948a9c80 0000000000000000 ffff88001b803d70
[ 8110.306059]  ffff88001b803c70 ffffffff8196736a ffff88001b803cb0 ffffffff8197e07d
[ 8110.306059] Call Trace:
[ 8110.306059]  <IRQ> 
[ 8110.306059]  [<ffffffff819674aa>] delay_tsc+0x10a/0x140
[ 8110.306059]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8110.306059]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8110.306059]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8110.306059]  [<ffffffff81126620>] ? load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126620>] load_balance+0x410/0x820
[ 8110.306059]  [<ffffffff81126d38>] ? update_shares+0x158/0x240
[ 8110.306059]  [<ffffffff81126fdd>] rebalance_domains+0x1bd/0x290
[ 8110.306059]  [<ffffffff81126e20>] ? update_shares+0x240/0x240
[ 8110.306059]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 8110.306059]  [<ffffffff811272c3>] run_rebalance_domains+0x43/0x60
[ 8110.306059]  [<ffffffff810e2c01>] __do_softirq+0x221/0x460
[ 8110.306059]  [<ffffffff8109a516>] ? kvm_clock_read+0x46/0x80
[ 8110.306059]  [<ffffffff837c3aec>] call_softirq+0x1c/0x30
[ 8110.306059]  [<ffffffff81069215>] do_softirq+0x75/0x120
[ 8110.306059]  [<ffffffff810e1c0b>] irq_exit+0x5b/0xf0
[ 8110.306059]  [<ffffffff8108e99a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 8110.306059]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8110.306059]  <EOI> 
[ 8110.306059]  [<ffffffff837c164b>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 8110.306059]  [<ffffffff837c166c>] ? _raw_spin_unlock_irq+0x4c/0x80
[ 8110.306059]  [<ffffffff811171bd>] finish_task_switch+0x8d/0x110
[ 8110.306059]  [<ffffffff81117180>] ? finish_task_switch+0x50/0x110
[ 8110.306059]  [<ffffffff837bf943>] __schedule+0x7e3/0x880
[ 8110.306059]  [<ffffffff8118dfc0>] ? rcu_torture_reader+0x380/0x380
[ 8110.306059]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8110.306059]  [<ffffffff8118dee2>] rcu_torture_reader+0x2a2/0x380
[ 8110.306059]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8110.306059]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8110.306059]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8110.306059]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8110.306059]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8110.306059]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8110.306059]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8110.306059] Code: 00 00 48 c7 c7 6f a7 40 84 e8 2d 21 fc ff eb 2b 0f 1f 00 65 48 8b 04 25 88 d9 00 00 29 b8 44 e0 ff ff eb 17 0f 1f 80 00 00 00 00 <81> ff fe 00 00 00 77 e0 eb aa 66 0f 1f 44 00 00 c9 0f 1f 80 00 
[ 8111.351463] NMI backtrace for cpu 2
[ 8111.351463] CPU 2 
[ 8111.351463] Pid: 11, comm: rcub/5 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.351463] RIP: 0010:[<ffffffff819674d1>]  [<ffffffff819674d1>] delay_tsc+0x131/0x140
[ 8111.351463] RSP: 0018:ffff88000d575cc8  EFLAGS: 00000082
[ 8111.351463] RAX: 0000000000000000 RBX: ffff88000d9d6140 RCX: 0000000000000000
[ 8111.351463] RDX: 00000000000012e5 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.351463] RBP: ffff88000d575cd0 R08: 0000000000000002 R09: 0000000000000000
[ 8111.351463] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000008a00398
[ 8111.351463] R13: 00000000948a9c80 R14: 0000000000000000 R15: ffff88000d9d6140
[ 8111.351463] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 8111.351463] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.351463] CR2: 00007f155b06eff9 CR3: 00000000389c4000 CR4: 00000000000406e0
[ 8111.351463] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.351463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.351463] Process rcub/5 (pid: 11, threadinfo ffff88000d574000, task ffff88000d578000)
[ 8111.351463] Stack:
[ 8111.351463]  ffffffff8196736a ffff88000d575d10 ffffffff8197e07d ffff88000d575d10
[ 8111.351463]  0000000000000086 ffff88000d9d6140 ffff88000d9d6158 0000000000000002
[ 8111.351463]  0000000000000000 ffff88000d575d40 ffffffff837c0b2b ffffffff8112bfec
[ 8111.351463] Call Trace:
[ 8111.351463]  [<ffffffff8196736a>] ? __delay+0xa/0x10
[ 8111.351463]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.351463]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.351463]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8111.351463]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8111.351463]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8111.351463]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8111.351463]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8111.351463]  [<ffffffff81190e50>] rcu_boost_kthread+0x90/0x120
[ 8111.351463]  [<ffffffff81190dc0>] ? trace_rcu_utilization+0xd0/0xd0
[ 8111.351463]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.351463]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.351463]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.351463]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.351463]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.351463] Code: 56 f3 7a ff 65 48 8b 04 25 88 d9 00 00 48 8b 80 38 e0 ff ff a8 08 74 05 e8 bd 85 e5 01 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f c9 <c3> 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bf 48 
[ 8111.011063] NMI backtrace for cpu 4
[ 8111.011063] CPU 4 
[ 8111.011063] Pid: 2654, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8111.011063] RIP: 0010:[<ffffffff819673a4>]  [<ffffffff819673a4>] delay_tsc+0x4/0x140
[ 8111.011063] RSP: 0018:ffff880041803da8  EFLAGS: 00000002
[ 8111.011063] RAX: 0000000000000000 RBX: ffff88000d9d6140 RCX: 000000000000b6d3
[ 8111.011063] RDX: 00000000b6d3b6d2 RSI: 0000000000000000 RDI: 0000000000000001
[ 8111.011063] RBP: ffff880041803da8 R08: 0000000000010001 R09: 0000000000000000
[ 8111.011063] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000191edad
[ 8111.011063] R13: 00000000948a9c80 R14: 0000000000000000 R15: 0000000000000001
[ 8111.011063] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 8111.011063] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8111.011063] CR2: 00007f93d6ff5021 CR3: 000000000809d000 CR4: 00000000000406e0
[ 8111.011063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8111.011063] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8111.011063] Process rcu_torture_rea (pid: 2654, threadinfo ffff88000cf74000, task ffff88000cf78000)
[ 8111.011063] Stack:
[ 8111.011063]  ffff880041803db8 ffffffff8196736a ffff880041803df8 ffffffff8197e07d
[ 8111.011063]  ffff880041803df8 0000000000000086 ffff88000d9d6140 ffff88000d9d6158
[ 8111.011063]  0000000000000001 0000000000000000 ffff880041803e28 ffffffff837c0b2b
[ 8111.011063] Call Trace:
[ 8111.011063]  <IRQ> 
[ 8111.011063]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8111.011063]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8111.011063]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8111.011063]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 8111.011063]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 8111.011063]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 8111.011063]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 8111.011063]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 8111.011063]  [<ffffffff8111641f>] ? account_system_vtime+0xff/0x140
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 8111.011063]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 8111.011063]  <EOI> 
[ 8111.011063]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
[ 8111.011063]  [<ffffffff8114f01d>] ? lock_release+0x17d/0x1a0
[ 8111.011063]  [<ffffffff8118dc38>] rcu_torture_read_unlock+0x58/0x60
[ 8111.011063]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
[ 8111.011063]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
[ 8111.011063]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
[ 8111.011063]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8111.011063]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8111.011063]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8111.011063]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8111.011063]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8111.011063] Code: 48 89 e5 65 48 8b 14 25 58 60 1d 00 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 08 0c 47 03 c9 c3 66 0f 1f 44 00 00 55 48 89 e5 <41> 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 
[ 8112.229101] NMI backtrace for cpu 3
[ 8112.229101] CPU 3 
[ 8112.229101] Pid: 27, comm: watchdog/3 Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376  
[ 8112.229101] RIP: 0010:[<ffffffff8196740e>]  [<ffffffff8196740e>] delay_tsc+0x6e/0x140
[ 8112.229101] RSP: 0018:ffff8800354d7ca0  EFLAGS: 00000082
[ 8112.229101] RAX: 000012e54536e761 RBX: 000000004536e761 RCX: 000000004536e761
[ 8112.229101] RDX: 00000000000012e5 RSI: 0000000000000000 RDI: 0000000000000001
[ 8112.229101] RBP: ffff8800354d7cd0 R08: 0000000000000002 R09: 0000000000000000
[ 8112.229101] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800354d6010
[ 8112.229101] R13: 0000000000000001 R14: 0000000000000003 R15: ffff88000d9d6140
[ 8112.229101] FS:  0000000000000000(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 8112.229101] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8112.229101] CR2: 00007fe1aee26600 CR3: 000000000b42d000 CR4: 00000000000406e0
[ 8112.229101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 8112.229101] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 8112.229101] Process watchdog/3 (pid: 27, threadinfo ffff8800354d6000, task ffff8800354d8000)
[ 8112.229101] Stack:
[ 8112.229101]  0000000000000000 ffff88000d9d6140 0000000005bcbf34 00000000948a9c80
[ 8112.229101]  0000000000000000 ffff88000d9d6140 ffff8800354d7ce0 ffffffff8196736a
[ 8112.229101]  ffff8800354d7d20 ffffffff8197e07d ffff8800354d7d20 0000000000000086
[ 8112.229101] Call Trace:
[ 8112.229101]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 8112.229101]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 8112.229101]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
[ 8112.229101]  [<ffffffff8112bfec>] ? pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff837c1530>] ? _raw_spin_unlock+0x30/0x60
[ 8112.229101]  [<ffffffff8112bfec>] pull_rt_task+0xec/0x270
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff8112c224>] pre_schedule_rt+0x14/0x20
[ 8112.229101]  [<ffffffff837bf3b9>] __schedule+0x259/0x880
[ 8112.229101]  [<ffffffff81121785>] ? sched_clock_local+0x25/0x90
[ 8112.229101]  [<ffffffff81183620>] ? watchdog_enable+0x110/0x110
[ 8112.229101]  [<ffffffff837bfb45>] schedule+0x55/0x60
[ 8112.229101]  [<ffffffff8118369a>] watchdog+0x7a/0xd0
[ 8112.229101]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 8112.229101]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 8112.229101]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 8112.229101]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 8112.229101]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 8112.229101] Code: 90 65 4c 8b 24 25 88 d9 00 00 89 c3 49 81 ec c8 1f 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f ae e8 48 83 3d fa cf 0d 03 00 <75> 10 0f 0b 66 0f 1f 44 00 00 eb fe 66 0f 1f 44 00 00 e8 5b 92 



