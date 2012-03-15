Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761930Ab2CONX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:23:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761852Ab2CONXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:23:25 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 15 Mar 2012 15:23:04 +0200
Message-ID: <CA+1xoqcGcfYzjrvRU-z=mUSq+wgqfBqdM51shV5gk4ohfe5Wng@mail.gmail.com>
Subject: ntp: BUG: spinlock lockup on CPU#1
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was doing some more fuzzing with trinity in a KVM tools guest, using
today's linux-next, when I've experienced a complete system lockup
(just in the guest ofcourse). After a bit I got the spew at the bottom
of this mail.

>From what I can tell from the logs, there were several threads waiting
on syscall results, and I suspect that the adjtimex() call on CPU3 is
somehow responsible for this lockup.

[   69.785020] BUG: spinlock lockup on CPU#1, trinity/3484
[   69.785020]  lock: ffffffff83240fc0, .magic: dead4ead, .owner:
trinity/7281, .owner_cpu: 3
[   69.785020] Pid: 3484, comm: trinity Tainted: G        W
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[   69.785020] Call Trace:
[   69.785020]  <IRQ>  [<ffffffff81899118>] spin_dump+0x78/0xc0
[   69.785020]  [<ffffffff818993b0>] do_raw_spin_lock+0x130/0x140
[   69.785020]  [<ffffffff81110500>] ? tick_nohz_handler+0x100/0x100
[   69.785020]  [<ffffffff82709a12>] _raw_spin_lock_irqsave+0x92/0xc0
[   69.785020]  [<ffffffff81109925>] ? ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8107bfe6>] ? kvm_clock_read+0x46/0x80
[   69.785020]  [<ffffffff81109925>] ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8110834c>] update_wall_time+0xbc/0x210
[   69.785020]  [<ffffffff811093c8>] do_timer+0x18/0x30
[   69.785020]  [<ffffffff811103a5>] tick_do_update_jiffies64+0x75/0xd0
[   69.785020]  [<ffffffff811105b0>] tick_sched_timer+0xb0/0xc0
[   69.785020]  [<ffffffff810daa71>] __run_hrtimer.clone.23+0x81/0x130
[   69.785020]  [<ffffffff810db537>] hrtimer_interrupt+0xe7/0x220
[   69.785020]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785020]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785020]  <EOI>  [<ffffffff810e7b51>] ? get_parent_ip+0x11/0x50
[   69.785020]  [<ffffffff81205c84>] ? mntput+0x14/0x30
[   69.785020]  [<ffffffff811f0d2d>] path_put+0x1d/0x30
[   69.785020]  [<ffffffff811f222c>] path_lookupat+0xcc/0x820
[   69.785020]  [<ffffffff81886034>] ? __strncpy_from_user+0x34/0x60
[   69.785020]  [<ffffffff811f29ac>] do_path_lookup+0x2c/0xc0
[   69.785020]  [<ffffffff811f2ed4>] user_path_at_empty+0x54/0xa0
[   69.785020]  [<ffffffff81885e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   69.785020]  [<ffffffff811f2f2c>] user_path_at+0xc/0x10
[   69.785020]  [<ffffffff811e91ef>] vfs_fstatat+0x3f/0x80
[   69.785020]  [<ffffffff811e9269>] vfs_lstat+0x19/0x20
[   69.785020]  [<ffffffff811e938f>] sys_newlstat+0x1f/0x40
[   69.785020]  [<ffffffff811e9371>] ? sys_newlstat+0x1/0x40
[   69.785020]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785020] sending NMI to all CPUs:
[   69.785020] NMI backtrace for cpu 1
[   69.785020] CPU 1
[   69.785020] Pid: 3484, comm: trinity Tainted: G        W
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[   69.785020] RIP: 0010:[<ffffffff81075f90>]  [<ffffffff81075f90>]
flat_send_IPI_all+0xd0/0x120
[   69.785020] RSP: 0018:ffff88003e003d58  EFLAGS: 00010006
[   69.785020] RAX: 0000000000000000 RBX: 0000000000000082 RCX: 0000000000000000
[   69.785020] RDX: ffff88002dc08000 RSI: 0000000000000000 RDI: 0000000000000300
[   69.785020] RBP: ffff88003e003d78 R08: 0000000000000001 R09: 0000000000000000
[   69.785020] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000c00
[   69.785020] R13: 000000000f000000 R14: 0000000000000000 R15: 000000103f82be23
[   69.785020] FS:  00007f99826c6700(0000) GS:ffff88003e000000(0000)
knlGS:0000000000000000
[   69.785020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.785020] CR2: 0000000000400c1d CR3: 000000002c5fe000 CR4: 00000000000406e0
[   69.785020] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.785020] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.785020] Process trinity (pid: 3484, threadinfo
ffff88002def4000, task ffff88002dc08000)
[   69.785020] Stack:
[   69.785020]  0000000000000000 0000000000002710 0000000094866e30
0000000094866e30
[   69.785020]  ffff88003e003d98 ffffffff81072aea ffffffff83240fc0
ffffffff83240fc0
[   69.785020]  ffff88003e003dd8 ffffffff818993b5 ffff88003e003dd8
ffffffff83240fc0
[   69.785020] Call Trace:
[   69.785020]  <IRQ>
[   69.785020]  [<ffffffff81072aea>] arch_trigger_all_cpu_backtrace+0x6a/0xb0
[   69.785020]  [<ffffffff818993b5>] do_raw_spin_lock+0x135/0x140
[   69.785020]  [<ffffffff81110500>] ? tick_nohz_handler+0x100/0x100
[   69.785020]  [<ffffffff82709a12>] _raw_spin_lock_irqsave+0x92/0xc0
[   69.785020]  [<ffffffff81109925>] ? ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8107bfe6>] ? kvm_clock_read+0x46/0x80
[   69.785020]  [<ffffffff81109925>] ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8110834c>] update_wall_time+0xbc/0x210
[   69.785020]  [<ffffffff811093c8>] do_timer+0x18/0x30
[   69.785020]  [<ffffffff811103a5>] tick_do_update_jiffies64+0x75/0xd0
[   69.785020]  [<ffffffff811105b0>] tick_sched_timer+0xb0/0xc0
[   69.785020]  [<ffffffff810daa71>] __run_hrtimer.clone.23+0x81/0x130
[   69.785020]  [<ffffffff810db537>] hrtimer_interrupt+0xe7/0x220
[   69.785020]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785020]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785020]  <EOI>
[   69.785020]  [<ffffffff810e7b51>] ? get_parent_ip+0x11/0x50
[   69.785020]  [<ffffffff81205c84>] ? mntput+0x14/0x30
[   69.785020]  [<ffffffff811f0d2d>] path_put+0x1d/0x30
[   69.785020]  [<ffffffff811f222c>] path_lookupat+0xcc/0x820
[   69.785020]  [<ffffffff81886034>] ? __strncpy_from_user+0x34/0x60
[   69.785020]  [<ffffffff811f29ac>] do_path_lookup+0x2c/0xc0
[   69.785020]  [<ffffffff811f2ed4>] user_path_at_empty+0x54/0xa0
[   69.785020]  [<ffffffff81885e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   69.785020]  [<ffffffff811f2f2c>] user_path_at+0xc/0x10
[   69.785020]  [<ffffffff811e91ef>] vfs_fstatat+0x3f/0x80
[   69.785020]  [<ffffffff811e9269>] vfs_lstat+0x19/0x20
[   69.785020]  [<ffffffff811e938f>] sys_newlstat+0x1f/0x40
[   69.785020]  [<ffffffff811e9371>] ? sys_newlstat+0x1/0x40
[   69.785020]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785020] Code: c1 e5 18 48 8b 05 a9 16 6c 02 44 8b 60 3c ff 90
50 01 00 00 44 89 2c 25 10 a3 5f ff 41 81 cc 00 04 00 00 44 89 24 25
00 a3 5f ff <f6> c7 02 74 24 e8 56 0c 0a 00 48 83 3d a6 f1 1b 02 00 74
33 48
[   69.785020] Call Trace:
[   69.785020]  <IRQ>  [<ffffffff81072aea>]
arch_trigger_all_cpu_backtrace+0x6a/0xb0
[   69.785020]  [<ffffffff818993b5>] do_raw_spin_lock+0x135/0x140
[   69.785020]  [<ffffffff81110500>] ? tick_nohz_handler+0x100/0x100
[   69.785020]  [<ffffffff82709a12>] _raw_spin_lock_irqsave+0x92/0xc0
[   69.785020]  [<ffffffff81109925>] ? ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8107bfe6>] ? kvm_clock_read+0x46/0x80
[   69.785020]  [<ffffffff81109925>] ntp_tick_length+0x15/0x40
[   69.785020]  [<ffffffff8110834c>] update_wall_time+0xbc/0x210
[   69.785020]  [<ffffffff811093c8>] do_timer+0x18/0x30
[   69.785020]  [<ffffffff811103a5>] tick_do_update_jiffies64+0x75/0xd0
[   69.785020]  [<ffffffff811105b0>] tick_sched_timer+0xb0/0xc0
[   69.785020]  [<ffffffff810daa71>] __run_hrtimer.clone.23+0x81/0x130
[   69.785020]  [<ffffffff810db537>] hrtimer_interrupt+0xe7/0x220
[   69.785020]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785020]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785020]  <EOI>  [<ffffffff810e7b51>] ? get_parent_ip+0x11/0x50
[   69.785020]  [<ffffffff81205c84>] ? mntput+0x14/0x30
[   69.785020]  [<ffffffff811f0d2d>] path_put+0x1d/0x30
[   69.785020]  [<ffffffff811f222c>] path_lookupat+0xcc/0x820
[   69.785020]  [<ffffffff81886034>] ? __strncpy_from_user+0x34/0x60
[   69.785020]  [<ffffffff811f29ac>] do_path_lookup+0x2c/0xc0
[   69.785020]  [<ffffffff811f2ed4>] user_path_at_empty+0x54/0xa0
[   69.785020]  [<ffffffff81885e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   69.785020]  [<ffffffff811f2f2c>] user_path_at+0xc/0x10
[   69.785020]  [<ffffffff811e91ef>] vfs_fstatat+0x3f/0x80
[   69.785020]  [<ffffffff811e9269>] vfs_lstat+0x19/0x20
[   69.785020]  [<ffffffff811e938f>] sys_newlstat+0x1f/0x40
[   69.785020]  [<ffffffff811e9371>] ? sys_newlstat+0x1/0x40
[   69.785020]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785019] NMI backtrace for cpu 2
[   69.785019] CPU 2
[   69.785019] Pid: 3148, comm: trinity Tainted: G        W
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[   69.785019] RIP: 0010:[<ffffffff81108679>]  [<ffffffff81108679>]
ktime_get+0x29/0xf0
[   69.785019] RSP: 0018:ffff88003e203e98  EFLAGS: 00000002
[   69.785019] RAX: 0000000000000000 RBX: ffff88003e20fba0 RCX: 0000000000000000
[   69.785019] RDX: 000000000000863f RSI: ffff88002f7938d8 RDI: ffff88003e20fba0
[   69.785019] RBP: ffff88003e203eb8 R08: 0000000000000000 R09: 0000000000000000
[   69.785019] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003e20f9c0
[   69.785019] R13: 000000000001c491 R14: ffffffff81110500 R15: 000000103f82cdba
[   69.785019] FS:  00007f43bb943700(0000) GS:ffff88003e200000(0000)
knlGS:0000000000000000
[   69.785019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.785019] CR2: 00007f6745dd4324 CR3: 000000002dc67000 CR4: 00000000000406e0
[   69.785019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.785019] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.785019] Process trinity (pid: 3148, threadinfo
ffff88002dd32000, task ffff88002f793000)
[   69.785019] Stack:
[   69.785019]  ffff88003e20fba0 ffff88003e20f9c0 ffff88002dd33d38
ffffffff81110500
[   69.785019]  ffff88003e203ee8 ffffffff81110525 ffff88003e203ee8
ffff88003e20fba0
[   69.785019]  ffff88003e20f9c0 ffff88003e20f940 ffff88003e203f18
ffffffff810daa71
[   69.785019] Call Trace:
[   69.785019]  <IRQ>
[   69.785019]  [<ffffffff81110500>] ? tick_nohz_handler+0x100/0x100
[   69.785019]  [<ffffffff81110525>] tick_sched_timer+0x25/0xc0
[   69.785019]  [<ffffffff810daa71>] __run_hrtimer.clone.23+0x81/0x130
[   69.785019]  [<ffffffff810db537>] hrtimer_interrupt+0xe7/0x220
[   69.785019]  [<ffffffff81252b15>] ? proc_readfd_common+0x255/0x660
[   69.785019]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785019]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785019]  <EOI>
[   69.785019]  [<ffffffff81119528>] ? lock_release+0x98/0xc0
[   69.785019]  [<ffffffff81252b2d>] proc_readfd_common+0x26d/0x660
[   69.785019]  [<ffffffff81252b7a>] ? proc_readfd_common+0x2ba/0x660
[   69.785019]  [<ffffffff81251cf0>] ? proc_tgid_base_lookup+0x20/0x20
[   69.785019]  [<ffffffff811f8920>] ? filldir64+0xf0/0xf0
[   69.785019]  [<ffffffff811f8920>] ? filldir64+0xf0/0xf0
[   69.785019]  [<ffffffff81252f30>] proc_readfdinfo+0x10/0x20
[   69.785019]  [<ffffffff811f8b80>] vfs_readdir+0xb0/0xd0
[   69.785019]  [<ffffffff811e4eed>] ? fget+0xbd/0x320
[   69.785019]  [<ffffffff811e4e30>] ? alloc_file+0x120/0x120
[   69.785019]  [<ffffffff811f8c84>] sys_getdents+0x84/0xf0
[   69.785019]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785019] Code: 00 00 55 48 89 e5 48 83 ec 20 8b 0d a2 1a 63 02
48 89 1c 24 4c 89 64 24 08 4c 89 6c 24 10 4c 89 74 24 18 85 c9 0f 85
8f 00 00 00 <44> 8b 2d 48 23 a7 02 41 f6 c5 01 0f 85 a0 00 00 00 4c 8b
35 af
[   69.785019] Call Trace:
[   69.785019]  <IRQ>  [<ffffffff81110500>] ? tick_nohz_handler+0x100/0x100
[   69.785019]  [<ffffffff81110525>] tick_sched_timer+0x25/0xc0
[   69.785019]  [<ffffffff810daa71>] __run_hrtimer.clone.23+0x81/0x130
[   69.785019]  [<ffffffff810db537>] hrtimer_interrupt+0xe7/0x220
[   69.785019]  [<ffffffff81252b15>] ? proc_readfd_common+0x255/0x660
[   69.785019]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785019]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785019]  <EOI>  [<ffffffff81119528>] ? lock_release+0x98/0xc0
[   69.785019]  [<ffffffff81252b2d>] proc_readfd_common+0x26d/0x660
[   69.785019]  [<ffffffff81252b7a>] ? proc_readfd_common+0x2ba/0x660
[   69.785019]  [<ffffffff81251cf0>] ? proc_tgid_base_lookup+0x20/0x20
[   69.785019]  [<ffffffff811f8920>] ? filldir64+0xf0/0xf0
[   69.785019]  [<ffffffff811f8920>] ? filldir64+0xf0/0xf0
[   69.785019]  [<ffffffff81252f30>] proc_readfdinfo+0x10/0x20
[   69.785019]  [<ffffffff811f8b80>] vfs_readdir+0xb0/0xd0
[   69.785019]  [<ffffffff811e4eed>] ? fget+0xbd/0x320
[   69.785019]  [<ffffffff811e4e30>] ? alloc_file+0x120/0x120
[   69.785019]  [<ffffffff811f8c84>] sys_getdents+0x84/0xf0
[   69.785019]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785024] NMI backtrace for cpu 0
[   69.785024] CPU 0
[   69.785024] Pid: 3093, comm: trinity Tainted: G        W
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[   69.785024] RIP: 0010:[<ffffffff81108680>]  [<ffffffff81108680>]
ktime_get+0x30/0xf0
[   69.785024] RSP: 0018:ffff88003de03ef8  EFLAGS: 00000002
[   69.785024] RAX: 0000000000000000 RBX: ffff88003de0f940 RCX: 0000000000000000
[   69.785024] RDX: 7fffffffffffffff RSI: 0000000000000000 RDI: ffff88003de0ef80
[   69.785024] RBP: ffff88003de03f18 R08: 0000000000000001 R09: 0000000000000003
[   69.785024] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003de0ef80
[   69.785024] R13: 000000000001c491 R14: 7fffffffffffffff R15: ffff88003d407a30
[   69.785024] FS:  00007f28410ae700(0000) GS:ffff88003de00000(0000)
knlGS:0000000000000000
[   69.785024] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.785024] CR2: 000000000093df38 CR3: 0000000035fac000 CR4: 00000000000406f0
[   69.785024] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.785024] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.785024] Process trinity (pid: 3093, threadinfo
ffff88002f6c2000, task ffff88002f493000)
[   69.785024] Stack:
[   69.785024]  ffff88003de0f940 ffff88003de0ef80 0000000000000000
7fffffffffffffff
[   69.785024]  ffff88003de03f88 ffffffff810db4aa ffff88003de03f38
0000000000000082
[   69.785024]  ffff88003de03f48 ffffffff81116d3d ffff88003de03f68
ffffffff810e584f
[   69.785024] Call Trace:
[   69.785024]  <IRQ>
[   69.785024]  [<ffffffff810db4aa>] hrtimer_interrupt+0x5a/0x220
[   69.785024]  [<ffffffff81116d3d>] ? trace_hardirqs_off+0xd/0x10
[   69.785024]  [<ffffffff810e584f>] ? account_system_vtime+0x10f/0x120
[   69.785024]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785024]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785024]  <EOI>
[   69.785024]  [<ffffffff81884aad>] ? delay_tsc+0xd/0x120
[   69.785024]  [<ffffffff81884bea>] __delay+0xa/0x10
[   69.785024]  [<ffffffff81899372>] do_raw_spin_lock+0xf2/0x140
[   69.785024]  [<ffffffff8270996b>] _raw_spin_lock+0x5b/0x70
[   69.785024]  [<ffffffff811f0471>] ? path_get+0x31/0x50
[   69.785024]  [<ffffffff81899486>] ? do_raw_spin_unlock+0x76/0xd0
[   69.785024]  [<ffffffff811f0471>] path_get+0x31/0x50
[   69.785024]  [<ffffffff811f063a>] unlazy_walk+0x1aa/0x2b0
[   69.785024]  [<ffffffff811f11fb>] do_lookup+0x1fb/0x3b0
[   69.785024]  [<ffffffff811f19b8>] link_path_walk+0x138/0x8e0
[   69.785024]  [<ffffffff811f21b0>] path_lookupat+0x50/0x820
[   69.785024]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   69.785024]  [<ffffffff81886022>] ? __strncpy_from_user+0x22/0x60
[   69.785024]  [<ffffffff811f29ac>] do_path_lookup+0x2c/0xc0
[   69.785024]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   69.785024]  [<ffffffff811f2ed4>] user_path_at_empty+0x54/0xa0
[   69.785024]  [<ffffffff8119ee07>] ? might_fault+0x97/0xa0
[   69.785024]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   69.785024]  [<ffffffff810dff71>] ? lg_local_unlock+0x51/0x80
[   69.785024]  [<ffffffff811e8e43>] ? cp_new_stat+0xf3/0x110
[   69.785024]  [<ffffffff811f2f2c>] user_path_at+0xc/0x10
[   69.785024]  [<ffffffff811e91ef>] vfs_fstatat+0x3f/0x80
[   69.785024]  [<ffffffff811e9269>] vfs_lstat+0x19/0x20
[   69.785024]  [<ffffffff811e938f>] sys_newlstat+0x1f/0x40
[   69.785024]  [<ffffffff81885e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   69.785024]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785024] Code: 83 ec 20 8b 0d a2 1a 63 02 48 89 1c 24 4c 89 64
24 08 4c 89 6c 24 10 4c 89 74 24 18 85 c9 0f 85 8f 00 00 00 44 8b 2d
48 23 a7 02 <41> f6 c5 01 0f 85 a0 00 00 00 4c 8b 35 af 22 a7 02 48 8b
1d 00
[   69.785024] Call Trace:
[   69.785024]  <IRQ>  [<ffffffff810db4aa>] hrtimer_interrupt+0x5a/0x220
[   69.785024]  [<ffffffff81116d3d>] ? trace_hardirqs_off+0xd/0x10
[   69.785024]  [<ffffffff810e584f>] ? account_system_vtime+0x10f/0x120
[   69.785024]  [<ffffffff810719e3>] smp_apic_timer_interrupt+0x63/0xa0
[   69.785024]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[   69.785024]  <EOI>  [<ffffffff81884aad>] ? delay_tsc+0xd/0x120
[   69.785024]  [<ffffffff81884bea>] __delay+0xa/0x10
[   69.785024]  [<ffffffff81899372>] do_raw_spin_lock+0xf2/0x140
[   69.785024]  [<ffffffff8270996b>] _raw_spin_lock+0x5b/0x70
[   69.785024]  [<ffffffff811f0471>] ? path_get+0x31/0x50
[   69.785024]  [<ffffffff81899486>] ? do_raw_spin_unlock+0x76/0xd0
[   69.785024]  [<ffffffff811f0471>] path_get+0x31/0x50
[   69.785024]  [<ffffffff811f063a>] unlazy_walk+0x1aa/0x2b0
[   69.785024]  [<ffffffff811f11fb>] do_lookup+0x1fb/0x3b0
[   69.785024]  [<ffffffff811f19b8>] link_path_walk+0x138/0x8e0
[   69.785024]  [<ffffffff811f21b0>] path_lookupat+0x50/0x820
[   69.785024]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   69.785024]  [<ffffffff81886022>] ? __strncpy_from_user+0x22/0x60
[   69.785024]  [<ffffffff811f29ac>] do_path_lookup+0x2c/0xc0
[   69.785024]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   69.785024]  [<ffffffff811f2ed4>] user_path_at_empty+0x54/0xa0
[   69.785024]  [<ffffffff8119ee07>] ? might_fault+0x97/0xa0
[   69.785024]  [<ffffffff8119edbe>] ? might_fault+0x4e/0xa0
[   69.785024]  [<ffffffff810dff71>] ? lg_local_unlock+0x51/0x80
[   69.785024]  [<ffffffff811e8e43>] ? cp_new_stat+0xf3/0x110
[   69.785024]  [<ffffffff811f2f2c>] user_path_at+0xc/0x10
[   69.785024]  [<ffffffff811e91ef>] vfs_fstatat+0x3f/0x80
[   69.785024]  [<ffffffff811e9269>] vfs_lstat+0x19/0x20
[   69.785024]  [<ffffffff811e938f>] sys_newlstat+0x1f/0x40
[   69.785024]  [<ffffffff81885e0e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   69.785024]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785019] NMI backtrace for cpu 3
[   69.785019] CPU 3
[   69.785019] Pid: 7281, comm: trinity Tainted: G        W
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[   69.785019] RIP: 0010:[<ffffffff8110872c>]  [<ffffffff8110872c>]
ktime_get+0xdc/0xf0
[   69.785019] RSP: 0018:ffff8800342d7cb8  EFLAGS: 00000002
[   69.785019] RAX: 0000000000000000 RBX: ffff88003e40ef80 RCX: 0000000000000000
[   69.785019] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88003e40ef80
[   69.785019] RBP: ffff8800342d7cd8 R08: 0000000000000001 R09: 0000000000000000
[   69.785019] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   69.785019] R13: 000000000001c491 R14: 7fffffffffffffff R15: 7fffffffffffffff
[   69.785019] FS:  00007f6746377700(0000) GS:ffff88003e400000(0000)
knlGS:0000000000000000
[   69.785019] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   69.785019] CR2: 0000000000d4f0cc CR3: 0000000025d55000 CR4: 00000000000406e0
[   69.785019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   69.785019] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   69.785019] Process trinity (pid: 7281, threadinfo
ffff8800342d6000, task ffff88001f443000)
[   69.785019] Stack:
[   69.785019]  ffff88003e40ef80 0000000000000000 0000000000000000
7fffffffffffffff
[   69.785019]  ffff8800342d7d18 ffffffff8110e41d ffff8800342d7d58
ffffffff8189babb
[   69.785019]  0000000000000000 0000000000000000 ffff88003e40f940
ffffffff83b7aa98
[   69.785019] Call Trace:
[   69.785019]  [<ffffffff8110e41d>] clockevents_program_event+0x3d/0x100
[   69.785019]  [<ffffffff8189babb>] ? debug_object_activate+0x11b/0x190
[   69.785019]  [<ffffffff8111009f>] tick_program_event+0x1f/0x30
[   69.785019]  [<ffffffff810da8d5>] hrtimer_reprogram.clone.21+0x95/0xe0
[   69.785019]  [<ffffffff810dafe4>] __hrtimer_start_range_ns+0x2c4/0x3b0
[   69.785019]  [<ffffffff810db103>] hrtimer_start+0x13/0x20
[   69.785019]  [<ffffffff8110a001>] do_adjtimex+0x541/0x6d0
[   69.785019]  [<ffffffff8119ee07>] ? might_fault+0x97/0xa0
[   69.785019]  [<ffffffff810b895e>] sys_adjtimex+0x4e/0x90
[   69.785019]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[   69.785019] Code: 4c 8b 74 24 18 c9 c3 be 07 01 00 00 48 c7 c7 31
01 e0 82 e8 f7 95 fa ff e9 5b ff ff ff 48 b8 ff ff ff ff ff ff ff 7f
eb c6 f3 90 <e9> 48 ff ff ff 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
00 55
[   69.785019] Call Trace:
[   69.785019]  [<ffffffff8110e41d>] clockevents_program_event+0x3d/0x100
[   69.785019]  [<ffffffff8189babb>] ? debug_object_activate+0x11b/0x190
[   69.785019]  [<ffffffff8111009f>] tick_program_event+0x1f/0x30
[   69.785019]  [<ffffffff810da8d5>] hrtimer_reprogram.clone.21+0x95/0xe0
[   69.785019]  [<ffffffff810dafe4>] __hrtimer_start_range_ns+0x2c4/0x3b0
[   69.785019]  [<ffffffff810db103>] hrtimer_start+0x13/0x20
[   69.785019]  [<ffffffff8110a001>] do_adjtimex+0x541/0x6d0
[   69.785019]  [<ffffffff8119ee07>] ? might_fault+0x97/0xa0
[   69.785019]  [<ffffffff810b895e>] sys_adjtimex+0x4e/0x90
[   69.785019]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
