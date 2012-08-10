Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153Ab2HJDWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 23:22:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34845 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HJDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 23:22:43 -0400
MIME-Version: 1.0
Date: Fri, 10 Aug 2012 12:22:41 +0900
Message-ID: <CAOAMb1Dd5_KWQme+EzXdpnABk=A50+vXuLMoS+r5et6=o0605g@mail.gmail.com>
Subject: [PATCH][SCSI] remove the queue unlock in scsi_requset_fn
From: Chanho Min <chanho0207@gmail.com>
To: James Bottomley <JBottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Bart Van Assche <bvanassche@acm.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to unlock the queue before put_device in scsi_request_fn()
If we trigger the ->remove() function, It occur a oops from the caller.
So sdev reference count should not be dropped to zero here.
Also It was added before scsi_device_dev_release() was moved
to user context, so it is outdated.

Signed-off-by: Chanho Min <chanho.min@lge.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..cb2185a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1626,11 +1626,7 @@ out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
 	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
 }

 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
-- 
1.7.0.4
