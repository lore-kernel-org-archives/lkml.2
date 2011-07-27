Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1G0WEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:04:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:28703 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533Ab1G0Vsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900585"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: James.Bottomley@HansenPartnership.com, jbottomley@parallels.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [38/99] Fix oops caused by queue refcounting failure
Message-Id: <20110727214837.03AAF2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/scsi_scan.c  |    2 +-
 drivers/scsi/scsi_sysfs.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.35.y/drivers/scsi/scsi_scan.c
@@ -295,7 +295,7 @@ static struct scsi_device *scsi_alloc_sd
 		kfree(sdev);
 		goto out;
 	}
-
+	blk_get_queue(sdev->request_queue);
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 
Index: linux-2.6.35.y/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.35.y/drivers/scsi/scsi_sysfs.c
@@ -319,6 +319,7 @@ static void scsi_device_dev_release_user
 		kfree(evt);
 	}
 
+	blk_put_queue(sdev->request_queue);
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
