Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2JGS1N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:27:13 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41620 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab2JGS1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:27:03 -0400
MIME-Version: 1.0
In-Reply-To: <505E2108.2060108@gmail.com>
References: <505E2108.2060108@gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 7 Oct 2012 14:26:42 -0400
Message-ID: <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

I'm still seeing this on linux-next.

On Sat, Sep 22, 2012 at 4:35 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest linux-next kernel, I've stumbled on the following BUG.
>
> I've also hit a similar trace where the 'BUG_ON(ELV_ON_HASH(rq));' above that list_del_init() gets hit, so I guess it's a race
> condition of some sorts.
>
>
> [    9.900299] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    9.909508] IP: [<ffffffff819ea637>] __list_del_entry+0xb7/0xe0
> [    9.910191] PGD 0
> [    9.910191] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    9.910191] Dumping ftrace buffer:
> [    9.910191]    (ftrace buffer empty)
> [    9.910191] CPU 2
> [    9.910191] Pid: 3996, comm: kworker/u:2 Tainted: G        W    3.6.0-rc6-next-20120921-sasha-00001-geb77a39-dirty #3
> [    9.910191] RIP: 0010:[<ffffffff819ea637>]  [<ffffffff819ea637>] __list_del_entry+0xb7/0xe0
> [    9.910191] RSP: 0000:ffff880034e11c88  EFLAGS: 00010007
> [    9.910191] RAX: 0000000000000000 RBX: ffff880034e3ec00 RCX: dead000000200200
> [    9.910191] RDX: 0000000000000000 RSI: ffffffff85366998 RDI: ffff880034e3ec00
> [    9.910191] RBP: ffff880034e11c88 R08: 0000000000000000 R09: ffff88001af60928
> [    9.910191] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [    9.910191] R13: ffffffff85366360 R14: 0000000000000000 R15: ffffffff85b4edd0
> [    9.910191] FS:  0000000000000000(0000) GS:ffff880029800000(0000) knlGS:0000000000000000
> [    9.910191] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    9.910191] CR2: 0000000000000000 CR3: 0000000004c26000 CR4: 00000000000406e0
> [    9.910191] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    9.910191] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    9.910191] Process kworker/u:2 (pid: 3996, threadinfo ffff880034e10000, task ffff88001af60000)
> [    9.910191] Stack:
> [    9.910191]  ffff880034e11ca8 ffffffff819a1a45 ffff880034e3ec00 0000000000000000
> [    9.910191]  ffff880034e11cc8 ffffffff819a1ae1 0000000000000000 ffff880034e3ec00
> [    9.910191]  ffff880034e11ce8 ffffffff819a271e 0000000000000000 0000000000000000
> [    9.910191] Call Trace:
> [    9.910191]  [<ffffffff819a1a45>] blk_dequeue_request+0x35/0xc0
> [    9.910191]  [<ffffffff819a1ae1>] blk_start_request+0x11/0x40
> [    9.910191]  [<ffffffff819a271e>] blk_fetch_request+0x1e/0x30
> [    9.910191]  [<ffffffff81e5a89d>] redo_fd_request+0x9d/0x3f0
> [    9.910191]  [<ffffffff8112a779>] process_one_work+0x3b9/0x770
> [    9.910191]  [<ffffffff8112a628>] ? process_one_work+0x268/0x770
> [    9.910191]  [<ffffffff81177a22>] ? get_lock_stats+0x22/0x70
> [    9.910191]  [<ffffffff81e5a800>] ? start_motor+0x120/0x120
> [    9.910191]  [<ffffffff8112b0fa>] worker_thread+0x2ba/0x3f0
> [    9.910191]  [<ffffffff8112ae40>] ? rescuer_thread+0x2d0/0x2d0
> [    9.910191]  [<ffffffff81135d83>] kthread+0xe3/0xf0
> [    9.910191]  [<ffffffff81177aae>] ? put_lock_stats.isra.16+0xe/0x40
> [    9.910191]  [<ffffffff81135ca0>] ? insert_kthread_work+0x90/0x90
> [    9.910191]  [<ffffffff839f1e45>] kernel_thread_helper+0x5/0x10
> [    9.910191]  [<ffffffff81135ca0>] ? insert_kthread_work+0x90/0x90
> [    9.910191] Code: 6a 84 be 3e 00 00 00 48 c7 c7 7b d8 6a 84 31 c0 e8 8f c2 71 ff eb 2c 0f 1f 44 00 00 48 b9 00 02 20 00 00 00
> ad de 48 39 c8 74 8c <4c> 8b 00 4c 39 c7 75 a6 4c 8b 42 08 4c 39 c7 75 bc 48 89 42 08
> [    9.910191] RIP  [<ffffffff819ea637>] __list_del_entry+0xb7/0xe0
> [    9.910191]  RSP <ffff880034e11c88>
> [    9.910191] CR2: 0000000000000000
>
>
> Thanks,
> Sasha
