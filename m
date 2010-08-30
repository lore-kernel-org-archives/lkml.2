Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab0H3V2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 17:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0H3V2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 17:28:35 -0400
Date: Mon, 30 Aug 2010 17:28:20 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        dm-devel@redhat.com
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Message-ID: <20100830212819.GA12522@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
 <20100830132836.GB5283@redhat.com>
 <4C7BB932.1070405@kernel.org>
 <4C7BC942.7070703@kernel.org>
 <20100830190835.GA8458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830190835.GA8458@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30 2010 at  3:08pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Aug 30 2010 at 11:07am -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
> > On 08/30/2010 03:59 PM, Tejun Heo wrote:
> > > Ah... that's probably from "if (!elv_queue_empty(q))" check below,
> > > flushes are on a separate queue but I forgot to update
> > > elv_queue_empty() to check the flush queue.  elv_queue_empty() can
> > > return %true spuriously in which case the queue won't be plugged and
> > > restarted later leading to queue hang.  I'll fix elv_queue_empty().
> > 
> > I think I was too quick to blame elv_queue_empty().  Can you please
> > test whether the following patch fixes the hang?
> 
> It does, thanks!

Hmm, but unfortunately I was too quick to say the patch fixed the hang.

It is much more rare, but I can still get a hang.  I just got the
following running vgcreate against an DM mpath (rq-based) device:

INFO: task vgcreate:3517 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
vgcreate      D ffff88003d677a00  5168  3517   3361 0x00000080
 ffff88003d677998 0000000000000046 ffff880000000000 ffff88003d677fd8
 ffff880039c84860 ffff88003d677fd8 00000000001d3880 ffff880039c84c30
 ffff880039c84c28 00000000001d3880 00000000001d3880 ffff88003d677fd8
Call Trace:
 [<ffffffff81389308>] io_schedule+0x73/0xb5
 [<ffffffff811c7304>] get_request_wait+0xef/0x17d
 [<ffffffff810642be>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff811c7890>] __make_request+0x333/0x467
 [<ffffffff810251e5>] ? pvclock_clocksource_read+0x50/0xb9
 [<ffffffff811c5e91>] generic_make_request+0x342/0x3bf
 [<ffffffff81074714>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81069df2>] ? local_clock+0x41/0x5a
 [<ffffffff811c5fe9>] submit_bio+0xdb/0xf8
 [<ffffffff810754a4>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811381a6>] dio_bio_submit+0x7b/0x9c
 [<ffffffff81138dbe>] __blockdev_direct_IO+0x7f3/0x97d
 [<ffffffff810251e5>] ? pvclock_clocksource_read+0x50/0xb9
 [<ffffffff81136d7a>] blkdev_direct_IO+0x57/0x59
 [<ffffffff81135f58>] ? blkdev_get_blocks+0x0/0x90
 [<ffffffff810ce301>] generic_file_aio_read+0xed/0x5b4
 [<ffffffff81077932>] ? lock_release_non_nested+0xd5/0x23b
 [<ffffffff810e40f8>] ? might_fault+0x5c/0xac
 [<ffffffff810251e5>] ? pvclock_clocksource_read+0x50/0xb9
 [<ffffffff8110e131>] do_sync_read+0xcb/0x108
 [<ffffffff81074688>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff81389a99>] ? __mutex_unlock_slowpath+0x120/0x132
 [<ffffffff8119d805>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff8119d86c>] ? security_file_permission+0x2e/0x33
 [<ffffffff8110e7a3>] vfs_read+0xab/0x107
 [<ffffffff81075473>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff8110e8c2>] sys_read+0x4d/0x74
 [<ffffffff81002c32>] system_call_fastpath+0x16/0x1b
no locks held by vgcreate/3517.

I was then able to reproduce it after reboot and another ~5 attempts
(all against 2.6.36-rc2 + your latest FLUSH+FUA patchset and DM
patches).

crash> bt -l 3893
PID: 3893   TASK: ffff88003e65a430  CPU: 0   COMMAND: "vgcreate"
 #0 [ffff88003a5298d8] schedule at ffffffff813891d3
    /root/git/linux-2.6/kernel/sched.c: 2873
 #1 [ffff88003a5299a0] io_schedule at ffffffff81389308
    /root/git/linux-2.6/kernel/sched.c: 5128
 #2 [ffff88003a5299c0] get_request_wait at ffffffff811c7304
    /root/git/linux-2.6/block/blk-core.c: 879
 #3 [ffff88003a529a50] __make_request at ffffffff811c7890
    /root/git/linux-2.6/block/blk-core.c: 1301
 #4 [ffff88003a529ac0] generic_make_request at ffffffff811c5e91
    /root/git/linux-2.6/block/blk-core.c: 1536
 #5 [ffff88003a529b70] submit_bio at ffffffff811c5fe9
    /root/git/linux-2.6/block/blk-core.c: 1632
 #6 [ffff88003a529bc0] dio_bio_submit at ffffffff811381a6
    /root/git/linux-2.6/fs/direct-io.c: 375
 #7 [ffff88003a529bf0] __blockdev_direct_IO at ffffffff81138dbe
    /root/git/linux-2.6/fs/direct-io.c: 1087
 #8 [ffff88003a529cd0] blkdev_direct_IO at ffffffff81136d7a
    /root/git/linux-2.6/fs/block_dev.c: 177
 #9 [ffff88003a529d10] generic_file_aio_read at ffffffff810ce301
    /root/git/linux-2.6/mm/filemap.c: 1303
#10 [ffff88003a529df0] do_sync_read at ffffffff8110e131
    /root/git/linux-2.6/fs/read_write.c: 282
#11 [ffff88003a529f00] vfs_read at ffffffff8110e7a3
    /root/git/linux-2.6/fs/read_write.c: 310
#12 [ffff88003a529f40] sys_read at ffffffff8110e8c2
    /root/git/linux-2.6/fs/read_write.c: 388
#13 [ffff88003a529f80] system_call_fastpath at ffffffff81002c32
    /root/git/linux-2.6/arch/x86/kernel/entry_64.S: 488
    RIP: 0000003b602d41a0  RSP: 00007fff55d5b928  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: ffffffff81002c32  RCX: 00007fff55d5b960
    RDX: 0000000000001000  RSI: 00007fff55d5a000  RDI: 0000000000000005
    RBP: 0000000000000000   R8: 0000000000494ecd   R9: 0000000000001000
    R10: 000000315c41c160  R11: 0000000000000246  R12: 00007fff55d5a000
    R13: 00007fff55d5b0a0  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b
