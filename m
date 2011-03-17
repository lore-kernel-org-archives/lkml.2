Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1CQPvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:51:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab1CQPvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:51:32 -0400
Date: Thu, 17 Mar 2011 11:51:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110317155120.GA9220@redhat.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
 <20110303221353.GA10366@redhat.com>
 <4D761E0D.8050200@fusionio.com>
 <20110308202100.GA31744@redhat.com>
 <4D76912C.9040705@fusionio.com>
 <20110308220526.GA393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308220526.GA393@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08 2011 at  5:05pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Mar 08 2011 at  3:27pm -0500,
> Jens Axboe <jaxboe@fusionio.com> wrote:
> 
> > On 2011-03-08 21:21, Mike Snitzer wrote:
> > > On Tue, Mar 08 2011 at  7:16am -0500,
> > > Jens Axboe <jaxboe@fusionio.com> wrote:
> > > 
> > >> On 2011-03-03 23:13, Mike Snitzer wrote:
> > >>> I'm now hitting a lockdep issue, while running a 'for-2.6.39/stack-plug'
> > >>> kernel, when I try an fsync heavy workload to a request-based mpath
> > >>> device (the kernel ultimately goes down in flames, I've yet to look at
> > >>> the crashdump I took)
> > >>
> > >> Mike, can you re-run with the current stack-plug branch? I've fixed the
> > >> !CONFIG_BLOCK and rebase issues, and also added a change for this flush
> > >> on schedule event. It's run outside of the runqueue lock now, so
> > >> hopefully that should solve this one.
> > > 
> > > Works for me, thanks.
> > 
> > Super, thanks! Out of curiousity, did you use dm/md?
> 
> Yes, I've been using a request-based DM multipath device.


Against latest 'for-2.6.39/core', I just ran that same fsync heavy
workload against XFS (ontop of a DM multipath volume).  ffsb induced the
following hangs (ripple effect causing NetworkManager to get hung up on
this data-only XFS volume, etc):

XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
mount used greatest stack depth: 3296 bytes left
ffsb used greatest stack depth: 2592 bytes left
INFO: task kswapd0:23 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kswapd0         D ffff880037b8f6e0  3656    23      2 0x00000000
 ffff880037b8f6d0 0000000000000046 ffff880037b8f630 ffffffff8107012f
 ffff880037b8e010 ffff880037b8ffd8 00000000001d21c0 ffff880037b90600
 ffff880037b90998 ffff880037b90990 00000000001d21c0 00000000001d21c0
Call Trace:
 [<ffffffff8107012f>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa013e958>] xlog_wait+0x60/0x78 [xfs]
 [<ffffffff810404de>] ? default_wake_function+0x0/0x14
 [<ffffffff81373c5f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffffa013f874>] xlog_state_get_iclog_space+0x9e/0x22c [xfs]
 [<ffffffffa013fb73>] xlog_write+0x171/0x4ae [xfs]
 [<ffffffffa0150df7>] ? kmem_alloc+0x69/0xb1 [xfs]
 [<ffffffff810fad18>] ? __kmalloc+0x14e/0x160
 [<ffffffffa013ff04>] xfs_log_write+0x54/0x7e [xfs]
 [<ffffffffa014b5b0>] xfs_trans_commit_iclog+0x195/0x2d8 [xfs]
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa014b7bc>] _xfs_trans_commit+0xc9/0x206 [xfs]
 [<ffffffffa0138a18>] xfs_itruncate_finish+0x1fd/0x2bd [xfs]
 [<ffffffffa014f202>] xfs_free_eofblocks+0x1ac/0x1f1 [xfs]
 [<ffffffffa014f707>] xfs_inactive+0x108/0x3a6 [xfs]
 [<ffffffff8106ff27>] ? lockdep_init_map+0xa6/0x11b
 [<ffffffffa015a87f>] xfs_fs_evict_inode+0xf6/0xfe [xfs]
 [<ffffffff81114766>] evict+0x24/0x8c
 [<ffffffff811147ff>] dispose_list+0x31/0xaf
 [<ffffffff81114e92>] shrink_icache_memory+0x1e5/0x215
 [<ffffffff810d1e14>] shrink_slab+0xe0/0x164
 [<ffffffff810d3e5b>] kswapd+0x5e7/0x9dc
 [<ffffffff810d3874>] ? kswapd+0x0/0x9dc
 [<ffffffff8105fb7c>] kthread+0xa0/0xa8
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81003a24>] kernel_thread_helper+0x4/0x10
 [<ffffffff813749d4>] ? restore_args+0x0/0x30
 [<ffffffff8105fadc>] ? kthread+0x0/0xa8
 [<ffffffff81003a20>] ? kernel_thread_helper+0x0/0x10
4 locks held by kswapd0/23:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810d1d71>] shrink_slab+0x3d/0x164
 #1:  (iprune_sem){++++.-}, at: [<ffffffff81114cf7>] shrink_icache_memory+0x4a/0x215
 #2:  (xfs_iolock_reclaimable){+.+.-.}, at: [<ffffffffa013615d>] xfs_ilock+0x30/0xb9 [xfs]
 #3:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
INFO: task NetworkManager:958 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
NetworkManager  D ffff88007a481288  3312   958      1 0x00000000
 ffff88007a481278 0000000000000046 ffff88007a4811d8 ffffffff8107012f
 ffff88007a480010 ffff88007a481fd8 00000000001d21c0 ffff88007b4f0f80
 ffff88007b4f1318 ffff88007b4f1310 00000000001d21c0 00000000001d21c0
Call Trace:
 [<ffffffff8107012f>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa013e958>] xlog_wait+0x60/0x78 [xfs]
 [<ffffffff810404de>] ? default_wake_function+0x0/0x14
 [<ffffffff81373c5f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffffa013f874>] xlog_state_get_iclog_space+0x9e/0x22c [xfs]
 [<ffffffffa013fb73>] xlog_write+0x171/0x4ae [xfs]
 [<ffffffffa0150df7>] ? kmem_alloc+0x69/0xb1 [xfs]
 [<ffffffff810fad18>] ? __kmalloc+0x14e/0x160
 [<ffffffffa013ff04>] xfs_log_write+0x54/0x7e [xfs]
 [<ffffffffa014b5b0>] xfs_trans_commit_iclog+0x195/0x2d8 [xfs]
 [<ffffffff81070c11>] ? mark_held_locks+0x52/0x70
 [<ffffffff810fa9f7>] ? kmem_cache_alloc+0xd1/0x145
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa014b7bc>] _xfs_trans_commit+0xc9/0x206 [xfs]
 [<ffffffffa011c5fa>] xfs_bmap_finish+0x87/0x16a [xfs]
 [<ffffffffa01389b9>] xfs_itruncate_finish+0x19e/0x2bd [xfs]
 [<ffffffffa014f202>] xfs_free_eofblocks+0x1ac/0x1f1 [xfs]
 [<ffffffffa014f707>] xfs_inactive+0x108/0x3a6 [xfs]
 [<ffffffff8106ff27>] ? lockdep_init_map+0xa6/0x11b
 [<ffffffffa015a87f>] xfs_fs_evict_inode+0xf6/0xfe [xfs]
 [<ffffffff81114766>] evict+0x24/0x8c
 [<ffffffff811147ff>] dispose_list+0x31/0xaf
 [<ffffffff81114e92>] shrink_icache_memory+0x1e5/0x215
 [<ffffffff810d1e14>] shrink_slab+0xe0/0x164
 [<ffffffff810d3282>] try_to_free_pages+0x27f/0x495
 [<ffffffff810cb3fc>] __alloc_pages_nodemask+0x4e3/0x767
 [<ffffffff810700a3>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff810f5b14>] alloc_pages_current+0xa7/0xca
 [<ffffffff810c515c>] __page_cache_alloc+0x85/0x8c
 [<ffffffff810cd420>] __do_page_cache_readahead+0xdb/0x1df
 [<ffffffff810cd545>] ra_submit+0x21/0x25
 [<ffffffff810c66e3>] filemap_fault+0x176/0x396
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810e15e7>] __do_fault+0x54/0x354
 [<ffffffff810709bf>] ? mark_lock+0x2d/0x22d
 [<ffffffff810e2493>] handle_pte_fault+0x2cf/0x6e8
 [<ffffffff810e004e>] ? __pte_alloc+0xc3/0xd0
 [<ffffffff810e2986>] handle_mm_fault+0xda/0xed
 [<ffffffff81377c28>] do_page_fault+0x3b4/0x3d6
 [<ffffffff8118e6de>] ? fsnotify_perm+0x69/0x75
 [<ffffffff8118e74b>] ? security_file_permission+0x2e/0x33
 [<ffffffff813739e6>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81374be5>] page_fault+0x25/0x30
5 locks held by NetworkManager/958:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81377a36>] do_page_fault+0x1c2/0x3d6
 #1:  (shrinker_rwsem){++++..}, at: [<ffffffff810d1d71>] shrink_slab+0x3d/0x164
 #2:  (iprune_sem){++++.-}, at: [<ffffffff81114cf7>] shrink_icache_memory+0x4a/0x215
 #3:  (xfs_iolock_reclaimable){+.+.-.}, at: [<ffffffffa013615d>] xfs_ilock+0x30/0xb9 [xfs]
 #4:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
INFO: task xfssyncd/dm-0:1346 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfssyncd/dm-0   D ffff880072cb1a20  4824  1346      2 0x00000000
 ffff880072cb1a10 0000000000000046 ffff880072cb1970 ffffffff8107012f
 ffff880072cb0010 ffff880072cb1fd8 00000000001d21c0 ffff88007b22ca00
 ffff88007b22cd98 ffff88007b22cd90 00000000001d21c0 00000000001d21c0
Call Trace:
 [<ffffffff8107012f>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffffa013e958>] xlog_wait+0x60/0x78 [xfs]
 [<ffffffff810404de>] ? default_wake_function+0x0/0x14
 [<ffffffff81373c5f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffffa013f874>] xlog_state_get_iclog_space+0x9e/0x22c [xfs]
 [<ffffffffa013fb73>] xlog_write+0x171/0x4ae [xfs]
 [<ffffffff81065905>] ? sched_clock_local+0x1c/0x82
 [<ffffffff810700a3>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff810709bf>] ? mark_lock+0x2d/0x22d
 [<ffffffffa013ff04>] xfs_log_write+0x54/0x7e [xfs]
 [<ffffffffa014b5b0>] xfs_trans_commit_iclog+0x195/0x2d8 [xfs]
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0150cdd>] ? kmem_zone_alloc+0x69/0xb1 [xfs]
 [<ffffffffa014af66>] ? xfs_trans_add_item+0x50/0x5c [xfs]
 [<ffffffffa014b7bc>] _xfs_trans_commit+0xc9/0x206 [xfs]
 [<ffffffffa0133289>] xfs_fs_log_dummy+0x76/0x7d [xfs]
 [<ffffffffa015cd3d>] xfs_sync_worker+0x37/0x6f [xfs]
 [<ffffffffa015ccb0>] xfssyncd+0x15b/0x1b1 [xfs]
 [<ffffffffa015cb55>] ? xfssyncd+0x0/0x1b1 [xfs]
 [<ffffffff8105fb7c>] kthread+0xa0/0xa8
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81003a24>] kernel_thread_helper+0x4/0x10
 [<ffffffff813749d4>] ? restore_args+0x0/0x30
 [<ffffffff8105fadc>] ? kthread+0x0/0xa8
 [<ffffffff81003a20>] ? kernel_thread_helper+0x0/0x10
no locks held by xfssyncd/dm-0/1346.
INFO: task ffsb:1355 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ffsb            D 000000010002503a  3648  1355   1322 0x00000000
 ffff88007baffae8 0000000000000046 ffff88007baffa48 ffffffff00000000
 ffff88007bafe010 ffff88007bafffd8 00000000001d21c0 ffff880071df4680
 ffff880071df4a18 ffff880071df4a10 00000000001d21c0 00000000001d21c0
Call Trace:
 [<ffffffffa013e958>] xlog_wait+0x60/0x78 [xfs]
 [<ffffffff810404de>] ? default_wake_function+0x0/0x14
 [<ffffffff81373c5f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffffa013f874>] xlog_state_get_iclog_space+0x9e/0x22c [xfs]
 [<ffffffffa013fb73>] xlog_write+0x171/0x4ae [xfs]
 [<ffffffff810727da>] ? __lock_acquire+0x3bc/0xd26
 [<ffffffff81065a7a>] ? local_clock+0x41/0x5a
 [<ffffffff81024167>] ? pvclock_clocksource_read+0x4b/0xb4
 [<ffffffffa013ff04>] xfs_log_write+0x54/0x7e [xfs]
 [<ffffffff81065905>] ? sched_clock_local+0x1c/0x82
 [<ffffffffa014b5b0>] xfs_trans_commit_iclog+0x195/0x2d8 [xfs]
 [<ffffffff81070c11>] ? mark_held_locks+0x52/0x70
 [<ffffffff810fa9f7>] ? kmem_cache_alloc+0xd1/0x145
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0150cdd>] ? kmem_zone_alloc+0x69/0xb1 [xfs]
 [<ffffffffa014b7bc>] _xfs_trans_commit+0xc9/0x206 [xfs]
 [<ffffffffa01566f8>] xfs_file_fsync+0x166/0x1e6 [xfs]
 [<ffffffff81122a8b>] vfs_fsync_range+0x54/0x7c
 [<ffffffff81122b15>] vfs_fsync+0x1c/0x1e
 [<ffffffff81122b45>] do_fsync+0x2e/0x43
 [<ffffffff81122b81>] sys_fsync+0x10/0x14
 [<ffffffff81002b82>] system_call_fastpath+0x16/0x1b
2 locks held by ffsb/1355:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
INFO: task ffsb:1364 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ffsb            D 0000000100024ff6  3776  1364   1322 0x00000000
 ffff880027d25ae8 0000000000000046 ffff880027d25a48 ffffffff00000000
 ffff880027d24010 ffff880027d25fd8 00000000001d21c0 ffff88002839c8c0
 ffff88002839cc58 ffff88002839cc50 00000000001d21c0 00000000001d21c0
Call Trace:
 [<ffffffffa013e958>] xlog_wait+0x60/0x78 [xfs]
 [<ffffffff810404de>] ? default_wake_function+0x0/0x14
 [<ffffffff81373c5f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffffa013f874>] xlog_state_get_iclog_space+0x9e/0x22c [xfs]
 [<ffffffffa013fb73>] xlog_write+0x171/0x4ae [xfs]
 [<ffffffffa0150df7>] ? kmem_alloc+0x69/0xb1 [xfs]
 [<ffffffff810fad18>] ? __kmalloc+0x14e/0x160
 [<ffffffffa013ff04>] xfs_log_write+0x54/0x7e [xfs]
 [<ffffffffa014b5b0>] xfs_trans_commit_iclog+0x195/0x2d8 [xfs]
 [<ffffffff81070c11>] ? mark_held_locks+0x52/0x70
 [<ffffffff810fa9f7>] ? kmem_cache_alloc+0xd1/0x145
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa0150cdd>] ? kmem_zone_alloc+0x69/0xb1 [xfs]
 [<ffffffffa014b7bc>] _xfs_trans_commit+0xc9/0x206 [xfs]
 [<ffffffffa01566f8>] xfs_file_fsync+0x166/0x1e6 [xfs]
 [<ffffffff81122a8b>] vfs_fsync_range+0x54/0x7c
 [<ffffffff81122b15>] vfs_fsync+0x1c/0x1e
 [<ffffffff81122b45>] do_fsync+0x2e/0x43
 [<ffffffff81122b81>] sys_fsync+0x10/0x14
 [<ffffffff81002b82>] system_call_fastpath+0x16/0x1b
2 locks held by ffsb/1364:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]

(and many more ffsb processes hung similar to the 2 above)

I just attempted a git command against the root volume, it hung:

git             D 0000000100252022  3440  1471   1461 0x00000004
 ffff88003ad611d8 0000000000000046 ffff88003ad61138 ffffffff00000000
 ffff88003ad60010 ffff88003ad61fd8 00000000001d21c0 ffff88003b498d40
 ffff88003b4990d8 ffff88003b4990d0 00000000001d21c0 00000000001d21c0
Call Trace:
 [<ffffffffa013e958>] xlog_wait+0x60/0x78 [xfs]
 [<ffffffff810404de>] ? default_wake_function+0x0/0x14
 [<ffffffff81373c5f>] ? _raw_spin_lock+0x62/0x69
 [<ffffffffa013f874>] xlog_state_get_iclog_space+0x9e/0x22c [xfs]
 [<ffffffffa013fb73>] xlog_write+0x171/0x4ae [xfs]
 [<ffffffffa0150df7>] ? kmem_alloc+0x69/0xb1 [xfs]
 [<ffffffff810fad18>] ? __kmalloc+0x14e/0x160
 [<ffffffffa013ff04>] xfs_log_write+0x54/0x7e [xfs]
 [<ffffffffa014b5b0>] xfs_trans_commit_iclog+0x195/0x2d8 [xfs]
 [<ffffffff81070c11>] ? mark_held_locks+0x52/0x70
 [<ffffffff810fa9f7>] ? kmem_cache_alloc+0xd1/0x145
 [<ffffffff81070e9d>] ? trace_hardirqs_on_caller+0x11d/0x141
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa014b7bc>] _xfs_trans_commit+0xc9/0x206 [xfs]
 [<ffffffffa011c5fa>] xfs_bmap_finish+0x87/0x16a [xfs]
 [<ffffffffa01389b9>] xfs_itruncate_finish+0x19e/0x2bd [xfs]
 [<ffffffffa014f202>] xfs_free_eofblocks+0x1ac/0x1f1 [xfs]
 [<ffffffffa014f707>] xfs_inactive+0x108/0x3a6 [xfs]
 [<ffffffff8106ff27>] ? lockdep_init_map+0xa6/0x11b
 [<ffffffffa015a87f>] xfs_fs_evict_inode+0xf6/0xfe [xfs]
 [<ffffffff81114766>] evict+0x24/0x8c
 [<ffffffff811147ff>] dispose_list+0x31/0xaf
 [<ffffffff81114e92>] shrink_icache_memory+0x1e5/0x215
 [<ffffffff810d1e14>] shrink_slab+0xe0/0x164
 [<ffffffff810d3282>] try_to_free_pages+0x27f/0x495
 [<ffffffff810cb3fc>] __alloc_pages_nodemask+0x4e3/0x767
 [<ffffffff810700a3>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff810f5b14>] alloc_pages_current+0xa7/0xca
 [<ffffffff810c515c>] __page_cache_alloc+0x85/0x8c
 [<ffffffff810cd420>] __do_page_cache_readahead+0xdb/0x1df
 [<ffffffff8106fa35>] ? lock_release_holdtime+0x2c/0xd7
 [<ffffffff810cd545>] ra_submit+0x21/0x25
 [<ffffffff810cd92c>] ondemand_readahead+0x1e3/0x1f6
 [<ffffffff810cd9b8>] page_cache_async_readahead+0x79/0x82
 [<ffffffff810c6633>] filemap_fault+0xc6/0x396
 [<ffffffff81070ece>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff810e15e7>] __do_fault+0x54/0x354
 [<ffffffff810709bf>] ? mark_lock+0x2d/0x22d
 [<ffffffff810e2493>] handle_pte_fault+0x2cf/0x6e8
 [<ffffffff810e004e>] ? __pte_alloc+0xc3/0xd0
 [<ffffffff810e2986>] handle_mm_fault+0xda/0xed
 [<ffffffff81377c28>] do_page_fault+0x3b4/0x3d6
 [<ffffffff810700a3>] ? trace_hardirqs_off_caller+0x1f/0x9e
 [<ffffffff8107012f>] ? trace_hardirqs_off+0xd/0xf
 [<ffffffff81065a7a>] ? local_clock+0x41/0x5a
 [<ffffffff813739e6>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81374be5>] page_fault+0x25/0x30

And here is the summary of all the locks (via sysrq-t):

Showing all locks held in the system:
2 locks held by kworker/0:1/10:
 #0:  (xfsdatad){++++..}, at: [<ffffffff81059fba>] process_one_work+0x18a/0x37f
 #1:  ((&ioend->io_work)){+.+...}, at: [<ffffffff81059fba>] process_one_work+0x18a/0x37f
4 locks held by kswapd0/23:
 #0:  (shrinker_rwsem){++++..}, at: [<ffffffff810d1d71>] shrink_slab+0x3d/0x164
 #1:  (iprune_sem){++++.-}, at: [<ffffffff81114cf7>] shrink_icache_memory+0x4a/0x215
 #2:  (xfs_iolock_reclaimable){+.+.-.}, at: [<ffffffffa013615d>] xfs_ilock+0x30/0xb9 [xfs]
 #3:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by multipathd/659:
 #0:  (&u->readlock){+.+.+.}, at: [<ffffffff813533dd>] unix_dgram_recvmsg+0x5a/0x27f
5 locks held by NetworkManager/958:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81377a36>] do_page_fault+0x1c2/0x3d6
 #1:  (shrinker_rwsem){++++..}, at: [<ffffffff810d1d71>] shrink_slab+0x3d/0x164
 #2:  (iprune_sem){++++.-}, at: [<ffffffff81114cf7>] shrink_icache_memory+0x4a/0x215
 #3:  (xfs_iolock_reclaimable){+.+.-.}, at: [<ffffffffa013615d>] xfs_ilock+0x30/0xb9 [xfs]
 #4:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by agetty/1099:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by mingetty/1101:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by mingetty/1103:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by mingetty/1105:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by mingetty/1107:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by mingetty/1109:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by mingetty/1111:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
1 lock held by bash/1313:
 #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8123c132>] n_tty_read+0x284/0x7ba
2 locks held by ffsb/1355:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1358:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by ffsb/1359:
 #0:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1362:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1364:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1365:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1366:
 #0:  (xfs_iolock_active){++++.+}, at: [<ffffffffa0136079>] xfs_ilock_nowait+0x2b/0xdf [xfs]
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1367:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by ffsb/1368:
 #0:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1371:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1372:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1373:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1374:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1375:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1376:
 #0:  (xfs_iolock_active){++++.+}, at: [<ffffffffa0136079>] xfs_ilock_nowait+0x2b/0xdf [xfs]
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1377:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1378:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1380:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1381:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1383:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
4 locks held by ffsb/1384:
 #0:  (&sb->s_type->i_mutex_key#13/1){+.+.+.}, at: [<ffffffff8110b9ba>] do_unlinkat+0x67/0x165
 #1:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81109eaf>] vfs_unlink+0x4f/0xcc
 #2:  (&(&ip->i_lock)->mr_lock/2){+.+...}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
 #3:  (&(&ip->i_lock)->mr_lock/3){+.+...}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1385:
 #0:  (xfs_iolock_active){++++.+}, at: [<ffffffffa0136079>] xfs_ilock_nowait+0x2b/0xdf [xfs]
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1386:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1387:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1388:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: 
2 locks held by ffsb/1389:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by ffsb/1390:
 #0:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1391:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1392:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1393:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by ffsb/1394:
 #0:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1395:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1396:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1397:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1398:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1399:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1400:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1402:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1403:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
1 lock held by ffsb/1404:
 #0:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1405:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1406:
 #0:  (xfs_iolock_active){++++.+}, at: [<ffffffffa0136079>] xfs_ilock_nowait+0x2b/0xdf [xfs]
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1407:
 #0:  (xfs_iolock_active){++++.+}, at: [<ffffffffa0136079>] xfs_ilock_nowait+0x2b/0xdf [xfs]
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1409:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1410:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1411:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1412:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1413:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1414:
 #0:  (xfs_iolock_active){++++.+}, at: [<ffffffffa0136079>] xfs_ilock_nowait+0x2b/0xdf [xfs]
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1416:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by ffsb/1417:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81122a7e>] vfs_fsync_range+0x47/0x7c
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
3 locks held by ffsb/1418:
 #0:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff8110a688>] do_last+0xb8/0x2f9
 #1:  (&(&ip->i_lock)->mr_lock/1){+.+.+.}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
 #2:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa01360a7>] xfs_ilock_nowait+0x59/0xdf [xfs]
2 locks held by flush-253:0/1350:
 #0:  (&type->s_umount_key#24){.+.+.+}, at: [<ffffffff8111f509>] writeback_inodes_wb+0xce/0x13d
 #1:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
5 locks held by git/1471:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81377a36>] do_page_fault+0x1c2/0x3d6
 #1:  (shrinker_rwsem){++++..}, at: [<ffffffff810d1d71>] shrink_slab+0x3d/0x164
 #2:  (iprune_sem){++++.-}, at: [<ffffffff81114cf7>] shrink_icache_memory+0x4a/0x215
 #3:  (xfs_iolock_reclaimable){+.+.-.}, at: [<ffffffffa013615d>] xfs_ilock+0x30/0xb9 [xfs]
 #4:  (&(&ip->i_lock)->mr_lock){++++--}, at: [<ffffffffa0136190>] xfs_ilock+0x63/0xb9 [xfs]
2 locks held by bash/1472:
 #0:  (sysrq_key_table_lock){......}, at: [<ffffffff81242275>] __handle_sysrq+0x28/0x15c
 #1:  (tasklist_lock){.+.+..}, at: [<ffffffff8107062c>] debug_show_all_locks+0x52/0x19b
