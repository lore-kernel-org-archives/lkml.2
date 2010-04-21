Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0DUN04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab0DUN0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:26:54 -0400
Date: Wed, 21 Apr 2010 09:26:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Divyesh Shah <dpshah@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: blkio controller BUG_ON()
Message-ID: <20100421132617.GA20733@redhat.com>
References: <20100420211749.GF3020@redhat.com> <t2te98e18941004202314v8e59423g1f602ab93f57fee6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <t2te98e18941004202314v8e59423g1f602ab93f57fee6@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:14:04PM -0700, Nauman Rafique wrote:
> Hi Vivek,
> Divyesh is out on vacation for the week. We are running our kernel
> with group isolation turned on, so that would explain why we would not
> see this in our testing.

Ok, that explains it. I was wondering why you did not face this issue.

> 
> I feel like moving queues around with pending requests would be quite
> problematic in general. Can we allocate new queue in the root group
> and let the old queue drain in the older cgroup?

You can try it out, not sure if it is a simple patch. In the past I have
seen frequent migration of cfqq across group. Keeping a reference to cfq
group in rq, might turn out to be a simpler implementation.

> In fact, are there
> many use cases of having cgroups but having group isolation off?

I am not a big fan of moving queues around, but it atleast gives one more
mode to operate where if somebody is looking to put sequential readers
in separate group but wants to treat all random readers in one group
(root). 

So I would say, lets keep it around at least for the time being.

Vivek


> 
> Thanks.
> --
> Nauman
> 
> On Tue, Apr 20, 2010 at 2:17 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Divyesh,
> >
> > While testing blkio controller, I ran into following BUG_ON(). I am doing
> > my testing on for-2.6.35 branch of blk tree. This can be easily reproduced
> > by putting two sequential readers in two cgroups.
> >
> > I think what is happening is that you are assuming that rq->cfqq->cfqg
> > will remain same at the time of request dispatch and completion. But
> > because of cfqq migration logic (move cfqq to root group if it is not
> > sequential workload), it is not necessary that request dispatched from
> > one group complete in same group.
> >
> > I guess one solution would be to stash a cfq_group pointer in rq
> > (rq->elevator_private3)?
> >
> > Thanks
> > Vivek
> >
> >
> > [   65.163523] ------------[ cut here ]------------
> > [   65.164301] kernel BUG at block/blk-cgroup.c:117!
> > [   65.164301] invalid opcode: 0000 [#1] SMP
> > [   65.164301] last sysfs file: /sys/devices/pci0000:00/0000:00:05.0/0000:60:00.1/host9/rport-9:0-0/target9:0:0/9:0:0:2/block/sde/stat
> > [   65.164301] CPU 1
> > [   65.164301] Modules linked in: dm_round_robin dm_multipath qla2xxx scsi_transport_fc dm_zero dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
> > [   65.164301]
> > [   65.164301] Pid: 4505, comm: fio Not tainted 2.6.34-rc4-blk-for-35 #34 0A98h/HP xw8600 Workstation
> > [   65.164301] RIP: 0010:[<ffffffff8121924f>]  [<ffffffff8121924f>] blkiocg_update_io_remove_stats+0x5b/0xaf
> > [   65.164301] RSP: 0018:ffff8800ba5a79e8  EFLAGS: 00010046
> > [   65.164301] RAX: 0000000000000096 RBX: ffff8800bb268d60 RCX: 0000000000000000
> > [   65.164301] RDX: ffff8800bb268eb8 RSI: 0000000000000000 RDI: ffff8800bb268e00
> > [   65.164301] RBP: ffff8800ba5a7a08 R08: 0000000000000064 R09: 0000000000000001
> > [   65.164301] R10: 0000000000079640 R11: ffff8800a0bd5bf0 R12: ffff8800bab4af01
> > [   65.164301] R13: ffff8800bab4af00 R14: ffff8800bb1d8928 R15: 0000000000000000
> > [   65.164301] FS:  00007f18f75056f0(0000) GS:ffff880001e40000(0000) knlGS:0000000000000000
> > [   65.164301] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   65.164301] CR2: 000000000040e7f0 CR3: 00000000ba52b000 CR4: 00000000000006e0
> > [   65.164301] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   65.164301] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   65.164301] Process fio (pid: 4505, threadinfo ffff8800ba5a6000, task ffff8800ba45ae80)
> > [   65.164301] Stack:
> > [   65.164301]  ffff8800ba5a7a08 ffff8800ba722540 ffff8800bab4af68 ffff8800bab4af68
> > [   65.164301] <0> ffff8800ba5a7a38 ffffffff8121d814 ffff8800ba722540 ffff8800bab4af68
> > [   65.164301] <0> ffff8800ba722540 ffff8800a08f6800 ffff8800ba5a7a68 ffffffff8121d8ca
> > [   65.164301] Call Trace:
> > [   65.164301]  [<ffffffff8121d814>] cfq_remove_request+0xe4/0x116
> > [   65.164301]  [<ffffffff8121d8ca>] cfq_dispatch_insert+0x84/0xe1
> > [   65.164301]  [<ffffffff8121e833>] cfq_dispatch_requests+0x767/0x8e8
> > [   65.164301]  [<ffffffff8120e524>] ? submit_bio+0xc3/0xcc
> > [   65.164301]  [<ffffffff810ad657>] ? sync_page_killable+0x0/0x35
> > [   65.164301]  [<ffffffff8120ea8d>] blk_peek_request+0x191/0x1a7
> > [   65.164301]  [<ffffffffa000109c>] ? dm_get_live_table+0x44/0x4f [dm_mod]
> > [   65.164301]  [<ffffffffa0002799>] dm_request_fn+0x38/0x14c [dm_mod]
> > [   65.164301]  [<ffffffff810ad657>] ? sync_page_killable+0x0/0x35
> > [   65.164301]  [<ffffffff8120f600>] __generic_unplug_device+0x32/0x37
> > [   65.164301]  [<ffffffff8120f8a0>] generic_unplug_device+0x2e/0x3c
> > [   65.164301]  [<ffffffffa00011a6>] dm_unplug_all+0x42/0x5b [dm_mod]
> > [   65.164301]  [<ffffffff8120b063>] blk_unplug+0x29/0x2d
> > [   65.164301]  [<ffffffff8120b079>] blk_backing_dev_unplug+0x12/0x14
> > [   65.164301]  [<ffffffff81108a82>] block_sync_page+0x35/0x39
> > [   65.164301]  [<ffffffff810ad64e>] sync_page+0x41/0x4a
> > [   65.164301]  [<ffffffff810ad665>] sync_page_killable+0xe/0x35
> > [   65.164301]  [<ffffffff81589027>] __wait_on_bit_lock+0x46/0x8f
> > [   65.164301]  [<ffffffff810ad52d>] __lock_page_killable+0x66/0x6d
> > [   65.164301]  [<ffffffff81055fd4>] ? wake_bit_function+0x0/0x33
> > [   65.164301]  [<ffffffff810ad560>] lock_page_killable+0x2c/0x2e
> > [   65.164301]  [<ffffffff810aebfd>] generic_file_aio_read+0x361/0x4f0
> > [   65.164301]  [<ffffffff810e906c>] do_sync_read+0xcb/0x108
> > [   65.164301]  [<ffffffff811e32a3>] ? security_file_permission+0x16/0x18
> > [   65.164301]  [<ffffffff810e96d3>] vfs_read+0xab/0x108
> > [   65.164301]  [<ffffffff810e97f0>] sys_read+0x4a/0x6e
> > [   65.164301]  [<ffffffff81002b5b>] system_call_fastpath+0x16/0x1b
> > [   65.164301] Code: 00 74 1c 48 8b 8b 60 01 00 00 48 85 c9 75 04 0f 0b eb fe 48 ff c9 48 89 8b 60 01 00 00 eb 1a 48 8b 8b 58 01 00 00 48 85 c9 75 04 <0f> 0b eb fe 48 ff c9 48 89 8b 58 01 00 00 45 84 e4 74 16 48 8b
> > [   65.164301] RIP  [<ffffffff8121924f>] blkiocg_update_io_remove_stats+0x5b/0xaf
> > [   65.164301]  RSP <ffff8800ba5a79e8>
> > [   65.164301] ---[ end trace 1b2b828753032e68 ]---
> >
