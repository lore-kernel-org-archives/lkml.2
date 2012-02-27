Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2B0SWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:22:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab2B0SWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:22:30 -0500
Date: Mon, 27 Feb 2012 13:22:20 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120227182220.GD27677@redhat.com>
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

Looks like there is one more issue. After booting kernel, I tried to read
one of the cgroup files.

cat /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device and it oopses.

Basically it looks like that we are getting a null dev pointer while we
do following.

dev_name(blkg->q->backing_dev_info.dev);

I put some printk to verify backing_dev_info.dev is null. That means
somehow we have a request queue and we did not call add_disk() on that?

I checked that queue is not in bypass mode or dead mode. So nobody called
blk_cleanup_queue() on that.

Thanks
Vivek

chilli.lab.bos.redhat.com login: [   62.090238] Vivek: q =
ffff880136d647a0 bypass=0 dead=0 
[   62.091001] Vivek: dev = ffff880138959520
[   62.091001] Vivek: q = ffff880136d623d0 bypass=0 dead=0 
[   62.091001] Vivek: dev =           (null)
[   62.091001] BUG: unable to handle kernel NULL pointer dereference at
0000000000000050
[   62.091001] IP: [<ffffffff813091b5>] blkio_print_group_conf+0x85/0x160
[   62.091001] PGD 131757067 PUD 130915067 PMD 0 
[   62.091001] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   62.091001] CPU 2 
[   62.091001] Modules linked in: floppy [last unloaded: scsi_wait_scan]
[   62.091001] 
[   62.091001] Pid: 4787, comm: cat Tainted: G        W
3.3.0-rc3-tejun-misc+ #13 Hewlett-Packard HP xw6600 Workstation/0A9Ch
[   62.091001] RIP: 0010:[<ffffffff813091b5>]  [<ffffffff813091b5>]
blkio_print_group_conf+0x85/0x160
[   62.091001] RSP: 0018:ffff8801315a9df8  EFLAGS: 00010096
[   62.091001] RAX: 0000000000000030 RBX: 0000000000000000 RCX:
0000000000006867
[   62.091001] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
ffffffff81038af5
[   62.091001] RBP: ffff8801315a9e28 R08: 0000000000000002 R09:
0000000000000000
[   62.091001] R10: 0000000000000001 R11: 0000000000000000 R12:
0000000000000001
[   62.091001] R13: 0000000000010000 R14: ffff880137a9b480 R15:
ffff880130a4c248
[   62.091001] FS:  00007ff3882f6720(0000) GS:ffff88013fc80000(0000)
knlGS:0000000000000000
[   62.091001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.091001] CR2: 0000000000000050 CR3: 0000000138b0a000 CR4:
00000000000006e0
[   62.091001] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   62.091001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[   62.091001] Process cat (pid: 4787, threadinfo ffff8801315a8000, task
ffff8801386ce840)
[   62.091001] Stack:
[   62.091001]  ffff8801315a9e28 ffff880137a9b7e0 ffffffff81e45fc0
ffff880130a4c248
[   62.091001]  ffffffff81e46aa8 0000000000000000 ffff8801315a9e58
ffffffff813092ff
[   62.091001]  ffff88013167a580 ffff880130a4c248 0000000000000001
ffff88013167a580
[   62.091001] Call Trace:
[   62.091001]  [<ffffffff813092ff>] blkiocg_file_read+0x6f/0xd0
[   62.091001]  [<ffffffff810aa240>] cgroup_seqfile_show+0x50/0x60
[   62.091001]  [<ffffffff81174741>] seq_read+0x131/0x3f0
[   62.091001]  [<ffffffff8114ee70>] vfs_read+0xb0/0x180
[   62.091001]  [<ffffffff8114ef8a>] sys_read+0x4a/0x90
[   62.091001]  [<ffffffff81843952>] system_call_fastpath+0x16/0x1b
[   62.091001] Code: 05 48 c1 ea 06 83 e2 01 83 e1 01 e8 dd 51 52 00 48 8b
03 48 c7 c7 57 bc c9 81 48 8b 98 a8 05 00 00 31 c0 48 89 de e8 c2 51 52 00
<48> 8b 53 50 48 85 d2 74 7a 45 85 e4 75 25 41 8b 4e 08 85 c9 75 
[   62.091001] RIP  [<ffffffff813091b5>] blkio_print_group_conf+0x85/0x160
[   62.091001]  RSP <ffff8801315a9df8>
[   62.091001] CR2: 0000000000000050
[   62.091001] ---[ end trace be53af9706c0e89c ]---

