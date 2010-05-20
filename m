Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab0ETRBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 13:01:04 -0400
Received: from eden-out.rutgers.edu ([128.6.68.11]:42153 "EHLO
	goshen7.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab0ETRBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 13:01:01 -0400
X-Greylist: delayed 1618 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 13:01:01 EDT
Date: Thu, 20 May 2010 12:34:00 -0400 (EDT)
From: Ciprian Docan <docan@eden.rutgers.edu>
X-X-Sender: docan@er1.rutgers.edu
To: linux-kernel@vger.kernel.org
Subject: possible circular locking dependency detected
Message-ID: <Pine.SOC.4.64.1005201226440.1441@er1.rutgers.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I got the following in the dmesg:

--------------------------------------------------------------------
[ INFO: possible circular locking dependency detected ]
2.6.33-rc8 #4
-------------------------------------------------------
fdisk/29231 is trying to acquire lock:
  (&type->s_umount_key#47){++++..}, at: [<ffffffff810fb13c>] 
get_super+0x5c/0xaf

but task is already holding lock:
  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811f2df0>] 
blkdev_ioctl+0x5c5/0x6b1

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&bdev->bd_mutex){+.+.+.}:
        [<ffffffff8106e65b>] __lock_acquire+0xb5d/0xd05
        [<ffffffff8106e8cf>] lock_acquire+0xcc/0xe9
        [<ffffffff81402d09>] __mutex_lock_common+0x4c/0x348
        [<ffffffff814030c9>] mutex_lock_nested+0x3e/0x43
        [<ffffffff8111f4a9>] __blkdev_put+0x34/0x16c
        [<ffffffff8111f5f1>] blkdev_put+0x10/0x12
        [<ffffffff8112063b>] close_bdev_exclusive+0x24/0x2d
        [<ffffffff810fbcaa>] get_sb_bdev+0xef/0x1a1
        [<ffffffffa0114189>] vfat_get_sb+0x18/0x1a [vfat]
        [<ffffffff810fb8bc>] vfs_kern_mount+0xa9/0x168
        [<ffffffff810fb9e3>] do_kern_mount+0x4d/0xed
        [<ffffffff81110f54>] do_mount+0x72f/0x7a6
        [<ffffffff81111053>] sys_mount+0x88/0xc2
        [<ffffffff8100236b>] system_call_fastpath+0x16/0x1b

-> #0 (&type->s_umount_key#47){++++..}:
        [<ffffffff8106e505>] __lock_acquire+0xa07/0xd05
        [<ffffffff8106e8cf>] lock_acquire+0xcc/0xe9
        [<ffffffff81403450>] down_read+0x51/0x84
        [<ffffffff810fb13c>] get_super+0x5c/0xaf
        [<ffffffff8111facd>] fsync_bdev+0x18/0x48
        [<ffffffff811f433c>] invalidate_partition+0x25/0x42
        [<ffffffff8114bda2>] rescan_partitions+0x37/0x3a7
        [<ffffffff811f2dff>] blkdev_ioctl+0x5d4/0x6b1
        [<ffffffff8111eca4>] block_ioctl+0x37/0x3b
        [<ffffffff811060d0>] vfs_ioctl+0x32/0xa6
        [<ffffffff81106650>] do_vfs_ioctl+0x490/0x4d6
        [<ffffffff811066ec>] sys_ioctl+0x56/0x79
        [<ffffffff8100236b>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by fdisk/29231:
  #0:  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811f2df0>] 
blkdev_ioctl+0x5c5/0x6b1

stack backtrace:
Pid: 29231, comm: fdisk Not tainted 2.6.33-rc8 #4
Call Trace:
  [<ffffffff8106d6dc>] print_circular_bug+0xa8/0xb6
  [<ffffffff8106e505>] __lock_acquire+0xa07/0xd05
  [<ffffffff81062009>] ? sched_clock_local+0x1c/0x82
  [<ffffffff8106e8cf>] lock_acquire+0xcc/0xe9
  [<ffffffff810fb13c>] ? get_super+0x5c/0xaf
  [<ffffffff8106b936>] ? lock_release_holdtime+0x2c/0xdb
  [<ffffffff81403450>] down_read+0x51/0x84
  [<ffffffff810fb13c>] ? get_super+0x5c/0xaf
  [<ffffffff810fb13c>] get_super+0x5c/0xaf
  [<ffffffff8111facd>] fsync_bdev+0x18/0x48
  [<ffffffff811f433c>] invalidate_partition+0x25/0x42
  [<ffffffff81402c8e>] ? mutex_trylock+0x12a/0x159
  [<ffffffff8114bda2>] rescan_partitions+0x37/0x3a7
  [<ffffffff8106d0c9>] ? trace_hardirqs_on+0xd/0xf
  [<ffffffff811f2df0>] ? blkdev_ioctl+0x5c5/0x6b1
  [<ffffffff811f2dff>] blkdev_ioctl+0x5d4/0x6b1
  [<ffffffff8106d098>] ? trace_hardirqs_on_caller+0x118/0x13c
  [<ffffffff8111eca4>] block_ioctl+0x37/0x3b
  [<ffffffff811060d0>] vfs_ioctl+0x32/0xa6
  [<ffffffff81106650>] do_vfs_ioctl+0x490/0x4d6
  [<ffffffff811066ec>] sys_ioctl+0x56/0x79
  [<ffffffff8102f9bd>] ? __wake_up+0x22/0x4d
  [<ffffffff8100236b>] system_call_fastpath+0x16/0x1b
-------------------------------------------------------------------------

Kernel version used: 2.6.33-rc8 #4. I do not remember the exact steps, but 
I was trying to format an USB stick using the fdisk. Please let me know if 
you need additional informations. Thank you.

Regards,
--
 	Ciprian Docan
