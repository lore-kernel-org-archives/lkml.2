Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2F3Lf7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 07:35:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43279 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab2F3Lf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 07:35:57 -0400
Message-ID: <1341056208.27537.3.camel@lappy>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
From: Sasha Levin <levinsasha928@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Sat, 30 Jun 2012 13:36:48 +0200
In-Reply-To: <20120629172320.GA2416@linux.vnet.ibm.com>
References: <1340964584.2936.40.camel@lappy>
	 <20120629172320.GA2416@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, 2012-06-29 at 10:23 -0700, Paul E. McKenney wrote:
> Please see below for an untested patch that gets RCU out of this loop,
> but it is quite possible that something else is involved here, so it would
> be very good to get a lockdep run, if possible.  My concern stems from the
> fact that interrupts were enabled during the call to __rcu_read_unlock()
> -- otherwise it would not have been preempted -- so the runqueue locks
> were presumably not held on entry to __rcu_read_unlock(). 

I'll continue with the good news/bad news theme.

Good news - the original problem I've reported seems to be gone.

Bad news - I'm getting the following instead:

[ 6331.841058] BUG: spinlock recursion on CPU#3, trinity-child45/25254
[ 6331.841066]  lock: 0xffff880035bd6340, .magic: dead4ead, .owner: trinity-child45/25254, .owner_cpu: 3
[ 6331.841066] Pid: 25254, comm: trinity-child45 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488
[ 6331.841066] Call Trace:
[ 6331.841079]  [<ffffffff8199ba38>] spin_dump+0x78/0xc0
[ 6331.841079]  [<ffffffff8199baab>] spin_bug+0x2b/0x40
[ 6331.841079]  [<ffffffff8199bbee>] do_raw_spin_lock+0x4e/0x140
[ 6331.841079]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.841091]  [<ffffffff81130291>] ? rt_mutex_setprio+0x81/0x2c0
[ 6331.841096]  [<ffffffff81130291>] rt_mutex_setprio+0x81/0x2c0
[ 6331.841096]  [<ffffffff8116a0a0>] __rt_mutex_adjust_prio+0x20/0x30
[ 6331.841096]  [<ffffffff8372b1d4>] rt_mutex_slowunlock+0x104/0x130
[ 6331.841096]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.841098]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.841101]  [<ffffffff8113fe58>] ? update_curr_rt+0x228/0x270
[ 6331.841104]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.841106]  [<ffffffff811a8fea>] rcu_preempt_note_context_switch+0x22a/0x300
[ 6331.841108]  [<ffffffff8372a93a>] __schedule+0x76a/0x880
[ 6331.841111]  [<ffffffff8372ab41>] preempt_schedule+0x51/0x70
[ 6331.841115]  [<ffffffff81071640>] ? read_persistent_clock+0x30/0x30
[ 6331.841119]  [<ffffffff81984e23>] delay_tsc+0x123/0x140
[ 6331.841121]  [<ffffffff81984cf8>] __const_udelay+0x28/0x30
[ 6331.841125]  [<ffffffff81115b54>] __rcu_read_unlock+0x44/0xb0
[ 6331.841129]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.841131]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.841134]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.841139]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.841141]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.841144]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.841146]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.841150]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.841153]  [<ffffffff8111f168>] ? __hrtimer_start_range_ns+0x448/0x490
[ 6331.841156]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.841158]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.841161]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.841163]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.841166]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.841169]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.841172]  [<ffffffff81274d61>] sys_setxattr+0x41/0xb0
[ 6331.841174]  [<ffffffff81985f3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6331.841177]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.906964] hardirqs last  enabled at (1166831): [<ffffffff83728ef5>] __mutex_unlock_slowpath+0x1a5/0x200
[ 6331.906964] hardirqs last disabled at (1166832): [<ffffffff8372bce4>] _raw_spin_lock_irqsave+0x54/0xc0
[ 6331.906964] softirqs last  enabled at (1166798): [<ffffffff8319b5c4>] unlist_netdevice+0xb4/0xe0
[ 6331.906964] softirqs last disabled at (1166796): [<ffffffff8372bf43>] _raw_write_lock_bh+0x13/0x80
[ 6331.954033] BUG: spinlock lockup suspected on CPU#2, swapper/2/0
[ 6331.954033]  lock: 0xffff88000d9d6340, .magic: dead4ead, .owner: rcub/5/12, .owner_cpu: 0
[ 6331.954033] Pid: 0, comm: swapper/2 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488
[ 6331.954033] Call Trace:
[ 6331.954033]  <IRQ>  [<ffffffff8199ba38>] spin_dump+0x78/0xc0
[ 6331.954033]  [<ffffffff8199bc9e>] do_raw_spin_lock+0xfe/0x140
[ 6331.954033]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.954033]  [<ffffffff8113a150>] ? load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113a150>] load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113ab2e>] ? rebalance_domains+0x17e/0x290
[ 6331.954033]  [<ffffffff81137f20>] ? find_busiest_group+0x2a0/0x2a0
[ 6331.954033]  [<ffffffff8113ab6d>] rebalance_domains+0x1bd/0x290
[ 6331.954033]  [<ffffffff8113a9b0>] ? update_shares+0x240/0x240
[ 6331.954033]  [<ffffffff810705bd>] ? sched_clock+0x1d/0x30
[ 6331.954033]  [<ffffffff8113ae53>] run_rebalance_domains+0x43/0x60
[ 6331.954033]  [<ffffffff810f5a81>] __do_softirq+0x221/0x460
[ 6331.954033]  [<ffffffff8109d616>] ? kvm_clock_read+0x46/0x80
[ 6331.954033]  [<ffffffff8372eb6c>] call_softirq+0x1c/0x30
[ 6331.954033]  [<ffffffff8106a215>] do_softirq+0x75/0x120
[ 6331.954033]  [<ffffffff810f4a8b>] irq_exit+0x5b/0xf0
[ 6331.954033]  [<ffffffff81090f5a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 6331.954033]  [<ffffffff8372e16f>] apic_timer_interrupt+0x6f/0x80
[ 6331.954033]  <EOI>  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[ 6331.954033]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[ 6331.954033]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.954033]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[ 6331.954033]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[ 6331.954033]  [<ffffffff8371fed7>] ? setup_APIC_timer+0x88/0x8d
[ 6331.954033]  [<ffffffff8371f512>] start_secondary+0xd7/0xde
[ 6331.954033] sending NMI to all CPUs:
[ 6331.954033] NMI backtrace for cpu 2
[ 6331.954033] CPU 2 
[ 6331.954033] Pid: 0, comm: swapper/2 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.954033] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[ 6331.954033] RSP: 0018:ffff880029803bf0  EFLAGS: 00000086
[ 6331.954033] RAX: 0000000000000400 RBX: 0000000000000002 RCX: 0000000000000830
[ 6331.954033] RDX: 0000000000000002 RSI: 0000000000000400 RDI: 0000000000000830
[ 6331.954033] RBP: ffff880029803bf0 R08: ffffffff84ee09c0 R09: 0000000000000000
[ 6331.954033] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[ 6331.954033] R13: ffffffff84ee09c0 R14: 0000000000000002 R15: 000000000000b024
[ 6331.954033] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 6331.954033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6331.954033] CR2: 0000000000000004 CR3: 000000001527e000 CR4: 00000000000406e0
[ 6331.954033] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.954033] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.954033] Process swapper/2 (pid: 0, threadinfo ffff88000d5ca000, task ffff88000d5c3000)
[ 6331.954033] Stack:
[ 6331.954033]  ffff880029803c60 ffffffff8109602d 0000000000000000 ffff880029803d60
[ 6331.954033]  ffff880029803c70 0000000000000086 0000000000000002 0000000200080000
[ 6331.954033]  ffff880029803c40 0000000000000000 000000009486a4e0 000000009486a4e0
[ 6331.954033] Call Trace:
[ 6331.954033]  <IRQ> 
[ 6331.954033]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 6331.954033]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[ 6331.954033]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 6331.954033]  [<ffffffff8199bca3>] do_raw_spin_lock+0x103/0x140
[ 6331.954033]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.954033]  [<ffffffff8113a150>] ? load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113a150>] load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113ab2e>] ? rebalance_domains+0x17e/0x290
[ 6331.954033]  [<ffffffff81137f20>] ? find_busiest_group+0x2a0/0x2a0
[ 6331.954033]  [<ffffffff8113ab6d>] rebalance_domains+0x1bd/0x290
[ 6331.954033]  [<ffffffff8113a9b0>] ? update_shares+0x240/0x240
[ 6331.954033]  [<ffffffff810705bd>] ? sched_clock+0x1d/0x30
[ 6331.954033]  [<ffffffff8113ae53>] run_rebalance_domains+0x43/0x60
[ 6331.954033]  [<ffffffff810f5a81>] __do_softirq+0x221/0x460
[ 6331.954033]  [<ffffffff8109d616>] ? kvm_clock_read+0x46/0x80
[ 6331.954033]  [<ffffffff8372eb6c>] call_softirq+0x1c/0x30
[ 6331.954033]  [<ffffffff8106a215>] do_softirq+0x75/0x120
[ 6331.954033]  [<ffffffff810f4a8b>] irq_exit+0x5b/0xf0
[ 6331.954033]  [<ffffffff81090f5a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 6331.954033]  [<ffffffff8372e16f>] apic_timer_interrupt+0x6f/0x80
[ 6331.954033]  <EOI> 
[ 6331.954033]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[ 6331.954033]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[ 6331.954033]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.954033]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[ 6331.954033]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[ 6331.954033]  [<ffffffff8371fed7>] ? setup_APIC_timer+0x88/0x8d
[ 6331.954033]  [<ffffffff8371f512>] start_secondary+0xd7/0xde
[ 6331.954033] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 6331.906944] NMI backtrace for cpu 0
[ 6331.906944] CPU 0 
[ 6331.906944] Pid: 12, comm: rcub/5 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.906944] RIP: 0010:[<ffffffff8199d552>]  [<ffffffff8199d552>] debug_smp_processor_id+0x102/0x110
[ 6331.906944] RSP: 0018:ffff88000d5799f0  EFLAGS: 00000002
[ 6331.906944] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 6331.906944] RDX: 000000002acf2ace RSI: 0000000000000003 RDI: 0000000000000001
[ 6331.906944] RBP: ffff88000d579a10 R08: 0000000000000000 R09: 0000000000000001
[ 6331.906944] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000d579fd8
[ 6331.906944] R13: 0000000000000001 R14: 0000000000000001 R15: ffff880035bd6340
[ 6331.906944] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 6331.906944] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6331.906944] CR2: 0000000000000800 CR3: 000000001a3ec000 CR4: 00000000000406f0
[ 6331.906944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.906944] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.906944] Process rcub/5 (pid: 12, threadinfo ffff88000d578000, task ffff88000d573000)
[ 6331.906944] Stack:
[ 6331.906944]  ffff88000d579a70 ffff880035bd6340 000000008b304187 0000000000000001
[ 6331.906944]  ffff88000d579a50 ffffffff81984d23 ffff88000d579aa0 ffff880035bd6340
[ 6331.906944]  000000008b304187 000000009486a4e0 0000000000000001 ffff880035bd6340
[ 6331.906944] Call Trace:
[ 6331.906944]  [<ffffffff81984d23>] delay_tsc+0x23/0x140
[ 6331.906944]  [<ffffffff81984cca>] __delay+0xa/0x10
[ 6331.906944]  [<ffffffff8199bc7d>] do_raw_spin_lock+0xdd/0x140
[ 6331.906944]  [<ffffffff8372bb18>] _raw_spin_lock_nested+0x68/0x90
[ 6331.906944]  [<ffffffff8113f7a2>] ? pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8372bba7>] ? _raw_spin_lock+0x67/0x70
[ 6331.906944]  [<ffffffff8113f795>] ? pull_rt_task+0xd5/0x270
[ 6331.906944]  [<ffffffff8113f7a2>] pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8113f9e4>] pre_schedule_rt+0x14/0x20
[ 6331.906944]  [<ffffffff8372a429>] __schedule+0x259/0x880
[ 6331.906944]  [<ffffffff8372abb5>] schedule+0x55/0x60
[ 6331.906944]  [<ffffffff8372b2bf>] __rt_mutex_slowlock+0xaf/0x110
[ 6331.906944]  [<ffffffff8372b40f>] rt_mutex_slowlock+0xef/0x180
[ 6331.906944]  [<ffffffff8372b520>] rt_mutex_lock+0x30/0x40
[ 6331.906944]  [<ffffffff811a406a>] rcu_boost+0xca/0x110
[ 6331.906944]  [<ffffffff8372b101>] ? rt_mutex_slowunlock+0x31/0x130
[ 6331.906944]  [<ffffffff811ab972>] rcu_boost_kthread+0x222/0x390
[ 6331.906944]  [<ffffffff811ab750>] ? synchronize_rcu_expedited+0x220/0x220
[ 6331.906944]  [<ffffffff81119e92>] kthread+0xb2/0xc0
[ 6331.906944]  [<ffffffff8372ea74>] kernel_thread_helper+0x4/0x10
[ 6331.906944]  [<ffffffff8372ccf4>] ? retint_restore_args+0x13/0x13
[ 6331.906944]  [<ffffffff81119de0>] ? __init_kthread_worker+0x70/0x70
[ 6331.906944]  [<ffffffff8372ea70>] ? gs_change+0x13/0x13
[ 6331.906944] Code: d8 01 48 8b 75 08 48 c7 c7 d6 2b 36 84 e8 27 11 7d ff e8 4e ab d8 01 65 48 8b 04 25 88 d9 00 00 ff 88 44 e0 ff ff 0f 1f 00 89 d8 <4c> 8b 65 f0 48 8b 5d e8 4c 8b 6d f8 c9 c3 55 48 89 e5 48 83 ec 
[ 6331.955620] NMI backtrace for cpu 1
[ 6331.955620] CPU 1 
[ 6331.955620] Pid: 24853, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.955620] RIP: 0010:[<ffffffff81132ac2>]  [<ffffffff81132ac2>] try_to_wake_up+0x132/0x290
[ 6331.955620] RSP: 0018:ffff880012af9af8  EFLAGS: 00000002
[ 6331.955620] RAX: ffff88000d578000 RBX: ffff88000d573000 RCX: 0000000003530352
[ 6331.955620] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000086
[ 6331.955620] RBP: ffff880012af9b38 R08: 0000000000000000 R09: 0000000000000000
[ 6331.955620] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000d573838
[ 6331.955620] R13: 0000000000000000 R14: 0000000000000286 R15: 0000000000000000
[ 6331.955620] FS:  00007f9e2b631700(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 6331.955620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6331.955620] CR2: 0000000000000001 CR3: 0000000022870000 CR4: 00000000000406e0
[ 6331.955620] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.955620] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.955620] Process trinity-child19 (pid: 24853, threadinfo ffff880012af8000, task ffff880012b10000)
[ 6331.955620] Stack:
[ 6331.955620]  ffff880012af9b18 ffff880012b10838 ffff880012b10838 ffff88000d579d50
[ 6331.955620]  ffff880012b10838 ffff880012b10000 ffff88000d579c70 0000000000000286
[ 6331.955620]  ffff880012af9b48 ffffffff81132c50 ffff880012af9b88 ffffffff8372b1b9
[ 6331.955620] Call Trace:
[ 6331.955620]  [<ffffffff81132c50>] wake_up_process+0x10/0x20
[ 6331.955620]  [<ffffffff8372b1b9>] rt_mutex_slowunlock+0xe9/0x130
[ 6331.955620]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.955620]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.955620]  [<ffffffff812c6870>] ? proc_sys_compare+0xe0/0x130
[ 6331.955620]  [<ffffffff81115b67>] __rcu_read_unlock+0x57/0xb0
[ 6331.955620]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.955620]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.955620]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.955620]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.955620]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.955620]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.955620]  [<ffffffff810f342b>] ? do_setitimer+0x23b/0x290
[ 6331.955620]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.955620]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.955620]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.955620]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.955620]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.955620]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.955620]  [<ffffffff8372d5e5>] ? sysret_check+0x22/0x5d
[ 6331.955620]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.955620]  [<ffffffff81273d30>] sys_removexattr+0x30/0x80
[ 6331.955620]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.955620] Code: da ff ff 48 8b 45 c8 48 89 c7 e8 ca 9a 5f 02 e9 31 01 00 00 0f 1f 44 00 00 48 89 c7 e8 b8 9a 5f 02 eb 08 66 0f 1f 44 00 00 f3 90 <8b> 73 28 85 f6 75 f7 31 c0 48 8b 13 83 e2 02 74 0a 0f b7 43 16 
[ 6331.847432] NMI backtrace for cpu 3
[ 6331.847432] CPU 3 
[ 6331.847432] Pid: 25254, comm: trinity-child45 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.847432] RIP: 0010:[<ffffffff81984d29>]  [<ffffffff81984d29>] delay_tsc+0x29/0x140
[ 6331.847432] RSP: 0018:ffff88000bd938a8  EFLAGS: 00000006
[ 6331.847432] RAX: 0000000000000003 RBX: ffff880035bd6340 RCX: 0000000000000000
[ 6331.847432] RDX: 000000002acf2ace RSI: 0000000010000004 RDI: 0000000000000001
[ 6331.847432] RBP: ffff88000bd938d8 R08: 0000000000000000 R09: 0000000000000000
[ 6331.847432] R10: 0000000000000000 R11: 000000000000ab08 R12: 000000008aa97388
[ 6331.847432] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000086
[ 6331.847432] FS:  00007f9e2b631700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 6331.847432] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6331.847432] CR2: 0000000000000008 CR3: 0000000013c12000 CR4: 00000000000406e0
[ 6331.847432] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.847432] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.847432] Process trinity-child45 (pid: 25254, threadinfo ffff88000bd92000, task ffff88000aea0000)
[ 6331.847432] Stack:
[ 6331.847432]  ffff88000bd938c8 ffff880035bd6340 000000008aa97388 000000009486a4e0
[ 6331.847432]  0000000000000001 0000000000000086 ffff88000bd938e8 ffffffff81984cca
[ 6331.847432]  ffff88000bd93928 ffffffff8199bc7d ffff88000bd93928 0000000000000086
[ 6331.847432] Call Trace:
[ 6331.847432]  [<ffffffff81984cca>] __delay+0xa/0x10
[ 6331.847432]  [<ffffffff8199bc7d>] do_raw_spin_lock+0xdd/0x140
[ 6331.847432]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.847432]  [<ffffffff81130291>] ? rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff81130291>] rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff8116a0a0>] __rt_mutex_adjust_prio+0x20/0x30
[ 6331.847432]  [<ffffffff8372b1d4>] rt_mutex_slowunlock+0x104/0x130
[ 6331.847432]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.847432]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.847432]  [<ffffffff8113fe58>] ? update_curr_rt+0x228/0x270
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff811a8fea>] rcu_preempt_note_context_switch+0x22a/0x300
[ 6331.847432]  [<ffffffff8372a93a>] __schedule+0x76a/0x880
[ 6331.847432]  [<ffffffff8372ab41>] preempt_schedule+0x51/0x70
[ 6331.847432]  [<ffffffff81071640>] ? read_persistent_clock+0x30/0x30
[ 6331.847432]  [<ffffffff81984e23>] delay_tsc+0x123/0x140
[ 6331.847432]  [<ffffffff81984cf8>] __const_udelay+0x28/0x30
[ 6331.847432]  [<ffffffff81115b54>] __rcu_read_unlock+0x44/0xb0
[ 6331.847432]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.847432]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.847432]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.847432]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.847432]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.847432]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.847432]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.847432]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.847432]  [<ffffffff8111f168>] ? __hrtimer_start_range_ns+0x448/0x490
[ 6331.847432]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.847432]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.847432]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.847432]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.847432]  [<ffffffff81274d61>] sys_setxattr+0x41/0xb0
[ 6331.847432]  [<ffffffff81985f3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6331.847432]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.847432] Code: 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 52 49 7a ff e8 2d 87 01 00 0f 1f 00 0f ae e8 <48> 83 3d 07 15 ec 02 00 75 07 0f 0b 0f 1f 00 eb fe 41 89 c6 e8 
[ 6331.906944] BUG: spinlock lockup suspected on CPU#0, rcub/5/12
[ 6331.906944]  lock: 0xffff880035bd6340, .magic: dead4ead, .owner: trinity-child45/25254, .owner_cpu: 3
[ 6331.906944] Pid: 12, comm: rcub/5 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488
[ 6331.906944] Call Trace:
[ 6331.906944]  [<ffffffff8199ba38>] spin_dump+0x78/0xc0
[ 6331.906944]  [<ffffffff8199bc9e>] do_raw_spin_lock+0xfe/0x140
[ 6331.906944]  [<ffffffff8372bb18>] _raw_spin_lock_nested+0x68/0x90
[ 6331.906944]  [<ffffffff8113f7a2>] ? pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8372bba7>] ? _raw_spin_lock+0x67/0x70
[ 6331.906944]  [<ffffffff8113f795>] ? pull_rt_task+0xd5/0x270
[ 6331.906944]  [<ffffffff8113f7a2>] pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8113f9e4>] pre_schedule_rt+0x14/0x20
[ 6331.906944]  [<ffffffff8372a429>] __schedule+0x259/0x880
[ 6331.906944]  [<ffffffff8372abb5>] schedule+0x55/0x60
[ 6331.906944]  [<ffffffff8372b2bf>] __rt_mutex_slowlock+0xaf/0x110
[ 6331.906944]  [<ffffffff8372b40f>] rt_mutex_slowlock+0xef/0x180
[ 6331.906944]  [<ffffffff8372b520>] rt_mutex_lock+0x30/0x40
[ 6331.906944]  [<ffffffff811a406a>] rcu_boost+0xca/0x110
[ 6331.906944]  [<ffffffff8372b101>] ? rt_mutex_slowunlock+0x31/0x130
[ 6331.906944]  [<ffffffff811ab972>] rcu_boost_kthread+0x222/0x390
[ 6331.906944]  [<ffffffff811ab750>] ? synchronize_rcu_expedited+0x220/0x220
[ 6331.906944]  [<ffffffff81119e92>] kthread+0xb2/0xc0
[ 6331.906944]  [<ffffffff8372ea74>] kernel_thread_helper+0x4/0x10
[ 6331.906944]  [<ffffffff8372ccf4>] ? retint_restore_args+0x13/0x13
[ 6331.906944]  [<ffffffff81119de0>] ? __init_kthread_worker+0x70/0x70
[ 6331.906944]  [<ffffffff8372ea70>] ? gs_change+0x13/0x13
[ 6331.906944] sending NMI to all CPUs:
[ 6331.906944] NMI backtrace for cpu 0
[ 6331.906944] CPU 0 
[ 6331.906944] Pid: 12, comm: rcub/5 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.906944] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[ 6331.906944] RSP: 0018:ffff88000d5799c0  EFLAGS: 00000086
[ 6331.906944] RAX: 0000000000000400 RBX: 0000000000000000 RCX: 0000000000000830
[ 6331.906944] RDX: 0000000000000000 RSI: 0000000000000400 RDI: 0000000000000830
[ 6331.906944] RBP: ffff88000d5799c0 R08: ffffffff84ee09c0 R09: 0000000000000000
[ 6331.906944] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 6331.906944] R13: ffffffff84ee09c0 R14: 0000000000000000 R15: 000000000000b024
[ 6331.906944] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 6331.906944] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6331.906944] CR2: 0000000000000800 CR3: 000000001a3ec000 CR4: 00000000000406f0
[ 6331.906944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.906944] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.906944] Process rcub/5 (pid: 12, threadinfo ffff88000d578000, task ffff88000d573000)
[ 6331.906944] Stack:
[ 6331.906944]  ffff88000d579a30 ffffffff8109602d 0000000000000000 ffff880035bd6340
[ 6331.906944]  ffff88000d579a40 0000000000000086 0000000000000002 0000000200080000
[ 6331.906944]  ffff88000d579a10 0000000000000000 000000009486a4e0 000000009486a4e0
[ 6331.906944] Call Trace:
[ 6331.906944]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 6331.906944]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[ 6331.906944]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 6331.906944]  [<ffffffff8199bca3>] do_raw_spin_lock+0x103/0x140
[ 6331.906944]  [<ffffffff8372bb18>] _raw_spin_lock_nested+0x68/0x90
[ 6331.906944]  [<ffffffff8113f7a2>] ? pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8372bba7>] ? _raw_spin_lock+0x67/0x70
[ 6331.906944]  [<ffffffff8113f795>] ? pull_rt_task+0xd5/0x270
[ 6331.906944]  [<ffffffff8113f7a2>] pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8113f9e4>] pre_schedule_rt+0x14/0x20
[ 6331.906944]  [<ffffffff8372a429>] __schedule+0x259/0x880
[ 6331.906944]  [<ffffffff8372abb5>] schedule+0x55/0x60
[ 6331.906944]  [<ffffffff8372b2bf>] __rt_mutex_slowlock+0xaf/0x110
[ 6331.906944]  [<ffffffff8372b40f>] rt_mutex_slowlock+0xef/0x180
[ 6331.906944]  [<ffffffff8372b520>] rt_mutex_lock+0x30/0x40
[ 6331.906944]  [<ffffffff811a406a>] rcu_boost+0xca/0x110
[ 6331.906944]  [<ffffffff8372b101>] ? rt_mutex_slowunlock+0x31/0x130
[ 6331.906944]  [<ffffffff811ab972>] rcu_boost_kthread+0x222/0x390
[ 6331.906944]  [<ffffffff811ab750>] ? synchronize_rcu_expedited+0x220/0x220
[ 6331.906944]  [<ffffffff81119e92>] kthread+0xb2/0xc0
[ 6331.906944]  [<ffffffff8372ea74>] kernel_thread_helper+0x4/0x10
[ 6331.906944]  [<ffffffff8372ccf4>] ? retint_restore_args+0x13/0x13
[ 6331.906944]  [<ffffffff81119de0>] ? __init_kthread_worker+0x70/0x70
[ 6331.906944]  [<ffffffff8372ea70>] ? gs_change+0x13/0x13
[ 6331.906944] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 6331.955620] NMI backtrace for cpu 1
[ 6331.955620] CPU 1 
[ 6331.955620] Pid: 24853, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.955620] RIP: 0010:[<ffffffff81132ac5>]  [<ffffffff81132ac5>] try_to_wake_up+0x135/0x290
[ 6331.955620] RSP: 0018:ffff880012af9af8  EFLAGS: 00000002
[ 6331.955620] RAX: ffff88000d578000 RBX: ffff88000d573000 RCX: 0000000003530352
[ 6331.955620] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000086
[ 6331.955620] RBP: ffff880012af9b38 R08: 0000000000000000 R09: 0000000000000000
[ 6331.955620] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000d573838
[ 6331.955620] R13: 0000000000000000 R14: 0000000000000286 R15: 0000000000000000
[ 6331.955620] FS:  00007f9e2b631700(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 6331.955620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6331.955620] CR2: 0000000000000001 CR3: 0000000022870000 CR4: 00000000000406e0
[ 6331.955620] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.955620] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.955620] Process trinity-child19 (pid: 24853, threadinfo ffff880012af8000, task ffff880012b10000)
[ 6331.955620] Stack:
[ 6331.955620]  ffff880012af9b18 ffff880012b10838 ffff880012b10838 ffff88000d579d50
[ 6331.955620]  ffff880012b10838 ffff880012b10000 ffff88000d579c70 0000000000000286
[ 6331.955620]  ffff880012af9b48 ffffffff81132c50 ffff880012af9b88 ffffffff8372b1b9
[ 6331.955620] Call Trace:
[ 6331.955620]  [<ffffffff81132c50>] wake_up_process+0x10/0x20
[ 6331.955620]  [<ffffffff8372b1b9>] rt_mutex_slowunlock+0xe9/0x130
[ 6331.955620]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.955620]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.955620]  [<ffffffff812c6870>] ? proc_sys_compare+0xe0/0x130
[ 6331.955620]  [<ffffffff81115b67>] __rcu_read_unlock+0x57/0xb0
[ 6331.955620]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.955620]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.955620]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.955620]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.955620]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.955620]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.955620]  [<ffffffff810f342b>] ? do_setitimer+0x23b/0x290
[ 6331.955620]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.955620]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.955620]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.955620]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.955620]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.955620]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.955620]  [<ffffffff8372d5e5>] ? sysret_check+0x22/0x5d
[ 6331.955620]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.955620]  [<ffffffff81273d30>] sys_removexattr+0x30/0x80
[ 6331.955620]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.955620] Code: 48 8b 45 c8 48 89 c7 e8 ca 9a 5f 02 e9 31 01 00 00 0f 1f 44 00 00 48 89 c7 e8 b8 9a 5f 02 eb 08 66 0f 1f 44 00 00 f3 90 8b 73 28 <85> f6 75 f7 31 c0 48 8b 13 83 e2 02 74 0a 0f b7 43 16 83 f0 01 
[ 6331.954033] NMI backtrace for cpu 2
[ 6331.954033] CPU 2 
[ 6331.954033] Pid: 0, comm: swapper/2 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.954033] RIP: 0010:[<ffffffff81071646>]  [<ffffffff81071646>] native_read_tsc+0x6/0x20
[ 6331.954033] RSP: 0018:ffff880029803c40  EFLAGS: 00000082
[ 6331.954033] RAX: 00000000ad32893d RBX: 00000000ad328911 RCX: 00000000ad328911
[ 6331.954033] RDX: 0000000000000eb4 RSI: 0000000000000104 RDI: 0000000000000001
[ 6331.954033] RBP: ffff880029803c40 R08: 0000000000000000 R09: 0000000000000000
[ 6331.954033] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000d5ca010
[ 6331.954033] R13: 0000000000000001 R14: 0000000000000002 R15: ffff880029803d60
[ 6331.954033] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 6331.954033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6331.954033] CR2: 0000000000000004 CR3: 000000001527e000 CR4: 00000000000406e0
[ 6331.954033] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.954033] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.954033] Process swapper/2 (pid: 0, threadinfo ffff88000d5ca000, task ffff88000d5c3000)
[ 6331.954033] Stack:
[ 6331.954033]  ffff880029803c80 ffffffff81984d85 0000000000000000 ffff88000d9d6340
[ 6331.954033]  0000000009a52e9c 000000009486a4e0 0000000000000000 ffff880029803d60
[ 6331.954033]  ffff880029803c90 ffffffff81984cca ffff880029803cd0 ffffffff8199bc7d
[ 6331.954033] Call Trace:
[ 6331.954033]  <IRQ> 
[ 6331.954033]  [<ffffffff81984d85>] delay_tsc+0x85/0x140
[ 6331.954033]  [<ffffffff81984cca>] __delay+0xa/0x10
[ 6331.954033]  [<ffffffff8199bc7d>] do_raw_spin_lock+0xdd/0x140
[ 6331.954033]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.954033]  [<ffffffff8113a150>] ? load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113a150>] load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113ab2e>] ? rebalance_domains+0x17e/0x290
[ 6331.954033]  [<ffffffff81137f20>] ? find_busiest_group+0x2a0/0x2a0
[ 6331.954033]  [<ffffffff8113ab6d>] rebalance_domains+0x1bd/0x290
[ 6331.954033]  [<ffffffff8113a9b0>] ? update_shares+0x240/0x240
[ 6331.954033]  [<ffffffff810705bd>] ? sched_clock+0x1d/0x30
[ 6331.954033]  [<ffffffff8113ae53>] run_rebalance_domains+0x43/0x60
[ 6331.954033]  [<ffffffff810f5a81>] __do_softirq+0x221/0x460
[ 6331.954033]  [<ffffffff8109d616>] ? kvm_clock_read+0x46/0x80
[ 6331.954033]  [<ffffffff8372eb6c>] call_softirq+0x1c/0x30
[ 6331.954033]  [<ffffffff8106a215>] do_softirq+0x75/0x120
[ 6331.954033]  [<ffffffff810f4a8b>] irq_exit+0x5b/0xf0
[ 6331.954033]  [<ffffffff81090f5a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 6331.954033]  [<ffffffff8372e16f>] apic_timer_interrupt+0x6f/0x80
[ 6331.954033]  <EOI> 
[ 6331.954033]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[ 6331.954033]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[ 6331.954033]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.954033]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[ 6331.954033]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[ 6331.954033]  [<ffffffff8371fed7>] ? setup_APIC_timer+0x88/0x8d
[ 6331.954033]  [<ffffffff8371f512>] start_secondary+0xd7/0xde
[ 6331.954033] Code: 08 ff 15 e6 ae 7c 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 <89> c1 c9 48 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 
[ 6331.847432] NMI backtrace for cpu 3
[ 6331.847432] CPU 3 
[ 6331.847432] Pid: 25254, comm: trinity-child45 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.847432] RIP: 0010:[<ffffffff8112960b>]  [<ffffffff8112960b>] sub_preempt_count+0x4b/0xb0
[ 6331.847432] RSP: 0018:ffff88000bd93898  EFLAGS: 00000006
[ 6331.847432] RAX: ffff88000bd93fd8 RBX: 00000000ad329a05 RCX: 00000000ad329a2e
[ 6331.847432] RDX: 0000000000000000 RSI: 0000000010000004 RDI: 0000000000000001
[ 6331.847432] RBP: ffff88000bd93898 R08: 0000000000000000 R09: 0000000000000000
[ 6331.847432] R10: 0000000000000000 R11: 000000000000ab08 R12: ffff88000bd92010
[ 6331.847432] R13: 0000000000000001 R14: 0000000000000003 R15: 00000000ad329a2e
[ 6331.847432] FS:  00007f9e2b631700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 6331.847432] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6331.847432] CR2: 0000000000000008 CR3: 0000000013c12000 CR4: 00000000000406e0
[ 6331.847432] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.847432] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.847432] Process trinity-child45 (pid: 25254, threadinfo ffff88000bd92000, task ffff88000aea0000)
[ 6331.847432] Stack:
[ 6331.847432]  ffff88000bd938d8 ffffffff81984e0a ffff88000bd938c8 ffff880035bd6340
[ 6331.847432]  0000000093c44cd0 000000009486a4e0 0000000000000001 0000000000000086
[ 6331.847432]  ffff88000bd938e8 ffffffff81984cca ffff88000bd93928 ffffffff8199bc7d
[ 6331.847432] Call Trace:
[ 6331.847432]  [<ffffffff81984e0a>] delay_tsc+0x10a/0x140
[ 6331.847432]  [<ffffffff81984cca>] __delay+0xa/0x10
[ 6331.847432]  [<ffffffff8199bc7d>] do_raw_spin_lock+0xdd/0x140
[ 6331.847432]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.847432]  [<ffffffff81130291>] ? rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff81130291>] rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff8116a0a0>] __rt_mutex_adjust_prio+0x20/0x30
[ 6331.847432]  [<ffffffff8372b1d4>] rt_mutex_slowunlock+0x104/0x130
[ 6331.847432]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.847432]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.847432]  [<ffffffff8113fe58>] ? update_curr_rt+0x228/0x270
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff811a8fea>] rcu_preempt_note_context_switch+0x22a/0x300
[ 6331.847432]  [<ffffffff8372a93a>] __schedule+0x76a/0x880
[ 6331.847432]  [<ffffffff8372ab41>] preempt_schedule+0x51/0x70
[ 6331.847432]  [<ffffffff81071640>] ? read_persistent_clock+0x30/0x30
[ 6331.847432]  [<ffffffff81984e23>] delay_tsc+0x123/0x140
[ 6331.847432]  [<ffffffff81984cf8>] __const_udelay+0x28/0x30
[ 6331.847432]  [<ffffffff81115b54>] __rcu_read_unlock+0x44/0xb0
[ 6331.847432]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.847432]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.847432]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.847432]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.847432]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.847432]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.847432]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.847432]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.847432]  [<ffffffff8111f168>] ? __hrtimer_start_range_ns+0x448/0x490
[ 6331.847432]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.847432]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.847432]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.847432]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.847432]  [<ffffffff81274d61>] sys_setxattr+0x41/0xb0
[ 6331.847432]  [<ffffffff81985f3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6331.847432]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.847432] Code: 4c d8 85 00 85 c0 74 78 83 3d 11 85 ce 04 00 75 6f be 48 0c 00 00 48 c7 c7 e1 a2 27 84 e8 8e 1a fc ff eb 5c 80 b8 44 e0 ff ff 00 <75> 2b 0f 1f 00 e8 1b d8 85 00 85 c0 74 47 83 3d e0 84 ce 04 00 
[ 6331.847432] BUG: spinlock lockup suspected on CPU#3, trinity-child45/25254
[ 6331.847432]  lock: 0xffff880035bd6340, .magic: dead4ead, .owner: trinity-child45/25254, .owner_cpu: 3
[ 6331.847432] Pid: 25254, comm: trinity-child45 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488
[ 6331.847432] Call Trace:
[ 6331.847432]  [<ffffffff8199ba38>] spin_dump+0x78/0xc0
[ 6331.847432]  [<ffffffff8199bc9e>] do_raw_spin_lock+0xfe/0x140
[ 6331.847432]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.847432]  [<ffffffff81130291>] ? rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff81130291>] rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff8116a0a0>] __rt_mutex_adjust_prio+0x20/0x30
[ 6331.847432]  [<ffffffff8372b1d4>] rt_mutex_slowunlock+0x104/0x130
[ 6331.847432]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.847432]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.847432]  [<ffffffff8113fe58>] ? update_curr_rt+0x228/0x270
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff811a8fea>] rcu_preempt_note_context_switch+0x22a/0x300
[ 6331.847432]  [<ffffffff8372a93a>] __schedule+0x76a/0x880
[ 6331.847432]  [<ffffffff8372ab41>] preempt_schedule+0x51/0x70
[ 6331.847432]  [<ffffffff81071640>] ? read_persistent_clock+0x30/0x30
[ 6331.847432]  [<ffffffff81984e23>] delay_tsc+0x123/0x140
[ 6331.847432]  [<ffffffff81984cf8>] __const_udelay+0x28/0x30
[ 6331.847432]  [<ffffffff81115b54>] __rcu_read_unlock+0x44/0xb0
[ 6331.847432]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.847432]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.847432]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.847432]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.847432]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.847432]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.847432]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.847432]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.847432]  [<ffffffff8111f168>] ? __hrtimer_start_range_ns+0x448/0x490
[ 6331.847432]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.847432]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.847432]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.847432]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.847432]  [<ffffffff81274d61>] sys_setxattr+0x41/0xb0
[ 6331.847432]  [<ffffffff81985f3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6331.847432]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.847432] sending NMI to all CPUs:
[ 6331.906944] NMI backtrace for cpu 0
[ 6331.906944] CPU 0 
[ 6331.906944] Pid: 12, comm: rcub/5 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.906944] RIP: 0010:[<ffffffff81984d29>]  [<ffffffff81984d29>] delay_tsc+0x29/0x140
[ 6331.906944] RSP: 0018:ffff88000d579a20  EFLAGS: 00000002
[ 6331.906944] RAX: 0000000000000000 RBX: ffff880035bd6340 RCX: 0000000000000000
[ 6331.906944] RDX: 000000002acf2ace RSI: 0000000000000003 RDI: 0000000000000001
[ 6331.906944] RBP: ffff88000d579a50 R08: 0000000000000000 R09: 0000000000000000
[ 6331.906944] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000d775c3
[ 6331.906944] R13: 0000000000000001 R14: 0000000000000000 R15: ffff880035bd6340
[ 6331.906944] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 6331.906944] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6331.906944] CR2: 0000000000000800 CR3: 000000001a3ec000 CR4: 00000000000406f0
[ 6331.906944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.906944] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.906944] Process rcub/5 (pid: 12, threadinfo ffff88000d578000, task ffff88000d573000)
[ 6331.906944] Stack:
[ 6331.906944]  0000000000000000 ffff880035bd6340 0000000000d775c3 000000009486a4e0
[ 6331.906944]  0000000000000000 ffff880035bd6340 ffff88000d579a60 ffffffff81984cca
[ 6331.906944]  ffff88000d579aa0 ffffffff8199bc7d ffff88000d579aa0 0000000000000086
[ 6331.906944] Call Trace:
[ 6331.906944]  [<ffffffff81984cca>] __delay+0xa/0x10
[ 6331.906944]  [<ffffffff8199bc7d>] do_raw_spin_lock+0xdd/0x140
[ 6331.906944]  [<ffffffff8372bb18>] _raw_spin_lock_nested+0x68/0x90
[ 6331.906944]  [<ffffffff8113f7a2>] ? pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8372bba7>] ? _raw_spin_lock+0x67/0x70
[ 6331.906944]  [<ffffffff8113f795>] ? pull_rt_task+0xd5/0x270
[ 6331.906944]  [<ffffffff8113f7a2>] pull_rt_task+0xe2/0x270
[ 6331.906944]  [<ffffffff8113f9e4>] pre_schedule_rt+0x14/0x20
[ 6331.906944]  [<ffffffff8372a429>] __schedule+0x259/0x880
[ 6331.906944]  [<ffffffff8372abb5>] schedule+0x55/0x60
[ 6331.906944]  [<ffffffff8372b2bf>] __rt_mutex_slowlock+0xaf/0x110
[ 6331.906944]  [<ffffffff8372b40f>] rt_mutex_slowlock+0xef/0x180
[ 6331.906944]  [<ffffffff8372b520>] rt_mutex_lock+0x30/0x40
[ 6331.906944]  [<ffffffff811a406a>] rcu_boost+0xca/0x110
[ 6331.906944]  [<ffffffff8372b101>] ? rt_mutex_slowunlock+0x31/0x130
[ 6331.906944]  [<ffffffff811ab972>] rcu_boost_kthread+0x222/0x390
[ 6331.906944]  [<ffffffff811ab750>] ? synchronize_rcu_expedited+0x220/0x220
[ 6331.906944]  [<ffffffff81119e92>] kthread+0xb2/0xc0
[ 6331.906944]  [<ffffffff8372ea74>] kernel_thread_helper+0x4/0x10
[ 6331.906944]  [<ffffffff8372ccf4>] ? retint_restore_args+0x13/0x13
[ 6331.906944]  [<ffffffff81119de0>] ? __init_kthread_worker+0x70/0x70
[ 6331.906944]  [<ffffffff8372ea70>] ? gs_change+0x13/0x13
[ 6331.906944] Code: 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 52 49 7a ff e8 2d 87 01 00 0f 1f 00 0f ae e8 <48> 83 3d 07 15 ec 02 00 75 07 0f 0b 0f 1f 00 eb fe 41 89 c6 e8 
[ 6331.847432] NMI backtrace for cpu 3
[ 6331.847432] CPU 3 
[ 6331.847432] Pid: 25254, comm: trinity-child45 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.847432] RIP: 0010:[<ffffffff8109d6aa>]  [<ffffffff8109d6aa>] native_write_msr_safe+0xa/0x10
[ 6331.847432] RSP: 0018:ffff88000bd93848  EFLAGS: 00000086
[ 6331.847432] RAX: 0000000000000400 RBX: 0000000000000003 RCX: 0000000000000830
[ 6331.847432] RDX: 0000000000000003 RSI: 0000000000000400 RDI: 0000000000000830
[ 6331.847432] RBP: ffff88000bd93848 R08: ffffffff84ee09c0 R09: 0000000000000000
[ 6331.847432] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
[ 6331.847432] R13: ffffffff84ee09c0 R14: 0000000000000003 R15: 000000000000b024
[ 6331.847432] FS:  00007f9e2b631700(0000) GS:ffff880035a00000(0000) knlGS:0000000000000000
[ 6331.847432] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6331.847432] CR2: 0000000000000008 CR3: 0000000013c12000 CR4: 00000000000406e0
[ 6331.847432] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.847432] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.847432] Process trinity-child45 (pid: 25254, threadinfo ffff88000bd92000, task ffff88000aea0000)
[ 6331.847432] Stack:
[ 6331.847432]  ffff88000bd938b8 ffffffff8109602d 0000000000000000 0000000000000086
[ 6331.847432]  ffff88000bd938c8 0000000000000086 0000000000000002 0000000200080000
[ 6331.847432]  ffff88000bd93898 0000000000000000 000000009486a4e0 000000009486a4e0
[ 6331.847432] Call Trace:
[ 6331.847432]  [<ffffffff8109602d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 6331.847432]  [<ffffffff81096117>] x2apic_send_IPI_all+0x17/0x20
[ 6331.847432]  [<ffffffff810917b4>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 6331.847432]  [<ffffffff8199bca3>] do_raw_spin_lock+0x103/0x140
[ 6331.847432]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.847432]  [<ffffffff81130291>] ? rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff81130291>] rt_mutex_setprio+0x81/0x2c0
[ 6331.847432]  [<ffffffff8116a0a0>] __rt_mutex_adjust_prio+0x20/0x30
[ 6331.847432]  [<ffffffff8372b1d4>] rt_mutex_slowunlock+0x104/0x130
[ 6331.847432]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.847432]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.847432]  [<ffffffff8113fe58>] ? update_curr_rt+0x228/0x270
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff811a8fea>] rcu_preempt_note_context_switch+0x22a/0x300
[ 6331.847432]  [<ffffffff8372a93a>] __schedule+0x76a/0x880
[ 6331.847432]  [<ffffffff8372ab41>] preempt_schedule+0x51/0x70
[ 6331.847432]  [<ffffffff81071640>] ? read_persistent_clock+0x30/0x30
[ 6331.847432]  [<ffffffff81984e23>] delay_tsc+0x123/0x140
[ 6331.847432]  [<ffffffff81984cf8>] __const_udelay+0x28/0x30
[ 6331.847432]  [<ffffffff81115b54>] __rcu_read_unlock+0x44/0xb0
[ 6331.847432]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.847432]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.847432]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.847432]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.847432]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.847432]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.847432]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.847432]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.847432]  [<ffffffff8111f168>] ? __hrtimer_start_range_ns+0x448/0x490
[ 6331.847432]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.847432]  [<ffffffff8115d35a>] ? get_lock_stats+0x2a/0x60
[ 6331.847432]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.847432]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.847432]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.847432]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.847432]  [<ffffffff81274d61>] sys_setxattr+0x41/0xb0
[ 6331.847432]  [<ffffffff81985f3e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 6331.847432]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.847432] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89 
[ 6331.954033] NMI backtrace for cpu 2
[ 6331.954033] CPU 2 
[ 6331.954033] Pid: 0, comm: swapper/2 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.954033] RIP: 0010:[<ffffffff81129604>]  [<ffffffff81129604>] sub_preempt_count+0x44/0xb0
[ 6331.954033] RSP: 0018:ffff880029803c40  EFLAGS: 00000097
[ 6331.954033] RAX: ffff88000d5cbfd8 RBX: 000000006ce53fcd RCX: 000000006ce53feb
[ 6331.954033] RDX: 0000000000000000 RSI: 0000000000000104 RDI: 0000000000000001
[ 6331.954033] RBP: ffff880029803c40 R08: 0000000000000000 R09: 0000000000000000
[ 6331.954033] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000d5ca010
[ 6331.954033] R13: 0000000000000001 R14: 0000000000000002 R15: 000000006ce53feb
[ 6331.954033] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
[ 6331.954033] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6331.954033] CR2: 0000000000000004 CR3: 000000001527e000 CR4: 00000000000406e0
[ 6331.954033] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.954033] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.954033] Process swapper/2 (pid: 0, threadinfo ffff88000d5ca000, task ffff88000d5c3000)
[ 6331.954033] Stack:
[ 6331.954033]  ffff880029803c80 ffffffff81984e0a 0000000000000000 ffff88000d9d6340
[ 6331.954033]  000000000a9671ab 000000009486a4e0 0000000000000000 ffff880029803d60
[ 6331.954033]  ffff880029803c90 ffffffff81984cca ffff880029803cd0 ffffffff8199bc7d
[ 6331.954033] Call Trace:
[ 6331.954033]  <IRQ> 
[ 6331.954033]  [<ffffffff81984e0a>] delay_tsc+0x10a/0x140
[ 6331.954033]  [<ffffffff81984cca>] __delay+0xa/0x10
[ 6331.954033]  [<ffffffff8199bc7d>] do_raw_spin_lock+0xdd/0x140
[ 6331.954033]  [<ffffffff8372bb9b>] _raw_spin_lock+0x5b/0x70
[ 6331.954033]  [<ffffffff8113a150>] ? load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113a150>] load_balance+0x2b0/0x6e0
[ 6331.954033]  [<ffffffff8113ab2e>] ? rebalance_domains+0x17e/0x290
[ 6331.954033]  [<ffffffff81137f20>] ? find_busiest_group+0x2a0/0x2a0
[ 6331.954033]  [<ffffffff8113ab6d>] rebalance_domains+0x1bd/0x290
[ 6331.954033]  [<ffffffff8113a9b0>] ? update_shares+0x240/0x240
[ 6331.954033]  [<ffffffff810705bd>] ? sched_clock+0x1d/0x30
[ 6331.954033]  [<ffffffff8113ae53>] run_rebalance_domains+0x43/0x60
[ 6331.954033]  [<ffffffff810f5a81>] __do_softirq+0x221/0x460
[ 6331.954033]  [<ffffffff8109d616>] ? kvm_clock_read+0x46/0x80
[ 6331.954033]  [<ffffffff8372eb6c>] call_softirq+0x1c/0x30
[ 6331.954033]  [<ffffffff8106a215>] do_softirq+0x75/0x120
[ 6331.954033]  [<ffffffff810f4a8b>] irq_exit+0x5b/0xf0
[ 6331.954033]  [<ffffffff81090f5a>] smp_apic_timer_interrupt+0x8a/0xa0
[ 6331.954033]  [<ffffffff8372e16f>] apic_timer_interrupt+0x6f/0x80
[ 6331.954033]  <EOI> 
[ 6331.954033]  [<ffffffff81072eb8>] ? default_idle+0x1a8/0x390
[ 6331.954033]  [<ffffffff8109d7e6>] ? native_safe_halt+0x6/0x10
[ 6331.954033]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.954033]  [<ffffffff81072ed5>] default_idle+0x1c5/0x390
[ 6331.954033]  [<ffffffff8107244f>] cpu_idle+0x11f/0x180
[ 6331.954033]  [<ffffffff8371fed7>] ? setup_APIC_timer+0x88/0x8d
[ 6331.954033]  [<ffffffff8371f512>] start_secondary+0xd7/0xde
[ 6331.954033] Code: 44 e0 ff ff 7d 71 e8 4c d8 85 00 85 c0 74 78 83 3d 11 85 ce 04 00 75 6f be 48 0c 00 00 48 c7 c7 e1 a2 27 84 e8 8e 1a fc ff eb 5c <80> b8 44 e0 ff ff 00 75 2b 0f 1f 00 e8 1b d8 85 00 85 c0 74 47 
[ 6331.955620] NMI backtrace for cpu 1
[ 6331.955620] CPU 1 
[ 6331.955620] Pid: 24853, comm: trinity-child19 Tainted: G        W    3.5.0-rc4-next-20120629-sasha-00007-g3fd449c #488  
[ 6331.955620] RIP: 0010:[<ffffffff81132ac5>]  [<ffffffff81132ac5>] try_to_wake_up+0x135/0x290
[ 6331.955620] RSP: 0018:ffff880012af9af8  EFLAGS: 00000002
[ 6331.955620] RAX: ffff88000d578000 RBX: ffff88000d573000 RCX: 0000000003530352
[ 6331.955620] RDX: 0000000000000002 RSI: 0000000000000001 RDI: 0000000000000086
[ 6331.955620] RBP: ffff880012af9b38 R08: 0000000000000000 R09: 0000000000000000
[ 6331.955620] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000d573838
[ 6331.955620] R13: 0000000000000000 R14: 0000000000000286 R15: 0000000000000000
[ 6331.955620] FS:  00007f9e2b631700(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 6331.955620] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6331.955620] CR2: 0000000000000001 CR3: 0000000022870000 CR4: 00000000000406e0
[ 6331.955620] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6331.955620] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6331.955620] Process trinity-child19 (pid: 24853, threadinfo ffff880012af8000, task ffff880012b10000)
[ 6331.955620] Stack:
[ 6331.955620]  ffff880012af9b18 ffff880012b10838 ffff880012b10838 ffff88000d579d50
[ 6331.955620]  ffff880012b10838 ffff880012b10000 ffff88000d579c70 0000000000000286
[ 6331.955620]  ffff880012af9b48 ffffffff81132c50 ffff880012af9b88 ffffffff8372b1b9
[ 6331.955620] Call Trace:
[ 6331.955620]  [<ffffffff81132c50>] wake_up_process+0x10/0x20
[ 6331.955620]  [<ffffffff8372b1b9>] rt_mutex_slowunlock+0xe9/0x130
[ 6331.955620]  [<ffffffff8372b209>] rt_mutex_unlock+0x9/0x10
[ 6331.955620]  [<ffffffff811a8d10>] rcu_read_unlock_special+0x350/0x400
[ 6331.955620]  [<ffffffff812c6870>] ? proc_sys_compare+0xe0/0x130
[ 6331.955620]  [<ffffffff81115b67>] __rcu_read_unlock+0x57/0xb0
[ 6331.955620]  [<ffffffff8126943d>] __d_lookup+0x2dd/0x2f0
[ 6331.955620]  [<ffffffff8199bb90>] ? do_raw_spin_unlock+0xd0/0xe0
[ 6331.955620]  [<ffffffff8125c8ae>] lookup_fast+0x1ae/0x2e0
[ 6331.955620]  [<ffffffff818c61fd>] ? security_inode_permission+0x1d/0x20
[ 6331.955620]  [<ffffffff8125d4e4>] link_path_walk+0x204/0x420
[ 6331.955620]  [<ffffffff8125a0a0>] ? generic_readlink+0xb0/0xb0
[ 6331.955620]  [<ffffffff810f342b>] ? do_setitimer+0x23b/0x290
[ 6331.955620]  [<ffffffff8125e024>] path_lookupat+0x54/0x700
[ 6331.955620]  [<ffffffff8123a134>] ? kmem_cache_alloc+0x154/0x240
[ 6331.955620]  [<ffffffff8125e6fc>] do_path_lookup+0x2c/0xc0
[ 6331.955620]  [<ffffffff8125f6bc>] user_path_at_empty+0x6c/0xb0
[ 6331.955620]  [<ffffffff8116227d>] ? trace_hardirqs_on+0xd/0x10
[ 6331.955620]  [<ffffffff8372c6e9>] ? _raw_spin_unlock_irq+0x59/0x80
[ 6331.955620]  [<ffffffff8372d5e5>] ? sysret_check+0x22/0x5d
[ 6331.955620]  [<ffffffff8125f70c>] user_path_at+0xc/0x10
[ 6331.955620]  [<ffffffff81273d30>] sys_removexattr+0x30/0x80
[ 6331.955620]  [<ffffffff8372d5b9>] system_call_fastpath+0x16/0x1b
[ 6331.955620] Code: 48 8b 45 c8 48 89 c7 e8 ca 9a 5f 02 e9 31 01 00 00 0f 1f 44 00 00 48 89 c7 e8 b8 9a 5f 02 eb 08 66 0f 1f 44 00 00 f3 90 8b 73 28 <85> f6 75 f7 31 c0 48 8b 13 83 e2 02 74 0a 0f b7 43 16 83 f0 01 

