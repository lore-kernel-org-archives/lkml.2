Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab0KSWXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:23:08 -0500
Received: from kroah.org ([198.145.64.141]:45253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541Ab0KSV6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:53 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:43 2010
Message-Id: <20101119215643.432549345@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [57/82] [SCSI] Fix regressions in scsi_internal_device_block
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2436,7 +2436,8 @@ scsi_internal_device_unblock(struct scsi
 		sdev->sdev_state = SDEV_RUNNING;
 	else if (sdev->sdev_state == SDEV_CREATED_BLOCK)
 		sdev->sdev_state = SDEV_CREATED;
-	else
+	else if (sdev->sdev_state != SDEV_CANCEL &&
+		 sdev->sdev_state != SDEV_OFFLINE)
 		return -EINVAL;
 
 	spin_lock_irqsave(q->queue_lock, flags);


