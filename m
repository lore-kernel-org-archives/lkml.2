Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0EJPdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:33:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:46721 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab0EJPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:33:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=rVY9ZsS1YkYnTNviH7rEiQQ31OuynbILnHvdqPBWCpj+rly1YEwRdfyLb91uswI7v
	skP9m81XR56Bbdkebl4uA==
MIME-Version: 1.0
Date: Mon, 10 May 2010 17:33:32 +0200
Message-ID: <AANLkTilxN7Lq8yywpsz8voqYo0hqOX0DGcoqHmAdmFW_@mail.gmail.com>
Subject: [BUG] perf_event: crash in perf_output_begin
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       perfmon2-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing 2.6.34-rc7 I ran into the following issue when
using BTS sampling on Intel Core. It seems like something
is not terminated properly. I am sampling BTS per-thread
on a test program, then hit CTRL-C, one second later my
machine crashes while running bash. Crash dump below:

[  750.249109] general protection fault: 0000 [#1] SMP
[  750.249270] CPU 3
[  750.249270] Pid: 6132, comm: bash Not tainted 2.6.34-rc7-tip+ #46
[  750.249270] RIP: 0010:[<ffffffff810c0fb6>]  [<ffffffff810c0fb6>]
perf_output_begin+0x66/0x250
[  750.249270] RSP: 0000:ffff88000a207b38  EFLAGS: 00010002
[  750.249270] RAX: 000095d332051880 RBX: 000000000000f018 RCX: 0000000000000002
[  750.249270] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffff8169fc40
[  750.249270] RBP: ffff88000a207bc8 R08: 0000000000000001 R09: 0000000000000000
[  750.249270] R10: ffff88000a207ce8 R11: 0000000000000206 R12: ffff88022efbb400
[  750.249270] R13: 0000000000000001 R14: 0000000000000001 R15: 000095d332051880
[  750.249270] FS:  00007f81b91f96e0(0000) GS:ffff88000a200000(0000)
knlGS:0000000000000000
[  750.249270] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  750.249270] CR2: 00000000006c8da8 CR3: 0000000233313000 CR4: 00000000000006e0
[  750.249270] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  750.249270] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  750.249270] Process bash (pid: 6132, threadinfo ffff88022f036000,
task ffff88022f7dac40)
[  750.249270] Stack:
[  750.249270]  ffffffff810c0f50 ffffffff810c0900 ffff88000a207b58
ffff88000a207ce8
[  750.249270] <0> 000000040a207b68 000000000000f030 ffff88000a207bb8
ffffffff810c0e66
[  750.249270] <0> ffff88022efbb400 ffff8802330f0000 ffff88000a207bc8
ffffffff810c0789
[  750.249270] Call Trace:
[  750.249270]  <NMI>
[  750.249270]  [<ffffffff810c0f50>] ? perf_output_begin+0x0/0x250
[  750.249270]  [<ffffffff810c0900>] ? perf_output_copy+0x80/0xd0
[  750.249270]  [<ffffffff810c0e66>] ? perf_output_unlock+0xe6/0x170
[  750.249270]  [<ffffffff810c0789>] ? perf_prepare_sample+0x139/0x230
[  750.249270]  [<ffffffff810120e8>] intel_pmu_drain_bts_buffer+0xf8/0x160
[  750.249270]  [<ffffffff810c0a10>] ? perf_output_read+0xc0/0x1c0
[  750.249270]  [<ffffffff8109e5f0>] ? wd_overflow+0x60/0xd0
[  750.249270]  [<ffffffff8101146d>] ? x86_perf_event_set_period+0xad/0x100
[  750.249270]  [<ffffffff810136c4>] intel_pmu_handle_irq+0x54/0x470
[  750.249270]  [<ffffffff8145185b>] perf_event_nmi_handler+0x4b/0x60
[  750.249270]  [<ffffffff8145364f>] notifier_call_chain+0x3f/0x70
[  750.249270]  [<ffffffff814536e9>] __atomic_notifier_call_chain+0x69/0xa0
[  750.249270]  [<ffffffff81453680>] ? __atomic_notifier_call_chain+0x0/0xa0
[  750.249270]  [<ffffffff81453731>] atomic_notifier_call_chain+0x11/0x20
[  750.249270]  [<ffffffff8145376e>] notify_die+0x2e/0x30
[  750.249270]  [<ffffffff81450b89>] do_nmi+0xa9/0x2a0
[  750.249270]  [<ffffffff814506ea>] nmi+0x1a/0x2c
