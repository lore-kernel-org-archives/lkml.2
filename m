Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875Ab1JFNGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:06:03 -0400
Received: from post.russia.ru ([87.242.118.101]:63833 "EHLO post.russia.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758262Ab1JFNGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:06:00 -0400
X-Greylist: delayed 882 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 09:05:59 EDT
Message-ID: <4E8DA415.8090007@russia.ru>
Date: Thu, 06 Oct 2011 19:50:29 +0700
From: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110907 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org,
        axboe@kernel.dk, duaneg@dghda.com
Subject: BUG: spinlock lockup while performing FS operations
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: paramonov@russia.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 25518 [Oct 06 2011]
X-SpamTest-Info: {received from trusted sender <paramonov@russia.ru>: common white list}
X-SpamTest-Method: white email list
X-SpamTest-Rate: 0
X-SpamTest-Status: Trusted
X-SpamTest-Status-Extended: trusted
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Faced with this problem. There are RAID5, assembled by mdadm (/dev/md127),
which is divided into 2 partitions (md127p1 and md127p2). In both reiserfs. The
second partition is exported via NFS. Everything works, the array is intact and
fully synchronized. SMART says disks are healthy. But when copy too many files
all hangs and saves only the reset. After a reset of course runs fsck, and then
synchronize the array.

I have a brand new computer. Sleaze is not set. Motherboard gigabyte 870-UD3,
Power Supply FSP 700W, memory 16Gb Kingston, CPU Phenom II X6 1090T.

I  reported an error  on  bugs.gentoo.org: https://bugs.gentoo.org/show_bug.cgi?id=385047
Was  compiling a custom kernel  with support for  debugging and  debug messages are  received.
Duane Griffin  then  sent me  upstream.

Now I have have BUG spinlock lockup on screen:

Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, mc/7609, ffff880419c37200
Oct  4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3, flush-9:127/2391, ffff880419c37200

Full log from /var/log/messages:

Oct  4 15:53:09 localhost kernel: INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0 2} (detected by 5, t=60028 jiffies)
Oct  4 15:53:15 localhost kernel: INFO: rcu_bh_state detected stalls on CPUs/tasks: { 0 2 3} (detected by 5, t=60025 jiffies)
Oct  4 15:55:25 localhost kernel: INFO: task sync_supers:151 blocked for more than 120 seconds.
Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 15:55:25 localhost kernel: sync_supers     D 0000000000000000     0   151      2 0x00000000
Oct  4 15:55:25 localhost kernel: ffff88042dba5740 0000000000000046 ffffffff81493e95 0000000000000008
Oct  4 15:55:25 localhost kernel: ffff88042dba8000 00000000000001ec 0000000000010b40 ffff88042dba8000
Oct  4 15:55:25 localhost kernel: 0000000000010b40 ffff88042dba5fd8 ffff88042dba4000 0000000000004000
Oct  4 15:55:25 localhost kernel: Call Trace:
Oct  4 15:55:25 localhost kernel: [<ffffffff81493e95>] ? schedule+0x695/0xa10
Oct  4 15:55:25 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+0x72/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x11/0x50
Oct  4 15:55:25 localhost kernel: [<ffffffff8138de22>] get_active_stripe+0x312/0x6f0
Oct  4 15:55:25 localhost kernel: [<ffffffff8103e7f0>] ? try_to_wake_up+0x2d0/0x2d0
Oct  4 15:55:25 localhost kernel: [<ffffffff81391bb8>] make_request+0x1a8/0x720
Oct  4 15:55:25 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40/0x40
Oct  4 15:55:25 localhost kernel: [<ffffffff8139c6be>] md_make_request+0x16e/0x2f0
Oct  4 15:55:25 localhost kernel: [<ffffffff8139c5a8>] ? md_make_request+0x58/0x2f0
Oct  4 15:55:25 localhost kernel: [<ffffffff810fcbb3>] ? kmem_cache_alloc+0x33/0xc0
Oct  4 15:55:25 localhost kernel: [<ffffffff81242dac>] generic_make_request+0x14c/0x2f0
Oct  4 15:55:25 localhost kernel: [<ffffffff81242fb1>] submit_bio+0x61/0xd0
Oct  4 15:55:25 localhost kernel: [<ffffffff81131e26>] submit_bh+0xe6/0x120
Oct  4 15:55:25 localhost kernel: [<ffffffff81192c8b>] write_ordered_chunk+0x5b/0x90
Oct  4 15:55:25 localhost kernel: [<ffffffff81192bfc>] add_to_chunk+0x4c/0x80
Oct  4 15:55:25 localhost kernel: [<ffffffff81192c30>] ? add_to_chunk+0x80/0x80
Oct  4 15:55:25 localhost kernel: [<ffffffff8119407d>] write_ordered_buffers.clone.31+0x8d/0x2a0
Oct  4 15:55:25 localhost kernel: [<ffffffff8107b60d>] ? trace_hardirqs_on+0xd/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff8119444f>] flush_commit_list+0x1bf/0x6e0
Oct  4 15:55:25 localhost kernel: [<ffffffff811984d4>] do_journal_end.clone.34+0xdb4/0xf20
Oct  4 15:55:25 localhost kernel: [<ffffffff810d4b90>] ? bdi_sched_wait+0x10/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff81198f54>] journal_end_sync+0x64/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff81186178>] reiserfs_sync_fs+0x58/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff8149608f>] ? down_read+0x2f/0x50
Oct  4 15:55:25 localhost kernel: [<ffffffff8118619e>] reiserfs_write_super+0xe/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff81109cca>] sync_supers+0xfa/0x100
Oct  4 15:55:25 localhost kernel: [<ffffffff810d4bd1>] bdi_sync_supers+0x41/0x60
Oct  4 15:55:25 localhost kernel: [<ffffffff810d4b90>] ? bdi_sched_wait+0x10/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] kernel_thread_helper+0x4/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_args+0xe/0xe
Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
Oct  4 15:55:25 localhost kernel: 2 locks held by sync_supers/151:
Oct  4 15:55:25 localhost kernel: #0:  (&type->s_umount_key#18){+++++.}, at: [<ffffffff81109c53>] sync_supers+0x83/0x100
Oct  4 15:55:25 localhost kernel: #1:  (&jl->j_commit_mutex){+.+...}, at: [<ffffffff811943c8>] flush_commit_list+0x138/0x6e0
Oct  4 15:55:25 localhost kernel: INFO: task md127_resync:3773 blocked for more than 120 seconds.
Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 15:55:25 localhost kernel: md127_resync    D 0000000000000000     0  3773      2 0x00000000
Oct  4 15:55:25 localhost kernel: ffff88041880fbb0 0000000000000046 ffffffff81493e95 0000000000000000
Oct  4 15:55:25 localhost kernel: 0000000000000000 ffff88041822e158 0000000000010b40 ffff88042d935b20
Oct  4 15:55:25 localhost kernel: 0000000000010b40 ffff88041880ffd8 ffff88041880e000 0000000000004000
Oct  4 15:55:25 localhost kernel: Call Trace:
Oct  4 15:55:25 localhost kernel: [<ffffffff81493e95>] ? schedule+0x695/0xa10
Oct  4 15:55:25 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x11/0x50
Oct  4 15:55:25 localhost kernel: [<ffffffff81494742>] schedule_timeout+0x152/0x220
Oct  4 15:55:25 localhost kernel: [<ffffffff81053490>] ? run_timer_softirq+0x2c0/0x2c0
Oct  4 15:55:25 localhost kernel: [<ffffffff81494829>] schedule_timeout_uninterruptible+0x19/0x20
Oct  4 15:55:25 localhost kernel: [<ffffffff81053d58>] msleep+0x18/0x20
Oct  4 15:55:25 localhost kernel: [<ffffffff8139dc7c>] md_do_sync+0x93c/0xd60
Oct  4 15:55:25 localhost kernel: [<ffffffff8149743b>] ? _raw_spin_unlock_irq+0x2b/0x60
Oct  4 15:55:25 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40/0x40
Oct  4 15:55:25 localhost kernel: [<ffffffff81054676>] ? recalc_sigpending+0x16/0x40
Oct  4 15:55:25 localhost kernel: [<ffffffff8139e3e6>] md_thread+0x116/0x150
Oct  4 15:55:25 localhost kernel: [<ffffffff814974ad>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff8139e2d0>] ? md_register_thread+0x110/0x110
Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] kernel_thread_helper+0x4/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_args+0xe/0xe
Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
Oct  4 15:55:25 localhost kernel: no locks held by md127_resync/3773.
Oct  4 15:55:25 localhost kernel: INFO: task mc:7609 blocked for more than 120 seconds.
Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 15:55:25 localhost kernel: mc              D 00000000000213da     0  7609   7603 0x00000000
Oct  4 15:55:25 localhost kernel: 0000000091827364 ffff880418bb9af0 ffff880418bb9af0 ffff880418bb9b00
Oct  4 15:55:25 localhost kernel: ffff880418bb9b00 ffffffff00000000 0000000000000087 0000000000521e7f
Oct  4 15:55:25 localhost kernel: 00000000000000ca 00000000000000cb 0000000000000133 ffff880418bb9bd8
Oct  4 15:55:25 localhost kernel: Call Trace:
Oct  4 15:55:25 localhost kernel: [<ffffffff8117b5a8>] ? reiserfs_readpages+0x18/0x20
Oct  4 15:55:25 localhost kernel: [<ffffffff810c75ad>] ? __do_page_cache_readahead+0x20d/0x2c0
Oct  4 15:55:25 localhost kernel: [<ffffffff810c7455>] ? __do_page_cache_readahead+0xb5/0x2c0
Oct  4 15:55:25 localhost kernel: [<ffffffff812cc920>] ? fbcon_decor_cursor+0x150/0x1e0
Oct  4 15:55:25 localhost kernel: [<ffffffff810c798c>] ? ra_submit+0x1c/0x20
Oct  4 15:55:25 localhost kernel: [<ffffffff810c7a96>] ? ondemand_readahead+0x106/0x2b0
Oct  4 15:55:25 localhost kernel: [<ffffffff810c7d0c>] ? page_cache_sync_readahead+0x2c/0x40
Oct  4 15:55:25 localhost kernel: [<ffffffff810be8d8>] ? generic_file_aio_read+0x428/0x770
Oct  4 15:55:25 localhost kernel: [<ffffffff811064c2>] ? do_sync_read+0xd2/0x110
Oct  4 15:55:25 localhost kernel: [<ffffffff8123266c>] ? security_file_permission+0x8c/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff81106c33>] ? vfs_read+0xc3/0x170
Oct  4 15:55:25 localhost kernel: [<ffffffff81106d2c>] ? sys_read+0x4c/0x90
Oct  4 15:55:25 localhost kernel: [<ffffffff8149803b>] ? system_call_fastpath+0x16/0x1b
Oct  4 15:55:25 localhost kernel: 1 lock held by mc/7609:
Oct  4 15:55:25 localhost kernel: #0:  (&(&conf->device_lock)->rlock){..-...}, at: [<ffffffff8138c862>] release_stripe+0x32/0x60
Oct  4 15:55:25 localhost kernel: INFO: task kworker/1:2:7644 blocked for more than 120 seconds.
Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 15:55:25 localhost kernel: kworker/1:2     D 0000000000000000     0  7644      2 0x00000000
Oct  4 15:55:25 localhost kernel: ffff88041b761c50 0000000000000046 ffffffff81493e95 0000000000000002
Oct  4 15:55:25 localhost kernel: ffff88041b761c10 0000000000000046 0000000000010b40 ffff88041b57ad90
Oct  4 15:55:25 localhost kernel: 0000000000010b40 ffff88041b761fd8 ffff88041b760000 0000000000004000
Oct  4 15:55:25 localhost kernel: Call Trace:
Oct  4 15:55:25 localhost kernel: [<ffffffff81493e95>] ? schedule+0x695/0xa10
Oct  4 15:55:25 localhost kernel: [<ffffffff8103d861>] ? load_balance+0xd1/0x830
Oct  4 15:55:25 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+0x72/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff814959d7>] mutex_lock_nested+0x167/0x380
Oct  4 15:55:25 localhost kernel: [<ffffffff811943c8>] ? flush_commit_list+0x138/0x6e0
Oct  4 15:55:25 localhost kernel: [<ffffffff8107b5bd>] ? trace_hardirqs_on_caller+0x12d/0x170
Oct  4 15:55:25 localhost kernel: [<ffffffff811943c8>] flush_commit_list+0x138/0x6e0
Oct  4 15:55:25 localhost kernel: [<ffffffff8119532a>] flush_async_commits+0x5a/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff8105cdcb>] process_one_work+0x18b/0x440
Oct  4 15:55:25 localhost kernel: [<ffffffff8105cd6a>] ? process_one_work+0x12a/0x440
Oct  4 15:55:25 localhost kernel: [<ffffffff811952d0>] ? get_list_bitmap+0xc0/0xc0
Oct  4 15:55:25 localhost kernel: [<ffffffff8105f062>] worker_thread+0x162/0x340
Oct  4 15:55:25 localhost kernel: [<ffffffff8105ef00>] ? manage_workers.clone.25+0x230/0x230
Oct  4 15:55:25 localhost kernel: [<ffffffff8105ef00>] ? manage_workers.clone.25+0x230/0x230
Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] kernel_thread_helper+0x4/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_args+0xe/0xe
Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
Oct  4 15:55:25 localhost kernel: 3 locks held by kworker/1:2/7644:
Oct  4 15:55:25 localhost kernel: #0:  (reiserfs){.+.+..}, at: [<ffffffff8105cd6a>] process_one_work+0x12a/0x440
Oct  4 15:55:25 localhost kernel: #1:  ((&(&journal->j_work)->work)){+.+...}, at: [<ffffffff8105cd6a>] process_one_work+0x12a/0x440
Oct  4 15:55:25 localhost kernel: #2:  (&jl->j_commit_mutex){+.+...}, at: [<ffffffff811943c8>] flush_commit_list+0x138/0x6e0
Oct  4 15:55:25 localhost kernel: INFO: task flush-9:127:2391 blocked for more than 120 seconds.
Oct  4 15:55:25 localhost kernel: "echo 0>  /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct  4 15:55:25 localhost kernel: flush-9:127     D ffffffff8112b988     0  2391      2 0x00000000
Oct  4 15:55:25 localhost kernel: 0000000000000000 ffffffff81897e00 ffff8804184bd808 ffff880419c2c980
Oct  4 15:55:25 localhost kernel: ffff88040367fc80 ffff88042f019800 ffff880419c2c8e0 ffff880419c2c970
Oct  4 15:55:25 localhost kernel: ffff88040367fd00 ffff88042f019868 ffff88040367fcd0 ffffffff8112c4b3
Oct  4 15:55:25 localhost kernel: Call Trace:
Oct  4 15:55:25 localhost kernel: [<ffffffff8112c4b3>] ? writeback_inodes_wb+0x83/0x180
Oct  4 15:55:25 localhost kernel: [<ffffffff8112c86b>] ? wb_writeback+0x2bb/0x330
Oct  4 15:55:25 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_count+0x95/0xd0
Oct  4 15:55:25 localhost kernel: [<ffffffff8112cb20>] ? wb_do_writeback+0x240/0x250
Oct  4 15:55:25 localhost kernel: [<ffffffff8112cbc2>] ? bdi_writeback_thread+0x92/0x180
Oct  4 15:55:25 localhost kernel: [<ffffffff8112cb30>] ? wb_do_writeback+0x250/0x250
Oct  4 15:55:25 localhost kernel: [<ffffffff81063f36>] ? kthread+0x96/0xa0
Oct  4 15:55:25 localhost kernel: [<ffffffff81499194>] ? kernel_thread_helper+0x4/0x10
Oct  4 15:55:25 localhost kernel: [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
Oct  4 15:55:25 localhost kernel: [<ffffffff814978c4>] ? retint_restore_args+0xe/0xe
Oct  4 15:55:25 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
Oct  4 15:55:25 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb
Oct  4 15:55:25 localhost kernel: 2 locks held by flush-9:127/2391:
Oct  4 15:55:25 localhost kernel: #0:  (&type->s_umount_key#24){.+.+..}, at: [<ffffffff8112c52c>] writeback_inodes_wb+0xfc/0x180
Oct  4 15:55:25 localhost kernel: #1:  (&(&conf->device_lock)->rlock){..-...}, at: [<ffffffff8138db45>] get_active_stripe+0x35/0x6f0
Nov 26 13:34:46 localhost -- MARK --
Nov 26 13:34:46 localhost kernel: BUG: spinlock lockup on CPU#2, mc/7609, ffff880419c37200
Nov 26 13:34:46 localhost kernel: Pid: 7609, comm: mc Tainted: G        W   3.0.4-gentoo-r1 #7
Nov 26 13:34:46 localhost kernel: Call Trace:
Nov 26 13:34:46 localhost kernel:<IRQ>   [<ffffffff81267866>] do_raw_spin_lock+0x156/0x170
Nov 26 13:34:46 localhost kernel: [<ffffffff81496cc9>] _raw_spin_lock_irqsave+0x49/0x60
Nov 26 13:34:46 localhost kernel: [<ffffffff8138c862>] ? release_stripe+0x32/0x60
Nov 26 13:34:46 localhost kernel: [<ffffffff814974ad>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
Nov 26 13:34:46 localhost kernel: [<ffffffff8138c862>] release_stripe+0x32/0x60
Nov 26 13:34:46 localhost kernel: [<ffffffff8138e80f>] raid5_end_write_request+0xcf/0x120
Nov 26 13:34:46 localhost kernel: [<ffffffff81136318>] bio_endio+0x18/0x30
Nov 26 13:34:46 localhost syslog-ng[6446]: Log statistics; processed='center(received)=0', processed='center(queued)=0', processed='source(src)=999', processed='destination(console_all)=999', processed='destination(messages)=999', processed='global(payload_reallocs)=0', processed='global(sdata_updates)=0', processed='src.internal(src#1)=2', stamp='src.internal(src#1)=2584593286', processed='global(msg_clones)=0'
Nov 26 13:36:43 localhost kernel: [<ffffffff812444fb>] req_bio_endio.clone.39+0x8b/0xd0
Nov 26 13:36:43 localhost kernel: [<ffffffff81244633>] blk_update_request+0xf3/0x500
Nov 26 13:36:43 localhost kernel: [<ffffffff81244869>] ? blk_update_request+0x329/0x500
Nov 26 13:36:43 localhost kernel: [<ffffffff8132f765>] ? ata_scsi_qc_complete+0x65/0x460
Nov 26 13:36:43 localhost kernel: [<ffffffff81244a6f>] blk_update_bidi_request+0x2f/0x90
Nov 26 13:36:43 localhost kernel: [<ffffffff81244c3a>] blk_end_bidi_request+0x2a/0x80
Nov 26 13:36:43 localhost kernel: [<ffffffff81244ccb>] blk_end_request+0xb/0x10
Nov 26 13:36:43 localhost kernel: [<ffffffff81319ab7>] scsi_io_completion+0x97/0x5d0
Nov 26 13:36:43 localhost kernel: [<ffffffff813124c2>] scsi_finish_command+0xb2/0xe0
Nov 26 13:36:43 localhost kernel: [<ffffffff813198ad>] scsi_softirq_done+0x9d/0x130
Oct  4 15:55:50 localhost kernel: [<ffffffff81249b4d>] blk_done_softirq+0x7d/0x90
Oct  4 15:55:50 localhost kernel: [<ffffffff8104cbf8>] __do_softirq+0xa8/0x140
Oct  4 15:55:50 localhost kernel: [<ffffffff8149928c>] call_softirq+0x1c/0x30
Oct  4 15:55:50 localhost kernel: [<ffffffff810047b5>] do_softirq+0x85/0xc0
Oct  4 15:55:50 localhost kernel: [<ffffffff8104cf9e>] irq_exit+0x9e/0xc0
Oct  4 15:55:50 localhost kernel: [<ffffffff810043d1>] do_IRQ+0x61/0xd0
Oct  4 15:55:50 localhost kernel: [<ffffffff81497813>] common_interrupt+0x13/0x13
Oct  4 15:55:50 localhost kernel:<EOI>   [<ffffffff81497441>] ? _raw_spin_unlock_irq+0x31/0x60
Oct  4 15:55:50 localhost kernel: [<ffffffff8149743b>] ? _raw_spin_unlock_irq+0x2b/0x60
Oct  4 15:55:50 localhost kernel: [<ffffffff8131958e>] scsi_request_fn+0x34e/0x400
Oct  4 15:55:50 localhost kernel: [<ffffffff812424a9>] __blk_run_queue+0x19/0x20
Oct  4 15:55:50 localhost kernel: [<ffffffff812537b5>] cfq_insert_request+0x345/0x4d0
Oct  4 15:55:50 localhost kernel: [<ffffffff81241a56>] __elv_add_request+0x126/0x1e0
Oct  4 15:55:50 localhost kernel: [<ffffffff81245880>] blk_flush_plug_list+0x1b0/0x200
Oct  4 15:55:50 localhost kernel: [<ffffffff81493c32>] schedule+0x432/0xa10
Oct  4 15:55:50 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x11/0x50
Oct  4 15:55:50 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_count+0x95/0xd0
Oct  4 15:55:50 localhost kernel: [<ffffffff8138de22>] get_active_stripe+0x312/0x6f0
Oct  4 15:55:50 localhost kernel: [<ffffffff8103e7f0>] ? try_to_wake_up+0x2d0/0x2d0
Oct  4 15:55:50 localhost kernel: [<ffffffff81391bb8>] make_request+0x1a8/0x720
Oct  4 15:55:50 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40/0x40
Oct  4 15:55:50 localhost kernel: [<ffffffff8139c6be>] md_make_request+0x16e/0x2f0
Oct  4 15:55:50 localhost kernel: [<ffffffff8139c5a8>] ? md_make_request+0x58/0x2f0
Oct  4 15:55:50 localhost kernel: [<ffffffff81242dac>] generic_make_request+0x14c/0x2f0
Oct  4 15:55:50 localhost kernel: [<ffffffff8113741a>] ? bvec_alloc_bs+0x6a/0x100
Oct  4 15:55:50 localhost kernel: [<ffffffff81242fb1>] submit_bio+0x61/0xd0
Oct  4 15:55:50 localhost kernel: [<ffffffff8113c3f7>] do_mpage_readpage+0x317/0x650
Oct  4 15:55:50 localhost kernel: [<ffffffff810c8c46>] ? __lru_cache_add+0x76/0xc0
Oct  4 15:55:50 localhost kernel: [<ffffffff8113c89c>] mpage_readpages+0xfc/0x150
Oct  4 15:55:50 localhost kernel: [<ffffffff8117d7a0>] ? restart_transaction+0xb0/0xb0
Oct  4 15:55:50 localhost kernel: [<ffffffff8117d7a0>] ? restart_transaction+0xb0/0xb0
Oct  4 15:55:50 localhost kernel: [<ffffffff8117b5a8>] reiserfs_readpages+0x18/0x20
Oct  4 15:55:50 localhost kernel: [<ffffffff810c75ad>] __do_page_cache_readahead+0x20d/0x2c0
Oct  4 15:55:50 localhost kernel: [<ffffffff810c7455>] ? __do_page_cache_readahead+0xb5/0x2c0
Oct  4 15:55:50 localhost kernel: [<ffffffff812cc920>] ? fbcon_decor_cursor+0x150/0x1e0
Oct  4 15:55:50 localhost kernel: [<ffffffff810c798c>] ra_submit+0x1c/0x20
Oct  4 15:55:50 localhost kernel: [<ffffffff810c7a96>] ondemand_readahead+0x106/0x2b0
Oct  4 15:55:50 localhost kernel: [<ffffffff810c7d0c>] page_cache_sync_readahead+0x2c/0x40
Oct  4 15:55:50 localhost kernel: [<ffffffff810be8d8>] generic_file_aio_read+0x428/0x770
Oct  4 15:55:50 localhost kernel: [<ffffffff811064c2>] do_sync_read+0xd2/0x110
Oct  4 15:55:50 localhost kernel: [<ffffffff8123266c>] ? security_file_permission+0x8c/0xa0
Oct  4 15:55:50 localhost kernel: [<ffffffff81106c33>] vfs_read+0xc3/0x170
Oct  4 15:55:50 localhost kernel: [<ffffffff81106d2c>] sys_read+0x4c/0x90
Oct  4 15:55:50 localhost kernel: [<ffffffff8149803b>] system_call_fastpath+0x16/0x1b
Oct  4 15:55:50 localhost kernel: BUG: spinlock lockup on CPU#3, flush-9:127/2391, ffff880419c37200
Oct  4 15:55:50 localhost kernel: Pid: 2391, comm: flush-9:127 Tainted: G        W   3.0.4-gentoo-r1 #7
Oct  4 15:55:50 localhost kernel: Call Trace:
Oct  4 15:55:50 localhost kernel: [<ffffffff81267866>] do_raw_spin_lock+0x156/0x170
Oct  4 15:55:50 localhost kernel: [<ffffffff81496c74>] _raw_spin_lock_irq+0x44/0x50
Oct  4 15:55:50 localhost kernel: [<ffffffff8138db45>] ? get_active_stripe+0x35/0x6f0
Oct  4 15:55:50 localhost kernel: [<ffffffff8138db45>] get_active_stripe+0x35/0x6f0
Oct  4 15:55:50 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+0x72/0xa0
Oct  4 15:55:50 localhost kernel: [<ffffffff8103fa41>] ? get_parent_ip+0x11/0x50
Oct  4 15:55:50 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_count+0x95/0xd0
Oct  4 15:55:50 localhost kernel: [<ffffffff814974ad>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
Oct  4 15:55:50 localhost kernel: [<ffffffff810646cb>] ? prepare_to_wait+0x5b/0x90
Oct  4 15:55:50 localhost kernel: [<ffffffff81391bb8>] make_request+0x1a8/0x720
Oct  4 15:55:50 localhost kernel: [<ffffffff81064430>] ? wake_up_bit+0x40/0x40
Oct  4 15:55:50 localhost kernel: [<ffffffff8139c6be>] md_make_request+0x16e/0x2f0
Oct  4 15:55:50 localhost kernel: [<ffffffff8139c5a8>] ? md_make_request+0x58/0x2f0
Oct  4 15:55:50 localhost kernel: [<ffffffff810fcbb3>] ? kmem_cache_alloc+0x33/0xc0
Oct  4 15:55:50 localhost kernel: [<ffffffff81242dac>] generic_make_request+0x14c/0x2f0
Oct  4 15:55:50 localhost kernel: [<ffffffff81242fb1>] submit_bio+0x61/0xd0
Oct  4 15:55:50 localhost kernel: [<ffffffff81131e26>] submit_bh+0xe6/0x120
Oct  4 15:55:50 localhost kernel: [<ffffffff811352c7>] __block_write_full_page+0x1f7/0x370
Oct  4 15:55:50 localhost kernel: [<ffffffff81133db0>] ? block_read_full_page+0x3b0/0x3b0
Oct  4 15:55:50 localhost kernel: [<ffffffff81138040>] ? I_BDEV+0x10/0x10
Oct  4 15:55:50 localhost kernel: [<ffffffff81138040>] ? I_BDEV+0x10/0x10
Oct  4 15:55:50 localhost kernel: [<ffffffff8113552e>] block_write_full_page_endio+0xee/0x130
Oct  4 15:55:50 localhost kernel: [<ffffffff8107b462>] ? mark_held_locks+0x72/0xa0
Oct  4 15:55:50 localhost kernel: [<ffffffff81135580>] block_write_full_page+0x10/0x20
Oct  4 15:55:50 localhost kernel: [<ffffffff81138ef3>] blkdev_writepage+0x13/0x20
Oct  4 15:55:50 localhost kernel: [<ffffffff810c5925>] __writepage+0x15/0x50
Oct  4 15:55:50 localhost kernel: [<ffffffff810c60a1>] write_cache_pages+0x1f1/0x420
Oct  4 15:55:50 localhost kernel: [<ffffffff810c5910>] ? set_page_dirty+0x70/0x70
Oct  4 15:55:50 localhost kernel: [<ffffffff810c6318>] generic_writepages+0x48/0x60
Oct  4 15:55:50 localhost kernel: [<ffffffff810c71ff>] do_writepages+0x1f/0x40
Oct  4 15:55:50 localhost kernel: [<ffffffff8112b5a9>] writeback_single_inode+0xf9/0x260
Oct  4 15:55:50 localhost kernel: [<ffffffff8112b988>] writeback_sb_inodes+0xe8/0x1c0
Oct  4 15:55:50 localhost kernel: [<ffffffff8112c4b3>] writeback_inodes_wb+0x83/0x180
Oct  4 15:55:50 localhost kernel: [<ffffffff8112c86b>] wb_writeback+0x2bb/0x330
Oct  4 15:55:50 localhost kernel: [<ffffffff8103fb15>] ? sub_preempt_count+0x95/0xd0
Oct  4 15:55:50 localhost kernel: [<ffffffff8112cb20>] wb_do_writeback+0x240/0x250
Oct  4 15:55:50 localhost kernel: [<ffffffff8112cbc2>] bdi_writeback_thread+0x92/0x180
Oct  4 15:55:50 localhost kernel: [<ffffffff8112cb30>] ? wb_do_writeback+0x250/0x250
Oct  4 15:55:50 localhost kernel: [<ffffffff81063f36>] kthread+0x96/0xa0
Oct  4 15:55:50 localhost kernel: [<ffffffff81499194>] kernel_thread_helper+0x4/0x10
Oct  4 15:55:50 localhost kernel: [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
Oct  4 15:55:50 localhost kernel: [<ffffffff814978c4>] ? retint_restore_args+0xe/0xe
Oct  4 15:55:50 localhost kernel: [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
Oct  4 15:55:50 localhost kernel: [<ffffffff81499190>] ? gs_change+0xb/0xb

Why  date  a failure  to  report?What next?
Thanks.

---
ParamonovValery.

