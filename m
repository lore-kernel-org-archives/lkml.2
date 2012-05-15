Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965613Ab2EOCSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:34 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53088 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964905Ab2EOCQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:38 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 048/179] Fix oops caused by queue refcounting failure
Date: Mon, 14 May 2012 22:12:24 -0400
Message-ID: <1337048075-6132-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e73e079bf128d68284efedeba1fbbc18d78610f9 upstream.

In certain circumstances, we can get an oops from a torn down device.
Most notably this is from CD roms trying to call scsi_ioctl.  The root
cause of the problem is the fact that after scsi_remove_device() has
been called, the queue is fully torn down.  This is actually wrong
since the queue can be used until the sdev release function is called.
Therefore, we add an extra reference to the queue which is released in
sdev->release, so the queue always exists.

Reported-by: Parag Warudkar <parag.lkml@gmail.com>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/scsi_scan.c  |    2 +-
 drivers/scsi/scsi_sysfs.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 38518b0..91d1724 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -295,7 +295,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
-
+	blk_get_queue(sdev->request_queue);
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed3b52f..f01117e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -319,6 +319,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 		kfree(evt);
 	}
 
+	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-- 
1.7.9.6

