Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1CQSqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:46:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab1CQSqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:46:22 -0400
Date: Thu, 17 Mar 2011 14:46:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110317184615.GA11359@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
 <20110303221353.GA10366@redhat.com>
 <4D761E0D.8050200@fusionio.com>
 <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
 <20110317155120.GA9220@redhat.com>
 <4D825367.90408@fusionio.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <4D825367.90408@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 17 2011 at  2:31pm -0400,
Jens Axboe <jaxboe@fusionio.com> wrote:

> On 2011-03-17 16:51, Mike Snitzer wrote:
> > On Tue, Mar 08 2011 at  5:05pm -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> >> On Tue, Mar 08 2011 at  3:27pm -0500,
> >> Jens Axboe <jaxboe@fusionio.com> wrote:
> >>
> >>> On 2011-03-08 21:21, Mike Snitzer wrote:
> >>>> On Tue, Mar 08 2011 at  7:16am -0500,
> >>>> Jens Axboe <jaxboe@fusionio.com> wrote:
> >>>>
> >>>>> On 2011-03-03 23:13, Mike Snitzer wrote:
> >>>>>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
> >>>>>> kernel, when I try an fsync heavy workload to a request-based mpath
> >>>>>> device (the kernel ultimately goes down in flames, I've yet to look at
> >>>>>> the crashdump I took)
> >>>>>
> >>>>> Mike, can you re-run with the current stack-plug branch? I've fixed the
> >>>>> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
> >>>>> on schedule event. It's run outside of the runqueue lock now, so
> >>>>> hopefully that should solve this one.
> >>>>
> >>>> Works for me, thanks.
> >>>
> >>> Super, thanks! Out of curiousity, did you use dm/md?
> >>
> >> Yes, I've been using a request-based DM multipath device.
> > 
> > 
> > Against latest 'for-2.6.39/core', I just ran that same fsync heavy
> > workload against XFS (ontop of a DM multipath volume).  ffsb induced the
> > following hangs (ripple effect causing NetworkManager to get hung up on
> > this data-only XFS volume, etc):
> 
> Ugh. Care to send the recipee for how to reproduce this? Essentially
> just looks like IO got stuck.

Here is the sequence to reproduce with the attached fsync-happy.ffsb
(I've been running the following in a KVM guest):

<create multipath device>
mkfs.xfs /dev/mapper/mpathb
mount /dev/mapper/mpathb /mnt/test
./ffsb fsync-happy.ffsb

And I just verified that the deadlock does _not_ seem to occur without
DM multipath -- by directly using an underlying SCSI device instead.

So multipath is exposing this somehow (could just be changing timing?).

Mike

p.s. though I did get this lockdep warning when unmounting the xfs
filesystem:

=================================
[ INFO: inconsistent lock state ]
2.6.38-rc6-snitm+ #8
---------------------------------
inconsistent {IN-RECLAIM_FS-R} -> {RECLAIM_FS-ON-W} usage.
umount/1524 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (iprune_sem){+++++-}, at: [<ffffffff81114a22>] evict_inodes+0x2f/0x107
{IN-RECLAIM_FS-R} state was registered at:
  [<ffffffff810727c2>] __lock_acquire+0x3a4/0xd26
  [<ffffffff81073227>] lock_acquire+0xe3/0x110
  [<ffffffff81372fa2>] down_read+0x51/0x96
  [<ffffffff81114d57>] shrink_icache_memory+0x4a/0x215
  [<ffffffff810d1e48>] shrink_slab+0xe0/0x164
  [<ffffffff810d3e8f>] kswapd+0x5e7/0x9dc
  [<ffffffff8105fb7c>] kthread+0xa0/0xa8
  [<ffffffff81003a24>] kernel_thread_helper+0x4/0x10
irq event stamp: 73433
hardirqs last  enabled at (73433): [<ffffffff81070ffe>] debug_check_no_locks_freed+0x12e/0x145
hardirqs last disabled at (73432): [<ffffffff81070f13>] debug_check_no_locks_freed+0x43/0x145
softirqs last  enabled at (72996): [<ffffffff8104a1f1>] __do_softirq+0x1b4/0x1d3
softirqs last disabled at (72991): [<ffffffff81003b1c>] call_softirq+0x1c/0x28

other info that might help us debug this:
2 locks held by umount/1524:
 #0:  (&type->s_umount_key#24){++++++}, at: [<ffffffff81102a27>] deactivate_super+0x3d/0x4a
 #1:  (iprune_sem){+++++-}, at: [<ffffffff81114a22>] evict_inodes+0x2f/0x107

stack backtrace:
Pid: 1524, comm: umount Not tainted 2.6.38-rc6-snitm+ #8
Call Trace:
 [<ffffffff8107097f>] ? valid_state+0x17e/0x191
 [<ffffffff810712e8>] ? check_usage_backwards+0x0/0x81
 [<ffffffff81070ae4>] ? mark_lock+0x152/0x22d
 [<ffffffff81070c11>] ? mark_held_locks+0x52/0x70
 [<ffffffff81070cc8>] ? lockdep_trace_alloc+0x99/0xbb
 [<ffffffff810fa98a>] ? kmem_cache_alloc+0x30/0x145
 [<ffffffffa014dcdd>] ? kmem_zone_alloc+0x69/0xb1 [xfs]
 [<ffffffffa014dd39>] ? kmem_zone_zalloc+0x14/0x35 [xfs]
 [<ffffffffa0147ed9>] ? _xfs_trans_alloc+0x27/0x64 [xfs]
 [<ffffffffa0148c97>] ? xfs_trans_alloc+0x9f/0xac [xfs]
 [<ffffffff810643b7>] ? up_read+0x23/0x3c
 [<ffffffffa0133000>] ? xfs_iunlock+0x7e/0xbc [xfs]
 [<ffffffffa014c140>] ? xfs_free_eofblocks+0xea/0x1f1 [xfs]
 [<ffffffffa014c707>] ? xfs_inactive+0x108/0x3a6 [xfs]
 [<ffffffff8106ff27>] ? lockdep_init_map+0xa6/0x11b
 [<ffffffffa015787f>] ? xfs_fs_evict_inode+0xf6/0xfe [xfs]
 [<ffffffff811147c6>] ? evict+0x24/0x8c
 [<ffffffff8111485f>] ? dispose_list+0x31/0xaf
 [<ffffffff81114ae3>] ? evict_inodes+0xf0/0x107
 [<ffffffff81101660>] ? generic_shutdown_super+0x5c/0xdf
 [<ffffffff8110170a>] ? kill_block_super+0x27/0x69
 [<ffffffff81101d89>] ? deactivate_locked_super+0x26/0x4b
 [<ffffffff81102a2f>] ? deactivate_super+0x45/0x4a
 [<ffffffff81118b87>] ? mntput_no_expire+0x105/0x10e
 [<ffffffff81119db6>] ? sys_umount+0x2d9/0x304
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81002b82>] ? system_call_fastpath+0x16/0x1b

--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fsync-happy.ffsb"

# Mail server simulation.

time=600
alignio=1
directio=0
#directio=%DIRECTIO%
#directio=0
#callout=/bin/bash
#callout=/usr/local/src/ffsb-6.0-rc2/ltc_tests/enable_lockstat.sh
#callout=/usr/local/src/ffsb-6.0-rc2/ltc_tests/osync.sh

[filesystem0]
	location=/mnt/test
	num_files=100000
	num_dirs=1000

reuse=1
	# File sizes range from 1kB to 1MB.
	size_weight 1KB 10
	size_weight 2KB 15
	size_weight 4KB 16
	size_weight 8KB 16
	size_weight 16KB 15
	size_weight 32KB 10
	size_weight 64KB 8
	size_weight 128KB 4
	size_weight 256KB 3
	size_weight 512KB 2
	size_weight 1MB 1

create_blocksize=1048576
[end0]

[threadgroup0]
	num_threads=64

	readall_weight=4
	create_fsync_weight=2
	delete_weight=1

	append_weight		= 1
	append_fsync_weight	= 1
	stat_weight		= 1
#	write_weight		= 1
#	write_fsync_weight	= 1
#	read_weight		= 1
	create_weight		= 1
	writeall_weight		= 1
	writeall_fsync_weight	= 1
	open_close_weight	= 1


	write_size=64KB
	write_blocksize=512KB

	read_size=64KB
	read_blocksize=512KB

	[stats]
		enable_stats=1
		enable_range=1

		msec_range    0.00      0.01
		msec_range    0.01      0.02
		msec_range    0.02      0.05
		msec_range    0.05      0.10
		msec_range    0.10      0.20
		msec_range    0.20      0.50
		msec_range    0.50      1.00
		msec_range    1.00      2.00
		msec_range    2.00      5.00
		msec_range    5.00     10.00
		msec_range   10.00     20.00
		msec_range   20.00     50.00
		msec_range   50.00    100.00
		msec_range  100.00    200.00
		msec_range  200.00    500.00
		msec_range  500.00   1000.00
		msec_range 1000.00   2000.00
		msec_range 2000.00   5000.00
		msec_range 5000.00  10000.00
	[end]
[end0]

--qDbXVdCdHGoSgWSk--
