Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2LAUme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 15:42:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:43717 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2LAUmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 15:42:32 -0500
Message-ID: <50BA6BA7.7000304@oracle.com>
Date: Sat, 01 Dec 2012 15:42:15 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121112 Thunderbird/16.0.1
MIME-Version: 1.0
To: axboe@kernel.dk
CC: mpatocka@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Jones <davej@redhat.com>
Subject: blk: bd_block_size_semaphore related lockdep warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest, running latest -next, I've
stumbled on:

[ 3130.099477] ======================================================
[ 3130.104862] [ INFO: possible circular locking dependency detected ]
[ 3130.104862] 3.7.0-rc7-next-20121130-sasha-00015-g06fcc7a-dirty #2 Tainted: G        W
[ 3130.104862] -------------------------------------------------------
[ 3130.104862] trinity-child77/12730 is trying to acquire lock:
[ 3130.104862]  (&sb->s_type->i_mutex_key#17/1){+.+.+.}, at: [<ffffffff8128a605>] pipe_lock_nested.isra.2+0x15/0x20
[ 3130.104862]
[ 3130.104862] but task is already holding lock:
[ 3130.104862]  (sb_writers#16){.+.+..}, at: [<ffffffff812b439f>] generic_file_splice_write+0x6f/0x170
[ 3130.104862]
[ 3130.104862] which lock already depends on the new lock.
[ 3130.104862]
[ 3130.104862]
[ 3130.104862] the existing dependency chain (in reverse order) is:
[ 3130.104862]
-> #3 (sb_writers#16){.+.+..}:
[ 3130.104862]        [<ffffffff8118a34a>] lock_acquire+0x1aa/0x240
[ 3130.104862]        [<ffffffff81285dd6>] __sb_start_write+0x146/0x1b0
[ 3130.104862]        [<ffffffff812b439f>] generic_file_splice_write+0x6f/0x170
[ 3130.104862]        [<ffffffff812be0ca>] blkdev_splice_write+0x5a/0x80
[ 3130.104862]        [<ffffffff812b2983>] do_splice_from+0x83/0xb0
[ 3130.104862]        [<ffffffff812b4de2>] sys_splice+0x492/0x690
[ 3130.104862]        [<ffffffff83cb1358>] tracesys+0xe1/0xe6
[ 3130.104862]
-> #2 (&ei->bdev.bd_block_size_semaphore){++++.+}:
[ 3130.104862]        [<ffffffff8118a34a>] lock_acquire+0x1aa/0x240
[ 3130.104862]        [<ffffffff81a0ec15>] percpu_down_read+0x55/0x90
[ 3130.104862]        [<ffffffff812be123>] blkdev_mmap+0x33/0x60
[ 3130.104862]        [<ffffffff8123ec9b>] mmap_region+0x31b/0x600
[ 3130.104862]        [<ffffffff8123f237>] do_mmap_pgoff+0x2b7/0x330
[ 3130.104862]        [<ffffffff81228b9a>] vm_mmap_pgoff+0x7a/0xa0
[ 3130.104862]        [<ffffffff8123d70e>] sys_mmap_pgoff+0x16e/0x1b0
[ 3130.104862]        [<ffffffff8107492d>] sys_mmap+0x1d/0x20
[ 3130.104862]        [<ffffffff83cb1358>] tracesys+0xe1/0xe6
[ 3130.104862]
-> #1 (&mm->mmap_sem){++++++}:
[ 3130.104862]        [<ffffffff8118a34a>] lock_acquire+0x1aa/0x240
[ 3130.104862]        [<ffffffff81239d6b>] might_fault+0x7b/0xa0
[ 3130.104862]        [<ffffffff812b4805>] sys_vmsplice+0xd5/0x220
[ 3130.104862]        [<ffffffff83cb1358>] tracesys+0xe1/0xe6
[ 3130.104862]
-> #0 (&sb->s_type->i_mutex_key#17/1){+.+.+.}:
[ 3130.104862]        [<ffffffff8118759f>] __lock_acquire+0x147f/0x1c30
[ 3130.104862]        [<ffffffff8118a34a>] lock_acquire+0x1aa/0x240
[ 3130.104862]        [<ffffffff83cac6d9>] __mutex_lock_common+0x59/0x5a0
[ 3130.104862]        [<ffffffff83cacc5f>] mutex_lock_nested+0x3f/0x50
[ 3130.104862]        [<ffffffff8128a605>] pipe_lock_nested.isra.2+0x15/0x20
[ 3130.104862]        [<ffffffff8128a6f5>] pipe_lock+0x15/0x20
[ 3130.104862]        [<ffffffff812b43a7>] generic_file_splice_write+0x77/0x170
[ 3130.104862]        [<ffffffff812be0ca>] blkdev_splice_write+0x5a/0x80
[ 3130.104862]        [<ffffffff812b2983>] do_splice_from+0x83/0xb0
[ 3130.104862]        [<ffffffff812b4de2>] sys_splice+0x492/0x690
[ 3130.104862]        [<ffffffff83cb1358>] tracesys+0xe1/0xe6
[ 3130.104862]
[ 3130.104862] other info that might help us debug this:
[ 3130.104862]
[ 3130.104862] Chain exists of:
  &sb->s_type->i_mutex_key#17/1 --> &ei->bdev.bd_block_size_semaphore --> sb_writers#16
[ 3130.104862]  Possible unsafe locking scenario:
[ 3130.104862]
[ 3130.104862]        CPU0                    CPU1
[ 3130.104862]        ----                    ----
[ 3130.104862]   lock(sb_writers#16);
[ 3130.104862]                                lock(&ei->bdev.bd_block_size_semaphore);
[ 3130.104862]                                lock(sb_writers#16);
[ 3130.104862]   lock(&sb->s_type->i_mutex_key#17/1);
[ 3130.104862]
[ 3130.104862]  *** DEADLOCK ***
[ 3130.104862]
[ 3130.104862] 2 locks held by trinity-child77/12730:
[ 3130.104862]  #0:  (&ei->bdev.bd_block_size_semaphore){++++.+}, at: [<ffffffff812be0b5>] blkdev_splice_write+0x45/0x80
[ 3130.104862]  #1:  (sb_writers#16){.+.+..}, at: [<ffffffff812b439f>] generic_file_splice_write+0x6f/0x170
[ 3130.104862]
[ 3130.104862] stack backtrace:
[ 3130.104862] Pid: 12730, comm: trinity-child77 Tainted: G        W    3.7.0-rc7-next-20121130-sasha-00015-g06fcc7a-dirty #2
[ 3130.104862] Call Trace:
[ 3130.104862]  [<ffffffff83c54d8a>] print_circular_bug+0x1fb/0x20c
[ 3130.104862]  [<ffffffff8118759f>] __lock_acquire+0x147f/0x1c30
[ 3130.104862]  [<ffffffff8118a34a>] lock_acquire+0x1aa/0x240
[ 3130.104862]  [<ffffffff8128a605>] ? pipe_lock_nested.isra.2+0x15/0x20
[ 3130.104862]  [<ffffffff83cac6d9>] __mutex_lock_common+0x59/0x5a0
[ 3130.104862]  [<ffffffff8128a605>] ? pipe_lock_nested.isra.2+0x15/0x20
[ 3130.104862]  [<ffffffff81185d8a>] ? __lock_is_held+0x5a/0x80
[ 3130.104862]  [<ffffffff8128a605>] ? pipe_lock_nested.isra.2+0x15/0x20
[ 3130.104862]  [<ffffffff83cacc5f>] mutex_lock_nested+0x3f/0x50
[ 3130.104862]  [<ffffffff8128a605>] pipe_lock_nested.isra.2+0x15/0x20
[ 3130.104862]  [<ffffffff8128a6f5>] pipe_lock+0x15/0x20
[ 3130.104862]  [<ffffffff812b43a7>] generic_file_splice_write+0x77/0x170
[ 3130.104862]  [<ffffffff812be0ca>] blkdev_splice_write+0x5a/0x80
[ 3130.104862]  [<ffffffff812b2983>] do_splice_from+0x83/0xb0
[ 3130.104862]  [<ffffffff812b4de2>] sys_splice+0x492/0x690
[ 3130.104862]  [<ffffffff8107eaf0>] ? syscall_trace_enter+0x20/0x2e0
[ 3130.104862]  [<ffffffff83cb1358>] tracesys+0xe1/0xe6


Thanks,
sasha
