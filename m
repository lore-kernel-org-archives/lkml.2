Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab2ARNvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:51:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510Ab2ARNvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:51:31 -0500
Date: Wed, 18 Jan 2012 08:51:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Kernel crash in icq_free_icq_rcu
Message-ID: <20120118135126.GB30204@redhat.com>
References: <20120117201823.GD19223@redhat.com>
 <20120117214834.GD26207@google.com>
 <20120117220715.GB23527@redhat.com>
 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
 <20120118010323.GA32160@htj.dyndns.org>
 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
 <20120118011112.GB32160@htj.dyndns.org>
 <1326850253.22361.619.camel@sli10-conroe>
 <1326866602.22361.624.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326866602.22361.624.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 02:03:22PM +0800, Shaohua Li wrote:
> On Wed, 2012-01-18 at 09:30 +0800, Shaohua Li wrote:
> > On Tue, 2012-01-17 at 17:11 -0800, Tejun Heo wrote:
> > > On Wed, Jan 18, 2012 at 09:05:26AM +0800, Shaohua Li wrote:
> > > > > Vivek is seeing the problem while switching elevators.  Are you too?
> > > > > Or is it during normal operation?
> > > > same here. I had some problems when I debug my ioscheduler, but
> > > > eventually found even switching cfq and noop can trigger oops.
> > > 
> > > Hmmm... maybe quiescing isn't working as expected and kmem cache is
> > > being destroyed with live icq's.  I'll try to reproduce it.
> > this debug patch seems to fix for me.
> > 
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index e6c05a9..c6a8ef5 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -872,11 +872,11 @@ retry:
> >  	spin_unlock_irq(q->queue_lock);
> >  
> >  	/* create icq if missing */
> > -	if (unlikely(et->icq_cache && !icq))
> > +	if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
> >  		icq = ioc_create_icq(q, gfp_mask);
> >  
> >  	/* rqs are guaranteed to have icq on elv_set_request() if requested */
> > -	if (likely(!et->icq_cache || icq))
> > +	if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
> >  		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
> >  
> >  	if (unlikely(!rq)) {
> > 
> Here is the formal patch. I hope it fixes all the problems related to
> icq_cache, but please open an eye :)
> 
> 
> Subject: block: fix NULL icq_cache reference
> 
> CPU0:					CPU1:
> 					switch from cfq to noop
> 					   elv_quiesce_start
> C: get_request
> A:   ioc_create_icq
>       alloc icq with cfq
> 					   B: do elevator switch
> 					       ioc_clear_queue
> 					   elv_quiesce_end
>       insert icq to ioc
> 					switch from noop to cfq
> 					    elv_quiesce_start
> 					    do elevator switch
> 					       ioc_clear_queue
> 					    elv_quiesce_end
> CPU0 leaves some icq to ioc list after elevator is switching from cfq to noop.
> in the second ioc_clear_queue, the ioc has icq in its list, but current
> elevator is noop. so ioc_exit_icq will get a NULL et->icq_cache.
> 
> In above cases, if A runs after B, ioc_create_icq will have a NULL
> et->icq_cache, this will trigger another crash.
> 
> Note, get_request caches et without lock hold. Between C and A, a elevator
> switch can start. But we will have elvpriv++, elv_quiesce_start will drain
> all requests first. So this will not trigger crash.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  block/blk-core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/block/blk-core.c
> ===================================================================
> --- linux.orig/block/blk-core.c	2012-01-18 12:44:13.000000000 +0800
> +++ linux/block/blk-core.c	2012-01-18 12:45:28.000000000 +0800
> @@ -872,11 +872,11 @@ retry:
>  	spin_unlock_irq(q->queue_lock);
>  
>  	/* create icq if missing */
> -	if (unlikely(et->icq_cache && !icq))
> +	if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
>  		icq = ioc_create_icq(q, gfp_mask);
>  
>  	/* rqs are guaranteed to have icq on elv_set_request() if requested */
> -	if (likely(!et->icq_cache || icq))
> +	if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
>  		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);

Not allocating icq if request is never going to go to elevator as elevator
switch was happening makes sense to me.

I tried this patch. It went little further and crashed at a different
place. I think this seems to be separate merging issue Tejun is trying
to track down.

[  167.704257] BUG: unable to handle kernel NULL pointer dereference at
0000000000000008
[  167.705002] IP: [<ffffffff8130a389>] cfq_allow_merge+0x59/0xb0
[  167.705002] PGD 13204e067 PUD 13224b067 PMD 0 
[  167.705002] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  167.705002] CPU 2 
[  167.705002] Modules linked in: [last unloaded: scsi_wait_scan]
[  167.705002] 
[  167.705002] Pid: 4653, comm: flush-8:16 Not tainted 3.2.0+ #21
Hewlett-Packard HP xw6600 Workstation/0A9Ch
[  167.705002] RIP: 0010:[<ffffffff8130a389>]  [<ffffffff8130a389>]
cfq_allow_merge+0x59/0xb0
[  167.705002] RSP: 0018:ffff8801323a74e0  EFLAGS: 00010246
[  167.705002] RAX: 0000000000000000 RBX: ffff880139500f78 RCX:
ffff880138753060
[  167.705002] RDX: 0000000000000001 RSI: ffff88013157b800 RDI:
ffff88013897cf18
[  167.705002] RBP: ffff8801323a7500 R08: ffff880138440a88 R09:
0000000000000000
[  167.705002] R10: 0000000000000003 R11: 0000000000000000 R12:
ffff88013210ac00
[  167.705002] R13: ffff88013210ac00 R14: ffff8801323a7ae0 R15:
ffff88013210ac00
[  167.705002] FS:  0000000000000000(0000) GS:ffff88013fc80000(0000)
knlGS:0000000000000000
[  167.705002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  167.705002] CR2: 0000000000000008 CR3: 0000000137e45000 CR4:
00000000000006e0
[  167.705002] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  167.705002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  167.705002] Process flush-8:16 (pid: 4653, threadinfo ffff8801323a6000,
task ffff880138753060)
[  167.705002] Stack:
[  167.705002]  ffff8801323a7510 ffff880139500f78 ffff88013210ac00
ffff880138440a88
[  167.705002]  ffff8801323a7510 ffffffff812eaf06 ffff8801323a7530
ffffffff812eb4e0
[  167.705002]  ffff880139500f78 0000000000000000 ffff8801323a7590
ffffffff812f3d22
[  167.705002] Call Trace:
[  167.705002]  [<ffffffff812eaf06>] elv_rq_merge_ok+0x96/0xa0
[  167.705002]  [<ffffffff812eb4e0>] elv_try_merge+0x20/0x60
[  167.705002]  [<ffffffff812f3d22>] blk_queue_bio+0x172/0x510
[  167.705002]  [<ffffffff81097952>] ? mark_held_locks+0x82/0x130
[  167.705002]  [<ffffffff812f222a>] generic_make_request+0xca/0x100
[  167.705002]  [<ffffffff812f22d6>] submit_bio+0x76/0xf0
[  167.705002]  [<ffffffff81105bf3>] ? account_page_writeback+0x13/0x20
[  167.705002]  [<ffffffff81106b6d>] ? test_set_page_writeback+0xed/0x1a0
[  167.705002]  [<ffffffff811f5379>] ext4_io_submit+0x29/0x60
[  167.705002]  [<ffffffff811f5575>] ext4_bio_write_page+0x1c5/0x4e0
[  167.705002]  [<ffffffff811f0819>] mpage_da_submit_io+0x509/0x580
[  167.705002]  [<ffffffff811f302e>] mpage_da_map_and_submit+0x1ce/0x450
[  167.705002]  [<ffffffff810fbe42>] ? find_get_pages_tag+0x42/0x290
[  167.705002]  [<ffffffff811f3325>] mpage_add_bh_to_extent+0x75/0x100
[  167.705002]  [<ffffffff811f36d8>] write_cache_pages_da+0x328/0x4a0
[  167.705002]  [<ffffffff8123c47d>] ? jbd2_journal_stop+0x1dd/0x2d0
[  167.705002]  [<ffffffff811f3b7d>] ext4_da_writepages+0x32d/0x830
[  167.705002]  [<ffffffff811081f4>] do_writepages+0x24/0x40
[  167.705002]  [<ffffffff81177ef1>] writeback_single_inode+0x171/0x590
[  167.705002]  [<ffffffff81178740>] writeback_sb_inodes+0x1b0/0x290
[  167.705002]  [<ffffffff811788be>] __writeback_inodes_wb+0x9e/0xd0
[  167.705002]  [<ffffffff81178aeb>] wb_writeback+0x1fb/0x520
[  167.705002]  [<ffffffff81179290>] ? wb_do_writeback+0x100/0x290
[  167.705002]  [<ffffffff811792e0>] wb_do_writeback+0x150/0x290
[  167.705002]  [<ffffffff8183510f>] ?
_raw_spin_unlock_irqrestore+0x3f/0x70
[  167.705002]  [<ffffffff811794b3>] bdi_writeback_thread+0x93/0x450
[  167.705002]  [<ffffffff81179420>] ? wb_do_writeback+0x290/0x290
[  167.705002]  [<ffffffff8105fbd3>] kthread+0x93/0xa0
[  167.705002]  [<ffffffff8183ec64>] kernel_thread_helper+0x4/0x10
[  167.705002]  [<ffffffff8183559d>] ? retint_restore_args+0xe/0xe
[  167.705002]  [<ffffffff8105fb40>] ? __init_kthread_worker+0x70/0x70
[  167.705002]  [<ffffffff8183ec60>] ? gs_change+0xb/0xb
[  167.705002] Code: 48 83 fa 01 74 0e 8b 43 40 45 31 e4 83 e0 11 83 f8 01
74 5a 48 8b 83 98 00 00 00 65 48 8b 0c 25 40 b9 00 00 48 8b b9 20 0e 00 00
<48> 3b 78 08 74 1c 45 31 e4 48 85 ff 74 35 48 8b 36 e8 a1 cf fe 
[  167.705002] RIP  [<ffffffff8130a389>] cfq_allow_merge+0x59/0xb0
[  167.705002]  RSP <ffff8801323a74e0>
[  167.705002] CR2: 0000000000000008
[  168.096368] ---[ end trace 80dfb68136073c47 ]---

Thanks
Vivek
