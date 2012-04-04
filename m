Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab2DDUNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:13:02 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51741 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DDUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:12:57 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 4 Apr 2012 22:12:36 +0200
Message-ID: <CA+1xoqeqyFT0eHS2k+vskPFQ-5gJ_Uq1HVsq2DA2sS1uN9C0vw@mail.gmail.com>
Subject: CPU softlockup due to smp_call_function()
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>
Cc: Dave Jones <davej@redhat.com>, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've starting seeing soft lockups resulting from smp_call_function()
calls. I've attached two different backtraces of this happening with
different code paths.

This is running inside a KVM guest with the trinity fuzzer, using
today's linux-next kernel.

[ 6540.134009] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u:1:38]
[ 6540.134048] irq event stamp: 286811770
[ 6540.134048] hardirqs last  enabled at (286811769):
[<ffffffff82669e74>] restore_args+0x0/0x30
[ 6540.134048] hardirqs last disabled at (286811770):
[<ffffffff8266b3ea>] apic_timer_interrupt+0x6a/0x80
[ 6540.134048] softirqs last  enabled at (286811768):
[<ffffffff810b746e>] __do_softirq+0x16e/0x190
[ 6540.134048] softirqs last disabled at (286811749):
[<ffffffff8266bdec>] call_softirq+0x1c/0x30
[ 6540.134048] CPU 0
[ 6540.134048] Pid: 38, comm: kworker/u:1 Tainted: G        W
3.4.0-rc1-next-20120404-sasha-dirty #72
[ 6540.134048] RIP: 0010:[<ffffffff8111f30e>]  [<ffffffff8111f30e>]
smp_call_function_many+0x27e/0x2a0
[ 6540.134048] RSP: 0018:ffff88007ba5bbb0  EFLAGS: 00000202
[ 6540.134048] RAX: 0000000000000000 RBX: ffffffff82669e74 RCX: 0000000000000006
[ 6540.134048] RDX: 0000000000000006 RSI: 0000000000000000 RDI: 0000000000000001
[ 6540.134048] RBP: ffff88007ba5bbf0 R08: 0000000000000000 R09: 0000000000000000
[ 6540.134048] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88007ba5bb28
[ 6540.134048] R13: ffff88007ba4b000 R14: ffff88007ba5a000 R15: ffff88007ba5bfd8
[ 6540.134048] FS:  0000000000000000(0000) GS:ffff88007cc00000(0000)
knlGS:0000000000000000
[ 6540.134048] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6540.134048] CR2: 00007f98daedff31 CR3: 000000000321d000 CR4: 00000000000406f0
[ 6540.134048] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6540.134048] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6540.134048] Process kworker/u:1 (pid: 38, threadinfo
ffff88007ba5a000, task ffff88007ba4b000)
[ 6540.134048] Stack:
[ 6540.134048]  01ff88007ba5bbd0 ffff880062f367c0
[ 6540.134048]  ffffffff8355c020
[ 6540.134048]  ffffffff821c0010
[ 6540.134048]  ffff880062f367c0 0000000000000001 ffff88007ba5bc60
ffff88007ba5bda0
[ 6540.134048]  ffff88007ba5bc20 ffffffff8111f371 ffff88007ba5bc20
ffffffff821c0010
[ 6540.134048] Call Trace:
[ 6540.134048]  [<ffffffff821c0010>] ? rps_trigger_softirq+0x40/0x40
[ 6540.134048]  [<ffffffff8111f371>] smp_call_function+0x41/0x80
[ 6540.134048]  [<ffffffff821c0010>] ? rps_trigger_softirq+0x40/0x40
[ 6540.134048]  [<ffffffff8111f47c>] on_each_cpu+0x3c/0x110
[ 6540.134048]  [<ffffffff821c97b3>] netdev_run_todo+0xc3/0x230
[ 6540.134048]  [<ffffffff821d7cd9>] rtnl_unlock+0x9/0x10
[ 6540.134048]  [<ffffffff823a4432>] ip6_tnl_exit_net+0x182/0x190
[ 6540.134048]  [<ffffffff823a42b0>] ? ip6_tnl_dev_uninit+0x1e0/0x1e0
[ 6540.134048]  [<ffffffff81251256>] ? proc_net_remove+0x16/0x20
[ 6540.134048]  [<ffffffff821be295>] ops_exit_list.clone.0+0x35/0x70
[ 6540.134048]  [<ffffffff821bec40>] cleanup_net+0x100/0x1a0
[ 6540.134048]  [<ffffffff810cb1d1>] process_one_work+0x281/0x430
[ 6540.134048]  [<ffffffff810cb170>] ? process_one_work+0x220/0x430
[ 6540.134048]  [<ffffffff821beb40>] ? net_drop_ns+0x40/0x40
[ 6540.134048]  [<ffffffff810cc643>] worker_thread+0x1f3/0x320
[ 6540.134048]  [<ffffffff810cc450>] ? manage_workers.clone.13+0x130/0x130
[ 6540.134048]  [<ffffffff810d30e2>] kthread+0xb2/0xc0
[ 6540.134048]  [<ffffffff8266bcf4>] kernel_thread_helper+0x4/0x10
[ 6540.134048]  [<ffffffff810deb38>] ? finish_task_switch+0x78/0xf0
[ 6540.134048]  [<ffffffff82669e74>] ? retint_restore_args+0x13/0x13
[ 6540.134048]  [<ffffffff810d3030>] ? kthread_flush_work_fn+0x10/0x10
[ 6540.134048]  [<ffffffff8266bcf0>] ? gs_change+0x13/0x13
[ 6540.134048] Code: 28 48 89 c6 e8 f4 9c 54 01 0f ae f0 48 8b 7b 30
ff 15 0f 54 11 02 80 7d c7 00 75 0b eb 0f 0f 1f 80 00 00 00 00 f3 90
f6 43 20 01 <75> f8 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c
8b 7d
[ 6540.134048] Call Trace:
[ 6540.134048]  [<ffffffff821c0010>] ? rps_trigger_softirq+0x40/0x40
[ 6540.134048]  [<ffffffff8111f371>] smp_call_function+0x41/0x80
[ 6540.134048]  [<ffffffff821c0010>] ? rps_trigger_softirq+0x40/0x40
[ 6540.134048]  [<ffffffff8111f47c>] on_each_cpu+0x3c/0x110
[ 6540.134048]  [<ffffffff821c97b3>] netdev_run_todo+0xc3/0x230
[ 6540.134048]  [<ffffffff821d7cd9>] rtnl_unlock+0x9/0x10
[ 6540.134048]  [<ffffffff823a4432>] ip6_tnl_exit_net+0x182/0x190
[ 6540.134048]  [<ffffffff823a42b0>] ? ip6_tnl_dev_uninit+0x1e0/0x1e0
[ 6540.134048]  [<ffffffff81251256>] ? proc_net_remove+0x16/0x20
[ 6540.134048]  [<ffffffff821be295>] ops_exit_list.clone.0+0x35/0x70
[ 6540.134048]  [<ffffffff821bec40>] cleanup_net+0x100/0x1a0
[ 6540.134048]  [<ffffffff810cb1d1>] process_one_work+0x281/0x430
[ 6540.134048]  [<ffffffff810cb170>] ? process_one_work+0x220/0x430
[ 6540.134048]  [<ffffffff821beb40>] ? net_drop_ns+0x40/0x40
[ 6540.134048]  [<ffffffff810cc643>] worker_thread+0x1f3/0x320
[ 6540.134048]  [<ffffffff810cc450>] ? manage_workers.clone.13+0x130/0x130
[ 6540.134048]  [<ffffffff810d30e2>] kthread+0xb2/0xc0
[ 6540.134048]  [<ffffffff8266bcf4>] kernel_thread_helper+0x4/0x10
[ 6540.134048]  [<ffffffff810deb38>] ? finish_task_switch+0x78/0xf0
[ 6540.134048]  [<ffffffff82669e74>] ? retint_restore_args+0x13/0x13
[ 6540.134048]  [<ffffffff810d3030>] ? kthread_flush_work_fn+0x10/0x10
[ 6540.134048]  [<ffffffff8266bcf0>] ? gs_change+0x13/0x13
[ 6540.134048] Kernel panic - not syncing: softlockup: hung tasks
[ 6540.134048] Rebooting in 1 seconds..

[ 1060.167000] BUG: soft lockup - CPU#1 stuck for 22s! [pageattr-test:1155]
[ 1060.167015] irq event stamp: 2579196
[ 1060.167015] hardirqs last  enabled at (2579195):
[<ffffffff82669e74>] restore_args+0x0/0x30
[ 1060.167015] hardirqs last disabled at (2579196):
[<ffffffff8266b3ea>] apic_timer_interrupt+0x6a/0x80
[ 1060.167015] softirqs last  enabled at (2579194):
[<ffffffff810b746e>] __do_softirq+0x16e/0x190
[ 1060.167015] softirqs last disabled at (2579185):
[<ffffffff8266bdec>] call_softirq+0x1c/0x30
[ 1060.167015] CPU 1
[ 1060.167015] Pid: 1155, comm: pageattr-test Tainted: G        W
3.4.0-rc1-next-20120404-sasha-dirty #72
[ 1060.167015] RIP: 0010:[<ffffffff8111f30e>]  [<ffffffff8111f30e>]
smp_call_function_many+0x27e/0x2a0
[ 1060.167015] RSP: 0018:ffff880079a77bf0  EFLAGS: 00000202
[ 1060.167015] RAX: 0000000000000000 RBX: ffffffff82669e74 RCX: 0000000000000000
[ 1060.167015] RDX: ffff88007ba7b000 RSI: 0000000000000000 RDI: 0000000000000001
[ 1060.167015] RBP: ffff880079a77c30 R08: 0000000000000000 R09: 0000000000000000
[ 1060.167015] R10: 0000000000000000 R11: 0000000000000001 R12: ffff880079a77b68
[ 1060.167015] R13: ffff88007ba7b000 R14: ffff880079a76000 R15: ffff880079a77fd8
[ 1060.167015] FS:  0000000000000000(0000) GS:ffff88007ce00000(0000)
knlGS:0000000000000000
[ 1060.167015] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1060.167015] CR2: 0000000000da3024 CR3: 000000005f393000 CR4: 00000000000406e0
[ 1060.167015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1060.167015] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1060.167015] Process pageattr-test (pid: 1155, threadinfo
ffff880079a76000, task ffff88007ba7b000)
[ 1060.167015] Stack:
[ 1060.167015]  01ff88007ba7b000 0000000000000000 0000000000000001
ffffffff810825e0
[ 1060.167015]  0000000000000000 0000000000000001 ffff880050278000
0000000000000200
[ 1060.167015]  ffff880079a77c60 ffffffff8111f371 ffff880079a77c60
ffffffff810825e0
[ 1060.167015] Call Trace:
[ 1060.167015]  [<ffffffff810825e0>] ? __cpa_process_fault+0xb0/0xb0
[ 1060.167015]  [<ffffffff8111f371>] smp_call_function+0x41/0x80
[ 1060.167015]  [<ffffffff810825e0>] ? __cpa_process_fault+0xb0/0xb0
[ 1060.167015]  [<ffffffff8111f47c>] on_each_cpu+0x3c/0x110
[ 1060.167015]  [<ffffffff81082dcb>] cpa_flush_range+0x7b/0x110
[ 1060.167015]  [<ffffffff810837f9>] ? __change_page_attr_set_clr+0x69/0xc0
[ 1060.167015]  [<ffffffff81083c72>] change_page_attr_set_clr+0x202/0x270
[ 1060.167015]  [<ffffffff81082efb>] ? print_split+0x9b/0x200
[ 1060.167015]  [<ffffffff810e44ae>] ? sub_preempt_count+0xae/0xe0
[ 1060.167015]  [<ffffffff810840d2>] pageattr_test+0x2c2/0x510
[ 1060.167015]  [<ffffffff810bea00>] ? destroy_timer_on_stack+0x10/0x20
[ 1060.167015]  [<ffffffff810be3e0>] ? cascade+0xa0/0xa0
[ 1060.167015]  [<ffffffff81084320>] ? pageattr_test+0x510/0x510
[ 1060.167015]  [<ffffffff8108433f>] do_pageattr_test+0x1f/0x50
[ 1060.167015]  [<ffffffff810d30e2>] kthread+0xb2/0xc0
[ 1060.167015]  [<ffffffff8266bcf4>] kernel_thread_helper+0x4/0x10
[ 1060.167015]  [<ffffffff810deb38>] ? finish_task_switch+0x78/0xf0
[ 1060.167015]  [<ffffffff82669e74>] ? retint_restore_args+0x13/0x13
[ 1060.167015]  [<ffffffff810d3030>] ? kthread_flush_work_fn+0x10/0x10
[ 1060.167015]  [<ffffffff8266bcf0>] ? gs_change+0x13/0x13
[ 1060.167015] Code: 28 48 89 c6 e8 f4 9c 54 01 0f ae f0 48 8b 7b 30
ff 15 0f 54 11 02 80 7d c7 00 75 0b eb 0f 0f 1f 80 00 00 00 00 f3 90
f6 43 20 01 <75> f8 48 8b 5d d8 4c 8b 65 e0 4c 8b 6d e8 4c 8b 75 f0 4c
8b 7d
[ 1060.167015] Call Trace:
[ 1060.167015]  [<ffffffff810825e0>] ? __cpa_process_fault+0xb0/0xb0
[ 1060.167015]  [<ffffffff8111f371>] smp_call_function+0x41/0x80
[ 1060.167015]  [<ffffffff810825e0>] ? __cpa_process_fault+0xb0/0xb0
[ 1060.167015]  [<ffffffff8111f47c>] on_each_cpu+0x3c/0x110
[ 1060.167015]  [<ffffffff81082dcb>] cpa_flush_range+0x7b/0x110
[ 1060.167015]  [<ffffffff810837f9>] ? __change_page_attr_set_clr+0x69/0xc0
[ 1060.167015]  [<ffffffff81083c72>] change_page_attr_set_clr+0x202/0x270
[ 1060.167015]  [<ffffffff81082efb>] ? print_split+0x9b/0x200
[ 1060.167015]  [<ffffffff810e44ae>] ? sub_preempt_count+0xae/0xe0
[ 1060.167015]  [<ffffffff810840d2>] pageattr_test+0x2c2/0x510
[ 1060.167015]  [<ffffffff810bea00>] ? destroy_timer_on_stack+0x10/0x20
[ 1060.167015]  [<ffffffff810be3e0>] ? cascade+0xa0/0xa0
[ 1060.167015]  [<ffffffff81084320>] ? pageattr_test+0x510/0x510
[ 1060.167015]  [<ffffffff8108433f>] do_pageattr_test+0x1f/0x50
[ 1060.167015]  [<ffffffff810d30e2>] kthread+0xb2/0xc0
[ 1060.167015]  [<ffffffff8266bcf4>] kernel_thread_helper+0x4/0x10
[ 1060.167015]  [<ffffffff810deb38>] ? finish_task_switch+0x78/0xf0
[ 1060.167015]  [<ffffffff82669e74>] ? retint_restore_args+0x13/0x13
[ 1060.167015]  [<ffffffff810d3030>] ? kthread_flush_work_fn+0x10/0x10
[ 1060.167015]  [<ffffffff8266bcf0>] ? gs_change+0x13/0x13
[ 1060.167015] Kernel panic - not syncing: softlockup: hung tasks
[ 1060.167015] Rebooting in 1 seconds..
