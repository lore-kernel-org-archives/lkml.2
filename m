Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab2KFLR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:17:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab2KFLRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:17:55 -0500
Date: Tue, 6 Nov 2012 12:17:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT] floppy
In-Reply-To: <5098F13E.20606@kernel.dk>
Message-ID: <alpine.LNX.2.00.1211061216570.24253@pobox.suse.cz>
References: <alpine.LNX.2.00.1211061208050.24253@pobox.suse.cz> <5098F13E.20606@kernel.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2012, Jens Axboe wrote:

> > Jiri Kosina (1):
> >       floppy: destroy floppy workqueue before cleaning up the queue
> > 
> >  drivers/block/floppy.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> Can you either just send me the patch, or base it against master? After
> the merge window, trees should be based off for-linus (if it exists) or
> just Linus master.

OK, noted you'd like this workflow for future pull requests.

> For this one, I'll just grab the patch, from the email thread :-)

Please apply the one below then. It contains proper changelog and also the 
corresponding module unload fix as well. Thanks.






From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] floppy: destroy floppy workqueue before cleaning up the queue

We need to first destroy the floppy_wq workqueue before cleaning up
the queue. Otherwise we might race with still pending work with the
workqueue, but all the block queue already gone. This might lead to
various oopses, such as

 CPU 0
 Pid: 6, comm: kworker/u:0 Not tainted 3.7.0-rc4 #1 Bochs Bochs
 RIP: 0010:[<ffffffff8134eef5>]  [<ffffffff8134eef5>] blk_peek_request+0xd5/0x1c0
 RSP: 0000:ffff88000dc7dd88  EFLAGS: 00010092
 RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: ffff88000f602688 RSI: ffffffff81fd95d8 RDI: 6b6b6b6b6b6b6b6b
 RBP: ffff88000dc7dd98 R08: ffffffff81fd95c8 R09: 0000000000000000
 R10: ffffffff81fd9480 R11: 0000000000000001 R12: 6b6b6b6b6b6b6b6b
 R13: ffff88000dc7dfd8 R14: ffff88000dc7dfd8 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffffffff81e21000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000001e11000 CR4: 00000000000006f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process kworker/u:0 (pid: 6, threadinfo ffff88000dc7c000, task ffff88000dc5ecc0)
 Stack:
  0000000000000000 0000000000000000 ffff88000dc7ddb8 ffffffff8134efee
  ffff88000dc7ddb8 0000000000000000 ffff88000dc7dde8 ffffffff814aef3c
  ffffffff81e75d80 ffff88000dc0c640 ffff88000fbfb000 ffffffff814aed90
 Call Trace:
  [<ffffffff8134efee>] blk_fetch_request+0xe/0x30
  [<ffffffff814aef3c>] redo_fd_request+0x1ac/0x400
  [<ffffffff814aed90>] ? start_motor+0x130/0x130
  [<ffffffff8106b526>] process_one_work+0x136/0x450
  [<ffffffff8106af65>] ? manage_workers+0x205/0x2e0
  [<ffffffff8106bb6d>] worker_thread+0x14d/0x420
  [<ffffffff8106ba20>] ? rescuer_thread+0x1a0/0x1a0
  [<ffffffff8107075a>] kthread+0xba/0xc0
  [<ffffffff810706a0>] ? __kthread_parkme+0x80/0x80
  [<ffffffff818b553a>] ret_from_fork+0x7a/0xb0
  [<ffffffff810706a0>] ? __kthread_parkme+0x80/0x80
 Code: 0f 84 c0 00 00 00 83 f8 01 0f 85 e2 00 00 00 81 4b 40 00 00 80 00 48 89 df e8 58 f8 ff ff be fb ff ff ff
 fe ff ff <49> 8b 1c 24 49 39 dc 0f 85 2e ff ff ff 41 0f b6 84 24 28 04 00
 RIP  [<ffffffff8134eef5>] blk_peek_request+0xd5/0x1c0
  RSP <ffff88000dc7dd88>

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/block/floppy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9d900e6..51f0c3d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4331,6 +4331,7 @@ out_unreg_region:
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
+	destroy_workqueue(floppy_wq);
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		if (!disks[drive])
 			break;
@@ -4345,7 +4346,6 @@ out_put_disk:
 		}
 		put_disk(disks[drive]);
 	}
-	destroy_workqueue(floppy_wq);
 	return err;
 }
 
@@ -4560,6 +4560,8 @@ static void __exit floppy_module_exit(void)
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 	platform_driver_unregister(&floppy_driver);
 
+	destroy_workqueue(floppy_wq);
+
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		del_timer_sync(&motor_off_timer[drive]);
 
@@ -4583,7 +4585,6 @@ static void __exit floppy_module_exit(void)
 
 	cancel_delayed_work_sync(&fd_timeout);
 	cancel_delayed_work_sync(&fd_timer);
-	destroy_workqueue(floppy_wq);
 
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();

-- 
Jiri Kosina
SUSE Labs
