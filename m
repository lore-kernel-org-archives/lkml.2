Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab2LSAZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:25:43 -0500
Received: from mail-wi0-f202.google.com ([209.85.212.202]:47414 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2LSAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:25:41 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Neil Brown <neilb@suse.de>, Doug Anderson <dianders@chromium.org>,
        Tejun Heo <tj@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] block: Avoid divide by 0 when max_discard_sectors is 0
Date: Tue, 18 Dec 2012 16:25:29 -0800
Message-Id: <1355876729-25627-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit "block: discard granularity might not be power of 2"
introduced a divide by 0 in the kernel.  Previously the code didn't
try to divide by discard_granularity when max_discard_sectors was 0.

Fix the code to only do the division if max_discard_sectors is
specified.

Error looked like this:

Division by zero in kernel.
[<8001618c>] (unwind_backtrace+0x0/0xec) from [<8046cfac>] (dump_stack+0x20/0x24)
[<8046cfac>] (dump_stack+0x20/0x24) from [<80012bf0>] (__div0+0x20/0x28)
[<80012bf0>] (__div0+0x20/0x28) from [<80224c24>] (Ldiv0_64+0x8/0x18)
[<80224c24>] (Ldiv0_64+0x8/0x18) from [<8021bcb8>] (add_partition+0x308/0x344)
[<8021bcb8>] (add_partition+0x308/0x344) from [<8021bf3c>] (rescan_partitions+0x248/0x2b8)
[<8021bf3c>] (rescan_partitions+0x248/0x2b8) from [<80127ae4>] (__blkdev_get+0x170/0x380)
[<80127ae4>] (__blkdev_get+0x170/0x380) from [<80127e60>] (blkdev_get+0x16c/0x2d0)
[<80127e60>] (blkdev_get+0x16c/0x2d0) from [<8021984c>] (add_disk+0x284/0x42c)
[<8021984c>] (add_disk+0x284/0x42c) from [<80342f50>] (mmc_add_disk+0x28/0x100)
[<80342f50>] (mmc_add_disk+0x28/0x100) from [<8034392c>] (mmc_blk_probe+0x2a8/0x2d8)
[<8034392c>] (mmc_blk_probe+0x2a8/0x2d8) from [<8033865c>] (mmc_bus_probe+0x24/0x28)
[<8033865c>] (mmc_bus_probe+0x24/0x28) from [<802969d8>] (driver_probe_device+0xb0/0x220)
[<802969d8>] (driver_probe_device+0xb0/0x220) from [<80296c1c>] (__device_attach+0x38/0x54)
[<80296c1c>] (__device_attach+0x38/0x54) from [<80294da4>] (bus_for_each_drv+0x5c/0xa4)
[<80294da4>] (bus_for_each_drv+0x5c/0xa4) from [<802968d0>] (device_attach+0x78/0x9c)
[<802968d0>] (device_attach+0x78/0x9c) from [<80295df8>] (bus_probe_device+0x38/0xa8)
[<80295df8>] (bus_probe_device+0x38/0xa8) from [<80294250>] (device_add+0x43c/0x60c)
[<80294250>] (device_add+0x43c/0x60c) from [<80338b84>] (mmc_add_card+0x18c/0x1e8)
[<80338b84>] (mmc_add_card+0x18c/0x1e8) from [<8033d414>] (mmc_attach_sd+0x18c/0x214)
[<8033d414>] (mmc_attach_sd+0x18c/0x214) from [<803382b0>] (mmc_rescan+0x25c/0x2c8)
[<803382b0>] (mmc_rescan+0x25c/0x2c8) from [<80042788>] (process_one_work+0x228/0x408)
[<80042788>] (process_one_work+0x228/0x408) from [<80042df4>] (worker_thread+0x280/0x3c4)
[<80042df4>] (worker_thread+0x280/0x3c4) from [<80048544>] (kthread+0xbc/0xcc)
[<80048544>] (kthread+0xbc/0xcc) from [<8000e358>] (ret_from_fork+0x14/0x20)

Signed-off-by: Doug Anderson <dianders@chromium.org>

---
 include/linux/blkdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index acb4f7b..b35c7e9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1189,11 +1189,11 @@ static inline int queue_discard_alignment(struct request_queue *q)
 static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector_t sector)
 {
 	sector_t alignment = sector << 9;
-	alignment = sector_div(alignment, lim->discard_granularity);
 
 	if (!lim->max_discard_sectors)
 		return 0;
 
+	alignment = sector_div(alignment, lim->discard_granularity);
 	alignment = lim->discard_granularity + lim->discard_alignment - alignment;
 	return sector_div(alignment, lim->discard_granularity);
 }
-- 
1.7.7.3

