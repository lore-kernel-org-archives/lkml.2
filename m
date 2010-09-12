Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0ILUn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:43:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab0ILUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:43:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: lockdep warning: events vs. bd_mutex
Date: Sun, 12 Sep 2010 22:43:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
MIME-Version: 1.0
Message-Id: <201009122243.23765.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:8ms0+i7fWkI6iWw9rxFhwwjZLCjpndt/vDVCYaxhCs3
 +M8RA0wNhAaj1ftJzMquuCDaegG0QxoFNfucgijY2g6WoVslhz
 /5GqBFIkh8VThudBXyjz0Mycuy1Rak6QzxXFLgVaQsX8jBs9/7
 wYsN74vfWhNTB2/3nqUEGR+MLR0s3rW0paI5/3BZL/JBL0kMoj
 uhLesSRJXZI7PXHIf9elA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the warning below, which apparently tells me that a work queue doing
sd_probe_async ends up calling invalidate_bdev, which calls flush_work,
and that is something that is not allowed from workqueue context.

The change leading to this seems to be fa4b9074cd "buffer: make
invalidate_bdev() drain all percpu LRU add caches", which Tejun
introduced in 2.6.35 as a bug fix.

AFAICT, this happened when I plugged in a USB flash drive while
running last Friday's linux-next kernel.

	Arnd

[  464.601121]  sdd: sdd1
[  464.601126] sdd: p1 size 260288 extends beyond EOD, enabling native capacity
[  464.601244] 
[  464.601244] =======================================================
[  464.601288] [ INFO: possible circular locking dependency detected ]
[  464.601317] 2.6.36-rc3-next-20100910+ #44
[  464.601337] -------------------------------------------------------
[  464.601366] kworker/u:5/1184 is trying to acquire lock:
[  464.601392]  (events){+.+.+.}, at: [<ffffffff810567a3>] flush_work+0xb8/0x143
[  464.602109] 
[  464.602109] but task is already holding lock:
[  464.602109]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8111e0db>] __blkdev_get+0x54/0x32f
[  464.602109] 
[  464.602109] which lock already depends on the new lock.
[  464.602109] 
[  464.602109] 
[  464.602109] the existing dependency chain (in reverse order) is:
[  464.602109] 
[  464.602109] -> #3 (&bdev->bd_mutex){+.+.+.}:
[  464.602109]        [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
[  464.602109]        [<ffffffff813f5b5b>] __mutex_lock_common+0x4b/0x35e
[  464.602109]        [<ffffffff813f5f32>] mutex_lock_nested+0x3e/0x43
[  464.602109]        [<ffffffff8111d7df>] revalidate_disk+0x4b/0x73
[  464.602109]        [<ffffffff812a969f>] sd_rescan+0x27/0x34
[  464.602109]        [<ffffffff812a1be6>] scsi_rescan_device+0x82/0x98
[  464.602109]        [<ffffffff812b53e5>] ata_scsi_dev_rescan+0x8d/0xf4
[  464.602109]        [<ffffffff810558b0>] process_one_work+0x232/0x399
[  464.602109]        [<ffffffff8105759a>] worker_thread+0x13b/0x251
[  464.602109]        [<ffffffff8105ace8>] kthread+0x82/0x8a
[  464.602109]        [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[  464.602109] 
[  464.602109] -> #2 (&ap->scsi_scan_mutex){+.+.+.}:
[  464.602109]        [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
[  464.602109]        [<ffffffff813f5b5b>] __mutex_lock_common+0x4b/0x35e
[  464.602109]        [<ffffffff813f5f32>] mutex_lock_nested+0x3e/0x43
[  464.602109]        [<ffffffff812b538e>] ata_scsi_dev_rescan+0x36/0xf4
[  464.602109]        [<ffffffff810558b0>] process_one_work+0x232/0x399
[  464.602109]        [<ffffffff8105759a>] worker_thread+0x13b/0x251
[  464.602109]        [<ffffffff8105ace8>] kthread+0x82/0x8a
[  464.602109]        [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[  464.602109] 
[  464.602109] -> #1 ((&ap->scsi_rescan_task)){+.+.+.}:
[  464.602109]        [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
[  464.602109]        [<ffffffff8105587a>] process_one_work+0x1fc/0x399
[  464.602109]        [<ffffffff8105759a>] worker_thread+0x13b/0x251
[  464.602109]        [<ffffffff8105ace8>] kthread+0x82/0x8a
[  464.602109]        [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[  464.602109] 
[  464.602109] -> #0 (events){+.+.+.}:
[  464.602109]        [<ffffffff8106d6e9>] __lock_acquire+0xa30/0xd38
[  464.602109]        [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
[  464.602109]        [<ffffffff810567e7>] flush_work+0xfc/0x143
[  464.602109]        [<ffffffff81056903>] schedule_on_each_cpu+0xd5/0x115
[  464.602109]        [<ffffffff810c6f06>] lru_add_drain_all+0x15/0x17
[  464.602109]        [<ffffffff81118b93>] invalidate_bdev+0x2d/0x3f
[  464.602109]        [<ffffffff8111d16c>] __invalidate_device+0x48/0x53
[  464.602109]        [<ffffffff811ebf1d>] invalidate_partition+0x2d/0x42
[  464.602109]        [<ffffffff8114ac31>] rescan_partitions+0x63/0x40e
[  464.602109]        [<ffffffff8111e2f0>] __blkdev_get+0x269/0x32f
[  464.602109]        [<ffffffff8111e3c6>] blkdev_get+0x10/0x12
[  464.602109]        [<ffffffff8114a35d>] register_disk+0xdc/0x13f
[  464.602109]        [<ffffffff811eb5f0>] add_disk+0xaf/0x10b
[  464.602109]        [<ffffffff812abd2b>] sd_probe_async+0x129/0x1cd
[  464.602109]        [<ffffffff81061847>] async_run_entry_fn+0xa8/0x15b
[  464.602109]        [<ffffffff810558b0>] process_one_work+0x232/0x399
[  464.602109]        [<ffffffff8105759a>] worker_thread+0x13b/0x251
[  464.602109]        [<ffffffff8105ace8>] kthread+0x82/0x8a
[  464.602109]        [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[  464.602109] 
[  464.602109] other info that might help us debug this:
[  464.602109] 
[  464.602109] 3 locks held by kworker/u:5/1184:
[  464.602109]  #0:  (events_unbound){+.+.+.}, at: [<ffffffff81055825>] process_one_work+0x1a7/0x399
[  464.602109]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff81055825>] process_one_work+0x1a7/0x399
[  464.602109]  #2:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff8111e0db>] __blkdev_get+0x54/0x32f
[  464.602109] 
[  464.602109] stack backtrace:
[  464.602109] Pid: 1184, comm: kworker/u:5 Not tainted 2.6.36-rc3-next-20100910+ #44
[  464.602109] Call Trace:
[  464.602109]  [<ffffffff8106c6b5>] print_circular_bug+0xbd/0xce
[  464.602109]  [<ffffffff8106d6e9>] __lock_acquire+0xa30/0xd38
[  464.602109]  [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
[  464.602109]  [<ffffffff810567a3>] ? flush_work+0xb8/0x143
[  464.602109]  [<ffffffff8106bffd>] ? trace_hardirqs_on_caller+0x11d/0x141
[  464.602109]  [<ffffffff810567e7>] flush_work+0xfc/0x143
[  464.602109]  [<ffffffff810567a3>] ? flush_work+0xb8/0x143
[  464.602109]  [<ffffffff8106bffd>] ? trace_hardirqs_on_caller+0x11d/0x141
[  464.602109]  [<ffffffff810553a0>] ? wq_barrier_func+0x0/0x14
[  464.602109]  [<ffffffff810c7120>] ? lru_add_drain_per_cpu+0x0/0x10
[  464.602109]  [<ffffffff81056903>] schedule_on_each_cpu+0xd5/0x115
[  464.602109]  [<ffffffff810c6f06>] lru_add_drain_all+0x15/0x17
[  464.602109]  [<ffffffff81118b93>] invalidate_bdev+0x2d/0x3f
[  464.602109]  [<ffffffff8111d16c>] __invalidate_device+0x48/0x53
[  464.602109]  [<ffffffff811ebf1d>] invalidate_partition+0x2d/0x42
[  464.602109]  [<ffffffff8114ac31>] rescan_partitions+0x63/0x40e
[  464.602109]  [<ffffffff812aa2bc>] ? sd_open+0x11f/0x147
[  464.602109]  [<ffffffff8111e2f0>] __blkdev_get+0x269/0x32f
[  464.602109]  [<ffffffff8106179f>] ? async_run_entry_fn+0x0/0x15b
[  464.602109]  [<ffffffff8111e3c6>] blkdev_get+0x10/0x12
[  464.602109]  [<ffffffff8114a35d>] register_disk+0xdc/0x13f
[  464.602109]  [<ffffffff8106179f>] ? async_run_entry_fn+0x0/0x15b
[  464.602109]  [<ffffffff811eb5f0>] add_disk+0xaf/0x10b
[  464.602109]  [<ffffffff812abd2b>] sd_probe_async+0x129/0x1cd
[  464.602109]  [<ffffffff81061847>] async_run_entry_fn+0xa8/0x15b
[  464.602109]  [<ffffffff810558b0>] process_one_work+0x232/0x399
[  464.602109]  [<ffffffff81055825>] ? process_one_work+0x1a7/0x399
[  464.602109]  [<ffffffff8105759a>] worker_thread+0x13b/0x251
[  464.602109]  [<ffffffff8105745f>] ? worker_thread+0x0/0x251
[  464.602109]  [<ffffffff8105ace8>] kthread+0x82/0x8a
[  464.602109]  [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10
[  464.602109]  [<ffffffff813f7710>] ? restore_args+0x0/0x30
[  464.602109]  [<ffffffff8105ac66>] ? kthread+0x0/0x8a
[  464.602109]  [<ffffffff81003a60>] ? kernel_thread_helper+0x0/0x10
[  464.735104] sd 9:0:0:0: [sdd] Assuming drive cache: write through
[  464.743108]  sdd: sdd1
