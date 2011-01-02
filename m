Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1ABH0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:26:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:37235 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab1ABH0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:26:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mike Christie <michaelc@cs.wisc.edu>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 259/260] Fix regressions in scsi_internal_device_block
Date: Sun,  2 Jan 2011 02:19:15 -0500
Message-Id: <1293952756-15010-260-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:52.0605 (UTC) FILETIME=[25A6CAD0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

commit 986fe6c7f50974e871b8ab5a800f5310ea25b361 upstream.

Deleting a SCSI device on a blocked fc_remote_port (before
fast_io_fail_tmo fires) results in a hanging thread:

  STACK:
  0 schedule+1108 [0x5cac48]
  1 schedule_timeout+528 [0x5cb7fc]
  2 wait_for_common+266 [0x5ca6be]
  3 blk_execute_rq+160 [0x354054]
  4 scsi_execute+324 [0x3b7ef4]
  5 scsi_execute_req+162 [0x3b80ca]
  6 sd_sync_cache+138 [0x3cf662]
  7 sd_shutdown+138 [0x3cf91a]
  8 sd_remove+112 [0x3cfe4c]
  9 __device_release_driver+124 [0x3a08b8]
10 device_release_driver+60 [0x3a0a5c]
11 bus_remove_device+266 [0x39fa76]
12 device_del+340 [0x39d818]
13 __scsi_remove_device+204 [0x3bcc48]
14 scsi_remove_device+66 [0x3bcc8e]
15 sysfs_schedule_callback_work+50 [0x260d66]
16 worker_thread+622 [0x162326]
17 kthread+160 [0x1680b0]
18 kernel_thread_starter+6 [0x10aaea]

During the delete, the SCSI device is in moved to SDEV_CANCEL.  When
the FC transport class later calls scsi_target_unblock, this has no
effect, since scsi_internal_device_unblock ignores SCSI devics in this
state.

It looks like all these are regressions caused by:
5c10e63c943b4c67561ddc6bf61e01d4141f881f
[SCSI] limit state transitions in scsi_internal_device_unblock

Fix by rejecting offline and cancel in the state transition.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
[jejb: Original patch by Christof Schmitt, modified by Mike Christie]
Signed-off-by: James Bottomley <James.Bottomley@suse.de>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1646fe7..9cc450b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2436,7 +2436,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev)
 		sdev->sdev_state = SDEV_RUNNING;
 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
 		sdev->sdev_state = SDEV_CREATED;
-	else
+	else if (sdev->sdev_state != SDEV_CANCEL &&
+		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-- 
1.7.3.3

