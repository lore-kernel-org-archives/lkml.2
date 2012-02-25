Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab2BYDo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 22:44:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab2BYDoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 22:44:44 -0500
Date: Fri, 24 Feb 2012 22:44:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120225034432.GA18391@redhat.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223231204.GM22536@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 03:12:04PM -0800, Tejun Heo wrote:
> On Thu, Feb 23, 2012 at 03:01:23PM -0800, Tejun Heo wrote:
> > Hmmm... going through the thread again, ah, okay, I forgot about that
> > completely.  Yeah, that is an actual problem.  Both __GFP_WAIT which
> > isn't GFP_KERNEL and GFP_KERNEL are valid use cases.  I guess we'll be
> > building async percpu pool in blkcg then.  Great.  :(
> 
> Vivek, you win. :) Can you please refresh the async alloc patch on top
> of blkcg-stacking branch?  I'll rool that into this series and drop
> the mempool stuff.

Hi Tejun,

Booting with blkcg-stacking branch and changing io scheduler from cfq to
deadline oopsed.

Thanks
Vivek


login: [   67.382768] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[   67.383037] CPU 1 
[   67.383037] Modules linked in: floppy [last unloaded: scsi_wait_scan]
[   67.383037] 
[   67.383037] Pid: 4763, comm: bash Not tainted 3.3.0-rc3-tejun-misc+ #6 Hewlett-Packard HP xw6600 Workstation/0A9Ch
[   67.383037] RIP: 0010:[<ffffffff81311793>]  [<ffffffff81311793>] cfq_put_queue+0xb3/0x1d0
[   67.383037] RSP: 0018:ffff8801315edd48  EFLAGS: 00010046
[   67.383037] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b6b RCX: 00000001001d000e
[   67.383037] RDX: 0000000000000000 RSI: ffffea0004db6800 RDI: ffffffff8114442d
[   67.383037] RBP: ffff8801315edd68 R08: 0000000000000000 R09: 00000001001d000d
[   67.383037] R10: 0000000000000230 R11: 0000000000000000 R12: ffff880137fe44a8
[   67.383037] R13: ffff880137fe3078 R14: ffff880137cf17e0 R15: 0000000000000020
[   67.383037] FS:  00007fce2dc73720(0000) GS:ffff88013fc40000(0000) knlGS:0000000000000000
[   67.383037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.383037] CR2: 00000000006d8dc8 CR3: 0000000138a6c000 CR4: 00000000000006e0
[   67.383037] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   67.383037] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   67.383037] Process bash (pid: 4763, threadinfo ffff8801315ec000, task ffff8801386fa2c0)
[   67.383037] Stack:
[   67.383037]  ffffffff81311eb7 ffff880137fe44a8 ffff880137fe45e8 ffff880137fe4578
[   67.383037]  ffff8801315edda8 ffffffff81311ef4 0000000000000000 ffff8801378e4490
[   67.383037]  ffff8801378e44e0 ffffffff81e46d60 ffff8801378e4490 0000000000000001
[   67.383037] Call Trace:
[   67.383037]  [<ffffffff81311eb7>] ? cfq_exit_queue+0x47/0xe0
[   67.383037]  [<ffffffff81311ef4>] cfq_exit_queue+0x84/0xe0
[   67.383037]  [<ffffffff812ef19a>] elevator_exit+0x3a/0x60
[   67.383037]  [<ffffffff812efe88>] elevator_change+0x138/0x200
[   67.383037]  [<ffffffff81837c3c>] ? mutex_lock_nested+0x28c/0x350
[   67.383037]  [<ffffffff812f07db>] elv_iosched_store+0x2b/0x60
[   67.383037]  [<ffffffff812f9556>] queue_attr_store+0x66/0xc0
[   67.383037]  [<ffffffff811c5876>] sysfs_write_file+0xe6/0x170
[   67.383037]  [<ffffffff8114ecf3>] vfs_write+0xb3/0x180
[   67.383037]  [<ffffffff8114f01a>] sys_write+0x4a/0x90
[   67.383037]  [<ffffffff818438d2>] system_call_fastpath+0x16/0x1b
[   67.383037] Code: 00 00 48 8b 3d 2f 21 58 01 48 89 de 31 db e8 95 3a e3 ff 4d 85 ed 74 07 49 8b 9d 10 ff ff ff 44 8b 05 72 67 b3 00 45 85 c0 75 4d <8b> 83 b0 00 00 00 85 c0 0f 8e 94 00 00 00 83 e8 01 85 c0 89 83 
[   67.383037] RIP  [<ffffffff81311793>] cfq_put_queue+0xb3/0x1d0
[   67.383037]  RSP <ffff8801315edd48>
[   67.383037] ---[ end trace 07c5b04a4c80feda ]---

