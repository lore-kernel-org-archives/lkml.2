Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab2J1LF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:05:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45341 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2J1LFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:05:55 -0400
MIME-Version: 1.0
Date: Sun, 28 Oct 2012 12:05:54 +0100
Message-ID: <CAPVoSvQLE4jdz514CamS0d9zedo1A1gYHpgN2dD4XUQOdwOagA@mail.gmail.com>
Subject: Hang with swap / mempool / md on 3.7.0-rc2
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While 3.7.0-rc1 and -rc2 otherwise worked fine for me, today my system
experienced a hang, trying to write to its disks.

Source of the problem seems to be a hang in kswapd0, after that many
more processes got stuck trying to do IO. Even an emergency sync via
SysRq+S did no longer complete.

The hang (that was still correctly logged to disk):
Oct 28 09:40:16 thoregon kernel: [141366.412179] INFO: task
kswapd0:724 blocked for more than 120 seconds.
Oct 28 09:40:16 thoregon kernel: [141366.412186] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 28 09:40:16 thoregon kernel: [141366.412191] kswapd0         D
ffff880337d112c0     0   724      2 0x00000000
Oct 28 09:40:16 thoregon kernel: [141366.412200]  ffff880329b8efa0
0000000000000046 0000000000000800 ffff88032986d240
Oct 28 09:40:16 thoregon kernel: [141366.412210]  ffff880329183fd8
ffff880329183fd8 ffff880329183fd8 ffff880329b8efa0
Oct 28 09:40:16 thoregon kernel: [141366.412217]  0000000000000246
ffff880329947680 ffff880329947400 00000000ffffffff
Oct 28 09:40:16 thoregon kernel: [141366.412224] Call Trace:
Oct 28 09:40:16 thoregon kernel: [141366.412239]  [<ffffffff814a6fbd>]
? md_super_wait+0x4d/0x80
Oct 28 09:40:16 thoregon kernel: [141366.412249]  [<ffffffff81054340>]
? add_wait_queue+0x60/0x60
Oct 28 09:40:16 thoregon kernel: [141366.412257]  [<ffffffff814ad283>]
? bitmap_unplug+0x153/0x160
Oct 28 09:40:16 thoregon kernel: [141366.412265]  [<ffffffff810cb3dc>]
? new_slab+0x1ec/0x220
Oct 28 09:40:16 thoregon kernel: [141366.412273]  [<ffffffff81497fc8>]
? raid1_unplug+0xb8/0x110
Oct 28 09:40:16 thoregon kernel: [141366.412281]  [<ffffffff81238180>]
? blk_flush_plug_list+0xb0/0x210
Oct 28 09:40:16 thoregon kernel: [141366.412288]  [<ffffffff816289e2>]
? io_schedule_timeout+0x82/0xf0
Oct 28 09:40:16 thoregon kernel: [141366.412296]  [<ffffffff81097882>]
? mempool_alloc+0x122/0x150
Oct 28 09:40:16 thoregon kernel: [141366.412302]  [<ffffffff81054340>]
? add_wait_queue+0x60/0x60
Oct 28 09:40:16 thoregon kernel: [141366.412309]  [<ffffffff811025fe>]
? bio_alloc_bioset+0x4e/0x120
Oct 28 09:40:16 thoregon kernel: [141366.412315]  [<ffffffff81102802>]
? bio_clone_bioset+0x12/0x40
Oct 28 09:40:16 thoregon kernel: [141366.412322]  [<ffffffff8149be16>]
? make_request+0x416/0xb70
Oct 28 09:40:16 thoregon kernel: [141366.412328]  [<ffffffff810cb3dc>]
? new_slab+0x1ec/0x220
Oct 28 09:40:16 thoregon kernel: [141366.412336]  [<ffffffff8123b9e1>]
? blk_recount_segments+0x21/0x40
Oct 28 09:40:16 thoregon kernel: [141366.412343]  [<ffffffff814a0a0f>]
? md_make_request+0xbf/0x1e0
Oct 28 09:40:16 thoregon kernel: [141366.412349]  [<ffffffff81236d9a>]
? generic_make_request+0xba/0xf0
Oct 28 09:40:16 thoregon kernel: [141366.412355]  [<ffffffff81236e31>]
? submit_bio+0x61/0x110
Oct 28 09:40:16 thoregon kernel: [141366.412363]  [<ffffffff811a8415>]
? _xfs_buf_ioapply+0x1e5/0x270
Oct 28 09:40:16 thoregon kernel: [141366.412370]  [<ffffffff8105f3c0>]
? try_to_wake_up+0x280/0x280
Oct 28 09:40:16 thoregon kernel: [141366.412377]  [<ffffffff811a9535>]
? xfs_buf_iorequest+0x25/0x40
Oct 28 09:40:16 thoregon kernel: [141366.412383]  [<ffffffff811f2666>]
? xlog_bdstrat+0x16/0x40
Oct 28 09:40:16 thoregon kernel: [141366.412389]  [<ffffffff811f398d>]
? xlog_sync+0x1bd/0x390
Oct 28 09:40:16 thoregon kernel: [141366.412394]  [<ffffffff811f40e9>]
? xlog_assign_tail_lsn_locked+0x19/0x50
Oct 28 09:40:16 thoregon kernel: [141366.412400]  [<ffffffff811f4b64>]
? xlog_write+0x554/0x6f0
Oct 28 09:40:16 thoregon kernel: [141366.412408]  [<ffffffff811bd1f2>]
? kmem_zone_zalloc+0x32/0x50
Oct 28 09:40:16 thoregon kernel: [141366.412415]  [<ffffffff811f5fed>]
? xlog_cil_push+0x26d/0x350
Oct 28 09:40:16 thoregon kernel: [141366.412421]  [<ffffffff811f67b0>]
? xlog_cil_force_lsn+0x130/0x140
Oct 28 09:40:16 thoregon kernel: [141366.412427]  [<ffffffff81061b02>]
? dequeue_task_fair+0x52/0x180
Oct 28 09:40:16 thoregon kernel: [141366.412433]  [<ffffffff811f5157>]
? _xfs_log_force_lsn+0x47/0x2d0
Oct 28 09:40:16 thoregon kernel: [141366.412439]  [<ffffffff8162265a>]
? __slab_free+0x17d/0x293
Oct 28 09:40:16 thoregon kernel: [141366.412446]  [<ffffffff81087481>]
? delayacct_end+0x81/0xa0
Oct 28 09:40:16 thoregon kernel: [141366.412452]  [<ffffffff811f53eb>]
? xfs_log_force_lsn+0xb/0x40
Oct 28 09:40:16 thoregon kernel: [141366.412458]  [<ffffffff811e6733>]
? xfs_iunpin_wait+0x93/0xf0
Oct 28 09:40:16 thoregon kernel: [141366.412465]  [<ffffffff81054370>]
? autoremove_wake_function+0x30/0x30
Oct 28 09:40:16 thoregon kernel: [141366.412471]  [<ffffffff811b85db>]
? xfs_reclaim_inode+0x11b/0x300
Oct 28 09:40:16 thoregon kernel: [141366.412478]  [<ffffffff811b8d9b>]
? xfs_reclaim_inodes_ag+0x1bb/0x2c0
Oct 28 09:40:16 thoregon kernel: [141366.412486]  [<ffffffff811b8fbc>]
? xfs_reclaim_inodes_nr+0x2c/0x40
Oct 28 09:40:16 thoregon kernel: [141366.412493]  [<ffffffff810d80e3>]
? prune_super+0x113/0x1b0
Oct 28 09:40:16 thoregon kernel: [141366.412499]  [<ffffffff810a1829>]
? shrink_slab+0x119/0x1c0
Oct 28 09:40:16 thoregon kernel: [141366.412506]  [<ffffffff810a3d82>]
? kswapd+0x682/0x9a0
Oct 28 09:40:16 thoregon kernel: [141366.412513]  [<ffffffff81054340>]
? add_wait_queue+0x60/0x60
Oct 28 09:40:16 thoregon kernel: [141366.412519]  [<ffffffff810a3700>]
? shrink_lruvec+0x540/0x540
Oct 28 09:40:16 thoregon kernel: [141366.412525]  [<ffffffff81053bd3>]
? kthread+0xb3/0xc0
Oct 28 09:40:16 thoregon kernel: [141366.412531]  [<ffffffff81053b20>]
? flush_kthread_worker+0xa0/0xa0
Oct 28 09:40:16 thoregon kernel: [141366.412538]  [<ffffffff81629bec>]
? ret_from_fork+0x7c/0xb0
Oct 28 09:40:16 thoregon kernel: [141366.412544]  [<ffffffff81053b20>]
? flush_kthread_worker+0xa0/0xa0

After that xfsaild/md4, flush-9:4 and several user processes also got
such an hang message, these look like they just got stuck on some
locks that kswapd was also using.

At that time the system had some memory pressure from compiling
firefox on an tmpfs, but usage of swap was still pretty minimal,
because the system as 12G of RAM.
Might be relevant:
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_ZCACHE=y

As I can not reproduce this on demand (This was the first time it
happened since the release of 3.7.0-rc1), would it be useful to enable
LOCKDEP?

Please ask, if you need other informations. I will try to provide them.

Thank for looking,

Torsten
