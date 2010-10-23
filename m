Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0JWPaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 11:30:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43889 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab0JWPaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 11:30:13 -0400
Date: Sat, 23 Oct 2010 17:29:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [origin tree boot failure] Re: [GIT PULL] core block bits for
 2.6.37-rc1
Message-ID: <20101023152959.GA20930@elte.hu>
References: <4CC143F5.3060202@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC143F5.3060202@fusionio.com>
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


Hi,

* Jens Axboe <jaxboe@fusionio.com> wrote:

> Hi Linus,
> 
> This first pull request is the core bits, meaning general
> block layer changes or core support. Should be clean this time,
> only 'weird bit' is the seemingly duplicate entry from Malahal.
> This is caused by the first patch being buggy (and later
> reverted), second patch used the same single line description.
> 
> Nothing really exciting in here. A good collection of fixes, some of
> which are marked for stable as well.
> 
> The biggest addition this time around is the block IO throttling support
> from Vivek.

The upstream block bits pulled in this merge window (or maybe the workqueue bits) 
are possibly the cause a boot crash on today's -tip, using a trivial x86 bootup test 
(64-bit allyesconfig):

[  116.064281] calling  hd_init+0x0/0x302 @ 1
[  116.068529] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[  116.076334] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[  116.080274] last sysfs file: 
[  116.080274] CPU 0 
[  116.080274] Modules linked in:
[  116.080274] 
[  116.080274] Pid: 1, comm: swapper Tainted: G        W   2.6.36-tip-03555-g825d9ec-dirty #51843 A8N-E/System Product Name
[  116.080274] RIP: 0010:[<ffffffff81064380>]  [<ffffffff81064380>] __ticket_spin_trylock+0x4/0x21
[  116.080274] RSP: 0018:ffff88003c417c10  EFLAGS: 00010082
[  116.080274] RAX: ffff88003c418000 RBX: 6b6b6b6b6b6b6b6a RCX: 0000000000000000
[  116.080274] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6b6a
[  116.080274] RBP: ffff88003c417c10 R08: 0000000000000002 R09: 0000000000000001
[  116.080274] R10: 0000000000000286 R11: ffff880032498738 R12: 6b6b6b6b6b6b6b82
[  116.080274] R13: 0000000000000286 R14: 6b6b6b6b6b6b6b6b R15: 0000000000000001
[  116.080274] FS:  0000000000000000(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
[  116.080274] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  116.080274] CR2: 0000000000000000 CR3: 0000000004071000 CR4: 00000000000006f0
[  116.080274] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  116.080274] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  116.080274] Process swapper (pid: 1, threadinfo ffff88003c416000, task ffff88003c418000)
[  116.080274] Stack:
[  116.080274]  ffff88003c417c30 ffffffff8168c6ee 6b6b6b6b6b6b6b6b 6b6b6b6b6b6b6b6a
[  116.080274] <0> ffff88003c417c70 ffffffff82d37a20 ffffffff810a1b65 ffff88003c418000
[  116.080274] <0> ffffffff82d3836b 6b6b6b6b6b6b6b6a ffff8800330fcc20 ffff88003c417cb8
[  116.080274] Call Trace:
[  116.080274]  [<ffffffff8168c6ee>] do_raw_spin_trylock+0x1f/0x41
[  116.080274]  [<ffffffff82d37a20>] _raw_spin_lock_irqsave+0x72/0xa4
[  116.080274]  [<ffffffff810a1b65>] ? lock_timer_base+0x2c/0x52
[  116.080274]  [<ffffffff82d3836b>] ? _raw_spin_unlock_irqrestore+0x55/0x72
[  116.080274]  [<ffffffff810a1b65>] lock_timer_base+0x2c/0x52
[  116.080274]  [<ffffffff810a1c43>] del_timer+0x2f/0x82
[  116.080274]  [<ffffffff810ac906>] ? wait_on_work+0x0/0xdb
[  116.080274]  [<ffffffff810aca18>] __cancel_work_timer+0x37/0x130
[  116.080274]  [<ffffffff810acb23>] cancel_delayed_work_sync+0x12/0x14
[  116.080274]  [<ffffffff8166974a>] throtl_shutdown_timer_wq+0x1c/0x1e
[  116.080274]  [<ffffffff8165dbec>] blk_sync_queue+0x3d/0x41
[  116.080274]  [<ffffffff8165f872>] blk_release_queue+0x1e/0x6a
[  116.080274]  [<ffffffff81673ce3>] kobject_release+0xf4/0x122
[  116.080274]  [<ffffffff81673bef>] ? kobject_release+0x0/0x122
[  116.080274]  [<ffffffff81674e7e>] kref_put+0x43/0x4d
[  116.080274]  [<ffffffff81673b46>] kobject_put+0x47/0x4c
[  116.080274]  [<ffffffff8165dc53>] blk_cleanup_queue+0x63/0x68
[  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
[  116.080274]  [<ffffffff84883f54>] hd_init+0x2d4/0x302
[  116.080274]  [<ffffffff81910778>] ? device_pm_unlock+0x15/0x17
[  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
[  116.080274]  [<ffffffff81002062>] do_one_initcall+0x57/0x15a
[  116.080274]  [<ffffffff8482f78b>] kernel_init+0x194/0x222
[  116.080274]  [<ffffffff8103ad04>] kernel_thread_helper+0x4/0x10
[  116.080274]  [<ffffffff82d38710>] ? restore_args+0x0/0x30
[  116.080274]  [<ffffffff8482f5f7>] ? kernel_init+0x0/0x222
[  116.080274]  [<ffffffff8103ad00>] ? kernel_thread_helper+0x0/0x10
[  116.080274] Code: ff ff c9 c3 90 90 90 55 b8 00 00 01 00 48 89 e5 f0 0f c1 07 0f b7 d0 c1 e8 10 39 c2 74 07 f3 90 0f b7 17 eb f5 c9 c3 55 48 89 e5 <8b> 07 89 c2 c1 c0 10 39 c2 8d 90 00 00 01 00 75 04 f0 0f b1 17 
[  116.080274] RIP  [<ffffffff81064380>] __ticket_spin_trylock+0x4/0x21
[  116.080274]  RSP <ffff88003c417c10>
[  116.080274] ---[ end trace e8df42e772bf6fed ]---
[  116.080274] Kernel panic - not syncing: Fatal exception
[  116.080274] Pid: 1, comm: swapper Tainted: G      D W   2.6.36-tip-03555-g825d9ec-dirty #51843
[  116.080274] Call Trace:
[  116.080274]  [<ffffffff82d34d9c>] panic+0x91/0x1b7
[  116.080274]  [<ffffffff81094c93>] ? kmsg_dump+0x18d/0x1a7
[  116.080274]  [<ffffffff82d38364>] ? _raw_spin_unlock_irqrestore+0x4e/0x72
[  116.080274]  [<ffffffff82d396af>] oops_end+0xd8/0xe8
[  116.080274]  [<ffffffff8103d6fd>] die+0x5a/0x63
[  116.080274]  [<ffffffff82d3924f>] do_general_protection+0x12a/0x132
[  116.080274]  [<ffffffff82d38740>] ? irq_return+0x0/0x10
[  116.080274]  [<ffffffff82d38965>] general_protection+0x25/0x30
[  116.080274]  [<ffffffff81064380>] ? __ticket_spin_trylock+0x4/0x21
[  116.080274]  [<ffffffff8168c6ee>] do_raw_spin_trylock+0x1f/0x41
[  116.080274]  [<ffffffff82d37a20>] _raw_spin_lock_irqsave+0x72/0xa4
[  116.080274]  [<ffffffff810a1b65>] ? lock_timer_base+0x2c/0x52
[  116.080274]  [<ffffffff82d3836b>] ? _raw_spin_unlock_irqrestore+0x55/0x72
[  116.080274]  [<ffffffff810a1b65>] lock_timer_base+0x2c/0x52
[  116.080274]  [<ffffffff810a1c43>] del_timer+0x2f/0x82
[  116.080274]  [<ffffffff810ac906>] ? wait_on_work+0x0/0xdb
[  116.080274]  [<ffffffff810aca18>] __cancel_work_timer+0x37/0x130
[  116.080274]  [<ffffffff810acb23>] cancel_delayed_work_sync+0x12/0x14
[  116.080274]  [<ffffffff8166974a>] throtl_shutdown_timer_wq+0x1c/0x1e
[  116.080274]  [<ffffffff8165dbec>] blk_sync_queue+0x3d/0x41
[  116.080274]  [<ffffffff8165f872>] blk_release_queue+0x1e/0x6a
[  116.080274]  [<ffffffff81673ce3>] kobject_release+0xf4/0x122
[  116.080274]  [<ffffffff81673bef>] ? kobject_release+0x0/0x122
[  116.080274]  [<ffffffff81674e7e>] kref_put+0x43/0x4d
[  116.080274]  [<ffffffff81673b46>] kobject_put+0x47/0x4c
[  116.080274]  [<ffffffff8165dc53>] blk_cleanup_queue+0x63/0x68
[  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
[  116.080274]  [<ffffffff84883f54>] hd_init+0x2d4/0x302
[  116.080274]  [<ffffffff81910778>] ? device_pm_unlock+0x15/0x17
[  116.080274]  [<ffffffff84883c80>] ? hd_init+0x0/0x302
[  116.080274]  [<ffffffff81002062>] do_one_initcall+0x57/0x15a
[  116.080274]  [<ffffffff8482f78b>] kernel_init+0x194/0x222
[  116.080274]  [<ffffffff8103ad04>] kernel_thread_helper+0x4/0x10
[  116.080274]  [<ffffffff82d38710>] ? restore_args+0x0/0x30
[  116.080274]  [<ffffffff8482f5f7>] ? kernel_init+0x0/0x222
[  116.080274]  [<ffffffff8103ad00>] ? kernel_thread_helper+0x0/0x10

(Note, the taint is there because there are a few other (unrelated and harmless) 
warnings in the bootup.)

Previous -tip testing narrows the regression down to between d4429f6 and ab34c02.

Going back to d4429f6 it boots fine.

I've also Cc:-ed Tejun as workqueue bits were pulled in that commit range as well 
and the crash is also in the workqueue code.

Thanks,

	Ingo
