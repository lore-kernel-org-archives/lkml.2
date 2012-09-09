Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2IIH7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 03:59:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:4616 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2IIH7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 03:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,394,1344236400"; 
   d="scan'208";a="219909184"
Date: Sun, 9 Sep 2012 15:59:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: BUG: soft lockup - CPU#1 stuck for 1024s!
Message-ID: <20120909075927.GA13058@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

The below lockup warning pops up very occasionally in kvm guest
kernels and it's bisected down to

        commit 2a8c0883c3cfffcc148ea606e2a4e7453cd75e73
        Author: John Stultz <john.stultz@linaro.org>
        Date:   Fri Jul 13 01:21:56 2012 -0400

            time: Move xtime_nsec adjustment underflow handling timekeeping_adjust

[    8.340327] Freeing unused kernel memory: 460k freed
[ 1107.515496] [sched_delayed] sched: RT throttling activated
[ 1107.516439] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1107.516439] irq event stamp: 13644
[ 1107.516439] hardirqs last  enabled at (13641): [<c167d0c5>] restore_all_notrace+0x0/0x18
[ 1107.516439] hardirqs last disabled at (13642): [<c167d3cf>] apic_timer_interrupt+0x2f/0x40
[ 1107.516439] softirqs last  enabled at (13644): [<c102e6ae>] _local_bh_enable+0xd/0xf
[ 1107.516439] softirqs last disabled at (13643): [<c102eb79>] irq_enter+0x2c/0x4d
[ 1107.516439] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-00023-g8a13a4c #66  
[ 1107.516439] EIP: 0060:[<c101da64>] EFLAGS: 00000286 CPU: 1
[ 1107.516439] EIP is at native_safe_halt+0x5/0x7
[ 1107.516439] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1107.516439] ESI: cfff9e80 EDI: cfff9e70 EBP: ce071f6c ESP: ce071f6c
[ 1107.516439]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1107.516439] CR0: 8005003b CR2: b766c130 CR3: 0e83b000 CR4: 00000690
[ 1107.516439] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1107.516439] DR6: ffff0ff0 DR7: 00000400
[ 1107.516439] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1107.516439] Stack:
[ 1107.516439]  ce071f74 c1008a89 ce071f88 c10092c6 cde0a192 dc4426ba 168f476e ce071fb4
[ 1107.516439]  c166d17b 00000000 00000000 00000000 00000000 86be5003 168f476e 01000800
[ 1107.516439]  0000d248 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1107.516439] Call Trace:
[ 1107.516439]  [<c1008a89>] default_idle+0x2f/0x55
[ 1107.516439]  [<c10092c6>] cpu_idle+0xc7/0xf9
[ 1107.516439]  [<c166d17b>] start_secondary+0x296/0x29e
[ 1107.516439] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c7 89 55 f0 89

Below are all the oops messages during the bisect.

[    4.459980] Freeing unused kernel memory: 460k freed
[ 1103.514811] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1103.514811] irq event stamp: 7390
[ 1103.514811] hardirqs last  enabled at (7387): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1103.514811] hardirqs last disabled at (7388): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.514811] softirqs last  enabled at (7390): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1103.514811] softirqs last disabled at (7389): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1103.514811] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.514811] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1103.514811] EIP is at native_safe_halt+0x5/0x7
[ 1103.523837] [sched_delayed] sched: RT throttling activated
[ 1103.514811] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1103.514811] ESI: c19716f0 EDI: ffff8b9d EBP: ce071f68 ESP: ce071f68
[ 1103.514811]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.514811] CR0: 8005003b CR2: b767dfb8 CR3: 0ee9c000 CR4: 00000690
[ 1103.514811] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.514811] DR6: ffff0ff0 DR7: 00000400
[ 1103.514811] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1103.514811] Stack:
[ 1103.514811]  ce071f70 c1008a09 ce071f88 c1009250 a987df14 b7eb6434 f2365b03 cfff9fa0
[ 1103.514811]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 626563a0 f2365b03
[ 1103.514811]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1103.514811] Call Trace:
[ 1103.514811]  [<c1008a09>] default_idle+0x2f/0x55
[ 1103.514811]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1103.514811]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1103.514811] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1103.514811] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.514811] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.514811] Call Trace:
[ 1103.514811]  [<c1673678>] panic+0x97/0x1aa
[ 1103.514811]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.514811]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.514811]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.514811]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.514811]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.514811]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.514811]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.514811]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.514811]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.514811]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.514811]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1103.514811]  [<c1008a09>] default_idle+0x2f/0x55
[ 1103.514811]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1103.514811]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1103.514811] Rebooting in 10 seconds..
--
[    5.274691] Freeing unused kernel memory: 460k freed
[ 1104.516417] BUG: soft lockup - CPU#1 stuck for 1024s! [umount:132]
[ 1104.516417] irq event stamp: 3118
[ 1104.516417] hardirqs last  enabled at (3117): [<c167e841>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.516417] hardirqs last disabled at (3118): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.516417] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1104.516417] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.516417] Pid: 132, comm: umount Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.516417] EIP: 0060:[<c10ad429>] EFLAGS: 00000202 CPU: 1
[ 1104.522300] [sched_delayed] sched: RT throttling activated
[ 1104.516417] EIP is at unmap_single_vma+0x206/0x473
[ 1104.516417] EAX: ce8afec0 EBX: ce68bde0 ECX: 0a66f025 EDX: b76d7000
[ 1104.516417] ESI: ce89eb5c EDI: 00000000 EBP: ce8afe98 ESP: ce8afe34
[ 1104.516417]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.516417] CR0: 80050033 CR2: b75bbfb8 CR3: 0e897000 CR4: 00000690
[ 1104.516417] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.516417] DR6: ffff0ff0 DR7: 00000400
[ 1104.516417] Process umount (pid: 132, ti=ce8ae000 task=cf8a9130 task.ti=ce8ae000)
[ 1104.516417] Stack:
[ 1104.516417]  00000002 00000203 006f0203 00000000 cf8a95a4 b76fbfff ce148f34 ce89eb58
[ 1104.516417]  0a66f025 ce897b74 ce897b74 ce148f00 00000000 ce8afec0 b76fc000 b76fc000
[ 1104.516417]  ce8ad1b8 b76d7000 ce8afe80 ffffffff 00000000 00000000 ce8ad1b8 ce8afec0
[ 1104.516417] Call Trace:
[ 1104.516417]  [<c10adbca>] unmap_vmas+0x2a/0x40
[ 1104.516417]  [<c10b19d9>] exit_mmap+0x76/0xe4
[ 1104.516417]  [<c1025e1a>] mmput+0x42/0xa7
[ 1104.516417]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1104.516417]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1104.516417]  [<c10c81e1>] ? vfs_write+0x105/0x10f
[ 1104.516417]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1104.516417]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1104.516417]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.516417] Code: 89 d0 8d b6 00 00 00 00 89 45 bc 83 3d b8 1f 91 c1 00 75 02 0f 0b 8b 45 c8 8b 55 e0 89 f1 8d b6 00 00 00 00 8b 45 d0 80 48 0c 01 <85> db 0f 84 8e 01 00 00 80 7d cc 00 74 5a 8b 0f 85 c9 74 54 8b
[ 1104.516417] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.516417] Pid: 132, comm: umount Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.516417] Call Trace:
[ 1104.516417]  [<c1673678>] panic+0x97/0x1aa
[ 1104.516417]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.516417]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.516417]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.516417]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.516417]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.516417]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.516417]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.516417]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.516417]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.516417]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.516417]  [<c10b007b>] ? munlock_vma_pages_range+0x34/0xa1
[ 1104.516417]  [<c10ad429>] ? unmap_single_vma+0x206/0x473
[ 1104.516417]  [<c10adbca>] unmap_vmas+0x2a/0x40
[ 1104.516417]  [<c10b19d9>] exit_mmap+0x76/0xe4
[ 1104.516417]  [<c1025e1a>] mmput+0x42/0xa7
[ 1104.516417]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1104.516417]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1104.516417]  [<c10c81e1>] ? vfs_write+0x105/0x10f
[ 1104.516417]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1104.516417]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1104.516417]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.516417] Rebooting in 10 seconds..
--
[    5.814040] Freeing unused kernel memory: 460k freed
[ 1104.524796] BUG: soft lockup - CPU#1 stuck for 1023s! [sh:130]
[ 1104.524796] irq event stamp: 1712
[ 1104.524796] hardirqs last  enabled at (1711): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1104.524796] hardirqs last disabled at (1712): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.524796] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1104.524796] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.524796] Pid: 130, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.524796] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[ 1104.524796] EIP is at lock_acquire+0xb4/0xc0
[ 1104.524796] EAX: 00000282 EBX: cf89d5f0 ECX: 006f4012 EDX: 006f4012
[ 1104.524796] ESI: 00000000 EDI: c19136b8 EBP: ce8bdedc ESP: ce8bdeb0
[ 1104.524796]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.524796] CR0: 8005003b CR2: b75df2c0 CR3: 0e872000 CR4: 00000690
[ 1104.524796] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.524796] DR6: ffff0ff0 DR7: 00000400
[ 1104.524796] Process sh (pid: 130, ti=ce8bc000 task=cf89d5f0 task.ti=ce8bc000)
[ 1104.524796] Stack:
[ 1104.524796]  00000002 00000001 00000000 00000000 c10c2db3 00000000 00000000 00000282
[ 1104.524796]  ce85a780 0000000b ce85a780 ce8bdefc c10c2de0 00000002 00000001 00000000
[ 1104.524796]  c10c2db3 ce8909f8 b75df2c0 ce8bdf20 c10aef10 ce8bdf20 c10432c5 00000001
[ 1104.524796] Call Trace:
[ 1104.524796]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1104.524796]  [<c10c2de0>] mem_cgroup_count_vm_event+0x4b/0x163
[ 1104.531682] [sched_delayed] sched: RT throttling activated
[ 1104.524796]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1104.524796]  [<c10aef10>] handle_mm_fault+0x2f/0xb0
[ 1104.524796]  [<c10432c5>] ? down_read_trylock+0x51/0x59
[ 1104.524796]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.524796]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1104.524796]  [<c10c939f>] ? fget_light+0xf7/0x334
[ 1104.524796]  [<c12b3908>] ? copy_to_user+0x3f/0x46
[ 1104.524796]  [<c167f085>] ? restore_all+0xf/0xf
[ 1104.524796]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.524796]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.524796]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1104.524796]  [<c167f5cc>] error_code+0x6c/0x80
[ 1104.524796] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[ 1104.524796] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.524796] Pid: 130, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.524796] Call Trace:
[ 1104.524796]  [<c1673678>] panic+0x97/0x1aa
[ 1104.524796]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.524796]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.524796]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.524796]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.524796]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.524796]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.524796]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.524796]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.524796]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.524796]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.524796]  [<c10675e9>] ? lock_acquire+0xb4/0xc0
[ 1104.524796]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1104.524796]  [<c10c2de0>] mem_cgroup_count_vm_event+0x4b/0x163
[ 1104.524796]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1104.524796]  [<c10aef10>] handle_mm_fault+0x2f/0xb0
[ 1104.524796]  [<c10432c5>] ? down_read_trylock+0x51/0x59
[ 1104.524796]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.524796]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1104.524796]  [<c10c939f>] ? fget_light+0xf7/0x334
[ 1104.524796]  [<c12b3908>] ? copy_to_user+0x3f/0x46
[ 1104.524796]  [<c167f085>] ? restore_all+0xf/0xf
[ 1104.524796]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.524796]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.524796]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1104.524796]  [<c167f5cc>] error_code+0x6c/0x80
[ 1104.524796] Rebooting in 10 seconds..
--
[ 1103.513737] [sched_delayed] sched: RT throttling activated
[ 1103.513714] BUG: soft lockup - CPU#1 stuck for 1024s! [hwclock:126]
[ 1103.513714] irq event stamp: 6902
[ 1103.513714] hardirqs last  enabled at (6901): [<c167e884>] _raw_spin_unlock_irq+0x22/0x40
[ 1103.513714] hardirqs last disabled at (6902): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.513714] softirqs last  enabled at (2618): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1103.513714] softirqs last disabled at (2616): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1103.513714] Pid: 126, comm: hwclock Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.513714] EIP: 0060:[<c167e891>] EFLAGS: 00000286 CPU: 1
[ 1103.513714] EIP is at _raw_spin_unlock_irq+0x2f/0x40
[ 1103.513714] EAX: cf8aa260 EBX: ce832084 ECX: 00000000 EDX: 00000007
[ 1103.513714] ESI: 00000001 EDI: 00000000 EBP: ce895f28 ESP: ce895f24
[ 1103.513714]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.513714] CR0: 8005003b CR2: b7642fb8 CR3: 019f0000 CR4: 00000690
[ 1103.513714] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.513714] DR6: ffff0ff0 DR7: 00000400
[ 1103.513714] Process hwclock (pid: 126, ti=ce894000 task=cf8aa260 task.ti=ce894000)
[ 1103.513714] Stack:
[ 1103.513714]  00000000 ce895f40 c1320af4 cf8aa260 cf8aa260 00000000 0000000f ce895f8c
[ 1103.513714]  c102ce62 b7642fb8 00000000 00000282 afb408d9 00001043 ce895f94 ce895f9c
[ 1103.513714]  00000000 00000001 c102dd6d c12b3946 00000007 00000006 00000000 cf883000
[ 1103.513714] Call Trace:
[ 1103.513714]  [<c1320af4>] disassociate_ctty+0xce/0x1cb
[ 1103.513714]  [<c102ce62>] do_exit+0x21f/0x72c
[ 1103.513714]  [<c102dd6d>] ? do_sys_settimeofday+0x88/0x93
[ 1103.513714]  [<c12b3946>] ? _copy_from_user+0x37/0x4b
[ 1103.513714]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1103.513714]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1103.513714]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1103.513714] Code: 89 c3 8d 40 10 8b 4d 04 ba 01 00 00 00 e8 1e 8b 9e ff 89 d8 e8 38 40 c4 ff e8 69 6a 9e ff 83 3d 94 20 91 c1 00 75 02 0f 0b fb 90 <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5d c3 55 89 e5 53
[ 1103.513714] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.513714] Pid: 126, comm: hwclock Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.513714] Call Trace:
[ 1103.513714]  [<c1673678>] panic+0x97/0x1aa
[ 1103.513714]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.513714]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.513714]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.513714]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.513714]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.513714]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.513714]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.513714]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.513714]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.513714]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.513714]  [<c167e891>] ? _raw_spin_unlock_irq+0x2f/0x40
[ 1103.513714]  [<c1320af4>] disassociate_ctty+0xce/0x1cb
[ 1103.513714]  [<c102ce62>] do_exit+0x21f/0x72c
[ 1103.513714]  [<c102dd6d>] ? do_sys_settimeofday+0x88/0x93
[ 1103.513714]  [<c12b3946>] ? _copy_from_user+0x37/0x4b
[ 1103.513714]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1103.513714]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1103.513714]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1103.513714] Rebooting in 10 seconds..
--
[ 1103.518186] [sched_delayed] sched: RT throttling activated
[ 1103.517941] BUG: soft lockup - CPU#1 stuck for 1023s! [chroot:133]
[ 1103.517941] irq event stamp: 1984
[ 1103.517941] hardirqs last  enabled at (1983): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1103.517941] hardirqs last disabled at (1984): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.517941] softirqs last  enabled at (1934): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1103.517941] softirqs last disabled at (1932): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1103.517941] Pid: 133, comm: chroot Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.517941] EIP: 0060:[<c1065d13>] EFLAGS: 00000282 CPU: 1
[ 1103.517941] EIP is at lock_is_held+0x9f/0xb2
[ 1103.517941] EAX: 00000282 EBX: 00000001 ECX: 00000000 EDX: 00000000
[ 1103.517941] ESI: ce88e720 EDI: c19136b8 EBP: ce861ef8 ESP: ce861ee8
[ 1103.517941]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.517941] CR0: 80050033 CR2: b763c720 CR3: 0e872000 CR4: 00000690
[ 1103.517941] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.517941] DR6: ffff0ff0 DR7: 00000400
[ 1103.517941] Process chroot (pid: 133, ti=ce860000 task=ce88e720 task.ti=ce860000)
[ 1103.517941] Stack:
[ 1103.517941]  00000282 0000046c c181eefe 00000000 ce861f20 c104ba8b c101d888 ce861f20
[ 1103.517941]  c10432c5 00000001 00000002 ce861fb4 ce861fb4 c101d888 ce861f9c c101e6cd
[ 1103.517941]  00000028 ce861f38 ce88e720 ce83ca54 ce83ca00 ce88e720 00000028 00000004
[ 1103.517941] Call Trace:
[ 1103.517941]  [<c104ba8b>] __might_sleep+0x2b/0x1cd
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c10432c5>] ? down_read_trylock+0x51/0x59
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c101e6cd>] do_page_fault+0x193/0x36e
[ 1103.517941]  [<c167e884>] ? _raw_spin_unlock_irq+0x22/0x40
[ 1103.517941]  [<c167f085>] ? restore_all+0xf/0xf
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1103.517941]  [<c167f5cc>] error_code+0x6c/0x80
[ 1103.517941] Code: 7c e2 31 c9 eb 05 b9 01 00 00 00 64 a1 28 06 9e c1 c7 80 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 eb 05 b9 01 00 00 00 89 c8 5b 5b 5e 5f 5d c3 55 89
[ 1103.517941] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.517941] Pid: 133, comm: chroot Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.517941] Call Trace:
[ 1103.517941]  [<c1673678>] panic+0x97/0x1aa
[ 1103.517941]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.517941]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.517941]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.517941]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.517941]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.517941]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.517941]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.517941]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.517941]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.517941]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.517941]  [<c1065d13>] ? lock_is_held+0x9f/0xb2
[ 1103.517941]  [<c104ba8b>] __might_sleep+0x2b/0x1cd
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c10432c5>] ? down_read_trylock+0x51/0x59
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c101e6cd>] do_page_fault+0x193/0x36e
[ 1103.517941]  [<c167e884>] ? _raw_spin_unlock_irq+0x22/0x40
[ 1103.517941]  [<c167f085>] ? restore_all+0xf/0xf
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517941]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1103.517941]  [<c167f5cc>] error_code+0x6c/0x80
[ 1103.517941] Rebooting in 10 seconds..
--
[    5.212332] Freeing unused kernel memory: 460k freed
[ 1104.518431] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1104.518431] irq event stamp: 5734
[ 1104.518431] hardirqs last  enabled at (5731): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.518431] hardirqs last disabled at (5732): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.518431] softirqs last  enabled at (5734): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1104.518431] softirqs last disabled at (5733): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1104.518431] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.518431] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1104.518431] EIP is at native_safe_halt+0x5/0x7
[ 1104.518431] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1104.518431] ESI: c19716f0 EDI: ffff8b9f EBP: ce071f68 ESP: ce071f68
[ 1104.518431]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.518431] CR0: 8005003b CR2: b768ffb8 CR3: 0f8a4000 CR4: 00000690
[ 1104.518431] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.518431] DR6: ffff0ff0 DR7: 00000400
[ 1104.518431] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1104.518431] Stack:
[ 1104.518431]  ce071f70 c1008a09 ce071f88 c1009250 fcc4d513 0b285a35 45735797 cfff9fa0
[ 1104.518431]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 b5a26032 45735797
[ 1104.518431]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.518431] Call Trace:
[ 1104.518431]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.518431]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.518431]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.518431] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.518431] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.518431] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.518431] Call Trace:
[ 1104.518431]  [<c1673678>] panic+0x97/0x1aa
[ 1104.518431]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.518431]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.518431]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.518431]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.518431]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.518431]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.518431]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.518431]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.518431]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.518431]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.518431]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1104.518431]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.518431]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.518431]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.518431] Rebooting in 10 seconds..
--
[ 1104.513600] [sched_delayed] sched: RT throttling activated
[ 1104.513573] BUG: soft lockup - CPU#1 stuck for 1025s! [run-parts:123]
[ 1104.513573] irq event stamp: 1114
[ 1104.513573] hardirqs last  enabled at (1113): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.513573] hardirqs last disabled at (1114): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.513573] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1104.513573] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.513573] Pid: 123, comm: run-parts Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.513573] EIP: 0060:[<c10a036c>] EFLAGS: 00000202 CPU: 1
--
[    5.941592] Freeing unused kernel memory: 460k freed
[ 1104.521335] BUG: soft lockup - CPU#1 stuck for 1023s! [umount:132]
[ 1104.521335] irq event stamp: 2688
[ 1104.521335] hardirqs last  enabled at (2687): [<c167f898>] sysenter_exit+0xf/0x1e
[ 1104.521335] hardirqs last disabled at (2688): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.521335] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1104.521335] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.521335] Pid: 132, comm: umount Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.521335] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[ 1104.521335] EIP is at lock_acquire+0xb4/0xc0
[ 1104.521335] EAX: 00000282 EBX: cf899130 ECX: 000001e4 EDX: 000001e4
[ 1104.521335] ESI: 00000000 EDI: cb48f9bc EBP: ce8bfeec ESP: ce8bfec0
[ 1104.521335]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.521335] CR0: 80050033 CR2: b773f8d0 CR3: 0e8a1000 CR4: 00000690
[ 1104.521335] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.521335] DR6: ffff0ff0 DR7: 00000400
[ 1104.521335] Process umount (pid: 132, ti=ce8be000 task=cf899130 task.ti=ce8be000)
[ 1104.521335] Stack:
[ 1104.521335]  00000000 00000002 00000000 00000000 c10d99bd 00000000 00000000 00000282
[ 1104.521335]  cb48f9ac ffffff9c cb48f9ac ce8bff08 c167e6a2 00000000 00000002 00000000
[ 1104.521335]  c10d99bd cb48f960 ce8bff20 c10d99bd ffffff9c ce8bff38 ffffff9c 00000000
[ 1104.521335] Call Trace:
[ 1104.521335]  [<c10d99bd>] ? dput+0x37/0x143
[ 1104.521335]  [<c167e6a2>] _raw_spin_lock+0x3d/0x4a
[ 1104.521335]  [<c10d99bd>] ? dput+0x37/0x143
[ 1104.521335]  [<c10d99bd>] dput+0x37/0x143
[ 1104.521335]  [<c10d1041>] path_put+0xe/0x18
[ 1104.521335]  [<c10cc05b>] vfs_fstatat+0x56/0x60
[ 1104.521335]  [<c10cc07e>] vfs_stat+0x19/0x1b
[ 1104.521335]  [<c10cc22a>] sys_stat64+0x11/0x22
[ 1104.521335]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.521335] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[ 1104.521335] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.521335] Pid: 132, comm: umount Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.521335] Call Trace:
[ 1104.521335]  [<c1673678>] panic+0x97/0x1aa
[ 1104.521335]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.521335]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.521335]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.521335]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.521335]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.521335]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.521335]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.521335]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.521335]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.521335]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.521335]  [<c10d00d8>] ? pipe_fcntl+0xbc/0x140
[ 1104.521335]  [<c10675e9>] ? lock_acquire+0xb4/0xc0
[ 1104.521335]  [<c10d99bd>] ? dput+0x37/0x143
[ 1104.521335]  [<c167e6a2>] _raw_spin_lock+0x3d/0x4a
[ 1104.521335]  [<c10d99bd>] ? dput+0x37/0x143
[ 1104.521335]  [<c10d99bd>] dput+0x37/0x143
[ 1104.521335]  [<c10d1041>] path_put+0xe/0x18
[ 1104.521335]  [<c10cc05b>] vfs_fstatat+0x56/0x60
[ 1104.521335]  [<c10cc07e>] vfs_stat+0x19/0x1b
[ 1104.521335]  [<c10cc22a>] sys_stat64+0x11/0x22
[ 1104.521335]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.521335] Rebooting in 10 seconds..
--
[    5.028838] Freeing unused kernel memory: 460k freed
[ 1104.517771] BUG: soft lockup - CPU#1 stuck for 1025s! [mountall:135]
[ 1104.517771] irq event stamp: 9160
[ 1104.517771] hardirqs last  enabled at (9159): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.517771] hardirqs last disabled at (9160): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.517771] softirqs last  enabled at (3012): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1104.517771] softirqs last disabled at (3010): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1104.517771] Pid: 135, comm: mountall Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.517771] EIP: 0073:[<b7722c34>] EFLAGS: 00000202 CPU: 1
[ 1104.517771] EIP is at 0xb7722c34
[ 1104.517771] EAX: ff8760ae EBX: b7739ff4 ECX: 000000ae EDX: 00020415
[ 1104.517771] ESI: b76f1590 EDI: 00000005 EBP: 007fc3b0 ESP: bfc17470
[ 1104.517771]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[ 1104.517771] Process mountall (pid: 135, ti=ce8c6000 task=ce842260 task.ti=ce8c6000)
[ 1104.517771] 
[ 1104.517771] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.517771] Pid: 135, comm: mountall Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.517771] Call Trace:
[ 1104.526641] [sched_delayed] sched: RT throttling activated
[ 1104.517771]  [<c1673678>] panic+0x97/0x1aa
[ 1104.517771]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.517771]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.517771]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.517771]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.517771]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.517771]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.517771]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.517771]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.517771]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.517771]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.517771] Rebooting in 10 seconds..
--
[    5.786476] Freeing unused kernel memory: 460k freed
[ 1104.518564] BUG: soft lockup - CPU#1 stuck for 1023s! [grep:129]
[ 1104.518564] irq event stamp: 2294
[ 1104.518564] hardirqs last  enabled at (2293): [<c167e841>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.518564] hardirqs last disabled at (2294): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.518564] softirqs last  enabled at (240): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1104.523873] [sched_delayed] sched: RT throttling activated
[ 1104.518564] softirqs last disabled at (205): [<c1003f90>] do_softirq+0x74/0xdf
[ 1104.518564] Pid: 129, comm: grep Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.518564] EIP: 0060:[<c167e850>] EFLAGS: 00000282 CPU: 1
[ 1104.518564] EIP is at _raw_spin_unlock_irqrestore+0x51/0x63
[ 1104.518564] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000007
[ 1104.518564] ESI: c196c730 EDI: 00000002 EBP: ce89fe2c ESP: ce89fe24
[ 1104.518564]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.518564] CR0: 8005003b CR2: b7627fb8 CR3: 019f0000 CR4: 00000690
[ 1104.518564] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.518564] DR6: ffff0ff0 DR7: 00000400
[ 1104.518564] Process grep (pid: 129, ti=ce89e000 task=ce849130 task.ti=ce89e000)
[ 1104.518564] Stack:
[ 1104.518564]  ce538018 c196c490 ce89fe54 c10a0736 00000000 c109fe68 c196c490 ce68f3c0
[ 1104.518564]  00000282 00000001 ce538098 00000005 ce89fe68 c10a0a6d ce89fec0 ce89fee4
[ 1104.518564]  ce89fed8 ce89fe70 c10a0a8a ce89fe8c c10b9614 bff4f000 00000008 ce89fec0
[ 1104.518564] Call Trace:
[ 1104.518564]  [<c10a0736>] pagevec_lru_move_fn+0x8d/0xa8
[ 1104.518564]  [<c109fe68>] ? pagevec_move_tail_fn+0x54/0x54
[ 1104.518564]  [<c10a0a6d>] lru_add_drain_cpu+0xe0/0xe5
[ 1104.518564]  [<c10a0a8a>] lru_add_drain+0x18/0x24
[ 1104.518564]  [<c10b9614>] free_pages_and_swap_cache+0x13/0x7b
[ 1104.518564]  [<c10ac647>] tlb_flush_mmu+0x56/0x6c
[ 1104.518564]  [<c10ac66f>] tlb_finish_mmu+0x12/0x31
[ 1104.518564]  [<c10b19f9>] exit_mmap+0x96/0xe4
[ 1104.518564]  [<c1025e1a>] mmput+0x42/0xa7
[ 1104.518564]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1104.518564]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1104.518564]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1104.518564]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1104.518564]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.518564] Code: 3d 8c 20 91 c1 00 74 1d 89 d8 50 9d 8d 74 26 00 e8 dd 6b 9e ff eb 18 e8 ac 6a 9e ff 83 3d 8c 20 91 c1 00 75 02 0f 0b 89 d8 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5
[ 1104.518564] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.518564] Pid: 129, comm: grep Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.518564] Call Trace:
[ 1104.518564]  [<c1673678>] panic+0x97/0x1aa
[ 1104.518564]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.518564]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.518564]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.518564]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.518564]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.518564]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.518564]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.518564]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.518564]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.518564]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.518564]  [<c167e850>] ? _raw_spin_unlock_irqrestore+0x51/0x63
[ 1104.518564]  [<c10a0736>] pagevec_lru_move_fn+0x8d/0xa8
[ 1104.518564]  [<c109fe68>] ? pagevec_move_tail_fn+0x54/0x54
[ 1104.518564]  [<c10a0a6d>] lru_add_drain_cpu+0xe0/0xe5
[ 1104.518564]  [<c10a0a8a>] lru_add_drain+0x18/0x24
[ 1104.518564]  [<c10b9614>] free_pages_and_swap_cache+0x13/0x7b
[ 1104.518564]  [<c10ac647>] tlb_flush_mmu+0x56/0x6c
[ 1104.518564]  [<c10ac66f>] tlb_finish_mmu+0x12/0x31
[ 1104.518564]  [<c10b19f9>] exit_mmap+0x96/0xe4
[ 1104.518564]  [<c1025e1a>] mmput+0x42/0xa7
[ 1104.518564]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1104.518564]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1104.518564]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1104.518564]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1104.518564]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.518564] Rebooting in 10 seconds..
--
[    5.159006] Freeing unused kernel memory: 460k freed
[ 1104.513734] BUG: soft lockup - CPU#1 stuck for 1025s! [swapper/1:0]
[ 1104.522610] [sched_delayed] sched: RT throttling activated
[ 1104.513734] irq event stamp: 12942
[ 1104.513734] hardirqs last  enabled at (12939): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.513734] hardirqs last disabled at (12940): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.513734] softirqs last  enabled at (12942): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1104.513734] softirqs last disabled at (12941): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1104.513734] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.513734] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1104.513734] EIP is at native_safe_halt+0x5/0x7
[ 1104.513734] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1104.513734] ESI: c19716f0 EDI: ffff8b9f EBP: ce071f68 ESP: ce071f68
[ 1104.513734]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.513734] CR0: 8005003b CR2: b7710000 CR3: 0ee89000 CR4: 00000690
[ 1104.513734] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.513734] DR6: ffff0ff0 DR7: 00000400
[ 1104.513734] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1104.513734] Stack:
[ 1104.513734]  ce071f70 c1008a09 ce071f88 c1009250 302764a8 3e8ae9cb 78d59122 cfff9fa0
[ 1104.552695]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 e90499bd 78d59122
[ 1104.552695]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.552695] Call Trace:
[ 1104.552695]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.552695]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.552695]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.552695] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.552695] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.552695] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.552695] Call Trace:
[ 1104.552695]  [<c1673678>] panic+0x97/0x1aa
[ 1104.552695]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.552695]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.552695]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.552695]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.552695]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.552695]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.552695]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.552695]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.552695]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.552695]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.552695]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1104.552695]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.552695]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.552695]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.552695] Rebooting in 10 seconds..
--
[    5.258753] Freeing unused kernel memory: 460k freed
[ 1104.517703] BUG: soft lockup - CPU#1 stuck for 1025s! [plymouthd:125]
[ 1104.517703] irq event stamp: 6312
[ 1104.517703] hardirqs last  enabled at (6311): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.517703] hardirqs last disabled at (6312): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.517703] softirqs last  enabled at (4300): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1104.517703] softirqs last disabled at (4287): [<c1003f90>] do_softirq+0x74/0xdf
[ 1104.517703] Pid: 125, comm: plymouthd Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.517703] EIP: 0060:[<c10ad232>] EFLAGS: 00000282 CPU: 1
[ 1104.517703] EIP is at unmap_single_vma+0xf/0x473
[ 1104.517703] EAX: ce86fe60 EBX: ce846318 ECX: b76db000 EDX: ce846318
[ 1104.526960] [sched_delayed] sched: RT throttling activated
[ 1104.517703] ESI: ce86fe60 EDI: b76db000 EBP: ce86fe34 ESP: ce86fdd0
[ 1104.517703]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.517703] CR0: 8005003b CR2: b76daedc CR3: 0e86a000 CR4: 00000690
[ 1104.517703] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.517703] DR6: ffff0ff0 DR7: 00000400
[ 1104.517703] Process plymouthd (pid: 125, ti=ce86e000 task=cf86e720 task.ti=ce86e000)
[ 1104.517703] Stack:
[ 1104.517703]  ce86fe04 c10a06a1 00000000 00000001 ce538120 00000282 c196c730 00000001
[ 1104.517703]  ce86fdf0 ce86fdf0 ce538118 c196c490 00000001 ce86fe60 c10a0743 00000001
[ 1104.517703]  ce846318 c196c490 ce73e940 00000282 00000001 ce538118 ce846318 ce86fe60
[ 1104.517703] Call Trace:
[ 1104.517703]  [<c10a06a1>] ? release_pages+0x171/0x179
[ 1104.517703]  [<c10a0743>] ? pagevec_lru_move_fn+0x9a/0xa8
[ 1104.517703]  [<c10adbca>] unmap_vmas+0x2a/0x40
[ 1104.517703]  [<c10b0843>] unmap_region+0x5c/0x92
[ 1104.517703]  [<c10b1893>] do_munmap+0x1d3/0x247
[ 1104.517703]  [<c10b21fa>] mmap_region+0x68/0x38a
[ 1104.517703]  [<c10b270b>] do_mmap_pgoff+0x1ef/0x22d
[ 1104.517703]  [<c10a69ab>] vm_mmap_pgoff+0x47/0x59
[ 1104.517703]  [<c10b1265>] sys_mmap_pgoff+0x80/0xa2
[ 1104.517703]  [<c167f04c>] syscall_call+0x7/0xb
[ 1104.517703] Code: 00 00 00 85 db 75 04 eb 09 89 c6 89 d8 e8 34 31 ff ff 89 f0 83 c4 2c 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 58 89 45 d0 89 55 dc <8b> 42 04 89 ce 39 c1 73 02 89 c6 8b 4d dc 8b 51 08 39 d6 0f 83
[ 1104.517703] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.517703] Pid: 125, comm: plymouthd Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.517703] Call Trace:
[ 1104.517703]  [<c1673678>] panic+0x97/0x1aa
[ 1104.517703]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.517703]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.517703]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.517703]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.517703]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.517703]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.517703]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.517703]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.517703]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.517703]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.517703]  [<c10600e0>] ? timecounter_init+0x13/0x21
[ 1104.517703]  [<c10ad232>] ? unmap_single_vma+0xf/0x473
[ 1104.517703]  [<c10a06a1>] ? release_pages+0x171/0x179
[ 1104.517703]  [<c10a0743>] ? pagevec_lru_move_fn+0x9a/0xa8
[ 1104.517703]  [<c10adbca>] unmap_vmas+0x2a/0x40
[ 1104.517703]  [<c10b0843>] unmap_region+0x5c/0x92
[ 1104.517703]  [<c10b1893>] do_munmap+0x1d3/0x247
[ 1104.517703]  [<c10b21fa>] mmap_region+0x68/0x38a
[ 1104.517703]  [<c10b270b>] do_mmap_pgoff+0x1ef/0x22d
[ 1104.517703]  [<c10a69ab>] vm_mmap_pgoff+0x47/0x59
[ 1104.517703]  [<c10b1265>] sys_mmap_pgoff+0x80/0xa2
[ 1104.517703]  [<c167f04c>] syscall_call+0x7/0xb
[ 1104.517703] Rebooting in 10 seconds..
--
[    5.088389] Freeing unused kernel memory: 460k freed
[ 1104.515816] BUG: soft lockup - CPU#1 stuck for 1025s! [99-trinity:126]
--
[    4.371778] Freeing unused kernel memory: 460k freed
[ 1103.516949] BUG: soft lockup - CPU#1 stuck for 1024s! [99-trinity:135]
[ 1103.516949] irq event stamp: 214
[ 1103.516949] hardirqs last  enabled at (213): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1103.516949] hardirqs last disabled at (214): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.516949] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1103.516949] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1103.516949] Pid: 135, comm: 99-trinity Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.516949] EIP: 0060:[<c1065d13>] EFLAGS: 00000282 CPU: 1
[ 1103.516949] EIP is at lock_is_held+0x9f/0xb2
[ 1103.516949] EAX: 00000282 EBX: 00000001 ECX: 00000001 EDX: 00000003
[ 1103.516949] ESI: ce8b3390 EDI: c19136b8 EBP: ce8cdedc ESP: ce8cdecc
[ 1103.516949]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.526882] [sched_delayed] sched: RT throttling activated
[ 1103.516949] CR0: 80050033 CR2: 080aaed0 CR3: 0e898000 CR4: 00000690
[ 1103.516949] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.516949] DR6: ffff0ff0 DR7: 00000400
mountall: ply-ev[ 1103.516949] Process 99-trinity (pid: 135, ti=ce8cc000 task=ce8b3390 task.ti=ce8cc000)
ent-loop.c:497: [ 1103.516949] Stack:
ply_event_loop_n[ 1103.516949]  00000282ew: Assertion `l ce8b3390oop->epoll_fd >= 0000000b 0' failed.
 ce130c80 ce8cdefc c10c2e53 00000002 00000001
[ 1103.516949]  00000000 c10c2db3 ce89a6e0 080aaed0 ce8cdf20 c10aef10 ce8cdf20 c10432c5
[ 1103.516949]  00000001 ce89a6e0 ce89a6e0 ce8cdfb4 c101d888 ce8cdf9c c101e870 00000028
--
[    4.924030] Freeing unused kernel memory: 460k freed
[ 1103.513755] BUG: soft lockup - CPU#1 stuck for 1024s! [init:1]
[ 1103.513755] irq event stamp: 744676
[ 1103.513755] hardirqs last  enabled at (744675): [<c167e841>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.513755] hardirqs last disabled at (744676): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.513755] softirqs last  enabled at (741152): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1103.513755] softirqs last disabled at (741139): [<c1003f90>] do_softirq+0x74/0xdf
[ 1103.513755] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.513755] EIP: 0060:[<c167e850>] EFLAGS: 00000282 CPU: 1
[ 1103.513755] EIP is at _raw_spin_unlock_irqrestore+0x51/0x63
[ 1103.513755] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000007
[ 1103.513755] ESI: cf89b778 EDI: 00000001 EBP: ce043dfc ESP: ce043df4
[ 1103.513755]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.513755] CR0: 80050033 CR2: b76aa920 CR3: 0ee86000 CR4: 00000690
[ 1103.523273] [sched_delayed] sched: RT throttling activated
[ 1103.513755] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.513755] DR6: ffff0ff0 DR7: 00000400
[ 1103.513755] Process init (pid: 1, ti=ce042000 task=ce048000 task.ti=ce042000)
[ 1103.513755] Stack:
[ 1103.513755]  00000000 cf89b390 ce043e20 c104a23a 00000282 cf89b778 0cb4c000 00000000
[ 1103.513755]  cf89b390 00000000 00000007 ce043e28 c104a280 ce043e38 c10306b6 cf89b390
[ 1103.513755]  00000000 ce043ef4 c1031596 003f8011 00000000 ce048474 00000000 ce048000
[ 1103.513755] Call Trace:
[ 1103.513755]  [<c104a23a>] try_to_wake_up+0x248/0x266
[ 1103.513755]  [<c104a280>] wake_up_state+0xa/0xc
[ 1103.513755]  [<c10306b6>] ptrace_resume+0x76/0x7c
[ 1103.513755]  [<c1031596>] ptrace_request+0x368/0x4f8
[ 1103.513755]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513755]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513755]  [<c10671f9>] ? lock_release_non_nested+0x7e/0x21b
[ 1103.513755]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513755]  [<c100acba>] arch_ptrace+0x474/0x48a
[ 1103.513755]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.513755]  [<c10652f8>] ? trace_hardirqs_on+0xb/0xd
[ 1103.513755]  [<c1047e25>] ? wait_task_inactive+0x6f/0xc1
[ 1103.513755]  [<c1030972>] ? ptrace_check_attach+0xb4/0xc4
[ 1103.513755]  [<c1031192>] sys_ptrace+0x34f/0x379
[ 1103.513755]  [<c1030eb1>] ? sys_ptrace+0x6e/0x379
[ 1103.513755]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1103.513755] Code: 3d 8c 20 91 c1 00 74 1d 89 d8 50 9d 8d 74 26 00 e8 dd 6b 9e ff eb 18 e8 ac 6a 9e ff 83 3d 8c 20 91 c1 00 75 02 0f 0b 89 d8 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5
[ 1103.513755] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.513755] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.513755] Call Trace:
[ 1103.513755]  [<c1673678>] panic+0x97/0x1aa
[ 1103.513755]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.513755]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.513755]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.513755]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.513755]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.513755]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.513755]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.513755]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.513755]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.513755]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.513755]  [<c167e850>] ? _raw_spin_unlock_irqrestore+0x51/0x63
[ 1103.513755]  [<c104a23a>] try_to_wake_up+0x248/0x266
[ 1103.513755]  [<c104a280>] wake_up_state+0xa/0xc
[ 1103.513755]  [<c10306b6>] ptrace_resume+0x76/0x7c
[ 1103.513755]  [<c1031596>] ptrace_request+0x368/0x4f8
[ 1103.513755]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513755]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513755]  [<c10671f9>] ? lock_release_non_nested+0x7e/0x21b
[ 1103.513755]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513755]  [<c100acba>] arch_ptrace+0x474/0x48a
[ 1103.513755]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.513755]  [<c10652f8>] ? trace_hardirqs_on+0xb/0xd
[ 1103.513755]  [<c1047e25>] ? wait_task_inactive+0x6f/0xc1
[ 1103.513755]  [<c1030972>] ? ptrace_check_attach+0xb4/0xc4
[ 1103.513755]  [<c1031192>] sys_ptrace+0x34f/0x379
[ 1103.513755]  [<c1030eb1>] ? sys_ptrace+0x6e/0x379
[ 1103.513755]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1103.513755] Rebooting in 10 seconds..
--
[ 1104.514595] [sched_delayed] sched: RT throttling activated
[ 1104.514574] BUG: soft lockup - CPU#1 stuck for 1023s! [hwclock:126]
[ 1104.514574] irq event stamp: 6886
[ 1104.514574] hardirqs last  enabled at (6885): [<c109c1fc>] get_page_from_freelist+0x2ca/0x456
[ 1104.514574] hardirqs last disabled at (6886): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.514574] softirqs last  enabled at (2696): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1104.514574] softirqs last disabled at (2694): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1104.514574] Pid: 126, comm: hwclock Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.514574] EIP: 0060:[<c10ad3a3>] EFLAGS: 00000246 CPU: 1
[ 1104.514574] EIP is at unmap_single_vma+0x180/0x473
[ 1104.514574] EAX: ce73eb80 EBX: ce73eb80 ECX: 0ffdc067 EDX: bf8e4000
[ 1104.514574] ESI: ce870390 EDI: 00000000 EBP: ce87de98 ESP: ce87de34
[ 1104.514574]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.514574] CR0: 8005003b CR2: b7666fb8 CR3: 0e877000 CR4: 00000690
[ 1104.514574] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.514574] DR6: ffff0ff0 DR7: 00000400
[ 1104.514574] Process hwclock (pid: 126, ti=ce87c000 task=cf8844c0 task.ti=ce87c000)
[ 1104.514574] Stack:
[ 1104.514574]  00000002 00000203 006f8203 00000000 cf884934 bf8e4fff ce852a34 ce87030c
[ 1104.514574]  0ffc9067 ce877bf8 ce877bf8 ce852a00 00000000 ce87dec0 bf8e5000 bf8e5000
[ 1104.514574]  ce839318 bf8e4000 ce87de80 00000000 ffffffff 00000000 ce839318 ce87dec0
[ 1104.514574] Call Trace:
[ 1104.514574]  [<c10adbca>] unmap_vmas+0x2a/0x40
[ 1104.514574]  [<c10b19d9>] exit_mmap+0x76/0xe4
[ 1104.514574]  [<c1025e1a>] mmput+0x42/0xa7
[ 1104.514574]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1104.514574]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1104.514574]  [<c102dd6d>] ? do_sys_settimeofday+0x88/0x93
[ 1104.514574]  [<c12b3946>] ? _copy_from_user+0x37/0x4b
[ 1104.514574]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1104.514574]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1104.514574]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.514574] Code: 7d 0c 8b 0e 85 c9 0f 84 3b 02 00 00 f7 c1 01 01 00 00 0f 84 73 01 00 00 8b 55 e0 8b 45 dc e8 d2 f7 ff ff 89 c3 85 ff 0f 95 45 cc <85> c0 74 30 80 7d cc 00 74 2a 8b 47 04 85 c0 74 09 3b 43 04 0f
[ 1104.514574] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.514574] Pid: 126, comm: hwclock Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.514574] Call Trace:
[ 1104.514574]  [<c1673678>] panic+0x97/0x1aa
[ 1104.514574]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.514574]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.514574]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.514574]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.514574]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.514574]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.514574]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.514574]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.514574]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.514574]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.514574]  [<c167007b>] ? kvm_guest_cpu_init+0x10b/0x214
[ 1104.514574]  [<c10ad3a3>] ? unmap_single_vma+0x180/0x473
[ 1104.514574]  [<c10adbca>] unmap_vmas+0x2a/0x40
[ 1104.514574]  [<c10b19d9>] exit_mmap+0x76/0xe4
[ 1104.514574]  [<c1025e1a>] mmput+0x42/0xa7
[ 1104.514574]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1104.514574]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1104.514574]  [<c102dd6d>] ? do_sys_settimeofday+0x88/0x93
[ 1104.514574]  [<c12b3946>] ? _copy_from_user+0x37/0x4b
[ 1104.514574]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1104.514574]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1104.514574]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.514574] Rebooting in 10 seconds..
--
[    4.775380] Freeing unused kernel memory: 460k freed
[ 1103.517476] BUG: soft lockup - CPU#1 stuck for 1024s! [sleep:135]
[ 1103.517476] irq event stamp: 1030
[ 1103.517476] hardirqs last  enabled at (1029): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1103.517476] hardirqs last disabled at (1030): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.521211] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1103.521211] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1103.521211] Pid: 135, comm: sleep Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.521211] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[ 1103.526940] [sched_delayed] sched: RT throttling activated
[ 1103.521211] EIP is at lock_acquire+0xb4/0xc0
[ 1103.521211] EAX: 00000282 EBX: ce89e720 ECX: 006fc012 EDX: 006fc012
[ 1103.521211] ESI: 00000000 EDI: c19136b8 EBP: ce8cfedc ESP: ce8cfeb0
[ 1103.521211]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.521211] CR0: 8005003b CR2: b77222c0 CR3: 0e8c4000 CR4: 00000690
[ 1103.521211] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.521211] DR6: ffff0ff0 DR7: 00000400
[ 1103.521211] Process sleep (pid: 135, ti=ce8ce000 task=ce89e720 task.ti=ce8ce000)
[ 1103.521211] Stack:
[ 1103.521211]  00000002 00000001 00000000 00000000 c10c2db3 00000000 00000000 00000282
[ 1103.521211]  ce84aa00 0000000b ce84aa00 ce8cfefc c10c2de0 00000002 00000001 00000000
[ 1103.521211]  c10c2db3 ce843948 b77222c0 ce8cff20 c10aef10 ce8cff20 c10432c5 00000001
[ 1103.521211] Call Trace:
[ 1103.521211]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1103.521211]  [<c10c2de0>] mem_cgroup_count_vm_event+0x4b/0x163
[ 1103.521211]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1103.521211]  [<c10aef10>] handle_mm_fault+0x2f/0xb0
[ 1103.521211]  [<c10432c5>] ? down_read_trylock+0x51/0x59
[ 1103.521211]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.521211]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1103.521211]  [<c10c8022>] ? vfs_read+0x103/0x10d
[ 1103.521211]  [<c167f085>] ? restore_all+0xf/0xf
[ 1103.521211]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.521211]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.521211]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1103.521211]  [<c167f5cc>] error_code+0x6c/0x80
[ 1103.521211] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[ 1103.521211] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.521211] Pid: 135, comm: sleep Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.521211] Call Trace:
[ 1103.521211]  [<c1673678>] panic+0x97/0x1aa
[ 1103.521211]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.521211]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.521211]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.521211]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.521211]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.521211]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.521211]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.521211]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.521211]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.521211]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.521211]  [<c10675e9>] ? lock_acquire+0xb4/0xc0
[ 1103.521211]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1103.521211]  [<c10c2de0>] mem_cgroup_count_vm_event+0x4b/0x163
[ 1103.521211]  [<c10c2db3>] ? mem_cgroup_count_vm_event+0x1e/0x163
[ 1103.521211]  [<c10aef10>] handle_mm_fault+0x2f/0xb0
[ 1103.521211]  [<c10432c5>] ? down_read_trylock+0x51/0x59
[ 1103.521211]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.521211]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1103.521211]  [<c10c8022>] ? vfs_read+0x103/0x10d
[ 1103.521211]  [<c167f085>] ? restore_all+0xf/0xf
[ 1103.521211]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.521211]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.521211]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1103.521211]  [<c167f5cc>] error_code+0x6c/0x80
[ 1103.521211] Rebooting in 10 seconds..
--
[    4.999346] Freeing unused kernel memory: 460k freed
[ 1104.515803] BUG: soft lockup - CPU#1 stuck for 1025s! [swapper/1:0]
[ 1104.515803] irq event stamp: 12116
[ 1104.515803] hardirqs last  enabled at (12113): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.515803] hardirqs last disabled at (12114): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.515803] softirqs last  enabled at (12116): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1104.515803] softirqs last disabled at (12115): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1104.515803] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.515803] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1104.515803] EIP is at native_safe_halt+0x5/0x7
[ 1104.515803] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1104.515803] ESI: c19716f0 EDI: ffff8b9d EBP: ce071f68 ESP: ce071f68
[ 1104.515803]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.515803] CR0: 8005003b CR2: b76c7fb8 CR3: 0ee89000 CR4: 00000690
[ 1104.515803] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.522791] [sched_delayed] sched: RT throttling activated
[ 1104.527860] DR6: ffff0ff0 DR7: 00000400
[ 1104.527860] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1104.527860] Stack:
[ 1104.527860]  ce071f70 c1008a09 ce071f88 c1009250 d2ce2da2 e131b2c1 1b7c62b3 cfff9fa0
[ 1104.527860]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 8bab6b51 1b7c62b3
[ 1104.527860]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.527860] Call Trace:
[ 1104.527860]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.527860]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.527860]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.527860] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.527860] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.527860] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.527860] Call Trace:
[ 1104.527860]  [<c1673678>] panic+0x97/0x1aa
[ 1104.527860]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.527860]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.527860]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.527860]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.527860]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.527860]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.527860]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.527860]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.527860]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.527860]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.527860]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1104.527860]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.527860]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.527860]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.527860] Rebooting in 10 seconds..
--
[    8.316068] Freeing unused kernel memory: 460k freed
[   76.723703] BUG: soft lockup - CPU#1 stuck for 64s! [sh:133]
[   76.723703] irq event stamp: 1490
[   76.723703] hardirqs last  enabled at (1489): [<c101e5d2>] do_page_fault+0x98/0x36e
[   76.723703] hardirqs last disabled at (1490): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[   76.723703] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[   76.723703] softirqs last disabled at (0): [<  (null)>]   (null)
[   76.723703] Pid: 133, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[   76.723703] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[   76.723703] EIP is at lock_acquire+0xb4/0xc0
[   76.723703] EAX: 00000282 EBX: ce8ab390 ECX: f46fc012 EDX: f46fc012
[   76.730213] [sched_delayed] sched: RT throttling activated
[   76.723703] ESI: 00000000 EDI: c19136b8 EBP: ce893e48 ESP: ce893e1c
[   76.723703]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   76.723703] CR0: 8005003b CR2: b752d2ad CR3: 0e889000 CR4: 00000690
[   76.723703] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   76.723703] DR6: ffff0ff0 DR7: 00000400
[   76.723703] Process sh (pid: 133, ti=ce892000 task=ce8ab390 task.ti=ce892000)
[   76.723703] Stack:
[   76.723703]  00000002 00000001 00000000 00000000 c10b402b 00000000 00000000 00000282
[   76.723703]  ce69cae0 00000000 0aed7025 ce893e6c c10b4058 00000002 00000001 00000000
[   76.723703]  c10b402b 00000000 c10ac260 ce69cae0 ce893eb8 c10ac2ee 00000000 ce870a34
[   76.723703] Call Trace:
[   76.723703]  [<c10b402b>] ? page_add_file_rmap+0xff/0x153
[   76.723703]  [<c10b4058>] page_add_file_rmap+0x12c/0x153
[   76.723703]  [<c10b402b>] ? page_add_file_rmap+0xff/0x153
[   76.723703]  [<c10ac260>] ? __do_fault+0x222/0x3c1
[   76.723703]  [<c10ac2ee>] __do_fault+0x2b0/0x3c1
[   76.723703]  [<c10aea20>] handle_pte_fault+0x2e6/0x7a7
[   76.723703]  [<c10aef82>] handle_mm_fault+0xa1/0xb0
[   76.723703]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[   76.723703]  [<c101e870>] do_page_fault+0x336/0x36e
[   76.723703]  [<c10af956>] ? might_fault+0x7b/0x99
[   76.723703]  [<c100b0ca>] ? set_tls_desc+0x14a/0x15d
[   76.723703]  [<c167f085>] ? restore_all+0xf/0xf
[   76.723703]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[   76.723703]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[   76.723703]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[   76.723703]  [<c167f5cc>] error_code+0x6c/0x80
[   76.723703] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[   76.723703] Kernel panic - not syncing: softlockup: hung tasks
[   76.723703] Pid: 133, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[   76.723703] Call Trace:
[   76.723703]  [<c1673678>] panic+0x97/0x1aa
[   76.723703]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[   76.723703]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[   76.723703]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[   76.723703]  [<c103205a>] run_local_timers+0x8/0x14
[   76.723703]  [<c103208a>] update_process_times+0x24/0x58
[   76.723703]  [<c106276e>] tick_periodic+0x66/0x72
[   76.723703]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[   76.723703]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[   76.723703]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[   76.723703]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[   76.723703]  [<c10675e9>] ? lock_acquire+0xb4/0xc0
[   76.723703]  [<c10b402b>] ? page_add_file_rmap+0xff/0x153
[   76.723703]  [<c10b4058>] page_add_file_rmap+0x12c/0x153
[   76.838708]  [<c10b402b>] ? page_add_file_rmap+0xff/0x153
[   76.838708]  [<c10ac260>] ? __do_fault+0x222/0x3c1
[   76.838708]  [<c10ac2ee>] __do_fault+0x2b0/0x3c1
[   76.838708]  [<c10aea20>] handle_pte_fault+0x2e6/0x7a7
[   76.838708]  [<c10aef82>] handle_mm_fault+0xa1/0xb0
[   76.838708]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[   76.838708]  [<c101e870>] do_page_fault+0x336/0x36e
[   76.838708]  [<c10af956>] ? might_fault+0x7b/0x99
[   76.838708]  [<c100b0ca>] ? set_tls_desc+0x14a/0x15d
[   76.838708]  [<c167f085>] ? restore_all+0xf/0xf
[   76.838708]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[   76.838708]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[   76.838708]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[   76.838708]  [<c167f5cc>] error_code+0x6c/0x80
[   76.838708] Rebooting in 10 seconds..
--
[    4.225859] Freeing unused kernel memory: 460k freed
[ 1103.516157] BUG: soft lockup - CPU#1 stuck for 1024s! [sh:134]
[ 1103.516157] irq event stamp: 3580
[ 1103.516157] hardirqs last  enabled at (3579): [<c167caf0>] __mutex_unlock_slowpath+0x114/0x12c
[ 1103.516157] hardirqs last disabled at (3580): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.516157] softirqs last  enabled at (2952): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1103.516157] softirqs last disabled at (2950): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1103.516157] Pid: 134, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.516157] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[ 1103.516157] EIP is at lock_acquire+0xb4/0xc0
[ 1103.516157] EAX: 00000282 EBX: cf891130 ECX: 006f437b EDX: 006f437b
[ 1103.524872] [sched_delayed] sched: RT throttling activated
--
[    5.072722] Freeing unused kernel memory: 460k freed
[ 1104.521453] BUG: soft lockup - CPU#1 stuck for 1024s! [trinity:133]
[ 1104.521453] irq event stamp: 5428
[ 1104.521453] hardirqs last  enabled at (5427): [<c109c1fc>] get_page_from_freelist+0x2ca/0x456
[ 1104.521453] hardirqs last disabled at (5428): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.521453] softirqs last  enabled at (3010): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1104.521453] softirqs last disabled at (3008): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1104.521453] Pid: 133, comm: trinity Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.521453] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[ 1104.530421] [sched_delayed] sched: RT throttling activated
[ 1104.521453] EIP is at lock_acquire+0xb4/0xc0
[ 1104.521453] EAX: 00000282 EBX: cf869130 ECX: 006f8012 EDX: 006f8012
[ 1104.521453] ESI: 00000000 EDI: c19136b8 EBP: ce8cfe04 ESP: ce8cfdd8
[ 1104.521453]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.521453] CR0: 8005003b CR2: 086e4e68 CR3: 0e883000 CR4: 00000690
[ 1104.521453] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.521453] DR6: ffff0ff0 DR7: 00000400
[ 1104.521453] Process trinity (pid: 133, ti=ce8ce000 task=cf869130 task.ti=ce8ce000)
[ 1104.521453] Stack:
[ 1104.521453]  00000002 00000001 00000000 00000000 c1096b46 00000000 00000000 00000282
[ 1104.521453]  c70b97c8 00000a5c 0000069c ce8cfe2c c1096b73 00000002 00000001 00000000
[ 1104.521453]  c1096b46 00000000 c6d5a500 00000a5c 00000000 ce8cfe6c c1096e6d 00000000
[ 1104.521453] Call Trace:
[ 1104.521453]  [<c1096b46>] ? find_get_page+0x17/0x1a6
[ 1104.521453]  [<c1096b73>] find_get_page+0x44/0x1a6
[ 1104.521453]  [<c1096b46>] ? find_get_page+0x17/0x1a6
[ 1104.521453]  [<c1096e6d>] filemap_fault+0x76/0x369
[ 1104.521453]  [<c10ac0e4>] __do_fault+0xa6/0x3c1
[ 1104.521453]  [<c10aea20>] handle_pte_fault+0x2e6/0x7a7
[ 1104.521453]  [<c10aef82>] handle_mm_fault+0xa1/0xb0
[ 1104.521453]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.521453]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1104.521453]  [<c1043362>] ? up_write+0x16/0x2b
[ 1104.521453]  [<c10a69b4>] ? vm_mmap_pgoff+0x50/0x59
[ 1104.521453]  [<c167f085>] ? restore_all+0xf/0xf
[ 1104.521453]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.521453]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.521453]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1104.521453]  [<c167f5cc>] error_code+0x6c/0x80
[ 1104.521453] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[ 1104.521453] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.521453] Pid: 133, comm: trinity Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.521453] Call Trace:
[ 1104.521453]  [<c1673678>] panic+0x97/0x1aa
[ 1104.521453]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.521453]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.521453]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.521453]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.521453]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.521453]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.521453]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.521453]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.521453]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.521453]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.521453]  [<c10675e9>] ? lock_acquire+0xb4/0xc0
[ 1104.521453]  [<c1096b46>] ? find_get_page+0x17/0x1a6
[ 1104.521453]  [<c1096b73>] find_get_page+0x44/0x1a6
[ 1104.521453]  [<c1096b46>] ? find_get_page+0x17/0x1a6
[ 1104.521453]  [<c1096e6d>] filemap_fault+0x76/0x369
[ 1104.521453]  [<c10ac0e4>] __do_fault+0xa6/0x3c1
[ 1104.521453]  [<c10aea20>] handle_pte_fault+0x2e6/0x7a7
[ 1104.521453]  [<c10aef82>] handle_mm_fault+0xa1/0xb0
[ 1104.521453]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.521453]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1104.521453]  [<c1043362>] ? up_write+0x16/0x2b
[ 1104.521453]  [<c10a69b4>] ? vm_mmap_pgoff+0x50/0x59
[ 1104.521453]  [<c167f085>] ? restore_all+0xf/0xf
[ 1104.521453]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.521453]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.521453]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1104.521453]  [<c167f5cc>] error_code+0x6c/0x80
[ 1104.521453] Rebooting in 10 seconds..
--
[    6.167052] Freeing unused kernel memory: 460k freed
[ 1105.525217] BUG: soft lockup - CPU#1 stuck for 1024s! [umount:132]
[ 1105.525217] irq event stamp: 1012
[ 1105.525217] hardirqs last  enabled at (1011): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1105.525217] hardirqs last disabled at (1012): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1105.525217] softirqs last  enabled at (604): [ 1105.528841] [sched_delayed] sched: RT throttling activated
[<c102e8ff>] __do_softirq+0x131/0x153
[ 1105.525217] softirqs last disabled at (583): [<c1003f90>] do_softirq+0x74/0xdf
[ 1105.525217] Pid: 132, comm: umount Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1105.525217] EIP: 0060:[<c10675e9>] EFLAGS: 00000282 CPU: 1
[ 1105.525217] EIP is at lock_acquire+0xb4/0xc0
[ 1105.525217] EAX: 00000282 EBX: cf893390 ECX: 006f637c EDX: 006f637c
[ 1105.525217] ESI: 00000000 EDI: ce8aa544 EBP: ce8afe50 ESP: ce8afe24
[ 1105.525217]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.525217] CR0: 8005003b CR2: b7749073 CR3: 0e89a000 CR4: 00000690
[ 1105.525217] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.525217] DR6: ffff0ff0 DR7: 00000400
[ 1105.525217] Process umount (pid: 132, ti=ce8ae000 task=cf893390 task.ti=ce8ae000)
[ 1105.525217] Stack:
[ 1105.525217]  00000000 00000002 00000000 00000000 c10ac260 00000000 00000000 00000282
[ 1105.525217]  ce8aa534 00000000 00000009 ce8afe6c c167e6a2 00000000 00000002 00000000
[ 1105.525217]  c10ac260 ce689ca0 ce8afeb8 c10ac260 00000000 ce8aa534 ce89dd24 00000000
[ 1105.525217] Call Trace:
[ 1105.525217]  [<c10ac260>] ? __do_fault+0x222/0x3c1
[ 1105.525217]  [<c167e6a2>] _raw_spin_lock+0x3d/0x4a
[ 1105.525217]  [<c10ac260>] ? __do_fault+0x222/0x3c1
[ 1105.525217]  [<c10ac260>] __do_fault+0x222/0x3c1
[ 1105.525217]  [<c10aea20>] handle_pte_fault+0x2e6/0x7a7
[ 1105.525217]  [<c10aef82>] handle_mm_fault+0xa1/0xb0
[ 1105.525217]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1105.525217]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1105.525217]  [<c1088b28>] ? call_rcu_sched+0x15/0x17
[ 1105.525217]  [<c10449ee>] ? __put_cred+0x35/0x37
[ 1105.525217]  [<c167f085>] ? restore_all+0xf/0xf
[ 1105.525217]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1105.525217]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1105.525217]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1105.525217]  [<c167f5cc>] error_code+0x6c/0x80
[ 1105.525217] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[ 1105.525217] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.525217] Pid: 132, comm: umount Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1105.525217] Call Trace:
[ 1105.525217]  [<c1673678>] panic+0x97/0x1aa
[ 1105.525217]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1105.525217]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.525217]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1105.525217]  [<c103205a>] run_local_timers+0x8/0x14
[ 1105.525217]  [<c103208a>] update_process_times+0x24/0x58
[ 1105.525217]  [<c106276e>] tick_periodic+0x66/0x72
[ 1105.525217]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1105.525217]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.525217]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.525217]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1105.525217]  [<c10675e9>] ? lock_acquire+0xb4/0xc0
[ 1105.525217]  [<c10ac260>] ? __do_fault+0x222/0x3c1
[ 1105.525217]  [<c167e6a2>] _raw_spin_lock+0x3d/0x4a
[ 1105.525217]  [<c10ac260>] ? __do_fault+0x222/0x3c1
[ 1105.525217]  [<c10ac260>] __do_fault+0x222/0x3c1
[ 1105.525217]  [<c10aea20>] handle_pte_fault+0x2e6/0x7a7
[ 1105.525217]  [<c10aef82>] handle_mm_fault+0xa1/0xb0
[ 1105.525217]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1105.525217]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1105.525217]  [<c1088b28>] ? call_rcu_sched+0x15/0x17
[ 1105.525217]  [<c10449ee>] ? __put_cred+0x35/0x37
[ 1105.525217]  [<c167f085>] ? restore_all+0xf/0xf
[ 1105.525217]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1105.525217]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1105.525217]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1105.525217]  [<c167f5cc>] error_code+0x6c/0x80
[ 1105.525217] Rebooting in 10 seconds..
--
[    4.943616] Freeing unused kernel memory: 460k freed
[ 1103.516727] BUG: soft lockup - CPU#1 stuck for 1023s! [99-trinity:129]
[ 1103.516727] irq event stamp: 632
[ 1103.516727] hardirqs last  enabled at (631): [<c167caf0>] __mutex_unlock_slowpath+0x114/0x12c
[ 1103.516727] hardirqs last disabled at (632): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.516727] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1103.516727] softirqs last disabled at (0): [ 1103.522351] [sched_delayed] sched: RT throttling activated
[<  (null)>]   (null)
[ 1103.516727] Pid: 129, comm: 99-trinity Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.516727] EIP: 0060:[<c1065d13>] EFLAGS: 00000282 CPU: 1
[ 1103.516727] EIP is at lock_is_held+0x9f/0xb2
[ 1103.516727] EAX: 00000282 EBX: 00000002 ECX: 00000000 EDX: 00000000
[ 1103.516727] ESI: cf899130 EDI: c19136a8 EBP: ce8bbddc ESP: ce8bbdcc
[ 1103.516727]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.516727] CR0: 8005003b CR2: 0807cbf0 CR3: 0e8b0000 CR4: 00000690
[ 1103.516727] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.516727] DR6: ffff0ff0 DR7: 00000400
[ 1103.516727] Process 99-trinity (pid: 129, ti=ce8ba000 task=cf899130 task.ti=ce8ba000)
[ 1103.516727] Stack:
[ 1103.516727]  00000282 000003c8 c182c540 00000000 ce8bbe04 c104bac6 00000001 00000282
[ 1103.516727]  ce828a34 00000000 ce828a34 023d8045 00000000 ce8b254c ce8bbe64 c10ada87
[ 1103.516727]  00000040 00000006 c1bcc504 ce829210 ce828a34 ce8291b4 ce8b2548 ce8acb74
[ 1103.516727] Call Trace:
[ 1103.516727]  [<c104bac6>] __might_sleep+0x66/0x1cd
[ 1103.516727]  [<c10ada87>] copy_pte_range+0x382/0x3bf
[ 1103.516727]  [<c10adb8c>] copy_page_range+0xc8/0xdc
[ 1103.516727]  [<c10262b7>] dup_mm+0x285/0x3a5
[ 1103.516727]  [<c1026c73>] copy_process+0x881/0xf8a
[ 1103.516727]  [<c1027493>] do_fork+0xef/0x257
[ 1103.516727]  [<c10af96b>] ? might_fault+0x90/0x99
[ 1103.516727]  [<c12b3908>] ? copy_to_user+0x3f/0x46
[ 1103.516727]  [<c100909b>] sys_clone+0x2b/0x32
[ 1103.516727]  [<c167f9f5>] ptregs_clone+0x15/0x20
[ 1103.516727]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1103.516727] Code: 7c e2 31 c9 eb 05 b9 01 00 00 00 64 a1 28 06 9e c1 c7 80 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 eb 05 b9 01 00 00 00 89 c8 5b 5b 5e 5f 5d c3 55 89
[ 1103.516727] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.516727] Pid: 129, comm: 99-trinity Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.516727] Call Trace:
[ 1103.516727]  [<c1673678>] panic+0x97/0x1aa
[ 1103.516727]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.516727]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.516727]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.516727]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.516727]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.516727]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.516727]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.516727]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.516727]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.516727]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.516727]  [<c1065d13>] ? lock_is_held+0x9f/0xb2
[ 1103.516727]  [<c104bac6>] __might_sleep+0x66/0x1cd
[ 1103.516727]  [<c10ada87>] copy_pte_range+0x382/0x3bf
[ 1103.516727]  [<c10adb8c>] copy_page_range+0xc8/0xdc
[ 1103.516727]  [<c10262b7>] dup_mm+0x285/0x3a5
[ 1103.516727]  [<c1026c73>] copy_process+0x881/0xf8a
[ 1103.516727]  [<c1027493>] do_fork+0xef/0x257
[ 1103.516727]  [<c10af96b>] ? might_fault+0x90/0x99
[ 1103.516727]  [<c12b3908>] ? copy_to_user+0x3f/0x46
[ 1103.516727]  [<c100909b>] sys_clone+0x2b/0x32
[ 1103.516727]  [<c167f9f5>] ptregs_clone+0x15/0x20
[ 1103.516727]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1103.516727] Rebooting in 10 seconds..
--
[ 1103.522466] [sched_delayed] sched: RT throttling activated
[ 1103.514897] BUG: soft lockup - CPU#1 stuck for 1023s! [init:1]
[ 1103.514897] irq event stamp: 746164
[ 1103.514897] hardirqs last  enabled at (746163): [<c167e884>] _raw_spin_unlock_irq+0x22/0x40
[ 1103.514897] hardirqs last disabled at (746164): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.514897] softirqs last  enabled at (745922): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1103.514897] softirqs last disabled at (745919): [<c1003f90>] do_softirq+0x74/0xdf
[ 1103.514897] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.514897] EIP: 0060:[<c167e891>] EFLAGS: 00000286 CPU: 1
[ 1103.514897] EIP is at _raw_spin_unlock_irq+0x2f/0x40
[ 1103.514897] EAX: ce048000 EBX: ce848504 ECX: 00000000 EDX: 00000007
[ 1103.514897] ESI: ce848158 EDI: ce043f94 EBP: ce043e8c ESP: ce043e88
[ 1103.514897]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.514897] CR0: 8005003b CR2: b75f1fb8 CR3: 0eecd000 CR4: 00000690
[ 1103.514897] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.514897] DR6: ffff0ff0 DR7: 00000400
[ 1103.514897] Process init (pid: 1, ti=ce042000 task=ce048000 task.ti=ce042000)
[ 1103.514897] Stack:
[ 1103.514897]  00000011 ce043ecc c1035a94 0000037b 0000037b 00000000 ce04845c ce048374
[ 1103.514897]  ce043f80 ce848000 ce044000 ce043fb4 ce848504 00000001 ce043fb4 bfbc73a0
[ 1103.514897]  00000000 ce043fa0 c1001cf3 00000000 00000000 ce844080 ce04845c ce048000
[ 1103.514897] Call Trace:
[ 1103.514897]  [<c1035a94>] get_signal_to_deliver+0x670/0x67a
[ 1103.514897]  [<c1001cf3>] do_signal+0x25/0x6a5
[ 1103.514897]  [<c10671f9>] ? lock_release_non_nested+0x7e/0x21b
[ 1103.514897]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.514897]  [<c10af956>] ? might_fault+0x7b/0x99
[ 1103.514897]  [<c10024f2>] do_notify_resume+0x22/0x56
[ 1103.514897]  [<c167f160>] work_notifysig+0x2b/0x3b
[ 1103.514897] Code: 89 c3 8d 40 10 8b 4d 04 ba 01 00 00 00 e8 1e 8b 9e ff 89 d8 e8 38 40 c4 ff e8 69 6a 9e ff 83 3d 94 20 91 c1 00 75 02 0f 0b fb 90 <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5d c3 55 89 e5 53
[ 1103.514897] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.514897] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.514897] Call Trace:
[ 1103.514897]  [<c1673678>] panic+0x97/0x1aa
[ 1103.514897]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.514897]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.514897]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.514897]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.514897]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.514897]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.514897]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.514897]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.514897]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.514897]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.514897]  [<c167e891>] ? _raw_spin_unlock_irq+0x2f/0x40
[ 1103.514897]  [<c1035a94>] get_signal_to_deliver+0x670/0x67a
[ 1103.514897]  [<c1001cf3>] do_signal+0x25/0x6a5
[ 1103.514897]  [<c10671f9>] ? lock_release_non_nested+0x7e/0x21b
[ 1103.514897]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.514897]  [<c10af956>] ? might_fault+0x7b/0x99
[ 1103.514897]  [<c10024f2>] do_notify_resume+0x22/0x56
[ 1103.514897]  [<c167f160>] work_notifysig+0x2b/0x3b
[ 1103.514897] Rebooting in 10 seconds..
--
[    5.094780] Freeing unused kernel memory: 460k freed
[ 1104.514155] BUG: soft lockup - CPU#1 stuck for 1024s! [sh:133]
[ 1104.514155] irq event stamp: 3594
[ 1104.514155] hardirqs last  enabled at (3593): [<c106831d>] debug_check_no_locks_freed+0x14b/0x167
[ 1104.514155] hardirqs last disabled at (3594): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.514155] softirqs last  enabled at (3024): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1104.514155] softirqs last disabled at (3022): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1104.514155] Pid: 133, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.522513] [sched_delayed] sched: RT throttling activated
[ 1104.514155] EIP: 0060:[<c10d0574>] EFLAGS: 00000246 CPU: 1
[ 1104.514155] EIP is at generic_permission+0x2d/0x22b
[ 1104.514155] EAX: ce881f80 EBX: 00000000 ECX: 00000000 EDX: 00000001
[ 1104.514155] ESI: cf891130 EDI: cb4b78c0 EBP: ce8bbe24 ESP: ce8bbe10
[ 1104.514155]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.514155] CR0: 80050033 CR2: b74f3267 CR3: 0e88e000 CR4: 00000690
[ 1104.514155] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.514155] DR6: ffff0ff0 DR7: 00000400
[ 1104.514155] Process sh (pid: 133, ti=ce8ba000 task=cf891130 task.ti=ce8ba000)
[ 1104.514155] Stack:
[ 1104.514155]  000041ed 00000001 cb4b78c0 cf891130 ce8bbef8 ce8bbe38 c10d07c3 00000000
[ 1104.514155]  ce028800 cf891130 ce8bbe44 c10d0808 ce8bbef8 ce8bbe98 c10d18cb cf891130
[ 1104.514155]  ce8bbe64 c1098035 cf891130 cf891130 ce8bbe90 cf891130 cae37000 c1021b4a
[ 1104.514155] Call Trace:
[ 1104.514155]  [<c10d07c3>] __inode_permission+0x51/0x56
[ 1104.514155]  [<c10d0808>] inode_permission+0x40/0x42
[ 1104.514155]  [<c10d18cb>] link_path_walk+0x68/0x64b
[ 1104.514155]  [<c1098035>] ? read_cache_page_async+0x22/0x27
[ 1104.514155]  [<c1021b4a>] ? kmap+0x5a/0x5c
[ 1104.514155]  [<c10d04a9>] ? page_getlink.isra.27+0x34/0x4f
[ 1104.514155]  [<c10d3631>] path_openat+0x256/0x352
[ 1104.514155]  [<c10d3753>] do_filp_open+0x26/0x67
[ 1104.514155]  [<c10deb0e>] ? alloc_fd+0x175/0x180
[ 1104.514155]  [<c10c7541>] do_sys_open+0xe6/0x171
[ 1104.514155]  [<c1088b28>] ? call_rcu_sched+0x15/0x17
[ 1104.514155]  [<c10449ee>] ? __put_cred+0x35/0x37
[ 1104.514155]  [<c10c75f0>] sys_open+0x24/0x2a
[ 1104.514155]  [<c167f04c>] syscall_call+0x7/0xb
[ 1104.514155] Code: e5 57 56 53 83 ec 08 89 c7 89 55 f0 0f b7 00 89 45 ec 8b 5f 04 e8 81 d6 f6 ff 64 a1 28 06 9e c1 8b 80 c0 02 00 00 39 58 1c 75 09 <c1> 6d ec 06 e9 66 01 00 00 8b 47 1c f6 40 32 01 0f 84 49 01 00
[ 1104.514155] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.514155] Pid: 133, comm: sh Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.514155] Call Trace:
[ 1104.514155]  [<c1673678>] panic+0x97/0x1aa
[ 1104.514155]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.514155]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.552525]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.552525]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.552525]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.552525]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.552525]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.552525]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.552525]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.552525]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.552525]  [<c10d0574>] ? generic_permission+0x2d/0x22b
[ 1104.552525]  [<c10d07c3>] __inode_permission+0x51/0x56
[ 1104.552525]  [<c10d0808>] inode_permission+0x40/0x42
[ 1104.552525]  [<c10d18cb>] link_path_walk+0x68/0x64b
[ 1104.552525]  [<c1098035>] ? read_cache_page_async+0x22/0x27
[ 1104.552525]  [<c1021b4a>] ? kmap+0x5a/0x5c
[ 1104.552525]  [<c10d04a9>] ? page_getlink.isra.27+0x34/0x4f
[ 1104.552525]  [<c10d3631>] path_openat+0x256/0x352
[ 1104.552525]  [<c10d3753>] do_filp_open+0x26/0x67
[ 1104.552525]  [<c10deb0e>] ? alloc_fd+0x175/0x180
[ 1104.552525]  [<c10c7541>] do_sys_open+0xe6/0x171
[ 1104.552525]  [<c1088b28>] ? call_rcu_sched+0x15/0x17
[ 1104.552525]  [<c10449ee>] ? __put_cred+0x35/0x37
[ 1104.552525]  [<c10c75f0>] sys_open+0x24/0x2a
[ 1104.552525]  [<c167f04c>] syscall_call+0x7/0xb
[ 1104.552525] Rebooting in 10 seconds..
--
[    4.485480] Freeing unused kernel memory: 460k freed
[ 1103.513144] BUG: soft lockup - CPU#1 stuck for 1024s! [init:132]
[ 1103.513144] irq event stamp: 544
[ 1103.513144] hardirqs last  enabled at (543): [<c106831d>] debug_check_no_locks_freed+0x14b/0x167
[ 1103.513144] hardirqs last disabled at (544): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.513144] softirqs last  enabled at (122): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1103.513144] softirqs last disabled at (95): [<c1003f90>] do_softirq+0x74/0xdf
[ 1103.513144] Pid: 132, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.513144] EIP: 0060:[<c1065d13>] EFLAGS: 00000282 CPU: 1
[ 1103.513144] EIP is at lock_is_held+0x9f/0xb2
[ 1103.513144] EAX: 00000282 EBX: 00000001 ECX: 00000000 EDX: 00000000
[ 1103.513144] ESI: cf8c9130 EDI: c1913698 EBP: ce8dbcf4 ESP: ce8dbce4
[ 1103.513144]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.522293] [sched_delayed] sched: RT throttling activated
[ 1103.513144] CR0: 8005003b CR2: b7776000 CR3: 0e892000 CR4: 00000690
[ 1103.513144] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.513144] DR6: ffff0ff0 DR7: 00000400
[ 1103.513144] Process init (pid: 132, ti=ce8da000 task=cf8c9130 task.ti=ce8da000)
[ 1103.513144] Stack:
[ 1103.513144]  00000282 00000452 c182a2ca 00000000 ce8dbd1c c104bb01 ce8dbe34 00000001
[ 1103.513144]  ce8da000 c784a100 00000080 00000000 ffffffff 00000000 ce8dbdac c1097c2a
[ 1103.513144]  00000001 c1918cd4 ce8dbd60 00000282 00000000 00000000 00000001 ce891c84
[ 1103.513144] Call Trace:
[ 1103.513144]  [<c104bb01>] __might_sleep+0xa1/0x1cd
[ 1103.513144]  [<c1097c2a>] generic_file_aio_read+0x268/0x5f1
[ 1103.513144]  [<c1045e49>] ? lg_local_unlock+0x16/0x2f
[ 1103.513144]  [<c10df58b>] ? mntput_no_expire+0x2b/0xfb
[ 1103.513144]  [<c10c78d1>] do_sync_read+0x75/0xb0
[ 1103.513144]  [<c10c7faa>] vfs_read+0x8b/0x10d
[ 1103.513144]  [<c10c785c>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1103.513144]  [<c10cd050>] kernel_read+0x30/0x41
[ 1103.513144]  [<c10f985c>] load_elf_binary+0x1ea/0xfbd
[ 1103.513144]  [<c10cdaa5>] search_binary_handler+0x14d/0x22b
[ 1103.513144]  [<c10cd992>] ? search_binary_handler+0x3a/0x22b
[ 1103.513144]  [<c10f9672>] ? load_elf_library+0x1bb/0x1bb
[ 1103.513144]  [<c10cdf0e>] do_execve+0x38b/0x456
[ 1103.513144]  [<c10cdc6e>] ? do_execve+0xeb/0x456
[ 1103.513144]  [<c1009165>] sys_execve+0x31/0x53
[ 1103.513144]  [<c167f962>] ptregs_execve+0x12/0x20
[ 1103.513144]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1103.513144] Code: 7c e2 31 c9 eb 05 b9 01 00 00 00 64 a1 28 06 9e c1 c7 80 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 eb 05 b9 01 00 00 00 89 c8 5b 5b 5e 5f 5d c3 55 89
[ 1103.513144] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.513144] Pid: 132, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.513144] Call Trace:
[ 1103.513144]  [<c1673678>] panic+0x97/0x1aa
[ 1103.513144]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.513144]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.513144]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.513144]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.513144]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.513144]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.513144]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.513144]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.513144]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.513144]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.513144]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.513144]  [<c1065d13>] ? lock_is_held+0x9f/0xb2
[ 1103.513144]  [<c104bb01>] __might_sleep+0xa1/0x1cd
[ 1103.513144]  [<c1097c2a>] generic_file_aio_read+0x268/0x5f1
[ 1103.513144]  [<c1045e49>] ? lg_local_unlock+0x16/0x2f
[ 1103.513144]  [<c10df58b>] ? mntput_no_expire+0x2b/0xfb
[ 1103.513144]  [<c10c78d1>] do_sync_read+0x75/0xb0
[ 1103.513144]  [<c10c7faa>] vfs_read+0x8b/0x10d
[ 1103.513144]  [<c10c785c>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1103.513144]  [<c10cd050>] kernel_read+0x30/0x41
[ 1103.513144]  [<c10f985c>] load_elf_binary+0x1ea/0xfbd
[ 1103.513144]  [<c10cdaa5>] search_binary_handler+0x14d/0x22b
[ 1103.513144]  [<c10cd992>] ? search_binary_handler+0x3a/0x22b
[ 1103.513144]  [<c10f9672>] ? load_elf_library+0x1bb/0x1bb
[ 1103.513144]  [<c10cdf0e>] do_execve+0x38b/0x456
[ 1103.513144]  [<c10cdc6e>] ? do_execve+0xeb/0x456
[ 1103.513144]  [<c1009165>] sys_execve+0x31/0x53
[ 1103.513144]  [<c167f962>] ptregs_execve+0x12/0x20
[ 1103.513144]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1103.513144] Rebooting in 10 seconds..
--
[    5.718013] Freeing unused kernel memory: 460k freed
[ 1104.517767] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1104.517767] irq event stamp: 8968
[ 1104.517767] hardirqs last  enabled at (8965): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.517767] hardirqs last disabled at (8966): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.517767] softirqs last  enabled at (8968): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1104.517767] softirqs last disabled at (8967): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1104.517767] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.517767] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1104.517767] EIP is at native_safe_halt+0x5/0x7
[ 1104.517767] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1104.517767] ESI: c19716f0 EDI: ffff8b9f EBP: ce071f68 ESP: ce071f68
[ 1104.517767]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.517767] CR0: 8005003b CR2: b765ebd0 CR3: 0e89b000 CR4: 00000690
[ 1104.517767] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.517767] DR6: ffff0ff0 DR7: 00000400
[ 1104.517767] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1104.517767] Stack:
[ 1104.517767]  ce071f70 c1008a09 ce071f88 c1009250 43ed9c2d 52512150 8c9c3063 cfff9fa0
[ 1104.517767]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 fccb38fe 8c9c3063
[ 1104.517767]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.517767] Call Trace:
[ 1104.517767]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.517767]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.517767]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1104.517767] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.517767] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.517767] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.517767] Call Trace:
[ 1104.517767]  [<c1673678>] panic+0x97/0x1aa
[ 1104.517767]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.517767]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.517767]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.517767]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.517767]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.517767]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.517767]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.517767]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.517767]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.517767]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.517767]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1104.517767]  [<c1008a09>] default_idle+0x2f/0x55
[ 1104.517767]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1104.517767]  [<c166ed10>] start_secondary+0x292/0x29a
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
[ 1104.517767] Rebooting in 10 seconds..
--
[ 1104.513744] [sched_delayed] sched: RT throttling activated
[ 1104.514576] BUG: soft lockup - CPU#1 stuck for 1024s! [init:1]
[ 1104.514576] irq event stamp: 747944
[ 1104.514576] hardirqs last  enabled at (747943): [<c167e841>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.514576] hardirqs last disabled at (747944): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.514576] softirqs last  enabled at (744332): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1104.514576] softirqs last disabled at (744329): [<c1003f90>] do_softirq+0x74/0xdf
[ 1104.514576] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.514576] EIP: 0060:[<c167e850>] EFLAGS: 00000282 CPU: 1
[ 1104.514576] EIP is at _raw_spin_unlock_irqrestore+0x51/0x63
[ 1104.514576] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000007
[ 1104.514576] ESI: cf8859d8 EDI: 00000001 EBP: ce043dfc ESP: ce043df4
[ 1104.514576]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.514576] CR0: 80050033 CR2: b76a9e60 CR3: 0eebd000 CR4: 00000690
[ 1104.514576] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.514576] DR6: ffff0ff0 DR7: 00000400
[ 1104.514576] Process init (pid: 1, ti=ce042000 task=ce048000 task.ti=ce042000)
[ 1104.514576] Stack:
[ 1104.514576]  00000000 cf8855f0 ce043e20 c104a23a 00000282 cf8859d8 0cb4c000 00000000
[ 1104.514576]  cf8855f0 00000000 00000007 ce043e28 c104a280 ce043e38 c10306b6 cf8855f0
[ 1104.514576]  00000000 ce043ef4 c1031596 003f8011 00000000 ce048474 00000000 ce048000
[ 1104.514576] Call Trace:
[ 1104.514576]  [<c104a23a>] try_to_wake_up+0x248/0x266
[ 1104.514576]  [<c104a280>] wake_up_state+0xa/0xc
[ 1104.514576]  [<c10306b6>] ptrace_resume+0x76/0x7c
[ 1104.514576]  [<c1031596>] ptrace_request+0x368/0x4f8
[ 1104.514576]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514576]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514576]  [<c10671f9>] ? lock_release_non_nested+0x7e/0x21b
[ 1104.514576]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514576]  [<c100acba>] arch_ptrace+0x474/0x48a
[ 1104.514576]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.514576]  [<c10652f8>] ? trace_hardirqs_on+0xb/0xd
[ 1104.514576]  [<c1047e25>] ? wait_task_inactive+0x6f/0xc1
[ 1104.514576]  [<c1030972>] ? ptrace_check_attach+0xb4/0xc4
[ 1104.514576]  [<c1031192>] sys_ptrace+0x34f/0x379
[ 1104.514576]  [<c1030eb1>] ? sys_ptrace+0x6e/0x379
[ 1104.514576]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.514576] Code: 3d 8c 20 91 c1 00 74 1d 89 d8 50 9d 8d 74 26 00 e8 dd 6b 9e ff eb 18 e8 ac 6a 9e ff 83 3d 8c 20 91 c1 00 75 02 0f 0b 89 d8 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5
[ 1104.514576] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.514576] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.514576] Call Trace:
[ 1104.514576]  [<c1673678>] panic+0x97/0x1aa
[ 1104.514576]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.514576]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.514576]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.514576]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.514576]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.514576]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.514576]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.514576]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.514576]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.514576]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.514576]  [<c167e850>] ? _raw_spin_unlock_irqrestore+0x51/0x63
[ 1104.514576]  [<c104a23a>] try_to_wake_up+0x248/0x266
[ 1104.514576]  [<c104a280>] wake_up_state+0xa/0xc
[ 1104.514576]  [<c10306b6>] ptrace_resume+0x76/0x7c
[ 1104.514576]  [<c1031596>] ptrace_request+0x368/0x4f8
[ 1104.514576]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514576]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514576]  [<c10671f9>] ? lock_release_non_nested+0x7e/0x21b
[ 1104.514576]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514576]  [<c100acba>] arch_ptrace+0x474/0x48a
[ 1104.514576]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.514576]  [<c10652f8>] ? trace_hardirqs_on+0xb/0xd
[ 1104.514576]  [<c1047e25>] ? wait_task_inactive+0x6f/0xc1
[ 1104.514576]  [<c1030972>] ? ptrace_check_attach+0xb4/0xc4
[ 1104.514576]  [<c1031192>] sys_ptrace+0x34f/0x379
[ 1104.514576]  [<c1030eb1>] ? sys_ptrace+0x6e/0x379
[ 1104.514576]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.514576] Rebooting in 10 seconds..
--
[    5.876251] Freeing unused kernel memory: 460k freed
[ 1104.522650] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1104.522650] irq event stamp: 14128
[ 1104.522650] hardirqs last  enabled at (14125): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.522650] hardirqs last disabled at (14126): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.528994] [sched_delayed] sched: RT throttling activated
[ 1104.532753] softirqs last  enabled at (14128): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1104.532753] softirqs last disabled at (14127): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1104.532753] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.540165] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1104.540165] EIP is at native_safe_halt+0x5/0x7
[ 1104.540165] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1104.540165] ESI: c19716f0 EDI: ffff8ba4 EBP: ce071f68 ESP: ce071f68
[ 1104.540165]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.540165] CR0: 8005003b CR2: b77b152c CR3: 019f0000 CR4: 00000690
[ 1104.540165] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
--
[    6.225744] Freeing unused kernel memory: 460k freed
[ 1105.529503] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1105.529503] irq event stamp: 14064
[ 1105.529503] hardirqs last  enabled at (14061): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1105.529503] hardirqs last disabled at (14062): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1105.529503] softirqs last  enabled at (14064): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1105.529503] softirqs last disabled at (14063): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1105.529503] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1105.529503] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1105.529503] EIP is at native_safe_halt+0x5/0x7
[ 1105.529503] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1105.529503] ESI: c19716f0 EDI: ffff8b9e EBP: ce071f68 ESP: ce071f68
[ 1105.529503]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.529503] CR0: 8005003b CR2: b7667fb8 CR3: 019f0000 CR4: 00000690
[ 1105.529503] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.529503] DR6: ffff0ff0 DR7: 00000400
[ 1105.529503] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1105.529503] Stack:
[ 1105.529503]  ce071f70 c1008a09 ce071f88 c1009250 b6ce783b c531fd5c ff7d2fe6 cfff9fa0
[ 1105.529503]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 6fac3882 ff7d2fe6
[ 1105.529503]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1105.529503] Call Trace:
[ 1105.529503]  [<c1008a09>] default_idle+0x2f/0x55
[ 1105.529503]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1105.529503]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1105.529503] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1105.529503] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.529503] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1105.529503] Call Trace:
[ 1105.529503]  [<c1673678>] panic+0x97/0x1aa
[ 1105.529503]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1105.529503]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.529503]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1105.529503]  [<c103205a>] run_local_timers+0x8/0x14
[ 1105.529503]  [<c103208a>] update_process_times+0x24/0x58
[ 1105.529503]  [<c106276e>] tick_periodic+0x66/0x72
[ 1105.529503]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1105.529503]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.529503]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.529503]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1105.529503]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1105.529503]  [<c1008a09>] default_idle+0x2f/0x55
[ 1105.529503]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1105.529503]  [<c166ed10>] start_secondary+0x292/0x29a
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
[ 1105.529503] Rebooting in 10 seconds..
--
[    5.084082] Freeing unused kernel memory: 460k freed
[ 1104.521392] BUG: soft lockup - CPU#1 stuck for 1025s! [swapper/1:0]
[ 1104.521414] irq event stamp: 14272
[ 1104.521414] hardirqs last  enabled at (14269): [<c10089f9>] default_idle+0x1f/0x55
[ 1104.523434] [sched_delayed] sched: RT throttling activated
[ 1104.521414] hardirqs last disabled at (14270): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.521414] softirqs last  enabled at (14272): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1104.521414] softirqs last disabled at (14271): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1104.521414] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.521414] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1104.521414] EIP is at native_safe_halt+0x5/0x7
[ 1104.521414] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1104.521414] ESI: c19716f0 EDI: ffff8b9f EBP: ce071f68 ESP: ce071f68
[ 1104.521414]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.521414] CR0: 8005003b CR2: b7611bd0 CR3: 0e866000 CR4: 00000690
[ 1104.521414] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
mountall: ply-ev[ 1104.521414] DR6: ffff0ff0 DR7: 00000400
ent-loop.c:497: [ 1104.521414] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
ply_event_loop_n[ 1104.521414] Stack:
ew: Assertion `l[ 1104.521414]  ce071f70oop->epoll_fd >= c1008a09 0' failed.
 ce071f88 c1009250 22af12a3 311297c7 6b5d3c03 cfff9fa0
[ 1104.521414]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 db8c449d 6b5d3c03
--
[    5.014137] Freeing unused kernel memory: 460k freed
[ 1104.514173] BUG: soft lockup - CPU#1 stuck for 1024s! [init:1]
[ 1104.514173] irq event stamp: 745706
[ 1104.514173] hardirqs last  enabled at (745705): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1104.514173] hardirqs last disabled at (745706): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1104.514173] softirqs last  enabled at (741514): [<c102e8ff>] __do_softirq+0x131/0x153
[ 1104.514173] softirqs last disabled at (741501): [<c1003f90>] do_softirq+0x74/0xdf
[ 1104.514173] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1104.514173] EIP: 0060:[<c105e677>] EFLAGS: 00000202 CPU: 1
[ 1104.522897] [sched_delayed] sched: RT throttling activated
[ 1104.514173] EIP is at current_kernel_time+0x10/0x48
[ 1104.514173] EAX: 000003f3 EBX: ce02d800 ECX: 00020001 EDX: 0000001d
[ 1104.514173] ESI: c797d300 EDI: 00000000 EBP: ce043e50 ESP: ce043e48
[ 1104.514173]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.514173] CR0: 8005003b CR2: b7762000 CR3: 0eec0000 CR4: 00000690
[ 1104.514173] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.514173] DR6: ffff0ff0 DR7: 00000400
[ 1104.514173] Process init (pid: 1, ti=ce042000 task=ce048000 task.ti=ce042000)
[ 1104.514173] Stack:
[ 1104.514173]  c797d300 00000000 ce043e5c c102de8e c70ca210 ce043e7c c10dd8d0 00000001
[ 1104.514173]  00000041 0000001d cf83a3c0 00000001 00000001 ce043ecc c10cf835 00000041
[ 1104.514173]  cf83a40c ce048000 cf869c00 00000008 00000000 c70ca298 c797d300 00000010
[ 1104.514173] Call Trace:
[ 1104.514173]  [<c102de8e>] current_fs_time+0xb/0x19
[ 1104.514173]  [<c10dd8d0>] file_update_time+0x21/0x91
[ 1104.514173]  [<c10cf835>] pipe_write+0x3bf/0x3cf
[ 1104.514173]  [<c10c80a1>] do_sync_write+0x75/0xb0
[ 1104.514173]  [<c10c8169>] vfs_write+0x8d/0x10f
[ 1104.514173]  [<c10c802c>] ? vfs_read+0x10d/0x10d
[ 1104.514173]  [<c10c8289>] sys_write+0x3d/0x61
[ 1104.514173]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.514173] Code: a1 c1 0f ad fe d3 ef f6 c1 20 74 04 89 fe 31 ff a1 70 d6 a1 c1 89 f2 5e 5f 5d c3 55 89 e5 57 56 a1 b4 d6 a1 c1 a8 01 74 04 f3 90 <eb> f3 8b 15 70 d6 a1 c1 8b 35 78 d6 a1 c1 8b 3d 7c d6 a1 c1 8b
[ 1104.514173] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.514173] Pid: 1, comm: init Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1104.514173] Call Trace:
[ 1104.514173]  [<c1673678>] panic+0x97/0x1aa
[ 1104.514173]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1104.514173]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.514173]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1104.514173]  [<c103205a>] run_local_timers+0x8/0x14
[ 1104.514173]  [<c103208a>] update_process_times+0x24/0x58
[ 1104.514173]  [<c106276e>] tick_periodic+0x66/0x72
[ 1104.514173]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1104.514173]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.514173]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.514173]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1104.514173]  [<c167007b>] ? kvm_guest_cpu_init+0x10b/0x214
[ 1104.514173]  [<c105e677>] ? current_kernel_time+0x10/0x48
[ 1104.514173]  [<c102de8e>] current_fs_time+0xb/0x19
[ 1104.514173]  [<c10dd8d0>] file_update_time+0x21/0x91
[ 1104.514173]  [<c10cf835>] pipe_write+0x3bf/0x3cf
[ 1104.514173]  [<c10c80a1>] do_sync_write+0x75/0xb0
[ 1104.514173]  [<c10c8169>] vfs_write+0x8d/0x10f
[ 1104.514173]  [<c10c802c>] ? vfs_read+0x10d/0x10d
[ 1104.514173]  [<c10c8289>] sys_write+0x3d/0x61
[ 1104.514173]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1104.514173] Rebooting in 10 seconds..
--
[    4.537105] Freeing unused kernel memory: 460k freed
[ 1103.514239] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1103.514239] irq event stamp: 7850
[ 1103.514239] hardirqs last  enabled at (7847): [<c167f085>] restore_all_notrace+0x0/0x18
[ 1103.514239] hardirqs last disabled at (7848): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.514239] softirqs last  enabled at (7850): [<c102e637>] _local_bh_enable+0xd/0xf
[ 1103.514239] softirqs last disabled at (7849): [<c102eac7>] irq_enter+0x2c/0x4d
[ 1103.514239] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.514239] EIP: 0060:[<c101da32>] EFLAGS: 00000286 CPU: 1
[ 1103.514239] EIP is at native_safe_halt+0x5/0x7
[ 1103.514239] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1103.514239] ESI: c19716f0 EDI: ffff8b9d EBP: ce071f68 ESP: ce071f68
[ 1103.523641] [sched_delayed] sched: RT throttling activated
[ 1103.514239]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.514239] CR0: 8005003b CR2: b7677fb8 CR3: 0ee96000 CR4: 00000690
[ 1103.514239] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.514239] DR6: ffff0ff0 DR7: 00000400
[ 1103.514239] Process swapper/1 (pid: 0, ti=ce070000 task=ce06a260 task.ti=ce070000)
[ 1103.514239] Stack:
[ 1103.514239]  ce071f70 c1008a09 ce071f88 c1009250 d5b8c18f e41c46af 1e665633 cfff9fa0
[ 1103.514239]  ce071fb4 c166ed10 00000000 00000000 00000000 00000000 8e955ed0 1e665633
[ 1103.514239]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1103.514239] Call Trace:
[ 1103.514239]  [<c1008a09>] default_idle+0x2f/0x55
[ 1103.514239]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1103.514239]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1103.514239] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1103.514239] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.514239] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.514239] Call Trace:
[ 1103.514239]  [<c1673678>] panic+0x97/0x1aa
[ 1103.514239]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.514239]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.514239]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.514239]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.514239]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.514239]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.514239]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.514239]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.514239]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.514239]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.514239]  [<c101da32>] ? native_safe_halt+0x5/0x7
[ 1103.514239]  [<c1008a09>] default_idle+0x2f/0x55
[ 1103.514239]  [<c1009250>] cpu_idle+0xc9/0xfb
[ 1103.514239]  [<c166ed10>] start_secondary+0x292/0x29a
[ 1103.514239] Rebooting in 10 seconds..
--
[    6.525425] Freeing unused kernel memory: 464k freed
[ 1105.523006] BUG: soft lockup - CPU#1 stuck for 1023s! [99-trinity:133]
[ 1105.523006] irq event stamp: 632
[ 1105.523006] hardirqs last  enabled at (631): [<c166e268>] __mutex_unlock_slowpath+0x114/0x12c
[ 1105.523006] hardirqs last disabled at (632): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1105.523006] softirqs last  enabled at (0): [<c10252e4>] copy_process+0x471/0xf82
[ 1105.523006] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1105.523006] Pid: 133, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1105.523006] EIP: 0060:[<c1064141>] EFLAGS: 00000202 CPU: 1
[ 1105.523006] EIP is at lockdep_trace_alloc+0x3/0xe0
[ 1105.523006] EAX: 000280da EBX: 000280da ECX: c1958810 EDX: 00000000
[ 1105.523006] ESI: 0000000a EDI: ce807680 EBP: ce8a3d5c ESP: ce8a3d5c
[ 1105.523006]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.523006] CR0: 80050033 CR2: b75e5baf CR3: 0e868000 CR4: 00000690
[ 1105.523006] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.523006] DR6: ffff0ff0 DR7: 00000400
[ 1105.523006] Process 99-trinity (pid: 133, ti=ce8a2000 task=ce8a8000 task.ti=ce8a2000)
[ 1105.523006] Stack:
[ 1105.523006]  ce8a3dfc c109a6d2 ce8a8000 00000040 00000006 c1bc8eb4 ce8a8458 ce8a8000
[ 1105.523006]  ce8a3da0 c1063a52 00000378 00000007 00000000 00000000 ce8a8000 c1900ad8
[ 1105.523006]  ce8a3db4 00000286 00000286 000000aa c181b224 00000000 ce8a3ddc 00000286
[ 1105.523006] Call Trace:
[ 1105.523006]  [<c109a6d2>] __alloc_pages_nodemask+0x78/0x5db
[ 1105.523006]  [<c1063a52>] ? mark_held_locks+0xa7/0xce
[ 1105.523006]  [<c10b19e1>] ? anon_vma_prepare+0x24/0x131
[ 1105.523006]  [<c10abbdd>] handle_pte_fault+0x16b/0x74c
[ 1105.523006]  [<c1020637>] ? kmap_atomic_prot+0x11f/0x133
[ 1105.523006]  [<c10ac253>] handle_mm_fault+0x95/0xa4
[ 1105.523006]  [<c10ac545>] __get_user_pages+0x264/0x39e
[ 1105.523006]  [<c10ac71d>] get_user_pages+0x4b/0x53
[ 1105.523006]  [<c10c3f2f>] get_arg_page+0x4a/0xa9
[ 1105.523006]  [<c10c408c>] copy_strings+0xfe/0x1c6
[ 1105.523006]  [<c10c44e9>] copy_strings_kernel+0x1c/0x2b
[ 1105.523006]  [<c10c56ff>] do_execve+0x343/0x456
[ 1105.523006]  [<c10c54a7>] ? do_execve+0xeb/0x456
[ 1105.523006]  [<c1009135>] sys_execve+0x31/0x53
[ 1105.523006]  [<c16718e2>] ptregs_execve+0x12/0x20
[ 1105.523006]  [<c16717e3>] ? sysenter_do_call+0x12/0x38
[ 1105.523006] Code: 3d 1c b7 95 c1 01 74 16 ba 9a 0a 00 00 b8 8b 35 81 c1 e8 7e 26 fc ff c6 05 1c b7 95 c1 01 64 ff 05 bc dc 9c c1 5b 5d c3 55 89 e5 <57> 56 53 89 c6 64 8b 1d 28 c6 9c c1 83 bb 54 04 00 00 00 0f 85
[ 1105.523006] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.523006] Pid: 133, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1105.523006] Call Trace:
[ 1105.523006]  [<c1664e92>] panic+0x81/0x194
[ 1105.523006]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1105.523006]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.523006]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1105.523006]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1105.523006]  [<c10306d2>] update_process_times+0x24/0x58
[ 1105.523006]  [<c1061092>] tick_periodic+0x66/0x72
[ 1105.523006]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1105.523006]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.523006]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.523006]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1105.523006]  [<c1064141>] ? lockdep_trace_alloc+0x3/0xe0
[ 1105.523006]  [<c109a6d2>] __alloc_pages_nodemask+0x78/0x5db
[ 1105.523006]  [<c1063a52>] ? mark_held_locks+0xa7/0xce
[ 1105.523006]  [<c10b19e1>] ? anon_vma_prepare+0x24/0x131
[ 1105.581916]  [<c10abbdd>] handle_pte_fault+0x16b/0x74c
[ 1105.581916]  [<c1020637>] ? kmap_atomic_prot+0x11f/0x133
[ 1105.581916]  [<c10ac253>] handle_mm_fault+0x95/0xa4
[ 1105.581916]  [<c10ac545>] __get_user_pages+0x264/0x39e
[ 1105.581916]  [<c10ac71d>] get_user_pages+0x4b/0x53
[ 1105.581916]  [<c10c3f2f>] get_arg_page+0x4a/0xa9
[ 1105.581916]  [<c10c408c>] copy_strings+0xfe/0x1c6
[ 1105.581916]  [<c10c44e9>] copy_strings_kernel+0x1c/0x2b
[ 1105.581916]  [<c10c56ff>] do_execve+0x343/0x456
[ 1105.581916]  [<c10c54a7>] ? do_execve+0xeb/0x456
[ 1105.581916]  [<c1009135>] sys_execve+0x31/0x53
[ 1105.581916]  [<c16718e2>] ptregs_execve+0x12/0x20
[ 1105.581916]  [<c16717e3>] ? sysenter_do_call+0x12/0x38
[ 1105.581916] Rebooting in 10 seconds..
--
[    4.563976] Freeing unused kernel memory: 464k freed
[ 1103.520656] BUG: soft lockup - CPU#1 stuck for 1023s! [shutdown:135]
[ 1103.520656] irq event stamp: 2580
[ 1103.520656] hardirqs last  enabled at (2579): [<c166b883>] mutex_lock_nested+0x2da/0x308
[ 1103.520656] hardirqs last disabled at (2580): [<c166f4bf>] apic_timer_interrupt+0x2f/0x40
[ 1103.520656] softirqs last  enabled at (0): [<c1025204>] copy_process+0x471/0xf82
mountall: ply-ev[ 1103.520656] softirqs last disabled at (0): ent-loop.c:497: [<  (null)>]   (null)
ply_event_loop_n[ 1103.520656] Pid: 135, comm: shutdown Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86  
ew: Assertion `l[ 1103.520656] EIP: 0060:[<c166b893>] EFLAGS: 00000286 CPU: 1
[ 1103.520656] EIP is at mutex_lock_nested+0x2ea/0x308
[ 1103.520656] EAX: 00000286 EBX: cb4e699c ECX: 00000006 EDX: cf8826c8
[ 1103.520656] ESI: ce82dbb0 EDI: ce873d7c EBP: ce873d98 ESP: ce873d5c
[ 1103.520656]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.520656] CR0: 8005003b CR2: b77911b8 CR3: 0e88b000 CR4: 00000690
[ 1103.520656] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
oop->epoll_fd >=[ 1103.520656] DR6: ffff0ff0 DR7: 00000400
[ 1103.520656] Process shutdown (pid: 135, ti=ce872000 task=cf882240 task.ti=ce872000)
 0' failed.
[ 1103.520656] Stack:
[ 1103.520656]  00000000 00000002 00000000 c10addf7 cb4e69c0 cf882240 cb4e69a0 00000286
[ 1103.520656]  ce873d7c ce873d7c 00000000 ce873d7c ce82d790 ce82dbb0 00000000 ce873dec
[ 1103.520656]  c10addf7 00000000 00000000 00000000 00000000 b775e000 ce0f6400 00000000
[ 1103.520656] Call Trace:
[ 1103.520656]  [<c10addf7>] ? vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10addf7>] vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10ae0bb>] __split_vma+0xea/0x13e
[ 1103.520656]  [<c10ae8fd>] do_munmap+0xab/0x24b
[ 1103.520656]  [<c10aeacd>] vm_munmap+0x30/0x41
[ 1103.520656]  [<c166505c>] elf_map+0x80/0xa6
[ 1103.520656]  [<c10f0e65>] load_elf_binary+0x7b7/0xfbd
[ 1103.520656]  [<c10c51f6>] search_binary_handler+0x14d/0x22b
[ 1103.520656]  [<c10c50e3>] ? search_binary_handler+0x3a/0x22b
[ 1103.520656]  [<c10f06ae>] ? load_elf_library+0x1bb/0x1bb
[ 1103.520656]  [<c10c565f>] do_execve+0x38b/0x456
[ 1103.520656]  [<c10c53bf>] ? do_execve+0xeb/0x456
[ 1103.520656]  [<c1009135>] sys_execve+0x31/0x53
[ 1103.520656]  [<c166faa2>] ptregs_execve+0x12/0x20
[ 1103.520656]  [<c166f9a3>] ? sysenter_do_call+0x12/0x38
[ 1103.520656] Code: d4 8f c1 00 74 1e 8b 45 e0 50 9d 8d 74 26 00 e8 5b 81 9f ff eb 19 e8 2a 80 9f ff 83 3d 6c d4 8f c1 00 75 02 0f 0b 8b 45 e0 50 9d <8d> 74 26 00 8d 45 e4 e8 c0 5f 9f ff 89 e0 25 00 e0 ff ff ff 48
[ 1103.520656] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.520656] Pid: 135, comm: shutdown Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86
[ 1103.520656] Call Trace:
[ 1103.520656]  [<c1662a5f>] panic+0x81/0x194
[ 1103.520656]  [<c107e1de>] watchdog_timer_fn+0x115/0x134
[ 1103.520656]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.520656]  [<c107e0c9>] ? __touch_watchdog+0x1d/0x1d
[ 1103.520656]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1103.520656]  [<c10305f6>] update_process_times+0x24/0x58
[ 1103.520656]  [<c1060d2e>] tick_periodic+0x66/0x72
[ 1103.520656]  [<c1060d88>] tick_handle_periodic+0x19/0x61
[ 1103.520656]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.520656]  [<c12aa260>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.520656]  [<c166f4c6>] apic_timer_interrupt+0x36/0x40
[ 1103.520656]  [<c166b893>] ? mutex_lock_nested+0x2ea/0x308
[ 1103.520656]  [<c10addf7>] ? vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10addf7>] vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10ae0bb>] __split_vma+0xea/0x13e
[ 1103.520656]  [<c10ae8fd>] do_munmap+0xab/0x24b
[ 1103.520656]  [<c10aeacd>] vm_munmap+0x30/0x41
[ 1103.520656]  [<c166505c>] elf_map+0x80/0xa6
[ 1103.520656]  [<c10f0e65>] load_elf_binary+0x7b7/0xfbd
[ 1103.520656]  [<c10c51f6>] search_binary_handler+0x14d/0x22b
[ 1103.520656]  [<c10c50e3>] ? search_binary_handler+0x3a/0x22b
[ 1103.520656]  [<c10f06ae>] ? load_elf_library+0x1bb/0x1bb
[ 1103.520656]  [<c10c565f>] do_execve+0x38b/0x456
[ 1103.520656]  [<c10c53bf>] ? do_execve+0xeb/0x456
[ 1103.520656]  [<c1009135>] sys_execve+0x31/0x53
[ 1103.520656]  [<c166faa2>] ptregs_execve+0x12/0x20
[ 1103.520656]  [<c166f9a3>] ? sysenter_do_call+0x12/0x38
[ 1103.520656] Rebooting in 10 seconds..
--
[ 1103.521634] [sched_delayed] sched: RT throttling activated
[ 1103.523066] BUG: soft lockup - CPU#1 stuck for 1023s! [hwclock:126]
[ 1103.523066] irq event stamp: 7436
[ 1103.523066] hardirqs last  enabled at (7435): [<c167e841>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.523066] hardirqs last disabled at (7436): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.523066] softirqs last  enabled at (3224): [<c1601126>] unix_sock_destructor+0xae/0xb3
[ 1103.523066] softirqs last disabled at (3222): [<c1601113>] unix_sock_destructor+0x9b/0xb3
[ 1103.523066] Pid: 126, comm: hwclock Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1103.523066] EIP: 0060:[<c167e850>] EFLAGS: 00000282 CPU: 1
[ 1103.523066] EIP is at _raw_spin_unlock_irqrestore+0x51/0x63
[ 1103.523066] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000007
[ 1103.523066] ESI: c1fa259c EDI: 00000000 EBP: ce891da4 ESP: ce891d9c
[ 1103.523066]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.523066] CR0: 8005003b CR2: b76b7fb8 CR3: 019f0000 CR4: 00000690
[ 1103.523066] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.523066] DR6: ffff0ff0 DR7: 00000400
[ 1103.523066] Process hwclock (pid: 126, ti=ce890000 task=cf89a260 task.ti=ce890000)
[ 1103.523066] Stack:
[ 1103.523066]  00000001 00000001 ce891dd8 c12c3bde ce891de0 00000282 c1fa2598 ce44d000
[ 1103.523066]  c1fa259c ce44c000 ce44c000 00000000 ce707980 00001000 00000000 ce891de0
[ 1103.523066]  c12c4324 ce891e04 c109bf2e 00000000 00000001 00000000 00000001 ce707a00
[ 1103.523066] Call Trace:
[ 1103.523066]  [<c12c3bde>] __debug_check_no_obj_freed+0xe4/0x137
[ 1103.523066]  [<c12c4324>] debug_check_no_obj_freed+0x11/0x15
[ 1103.523066]  [<c109bf2e>] free_pages_prepare+0x10a/0x10e
[ 1103.523066]  [<c109d0fa>] free_hot_cold_page+0x20/0x155
[ 1103.523066]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.523066]  [<c109d24c>] free_hot_cold_page_list+0x1d/0x31
[ 1103.523066]  [<c10a06a1>] release_pages+0x171/0x179
[ 1103.523066]  [<c10b9669>] free_pages_and_swap_cache+0x68/0x7b
[ 1103.523066]  [<c10ac647>] tlb_flush_mmu+0x56/0x6c
[ 1103.523066]  [<c10ac66f>] tlb_finish_mmu+0x12/0x31
[ 1103.523066]  [<c10b19f9>] exit_mmap+0x96/0xe4
[ 1103.523066]  [<c1025e1a>] mmput+0x42/0xa7
[ 1103.523066]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1103.523066]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1103.523066]  [<c102dd6d>] ? do_sys_settimeofday+0x88/0x93
[ 1103.523066]  [<c12b3946>] ? _copy_from_user+0x37/0x4b
[ 1103.523066]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1103.523066]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1103.523066]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1103.523066] Code: 3d 8c 20 91 c1 00 74 1d 89 d8 50 9d 8d 74 26 00 e8 dd 6b 9e ff eb 18 e8 ac 6a 9e ff 83 3d 8c 20 91 c1 00 75 02 0f 0b 89 d8 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5
[ 1103.523066] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.523066] Pid: 126, comm: hwclock Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1103.523066] Call Trace:
[ 1103.523066]  [<c1673678>] panic+0x97/0x1aa
[ 1103.523066]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.523066]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.523066]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.523066]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.523066]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.523066]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.523066]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.523066]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.523066]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.523066]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1103.523066]  [<c167e850>] ? _raw_spin_unlock_irqrestore+0x51/0x63
[ 1103.523066]  [<c12c3bde>] __debug_check_no_obj_freed+0xe4/0x137
[ 1103.523066]  [<c12c4324>] debug_check_no_obj_freed+0x11/0x15
[ 1103.523066]  [<c109bf2e>] free_pages_prepare+0x10a/0x10e
[ 1103.523066]  [<c109d0fa>] free_hot_cold_page+0x20/0x155
[ 1103.523066]  [<c167e841>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.523066]  [<c109d24c>] free_hot_cold_page_list+0x1d/0x31
[ 1103.523066]  [<c10a06a1>] release_pages+0x171/0x179
[ 1103.523066]  [<c10b9669>] free_pages_and_swap_cache+0x68/0x7b
[ 1103.523066]  [<c10ac647>] tlb_flush_mmu+0x56/0x6c
[ 1103.523066]  [<c10ac66f>] tlb_finish_mmu+0x12/0x31
[ 1103.523066]  [<c10b19f9>] exit_mmap+0x96/0xe4
[ 1103.523066]  [<c1025e1a>] mmput+0x42/0xa7
[ 1103.523066]  [<c102cab2>] exit_mm+0xde/0xe6
[ 1103.523066]  [<c102ce13>] do_exit+0x1d0/0x72c
[ 1103.523066]  [<c102dd6d>] ? do_sys_settimeofday+0x88/0x93
[ 1103.523066]  [<c12b3946>] ? _copy_from_user+0x37/0x4b
[ 1103.523066]  [<c102d3f6>] do_group_exit+0x5e/0x81
[ 1103.523066]  [<c102d42c>] sys_exit_group+0x13/0x13
[ 1103.523066]  [<c167f863>] sysenter_do_call+0x12/0x38
[ 1103.523066] Rebooting in 10 seconds..
--
[    4.801716] Freeing unused kernel memory: 460k freed
[ 1103.512941] BUG: soft lockup - CPU#1 stuck for 1023s! [sleep:134]
[ 1103.512941] irq event stamp: 780
[ 1103.512941] hardirqs last  enabled at (779): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1103.512941] hardirqs last disabled at (780): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.517007] softirqs last  enabled at (22): [<c102e8ff>] __do_softirq+0x131/0x153
--
[ 1105.513232] [sched_delayed] sched: RT throttling activated
[ 1105.513206] BUG: soft lockup - CPU#1 stuck for 1023s! [rc.local:123]
[ 1105.513206] irq event stamp: 326
[ 1105.513206] hardirqs last  enabled at (325): [<c106831d>] debug_check_no_locks_freed+0x14b/0x167
[ 1105.513206] hardirqs last disabled at (326): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1105.513206] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1105.513206] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1105.513206] Pid: 123, comm: rc.local Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1105.513206] EIP: 0060:[<c10df7c4>] EFLAGS: 00000246 CPU: 1
[ 1105.513206] EIP is at __mnt_drop_write+0x1/0x1a
[ 1105.513206] EAX: ce014110 EBX: cb438000 ECX: 00000000 EDX: 00000001
[ 1105.513206] ESI: ce014110 EDI: 00000000 EBP: ce879dbc ESP: ce879da4
[ 1105.513206]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.513206] CR0: 80050033 CR2: b7553baf CR3: 0e85a000 CR4: 00000690
[ 1105.513206] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.513206] DR6: ffff0ff0 DR7: 00000400
[ 1105.513206] Process rc.local (pid: 123, ti=ce878000 task=cf8ad5f0 task.ti=ce878000)
[ 1105.513206] Stack:
[ 1105.513206]  ce879dbc c10dd7bf 504bf223 ffffff88 ce889800 ce6a2f80 ce879e4c c1097f77
[ 1105.513206]  00001000 006f41e4 00000000 00000080 00000000 00000000 00000001 ce889884
[ 1105.513206]  ce879e90 00000000 00001000 00000080 00000000 cb438000 ce879ed4 00000000
[ 1105.513206] Call Trace:
[ 1105.513206]  [<c10dd7bf>] ? touch_atime+0xdc/0x104
[ 1105.513206]  [<c1097f77>] generic_file_aio_read+0x5b5/0x5f1
[ 1105.513206]  [<c10c78d1>] do_sync_read+0x75/0xb0
[ 1105.513206]  [<c10c7faa>] vfs_read+0x8b/0x10d
[ 1105.513206]  [<c10af901>] ? might_fault+0x26/0x99
[ 1105.513206]  [<c10c785c>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1105.513206]  [<c10cd050>] kernel_read+0x30/0x41
[ 1105.513206]  [<c10cd8d6>] prepare_binprm+0xfb/0x103
[ 1105.513206]  [<c10cdeaa>] do_execve+0x327/0x456
[ 1105.513206]  [<c10cdc6e>] ? do_execve+0xeb/0x456
[ 1105.546433]  [<c1009165>] sys_execve+0x31/0x53
[ 1105.546433]  [<c167f962>] ptregs_execve+0x12/0x20
[ 1105.546433]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1105.546433] Code: 00 00 e8 6c ba fe ff 89 d8 e8 91 ff ff ff 89 c6 85 c0 74 10 8b 43 08 8b 40 04 ba 01 00 00 00 e8 dd b9 fe ff 89 f0 5b 5e 5d c3 55 <89> e5 89 e2 81 e2 00 e0 ff ff ff 42 14 8b 40 0c 64 ff 48 04 ff
[ 1105.546433] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.546433] Pid: 123, comm: rc.local Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1105.546433] Call Trace:
[ 1105.546433]  [<c1673678>] panic+0x97/0x1aa
[ 1105.546433]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1105.546433]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.546433]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1105.546433]  [<c103205a>] run_local_timers+0x8/0x14
[ 1105.546433]  [<c103208a>] update_process_times+0x24/0x58
[ 1105.546433]  [<c106276e>] tick_periodic+0x66/0x72
[ 1105.546433]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1105.546433]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.546433]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.546433]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1105.546433]  [<c10d00d8>] ? pipe_fcntl+0xbc/0x140
[ 1105.546433]  [<c10df7c4>] ? __mnt_drop_write+0x1/0x1a
[ 1105.546433]  [<c10dd7bf>] ? touch_atime+0xdc/0x104
[ 1105.546433]  [<c1097f77>] generic_file_aio_read+0x5b5/0x5f1
[ 1105.546433]  [<c10c78d1>] do_sync_read+0x75/0xb0
[ 1105.546433]  [<c10c7faa>] vfs_read+0x8b/0x10d
[ 1105.546433]  [<c10af901>] ? might_fault+0x26/0x99
[ 1105.546433]  [<c10c785c>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1105.546433]  [<c10cd050>] kernel_read+0x30/0x41
[ 1105.546433]  [<c10cd8d6>] prepare_binprm+0xfb/0x103
[ 1105.546433]  [<c10cdeaa>] do_execve+0x327/0x456
[ 1105.546433]  [<c10cdc6e>] ? do_execve+0xeb/0x456
[ 1105.546433]  [<c1009165>] sys_execve+0x31/0x53
[ 1105.546433]  [<c167f962>] ptregs_execve+0x12/0x20
[ 1105.546433]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1105.546433] Rebooting in 10 seconds..
--
[    4.563365] Freeing unused kernel memory: 464k freed
[ 1103.514494] BUG: soft lockup - CPU#1 stuck for 1024s! [rc.local:122]
[ 1103.514494] irq event stamp: 8
[ 1103.514494] hardirqs last  enabled at (7): [<c101cfda>] do_page_fault+0x98/0x36e
[ 1103.514494] hardirqs last disabled at (8): [<c166f4bf>] apic_timer_interrupt+0x2f/0x40
[ 1103.514494] softirqs last  enabled at (0): [<c1025204>] copy_process+0x471/0xf82
[ 1103.514494] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1103.514494] Pid: 122, comm: rc.local Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86  
[ 1103.520829] [sched_delayed] sched: RT throttling activated
[ 1103.514494] EIP: 0060:[<c10ae5c3>] EFLAGS: 00000212 CPU: 1
[ 1103.514494] EIP is at find_vma+0x48/0x68
[ 1103.514494] EAX: ce816780 EBX: ceea0d68 ECX: ceea0ddc EDX: b7654d0c
[ 1103.514494] ESI: ce849fb4 EDI: c101c2e6 EBP: ce849f20 ESP: ce849f1c
[ 1103.514494]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.514494] CR0: 8005003b CR2: b7654d0c CR3: 0e842000 CR4: 00000690
[ 1103.514494] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.514494] DR6: ffff0ff0 DR7: 00000400
[ 1103.514494] Process rc.local (pid: 122, ti=ce848000 task=cf1fd5a0 task.ti=ce848000)
[ 1103.514494] Stack:
[ 1103.514494]  ce849fb4 ce849f9c c101d0e5 00000000 00000000 cf1fd5a0 ce8167d4 ce816780
[ 1103.514494]  cf1fd5a0 00000028 00000004 b7654d0c c12aa250 00000001 00000003 00000000
[ 1103.514494]  c166e9b5 bffffffd b75a0728 00000000 00000001 ce816780 00000007 00000006
[ 1103.514494] Call Trace:
[ 1103.514494]  [<c101d0e5>] do_page_fault+0x1a3/0x36e
[ 1103.514494]  [<c12aa250>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 1103.514494]  [<c166e9b5>] ? restore_all+0xf/0xf
[ 1103.514494]  [<c166e9b5>] ? restore_all+0xf/0xf
[ 1103.514494]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.514494]  [<c101c309>] do_async_page_fault+0x23/0x5f
[ 1103.514494]  [<c166f6fc>] error_code+0x6c/0x80
[ 1103.514494] Code: e8 2e 81 f7 ff c6 05 05 94 95 c1 01 eb 38 8b 58 08 85 db 74 0a 39 53 08 76 05 39 53 04 76 27 8b 48 04 31 db eb 15 39 51 ec 76 0d <8d> 59 e4 39 51 e8 76 0c 8b 49 08 eb 03 8b 49 04 85 c9 75 e7 85
[ 1103.514494] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.514494] Pid: 122, comm: rc.local Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86
[ 1103.514494] Call Trace:
[ 1103.514494]  [<c1662a5f>] panic+0x81/0x194
[ 1103.514494]  [<c107e1de>] watchdog_timer_fn+0x115/0x134
[ 1103.514494]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.514494]  [<c107e0c9>] ? __touch_watchdog+0x1d/0x1d
[ 1103.514494]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1103.514494]  [<c10305f6>] update_process_times+0x24/0x58
[ 1103.514494]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.514494]  [<c1060d2e>] tick_periodic+0x66/0x72
[ 1103.514494]  [<c1060d88>] tick_handle_periodic+0x19/0x61
[ 1103.514494]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.514494]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.514494]  [<c12aa260>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.514494]  [<c166f4c6>] apic_timer_interrupt+0x36/0x40
[ 1103.514494]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.514494]  [<c101007b>] ? intel_pmu_lbr_init_core+0x34/0x3a
[ 1103.514494]  [<c10400e0>] ? posix_cpu_timer_set+0x29e/0x361
[ 1103.514494]  [<c10ae5c3>] ? find_vma+0x48/0x68
[ 1103.514494]  [<c101d0e5>] do_page_fault+0x1a3/0x36e
[ 1103.514494]  [<c12aa250>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 1103.514494]  [<c166e9b5>] ? restore_all+0xf/0xf
[ 1103.514494]  [<c166e9b5>] ? restore_all+0xf/0xf
[ 1103.514494]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.514494]  [<c101c309>] do_async_page_fault+0x23/0x5f
[ 1103.514494]  [<c166f6fc>] error_code+0x6c/0x80
[ 1103.514494] Rebooting in 10 seconds..
--
[    4.379731] Freeing unused kernel memory: 464k freed
[ 1103.518739] BUG: soft lockup - CPU#1 stuck for 1024s! [init:1]
[ 1103.518739] irq event stamp: 761948
[ 1103.518739] hardirqs last  enabled at (761947): [<c101cfda>] do_page_fault+0x98/0x36e
[ 1103.518739] hardirqs last disabled at (761948): [<c166f4bf>] apic_timer_interrupt+0x2f/0x40
[ 1103.518739] softirqs last  enabled at (761912): [<c15f048e>] unix_accept+0xd2/0xe8
[ 1103.518739] softirqs last disabled at (761910): mountall: ply-ev[<c166e66a>] _raw_write_lock_bh+0xe/0x4f
ent-loop.c:497: [ 1103.518739] Pid: 1, comm: init Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86  
ply_event_loop_n[ 1103.518739] EIP: 0060:[<c1065aea>] EFLAGS: 00000286 CPU: 1
ew: Assertion `l[ 1103.518739] EIP is at lock_release+0x194/0x19f
oop->epoll_fd >=[ 1103.518739] EAX: 00000286 EBX: ce040000 ECX: 0000036f EDX: 0000036f
 0' failed.
[ 1103.518739] ESI: 0000036f EDI: 00000000 EBP: ce03de60 ESP: ce03de4c
[ 1103.528082] [sched_delayed] sched: RT throttling activated
[ 1103.518739]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.518739] CR0: 80050033 CR2: b7665b90 CR3: 0f1ea000 CR4: 00000690
[ 1103.518739] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.518739] DR6: ffff0ff0 DR7: 00000400
[ 1103.518739] Process init (pid: 1, ti=ce03c000 task=ce040000 task.ti=ce03c000)
[ 1103.518739] Stack:
[ 1103.518739]  00000001 00000286 ce116534 00000000 00000000 ce03de6c c166e11b ce68afe0
[ 1103.518739]  ce03deb8 c10a95e0 c10acb05 ce116534 cf1eb994 00000000 b7665b90 ce116500
[ 1103.518739]  00000000 00000200 cf81cf20 0a5ff025 00000028 0000000a b7665000 ce68afe0
[ 1103.518739] Call Trace:
[ 1103.518739]  [<c166e11b>] _raw_spin_unlock+0x16/0x2a
[ 1103.518739]  [<c10a95e0>] __do_fault+0x2fa/0x38a
[ 1103.518739]  [<c10acb05>] ? might_fault+0x90/0x97
[ 1103.518739]  [<c10abbf5>] handle_pte_fault+0x2c3/0x74c
[ 1103.518739]  [<c102055f>] ? kmap_atomic_prot+0x11f/0x133
[ 1103.518739]  [<c10ac113>] handle_mm_fault+0x95/0xa4
[ 1103.518739]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.518739]  [<c101d278>] do_page_fault+0x336/0x36e
[ 1103.518739]  [<c12aa4e6>] ? _copy_from_user+0x37/0x4b
[ 1103.518739]  [<c159f160>] ? sys_socketcall+0xf1/0x2b2
[ 1103.518739]  [<c166e9b5>] ? restore_all+0xf/0xf
[ 1103.518739]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.518739]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.518739]  [<c101c309>] do_async_page_fault+0x23/0x5f
[ 1103.518739]  [<c166f6fc>] error_code+0x6c/0x80
[ 1103.518739] Code: 85 c0 74 07 89 d8 e8 0a c5 ff ff 64 a1 28 a6 9c c1 c7 80 54 04 00 00 00 00 00 00 83 3d 6c d4 8f c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 5f 58 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 20 89
[ 1103.518739] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.518739] Pid: 1, comm: init Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86
[ 1103.518739] Call Trace:
[ 1103.518739]  [<c1662a5f>] panic+0x81/0x194
[ 1103.518739]  [<c107e1de>] watchdog_timer_fn+0x115/0x134
[ 1103.518739]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.518739]  [<c107e0c9>] ? __touch_watchdog+0x1d/0x1d
[ 1103.518739]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1103.518739]  [<c10305f6>] update_process_times+0x24/0x58
[ 1103.518739]  [<c1060d2e>] tick_periodic+0x66/0x72
[ 1103.518739]  [<c1060d88>] tick_handle_periodic+0x19/0x61
[ 1103.518739]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.518739]  [<c12aa260>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.518739]  [<c166f4c6>] apic_timer_interrupt+0x36/0x40
[ 1103.518739]  [<c1065aea>] ? lock_release+0x194/0x19f
[ 1103.518739]  [<c166e11b>] _raw_spin_unlock+0x16/0x2a
[ 1103.518739]  [<c10a95e0>] __do_fault+0x2fa/0x38a
[ 1103.518739]  [<c10acb05>] ? might_fault+0x90/0x97
[ 1103.518739]  [<c10abbf5>] handle_pte_fault+0x2c3/0x74c
[ 1103.518739]  [<c102055f>] ? kmap_atomic_prot+0x11f/0x133
[ 1103.518739]  [<c10ac113>] handle_mm_fault+0x95/0xa4
[ 1103.518739]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.518739]  [<c101d278>] do_page_fault+0x336/0x36e
[ 1103.518739]  [<c12aa4e6>] ? _copy_from_user+0x37/0x4b
[ 1103.518739]  [<c159f160>] ? sys_socketcall+0xf1/0x2b2
[ 1103.518739]  [<c166e9b5>] ? restore_all+0xf/0xf
[ 1103.518739]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.518739]  [<c101c2e6>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.518739]  [<c101c309>] do_async_page_fault+0x23/0x5f
[ 1103.518739]  [<c166f6fc>] error_code+0x6c/0x80
[ 1103.518739] Rebooting in 10 seconds..
--
[    5.795207] Freeing unused kernel memory: 464k freed
[ 1104.515634] BUG: soft lockup - CPU#1 stuck for 1023s! [99-trinity:126]
[ 1104.515634] irq event stamp: 732
[ 1104.515634] hardirqs last  enabled at (731): [<c101cfce>] do_page_fault+0x98/0x36e
[ 1104.515634] hardirqs last disabled at (732): [<c166ecff>] apic_timer_interrupt+0x2f/0x40
[ 1104.515634] softirqs last  enabled at (0): [<c1025204>] copy_process+0x471/0xf82
[ 1104.515634] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.515634] Pid: 126, comm: 99-trinity Not tainted 3.5.0-bisect2-01297-ga17f29a #84  
[ 1104.515634] EIP: 0060:[<c1064337>] EFLAGS: 00000286 CPU: 1
[ 1104.515634] EIP is at lock_is_held+0x9f/0xb2
[ 1104.515634] EAX: 00000286 EBX: 00000001 ECX: 00000000 EDX: 00000000
[ 1104.515634] ESI: ce859120 EDI: c18feae8 EBP: ce869ef8 ESP: ce869ee8
[ 1104.515634]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.515634] CR0: 8005003b CR2: b7779ee0 CR3: 0e849000 CR4: 00000690
[ 1104.515634] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.515634] DR6: ffff0ff0 DR7: 00000400
[ 1104.515634] Process 99-trinity (pid: 126, ti=ce868000 task=ce859120 task.ti=ce868000)
[ 1104.515634] Stack:
[ 1104.515634]  00000286 0000046c c180ae2c 00000000 ce869f20 c1049cb6 c101c2da ce869f20
[ 1104.515634]  c10415f1 00000001 00000002 ce869fb4 ce869fb4 c101c2da ce869f9c c101d0c9
[ 1104.515634]  00000028 00000000 00000000 ce834f54 ce834f00 ce859120 00000029 00000007
[ 1104.515634] Call Trace:
[ 1104.515634]  [<c1049cb6>] __might_sleep+0x66/0x1cd
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c10415f1>] ? down_read_trylock+0x51/0x59
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c101d0c9>] do_page_fault+0x193/0x36e
[ 1104.515634]  [<c104168e>] ? up_write+0x16/0x2b
[ 1104.515634]  [<c10a3f6b>] ? vm_mmap_pgoff+0x50/0x59
[ 1104.515634]  [<c166e1f5>] ? restore_all+0xf/0xf
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c101c2fd>] do_async_page_fault+0x23/0x5f
[ 1104.515634]  [<c166ef3c>] error_code+0x6c/0x80
[ 1104.515634] Code: 7c e2 31 c9 eb 05 b9 01 00 00 00 64 a1 28 a6 9c c1 c7 80 54 04 00 00 00 00 00 00 83 3d 6c d4 8f c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 eb 05 b9 01 00 00 00 89 c8 5b 5b 5e 5f 5d c3 55 89
[ 1104.515634] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.515634] Pid: 126, comm: 99-trinity Not tainted 3.5.0-bisect2-01297-ga17f29a #84
[ 1104.515634] Call Trace:
[ 1104.515634]  [<c16622f2>] panic+0x81/0x194
[ 1104.515634]  [<c107e1d2>] watchdog_timer_fn+0x115/0x134
[ 1104.515634]  [<c10413fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.515634]  [<c107e0bd>] ? __touch_watchdog+0x1d/0x1d
[ 1104.515634]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1104.515634]  [<c10305f6>] update_process_times+0x24/0x58
[ 1104.515634]  [<c1060d92>] tick_periodic+0x66/0x72
[ 1104.515634]  [<c1060dec>] tick_handle_periodic+0x19/0x61
[ 1104.515634]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.515634]  [<c12aa840>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.515634]  [<c166ed06>] apic_timer_interrupt+0x36/0x40
[ 1104.515634]  [<c1064337>] ? lock_is_held+0x9f/0xb2
[ 1104.515634]  [<c1049cb6>] __might_sleep+0x66/0x1cd
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c10415f1>] ? down_read_trylock+0x51/0x59
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c101d0c9>] do_page_fault+0x193/0x36e
[ 1104.515634]  [<c104168e>] ? up_write+0x16/0x2b
[ 1104.515634]  [<c10a3f6b>] ? vm_mmap_pgoff+0x50/0x59
[ 1104.515634]  [<c166e1f5>] ? restore_all+0xf/0xf
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515634]  [<c101c2fd>] do_async_page_fault+0x23/0x5f
[ 1104.515634]  [<c166ef3c>] error_code+0x6c/0x80
[ 1104.515634] Rebooting in 10 seconds..
--
[    4.912862] Freeing unused kernel memory: 460k freed
[ 1103.516433] BUG: soft lockup - CPU#1 stuck for 1023s! [99-trinity:128]
[ 1103.516433] irq event stamp: 32
[ 1103.516433] hardirqs last  enabled at (31): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1103.516433] hardirqs last disabled at (32): [<c167f36f>] apic_timer_interrupt+0x2f/0x40
[ 1103.516433] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1103.516433] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1103.516433] Pid: 128, comm: 99-trinity Not tainted 3.6.0-rc1-bisect2 #80  
[ 1103.516433] EIP: 0060:[<c109bf33>] EFLAGS: 00000202 CPU: 1
[ 1103.516433] EIP is at get_page_from_freelist+0x1/0x456
[ 1103.516433] EAX: 000200da EBX: 000200da ECX: 00000000 EDX: 00000000
[ 1103.516433] ESI: 00000003 EDI: c196cfa0 EBP: ce857e78 ESP: ce857de0
[ 1103.516433]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.516433] CR0: 8005003b CR2: b7779460 CR3: 0e878000 CR4: 00000690
[ 1103.516433] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.516433] DR6: ffff0ff0 DR7: 00000400
[ 1103.516433] Process 99-trinity (pid: 128, ti=ce856000 task=cf8b2260 task.ti=ce856000)
[ 1103.516433] Stack:
[ 1103.516433]  ce857e78 c109c83a c196cfa0 00000003 00000041 c196c490 00000002 c1823e91
[ 1103.516433]  00000000 ce857e2c 00000000 00000000 cf8b2260 c1913698 ce857e30 00000282
[ 1103.516433]  00000282 000000aa c182c5ad 000200da 00000010 00000282 0000037b 0000037b
[ 1103.516433] Call Trace:
[ 1103.516433]  [<c109c83a>] ? __alloc_pages_nodemask+0x11e/0x5f3
[ 1103.516433]  [<c10b47b1>] ? anon_vma_prepare+0x24/0x131
[ 1103.516433]  [<c10ace14>] do_wp_page+0x40d/0x63c
[ 1103.516433]  [<c167e689>] ? _raw_spin_lock+0x44/0x4a
[ 1103.516433]  [<c10aecb2>] handle_pte_fault+0x758/0x7a7
[ 1103.516433]  [<c10aeda2>] handle_mm_fault+0xa1/0xb0
[ 1103.516433]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.516433]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1103.516433]  [<c12b3690>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 1103.516433]  [<c167f065>] ? restore_all+0xf/0xf
[ 1103.516433]  [<c167f065>] ? restore_all+0xf/0xf
[ 1103.516433]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.516433]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.516433]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1103.516433]  [<c167f5ac>] error_code+0x6c/0x80
[ 1103.516433] Code: be 00 10 00 00 8a 4d e4 d3 e6 89 d8 e8 e6 f4 00 00 89 f2 e8 b2 c2 fc ff 89 d8 e8 d8 f4 00 00 89 f2 e8 c5 83 22 00 b0 01 eb ce 55 <89> e5 57 56 53 83 ec 5c 89 45 dc 89 55 c0 89 4d e4 8b 45 14 2b
[ 1103.516433] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.516433] Pid: 128, comm: 99-trinity Not tainted 3.6.0-rc1-bisect2 #80
[ 1103.516433] Call Trace:
[ 1103.516433]  [<c1673658>] panic+0x97/0x1aa
[ 1103.516433]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.516433]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.516433]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.516433]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.516433]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.516433]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.516433]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.516433]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.516433]  [<c12b36a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.516433]  [<c167f376>] apic_timer_interrupt+0x36/0x40
[ 1103.516433]  [<c109bf33>] ? get_page_from_freelist+0x1/0x456
[ 1103.516433]  [<c109c83a>] ? __alloc_pages_nodemask+0x11e/0x5f3
[ 1103.516433]  [<c10b47b1>] ? anon_vma_prepare+0x24/0x131
[ 1103.516433]  [<c10ace14>] do_wp_page+0x40d/0x63c
[ 1103.516433]  [<c167e689>] ? _raw_spin_lock+0x44/0x4a
[ 1103.516433]  [<c10aecb2>] handle_pte_fault+0x758/0x7a7
[ 1103.516433]  [<c10aeda2>] handle_mm_fault+0xa1/0xb0
[ 1103.516433]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.516433]  [<c101e870>] do_page_fault+0x336/0x36e
[ 1103.516433]  [<c12b3690>] ? trace_hardirqs_on_thunk+0xc/0x10
[ 1103.516433]  [<c167f065>] ? restore_all+0xf/0xf
[ 1103.516433]  [<c167f065>] ? restore_all+0xf/0xf
[ 1103.516433]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.516433]  [<c101d888>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.516433]  [<c101d8ab>] do_async_page_fault+0x23/0x5f
[ 1103.516433]  [<c167f5ac>] error_code+0x6c/0x80
[ 1103.516433] Rebooting in 10 seconds..
--
[    5.018929] Freeing unused kernel memory: 464k freed
[ 1104.515153] BUG: soft lockup - CPU#1 stuck for 1025s! [sh:135]
[ 1104.515153] irq event stamp: 3314
[ 1104.515153] hardirqs last  enabled at (3313): [<c16707f5>] restore_all_notrace+0x0/0x18
[ 1104.515153] hardirqs last disabled at (3314): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1104.515153] softirqs last  enabled at (3026): [<c15f31f2>] unix_sock_destructor+0xae/0xb3
[ 1104.515153] softirqs last disabled at (3024): [<c15f31df>] unix_sock_destructor+0x9b/0xb3
[ 1104.515153] Pid: 135, comm: sh Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1104.515153] EIP: 0060:[<c1095f63>] EFLAGS: 00000296 CPU: 1
[ 1104.515153] EIP is at generic_file_aio_read+0x27f/0x5f1
[ 1104.524187] [sched_delayed] sched: RT throttling activated
[ 1104.515153] EAX: ce688fe0 EBX: 00000001 ECX: 00000000 EDX: 00000000
[ 1104.515153] ESI: ffffffff EDI: 00000000 EBP: ce893ecc ESP: ce893e44
[ 1104.515153]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.515153] CR0: 80050033 CR2: b75d4198 CR3: 0e8a5000 CR4: 00000690
[ 1104.515153] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.515153] DR6: ffff0ff0 DR7: 00000400
[ 1104.515153] Process sh (pid: 135, ti=ce892000 task=cf8b3360 task.ti=ce892000)
[ 1104.515153] Stack:
[ 1104.515153]  00000001 00000000 ce893e68 00000000 00000000 00000000 00000001 ce8a4c84
[ 1104.515153]  ce893f10 00000000 00000001 00000fff ffffffff cb4d6210 ce893f54 00000000
[ 1104.515153]  ce8a4c00 00000000 cb4d6328 00000001 c10c8890 00000001 00000000 c1bb0d04
[ 1104.515153] Call Trace:
[ 1104.515153]  [<c10c8890>] ? path_put+0x15/0x18
[ 1104.515153]  [<c10bf446>] do_sync_read+0x9e/0xd6
[ 1104.515153]  [<c10bfb1c>] vfs_read+0x8b/0x10d
[ 1104.515153]  [<c10bf3a8>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1104.515153]  [<c10bfdc0>] sys_read+0x3d/0x61
[ 1104.515153]  [<c16707bc>] syscall_call+0x7/0xb
[ 1104.515153] Code: a8 89 df 31 c9 ba 52 04 00 00 b8 3a 8f 81 c1 e8 04 40 fb ff e8 ed 92 5d 00 8b 5d 90 29 fb 89 5d a0 89 fa 8b 45 c0 e8 fc ee ff ff <89> c6 85 c0 75 2c 8b 5d a0 89 5c 24 04 89 3c 24 8b 4d b8 8b 55
[ 1104.515153] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.515153] Pid: 135, comm: sh Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1104.515153] Call Trace:
[ 1104.515153]  [<c1664e92>] panic+0x81/0x194
[ 1104.515153]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1104.515153]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.515153]  [<c1065a8e>] ? __lock_acquire+0x1444/0x1455
[ 1104.515153]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1104.515153]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1104.515153]  [<c10306d2>] update_process_times+0x24/0x58
[ 1104.515153]  [<c1061092>] tick_periodic+0x66/0x72
[ 1104.515153]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1104.515153]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.515153]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.515153]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1104.515153]  [<c109007b>] ? perf_event_comm_output+0x31/0xe9
[ 1104.515153]  [<c1095f63>] ? generic_file_aio_read+0x27f/0x5f1
[ 1104.515153]  [<c10c8890>] ? path_put+0x15/0x18
[ 1104.515153]  [<c10bf446>] do_sync_read+0x9e/0xd6
[ 1104.515153]  [<c10bfb1c>] vfs_read+0x8b/0x10d
[ 1104.515153]  [<c10bf3a8>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1104.515153]  [<c10bfdc0>] sys_read+0x3d/0x61
[ 1104.515153]  [<c16707bc>] syscall_call+0x7/0xb
[ 1104.515153] Rebooting in 10 seconds..
--
[    5.793227] Freeing unused kernel memory: 464k freed
[ 1104.521267] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1104.521267] irq event stamp: 13836
[ 1104.521267] hardirqs last  enabled at (13833): [<c166e1f5>] restore_all_notrace+0x0/0x18
[ 1104.521267] hardirqs last disabled at (13834): [<c166ecff>] apic_timer_interrupt+0x2f/0x40
[ 1104.521267] softirqs last  enabled at (13836): [ 1104.527910] [sched_delayed] sched: RT throttling activated
[<c102cbbf>] _local_bh_enable+0xd/0xf
[ 1104.528470] softirqs last disabled at (13835): [<c102d02c>] irq_enter+0x2c/0x4d
[ 1104.528470] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-01297-ga17f29a #84  
[ 1104.528470] EIP: 0060:[<c101c42e>] EFLAGS: 00000282 CPU: 1
[ 1104.528470] EIP is at native_safe_halt+0x5/0x7
[ 1104.528470] EAX: ce060000 EBX: ffffffff ECX: ce060000 EDX: 00000007
[ 1104.528470] ESI: c195a818 EDI: ffff8b9e EBP: ce05ff68 ESP: ce05ff68
[ 1104.528470]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.528470] CR0: 8005003b CR2: b75f5fb8 CR3: 0ee64000 CR4: 00000690
[ 1104.528470] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.528470] DR6: ffff0ff0 DR7: 00000400
[ 1104.528470] Process swapper/1 (pid: 0, ti=ce05e000 task=ce060000 task.ti=ce05e000)
[ 1104.528470] Stack:
[ 1104.528470]  ce05ff70 c10089d9 ce05ff88 c1009220 3c8ef9e1 4af27f04 853dc1b9 cfff9fa0
[ 1104.528470]  ce05ffb4 c165d2ba 00000000 00000000 00000000 00000000 f56cca54 853dc1b9
[ 1104.528470]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.528470] Call Trace:
[ 1104.528470]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.528470]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.528470]  [<c165d2ba>] start_secondary+0x292/0x29a
[ 1104.528470] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.528470] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.528470] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-01297-ga17f29a #84
[ 1104.528470] Call Trace:
[ 1104.528470]  [<c16622f2>] panic+0x81/0x194
[ 1104.528470]  [<c107e1d2>] watchdog_timer_fn+0x115/0x134
[ 1104.528470]  [<c10413fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.528470]  [<c107e0bd>] ? __touch_watchdog+0x1d/0x1d
[ 1104.528470]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1104.528470]  [<c10305f6>] update_process_times+0x24/0x58
[ 1104.528470]  [<c1060d92>] tick_periodic+0x66/0x72
[ 1104.528470]  [<c1060dec>] tick_handle_periodic+0x19/0x61
[ 1104.528470]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.528470]  [<c12aa840>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.528470]  [<c166ed06>] apic_timer_interrupt+0x36/0x40
[ 1104.528470]  [<c101c42e>] ? native_safe_halt+0x5/0x7
[ 1104.528470]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.528470]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.528470]  [<c165d2ba>] start_secondary+0x292/0x29a
[ 1104.528470] Rebooting in 10 seconds..
--
[ 1104.519836] [sched_delayed] sched: RT throttling activated
[ 1104.520679] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1104.520679] irq event stamp: 6818
[ 1104.520679] hardirqs last  enabled at (6815): [<c10089c9>] default_idle+0x1f/0x55
[ 1104.520679] hardirqs last disabled at (6816): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1104.520679] softirqs last  enabled at (6818): [<c102cc9f>] _local_bh_enable+0xd/0xf
[ 1104.520679] softirqs last disabled at (6817): [<c102d10c>] irq_enter+0x2c/0x4d
[ 1104.520679] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1104.520679] EIP: 0060:[<c101c512>] EFLAGS: 00000282 CPU: 1
[ 1104.520679] EIP is at native_safe_halt+0x5/0x7
[ 1104.520679] EAX: ce062240 EBX: ffffffff ECX: ce062240 EDX: 00000007
[ 1104.520679] ESI: c195cbf0 EDI: ffff8ba3 EBP: ce06bf68 ESP: ce06bf68
[ 1104.533562]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.533562] CR0: 8005003b CR2: b754c460 CR3: 0e88f000 CR4: 00000690
[ 1104.533562] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.533562] DR6: ffff0ff0 DR7: 00000400
[ 1104.533562] Process swapper/1 (pid: 0, ti=ce06a000 task=ce062240 task.ti=ce06a000)
[ 1104.533562] Stack:
[ 1104.533562]  ce06bf70 c10089d9 ce06bf88 c1009220 a752cb21 b5b65043 f001826a cfff9fa0
[ 1104.533562]  ce06bfb4 c166027a 00000000 00000000 00000000 00000000 60308b05 f001826a
[ 1104.533562]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.533562] Call Trace:
[ 1104.533562]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.533562]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.533562]  [<c166027a>] start_secondary+0x292/0x29a
[ 1104.533562] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.533562] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.533562] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1104.533562] Call Trace:
[ 1104.533562]  [<c1664e92>] panic+0x81/0x194
[ 1104.533562]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1104.533562]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.533562]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1104.533562]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1104.533562]  [<c10306d2>] update_process_times+0x24/0x58
[ 1104.533562]  [<c1061092>] tick_periodic+0x66/0x72
[ 1104.533562]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1104.533562]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.533562]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.533562]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1104.533562]  [<c101c512>] ? native_safe_halt+0x5/0x7
[ 1104.533562]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.533562]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.533562]  [<c166027a>] start_secondary+0x292/0x29a
[ 1104.533562] Rebooting in 10 seconds..
--
[ 1104.522067] [sched_delayed] sched: RT throttling activated
[ 1104.522043] BUG: soft lockup - CPU#1 stuck for 1024s! [99-trinity:129]
[ 1104.522043] irq event stamp: 2948
[ 1104.522043] hardirqs last  enabled at (2947): [<c16707f5>] restore_all_notrace+0x0/0x18
[ 1104.522043] hardirqs last disabled at (2948): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1104.522043] softirqs last  enabled at (2348): [<c15f31f2>] unix_sock_destructor+0xae/0xb3
[ 1104.522043] softirqs last disabled at (2346): [<c15f31df>] unix_sock_destructor+0x9b/0xb3
[ 1104.522043] Pid: 129, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1104.522043] EIP: 0060:[<c1670770>] EFLAGS: 00000246 CPU: 1
[ 1104.522043] EIP is at system_call+0x0/0x45
[ 1104.522043] EAX: 000000c0 EBX: 00000000 ECX: 0000c404 EDX: 00000005
[ 1104.522043] ESI: 00000802 EDI: 00000003 EBP: 00000000 ESP: ce881fe4
[ 1104.522043]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[ 1104.522043] CR0: 80050033 CR2: b752b267 CR3: 0e867000 CR4: 00000690
[ 1104.522043] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.522043] DR6: ffff0ff0 DR7: 00000400
[ 1104.522043] Process 99-trinity (pid: 129, ti=ce880000 task=cf8b3360 task.ti=ce880000)
[ 1104.522043] Stack:
[ 1104.522043]  b773fd63 00000073 00000246 bfc9319c 0000007b cccccccc cccccccc
[ 1104.522043] Call Trace:
[ 1104.522043] Code: 67 9f ff 5a 59 58 fa 8d b6 00 00 00 00 e8 3d a2 c3 ff 8b 4d 08 81 e1 2e fe 00 00 0f 85 0a 01 00 00 eb 7e 90 8d b4 26 00 00 00 00 <50> fc 0f a8 0f a0 06 1e 50 55 57 56 52 51 53 ba 7b 00 00 00 8e
[ 1104.522043] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.522043] Pid: 129, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1104.522043] Call Trace:
[ 1104.522043]  [<c1664e92>] panic+0x81/0x194
[ 1104.522043]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1104.522043]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.522043]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1104.522043]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1104.522043]  [<c10306d2>] update_process_times+0x24/0x58
[ 1104.522043]  [<c1061092>] tick_periodic+0x66/0x72
[ 1104.522043]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1104.522043]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.522043]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.522043]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1104.522043]  [<c1670770>] ? resume_userspace+0x30/0x30
[ 1104.522043] Rebooting in 10 seconds..
--
[    5.773899] Freeing unused kernel memory: 464k freed
[ 1104.518996] BUG: soft lockup - CPU#1 stuck for 1023s! [sh:134]
[ 1104.518996] irq event stamp: 1020
[ 1104.518996] hardirqs last  enabled at (1019): [<c166b6e8>] __mutex_unlock_slowpath+0x114/0x12c
[ 1104.518996] hardirqs last disabled at (1020): [<c166e77f>] apic_timer_interrupt+0x2f/0x40
[ 1104.518996] softirqs last  enabled at (0): [<c1025204>] copy_process+0x471/0xf82
[ 1104.518996] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.518996] Pid: 134, comm: sh Not tainted 3.5.0-bisect2-00646-g5b160bd #85  
[ 1104.518996] EIP: 0060:[<c1065bcd>] EFLAGS: 00000286 CPU: 1
[ 1104.526690] [sched_delayed] sched: RT throttling activated
[ 1104.518996] EIP is at lock_acquire+0xb4/0xc0
[ 1104.518996] EAX: 00000286 EBX: cf8966c0 ECX: 000001e3 EDX: 000001e3
[ 1104.518996] ESI: 00000000 EDI: cb732cdc EBP: ce869e3c ESP: ce869e10
[ 1104.518996]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.518996] CR0: 8005003b CR2: 08124f6c CR3: 0e86c000 CR4: 00000690
[ 1104.518996] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.518996] DR6: ffff0ff0 DR7: 00000400
[ 1104.518996] Process sh (pid: 134, ti=ce868000 task=cf8966c0 task.ti=ce868000)
[ 1104.518996] Stack:
[ 1104.518996]  00000000 00000002 00000000 00000000 c10d0b7e 00000000 00000000 00000286
[ 1104.518996]  cb732ccc fffffffe cb732ccc ce869e58 c166d29a 00000000 00000002 00000000
[ 1104.518996]  c10d0b7e cb732c80 ce869e70 c10d0b7e fffffffe ce869ef4 fffffffe 00000041
[ 1104.518996] Call Trace:
[ 1104.518996]  [<c10d0b7e>] ? dput+0x37/0x143
[ 1104.518996]  [<c166d29a>] _raw_spin_lock+0x3d/0x4a
[ 1104.518996]  [<c10d0b7e>] ? dput+0x37/0x143
[ 1104.518996]  [<c10d0b7e>] dput+0x37/0x143
[ 1104.518996]  [<c10c86ac>] path_put+0xe/0x18
[ 1104.518996]  [<c10c8ad7>] terminate_walk+0x10/0x86
[ 1104.518996]  [<c10c9655>] path_lookupat+0x1cd/0x535
[ 1104.518996]  [<c10c99dc>] do_path_lookup+0x1f/0x8e
[ 1104.518996]  [<c10c9d2d>] user_path_at_empty+0x41/0x66
[ 1104.518996]  [<c101d248>] ? do_page_fault+0x312/0x36e
[ 1104.518996]  [<c10bbdaf>] ? kmem_cache_alloc+0xab/0xcb
[ 1104.518996]  [<c10c9d6c>] user_path_at+0x1a/0x1f
[ 1104.518996]  [<c10be6d0>] sys_faccessat+0x90/0x150
[ 1104.518996]  [<c166dc75>] ? restore_all+0xf/0xf
[ 1104.518996]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.518996]  [<c10be7b0>] sys_access+0x20/0x22
[ 1104.518996]  [<c166dc3c>] syscall_call+0x7/0xb
[ 1104.518996] Code: 45 08 89 04 24 8b 4d ec 89 f2 89 f8 e8 57 e7 ff ff c7 83 54 04 00 00 00 00 00 00 83 3d 6c b4 8f c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 83 c4 20 5b 5e 5f 5d c3 55 89 e5 57 56 53 83 ec 1c
[ 1104.518996] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.518996] Pid: 134, comm: sh Not tainted 3.5.0-bisect2-00646-g5b160bd #85
[ 1104.518996] Call Trace:
[ 1104.518996]  [<c1661ced>] panic+0x81/0x194
[ 1104.518996]  [<c107e202>] watchdog_timer_fn+0x115/0x134
[ 1104.518996]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.518996]  [<c107e0ed>] ? __touch_watchdog+0x1d/0x1d
[ 1104.518996]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1104.518996]  [<c10305f6>] update_process_times+0x24/0x58
[ 1104.518996]  [<c1060d52>] tick_periodic+0x66/0x72
[ 1104.518996]  [<c1060dac>] tick_handle_periodic+0x19/0x61
[ 1104.518996]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.518996]  [<c12aa280>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.518996]  [<c166e786>] apic_timer_interrupt+0x36/0x40
[ 1104.518996]  [<c1065bcd>] ? lock_acquire+0xb4/0xc0
[ 1104.518996]  [<c10d0b7e>] ? dput+0x37/0x143
[ 1104.518996]  [<c166d29a>] _raw_spin_lock+0x3d/0x4a
[ 1104.518996]  [<c10d0b7e>] ? dput+0x37/0x143
[ 1104.518996]  [<c10d0b7e>] dput+0x37/0x143
[ 1104.518996]  [<c10c86ac>] path_put+0xe/0x18
[ 1104.518996]  [<c10c8ad7>] terminate_walk+0x10/0x86
[ 1104.518996]  [<c10c9655>] path_lookupat+0x1cd/0x535
[ 1104.518996]  [<c10c99dc>] do_path_lookup+0x1f/0x8e
[ 1104.518996]  [<c10c9d2d>] user_path_at_empty+0x41/0x66
[ 1104.518996]  [<c101d248>] ? do_page_fault+0x312/0x36e
[ 1104.518996]  [<c10bbdaf>] ? kmem_cache_alloc+0xab/0xcb
[ 1104.518996]  [<c10c9d6c>] user_path_at+0x1a/0x1f
[ 1104.518996]  [<c10be6d0>] sys_faccessat+0x90/0x150
[ 1104.518996]  [<c166dc75>] ? restore_all+0xf/0xf
[ 1104.518996]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.518996]  [<c10be7b0>] sys_access+0x20/0x22
[ 1104.518996]  [<c166dc3c>] syscall_call+0x7/0xb
[ 1104.518996] Rebooting in 10 seconds..
--
[ 1104.515042] [sched_delayed] sched: RT throttling activated
[ 1104.515017] BUG: soft lockup - CPU#1 stuck for 1024s! [99-trinity:129]
[ 1104.515017] irq event stamp: 1404
[ 1104.515017] hardirqs last  enabled at (1403): [<c16707f5>] restore_all_notrace+0x0/0x18
[ 1104.515017] hardirqs last disabled at (1404): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1104.515017] softirqs last  enabled at (0): [<c10252e4>] copy_process+0x471/0xf82
[ 1104.515017] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.515017] Pid: 129, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1104.515017] EIP: 0073:[<b77231e7>] EFLAGS: 00000202 CPU: 1
[ 1104.515017] EIP is at 0xb77231e7
[ 1104.515017] EAX: 08124f88 EBX: b7735ff4 ECX: b75466c0 EDX: 0805db8c
[ 1104.515017] ESI: b7736918 EDI: 00000000 EBP: 08124f50 ESP: bfba3268
[ 1104.515017]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[ 1104.515017] Process 99-trinity (pid: 129, ti=ce890000 task=cf8ad5a0 task.ti=ce890000)
[ 1104.515017] 
[ 1104.515017] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.515017] Pid: 129, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1104.515017] Call Trace:
[ 1104.515017]  [<c1664e92>] panic+0x81/0x194
[ 1104.515017]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1104.515017]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.515017]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1104.515017]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1104.515017]  [<c10306d2>] update_process_times+0x24/0x58
[ 1104.515017]  [<c1061092>] tick_periodic+0x66/0x72
[ 1104.515017]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1104.515017]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.515017]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.515017]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1104.515017] Rebooting in 10 seconds..
--
[    4.455784] Freeing unused kernel memory: 464k freed
[ 1103.514772] BUG: soft lockup - CPU#1 stuck for 1024s! [init:1]
[ 1103.524384] [sched_delayed] sched: RT throttling activated
[ 1103.514772] irq event stamp: 759084
[ 1103.514772] hardirqs last  enabled at (759083): [<c166dc81>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.514772] hardirqs last disabled at (759084): [<c166efcf>] apic_timer_interrupt+0x2f/0x40
[ 1103.514772] softirqs last  enabled at (754272): [<c15f0a02>] unix_sock_destructor+0xae/0xb3
[ 1103.514772] softirqs last disabled at (754270): [<c15f09ef>] unix_sock_destructor+0x9b/0xb3
[ 1103.514772] 
[ 1103.514772] Pid: 1, comm: init Not tainted 3.5.0-bisect2-00242-g3992c03 #88  
[ 1103.514772] EIP: 0060:[<c166dc90>] EFLAGS: 00000282 CPU: 1
[ 1103.514772] EIP is at _raw_spin_unlock_irqrestore+0x51/0x63
[ 1103.514772] EAX: 00000282 EBX: 00000282 ECX: 00000000 EDX: 00000007
[ 1103.514772] ESI: ce8583e4 EDI: 00000001 EBP: ce03ddfc ESP: ce03ddf4
[ 1103.514772]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.514772] CR0: 80050033 CR2: 080b1bc0 CR3: 0e80b000 CR4: 00000690
[ 1103.514772] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.514772] DR6: ffff0ff0 DR7: 00000400
[ 1103.514772] Process init (pid: 1, ti=ce03c000 task=ce040000 task.ti=ce03c000)
[ 1103.514772] Stack:
[ 1103.514772]  00000000 ce858000 ce03de20 c104842a 00000282 ce8583e4 0cb64000 00000000
[ 1103.514772]  ce858000 00000000 00000007 ce03de28 c1048470 ce03de38 c102ec42 ce858000
[ 1103.514772]  00000000 ce03def4 c102fb22 003f0011 00000000 ce040470 00000000 ce040000
[ 1103.514772] Call Trace:
[ 1103.514772]  [<c104842a>] try_to_wake_up+0x248/0x266
[ 1103.514772]  [<c1048470>] wake_up_state+0xa/0xc
[ 1103.514772]  [<c102ec42>] ptrace_resume+0x76/0x7c
[ 1103.514772]  [<c102fb22>] ptrace_request+0x368/0x4f8
[ 1103.514772]  [<c106574a>] ? __lock_acquire+0x1444/0x1455
[ 1103.514772]  [<c106574a>] ? __lock_acquire+0x1444/0x1455
[ 1103.514772]  [<c10657d9>] ? lock_release_non_nested+0x7e/0x21b
[ 1103.514772]  [<c106574a>] ? __lock_acquire+0x1444/0x1455
[ 1103.514772]  [<c100ac76>] arch_ptrace+0x474/0x48a
[ 1103.514772]  [<c166dc81>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.514772]  [<c10638d8>] ? trace_hardirqs_on+0xb/0xd
[ 1103.514772]  [<c1046015>] ? wait_task_inactive+0x6f/0xc1
[ 1103.514772]  [<c102eefe>] ? ptrace_check_attach+0xb4/0xc4
[ 1103.514772]  [<c102f71e>] sys_ptrace+0x34f/0x379
[ 1103.514772]  [<c102f43d>] ? sys_ptrace+0x6e/0x379
[ 1103.514772]  [<c166f4a3>] sysenter_do_call+0x12/0x38
[ 1103.514772] Code: 3d 6c b4 8f c1 00 74 1d 89 d8 50 9d 8d 74 26 00 e8 7d 5d 9f ff eb 18 e8 4c 5c 9f ff 83 3d 6c b4 8f c1 00 75 02 0f 0b 89 d8 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5 
[ 1103.514772] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.514772] Pid: 1, comm: init Not tainted 3.5.0-bisect2-00242-g3992c03 #88
[ 1103.514772] Call Trace:
[ 1103.514772]  [<c166256f>] panic+0x81/0x194
[ 1103.514772]  [<c107e1fe>] watchdog_timer_fn+0x115/0x134
[ 1103.514772]  [<c10413de>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.514772]  [<c107e0e9>] ? __touch_watchdog+0x1d/0x1d
[ 1103.514772]  [<c10305e6>] run_local_timers+0x8/0x14
[ 1103.514772]  [<c1030616>] update_process_times+0x24/0x58
[ 1103.514772]  [<c1060d4e>] tick_periodic+0x66/0x72
[ 1103.514772]  [<c1060da8>] tick_handle_periodic+0x19/0x61
[ 1103.514772]  [<c10176c5>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.514772]  [<c12aa280>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.514772]  [<c166efd6>] apic_timer_interrupt+0x36/0x40
[ 1103.514772]  [<c166dc90>] ? _raw_spin_unlock_irqrestore+0x51/0x63
[ 1103.514772]  [<c104842a>] try_to_wake_up+0x248/0x266
[ 1103.514772]  [<c1048470>] wake_up_state+0xa/0xc
[ 1103.514772]  [<c102ec42>] ptrace_resume+0x76/0x7c
[ 1103.514772]  [<c102fb22>] ptrace_request+0x368/0x4f8
[ 1103.514772]  [<c106574a>] ? __lock_acquire+0x1444/0x1455
[ 1103.514772]  [<c106574a>] ? __lock_acquire+0x1444/0x1455
[ 1103.514772]  [<c10657d9>] ? lock_release_non_nested+0x7e/0x21b
[ 1103.514772]  [<c106574a>] ? __lock_acquire+0x1444/0x1455
[ 1103.514772]  [<c100ac76>] arch_ptrace+0x474/0x48a
[ 1103.514772]  [<c166dc81>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1103.514772]  [<c10638d8>] ? trace_hardirqs_on+0xb/0xd
[ 1103.514772]  [<c1046015>] ? wait_task_inactive+0x6f/0xc1
[ 1103.514772]  [<c102eefe>] ? ptrace_check_attach+0xb4/0xc4
[ 1103.514772]  [<c102f71e>] sys_ptrace+0x34f/0x379
[ 1103.514772]  [<c102f43d>] ? sys_ptrace+0x6e/0x379
[ 1103.514772]  [<c166f4a3>] sysenter_do_call+0x12/0x38
[ 1103.514772] Rebooting in 10 seconds..
--
[    5.165476] Freeing unused kernel memory: 464k freed
[ 1104.519906] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1104.519906] irq event stamp: 6640
[ 1104.519906] hardirqs last  enabled at (6637): [<c16707f5>] restore_all_notrace+0x0/0x18
[ 1104.519906] hardirqs last disabled at (6638): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1104.519906] softirqs last  enabled at (6640): [<c102cc9f>] _local_bh_enable+0xd/0xf
[ 1104.519906] softirqs last disabled at (6639): [<c102d10c>] irq_enter+0x2c/0x4d
[ 1104.519906] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1104.519906] EIP: 0060:[<c101c512>] EFLAGS: 00000282 CPU: 1
[ 1104.519906] EIP is at native_safe_halt+0x5/0x7
[ 1104.519906] EAX: ce062240 EBX: ffffffff ECX: ce062240 EDX: 00000007
[ 1104.519906] ESI: c195cbf0 EDI: ffff8b9e EBP: ce06bf68 ESP: ce06bf68
[ 1104.519906]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.519906] CR0: 8005003b CR2: b76acc50 CR3: 019dc000 CR4: 00000690
[ 1104.519906] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.519906] DR6: ffff0ff0 DR7: 00000400
[ 1104.519906] Process swapper/1 (pid: 0, ti=ce06a000 task=ce062240 task.ti=ce06a000)
[ 1104.519906] Stack:
[ 1104.519906]  ce06bf70 c10089d9 ce06bf88 c1009220 7b380d04 899b9224 c3e68548 cfff9fa0
[ 1104.519906]  ce06bfb4 c166027a 00000000 00000000 00000000 00000000 34158de5 c3e68548
[ 1104.519906]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.519906] Call Trace:
[ 1104.519906]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.519906]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.519906]  [<c166027a>] start_secondary+0x292/0x29a
[ 1104.519906] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.519906] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.519906] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1104.519906] Call Trace:
[ 1104.519906]  [<c1664e92>] panic+0x81/0x194
[ 1104.519906]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1104.519906]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.519906]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1104.519906]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1104.519906]  [<c10306d2>] update_process_times+0x24/0x58
[ 1104.519906]  [<c1061092>] tick_periodic+0x66/0x72
[ 1104.519906]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1104.519906]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.519906]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.519906]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1104.519906]  [<c101c512>] ? native_safe_halt+0x5/0x7
[ 1104.519906]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.519906]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.519906]  [<c166027a>] start_secondary+0x292/0x29a
[ 1104.519906] Rebooting in 10 seconds..
--
[    4.683031] Freeing unused kernel memory: 460k freed
[ 1103.515937] BUG: soft lockup - CPU#1 stuck for 1024s! [chroot:134]
[ 1103.515937] irq event stamp: 3200
[ 1103.515937] hardirqs last  enabled at (3199): [<c106831d>] debug_check_no_locks_freed+0x14b/0x167
[ 1103.515937] hardirqs last disabled at (3200): [<c167f36f>] apic_timer_interrupt+0x2f/0x40
[ 1103.515937] softirqs last  enabled at (3056): [<c1601106>] unix_sock_destructor+0xae/0xb3
[ 1103.515937] softirqs last disabled at (3054): [<c16010f3>] unix_sock_destructor+0x9b/0xb3
[ 1103.515937] Pid: 134, comm: chroot Not tainted 3.6.0-rc1-bisect2 #80  
[ 1103.515937] EIP: 0060:[<c1065d13>] EFLAGS: 00000282 CPU: 1
[ 1103.515937] EIP is at lock_is_held+0x9f/0xb2
[ 1103.515937] EAX: 00000282 EBX: 00000001 ECX: 00000000 EDX: 00000000
[ 1103.515937] ESI: ce8b2260 EDI: c1913698 EBP: ce8c7f0c ESP: ce8c7efc
[ 1103.515937]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.515937] CR0: 8005003b CR2: 080b6730 CR3: 0e8be000 CR4: 00000690
[ 1103.525323] [sched_delayed] sched: RT throttling activated
[ 1103.515937] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.515937] DR6: ffff0ff0 DR7: 00000400
[ 1103.515937] Process chroot (pid: 134, ti=ce8c6000 task=ce8b2260 task.ti=ce8c6000)
[ 1103.515937] Stack:
[ 1103.515937]  00000282 000001c5 c182dba3 00000000 ce8c7f34 c104bb01 bfc5c5fc ce8c7f34
[ 1103.515937]  c10af78b 00000001 00000002 00000008 ce8b2260 bfc5c5fc ce8c7f48 c10cc958
[ 1103.515937]  c7b3a300 00000006 00000001 ce8c7f88 c10cde5f 00000002 00000001 00000000
[ 1103.515937] Call Trace:
[ 1103.515937]  [<c104bb01>] __might_sleep+0xa1/0x1cd
[ 1103.515937]  [<c10af78b>] ? might_fault+0x90/0x99
[ 1103.515937]  [<c10cc958>] count.constprop.35+0x78/0x82
[ 1103.515937]  [<c10cde5f>] do_execve+0x310/0x456
[ 1103.515937]  [<c10cdc3a>] ? do_execve+0xeb/0x456
[ 1103.515937]  [<c1009165>] sys_execve+0x31/0x53
[ 1103.515937]  [<c167f942>] ptregs_execve+0x12/0x20
[ 1103.515937]  [<c167f843>] ? sysenter_do_call+0x12/0x38
[ 1103.515937] Code: 7c e2 31 c9 eb 05 b9 01 00 00 00 64 a1 28 06 9e c1 c7 80 58 04 00 00 00 00 00 00 83 3d 8c 20 91 c1 00 75 02 0f 0b 8b 45 f0 50 9d <8d> 74 26 00 eb 05 b9 01 00 00 00 89 c8 5b 5b 5e 5f 5d c3 55 89
[ 1103.515937] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.515937] Pid: 134, comm: chroot Not tainted 3.6.0-rc1-bisect2 #80
[ 1103.515937] Call Trace:
[ 1103.515937]  [<c1673658>] panic+0x97/0x1aa
[ 1103.515937]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1103.515937]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.515937]  [<c106716a>] ? __lock_acquire+0x1444/0x1455
[ 1103.515937]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1103.515937]  [<c103205a>] run_local_timers+0x8/0x14
[ 1103.515937]  [<c103208a>] update_process_times+0x24/0x58
[ 1103.515937]  [<c106276e>] tick_periodic+0x66/0x72
[ 1103.515937]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1103.515937]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.515937]  [<c12b36a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.515937]  [<c167f376>] apic_timer_interrupt+0x36/0x40
[ 1103.515937]  [<c1065d13>] ? lock_is_held+0x9f/0xb2
[ 1103.515937]  [<c104bb01>] __might_sleep+0xa1/0x1cd
[ 1103.515937]  [<c10af78b>] ? might_fault+0x90/0x99
[ 1103.515937]  [<c10cc958>] count.constprop.35+0x78/0x82
[ 1103.515937]  [<c10cde5f>] do_execve+0x310/0x456
[ 1103.515937]  [<c10cdc3a>] ? do_execve+0xeb/0x456
[ 1103.515937]  [<c1009165>] sys_execve+0x31/0x53
[ 1103.515937]  [<c167f942>] ptregs_execve+0x12/0x20
[ 1103.515937]  [<c167f843>] ? sysenter_do_call+0x12/0x38
[ 1103.515937] Rebooting in 10 seconds..
--
[    5.214556] Freeing unused kernel memory: 464k freed
[ 1104.514802] BUG: soft lockup - CPU#1 stuck for 1025s! [init:1]
[ 1104.514802] irq event stamp: 756026
[ 1104.514802] hardirqs last  enabled at (756025): [<c166e171>] _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.514802] hardirqs last disabled at (756026): [<c166f4bf>] apic_timer_interrupt+0x2f/0x40
[ 1104.514802] softirqs last  enabled at (751184): [<c15f0ef2>] unix_sock_destructor+0xae/0xb3
[ 1104.514802] softirqs last disabled at (751182): [<c15f0edf>] unix_sock_destructor+0x9b/0xb3
[ 1104.514802] Pid: 1, comm: init Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86  
[ 1104.514802] EIP: 0060:[<c166e180>] EFLAGS: 00000286 CPU: 1
[ 1104.514802] EIP is at _raw_spin_unlock_irqrestore+0x51/0x63
[ 1104.514802] EAX: 00000286 EBX: 00000286 ECX: 00000000 EDX: 00000007
[ 1104.514802] ESI: ce861504 EDI: 00000001 EBP: ce03ddfc ESP: ce03ddf4
[ 1104.514802]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.524377] [sched_delayed] sched: RT throttling activated
[ 1104.514802] CR0: 80050033 CR2: b760b600 CR3: 0ee6a000 CR4: 00000690
[ 1104.514802] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.514802] DR6: ffff0ff0 DR7: 00000400
[ 1104.514802] Process init (pid: 1, ti=ce03c000 task=ce040000 task.ti=ce03c000)
[ 1104.514802] Stack:
[ 1104.514802]  00000000 ce861120 ce03de20 c104840a 00000286 ce861504 0cb62000 00000000
[ 1104.514802]  ce861120 00000000 00000007 ce03de28 c1048450 ce03de38 c102ec22 ce861120
[ 1104.514802]  00000000 ce03def4 c102fb02 003f0011 00000000 ce040470 00000000 ce040000
[ 1104.514802] Call Trace:
[ 1104.514802]  [<c104840a>] try_to_wake_up+0x248/0x266
[ 1104.514802]  [<c1048450>] wake_up_state+0xa/0xc
[ 1104.514802]  [<c102ec22>] ptrace_resume+0x76/0x7c
[ 1104.514802]  [<c102fb02>] ptrace_request+0x368/0x4f8
[ 1104.514802]  [<c106572a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514802]  [<c106572a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514802]  [<c10657b9>] ? lock_release_non_nested+0x7e/0x21b
[ 1104.514802]  [<c106572a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514802]  [<c100ac8a>] arch_ptrace+0x474/0x48a
[ 1104.514802]  [<c166e171>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.514802]  [<c10638b8>] ? trace_hardirqs_on+0xb/0xd
[ 1104.514802]  [<c1045ff5>] ? wait_task_inactive+0x6f/0xc1
[ 1104.514802]  [<c102eede>] ? ptrace_check_attach+0xb4/0xc4
[ 1104.514802]  [<c102f6fe>] sys_ptrace+0x34f/0x379
[ 1104.514802]  [<c102f41d>] ? sys_ptrace+0x6e/0x379
[ 1104.514802]  [<c166f9a3>] sysenter_do_call+0x12/0x38
[ 1104.514802] Code: 3d 6c d4 8f c1 00 74 1d 89 d8 50 9d 8d 74 26 00 e8 6d 58 9f ff eb 18 e8 3c 57 9f ff 83 3d 6c d4 8f c1 00 75 02 0f 0b 89 d8 50 9d <8d> 74 26 00 89 e0 25 00 e0 ff ff ff 48 14 5b 5e 5d c3 55 89 e5
[ 1104.514802] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.514802] Pid: 1, comm: init Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86
[ 1104.514802] Call Trace:
[ 1104.514802]  [<c1662a5f>] panic+0x81/0x194
[ 1104.514802]  [<c107e1de>] watchdog_timer_fn+0x115/0x134
[ 1104.514802]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.514802]  [<c107e0c9>] ? __touch_watchdog+0x1d/0x1d
[ 1104.514802]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1104.514802]  [<c10305f6>] update_process_times+0x24/0x58
[ 1104.514802]  [<c1060d2e>] tick_periodic+0x66/0x72
[ 1104.514802]  [<c1060d88>] tick_handle_periodic+0x19/0x61
[ 1104.514802]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.514802]  [<c12aa260>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.514802]  [<c166f4c6>] apic_timer_interrupt+0x36/0x40
[ 1104.514802]  [<c166e180>] ? _raw_spin_unlock_irqrestore+0x51/0x63
[ 1104.514802]  [<c104840a>] try_to_wake_up+0x248/0x266
[ 1104.514802]  [<c1048450>] wake_up_state+0xa/0xc
[ 1104.514802]  [<c102ec22>] ptrace_resume+0x76/0x7c
[ 1104.514802]  [<c102fb02>] ptrace_request+0x368/0x4f8
[ 1104.514802]  [<c106572a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514802]  [<c106572a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514802]  [<c10657b9>] ? lock_release_non_nested+0x7e/0x21b
[ 1104.514802]  [<c106572a>] ? __lock_acquire+0x1444/0x1455
[ 1104.514802]  [<c100ac8a>] arch_ptrace+0x474/0x48a
[ 1104.514802]  [<c166e171>] ? _raw_spin_unlock_irqrestore+0x42/0x63
[ 1104.514802]  [<c10638b8>] ? trace_hardirqs_on+0xb/0xd
[ 1104.514802]  [<c1045ff5>] ? wait_task_inactive+0x6f/0xc1
[ 1104.514802]  [<c102eede>] ? ptrace_check_attach+0xb4/0xc4
[ 1104.514802]  [<c102f6fe>] sys_ptrace+0x34f/0x379
[ 1104.514802]  [<c102f41d>] ? sys_ptrace+0x6e/0x379
[ 1104.514802]  [<c166f9a3>] sysenter_do_call+0x12/0x38
[ 1104.514802] Rebooting in 10 seconds..
--
[    5.704992] Freeing unused kernel memory: 464k freed
[ 1104.527176] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1104.527176] irq event stamp: 14280
[ 1104.527176] hardirqs last  enabled at (14277): [<c166e1f5>] restore_all_notrace+0x0/0x18
[ 1104.527176] hardirqs last disabled at (14278): [<c166ecff>] apic_timer_interrupt+0x2f/0x40
[ 1104.527176] softirqs last  enabled at (14280): [<c102cbbf>] _local_bh_enable+0xd/0xf
[ 1104.527176] softirqs last disabled at (14279): [<c102d02c>] irq_enter+0x2c/0x4d
[ 1104.527176] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-01297-ga17f29a #84  
[ 1104.527176] EIP: 0060:[<c101c42e>] EFLAGS: 00000282 CPU: 1
[ 1104.527176] EIP is at native_safe_halt+0x5/0x7
[ 1104.527176] EAX: ce060000 EBX: ffffffff ECX: ce060000 EDX: 00000007
[ 1104.527176] ESI: c195a818 EDI: ffff8b9e EBP: ce05ff68 ESP: ce05ff68
[ 1104.527176]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.527176] CR0: 8005003b CR2: b76c8000 CR3: 0ee58000 CR4: 00000690
[ 1104.527176] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.527176] DR6: ffff0ff0 DR7: 00000400
[ 1104.527176] Process swapper/1 (pid: 0, ti=ce05e000 task=ce060000 task.ti=ce05e000)
[ 1104.527176] Stack:
[ 1104.527176]  ce05ff70 c10089d9 ce05ff88 c1009220 a6cdc943 b5314e64 ef7c5be0 cfff9fa0
[ 1104.527176]  ce05ffb4 c165d2ba 00000000 00000000 00000000 00000000 5fab647c ef7c5be0
[ 1104.527176]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.527176] Call Trace:
[ 1104.527176]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.527176]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.527176]  [<c165d2ba>] start_secondary+0x292/0x29a
[ 1104.527176] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1104.527176] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.527176] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-01297-ga17f29a #84
[ 1104.527176] Call Trace:
[ 1104.527176]  [<c16622f2>] panic+0x81/0x194
[ 1104.527176]  [<c107e1d2>] watchdog_timer_fn+0x115/0x134
[ 1104.527176]  [<c10413fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.527176]  [<c107e0bd>] ? __touch_watchdog+0x1d/0x1d
[ 1104.527176]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1104.527176]  [<c10305f6>] update_process_times+0x24/0x58
[ 1104.527176]  [<c1060d92>] tick_periodic+0x66/0x72
[ 1104.527176]  [<c1060dec>] tick_handle_periodic+0x19/0x61
[ 1104.527176]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.527176]  [<c12aa840>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.527176]  [<c166ed06>] apic_timer_interrupt+0x36/0x40
[ 1104.527176]  [<c101c42e>] ? native_safe_halt+0x5/0x7
[ 1104.527176]  [<c10089d9>] default_idle+0x2f/0x55
[ 1104.527176]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1104.527176]  [<c165d2ba>] start_secondary+0x292/0x29a
[ 1104.527176] Rebooting in 10 seconds..
--
[    6.525425] Freeing unused kernel memory: 464k freed
[ 1105.523006] BUG: soft lockup - CPU#1 stuck for 1023s! [99-trinity:133]
[ 1105.523006] irq event stamp: 632
[ 1105.523006] hardirqs last  enabled at (631): [<c166e268>] __mutex_unlock_slowpath+0x114/0x12c
[ 1105.523006] hardirqs last disabled at (632): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1105.523006] softirqs last  enabled at (0): [<c10252e4>] copy_process+0x471/0xf82
[ 1105.523006] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1105.523006] Pid: 133, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1105.523006] EIP: 0060:[<c1064141>] EFLAGS: 00000202 CPU: 1
[ 1105.523006] EIP is at lockdep_trace_alloc+0x3/0xe0
[ 1105.523006] EAX: 000280da EBX: 000280da ECX: c1958810 EDX: 00000000
[ 1105.523006] ESI: 0000000a EDI: ce807680 EBP: ce8a3d5c ESP: ce8a3d5c
[ 1105.523006]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.523006] CR0: 80050033 CR2: b75e5baf CR3: 0e868000 CR4: 00000690
[ 1105.523006] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.523006] DR6: ffff0ff0 DR7: 00000400
[ 1105.523006] Process 99-trinity (pid: 133, ti=ce8a2000 task=ce8a8000 task.ti=ce8a2000)
[ 1105.523006] Stack:
[ 1105.523006]  ce8a3dfc c109a6d2 ce8a8000 00000040 00000006 c1bc8eb4 ce8a8458 ce8a8000
[ 1105.523006]  ce8a3da0 c1063a52 00000378 00000007 00000000 00000000 ce8a8000 c1900ad8
[ 1105.523006]  ce8a3db4 00000286 00000286 000000aa c181b224 00000000 ce8a3ddc 00000286
[ 1105.523006] Call Trace:
[ 1105.523006]  [<c109a6d2>] __alloc_pages_nodemask+0x78/0x5db
[ 1105.523006]  [<c1063a52>] ? mark_held_locks+0xa7/0xce
[ 1105.523006]  [<c10b19e1>] ? anon_vma_prepare+0x24/0x131
[ 1105.523006]  [<c10abbdd>] handle_pte_fault+0x16b/0x74c
[ 1105.523006]  [<c1020637>] ? kmap_atomic_prot+0x11f/0x133
[ 1105.523006]  [<c10ac253>] handle_mm_fault+0x95/0xa4
[ 1105.523006]  [<c10ac545>] __get_user_pages+0x264/0x39e
[ 1105.523006]  [<c10ac71d>] get_user_pages+0x4b/0x53
[ 1105.523006]  [<c10c3f2f>] get_arg_page+0x4a/0xa9
[ 1105.523006]  [<c10c408c>] copy_strings+0xfe/0x1c6
[ 1105.523006]  [<c10c44e9>] copy_strings_kernel+0x1c/0x2b
[ 1105.523006]  [<c10c56ff>] do_execve+0x343/0x456
[ 1105.523006]  [<c10c54a7>] ? do_execve+0xeb/0x456
[ 1105.523006]  [<c1009135>] sys_execve+0x31/0x53
[ 1105.523006]  [<c16718e2>] ptregs_execve+0x12/0x20
[ 1105.523006]  [<c16717e3>] ? sysenter_do_call+0x12/0x38
[ 1105.523006] Code: 3d 1c b7 95 c1 01 74 16 ba 9a 0a 00 00 b8 8b 35 81 c1 e8 7e 26 fc ff c6 05 1c b7 95 c1 01 64 ff 05 bc dc 9c c1 5b 5d c3 55 89 e5 <57> 56 53 89 c6 64 8b 1d 28 c6 9c c1 83 bb 54 04 00 00 00 0f 85
[ 1105.523006] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.523006] Pid: 133, comm: 99-trinity Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1105.523006] Call Trace:
[ 1105.523006]  [<c1664e92>] panic+0x81/0x194
[ 1105.523006]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1105.523006]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.523006]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1105.523006]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1105.523006]  [<c10306d2>] update_process_times+0x24/0x58
[ 1105.523006]  [<c1061092>] tick_periodic+0x66/0x72
[ 1105.523006]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1105.523006]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.523006]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.523006]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1105.523006]  [<c1064141>] ? lockdep_trace_alloc+0x3/0xe0
[ 1105.523006]  [<c109a6d2>] __alloc_pages_nodemask+0x78/0x5db
[ 1105.523006]  [<c1063a52>] ? mark_held_locks+0xa7/0xce
[ 1105.523006]  [<c10b19e1>] ? anon_vma_prepare+0x24/0x131
[ 1105.581916]  [<c10abbdd>] handle_pte_fault+0x16b/0x74c
[ 1105.581916]  [<c1020637>] ? kmap_atomic_prot+0x11f/0x133
[ 1105.581916]  [<c10ac253>] handle_mm_fault+0x95/0xa4
[ 1105.581916]  [<c10ac545>] __get_user_pages+0x264/0x39e
[ 1105.581916]  [<c10ac71d>] get_user_pages+0x4b/0x53
[ 1105.581916]  [<c10c3f2f>] get_arg_page+0x4a/0xa9
[ 1105.581916]  [<c10c408c>] copy_strings+0xfe/0x1c6
[ 1105.581916]  [<c10c44e9>] copy_strings_kernel+0x1c/0x2b
[ 1105.581916]  [<c10c56ff>] do_execve+0x343/0x456
[ 1105.581916]  [<c10c54a7>] ? do_execve+0xeb/0x456
[ 1105.581916]  [<c1009135>] sys_execve+0x31/0x53
[ 1105.581916]  [<c16718e2>] ptregs_execve+0x12/0x20
[ 1105.581916]  [<c16717e3>] ? sysenter_do_call+0x12/0x38
[ 1105.581916] Rebooting in 10 seconds..
--
[    4.563976] Freeing unused kernel memory: 464k freed
[ 1103.520656] BUG: soft lockup - CPU#1 stuck for 1023s! [shutdown:135]
[ 1103.520656] irq event stamp: 2580
[ 1103.520656] hardirqs last  enabled at (2579): [<c166b883>] mutex_lock_nested+0x2da/0x308
[ 1103.520656] hardirqs last disabled at (2580): [<c166f4bf>] apic_timer_interrupt+0x2f/0x40
[ 1103.520656] softirqs last  enabled at (0): [<c1025204>] copy_process+0x471/0xf82
mountall: ply-ev[ 1103.520656] softirqs last disabled at (0): ent-loop.c:497: [<  (null)>]   (null)
ply_event_loop_n[ 1103.520656] Pid: 135, comm: shutdown Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86  
ew: Assertion `l[ 1103.520656] EIP: 0060:[<c166b893>] EFLAGS: 00000286 CPU: 1
[ 1103.520656] EIP is at mutex_lock_nested+0x2ea/0x308
[ 1103.520656] EAX: 00000286 EBX: cb4e699c ECX: 00000006 EDX: cf8826c8
[ 1103.520656] ESI: ce82dbb0 EDI: ce873d7c EBP: ce873d98 ESP: ce873d5c
[ 1103.520656]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.520656] CR0: 8005003b CR2: b77911b8 CR3: 0e88b000 CR4: 00000690
[ 1103.520656] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
oop->epoll_fd >=[ 1103.520656] DR6: ffff0ff0 DR7: 00000400
[ 1103.520656] Process shutdown (pid: 135, ti=ce872000 task=cf882240 task.ti=ce872000)
 0' failed.
[ 1103.520656] Stack:
[ 1103.520656]  00000000 00000002 00000000 c10addf7 cb4e69c0 cf882240 cb4e69a0 00000286
[ 1103.520656]  ce873d7c ce873d7c 00000000 ce873d7c ce82d790 ce82dbb0 00000000 ce873dec
[ 1103.520656]  c10addf7 00000000 00000000 00000000 00000000 b775e000 ce0f6400 00000000
[ 1103.520656] Call Trace:
[ 1103.520656]  [<c10addf7>] ? vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10addf7>] vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10ae0bb>] __split_vma+0xea/0x13e
[ 1103.520656]  [<c10ae8fd>] do_munmap+0xab/0x24b
[ 1103.520656]  [<c10aeacd>] vm_munmap+0x30/0x41
[ 1103.520656]  [<c166505c>] elf_map+0x80/0xa6
[ 1103.520656]  [<c10f0e65>] load_elf_binary+0x7b7/0xfbd
[ 1103.520656]  [<c10c51f6>] search_binary_handler+0x14d/0x22b
[ 1103.520656]  [<c10c50e3>] ? search_binary_handler+0x3a/0x22b
[ 1103.520656]  [<c10f06ae>] ? load_elf_library+0x1bb/0x1bb
[ 1103.520656]  [<c10c565f>] do_execve+0x38b/0x456
[ 1103.520656]  [<c10c53bf>] ? do_execve+0xeb/0x456
[ 1103.520656]  [<c1009135>] sys_execve+0x31/0x53
[ 1103.520656]  [<c166faa2>] ptregs_execve+0x12/0x20
[ 1103.520656]  [<c166f9a3>] ? sysenter_do_call+0x12/0x38
[ 1103.520656] Code: d4 8f c1 00 74 1e 8b 45 e0 50 9d 8d 74 26 00 e8 5b 81 9f ff eb 19 e8 2a 80 9f ff 83 3d 6c d4 8f c1 00 75 02 0f 0b 8b 45 e0 50 9d <8d> 74 26 00 8d 45 e4 e8 c0 5f 9f ff 89 e0 25 00 e0 ff ff ff 48
[ 1103.520656] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.520656] Pid: 135, comm: shutdown Not tainted 3.5.0-bisect2-00313-g7cd58b0 #86
[ 1103.520656] Call Trace:
[ 1103.520656]  [<c1662a5f>] panic+0x81/0x194
[ 1103.520656]  [<c107e1de>] watchdog_timer_fn+0x115/0x134
[ 1103.520656]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.520656]  [<c107e0c9>] ? __touch_watchdog+0x1d/0x1d
[ 1103.520656]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1103.520656]  [<c10305f6>] update_process_times+0x24/0x58
[ 1103.520656]  [<c1060d2e>] tick_periodic+0x66/0x72
[ 1103.520656]  [<c1060d88>] tick_handle_periodic+0x19/0x61
[ 1103.520656]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.520656]  [<c12aa260>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.520656]  [<c166f4c6>] apic_timer_interrupt+0x36/0x40
[ 1103.520656]  [<c166b893>] ? mutex_lock_nested+0x2ea/0x308
[ 1103.520656]  [<c10addf7>] ? vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10addf7>] vma_adjust+0x134/0x30e
[ 1103.520656]  [<c10ae0bb>] __split_vma+0xea/0x13e
[ 1103.520656]  [<c10ae8fd>] do_munmap+0xab/0x24b
[ 1103.520656]  [<c10aeacd>] vm_munmap+0x30/0x41
[ 1103.520656]  [<c166505c>] elf_map+0x80/0xa6
[ 1103.520656]  [<c10f0e65>] load_elf_binary+0x7b7/0xfbd
[ 1103.520656]  [<c10c51f6>] search_binary_handler+0x14d/0x22b
[ 1103.520656]  [<c10c50e3>] ? search_binary_handler+0x3a/0x22b
[ 1103.520656]  [<c10f06ae>] ? load_elf_library+0x1bb/0x1bb
[ 1103.520656]  [<c10c565f>] do_execve+0x38b/0x456
[ 1103.520656]  [<c10c53bf>] ? do_execve+0xeb/0x456
[ 1103.520656]  [<c1009135>] sys_execve+0x31/0x53
[ 1103.520656]  [<c166faa2>] ptregs_execve+0x12/0x20
[ 1103.520656]  [<c166f9a3>] ? sysenter_do_call+0x12/0x38
[ 1103.520656] Rebooting in 10 seconds..
--
[    4.801716] Freeing unused kernel memory: 460k freed
[ 1103.512941] BUG: soft lockup - CPU#1 stuck for 1023s! [sleep:134]
[ 1103.512941] irq event stamp: 780
[ 1103.512941] hardirqs last  enabled at (779): [<c101e5d2>] do_page_fault+0x98/0x36e
[ 1103.512941] hardirqs last disabled at (780): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1103.517007] softirqs last  enabled at (22): [<c102e8ff>] __do_softirq+0x131/0x153
--
[    5.230581] Freeing unused kernel memory: 464k freed
[ 1104.515302] BUG: soft lockup - CPU#1 stuck for 1024s! [run-parts:122]
[ 1104.515302] irq event stamp: 1238
[ 1104.515302] hardirqs last  enabled at (1237): [<c101cfce>] do_page_fault+0x98/0x36e
[ 1104.515302] hardirqs last disabled at (1238): [<c166e77f>] apic_timer_interrupt+0x2f/0x40
[ 1104.515302] softirqs last  enabled at (0): [<c1025204>] copy_process+0x471/0xf82
[ 1104.515302] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1104.515302] Pid: 122, comm: run-parts Not tainted 3.5.0-bisect2-00646-g5b160bd #85  
[ 1104.515302] EIP: 0060:[<c1086e16>] EFLAGS: 00000246 CPU: 1
[ 1104.515302] EIP is at rcu_lockdep_current_cpu_online+0x0/0x51
[ 1104.515302] EAX: 00000000 EBX: cb4e695c ECX: 00000001 EDX: ce83c000
[ 1104.522494] [sched_delayed] sched: RT throttling activated
[ 1104.515302] ESI: 0000000c EDI: cb4bf851 EBP: ce83ddfc ESP: ce83dde0
[ 1104.515302]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.515302] CR0: 8005003b CR2: b774b696 CR3: 0e863000 CR4: 00000690
[ 1104.515302] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.515302] DR6: ffff0ff0 DR7: 00000400
[ 1104.515302] Process run-parts (pid: 122, ti=ce83c000 task=cf8a0000 task.ti=ce83c000)
[ 1104.515302] Stack:
[ 1104.515302]  c12a4768 00000000 00000001 00000000 cb4e695c 00000021 0000000c ce83de04
[ 1104.515302]  c12a4a88 ce83de2c c1094dcd 00000002 00000001 00000000 c1094d5a cb4e695c
[ 1104.515302]  ce861200 00000021 00000000 ce83de6c c1095082 00000000 00000001 0000036f
[ 1104.515302] Call Trace:
[ 1104.515302]  [<c12a4768>] ? radix_tree_lookup_element+0x3c/0x107
[ 1104.515302]  [<c12a4a88>] radix_tree_lookup_slot+0xd/0xf
[ 1104.515302]  [<c1094dcd>] find_get_page+0x8a/0x1a6
[ 1104.515302]  [<c1094d5a>] ? find_get_page+0x17/0x1a6
[ 1104.515302]  [<c1095082>] filemap_fault+0x77/0x35b
[ 1104.515302]  [<c10a9392>] __do_fault+0x88/0x38a
[ 1104.515302]  [<c10abc19>] handle_pte_fault+0x2c3/0x74c
[ 1104.515302]  [<c1020553>] ? kmap_atomic_prot+0x11f/0x133
[ 1104.515302]  [<c10ac137>] handle_mm_fault+0x95/0xa4
[ 1104.515302]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515302]  [<c101d26c>] do_page_fault+0x336/0x36e
[ 1104.515302]  [<c10acb14>] ? might_fault+0x7b/0x97
[ 1104.515302]  [<c100b09a>] ? set_tls_desc+0x14a/0x15d
[ 1104.515302]  [<c166dc75>] ? restore_all+0xf/0xf
[ 1104.515302]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515302]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515302]  [<c101c2fd>] do_async_page_fault+0x23/0x5f
[ 1104.515302]  [<c166e9bc>] error_code+0x6c/0x80
[ 1104.515302] Code: 51 c7 04 24 00 00 00 00 b9 00 f4 8f c1 e8 b9 fd ff ff c9 c3 55 89 e5 51 c7 04 24 00 00 00 00 b9 90 f6 8f c1 e8 a2 fd ff ff c9 c3 <55> 89 e5 89 e2 81 e2 00 e0 ff ff 8b 4a 14 b0 01 f7 c1 00 00 00
[ 1104.515302] Kernel panic - not syncing: softlockup: hung tasks
[ 1104.515302] Pid: 122, comm: run-parts Not tainted 3.5.0-bisect2-00646-g5b160bd #85
[ 1104.515302] Call Trace:
[ 1104.515302]  [<c1661ced>] panic+0x81/0x194
[ 1104.515302]  [<c107e202>] watchdog_timer_fn+0x115/0x134
[ 1104.515302]  [<c10413be>] hrtimer_run_queues+0x14c/0x1c6
[ 1104.515302]  [<c107e0ed>] ? __touch_watchdog+0x1d/0x1d
[ 1104.515302]  [<c10305c6>] run_local_timers+0x8/0x14
[ 1104.515302]  [<c10305f6>] update_process_times+0x24/0x58
[ 1104.515302]  [<c1060d52>] tick_periodic+0x66/0x72
[ 1104.515302]  [<c1060dac>] tick_handle_periodic+0x19/0x61
[ 1104.515302]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1104.515302]  [<c12aa280>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1104.515302]  [<c166e786>] apic_timer_interrupt+0x36/0x40
[ 1104.515302]  [<c1086e16>] ? call_rcu_sched+0x17/0x17
[ 1104.515302]  [<c12a4768>] ? radix_tree_lookup_element+0x3c/0x107
[ 1104.515302]  [<c12a4a88>] radix_tree_lookup_slot+0xd/0xf
[ 1104.515302]  [<c1094dcd>] find_get_page+0x8a/0x1a6
[ 1104.515302]  [<c1094d5a>] ? find_get_page+0x17/0x1a6
[ 1104.515302]  [<c1095082>] filemap_fault+0x77/0x35b
[ 1104.515302]  [<c10a9392>] __do_fault+0x88/0x38a
[ 1104.515302]  [<c10abc19>] handle_pte_fault+0x2c3/0x74c
[ 1104.515302]  [<c1020553>] ? kmap_atomic_prot+0x11f/0x133
[ 1104.515302]  [<c10ac137>] handle_mm_fault+0x95/0xa4
[ 1104.515302]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515302]  [<c101d26c>] do_page_fault+0x336/0x36e
[ 1104.515302]  [<c10acb14>] ? might_fault+0x7b/0x97
[ 1104.515302]  [<c100b09a>] ? set_tls_desc+0x14a/0x15d
[ 1104.515302]  [<c166dc75>] ? restore_all+0xf/0xf
[ 1104.515302]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515302]  [<c101c2da>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1104.515302]  [<c101c2fd>] do_async_page_fault+0x23/0x5f
[ 1104.515302]  [<c166e9bc>] error_code+0x6c/0x80
[ 1104.515302] Rebooting in 10 seconds..
--
[ 1105.513232] [sched_delayed] sched: RT throttling activated
[ 1105.513206] BUG: soft lockup - CPU#1 stuck for 1023s! [rc.local:123]
[ 1105.513206] irq event stamp: 326
[ 1105.513206] hardirqs last  enabled at (325): [<c106831d>] debug_check_no_locks_freed+0x14b/0x167
[ 1105.513206] hardirqs last disabled at (326): [<c167f38f>] apic_timer_interrupt+0x2f/0x40
[ 1105.513206] softirqs last  enabled at (0): [<c1026857>] copy_process+0x465/0xf8a
[ 1105.513206] softirqs last disabled at (0): [<  (null)>]   (null)
[ 1105.513206] Pid: 123, comm: rc.local Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79  
[ 1105.513206] EIP: 0060:[<c10df7c4>] EFLAGS: 00000246 CPU: 1
[ 1105.513206] EIP is at __mnt_drop_write+0x1/0x1a
[ 1105.513206] EAX: ce014110 EBX: cb438000 ECX: 00000000 EDX: 00000001
[ 1105.513206] ESI: ce014110 EDI: 00000000 EBP: ce879dbc ESP: ce879da4
[ 1105.513206]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.513206] CR0: 80050033 CR2: b7553baf CR3: 0e85a000 CR4: 00000690
[ 1105.513206] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.513206] DR6: ffff0ff0 DR7: 00000400
[ 1105.513206] Process rc.local (pid: 123, ti=ce878000 task=cf8ad5f0 task.ti=ce878000)
[ 1105.513206] Stack:
[ 1105.513206]  ce879dbc c10dd7bf 504bf223 ffffff88 ce889800 ce6a2f80 ce879e4c c1097f77
[ 1105.513206]  00001000 006f41e4 00000000 00000080 00000000 00000000 00000001 ce889884
[ 1105.513206]  ce879e90 00000000 00001000 00000080 00000000 cb438000 ce879ed4 00000000
[ 1105.513206] Call Trace:
[ 1105.513206]  [<c10dd7bf>] ? touch_atime+0xdc/0x104
[ 1105.513206]  [<c1097f77>] generic_file_aio_read+0x5b5/0x5f1
[ 1105.513206]  [<c10c78d1>] do_sync_read+0x75/0xb0
[ 1105.513206]  [<c10c7faa>] vfs_read+0x8b/0x10d
[ 1105.513206]  [<c10af901>] ? might_fault+0x26/0x99
[ 1105.513206]  [<c10c785c>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1105.513206]  [<c10cd050>] kernel_read+0x30/0x41
[ 1105.513206]  [<c10cd8d6>] prepare_binprm+0xfb/0x103
[ 1105.513206]  [<c10cdeaa>] do_execve+0x327/0x456
[ 1105.513206]  [<c10cdc6e>] ? do_execve+0xeb/0x456
[ 1105.546433]  [<c1009165>] sys_execve+0x31/0x53
[ 1105.546433]  [<c167f962>] ptregs_execve+0x12/0x20
[ 1105.546433]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1105.546433] Code: 00 00 e8 6c ba fe ff 89 d8 e8 91 ff ff ff 89 c6 85 c0 74 10 8b 43 08 8b 40 04 ba 01 00 00 00 e8 dd b9 fe ff 89 f0 5b 5e 5d c3 55 <89> e5 89 e2 81 e2 00 e0 ff ff ff 42 14 8b 40 0c 64 ff 48 04 ff
[ 1105.546433] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.546433] Pid: 123, comm: rc.local Not tainted 3.6.0-rc1-bisect2-00023-g8a13a4c #79
[ 1105.546433] Call Trace:
[ 1105.546433]  [<c1673678>] panic+0x97/0x1aa
[ 1105.546433]  [<c107fada>] watchdog_timer_fn+0x115/0x134
[ 1105.546433]  [<c10430d2>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.546433]  [<c107f9c5>] ? __touch_watchdog+0x1d/0x1d
[ 1105.546433]  [<c103205a>] run_local_timers+0x8/0x14
[ 1105.546433]  [<c103208a>] update_process_times+0x24/0x58
[ 1105.546433]  [<c106276e>] tick_periodic+0x66/0x72
[ 1105.546433]  [<c10627c8>] tick_handle_periodic+0x19/0x61
[ 1105.546433]  [<c1018bcd>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.546433]  [<c12b36c0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.546433]  [<c167f396>] apic_timer_interrupt+0x36/0x40
[ 1105.546433]  [<c10d00d8>] ? pipe_fcntl+0xbc/0x140
[ 1105.546433]  [<c10df7c4>] ? __mnt_drop_write+0x1/0x1a
[ 1105.546433]  [<c10dd7bf>] ? touch_atime+0xdc/0x104
[ 1105.546433]  [<c1097f77>] generic_file_aio_read+0x5b5/0x5f1
[ 1105.546433]  [<c10c78d1>] do_sync_read+0x75/0xb0
[ 1105.546433]  [<c10c7faa>] vfs_read+0x8b/0x10d
[ 1105.546433]  [<c10af901>] ? might_fault+0x26/0x99
[ 1105.546433]  [<c10c785c>] ? wait_on_retry_sync_kiocb+0x3f/0x3f
[ 1105.546433]  [<c10cd050>] kernel_read+0x30/0x41
[ 1105.546433]  [<c10cd8d6>] prepare_binprm+0xfb/0x103
[ 1105.546433]  [<c10cdeaa>] do_execve+0x327/0x456
[ 1105.546433]  [<c10cdc6e>] ? do_execve+0xeb/0x456
[ 1105.546433]  [<c1009165>] sys_execve+0x31/0x53
[ 1105.546433]  [<c167f962>] ptregs_execve+0x12/0x20
[ 1105.546433]  [<c167f863>] ? sysenter_do_call+0x12/0x38
[ 1105.546433] Rebooting in 10 seconds..
--
[    6.292044] Freeing unused kernel memory: 464k freed
[ 1105.523875] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1105.523875] irq event stamp: 13590
[ 1105.523875] hardirqs last  enabled at (13587): [<c16707f5>] restore_all_notrace+0x0/0x18
[ 1105.523875] hardirqs last disabled at (13588): [<c16712ff>] apic_timer_interrupt+0x2f/0x40
[ 1105.523875] softirqs last  enabled at (13590): [<c102cc9f>] _local_bh_enable+0xd/0xf
[ 1105.523875] softirqs last disabled at (13589): [<c102d10c>] irq_enter+0x2c/0x4d
[ 1105.523875] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-05018-g614a6d43 #82  
[ 1105.523875] EIP: 0060:[<c101c512>] EFLAGS: 00000282 CPU: 1
[ 1105.523875] EIP is at native_safe_halt+0x5/0x7
[ 1105.523875] EAX: ce062240 EBX: ffffffff ECX: ce062240 EDX: 00000007
[ 1105.523875] ESI: c195cbf0 EDI: ffff8b9f EBP: ce06bf68 ESP: ce06bf68
[ 1105.523875]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1105.523875] CR0: 8005003b CR2: b76e4fb8 CR3: 0e888000 CR4: 00000690
[ 1105.523875] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1105.523875] DR6: ffff0ff0 DR7: 00000400
[ 1105.523875] Process swapper/1 (pid: 0, ti=ce06a000 task=ce062240 task.ti=ce06a000)
[ 1105.523875] Stack:
[ 1105.523875]  ce06bf70 c10089d9 ce06bf88 c1009220 d1bf6876 e022ed99 1a6ddff1 cfff9fa0
[ 1105.523875]  ce06bfb4 c166027a 00000000 00000000 00000000 00000000 8a9ce88b 1a6ddff1
[ 1105.523875]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1105.523875] Call Trace:
[ 1105.523875]  [<c10089d9>] default_idle+0x2f/0x55
[ 1105.523875]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1105.523875]  [<c166027a>] start_secondary+0x292/0x29a
[ 1105.523875] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89
[ 1105.523875] Kernel panic - not syncing: softlockup: hung tasks
[ 1105.523875] Pid: 0, comm: swapper/1 Not tainted 3.5.0-bisect2-05018-g614a6d43 #82
[ 1105.523875] Call Trace:
[ 1105.523875]  [<c1664e92>] panic+0x81/0x194
[ 1105.523875]  [<c107e316>] watchdog_timer_fn+0x115/0x134
[ 1105.523875]  [<c10416fe>] hrtimer_run_queues+0x14c/0x1c6
[ 1105.523875]  [<c107e201>] ? __touch_watchdog+0x1d/0x1d
[ 1105.523875]  [<c10306a2>] run_local_timers+0x8/0x14
[ 1105.523875]  [<c10306d2>] update_process_times+0x24/0x58
[ 1105.523875]  [<c1061092>] tick_periodic+0x66/0x72
[ 1105.523875]  [<c10610ec>] tick_handle_periodic+0x19/0x61
[ 1105.523875]  [<c10176ad>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1105.523875]  [<c12aa9a0>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1105.523875]  [<c1671306>] apic_timer_interrupt+0x36/0x40
[ 1105.523875]  [<c101c512>] ? native_safe_halt+0x5/0x7
[ 1105.523875]  [<c10089d9>] default_idle+0x2f/0x55
[ 1105.523875]  [<c1009220>] cpu_idle+0xc9/0xfb
[ 1105.523875]  [<c166027a>] start_secondary+0x292/0x29a
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_fd >= 0' failed.
[ 1105.523875] Rebooting in 10 seconds..
--
[ 1103.519588] [sched_delayed] sched: RT throttling activated
[ 1103.517937] BUG: soft lockup - CPU#1 stuck for 1024s! [trinity:131]
[ 1103.517937] irq event stamp: 5400
[ 1103.517937] hardirqs last disabled at (5400): [<c166ce9f>] apic_timer_interrupt+0x2f/0x40
[ 1103.517937] softirqs last  enabled at (2968): [<c15eefbe>] unix_sock_destructor+0xae/0xb3
[ 1103.517937] softirqs last disabled at (2966): [<c15eefab>] unix_sock_destructor+0x9b/0xb3
[ 1103.517937] 
[ 1103.517937] Pid: 131, comm: trinity Not tainted 3.5.0-rc7-bisect2-00018-g2a8c088 #93  
[ 1103.517937] EIP: 0060:[<c10a7a06>] EFLAGS: 00010206 CPU: 1
[ 1103.517937] EIP is at __do_fault+0x100/0x38a
[ 1103.517937] EAX: c23b8000 EBX: c63b9000 ECX: 00000400 EDX: 00000163
[ 1103.517937] ESI: c63b9000 EDI: c23b8000 EBP: ce8b1eb8 ESP: ce8b1e74
[ 1103.517937]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.517937] CR0: 8005003b CR2: 0824cc48 CR3: 0e86d000 CR4: 00000690
[ 1103.517937] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.517937] DR6: ffff0ff0 DR7: 00000400
[ 1103.517937] Process trinity (pid: 131, ti=ce8b0000 task=ce8a9120 task.ti=ce8b0000)
[ 1103.517937] Stack:
[ 1103.517937]  00000000 ce826a34 00000001 00000001 0824cc48 ce826a00 00000370 00000200
[ 1103.517937]  ce850370 ce586700 00000029 00000204 0824c000 ce606720 ce850370 ce878930
[ 1103.517937]  00000204 ce8b1efc c10aa215 ce86d080 00000204 00000029 00000000 ce70ff00
[ 1103.517937] Call Trace:
[ 1103.517937]  [<c10aa215>] handle_pte_fault+0x2c3/0x74c
[ 1103.517937]  [<c101f00f>] ? kmap_atomic_prot+0x11f/0x133
[ 1103.517937]  [<c10aa733>] handle_mm_fault+0x95/0xa4
[ 1103.517937]  [<c101ad7a>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517937]  [<c101bd28>] do_page_fault+0x336/0x36e
[ 1103.517937]  [<c10400da>] ? up_write+0x16/0x2b
[ 1103.517937]  [<c10a259b>] ? vm_mmap_pgoff+0x50/0x59
[ 1103.517937]  [<c166c395>] ? restore_all+0xf/0xf
[ 1103.517937]  [<c101ad7a>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517937]  [<c101ad7a>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517937]  [<c101ad9d>] do_async_page_fault+0x23/0x5f
[ 1103.517937]  [<c166d0dc>] error_code+0x6c/0x80
[ 1103.517937] Code: c8 00 0f 84 cd 00 00 00 8b 55 dc f6 42 18 08 75 42 89 d8 e8 30 76 f7 ff 89 c3 8b 45 e0 e8 26 76 f7 ff b9 00 04 00 00 89 c7 89 de <f3> a5 e8 36 76 f7 ff 89 d8 e8 2f 76 f7 ff 8b 45 e0 0f ba 28 03 
[ 1103.517937] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.517937] Pid: 131, comm: trinity Not tainted 3.5.0-rc7-bisect2-00018-g2a8c088 #93
[ 1103.517937] Call Trace:
[ 1103.517937]  [<c1660345>] panic+0x81/0x194
[ 1103.517937]  [<c107cc9a>] watchdog_timer_fn+0x115/0x134
[ 1103.517937]  [<c103fe4a>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.517937]  [<c107cb85>] ? __touch_watchdog+0x1d/0x1d
[ 1103.517937]  [<c102f052>] run_local_timers+0x8/0x14
[ 1103.517937]  [<c102f082>] update_process_times+0x24/0x58
[ 1103.517937]  [<c105f7ae>] tick_periodic+0x66/0x72
[ 1103.517937]  [<c105f808>] tick_handle_periodic+0x19/0x61
[ 1103.517937]  [<c1016169>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.517937]  [<c12a8880>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.517937]  [<c166cea6>] apic_timer_interrupt+0x36/0x40
[ 1103.517937]  [<c10a7a06>] ? __do_fault+0x100/0x38a
[ 1103.517937]  [<c10aa215>] handle_pte_fault+0x2c3/0x74c
[ 1103.517937]  [<c101f00f>] ? kmap_atomic_prot+0x11f/0x133
[ 1103.517937]  [<c10aa733>] handle_mm_fault+0x95/0xa4
[ 1103.517937]  [<c101ad7a>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517937]  [<c101bd28>] do_page_fault+0x336/0x36e
[ 1103.517937]  [<c10400da>] ? up_write+0x16/0x2b
[ 1103.517937]  [<c10a259b>] ? vm_mmap_pgoff+0x50/0x59
[ 1103.517937]  [<c166c395>] ? restore_all+0xf/0xf
[ 1103.517937]  [<c101ad7a>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517937]  [<c101ad7a>] ? kvm_read_and_reset_pf_reason+0x33/0x33
[ 1103.517937]  [<c101ad9d>] do_async_page_fault+0x23/0x5f
[ 1103.517937]  [<c166d0dc>] error_code+0x6c/0x80
[ 1103.517937] hardirqs last  enabled at (5399): [<c109865c>] get_page_from_freelist+0x2ca/0x446
[ 1103.517937] Rebooting in 10 seconds..
--
[ 1104.518348] [sched_delayed] sched: RT throttling activated
[ 1104.519792] BUG: soft lockup - CPU#1 stuck for 1025s! [swapper/1:0]
[ 1104.519792] irq event stamp: 12060
[ 1104.519792] hardirqs last  enabled at (12057): [<c166c395>] restore_all_notrace+0x0/0x18
[ 1104.519792] hardirqs last disabled at (12058): [<c166ce9f>] apic_timer_interrupt+0x2f/0x40
[ 1104.519792] softirqs last  enabled at (12060): [<c102b64b>] _local_bh_enable+0xd/0xf
[ 1104.519792] softirqs last disabled at (12059): [<c102bab8>] irq_enter+0x2c/0x4d
[ 1104.519792] 
[ 1104.519792] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc7-bisect2-00018-g2a8c088 #93  
[ 1104.519792] EIP: 0060:[<c101aece>] EFLAGS: 00000286 CPU: 1
[ 1104.519792] EIP is at native_safe_halt+0x5/0x7
[ 1104.519792] EAX: ce060000 EBX: ffffffff ECX: ce060000 EDX: 00000007
[ 1104.519792] ESI: c1954c80 EDI: ffff8b9e EBP: ce05ff68 ESP: ce05ff68
[ 1104.519792]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1104.519792] CR0: 8005003b CR2: b77e052c CR3: 0f878000 CR4: 00000690
[ 1104.519792] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1104.519792] DR6: ffff0ff0 DR7: 00000400
[ 1104.519792] Process swapper/1 (pid: 0, ti=ce05e000 task=ce060000 task.ti=ce05e000)
[ 1104.519792] Stack:
[ 1104.519792]  ce05ff70 c10089b1 ce05ff88 c100920c 157956ca 23dcdbea 5e27d951 cfff9fa0
[ 1104.519792]  ce05ffb4 c165b4be 00000000 00000000 00000000 00000000 ce56e1ef 5e27d951
[ 1104.519792]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1104.519792] Call Trace:
--
[    4.512630] Freeing unused kernel memory: 456k freed
[ 1103.517164] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1103.517164] irq event stamp: 5018
[ 1103.517164] hardirqs last  enabled at (5015): [<c10089a1>] default_idle+0x1f/0x55
mountall: ply-ev[ 1103.517164] hardirqs last disabled at (5016): ent-loop.c:497: [<c166ce9f>] apic_timer_interrupt+0x2f/0x40
ply_event_loop_n[ 1103.517164] softirqs last  enabled at (5018): ew: Assertion `l[<c102b64b>] _local_bh_enable+0xd/0xf
oop->epoll_fd >=[ 1103.517164] softirqs last disabled at (5017):  0' failed.[<c102bab8>] irq_enter+0x2c/0x4d
[ 1103.526001] [sched_delayed] sched: RT throttling activated
[ 1103.517164] 
[ 1103.517164] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc7-bisect2-00018-g2a8c088 #93  
[ 1103.517164] EIP: 0060:[<c101aece>] EFLAGS: 00000286 CPU: 1
[ 1103.517164] EIP is at native_safe_halt+0x5/0x7

[ 1103.517164] EAX: ce060000 EBX: ffffffff ECX: ce060000 EDX: 00000007
[ 1103.517164] ESI: c1954c80 EDI: ffff8b9e EBP: ce05ff68 ESP: ce05ff68
[ 1103.517164]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.517164] CR0: 8005003b CR2: b7665bd0 CR3: 0e852000 CR4: 00000690
[ 1103.517164] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.517164] DR6: ffff0ff0 DR7: 00000400
[ 1103.517164] Process swapper/1 (pid: 0, ti=ce05e000 task=ce060000 task.ti=ce05e000)
[ 1103.517164] Stack:
[ 1103.517164]  ce05ff70 c10089b1 ce05ff88 c100920c
--
[    4.696250] Freeing unused kernel memory: 456k freed
[ 1103.520327] BUG: soft lockup - CPU#1 stuck for 1023s! [swapper/1:0]
[ 1103.520327] irq event stamp: 13124
[ 1103.520327] hardirqs last  enabled at (13121): [<c166c395>] restore_all_notrace+0x0/0x18
[ 1103.520327] hardirqs last disabled at (13122): [<c166ce9f>] apic_timer_interrupt+0x2f/0x40
[ 1103.520327] softirqs last  enabled at (13124): [<c102b64b>] _local_bh_enable+0xd/0xf
[ 1103.520327] softirqs last disabled at (13123): [<c102bab8>] irq_enter+0x2c/0x4d
[ 1103.520327] 
[ 1103.520327] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc7-bisect2-00018-g2a8c088 #93  
[ 1103.520327] EIP: 0060:[<c101aece>] EFLAGS: 00000286 CPU: 1
[ 1103.520327] EIP is at native_safe_halt+0x5/0x7
[ 1103.520327] EAX: ce060000 EBX: ffffffff ECX: ce060000 EDX: 00000007
[ 1103.520327] ESI: c1954c80 EDI: ffff8b9f EBP: ce05ff68 ESP: ce05ff68
[ 1103.520327]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1103.520327] CR0: 8005003b CR2: 08051f68 CR3: 0e876000 CR4: 00000690
[ 1103.520327] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1103.520327] DR6: ffff0ff0 DR7: 00000400
[ 1103.520327] Process swapper/1 (pid: 0, ti=ce05e000 task=ce060000 task.ti=ce05e000)
[ 1103.520327] Stack:
[ 1103.520327]  ce05ff70 c10089b1 ce05ff88 c100920c 95c987b1 a42d0cd0 de77b93b cfff9fa0
[ 1103.520327]  ce05ffb4 c165b4be 00000000 00000000 00000000 00000000 4ea6c1d9 de77b93b
[ 1103.520327]  01000800 0000d248 00000000 00000000 00000000 00000000 00000000 00000000
[ 1103.520327] Call Trace:
[ 1103.520327]  [<c10089b1>] default_idle+0x2f/0x55
[ 1103.520327]  [<c100920c>] cpu_idle+0xc9/0xfb
[ 1103.520327]  [<c165b4be>] start_secondary+0x29c/0x2a4
[ 1103.520327] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 <5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c6 89 55 f0 89 
[ 1103.520327] Kernel panic - not syncing: softlockup: hung tasks
[ 1103.520327] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc7-bisect2-00018-g2a8c088 #93
[ 1103.520327] Call Trace:
[ 1103.520327]  [<c1660345>] panic+0x81/0x194
[ 1103.520327]  [<c107cc9a>] watchdog_timer_fn+0x115/0x134
[ 1103.520327]  [<c103fe4a>] hrtimer_run_queues+0x14c/0x1c6
[ 1103.520327]  [<c107cb85>] ? __touch_watchdog+0x1d/0x1d
[ 1103.520327]  [<c102f052>] run_local_timers+0x8/0x14
[ 1103.520327]  [<c102f082>] update_process_times+0x24/0x58
[ 1103.520327]  [<c105f7ae>] tick_periodic+0x66/0x72
[ 1103.520327]  [<c105f808>] tick_handle_periodic+0x19/0x61
[ 1103.520327]  [<c1016169>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1103.520327]  [<c12a8880>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1103.520327]  [<c166cea6>] apic_timer_interrupt+0x36/0x40
[ 1103.520327]  [<c101aece>] ? native_safe_halt+0x5/0x7
[ 1103.520327]  [<c10089b1>] default_idle+0x2f/0x55
[ 1103.520327]  [<c100920c>] cpu_idle+0xc9/0xfb
[ 1103.520327]  [<c165b4be>] start_secondary+0x29c/0x2a4
[ 1103.520327] Rebooting in 10 seconds..

Thanks,
Fengguang

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-waimea-5039-2012-09-05-17-32-55-3.6.0-rc1-00023-g8a13a4c-66"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc1-00023-g8a13a4c (kbuild@kbuild) (gcc =
version 4.7.1 (Debian 4.7.1-6) ) #66 SMP Wed Sep 5 17:30:29 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[c00fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x023f90=
00-0x023fffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 198c000, base 00000000, lim=
it 00000000)
[    0.000000] cma: CMA: reserved 32 MiB at 0c000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128836(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c196e8f0, node_mem_map ce=
53f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 00000000000=
94000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 00000000001=
00000
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @ce52b000 s25040 r0 d15920 u40=
960
[    0.000000] pcpu-alloc: s25040 r0 d15920 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e52d500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64897
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 rcutre=
e.rcu_cpu_stall_timeout=3D100 branch=3Dslab/for-next log_buf_len=3D8M ignor=
e_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabl=
ed panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2012-09-05-17-30-34-slab:for-=
next:da9f26d-8a13a4c-i386-randconfig-k910-1-waimea BOOT_IMAGE=3Dkernel-test=
s/kernels/i386-randconfig-k910/8a13a4c/vmlinuz-3.6.0-rc1-00023-g8a13a4c
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524144 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 176216k/262136k available (6649k kernel code, 85420k=
 reserved, 3035k data, 460k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa96000 - 0xfffff000   (5540 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff3fe000   ( 748 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1976000 - 0xc19e9000   ( 460 kB)
[    0.000000]       .data : 0xc167e68a - 0xc1975360   (3035 kB)
[    0.000000]       .text : 0xc1000000 - 0xc167e68a   (6649 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D128, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dce008000 soft=3Dce00a000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 3300.030 MHz processor
[    0.040002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6600.06 BogoMIPS (lpj=3D33000300)
[    0.041789] pid_max: default: 32768 minimum: 301
[    0.050171] Mount-cache hash table entries: 512
[    0.051508] Initializing cgroup subsys memory
[    0.052271] Initializing cgroup subsys freezer
[    0.052980] Initializing cgroup subsys blkio
[    0.053722] Initializing cgroup subsys perf_event
[    0.054670] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.054670] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.054670] tlb_flushall_shift is 0x6
[    0.060519] ACPI: Core revision 20120711
[    0.062830] Getting VERSION: 50014
[    0.063360] Getting VERSION: 50014
[    0.063927] Getting ID: 0
[    0.064354] Getting ID: f000000
[    0.070016] Getting LVT0: 8700
[    0.070458] Getting LVT1: 8400
[    0.070918] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.071794] enabled ExtINT on CPU#0
[    0.073172] ENABLING IO-APIC IRQs
[    0.080009] init IO_APIC IRQs
[    0.080438]  apic 2 pin 0 not connected
[    0.081042] IOAPIC[0]: Set routing entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.082278] IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.083495] IOAPIC[0]: Set routing entry (2-3 -> 0x61 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.084682] IOAPIC[0]: Set routing entry (2-4 -> 0x71 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.090048] IOAPIC[0]: Set routing entry (2-5 -> 0x81 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.091350] IOAPIC[0]: Set routing entry (2-6 -> 0x91 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.092590] IOAPIC[0]: Set routing entry (2-7 -> 0xa1 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.093805] IOAPIC[0]: Set routing entry (2-8 -> 0xb1 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.095084] IOAPIC[0]: Set routing entry (2-9 -> 0xc1 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.096302] IOAPIC[0]: Set routing entry (2-10 -> 0xd1 -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.097571] IOAPIC[0]: Set routing entry (2-11 -> 0xe1 -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.100000] IOAPIC[0]: Set routing entry (2-12 -> 0x22 -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.100000] IOAPIC[0]: Set routing entry (2-13 -> 0x42 -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.100000] IOAPIC[0]: Set routing entry (2-14 -> 0x52 -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.100028] IOAPIC[0]: Set routing entry (2-15 -> 0x62 -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.101274]  apic 2 pin 16 not connected
[    0.101941]  apic 2 pin 17 not connected
[    0.102504]  apic 2 pin 18 not connected
[    0.103138]  apic 2 pin 19 not connected
[    0.103701]  apic 2 pin 20 not connected
[    0.104278]  apic 2 pin 21 not connected
[    0.104873]  apic 2 pin 22 not connected
[    0.105436]  apic 2 pin 23 not connected
[    0.110000] ..TIMER: vector=3D0x51 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.110008] smpboot: CPU0: Intel Common KVM processor stepping 01
[    0.111377] Using local APIC timer interrupts.
[    0.111377] calibrating APIC timer ...
[    0.130000] ... lapic delta =3D 6485209
[    0.130000] ... PM-Timer delta =3D 371424
[    0.130000] APIC calibration not consistent with PM-Timer: 103ms instead=
 of 100ms
[    0.130000] APIC delta adjusted to PM-Timer: 6250017 (6485209)
[    0.130000] TSC delta adjusted to PM-Timer: 330018262 (342437026)
[    0.130000] ..... delta 6250017
[    0.130000] ..... mult: 268436186
[    0.130000] ..... calibration result: 10000027
[    0.130000] ..... CPU clock speed is 3300.1826 MHz.
[    0.130000] ..... host bus clock speed is 1000.0027 MHz.
[    0.130068] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.132646] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.134503] SMP alternatives: lockdep: fixing up alternatives
[    0.136068] CPU 1 irqstacks, hard=3Dce082000 soft=3Dce084000
[    0.137284] smpboot: Booting Node   0, Processors  #1 OK
[    0.050000] Initializing CPU#1
[    0.050000] masked ExtINT on CPU#1
[    0.050000] calibrate_delay_direct() failed to get a good estimate for l=
oops_per_jiffy.
[    0.050000] Probably due to long platform interrupts. Consider using "lp=
j=3D" boot option.
[    0.420364] Brought up 2 CPUs
[    0.420842] ----------------
[    0.421293] | NMI testsuite:
[    0.421730] --------------------
[    0.422367]   remote IPI:[    0.420360] KVM setup async PF for cpu 1
[    0.420360] kvm-stealtime: cpu 1, msr e537500
  ok  |
[    0.450256]    local IPI:  ok  |
[    0.520023] --------------------
[    0.520646] Good, all   2 testcases passed! |
[    0.521452] ---------------------------------
[    0.522262] smpboot: Total of 2 processors activated (10112.78 BogoMIPS)
[    0.523596] CPU0 attaching sched-domain:
[    0.524313]  domain 0: span 0-1 level CPU
[    0.525093]   groups: 0 (cpu_power =3D 1023) 1
[    0.525994] CPU1 attaching sched-domain:
[    0.526868]  domain 0: span 0-1 level CPU
[    0.527618]   groups: 1 0 (cpu_power =3D 1023)
[    0.530803] devtmpfs: initialized
[    0.540041] device: 'platform': device_add
[    0.540835] PM: Adding info for No Bus:platform
[    0.541696] bus: 'platform': registered
[    0.542438] bus: 'cpu': registered
[    0.543084] device: 'cpu': device_add
[    0.543785] PM: Adding info for No Bus:cpu
[    0.550705] xor: automatically using best checksumming function:
[    0.650013]    pIII_sse  :   104.400 MB/sec
[    0.650781] atomic64 test passed for i386+ platform with CX8 and with SSE
[    0.651964] bus: 'virtio': registered
[    0.652621] cma: cma_init_reserved_areas()
[    0.653328] cma: cma_create_area(base 0000c000, count 2000)
[    0.662557] cma: cma_create_area: returned ce000510
[    0.663612] NET: Registered protocol family 16
[    0.664902] device class 'bdi': registering
[    0.670180] device class 'pci_bus': registering
[    0.670847] bus: 'pci': registered
[    0.671346] device class 'backlight': registering
[    0.672005] device class 'video_output': registering
[    0.672741] device class 'tty': registering
[    0.673367] bus: 'hsi': registered
[    0.673858] bus: 'i2c': registered
[    0.680006] bus: 'i2c': add driver dummy
[    0.680626] i2c-core: driver [dummy] registered
[    0.681977] ACPI: bus type pci registered
[    0.682693] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.683559] PCI: Using configuration type 1 for base access
[    0.684806] device: 'cpu0': device_add
[    0.685457] bus: 'cpu': add device cpu0
[    0.686041] PM: Adding info for cpu:cpu0
[    0.686728] device: 'cpu1': device_add
[    0.687311] bus: 'cpu': add device cpu1
[    0.687953] PM: Adding info for cpu:cpu1
[    0.694067] device: 'default': device_add
[    0.694780] PM: Adding info for No Bus:default
[    0.700350] bio: create slab <bio-0> at 0
[    0.701066] device class 'block': registering
[    0.870017] raid6: mmxx1     2539 MB/s
[    1.040024] raid6: mmxx2     2186 MB/s
[    1.210016] raid6: sse1x1    1924 MB/s
[    1.380011] raid6: sse1x2    3030 MB/s
[    1.550014] raid6: sse2x1    4598 MB/s
[    1.720012] raid6: sse2x2    6907 MB/s
[    1.720606] raid6: using algorithm sse2x2 (6907 MB/s)
[    1.721403] raid6: using intx1 recovery algorithm
[    1.722159] bus: 'i2c': add driver pca953x
[    1.722826] i2c-core: driver [pca953x] registered
[    1.724022] bus: 'i2c': add driver pcf857x
[    1.724642] i2c-core: driver [pcf857x] registered
[    1.725509] bus: 'i2c': add driver sx150x
[    1.726236] i2c-core: driver [sx150x] registered
[    1.727020] bus: 'platform': add driver tc3589x-gpio
[    1.728563] bus: 'platform': add driver twl4030_gpio
[    1.729489] device class 'graphics': registering
[    1.730036] ACPI: Added _OSI(Module Device)
[    1.730770] ACPI: Added _OSI(Processor Device)
[    1.732067] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.732874] ACPI: Added _OSI(Processor Aggregator Device)
[    1.735886] ACPI: EC: Look up EC in DSDT
[    1.740315] ACPI: Interpreter enabled
[    1.740937] ACPI: (supports S0 S3 S4 S5)
[    1.741654] ACPI: Using IOAPIC for interrupt routing
[    1.742465] bus: 'acpi': registered
[    1.743004] bus: 'acpi': add driver power
[    1.743823] device: 'LNXSYSTM:00': device_add
[    1.744540] bus: 'acpi': add device LNXSYSTM:00
[    1.745807] PM: Adding info for acpi:LNXSYSTM:00
[    1.746673] device: 'device:00': device_add
[    1.747392] bus: 'acpi': add device device:00
[    1.748200] PM: Adding info for acpi:device:00
[    1.749034] device: 'PNP0A03:00': device_add
[    1.750012] bus: 'acpi': add device PNP0A03:00
[    1.750797] PM: Adding info for acpi:PNP0A03:00
[    1.758171] device: 'device:01': device_add
[    1.758820] bus: 'acpi': add device device:01
[    1.760011] PM: Adding info for acpi:device:01
[    1.760721] device: 'device:02': device_add
[    1.761337] bus: 'acpi': add device device:02
[    1.762049] PM: Adding info for acpi:device:02
[    1.762826] device: 'PNP0B00:00': device_add
[    1.765529] bus: 'acpi': add device PNP0B00:00
[    1.766285] PM: Adding info for acpi:PNP0B00:00
[    1.767780] device: 'PNP0303:00': device_add
[    1.768495] bus: 'acpi': add device PNP0303:00
[    1.769254] PM: Adding info for acpi:PNP0303:00
[    1.770079] device: 'PNP0F13:00': device_add
[    1.770832] bus: 'acpi': add device PNP0F13:00
[    1.780020] PM: Adding info for acpi:PNP0F13:00
[    1.780875] device: 'PNP0700:00': device_add
[    1.781531] bus: 'acpi': add device PNP0700:00
[    1.782189] PM: Adding info for acpi:PNP0700:00
[    1.783010] device: 'PNP0400:00': device_add
[    1.783736] bus: 'acpi': add device PNP0400:00
[    1.784491] PM: Adding info for acpi:PNP0400:00
[    1.790141] device: 'PNP0501:00': device_add
[    1.790883] bus: 'acpi': add device PNP0501:00
[    1.791637] PM: Adding info for acpi:PNP0501:00
[    1.792535] device: 'device:03': device_add
[    1.793265] bus: 'acpi': add device device:03
[    1.794023] PM: Adding info for acpi:device:03
[    1.794865] device: 'device:04': device_add
[    1.795565] bus: 'acpi': add device device:04
[    1.796307] PM: Adding info for acpi:device:04
[    1.797137] device: 'device:05': device_add
[    1.797862] bus: 'acpi': add device device:05
[    1.798480] PM: Adding info for acpi:device:05
[    1.799190] device: 'device:06': device_add
[    1.800018] bus: 'acpi': add device device:06
[    1.800760] PM: Adding info for acpi:device:06
[    1.801606] device: 'device:07': device_add
[    1.802288] bus: 'acpi': add device device:07
[    1.803152] PM: Adding info for acpi:device:07
[    1.803958] device: 'device:08': device_add
[    1.804669] bus: 'acpi': add device device:08
[    1.805376] PM: Adding info for acpi:device:08
[    1.806178] device: 'device:09': device_add
[    1.810015] bus: 'acpi': add device device:09
[    1.810793] PM: Adding info for acpi:device:09
[    1.811621] device: 'device:0a': device_add
[    1.812336] bus: 'acpi': add device device:0a
[    1.820015] PM: Adding info for acpi:device:0a
[    1.820799] device: 'device:0b': device_add
[    1.821515] bus: 'acpi': add device device:0b
[    1.822270] PM: Adding info for acpi:device:0b
[    1.823048] device: 'device:0c': device_add
[    1.830018] bus: 'acpi': add device device:0c
[    1.830713] PM: Adding info for acpi:device:0c
[    1.831562] device: 'device:0d': device_add
[    1.832271] bus: 'acpi': add device device:0d
[    1.833011] PM: Adding info for acpi:device:0d
[    1.840070] device: 'device:0e': device_add
[    1.840762] bus: 'acpi': add device device:0e
[    1.841478] PM: Adding info for acpi:device:0e
[    1.842266] device: 'device:0f': device_add
[    1.842945] bus: 'acpi': add device device:0f
[    1.850015] PM: Adding info for acpi:device:0f
[    1.850836] device: 'device:10': device_add
[    1.851545] bus: 'acpi': add device device:10
[    1.852278] PM: Adding info for acpi:device:10
[    1.853021] device: 'device:11': device_add
[    1.860012] bus: 'acpi': add device device:11
[    1.860750] PM: Adding info for acpi:device:11
[    1.861547] device: 'device:12': device_add
[    1.862257] bus: 'acpi': add device device:12
[    1.862978] PM: Adding info for acpi:device:12
[    1.870071] device: 'device:13': device_add
[    1.870742] bus: 'acpi': add device device:13
[    1.871460] PM: Adding info for acpi:device:13
[    1.872229] device: 'device:14': device_add
[    1.872925] bus: 'acpi': add device device:14
[    1.877785] PM: Adding info for acpi:device:14
[    1.878601] device: 'device:15': device_add
[    1.879280] bus: 'acpi': add device device:15
[    1.880011] PM: Adding info for acpi:device:15
[    1.880794] device: 'device:16': device_add
[    1.882384] bus: 'acpi': add device device:16
[    1.883025] PM: Adding info for acpi:device:16
[    1.883796] device: 'device:17': device_add
[    1.884485] bus: 'acpi': add device device:17
[    1.885168] PM: Adding info for acpi:device:17
[    1.885960] device: 'device:18': device_add
[    1.886645] bus: 'acpi': add device device:18
[    1.887351] PM: Adding info for acpi:device:18
[    1.888089] device: 'device:19': device_add
[    1.888765] bus: 'acpi': add device device:19
[    1.889467] PM: Adding info for acpi:device:19
[    1.890078] device: 'device:1a': device_add
[    1.900023] bus: 'acpi': add device device:1a
[    1.900708] PM: Adding info for acpi:device:1a
[    1.901487] device: 'device:1b': device_add
[    1.902152] bus: 'acpi': add device device:1b
[    1.902879] PM: Adding info for acpi:device:1b
[    1.903646] device: 'device:1c': device_add
[    1.904299] bus: 'acpi': add device device:1c
[    1.910011] PM: Adding info for acpi:device:1c
[    1.910782] device: 'device:1d': device_add
[    1.911490] bus: 'acpi': add device device:1d
[    1.912189] PM: Adding info for acpi:device:1d
[    1.912978] device: 'device:1e': device_add
[    1.913672] bus: 'acpi': add device device:1e
[    1.914388] PM: Adding info for acpi:device:1e
[    1.915135] device: 'device:1f': device_add
[    1.915844] bus: 'acpi': add device device:1f
[    1.920017] PM: Adding info for acpi:device:1f
[    1.920810] device: 'device:20': device_add
[    1.921488] bus: 'acpi': add device device:20
[    1.922222] PM: Adding info for acpi:device:20
[    1.923145] device: 'device:21': device_add
[    1.923874] bus: 'acpi': add device device:21
[    1.924571] PM: Adding info for acpi:device:21
[    1.925414] device: 'device:22': device_add
[    1.926113] bus: 'acpi': add device device:22
[    1.930011] PM: Adding info for acpi:device:22
[    1.931007] device: 'PNP0103:00': device_add
[    1.931741] bus: 'acpi': add device PNP0103:00
[    1.932477] PM: Adding info for acpi:PNP0103:00
[    1.933394] device: 'PNP0C0F:00': device_add
[    1.940015] bus: 'acpi': add device PNP0C0F:00
[    1.940773] PM: Adding info for acpi:PNP0C0F:00
[    1.941703] device: 'PNP0C0F:01': device_add
[    1.942458] bus: 'acpi': add device PNP0C0F:01
[    1.943171] PM: Adding info for acpi:PNP0C0F:01
[    1.950179] device: 'PNP0C0F:02': device_add
[    1.950912] bus: 'acpi': add device PNP0C0F:02
[    1.951678] PM: Adding info for acpi:PNP0C0F:02
[    1.952568] device: 'PNP0C0F:03': device_add
[    1.953260] bus: 'acpi': add device PNP0C0F:03
[    1.960014] PM: Adding info for acpi:PNP0C0F:03
[    1.960921] device: 'PNP0C0F:04': device_add
[    1.970010] bus: 'acpi': add device PNP0C0F:04
[    1.970776] PM: Adding info for acpi:PNP0C0F:04
[    1.971632] device: 'LNXCPU:00': device_add
[    1.980016] bus: 'acpi': add device LNXCPU:00
[    1.980739] PM: Adding info for acpi:LNXCPU:00
[    1.981560] device: 'LNXCPU:01': device_add
[    1.982294] bus: 'acpi': add device LNXCPU:01
[    1.983033] PM: Adding info for acpi:LNXCPU:01
[    1.990109] device: 'device:23': device_add
[    1.990784] bus: 'acpi': add device device:23
[    1.991521] PM: Adding info for acpi:device:23
[    1.992297] device: 'LNXPWRBN:00': device_add
[    1.992998] bus: 'acpi': add device LNXPWRBN:00
[    2.000017] PM: Adding info for acpi:LNXPWRBN:00
[    2.001131] bus: 'acpi': add driver ec
[    2.010157] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    2.013809] bus: 'acpi': add driver pci_root
[    2.014548] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    2.020010] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    2.021295] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.030085] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    2.032039] device: 'pci0000:00': device_add
[    2.032792] PM: Adding info for No Bus:pci0000:00
[    2.040023] device: '0000:00': device_add
[    2.040715] PM: Adding info for No Bus:0000:00
[    2.041635] PCI host bridge to bus 0000:00
[    2.042331] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    2.050007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.050914] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.051916] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    2.052914] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    2.060008] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    2.062064] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.063439] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.065030] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.071062] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    2.081268] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.082731] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    2.090019] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    2.091324] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.093735] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    2.095787] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    2.104147] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    2.105821] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.110443] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    2.112185] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    2.121913] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    2.130507] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    2.131794] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    2.135654] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.137081] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    2.138681] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    2.144531] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.145944] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    2.150765] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    2.158215] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.160050] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    2.161681] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    2.171381] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    2.179773] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    2.180768] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    2.193240] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    2.200050] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    2.204566] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    2.212904] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    2.220054] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    2.223239] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    2.232842] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    2.240289] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    2.248789] pci_bus 0000:00: on NUMA node 0
[    2.250048] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.255485]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    2.256864] device: '0000:00:00.0': device_add
[    2.260284] bus: 'pci': add device 0000:00:00.0
[    2.261106] PM: Adding info for pci:0000:00:00.0
[    2.263481] device: '0000:00:01.0': device_add
[    2.264882] bus: 'pci': add device 0000:00:01.0
[    2.265699] PM: Adding info for pci:0000:00:01.0
[    2.270020] device: '0000:00:01.1': device_add
[    2.271419] bus: 'pci': add device 0000:00:01.1
[    2.272210] PM: Adding info for pci:0000:00:01.1
[    2.276338] device: '0000:00:01.3': device_add
[    2.280671] bus: 'pci': add device 0000:00:01.3
[    2.281452] PM: Adding info for pci:0000:00:01.3
[    2.290033] device: '0000:00:02.0': device_add
[    2.291603] bus: 'pci': add device 0000:00:02.0
[    2.292404] PM: Adding info for pci:0000:00:02.0
[    2.293149] device: '0000:00:03.0': device_add
[    2.300686] bus: 'pci': add device 0000:00:03.0
[    2.303464] PM: Adding info for pci:0000:00:03.0
[    2.304249] device: '0000:00:04.0': device_add
[    2.308316] bus: 'pci': add device 0000:00:04.0
[    2.309126] PM: Adding info for pci:0000:00:04.0
[    2.310018] device: '0000:00:05.0': device_add
[    2.314994] bus: 'pci': add device 0000:00:05.0
[    2.318703] PM: Adding info for pci:0000:00:05.0
[    2.320021] device: '0000:00:06.0': device_add
[    2.321444] bus: 'pci': add device 0000:00:06.0
[    2.324170] PM: Adding info for pci:0000:00:06.0
[    2.324928] device: '0000:00:07.0': device_add
[    2.326412] bus: 'pci': add device 0000:00:07.0
[    2.327183] PM: Adding info for pci:0000:00:07.0
[    2.330022] device: '0000:00:08.0': device_add
[    2.331454] bus: 'pci': add device 0000:00:08.0
[    2.332237] PM: Adding info for pci:0000:00:08.0
[    2.336380] device: '0000:00:09.0': device_add
[    2.340397] bus: 'pci': add device 0000:00:09.0
[    2.341214] PM: Adding info for pci:0000:00:09.0
[    2.342006] device: '0000:00:0a.0': device_add
[    2.346802] bus: 'pci': add device 0000:00:0a.0
[    2.347569] PM: Adding info for pci:0000:00:0a.0
[    2.350022] device: '0000:00:0b.0': device_add
[    2.351444] bus: 'pci': add device 0000:00:0b.0
[    2.352245] PM: Adding info for pci:0000:00:0b.0
[    2.356407] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    2.360036] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    2.361334] bus: 'acpi': add driver pci_link
[    2.364062] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    2.365430] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    2.366821] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.368008] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    2.369131] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    2.370009] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    2.371335] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    2.372779] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.373809] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    2.374869] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    2.376276] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    2.377634] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    2.379015] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.380367] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    2.381483] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    2.382738] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    2.384261] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    2.385701] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.386731] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    2.387943] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    2.389147] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    2.390005] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    2.391426] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.392378] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    2.393487] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    2.394816] bus: 'pnp': registered
[    2.395519] device class 'misc': registering
[    2.396297] device: 'vga_arbiter': device_add
[    2.397299] PM: Adding info for No Bus:vga_arbiter
[    2.398215] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.400017] vgaarb: loaded
[    2.400478] vgaarb: bridge control possible 0000:00:02.0
[    2.401393] bus: 'i2c': add driver tc3589x
[    2.402153] i2c-core: driver [tc3589x] registered
[    2.402911] tps65010: version 2 May 2005
[    2.403712] bus: 'i2c': add driver tps65010
[    2.404422] i2c-core: driver [tps65010] registered
[    2.405326] bus: 'i2c': remove driver tps65010
[    2.406075] driver: 'tps65010': driver_release
[    2.406819] i2c-core: driver [tps65010] unregistered
[    2.420047] bus: 'i2c': add driver tps65010
[    2.420787] i2c-core: driver [tps65010] registered
[    2.421590] bus: 'i2c': remove driver tps65010
[    2.422313] driver: 'tps65010': driver_release
[    2.423093] i2c-core: driver [tps65010] unregistered
[    2.440025] bus: 'i2c': add driver tps65010
[    2.440772] i2c-core: driver [tps65010] registered
[    2.441543] bus: 'i2c': remove driver tps65010
[    2.442295] driver: 'tps65010': driver_release
[    2.443035] i2c-core: driver [tps65010] unregistered
[    2.443850] tps65010: no chip?
[    2.444344] bus: 'i2c': add driver tps65910
[    2.445052] i2c-core: driver [tps65910] registered
[    2.445850] bus: 'i2c': add driver twl
[    2.446657] i2c-core: driver [twl] registered
[    2.447391] bus: 'i2c': add driver mc13xxx
[    2.448210] i2c-core: driver [mc13xxx] registered
[    2.449049] bus: 'i2c': add driver da903x
[    2.449741] i2c-core: driver [da903x] registered
[    2.450008] bus: 'i2c': add driver da9052
[    2.450719] i2c-core: driver [da9052] registered
[    2.451661] bus: 'i2c': add driver max77686
[    2.452386] i2c-core: driver [max77686] registered
[    2.453156] bus: 'i2c': add driver max77693
[    2.453874] i2c-core: driver [max77693] registered
[    2.454679] bus: 'i2c': add driver ab3100
[    2.458787] i2c-core: driver [ab3100] registered
[    2.460014] bus: 'i2c': add driver tps65090
[    2.460720] i2c-core: driver [tps65090] registered
[    2.461508] bus: 'i2c': add driver aat2870
[    2.462504] i2c-core: driver [aat2870] registered
[    2.465910] bus: 'i2c': add driver palmas
[    2.466656] i2c-core: driver [palmas] registered
[    2.467429] bus: 'i2c': add driver sec_pmic
[    2.470017] i2c-core: driver [sec_pmic] registered
[    2.471000] device class 'scsi_host': registering
[    2.475390] bus: 'scsi': registered
[    2.476122] device class 'scsi_device': registering
[    2.476973] SCSI subsystem initialized
[    2.480022] ACPI: bus type scsi registered
[    2.490039] device class 'ata_link': registering
[    2.490791] device class 'ata_port': registering
[    2.491559] device class 'ata_device': registering
[    2.492368] libata version 3.00 loaded.
[    2.493019] device class 'mdio_bus': registering
[    2.493764] bus: 'mdio_bus': registered
[    2.494387] bus: 'mdio_bus': add driver Generic PHY
[    2.495192] device class 'pcmcia_socket': registering
[    2.496071] ACPI: bus type usb registered
[    2.496716] bus: 'usb': registered
[    2.500029] bus: 'usb': add driver usbfs
[    2.510031] usbcore: registered new interface driver usbfs
[    2.510955] bus: 'usb': add driver hub
[    2.511571] usbcore: registered new interface driver hub
[    2.524730] bus: 'usb': add driver usb
[    2.525404] usbcore: registered new device driver usb
[    2.526226] bus: 'serio': registered
[    2.526812] bus: 'gameport': registered
[    2.527433] device class 'input': registering
[    2.528171] device class 'power_supply': registering
[    2.528992] device class 'hwmon': registering
[    2.530018] device class 'watchdog': registering
[    2.535901] bus: 'mmc': registered
[    2.536473] device class 'mmc_host': registering
[    2.537322] bus: 'sdio': registered
[    2.537877] device class 'leds': registering
[    2.538579] device class 'devfreq': registering
[    2.539320] bus: 'iio': registered
[    2.540022] device class 'sound': registering
[    2.540733] PCI: Using ACPI for IRQ routing
[    2.541416] PCI: pci_cache_line_size set to 64 bytes
[    2.542580] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    2.543517] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    2.544453] device class 'net': registering
[    2.545163] device: 'lo': device_add
[    2.550177] PM: Adding info for No Bus:lo
[    2.551056] Bluetooth: Core ver 2.16
[    2.551669] device class 'bluetooth': registering
[    2.552408] NET: Registered protocol family 31
[    2.553115] Bluetooth: HCI device and connection manager initialized
[    2.554144] Bluetooth: HCI socket layer initialized
[    2.554939] Bluetooth: L2CAP socket layer initialized
[    2.555782] Bluetooth: SCO socket layer initialized
[    2.556533] NET: Registered protocol family 8
[    2.557222] NET: Registered protocol family 20
[    2.560021] device class 'atm': registering
[    2.561304] Switching to clocksource hpet
[    2.562229] FS-Cache: Loaded
[    2.562741] device: 'cachefiles': device_add
[    2.565672] PM: Adding info for No Bus:cachefiles
[    2.566465] CacheFiles: Loaded
[    2.567016] bus: 'pnp': add driver system
[    2.567712] pnp: PnP ACPI init
[    2.568243] device: 'pnp0': device_add
[    2.569184] PM: Adding info for No Bus:pnp0
[    2.569184] ACPI: bus type pnp registered
[    2.569184] pnp 00:00: [bus 00-ff]
[    2.569184] pnp 00:00: [io  0x0cf8-0x0cff]
[    2.570003] pnp 00:00: [io  0x0000-0x0cf7 window]
[    2.570779] pnp 00:00: [io  0x0d00-0xffff window]
[    2.571520] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    2.572406] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    2.580093] device: '00:00': device_add
[    2.580825] bus: 'pnp': add device 00:00
[    2.581485] PM: Adding info for pnp:00:00
[    2.583780] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    2.584911] pnp 00:01: [io  0x0070-0x0071]
[    2.585622] pnp 00:01: [irq 8]
[    2.590334] pnp 00:01: [io  0x0072-0x0077]
[    2.591023] device: '00:01': device_add
[    2.591715] bus: 'pnp': add device 00:01
[    2.592353] PM: Adding info for pnp:00:01
[    2.593037] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.598879] pnp 00:02: [io  0x0060]
[    2.599454] pnp 00:02: [io  0x0064]
[    2.602044] pnp 00:02: [irq 1]
[    2.602548] device: '00:02': device_add
[    2.603223] bus: 'pnp': add device 00:02
[    2.606508] PM: Adding info for pnp:00:02
[    2.610608] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.611733] pnp 00:03: [irq 12]
[    2.612256] device: '00:03': device_add
[    2.612932] bus: 'pnp': add device 00:03
[    2.617004] PM: Adding info for pnp:00:03
[    2.617691] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.618987] pnp 00:04: [io  0x03f2-0x03f5]
[    2.619687] pnp 00:04: [io  0x03f7]
[    2.623669] pnp 00:04: [irq 6]
[    2.624217] pnp 00:04: [dma 2]
[    2.624745] device: '00:04': device_add
[    2.625378] bus: 'pnp': add device 00:04
[    2.630261] PM: Adding info for pnp:00:04
[    2.630932] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.632101] pnp 00:05: [io  0x0378-0x037f]
[    2.632795] pnp 00:05: [irq 7]
[    2.638004] device: '00:05': device_add
[    2.638705] bus: 'pnp': add device 00:05
[    2.639348] PM: Adding info for pnp:00:05
[    2.642758] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.643878] pnp 00:06: [io  0x03f8-0x03ff]
[    2.644526] pnp 00:06: [irq 4]
[    2.645115] device: '00:06': device_add
[    2.645761] bus: 'pnp': add device 00:06
[    2.646396] PM: Adding info for pnp:00:06
[    2.647067] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.648416] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    2.649227] device: '00:07': device_add
[    2.649912] bus: 'pnp': add device 00:07
[    2.650540] PM: Adding info for pnp:00:07
[    2.651191] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.669466] pnp: PnP ACPI: found 8 devices
[    2.670148] ACPI: ACPI bus type pnp unregistered
[    2.670941] device class 'mem': registering
[    2.671647] device: 'mem': device_add
[    2.684656] PM: Adding info for No Bus:mem
[    2.685327] device: 'null': device_add
[    2.686035] PM: Adding info for No Bus:null
[    2.686742] device: 'port': device_add
[    2.687400] PM: Adding info for No Bus:port
[    2.688124] device: 'zero': device_add
[    2.688807] PM: Adding info for No Bus:zero
[    2.689474] device: 'full': device_add
[    2.690228] PM: Adding info for No Bus:full
[    2.690918] device: 'random': device_add
[    2.701662] PM: Adding info for No Bus:random
[    2.702396] device: 'urandom': device_add
[    2.703151] PM: Adding info for No Bus:urandom
[    2.703903] device: 'kmsg': device_add
[    2.704613] PM: Adding info for No Bus:kmsg
[    2.705266] device: 'oldmem': device_add
[    2.705997] PM: Adding info for No Bus:oldmem
[    2.706742] device: 'tty': device_add
[    2.707396] PM: Adding info for No Bus:tty
[    2.708143] device: 'console': device_add
[    2.718657] PM: Adding info for No Bus:console
[    2.719370] device class 'firmware': registering
[    2.720168] bus: 'pcmcia': registered
[    2.720806] device class 'thermal': registering
[    2.756279] bus: 'bcma': registered
[    2.756939] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.758083] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.758996] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.760079] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    2.761130] NET: Registered protocol family 1
[    2.763605] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.764659] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.770210] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.771253] pci 0000:00:02.0: Boot video device
[    2.772138] PCI: CLS 0 bytes, default 64
[    2.772989] Unpacking initramfs...
[    4.490010] Freeing initrd memory: 25284k freed
[    4.521090] DMA-API: preallocated 32768 debug entries
[    4.522005] DMA-API: debugging enabled by kernel config
[    4.523821] device class 'msr': registering
[    4.524667] device: 'msr0': device_add
[    4.525352] PM: Adding info for No Bus:msr0
[    4.525986] device: 'msr1': device_add
[    4.526676] PM: Adding info for No Bus:msr1
[    4.527267] apm: BIOS not found.
[    4.528258] The force parameter has not been set to 1 so the Iris powero=
ff handler will not be installed.
[    4.529778] NatSemi SCx200 Driver
[    4.530383] bus: 'pci': add driver scx200
[    4.531130] device: 'snapshot': device_add
[    4.531759] PM: Adding info for No Bus:snapshot
[    4.532408] bus: 'clocksource': registered
[    4.533008] device: 'clocksource': device_add
[    4.533650] PM: Adding info for No Bus:clocksource
[    4.534425] device: 'clocksource0': device_add
[    4.535075] bus: 'clocksource': add device clocksource0
[    4.535837] PM: Adding info for clocksource:clocksource0
[    4.536703] bus: 'platform': add driver alarmtimer
[    4.537462] Registering platform device 'alarmtimer'. Parent at platform
[    4.538700] device: 'alarmtimer': device_add
[    4.539388] bus: 'platform': add device alarmtimer
[    4.540170] PM: Adding info for platform:alarmtimer
[    4.540967] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    4.542452] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    4.543809] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    4.546510] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    4.548061] bus: 'rttest': registered
[    4.548678] device: 'rttest': device_add
[    4.549297] PM: Adding info for No Bus:rttest
[    4.550420] device: 'rttest0': device_add
[    4.551090] bus: 'rttest': add device rttest0
[    4.551803] PM: Adding info for rttest:rttest0
[    4.556690] device: 'rttest1': device_add
[    4.557335] bus: 'rttest': add device rttest1
[    4.558111] PM: Adding info for rttest:rttest1
[    4.559163] device: 'rttest2': device_add
[    4.559823] bus: 'rttest': add device rttest2
[    4.560522] PM: Adding info for rttest:rttest2
[    4.563414] device: 'rttest3': device_add
[    4.564118] bus: 'rttest': add device rttest3
[    4.564854] PM: Adding info for rttest:rttest3
[    4.567680] device: 'rttest4': device_add
[    4.568375] bus: 'rttest': add device rttest4
[    4.569102] PM: Adding info for rttest:rttest4
[    4.571898] device: 'rttest5': device_add
[    4.572528] bus: 'rttest': add device rttest5
[    4.573248] PM: Adding info for rttest:rttest5
[    4.582439] device: 'rttest6': device_add
[    4.583114] bus: 'rttest': add device rttest6
[    4.583828] PM: Adding info for rttest:rttest6
[    4.584718] device: 'rttest7': device_add
[    4.585357] bus: 'rttest': add device rttest7
[    4.586081] PM: Adding info for rttest:rttest7
[    4.590942] Initializing RT-Tester: OK
[    4.591650] audit: initializing netlink socket (disabled)
[    4.592604] type=3D2000 audit(1346837563.590:1): initialized
[    4.593490] rcu-torture:--- Start of test: nreaders=3D4 nfakewriters=3D4=
 stat_interval=3D0 verbose=3D0 test_no_idle_hz=3D0 shuffle_interval=3D3 stu=
tter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 tes=
t_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    4.627368] bus: 'event_source': registered
[    4.628068] device: 'breakpoint': device_add
[    4.628756] bus: 'event_source': add device breakpoint
[    4.629716] PM: Adding info for event_source:breakpoint
[    4.630670] device: 'software': device_add
[    4.631313] bus: 'event_source': add device software
[    4.632123] PM: Adding info for event_source:software
[    4.640554] VFS: Disk quotas dquot_6.5.2
[    4.641284] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.646931] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    4.648728] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    4.649630] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    4.652285] jffs2: version 2.2. (SUMMARY) =20
[    4.653702] QNX4 filesystem 0.2.3 registered.
[    4.656658] QNX6 filesystem 1.0.0 registered.
[    4.657364] device: 'autofs': device_add
[    4.659995] PM: Adding info for No Bus:autofs
[    4.660727] fuse init (API version 7.19)
[    4.661432] device: 'fuse': device_add
[    4.662095] PM: Adding info for No Bus:fuse
[    4.664873] SGI XFS with security attributes, realtime, large block/inod=
e numbers, debug enabled
[    4.704937] OCFS2 1.5.0
[    4.705651] ocfs2 stack glue: unable to register sysctl
[    4.706668] OCFS2 DLMFS 1.5.0
[    4.707326] OCFS2 User DLM kernel interface loaded
[    4.708119] OCFS2 Node Manager 1.5.0
[    4.718029] io scheduler noop registered (default)
[    4.719037] list_sort_test: start testing list_sort()
[    4.720203] xz_dec_test: module loaded
[    4.720828] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
252 0' and write .xz files to it.
[    4.729934] bus: 'platform': add driver basic-mmio-gpio
[    4.731110] bus: 'platform': add driver hecubafb
[    4.731855] no IO addresses supplied
[    4.732409] bus: 'platform': add driver metronomefb
[    4.733212] bus: 'platform': add driver broadsheetfb
[    4.738120] bus: 'platform': add driver auo_k1900fb
[    4.739099] bus: 'platform': add driver auo_k1901fb
[    4.739908] bus: 'platform': add driver s1d13xxxfb
[    4.740694] bus: 'platform': add driver sm501-fb
[    4.741424] bus: 'usb': add driver smscufx
[    4.742109] usbcore: registered new interface driver smscufx
[    4.751180] bus: 'acpi': add driver ac
[    4.751841] bus: 'acpi': add driver button
[    4.752509] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[    4.753828] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[    4.763276] device: 'input0': device_add
[    4.764066] PM: Adding info for No Bus:input0
[    4.764869] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.766071] ACPI: Power Button [PWRF]
[    4.767206] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    4.768325] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[    4.769522] bus: 'acpi': add driver fan
[    4.770543] bus: 'acpi': add driver processor
[    4.771292] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[    4.772650] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[    4.774115] device: 'cooling_device0': device_add
[    4.774990] PM: Adding info for No Bus:cooling_device0
[    4.775873] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[    4.776972] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[    4.778555] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[    4.780153] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[    4.781528] device: 'cooling_device1': device_add
[    4.782389] PM: Adding info for No Bus:cooling_device1
[    4.783284] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[    4.784461] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[    4.787772] bus: 'acpi': add driver container
[    4.789943] bus: 'acpi': add driver thermal
[    4.790882] bus: 'virtio': add driver virtio_balloon
[    4.806379] device: 'ptmx': device_add
[    4.807217] bus: 'acpi': add driver battery
[    4.808010] PM: Adding info for No Bus:ptmx
[    4.808768] HDLC line discipline maxframe=3D4096
[    4.809523] N_HDLC line discipline registered.
[    4.810439] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.811363] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.812386] Registering platform device 'serial8250'. Parent at platform
[    4.813439] device: 'serial8250': device_add
[    4.814381] bus: 'platform': add device serial8250
[    4.815181] PM: Adding info for platform:serial8250
[    4.868887] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.869965] device: 'ttyS0': device_add
[    4.874971] PM: Adding info for No Bus:ttyS0
[    4.875876] device: 'ttyS1': device_add
[    4.876656] PM: Adding info for No Bus:ttyS1
[    4.877477] device: 'ttyS2': device_add
[    4.882367] PM: Adding info for No Bus:ttyS2
[    4.883074] device: 'ttyS3': device_add
[    4.883730] PM: Adding info for No Bus:ttyS3
[    4.884378] bus: 'platform': add driver serial8250
[    4.885066] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    4.886387] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    4.887548] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    4.888759] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    4.894063] bus: 'pnp': add driver serial
[    4.894939] bus: 'pnp': driver_probe_device: matched device 00:06 with d=
river serial
[    4.896283] bus: 'pnp': really_probe: probing driver serial with device =
00:06
[    4.897637] device: 'ttyS0': device_unregister
[    4.898538] PM: Removing info for No Bus:ttyS0
[    4.899884] device: 'ttyS0': device_create_release
[    4.943757] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.944645] device: 'ttyS0': device_add
[    4.945300] PM: Adding info for No Bus:ttyS0
[    4.945965] driver: '00:06': driver_bound: bound to device 'serial'
[    4.950966] bus: 'pnp': really_probe: bound device 00:06 to driver serial
[    4.951935] bus: 'pci': add driver serial
[    4.952694] bus: 'platform': add driver xuartps
[    4.953492] MOXA Intellio family driver version 6.0k
[    4.958553] device: 'ttyMX0': device_add
[    4.959348] PM: Adding info for No Bus:ttyMX0
[    4.960150] device: 'ttyMX1': device_add
[    4.960944] PM: Adding info for No Bus:ttyMX1
[    4.961739] device: 'ttyMX2': device_add
[    4.966620] PM: Adding info for No Bus:ttyMX2
[    4.967236] device: 'ttyMX3': device_add
[    4.967910] PM: Adding info for No Bus:ttyMX3
[    4.968544] device: 'ttyMX4': device_add
[    4.969176] PM: Adding info for No Bus:ttyMX4
[    4.969828] device: 'ttyMX5': device_add
[    4.974654] PM: Adding info for No Bus:ttyMX5
[    4.975419] device: 'ttyMX6': device_add
[    4.976212] PM: Adding info for No Bus:ttyMX6
[    4.977003] device: 'ttyMX7': device_add
[    4.977777] PM: Adding info for No Bus:ttyMX7
[    4.982654] device: 'ttyMX8': device_add
[    4.983268] PM: Adding info for No Bus:ttyMX8
[    4.983904] device: 'ttyMX9': device_add
[    4.984546] PM: Adding info for No Bus:ttyMX9
[    4.985190] device: 'ttyMX10': device_add
[    4.985834] PM: Adding info for No Bus:ttyMX10
[    4.990710] device: 'ttyMX11': device_add
[    4.991491] PM: Adding info for No Bus:ttyMX11
[    4.992303] device: 'ttyMX12': device_add
[    4.993106] PM: Adding info for No Bus:ttyMX12
[    4.993941] device: 'ttyMX13': device_add
[    4.998940] PM: Adding info for No Bus:ttyMX13
[    4.999707] device: 'ttyMX14': device_add
[    5.000343] PM: Adding info for No Bus:ttyMX14
[    5.000987] device: 'ttyMX15': device_add
[    5.001633] PM: Adding info for No Bus:ttyMX15
[    5.006364] device: 'ttyMX16': device_add
[    5.007010] PM: Adding info for No Bus:ttyMX16
[    5.007665] device: 'ttyMX17': device_add
[    5.008404] PM: Adding info for No Bus:ttyMX17
[    5.009224] device: 'ttyMX18': device_add
[    5.010037] PM: Adding info for No Bus:ttyMX18
[    5.010930] device: 'ttyMX19': device_add
[    5.011726] PM: Adding info for No Bus:ttyMX19
[    5.012520] device: 'ttyMX20': device_add
[    5.013323] PM: Adding info for No Bus:ttyMX20
[    5.014258] device: 'ttyMX21': device_add
[    5.015055] PM: Adding info for No Bus:ttyMX21
[    5.015889] device: 'ttyMX22': device_add
[    5.016704] PM: Adding info for No Bus:ttyMX22
[    5.017482] device: 'ttyMX23': device_add
[    5.018474] PM: Adding info for No Bus:ttyMX23
[    5.019283] device: 'ttyMX24': device_add
[    5.020098] PM: Adding info for No Bus:ttyMX24
[    5.020912] device: 'ttyMX25': device_add
[    5.021697] PM: Adding info for No Bus:ttyMX25
[    5.022392] device: 'ttyMX26': device_add
[    5.023042] PM: Adding info for No Bus:ttyMX26
[    5.023698] device: 'ttyMX27': device_add
[    5.024359] PM: Adding info for No Bus:ttyMX27
[    5.025017] device: 'ttyMX28': device_add
[    5.025660] PM: Adding info for No Bus:ttyMX28
[    5.026356] device: 'ttyMX29': device_add
[    5.027034] PM: Adding info for No Bus:ttyMX29
[    5.027688] device: 'ttyMX30': device_add
[    5.028327] PM: Adding info for No Bus:ttyMX30
[    5.028975] device: 'ttyMX31': device_add
[    5.029630] PM: Adding info for No Bus:ttyMX31
[    5.030334] device: 'ttyMX32': device_add
[    5.030981] PM: Adding info for No Bus:ttyMX32
[    5.031634] device: 'ttyMX33': device_add
[    5.032324] PM: Adding info for No Bus:ttyMX33
[    5.033144] device: 'ttyMX34': device_add
[    5.033921] PM: Adding info for No Bus:ttyMX34
[    5.034846] device: 'ttyMX35': device_add
[    5.035657] PM: Adding info for No Bus:ttyMX35
[    5.036444] device: 'ttyMX36': device_add
[    5.037236] PM: Adding info for No Bus:ttyMX36
[    5.038076] device: 'ttyMX37': device_add
[    5.038957] PM: Adding info for No Bus:ttyMX37
[    5.039794] device: 'ttyMX38': device_add
[    5.040599] PM: Adding info for No Bus:ttyMX38
[    5.041395] device: 'ttyMX39': device_add
[    5.042296] PM: Adding info for No Bus:ttyMX39
[    5.043097] device: 'ttyMX40': device_add
[    5.043901] PM: Adding info for No Bus:ttyMX40
[    5.044767] device: 'ttyMX41': device_add
[    5.045538] PM: Adding info for No Bus:ttyMX41
[    5.046446] device: 'ttyMX42': device_add
[    5.047241] PM: Adding info for No Bus:ttyMX42
[    5.048077] device: 'ttyMX43': device_add
[    5.048724] PM: Adding info for No Bus:ttyMX43
[    5.049345] device: 'ttyMX44': device_add
[    5.049989] PM: Adding info for No Bus:ttyMX44
[    5.050727] device: 'ttyMX45': device_add
[    5.051374] PM: Adding info for No Bus:ttyMX45
[    5.052038] device: 'ttyMX46': device_add
[    5.052684] PM: Adding info for No Bus:ttyMX46
[    5.053311] device: 'ttyMX47': device_add
[    5.053958] PM: Adding info for No Bus:ttyMX47
[    5.054723] device: 'ttyMX48': device_add
[    5.055346] PM: Adding info for No Bus:ttyMX48
[    5.056002] device: 'ttyMX49': device_add
[    5.056816] PM: Adding info for No Bus:ttyMX49
[    5.057621] device: 'ttyMX50': device_add
[    5.058524] PM: Adding info for No Bus:ttyMX50
[    5.059335] device: 'ttyMX51': device_add
[    5.060139] PM: Adding info for No Bus:ttyMX51
[    5.060957] device: 'ttyMX52': device_add
[    5.061770] PM: Adding info for No Bus:ttyMX52
[    5.062681] device: 'ttyMX53': device_add
[    5.063451] PM: Adding info for No Bus:ttyMX53
[    5.064303] device: 'ttyMX54': device_add
[    5.065105] PM: Adding info for No Bus:ttyMX54
[    5.065928] device: 'ttyMX55': device_add
[    5.066831] PM: Adding info for No Bus:ttyMX55
[    5.067626] device: 'ttyMX56': device_add
[    5.068441] PM: Adding info for No Bus:ttyMX56
[    5.069259] device: 'ttyMX57': device_add
[    5.070046] PM: Adding info for No Bus:ttyMX57
[    5.070971] device: 'ttyMX58': device_add
[    5.071737] PM: Adding info for No Bus:ttyMX58
[    5.072374] device: 'ttyMX59': device_add
[    5.072999] PM: Adding info for No Bus:ttyMX59
[    5.073644] device: 'ttyMX60': device_add
[    5.074368] PM: Adding info for No Bus:ttyMX60
[    5.075063] device: 'ttyMX61': device_add
[    5.075707] PM: Adding info for No Bus:ttyMX61
[    5.076328] device: 'ttyMX62': device_add
[    5.076974] PM: Adding info for No Bus:ttyMX62
[    5.077627] device: 'ttyMX63': device_add
[    5.078375] PM: Adding info for No Bus:ttyMX63
[    5.079037] device: 'ttyMX64': device_add
[    5.079674] PM: Adding info for No Bus:ttyMX64
[    5.080359] device: 'ttyMX65': device_add
[    5.081149] PM: Adding info for No Bus:ttyMX65
[    5.081943] device: 'ttyMX66': device_add
[    5.082817] PM: Adding info for No Bus:ttyMX66
[    5.083625] device: 'ttyMX67': device_add
[    5.084436] PM: Adding info for No Bus:ttyMX67
[    5.085250] device: 'ttyMX68': device_add
[    5.086050] PM: Adding info for No Bus:ttyMX68
[    5.086952] device: 'ttyMX69': device_add
[    5.087766] PM: Adding info for No Bus:ttyMX69
[    5.088635] device: 'ttyMX70': device_add
[    5.089404] PM: Adding info for No Bus:ttyMX70
[    5.090312] device: 'ttyMX71': device_add
[    5.091100] PM: Adding info for No Bus:ttyMX71
[    5.091898] device: 'ttyMX72': device_add
[    5.092695] PM: Adding info for No Bus:ttyMX72
[    5.093488] device: 'ttyMX73': device_add
[    5.094337] PM: Adding info for No Bus:ttyMX73
[    5.094984] device: 'ttyMX74': device_add
[    5.095624] PM: Adding info for No Bus:ttyMX74
[    5.096269] device: 'ttyMX75': device_add
[    5.096915] PM: Adding info for No Bus:ttyMX75
[    5.097536] device: 'ttyMX76': device_add
[    5.098277] PM: Adding info for No Bus:ttyMX76
[    5.098965] device: 'ttyMX77': device_add
[    5.099597] PM: Adding info for No Bus:ttyMX77
[    5.100224] device: 'ttyMX78': device_add
[    5.100884] PM: Adding info for No Bus:ttyMX78
[    5.101513] device: 'ttyMX79': device_add
[    5.102153] PM: Adding info for No Bus:ttyMX79
[    5.102887] device: 'ttyMX80': device_add
[    5.103494] PM: Adding info for No Bus:ttyMX80
[    5.104226] device: 'ttyMX81': device_add
[    5.105032] PM: Adding info for No Bus:ttyMX81
[    5.105835] device: 'ttyMX82': device_add
[    5.106700] PM: Adding info for No Bus:ttyMX82
[    5.107494] device: 'ttyMX83': device_add
[    5.108338] PM: Adding info for No Bus:ttyMX83
[    5.109160] device: 'ttyMX84': device_add
[    5.109944] PM: Adding info for No Bus:ttyMX84
[    5.110832] device: 'ttyMX85': device_add
[    5.111641] PM: Adding info for No Bus:ttyMX85
[    5.112430] device: 'ttyMX86': device_add
[    5.113239] PM: Adding info for No Bus:ttyMX86
[    5.114097] device: 'ttyMX87': device_add
[    5.114981] PM: Adding info for No Bus:ttyMX87
[    5.115792] device: 'ttyMX88': device_add
[    5.116611] PM: Adding info for No Bus:ttyMX88
[    5.117404] device: 'ttyMX89': device_add
[    5.118355] PM: Adding info for No Bus:ttyMX89
[    5.119177] device: 'ttyMX90': device_add
[    5.119962] PM: Adding info for No Bus:ttyMX90
[    5.120689] device: 'ttyMX91': device_add
[    5.121469] PM: Adding info for No Bus:ttyMX91
[    5.122379] device: 'ttyMX92': device_add
[    5.123155] PM: Adding info for No Bus:ttyMX92
[    5.123805] device: 'ttyMX93': device_add
[    5.124478] PM: Adding info for No Bus:ttyMX93
[    5.125149] device: 'ttyMX94': device_add
[    5.125780] PM: Adding info for No Bus:ttyMX94
[    5.126491] device: 'ttyMX95': device_add
[    5.127138] PM: Adding info for No Bus:ttyMX95
[    5.127798] device: 'ttyMX96': device_add
[    5.128463] PM: Adding info for No Bus:ttyMX96
[    5.129121] device: 'ttyMX97': device_add
[    5.129771] PM: Adding info for No Bus:ttyMX97
[    5.130467] device: 'ttyMX98': device_add
[    5.131190] PM: Adding info for No Bus:ttyMX98
[    5.131988] device: 'ttyMX99': device_add
[    5.132800] PM: Adding info for No Bus:ttyMX99
[    5.133609] device: 'ttyMX100': device_add
[    5.134544] PM: Adding info for No Bus:ttyMX100
[    5.135381] device: 'ttyMX101': device_add
[    5.136202] PM: Adding info for No Bus:ttyMX101
[    5.137040] device: 'ttyMX102': device_add
[    5.137898] PM: Adding info for No Bus:ttyMX102
[    5.138841] device: 'ttyMX103': device_add
[    5.139667] PM: Adding info for No Bus:ttyMX103
[    5.140470] device: 'ttyMX104': device_add
[    5.141281] PM: Adding info for No Bus:ttyMX104
[    5.142126] device: 'ttyMX105': device_add
[    5.142944] PM: Adding info for No Bus:ttyMX105
[    5.143779] device: 'ttyMX106': device_add
[    5.144638] PM: Adding info for No Bus:ttyMX106
[    5.145389] device: 'ttyMX107': device_add
[    5.146092] PM: Adding info for No Bus:ttyMX107
[    5.146843] device: 'ttyMX108': device_add
[    5.147610] PM: Adding info for No Bus:ttyMX108
[    5.148293] device: 'ttyMX109': device_add
[    5.148952] PM: Adding info for No Bus:ttyMX109
[    5.149620] device: 'ttyMX110': device_add
[    5.152038] PM: Adding info for No Bus:ttyMX110
[    5.155325] device: 'ttyMX111': device_add
[    5.156144] PM: Adding info for No Bus:ttyMX111
[    5.156954] device: 'ttyMX112': device_add
[    5.157693] PM: Adding info for No Bus:ttyMX112
[    5.158535] device: 'ttyMX113': device_add
[    5.159275] PM: Adding info for No Bus:ttyMX113
[    5.160043] device: 'ttyMX114': device_add
[    5.160770] PM: Adding info for No Bus:ttyMX114
[    5.161486] device: 'ttyMX115': device_add
[    5.162304] PM: Adding info for No Bus:ttyMX115
[    5.163057] device: 'ttyMX116': device_add
[    5.163836] PM: Adding info for No Bus:ttyMX116
[    5.164717] device: 'ttyMX117': device_add
[    5.165492] PM: Adding info for No Bus:ttyMX117
[    5.166389] device: 'ttyMX118': device_add
[    5.167201] PM: Adding info for No Bus:ttyMX118
[    5.168007] device: 'ttyMX119': device_add
[    5.168682] PM: Adding info for No Bus:ttyMX119
[    5.169318] device: 'ttyMX120': device_add
[    5.169966] PM: Adding info for No Bus:ttyMX120
[    5.170722] device: 'ttyMX121': device_add
[    5.171448] PM: Adding info for No Bus:ttyMX121
[    5.172121] device: 'ttyMX122': device_add
[    5.172772] PM: Adding info for No Bus:ttyMX122
[    5.173422] device: 'ttyMX123': device_add
[    5.174135] PM: Adding info for No Bus:ttyMX123
[    5.174870] device: 'ttyMX124': device_add
[    5.175497] PM: Adding info for No Bus:ttyMX124
[    5.176206] device: 'ttyMX125': device_add
[    5.176940] PM: Adding info for No Bus:ttyMX125
[    5.177681] device: 'ttyMX126': device_add
[    5.178504] PM: Adding info for No Bus:ttyMX126
[    5.179270] device: 'ttyMX127': device_add
[    5.180019] PM: Adding info for No Bus:ttyMX127
[    5.180768] device: 'ttyMX128': device_add
[    5.181464] PM: Adding info for No Bus:ttyMX128
[    5.182304] bus: 'pci': add driver moxa
[    5.183011] RocketPort device driver module, version 2.09, 12-June-2003
[    5.184189] No rocketport ports found; unloading driver
[    5.185129] bus: 'pcmcia': add driver ipwireless
[    5.186024] device: 'ttyprintk': device_add
[    5.186962] PM: Adding info for No Bus:ttyprintk
[    5.187770] device class 'virtio-ports': registering
[    5.188717] bus: 'virtio': add driver virtio_console
[    5.189620] Generic RTC Driver v1.07
[    5.190346] device: 'rtc': device_add
[    5.191106] PM: Adding info for No Bus:rtc
[    5.192020] scx200_gpio: no SCx200 gpio present
[    5.192768] nsc_gpio initializing
[    5.193280] device class 'cardman_4040': registering
[    5.194138] bus: 'pcmcia': add driver cm4040_cs
[    5.195110] bus: 'platform': add driver ipmi
[    5.195833] ipmi message handler version 39.2
[    5.196517] bus: 'platform': add driver ipmi_si
[    5.197258] IPMI System Interface driver.
[    5.197953] bus: 'pci': add driver ipmi_si
[    5.198729] bus: 'pnp': add driver ipmi_si
[    5.199412] ipmi_si: Adding default-specified kcs state machine
[    5.200418] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    5.202157] ipmi_si: Interface detection failed
[    5.237944] ipmi_si: Adding default-specified smic state machine
[    5.238943] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.240479] ipmi_si: Interface detection failed
[    5.267919] ipmi_si: Adding default-specified bt state machine
[    5.268900] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    5.270445] ipmi_si: Interface detection failed
[    5.297970] bus: 'pci': remove driver ipmi_si
[    5.298706] driver: 'ipmi_si': driver_release
[    5.299361] bus: 'pnp': remove driver ipmi_si
[    5.299999] driver: 'ipmi_si': driver_release
[    5.300639] bus: 'platform': remove driver ipmi_si
[    5.301308] driver: 'ipmi_si': driver_release
[    5.301933] ipmi_si: Unable to find any System Interface(s)
[    5.302776] IPMI Watchdog: driver initialized
[    5.303383] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    5.304685] IPMI poweroff: Unable to register powercycle sysctl
[    5.305640] device class 'drm': registering
[    5.306416] [drm] Initialized drm 1.1.0 20060810
[    5.307197] bus: 'usb': add driver udl
[    5.307952] usbcore: registered new interface driver udl
[    5.308900] bus: 'platform': add driver parport_pc
[    5.314668] bus: 'pnp': add driver parport_pc
[    5.315335] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river parport_pc
[    5.316452] bus: 'pnp': really_probe: probing driver parport_pc with dev=
ice 00:05
[    5.317509] parport_pc 00:05: reported by Plug and Play ACPI
[    5.322738] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    5.397971] driver: '00:05': driver_bound: bound to device 'parport_pc'
[    5.399003] bus: 'pnp': really_probe: bound device 00:05 to driver parpo=
rt_pc
[    5.400128] Registering platform device 'parport_pc.956'. Parent at plat=
form
[    5.401237] device: 'parport_pc.956': device_add
[    5.402007] bus: 'platform': add device parport_pc.956
[    5.402920] PM: Adding info for platform:parport_pc.956
[    5.403769] bus: 'platform': driver_probe_device: matched device parport=
_pc.956 with driver parport_pc
[    5.405375] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.956
[    5.406771] driver: 'parport_pc.956': driver_bound: bound to device 'par=
port_pc'
[    5.408009] bus: 'platform': really_probe: bound device parport_pc.956 t=
o driver parport_pc
[    5.409515] PM: Removing info for platform:parport_pc.956
[    5.414680] bus: 'platform': remove device parport_pc.956
[    5.415696] Registering platform device 'parport_pc.888'. Parent at plat=
form
[    5.416741] device: 'parport_pc.888': device_add
[    5.417386] bus: 'platform': add device parport_pc.888
[    5.423355] PM: Adding info for platform:parport_pc.888
[    5.424190] bus: 'platform': driver_probe_device: matched device parport=
_pc.888 with driver parport_pc
[    5.425484] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.888
[    5.426845] driver: 'parport_pc.888': driver_bound: bound to device 'par=
port_pc'
[    5.428184] bus: 'platform': really_probe: bound device parport_pc.888 t=
o driver parport_pc
[    5.429669] PM: Removing info for platform:parport_pc.888
[    5.430655] bus: 'platform': remove device parport_pc.888
[    5.431638] Registering platform device 'parport_pc.632'. Parent at plat=
form
[    5.432809] device: 'parport_pc.632': device_add
[    5.433526] bus: 'platform': add device parport_pc.632
[    5.440006] PM: Adding info for platform:parport_pc.632
[    5.440768] bus: 'platform': driver_probe_device: matched device parport=
_pc.632 with driver parport_pc
[    5.442025] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.632
[    5.443240] driver: 'parport_pc.632': driver_bound: bound to device 'par=
port_pc'
[    5.444261] bus: 'platform': really_probe: bound device parport_pc.632 t=
o driver parport_pc
[    5.445507] PM: Removing info for platform:parport_pc.632
[    5.456497] bus: 'platform': remove device parport_pc.632
[    5.457410] bus: 'pci': add driver parport_pc
[    5.458237] bus: 'platform': add driver ax88796-pp
[    5.459119] bus: 'isa': registered
[    5.459737] device: 'isa': device_add
[    5.460386] PM: Adding info for No Bus:isa
[    5.461108] bus: 'i2c': add driver bmp085
[    5.461823] i2c-core: driver [bmp085] registered
[    5.462659] lkdtm: No crash points registered, enable through debugfs
[    5.481795] device class 'enclosure': registering
[    5.482626] bus: 'i2c': add driver apds9802als
[    5.483371] i2c-core: driver [apds9802als] using legacy suspend method
[    5.493002] i2c-core: driver [apds9802als] using legacy resume method
[    5.493894] i2c-core: driver [apds9802als] registered
[    5.494623] bus: 'i2c': add driver ds1682
[    5.495171] i2c-core: driver [ds1682] registered
[    5.495829] bus: 'i2c': add driver hmc6352
[    5.496392] i2c-core: driver [hmc6352] registered
[    5.497063] bus: 'i2c': add driver at24
[    5.497627] i2c-core: driver [at24] registered
[    5.498270] bus: 'i2c': add driver eeprom
[    5.498852] i2c-core: driver [eeprom] registered
[    5.499471] bus: 'i2c': add driver max6875
[    5.500119] i2c-core: driver [max6875] registered
[    5.500778] bus: 'i2c': add driver lis3lv02d_i2c
[    5.501403] i2c-core: driver [lis3lv02d_i2c] registered
[    5.502149] bus: 'platform': add driver sm501
[    5.502798] bus: 'pci': add driver sm501
[    5.503359] bus: 'platform': add driver pasic3
[    5.520176] bus: 'platform': remove driver pasic3
[    5.520997] driver: 'pasic3': driver_release
[    5.521731] bus: 'i2c': add driver wm8994
[    5.522383] i2c-core: driver [wm8994] registered
[    5.523138] bus: 'platform': add driver ab3100-otp
[    5.523839] bus: 'platform': remove driver ab3100-otp
[    5.532161] driver: 'ab3100-otp': driver_release
[    5.532829] bus: 'i2c': add driver adp5520
[    5.533408] i2c-core: driver [adp5520] registered
[    5.534099] device class 'spi_transport': registering
[    5.534831] device class 'spi_host': registering
[    5.535472] device class 'fc_host': registering
[    5.536244] device class 'fc_vports': registering
[    5.537023] device class 'fc_remote_ports': registering
[    5.537983] device class 'fc_transport': registering
[    5.538831] device class 'srp_host': registering
[    5.539637] device class 'srp_remote_ports': registering
[    5.540535] hp_sw: device handler registered
[    5.548791] emc: device handler registered
[    5.578930] bus: 'isa': add driver advansys
[    5.579696] device: 'advansys.0': device_add
[    5.580411] bus: 'isa': add device advansys.0
[    5.581169] PM: Adding info for isa:advansys.0
[    5.581929] bus: 'isa': driver_probe_device: matched device advansys.0 w=
ith driver advansys
[    5.583361] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.0
[    5.584740] advansys: probe of advansys.0 rejects match -19
[    5.592790] device: 'advansys.1': device_add
[    5.593376] bus: 'isa': add device advansys.1
[    5.594025] PM: Adding info for isa:advansys.1
[    5.594679] bus: 'isa': driver_probe_device: matched device advansys.1 w=
ith driver advansys
[    5.595845] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.1
[    5.604180] advansys: probe of advansys.1 rejects match -19
[    5.605145] device: 'advansys.2': device_add
[    5.605898] bus: 'isa': add device advansys.2
[    5.606673] PM: Adding info for isa:advansys.2
[    5.607429] bus: 'isa': driver_probe_device: matched device advansys.2 w=
ith driver advansys
[    5.608901] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.2
[    5.610203] advansys: probe of advansys.2 rejects match -19
[    5.611112] device: 'advansys.3': device_add
[    5.611729] bus: 'isa': add device advansys.3
[    5.612317] PM: Adding info for isa:advansys.3
[    5.612961] bus: 'isa': driver_probe_device: matched device advansys.3 w=
ith driver advansys
[    5.620726] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.3
[    5.621844] advansys: probe of advansys.3 rejects match -19
[    5.622634] device: 'advansys.4': device_add
[    5.623224] bus: 'isa': add device advansys.4
[    5.623915] PM: Adding info for isa:advansys.4
[    5.624116] tsc: Refined TSC clocksource calibration: 3300.198 MHz
[    5.624130] Switching to clocksource tsc
[    5.645808] bus: 'isa': driver_probe_device: matched device advansys.4 w=
ith driver advansys
[    5.647209] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.4
[    5.648535] advansys: probe of advansys.4 rejects match -19
[    5.649485] device: 'advansys.5': device_add
[    5.650230] bus: 'isa': add device advansys.5
[    5.651150] PM: Adding info for isa:advansys.5
[    5.651927] bus: 'isa': driver_probe_device: matched device advansys.5 w=
ith driver advansys
[    5.653474] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.5
[    5.654864] advansys: probe of advansys.5 rejects match -19
[    5.655777] device: 'advansys.6': device_add
[    5.656366] bus: 'isa': add device advansys.6
[    5.657009] PM: Adding info for isa:advansys.6
[    5.657790] bus: 'isa': driver_probe_device: matched device advansys.6 w=
ith driver advansys
[    5.658996] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.6
[    5.660079] advansys: probe of advansys.6 rejects match -19
[    5.660874] device: 'advansys.7': device_add
[    5.661614] bus: 'isa': add device advansys.7
[    5.662214] PM: Adding info for isa:advansys.7
[    5.662865] bus: 'isa': driver_probe_device: matched device advansys.7 w=
ith driver advansys
[    5.664029] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.7
[    5.673938] advansys: probe of advansys.7 rejects match -19
[    5.674942] device: 'advansys.8': device_add
[    5.675704] bus: 'isa': add device advansys.8
[    5.676431] PM: Adding info for isa:advansys.8
[    5.677200] bus: 'isa': driver_probe_device: matched device advansys.8 w=
ith driver advansys
[    5.678671] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.8
[    5.682300] advansys: probe of advansys.8 rejects match -19
[    5.683111] device: 'advansys.9': device_add
[    5.683747] bus: 'isa': add device advansys.9
[    5.684384] PM: Adding info for isa:advansys.9
[    5.685040] bus: 'isa': driver_probe_device: matched device advansys.9 w=
ith driver advansys
[    5.686231] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.9
[    5.687331] advansys: probe of advansys.9 rejects match -19
[    5.688156] device: 'advansys.10': device_add
[    5.688800] bus: 'isa': add device advansys.10
[    5.689439] PM: Adding info for isa:advansys.10
[    5.690559] bus: 'isa': driver_probe_device: matched device advansys.10 =
with driver advansys
[    5.691769] bus: 'isa': really_probe: probing driver advansys with devic=
e advansys.10
[    5.692873] advansys: probe of advansys.10 rejects match -19
[    5.693777] bus: 'isa': add driver advansys_vlb
[    5.705630] device: 'advansys_vlb.0': device_add
[    5.706272] bus: 'isa': add device advansys_vlb.0
[    5.706963] PM: Adding info for isa:advansys_vlb.0
[    5.707660] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E0 with driver advansys_vlb
[    5.708919] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.0
[    5.710129] advansys_vlb: probe of advansys_vlb.0 rejects match -19
[    5.711007] device: 'advansys_vlb.1': device_add
[    5.712165] bus: 'isa': add device advansys_vlb.1
[    5.720010] PM: Adding info for isa:advansys_vlb.1
[    5.720828] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E1 with driver advansys_vlb
[    5.722305] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.1
[    5.728047] advansys_vlb: probe of advansys_vlb.1 rejects match -19
[    5.729120] device: 'advansys_vlb.2': device_add
[    5.729909] bus: 'isa': add device advansys_vlb.2
[    5.733482] PM: Adding info for isa:advansys_vlb.2
[    5.734253] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E2 with driver advansys_vlb
[    5.735513] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.2
[    5.736740] advansys_vlb: probe of advansys_vlb.2 rejects match -19
[    5.737661] device: 'advansys_vlb.3': device_add
[    5.738327] bus: 'isa': add device advansys_vlb.3
[    5.739015] PM: Adding info for isa:advansys_vlb.3
[    5.739708] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E3 with driver advansys_vlb
[    5.740952] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.3
[    5.742293] advansys_vlb: probe of advansys_vlb.3 rejects match -19
[    5.743333] device: 'advansys_vlb.4': device_add
[    5.752151] bus: 'isa': add device advansys_vlb.4
[    5.752989] PM: Adding info for isa:advansys_vlb.4
[    5.753820] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E4 with driver advansys_vlb
[    5.758306] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.4
[    5.759505] advansys_vlb: probe of advansys_vlb.4 rejects match -19
[    5.760397] device: 'advansys_vlb.5': device_add
[    5.761049] bus: 'isa': add device advansys_vlb.5
[    5.761752] PM: Adding info for isa:advansys_vlb.5
[    5.762416] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E5 with driver advansys_vlb
[    5.763699] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.5
[    5.765683] advansys_vlb: probe of advansys_vlb.5 rejects match -19
[    5.766754] device: 'advansys_vlb.6': device_add
[    5.767516] bus: 'isa': add device advansys_vlb.6
[    5.768352] PM: Adding info for isa:advansys_vlb.6
[    5.769383] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E6 with driver advansys_vlb
[    5.770916] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.6
[    5.773313] advansys_vlb: probe of advansys_vlb.6 rejects match -19
[    5.774387] device: 'advansys_vlb.7': device_add
[    5.775173] bus: 'isa': add device advansys_vlb.7
[    5.775967] PM: Adding info for isa:advansys_vlb.7
[    5.777067] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E7 with driver advansys_vlb
[    5.778777] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.7
[    5.790963] advansys_vlb: probe of advansys_vlb.7 rejects match -19
[    5.791978] device: 'advansys_vlb.8': device_add
[    5.792760] bus: 'isa': add device advansys_vlb.8
[    5.793517] PM: Adding info for isa:advansys_vlb.8
[    5.794330] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E8 with driver advansys_vlb
[    5.800101] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.8
[    5.801510] advansys_vlb: probe of advansys_vlb.8 rejects match -19
[    5.806707] device: 'advansys_vlb.9': device_add
[    5.807459] bus: 'isa': add device advansys_vlb.9
[    5.808273] PM: Adding info for isa:advansys_vlb.9
[    5.809111] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E9 with driver advansys_vlb
[    5.814135] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.9
[    5.815636] advansys_vlb: probe of advansys_vlb.9 rejects match -19
[    5.816675] device: 'advansys_vlb.10': device_add
[    5.817421] bus: 'isa': add device advansys_vlb.10
[    5.818259] PM: Adding info for isa:advansys_vlb.10
[    5.823159] bus: 'isa': driver_probe_device: matched device advansys_vlb=
=2E10 with driver advansys_vlb
[    5.824694] bus: 'isa': really_probe: probing driver advansys_vlb with d=
evice advansys_vlb.10
[    5.826137] advansys_vlb: probe of advansys_vlb.10 rejects match -19
[    5.833428] bus: 'pci': add driver advansys
[    5.834775] qlogicfas: no cards were found, please specify I/O address a=
nd IRQ using iobase=3D and irq=3D optionsGDT-HA: Storage RAID Controller Dr=
iver. Version: 3.05
[    5.837203] bus: 'pci': add driver gdth
[    5.837898] ppa: Version 2.07 (for Linux 2.4.x)
[    5.841033] imm: Version 2.05 (for Linux 2.4.0)
[    5.842409] bus: 'virtio': add driver virtio_scsi
[    5.843238] osst :I: Tape driver with OnStream support version 0.99.4
[    5.843238] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    5.845381] device class 'onstream_tape': registering
[    5.846259] bus: 'scsi': add driver osst
[    5.846958] bus: 'scsi': add driver sr
[    5.847619] device class 'scsi_generic': registering
[    5.848502] SCSI Media Changer driver v0.25=20
[    5.849202] device class 'scsi_changer': registering
[    5.853996] bus: 'scsi': add driver ch
[    5.854616] bus: 'scsi': add driver ses
[    5.856672] device: 'pseudo_0': device_add
[    5.857341] PM: Adding info for No Bus:pseudo_0
[    5.858137] bus: 'pseudo': registered
[    5.858878] bus: 'pseudo': add driver scsi_debug
[    5.859710] device: 'adapter0': device_add
[    5.860353] bus: 'pseudo': add device adapter0
[    5.861057] PM: Adding info for pseudo:adapter0
[    5.861771] bus: 'pseudo': driver_probe_device: matched device adapter0 =
with driver scsi_debug
[    5.871012] bus: 'pseudo': really_probe: probing driver scsi_debug with =
device adapter0
[    5.875914] scsi_debug: host protection
[    5.876502] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    5.877726] device: 'host2': device_add
[    5.885754] bus: 'scsi': add device host2
[    5.886386] PM: Adding info for scsi:host2
[    5.887140] device: 'host2': device_add
[    5.887817] PM: Adding info for No Bus:host2
[    5.922297] driver: 'adapter0': driver_bound: bound to device 'scsi_debu=
g'
[    5.923400] bus: 'pseudo': really_probe: bound device adapter0 to driver=
 scsi_debug
[    5.924096] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    5.924135] device: 'target2:0:0': device_add
[    5.924163] bus: 'scsi': add device target2:0:0
[    5.924179] PM: Adding info for scsi:target2:0:0
[    5.924215] device: '2:0:0:0': device_add
[    5.924252] bus: 'scsi': add device 2:0:0:0
[    5.924260] PM: Adding info for scsi:2:0:0:0
[    5.924286] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 wit=
h driver osst
[    5.924288] bus: 'scsi': really_probe: probing driver osst with device 2=
:0:0:0
[    5.924310] osst: probe of 2:0:0:0 rejects match -19
[    5.924314] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 wit=
h driver sr
[    5.924315] bus: 'scsi': really_probe: probing driver sr with device 2:0=
:0:0
[    5.924331] sr: probe of 2:0:0:0 rejects match -19
[    5.924333] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 wit=
h driver ch
[    5.924335] bus: 'scsi': really_probe: probing driver ch with device 2:0=
:0:0
[    5.924348] ch: probe of 2:0:0:0 rejects match -19
[    5.924351] bus: 'scsi': driver_probe_device: matched device 2:0:0:0 wit=
h driver ses
[    5.924352] bus: 'scsi': really_probe: probing driver ses with device 2:=
0:0:0
[    5.924365] ses: probe of 2:0:0:0 rejects match -19
[    5.924369] device: '2:0:0:0': device_add
[    5.924403] PM: Adding info for No Bus:2:0:0:0
[    5.924484] device: 'sg0': device_add
[    5.924628] PM: Adding info for No Bus:sg0
[    5.924673] scsi 2:0:0:0: Attached scsi generic sg0 type 0
[    5.968631] bus: 'pcmcia': add driver pata_pcmcia
[    5.969400] bus: 'platform': add driver pata_platform
[    5.978372] bus: 'platform': add driver pata_of_platform
[    5.979890] Rounding down aligned max_sectors from 4294967295 to 8388600
[    5.981107] device: 'tcm_loop_0': device_add
[    5.981822] PM: Adding info for No Bus:tcm_loop_0
[    5.982604] bus: 'tcm_loop_bus': registered
[    5.983261] bus: 'tcm_loop_bus': add driver tcm_loop
[    6.003296] device class 'mtd': registering
[    6.004037] device: 'mtd-unmap': device_add
[    6.004750] PM: Adding info for No Bus:mtd-unmap
[    6.005520] device: 'mtd-romap': device_add
[    6.006213] PM: Adding info for No Bus:mtd-romap
[    6.006979] device: 'mtd-rwmap': device_add
[    6.007668] PM: Adding info for No Bus:mtd-rwmap
[    6.026299] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    6.027368] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    6.028668] bus: 'platform': add driver physmap-flash
[    6.029492] bus: 'pcmcia': add driver pcmciamtd
[    6.030277] Could not find PAR responsible for SC520CDP Flash Bank #1
[    6.031298] Trying default address 0x8c00000
[    6.031994] SC520 CDP flash device: 0x800000 at 0x8800000
[    6.032861] Failed to ioremap_nocache
[    6.033434] Failed to ioremap_nocache
[    6.034044] bus: 'platform': add driver gpio-addr-flash
[    6.038996] bus: 'platform': add driver docg3
[    6.039717] bus: 'platform': remove driver docg3
[    6.040454] driver: 'docg3': driver_release
[    6.108274] No recognised DiskOnChip devices found
[    6.109056] slram: not enough parameters.
[    6.118944] device: 'mtd0': device_add
[    6.119634] PM: Adding info for No Bus:mtd0
[    6.120348] ftl_cs: FTL header not found.
[    6.121293] bus: 'platform': add driver docg4
[    6.122030] bus: 'platform': remove driver docg4
[    6.122894] driver: 'docg4': driver_release
[    6.123557] bus: 'hsi': add driver hsi_char
[    6.124247] HSI/SSI char device loaded
[    6.124902] device: 'dummy0': device_add
[    6.125622] PM: Adding info for No Bus:dummy0
[    6.134468] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[    6.135894] device: 'eql': device_add
[    6.136532] PM: Adding info for No Bus:eql
[    6.153411] Registering platform device 'ne.0'. Parent at platform
[    6.158503] device: 'ne.0': device_add
[    6.159127] bus: 'platform': add device ne.0
[    6.159828] PM: Adding info for platform:ne.0
[    6.160524] Registering platform device 'ne.1'. Parent at platform
[    6.161510] device: 'ne.1': device_add
[    6.162129] bus: 'platform': add device ne.1
[    6.170986] PM: Adding info for platform:ne.1
[    6.171729] Registering platform device 'ne.2'. Parent at platform
[    6.172720] device: 'ne.2': device_add
[    6.173296] bus: 'platform': add device ne.2
[    6.174020] PM: Adding info for platform:ne.2
[    6.181799] Registering platform device 'ne.3'. Parent at platform
[    6.182875] device: 'ne.3': device_add
[    6.183462] bus: 'platform': add device ne.3
[    6.184178] PM: Adding info for platform:ne.3
[    6.185297] bus: 'mdio_bus': add driver Marvell 88E1101
[    6.194354] bus: 'mdio_bus': add driver Marvell 88E1112
[    6.195207] bus: 'mdio_bus': add driver Marvell 88E1111
[    6.196066] bus: 'mdio_bus': add driver Marvell 88E1118
[    6.196919] bus: 'mdio_bus': add driver Marvell 88E1121R
[    6.197787] bus: 'mdio_bus': add driver Marvell 88E1318S
[    6.198674] bus: 'mdio_bus': add driver Marvell 88E1145
[    6.199497] bus: 'mdio_bus': add driver Marvell 88E1149R
[    6.200368] bus: 'mdio_bus': add driver Marvell 88E1240
[    6.201228] bus: 'mdio_bus': add driver Cicada Cis8201
[    6.202083] bus: 'mdio_bus': add driver Cicada Cis8204
[    6.210464] bus: 'mdio_bus': add driver LXT970
[    6.211181] bus: 'mdio_bus': add driver LXT971
[    6.211897] bus: 'mdio_bus': add driver LXT973
[    6.212613] bus: 'mdio_bus': add driver SMSC LAN83C185
[    6.213425] bus: 'mdio_bus': add driver SMSC LAN8187
[    6.214244] bus: 'mdio_bus': add driver SMSC LAN8700
[    6.215070] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[    6.216039] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[    6.216958] bus: 'mdio_bus': add driver Broadcom BCM8706
[    6.217829] bus: 'mdio_bus': add driver Broadcom BCM8727
[    6.222865] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[    6.223911] bus: 'mdio_bus': add driver ET1011C
[    6.224655] bus: 'mdio_bus': add driver STe101p
[    6.225362] bus: 'mdio_bus': add driver STe100p
[    6.226113] bus: 'mdio_bus': add driver AM79C874
[    6.230987] bus: 'platform': add driver mdio-mux-gpio
[    6.231876] arcnet loaded.
[    6.232308] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    6.233393] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    6.242759] arcnet: raw mode (`r') encapsulation support loaded.
[    6.243715] arcnet: cap mode (`c') encapsulation support loaded.
[    6.244674] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[    6.245818] E-mail me if you actually test this driver, please!
[    6.246761]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[    6.248060] arcnet: RIM I (entirely mem-mapped) support
[    6.248896] E-mail me if you actually test the RIM I driver, please!
[    6.249881] Given: node 00h, shmem 0h, irq 0
[    6.254706] No autoprobe for RIM I; you must specify the shmem and irq!
[    6.255895] bus: 'platform': add driver ne
[    6.256632] bus: 'platform': driver_probe_device: matched device ne.0 wi=
th driver ne
[    6.257963] bus: 'platform': really_probe: probing driver ne with device=
 ne.0
[    6.267287] ne: probe of ne.0 rejects match -19
[    6.268067] bus: 'platform': driver_probe_device: matched device ne.1 wi=
th driver ne
[    6.269258] bus: 'platform': really_probe: probing driver ne with device=
 ne.1
[    6.270430] ne: probe of ne.1 rejects match -19
[    6.271167] bus: 'platform': driver_probe_device: matched device ne.2 wi=
th driver ne
[    6.272372] bus: 'platform': really_probe: probing driver ne with device=
 ne.2
[    6.273553] ne: probe of ne.2 rejects match -19
[    6.278442] bus: 'platform': driver_probe_device: matched device ne.3 wi=
th driver ne
[    6.279811] bus: 'platform': really_probe: probing driver ne with device=
 ne.3
[    6.280951] ne: probe of ne.3 rejects match -19
[    6.281697] bus: 'platform': remove driver ne
[    6.282549] driver: 'ne': driver_release
[    6.283259] PM: Removing info for platform:ne.0
[    6.284086] bus: 'platform': remove device ne.0
[    6.284874] PM: Removing info for platform:ne.1
[    6.285666] bus: 'platform': remove device ne.1
[    6.286423] PM: Removing info for platform:ne.2
[    6.287217] bus: 'platform': remove device ne.2
[    6.288061] PM: Removing info for platform:ne.3
[    6.288869] bus: 'platform': remove device ne.3
[    6.289659] bus: 'platform': add driver ks8851_mll
[    6.290610] bus: 'platform': add driver ethoc
[    6.291346] AX.25: Z8530 SCC driver version 3.0.dl1bke
[    6.292200] device: 'scc0': device_add
[    6.292897] PM: Adding info for No Bus:scc0
[    6.293633] AX.25: 6pack driver, Revision: 0.3.0
[    6.294350] YAM driver version 0.8 by F1OAT/F6FBB
[    6.295118] device: 'yam0': device_add
[    6.295798] PM: Adding info for No Bus:yam0
[    6.296516] device: 'yam1': device_add
[    6.297223] PM: Adding info for No Bus:yam1
[    6.297987] device: 'yam2': device_add
[    6.298765] PM: Adding info for No Bus:yam2
[    6.299455] device: 'yam3': device_add
[    6.300137] PM: Adding info for No Bus:yam3
[    6.300886] AX.25: bpqether driver version 004
[    6.301615] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.301615] baycom_ser_hdx: version 0.10
[    6.303332] device: 'bcsh0': device_add
[    6.304024] PM: Adding info for No Bus:bcsh0
[    6.304832] device: 'bcsh1': device_add
[    6.305596] PM: Adding info for No Bus:bcsh1
[    6.306501] device: 'bcsh2': device_add
[    6.307281] PM: Adding info for No Bus:bcsh2
[    6.308198] device: 'bcsh3': device_add
[    6.308941] PM: Adding info for No Bus:bcsh3
[    6.309716] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    6.310698] hdlcdrv: version 0.8
[    6.311243] baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA
[    6.311243] baycom_epp: version 0.7
[    6.312852] device: 'bce0': device_add
[    6.313548] PM: Adding info for No Bus:bce0
[    6.314422] device: 'bce1': device_add
[    6.315110] PM: Adding info for No Bus:bce1
[    6.315839] device: 'bce2': device_add
[    6.316494] PM: Adding info for No Bus:bce2
[    6.317248] device: 'bce3': device_add
[    6.317972] PM: Adding info for No Bus:bce3
[    6.318880] device: 'plip0': device_add
[    6.319552] PM: Adding info for No Bus:plip0
[    6.320294] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    6.321164] plip0: Parallel port at 0x378, using IRQ 7.
[    6.321989] PPP generic driver version 2.4.2
[    6.322803] device class 'ppp': registering
[    6.323452] device: 'ppp': device_add
[    6.324178] PM: Adding info for No Bus:ppp
[    6.324949] PPP BSD Compression module registered
[    6.325793] PPP MPPE Compression module registered
[    6.326718] NET: Registered protocol family 24
[    6.327484] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256) (6 bit encapsulation enabled).
[    6.329209] bus: 'pnp': add driver sb1000
[    6.329934] x25_asy: X.25 async: version 0.00 ALPHA (dynamic channels, m=
ax=3D256)
[    6.331340] bus: 'usb': add driver catc
[    6.332055] usbcore: registered new interface driver catc
[    6.332978] bus: 'usb': add driver kaweth
[    6.333681] usbcore: registered new interface driver kaweth
[    6.334670] bus: 'usb': add driver asix
[    6.335324] usbcore: registered new interface driver asix
[    6.336252] bus: 'usb': add driver cdc_ether
[    6.337011] usbcore: registered new interface driver cdc_ether
[    6.338010] bus: 'usb': add driver cdc_eem
[    6.338861] usbcore: registered new interface driver cdc_eem
[    6.339824] bus: 'usb': add driver dm9601
[    6.340537] usbcore: registered new interface driver dm9601
[    6.341535] bus: 'usb': add driver gl620a
[    6.342282] usbcore: registered new interface driver gl620a
[    6.343199] bus: 'usb': add driver net1080
[    6.343868] usbcore: registered new interface driver net1080
[    6.344781] bus: 'usb': add driver rndis_host
[    6.345463] usbcore: registered new interface driver rndis_host
[    6.346489] bus: 'usb': add driver int51x1
[    6.347165] usbcore: registered new interface driver int51x1
[    6.348081] bus: 'usb': add driver kalmia
[    6.348760] usbcore: registered new interface driver kalmia
[    6.349658] bus: 'usb': add driver sierra_net
[    6.350422] usbcore: registered new interface driver sierra_net
[    6.351377] bus: 'usb': add driver lg-vl600
[    6.352061] usbcore: registered new interface driver lg-vl600
[    6.352971] bus: 'usb': add driver qmi_wwan
[    6.353685] usbcore: registered new interface driver qmi_wwan
[    6.354738] device class 'uio': registering
[    6.355399] bus: 'platform': add driver uio_pdrv
[    6.356142] bus: 'platform': add driver uio_pdrv_genirq
[    6.357030] bus: 'usb': add driver cdc_acm
[    6.357763] usbcore: registered new interface driver cdc_acm
[    6.358763] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    6.360135] bus: 'usb': add driver cdc_wdm
[    6.360859] usbcore: registered new interface driver cdc_wdm
[    6.361847] bus: 'pnp': add driver i8042 kbd
[    6.362723] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[    6.364093] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[    6.365347] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[    6.366629] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[    6.367875] bus: 'pnp': add driver i8042 aux
[    6.368625] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[    6.369932] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[    6.371208] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[    6.372233] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[    6.373541] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    6.374978] Registering platform device 'i8042'. Parent at platform
[    6.375984] device: 'i8042': device_add
[    6.376619] bus: 'platform': add device i8042
[    6.377295] PM: Adding info for platform:i8042
[    6.378070] bus: 'platform': add driver i8042
[    6.378889] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[    6.380150] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[    6.382306] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.383211] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.384145] driver: 'i8042': driver_bound: bound to device 'i8042'
[    6.385265] device: 'serio0': device_add
[    6.386009] bus: 'serio': add device serio0
[    6.386869] PM: Adding info for serio:serio0
[    6.387652] device: 'serio1': device_add
[    6.388346] bus: 'serio': add device serio1
[    6.389090] PM: Adding info for serio:serio1
[    6.389844] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[    6.391052] bus: 'serio': add driver ps2mult
[    6.391842] bus: 'serio': add driver serio_raw
[    6.392658] bus: 'serio': add driver atkbd
[    6.393356] bus: 'gameport': add driver adi
[    6.394251] bus: 'gameport': add driver analog
[    6.395048] bus: 'gameport': add driver interact
[    6.395858] bus: 'serio': add driver spaceball
[    6.396649] bus: 'serio': add driver spaceorb
[    6.397330] bus: 'gameport': add driver tmdc
[    6.398061] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[    6.399595] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[    6.424601] bus: 'serio': add driver zhenhua
[    6.425315] bus: 'i2c': add driver smbus_alert
[    6.426065] i2c-core: driver [smbus_alert] registered
[    6.426975] i2c /dev entries driver
[    6.427513] device class 'i2c-dev': registering
[    6.428287] bus: 'platform': add driver simtec-i2c
[    6.429080] bus: 'platform': add driver xiic-i2c
[    6.429844] bus: 'usb': add driver i2c-diolan-u2c
[    6.430622] usbcore: registered new interface driver i2c-diolan-u2c
[    6.432090] i2c-parport: adapter type unspecified
[    6.432925] bus: 'serio': add driver taos-evm
[    6.442615] bus: 'usb': add driver i2c-tiny-usb
[    6.443354] usbcore: registered new interface driver i2c-tiny-usb
[    6.444332] bus: 'isa': add driver i2c-pca-isa
[    6.445084] device: 'i2c-pca-isa.0': device_add
[    6.445834] bus: 'isa': add device i2c-pca-isa.0
[    6.446793] PM: Adding info for isa:i2c-pca-isa.0
[    6.447543] isa i2c-pca-isa.0: Please specify I/O base
[    6.458307] device: 'i2c-pca-isa.0': device_unregister
[    6.459451] PM: Removing info for isa:i2c-pca-isa.0
[    6.460325] bus: 'isa': remove device i2c-pca-isa.0
[    6.461190] bus: 'isa': remove driver i2c-pca-isa
[    6.462038] driver: 'i2c-pca-isa': driver_release
[    6.463003] Driver for 1-wire Dallas network protocol.
[    6.463930] bus: 'w1': registered
[    6.464701] bus: 'w1': add driver w1_master_driver
[    6.465439] bus: 'w1': add driver w1_slave_driver
[    6.466372] bus: 'i2c': add driver ds2482
[    6.467095] i2c-core: driver [ds2482] registered
[    6.467863] bus: 'platform': add driver w1-gpio
[    6.478519] bus: 'platform': remove driver w1-gpio
[    6.479384] driver: 'w1-gpio': driver_release
[    6.480285] bus: 'i2c': add driver asb100
[    6.480994] i2c-core: driver [asb100] registered
[    6.481805] bus: 'i2c': add driver w83795
[    6.482723] i2c-core: driver [w83795] registered
[    6.483496] bus: 'i2c': add driver w83791d
[    6.484238] i2c-core: driver [w83791d] registered
[    6.485042] bus: 'i2c': add driver ad7418
[    6.485755] i2c-core: driver [ad7418] registered
[    6.486688] bus: 'i2c': add driver adm1025
[    6.487393] i2c-core: driver [adm1025] registered
[    6.505630] bus: 'i2c': add driver adm1031
[    6.506412] i2c-core: driver [adm1031] registered
[    6.507172] bus: 'i2c': add driver ads1015
[    6.507824] i2c-core: driver [ads1015] registered
[    6.508605] bus: 'i2c': add driver asc7621
[    6.509250] i2c-core: driver [asc7621] registered
[    6.509989] bus: 'i2c': add driver atxp1
[    6.510624] i2c-core: driver [atxp1] registered
[    6.511331] bus: 'i2c': add driver dme1737
[    6.512020] i2c-core: driver [dme1737] registered
[    6.512799] bus: 'i2c': add driver ds620
[    6.513407] i2c-core: driver [ds620] registered
[    6.514136] bus: 'i2c': add driver ds1621
[    6.542306] i2c-core: driver [ds1621] registered
[    6.543061] bus: 'i2c': add driver emc6w201
[    6.543742] i2c-core: driver [emc6w201] registered
[    6.544604] bus: 'i2c': add driver gl518sm
[    6.545262] i2c-core: driver [gl518sm] registered
[    6.546005] bus: 'platform': add driver gpio-fan
[    6.546848] bus: 'i2c': add driver hih6130
[    6.547502] i2c-core: driver [hih6130] registered
[    6.548294] bus: 'platform': add driver aem
[    6.549000] bus: 'i2c': add driver ina2xx
[    6.549680] i2c-core: driver [ina2xx] registered
[    6.550446] bus: 'i2c': add driver jc42
[    6.551087] i2c-core: driver [jc42] registered
[    6.551807] bus: 'i2c': add driver lineage_pem
[    6.552508] i2c-core: driver [lineage_pem] registered
[    6.563166] device: 'input1': device_add
[    6.563907] PM: Adding info for No Bus:input1
[    6.564701] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    6.566065] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    6.567155] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[    6.568261] bus: 'i2c': add driver lm77
[    6.568903] i2c-core: driver [lm77] registered
[    6.569639] bus: 'i2c': add driver lm80
[    6.578409] i2c-core: driver [lm80] registered
[    6.579138] bus: 'i2c': add driver lm83
[    6.579785] i2c-core: driver [lm83] registered
[    6.580486] bus: 'i2c': add driver lm85
[    6.581134] i2c-core: driver [lm85] registered
[    6.581846] bus: 'i2c': add driver lm87
[    6.582461] i2c-core: driver [lm87] registered
[    6.583197] bus: 'i2c': add driver lm92
[    6.583835] i2c-core: driver [lm92] registered
[    6.584556] bus: 'i2c': add driver ltc4215
[    6.585222] i2c-core: driver [ltc4215] registered
[    6.585968] bus: 'i2c': add driver ltc4245
[    6.590754] i2c-core: driver [ltc4245] registered
[    6.591492] bus: 'i2c': add driver ltc4261
[    6.592169] i2c-core: driver [ltc4261] registered
[    6.592919] bus: 'i2c': add driver max6639
[    6.593609] i2c-core: driver [max6639] registered
[    6.625347] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[    6.629810] bus: 'serio': really_probe: probing driver atkbd with device=
 serio1
[    6.631122] bus: 'i2c': add driver max6642
[    6.631822] i2c-core: driver [max6642] registered
[    6.632552] bus: 'platform': add driver mc13783-adc
[    6.638625] bus: 'platform': remove driver mc13783-adc
[    6.639416] driver: 'mc13783-adc': driver_release
[    6.640175] bus: 'i2c': add driver mcp3021
[    6.640829] i2c-core: driver [mcp3021] registered
[    6.641535] bus: 'i2c': add driver pcf8591
[    6.650440] atkbd: probe of serio1 rejects match -19
[    6.651344] i2c-core: driver [pcf8591] registered
[    6.652151] bus: 'platform': add driver sch5636
[    6.652891] bus: 'platform': add driver sht10
[    6.653609] bus: 'platform': add driver sht11
[    6.654300] bus: 'platform': add driver sht15
[    6.655007] bus: 'platform': add driver sht71
[    6.655713] bus: 'platform': add driver sht75
[    6.656414] bus: 'i2c': add driver smm665
[    6.657092] i2c-core: driver [smm665] registered
[    6.657881] bus: 'i2c': add driver smsc47m192
[    6.662698] i2c-core: driver [smsc47m192] registered
[    6.663479] bus: 'i2c': add driver tmp102
[    6.664183] i2c-core: driver [tmp102] registered
[    6.664907] bus: 'i2c': add driver tmp401
[    6.665533] i2c-core: driver [tmp401] registered
[    6.674441] bus: 'i2c': add driver tmp421
[    6.675112] i2c-core: driver [tmp421] registered
[    6.675922] bus: 'i2c': add driver w83l785ts
[    6.676651] i2c-core: driver [w83l785ts] registered
[    6.677419] bus: 'i2c': add driver pmbus
[    6.678111] i2c-core: driver [pmbus] registered
[    6.678849] bus: 'i2c': add driver adm1275
[    6.679483] i2c-core: driver [adm1275] registered
[    6.682684] bus: 'i2c': add driver lm25066
[    6.683344] i2c-core: driver [lm25066] registered
[    6.684139] bus: 'i2c': add driver ltc2978
[    6.684831] i2c-core: driver [ltc2978] registered
[    6.685559] bus: 'i2c': add driver max16064
[    6.690991] i2c-core: driver [max16064] registered
[    6.691771] bus: 'i2c': add driver max34440
[    6.692446] i2c-core: driver [max34440] registered
[    6.693221] bus: 'i2c': add driver max8688
[    6.693905] i2c-core: driver [max8688] registered
[    6.694692] bus: 'i2c': add driver ucd9000
[    6.695347] i2c-core: driver [ucd9000] registered
[    6.696126] bus: 'i2c': add driver ucd9200
[    6.696802] i2c-core: driver [ucd9200] registered
[    6.697643] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    6.711409] bus: 'platform': add driver ib700wdt
[    6.712204] Registering platform device 'ib700wdt'. Parent at platform
[    6.713241] device: 'ib700wdt': device_add
[    6.713901] bus: 'platform': add device ib700wdt
[    6.718865] PM: Adding info for platform:ib700wdt
[    6.719655] bus: 'platform': driver_probe_device: matched device ib700wd=
t with driver ib700wdt
[    6.721003] bus: 'platform': really_probe: probing driver ib700wdt with =
device ib700wdt
[    6.730482] device: 'watchdog': device_add
[    6.731240] PM: Adding info for No Bus:watchdog
[    6.732005] driver: 'ib700wdt': driver_bound: bound to device 'ib700wdt'
[    6.733076] bus: 'platform': really_probe: bound device ib700wdt to driv=
er ib700wdt
[    6.738458] sc1200wdt: build 20020303
[    6.739065] bus: 'pnp': add driver scl200wdt
[    6.739781] sc1200wdt: io parameter must be specified
[    6.740614] bus: 'pnp': remove driver scl200wdt
[    6.741332] driver: 'scl200wdt': driver_release
[    6.742093] bus: 'platform': add driver rdc321x-wdt
[    6.742877] sbc8360: failed to register misc device
[    6.743718] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    6.745666] smsc37b787_wdt: Unable to register miscdev on minor 130
[    6.754788] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG=
/DHG Super I/O chip initialising
[    6.756304] w83627hf_wdt: Watchdog already running. Resetting timeout to=
 60 sec
[    6.757497] w83627hf_wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    6.770742] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    6.772135] w83697ug_wdt: No W83697UG/UF could be found
[    6.772961] w83977f_wdt: driver v1.00
[    6.773540] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    6.774652] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    6.775700] bus: 'platform': add driver da9052-watchdog
[    6.776617] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    6.777897] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    6.783271] device: 'watchdog1': device_add
[    6.784043] PM: Adding info for No Bus:watchdog1
[    6.784833] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[    6.788038] md: linear personality registered for level -1
[    6.788923] md: raid0 personality registered for level 0
[    6.789780] md: raid6 personality registered for level 6
[    6.790633] md: raid5 personality registered for level 5
[    6.791437] md: raid4 personality registered for level 4
[    6.792291] md: faulty personality registered for level -5
[    6.793307] device-mapper: uevent: version 1.0.3
[    6.794693] device: 'device-mapper': device_add
[    6.795833] PM: Adding info for No Bus:device-mapper
[    6.796651] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised:=
 dm-devel@redhat.com
[    6.799115] Bluetooth: Virtual HCI driver ver 1.3
[    6.807029] device: 'vhci': device_add
[    6.807680] PM: Adding info for No Bus:vhci
[    6.808328] bus: 'usb': add driver bcm203x
[    6.809004] usbcore: registered new interface driver bcm203x
[    6.809923] bus: 'usb': add driver bfusb
[    6.817020] usbcore: registered new interface driver bfusb
[    6.817884] bus: 'pcmcia': add driver bluecard_cs
[    6.818801] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    6.819712] bus: 'sdio': add driver btsdio
[    6.820526] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/1.1.2.2/1.1.2.2
[    6.821741] dss1_divert module successfully installed
[    6.822527] HiSax: Linux Driver for passive ISDN cards
[    6.823360] HiSax: Version 3.5 (kernel)
[    6.823980] HiSax: Layer1 Revision 2.46.2.5
[    6.824692] HiSax: Layer2 Revision 2.30.2.4
[    6.825345] HiSax: TeiMgr Revision 2.20.2.3
[    6.826024] HiSax: Layer3 Revision 2.22.2.3
[    6.826797] HiSax: LinkLayer Revision 2.59.2.4
[    6.827505] HiSax: Total 1 card defined
[    6.828176] HiSax: Card 1 Protocol 1TR6 Id=3DHiSax (0)
[    6.828997] Gazel: Driver Revision 2.19.2.4
[    6.829691] Gazel: ISA PnP card automatic recognition
[    6.834635] Gazel: Card ISA R647/R648 found
[    6.835293] Gazel: config irq:15 isac:0x8180  cfg:0xC180
[    6.836140] Gazel: hscx A:0x180  hscx B:0x4180
[    6.954860] Gazel: ISAC version (ff): 2085 V2.3
[    6.955626] Gazel: HSCX version A: ???  B: ???
[    6.956293] Gazel: wrong HSCX versions check IO address
[    6.962897] HiSax: Card Gazel not installed !
[    6.963602] bus: 'pcmcia': add driver elsa_cs
[    6.964322] bus: 'pcmcia': add driver avma1_cs
[    6.965060] HFC-S USB: driver module revision 2.3.2.24 date 2007/10/14 l=
oaded, (debug=3D0)
[    6.966332] bus: 'usb': add driver hfc_usb
[    6.967016] usbcore: registered new interface driver hfc_usb
[    6.967919] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, R=
evision: 1.10
[    6.969140] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult=
=2Ede
[    6.974343] bus: 'pci': add driver hfc4s8s_l1
[    6.975083] HFC-4S/8S: found 0 cards
[    6.975674] ICN-ISDN-driver Rev 1.65.6.8 mem=3D0x000d0000
[    6.976483] icn: (line0) ICN-2B, port 0x320 added
[    6.977240] PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1=
996 Universidade de Lisboa
[    6.986797] Trying to detect board using default settings
[    6.987697] gigaset: Driver for Gigaset 307x (debug build)
[    6.988509] gigaset: Kernel CAPI interface
[    6.989226] bus: 'usb': add driver usb_gigaset
[    6.989960] usbcore: registered new interface driver usb_gigaset
[    6.990895] usb_gigaset: USB Driver for Gigaset 307x using M105
[    6.991855] cpuidle: using governor ladder
[    6.992487] bus: 'mmc': add driver mmcblk
[    6.993154] bus: 'mmc': add driver mmc_test
[    6.993848] wbsd: Winbond W83L51xD SD/MMC card interface driver
[    6.994917] wbsd: Copyright(c) Pierre Ossman
[    6.995621] bus: 'pnp': add driver wbsd
[    6.996229] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    7.007716] bus: 'usb': add driver vub300
[    7.008411] usbcore: registered new interface driver vub300
[    7.009282] bus: 'usb': add driver ushc
[    7.009924] usbcore: registered new interface driver ushc
[    7.010805] bus: 'i2c': add driver BD2802
[    7.011442] i2c-core: driver [BD2802] registered
[    7.012194] bus: 'i2c': add driver lm3530-led
[    7.012908] i2c-core: driver [lm3530-led] registered
[    7.013692] bus: 'i2c': add driver lp3944
[    7.014355] i2c-core: driver [lp3944] registered
[    7.015104] bus: 'i2c': add driver lp5523
[    7.015879] i2c-core: driver [lp5523] registered
[    7.016623] bus: 'i2c': add driver leds-pca955x
[    7.017338] i2c-core: driver [leds-pca955x] registered
[    7.018320] bus: 'i2c': add driver leds-pca9633
[    7.019062] i2c-core: driver [leds-pca9633] registered
[    7.019895] bus: 'platform': add driver mc13783-led
[    7.020688] bus: 'i2c': add driver blinkm
[    7.021325] i2c-core: driver [blinkm] registered
[    7.022076] Registering platform device 'dell_rbu'. Parent at platform
[    7.027228] device: 'dell_rbu': device_add
[    7.027910] bus: 'platform': add device dell_rbu
[    7.028652] PM: Adding info for platform:dell_rbu
[    7.029405] bus: 'platform': add driver dcdbas
[    7.030134] Registering platform device 'dcdbas'. Parent at platform
[    7.035245] device: 'dcdbas': device_add
[    7.035899] bus: 'platform': add device dcdbas
[    7.036625] PM: Adding info for platform:dcdbas
[    7.037343] bus: 'platform': driver_probe_device: matched device dcdbas =
with driver dcdbas
[    7.042739] bus: 'platform': really_probe: probing driver dcdbas with de=
vice dcdbas
[    7.043971] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    7.045188] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[    7.050302] bus: 'platform': really_probe: bound device dcdbas to driver=
 dcdbas
[    7.051460] No iBFT detected.
[    7.051979] bus: 'hid': registered
[    7.052600] bus: 'hid': add driver hid-generic
[    7.053293] bus: 'hid': add driver apple
[    7.053941] bus: 'hid': add driver belkin
[    7.054714] bus: 'hid': add driver cherry
[    7.055346] bus: 'hid': add driver chicony
[    7.056020] bus: 'hid': add driver hkems
[    7.056667] bus: 'hid': add driver gyration
[    7.057327] bus: 'hid': add driver kensington
[    7.058033] bus: 'hid': add driver keytouch
[    7.062804] bus: 'hid': add driver LC RC1000MCE
[    7.063512] bus: 'hid': add driver logitech
[    7.064222] bus: 'hid': add driver logitech-djreceiver
[    7.065065] bus: 'hid': add driver logitech-djdevice
[    7.065876] bus: 'hid': add driver microsoft
[    7.070704] bus: 'hid': add driver monterey
[    7.071374] bus: 'hid': add driver hid-multitouch
[    7.072136] bus: 'hid': add driver pantherlord
[    7.072876] bus: 'hid': add driver petalynx
[    7.073547] bus: 'hid': add driver hid-picolcd
[    7.078427] device class 'arvo': registering
[    7.079146] bus: 'hid': add driver arvo
[    7.079783] device class 'isku': registering
[    7.080460] bus: 'hid': add driver isku
[    7.081089] device class 'kone': registering
[    7.081778] bus: 'hid': add driver kone
[    7.086505] device class 'koneplus': registering
[    7.087261] bus: 'hid': add driver koneplus
[    7.087976] device class 'kovaplus': registering
[    7.088720] bus: 'hid': add driver kovaplus
[    7.089383] device class 'pyra': registering
[    7.090080] bus: 'hid': add driver pyra
[    7.094811] device class 'savu': registering
[    7.095473] bus: 'hid': add driver savu
[    7.096131] bus: 'hid': add driver sunplus
[    7.096788] bus: 'hid': add driver greenasia
[    7.097437] bus: 'hid': add driver thrustmaster
[    7.102257] bus: 'hid': add driver topseed
[    7.102959] bus: 'hid': add driver uclogic
[    7.103636] bus: 'hid': add driver zeroplus
[    7.104321] bus: 'hid': add driver zydacron
[    7.105018] bus: 'hid': add driver waltop
[    7.105697] bus: 'usb': add driver usbhid
[    7.110430] usbcore: registered new interface driver usbhid
[    7.111307] usbhid: USB HID core driver
[    7.111944] bus: 'i2c': add driver olpc_dcon
[    7.112643] i2c-core: driver [olpc_dcon] using legacy suspend method
[    7.113642] i2c-core: driver [olpc_dcon] using legacy resume method
[    7.118800] i2c-core: driver [olpc_dcon] registered
[    7.228227] device: 'lcd': device_add
[    7.228935] PM: Adding info for No Bus:lcd
[    7.229627] device: 'keypad': device_add
[    7.230279] PM: Adding info for No Bus:keypad
[    7.231101] panel: driver version 0.9.5 registered on parport0 (io=3D0x3=
78).
[    7.232161] bus: 'usb': add driver tranzport
[    7.232868] usbcore: registered new interface driver tranzport
[    7.233777] bus: 'usb': add driver alphatrack
[    7.235436] usbcore: registered new interface driver alphatrack
[    7.236514] device: 'iio_evgen': device_add
[    7.237160] bus: 'iio': add device iio_evgen
[    7.237783] PM: Adding info for iio:iio_evgen
[    7.239598] bus: 'platform': add driver iio_hwmon
[    7.240271] bus: 'i2c': add driver max1363
[    7.240876] i2c-core: driver [max1363] registered
[    7.241534] bus: 'platform': add driver ad7606
[    7.242472] bus: 'i2c': add driver ad799x
[    7.250882] i2c-core: driver [ad799x] registered
[    7.251630] bus: 'i2c': add driver ad7291
[    7.252243] i2c-core: driver [ad7291] registered
[    7.252983] bus: 'i2c': add driver adt7410
[    7.253669] i2c-core: driver [adt7410] registered
[    7.257271] bus: 'i2c': add driver ad7150
[    7.257930] i2c-core: driver [ad7150] registered
[    7.258693] bus: 'i2c': add driver isl29018
[    7.259284] i2c-core: driver [isl29018] registered
[    7.259969] bus: 'platform': add driver iio_gpio_trigger
[    7.260738] device: 'iio_sysfs_trigger': device_add
[    7.261412] bus: 'iio': add device iio_sysfs_trigger
[    7.262142] PM: Adding info for iio:iio_sysfs_trigger
[    7.263514] bus: 'i2c': add driver synaptics_rmi4_i2c
[    7.264434] i2c-core: driver [synaptics_rmi4_i2c] registered
[    7.271136] device: 'binder': device_add
[    7.271899] PM: Adding info for No Bus:binder
[    7.272714] device: 'ashmem': device_add
[    7.273440] PM: Adding info for No Bus:ashmem
[    7.275199] ashmem: initialized
[    7.275748] device: 'log_main': device_add
[    7.276401] PM: Adding info for No Bus:log_main
[    7.277134] logger: created 256K log 'log_main'
[    7.277877] device: 'log_events': device_add
[    7.283852] PM: Adding info for No Bus:log_events
[    7.284645] logger: created 256K log 'log_events'
[    7.285420] device: 'log_radio': device_add
[    7.286135] PM: Adding info for No Bus:log_radio
[    7.287188] logger: created 256K log 'log_radio'
[    7.287981] device: 'log_system': device_add
[    7.288801] PM: Adding info for No Bus:log_system
[    7.289482] logger: created 256K log 'log_system'
[    7.298312] device class 'timed_output': registering
[    7.299233] bus: 'platform': add driver timed-gpio
[    7.300089] device class 'ozmo_wpan': registering
[    7.300951] device: 'ozwpan': device_add
[    7.301702] PM: Adding info for No Bus:ozwpan
[    7.305093] bus: 'platform': add driver ozwpan
[    7.305891] Registering platform device 'ozwpan'. Parent at platform
[    7.307135] device: 'ozwpan': device_add
[    7.307725] bus: 'platform': add device ozwpan
[    7.308409] PM: Adding info for platform:ozwpan
[    7.309157] bus: 'platform': driver_probe_device: matched device ozwpan =
with driver ozwpan
[    7.311363] bus: 'platform': really_probe: probing driver ozwpan with de=
vice ozwpan
[    7.312548] ozwpan ozwpan: Ozmo Devices WPAN
[    7.313281] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    7.317203] device: 'usb1': device_add
[    7.317905] bus: 'usb': add device usb1
[    7.318458] PM: Adding info for usb:usb1
[    7.319062] bus: 'usb': driver_probe_device: matched device usb1 with dr=
iver usb
[    7.320214] bus: 'usb': really_probe: probing driver usb with device usb1
[    7.321238] device: '1-0:1.0': device_add
[    7.321861] bus: 'usb': add device 1-0:1.0
[    7.322419] PM: Adding info for usb:1-0:1.0
[    7.331046] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with=
 driver hub
[    7.332269] bus: 'usb': really_probe: probing driver hub with device 1-0=
:1.0
[    7.333388] hub 1-0:1.0: USB hub found
[    7.334073] hub 1-0:1.0: 8 ports detected
[    7.354332] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[    7.355335] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[    7.356438] device: 'ep_81': device_add
[    7.357114] PM: Adding info for No Bus:ep_81
[    7.357813] driver: 'usb1': driver_bound: bound to device 'usb'
[    7.358752] bus: 'usb': really_probe: bound device usb1 to driver usb
[    7.374885] device: 'ep_00': device_add
[    7.375517] PM: Adding info for No Bus:ep_00
[    7.376259] driver: 'ozwpan': driver_bound: bound to device 'ozwpan'
[    7.377275] bus: 'platform': really_probe: bound device ozwpan to driver=
 ozwpan
[    7.378466] bus: 'sdio': add driver sdio_wimax
[    7.379216] bus: 'pnp': add driver apple-gmux
[    7.379948] bus: 'platform': add driver olpc-ec
[    7.383300] bus: 'i2c': add driver adjd_s311
[    7.384040] i2c-core: driver [adjd_s311] registered
[    7.384830] bus: 'i2c': add driver mcp4725
[    7.385481] i2c-core: driver [mcp4725] registered
[    7.407074] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    7.408560] NET: Registered protocol family 26
[    7.409348] device: 'teql0': device_add
[    7.410064] PM: Adding info for No Bus:teql0
[    7.410825] u32 classifier
[    7.411258]     Performance counters on
[    7.411878]     input device check on
[    7.412478] NET: Registered protocol family 15
[    7.413229] bus: 'platform': add driver dsa
[    7.413953] NET: Registered protocol family 4
[    7.414705] NET: Registered protocol family 9
[    7.415371] X.25 for Linux Version 0.2
[    7.415980] NET: Registered protocol family 3
[    7.416706] lib80211: common routines for IEEE802.11 drivers
[    7.417605] lib80211_crypt: registered algorithm 'NULL'
[    7.418447] NET: Registered protocol family 37
[    7.419697]=20
[    7.419697] printing PIC contents
[    7.420444] ... PIC  IMR: ffff
[    7.420969] ... PIC  IRR: 1013
[    7.421448] ... PIC  ISR: 0000
[    7.434057] ... PIC ELCR: 0c00
[    7.434552] printing local APIC contents on CPU#0/0:
[    7.435294] ... APIC ID:      00000000 (0)
[    7.435901] ... APIC VERSION: 00050014
[    7.436440] ... APIC TASKPRI: 00000000 (00)
[    7.437066] ... APIC PROCPRI: 00000000
[    7.437620] ... APIC LDR: 01000000
[    7.437865] ... APIC DFR: ffffffff
[    7.437865] ... APIC SPIV: 000001ff
[    7.437865] ... APIC ISR field:
[    7.437865] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.437865] ... APIC TMR field:
[    7.437865] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.437865] ... APIC IRR field:
[    7.437865] 000000000000000000000000000000000000000000000000000000000000=
8000
[    7.437865] ... APIC ESR: 00000000
[    7.437865] ... APIC ICR: 000008fd
[    7.437865] ... APIC ICR2: 02000000
[    7.437865] ... APIC LVTT: 000200ef
[    7.437865] ... APIC LVTPC: 00010000
[    7.437865] ... APIC LVT0: 00010700
[    7.437865] ... APIC LVT1: 00000400
[    7.437865] ... APIC LVTERR: 000000fe
[    7.437865] ... APIC TMICT: 00098969
[    7.437865] ... APIC TMCCT: 0002576b
[    7.437865] ... APIC TDCR: 00000003
[    7.437865]=20
[    7.466911] number of MP IRQ sources: 15.
[    7.467477] number of IO-APIC #2 registers: 24.
[    7.468132] testing the IO APIC.......................
[    7.468863] IO APIC #2......
[    7.469272] .... register #00: 00000000
[    7.469828] .......    : physical APIC id: 00
[    7.470420] .......    : Delivery Type: 0
[    7.470992] .......    : LTS          : 0
[    7.471541] .... register #01: 00170011
[    7.480305] .......     : max redirection entries: 17
[    7.481120] .......     : PRQ implemented: 0
[    7.481887] .......     : IO APIC version: 11
[    7.482644] .... register #02: 00000000
[    7.491398] .......     : arbitration: 00
[    7.491981] .... IRQ redirection table:
[    7.492503]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    7.493295]  00 00  1    0    0   0   0    0    0    00
[    7.494074]  01 03  0    0    0   0   0    1    1    41
[    7.504312]  02 03  0    0    0   0   0    1    1    51
[    7.505084]  03 01  0    0    0   0   0    1    1    61
[    7.505851]  04 01  1    0    0   0   0    1    1    71
[    7.506608]  05 01  0    1    0   0   0    1    1    81
[    7.512804]  06 01  0    0    0   0   0    1    1    91
[    7.513802]  07 01  0    0    0   0   0    1    1    A1
[    7.520129]  08 01  0    0    0   0   0    1    1    B1
[    7.521024]  09 01  0    1    0   0   0    1    1    C1
[    7.521931]  0a 01  1    1    0   0   0    1    1    D1
[    7.528183]  0b 01  1    1    0   0   0    1    1    E1
[    7.529105]  0c 03  0    0    0   0   0    1    1    22
[    7.530034]  0d 01  0    0    0   0   0    1    1    42
[    7.536239]  0e 01  0    0    0   0   0    1    1    52
[    7.537063]  0f 01  0    0    0   0   0    1    1    62
[    7.537897]  10 00  1    0    0   0   0    0    0    00
[    7.544157]  11 00  1    0    0   0   0    0    0    00
[    7.545085]  12 00  1    0    0   0   0    0    0    00
[    7.545986]  13 00  1    0    0   0   0    0    0    00
[    7.552214]  14 00  1    0    0   0   0    0    0    00
[    7.553173]  15 00  1    0    0   0   0    0    0    00
[    7.554173]  16 00  1    0    0   0   0    0    0    00
[    7.555295]  17 00  1    0    0   0   0    0    0    00
[    7.556235] IRQ to pin mappings:
[    7.556784] IRQ0 -> 0:2
[    7.557186] IRQ1 -> 0:1
[    7.557596] IRQ3 -> 0:3
[    7.557973] IRQ4 -> 0:4
[    7.558348] IRQ5 -> 0:5
[    7.558782] IRQ6 -> 0:6
[    7.559161] IRQ7 -> 0:7
[    7.559546] IRQ8 -> 0:8
[    7.559967] IRQ9 -> 0:9
[    7.566604] IRQ10 -> 0:10
[    7.567006] IRQ11 -> 0:11
[    7.567415] IRQ12 -> 0:12
[    7.567849] IRQ13 -> 0:13
[    7.568301] IRQ14 -> 0:14
[    7.568732] IRQ15 -> 0:15
[    7.569145] .................................... done.
[    7.569876] Using IPI No-Shortcut mode
[    7.570466] device: 'cpu_dma_latency': device_add
[    7.576162] PM: Adding info for No Bus:cpu_dma_latency
[    7.576923] device: 'network_latency': device_add
[    7.578991] PM: Adding info for No Bus:network_latency
[    7.579732] device: 'network_throughput': device_add
[    7.580497] PM: Adding info for No Bus:network_throughput
[    7.581491] registered taskstats version 1
[    7.592880] Key type encrypted registered
[    7.593755] raid6test: testing the 4-disk case...
[    7.594505] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    7.595494] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[    7.596439] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[    7.597421] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[    7.598404] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[    7.599376] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[    7.600475] raid6test: testing the 5-disk case...
[    7.601339] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    7.602516] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    7.603722] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[    7.604855] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[    7.619054] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    7.620071] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[    7.621045] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[    7.622039] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[    7.623018] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[    7.623993] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[    7.630602] raid6test: testing the 11-disk case...
[    7.631365] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    7.632423] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    7.633490] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    7.634534] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    7.635594] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    7.636623] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    7.637661] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    7.638753] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    7.661863] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[    7.662893] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[    7.663957] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    7.665010] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    7.666058] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    7.698168] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    7.699224] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    7.700263] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    7.701265] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    7.707352] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[    7.708453] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[    7.712355] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    7.713611] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    7.714636] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    7.715725] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    7.720403] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    7.730236] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    7.731290] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[    7.735744] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[    7.741544] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    7.747717] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    7.755706] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    7.757823] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    7.759929] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    7.763848] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[    7.769111] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[    7.774535] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    7.777649] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    7.780822] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    7.783917] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    7.786128] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[    7.791296] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[    7.794456] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    7.796607] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    7.799763] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    7.803239] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[    7.806371] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[    7.809510] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    7.812694] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    7.815848] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[    7.817945] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[    7.821138] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    7.824819] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[    7.826895] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[    7.829048] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[    7.833300] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[    7.835600] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[    7.837766] raid6test: testing the 12-disk case...
[    7.839718] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    7.841809] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    7.843844] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    7.845942] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    7.848002] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    7.850086] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    7.852098] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    7.854155] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    7.857369] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    7.859680] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[    7.861870] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[    7.863984] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    7.866099] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    7.869205] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    7.871325] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    7.873343] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    7.875424] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    7.877453] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    7.879603] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    7.881791] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[    7.883993] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[    7.887312] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    7.889552] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    7.891616] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    7.893669] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    7.895743] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    7.898794] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    7.899943] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    7.901951] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[    7.903980] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[    7.908236] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    7.909615] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    7.911853] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    7.915004] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    7.917112] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    7.920287] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    7.922358] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[    7.924617] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[    7.926765] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    7.928878] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    7.931656] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    7.933861] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    7.936109] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    7.940235] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[    7.942340] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[    7.944524] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    7.946622] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    7.948718] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    7.950960] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    7.952067] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[    7.955330] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[    7.957542] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    7.959899] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    7.961117] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    7.964322] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[    7.965428] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[    7.967589] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    7.969773] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    7.970832] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[    7.973067] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[    7.976244] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    7.978384] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[    7.980504] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[    7.982670] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[    7.984850] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[    7.987013] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[    7.990356] raid6test: testing the 16-disk case...
[    7.992349] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    7.994496] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    7.996607] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    7.998740] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    8.000809] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    8.002927] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    8.005128] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    8.007334] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    8.009681] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    8.011904] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    8.014159] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    8.017368] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    8.019553] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    8.021698] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(P)=
  OK
[    8.023772] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(Q)=
  OK
[    8.025888] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    8.027993] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    8.030131] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    8.033299] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    8.035524] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    8.037767] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    8.040082] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    8.043335] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    8.045509] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    8.047634] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    8.049838] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    8.052013] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    8.054166] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(P)=
  OK
[    8.057426] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(Q)=
  OK
[    8.059699] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    8.060826] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    8.063031] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    8.066315] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    8.068643] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    8.070896] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    8.074280] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    8.076537] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    8.078811] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    8.080962] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    8.083163] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    8.086351] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(P)=
  OK
[    8.088958] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(Q)=
  OK
[    8.092101] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    8.095011] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    8.097028] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    8.101336] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    8.103445] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    8.105555] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    8.107698] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    8.110745] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    8.112925] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    8.115082] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    8.118353] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(P)=
  OK
[    8.119700] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(Q)=
  OK
[    8.121921] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    8.125196] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    8.127396] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    8.129713] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    8.131867] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    8.133977] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    8.136104] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    8.139249] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    8.141426] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    8.143525] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(P)=
  OK
[    8.145744] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(Q)=
  OK
[    8.147931] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    8.151221] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    8.153453] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    8.155751] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    8.158736] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    8.159935] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    8.162029] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    8.165190] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    8.166344] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(P)=
  OK
[    8.168457] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(Q)=
  OK
[    8.170616] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    8.172863] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    8.173949] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    8.176130] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    8.179462] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    8.180675] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    8.182905] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    8.186238] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(P)=
  OK
[    8.188322] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(Q)=
  OK
[    8.190472] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    8.191686] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    8.194864] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    8.197092] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    8.199526] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    8.201681] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    8.203832] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(P)=
  OK
[    8.206027] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(Q)=
  OK
[    8.208117] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    8.211239] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    8.213305] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    8.215436] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    8.217530] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    8.219879] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(P)=
  OK
[    8.222108] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(Q)=
  OK
[    8.224427] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    8.226526] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    8.228658] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    8.230701] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    8.232831] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(P)=
  OK
[    8.234794] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(Q)=
  OK
[    8.235796] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    8.236836] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    8.237934] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    8.239131] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(P=
)  OK
[    8.250245] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(Q=
)  OK
[    8.251323] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    8.252421] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    8.253449] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(P=
)  OK
[    8.254494] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(Q=
)  OK
[    8.255508] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    8.256533] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(P=
)  OK
[    8.257554] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(Q=
)  OK
[    8.258623] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(P=
)  OK
[    8.266180] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(Q=
)  OK
[    8.267194] raid6test: test_disks(14, 15): faila=3D 14(P)  failb=3D 15(Q=
)  OK
[    8.268313] raid6test:=20
[    8.268721] raid6test: complete (257 tests, 0 failures)
[    8.335800] console [netcon0] enabled
[    8.336437] netconsole: network logging started
[    8.340327] Freeing unused kernel memory: 460k freed
[ 1107.515496] [sched_delayed] sched: RT throttling activated
[ 1107.516439] BUG: soft lockup - CPU#1 stuck for 1024s! [swapper/1:0]
[ 1107.516439] irq event stamp: 13644
[ 1107.516439] hardirqs last  enabled at (13641): [<c167d0c5>] restore_all_=
notrace+0x0/0x18
[ 1107.516439] hardirqs last disabled at (13642): [<c167d3cf>] apic_timer_i=
nterrupt+0x2f/0x40
[ 1107.516439] softirqs last  enabled at (13644): [<c102e6ae>] _local_bh_en=
able+0xd/0xf
[ 1107.516439] softirqs last disabled at (13643): [<c102eb79>] irq_enter+0x=
2c/0x4d
[ 1107.516439] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-00023-g8a13a4c=
 #66 =20
[ 1107.516439] EIP: 0060:[<c101da64>] EFLAGS: 00000286 CPU: 1
[ 1107.516439] EIP is at native_safe_halt+0x5/0x7
[ 1107.516439] EAX: ce06a260 EBX: ffffffff ECX: ce06a260 EDX: 00000007
[ 1107.516439] ESI: cfff9e80 EDI: cfff9e70 EBP: ce071f6c ESP: ce071f6c
[ 1107.516439]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1107.516439] CR0: 8005003b CR2: b766c130 CR3: 0e83b000 CR4: 00000690
[ 1107.516439] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[ 1107.516439] DR6: ffff0ff0 DR7: 00000400
[ 1107.516439] Process swapper/1 (pid: 0, ti=3Dce070000 task=3Dce06a260 tas=
k.ti=3Dce070000)
[ 1107.516439] Stack:
[ 1107.516439]  ce071f74 c1008a89 ce071f88 c10092c6 cde0a192 dc4426ba 168f4=
76e ce071fb4
[ 1107.516439]  c166d17b 00000000 00000000 00000000 00000000 86be5003 168f4=
76e 01000800
[ 1107.516439]  0000d248 00000000 00000000 00000000 00000000 00000000 00000=
000 00000000
[ 1107.516439] Call Trace:
[ 1107.516439]  [<c1008a89>] default_idle+0x2f/0x55
[ 1107.516439]  [<c10092c6>] cpu_idle+0xc7/0xf9
[ 1107.516439]  [<c166d17b>] start_secondary+0x296/0x29e
[ 1107.516439] Code: 0f 22 e0 5d c3 55 89 e5 0f 09 5d c3 55 89 e5 9c 58 5d =
c3 55 89 e5 50 9d 5d c3 55 89 e5 fa 5d c3 55 89 e5 fb 5d c3 55 89 e5 fb f4 =
<5d> c3 55 89 e5 f4 5d c3 55 89 e5 57 56 53 53 89 c7 89 55 f0 89
[ 1107.580977] Kernel panic - not syncing: softlockup: hung tasks
[ 1107.580977] Pid: 0, comm: swapper/1 Not tainted 3.6.0-rc1-00023-g8a13a4c=
 #66
[ 1107.580977] Call Trace:
[ 1107.580977]  [<c1671945>] panic+0x97/0x1a4
[ 1107.580977]  [<c101da79>] ? native_cpuid+0xd/0x28
[ 1107.580977]  [<c1080385>] watchdog_timer_fn+0x112/0x131
[ 1107.580977]  [<c10432c4>] hrtimer_run_queues+0x14c/0x1c4
[ 1107.580977]  [<c1080273>] ? __touch_watchdog+0x1d/0x1d
[ 1107.580977]  [<c10320f8>] run_local_timers+0x8/0x14
[ 1107.580977]  [<c1032128>] update_process_times+0x24/0x58
[ 1107.580977]  [<c10629e6>] tick_periodic+0x66/0x72
[ 1107.580977]  [<c1062a46>] tick_handle_periodic+0x19/0x61
[ 1107.580977]  [<c1018c17>] smp_apic_timer_interrupt+0x6d/0x7f
[ 1107.580977]  [<c12b3440>] ? trace_hardirqs_off_thunk+0xc/0x10
[ 1107.580977]  [<c167d3d6>] apic_timer_interrupt+0x36/0x40
[ 1107.580977]  [<c101da64>] ? native_safe_halt+0x5/0x7
[ 1107.580977]  [<c1008a89>] default_idle+0x2f/0x55
[ 1107.580977]  [<c10092c6>] cpu_idle+0xc7/0xf9
[ 1107.580977]  [<c166d17b>] start_secondary+0x296/0x29e
[ 1107.580977] Rebooting in 10 seconds..
--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc1-00023-g8a13a4c"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_WANT_INTEL_MID is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_DEBUG=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
CONFIG_MELAN=y
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
# CONFIG_BRIDGE is not set
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_SCC=y
# CONFIG_SCC_DELAY is not set
CONFIG_SCC_TRXECHO=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=y
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
CONFIG_CMA_SIZE_SEL_PERCENTAGE=y
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_OF_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
# CONFIG_MTD_BLOCK_RO is not set
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_PHYSMAP_OF is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_PCMCIA=y
CONFIG_MTD_PCMCIA_ANONYMOUS=y
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=y
CONFIG_MTD_DOC2001=y
CONFIG_MTD_DOC2001PLUS=y
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=y
CONFIG_MTD_DOCECC=y
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
# CONFIG_MTD_DOCPROBE_HIGH is not set
# CONFIG_MTD_DOCPROBE_55AA is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_MUSEUM_IDS=y
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ALAUDA is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_T128=y
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_PLATFORM=y
CONFIG_PATA_OF_PLATFORM=y
CONFIG_PATA_QDI=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=y
# CONFIG_MULTICORE_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
# CONFIG_ARCNET_COM20020_ISA is not set
# CONFIG_ARCNET_COM20020_PCI is not set
# CONFIG_ARCNET_COM20020_CS is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_EWRK3 is not set
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_AT1700 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_ETH16I=y
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=y
# CONFIG_KSZ884X_PCI is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_EL2=y
# CONFIG_AC3200 is not set
# CONFIG_PCMCIA_AXNET is not set
CONFIG_E2100=y
# CONFIG_HPLAN_PLUS is not set
# CONFIG_HPLAN is not set
CONFIG_NE2000=y
# CONFIG_NE2K_PCI is not set
# CONFIG_PCMCIA_PCNET is not set
CONFIG_ULTRA=y
# CONFIG_WD80x3 is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_SEEQ8005 is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=y
CONFIG_SLHC=y
CONFIG_SLIP_COMPRESSED=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
# CONFIG_USB_NET_CDC_NCM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=y
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
# CONFIG_LAPBETHER is not set
CONFIG_X25_ASY=y
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set
# CONFIG_ISDN_X25 is not set

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
# CONFIG_HISAX_EURO is not set
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_0 is not set
# CONFIG_HISAX_16_3 is not set
# CONFIG_HISAX_TELESPCI is not set
# CONFIG_HISAX_S0BOX is not set
# CONFIG_HISAX_AVM_A1 is not set
CONFIG_HISAX_FRITZPCI=y
# CONFIG_HISAX_AVM_A1_PCMCIA is not set
CONFIG_HISAX_ELSA=y
# CONFIG_HISAX_IX1MICROR2 is not set
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_ASUSCOM=y
CONFIG_HISAX_TELEINT=y
# CONFIG_HISAX_HFCS is not set
# CONFIG_HISAX_SEDLBAUER is not set
# CONFIG_HISAX_SPORTSTER is not set
# CONFIG_HISAX_MIC is not set
# CONFIG_HISAX_NETJET is not set
# CONFIG_HISAX_NETJET_U is not set
# CONFIG_HISAX_NICCY is not set
CONFIG_HISAX_ISURF=y
CONFIG_HISAX_HSTSAPHIR=y
# CONFIG_HISAX_BKM_A4T is not set
# CONFIG_HISAX_SCT_QUADRO is not set
CONFIG_HISAX_GAZEL=y
# CONFIG_HISAX_HFC_PCI is not set
# CONFIG_HISAX_W6692 is not set
CONFIG_HISAX_HFC_SX=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_ELSA_CS=y
CONFIG_HISAX_AVM_A1_CS=y

#
# HiSax sub driver modules
#
# CONFIG_HISAX_ST5481 is not set
CONFIG_HISAX_HFCUSB=y
CONFIG_HISAX_HFC4S8S=y
# CONFIG_HISAX_FRITZ_PCIPNP is not set

#
# Active cards
#
CONFIG_ISDN_DRV_ICN=y
CONFIG_ISDN_DRV_PCBIT=y
# CONFIG_ISDN_DRV_SC is not set
# CONFIG_ISDN_DRV_ACT2000 is not set
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
# CONFIG_ISDN_CAPI_CAPI20 is not set
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
# CONFIG_GIGASET_M101 is not set
CONFIG_GIGASET_DEBUG=y
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
CONFIG_GEN_RTC=y
CONFIG_GEN_RTC_X=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS65910 is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
CONFIG_DA9052_WATCHDOG=y
# CONFIG_TWL4030_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_RDC321X_WDT=y
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
CONFIG_SBC_EPX_C3_WATCHDOG=y

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_USB=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_SM501=y
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_ATM is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TWL6030_USB is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM3556 is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_LEGACY_SYSFS is not set
CONFIG_EDAC_DEBUG=y
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_FB_OLPC_DCON=y
CONFIG_FB_OLPC_DCON_1_5=y
# CONFIG_ASUS_OLED is not set
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_RTS_PSTOR is not set
# CONFIG_RTS5139 is not set
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
CONFIG_IIO_ST_HWMON=y
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
CONFIG_ADT7410=y
CONFIG_MAX1363=y
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Inertial measurement units
#

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_AK8975 is not set
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_GPIO_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
# CONFIG_ZRAM is not set
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=y
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_PHONE is not set
CONFIG_USB_WPAN_HCD=y
# CONFIG_IPACK_BUS is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
# CONFIG_WIMAX_GDM72XX_K_MODE is not set
CONFIG_WIMAX_GDM72XX_WIMAX2=y
# CONFIG_WIMAX_GDM72XX_USB is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_VCNL4000 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_LOGFS=y
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y

--cWoXeonUoKmBZSoM--
