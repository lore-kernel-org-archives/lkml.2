Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2FMMjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:39:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:19814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab2FMMjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:39:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165107935"
Date: Wed, 13 Jun 2012 20:39:32 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: xfs ip->i_lock: inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W}
 usage
Message-ID: <20120613123932.GA1445@localhost>
References: <20120612012134.GA7706@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612012134.GA7706@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph, Dave,

I got this lockdep warning on XFS when running the xfs tests:

[  704.832019] =================================
[  704.832019] [ INFO: inconsistent lock state ]
[  704.832019] 3.5.0-rc1+ #8 Tainted: G        W   
[  704.832019] ---------------------------------
[  704.832019] inconsistent {IN-RECLAIM_FS-W} -> {RECLAIM_FS-ON-W} usage.
[  704.832019] fsstress/11619 [HC0[0]:SC0[0]:HE1:SE1] takes:
[  704.832019]  (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff8143953d>] xfs_ilock_nowait+0xd7/0x1d0
[  704.832019] {IN-RECLAIM_FS-W} state was registered at:
[  704.832019]   [<ffffffff810e30a2>] mark_irqflags+0x12d/0x13e
[  704.832019]   [<ffffffff810e32f6>] __lock_acquire+0x243/0x3f9
[  704.832019]   [<ffffffff810e3a1c>] lock_acquire+0x112/0x13d
[  704.832019]   [<ffffffff810b8931>] down_write_nested+0x54/0x8b
[  704.832019]   [<ffffffff81438fab>] xfs_ilock+0xd8/0x17d
[  704.832019]   [<ffffffff814431b8>] xfs_reclaim_inode+0x4a/0x2cb
[  704.832019]   [<ffffffff814435ee>] xfs_reclaim_inodes_ag+0x1b5/0x28e
[  704.832019]   [<ffffffff814437d7>] xfs_reclaim_inodes_nr+0x33/0x3a
[  704.832019]   [<ffffffff8144050e>] xfs_fs_free_cached_objects+0x15/0x17
[  704.832019]   [<ffffffff81196076>] prune_super+0x103/0x154
[  704.832019]   [<ffffffff81152fa7>] shrink_slab+0x1ec/0x316
[  704.832019]   [<ffffffff8115574f>] balance_pgdat+0x308/0x618
[  704.832019]   [<ffffffff81155c22>] kswapd+0x1c3/0x1dc
[  704.832019]   [<ffffffff810b3f77>] kthread+0xaf/0xb7
[  704.832019]   [<ffffffff82f480b4>] kernel_thread_helper+0x4/0x10
[  704.832019] irq event stamp: 105253
[  704.832019] hardirqs last  enabled at (105253): [<ffffffff8114b693>] get_page_from_freelist+0x403/0x4e1
[  704.832019] hardirqs last disabled at (105252): [<ffffffff8114b55d>] get_page_from_freelist+0x2cd/0x4e1
[  704.832019] softirqs last  enabled at (104506): [<ffffffff81099e7e>] __do_softirq+0x239/0x24f
[  704.832019] softirqs last disabled at (104451): [<ffffffff82f481ac>] call_softirq+0x1c/0x30
[  704.832019] 
[  704.832019] other info that might help us debug this:
[  704.832019]  Possible unsafe locking scenario:
[  704.832019] 
[  704.832019]        CPU0
[  704.832019]        ----
[  704.832019]   lock(&(&ip->i_lock)->mr_lock);
[  704.832019]   <Interrupt>
[  704.832019]     lock(&(&ip->i_lock)->mr_lock);
[  704.832019] 
[  704.832019]  *** DEADLOCK ***
[  704.832019] 
[  704.832019] 3 locks held by fsstress/11619:
[  704.832019]  #0:  (&type->i_mutex_dir_key#4/1){+.+.+.}, at: [<ffffffff8119eadc>] kern_path_create+0x7d/0x11e
[  704.832019]  #1:  (&(&ip->i_lock)->mr_lock/1){+.+.+.}, at: [<ffffffff81438fab>] xfs_ilock+0xd8/0x17d
[  704.832019]  #2:  (&(&ip->i_lock)->mr_lock){++++?.}, at: [<ffffffff8143953d>] xfs_ilock_nowait+0xd7/0x1d0
[  704.832019] 
[  704.832019] stack backtrace:
[  704.832019] Pid: 11619, comm: fsstress Tainted: G        W    3.5.0-rc1+ #8
[  704.832019] Call Trace:
[  704.832019]  [<ffffffff82e92243>] print_usage_bug+0x1f5/0x206
[  704.832019]  [<ffffffff810e2220>] ? check_usage_forwards+0xa6/0xa6
[  704.832019]  [<ffffffff82e922c3>] mark_lock_irq+0x6f/0x120
[  704.832019]  [<ffffffff810e2f02>] mark_lock+0xaf/0x122
[  704.832019]  [<ffffffff810e3d4e>] mark_held_locks+0x6d/0x95
[  704.832019]  [<ffffffff810c5cd1>] ? local_clock+0x36/0x4d
[  704.832019]  [<ffffffff810e3de3>] __lockdep_trace_alloc+0x6d/0x6f
[  704.832019]  [<ffffffff810e42e7>] lockdep_trace_alloc+0x3d/0x57
[  704.832019]  [<ffffffff811837c8>] kmem_cache_alloc_node_trace+0x47/0x1b4
[  704.832019]  [<ffffffff810e377d>] ? lock_release_nested+0x9f/0xa6
[  704.832019]  [<ffffffff81431650>] ? _xfs_buf_find+0xaa/0x302
[  704.832019]  [<ffffffff811710a2>] ? new_vmap_block.constprop.18+0x3a/0x1de
[  704.832019]  [<ffffffff811710a2>] new_vmap_block.constprop.18+0x3a/0x1de
[  704.832019]  [<ffffffff8117144a>] vb_alloc.constprop.16+0x204/0x225
[  704.832019]  [<ffffffff8117149d>] vm_map_ram+0x32/0xaa
[  704.832019]  [<ffffffff81430c95>] _xfs_buf_map_pages+0xb3/0xf5
[  704.832019]  [<ffffffff81431a6a>] xfs_buf_get+0xd3/0x1ac
[  704.832019]  [<ffffffff81492dd9>] xfs_trans_get_buf+0x180/0x244
[  704.832019]  [<ffffffff8146947a>] xfs_da_do_buf+0x2a0/0x5cc
[  704.832019]  [<ffffffff81469826>] xfs_da_get_buf+0x21/0x23
[  704.832019]  [<ffffffff8146f894>] xfs_dir2_data_init+0x44/0xf9
[  704.832019]  [<ffffffff8146e94f>] xfs_dir2_sf_to_block+0x1ef/0x5d8
[  704.832019]  [<ffffffff81475a0e>] ? xfs_dir2_sfe_get_ino+0x1a/0x1c
[  704.832019]  [<ffffffff81475ed1>] ? xfs_dir2_sf_check.isra.18+0xc2/0x14e
[  704.832019]  [<ffffffff81476d37>] ? xfs_dir2_sf_lookup+0x26f/0x27e
[  704.832019]  [<ffffffff81476f7f>] xfs_dir2_sf_addname+0x239/0x2c0
[  704.832019]  [<ffffffff8146cfb6>] xfs_dir_createname+0x118/0x177
[  704.832019]  [<ffffffff81445eec>] xfs_create+0x3c6/0x594
[  704.832019]  [<ffffffff8143db9e>] xfs_vn_mknod+0xd8/0x165
[  704.832019]  [<ffffffff8119f02d>] vfs_mknod+0xa3/0xc5
[  704.832019]  [<ffffffff8119ebca>] ? user_path_create+0x4d/0x58
[  704.832019]  [<ffffffff811a05b6>] sys_mknodat+0x16b/0x1bb
[  704.832019]  [<ffffffff816f521e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  704.832019]  [<ffffffff811a0623>] sys_mknod+0x1d/0x1f
[  704.832019]  [<ffffffff82f46c69>] system_call_fastpath+0x16/0x1b

Thanks,
Fengguang
