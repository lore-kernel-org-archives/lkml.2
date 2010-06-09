Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab0FIB6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 21:58:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:24524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0FIB6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 21:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,387,1272870000"; 
   d="scan'208";a="574572764"
Subject: BTRFS hangs testing processes
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       tim.c.chen@intel.com, shaohua.li@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 09 Jun 2010 10:00:45 +0800
Message-Id: <1276048845.2096.340.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

We ran into a hang issue when testing btrfs by fio. With 2.6.34-rc kernel, we hit
it sometimes and it's hard to reproduce it, so we don't report it to you. Now
with 2.6.35-rc1, we could hit it often with a test case fio_aio_randwrite_4k.

We test it by a JBOD with 12 disks. Every disk has 2 partitions. Every partition
has 2 1-GB files. fio starts 1 sub-process per partition to do aio randwrite. Block
size is 4k. The machine is a dual-socket Nehalem with 6GB memory.

After the testing, our automation testing script does a sync immediately. The hang
always happens there. It's not a panic. Kernel reports below info.

INFO: task btrfs-transacti:5795 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transac D ffff8800bd7e5830  4456  5795      2 0x00000000
 ffff8800bc1b7d60 0000000000000046 0000000000004000 ffff8800bc1b7fd8
 0000000000013ac0 ffff8800bc1b7fd8 ffff8800bd7e54c0 0000000000013ac0
 0000000000013ac0 ffffffff8163caea 0000000000000000 ffff8800bd7e54c0
Call Trace:
 [<ffffffff8163caea>] ? __mutex_lock_slowpath+0x4f/0x131
 [<ffffffff812728f2>] wait_for_commit+0x94/0xde
 [<ffffffff8105557c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff81273830>] btrfs_commit_transaction+0xf8/0x5e1
 [<ffffffff8163cf51>] ? mutex_lock+0x24/0x48
 [<ffffffff8105557c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8126f404>] transaction_kthread+0x165/0x215
 [<ffffffff8126f29f>] ? transaction_kthread+0x0/0x215
 [<ffffffff8126f29f>] ? transaction_kthread+0x0/0x215
 [<ffffffff81055116>] kthread+0x7d/0x85
 [<ffffffff81003714>] kernel_thread_helper+0x4/0x10
 [<ffffffff81055099>] ? kthread+0x0/0x85
 [<ffffffff81003710>] ? kernel_thread_helper+0x0/0x10
INFO: task sync:8753 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D ffff8801bda6fb80  5088  8753   4307 0x00000000
 ffff8801952f7d98 0000000000000086 0000000000004000 ffff8801952f7fd8
 0000000000013ac0 ffff8801952f7fd8 ffff8801bda6f810 0000000000013ac0
 0000000000013ac0 ffff8801952f7fd8 ffff8801bda6f810 ffff8801bda6f810
Call Trace:
 [<ffffffff8163c5f1>] schedule_timeout+0x28/0x20f
 [<ffffffff8163cf51>] ? mutex_lock+0x24/0x48
 [<ffffffff810557b5>] ? prepare_to_wait+0x70/0x7b
 [<ffffffff812739cf>] btrfs_commit_transaction+0x297/0x5e1
 [<ffffffff8105557c>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff810f46f4>] ? sync_one_sb+0x0/0x1d
 [<ffffffff81256ee1>] btrfs_sync_fs+0x5d/0x61
 [<ffffffff810f46dc>] __sync_filesystem+0x66/0x7e
 [<ffffffff810f470f>] sync_one_sb+0x1b/0x1d
 [<ffffffff810d67b5>] iterate_supers+0x67/0xa6
 [<ffffffff810f4751>] sys_sync+0x40/0x57
 [<ffffffff810029eb>] system_call_fastpath+0x16/0x1b


If I run sync manually, the sync also hangs. Machine reboot also hangs because
reboot script calls sync.

I add scsi_mod.scsi_logging_level=7 too kernel boot cmdline and kernel doesn't
report clear scsi errors. I double-check my JBOD and don't find anything abnormal
about hardware.

I trigger a sysrq to dump all process stack and don't find any useful info other
than above dumping.

Currently, the only clear clue is it happens when we do a sync immediately just
after the testing is done. It seems btrfs might have a narrow race.

Would you like to provide some clues? Any debugging patch is welcome. To resolve
it, we don't run other new test cases now in case they might change the data to decrease
the possibility to reproduce the bug.

Yanmin




