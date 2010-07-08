Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab0GHHDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 03:03:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab0GHHC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 03:02:59 -0400
Date: Thu, 8 Jul 2010 09:02:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ma Ling <ling.ma@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG -tip bisected] x86, mem: Optimize memcpy by avoiding memory
 false dependece
Message-ID: <20100708070251.GC4414@elte.hu>
References: <20100707220325.GA27738@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707220325.GA27738@Krystal>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Hi Ingo,
> 
> I just bisected the cause of boot hard lockup on my Intel Xeon E5405 to this
> commit recently added to -tip:
> 
> a1e5278e40f16a4611264f8da9e557c16cb6f6ed is the first bad commit
> Merge branch 'x86/mem'
> 
> Which merge:
> 
> commit a1e5278e40f16a4611264f8da9e557c16cb6f6ed
> x86, mem: Optimize memcpy by avoiding memory false dependece
> 
> So maybe a revert while we wait for more thorough testing would be appropriate ?

I am seeing some boot crashes too which indicate memory corruption. Didnt have 
time to bisect it but they started a day ago, just when i merged that new 
commit. I'll exclude it for the time being so that Ma Ling and Peter can 
investigate it.

Below are two of the crash signatures, captured via a serial console. They 
both happen during general startup and indicate some sort of memory 
corruption. Athlon64 CPU.

Thanks,

	Ingo

[   11.496000] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   11.504000] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   11.508000] async_waiting @ 1
[   11.512000] async_continuing @ 1 after 0 usec
[   11.516000] Freeing unused kernel memory: 512k freed
[   11.520000] BUG: unable to handle kernel paging request at ffffea0000063e31
[   11.524000] IP: [<ffffffff810286e9>] free_init_pages+0x149/0x1c0
[   11.524000] PGD 26b3067 PUD f050f000081a4 
[   11.524000] Oops: 0002 [#1] PREEMPT SMP 
[   11.524000] last sysfs file: 
[   11.524000] CPU 1 
[   11.524000] Modules linked in:
[   11.524000] 
[   11.524000] Pid: 1, comm: swapper Not tainted 2.6.35-rc4-tip-01099-g2cf4496-dirty #15891 A8N-E/System Product Name
[   11.524000] RIP: 0010:[<ffffffff810286e9>]  [<ffffffff810286e9>] free_init_pages+0x149/0x1c0
[   11.524000] RSP: 0018:ffff88003f83dec0  EFLAGS: 00010286
[   11.524000] RAX: ffffea0000063e30 RBX: ffffffff81d0a000 RCX: 00000000ffffffff
[   11.524000] RDX: 000000000000e450 RSI: 0000000000000046 RDI: ffffffff81c8a000
[   11.524000] RBP: ffff88003f83def0 R08: 00000000ffffffff R09: 0000000000000000
[   11.524000] R10: 0000000000000000 R11: 0000000000000002 R12: ffffffff81c8a000
[   11.524000] R13: ffffea0000000000 R14: cccccccccccccccc R15: ffffffff81d0a000
[   11.524000] FS:  0000000000000000(0000) GS:ffff880002100000(0000) knlGS:0000000000000000
[   11.524000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   11.524000] CR2: ffffea0000063e31 CR3: 0000000001bf8000 CR4: 00000000000006e0
[   11.524000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   11.524000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   11.524000] Process swapper (pid: 1, threadinfo ffff88003f83c000, task ffff88003f848000)
[   11.524000] Stack:
[   11.524000]  ffffffff81cf8a80 ffffffff81cf8a80 ffffffff81c85488 0000000000000008
[   11.524000] <0> 0000000000000008 0000000000000000 ffff88003f83df00 ffffffff810287b3
[   11.524000] <0> ffff88003f83df10 ffffffff81000393 ffff88003f83df40 ffffffff81c9f7bf
[   11.524000] Call Trace:
[   11.524000]  [<ffffffff810287b3>] free_initmem+0x23/0x30
[   11.524000]  [<ffffffff81000393>] init_post+0x13/0xe0
[   11.524000]  [<ffffffff81c9f7bf>] kernel_init+0x1d0/0x1db
[   11.524000]  [<ffffffff81003ea4>] kernel_thread_helper+0x4/0x10
[   11.524000]  [<ffffffff8185e981>] ? restore_args+0x0/0x30
[   11.524000]  [<ffffffff81c9f5ef>] ? kernel_init+0x0/0x1db
[   11.524000]  [<ffffffff81003ea0>] ? kernel_thread_helper+0x0/0x10
[   11.524000] Code: db c5 00 01 4c 39 e3 0f 86 26 ff ff ff 4c 89 e7 e8 1d 53 00 00 48 c1 e8 0c 48 8d 14 c5 00 00 00 00 48 c1 e0 06 48 29 d0 4c 01 e8 <f0> 80 60 01 fb 4c 89 e7 e8 fa 52 00 00 48 c1 e8 0c 4c 89 e7 48 
[   11.524000] RIP  [<ffffffff810286e9>] free_init_pages+0x149/0x1c0

[   14.500850] VFS: Mounted root (ext3 filesystem) readonly on device 8:6.
[   14.507555] async_waiting @ 1
[   14.510574] async_continuing @ 1 after 2 usec
[   14.514986] Freeing unused kernel memory: 544k freed
[   14.743730] BUG: unable to handle kernel paging request at ffffea00000b6d20
[   14.747017] IP: [<ffffffff81149540>] mpage_end_io_read+0x30/0x90
[   14.747017] PGD 343d067 PUD 2e3c4ce88301246c 
[   14.747017] Oops: 0002 [#1] 
[   14.747017] last sysfs file: 
[   14.747017] CPU 0 
[   14.747017] Modules linked in:
[   14.747017] 
[   14.747017] Pid: 0, comm: swapper Not tainted 2.6.35-rc4-tip-01145-g7d54b7e-dirty #15956 A8N-E/System Product Name
[   14.747017] RIP: 0010:[<ffffffff81149540>]  [<ffffffff81149540>] mpage_end_io_read+0x30/0x90
[   14.747017] RSP: 0000:ffffffff81d62c70  EFLAGS: 00010202
[   14.747017] RAX: ffffea00000b6d58 RBX: ffff88003e5960e0 RCX: 0000000000000080
[   14.747017] RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffea00000b6d20
[   14.747017] RBP: ffffffff81d62c90 R08: 0000000000000001 R09: 0000000000000001
[   14.747017] R10: ffff88003e5e2c18 R11: 0000000000000000 R12: ffff88003e5c1a80
[   14.747017] R13: 0000000000000001 R14: 0000000000010000 R15: 0000000000000000
[   14.747017] FS:  00007f4565040780(0000) GS:ffffffff81d5f000(0000) knlGS:0000000000000000
[   14.747017] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   14.747017] CR2: ffffea00000b6d20 CR3: 000000003e5c0000 CR4: 00000000000006f0
[   14.747017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   14.747017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   14.747017] Process swapper (pid: 0, threadinfo ffffffff81d40000, task ffffffff81d54040)
[   14.747017] Stack:
[   14.747017]  ffffffff81d54040 ffff88003e5c1a80 ffff88003e5e2c18 0000000000000000
[   14.747017] <0> ffffffff81d62ca0 ffffffff81143977 ffffffff81d62cd0 ffffffff81367b6b
[   14.747017] <0> 0000000000000000 0000000000000000 ffff88003e5c1a80 0000000000010000
[   14.747017] Call Trace:
[   14.747017]  <IRQ> 
[   14.747017]  [<ffffffff81143977>] bio_endio+0x17/0x30
[   14.747017]  [<ffffffff81367b6b>] req_bio_endio+0xab/0x110
[   14.747017]  [<ffffffff813690b4>] blk_update_request+0x104/0x4b0
[   14.747017]  [<ffffffff81369289>] ? blk_update_request+0x2d9/0x4b0
[   14.747017]  [<ffffffff81369482>] blk_update_bidi_request+0x22/0x80
[   14.747017]  [<ffffffff81369aba>] blk_end_bidi_request+0x2a/0x80
[   14.747017]  [<ffffffff81369b4b>] blk_end_request+0xb/0x10
[   14.747017]  [<ffffffff8147da9a>] scsi_io_completion+0xaa/0x5c0
[   14.747017]  [<ffffffff8147530d>] scsi_finish_command+0xbd/0x140
[   14.747017]  [<ffffffff8147e105>] scsi_softirq_done+0x145/0x170
[   14.747017]  [<ffffffff8136f3c5>] blk_done_softirq+0xa5/0xd0
[   14.747017]  [<ffffffff8104f9a1>] __do_softirq+0xb1/0x230
[   14.747017]  [<ffffffff81003e7a>] call_softirq+0x1a/0x30
[   14.747017]  [<ffffffff810052ad>] do_softirq+0x8d/0x100
[   14.747017]  [<ffffffff8104f535>] irq_exit+0x85/0x90
[   14.747017]  [<ffffffff81004cbe>] do_IRQ+0x5e/0xd0
[   14.747017]  [<ffffffff818e7253>] ret_from_intr+0x0/0x15
[   14.747017]  <EOI> 
[   14.747017]  [<ffffffff81024486>] ? native_safe_halt+0x6/0x10
[   14.747017]  [<ffffffff8107cadd>] ? trace_hardirqs_on+0xd/0x10
[   14.747017]  [<ffffffff8100ae33>] default_idle+0x43/0xb0
[   14.747017]  [<ffffffff81001fab>] cpu_idle+0x5b/0xf0
[   14.747017]  [<ffffffff818b099c>] rest_init+0xac/0xc0
[   14.747017]  [<ffffffff818b08f0>] ? rest_init+0x0/0xc0
[   14.747017]  [<ffffffff81fd9c88>] start_kernel+0x366/0x371
[   14.747017]  [<ffffffff81fd92ef>] x86_64_start_reservations+0xf6/0xfa
[   14.747017]  [<ffffffff81fd9441>] x86_64_start_kernel+0x14e/0x15d
[   14.747017] Code: 55 41 54 49 89 fc 53 48 83 ec 08 0f b7 57 28 4c 8b 6f 18 48 8b 47 48 41 83 e5 01 48 c1 e2 04 48 8d 5c 02 f0 eb 17 0f 1f 44 00 00 <80> 0f 08 e8 78 02 f9 ff 49 8b 44 24 48 48 39 c3 72 2c 48 8b 3b 
[   14.747017] RIP  [<ffffffff81149540>] mpage_end_io_read+0x30/0x90
