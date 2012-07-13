Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2GMMuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 08:50:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37966 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756252Ab2GMMuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 08:50:51 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/6g/lDPTL6z4qqNsMyS6mG75gi/PYSfzol7gLn2z
	fO0o5c3z1jejy5
Message-ID: <1342183843.7380.112.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 13 Jul 2012 14:50:43 +0200
In-Reply-To: <20120713104741.GF30128@shiny>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <1342082648.7338.171.camel@marge.simpson.net>
	 <1342086792.7707.9.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121310420.32033@ionos>
	 <1342094233.7707.12.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121514240.32033@ionos>
	 <1342161072.7380.65.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207131142440.32033@ionos>
	 <1342174485.7380.103.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207131223240.32033@ionos> <20120713104741.GF30128@shiny>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-13 at 06:47 -0400, Chris Mason wrote: 
> On Fri, Jul 13, 2012 at 04:26:26AM -0600, Thomas Gleixner wrote:
> > On Fri, 13 Jul 2012, Mike Galbraith wrote:
> > > On Fri, 2012-07-13 at 11:52 +0200, Thomas Gleixner wrote: 
> > > > On Fri, 13 Jul 2012, Mike Galbraith wrote:
> > > > > On Thu, 2012-07-12 at 15:31 +0200, Thomas Gleixner wrote: 
> > > > > > Bingo, that makes it more likely that this is caused by copying w/o
> > > > > > initializing the lock and then freeing the original structure.
> > > > > > 
> > > > > > A quick check for memcpy finds that __btrfs_close_devices() does a
> > > > > > memcpy of btrfs_device structs w/o initializing the lock in the new
> > > > > > copy, but I have no idea whether that's the place we are looking for.
> > > > > 
> > > > > Thanks a bunch Thomas.  I doubt I would have ever figured out that lala
> > > > > land resulted from _copying_ a lock.  That's one I won't be forgetting
> > > > > any time soon.  Box not only survived a few thousand xfstests 006 runs,
> > > > > dbench seemed disinterested in deadlocking virgin 3.0-rt.
> > > > 
> > > > Cute. It think that the lock copying caused the deadlock problem as
> > > > the list pointed to the wrong place, so we might have ended up with
> > > > following down the wrong chain when walking the list as long as the
> > > > original struct was not freed. That beast is freed under RCU so there
> > > > could be a rcu read side critical section fiddling with the old lock
> > > > and cause utter confusion.
> > > 
> > > Virgin 3.0-rt appears to really be solid.  But then it doesn't have
> > > pesky rwlocks.
> > 
> > Ah. So 3.0 is not having those rwlock thingies. Bummer.
> >  
> > > > /me goes and writes a nastigram^W proper changelog
> > > > 
> > > > > btrfs still locks up in my enterprise kernel, so I suppose I had better
> > > > > plug your fix into 3.4-rt and see what happens, and go beat hell out of
> > > > > virgin 3.0-rt again to be sure box really really survives dbench.
> > > > 
> > > > A test against 3.4-rt sans enterprise mess might be nice as well.
> > > 
> > > Enterprise is 3.0-stable with um 555 btrfs patches (oh dear).
> > > 
> > > Virgin 3.4-rt and 3.2-rt deadlock gripe.  Enterprise doesn't gripe, but
> > > deadlocks, so I have another adventure in my future even if I figure out
> > > wth to do about rwlocks.
> > 
> > Hrmpf. /me goes to stare into fs/btrfs/ some more.
> 
> Please post the deadlocks here, I'll help ;)

This is the one from top of thread.  Below that is without the deadlock
detector.

[  692.857165] ============================================
[  692.863963] [ BUG: circular locking deadlock detected! ]
[  692.869264] Not tainted
[  692.871708] --------------------------------------------
[  692.877008] btrfs-delayed-m/1404 is deadlocking current task dbench/7937
[  692.877009] 
[  692.885183] 
[  692.885184] 1) dbench/7937 is trying to acquire this lock:
[  692.892149]  [ffff88014d6aea80] {&(&eb->lock)->lock}
[  692.897102] .. ->owner: ffff880175808501
[  692.901018] .. held by:   btrfs-delayed-m: 1404 [ffff880175808500, 120]
[  692.907657] 
[  692.907657] 2) btrfs-delayed-m/1404 is blocked on this lock:
[  692.914797]  [ffff88014bf58d60] {&(&eb->lock)->lock}
[  692.919751] .. ->owner: ffff880175186101
[  692.923672] .. held by:            dbench: 7937 [ffff880175186100, 120]
[  692.930309] 
[  692.930309] btrfs-delayed-m/1404's [blocked] stackdump:
[  692.930310] 
[  692.938504]  ffff880177575aa0 0000000000000046 ffff88014bf58d60 000000000000fb00
[  692.938507]  000000000000fb00 ffff880177575fd8 000000000000fb00 ffff880177574000
[  692.938509]  ffff880177575fd8 000000000000fb00 ffff88017662f240 ffff880175808500
[  692.960635] Call Trace:
[  692.963085]  [<ffffffff814c68e9>] schedule+0x29/0x90
[  692.963087]  [<ffffffff814c745d>] rt_spin_lock_slowlock+0xfd/0x330
[  692.963090]  [<ffffffff814c7a39>] __rt_spin_lock+0x9/0x10
[  692.963092]  [<ffffffff814c7b27>] rt_read_lock+0x27/0x40
[  692.963096]  [<ffffffff812550cf>] btrfs_clear_lock_blocking_rw+0x6f/0x180
[  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70
[  692.963102]  [<ffffffff81200342>] btrfs_search_slot+0x6b2/0x810
[  692.963105]  [<ffffffff812148da>] btrfs_lookup_inode+0x2a/0xa0
[  692.963107]  [<ffffffff814c7312>] ? rt_mutex_lock+0x12/0x20
[  692.963111]  [<ffffffff8126d0bc>] btrfs_update_delayed_inode+0x6c/0x160
[  692.963113]  [<ffffffff814c7ab9>] ? _mutex_unlock+0x9/0x10
[  692.963116]  [<ffffffff8126e142>] btrfs_async_run_delayed_node_done+0x182/0x1a0
[  692.963119]  [<ffffffff8124ed5f>] worker_loop+0xaf/0x430
[  692.963121]  [<ffffffff8124ecb0>] ? btrfs_queue_worker+0x1e0/0x1e0
[  692.963123]  [<ffffffff8124ecb0>] ? btrfs_queue_worker+0x1e0/0x1e0
[  692.963127]  [<ffffffff8105850e>] kthread+0xae/0xc0
[  692.963129]  [<ffffffff814c68e9>] ? schedule+0x29/0x90
[  692.963133]  [<ffffffff810015bc>] ? __switch_to+0x14c/0x410
[  692.963137]  [<ffffffff81061e44>] ? finish_task_switch+0x54/0xd0
[  692.963140]  [<ffffffff814ceca4>] kernel_thread_helper+0x4/0x10
[  692.963143]  [<ffffffff81058460>] ? __init_kthread_worker+0x50/0x50
[  692.963145]  [<ffffffff814ceca0>] ? gs_change+0x13/0x13
[  692.963146] 
[  692.963147] dbench/7937's [current] stackdump:
[  692.963147] 
[  693.098724] Pid: 7937, comm: dbench Not tainted 3.4.4-rt13 #25
[  693.104544] Call Trace:
[  693.106993]  [<ffffffff8108b436>] debug_rt_mutex_print_deadlock+0x176/0x190
[  693.106995]  [<ffffffff814c74ec>] rt_spin_lock_slowlock+0x18c/0x330
[  693.106998]  [<ffffffff814c7a39>] __rt_spin_lock+0x9/0x10
[  693.107000]  [<ffffffff814c7b27>] rt_read_lock+0x27/0x40
[  693.107002]  [<ffffffff8125538c>] btrfs_try_tree_read_lock+0x4c/0x80
[  693.107004]  [<ffffffff812001bd>] btrfs_search_slot+0x52d/0x810
[  693.107007]  [<ffffffff812027ba>] btrfs_next_leaf+0xea/0x440
[  693.107010]  [<ffffffff81238ed8>] ? btrfs_token_dir_data_len+0x58/0xd0
[  693.107012]  [<ffffffff81238ed8>] ? btrfs_token_dir_data_len+0x58/0xd0
[  693.107016]  [<ffffffff81222e17>] btrfs_real_readdir+0x247/0x610
[  693.107020]  [<ffffffff81131350>] ? sys_ioctl+0xa0/0xa0
[  693.107022]  [<ffffffff81131350>] ? sys_ioctl+0xa0/0xa0
[  693.107024]  [<ffffffff81131660>] vfs_readdir+0xb0/0xd0
[  693.107026]  [<ffffffff81131840>] sys_getdents64+0x80/0xe0
[  693.107030]  [<ffffffff814cd9b9>] system_call_fastpath+0x16/0x1b
[  693.107032] [ turning off deadlock detection.Please report this trace. ]
[  693.107033] 


[  679.476016] SysRq : Show Blocked State
[  679.479781]   task                        PC stack   pid father
[  679.485708] btrfs-endio-wri D ffffffff81605920     0  1314      2 0x00000000
[  679.492785]  ffff880172939810 0000000000000046 ffff8801774ca538 000000000000f7c0
[  679.492789]  000000000000f7c0 ffff880172939fd8 ffff880172938000 000000000000f7c0
[  679.492792]  ffff880172939fd8 000000000000f7c0 ffff88017a4caa60 ffff8801744a88e0
[  679.514922] Call Trace:
[  679.517374]  [<ffffffff814ca569>] schedule+0x29/0x90
[  679.517378]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  679.517382]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  679.517384]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  679.517388]  [<ffffffff81257d5d>] btrfs_tree_read_lock+0x5d/0x160
[  679.517392]  [<ffffffff812e46c6>] ? cpumask_next_and+0x36/0x50
[  679.517397]  [<ffffffff811fd863>] btrfs_read_lock_root_node+0x33/0x40
[  679.517400]  [<ffffffff81202919>] btrfs_search_slot+0x459/0x810
[  679.517404]  [<ffffffff8110dd60>] ? poison_obj+0x30/0x50
[  679.517409]  [<ffffffff81215957>] btrfs_lookup_file_extent+0x37/0x40
[  679.517412]  [<ffffffff811fd375>] ? btrfs_alloc_path+0x15/0x20
[  679.517417]  [<ffffffff81231bce>] btrfs_drop_extents+0xfe/0xa70
[  679.517421]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  679.517424]  [<ffffffff81066bb4>] ? migrate_enable+0xf4/0x1d0
[  679.517429]  [<ffffffff8110eb81>] ? cache_alloc_debugcheck_after+0x101/0x1a0
[  679.517432]  [<ffffffff81110545>] ? kmem_cache_alloc+0x1d5/0x200
[  679.517436]  [<ffffffff81224add>] insert_reserved_file_extent.clone.0+0x7d/0x270
[  679.517440]  [<ffffffff812218ab>] ? start_transaction+0x8b/0x290
[  679.517443]  [<ffffffff8122847e>] btrfs_finish_ordered_io+0x32e/0x3b0
[  679.517451]  [<ffffffff81047d1b>] ? try_to_del_timer_sync+0x6b/0xa0
[  679.517455]  [<ffffffff81228515>] btrfs_writepage_end_io_hook+0x15/0x20
[  679.517459]  [<ffffffff812446b4>] end_extent_writepage+0x64/0x100
[  679.517463]  [<ffffffff8124478b>] end_bio_extent_writepage+0x3b/0xa0
[  679.517468]  [<ffffffff81151af8>] bio_endio+0x18/0x30
[  679.517470]  [<ffffffff81219ba0>] end_workqueue_fn+0x40/0x50
[  679.517473]  [<ffffffff81251883>] worker_loop+0xc3/0x450
[  679.517476]  [<ffffffff814ca17f>] ? __schedule+0x2df/0x640
[  679.517480]  [<ffffffff812517c0>] ? btrfs_queue_worker+0x220/0x220
[  679.517483]  [<ffffffff812517c0>] ? btrfs_queue_worker+0x220/0x220
[  679.517486]  [<ffffffff81059586>] kthread+0x96/0xa0
[  679.517490]  [<ffffffff81062fb4>] ? finish_task_switch+0x54/0xd0
[  679.517494]  [<ffffffff814d2d24>] kernel_thread_helper+0x4/0x10
[  679.517498]  [<ffffffff810594f0>] ? __init_kthread_worker+0x50/0x50
[  679.517501]  [<ffffffff814d2d20>] ? gs_change+0x13/0x13
[  679.517509] btrfs-transacti D ffffffff81605920     0  1320      2 0x00000000
[  679.725747]  ffff880172d07a50 0000000000000046 ffff8801774ca538 000000000000f7c0
[  679.725750]  000000000000f7c0 ffff880172d07fd8 ffff880172d06000 000000000000f7c0
[  679.725753]  ffff880172d07fd8 000000000000f7c0 ffff88017a4929e0 ffff880176320920
[  679.747879] Call Trace:
[  679.750326]  [<ffffffff814ca569>] schedule+0x29/0x90
[  679.750328]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  679.750331]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  679.750333]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  679.750335]  [<ffffffff81257d5d>] btrfs_tree_read_lock+0x5d/0x160
[  679.750338]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  679.750340]  [<ffffffff81066bb4>] ? migrate_enable+0xf4/0x1d0
[  679.750343]  [<ffffffff811fd863>] btrfs_read_lock_root_node+0x33/0x40
[  679.750345]  [<ffffffff81202919>] btrfs_search_slot+0x459/0x810
[  679.750349]  [<ffffffff81270d13>] btrfs_delete_delayed_items+0x63/0x100
[  679.750352]  [<ffffffff812710d2>] btrfs_run_delayed_items+0x112/0x160
[  679.750355]  [<ffffffff81220da2>] btrfs_commit_transaction+0x322/0xa70
[  679.750357]  [<ffffffff8122021a>] ? join_transaction+0x35a/0x3a0
[  679.750360]  [<ffffffff81059d30>] ? wake_up_bit+0x40/0x40
[  679.750362]  [<ffffffff81219a33>] transaction_kthread+0x273/0x2f0
[  679.750364]  [<ffffffff812197c0>] ? btrfs_congested_fn+0xb0/0xb0
[  679.750367]  [<ffffffff812197c0>] ? btrfs_congested_fn+0xb0/0xb0
[  679.750369]  [<ffffffff81059586>] kthread+0x96/0xa0
[  679.750371]  [<ffffffff81062fb4>] ? finish_task_switch+0x54/0xd0
[  679.750374]  [<ffffffff814d2d24>] kernel_thread_helper+0x4/0x10
[  679.750377]  [<ffffffff810594f0>] ? __init_kthread_worker+0x50/0x50
[  679.750379]  [<ffffffff814d2d20>] ? gs_change+0x13/0x13
[  679.750401] dbench          D ffffffff81605920     0  7812      1 0x00000004
[  679.886585]  ffff880174d99a98 0000000000000086 000000000000b380 000000000000f7c0
[  679.886587]  000000000000f7c0 ffff880174d99fd8 ffff880174d98000 000000000000f7c0
[  679.886590]  ffff880174d99fd8 000000000000f7c0 ffffffff81816020 ffff8801738be700
[  679.908712] Call Trace:
[  679.911158]  [<ffffffff810c87e0>] ? __lock_page+0x70/0x70
[  679.911160]  [<ffffffff814ca569>] schedule+0x29/0x90
[  679.911163]  [<ffffffff814ca657>] io_schedule+0x87/0xd0
[  679.911165]  [<ffffffff810c87e9>] sleep_on_page+0x9/0x10
[  679.911167]  [<ffffffff814c97a7>] __wait_on_bit+0x57/0x80
[  679.911170]  [<ffffffff810c983f>] ? find_get_pages_tag+0xcf/0x190
[  679.911172]  [<ffffffff810c8a0e>] wait_on_page_bit+0x6e/0x80
[  679.911175]  [<ffffffff81059d70>] ? autoremove_wake_function+0x40/0x40
[  679.911177]  [<ffffffff810d58b0>] ? pagevec_lookup_tag+0x20/0x30
[  679.911180]  [<ffffffff810c900e>] filemap_fdatawait_range+0xee/0x190
[  679.911183]  [<ffffffff812460bc>] ? extent_writepages+0x4c/0x60
[  679.911185]  [<ffffffff81226190>] ? btrfs_submit_direct+0x1d0/0x1d0
[  679.911188]  [<ffffffff811113e6>] ? kfree+0x1a6/0x2e0
[  679.911190]  [<ffffffff812240b2>] ? btrfs_writepages+0x22/0x30
[  679.911192]  [<ffffffff810d4dbf>] ? do_writepages+0x1f/0x40
[  679.911195]  [<ffffffff810c9e30>] filemap_write_and_wait_range+0x70/0x80
[  679.911198]  [<ffffffff81230587>] btrfs_sync_file+0x37/0x1b0
[  679.911201]  [<ffffffff8114ba50>] generic_write_sync+0x50/0x70
[  679.911203]  [<ffffffff812316dc>] btrfs_file_aio_write+0x31c/0x370
[  679.911207]  [<ffffffff811208da>] do_sync_write+0xda/0x120
[  679.911210]  [<ffffffff810ec752>] ? handle_mm_fault+0x162/0x220
[  679.911213]  [<ffffffff8104bc99>] ? kill_something_info+0x49/0x160
[  679.911216]  [<ffffffff812b45a3>] ? apparmor_file_permission+0x13/0x20
[  679.911219]  [<ffffffff8128ef27>] ? security_file_permission+0x27/0xb0
[  679.911222]  [<ffffffff811211c6>] vfs_write+0xc6/0x180
[  679.911224]  [<ffffffff81121672>] sys_pwrite64+0xa2/0xb0
[  679.911227]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  679.911229] dbench          D ffffffff81605920     0  7813      1 0x00000004
[  680.074937]  ffff880174445908 0000000000000086 ffff8801744458a8 000000000000f7c0
[  680.074940]  000000000000f7c0 ffff880174445fd8 ffff880174444000 000000000000f7c0
[  680.074942]  ffff880174445fd8 000000000000f7c0 ffff88017a4e4ae0 ffff880174eb62c0
[  680.097069] Call Trace:
[  680.099514]  [<ffffffff814ca569>] schedule+0x29/0x90
[  680.099516]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  680.099519]  [<ffffffff810d083a>] ? prep_new_page+0x12a/0x190
[  680.099521]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  680.099523]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  680.099525]  [<ffffffff81257d5d>] btrfs_tree_read_lock+0x5d/0x160
[  680.099529]  [<ffffffff812c21c6>] ? chksum_update+0x16/0x30
[  680.099531]  [<ffffffff811fd863>] btrfs_read_lock_root_node+0x33/0x40
[  680.099533]  [<ffffffff81202919>] btrfs_search_slot+0x459/0x810
[  680.099536]  [<ffffffff812148da>] btrfs_lookup_xattr+0x7a/0xc0
[  680.099539]  [<ffffffff8123e447>] __btrfs_getxattr+0x77/0x150
[  680.099542]  [<ffffffff8123e9cd>] btrfs_getxattr+0x7d/0x80
[  680.099544]  [<ffffffff8128d618>] cap_inode_need_killpriv+0x28/0x40
[  680.099547]  [<ffffffff8128ee41>] security_inode_need_killpriv+0x11/0x20
[  680.099549]  [<ffffffff810c85cb>] file_remove_suid+0x4b/0xc0
[  680.099551]  [<ffffffff810c88b5>] ? unlock_page+0x25/0x30
[  680.099556]  [<ffffffff810e7931>] ? __do_fault+0x431/0x530
[  680.099559]  [<ffffffff81231550>] btrfs_file_aio_write+0x190/0x370
[  680.099562]  [<ffffffff810eb437>] ? handle_pte_fault+0xe7/0x200
[  680.099565]  [<ffffffff811208da>] do_sync_write+0xda/0x120
[  680.099567]  [<ffffffff810ec752>] ? handle_mm_fault+0x162/0x220
[  680.099570]  [<ffffffff8104bc99>] ? kill_something_info+0x49/0x160
[  680.099572]  [<ffffffff812b45a3>] ? apparmor_file_permission+0x13/0x20
[  680.099574]  [<ffffffff8128ef27>] ? security_file_permission+0x27/0xb0
[  680.099577]  [<ffffffff811211c6>] vfs_write+0xc6/0x180
[  680.099579]  [<ffffffff81121672>] sys_pwrite64+0xa2/0xb0
[  680.099582]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  680.099584] dbench          D ffffffff81605920     0  7814      1 0x00000004
[  680.263730]  ffff880176169be8 0000000000000086 ffff88017759a9b8 000000000000f7c0
[  680.263733]  000000000000f7c0 ffff880176169fd8 ffff880176168000 000000000000f7c0
[  680.263735]  ffff880176169fd8 000000000000f7c0 ffff88017a476960 ffff8801756ec1c0
[  680.285863] Call Trace:
[  680.288309]  [<ffffffff814ca569>] schedule+0x29/0x90
[  680.288311]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  680.288314]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  680.288316]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  680.288319]  [<ffffffff81257eac>] btrfs_try_tree_read_lock+0x4c/0x80
[  680.288321]  [<ffffffff812029ed>] btrfs_search_slot+0x52d/0x810
[  680.288324]  [<ffffffff812256bf>] btrfs_real_readdir+0x1af/0x5f0
[  680.288326]  [<ffffffff81133690>] ? sys_ioctl+0xa0/0xa0
[  680.288329]  [<ffffffff81133690>] ? sys_ioctl+0xa0/0xa0
[  680.288331]  [<ffffffff811339a0>] vfs_readdir+0xb0/0xd0
[  680.288333]  [<ffffffff81133b80>] sys_getdents64+0x80/0xe0
[  680.288336]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  680.288338] dbench          D ffffffff81605920     0  7815      1 0x00000004
[  680.362625]  ffff880174ea7ad8 0000000000000086 ffff88017759abf8 000000000000f7c0
[  680.362627]  000000000000f7c0 ffff880174ea7fd8 ffff880174ea6000 000000000000f7c0
[  680.362630]  ffff880174ea7fd8 000000000000f7c0 ffff88017a4fab60 ffff880174d5ca60
[  680.384756] Call Trace:
[  680.387202]  [<ffffffff814ca569>] schedule+0x29/0x90
[  680.387204]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  680.387207]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  680.387209]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  680.387211]  [<ffffffff81257eac>] btrfs_try_tree_read_lock+0x4c/0x80
[  680.387214]  [<ffffffff812029ed>] btrfs_search_slot+0x52d/0x810
[  680.387216]  [<ffffffff812148da>] btrfs_lookup_xattr+0x7a/0xc0
[  680.387219]  [<ffffffff8123e447>] __btrfs_getxattr+0x77/0x150
[  680.387222]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  680.387225]  [<ffffffff8127b060>] btrfs_get_acl+0xf0/0x250
[  680.387227]  [<ffffffff8122d33d>] ? btrfs_new_inode+0x2bd/0x360
[  680.387230]  [<ffffffff8127b2e1>] btrfs_init_acl+0x81/0x150
[  680.387232]  [<ffffffff8122258c>] btrfs_init_inode_security+0x2c/0x60
[  680.387235]  [<ffffffff8122ea51>] btrfs_mkdir+0x121/0x1f0
[  680.387237]  [<ffffffff8112dfc8>] vfs_mkdir+0xb8/0x130
[  680.387240]  [<ffffffff81131273>] sys_mkdirat+0xf3/0x100
[  680.387242]  [<ffffffff81131294>] sys_mkdir+0x14/0x20
[  680.387244]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  680.387246] dbench          D ffffffff81605920     0  7818      1 0x00000004
[  680.496083]  ffff8801790c98e8 0000000000000082 ffff8801790c9888 000000000000f7c0
[  680.496086]  000000000000f7c0 ffff8801790c9fd8 ffff8801790c8000 000000000000f7c0
[  680.496088]  ffff8801790c9fd8 000000000000f7c0 ffff88017a536be0 ffff880176072700
[  680.518214] Call Trace:
[  680.520658]  [<ffffffff814ca569>] schedule+0x29/0x90
[  680.520660]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  680.520663]  [<ffffffff814cb821>] ? __rt_spin_lock+0x21/0x30
[  680.520665]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  680.520667]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  680.520669]  [<ffffffff81257bef>] btrfs_clear_lock_blocking_rw+0x6f/0x180
[  680.520672]  [<ffffffff811fd422>] btrfs_clear_path_blocking+0x32/0x70
[  680.520674]  [<ffffffff81202ba2>] btrfs_search_slot+0x6e2/0x810
[  680.520676]  [<ffffffff812c21c6>] ? chksum_update+0x16/0x30
[  680.520679]  [<ffffffff81214bd6>] btrfs_lookup_dir_item+0x76/0xc0
[  680.520682]  [<ffffffff8122c8db>] btrfs_lookup_dentry+0x9b/0x370
[  680.520685]  [<ffffffff810659c1>] ? get_parent_ip+0x11/0x50
[  680.520687]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  680.520690]  [<ffffffff8122cbc8>] btrfs_lookup+0x18/0x70
[  680.520693]  [<ffffffff8112bba8>] __lookup_hash+0x58/0x120
[  680.520695]  [<ffffffff8112e59f>] do_lookup+0x2af/0x330
[  680.520697]  [<ffffffff8112f174>] path_lookupat+0x134/0x750
[  680.520700]  [<ffffffff8110eb10>] ? cache_alloc_debugcheck_after+0x90/0x1a0
[  680.520702]  [<ffffffff8111048a>] ? kmem_cache_alloc+0x11a/0x200
[  680.520705]  [<ffffffff8112f7bc>] do_path_lookup+0x2c/0xc0
[  680.520707]  [<ffffffff810659c1>] ? get_parent_ip+0x11/0x50
[  680.520709]  [<ffffffff81130d74>] user_path_at_empty+0x54/0xa0
[  680.520712]  [<ffffffff81049380>] ? check_kill_permission+0x100/0x190
[  680.520714]  [<ffffffff8104baad>] ? group_send_sig_info+0x3d/0x80
[  680.520716]  [<ffffffff8104bc23>] ? kill_pid_info+0x53/0x80
[  680.520718]  [<ffffffff81130dcc>] user_path_at+0xc/0x10
[  680.520721]  [<ffffffff81125f1f>] vfs_fstatat+0x3f/0x80
[  680.520723]  [<ffffffff81125f96>] vfs_stat+0x16/0x20
[  680.520725]  [<ffffffff811260df>] sys_newstat+0x1f/0x40
[  680.520727]  [<ffffffff81122d6d>] ? fput+0x1d/0x30
[  680.520730]  [<ffffffff8111edd1>] ? filp_close+0x61/0x90
[  680.520732]  [<ffffffff8111eea8>] ? sys_close+0xa8/0x110
[  680.520735]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  680.520737] rm              D ffffffff81605920     0  7820      1 0x00000004
[  680.714842]  ffff880176411a08 0000000000000086 ffff8801774ca538 000000000000f7c0
[  680.714844]  000000000000f7c0 ffff880176411fd8 ffff880176410000 000000000000f7c0
[  680.714847]  ffff880176411fd8 000000000000f7c0 ffff88017a4e4ae0 ffff880175892d20
[  680.736972] Call Trace:
[  680.739420]  [<ffffffff814ca569>] schedule+0x29/0x90
[  680.739422]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  680.739426]  [<ffffffff810659c1>] ? get_parent_ip+0x11/0x50
[  680.739428]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  680.739430]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  680.739432]  [<ffffffff81257d5d>] btrfs_tree_read_lock+0x5d/0x160
[  680.739435]  [<ffffffff81246a34>] ? free_extent_buffer+0x34/0x70
[  680.739437]  [<ffffffff812002f1>] ? read_block_for_search+0x161/0x210
[  680.739440]  [<ffffffff811fd863>] btrfs_read_lock_root_node+0x33/0x40
[  680.739442]  [<ffffffff81202919>] btrfs_search_slot+0x459/0x810
[  680.739445]  [<ffffffff8121716a>] btrfs_lookup_inode+0x2a/0xa0
[  680.739448]  [<ffffffff81224e1e>] btrfs_read_locked_inode+0x7e/0x3a0
[  680.739450]  [<ffffffff81223eb0>] ? btrfs_permission+0x60/0x60
[  680.739453]  [<ffffffff8122c33f>] btrfs_iget+0x9f/0x100
[  680.739455]  [<ffffffff8122cad0>] btrfs_lookup_dentry+0x290/0x370
[  680.739458]  [<ffffffff8122cbc8>] btrfs_lookup+0x18/0x70
[  680.739461]  [<ffffffff8112bba8>] __lookup_hash+0x58/0x120
[  680.739463]  [<ffffffff8112faf7>] ? user_path_parent+0x47/0x80
[  680.739466]  [<ffffffff8112bc84>] lookup_hash+0x14/0x20
[  680.739468]  [<ffffffff8112fbc6>] do_unlinkat+0x96/0x1d0
[  680.739470]  [<ffffffff81133987>] ? vfs_readdir+0x97/0xd0
[  680.739472]  [<ffffffff81133baf>] ? sys_getdents64+0xaf/0xe0
[  680.739474]  [<ffffffff811312dd>] sys_unlinkat+0x1d/0x40
[  680.739477]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  680.739479] rm              D ffffffff81605920     0  7822      1 0x00000004
[  680.883473]  ffff880172e0fa28 0000000000000086 ffff8801774ca538 000000000000f7c0
[  680.883475]  000000000000f7c0 ffff880172e0ffd8 ffff880172e0e000 000000000000f7c0
[  680.883478]  ffff880172e0ffd8 000000000000f7c0 ffff88017a476960 ffff8801791a4500
[  680.905605] Call Trace:
[  680.908050]  [<ffffffff814ca569>] schedule+0x29/0x90
[  680.908052]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  680.908055]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  680.908057]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  680.908059]  [<ffffffff81257d5d>] btrfs_tree_read_lock+0x5d/0x160
[  680.908062]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  680.908065]  [<ffffffff811fd863>] btrfs_read_lock_root_node+0x33/0x40
[  680.908067]  [<ffffffff81202919>] btrfs_search_slot+0x459/0x810
[  680.908069]  [<ffffffff81066bb4>] ? migrate_enable+0xf4/0x1d0
[  680.908072]  [<ffffffff8122aefc>] btrfs_truncate_inode_items+0x13c/0x880
[  680.908074]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  680.908077]  [<ffffffff810659c1>] ? get_parent_ip+0x11/0x50
[  680.908079]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  680.908082]  [<ffffffff812218ab>] ? start_transaction+0x8b/0x290
[  680.908085]  [<ffffffff8122bf54>] btrfs_evict_inode+0x194/0x2c0
[  680.908087]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  680.908090]  [<ffffffff8113b875>] evict+0xb5/0x1d0
[  680.908092]  [<ffffffff8113ba83>] iput_final+0xf3/0x220
[  680.908095]  [<ffffffff8113bbe9>] iput+0x39/0x50
[  680.908097]  [<ffffffff8112fc87>] do_unlinkat+0x157/0x1d0
[  680.908099]  [<ffffffff81133987>] ? vfs_readdir+0x97/0xd0
[  680.908101]  [<ffffffff81133baf>] ? sys_getdents64+0xaf/0xe0
[  680.908104]  [<ffffffff811312dd>] sys_unlinkat+0x1d/0x40
[  680.908106]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  680.908108] rm              D ffffffff81605920     0  7827      1 0x00000004
[  681.051241]  ffff880172dffa98 0000000000000086 ffff8801774ca538 000000000000f7c0
[  681.051244]  000000000000f7c0 ffff880172dfffd8 ffff880172dfe000 000000000000f7c0
[  681.051246]  ffff880172dfffd8 000000000000f7c0 ffff88017a476960 ffff8801761e4340
[  681.073378] Call Trace:
[  681.075823]  [<ffffffff814ca569>] schedule+0x29/0x90
[  681.075825]  [<ffffffff814cb525>] rt_spin_lock_slowlock+0xd5/0x2bf
[  681.075827]  [<ffffffff814cb821>] __rt_spin_lock+0x21/0x30
[  681.075829]  [<ffffffff814cb927>] rt_read_lock+0x27/0x40
[  681.075832]  [<ffffffff81257d5d>] btrfs_tree_read_lock+0x5d/0x160
[  681.075834]  [<ffffffff810659c1>] ? get_parent_ip+0x11/0x50
[  681.075837]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  681.075840]  [<ffffffff811fd863>] btrfs_read_lock_root_node+0x33/0x40
[  681.075842]  [<ffffffff81202919>] btrfs_search_slot+0x459/0x810
[  681.075844]  [<ffffffff812c21c6>] ? chksum_update+0x16/0x30
[  681.075847]  [<ffffffff81214bd6>] btrfs_lookup_dir_item+0x76/0xc0
[  681.075850]  [<ffffffff8122c8db>] btrfs_lookup_dentry+0x9b/0x370
[  681.075852]  [<ffffffff810659c1>] ? get_parent_ip+0x11/0x50
[  681.075855]  [<ffffffff814cf69d>] ? sub_preempt_count+0x9d/0xd0
[  681.075857]  [<ffffffff8122cbc8>] btrfs_lookup+0x18/0x70
[  681.075860]  [<ffffffff8112bba8>] __lookup_hash+0x58/0x120
[  681.075862]  [<ffffffff8112faf7>] ? user_path_parent+0x47/0x80
[  681.075864]  [<ffffffff8112bc84>] lookup_hash+0x14/0x20
[  681.075866]  [<ffffffff8112fbc6>] do_unlinkat+0x96/0x1d0
[  681.075869]  [<ffffffff81133987>] ? vfs_readdir+0x97/0xd0
[  681.075871]  [<ffffffff81133baf>] ? sys_getdents64+0xaf/0xe0
[  681.075873]  [<ffffffff811312dd>] sys_unlinkat+0x1d/0x40
[  681.075875]  [<ffffffff814d1a39>] system_call_fastpath+0x16/0x1b
[  681.075878] Sched Debug Version: v0.10, 3.4.4-rt13 #37


