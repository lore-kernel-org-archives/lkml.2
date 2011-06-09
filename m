Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1FIKtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 06:49:52 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42575 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754674Ab1FIKtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 06:49:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=d6V5BwTiQ0oD9jU7nH0IA2MjW+1jtMhufm54AMTw8UFb8iGuDYWHA+IYVo4WRDEcu3+kSJgqtEIFnTQu38eKcPpZGZG27UWNzh6R5hz32DzKDfWjI4xRgoglEo3binQ1;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Tao Ma <tm@tao.ma>
Subject: CFQ: async queue blocks the whole system
Date: Thu,  9 Jun 2011 18:49:37 +0800
Message-Id: <1307616577-6101-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens and Vivek,
	We are current running some heavy ext4 metadata test,
and we found a very severe problem for CFQ. Please correct me if
my statement below is wrong.

CFQ only has an async queue for every priority of every class and
these queues have a very low serving priority, so if the system
has a large number of sync reads, these queues will be delayed a
lot of time. As a result, the flushers will be blocked, then the
journal and finally our applications[1].

I have tried to let jbd/2 to use WRITE_SYNC so that they can checkpoint
in time and the patches are sent. But today we found another similar
block in kswapd which make me think that maybe CFQ should be changed
somehow so that all these callers can benefit from it.

So is there any way to let the async queue work timely or at least
is there any deadline for async queue to finish an request in time
even in case there are many reads?

btw, We have tested deadline scheduler and it seems to work in our test.

[1] the message we get from one system:
INFO: task flush-8:0:2950 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-8:0       D ffff88062bfde738     0  2950      2 0x00000000
 ffff88062b137820 0000000000000046 ffff88062b137750 ffffffff812b7bc3
 ffff88032cddc000 ffff88062bfde380 ffff88032d3d8840 0000000c2be37400
 000000002be37601 0000000000000006 ffff88062b137760 ffffffff811c242e
Call Trace:
 [<ffffffff812b7bc3>] ? scsi_request_fn+0x345/0x3df
 [<ffffffff811c242e>] ? __blk_run_queue+0x1a/0x1c
 [<ffffffff811c57cc>] ? queue_unplugged+0x77/0x8e
 [<ffffffff813dbe67>] io_schedule+0x47/0x61
 [<ffffffff811c512c>] get_request_wait+0xe0/0x152
 [<ffffffff81062ed0>] ? list_del_init+0x21/0x21
 [<ffffffff811c1c21>] ? elv_merge+0xa0/0xb5
 [<ffffffff811c7cdd>] __make_request+0x185/0x2a8
 [<ffffffff811c4536>] generic_make_request+0x246/0x323
 [<ffffffff810c880b>] ? mempool_alloc_slab+0x16/0x18
 [<ffffffff810c8a7d>] ? mempool_alloc+0x31/0xf4
 [<ffffffff811c5bc2>] submit_bio+0xe2/0x101
 [<ffffffff81136c88>] ? bio_alloc_bioset+0x4d/0xc5
 [<ffffffff810dc846>] ? inc_zone_page_state+0x25/0x28
 [<ffffffff811326f7>] submit_bh+0x105/0x129
 [<ffffffff81134b74>] __block_write_full_page+0x218/0x31d
 [<ffffffff811356ea>] ? __set_page_dirty_buffers+0xac/0xac
 [<ffffffff81138aea>] ? blkdev_get_blocks+0xa6/0xa6
 [<ffffffff811356ea>] ? __set_page_dirty_buffers+0xac/0xac
 [<ffffffff81138aea>] ? blkdev_get_blocks+0xa6/0xa6
 [<ffffffff81134d02>] block_write_full_page_endio+0x89/0x95
 [<ffffffff81134d23>] block_write_full_page+0x15/0x17
 [<ffffffff81137cc6>] blkdev_writepage+0x18/0x1a
 [<ffffffff810cdf48>] __writepage+0x17/0x30
 [<ffffffff810ce571>] write_cache_pages+0x251/0x361
 [<ffffffff810cdf31>] ? page_mapping+0x35/0x35
 [<ffffffff810ce6c9>] generic_writepages+0x48/0x63
 [<ffffffff810ce705>] do_writepages+0x21/0x2a
 [<ffffffff8112c296>] writeback_single_inode+0xb1/0x1a8
 [<ffffffff8112c7fb>] writeback_sb_inodes+0xb5/0x12f
 [<ffffffff8112cbfa>] writeback_inodes_wb+0x111/0x121
 [<ffffffff8112cdd3>] wb_writeback+0x1c9/0x2ce
 [<ffffffff81053b6a>] ? lock_timer_base+0x2b/0x4f
 [<ffffffff8112d00c>] wb_do_writeback+0x134/0x1a3
 [<ffffffff8112df71>] bdi_writeback_thread+0x89/0x1b4
 [<ffffffff8112dee8>] ? perf_trace_writeback_class+0xa6/0xa6
 [<ffffffff81062966>] kthread+0x72/0x7a
 [<ffffffff813e4a04>] kernel_thread_helper+0x4/0x10
 [<ffffffff810628f4>] ? kthread_bind+0x67/0x67
 [<ffffffff813e4a00>] ? gs_change+0x13/0x13
INFO: task jbd2/sda12-8:3435 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/sda12-8    D ffff88062c2fabb8     0  3435      2 0x00000000
 ffff88061f6c9d30 0000000000000046 0000000000000000 0000000000000000
 0000000000000000 ffff88062c2fa800 ffff88032d238400 00000001000024b4
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81062f38>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffffa00fa718>] jbd2_journal_commit_transaction+0x254/0x14a4 [jbd2]
 [<ffffffff81036d7a>] ? need_resched+0x23/0x2d
 [<ffffffff81062ed0>] ? list_del_init+0x21/0x21
 [<ffffffff81053b6a>] ? lock_timer_base+0x2b/0x4f
 [<ffffffff81053b3d>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81053c09>] ? try_to_del_timer_sync+0x7b/0x89
 [<ffffffffa01001a5>] ? jbd2_journal_start_commit+0x72/0x72 [jbd2]
 [<ffffffffa01002c9>] kjournald2+0x124/0x381 [jbd2]
 [<ffffffff81062ed0>] ? list_del_init+0x21/0x21
 [<ffffffff81062966>] kthread+0x72/0x7a
 [<ffffffff813e4a04>] kernel_thread_helper+0x4/0x10
 [<ffffffff810628f4>] ? kthread_bind+0x67/0x67
 [<ffffffff813e4a00>] ? gs_change+0x13/0x13
INFO: task attr_set:3832 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
attr_set        D ffff8806157f8538     0  3832      1 0x00000000
 ffff880615565b28 0000000000000086 0000000000000001 0000000000000007
 0000000000000000 ffff8806157f8180 ffffffff8180b020 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8103926f>] ? hrtick_update+0x32/0x34
 [<ffffffff81042360>] ? dequeue_task_fair+0x15c/0x169
 [<ffffffff81062f38>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffffa00f92f7>] start_this_handle+0x2f5/0x564 [jbd2]
 [<ffffffff81062ed0>] ? list_del_init+0x21/0x21
 [<ffffffffa00f973c>] jbd2__journal_start+0xa5/0xd2 [jbd2]
 [<ffffffffa00f977c>] jbd2_journal_start+0x13/0x15 [jbd2]
 [<ffffffffa012f1fc>] ext4_journal_start_sb+0x11a/0x129 [ext4]
 [<ffffffffa0119b56>] ? ext4_file_open+0x15b/0x181 [ext4]
 [<ffffffffa014c1de>] ext4_xattr_set+0x69/0xe2 [ext4]
 [<ffffffffa014c96e>] ext4_xattr_user_set+0x43/0x49 [ext4]
 [<ffffffff811294cb>] generic_setxattr+0x67/0x76
 [<ffffffff81129f7b>] __vfs_setxattr_noperm+0x77/0xdc
 [<ffffffff8112a05c>] vfs_setxattr+0x7c/0x97
 [<ffffffff8112a12c>] setxattr+0xb5/0xe8
 [<ffffffff810fed93>] ? virt_to_head_page+0x29/0x2b
 [<ffffffff810fedb3>] ? virt_to_slab+0x1e/0x2e
 [<ffffffff810ff668>] ? __cache_free+0x44/0x1bf
 [<ffffffff8112a1ca>] sys_fsetxattr+0x6b/0x91
 [<ffffffff813e38c2>] system_call_fastpath+0x16/0x1b

[2] kswapd is blocked.
[<ffffffff814ae453>] io_schedule+0x73/0xc0
[682201.029914]  [<ffffffff81230cea>] get_request_wait+0xca/0x160
[682201.030236]  [<ffffffff8108d520>] ? autoremove_wake_function+0x0/0x40
[682201.030602]  [<ffffffff81228077>] ? elv_merge+0x37/0x1c0
[682201.030880]  [<ffffffff81230e13>] __make_request+0x93/0x4b0
[682201.031511]  [<ffffffff8122f1b9>] generic_make_request+0x1b9/0x3c0
[682201.031863]  [<ffffffff810d6a3d>] ? rcu_start_gp+0xfd/0x1e0
[682201.032195]  [<ffffffff8122f439>] submit_bio+0x79/0x120
[682201.032472]  [<ffffffff8118f0b9>] submit_bh+0xf9/0x150
[682201.032741]  [<ffffffff8119211e>] __block_write_full_page+0x1ae/0x320
[682201.033093]  [<ffffffff811900a0>] ? end_buffer_async_write+0x0/0x160
[682201.033457]  [<ffffffffa02483b0>] ? noalloc_get_block_write+0x0/0x60 [ext4]
[682201.033777]  [<ffffffff811900a0>] ? end_buffer_async_write+0x0/0x160
[682201.034079]  [<ffffffff81192366>] block_write_full_page_endio+0xd6/0x120
[682201.034413]  [<ffffffffa02483b0>] ? noalloc_get_block_write+0x0/0x60 [ext4]
[682201.034727]  [<ffffffff811923c5>] block_write_full_page+0x15/0x20
[682201.035063]  [<ffffffffa0244d9e>] ext4_writepage+0x28e/0x340 [ext4]
[682201.035509]  [<ffffffff8111d61d>] shrink_zone+0x116d/0x1480
[682201.035792]  [<ffffffff8111e25c>] kswapd+0x60c/0x800
[682201.036049]  [<ffffffff8111b5d0>] ? isolate_pages_global+0x0/0x3e0
[682201.036397]  [<ffffffff814adcfa>] ? thread_return+0x4e/0x734
[682201.036745]  [<ffffffff8108d520>] ? autoremove_wake_function+0x0/0x40
[682201.037055]  [<ffffffff8111dc50>] ? kswapd+0x0/0x800
[682201.037359]  [<ffffffff8108d3a6>] kthread+0x96/0xa0
[682201.037671]  [<ffffffff8101408a>] child_rip+0xa/0x20
[682201.038115]  [<ffffffff8108d310>] ? kthread+0x0/0xa0
[682201.038421]  [<ffffffff81014080>] ? child_rip+0x0/0x20

Regards,
Tao
