Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2KTU1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:27:49 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:13255 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866Ab2KTU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:27:48 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcJAE7lq1B5LbLL/2dsb2JhbABFvFeGAhdzgh4BAQU6HCMQCAMOCi4UJQMhE4gMv24UjCGEdQOVfZBCgwM
Date: Wed, 21 Nov 2012 07:27:45 +1100
From: Dave Chinner <david@fromorbit.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121120202745.GG2591@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
 <20121029222613.GU29378@dastard>
 <CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
 <CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
 <CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
 <20121118235105.GT14281@dastard>
 <CAPVoSvR+Gk6ggSZ6=ZMpyvwhosjd4BSGsUqRT=txkzGDGLMTPw@mail.gmail.com>
 <20121119235306.GX14281@dastard>
 <CAPVoSvStEdD2uhGQmtb6+qOrme_Cs_AWAuE+dP_XYD5BZyp-kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPVoSvStEdD2uhGQmtb6+qOrme_Cs_AWAuE+dP_XYD5BZyp-kA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 08:45:03PM +0100, Torsten Kaiser wrote:
> On Tue, Nov 20, 2012 at 12:53 AM, Dave Chinner <david@fromorbit.com> wrote:
> >        [<ffffffff8108137e>] mark_held_locks+0x7e/0x130
> >        [<ffffffff81081a63>] lockdep_trace_alloc+0x63/0xc0
> >        [<ffffffff810e9dd5>] kmem_cache_alloc+0x35/0xe0
> >        [<ffffffff810dba31>] vm_map_ram+0x271/0x770
> >        [<ffffffff811e1316>] _xfs_buf_map_pages+0x46/0xe0
> >        [<ffffffff811e222a>] xfs_buf_get_map+0x8a/0x130
> >        [<ffffffff81233ab9>] xfs_trans_get_buf_map+0xa9/0xd0
> >        [<ffffffff8121bced>] xfs_ialloc_inode_init+0xcd/0x1d0
> >
> > We shouldn't be mapping buffers there, there's a patch below to fix
> > this. It's probably the source of this report, even though I cannot
> > lockdep seems to be off with the fairies...
> 
> That patch seems to break my system.

You've got an IO problem, not an XFS problem. Everything is hung up
on MD.

 INFO: task kswapd0:725 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 kswapd0         D 0000000000000001     0   725      2 0x00000000
  ffff8803280d13f8 0000000000000046 ffff880329a0ab80 ffff8803280d1fd8
  ffff8803280d1fd8 ffff8803280d1fd8 ffff880046b7c880 ffff880329a0ab80
  ffff8803280d1408 ffff8803278dbbd0 ffff8803278db800 00000000ffffffff
 Call Trace:
  [<ffffffff816b1224>] schedule+0x24/0x60
  [<ffffffff814f9dad>] md_super_wait+0x4d/0x80
  [<ffffffff81500753>] bitmap_unplug+0x173/0x180
  [<ffffffff814e8eb8>] raid1_unplug+0x98/0x110
  [<ffffffff81278a6d>] blk_flush_plug_list+0xad/0x240
  [<ffffffff816b15c3>] io_schedule_timeout+0x83/0xf0
  [<ffffffff810b0e1d>] mempool_alloc+0x12d/0x160
  [<ffffffff811263da>] bvec_alloc_bs+0xda/0x100
  [<ffffffff811264ea>] bio_alloc_bioset+0xea/0x110
  [<ffffffff81126656>] bio_clone_bioset+0x16/0x40
  [<ffffffff814f471a>] bio_clone_mddev+0x1a/0x30
  [<ffffffff814edbb1>] make_request+0x551/0xde0
  [<ffffffff814f80bb>] md_make_request+0x21b/0x4d0
  [<ffffffff81276e52>] generic_make_request+0xc2/0x100
  [<ffffffff81276ef5>] submit_bio+0x65/0x110
  [<ffffffff811e07bf>] xfs_submit_ioend_bio.isra.21+0x2f/0x40
  [<ffffffff811e088e>] xfs_submit_ioend+0xbe/0x110
  [<ffffffff811e0c91>] xfs_vm_writepage+0x3b1/0x540
  [<ffffffff810bcd84>] shrink_page_list+0x564/0x890
  [<ffffffff810bd637>] shrink_inactive_list+0x1d7/0x310
  [<ffffffff810bdb9d>] shrink_lruvec+0x42d/0x530
  [<ffffffff810be323>] kswapd+0x683/0xa20
  [<ffffffff8105c246>] kthread+0xd6/0xe0
  [<ffffffff816b31ac>] ret_from_fork+0x7c/0xb0
 no locks held by kswapd0/725.

So kswapd is trying to clean pages, but it's blocked in an unplug
during IO submission. Probably one to report to the linux-raid list.

 INFO: task xfsaild/md4:1742 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 xfsaild/md4     D 0000000000000003     0  1742      2 0x00000000
  ffff88032438bb68 0000000000000046 ffff880329965700 ffff88032438bfd8
  ffff88032438bfd8 ffff88032438bfd8 ffff88032827e580 ffff880329965700
  ffff88032438bb78 ffff8803278dbbd0 ffff8803278db800 00000000ffffffff
 Call Trace:
  [<ffffffff816b1224>] schedule+0x24/0x60
  [<ffffffff814f9dad>] md_super_wait+0x4d/0x80
  [<ffffffff8105ca30>] ? __init_waitqueue_head+0x60/0x60
  [<ffffffff81500753>] bitmap_unplug+0x173/0x180
  [<ffffffff81278c13>] ? blk_finish_plug+0x13/0x50
  [<ffffffff814e8eb8>] raid1_unplug+0x98/0x110
  [<ffffffff81278a6d>] blk_flush_plug_list+0xad/0x240
  [<ffffffff81278c13>] blk_finish_plug+0x13/0x50
  [<ffffffff811e296a>] __xfs_buf_delwri_submit+0x1ca/0x1e0
  [<ffffffff811e2ffb>] xfs_buf_delwri_submit_nowait+0x1b/0x20
  [<ffffffff81233066>] xfsaild+0x226/0x4c0
  [<ffffffff81065dfa>] ? finish_task_switch+0x3a/0x100
  [<ffffffff81232e40>] ? xfs_trans_ail_cursor_first+0xa0/0xa0
  [<ffffffff8105c246>] kthread+0xd6/0xe0
  [<ffffffff816b246b>] ? _raw_spin_unlock_irq+0x2b/0x50
  [<ffffffff8105c170>] ? flush_kthread_worker+0xe0/0xe0
  [<ffffffff816b31ac>] ret_from_fork+0x7c/0xb0
  [<ffffffff8105c170>] ? flush_kthread_worker+0xe0/0xe0
 no locks held by xfsaild/md4/1742.

Same here - metadata writes are backed up waiting for MD to submit
IO. Everything else is stuck on thesei or MD, too...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
