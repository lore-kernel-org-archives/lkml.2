Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab0INH1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:27:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36502 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0INH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:27:48 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: lockdep warning: events vs. bd_mutex
Cc: kosaki.motohiro@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201009122243.23765.arnd@arndb.de>
References: <201009122243.23765.arnd@arndb.de>
Message-Id: <20100914160729.C9A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Sep 2010 16:27:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  464.602109] -> #3 (&bdev->bd_mutex){+.+.+.}:
> [  464.602109]        [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
> [  464.602109]        [<ffffffff813f5b5b>] __mutex_lock_common+0x4b/0x35e
> [  464.602109]        [<ffffffff813f5f32>] mutex_lock_nested+0x3e/0x43
> [  464.602109]        [<ffffffff8111d7df>] revalidate_disk+0x4b/0x73		// grab bd_mutex
> [  464.602109]        [<ffffffff812a969f>] sd_rescan+0x27/0x34
> [  464.602109]        [<ffffffff812a1be6>] scsi_rescan_device+0x82/0x98
> [  464.602109]        [<ffffffff812b53e5>] ata_scsi_dev_rescan+0x8d/0xf4	// on system_wq
> [  464.602109]        [<ffffffff810558b0>] process_one_work+0x232/0x399
> [  464.602109]        [<ffffffff8105759a>] worker_thread+0x13b/0x251
> [  464.602109]        [<ffffffff8105ace8>] kthread+0x82/0x8a
> [  464.602109]        [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10

ata_scsi_dev_rescan() was invoked by schedule_work() from ata_eh_revalidate_and_attach().
IOW, it use system_wq.

> [  464.602109] -> #0 (events){+.+.+.}:
> [  464.602109]        [<ffffffff8106d6e9>] __lock_acquire+0xa30/0xd38
> [  464.602109]        [<ffffffff8106dad4>] lock_acquire+0xe3/0x110
> [  464.602109]        [<ffffffff810567e7>] flush_work+0xfc/0x143		// wait system_wq
> [  464.602109]        [<ffffffff81056903>] schedule_on_each_cpu+0xd5/0x115
> [  464.602109]        [<ffffffff810c6f06>] lru_add_drain_all+0x15/0x17
> [  464.602109]        [<ffffffff81118b93>] invalidate_bdev+0x2d/0x3f
> [  464.602109]        [<ffffffff8111d16c>] __invalidate_device+0x48/0x53
> [  464.602109]        [<ffffffff811ebf1d>] invalidate_partition+0x2d/0x42
> [  464.602109]        [<ffffffff8114ac31>] rescan_partitions+0x63/0x40e
> [  464.602109]        [<ffffffff8111e2f0>] __blkdev_get+0x269/0x32f		// grab bd_mutex
> [  464.602109]        [<ffffffff8111e3c6>] blkdev_get+0x10/0x12
> [  464.602109]        [<ffffffff8114a35d>] register_disk+0xdc/0x13f
> [  464.602109]        [<ffffffff811eb5f0>] add_disk+0xaf/0x10b
> [  464.602109]        [<ffffffff812abd2b>] sd_probe_async+0x129/0x1cd
> [  464.602109]        [<ffffffff81061847>] async_run_entry_fn+0xa8/0x15b
> [  464.602109]        [<ffffffff810558b0>] process_one_work+0x232/0x399
> [  464.602109]        [<ffffffff8105759a>] worker_thread+0x13b/0x251
> [  464.602109]        [<ffffffff8105ace8>] kthread+0x82/0x8a
> [  464.602109]        [<ffffffff81003a64>] kernel_thread_helper+0x4/0x10

lru_add_drain_all() wait system_wq.


Probably we have four choice.
 1) simple revert buggy patch (I don't know how much serious original issue)
 2) ata_scsi_dev_rescan() doesn't use system_wq
 3) lru_add_drain_all() doesn't use system_wq
 4) make IPI version lru_add_drain_all()

I'd like to hear Tejun's opinion.



