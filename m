Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2GTLPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 07:15:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56661 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GTLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 07:15:33 -0400
Message-ID: <50093DED.7090706@gmail.com>
Date: Fri, 20 Jul 2012 13:15:57 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120713 Thunderbird/13.0
MIME-Version: 1.0
To: tglx@linutronix.de
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: hrtimer: Lockups with latest -next kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest on the latest -next kernel, I've started seeing
hangs straight away after the guest has started fuzzing.

I've annotated the hang spots with [HANG]. When those happen everything is pretty much locked up.


[   39.030023] hrtimer: interrupt took 3064 ns
[   39.030025] hrtimer: interrupt took 2769 ns

[HANG]

[   78.052011] ------------[ cut here ]------------
[   78.052012] ------------[ cut here ]------------
[   78.052038] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x48/0xf0()
[   78.052041] Pid: 0, comm: swapper/2 Tainted: G        W    3.5.0-rc7-next-20120720-sasha-00001-g0bb3f48-dirty #227
[   78.052041] Call Trace:
[   78.052058]  <IRQ>  [<ffffffff811554b8>] ? clockevents_program_event+0x48/0xf0
[   78.052082]  [<ffffffff810e93d7>] warn_slowpath_common+0x87/0xb0
[   78.052086]  [<ffffffff810e94c5>] warn_slowpath_null+0x15/0x20
[   78.052086]  [<ffffffff811554b8>] clockevents_program_event+0x48/0xf0
[   78.052103]  [<ffffffff8115717f>] tick_program_event+0x1f/0x30
[   78.052121]  [<ffffffff8111e62a>] hrtimer_interrupt+0x1ea/0x220
[   78.052132]  [<ffffffff81092035>] smp_apic_timer_interrupt+0x85/0xa0
[   78.052132]  [<ffffffff8378c82f>] apic_timer_interrupt+0x6f/0x80
[   78.052150]  <EOI>  [<ffffffff8378b234>] ? retint_restore_args+0x13/0x13
[   78.052169]  [<ffffffff8109e036>] ? native_safe_halt+0x6/0x10
[   78.052179]  [<ffffffff8115d78d>] ? trace_hardirqs_on+0xd/0x10
[   78.052179]  [<ffffffff81074a65>] default_idle+0x235/0x5c0
[   78.052196]  [<ffffffff81076648>] cpu_idle+0x118/0x160
[   78.052212]  [<ffffffff836c100e>] start_secondary+0xd0/0xd7
[   78.052218] ---[ end trace 2b1961b84676e158 ]---
[   78.061989] WARNING: at kernel/time/clockevents.c:209 clockevents_program_event+0x48/0xf0()
[   78.061989] Pid: 0, comm: swapper/3 Tainted: G        W    3.5.0-rc7-next-20120720-sasha-00001-g0bb3f48-dirty #227
[   78.061989] Call Trace:
[   78.061989]  <IRQ>  [<ffffffff811554b8>] ? clockevents_program_event+0x48/0xf0
[   78.061989]  [<ffffffff810e93d7>] warn_slowpath_common+0x87/0xb0
[   78.061989]  [<ffffffff810e94c5>] warn_slowpath_null+0x15/0x20
[   78.061989]  [<ffffffff811554b8>] clockevents_program_event+0x48/0xf0
[   78.061989]  [<ffffffff8115717f>] tick_program_event+0x1f/0x30
[   78.061989]  [<ffffffff8111e62a>] hrtimer_interrupt+0x1ea/0x220
[   78.061989]  [<ffffffff81092035>] smp_apic_timer_interrupt+0x85/0xa0
[   78.061989]  [<ffffffff8378c82f>] apic_timer_interrupt+0x6f/0x80
[   78.061989]  <EOI>  [<ffffffff8378b234>] ? retint_restore_args+0x13/0x13
[   78.061989]  [<ffffffff8109e036>] ? native_safe_halt+0x6/0x10
[   78.061989]  [<ffffffff8115d78d>] ? trace_hardirqs_on+0xd/0x10
[   78.061989]  [<ffffffff81074a65>] default_idle+0x235/0x5c0
[   78.061989]  [<ffffffff81076648>] cpu_idle+0x118/0x160
[   78.061989]  [<ffffffff836c100e>] start_secondary+0xd0/0xd7
[   78.061989] ---[ end trace 2b1961b84676e159 ]---

[HANG]

[  234.121718] BUG: soft lockup - CPU#0 stuck for 34s! [trinity-child41:6057]
[  234.121718] irq event stamp: 31065397
[  234.121718] hardirqs last  enabled at (31065396): [<ffffffff8378b234>] restore_args+0x0/0x30
[  234.121718] hardirqs last disabled at (31065397): [<ffffffff8378c82a>] apic_timer_interrupt+0x6a/0x80
[  234.121718] softirqs last  enabled at (344302): [<ffffffff8311a114>] release_sock+0x94/0xa0
[  234.121718] softirqs last disabled at (7204061): [<ffffffff8378d22c>] call_softirq+0x1c/0x30
[  234.121718] CPU 0
[  234.121718] Pid: 6057, comm: trinity-child41 Tainted: G        W    3.5.0-rc7-next-20120720-sasha-00001-g0bb3f48-dirty #227
[  234.121718] RIP: 0010:[<ffffffff810f3604>]  [<ffffffff810f3604>] __do_softirq+0x94/0x450
[  234.121718] RSP: 0018:ffff88000d803ec0  EFLAGS: 00000282
[  234.121718] RAX: 0000000000000086 RBX: ffffffff8378b234 RCX: 0000000000000000
[  234.121718] RDX: ffff88000bad0000 RSI: 0000000000000000 RDI: ffff88000bad0000
[  234.121718] RBP: ffff88000d803f30 R08: 0000000000000000 R09: 0000000000000000
[  234.121718] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88000d803e38
[  234.121718] R13: ffffffff8378c82f R14: ffff88000d803f30 R15: 0000000000000282
[  234.121718] FS:  00007f8ca2ccb700(0000) GS:ffff88000d800000(0000) knlGS:0000000000000000
[  234.121718] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  234.121718] CR2: 0000000000000000 CR3: 000000000bab3000 CR4: 00000000000406f0
[  234.121718] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  234.121718] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  234.121718] Process trinity-child41 (pid: 6057, threadinfo ffff88000baca000, task ffff88000bad0000)
[  234.121718] Stack:
[  234.121718]  ffff88000d9d7640 ffff88000bacbfd8 ffff88000bacbfd8 ffff88000000000a
[  234.121718]  ffff88000bacbfd8 000000000d803f18 ffff88000bacbfd8 0000000000005678
[  234.121718]  0000000000000000 0000000000000086 ffff88000bacbfd8 0000000000000001
[  234.121718] Call Trace:
[  234.121718]  <IRQ>
[  234.121718]  [<ffffffff8378d22c>] call_softirq+0x1c/0x30
[  234.121718]  [<ffffffff8106d41d>] do_softirq+0x7d/0x100
[  234.121718]  [<ffffffff810f3cec>] irq_exit+0x5c/0xd0
[  234.121718]  [<ffffffff8109203a>] smp_apic_timer_interrupt+0x8a/0xa0
[  234.121718]  [<ffffffff8378c82f>] apic_timer_interrupt+0x6f/0x80
[  234.121718]  <EOI>
[  234.121718]  [<ffffffff8378b234>] ? retint_restore_args+0x13/0x13
[  234.121718]  [<ffffffff8378a3ed>] ? _raw_spin_unlock_irqrestore+0x6d/0xa0
[  234.121718]  [<ffffffff8111e012>] hrtimer_try_to_cancel+0x182/0x1f0
[  234.121718]  [<ffffffff8111e098>] hrtimer_cancel+0x18/0x30
[  234.121718]  [<ffffffff83787e54>] do_nanosleep+0x84/0xd0
[  234.121718]  [<ffffffff8111ea47>] hrtimer_nanosleep+0xd7/0x180
[  234.121718]  [<ffffffff8111cce0>] ? update_rmtp+0x70/0x70
[  234.121718]  [<ffffffff81116a1e>] common_nsleep+0x1e/0x20
[  234.121718]  [<ffffffff8111805c>] sys_clock_nanosleep+0xcc/0x110
[  234.121718]  [<ffffffff8378bafd>] system_call_fastpath+0x1a/0x1f
[  234.121718] Code: 1f 84 00 00 00 00 00 65 c7 04 25 c0 46 1d 00 00 00 00 00 e8 8f a1 06 00 48 83 3d df 70 75 03 00 75 05 0f 0b 0f 1f 00 fb 66 66 90 <66> 66 90 48 c7 c3 00 60 80 84 66 90 41 f6 c4 01 0f 84 76 02 00
[  234.121718] Kernel panic - not syncing: softlockup: hung tasks
[  234.121718] Pid: 6057, comm: trinity-child41 Tainted: G        W    3.5.0-rc7-next-20120720-sasha-00001-g0bb3f48-dirty #227
[  234.121718] Call Trace:
[  234.121718]  <IRQ>  [<ffffffff836cf8e2>] panic+0xcd/0x1f4
[  234.121718]  [<ffffffff810f3618>] ? __do_softirq+0xa8/0x450
[  234.121718]  [<ffffffff81195b5e>] watchdog_timer_fn+0x15e/0x190
[  234.121718]  [<ffffffff8111d51e>] __run_hrtimer+0x27e/0x4d0
[  234.121718]  [<ffffffff8109dda9>] ? kvm_clock_get_cycles+0x9/0x10
[  234.121718]  [<ffffffff81195a00>] ? __touch_watchdog+0x20/0x20
[  234.121718]  [<ffffffff811508cc>] ? ktime_get_update_offsets+0x4c/0xd0
[  234.121718]  [<ffffffff8111e559>] hrtimer_interrupt+0x119/0x220
[  234.121718]  [<ffffffff81092035>] smp_apic_timer_interrupt+0x85/0xa0
[  234.121718]  [<ffffffff8378c82f>] apic_timer_interrupt+0x6f/0x80
[  234.121718]  [<ffffffff8378b234>] ? retint_restore_args+0x13/0x13
[  234.121718]  [<ffffffff810f3604>] ? __do_softirq+0x94/0x450
[  234.121718]  [<ffffffff8378d22c>] call_softirq+0x1c/0x30
[  234.121718]  [<ffffffff8106d41d>] do_softirq+0x7d/0x100
[  234.121718]  [<ffffffff810f3cec>] irq_exit+0x5c/0xd0
[  234.121718]  [<ffffffff8109203a>] smp_apic_timer_interrupt+0x8a/0xa0
[  234.121718]  [<ffffffff8378c82f>] apic_timer_interrupt+0x6f/0x80
[  234.121718]  <EOI>  [<ffffffff8378b234>] ? retint_restore_args+0x13/0x13
[  234.121718]  [<ffffffff8378a3ed>] ? _raw_spin_unlock_irqrestore+0x6d/0xa0
[  234.121718]  [<ffffffff8111e012>] hrtimer_try_to_cancel+0x182/0x1f0
[  234.121718]  [<ffffffff8111e098>] hrtimer_cancel+0x18/0x30
[  234.121718]  [<ffffffff83787e54>] do_nanosleep+0x84/0xd0
[  234.121718]  [<ffffffff8111ea47>] hrtimer_nanosleep+0xd7/0x180
[  234.121718]  [<ffffffff8111cce0>] ? update_rmtp+0x70/0x70
[  234.121718]  [<ffffffff81116a1e>] common_nsleep+0x1e/0x20
[  234.121718]  [<ffffffff8111805c>] sys_clock_nanosleep+0xcc/0x110
[  234.121718]  [<ffffffff8378bafd>] system_call_fastpath+0x1a/0x1f
