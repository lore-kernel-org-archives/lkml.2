Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab2KENYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:24:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab2KENYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:24:21 -0500
Date: Mon, 5 Nov 2012 14:24:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
In-Reply-To: <20121105070106.GA17015@localhost>
Message-ID: <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
References: <20121105070106.GA17015@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Fengguang Wu wrote:

> Hi Herton,
> 
> I got the below oops in Linux 3.7-rc4 and it's bisected down to
> 
> commit b54e1f88897bcacc2cd359f48ea3b39eaf55f084
> Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> Date:   Mon Aug 27 20:56:51 2012 -0300
> 
>     floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop

Fengguang,

thanks for the report.

How reliable is the bisection result? (i.e. how reliably are you able to 
trigger this oops?).

I am having a hard time seeing how that particular commit could be causing 
this kind of oops.

Thanks.

> 
> 
> [   14.108013] CPU 0 
> [   14.108013] Pid: 6, comm: kworker/u:0 Not tainted 3.7.0-rc4 #1 Bochs Bochs
> [   14.108013] RIP: 0010:[<ffffffff8134eef5>]  [<ffffffff8134eef5>] blk_peek_request+0xd5/0x1c0
> [   14.108013] RSP: 0000:ffff88000dc7dd88  EFLAGS: 00010092
> [   14.108013] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
> [   14.108013] RDX: ffff88000f602688 RSI: ffffffff81fd95d8 RDI: 6b6b6b6b6b6b6b6b
> [   14.108013] RBP: ffff88000dc7dd98 R08: ffffffff81fd95c8 R09: 0000000000000000
> [   14.108013] R10: ffffffff81fd9480 R11: 0000000000000001 R12: 6b6b6b6b6b6b6b6b
> [   14.108013] R13: ffff88000dc7dfd8 R14: ffff88000dc7dfd8 R15: 0000000000000000
> [   14.108013] FS:  0000000000000000(0000) GS:ffffffff81e21000(0000) knlGS:0000000000000000
> [   14.108013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   14.108013] CR2: 0000000000000000 CR3: 0000000001e11000 CR4: 00000000000006f0
> [   14.108013] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   14.108013] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   14.108013] Process kworker/u:0 (pid: 6, threadinfo ffff88000dc7c000, task ffff88000dc5ecc0)
> [   14.108013] Stack:
> [   14.108013]  0000000000000000 0000000000000000 ffff88000dc7ddb8 ffffffff8134efee
> [   14.108013]  ffff88000dc7ddb8 0000000000000000 ffff88000dc7dde8 ffffffff814aef3c
> [   14.108013]  ffffffff81e75d80 ffff88000dc0c640 ffff88000fbfb000 ffffffff814aed90
> [   14.108013] Call Trace:
> [   14.108013]  [<ffffffff8134efee>] blk_fetch_request+0xe/0x30
> [   14.108013]  [<ffffffff814aef3c>] redo_fd_request+0x1ac/0x400
> [   14.108013]  [<ffffffff814aed90>] ? start_motor+0x130/0x130
> [   14.108013]  [<ffffffff8106b526>] process_one_work+0x136/0x450
> [   14.108013]  [<ffffffff8106af65>] ? manage_workers+0x205/0x2e0
> [   14.108013]  [<ffffffff8106bb6d>] worker_thread+0x14d/0x420
> [   14.108013]  [<ffffffff8106ba20>] ? rescuer_thread+0x1a0/0x1a0
> [   14.108013]  [<ffffffff8107075a>] kthread+0xba/0xc0
> [   14.108013]  [<ffffffff810706a0>] ? __kthread_parkme+0x80/0x80
> [   14.108013]  [<ffffffff818b553a>] ret_from_fork+0x7a/0xb0
> [   14.108013]  [<ffffffff810706a0>] ? __kthread_parkme+0x80/0x80
> [   14.108013] Code: 0f 84 c0 00 00 00 83 f8 01 0f 85 e2 00 00 00 81 4b 40 00 00 80 00 48 89 df e8 58 f8 ff ff be fb ff ff ff 48 89 df e8 fb fe ff ff <49> 8b 1c 24 49 39 dc 0f 85 2e ff ff ff 41 0f b6 84 24 28 04 00 
> [   14.108013] RIP  [<ffffffff8134eef5>] blk_peek_request+0xd5/0x1c0
> [   14.108013]  RSP <ffff88000dc7dd88>
> 
> Thanks,
> Fengguang
> 

-- 
Jiri Kosina
SUSE Labs
