Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab2LZNWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 08:22:25 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:46486 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2LZNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 08:22:22 -0500
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 08:22:22 EST
MIME-Version: 1.0
In-Reply-To: <CAN_LGv3oBE4yfdjp76RkxiuUv4PN5RLq0qa8Y5kAMp9XUQXYDQ@mail.gmail.com>
References: <CAN_LGv3oBE4yfdjp76RkxiuUv4PN5RLq0qa8Y5kAMp9XUQXYDQ@mail.gmail.com>
Date: Wed, 26 Dec 2012 19:14:55 +0600
Message-ID: <CAN_LGv29fuLdERnw2j_iSAsgoBPaWtp1hLif6YYtn_MweaU0_g@mail.gmail.com>
Subject: staging/zram: possible deadlock & typo in error message
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the duplicate on linux-mm-cc, the first copy used a wrong
address for LKML]

Hello.

I have a single-core KVM virtual machine with 2 GB of RAM and
linux-3.7.1 inside, and I wanted to test the ZRAM module from staging
there. Here is how:

#!/bin/sh

modprobe zram

echo $((5*1024*1024*1024)) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0 -p 10 -d

Here is what I found in dmesg:

[    4.905544] zram: module is from the staging directory, the quality
is unknown, you have been warned.
[    4.907493] zram: num_devices not specified. Using default: 1
[    4.907500] zram: Creating 1 devices ...
[    4.917044] zram: There is little point creating a zram of greater
than twice the size of memory since we expect a 2:1 compression ratio.
Note that zram uses about 0.1% of the size of the disk when not in use
so a huge zram is wasteful.
[    4.917044]  Memory Size: 2043108 kB
[    4.917044]  Size you selected: 5368709120 kB
^^^ it definitely needs to divide that by 1024 in the message.

[    4.917044] Continuing anyway ...
[    4.986620] Adding 5242876k swap on /dev/zram0.  Priority:10
extents:1 across:5242876k SS
^^^ yes, that's what I added.

And here is the lock checker spew that appeared when the machine
started to use swap (the taint is AFAICT only from zram itself):

[ 6168.672533]
[ 6168.672592] =================================
[ 6168.672700] [ INFO: inconsistent lock state ]
[ 6168.672811] 3.7.1-gentoo #1 Tainted: G         C
[ 6168.672927] ---------------------------------
[ 6168.673042] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
[ 6168.673108] kswapd0/25 [HC0[0]:SC0[0]:HE1:SE1] takes:
[ 6168.673108]  (&zram->init_lock){+++++-}, at: [<ffffffffa00c5d14>]
zram_make_request+0x44/0x260 [zram]
[ 6168.673108] {RECLAIM_FS-ON-W} state was registered at:
[ 6168.673108]   [<ffffffff810b78cf>] mark_held_locks+0x5f/0x140
[ 6168.673108]   [<ffffffff810b80b2>] lockdep_trace_alloc+0xa2/0xe0
[ 6168.673108]   [<ffffffff81127143>] __alloc_pages_nodemask+0x83/0xa20
[ 6168.673108]   [<ffffffff81162ee1>] alloc_pages_current+0xb1/0x120
[ 6168.673108]   [<ffffffff811226d9>] __get_free_pages+0x9/0x40
[ 6168.673108]   [<ffffffff8116c2b9>] kmalloc_order_trace+0x39/0xf0
[ 6168.673108]   [<ffffffffa00c5b56>] zram_init_device+0x76/0x1f0 [zram]
[ 6168.673108]   [<ffffffffa00c5f1d>] zram_make_request+0x24d/0x260 [zram]
[ 6168.673108]   [<ffffffff81340ce2>] generic_make_request+0xc2/0x100
[ 6168.673108]   [<ffffffff81340d87>] submit_bio+0x67/0x130
[ 6168.673108]   [<ffffffff811b4ef3>] submit_bh+0x123/0x220
[ 6168.673108]   [<ffffffff811b8b08>] block_read_full_page+0x228/0x3d0
[ 6168.673108]   [<ffffffff811bc3a3>] blkdev_readpage+0x13/0x20
[ 6168.673108]   [<ffffffff8112a73a>] __do_page_cache_readahead+0x2aa/0x2b0
[ 6168.673108]   [<ffffffff8112aa01>] force_page_cache_readahead+0x71/0xa0
[ 6168.673108]   [<ffffffff8112adeb>] page_cache_sync_readahead+0x3b/0x40
[ 6168.673108]   [<ffffffff8111f7b8>] generic_file_aio_read+0x4f8/0x740
[ 6168.673108]   [<ffffffff811bba4c>] blkdev_aio_read+0x4c/0x80
[ 6168.673108]   [<ffffffff811839f2>] do_sync_read+0xa2/0xe0
[ 6168.673108]   [<ffffffff81184153>] vfs_read+0xc3/0x180
[ 6168.673108]   [<ffffffff8118426a>] sys_read+0x5a/0xa0
[ 6168.673108]   [<ffffffff81652469>] system_call_fastpath+0x16/0x1b
[ 6168.673108] irq event stamp: 55013
[ 6168.673108] hardirqs last  enabled at (55013): [<ffffffff810b7c04>]
debug_check_no_locks_freed+0xa4/0x190
[ 6168.673108] hardirqs last disabled at (55012): [<ffffffff810b7bad>]
debug_check_no_locks_freed+0x4d/0x190
[ 6168.673108] softirqs last  enabled at (54648): [<ffffffff8105df3e>]
__do_softirq+0x14e/0x290
[ 6168.673108] softirqs last disabled at (54625): [<ffffffff816536fc>]
call_softirq+0x1c/0x30
[ 6168.673108]
[ 6168.673108] other info that might help us debug this:
[ 6168.673108]  Possible unsafe locking scenario:
[ 6168.673108]
[ 6168.673108]        CPU0
[ 6168.673108]        ----
[ 6168.673108]   lock(&zram->init_lock);
[ 6168.673108]   <Interrupt>
[ 6168.673108]     lock(&zram->init_lock);
[ 6168.673108]
[ 6168.673108]  *** DEADLOCK ***
[ 6168.673108]
[ 6168.673108] no locks held by kswapd0/25.
[ 6168.673108]
[ 6168.673108] stack backtrace:
[ 6168.673108] Pid: 25, comm: kswapd0 Tainted: G         C   3.7.1-gentoo #1
[ 6168.673108] Call Trace:
[ 6168.673108]  [<ffffffff810b4467>] print_usage_bug+0x247/0x2e0
[ 6168.673108]  [<ffffffff810b4834>] mark_lock+0x334/0x630
[ 6168.673108]  [<ffffffff810bf49d>] ? __module_text_address+0xd/0x70
[ 6168.673108]  [<ffffffff810b511e>] __lock_acquire+0x5ee/0x1ee0
[ 6168.673108]  [<ffffffff810c4d5e>] ? is_module_text_address+0x2e/0x60
[ 6168.673108]  [<ffffffff810b0ec3>] ? __bfs+0x23/0x290
[ 6168.673108]  [<ffffffff81077020>] ? __kernel_text_address+0x40/0x70
[ 6168.673108]  [<ffffffff810b7052>] lock_acquire+0x92/0x140
[ 6168.673108]  [<ffffffffa00c5d14>] ? zram_make_request+0x44/0x260 [zram]
[ 6168.673108]  [<ffffffff816481e2>] down_read+0x42/0x60
[ 6168.673108]  [<ffffffffa00c5d14>] ? zram_make_request+0x44/0x260 [zram]
[ 6168.673108]  [<ffffffffa00c5d14>] zram_make_request+0x44/0x260 [zram]
[ 6168.673108]  [<ffffffff81127cce>] ? test_set_page_writeback+0x5e/0x190
[ 6168.673108]  [<ffffffff8164ac75>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[ 6168.673108]  [<ffffffff81340ce2>] generic_make_request+0xc2/0x100
[ 6168.673108]  [<ffffffff81340d87>] submit_bio+0x67/0x130
[ 6168.673108]  [<ffffffff81127d85>] ? test_set_page_writeback+0x115/0x190
[ 6168.673108]  [<ffffffff81159599>] swap_writepage+0x1a9/0x230
[ 6168.673108]  [<ffffffff810b78cf>] ? mark_held_locks+0x5f/0x140
[ 6168.673108]  [<ffffffff81647e05>] ? __mutex_unlock_slowpath+0x105/0x180
[ 6168.673108]  [<ffffffff810b7abd>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[ 6168.673108]  [<ffffffff810b7b5d>] ? trace_hardirqs_on+0xd/0x10
[ 6168.673108]  [<ffffffff81134e6e>] shmem_writepage+0x2ae/0x2f0
[ 6168.673108]  [<ffffffff811317e2>] shrink_page_list+0x742/0x9b0
[ 6168.673108]  [<ffffffff81131fa7>] shrink_inactive_list+0x167/0x460
[ 6168.673108]  [<ffffffff8113271c>] ? shrink_lruvec+0x13c/0x5c0
[ 6168.673108]  [<ffffffff81132a84>] shrink_lruvec+0x4a4/0x5c0
[ 6168.673108]  [<ffffffff81132c14>] shrink_zone+0x74/0xa0
[ 6168.673108]  [<ffffffff81133fbf>] balance_pgdat+0x5ff/0x7e0
[ 6168.673108]  [<ffffffff81134344>] kswapd+0x1a4/0x490
[ 6168.673108]  [<ffffffff8107aaa0>] ? wake_up_bit+0x40/0x40
[ 6168.673108]  [<ffffffff8164ac87>] ? _raw_spin_unlock_irqrestore+0x77/0x80
[ 6168.673108]  [<ffffffff811341a0>] ? balance_pgdat+0x7e0/0x7e0
[ 6168.673108]  [<ffffffff8107a2d6>] kthread+0xd6/0xe0
[ 6168.673108]  [<ffffffff8107a200>] ? __init_kthread_worker+0x70/0x70
[ 6168.673108]  [<ffffffff816523bc>] ret_from_fork+0x7c/0xb0
[ 6168.673108]  [<ffffffff8107a200>] ? __init_kthread_worker+0x70/0x70

-- 
Alexander E. Patrakov
