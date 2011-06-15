Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1FPHA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:00:29 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35432 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755174Ab1FPHAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:24 -0400
X-Sasl-enc: OOoaLrCpUPTOyaD/YcrOhAZ3En+/P+eqomfcBqZ7qW8y 1308207623
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:30 2011
Message-Id: <20110616000230.580182239@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Bottomley <jbottomley@parallels.com>
Subject: [16/89] [SCSI] Fix oops caused by queue refcounting failure
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_scan.c  |    2 +-
 drivers/scsi/scsi_sysfs.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -297,7 +297,7 @@ static struct scsi_device *scsi_alloc_sd
 		kfree(sdev);
 		goto out;
 	}
-
+	blk_get_queue(sdev->request_queue);
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -322,6 +322,7 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
+	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 


