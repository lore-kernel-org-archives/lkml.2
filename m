Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2LRRad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:30:33 -0500
Received: from mail.palosanto.com ([201.234.196.171]:37126 "EHLO
	pbx.palosanto.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab2LRRaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:30:30 -0500
Message-ID: <50D0A834.2000505@palosanto.com>
Date: Tue, 18 Dec 2012 12:30:28 -0500
From: =?ISO-8859-1?Q?Alex_Villac=ED=ADs_Lasso?= 
	<a_villacis@palosanto.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep failure in 3.7.0 with zcache
References: <50D09422.8080609@palosanto.com>
In-Reply-To: <50D09422.8080609@palosanto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 18/12/12 11:04, Alex Villací­s Lasso escribió:
> I enabled CONFIG_PROVE_LOCKING=y and added slub_debug=FZPU in order to track down https://bugs.freedesktop.org/show_bug.cgi?id=57122 . While running the recompiled kernel with CONFIG_ZCACHE2=y, I got a "INFO: possible irq lock inversion dependency 
> detected" message in the kernel log. I was told to report it here.
Got it again:

[  737.788911] =========================================================
[  737.788912] [ INFO: possible irq lock inversion dependency detected ]
[  737.788915] 3.7.0 #6 Not tainted
[  737.788916] ---------------------------------------------------------
[  737.788918] yum_childtask.p/3525 just changed the state of lock:
[  737.788919]  (&(&hb->lock)->rlock){+.+.-.}, at: [<ffffffff81521ca3>] tmem_get+0xb3/0x1f0
[  737.788929] but this lock was taken by another, SOFTIRQ-safe lock in the past:
[  737.788930] (&(&mapping->tree_lock)->rlock){..-.-.}
[  737.788930]
[  737.788930] and interrupts could create inverse lock ordering between them.
[  737.788930]
[  737.788933]
[  737.788933] other info that might help us debug this:
[  737.788935]  Possible interrupt unsafe locking scenario:
[  737.788935]
[  737.788936]        CPU0                    CPU1
[  737.788937]        ----                    ----
[  737.788938]   lock(&(&hb->lock)->rlock);
[  737.788941]                                local_irq_disable();
[  737.788942] lock(&(&mapping->tree_lock)->rlock);
[  737.788944] lock(&(&hb->lock)->rlock);
[  737.788946]   <Interrupt>
[  737.788947] lock(&(&mapping->tree_lock)->rlock);
[  737.788950]
[  737.788950]  *** DEADLOCK ***
[  737.788950]
[  737.788952] 1 lock held by yum_childtask.p/3525:
[  737.788953]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff816773f4>] __do_page_fault+0x104/0x5b0
[  737.788960]
[  737.788960] the shortest dependencies between 2nd lock and 1st lock:
[  737.788969]  -> (&(&mapping->tree_lock)->rlock){..-.-.} ops: 1439757 {
[  737.788973]     IN-SOFTIRQ-W at:
[  737.788975]                       [<ffffffff810c3fd0>] __lock_acquire+0x5d0/0x1c60
[  737.788980]                       [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.788982]                       [<ffffffff81673c53>] _raw_spin_lock_irqsave+0x53/0x70
[  737.788985]                       [<ffffffff811517ba>] test_clear_page_writeback+0x6a/0x1d0
[  737.788989]                       [<ffffffff81144844>] end_page_writeback+0x24/0x60
[  737.788992]                       [<ffffffff811e0754>] end_buffer_async_write+0x194/0x2b0
[  737.788996]                       [<ffffffff811ddd40>] end_bio_bh_io_sync+0x30/0x50
[  737.788998]                       [<ffffffff811e297d>] bio_endio+0x1d/0x40
[  737.789001]                       [<ffffffff812e2dc3>] req_bio_endio+0xa3/0xe0
[  737.789003]                       [<ffffffff812e66a9>] blk_update_request+0x109/0x570
[  737.789003]                       [<ffffffff812e6b41>] blk_update_bidi_request+0x31/0x90
[  737.789003]                       [<ffffffff812e6bcc>] blk_end_bidi_request+0x2c/0x80
[  737.789003]                       [<ffffffff812e6c60>] blk_end_request+0x10/0x20
[  737.789003]                       [<ffffffff8141b4df>] scsi_io_completion+0xaf/0x6a0
[  737.789003]                       [<ffffffff814116a1>] scsi_finish_command+0xc1/0x120
[  737.789003]                       [<ffffffff8141b32f>] scsi_softirq_done+0x13f/0x160
[  737.789003]                       [<ffffffff812ee174>] blk_done_softirq+0x94/0xb0
[  737.789003]                       [<ffffffff8106b128>] __do_softirq+0xd8/0x2d0
[  737.789003]                       [<ffffffff8167cbbc>] call_softirq+0x1c/0x30
[  737.789003]                       [<ffffffff810185b5>] do_softirq+0xa5/0xe0
[  737.789003]                       [<ffffffff8106b4d6>] irq_exit+0xb6/0xf0
[  737.789003]                       [<ffffffff8167d473>] do_IRQ+0x63/0xd0
[  737.789003]                       [<ffffffff81673f32>] ret_from_intr+0x0/0x1a
[  737.789003]                       [<ffffffff810201df>] cpu_idle+0xdf/0x140
[  737.789003]                       [<ffffffff8164cdd1>] rest_init+0xc1/0xd0
[  737.789003]                       [<ffffffff81d17c53>] start_kernel+0x3e9/0x3f6
[  737.789003]                       [<ffffffff81d17356>] x86_64_start_reservations+0x131/0x135
[  737.789003]                       [<ffffffff81d1745c>] x86_64_start_kernel+0x102/0x111
[  737.789003]     IN-RECLAIM_FS-W at:
[  737.789003]                          [<ffffffff810c3f64>] __lock_acquire+0x564/0x1c60
[  737.789003]                          [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]                          [<ffffffff81673a97>] _raw_spin_lock_irq+0x47/0x60
[  737.789003]                          [<ffffffff81157a60>] __remove_mapping+0x70/0x160
[  737.789003]                          [<ffffffff81158ed2>] shrink_page_list+0x602/0xa00
[  737.789003]                          [<ffffffff8115980f>] shrink_inactive_list+0x15f/0x450
[  737.789003]                          [<ffffffff8115a278>] shrink_lruvec+0x438/0x550
[  737.789003]                          [<ffffffff8115a405>] shrink_zone+0x75/0xa0
[  737.789003]                          [<ffffffff8115b81f>] balance_pgdat+0x56f/0x720
[  737.789003]                          [<ffffffff8115bb53>] kswapd+0x183/0x510
[  737.789003]                          [<ffffffff810883aa>] kthread+0xea/0xf0
[  737.789003]                          [<ffffffff8167b86c>] ret_from_fork+0x7c/0xb0
[  737.789003]     INITIAL USE at:
[  737.789003]                      [<ffffffff810c3ce4>] __lock_acquire+0x2e4/0x1c60
[  737.789003]                      [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]                      [<ffffffff81673a97>] _raw_spin_lock_irq+0x47/0x60
[  737.789003]                      [<ffffffff8114497b>] add_to_page_cache_locked+0xbb/0x190
[  737.789003]                      [<ffffffff81144a71>] add_to_page_cache_lru+0x21/0x50
[  737.789003]                      [<ffffffff81144dd5>] grab_cache_page_write_begin+0x95/0xf0
[  737.789003]                      [<ffffffff811d2a98>] simple_write_begin+0x38/0x120
[  737.789003]                      [<ffffffff81145177>] generic_file_buffered_write+0x107/0x2a0
[  737.789003]                      [<ffffffff81146376>] __generic_file_aio_write+0x1b6/0x3b0
[  737.789003]                      [<ffffffff811465f1>] generic_file_aio_write+0x81/0x100
[  737.789003]                      [<ffffffff811abe63>] do_sync_write+0xa3/0xe0
[  737.789003]                      [<ffffffff811ac513>] vfs_write+0xb3/0x180
[  737.789003]                      [<ffffffff811ac852>] sys_write+0x52/0xa0
[  737.789003]                      [<ffffffff81d19100>] do_copy+0x2b/0x8e
[  737.789003]                      [<ffffffff81d18a73>] flush_buffer+0x82/0xb2
[  737.789003]                      [<ffffffff81d427fb>] gunzip+0x287/0x32f
[  737.789003]                      [<ffffffff81d18ec6>] unpack_to_rootfs+0x172/0x284
[  737.789003]                      [<ffffffff81d19698>] populate_rootfs+0x58/0x108
[  737.789003]                      [<ffffffff8100207f>] do_one_initcall+0x3f/0x170
[  737.789003]                      [<ffffffff8164cfdd>] kernel_init+0x1fd/0x390
[  737.789003]                      [<ffffffff8167b86c>] ret_from_fork+0x7c/0xb0
[  737.789003]   }
[  737.789003]   ... key      at: [<ffffffff8276ad60>] __key.30173+0x0/0x8
[  737.789003]   ... acquired at:
[  737.789003]    [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]    [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]    [<ffffffff8152189d>] tmem_put+0x8d/0x3e0
[  737.789003]    [<ffffffff8152068b>] zcache_put_page+0xbb/0x120
[  737.789003]    [<ffffffff81520846>] zcache_cleancache_put_page+0x56/0x60
[  737.789003]    [<ffffffff811a9d2e>] __cleancache_put_page+0x7e/0xa0
[  737.789003]    [<ffffffff81145cf8>] __delete_from_page_cache+0x178/0x1a0
[  737.789003]    [<ffffffff81157aa6>] __remove_mapping+0xb6/0x160
[  737.789003]    [<ffffffff81158ed2>] shrink_page_list+0x602/0xa00
[  737.789003]    [<ffffffff8115980f>] shrink_inactive_list+0x15f/0x450
[  737.789003]    [<ffffffff8115a278>] shrink_lruvec+0x438/0x550
[  737.789003]    [<ffffffff8115a405>] shrink_zone+0x75/0xa0
[  737.789003]    [<ffffffff8115b81f>] balance_pgdat+0x56f/0x720
[  737.789003]    [<ffffffff8115bb53>] kswapd+0x183/0x510
[  737.789003]    [<ffffffff810883aa>] kthread+0xea/0xf0
[  737.789003]    [<ffffffff8167b86c>] ret_from_fork+0x7c/0xb0
[  737.789003]
[  737.789003] -> (&(&hb->lock)->rlock){+.+.-.} ops: 266 {
[  737.789003]    HARDIRQ-ON-W at:
[  737.789003]                     [<ffffffff810c4010>] __lock_acquire+0x610/0x1c60
[  737.789003]                     [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]                     [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]                     [<ffffffff8152202d>] tmem_destroy_pool+0x3d/0xd0
[  737.789003]                     [<ffffffff8151fc7b>] zcache_cleancache_flush_fs+0x5b/0x90
[  737.789003]                     [<ffffffff811a9e35>] __cleancache_invalidate_fs+0x25/0x30
[  737.789003]                     [<ffffffff811ae8ad>] deactivate_locked_super+0x6d/0x90
[  737.789003]                     [<ffffffff811af55e>] deactivate_super+0x4e/0x70
[  737.789003]                     [<ffffffff811cb6ba>] mntput_no_expire+0xda/0x140
[  737.789003]                     [<ffffffff811cc781>] sys_umount+0x71/0x3a0
[  737.789003]                     [<ffffffff8167b919>] system_call_fastpath+0x16/0x1b
[  737.789003]    SOFTIRQ-ON-W at:
[  737.789003]                     [<ffffffff810c4043>] __lock_acquire+0x643/0x1c60
[  737.789003]                     [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]                     [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]                     [<ffffffff81521ca3>] tmem_get+0xb3/0x1f0
[  737.789003]                     [<ffffffff815208fd>] zcache_get_page+0xad/0x120
[  737.789003]                     [<ffffffff81520a74>] zcache_cleancache_get_page+0x54/0x70
[  737.789003]                     [<ffffffff811a9ddd>] __cleancache_get_page+0x8d/0xc0
[  737.789003]                     [<ffffffff811eac4a>] do_mpage_readpage+0x2fa/0x640
[  737.789003]                     [<ffffffff811eb0cf>] mpage_readpages+0xcf/0x120
[  737.789003]                     [<ffffffff8123261d>] ext4_readpages+0x1d/0x20
[  737.789003]                     [<ffffffff81151d1a>] __do_page_cache_readahead+0x21a/0x2c0
[  737.789003]                     [<ffffffff81151f51>] ra_submit+0x21/0x30
[  737.789003]                     [<ffffffff81147227>] filemap_fault+0x267/0x4c0
[  737.789003]                     [<ffffffff8116c94f>] __do_fault+0x6f/0x550
[  737.789003]                     [<ffffffff8116f7c0>] handle_pte_fault+0x90/0x9f0
[  737.789003]                     [<ffffffff81171341>] handle_mm_fault+0x251/0x310
[  737.789003]                     [<ffffffff81677464>] __do_page_fault+0x174/0x5b0
[  737.789003]                     [<ffffffff816778ae>] do_page_fault+0xe/0x10
[  737.789003]                     [<ffffffff816742f8>] page_fault+0x28/0x30
[  737.789003]    IN-RECLAIM_FS-W at:
[  737.789003]                        [<ffffffff810c3f64>] __lock_acquire+0x564/0x1c60
[  737.789003]                        [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]                        [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]                        [<ffffffff8152189d>] tmem_put+0x8d/0x3e0
[  737.789003]                        [<ffffffff8152068b>] zcache_put_page+0xbb/0x120
[  737.789003]                        [<ffffffff81520846>] zcache_cleancache_put_page+0x56/0x60
[  737.789003]                        [<ffffffff811a9d2e>] __cleancache_put_page+0x7e/0xa0
[  737.789003]                        [<ffffffff81145cf8>] __delete_from_page_cache+0x178/0x1a0
[  737.789003]                        [<ffffffff81157aa6>] __remove_mapping+0xb6/0x160
[  737.789003]                        [<ffffffff81158ed2>] shrink_page_list+0x602/0xa00
[  737.789003]                        [<ffffffff8115980f>] shrink_inactive_list+0x15f/0x450
[  737.789003]                        [<ffffffff8115a278>] shrink_lruvec+0x438/0x550
[  737.789003]                        [<ffffffff8115a405>] shrink_zone+0x75/0xa0
[  737.789003]                        [<ffffffff8115b81f>] balance_pgdat+0x56f/0x720
[  737.789003]                        [<ffffffff8115bb53>] kswapd+0x183/0x510
[  737.789003]                        [<ffffffff810883aa>] kthread+0xea/0xf0
[  737.789003]                        [<ffffffff8167b86c>] ret_from_fork+0x7c/0xb0
[  737.789003]    INITIAL USE at:
[  737.789003]                    [<ffffffff810c3ce4>] __lock_acquire+0x2e4/0x1c60
[  737.789003]                    [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]                    [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]                    [<ffffffff8152202d>] tmem_destroy_pool+0x3d/0xd0
[  737.789003]                    [<ffffffff8151fc7b>] zcache_cleancache_flush_fs+0x5b/0x90
[  737.789003]                    [<ffffffff811a9e35>] __cleancache_invalidate_fs+0x25/0x30
[  737.789003]                    [<ffffffff811ae8ad>] deactivate_locked_super+0x6d/0x90
[  737.789003]                    [<ffffffff811af55e>] deactivate_super+0x4e/0x70
[  737.789003]                    [<ffffffff811cb6ba>] mntput_no_expire+0xda/0x140
[  737.789003]                    [<ffffffff811cc781>] sys_umount+0x71/0x3a0
[  737.789003]                    [<ffffffff8167b919>] system_call_fastpath+0x16/0x1b
[  737.789003]  }
[  737.789003]  ... key      at: [<ffffffff8280ce20>] __key.20361+0x0/0x20
[  737.789003]  ... acquired at:
[  737.789003]    [<ffffffff810c3028>] check_usage_backwards+0x108/0x140
[  737.789003]    [<ffffffff810c38a8>] mark_lock+0x198/0x2f0
[  737.789003]    [<ffffffff810c4043>] __lock_acquire+0x643/0x1c60
[  737.789003]    [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]    [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]    [<ffffffff81521ca3>] tmem_get+0xb3/0x1f0
[  737.789003]    [<ffffffff815208fd>] zcache_get_page+0xad/0x120
[  737.789003]    [<ffffffff81520a74>] zcache_cleancache_get_page+0x54/0x70
[  737.789003]    [<ffffffff811a9ddd>] __cleancache_get_page+0x8d/0xc0
[  737.789003]    [<ffffffff811eac4a>] do_mpage_readpage+0x2fa/0x640
[  737.789003]    [<ffffffff811eb0cf>] mpage_readpages+0xcf/0x120
[  737.789003]    [<ffffffff8123261d>] ext4_readpages+0x1d/0x20
[  737.789003]    [<ffffffff81151d1a>] __do_page_cache_readahead+0x21a/0x2c0
[  737.789003]    [<ffffffff81151f51>] ra_submit+0x21/0x30
[  737.789003]    [<ffffffff81147227>] filemap_fault+0x267/0x4c0
[  737.789003]    [<ffffffff8116c94f>] __do_fault+0x6f/0x550
[  737.789003]    [<ffffffff8116f7c0>] handle_pte_fault+0x90/0x9f0
[  737.789003]    [<ffffffff81171341>] handle_mm_fault+0x251/0x310
[  737.789003]    [<ffffffff81677464>] __do_page_fault+0x174/0x5b0
[  737.789003]    [<ffffffff816778ae>] do_page_fault+0xe/0x10
[  737.789003]    [<ffffffff816742f8>] page_fault+0x28/0x30
[  737.789003]
[  737.789003]
[  737.789003] stack backtrace:
[  737.789003] Pid: 3525, comm: yum_childtask.p Not tainted 3.7.0 #6
[  737.789003] Call Trace:
[  737.789003]  [<ffffffff810c2dd8>] print_irq_inversion_bug.part.14+0x1e8/0x1f0
[  737.789003]  [<ffffffff810c3028>] check_usage_backwards+0x108/0x140
[  737.789003]  [<ffffffff810c38a8>] mark_lock+0x198/0x2f0
[  737.789003]  [<ffffffff810c2f20>] ? check_usage_forwards+0x140/0x140
[  737.789003]  [<ffffffff810c4043>] __lock_acquire+0x643/0x1c60
[  737.789003]  [<ffffffff810c6715>] ? trace_hardirqs_on_caller+0x105/0x190
[  737.789003]  [<ffffffff810c67ad>] ? trace_hardirqs_on+0xd/0x10
[  737.789003]  [<ffffffff8167362a>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
[  737.789003]  [<ffffffff8166978e>] ? __slab_free+0x30a/0x366
[  737.789003]  [<ffffffff810c6556>] ? mark_held_locks+0x86/0x140
[  737.789003]  [<ffffffff81521ca3>] ? tmem_get+0xb3/0x1f0
[  737.789003]  [<ffffffff810c5c52>] lock_acquire+0x92/0x160
[  737.789003]  [<ffffffff81521ca3>] ? tmem_get+0xb3/0x1f0
[  737.789003]  [<ffffffff81263c05>] ? ext4_ext_map_blocks+0x1b5/0x1360
[  737.789003]  [<ffffffff8167308b>] _raw_spin_lock+0x3b/0x50
[  737.789003]  [<ffffffff81521ca3>] ? tmem_get+0xb3/0x1f0
[  737.789003]  [<ffffffff81234851>] ? ext4_map_blocks+0x191/0x2c0
[  737.789003]  [<ffffffff81521ca3>] tmem_get+0xb3/0x1f0
[  737.789003]  [<ffffffff815208fd>] zcache_get_page+0xad/0x120
[  737.789003]  [<ffffffff81520a74>] zcache_cleancache_get_page+0x54/0x70
[  737.789003]  [<ffffffff811a9ddd>] __cleancache_get_page+0x8d/0xc0
[  737.789003]  [<ffffffff811eac4a>] do_mpage_readpage+0x2fa/0x640
[  737.789003]  [<ffffffff811535e7>] ? __lru_cache_add+0x87/0xf0
[  737.789003]  [<ffffffff811eb0cf>] mpage_readpages+0xcf/0x120
[  737.789003]  [<ffffffff81236f20>] ? noalloc_get_block_write+0x30/0x30
[  737.789003]  [<ffffffff81236f20>] ? noalloc_get_block_write+0x30/0x30
[  737.789003]  [<ffffffff8123261d>] ext4_readpages+0x1d/0x20
[  737.789003]  [<ffffffff81151d1a>] __do_page_cache_readahead+0x21a/0x2c0
[  737.789003]  [<ffffffff81151bbe>] ? __do_page_cache_readahead+0xbe/0x2c0
[  737.789003]  [<ffffffff81151f51>] ra_submit+0x21/0x30
[  737.789003]  [<ffffffff81147227>] filemap_fault+0x267/0x4c0
[  737.789003]  [<ffffffff8116c94f>] __do_fault+0x6f/0x550
[  737.789003]  [<ffffffff810c3ce4>] ? __lock_acquire+0x2e4/0x1c60
[  737.789003]  [<ffffffff8116f7c0>] handle_pte_fault+0x90/0x9f0
[  737.789003]  [<ffffffff811a169b>] ? mem_cgroup_count_vm_event+0x1b/0xc0
[  737.789003]  [<ffffffff816773f4>] ? __do_page_fault+0x104/0x5b0
[  737.789003]  [<ffffffff81171341>] handle_mm_fault+0x251/0x310
[  737.789003]  [<ffffffff81677464>] __do_page_fault+0x174/0x5b0
[  737.789003]  [<ffffffff8116c3d0>] ? might_fault+0x40/0x90
[  737.789003]  [<ffffffff816735a0>] ? _raw_spin_unlock_irq+0x30/0x70
[  737.789003]  [<ffffffff810c6715>] ? trace_hardirqs_on_caller+0x105/0x190
[  737.789003]  [<ffffffff810c67ad>] ? trace_hardirqs_on+0xd/0x10
[  737.789003]  [<ffffffff8131505d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[  737.789003]  [<ffffffff816778ae>] do_page_fault+0xe/0x10
[  737.789003]  [<ffffffff816742f8>] page_fault+0x28/0x30

