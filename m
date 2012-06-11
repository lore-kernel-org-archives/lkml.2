Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2FKRRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:17:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44401 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2FKRRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:17:02 -0400
Message-ID: <1339435090.4999.76.camel@lappy>
Subject: blk/dm: Kernel crash on 3.5-rc2
From: Sasha Levin <levinsasha928@gmail.com>
To: neilb@suse.de, axboe <axboe@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Mon, 11 Jun 2012 19:18:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was fuzzing with trinity inside a KVM tools guest running on 3.5-rc2, when I hit the following:

[ 1848.195822] INFO: trying to register non-static key.
[ 1848.196040] the code is fine but needs lockdep annotation.
[ 1848.196040] turning off the locking correctness validator.
[ 1848.196040] Pid: 2901, comm: kworker/4:1 Tainted: G        W    3.5.0-rc2-sasha-00015-g7b268f7 #374
[ 1848.196040] Call Trace:
[ 1848.196040]  [<ffffffff81149da8>] register_lock_class+0x538/0x540
[ 1848.196040]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 1848.196040]  [<ffffffff8114e437>] __lock_acquire+0xf7/0x4b0
[ 1848.196040]  [<ffffffff8114e97a>] lock_acquire+0x18a/0x1e0
[ 1848.196040]  [<ffffffff8111533d>] ? __wake_up+0x2d/0x70
[ 1848.196040]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
[ 1848.196040]  [<ffffffff837c0c91>] _raw_spin_lock_irqsave+0x81/0xc0
[ 1848.196040]  [<ffffffff8111533d>] ? __wake_up+0x2d/0x70
[ 1848.196040]  [<ffffffff8111533d>] __wake_up+0x2d/0x70
[ 1848.196040]  [<ffffffff81932b06>] blk_drain_queue+0x116/0x160
[ 1848.196040]  [<ffffffff8193494c>] blk_cleanup_queue+0x17c/0x1b0
[ 1848.196040]  [<ffffffff82cba5b3>] md_free+0x53/0x70
[ 1848.196040]  [<ffffffff8195c725>] kobject_cleanup+0x145/0x190
[ 1848.196040]  [<ffffffff8195c77d>] kobject_release+0xd/0x10
[ 1848.196040]  [<ffffffff8195c50c>] kobject_put+0x4c/0x60
[ 1848.196040]  [<ffffffff82cba08f>] mddev_delayed_delete+0x2f/0x40
[ 1848.196040]  [<ffffffff810fca06>] process_one_work+0x366/0x5f0
[ 1848.196040]  [<ffffffff810fc8e0>] ? process_one_work+0x240/0x5f0
[ 1848.196040]  [<ffffffff82cba060>] ? bb_show+0x20/0x20
[ 1848.196040]  [<ffffffff810fe0a1>] worker_thread+0x211/0x3a0
[ 1848.196040]  [<ffffffff810fde90>] ? manage_workers+0x130/0x130
[ 1848.196040]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 1848.196040]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 1848.196040]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 1848.196040]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 1848.196040]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13

Which was followed by:

[ 1848.196040] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 1848.196040] IP: [<ffffffff8111234c>] __wake_up_common+0x2c/0x90
[ 1848.196040] PGD 0 
[ 1848.196040] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1848.196040] CPU 4 
[ 1848.196040] Pid: 2901, comm: kworker/4:1 Tainted: G        W    3.5.0-rc2-sasha-00015-g7b268f7 #374  
[ 1848.196040] RIP: 0010:[<ffffffff8111234c>]  [<ffffffff8111234c>] __wake_up_common+0x2c/0x90
[ 1848.196040] RSP: 0018:ffff880040df5bd0  EFLAGS: 00010086
[ 1848.196040] RAX: ffffffffffffffe8 RBX: ffff8800644a0040 RCX: 0000000000000000
[ 1848.196040] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8800644a0040
[ 1848.196040] RBP: ffff880040df5c10 R08: 0000000000000000 R09: 0000000000000001
[ 1848.196040] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000086
[ 1848.196040] R13: ffff8800644a0088 R14: 0000000000000000 R15: 0000000000000000
[ 1848.196040] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 1848.196040] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1848.196040] CR2: 0000000000000000 CR3: 0000000004a25000 CR4: 00000000000406e0
[ 1848.196040] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1848.196040] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1848.196040] Process kworker/4:1 (pid: 2901, threadinfo ffff880040df4000, task ffff8800415ab000)
[ 1848.196040] Stack:
[ 1848.196040]  ffff880040df5c10 0000000300000000 ffffffff8111533d ffff8800644a0040
[ 1848.196040]  0000000000000086 0000000000000003 0000000000000000 0000000000000000
[ 1848.196040]  ffff880040df5c50 ffffffff81115353 ffff880040df5c50 ffff8800644a0000
[ 1848.196040] Call Trace:
[ 1848.196040]  [<ffffffff8111533d>] ? __wake_up+0x2d/0x70
[ 1848.196040]  [<ffffffff81115353>] __wake_up+0x43/0x70
[ 1848.196040]  [<ffffffff81932b06>] blk_drain_queue+0x116/0x160
[ 1848.196040]  [<ffffffff8193494c>] blk_cleanup_queue+0x17c/0x1b0
[ 1848.196040]  [<ffffffff82cba5b3>] md_free+0x53/0x70
[ 1848.196040]  [<ffffffff8195c725>] kobject_cleanup+0x145/0x190
[ 1848.196040]  [<ffffffff8195c77d>] kobject_release+0xd/0x10
[ 1848.196040]  [<ffffffff8195c50c>] kobject_put+0x4c/0x60
[ 1848.196040]  [<ffffffff82cba08f>] mddev_delayed_delete+0x2f/0x40
[ 1848.196040]  [<ffffffff810fca06>] process_one_work+0x366/0x5f0
[ 1848.196040]  [<ffffffff810fc8e0>] ? process_one_work+0x240/0x5f0
[ 1848.196040]  [<ffffffff82cba060>] ? bb_show+0x20/0x20
[ 1848.196040]  [<ffffffff810fe0a1>] worker_thread+0x211/0x3a0
[ 1848.196040]  [<ffffffff810fde90>] ? manage_workers+0x130/0x130
[ 1848.196040]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 1848.196040]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 1848.196040]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 1848.196040]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 1848.196040]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 1848.196040] Code: 48 89 e5 41 57 41 89 cf 41 56 4d 89 c6 41 55 4c 8d 6f 48 41 54 53 48 83 ec 18 89 75 cc 89 55 c8 48 8b 57 48 48 8d 42 e8 49 39 d5 <48> 8b 58 18 74 4e 48 83 eb 18 66 2e 0f 1f 84 00 00 00 00 00 44 
[ 1848.196040] RIP  [<ffffffff8111234c>] __wake_up_common+0x2c/0x90
[ 1848.196040]  RSP <ffff880040df5bd0>
[ 1848.196040] CR2: 0000000000000000
[ 1848.196040] ---[ end trace 6d450e935ee18982 ]---

Once the noise from the OOPS has stopped (there were 4-5 follow-up dumps - mostly things angry the oopsing itself), I've tried sysrq-t to see what's up in the system, but that was interrupted half-way by:

[ 1848.862010] BUG: spinlock lockup on CPU#4, kworker/4:1/2901
[ 1848.862010]  lock: 0xffff8800419d6140, .magic: dead4ead, .owner: kworker/4:1/2901, .owner_cpu: 4
[ 1848.862010] Pid: 2901, comm: kworker/4:1 Tainted: G      D W    3.5.0-rc2-sasha-00015-g7b268f7 #374
[ 1848.862010] Call Trace:
[ 1848.862010]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
[ 1848.862010]  [<ffffffff8197e09e>] do_raw_spin_lock+0xfe/0x140
[ 1848.862010]  [<ffffffff837c0d51>] _raw_spin_lock_irq+0x81/0xa0
[ 1848.862010]  [<ffffffff837bf2f0>] ? __schedule+0x1a0/0x880
[ 1848.862010]  [<ffffffff837bf2f0>] __schedule+0x1a0/0x880
[ 1848.862010]  [<ffffffff837bfb35>] schedule+0x55/0x60
[ 1848.862010]  [<ffffffff810df7c7>] do_exit+0x107/0x4f0
[ 1848.862010]  [<ffffffff8106a978>] oops_end+0x108/0x120
[ 1848.862010]  [<ffffffff810a171f>] no_context+0x1bf/0x1e0
[ 1848.862010]  [<ffffffff819552f9>] ? cfq_put_queue+0x1f9/0x2a0
[ 1848.862010]  [<ffffffff810a194d>] __bad_area_nosemaphore+0x20d/0x250
[ 1848.862010]  [<ffffffff8121eeef>] ? free_debug_processing+0x2bf/0x350
[ 1848.862010]  [<ffffffff810a199e>] bad_area_nosemaphore+0xe/0x10
[ 1848.862010]  [<ffffffff810a1e39>] do_page_fault+0x209/0x450
[ 1848.862010]  [<ffffffff8114ad1a>] ? __lock_acquired+0xda/0x2e0
[ 1848.862010]  [<ffffffff819803bd>] ? debug_object_activate+0x6d/0x1b0
[ 1848.862010]  [<ffffffff8114ab52>] ? print_lock_contention_bug+0x22/0x110
[ 1848.862010]  [<ffffffff8114ad1a>] ? __lock_acquired+0xda/0x2e0
[ 1848.862010]  [<ffffffff810fb320>] ? __queue_work+0x250/0x500
[ 1848.862010]  [<ffffffff8109a1d1>] do_async_page_fault+0x31/0xb0
[ 1848.862010]  [<ffffffff837c1f55>] async_page_fault+0x25/0x30
[ 1848.862010]  [<ffffffff8110673b>] ? kthread_data+0xb/0x20
[ 1848.862010]  [<ffffffff810fa730>] wq_worker_sleeping+0x10/0xb0
[ 1848.862010]  [<ffffffff837bf376>] __schedule+0x226/0x880
[ 1848.862010]  [<ffffffff837bfb35>] schedule+0x55/0x60
[ 1848.862010]  [<ffffffff810dfb89>] do_exit+0x4c9/0x4f0
[ 1848.862010]  [<ffffffff8106a978>] oops_end+0x108/0x120
[ 1848.862010]  [<ffffffff810a171f>] no_context+0x1bf/0x1e0
[ 1848.862010]  [<ffffffff810a194d>] __bad_area_nosemaphore+0x20d/0x250
[ 1848.862010]  [<ffffffff810a199e>] bad_area_nosemaphore+0xe/0x10
[ 1848.862010]  [<ffffffff810a1e39>] do_page_fault+0x209/0x450
[ 1848.862010]  [<ffffffff837bcf4d>] ? dump_stack+0x77/0x82
[ 1848.862010]  [<ffffffff81149da8>] ? register_lock_class+0x538/0x540
[ 1848.862010]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 1848.862010]  [<ffffffff8109a1d1>] do_async_page_fault+0x31/0xb0
[ 1848.862010]  [<ffffffff837c1f55>] async_page_fault+0x25/0x30
[ 1848.862010]  [<ffffffff8111234c>] ? __wake_up_common+0x2c/0x90
[ 1848.862010]  [<ffffffff8111533d>] ? __wake_up+0x2d/0x70
[ 1848.862010]  [<ffffffff81115353>] __wake_up+0x43/0x70
[ 1848.862010]  [<ffffffff81932b06>] blk_drain_queue+0x116/0x160
[ 1848.862010]  [<ffffffff8193494c>] blk_cleanup_queue+0x17c/0x1b0
[ 1848.862010]  [<ffffffff82cba5b3>] md_free+0x53/0x70
[ 1848.862010]  [<ffffffff8195c725>] kobject_cleanup+0x145/0x190
[ 1848.862010]  [<ffffffff8195c77d>] kobject_release+0xd/0x10
[ 1848.862010]  [<ffffffff8195c50c>] kobject_put+0x4c/0x60
[ 1848.862010]  [<ffffffff82cba08f>] mddev_delayed_delete+0x2f/0x40
[ 1848.862010]  [<ffffffff810fca06>] process_one_work+0x366/0x5f0
[ 1848.862010]  [<ffffffff810fc8e0>] ? process_one_work+0x240/0x5f0
[ 1848.862010]  [<ffffffff82cba060>] ? bb_show+0x20/0x20
[ 1848.862010]  [<ffffffff810fe0a1>] worker_thread+0x211/0x3a0
[ 1848.862010]  [<ffffffff810fde90>] ? manage_workers+0x130/0x130
[ 1848.862010]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 1848.862010]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 1848.862010]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 1848.862010]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 1848.862010]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 1848.862010] sending NMI to all CPUs:
[ 1919.331706] NMI backtrace for cpu 0
[ 1919.331706] CPU 0
[ 1919.331706] Pid: 0, comm: swapper/0 Tainted: G      D W    3.5.0-rc2-sasha-00015-g7b268f7 #374  
[ 1919.331706] RIP: 0010:[<ffffffff819673c9>]  [<ffffffff819673c9>] delay_tsc+0x29/0x140
[ 1919.331706] RSP: 0018:ffff88000d803a38  EFLAGS: 00000002
[ 1919.331706] RAX: 0000000000000000 RBX: ffff8800419d6140 RCX: 000000000000e778
[ 1919.331706] RDX: 00000000e778e777 RSI: 0000000000000000 RDI: 0000000000000001
[ 1919.331706] RBP: ffff88000d803a68 R08: 0000000000010006 R09: 0000000000000000
[ 1919.331706] R10: 0000000000000000 R11: 0000000000000001 R12: 000000004fd88e78
[ 1919.331706] R13: 0000000000000001 R14: 0000000000000001 R15: 00000012c96bbf75
[ 1919.331706] FS:  0000000000000000(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[ 1919.331706] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1919.331706] CR2: 00007fdb780a2600 CR3: 0000000033ecf000 CR4: 00000000000406f0
[ 1919.331706] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1919.331706] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1919.331706] Process swapper/0 (pid: 0, threadinfo ffffffff84a00000, task ffffffff84a2d400)
[ 1919.331706] Stack:
[ 1919.331706]  ffff88000d803ab8 ffff8800419d6140 000000004fd88e78 00000000948a9c80
[ 1919.331706]  0000000000000001 00000012c96bbf75 ffff88000d803a78 ffffffff8196736a
[ 1919.331706]  ffff88000d803ab8 ffffffff8197e07d ffff88000d803ab8 0000000000000086
[ 1919.331706] Call Trace:
[ 1919.331706]  <IRQ> 
[ 1919.331706]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 1919.331706]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 1919.331706]  [<ffffffff837c0cb1>] _raw_spin_lock_irqsave+0xa1/0xc0
[ 1919.331706]  [<ffffffff8112fb38>] ? print_cfs_rq+0x128/0x700
[ 1919.331706]  [<ffffffff8112fb38>] print_cfs_rq+0x128/0x700
[ 1919.331706]  [<ffffffff81127bf0>] ? unthrottle_offline_cfs_rqs+0x100/0x100
[ 1919.331706]  [<ffffffff8114ac7d>] ? __lock_acquired+0x3d/0x2e0
[ 1919.331706]  [<ffffffff81127ce9>] print_cfs_stats+0xf9/0x1f0
[ 1919.331706]  [<ffffffff81127bf0>] ? unthrottle_offline_cfs_rqs+0x100/0x100
[ 1919.331706]  [<ffffffff81130d6c>] ? print_cpu+0x59c/0x6b0
[ 1919.331706]  [<ffffffff81130d7a>] print_cpu+0x5aa/0x6b0
[ 1919.331706]  [<ffffffff81130d60>] ? print_cpu+0x590/0x6b0
[ 1919.331706]  [<ffffffff81131462>] sched_debug_show+0x5e2/0x680
[ 1919.331706]  [<ffffffff8113150d>] sysrq_sched_debug_show+0xd/0x10
[ 1919.331706]  [<ffffffff8111bb7a>] show_state_filter+0x1aa/0x230
[ 1919.331706]  [<ffffffff8111b9d0>] ? account_system_time+0x2a0/0x2a0
[ 1919.331706]  [<ffffffff81b2b82b>] sysrq_handle_showstate+0xb/0x10
[ 1919.331706]  [<ffffffff81b2bca7>] __handle_sysrq+0xb7/0x180
[ 1919.331706]  [<ffffffff81b2bf91>] handle_sysrq+0x21/0x30
[ 1919.331706]  [<ffffffff81b485a9>] serial8250_rx_chars+0x179/0x210
[ 1919.331706]  [<ffffffff837c0cbd>] ? _raw_spin_lock_irqsave+0xad/0xc0
[ 1919.331706]  [<ffffffff81b490f3>] ? serial8250_handle_irq+0x23/0x80
[ 1919.331706]  [<ffffffff81b49116>] serial8250_handle_irq+0x46/0x80
[ 1919.331706]  [<ffffffff81b4916e>] serial8250_default_handle_irq+0x1e/0x30
[ 1919.331706]  [<ffffffff81b475be>] serial8250_interrupt+0x4e/0xd0
[ 1919.331706]  [<ffffffff81184701>] handle_irq_event_percpu+0x151/0x3e0
[ 1919.331706]  [<ffffffff811849d3>] handle_irq_event+0x43/0x70
[ 1919.331706]  [<ffffffff81187cf9>] ? handle_level_irq+0x19/0xe0
[ 1919.331706]  [<ffffffff81187d88>] handle_level_irq+0xa8/0xe0
[ 1919.331706]  [<ffffffff81069424>] handle_irq+0x164/0x180
[ 1919.331706]  [<ffffffff8110f0c0>] ? srcu_notifier_call_chain+0x20/0x20
[ 1919.331706]  [<ffffffff81068618>] do_IRQ+0x58/0xd0
[ 1919.331706]  [<ffffffff837c1baf>] common_interrupt+0x6f/0x6f
[ 1919.331706]  <EOI> 
[ 1919.331706]  [<ffffffff81071f08>] ? default_idle+0x1a8/0x390
[ 1919.331706]  [<ffffffff8109a6e6>] ? native_safe_halt+0x6/0x10
[ 1919.331706]  [<ffffffff8114d33d>] ? trace_hardirqs_on+0xd/0x10
[ 1919.331706]  [<ffffffff81071f25>] default_idle+0x1c5/0x390
[ 1919.331706]  [<ffffffff8107149f>] cpu_idle+0x11f/0x180
[ 1919.331706]  [<ffffffff836c7781>] rest_init+0x131/0x140
[ 1919.331706]  [<ffffffff836c7650>] ? csum_partial_copy_generic+0x170/0x170
[ 1919.331706]  [<ffffffff85315079>] start_kernel+0x3c9/0x3d6
[ 1919.331706]  [<ffffffff85314ade>] ? kernel_init+0x28a/0x28a
[ 1919.331706]  [<ffffffff85314324>] x86_64_start_reservations+0xff/0x104
[ 1919.331706]  [<ffffffff8531447e>] x86_64_start_kernel+0x155/0x164
[ 1919.331706] Code: 00 00 55 48 89 e5 41 57 41 56 41 55 49 89 fd 41 54 bf 01 00 00 00 53 48 83 ec 08 e8 f2 f4 7a ff e8 8d 84 01 00 0f 1f 00 0f ae e8 <48> 83 3d 37 d0 0d 03 00 75 07 0f 0b 0f 1f 00 eb fe 41 89 c6 e8 
[ 1867.123342] NMI backtrace for cpu 1
[ 1867.123342] CPU 1 
[ 1867.123342] Pid: 0, comm: swapper/1 Tainted: G      D W    3.5.0-rc2-sasha-00015-g7b268f7 #374  
[ 1867.123342] RIP: 0010:[<ffffffff8107068c>]  [<ffffffff8107068c>] native_read_tsc+0xc/0x20
[ 1867.123342] RSP: 0018:ffff88001b803d70  EFLAGS: 00000082
[ 1867.123342] RAX: 000000000000049e RBX: 000000006b283299 RCX: 000000006b2832ce
[ 1867.123342] RDX: 000000000000049e RSI: 0000000000000000 RDI: 0000000000000001
[ 1867.123342] RBP: ffff88001b803da8 R08: 0000000000010002 R09: 0000000000000000
[ 1867.123342] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88000d5aa010
[ 1867.123342] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000001
[ 1867.123342] FS:  0000000000000000(0000) GS:ffff88001b800000(0000) knlGS:0000000000000000
[ 1867.123342] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1867.123342] CR2: 00007f73f1bc1a40 CR3: 0000000004a25000 CR4: 00000000000406e0
[ 1867.123342] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1867.123342] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1867.123342] Process swapper/1 (pid: 0, threadinfo ffff88000d5aa000, task ffff88000d5b0000)
[ 1867.123342] Stack:
[ 1867.123342]  ffffffff81967425 ffff88001b803df8 ffff8800419d6140 0000000091d6599d
[ 1867.123342]  00000000948a9c80 0000000000000001 0000000000000001 ffff88001b803db8
[ 1867.123342]  ffffffff8196736a ffff88001b803df8 ffffffff8197e07d ffff88001b803df8
[ 1867.123342] Call Trace:
[ 1867.123342]  <IRQ> 
[ 1867.123342]  [<ffffffff81967425>] ? delay_tsc+0x85/0x140
[ 1867.123342]  [<ffffffff8196736a>] __delay+0xa/0x10
[ 1867.123342]  [<ffffffff8197e07d>] do_raw_spin_lock+0xdd/0x140
[ 1867.123342]  [<ffffffff837c0b1b>] _raw_spin_lock+0x5b/0x70
[ 1867.123342]  [<ffffffff8112c8fe>] ? do_sched_rt_period_timer+0x7e/0x320
[ 1867.123342]  [<ffffffff837c1520>] ? _raw_spin_unlock+0x30/0x60
[ 1867.123342]  [<ffffffff8112c8fe>] do_sched_rt_period_timer+0x7e/0x320
[ 1867.123342]  [<ffffffff8112cbe5>] sched_rt_period_timer+0x45/0x70
[ 1867.123342]  [<ffffffff8110c4a6>] __run_hrtimer+0x206/0x330
[ 1867.123342]  [<ffffffff8112cba0>] ? do_sched_rt_period_timer+0x320/0x320
[ 1867.123342]  [<ffffffff8110c898>] hrtimer_interrupt+0x118/0x230
[ 1867.123342]  [<ffffffff8108e995>] smp_apic_timer_interrupt+0x85/0xa0
[ 1867.123342]  [<ffffffff837c30ef>] apic_timer_interrupt+0x6f/0x80
[ 1867.123342]  <EOI> 
[ 1867.123342]  [<ffffffff81071f08>] ? default_idle+0x1a8/0x390
[ 1867.123342]  [<ffffffff8109a6e6>] ? native_safe_halt+0x6/0x10
[ 1867.123342]  [<ffffffff8114d33d>] ? trace_hardirqs_on+0xd/0x10
[ 1867.123342]  [<ffffffff81071f25>] default_idle+0x1c5/0x390
[ 1867.123342]  [<ffffffff8107149f>] cpu_idle+0x11f/0x180
[ 1867.123342]  [<ffffffff837b4f6e>] ? setup_APIC_timer+0x88/0x8d
[ 1867.123342]  [<ffffffff837b458c>] start_secondary+0xe1/0xe8
[ 1867.123342] Code: 03 48 c7 43 08 00 00 00 00 48 89 03 48 83 c4 08 5b c9 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 0f 31 89 c1 c9 48 89 d0 <89> c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 00 00 00 00 00 55 
[ 1848.862010] NMI backtrace for cpu 4
[ 1848.862010] CPU 4 
[ 1848.862010] Pid: 2901, comm: kworker/4:1 Tainted: G      D W    3.5.0-rc2-sasha-00015-g7b268f7 #374  
[ 1848.862010] RIP: 0010:[<ffffffff8109a5aa>]  [<ffffffff8109a5aa>] native_write_msr_safe+0xa/0x10
[ 1848.862010] RSP: 0018:ffff880040df5348  EFLAGS: 00000086
[ 1848.862010] RAX: 0000000000000400 RBX: 0000000000000004 RCX: 0000000000000830
[ 1848.862010] RDX: 0000000000000004 RSI: 0000000000000400 RDI: 0000000000000830
[ 1848.862010] RBP: ffff880040df5348 R08: ffffffff851259c0 R09: 0000000000000000
[ 1848.862010] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000004
[ 1848.862010] R13: ffffffff851259c0 R14: 0000000000000004 R15: 000000000000ef40
[ 1848.862010] FS:  0000000000000000(0000) GS:ffff880041800000(0000) knlGS:0000000000000000
[ 1848.862010] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1848.862010] CR2: fffffffffffffff8 CR3: 0000000004a25000 CR4: 00000000000406e0
[ 1848.862010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1848.862010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1848.862010] Process kworker/4:1 (pid: 2901, threadinfo ffff880040df4000, task ffff8800415ab000)
[ 1848.862010] Stack:
[ 1848.862010]  ffff880040df53b8 ffffffff81093d2d 0000000000000000 0000000000000000
[ 1848.862010]  ffff880040df53c8 0000000000000086 0000000000000002 0000000200080000
[ 1848.862010]  ffff880040df5398 0000000000000000 00000000948a9c80 00000000948a9c80
[ 1848.862010] Call Trace:
[ 1848.862010]  [<ffffffff81093d2d>] __x2apic_send_IPI_mask+0xdd/0x1b0
[ 1848.862010]  [<ffffffff81093e17>] x2apic_send_IPI_all+0x17/0x20
[ 1848.862010]  [<ffffffff8108f184>] arch_trigger_all_cpu_backtrace+0x64/0xb0
[ 1848.862010]  [<ffffffff8197e0a3>] do_raw_spin_lock+0x103/0x140
[ 1848.862010]  [<ffffffff837c0d51>] _raw_spin_lock_irq+0x81/0xa0
[ 1848.862010]  [<ffffffff837bf2f0>] ? __schedule+0x1a0/0x880
[ 1848.862010]  [<ffffffff837bf2f0>] __schedule+0x1a0/0x880
[ 1848.862010]  [<ffffffff837bfb35>] schedule+0x55/0x60
[ 1848.862010]  [<ffffffff810df7c7>] do_exit+0x107/0x4f0
[ 1848.862010]  [<ffffffff8106a978>] oops_end+0x108/0x120
[ 1848.862010]  [<ffffffff810a171f>] no_context+0x1bf/0x1e0
[ 1848.862010]  [<ffffffff819552f9>] ? cfq_put_queue+0x1f9/0x2a0
[ 1848.862010]  [<ffffffff810a194d>] __bad_area_nosemaphore+0x20d/0x250
[ 1848.862010]  [<ffffffff8121eeef>] ? free_debug_processing+0x2bf/0x350
[ 1848.862010]  [<ffffffff810a199e>] bad_area_nosemaphore+0xe/0x10
[ 1848.862010]  [<ffffffff810a1e39>] do_page_fault+0x209/0x450
[ 1848.862010]  [<ffffffff8114ad1a>] ? __lock_acquired+0xda/0x2e0
[ 1848.862010]  [<ffffffff819803bd>] ? debug_object_activate+0x6d/0x1b0
[ 1848.862010]  [<ffffffff8114ab52>] ? print_lock_contention_bug+0x22/0x110
[ 1848.862010]  [<ffffffff8114ad1a>] ? __lock_acquired+0xda/0x2e0
[ 1848.862010]  [<ffffffff810fb320>] ? __queue_work+0x250/0x500
[ 1848.862010]  [<ffffffff8109a1d1>] do_async_page_fault+0x31/0xb0
[ 1848.862010]  [<ffffffff837c1f55>] async_page_fault+0x25/0x30
[ 1848.862010]  [<ffffffff8110673b>] ? kthread_data+0xb/0x20
[ 1848.862010]  [<ffffffff810fa730>] wq_worker_sleeping+0x10/0xb0
[ 1848.862010]  [<ffffffff837bf376>] __schedule+0x226/0x880
[ 1848.862010]  [<ffffffff837bfb35>] schedule+0x55/0x60
[ 1848.862010]  [<ffffffff810dfb89>] do_exit+0x4c9/0x4f0
[ 1848.862010]  [<ffffffff8106a978>] oops_end+0x108/0x120
[ 1848.862010]  [<ffffffff810a171f>] no_context+0x1bf/0x1e0
[ 1848.862010]  [<ffffffff810a194d>] __bad_area_nosemaphore+0x20d/0x250
[ 1848.862010]  [<ffffffff810a199e>] bad_area_nosemaphore+0xe/0x10
[ 1848.862010]  [<ffffffff810a1e39>] do_page_fault+0x209/0x450
[ 1848.862010]  [<ffffffff837bcf4d>] ? dump_stack+0x77/0x82
[ 1848.862010]  [<ffffffff81149da8>] ? register_lock_class+0x538/0x540
[ 1848.862010]  [<ffffffff8106f5fd>] ? sched_clock+0x1d/0x30
[ 1848.862010]  [<ffffffff8109a1d1>] do_async_page_fault+0x31/0xb0
[ 1848.862010]  [<ffffffff837c1f55>] async_page_fault+0x25/0x30
[ 1848.862010]  [<ffffffff8111234c>] ? __wake_up_common+0x2c/0x90
[ 1848.862010]  [<ffffffff8111533d>] ? __wake_up+0x2d/0x70
[ 1848.862010]  [<ffffffff81115353>] __wake_up+0x43/0x70
[ 1848.862010]  [<ffffffff81932b06>] blk_drain_queue+0x116/0x160
[ 1848.862010]  [<ffffffff8193494c>] blk_cleanup_queue+0x17c/0x1b0
[ 1848.862010]  [<ffffffff82cba5b3>] md_free+0x53/0x70
[ 1848.862010]  [<ffffffff8195c725>] kobject_cleanup+0x145/0x190
[ 1848.862010]  [<ffffffff8195c77d>] kobject_release+0xd/0x10
[ 1848.862010]  [<ffffffff8195c50c>] kobject_put+0x4c/0x60
[ 1848.862010]  [<ffffffff82cba08f>] mddev_delayed_delete+0x2f/0x40
[ 1848.862010]  [<ffffffff810fca06>] process_one_work+0x366/0x5f0
[ 1848.862010]  [<ffffffff810fc8e0>] ? process_one_work+0x240/0x5f0
[ 1848.862010]  [<ffffffff82cba060>] ? bb_show+0x20/0x20
[ 1848.862010]  [<ffffffff810fe0a1>] worker_thread+0x211/0x3a0
[ 1848.862010]  [<ffffffff810fde90>] ? manage_workers+0x130/0x130
[ 1848.862010]  [<ffffffff81106e32>] kthread+0xb2/0xc0
[ 1848.862010]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
[ 1848.862010]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
[ 1848.862010]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
[ 1848.862010]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13
[ 1848.862010] Code: 00 55 89 f9 48 89 e5 0f 32 45 31 c0 89 c7 44 89 06 48 89 d0 89 f9 48 c1 e0 20 c9 48 09 c8 c3 66 90 55 89 f0 48 89 e5 89 f9 0f 30 <31> c0 c9 c3 66 90 55 89 f9 48 89 e5 0f 33 89 c7 c9 48 89 d0 89

And this little loop went on until everything choked and the vm just hang there.

