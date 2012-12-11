Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2LKPmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:42:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2LKPmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:42:12 -0500
Date: Tue, 11 Dec 2012 10:42:07 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com
Subject: 3.7 XFS lockdep trace
Message-ID: <20121211154207.GA12771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This says rc8+, but it's just missing the Makefile change, so it's still there in 3.7
Curious that firefox was the process mentioned here, as ~/.mozilla isn't on xfs.
My only xfs partition is /data holding a kernel source tree & .ccache

	Dave


[30557.769727] =========================================================
[30557.770098] [ INFO: possible irq lock inversion dependency detected ]
[30557.770451] 3.7.0-rc8+ #3 Not tainted
[30557.770655] ---------------------------------------------------------
[30557.771006] firefox/17386 just changed the state of lock:
[30557.771303] blocked:  (sb_internal#3){.+.+.?}, instance: ffff8800c4ed5d58, at: [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.772028] but this lock took another, RECLAIM_FS-unsafe lock in the past:
[30557.772405]  (&(&ip->i_lock)->mr_lock/1){+.+.+.}

and interrupts could create inverse lock ordering between them.

[30557.773034] 
other info that might help us debug this:
[30557.773386]  Possible interrupt unsafe locking scenario:

[30557.773757]        CPU0                    CPU1
[30557.774007]        ----                    ----
[30557.774257]   lock(&(&ip->i_lock)->mr_lock/1);
[30557.774532]                                local_irq_disable();
[30557.774854]                                lock(sb_internal#3);
[30557.775206]                                lock(&(&ip->i_lock)->mr_lock/1);
[30557.775610]   <Interrupt>
[30557.775770]     lock(sb_internal#3);
[30557.776005] 
 *** DEADLOCK ***

[30557.776326] 3 locks on stack by firefox/17386:
[30557.776571]  #0: blocked:  (&mm->mmap_sem){++++++}, instance: ffff8800a823c308, at: [<ffffffff816ac2b3>] __do_page_fault+0x103/0x4f0
[30557.777276]  #1: blocked:  (shrinker_rwsem){++++..}, instance: ffffffff81c49de0, at: [<ffffffff81169ccc>] shrink_slab+0x3c/0x510
[30557.777962]  #2: blocked:  (&type->s_umount_key#42){.+.+.+}, instance: ffff8800c4ed5730, at: [<ffffffff811c24c4>] grab_super_passive+0x44/0x90
[30557.778718] 
the shortest dependencies between 2nd lock and 1st lock:
[30557.779177]  -> (&(&ip->i_lock)->mr_lock/1){+.+.+.} ops: 63645 {
[30557.779562]     HARDIRQ-ON-W at:
[30557.779751]                       [<ffffffff810c5982>] __lock_acquire+0x5d2/0x1ba0
[30557.780174]                       [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.780583]                       [<ffffffff81088000>] down_write_nested+0x60/0xb0
[30557.781005]                       [<ffffffffa053688c>] xfs_ilock+0x18c/0x270 [xfs]
[30557.781439]                       [<ffffffffa0546df5>] xfs_create+0x145/0x6e0 [xfs]
[30557.781901]                       [<ffffffffa053ce36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[30557.782335]                       [<ffffffffa053cf56>] xfs_vn_mkdir+0x16/0x20 [xfs]
[30557.782770]                       [<ffffffff811cd9f6>] vfs_mkdir+0xa6/0x140
[30557.783161]                       [<ffffffff811cf63a>] sys_mkdirat+0x4a/0x80
[30557.783556]                       [<ffffffff811cf689>] sys_mkdir+0x19/0x20
[30557.783972]                       [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.784357]     SOFTIRQ-ON-W at:
[30557.784552]                       [<ffffffff810c59b0>] __lock_acquire+0x600/0x1ba0
[30557.784997]                       [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.785401]                       [<ffffffff81088000>] down_write_nested+0x60/0xb0
[30557.785824]                       [<ffffffffa053688c>] xfs_ilock+0x18c/0x270 [xfs]
[30557.786269]                       [<ffffffffa0546df5>] xfs_create+0x145/0x6e0 [xfs]
[30557.786704]                       [<ffffffffa053ce36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[30557.787160]                       [<ffffffffa053cf56>] xfs_vn_mkdir+0x16/0x20 [xfs]
[30557.787593]                       [<ffffffff811cd9f6>] vfs_mkdir+0xa6/0x140
[30557.788006]                       [<ffffffff811cf63a>] sys_mkdirat+0x4a/0x80
[30557.788397]                       [<ffffffff811cf689>] sys_mkdir+0x19/0x20
[30557.788781]                       [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.789160]     RECLAIM_FS-ON-W at:
[30557.789362]                          [<ffffffff810c8042>] mark_held_locks+0xb2/0x130
[30557.789792]                          [<ffffffff810c8795>] lockdep_trace_alloc+0x75/0xd0
[30557.790241]                          [<ffffffff811af81a>] kmem_cache_alloc_node_trace+0x3a/0x2e0
[30557.790740]                          [<ffffffff81192242>] vm_map_ram+0x2a2/0x7f0
[30557.791161]                          [<ffffffffa052a4c3>] _xfs_buf_map_pages+0x73/0x130 [xfs]
[30557.791646]                          [<ffffffffa052baeb>] xfs_buf_get_map+0x15b/0x270 [xfs]
[30557.792114]                          [<ffffffffa05ada19>] xfs_trans_get_buf_map+0x1d9/0x3b0 [xfs]
[30557.792615]                          [<ffffffffa0589f04>] xfs_ialloc_inode_init+0xe4/0x1f0 [xfs]
[30557.793109]                          [<ffffffffa058aca0>] xfs_ialloc_ag_alloc+0x180/0x550 [xfs]
[30557.793604]                          [<ffffffffa058c1d1>] xfs_dialloc+0x121/0x2d0 [xfs]
[30557.794082]                          [<ffffffffa058d377>] xfs_ialloc+0x57/0x6e0 [xfs]
[30557.794530]                          [<ffffffffa054536a>] xfs_dir_ialloc+0x9a/0x2f0 [xfs]
[30557.794993]                          [<ffffffffa0546e72>] xfs_create+0x1c2/0x6e0 [xfs]
[30557.795437]                          [<ffffffffa053ce36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[30557.795886]                          [<ffffffffa053cf73>] xfs_vn_create+0x13/0x20 [xfs]
[30557.796339]                          [<ffffffff811cdc85>] vfs_create+0xb5/0x120
[30557.796753]                          [<ffffffff811ce657>] do_last+0x967/0xe00
[30557.797162]                          [<ffffffff811cebaf>] path_openat+0xbf/0x510
[30557.797572]                          [<ffffffff811cf2d1>] do_filp_open+0x41/0xa0
[30557.797980]                          [<ffffffff811be3f4>] do_sys_open+0xf4/0x1e0
[30557.798394]                          [<ffffffff811be501>] sys_open+0x21/0x30
[30557.798807]                          [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.799210]     INITIAL USE at:
[30557.799395]                      [<ffffffff810c56b7>] __lock_acquire+0x307/0x1ba0
[30557.799835]                      [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.800235]                      [<ffffffff81088000>] down_write_nested+0x60/0xb0
[30557.800653]                      [<ffffffffa053688c>] xfs_ilock+0x18c/0x270 [xfs]
[30557.801074]                      [<ffffffffa0546df5>] xfs_create+0x145/0x6e0 [xfs]
[30557.801501]                      [<ffffffffa053ce36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[30557.801936]                      [<ffffffffa053cf56>] xfs_vn_mkdir+0x16/0x20 [xfs]
[30557.802363]                      [<ffffffff811cd9f6>] vfs_mkdir+0xa6/0x140
[30557.802764]                      [<ffffffff811cf63a>] sys_mkdirat+0x4a/0x80
[30557.803163]                      [<ffffffff811cf689>] sys_mkdir+0x19/0x20
[30557.803541]                      [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.803920]   }
[30557.804020]   ... key      at: [<ffffffffa05ecb59>] __key.46175+0x1/0xfffffffffffc94a8 [xfs]
[30557.804487]   ... acquired at:
[30557.804658]    [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.804976]    [<ffffffff81088000>] down_write_nested+0x60/0xb0
[30557.805311]    [<ffffffffa053688c>] xfs_ilock+0x18c/0x270 [xfs]
[30557.805650]    [<ffffffffa0546df5>] xfs_create+0x145/0x6e0 [xfs]
[30557.806017]    [<ffffffffa053ce36>] xfs_vn_mknod+0xa6/0x1b0 [xfs]
[30557.806375]    [<ffffffffa053cf56>] xfs_vn_mkdir+0x16/0x20 [xfs]
[30557.806721]    [<ffffffff811cd9f6>] vfs_mkdir+0xa6/0x140
[30557.807020]    [<ffffffff811cf63a>] sys_mkdirat+0x4a/0x80
[30557.807329]    [<ffffffff811cf689>] sys_mkdir+0x19/0x20
[30557.807620]    [<ffffffff816b1040>] tracesys+0xdd/0xe2

[30557.808001] -> (sb_internal#3){.+.+.?} ops: 1484875 {
[30557.808332]    HARDIRQ-ON-R at:
[30557.808524]                     [<ffffffff810c5898>] __lock_acquire+0x4e8/0x1ba0
[30557.808959]                     [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.809354]                     [<ffffffff811c11f7>] __sb_start_write+0xd7/0x1d0
[30557.809767]                     [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.810209]                     [<ffffffffa053ca1a>] xfs_vn_update_time+0x4a/0x280 [xfs]
[30557.810667]                     [<ffffffff811da345>] update_time+0x25/0xc0
[30557.811053]                     [<ffffffff811da5c2>] touch_atime+0xf2/0x140
[30557.811443]                     [<ffffffff811d22dd>] vfs_readdir+0xcd/0xf0
[30557.811846]                     [<ffffffff811d241f>] sys_getdents+0x8f/0x120
[30557.812239]                     [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.812613]    SOFTIRQ-ON-R at:
[30557.812797]                     [<ffffffff810c59b0>] __lock_acquire+0x600/0x1ba0
[30557.813205]                     [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.813596]                     [<ffffffff811c11f7>] __sb_start_write+0xd7/0x1d0
[30557.814015]                     [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.814455]                     [<ffffffffa053ca1a>] xfs_vn_update_time+0x4a/0x280 [xfs]
[30557.814938]                     [<ffffffff811da345>] update_time+0x25/0xc0
[30557.815323]                     [<ffffffff811da5c2>] touch_atime+0xf2/0x140
[30557.815709]                     [<ffffffff811d22dd>] vfs_readdir+0xcd/0xf0
[30557.816094]                     [<ffffffff811d241f>] sys_getdents+0x8f/0x120
[30557.816487]                     [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.816858]    IN-RECLAIM_FS-R at:
[30557.817060]                        [<ffffffff810c58fc>] __lock_acquire+0x54c/0x1ba0
[30557.817486]                        [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.817912]                        [<ffffffff811c11f7>] __sb_start_write+0xd7/0x1d0
[30557.818334]                        [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.818796]                        [<ffffffffa0545d6d>] xfs_free_eofblocks+0xed/0x250 [xfs]
[30557.819268]                        [<ffffffffa05466dc>] xfs_inactive+0x19c/0x550 [xfs]
[30557.819728]                        [<ffffffffa0540717>] xfs_fs_evict_inode+0xa7/0x1c0 [xfs]
[30557.820214]                        [<ffffffff811dacd7>] evict+0xa7/0x1a0
[30557.820588]                        [<ffffffff811dae0e>] dispose_list+0x3e/0x60
[30557.821003]                        [<ffffffff811dbcfb>] prune_icache_sb+0x16b/0x320
[30557.821427]                        [<ffffffff811c25f5>] prune_super+0xe5/0x1b0
[30557.821826]                        [<ffffffff81169dfb>] shrink_slab+0x16b/0x510
[30557.822234]                        [<ffffffff8116cc2a>] do_try_to_free_pages+0x22a/0x570
[30557.822684]                        [<ffffffff8116d140>] try_to_free_pages+0xe0/0x320
[30557.823125]                        [<ffffffff81160556>] __alloc_pages_nodemask+0x736/0xb90
[30557.823589]                        [<ffffffff811a2956>] alloc_pages_vma+0xb6/0x190
[30557.824029]                        [<ffffffff811b7076>] do_huge_pmd_anonymous_page+0x146/0x340
[30557.824500]                        [<ffffffff81184385>] handle_mm_fault+0x265/0x2f0
[30557.824925]                        [<ffffffff816ac31d>] __do_page_fault+0x16d/0x4f0
[30557.825352]                        [<ffffffff816ac6cb>] do_page_fault+0x2b/0x50
[30557.825757]                        [<ffffffff816a8fe8>] page_fault+0x28/0x30
[30557.826154]    RECLAIM_FS-ON-R at:
[30557.826351]                        [<ffffffff810c8042>] mark_held_locks+0xb2/0x130
[30557.826793]                        [<ffffffff810c8795>] lockdep_trace_alloc+0x75/0xd0
[30557.827235]                        [<ffffffff811ad03f>] kmem_cache_alloc+0x2f/0x2a0
[30557.827667]                        [<ffffffffa0549fe7>] kmem_zone_alloc+0x67/0xf0 [xfs]
[30557.828146]                        [<ffffffffa054a08d>] kmem_zone_zalloc+0x1d/0x50 [xfs]
[30557.828609]                        [<ffffffffa059f537>] _xfs_trans_alloc+0x37/0xa0 [xfs]
[30557.829097]                        [<ffffffffa059f5dd>] xfs_trans_alloc+0x3d/0x50 [xfs]
[30557.829560]                        [<ffffffffa053ca1a>] xfs_vn_update_time+0x4a/0x280 [xfs]
[30557.830064]                        [<ffffffff811da345>] update_time+0x25/0xc0
[30557.830463]                        [<ffffffff811da5c2>] touch_atime+0xf2/0x140
[30557.830886]                        [<ffffffff811d22dd>] vfs_readdir+0xcd/0xf0
[30557.831294]                        [<ffffffff811d241f>] sys_getdents+0x8f/0x120
[30557.831716]                        [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.832121]    INITIAL USE at:
[30557.832303]                    [<ffffffff810c56b7>] __lock_acquire+0x307/0x1ba0
[30557.832726]                    [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.833131]                    [<ffffffff811c11f7>] __sb_start_write+0xd7/0x1d0
[30557.833550]                    [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.834020]                    [<ffffffffa053ca1a>] xfs_vn_update_time+0x4a/0x280 [xfs]
[30557.834483]                    [<ffffffff811da345>] update_time+0x25/0xc0
[30557.834891]                    [<ffffffff811da5c2>] touch_atime+0xf2/0x140
[30557.835279]                    [<ffffffff811d22dd>] vfs_readdir+0xcd/0xf0
[30557.835671]                    [<ffffffff811d241f>] sys_getdents+0x8f/0x120
[30557.836072]                    [<ffffffff816b1040>] tracesys+0xdd/0xe2
[30557.836442]  }
[30557.836541]  ... key      at: [<ffffffffa05e4580>] xfs_fs_type+0x60/0xfffffffffffd1ae0 [xfs]
[30557.837048]  ... acquired at:
[30557.837217]    [<ffffffff810c4a36>] check_usage_forwards+0x136/0x140
[30557.837590]    [<ffffffff810c5276>] mark_lock+0x176/0x2b0
[30557.837898]    [<ffffffff810c58fc>] __lock_acquire+0x54c/0x1ba0
[30557.838237]    [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.838551]    [<ffffffff811c11f7>] __sb_start_write+0xd7/0x1d0
[30557.838903]    [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.839269]    [<ffffffffa0545d6d>] xfs_free_eofblocks+0xed/0x250 [xfs]
[30557.839652]    [<ffffffffa05466dc>] xfs_inactive+0x19c/0x550 [xfs]
[30557.840020]    [<ffffffffa0540717>] xfs_fs_evict_inode+0xa7/0x1c0 [xfs]
[30557.840401]    [<ffffffff811dacd7>] evict+0xa7/0x1a0
[30557.840697]    [<ffffffff811dae0e>] dispose_list+0x3e/0x60
[30557.841021]    [<ffffffff811dbcfb>] prune_icache_sb+0x16b/0x320
[30557.841356]    [<ffffffff811c25f5>] prune_super+0xe5/0x1b0
[30557.841678]    [<ffffffff81169dfb>] shrink_slab+0x16b/0x510
[30557.842006]    [<ffffffff8116cc2a>] do_try_to_free_pages+0x22a/0x570
[30557.842368]    [<ffffffff8116d140>] try_to_free_pages+0xe0/0x320
[30557.842727]    [<ffffffff81160556>] __alloc_pages_nodemask+0x736/0xb90
[30557.843098]    [<ffffffff811a2956>] alloc_pages_vma+0xb6/0x190
[30557.843433]    [<ffffffff811b7076>] do_huge_pmd_anonymous_page+0x146/0x340
[30557.843840]    [<ffffffff81184385>] handle_mm_fault+0x265/0x2f0
[30557.844177]    [<ffffffff816ac31d>] __do_page_fault+0x16d/0x4f0
[30557.844511]    [<ffffffff816ac6cb>] do_page_fault+0x2b/0x50
[30557.844848]    [<ffffffff816a8fe8>] page_fault+0x28/0x30

[30557.845239] 
stack backtrace:
[30557.845488] Pid: 17386, comm: firefox Not tainted 3.7.0-rc8+ #3
[30557.845836] Call Trace:
[30557.845979]  [<ffffffff8169bb6b>] print_irq_inversion_bug.part.41+0x1b0/0x1bf
[30557.846380]  [<ffffffff810c4a36>] check_usage_forwards+0x136/0x140
[30557.846747]  [<ffffffff810c4900>] ? check_usage_backwards+0x130/0x130
[30557.847103]  [<ffffffff810c5276>] mark_lock+0x176/0x2b0
[30557.847388]  [<ffffffff810c58fc>] __lock_acquire+0x54c/0x1ba0
[30557.847723]  [<ffffffff8109b77d>] ? sched_clock_cpu+0xcd/0x120
[30557.848075]  [<ffffffffa058ff37>] ? xfs_iext_bno_to_ext+0x97/0x170 [xfs]
[30557.848514]  [<ffffffffa056cfa8>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
[30557.848879]  [<ffffffff810c7631>] lock_acquire+0xa1/0x200
[30557.849194]  [<ffffffffa059f5cd>] ? xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.849542]  [<ffffffff811c11f7>] __sb_start_write+0xd7/0x1d0
[30557.849889]  [<ffffffffa059f5cd>] ? xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.850235]  [<ffffffff810c204e>] ? put_lock_stats.isra.25+0xe/0x40
[30557.850607]  [<ffffffffa059f5cd>] ? xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.850977]  [<ffffffffa059f5cd>] xfs_trans_alloc+0x2d/0x50 [xfs]
[30557.851323]  [<ffffffffa0545d6d>] xfs_free_eofblocks+0xed/0x250 [xfs]
[30557.851695]  [<ffffffff810c204e>] ? put_lock_stats.isra.25+0xe/0x40
[30557.852057]  [<ffffffffa05466dc>] xfs_inactive+0x19c/0x550 [xfs]
[30557.852394]  [<ffffffff816a86e1>] ? _raw_spin_unlock_irq+0x41/0x70
[30557.852777]  [<ffffffffa0540717>] xfs_fs_evict_inode+0xa7/0x1c0 [xfs]
[30557.853137]  [<ffffffff811dacd7>] evict+0xa7/0x1a0
[30557.853407]  [<ffffffff811dae0e>] dispose_list+0x3e/0x60
[30557.853722]  [<ffffffff811dbcfb>] prune_icache_sb+0x16b/0x320
[30557.854041]  [<ffffffff811c25f5>] prune_super+0xe5/0x1b0
[30557.854339]  [<ffffffff81169dfb>] shrink_slab+0x16b/0x510
[30557.854651]  [<ffffffff8116cc2a>] do_try_to_free_pages+0x22a/0x570
[30557.855011]  [<ffffffff81168dcf>] ? throttle_direct_reclaim.isra.55+0x8f/0x260
[30557.855412]  [<ffffffff8116d140>] try_to_free_pages+0xe0/0x320
[30557.855753]  [<ffffffff81160556>] __alloc_pages_nodemask+0x736/0xb90
[30557.856106]  [<ffffffff8100a6d9>] ? sched_clock+0x9/0x10
[30557.856402]  [<ffffffff811a2956>] alloc_pages_vma+0xb6/0x190
[30557.856741]  [<ffffffff811b7076>] do_huge_pmd_anonymous_page+0x146/0x340
[30557.857116]  [<ffffffff81184385>] handle_mm_fault+0x265/0x2f0
[30557.857441]  [<ffffffff816ac31d>] __do_page_fault+0x16d/0x4f0
[30557.857774]  [<ffffffff810c26f4>] ? lock_release_holdtime.part.26+0xd4/0x150
[30557.858164]  [<ffffffff8111173e>] ? rcu_eqs_exit_common+0x3e/0x380
[30557.858555]  [<ffffffff8111208b>] ? rcu_user_enter+0x8b/0x100
[30557.858893]  [<ffffffff81111ae5>] ? rcu_eqs_exit+0x65/0xb0
[30557.859197]  [<ffffffff816a8d5c>] ? retint_swapgs+0x13/0x1b
[30557.859505]  [<ffffffff816ac6cb>] do_page_fault+0x2b/0x50
[30557.859823]  [<ffffffff816a8fe8>] page_fault+0x28/0x30

