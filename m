Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030866Ab2COPZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 11:25:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57221 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030466Ab2COPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 11:25:27 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 15 Mar 2012 17:25:06 +0200
Message-ID: <CA+1xoqfKE2u7mm=o507TvoFw8oqtKq8RRaJ5jU4c=J-GAH0APw@mail.gmail.com>
Subject: sound: BUG: unable to handle kernel irq event stamp: 2013419
To: perex@perex.cz, tiwai@suse.de, lucas.demarchi@profusion.mobi
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I got the following kernel panic when running the trinity fuzzer in a
KVM tool guest, using today's linux-next.

Please note that the guest doesn't have anything which even remotely
reminds a multimedia device of any sort, although most of the drivers
are compiled into the kernel.

[  145.747790] BUG: unable to handle kernel irq event stamp: 2013419
[  145.744076] hardirqs last  enabled at (2013419):
[<ffffffff811582d8>] __call_rcu+0x128/0x2c0
[  145.744076] hardirqs last disabled at (2013418):
[<ffffffff81158247>] __call_rcu+0x97/0x2c0
[  145.744076] softirqs last  enabled at (2013156):
[<ffffffff810b9a93>] __do_softirq+0x133/0x180
[  145.744076] softirqs last disabled at (2013139):
[<ffffffff8270c96c>] call_softirq+0x1c/0x30
[  145.748761] paging request at ffffc9000279e000
[  145.748761] IP: [<ffffffff821474cb>] midi_poll+0x6b/0x180
[  145.748761] PGD 3c9bc067 PUD 3c9bd067 PMD 36b5c067 PTE 0
[  145.748761] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  145.748761] CPU 0
[  145.748761] Pid: 3129, comm: trinity Tainted: G        W
3.3.0-rc7-next-20120315-sasha-00002-g91cfd71 #51
[  145.748761] RIP: 0010:[<ffffffff821474cb>]  [<ffffffff821474cb>]
midi_poll+0x6b/0x180
[  145.784811] RSP: 0018:ffff88003d603dc0  EFLAGS: 00010086
[  145.784811] RAX: 0000000000000000 RBX: 0000000000000282 RCX: ffffc9000279e000
[  145.792008] RDX: ffff880034ad0000 RSI: 0000000000000000 RDI: 0000000000000001
[  145.792008] RBP: ffff88003d603df0 R08: 0000000000000001 R09: 0000000000000000
[  145.792008] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[  145.792008] R13: 0000000010624dd3 R14: 0000000000000001 R15: 0000000000000000
[  145.792008] FS:  00007f2af88d0700(0000) GS:ffff88003d600000(0000)
knlGS:0000000000000000
[  145.792008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  145.792008] CR2: ffffc9000279e000 CR3: 0000000035195000 CR4: 00000000000406f0
[  145.792008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  145.792008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  145.792008] Process trinity (pid: 3129, threadinfo
ffff880034aca000, task ffff880034ad0000)
[  145.792008] Stack:
[  145.792008]  ffff880034ad0000 ffff880034acbfd8 ffff88003d603e10
0000000000000102
[  145.792008]  ffffffff82147460 0000000000000000 ffff88003d603e70
ffffffff810c0c2a
[  145.792008]  ffffffff810c0ba0 ffff88003d603ea0 ffffffff8300abec
ffffffff83d2e370
[  145.792008] Call Trace:
[  145.792008]  <IRQ>
[  145.792008]  [<ffffffff82147460>] ? midi_input_intr+0xb0/0xb0
[  145.792008]  [<ffffffff810c0c2a>] call_timer_fn.clone.11+0x8a/0x110
[  145.792008]  [<ffffffff810c0ba0>] ? process_timeout+0x10/0x10
[  145.792008]  [<ffffffff82147460>] ? midi_input_intr+0xb0/0xb0
[  145.792008]  [<ffffffff810c0efa>] run_timer_softirq+0x13a/0x220
[  145.792008]  [<ffffffff810b9a28>] __do_softirq+0xc8/0x180
[  145.792008]  [<ffffffff811fce9d>] ? dput+0x13d/0x1d0
[  145.792008]  [<ffffffff8270c96c>] call_softirq+0x1c/0x30
[  145.792008]  [<ffffffff8104fc05>] do_softirq+0xc5/0x100
[  145.792008]  [<ffffffff810b9e9e>] irq_exit+0xae/0xe0
[  145.792008]  [<ffffffff810719e8>] smp_apic_timer_interrupt+0x68/0xa0
[  145.792008]  [<ffffffff8270bf6f>] apic_timer_interrupt+0x6f/0x80
[  145.792008]  <EOI>
[  145.792008]  [<ffffffff8270a9f4>] ? retint_restore_args+0x13/0x13
[  145.792008]  [<ffffffff81119528>] ? lock_release+0x98/0xc0
[  145.792008]  [<ffffffff82709b6e>] _raw_spin_unlock+0x1e/0x60
[  145.792008]  [<ffffffff811fce9d>] dput+0x13d/0x1d0
[  145.792008]  [<ffffffff811f35e1>] do_last+0x461/0x790
[  145.792008]  [<ffffffff811f39e7>] path_openat+0xd7/0x500
[  145.792008]  [<ffffffff810ec458>] ? sched_clock_cpu+0xc8/0x140
[  145.792008]  [<ffffffff811f3e54>] do_filp_open+0x44/0xa0
[  145.792008]  [<ffffffff82709b80>] ? _raw_spin_unlock+0x30/0x60
[  145.792008]  [<ffffffff81203a36>] ? alloc_fd+0x176/0x240
[  145.792008]  [<ffffffff811e2c8d>] do_sys_open+0xfd/0x1d0
[  145.792008]  [<ffffffff811e2d7c>] sys_open+0x1c/0x20
[  145.792008]  [<ffffffff8270b2bd>] system_call_fastpath+0x1a/0x1f
[  145.792008] Code: bd d3 4d 62 10 0f 1f 00 4d 63 f4 4a 83 3c f5 e0
32 90 84 00 0f 84 ad 00 00 00 4a 8b 0c f5 a0 5b 90 84 48 85 c9 0f 84
9c 00 00 00 <8b> 01 85 c0 0f 84 e3 00 00 00 8b 51 04 eb 3d 66 0f 1f 44
00 00
[  145.792008] RIP  [<ffffffff821474cb>] midi_poll+0x6b/0x180
[  145.792008]  RSP <ffff88003d603dc0>
[  145.792008] CR2: ffffc9000279e000
[  145.792008] ---[ end trace 31f7a567e17c1567 ]---
[  145.792008] Kernel panic - not syncing: Fatal exception in interrupt
[  145.792008] Rebooting in 1 seconds..\

Thanks!
